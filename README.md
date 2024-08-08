# Sales Data Mart Project
==========================
### Overview
This project creates a scalable data mart for improved business intelligence and reporting using SQL Server Integration Services (SSIS) and the AdventureWorks2014 database. The data mart is designed to support efficient, multidimensional analysis of sales performance.
Project Structure
- Dimension Tables
  - Dim Product: handles historical data using Slowly Changing Dimension (SCD) Type 2 mechanism
  - Dim Customer: implements SCD Type 2 for accurate historical tracking
  - Dim Date: extracts date-related data from an Excel source
  - Dim Territory: loads data from AdventureWorks2014 database with necessary conversions
- Fact Table
  - Fact Sales: extracts sales data from AdventureWorks2014 database, cleanses and enriches with dimensions, and loads into an      OLE DB destination using an incremental load approach
### Technical Details
- Database: AdventureWorks2014
- ETL Tool: SQL Server Integration Services (SSIS)
- Data Mart Design: Star schema-based data mart with fact and dimension tables
### Usage
To use this project, follow these steps:
1. Clone the repository to your local machine.
2. Open the SSIS project in Visual Studio.
3. Configure the connection managers to point to your AdventureWorks2014 database and Excel source.
4. Run the ETL packages to load data into the data mart.

### License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

### Acknowledgments
This project was developed using the AdventureWorks2014 database and SQL Server Integration Services (SSIS).
