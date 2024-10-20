DROP DATABASE IF EXISTS energy_dw;

CREATE DATABASE energy_dw;

USE energy_dw;

CREATE TABLE dim_time (
	time_id INT,
	year INT,
	season_id INT,
	season VARCHAR(255),
	month VARCHAR(255),
	month_id INT,
	PRIMARY KEY(time_id)
);


CREATE TABLE dim_location(
	location_id VARCHAR(255),
	region VARCHAR(255),
	municipality VARCHAR(255),
	parish VARCHAR(255),
	PRIMARY KEY (location_id)
);


CREATE TABLE fact_contract(
	contract_id INT,
	location_id VARCHAR(255),
	time_id INT,
	energyconsumption DECIMAL(15,2),
	percentagesmartmeters DECIMAL(5,4),
	PRIMARY KEY(contract_id),
	FOREIGN KEY(location_id) REFERENCES dim_location (location_id),
	FOREIGN KEY(time_id) REFERENCES dim_time (time_id)
);

DROP PROCEDURE IF EXISTS populate_dim_time;
DELIMITER $$

CREATE PROCEDURE populate_dim_time()
BEGIN
	DECLARE start_date DATE;
	DECLARE end_date DATE;

	SET start_date = '2022-01-01';
	SET end_date = '2025-12-31';


	WHILE start_date <= end_date DO
		INSERT INTO dim_time(
			time_id,
			year,
			season_id,
			season,
			month_id,
			month
		)
		VALUES (
			YEAR(start_date) * 100 + MONTH(start_date),
			YEAR(start_date),
			(case when month(start_date) in (1, 2) then 1
				when month(start_date) in (3, 4, 5) then 2
				when month(start_date) in (6, 7, 8) then 3
			      	when month(start_date) in (9, 10, 11) then 4
				when month(start_date) in (12) then 5
			 end) ,
			(case when month(start_date) in (12, 1, 2) then 'winter'
				when month(start_date) in (3, 4, 5) then 'spring'
				when month(start_date) in (6, 7, 8) then 'summer'
			      	when month(start_date) in (9, 10, 11) then 'autumn'
			 end) ,
			MONTH(start_date),
			MONTHNAME(start_date)
		);
	SET start_date = DATE_ADD(start_date, INTERVAL 1 MONTH);
	END WHILE;
END$$

DELIMITER ;

