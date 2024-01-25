# ETL-Project-TokyoOlympicsData

Welcome to the end to end Data Engineering project on Tokyo Olympics Data on Azure. This project is designed to showcase how various Azure services can be utilized and leveraged to perform ETL operations like data ingestion, data transformation and data analytics on this dataset. We have used the following Azure services to build this project and achieve the final goal.

# Table of Contents
1. Introduction to Azure Services
2. [Project Overview](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/blob/b96887990ae380f95ee36eb88ce4f268224d8523/README.md?plain=1#L26) 
3. Data Architecture Flow Diagram
4. Data Sources & Visualisations
5. PreRequisites

# Introduction to Azure Services (Step by Step)
**Azure Data Factory**: Azure Data Factory (ADF) is a fully managed, serverless data integration solution for ingesting, preparing, and transforming all your data at scale. In this project we are using the ADF to ingest data from our data sources that are .csv files from web(https). We are using the copy data activity in Azure Data Factory to move our data from source (.csv files) to sink (Azure Data Lake Storage Gen2). 

**Azure Data Lake Storage Gen2** : This is the storage account where we are storing the data coming from our sorce. The data ingested here is in raw format. Azure Data Lake Storage Gen2 provides a scalable and secure platform for storing large volumes of data. It enables us to manage, access. and analyze data effectively. We'll be storing the data in three layers.
   - raw-data (BRONZE)
   - transformed-data (SILVER)
   - aggreagated-data (GOLD)

**Azure Databricks**: For data transformation like changing or modifying the schema of the tables, changing and modifying few columns we have leveraged Azure Databricks with PySpark. It is used for data tranformations like removing nulls and duplicate data. Firstly, we used the fs utility under dbutils to mount the data from ADLS Gen2 to Databricks Workspace and on top of that we did some cleaning and modification of Tokyo Olympics Data. Databricks is a unified, open analytics platform for building, deploying, sharing, and maintaining enterprise-grade data, analytics, and AI solutions at scale. And then we moved the transformed_data to the same named folder(silver layer) in ADLS Gen2.

**Azure Synapse Analytics** : We have used Azure Synapse Analytics to gain some valuable insights from the transformed data and performed some aggregations on top of the transformed data. We created a lake database by accessing the files on ADLS Gen2. We also used SQL queries to build some aggreagtion and store that in external tables and writing the aggregated data into the gold layer of storage account. This is where we extract meaningful information. This is where we uncover trends, find patterns, get valuable insights related to our Data Olympic Dataset. 

**Azure Key Valut** : We have used this service to maintain and keep our secrets encrypted. Azure Key Vault is a cloud service that provides a secure store for secrets. You can securely store keys, passwords, certificates, and other secrets. Azure key vaults are created and managed through the Azure portal. It is widely used for security management and data encryption. 

# Project Overiew

**Data Ingestion** - This is the first step in the project where we are ingesting the data from web urls and moving it to the Azure Data Lake Storage Gen2. The data ingestion process was carried out using Azure Data Factory. Use the copy activity under ADF and define your source and sink to carry out the data movement. You can monitor your pipeline runs for efficient copy. 

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/87df4707-b2e9-44dc-afdb-382991cb4304)

**Data Storage** - This is the immediate step after our data ingestion. We configured our sink as Azure Data Lake Storage Gen2 where the data will come and load into raw-data folder and the data will be in the exact same format as the source. There are three layers build on the storage account for this project - bronze layer that will contain the data in its raw format, silver layer that will have the transformed data like refining schema, removing null and duplicates, altering table structures etc. and gold layer that will store all the aggregated data that is built on our transformed data from the silver layer. 

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/d7a0b572-0b28-4a50-877b-503fb15fdfe4)

**Data Transformation** - After the preliminary data movement is done and we finally have the data on cloud, we move on to the next step of mounting the data and transforming and cleaning the data to make it more readable and structured. In this step, we are using Azure Databricks build on Apache Spark and we are using PySPark to write the transformations in the Notebook. We can then execute the Notebook that will automatically spin up the spark cluster and provide you the necessary compute to carry out your data transformations. But before transformations, make sure to provide necessary permissions for your Databricks workspace to connect with storage account (ADLS Gen2). 

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/48bf9652-3ce3-486b-aaf5-838d2bf64232)

**Data Analytics** - We are then using Azure Synapse Analytics for analytics. Here we create aggreagtions using SQL queries on the transformed data and store it in the gold layer. We are also creating external data sources, file formats and tables for querying the data to gain insights and understand patterns from the data. We can either do the analytics on Synapse using Synapse SQL or Apache Spark Pool. Make sure you provide the necessary roles and permissions to your Synapse workspace that it can access the storage account. 

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/e06ed0e7-1966-4e7f-9751-41a82123067f)

**Data Visualisation** : This is the last step where we are creating visualisations on top of our aggregated data. We create charts and graphs so that these visualisations can help business understand the data clearly and easily. It's an important step in making informed business decisions. We can create various types of graphs like bar chart, scatter plot, column chart, line chart, pie charts etc. using various tools. 

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/27e09033-2f55-4445-9cc8-8a955377d2d8)

# Data Architecture Flow Diagram

![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/7cf41ae1-8d3a-4303-b9c0-ec7312314a50)

# Data Sources and Visualisations

Data Source
![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/254341f1-f5e1-4dce-acb5-b7103c91a0ef)

Visualisation 1: ageAnalysisOfAthletesbyDiscipline
![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/2eabc000-3a4d-43ff-bca3-823b254f8e78)

Visualisation 2: averageEntriesGenderbyDiscipline
![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/80e39333-21c3-4926-870d-43c40b4d6a0b)

Visualisation 3: coachWithMultipleEvents
![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/c414c0e7-e9fa-44ba-9361-447760495255)

Visualisation 4: performanceOfCountrybyOverallMedalsvsGoldMedals
![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/519f8398-cae5-48f7-9dbb-4ca6273fb4e9)

Visualisation 5: totalAthletesByCountry
![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/5ab03752-b514-48d5-a737-9ec8e3c3565c)

Visualisation 6: totalAthletesbyDiscipline
![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/8800db4d-c202-48a7-9de2-5cda6a76dea3)

Visualisation 7: totalMedalsbyCountry
![image](https://github.com/gunjansingh21/ETL-Project-TokyoOlympicsData/assets/29482753/4accaf0d-a189-4c6b-90a9-71f167291dba)

# Pre-Requisites

1. You need to have an active Azure subscription to provision these required services.
2. You need to have an account on Azure Portal to access and manage these resources for your ETL project.
3. Make sure you have your source data sets ready and in place to start the project.







