
--Looking at Total cases vs Total deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as Deathpercentage
FROM PortfolioProject..CovidDeaths$
Where location like '%canada%'
order by 1,2


-- Looking at the Total cases vs Population
-- Shows what percentage of population got covid

SELECT Location, date, total_cases, population, (total_cases/population) * 100 as Deathpercentage
FROM PortfolioProject..CovidDeaths$
Where location like '%canada%'
order by 1,2


-- Looking at countries with Highest infection rate compared to population

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population)) * 100
as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
--Where location like '%canada%'
Group by Location, Population
order by PercentPopulationInfected desc

--BROKEN DOWN BY CONTINENT 
SELECT location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is null
Group by location
order by TotalDeathCount desc


-- Showing continents with the highest death counts per population 

SELECT continent, MAX(CAST(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
where continent is null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS
SELECT date, SUM(new_cases) as total_cases,  SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases) * 100 
as Deathpercentage
FROM PortfolioProject..CovidDeaths$
--Where location like '%canada%'
where continent is not null
Group by date
order by 1,2


--GLOBAL NUMBERS
SELECT date, SUM(new_cases) as total_cases,  SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases) * 100 
as Deathpercentage
FROM PortfolioProject..CovidDeaths$
--Where location like '%canada%'
where continent is not null
--Group by date
order by 1,2

-- Looking at the Total Population vs Vaccinations

with PopvsVac (continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) 
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--Order by 2,3
)

SELECT *, (RollingPeopleVaccinated/Population) * 100
FROM PopvsVac
	--USE CTE


	--TEMP TABLE
	Create Table #PercentPoulationVaccinated
	(
	Continent nvarchar(255),
	Location nvarchar (255),
	Date datetime,
	Population numeric,
	New_vacciantions numeric,
	RollingPeopleVaccinated numeric
	)
Insert into #PercentPoulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (partition by dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--Order by 2,3


SELECT *, (RollingPeopleVaccinated/Population) * 100
FROM #PercentPoulationVaccinated
	--USE CTE
	