# This script just inserts the original data into the db table that was created beforehand. 
# Would not recommend running this again since the data has already been loaded.
library(DBI)
library(odbc)

events <- read.csv("~/src/wonder-data-project/data/Assignment Log.csv")
# note: we will be connecting to the AWS db in multiple scripts. 
#       In the future I would create an R package that took care of connection settings/credentials that was flexible 
#       for reuse by multiple analysts in their local environents. For speed and simplicity in this weekend project I will 
#       repeat the code where needed (:the DRY gods scream:)
con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "/usr/local/lib/psqlodbcw.so", #probable location if using default MacOS installation
                      Server   = "host",
                      Database = "database_name",
                      UID      = "user_name",
                      PWD      = "password",
                      Port     = 5432)

values <- paste0(apply(events, 1, function(x) paste0("('", paste0(x, collapse = "', '"), "')")), collapse = ", ")
dbSendQuery(con, paste0("INSERT INTO events_original VALUES ", values, ";"))
dbDisconnect(con)