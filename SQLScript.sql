-- Query for the total confirmed, death, and recovered cases.
	SELECT sum(confirmed) as total_confirmed, 
	sum(death) as total_deaths, 
	sum(recovered) as total_recoveries
	FROM covid_19_data

--Query for the total confirmed, deaths and recovered cases for the first quarter
--of each year of observation.
SELECT 
	EXTRACT(YEAR FROM observation_date) AS YEAR,
	sum(confirmed) as confirmed_cases_1st_quater, 
	sum(death) as deaths_1st_quater, 
	sum(recovered) as recoveries_1st_quater 
	FROM covid_19_data
	WHERE observation_date BETWEEN '2019-01-01'  AND '2019-03-30' OR  
	observation_date BETWEEN '2020-01-01'  AND '2020-03-30'
	GROUP BY YEAR
	
-- Query for summary of all the records for each country

	SELECT
	country_province,
	sum(confirmed) as total_confirmed, 
	sum(death) as total_deaths, 
	sum(recovered) as total_recoveries
	FROM covid_19_data
	Group By country_province;
	
-- Query the percentage increase in the number of death cases from 2019 to
-- 2020.

	SELECT 
	((SELECT SUM(death) 
	  FROM covid_19_data 
	  where observation_date 
	  between '2020-01-01' 
	  and '2020-12-31') / 
	 (SELECT SUM(death) 
	  FROM covid_19_data))*100 AS percentage_death_increase_2019_2020;
	  
-- Query information for the top 5 countries with the highest confirmed cases.

	SELECT sum(confirmed) as total_confirmed,
	country_province
	FROM covid_19_data
	group by country_province
	order by total_confirmed desc
	limit 5
	
-- Query for the total number of drop (decrease) or increase in the confirmed
-- cases from month to month in the 2 years of observation.

	WITH monthly_cases_2019 AS (
		SELECT EXTRACT(YEAR FROM observation_date) AS year_2019,
			   EXTRACT(MONTH FROM observation_date) AS month_in_2019,
			   sum(confirmed) as total_per_month_2019 
		FROM covid_19_data
		WHERE EXTRACT(YEAR FROM observation_date)= 2019
		GROUP BY month_in_2019, year_2019),
	monthly_cases_2020 AS (
		SELECT EXTRACT(YEAR FROM observation_date) AS year_2020,
			   EXTRACT(MONTH FROM observation_date) AS month_in_2020,
			   sum(confirmed) as total_per_month_2020 
		FROM covid_19_data
		WHERE EXTRACT(YEAR FROM observation_date)= 2020
		GROUP BY month_in_2020, year_2020
	)
	SELECT
		m2019.month_in_2019 as month,
		m2019.total_per_month_2019 as confirmed_per_month_2019,
		m2020.total_per_month_2020 as confirmed_per_month_2020,
		m2019.total_per_month_2019 - m2020.total_per_month_2020 AS difference
	FROM
		monthly_cases_2019 m2019
		INNER JOIN monthly_cases_2020 m2020 ON m2019.month_in_2019 = m2020.month_in_2020
	ORDER BY
		m2019.year_2019, m2019.month_in_2019;