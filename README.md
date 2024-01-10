# reproducible-data-analysis

This is a simple example of what reproducible research can look like using R and R Markdown files. In production this can be set up in combination with a static website that points to html files and slide decks for access by a non-technical target audience.

The reader-friendly example report is the file [wonder_report.html](wonder_report.html) which should be downloaded and then opened with any internet browser. HTML was chosen because it allowed for easy formatting and tabular chart presentation. The markdown file used to create that report is [wonder_report.Rmd](wonder_report.Rmd).

## Steps to set this up:

1) spin up postgresql db in AWS
2) run [sql/create_event_table.sql](sql/create_event_table.sql) file in a db client
3) run the file [r/insert_original_data.R](r/insert_original_data.R) to insert CSV data into the new table

Data transformation here was done mostly in SQL, queries are in the file [r/analysis.R](r/analysis.R).

## Steps to recreate the process

To recreate this analysis run the following from your terminal:
1) brew install unixodbc
2) brew install psqlodbc (optional)

Make sure you have
1) an installation of RStudio with R >= 3.3
2) any R packages loaded at the top of each R and RMD script

Clone this repo and run these files in this order (leveraging an existing postgres instance that's already live):
1) [r/analysis.R](r/analysis.R)
2) [wonder_report.Rmd](wonder_report.Rmd)
