# ETL-Project-TokyoOlympicsData

Welcome to the end to end Data Engineering project on Tokyo Olympics Data on Azure. This project is designed to showcase how various Azure services can be utilized and leveraged to perform ETL operations like data ingestion, data transformation and data analytics on this dataset. We have used the following Azure services to build this project and achieve the final goal.

# Table of Contents
1. Introduction to Azure Services
2. Project Overview 
3. Data Architecture Flow Diagram
4. Data Sources & Visualisations
5. PreRequisites

# Introduction to Azure Services (Step by Step)
**Azure Data Factory **: Azure Data Factory (ADF) is a fully managed, serverless data integration solution for ingesting, preparing, and transforming all your data at scale. In this project we are using the ADF to ingest data from our data sources that are .csv files from web(https). We are using the copy data activity in Azure Data Factory to move our data from source (.csv files) to sink (Azure Data Lake Storage Gen2). 

**Azure Data Lake Storage Gen2** : This is the storage account where we are storing the data coming from our sorce. The data ingested here is in raw format. Azure Data Lake Storage Gen2 provides a scalable and secure platform for storing large volumes of data. It enables us to manage, access. and analyze data effectively. We'll be storing the data in three layers.
   - raw-data (BRONZE)
   - transformed-data (SILVER)
   - aggreagated-data (GOLD)

**Azure Databricks**: For data transformation like changing or modifying the schema of the tables, changing and modifying few columns we have leveraged Azure Databricks with PySpark. It is used for data tranformations like removing nulls and duplicate data. Firstly, we used the fs utility under dbutils to mount the data from ADLS Gen2 to Databricks Workspace and on top of that we did some cleaning and modification of Tokyo Olympics Data. Databricks is a unified, open analytics platform for building, deploying, sharing, and maintaining enterprise-grade data, analytics, and AI solutions at scale. And then we moved the transformed_data to the same named folder(silver layer) in ADLS Gen2.

**Azure Synapse Analytics** : We have used Azure Synapse Analytics to gain some valuable insights from the transformed data and performed some aggregations on top of the transformed data. We created a lake database by accessing the files on ADLS Gen2. We also used SQL queries to build some aggreagtion and store that in external tables and writing the aggregated data into the gold layer of storage account. This is where we extract meaningful information. This is where we uncover trends, find patterns, get valuable insights related to our Data Olympic Dataset. 

**Azure Key Valut** : We have used this service to maintain and keep our secrets encrypted. Azure Key Vault is a cloud service that provides a secure store for secrets. You can securely store keys, passwords, certificates, and other secrets. Azure key vaults are created and managed through the Azure portal. It is widely used for security management and data encryption. 

# Project Overiew

Data Ingestion - This is the first step in the project where we are ingesting the data from web urls and moving it to our Azure Data Lake Storage Gen2. And all the process was carried out using Azure Data Factory. Use the copy activity under ADF and define your source and sink to carry out the data movement. You can monitor your pipeline runs for efficient copy. 

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/87df4707-b2e9-44dc-afdb-382991cb4304)


Data Storage - This is the immediate step after our data ingestion step through Azure Data Factory. We configured our sink as Azure Data Lake Storage Gen2 where the data will come and load into raw-data folder and the data will be in the exact same format as the source. And we have total three layers build on the storage account - bronze layer that will contain the data in its raw format, silver layer that will have transformed data like refining schema, removing null and duplicates, altering table structures etc. and gold layer that will store all the aggregated data that is built on our transformed data from the silver layer. 

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/d7a0b572-0b28-4a50-877b-503fb15fdfe4)


DATA TRANSFORMATION - After the preliminary data movement is done and we finally have the data on cloud, we move on to the next step of transforming and cleaning the data to make it more usable and structured. In this step we are using Azure Databricks build on Apache Spark and we are using PySPark to write the transformations in the Notebook. We can then execute the Notebook that will automatically spin up the spark cluster and provide you the necessary transformations. But before transformations, we have to provide necessary permissions for our workspace to conncet with storage account and once that is ensured, we then have to mount the data and start with our code.

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/48bf9652-3ce3-486b-aaf5-838d2bf64232)


DATA ANAYTICS - We are then using Azure Synapse Analytics

VISUALISATIONS

# Data Architecture Flow Diagram

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/7cf41ae1-8d3a-4303-b9c0-ec7312314a50)

# Data Sources and Visualisations

# Pre-Requisites




