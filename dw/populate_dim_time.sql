START transaction;

DELETE FROM dim_time;

CALL populate_dim_time();

COMMIT;
