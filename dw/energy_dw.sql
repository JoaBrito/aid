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
	location_id INT,
	region VARCHAR(255),
	municipality VARCHAR(255),
	parish VARCHAR(255),
	PRIMARY KEY (location_id)
);


CREATE TABLE fact_contract(
	contract_id INT,
	location_id INT,
	time_id INT,
	energyconsumption DECIMAL(15,2),
	nosmartmeters INT,
	nocontracts INT,
	percentagesmartmeters DECIMAL(5,4),
	PRIMARY KEY(contract_id),
	FOREIGN KEY(location_id) REFERENCES dim_location (location_id),
	FOREIGN KEY(time_id) REFERENCES dim_time (time_id)
);
