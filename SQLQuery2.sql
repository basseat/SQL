select *
From portfolioproject..covidDeath
where continent is not null
order by 3,4



--select *
--from portfolioproject..['covid vaccination$']
--order by 3,4

--select data 
select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..covidDeath
where continent is not null
order by 1,2



--looking at total cases vs total deaths 
--show death percentage
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from portfolioproject..covidDeath
where location like '%nigeria%'
order by 1,2



--loking at total cases vs population
select location, date, total_cases, population, (total_cases/population)*100 as case_percentage
from portfolioproject..covidDeath
--where location like '%nigeria%'
where continent is not null
order by 1,2


--looking at countries with highest case percentages
select location, max(total_cases) as max_cases, population, max(total_cases/population)*100 as highest_case_percentage
from portfolioproject..covidDeath
--where location like '%nigeria%'
where continent is not null
group by location, population
order by 4 desc


--looking at countries with highest death percentages
select location, max(cast(total_deaths as int)) as max_death
from portfolioproject..covidDeath
--where location like '%nigeria%'
where continent is not null
group by location
order by max_death desc



select location, max(cast(total_deaths as int)) as max_death
from portfolioproject..covidDeath
--where location like '%nigeria%'
where continent is null
group by location
order by max_death desc


select continent, max(cast(total_deaths as int)) as max_death
from portfolioproject..covidDeath
--where location like '%nigeria%'
where continent is not null
group by continent
order by max_death desc



--global numbers

select date, sum(cast(new_cases as int)) as daily_total, sum(cast(total_cases as int)) as total, sum(cast(new_deaths as int)) as daily_total_death, sum(cast(total_deaths as int)) as death_total
from portfolioproject..covidDeath
where continent is not null
group by date
order by 1



select date, sum(cast(new_cases as int)) as daily_total, sum(cast(new_deaths as int)) as daily_total_death, (sum(cast(new_deaths as float))/sum(new_cases ))*100 as death_perentage
from portfolioproject..covidDeath
where continent is not null
group by date
order by 1


select sum(cast(new_cases as int)) as daily_total, sum(cast(new_deaths as int)) as daily_total_death, (sum(cast(new_deaths as float))/sum(new_cases ))*100 as death_perentage
from portfolioproject..covidDeath
where continent is not null
--group by date
order by 1


--vaccinations by country
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
from portfolioproject..covidDeath as dea
join portfolioproject..covidVaccination as vac
on  dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3


select distinct new_vaccinations
from portfolioproject..covidVaccination





--using CTE
with PopvsVac(continent, location, date, population, new_vaccinations, vaccinations_by_country)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as vaccination_by_country
from portfolioproject..covidDeath as dea
join portfolioproject..covidVaccination as vac
on  dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select *, (vaccinations_by_country/population)*100
from PopvsVac
where location like '%Nigeria%'


create table percentpopulaionvaccinated(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
vaccinations_by_country numeric)

insert into percentpopulaionvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as vaccination_by_country
from portfolioproject..covidDeath as dea
join portfolioproject..covidVaccination as vac
on  dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3



select *, (vaccinations_by_country/population)*100
from percentpopulaionvaccinated
where location like '%Nigeria%'



create view percentpopulation_vacinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as vaccination_by_country
from portfolioproject..covidDeath as dea
join portfolioproject..covidVaccination as vac
on  dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3