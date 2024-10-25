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
			(case when month(start_date) in (1, 2, 12) then 1
				when month(start_date) in (3, 4, 5) then 2
				when month(start_date) in (6, 7, 8) then 3
			      	when month(start_date) in (9, 10, 11) then 4
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

CALL populate_dim_time();

