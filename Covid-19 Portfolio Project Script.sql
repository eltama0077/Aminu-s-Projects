SELECT *  FROM portfolio.coviddeaths1;

Select * from covidvaccinations;

-- Total cases vs Total Deaths

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)* 100 as Deathpercentage
 from coviddeaths1 
 where location like '%Nigeria%';
-- Total cases vs population (shows what percentage of population infected)
Select location, date, total_cases, population,(total_cases/population)* 100 as PercentofPopulationInfected
 from coviddeaths1 
 where location like '%Nigeria%';
 -- looking at countries with Highest infection rate compared to the population
 Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))* 100 as PercentofPopulationInfected
 from coviddeaths1
 group by location, population
 order by PercentofPopulationInfected desc;
 -- showing countries with Highest Death count per population
 Select location, sum(new_deaths) AS TotalDeathCount
 from coviddeaths1
 group by location
 order by TotalDeathCount desc;
 -- SHOWING THE TOTAL DEATH IN AFGHANISTAN
  Select location, sum(new_deaths) AS TotalDeathCount
 from coviddeaths1
 where location like '%afghanistan%'
 group by location;
 -- SHOWING THE TOTAL DEATHS IN NIGERIA
 Select location, sum(new_deaths) AS TotalDeathCount
 from coviddeaths1 where location like '%Nigeria%'
 group by location;
-- CONTINENTAL BREAKDWON (CONTINENT WITH THE HIGHEST DEATH COUNT)
select continent, sum(new_deaths) as TotalDeathCount 
from coviddeaths1 where continent is not null
group by continent
order by TotalDeathCount desc;

-- LOOKING AT TOTAL POPULATION VS VACCINATIONS
-- USE CTE
 with PopVsVacc (continent, location, date, population, new_vaccinations,RollingPeopleVaccinated) as
(SELECT Cd.continent,cd.location,  cv.date,cd.population, cv.new_vaccinations, sum(cast(cv.new_vaccinations as unsigned)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated 
 FROM portfolio.coviddeaths1  Cd
join portfolio.covidvaccinations Cv
on Cd.location = Cv.location and cd.date = cv.date
where cd.continent is not null)
select * ,(RollingPeopleVaccinated/Population)* 100
from PopVsVacc;

-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
CREATE VIEW `new_view` AS
select cd.continent,cd.location,  cv.date,cd.population, cv.new_vaccinations, sum(cast(cv.new_vaccinations as unsigned)) over (partition by cd.location order by cd.location, cd.date) as RollingPeopleVaccinated 
From coviddeaths1  Cd
join covidvaccinations Cv on Cd.location = Cv.location
 and cd.date = cv.date 
 where cd.continent is not null;
 rename table `new_view` to PercentPopulationVaccinated_view;


