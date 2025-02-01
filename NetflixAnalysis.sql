CREATE TABLE IF NOT EXISTS netflix_titles (
show_id INT,
`type` VARCHAR(255),
title VARCHAR(255),
director VARCHAR(255),
cast VARCHAR(255),
country VARCHAR(255),
date_added datetime,
release_year datetime,
rating VARCHAR(255),
duration VARCHAR(255),
listed_in VARCHAR(255),
`description` VARCHAR(255)
);

SELECT *
FROM netflix_titles;

################################################################## DATA CLEANING ##################################################################################


## Create a staging table to use for analysis  ##

CREATE TABLE netflix_staging
LIKE netflix_titles;

INSERT netflix_staging
SELECT *
FROM netflix_titles;

SELECT *
FROM netflix_staging;

##  staging table created, the cleaning now begins ##

-- 1. Checking for duplicates and removing the duplicates if they are there

SELECT *,
ROW_NUMBER() OVER(PARTITION BY show_id, `type`, title, director, country, date_added, release_year, rating, duration) AS row_num
FROM netflix_staging;

WITH duplicates_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY 
show_id, `type`, title, director, country, date_added, release_year, rating) AS row_num
FROM netflix_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

## after checking, it is confirmed that this dataset does not contain any duplicates

-- 2. Standardize the data

SELECT *
FROM netflix_staging;

SELECT date_added,
	CASE 
		WHEN date_added LIKE '%-%-%' THEN
				STR_TO_DATE(date_added, '%d-%b-%y')
		ELSE 	STR_TO_DATE(date_added, '%M%d,%Y')
	END AS converted_date
FROM netflix_staging;



UPDATE netflix_staging
SET date_added = CASE 
					WHEN date_added LIKE '%-%-%' THEN
							STR_TO_DATE(date_added, '%d-%b-%y')
					ELSE 	STR_TO_DATE(date_added, '%M%d,%Y')
					END;
                    

ALTER TABLE netflix_staging
MODIFY COLUMN date_added DATE;

## changed the formatting of the date_added which was in 2 different formats and changed them to the standard format
## updated the changes on the table and altered the table from text to datetime data type



-- 3. Null or Blank values

SELECT *
FROM netflix_staging;



SELECT *
FROM netflix_staging
WHERE director IS NULL;


DELETE
FROM netflix_staging
WHERE director IS NULL;


## deleted all the nulls that existed in director and country because there is no way of populating them


-- 4. Remove any unnecessary data

SELECT *
FROM netflix_staging;

ALTER TABLE netflix_staging
DROP COLUMN cast;

ALTER TABLE netflix_staging
DROP COLUMN duration;

ALTER TABLE netflix_staging
DROP COLUMN listed_in;

ALTER TABLE netflix_staging
DROP COLUMN `description`;

## removed all the unnecessary columns that will not be used

###########################################################  THE DATA HAS BEEN CLEANED ##############################################################################

