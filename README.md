# eBMS Transect Survey - INDICIA Data Integration

This repository contains SQL queries and sample data outputs for extracting eBMS Transect Survey data from the INDICIA database.

## Contents

### SQL Folder
SQL scripts for querying the INDICIA database:
- `survey_description.sql` - Survey and website configuration for eBMS Transects (website_id: 118, survey_id: 562)
- `sample_table_attributes.sql` - Sample-level attributes and metadata
- `location_table_attributes.sql` - Location-level attributes and spatial information
- `occurrence_table_attributes.sql` - Occurrence/species-level data and attributes

### Output Examples Folder
Sample CSV exports from INDICIA queries:
- `eBMS_TransectSurveyDetails.csv` - Survey-level overview
- `sample_attributes.csv` - Sample attribute definitions
- `sample_data_example.csv` - Sample records with attributes
- `location_attributes.csv` - Location attribute definitions
- `location_data_example.csv` - Location records with spatial data
- `occurrence_attributes.csv` - Occurrence attribute definitions
- `occurrence_data_example.csv` - Species occurrence records

## Purpose

These scripts and outputs facilitate data formatting for integration of external data into the eBMS Transect Survey data in INDICIA.
