

-- Write a user stored procedure that uses dynamic SQL to run all the checks that exist in the validation_check table
DROP PROCEDURE IF EXISTS validate;

DELIMITER $$

CREATE PROCEDURE `validate`(pSummaryId INT)
BEGIN 
 
	SELECT 1 INTO @record_start;
	SELECT COUNT(*) FROM validation_check INTO @record_end;

	WHILE(@record_start <= @record_end)

	DO

	SELECT 
		id,
		field_name,
		where_clause
	FROM validation_check
	WHERE id = @record_start
	INTO 
		@validation_check_id,
		@field_name,
		@where_clause;
		
	SET @sql:=CONCAT('INSERT INTO validation_detail (detail_id,validation_check_id,field_name,field_value) SELECT '
	,'id'
	,','''
	,@validation_check_id
	,''','''
	,@field_name
	,''','
	,@field_name
	,' FROM detail where '
	,@field_name
	,' '
	,@where_clause
	,' and summary_id = '
	,pSummaryId
	,';');

	PREPARE dynamic_statement FROM @sql;
	EXECUTE dynamic_statement;
	DEALLOCATE PREPARE dynamic_statement;
	
	SET @record_start = @record_start + 1;
		
	END WHILE;

	-- Write a query to report to the user that they should fix their warnings, or let them commit the file anyway (depending on business logic within the app)
	SELECT
		s.student_name,
		s.file_name,
		vc.validation_description,
		d.id AS record_id,
		vd.field_name,
		vd.field_value
	FROM validation_detail vd
	LEFT JOIN detail d
	ON vd.detail_id = d.id
	LEFT JOIN summary s
	ON d.summary_id = s.id
	LEFT JOIN validation_check vc
	ON vd.validation_check_id = vc.id
	WHERE s.id = pSummaryId;

END $$
DELIMITER ;

TRUNCATE TABLE validation_detail;

CALL validate(1);
CALL validate(2);

