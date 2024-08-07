SELECT *
FROM Portfolio_Project.dbo.covid_death
ORDER BY 3,4


SELECT *
FROM Portfolio_Project.dbo.covid_vaccination
ORDER BY 3,4


--- picking useful datasets
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project.dbo.covid_death
ORDER BY 1, 2

---- looking at total_cases vs total_deaths
SELECT
	location, date, total_cases, total_deaths,
	(total_deaths / NULLIF (total_cases, 0) ) * 100  AS death_percent
FROM
	Portfolio_Project.dbo.covid_death
ORDER BY 
	1, 2

---- looking at total_cases vs total_deaths another way to eliminate divisor 0
SELECT
	location, date, total_cases, total_deaths,
	CASE
		WHEN total_cases = 0 THEN NULL
		ELSE
			(total_deaths / total_cases) * 100 
	END AS death_percent
FROM
	Portfolio_Project.dbo.covid_death
ORDER BY 
	1, 2


--exploring china cases
--likelihood of dying if you contract covid in china
SELECT
	location, date, total_cases, total_deaths,
	(total_deaths / NULLIF (total_cases, 0) ) * 100  AS death_percent
FROM
	Portfolio_Project.dbo.covid_death
WHERE location LIKE 'chin%'
ORDER BY 
	1, 2


-- total cases and deaths for each country
SELECT
	location, MAX(total_cases) AS total_cases, 
	MAX(total_deaths) AS total_deaths
FROM
	Portfolio_Project.dbo.covid_death
WHERE location <> 'Africa' AND location!= 'Europe' 
	  AND location != 'Asia' AND location != 'North America'
	  AND location != 'European Union (27)' AND location != 'Oceania'
	  AND location != 'South America' AND location != 'World'
	  AND location NOT LIKE 'Upper-midd%'
	  
GROUP BY location
ORDER BY  location

--create view total cases and death per country

CREATE VIEW percentage_death AS
SELECT
	location, MAX(total_cases) AS total_cases, 
	MAX(total_deaths) AS total_deaths
FROM
	Portfolio_Project.dbo.covid_death
WHERE location <> 'Africa' AND location!= 'Europe' 
	  AND location != 'Asia' AND location != 'North America'
	  AND location != 'European Union (27)' AND location != 'Oceania'
	  AND location != 'South America' AND location != 'World'
	  AND location NOT LIKE 'Upper-midd%'
	  
GROUP BY location

-- total cases and deaths for continent and world data
SELECT
	location, population, MAX(total_cases) AS total_cases, 
	MAX(total_deaths) AS total_deaths
FROM
	Portfolio_Project.dbo.covid_death
WHERE location = 'Africa' OR location = 'Europe' 
	  OR location = 'Asia' OR location = 'North America'
	  OR location = 'European Union (27)' OR location = 'Oceania'
	  OR location = 'South America' OR location = 'World'
	  OR location LIKE 'Upper-midd%'
	  
GROUP BY location, population
ORDER BY  location

-- creating view total covid death per continent
CREATE VIEW covid_death_per_continent AS
SELECT
	location, population, MAX(total_cases) AS total_cases, 
	MAX(total_deaths) AS total_deaths
FROM
	Portfolio_Project.dbo.covid_death
WHERE location = 'Africa' OR location = 'Europe' 
	  OR location = 'Asia' OR location = 'North America'
	  OR location = 'European Union (27)' OR location = 'Oceania'
	  OR location = 'South America' OR location = 'World'
	  OR location LIKE 'Upper-midd%'
	  
GROUP BY location, population


-- Total cases vs population of italy
SELECT 
	location, date, total_cases, population,
	total_cases / NULLIF (population, 0) * 100 AS percent_case
FROM
	Portfolio_Project..covid_death
WHERE location = 'Italy'
ORDER BY date

-- Total cases vs population of USA
-- Percen got covid
SELECT 
	location, date, population, total_cases,
	total_cases / NULLIF (population, 0) * 100 AS percent_case
FROM
	Portfolio_Project..covid_death
WHERE location LIKE 'United States'
ORDER BY date

---country vs country infection of covid and death_percentage
SELECT 
	location, MAX(total_cases) AS highest_infection_count,
	MAX(total_deaths) AS total_deaths,
	MAX(population) population, 
	MAX(total_cases / NULLIF (population, 0) * 100) AS percentage_population_infected,
CASE
	WHEN MAX (total_cases) = 0 THEN 0
	ELSE MAX(total_deaths) / MAX (total_cases) * 100 
END AS death_percentage
FROM
	Portfolio_Project..covid_death
WHERE
	location <> 'Africa' AND location!= 'Europe' 
	  AND location != 'Asia' AND location != 'North America'
	  AND location != 'European Union (27)' AND location != 'Oceania'
	  AND location != 'South America' AND location != 'World'
	  AND location NOT LIKE 'Upper-midd%'
	  AND location NOT LIKE 'Lower-midd%' AND location NOT LIKE 'Low-inc%'
GROUP BY 
	location
ORDER BY 
	 death_percentage DESC

	--create view
CREATE VIEW covid_infection_and_death_rate_per_country AS
SELECT 
	location, MAX(total_cases) AS highest_infection_count,
	MAX(total_deaths) AS total_deaths,
	MAX(population) population, 
	MAX(total_cases / NULLIF (population, 0) * 100) AS percentage_population_infected,
CASE
	WHEN MAX (total_cases) = 0 THEN 0
	ELSE MAX(total_deaths) / MAX (total_cases) * 100 
END AS death_percentage
FROM
	Portfolio_Project..covid_death
WHERE
	location <> 'Africa' AND location!= 'Europe' 
	  AND location != 'Asia' AND location != 'North America'
	  AND location != 'European Union (27)' AND location != 'Oceania'
	  AND location != 'South America' AND location != 'World'
	  AND location NOT LIKE 'Upper-midd%'
	  AND location NOT LIKE 'Lower-midd%' AND location NOT LIKE 'Low-inc%'
GROUP BY 
	location
	
--- country with highest infection rate compared to population

SELECT 
	location, population,
	MAX(total_cases) AS highest_infection_count, 
	MAX(total_cases / NULLIF (population, 0) * 100) AS percentage_population_infected
FROM
	Portfolio_Project..covid_death
WHERE
	location <> 'Africa' AND location!= 'Europe' 
	  AND location != 'Asia' AND location != 'North America'
	  AND location != 'European Union (27)' AND location != 'Oceania'
	  AND location != 'South America' AND location != 'World'
	  AND location NOT LIKE 'Upper-midd%'
	  AND location NOT LIKE 'Lower-midd%' AND location NOT LIKE 'Low-inc%'
GROUP BY 
	location, population
ORDER BY 
	 percentage_population_infected DESC


--create view
CREATE VIEW infection_rate_per_population AS
SELECT 
	location, population,
	MAX(total_cases) AS highest_infection_count, 
	MAX(total_cases / NULLIF (population, 0) * 100) AS percentage_population_infected
FROM
	Portfolio_Project..covid_death
WHERE
	location <> 'Africa' AND location!= 'Europe' 
	  AND location != 'Asia' AND location != 'North America'
	  AND location != 'European Union (27)' AND location != 'Oceania'
	  AND location != 'South America' AND location != 'World'
	  AND location NOT LIKE 'Upper-midd%'
	  AND location NOT LIKE 'Lower-midd%' AND location NOT LIKE 'Low-inc%'
GROUP BY 
	location, population

-- country with highest death count
SELECT 
	location, MAX(total_deaths) AS total_death_count
FROM
	Portfolio_Project..covid_death
WHERE continent IS NOT NULL
GROUP BY
	location
ORDER BY
	total_death_count DESC


--create view
CREATE VIEW country_covid_death AS
SELECT 
	location, MAX(total_deaths) AS total_death_count
FROM
	Portfolio_Project..covid_death
WHERE continent IS NOT NULL
GROUP BY
	location


--- continent death count
SELECT 
	location, MAX(total_deaths) AS total_death_count
FROM
	Portfolio_Project..covid_death
WHERE location = 'Africa' OR location = 'Europe' 
	  OR location = 'Asia' OR location = 'North America'
	  OR location = 'European Union (27)' OR location = 'Oceania'
	  OR location = 'South America' 
GROUP BY
	location
ORDER BY
	total_death_count DESC

-- continent infection count and death count
SELECT 
	location, MAX(total_cases) AS total_infection_count,
	MAX(total_deaths) AS total_death_count
FROM
	Portfolio_Project..covid_death
WHERE location = 'Africa' OR location = 'Europe' 
	  OR location = 'Asia' OR location = 'North America'
	  OR location = 'European Union (27)' OR location = 'Oceania'
	  OR location = 'South America' 
GROUP BY
	location
ORDER BY
	total_infection_count DESC

-- total covid 19 death
SELECT 
	continent, MAX(total_deaths) AS total_death_count
FROM
	Portfolio_Project..covid_death
WHERE continent IS NULL
GROUP BY
	continent

-- continent with higest death count per population
SELECT 
	location, population, MAX(total_deaths) AS total_death_count,  
	MAX(total_deaths / NULLIF(population, 0) * 100) AS percentage_death_count
FROM
	Portfolio_Project..covid_death
WHERE location = 'Africa' OR location = 'Europe' 
	  OR location = 'Asia' OR location = 'North America'
	  OR location = 'European Union (27)' OR location = 'Oceania'
	  OR location = 'South America' 
GROUP BY
	location, population
ORDER BY
	percentage_death_count DESC

-- Death percentage to covid infection of the whole world

SELECT
	SUM(new_cases) AS covid_world_infection,
	SUM(new_deaths) AS covid_world_death,
	SUM(new_deaths) / SUM(new_cases) * 100 AS percentage_world_death_by_covid
FROM
	Portfolio_Project..covid_death
WHERE 
	continent IS NOT NULL 


--exploring other dataset vaccination and total population
SELECT 
	covid_d.continent, covid_d.location, covid_d.date, 
	covid_d.population, covid_d.total_cases, covid_d.total_deaths, new_vaccinations,
 --cast
	SUM(CONVERT(int, new_vaccinations ))
	OVER (PARTITION BY covid_d.location ORDER BY covid_d.date) AS vacc_sum
FROM 
	Portfolio_Project..covid_death AS covid_d
INNER JOIN
	Portfolio_Project..covid_vaccination AS covid_v
ON
	covid_d.location = covid_v.location
AND 
	covid_d.date = covid_v.date
WHERE covid_d.continent IS NOT NULL
ORDER BY 2

--creating CRT
WITH Pop_Vs_Vac AS
(SELECT 
	covid_d.continent, covid_d.location, covid_d.date, 
	covid_d.population, covid_d.total_cases, covid_d.total_deaths, new_vaccinations,
 --cast
	SUM(CONVERT(int, new_vaccinations ))
	OVER (PARTITION BY covid_d.location ORDER BY covid_d.date) AS vacc_sum
FROM 
	Portfolio_Project..covid_death AS covid_d
INNER JOIN
	Portfolio_Project..covid_vaccination AS covid_v
ON
	covid_d.location = covid_v.location
AND 
	covid_d.date = covid_v.date
WHERE covid_d.continent IS NOT NULL)

SELECT* , vacc_sum / population *100 AS Percent_vacc_per_pop
FROM Pop_Vs_Vac

-- creating Temp Table
DROP TABLE IF EXISTS #POP_VS_VACC_1
CREATE TABLE #POP_VS_VACC_1
(continent nvarchar(255), location nvarchar(255),
date datetime, population numeric, total_cases float, total_deaths float,
new_vaccinations int, vacc_sum numeric)

INSERT INTO #POP_VS_VACC_1
SELECT 
	covid_d.continent, covid_d.location, covid_d.date, 
	covid_d.population, covid_d.total_cases, covid_d.total_deaths, new_vaccinations,
 --cast
	SUM(CONVERT(int, new_vaccinations ))
	OVER (PARTITION BY covid_d.location ORDER BY covid_d.date) AS vacc_sum
FROM 
	Portfolio_Project..covid_death AS covid_d
INNER JOIN
	Portfolio_Project..covid_vaccination AS covid_v
ON
	covid_d.location = covid_v.location
AND 
	covid_d.date = covid_v.date
WHERE covid_d.continent IS NOT NULL
ORDER BY 2

SELECT *,  vacc_sum / population *100 AS Percent_vacc_per_pop
FROM 
	#POP_VS_VACC_1

--creating View to store data for later visualization

CREATE VIEW country_covid_death AS
 SELECT 
	location, MAX(total_deaths) AS total_death_count
FROM
	Portfolio_Project..covid_death
WHERE continent IS NOT NULL
GROUP BY
	location

--creating view vacc per country
CREATE VIEW vacc_per_country AS
SELECT 
	covid_d.continent, covid_d.location, covid_d.date, 
	covid_d.population, covid_d.total_cases, covid_d.total_deaths, new_vaccinations,
 --cast
	SUM(CONVERT(int, new_vaccinations ))
	OVER (PARTITION BY covid_d.location ORDER BY covid_d.date) AS vacc_sum
FROM 
	Portfolio_Project..covid_death AS covid_d
INNER JOIN
	Portfolio_Project..covid_vaccination AS covid_v
ON
	covid_d.location = covid_v.location
AND 
	covid_d.date = covid_v.date
WHERE covid_d.continent IS NOT NULL



