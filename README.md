# wonder-data-project

The reader-friendly report is the file [wonder_report.html](wonder_report.html) which should be downloaded and then opened with any internet browser. HTML was chosen because it allowed for easy formatting and tabular chart presentation. The markdown file used to create that report is [wonder_report.Rmd](wonder_report.Rmd).

## Steps I followed:

1) spun up postgresql db in AWS
2) ran [sql/create_event_table.sql](sql/create_event_table.sql) file in a db client
3) ran the file [r/insert_original_data.R](r/insert_original_data.R) to insert CSV data into the new table
4) explored the dataset using SQL and R, before settling on the type of analysis and queries to use

Data transformation was done mostly in SQL, and the queries are in the file [r/analysis.R](r/analysis.R).

## Steps to recreate the process

To recreate this analysis run the following from your terminal:
1) brew install unixodbc
2) brew install psqlodbc (optional)

Make sure you have
1) an installation of RStudio with R >= 3.3
2) any R packages loaded at the top of each R and RMD script

Clone this repo and run these files in this order (leveraging the existing postgres instance that's already live):
1) [r/analysis.R](r/analysis.R)
2) [wonder_report.Rmd](wonder_report.Rmd)