-- 1.
SELECT SUM(new_cases) AS total_cases,
       SUM(CAST(new_deaths AS SIGNED)) AS total_deaths,
       SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 AS DeathPercentage
FROM portfolioproject.CovidDeaths
-- Where location like '%states%'
WHERE continent <> '' AND continent IS NOT NULL
-- Group By date
ORDER BY 1,2;
SELECT COUNT(*) FROM portfolioproject.CovidDeaths;
-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International" Location
-- SELECT SUM(new_cases) AS total_cases,
--        SUM(CAST(new_deaths AS SIGNED)) AS total_deaths,
--        SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 AS DeathPercentage
-- FROM portfolioproject.CovidDeaths
-- Where location like '%states%'
-- WHERE location = 'World'
-- Group By date
-- ORDER BY 1,2;


-- 2.
-- We take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe
SELECT location,
       SUM(CAST(new_deaths AS SIGNED)) AS TotalDeathCount
FROM portfolioproject.CovidDeaths
-- Where location like '%states%'
WHERE (continent = '' OR continent IS NULL)
  AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- 3.
SELECT location,
       population,
       MAX(total_cases) AS HighestInfectionCount,
       MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM portfolioproject.CovidDeaths
-- Where location like '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


-- 4.
SELECT location,
       population,
       date,
       MAX(total_cases) AS HighestInfectionCount,
       MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM portfolioproject.CovidDeaths
-- Where location like '%states%'
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;