-- We're creating a table for the initial Wonder event data

CREATE TABLE events_original (
  event_occurred_at TIMESTAMP,
  analyst VARCHAR(40),
  quality_score_sourcing FLOAT,
  quality_score_writing FLOAT,
  action VARCHAR(32),
  request VARCHAR(32),
  request_created_at TIMESTAMP,
  job VARCHAR(32),
  wait_time_min INTEGER,
  waiting_for TEXT,
  analysts_available INTEGER,
  analysts_occupied INTEGER,
  total_jobs_available INTEGER,
  review_jobs_available INTEGER,
  vetting_jobs_available INTEGER,
  planning_jobs_available INTEGER,
  editing_jobs_available INTEGER,
  sourcing_jobs_available INTEGER,
  writing_jobs_available INTEGER
);