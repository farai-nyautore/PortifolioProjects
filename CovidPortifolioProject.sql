------Select Only The Data We are going to be using
Select [Location],[Date],total_cases,new_cases,total_deaths,population

from PortfolioProject..CovidDeaths
where continent is not null
Order by 1,2

----Total cases vs Total Deaths
Select [Location],[Date],total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage

from PortfolioProject..CovidDeaths
where location like '%Zim%' and continent is not null
Order by 1,2

---Total Case vs Population
Select [Location],[Date],total_cases,population,(total_cases/population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%Zim%' and continent is not null
Order by 1,2

---Countries with highest Infection Rate VS Population
Select [Location],population,max(total_cases)HighestInfectionCount,
max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%Zim%'
where continent is not null
Group by [Location],population
Order by PercentPopulationInfected desc


----Highest Death Count per Population

Select [Location],max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%Zim%'
where continent is not null
Group by [Location]
Order by TotalDeathCount desc


-----by continent

Select [location],max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%Zim%'
where continent is  null
Group by [location]
Order by TotalDeathCount desc
----------------------------------------------

Select [continent],max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%Zim%'
where continent is  not null
Group by [continent]
Order by TotalDeathCount desc


--------Showing the continents with highest death count per population

Select [continent],max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%Zim%'
where continent is  not null
Group by [continent]
Order by TotalDeathCount desc


------===Global

Select [Date],sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercentage

from PortfolioProject..CovidDeaths
--where location like '%Zim%' and 
where continent is not null
group by date
Order by 1,2


--------------------Population vs Vaccinations

Select d.continent,d.location,d.date,d.population,v.new_vaccinations,

SUM(cast(v.new_vaccinations as bigint)) over (Partition by d.location order by d.location,d.date) as RollingVaccinations


from PortfolioProject..CovidDeaths d

join PortfolioProject..CovidVaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
order by 2,3


-----CTE
With PopVsVac (Continent, Location, Date, Population, new_vaccinations,RollingVaccinations)
as
(

Select d.continent,d.location,d.date,d.population,v.new_vaccinations,

SUM(cast(v.new_vaccinations as bigint)) over (Partition by d.location order by d.location,d.date) as RollingVaccinations


from PortfolioProject..CovidDeaths d

join PortfolioProject..CovidVaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
--order by 2,3
) Select *, (RollingVaccinations/Population)*100


from PopVsVac order by 2,3

-----=====Sub QUERY

Select *, (RollingVaccinations/Population)*100 as PercVaccinated from (

Select d.continent,d.location,d.date,d.population,v.new_vaccinations,

SUM(cast(v.new_vaccinations as bigint)) over (Partition by d.location order by d.location,d.date) as RollingVaccinations


from PortfolioProject..CovidDeaths d

join PortfolioProject..CovidVaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null) a

Go
------Views
Create View PercentagePopulationVaccinated as
Select d.continent,d.location,d.date,d.population,v.new_vaccinations,

SUM(cast(v.new_vaccinations as bigint)) over (Partition by d.location order by d.location,d.date) as RollingVaccinations


from PortfolioProject..CovidDeaths d

join PortfolioProject..CovidVaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
--order by 2,3

Select * from PercentagePopulationVaccinated

