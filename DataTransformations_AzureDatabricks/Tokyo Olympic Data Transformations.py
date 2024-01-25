# Databricks notebook source
configs = {"fs.azure.account.auth.type": "OAuth",
"fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
"fs.azure.account.oauth2.client.id": "2d8731f9-36d2-4b82-b0ac-72ca4a2e8c24",
"fs.azure.account.oauth2.client.secret": dbutils.secre,
"fs.azure.account.oauth2.client.endpoint": "https://login.microsoftonline.com/b46aa8e3-1d91-428a-b230-f35159b85f42/oauth2/token"}

dbutils.fs.mount(
    source = "abfss://tokyo-olympic-data@storageaccolympicdata.dfs.core.windows.net",
    mount_point = "/mnt/tokyoolympicdata",
    extra_configs = configs
)

# COMMAND ----------

# MAGIC %fs
# MAGIC ls "/mnt/tokyoolympicdata"

# COMMAND ----------

# MAGIC %fs
# MAGIC ls "/mnt/tokyoolympicdata/raw-data/"

# COMMAND ----------

athletes = spark.read.csv("dbfs:/mnt/tokyoolympicdata/raw-data/athletes.csv",header=True, inferSchema=True)
coaches = spark.read.csv("dbfs:/mnt/tokyoolympicdata/raw-data/coaches.csv",header=True, inferSchema=True) 
entriesgender = spark.read.csv("dbfs:/mnt/tokyoolympicdata/raw-data/EnteriesGender.csv",header=True)
medals = spark.read.csv("dbfs:/mnt/tokyoolympicdata/raw-data/medals.csv",header=True, inferSchema=True)
teams = spark.read.csv("dbfs:/mnt/tokyoolympicdata/raw-data/teams.csv",header=True, inferSchema=True)

# COMMAND ----------

display(athletes)

# COMMAND ----------

athletes.printSchema()

# COMMAND ----------

display(coaches)

# COMMAND ----------

coaches.printSchema()

# COMMAND ----------

display(entriesgender)

# COMMAND ----------

entriesgender.printSchema()

# COMMAND ----------

from pyspark.sql.functions import col
from pyspark.sql.types import  IntegerType, DoubleType, BooleanType, DateType, StringType

entriesgender = entriesgender.withColumn("Female",col("Female").cast(IntegerType()))\
    .withColumn("Male",col("Male").cast(IntegerType()))\
    .withColumn("Total",col("Total").cast(IntegerType()))

# COMMAND ----------

entriesgender.printSchema()

# COMMAND ----------

display(medals)

# COMMAND ----------

medals.printSchema()

# COMMAND ----------

display(teams)

# COMMAND ----------

teams.printSchema()

# COMMAND ----------

#Find the top countries with the highest number of gold medals
top_gold_medal_countries = medals.select("Team_Country","Gold").orderBy("Gold", ascending=False)

# COMMAND ----------

top_gold_medal_countries.show()

# COMMAND ----------

# Calculate the average number of entries by gender for each discipline
average_entries_by_gender = entriesgender.withColumn(
    'Avg_Female', entriesgender['Female'] / entriesgender['Total']
).withColumn(
    'Avg_Male', entriesgender['Male'] / entriesgender['Total']
)
average_entries_by_gender.show()

# COMMAND ----------

athletes.repartition(1).write.mode("overwrite").option("header",'true').csv("dbfs:/mnt/tokyoolympicdata/transformed-data/athletes")

# COMMAND ----------

coaches.repartition(1).write.mode("overwrite").option("header","true").csv("dbfs:/mnt/tokyoolympicdata/transformed-data/coaches")
entriesgender.repartition(1).write.mode("overwrite").option("header","true").csv("dbfs:/mnt/tokyoolympicdata/transformed-data/entriesgender")
medals.repartition(1).write.mode("overwrite").option("header","true").csv("dbfs:/mnt/tokyoolympicdata/transformed-data//medals")
teams.repartition(1).write.mode("overwrite").option("header","true").csv("dbfs:/mnt/tokyoolympicdata/transformed-data/teams")

# COMMAND ----------


