# wonder-data-project

requirements to recreate this analysis run the following:
1) brew install unixodbc
2) brew install psqlodbc (optional)
3) an installation of RStudio with R >= 3.3
4) any R packages loaded at the top of each R and RMD script

## steps I followed:

1) spun up postgresql db in AWS
2) ran "create_event_table.sql" file in a db client
3) ran the file "insert_original_data.R" to insert CSV data into the new table
4) explored the dataset using SQL and R, before settling on the type of analysis and queries to use

Data transformation was done mostly in SQL, and the queries are in the file `analysis.R`. The reader-friendly report is the file `wonder_report.html` and should be downloaded and then opened with any internet browser. HTML was chosen because it allowed easy formatting and tabular chart presentation. The markdown file used to create that report is `wonder_report.Rmd`.