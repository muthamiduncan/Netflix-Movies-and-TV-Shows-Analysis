SELECT *
FROM netflix_staging;

#####################################################  EXPLORATORY DATA ANALYSIS   ###############################################################################

-- the date range of when the movies were added on Netflix

SELECT MIN(date_added), MAX(date_added)
FROM netflix_staging;


SELECT director, COUNT(title) AS movies_directed
FROM netflix_staging
GROUP BY director
ORDER BY 2 DESC;

SELECT country, COUNT(title) AS movies_per_country
FROM netflix_staging
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date_added), COUNT(title) AS movies_per_year
FROM netflix_staging
GROUP BY YEAR(date_added)
ORDER BY 2 DESC;

SELECT rating, COUNT(title) AS movies_per_rating
FROM netflix_staging
GROUP BY rating
ORDER BY 2 DESC;

SELECT *
FROM netflix_staging;


WITH rolling_cte AS
(
SELECT SUBSTRING(date_added, 1, 7) AS `MONTH`, COUNT(title) AS monthly_addition
FROM netflix_staging
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, monthly_addition,
SUM(monthly_addition) OVER (ORDER BY `MONTH`) AS rolling_total
FROM rolling_cte;









