select*
From Portfolioproject..coviddeaths
where continent is not null
ORDER BY  3,4

--SELECT*
--FROM Portfolioproject..covidvaccination
--ORDER BY 3,4
--SELECT data that we are going to be using 

Select location,date,total_cases,new_cases,total_deaths,population
From Portfolioproject..coviddeaths
order by 1,2

--looking total cases vs total deaths
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage 
From Portfolioproject..coviddeaths
where location like'%states'
order by 1,2

--looking total cases vs totalpopulation 
-- shows what percentage of people have contracted covid due to different variant 

Select location,date,population ,total_cases, (total_cases/population)*100 as Deathpercentage 
From Portfolioproject..coviddeaths
where location like'%states'
order by 1,2

--looking at countries with highest infection rate compared to population 

Select location,population ,max(total_cases)as highestinfectioncount,max((total_cases/population))*100 as percentagepopulationinfected  
From Portfolioproject..coviddeaths
--where location like'%states'
group by location,population
order by percentagepopulationinfected desc

--Showing countries with highest death count per population 
--using cast function to convert total deaths to int type

Select location,max(cast(total_deaths as int)) as Totaldeathcount  
From Portfolioproject..coviddeaths
--where location like'%states'
where continent is not null
group by location
order by Totaldeathcount desc

-- lets break things down by continent 

Select continent,max(cast(total_deaths as int)) as Totaldeathcount  
From Portfolioproject..coviddeaths
--where location like'%states'
where continent is  not  null
group by continent
order by Totaldeathcount desc

-- showing contient with highest death count per population 

Select continent,max(cast(total_deaths as int)) as Totaldeathcount  
From Portfolioproject..coviddeaths
--where location like'%states'
where continent is  not  null
group by continent
order by Totaldeathcount desc

--GLOBAL NUMBERS
Select  sum(new_cases)as total_cases,sum(cast(new_deaths as int))as total_deaths ,sum(cast(new_deaths as int))/sum(new_cases)* 100 as Deathpercentage 
From Portfolioproject..coviddeaths
---where location like'%states' and 
 where continent is not null
 --Group by date --groupby  statment is oftern used with aggregate function 
order by 1,2

--concept of join function 
--looking at Total population vs vaccination 
 --using convert function to change to int data type ,use partition comand to do rolling count 

select dea.continent,dea.location,dea.date,dea. population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated 
from Portfolioproject..coviddeaths dea
join  Portfolioproject..covidvaccination vac
      on dea.location=vac.location
	   and dea.date= vac.date
	   where dea.continent is not null
	   order by 2,3

-- use CTE
With popvsvac(continent,Location,Date,population,new_vaccinations,Rollingpeoplevaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea. population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated 
from Portfolioproject..coviddeaths dea
join  Portfolioproject..covidvaccination vac
      on dea.location=vac.location
	   and dea.date= vac.date
	   where dea.continent is not null
	  -- order by 2,3
	   )
	   select*, (Rollingpeoplevaccinated/population)*100
	   from popvsvac

	  --temp table
	 
