library(DBI)
library(odbc)
library(ggplot2)
library(dplyr)

kDataPath <- file.path("~/src/wonder-data-project","data")

con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "/usr/local/lib/psqlodbcw.so", #probable location if using default MacOS installation
                      Server   = "host",
                      Database = "database_name",
                      UID      = "user_name",
                      PWD      = "password",
                      Port     = 5432)

res <- dbSendQuery(con, "
-- get the full log
select 
  *
from events_original e
")
full_log <- dbFetch(res)

res <- dbSendQuery(con, "
-- look at when requests are created
select distinct
  request
, date_part('hour', e.request_created_at) as request_created_at_hour
from events_original e
")
requests_created <- dbFetch(res)

# state of the research queue over the day
res <- dbSendQuery(con, "
-- look at the state of the research queue over the day
select 
  date_part('hour', e.event_occurred_at) as snapshot_taken_at_hour
, round(avg(total_jobs_available),2) as avg_total_jobs_available
, round(avg(analysts_available),2) as avg_analysts_available
, round(avg(analysts_occupied),2) as avg_analysts_occupied
from events_original e
group by 1
")
queue_status <- dbFetch(res)

# look at time between assignment and first response
res <- dbSendQuery(con, "
-- time between assignment and answered by time of assignment
with request_assigned as (
  select 
    e.request
  , min(e.event_occurred_at) as first_assigment_time
  from events_original e
  where action = 'Assigned Job'
    and e.request_created_at >= (select min(e.event_occurred_at) from events_original e)
  group by 1
)
, request_answered as (
  select 
    e.request
  , min(e.event_occurred_at) as first_answered_time
  from events_original e
  join request_assigned r on r.request = e.request
  where action <> 'Assigned Job'
  group by 1
)
select 
  r.request
, r.first_assigment_time
, ra.first_answered_time
, (date_part('day', ra.first_answered_time-r.first_assigment_time) * 24 + 
    date_part('hour', ra.first_answered_time-r.first_assigment_time)) * 60 +
    date_part('minute', ra.first_answered_time-r.first_assigment_time) as time_in_mins
from request_assigned r 
join request_answered ra on ra.request = r.request
")
response_rate <- dbFetch(res)

res <- dbSendQuery(con, "
-- look at when first assignments happen through the day
with first_assignment as (
  select
    request
  , request_created_at
  , min(event_occurred_at) as first_assigment_time
  from events_original e
  where action = 'Accepted Job'
  group by 1, 2
)
select 
  date_part('hour', e.request_created_at) as request_created_at_hour
, date_part('hour', e.event_occurred_at) as event_occurred_at_hour
, (date_part('day', e.event_occurred_at-e.request_created_at) * 24 + 
    date_part('hour', e.event_occurred_at-e.request_created_at)) * 60 +
    date_part('minute', e.event_occurred_at-e.request_created_at) as time_in_mins
, e.analyst
from events_original e
join first_assignment fa
  on fa.request = e.request
  and fa.request_created_at = e.request_created_at
  and fa.first_assigment_time = e.event_occurred_at
-- need to limit to requests created within the period of assignments we have in the dataset, otherwise we'd have a falsely long tail
where e.request_created_at >= (select min(first_assigment_time) from first_assignment)
order by 1
")
first_assignments <- dbFetch(res)  

g_fassignments <- first_assignments %>% 
                  group_by(request_created_at_hour) %>% 
                  summarise(
                    avg_mins = mean(time_in_mins),
                    event_cnt = n()
                  )

dbDisconnect(con)

save(full_log,
     first_assignments,
     g_fassignments,
     queue_status,
     requests_created,
     response_rate,
     file = file.path(kDataPath,"query_outputs.RData"))
