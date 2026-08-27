

drop table coviddeaths;
-- Syntax for creating the covid deaths table. The import wizard kept freezing due to the csv files being large, so I did the import manually
CREATE TABLE `covid_analysis`.`coviddeaths` (`iso_code` text, `continent` text, `location` text, `date` datetime, `total_cases` double, `new_cases` double, `new_cases_smoothed` double, `total_deaths` double, `new_deaths` double, `new_deaths_smoothed` double, `total_cases_per_million` double, `new_cases_per_million` double, `new_cases_smoothed_per_million` double, `total_deaths_per_million` double, `new_deaths_per_million` double, `new_deaths_smoothed_per_million` double, `reproduction_rate` double, `icu_patients` double, `icu_patients_per_million` double, `hosp_patients` double, `hosp_patients_per_million` double, `weekly_icu_admissions` double, `weekly_icu_admissions_per_million` double, `weekly_hosp_admissions` double, `weekly_hosp_admissions_per_million` double, `new_tests` double, `total_tests` double, `total_tests_per_thousand` double, `new_tests_per_thousand` double, `new_tests_smoothed` double, `new_tests_smoothed_per_thousand` double, `positive_rate` double, `tests_per_case` double, `tests_units` double, `total_vaccinations` double, `people_vaccinated` double, `people_fully_vaccinated` double, `new_vaccinations` double, `new_vaccinations_smoothed` double, `total_vaccinations_per_hundred` double, `people_vaccinated_per_hundred` double, `people_fully_vaccinated_per_hundred` double, `new_vaccinations_smoothed_per_million` double, `stringency_index` double, `population` double, `population_density` double, `median_age` double, `aged_65_older` double, `aged_70_older` double, `gdp_per_capita` double, `extreme_poverty` double, `cardiovasc_death_rate` double, `diabetes_prevalence` double, `female_smokers` double, `male_smokers` double, `handwashing_facilities` double, `hospital_beds_per_thousand` double, `life_expectancy` double, `human_development_index` double);
CREATE TABLE `covid_analysis`.`covidvaccinations` (`iso_code` text, `continent` text, `location` text, `date` datetime, `new_tests` double, `total_tests` double, `total_tests_per_thousand` double, `new_tests_per_thousand` double, `new_tests_smoothed` double, `new_tests_smoothed_per_thousand` double, `positive_rate` double, `tests_per_case` double, `tests_units` double, `total_vaccinations` double, `people_vaccinated` double, `people_fully_vaccinated` double, `new_vaccinations` double, `new_vaccinations_smoothed` double, `total_vaccinations_per_hundred` double, `people_vaccinated_per_hundred` double, `people_fully_vaccinated_per_hundred` double, `new_vaccinations_smoothed_per_million` double, `stringency_index` double, `population_density` double, `median_age` double, `aged_65_older` double, `aged_70_older` double, `gdp_per_capita` double, `extreme_poverty` double, `cardiovasc_death_rate` double, `diabetes_prevalence` double, `female_smokers` double, `male_smokers` double, `handwashing_facilities` double, `hospital_beds_per_thousand` double, `life_expectancy` double, `human_development_index` double);



SET GLOBAL local_infile = 1;


LOAD DATA LOCAL INFILE 'C:/Users/daven/Downloads/CovidDeaths.csv'
INTO TABLE coviddeaths
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
-- the format of the date column was not compatible with mysql import, so I recoded the variable below using STR_TO_DATE
(iso_code, continent, location, @date, total_cases, new_cases, new_cases_smoothed, total_deaths, new_deaths, new_deaths_smoothed, total_cases_per_million, new_cases_per_million, new_cases_smoothed_per_million, total_deaths_per_million, new_deaths_per_million, new_deaths_smoothed_per_million, reproduction_rate, icu_patients, icu_patients_per_million, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million, new_tests, total_tests, total_tests_per_thousand, new_tests_per_thousand, new_tests_smoothed, new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units, total_vaccinations, people_vaccinated, people_fully_vaccinated, new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, new_vaccinations_smoothed_per_million, stringency_index, population, population_density, median_age, aged_65_older, aged_70_older, gdp_per_capita, extreme_poverty, cardiovasc_death_rate, diabetes_prevalence, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand, life_expectancy, human_development_index)
SET date = STR_TO_DATE(@date, '%c/%e/%Y');

select *
FROM covid_analysis.coviddeaths;

-- The datatypes of the 




LOAD DATA LOCAL INFILE 'C:/Users/daven/Downloads/CovidVaccinations.csv'
INTO TABLE covidvaccinations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select *
FROM covid_analysis.covidvaccinations;