-- Create a db master key if one does not already exist, using your own password.
CREATE MASTER KEY ENCRYPTION BY PASSWORD='Welcome@123';

-- Create a database scoped credential.
CREATE DATABASE SCOPED CREDENTIAL ADLS_Credentials
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupyx&se=2024-01-25T13:58:40Z&st=2024-01-25T05:58:40Z&spr=https&sig=fJhvtjt0hklwzJGEA7m5PpiPyrDMuUQ%2BAtSC42QVHxw%3D';

-- Create an external Data Source
CREATE EXTERNAL DATA SOURCE ADLS_TokyoOlympicData1
WITH (
    LOCATION = 'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/',
    CREDENTIAL = ADLS_Credentials
);

-- Create an external File Format
CREATE EXTERNAL FILE FORMAT TokyoOlympicData_csv1
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (FIELD_TERMINATOR = ',' )
);

-- Fixed Collation for varchar columns to UTF-8 encoding
ALTER DATABASE AggregatedOlympicDB COLLATE Latin1_General_100_BIN2_UTF8;

-- Creating External Tables as Select (CETAS)

-- A. Total Athletes by Country
CREATE EXTERNAL TABLE TotalAthletes_by_Country
 WITH (
        LOCATION = 'aggregated-data/totalAthletesByCountry.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT Country, Count(*) AS totalAthletes
FROM 
    OPENROWSET(
        BULK  'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/athletes_new.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [PersonName] VARCHAR(100),
         [Country] VARCHAR(50),
         [Discipline] VARCHAR(100),
         [Age] INT
    )
AS [result]
GROUP BY Country
ORDER BY totalAthletes DESC

-- B. Total Athletes by Discipline
CREATE EXTERNAL TABLE TotalAthletes_by_Discipline
 WITH (
        LOCATION = 'aggregated-data/totalAthletesbyDiscipline.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT Discipline, 
COUNT(PersonName) as Total_Athletes
FROM 
    OPENROWSET(
        BULK  'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/athletes_new.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [PersonName] VARCHAR(100),
         [Country] VARCHAR(50),
         [Discipline] VARCHAR(100),
         [Age] INT
    )
AS [result]
GROUP BY Discipline
ORDER BY Total_Athletes DESC

-- C.TotalMedals by country

CREATE EXTERNAL TABLE TotalMedals_by_Country
 WITH (
        LOCATION = 'aggregated-data/totalMedalsbyCountry.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT Team_Country, 
SUM(Gold) as Total_Gold,
SUM(Silver) as Total_Silver,
SUM(Bronze) as Total_Bronze,
SUM(Total) as Overall_Medals
FROM 
    OPENROWSET(
        BULK  'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/medals/part-00000-tid-3639131614052000798-2de27635-2f69-4243-bd7d-f2cabfc0c124-79-1-c000.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [Rank] INT,
         [Team_Country] VARCHAR(50),
         [Gold] INT,
         [Silver] INT,
         [Bronze] INT,
         [Total] INT,
         [Rank_By_Total] INT
    )
AS [result]
GROUP BY Team_Country
ORDER BY Overall_Medals DESC

-- D. Average Entries By Discipline
CREATE EXTERNAL TABLE Avg_EntriesByGender_per_Discipline
 WITH (
        LOCATION = 'aggregated-data/averageEntriesGenderbyDiscipline.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT Discipline,
AVG(Female) as Avg_Female_Count,
AVG(Male) as Avg_Male_Count
FROM 
    OPENROWSET(
        BULK 'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/entriesgender/part-00000-tid-3869180268527403095-88925696-dc09-4d74-9cb5-2f8a27f81b18-77-1-c000.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [Discipline] VARCHAR(50),
         [Female] INT,
         [Male] INT,
         [Total] INT
    )
AS [result]
GROUP BY Discipline

-- E. GenderDistribution and difference
CREATE EXTERNAL TABLE GenderDistribution_Difference_per_Discipline
 WITH (
        LOCATION = 'aggregated-data/genderDistributionDifferencebyDiscipline.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT Discipline,
SUM(Female) as Total_Female,
SUM(Male) as Total_Male,
SUM(Male) - SUM(Female) as Difference_Gender_Distribution
FROM 
    OPENROWSET(
        BULK 'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/entriesgender/part-00000-tid-3869180268527403095-88925696-dc09-4d74-9cb5-2f8a27f81b18-77-1-c000.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [Discipline] VARCHAR(50),
         [Female] INT,
         [Male] INT,
         [Total] INT
    )
AS [result]
GROUP BY Discipline
ORDER BY Total_Female DESC

-- F. Age Analysis of Athletes

CREATE EXTERNAL TABLE AgeAnalysis_Athletes_by_Discipline
 WITH (
        LOCATION = 'aggregated-data/ageAnalysisOfAthletesbyDiscipline.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age >= 18 AND Age < 25 THEN '18-24'
        WHEN Age >= 25 AND Age < 35 THEN '35 and Above'
        ELSE 'Unknown'
    END as AgeGroup,
COUNT(*) AS Athlete_Count
FROM 
    OPENROWSET(
        BULK  'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/athletes_new.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [PersonName] VARCHAR(100),
         [Country] VARCHAR(50),
         [Discipline] VARCHAR(100),
         [Age] INT
    )
AS [result]
WHERE Age IS NOT NULL
GROUP BY 
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age >= 18 AND Age < 25 THEN '18-24'
        WHEN Age >= 25 AND Age < 35 THEN '35 and Above'
        ELSE 'Unknown'
    END ;

-- F. Teams Table

CREATE EXTERNAL TABLE Teams
 WITH (
        LOCATION = 'aggregated-data/teams.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT *
FROM 
    OPENROWSET(
        BULK  'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/teams/part-00000-tid-63323728905602008-7586b4fc-a94f-40bd-afef-6f2e95b556cd-81-1-c000.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [TeamName] VARCHAR(100),
         [Discipline] VARCHAR(50),
         [Country] VARCHAR(100),
         [Event] VARCHAR(100)
    )
AS [result]

-- Create coaches table

CREATE EXTERNAL TABLE Coaches
 WITH (
        LOCATION = 'aggregated-data/coaches.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT *
FROM 
    OPENROWSET(
        BULK  'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/coaches/part-00000-tid-6435612361385679509-b3dc354a-76c0-4f70-84f4-0a98091014df-75-1-c000.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [Name] VARCHAR(100),
         [Country] VARCHAR(50),
         [Discipline] VARCHAR(100),
         [Event] VARCHAR(100)
    )
AS [result]

--Create medals table
CREATE EXTERNAL TABLE Medal
 WITH (
        LOCATION = 'aggregated-data/Medal.csv',
        DATA_SOURCE = ADLS_TokyoOlympicData1,
        FILE_FORMAT = TokyoOlympicData_csv1
    ) 
AS
SELECT *
FROM 
    OPENROWSET(
        BULK  'https://storageaccolympicdata.dfs.core.windows.net/tokyo-olympic-data/transformed-data/medals/part-00000-tid-3639131614052000798-2de27635-2f69-4243-bd7d-f2cabfc0c124-79-1-c000.csv',
        FORMAT = 'CSV',
        HEADER_ROW = TRUE,
        PARSER_VERSION = '2.0'
    )
    WITH(
         [Rank] INT,
         [Team_Country] VARCHAR(50),
         [Gold] INT,
         [Silver] INT,
         [Bronze] INT,
         [Total] INT,
         [Rank_By_Total] INT
    )
AS [result]

--Correlation between coach nationality and team performance
CREATE EXTERNAL TABLE coach_teamPerformances
WITH(
    LOCATION = 'aggregated-data/coachesTeamPerformance.csv',
    DATA_SOURCE = ADLS_TokyoOlympicData1,
    FILE_FORMAT = TokyoOlympicData_csv1
)
AS
SELECT m.Team_Country,m.Gold as TotalGold, m.Silver as TotalSilver, m.Bronze as TotalBronze, m.Total as OverallMedals,
c.Name as CoachName, c.Country as CoachNationality
FROM Medals m 
JOIN Coaches c ON m.Team_Country = c.Country
ORDER BY OverallMedals DESC

-- Coaches involved in multiple events
CREATE EXTERNAL TABLE coach_with_multipleEvents
WITH(
    LOCATION = 'aggregated-data/coachWithMultipleEvents.csv',
    DATA_SOURCE = ADLS_TokyoOlympicData1,
    FILE_FORMAT = TokyoOlympicData_csv1
)
AS
SELECT Name , Country , COUNT(DISTINCT Event) as EventsInvolved 
FROM Coaches
GROUP BY Name, Country 
HAVING COUNT(DISTINCT Event)  > 1
ORDER BY EventsInvolved DESC

select * from Medal




