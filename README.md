# wonder-data-project

requirements to run the following:
1) brew install unixodbc
2) brew install psqlodbc (optional)
3) an installation of RStudio with R >= 3.3
4) any R packages loaded at the top of each R script

## steps:

1) spin up postgresql db in AWS
2) run "create_event_table.sql" file in a db client
3) run the file "insert_original_data.R" to insert CSV data into the new table