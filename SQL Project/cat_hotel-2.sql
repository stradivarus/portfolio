USE cat_hotel;

SELECT * FROM cat;
SELECT * FROM diet;
SELECT * FROM grooming_package;
SELECT * FROM owner;
SELECT * FROM payments;
SELECT * FROM stay;


# A view that
# displays all cat information that is needed to care for them
CREATE VIEW cat_info
AS
SELECT c.name AS "Name", c.age AS "Age", c.temperament AS "Temperament", CASE WHEN c.likes_cats = 1 THEN 'Yes' ELSE 'No' END AS "Likes other cats?", d.description AS "Diet",
w.first_name AS "Owner's first name", w.last_name AS "Owner's last name", w.phone_number AS "Owner's phone number"
FROM cat c
LEFT JOIN diet d
ON c.diet = d.id
LEFT JOIN owner w
ON c.owner = w.id;

SELECT * FROM cat_info
WHERE name = "Roberto Escobar";


# A function that
# takes cat name and owner's last name and date of end of stay
# returns total cost of the cat's stay 
DELIMITER //
CREATE FUNCTION cost_of_stay(last_name VARCHAR(50), cat_name VARCHAR(50), to_date DATE)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
	DECLARE length_of_stay INT;
    DECLARE cost DECIMAL(10, 2);
    DECLARE grooming_price DECIMAL(5,2);
    
    SET @price_per_day = 45.00;
    
    SET @stay_id = (
        SELECT s.id
        FROM stay s
        INNER JOIN cat c
        ON s.cat = c.id
        INNER JOIN owner w
        ON c.owner = w.id
        WHERE c.name = cat_name
        AND w.last_name = last_name
        AND s.to_date = to_date
	);
    
	SET length_of_stay = DATEDIFF(to_date, (
        SELECT s.from_date
        FROM stay s
        WHERE s.id = @stay_id)
	);
    
    SET grooming_price = (
		SELECT g.price
        FROM grooming_package g
        RIGHT JOIN stay s
        ON g.id = s.grooming_package
        WHERE s.id = @stay_id
	);
    
    IF (ISNULL(grooming_price)) THEN
		SET grooming_price = 0.00;
	END IF;
        
    SET cost = length_of_stay * @price_per_day + grooming_price;
        
	RETURN (cost);
END //
DELIMITER ;

SELECT cost_of_stay("Jade", "Roberto Escobar", CURDATE());


# A procedure that 
# lists all cats leaving on the given day and what is owed, and owner names
DELIMITER //
CREATE PROCEDURE leaving_on(to_date date)
BEGIN
	SELECT GROUP_CONCAT(c.name SEPARATOR ', ') AS "Cat name",
	w.first_name AS "Owner first name",
	w.last_name AS "Owner last name",
	sum(cost_of_stay(w.last_name, c.name, to_date)) AS "Total cost"
	FROM cat c
	LEFT JOIN owner w
	ON c.owner = w.id
	LEFT JOIN stay s
	ON s.cat = c.id
	WHERE s.to_date = to_date
    GROUP BY w.id
    ORDER BY w.last_name, w.first_name;
END //
DELIMITER ;

CALL leaving_on(CURDATE());


# Example query with a subquery
# to view all payments by a particular owner
SELECT
date_received, amount
FROM payments
WHERE owner = (
	SELECT id FROM owner WHERE first_name = "Krissy" AND last_name = "Jade"
);


# A trigger that
# after client deletion
# adds them to a blacklist
CREATE TABLE blacklist (
    first_name VARCHAR(50),
    last_name VARCHAR(50));

DELIMITER //
CREATE TRIGGER before_owner_delete
BEFORE DELETE
ON owner FOR EACH ROW
BEGIN
    INSERT INTO blacklist
    VALUES
    (OLD.first_name, OLD.last_name);
END //
DELIMITER ;

SELECT * FROM blacklist;

INSERT INTO owner
(first_name, last_name, phone_number, email)
VALUES
("Joe", "Shmoe", "666-535-2455", "joe@alljoes.com");

DELETE FROM owner
WHERE first_name = "Joe" and last_name = "Shmoe";


# An event that
# updates cat's ages each year
CREATE EVENT increase_cat_age
ON SCHEDULE EVERY 1 YEAR
STARTS '2024-01-01 00:00:00'
DO 
	UPDATE cat
    SET age = age + 1;
    
SHOW EVENTS FROM cat_hotel;
