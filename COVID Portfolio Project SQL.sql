Select*
From [Portfolio Project ]..CovidDeaths
Where continent is not null
order by 3,4

Select*
From [Portfolio Project ]..[Covid Vaccinations]
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project ]..CovidDeaths
order by 1,2


-- Total Cases vs Total Deaths  
-- Likelihood of dying if Covid is contracted in Europe 
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project ]..CovidDeaths
where location like '%Europe%'
order by 1,2

-- Total Cases vs Population  
-- Different percentages of population that got covid
Select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
order by 1,2


-- Highest infection rate compared to population 

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
Group by location, population
order by PercentPopulationInfected desc

-- Countries with the Highest Death count per Population 

Select Location, MAX(cast(Total_cases as int)) as TotalDeathCount 
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
Where continent is not null
Group by location, population
order by TotalDeathCount desc

-- By Continent
Select continent, MAX(cast(Total_cases as int)) as TotalDeathCount 
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Where is Null
Select location, MAX(cast(Total_cases as int)) as TotalDeathCount 
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
Where continent is null
Group by location
order by TotalDeathCount desc

--Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
Where continent is not null
--Group by date
order by 1,2 

-- Total Population vs Vaccinations 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths dea
Join [Portfolio Project ]..[Covid Vaccinations ] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



--USE CTE

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths dea
Join [Portfolio Project ]..[Covid Vaccinations ] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3 
)
select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



--Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths dea
Join [Portfolio Project ]..[Covid Vaccinations ] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3 

select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating views to store data for later visualization 


Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths dea
Join [Portfolio Project ]..[Covid Vaccinations ] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3 


Create View GlobalNumbers as 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
Where continent is not null
--Group by date
--order by 1,2


Create View TotalPopulationvsVaccinations as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..CovidDeaths dea
Join [Portfolio Project ]..[Covid Vaccinations ] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Create View ByContinent as 
Select continent, MAX(cast(Total_cases as int)) as TotalDeathCount 
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
Where continent is not null
Group by continent
--order by TotalDeathCount desc


Create View TotalCasesvsTotalDeaths as
Select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project ]..CovidDeaths
-- where location like '%Europe%'
--order by 1,2

Select *
From PercentPopulationVaccinated 

