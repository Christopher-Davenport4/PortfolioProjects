
select * from coviddeaths;
Select Location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject.coviddeaths
WHERE continent <> '' AND continent IS NOT NULL
order by 1, 2;
 
-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 as death_pct
FROM portfolioproject.coviddeaths
WHERE location like '%state%' 
and continent <> '' AND continent IS NOT NULL
order by 1, 2;

-- Looking at the total cases vs the population
-- Shows what percentage of population got covid
Select Location, date, total_cases, Population, (total_cases/Population) * 100 as contractionPct
FROM portfolioproject.coviddeaths
WHERE location like '%state%'
AND  continent <> '' AND continent IS NOT NULL
order by 1, 2;

-- Looking at the countries with the highest infection rate compared to population
Select Location, Population, Max(total_cases) as highest_infection_count, max((total_cases/Population) * 100) as contractionPct
FROM portfolioproject.coviddeaths
-- WHERE location like '%state%'
WHERE continent <> '' AND continent IS NOT NULL
group by location, Population
order by contractionPct DESC;

-- Showing Countries with Highest Deathcount per population
Select Location,  max(CAST(total_deaths AS SIGNED)) as totaldeathcount
FROM portfolioproject.coviddeaths
WHERE continent <> '' AND continent IS NOT NULL
group by Location 	
order by totaldeathcount DESC;

-- BROKEN DOWN BY CONTINENT
-- Showing the continents with the highest deathcount
Select continent,  max(CAST(total_deaths AS SIGNED)) as totaldeathcount
FROM portfolioproject.coviddeaths
WHERE continent <> '' AND continent IS NOT NULL
group by continent
order by totaldeathcount DESC;

-- GLOBAL NUMBERS
Select  SUM(new_cases) as totalCases, SUM(new_deaths) as totalDeaths, sum(new_deaths)/sum(new_cases)* 100 as global_death_pct
FROM portfolioproject.coviddeaths
-- WHERE location like '%state%' 
WHERE continent <> '' AND continent IS NOT NULL
-- GROUP BY DATE
order by 1, 2;

-- Looking at total population vs vaccination
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, rolling_people_vaccinated) 
AS (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) OVER (Partition by dea.Location order by dea.location, dea.date) as rolling_people_vaccinated
FROM portfolioproject.coviddeaths dea
JOIN portfolioproject.covidvaccinations vac
	on dea.location = vac.location and dea.date = vac.date
WHERE dea.continent <> '' AND dea.continent IS NOT NULL
order by  2, 3
)
select *, (rolling_people_vaccinated/Population) * 100
from PopvsVac;

-- TEMP TABLE
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population int,
New_vaccination float,
RollingPeopleVaccinated int
);
Insert Into PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) OVER (Partition by dea.Location order by dea.location, dea.date) as rolling_people_vaccinated
FROM portfolioproject.coviddeaths dea
JOIN portfolioproject.covidvaccinations vac
	on dea.location = vac.location and dea.date = vac.date
WHERE dea.continent <> '' AND dea.continent IS NOT NULL
order by  2, 3;
select *, (RollingPeopleVaccinated/Population) * 100
from PercentPopulationVaccinated;

-- Creating View to Store Data for Later Visualizations
Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) OVER (Partition by dea.Location order by dea.location, dea.date) as rolling_people_vaccinated
FROM portfolioproject.coviddeaths dea
JOIN portfolioproject.covidvaccinations vac
	on dea.location = vac.location and dea.date = vac.date
WHERE dea.continent <> '' AND dea.continent IS NOT NULL
order by  2, 3;
select * from percentpopulationvaccinated;