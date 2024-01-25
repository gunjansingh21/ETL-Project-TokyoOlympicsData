-- Count the number of athletes from each country
SELECT Country,
       Count(*) AS totalAthletes
FROM athletes_age
GROUP BY Country
ORDER BY totalAthletes DESC

-- TotalAthletes per discipline
SELECT Discipline, 
COUNT(PersonName) as Total_Athletes
FROM athletes_age
GROUP BY Discipline
ORDER BY Total_Athletes DESC

-- Calculate the total medals won by each country
SELECT Team_Country, 
SUM(Gold) as Total_Gold,
SUM(Silver) as Total_Silver,
SUM(Bronze) as Total_Bronze,
SUM(Total) as Overall_Medals
FROM medals
GROUP BY Team_Country
ORDER BY Overall_Medals DESC

-- Calculate the average number of entriesby gender of each distribution
SELECT Discipline,
AVG(Female) as Avg_Female_Count,
AVG(Male) as Avg_Male_Count
FROM entriesgender
GROUP BY Discipline


--Total Female and Male for each discipline and difference in the gender distribution
SELECT Discipline,
SUM(Female) as Total_Female,
SUM(Male) as Total_Male,
SUM(Male) - SUM(Female) as Difference_Gender_Distribution
FROM entriesgender
GROUP BY Discipline
ORDER BY Total_Female DESC

-- Age Group Analysis
SELECT 
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age >= 18 AND Age < 25 THEN '18-24'
        WHEN Age >= 25 AND Age < 35 THEN '35 and Above'
        ELSE 'Unknown'
    END as AgeGroup,
COUNT(*) AS Athlete_Count
FROM athletes_age
WHERE Age IS NOT NULL
GROUP BY 
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age >= 18 AND Age < 25 THEN '18-24'
        WHEN Age >= 25 AND Age < 35 THEN '35 and Above'
        ELSE 'Unknown'
    END ;

--Correlation between coach nationality and team performance
SELECT m.Team_Country,m.Gold as TotalGold, m.Silver as TotalSilver, m.Bronze as TotalBronze, m.Total as OverallMedals,
c.Name as CoachName, c.Country as CoachNationality
FROM medals m 
JOIN coaches c ON m.Team_Country = c.Country
ORDER BY OverallMedals DESC

-- Coaches involved in multiple events
SELECT Name , Country , COUNT(DISTINCT Event) as EventsInvolved 
FROM coaches
GROUP BY Name, Country 
HAVING COUNT(DISTINCT Event)  > 1
ORDER BY EventsInvolved DESC

