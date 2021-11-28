-- 1. Top 10 countries with worst COVID-19 cases scenario
SELECT location, date, new_cases, new_cases_per_million, total_cases, total_cases_per_million 
FROM Cases
WHERE location IN (SELECT TOP 10 (location) AS Cases
                   FROM Cases 
				   GROUP BY location
				   HAVING location NOT IN ('World', 'Asia', 'Upper middle income', 'Africa', 'Europe', 'Lower middle income', 'North America', 'South America', 'High income', 'European Union')
				   ORDER BY MAX(total_cases) DESC
				   )

-- 2. Top 10 countries with worst COVID-19 death scenario
SELECT location, date, new_deaths, new_deaths_per_million, total_deaths, total_deaths_per_million
FROM Cases
WHERE location IN (SELECT TOP 10 (location) AS Cases
                   FROM Cases 
				   GROUP BY location
				   HAVING location NOT IN ('World', 'Asia', 'Upper middle income', 'Africa', 'Europe', 'Lower middle income', 'North America', 'South America', 'High income', 'European Union')
				   ORDER BY MAX(total_deaths) DESC
				   )

-- 3. Top countries with worst COVID-19 cases scenario by (Cases/Population) Ratio
SELECT Country.location, MAX(Country.population) AS population, SUM(new_cases) AS cases, (SUM(new_cases)/MAX(population)) AS cases_to_poplation_ratio
FROM Country
INNER JOIN Cases
ON Country.location = Cases.location AND Country.date = Cases.date
WHERE Country.location NOT IN (SELECT Country.location FROM Country
                                WHERE population=0
								GROUP BY Country.location
							  )
GROUP BY Country.location 
ORDER BY cases_to_poplation_ratio DESC

-- 4. Top countries with worst COVID-19 death scenario by (Death/Population) Ratio
SELECT Country.location, MAX(Country.population) AS population, SUM(new_deaths) AS deaths, (SUM(new_deaths)/MAX(population)) AS deaths_to_poplation_ratio
FROM Country
INNER JOIN Cases
ON Country.location = Cases.location AND Country.date = Cases.date
WHERE Country.location NOT IN (SELECT Country.location FROM Country
                                WHERE population=0
								GROUP BY Country.location
							  )
GROUP BY Country.location 
ORDER BY deaths_to_poplation_ratio DESC

-- 5. Sorting TOP countries with COVID-19 cases by in each continents
SELECT * FROM 
(SELECT continent, location, total_cases,
 ROW_NUMBER() OVER (PARTITION BY continent ORDER BY total_cases DESC) AS rank_num
 FROM (SELECT continent, location, MAX(total_cases) AS total_cases
       FROM Cases
       GROUP BY continent, location)
 )AS RNK
WHERE rank_num <4

-- India's COVID-19 scenarios
SELECT * FROM Cases
WHERE location = 'India'

-- 6. Asia's Top 10 countries with maximum COVID-19 impact
SELECT TOP 10  (location), max(total_cases) AS covid19_cases, max(total_deaths) As covid19_deaths
FROM Cases
WHERE continent = 'Asia'
GROUP BY location
ORDER BY covid19_deaths DESC

-- 7. Months when COVID-19 cases were on Peak
SELECT * FROM 
(SELECT TOP 10 DATENAME(yyyy, date) AS year , DATENAME(m, date) AS month, SUM(new_cases) AS new_cases
 FROM Cases
 WHERE location = 'World'
 GROUP BY DATENAME(yyyy, date), DATENAME(mm, date)
) AS t1
ORDER BY new_cases DESC

-- 8. Total cases, deaths in each country by COVID-19
SELECT location, MAX(total_cases) AS Total_Cases, MAX(total_deaths) AS Total_Deaths
FROM Cases
GROUP BY location
ORDER BY Total_Deaths DESC

-- 9. New cases, deaths in each country by COVID-19
SELECT location, new_cases, new_deaths, new_cases_per_million, new_deaths_per_million
FROM Cases
ORDER BY location

-- 10. Finding daily new cases by using lag function which finds todays cases by substracting yesterdays cases
SELECT
   total_cases - LAG(total_cases,1) OVER (PARTITION BY location ORDER BY date) AS new_cases_by_lag_calculation,
   total_cases,
   location,
   date
FROM Cases

-- 11. Corona cases smoothed by averaging 
SELECT
   AVG(total_cases) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS cases_smoothed,
   total_cases,
   location,
   date
FROM Cases 

-- 12. Corona deaths smoothed by averaging
SELECT
   AVG(total_deaths) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS deaths_smoothed,
   total_deaths,
   location,
   date
FROM Cases 


-- 13. Maximum total vaccinations by country
SELECT location, MAX(total_vaccinations) AS vaccinations
FROM Vaccine
GROUP BY location
ORDER BY vaccinations DESC

-- 14. Ratio of(total test/total cases)
SELECT Cases.location, MAX(Vaccine.total_tests)/MAX(Cases.total_cases) AS test_cases_ratio
FROM Vaccine 
INNER JOIN Cases
ON Cases.location = Vaccine.location AND Cases.date = Vaccine.date
WHERE Cases.total_cases NOT IN (0)
GROUP BY Cases.location
ORDER BY test_cases_ratio DESC 

-- 15. Ratio of (total cases/total population) i.e. Percentageof population vaccinated
SELECT
Country.location, 
ROUND(MAX(Vaccine.people_fully_vaccinated)/MAX(Country.population), 4)*100 AS perc_population_vaccinated
FROM Country
INNER JOIN Vaccine
ON Country.location = Vaccine.location AND Vaccine.date = Country.date
GROUP BY Country.location
ORDER BY perc_population_vaccinated DESC

-- 16. Datewise vaccinations for each country
SELECT date, location,new_vaccinations
FROM Vaccine
WHERE new_vaccinations > 0

-- 17. Smoothed vaccination for each country
SELECT
   AVG(new_vaccinations) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 5 PRECEDING AND 5 FOLLOWING) AS new_vaccinations_smoothed,
   new_vaccinations,
   location,
   date
FROM Vaccine
WHERE new_vaccinations > 0

-- 18. Total Cases, Deaths, Vaccinations, Recoveries From COVID-19 in Asia
SELECT 
Cases.location,
MAX(Cases.total_cases) AS total_cases, 
MAX(total_deaths) AS total_deaths, 
MAX(total_vaccinations)AS total_vaccinations,
MAX(total_cases)- MAX(total_deaths) AS total_recoveries
FROM Cases
INNER JOIN Vaccine
ON Cases.location = Vaccine.location AND Vaccine.date = Cases.date
WHERE Cases.continent='Asia'
GROUP BY Cases.location

-- 19. Recovery rates by country
SELECT 
location,
MAX(total_cases)- MAX(total_deaths) AS total_recoveries, 
MAX(Cases.total_cases) AS total_cases,
ROUND(((MAX(total_cases)- MAX(total_deaths))/MAX(total_cases))*100, 2) AS recovery_rate
FROM Cases
WHERE total_cases!=0
GROUP BY location
ORDER BY total_cases DESC

-- 20. COVID-19 cases, deaths, recoveries and vaccinations for entire world
SELECT 
MAX(Cases.total_cases) As total_cases_in_world,
MAX(Cases.total_deaths) AS total_deaths_in_world,
MAX(Cases.total_cases) - SUM(Cases.new_deaths) AS total_recoveries_in_world,
MAX(Vaccine.total_vaccinations) AS total_vaccination_in_world
FROM Cases 
INNER JOIN Vaccine
ON Cases.location = Vaccine.location AND Vaccine.date = Cases.date







































