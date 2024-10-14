DROP TABLE IF EXISTS dim_time;
CREATE TABLE dim_time (
	time_id INT,
	year INT,
	season ENUM('summer','autumn','winter','spring'),
	month INT,
	PRIMARY KEY(time_id)
);


DROP PROCEDURE IF EXISTS populate_date_dim;
DELIMITER $$

CREATE PROCEDURE populate_date_dim()
BEGIN
	DECLARE start_date DATE;
	DECLARE end_date DATE;

	SET start_date = '2022-06-01';
	SET end_date = '2030-06-30';


	WHILE start_date <= end_date DO
		INSERT INTO dim_time(
			time_id,
			year,
			season,
			month
		)
		VALUES (
			YEAR(start_date) * 100 + MONTH(start_date),
			YEAR(start_date),
			(case when month(start_date) in (12, 1, 2) then 'winter'
				when month(start_date) in (3, 4, 5) then 'spring'
				when month(start_date) in (6, 7, 8) then 'summer'
			      	when month(start_date) in (9, 10, 11) then 'autumn'
			 end) ,
			MONTH(start_date)
		);
	SET start_date = DATE_ADD(start_date, INTERVAL 1 MONTH);
	END WHILE;
END$$

DELIMITER ;

CALL populate_date_dim();
