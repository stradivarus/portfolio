# create and populate cat database

CREATE DATABASE cat_hotel;

USE cat_hotel;

CREATE TABLE cat (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50),
age DECIMAL(3, 1),
temperament VARCHAR(100),
diet INT DEFAULT 1,
owner INT NOT NULL,
FOREIGN KEY (diet) REFERENCES diet(id),
FOREIGN KEY (owner) REFERENCES owner(id) ON DELETE CASCADE
);

ALTER TABLE cat
ADD likes_cats BOOLEAN;

INSERT INTO cat
(name, age, temperament,  diet, owner, likes_cats)
VALUES
("Slinky", 2.5, "skittish but friendly", 1, 1, false),
("Captain Fever", 7, "aggressive unless bribed with treats", 6, 2, true),
("Crazy Jose", 1.5, "friendly and playful, loves watching tv", 4, 3, true),
("Fandy", 0.5, "anxious, scared of houseplants", 1, 3, false),
("Roberto Escobar", 5, "friendly and calm", 2, 4, true),
("Princess Ice", 12, "friendly, loves bellyrubs", 5, 2, true);

CREATE TABLE owner (
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
phone_number VARCHAR(20),
email VARCHAR(50)
);

INSERT INTO owner
(first_name, last_name, phone_number, email)
VALUES
("Jade", "Opal", "123-456-4466", "jade.opal@email.com"),
("Ruby", "Topaz", "324-234-1123", "ruby.topaz@email.com"),
("Emerald", "Stone", "789-234-1435", "emerald.stone@email.com"),
("Krissy", "Jade", "577-875-9579", "krissy.jade@email.com");

CREATE TABLE diet (
id INT AUTO_INCREMENT PRIMARY KEY,
description VARCHAR(80)
);

INSERT INTO diet
(description)
VALUES
("standard"),
("dairy-free"),
("gluten-free"),
("no beef"),
("no fish"),
("special");

CREATE TABLE grooming_package (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(30) NOT NULL,
description VARCHAR(80),
price DECIMAL(5,2)
);

INSERT INTO grooming_package
(name, description, price)
VALUES
("basic", "claw trimming, fur brushing", 10),
("standard", "claw trimming, shower", 30),
("premium", "claw trimming, shave", 60),
("deluxe", "full kitty spa day for your cats enjoyment", 100);

CREATE TABLE stay (
id INT AUTO_INCREMENT PRIMARY KEY,
cat INT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
grooming_package INT,
FOREIGN KEY (cat) REFERENCES cat(id) ON DELETE CASCADE,
FOREIGN KEY (grooming_package) REFERENCES grooming_package(id)
);

INSERT INTO stay
(cat, from_date, to_date, grooming_package)
VALUES
(4, '2023-06-01', '2023-06-10', 1),
(2, '2023-06-11', CURDATE(), NULL),
(1, '2023-06-09', '2023-06-21', NULL),
(3, '2023-06-10', '2023-06-14', 3),
(5, '2023-06-13', CURDATE(), 4),
(6, '2023-06-14', '2023-06-13', 1),
(4, '2023-06-12', CURDATE(), 2),
(3, '2023-06-15', CURDATE(), NULL);

truncate table stay;

CREATE TABLE payments (
id INT AUTO_INCREMENT PRIMARY KEY,
owner INT NOT NULL,
date_received DATE,
amount DECIMAL(10, 2),
FOREIGN KEY (owner) REFERENCES owner(id) ON DELETE CASCADE
);

INSERT INTO payments
(owner, date_received, amount)
VALUES
(1, '2023-05-01', 160.00),
(2, '2023-05-05', 250.00),
(3, '2023-05-06', 70.00),
(4, '2023-05-11', 185.00),
(3, '2023-05-14', 360.00),
(2, '2023-05-17', 700.00),
(1, '2023-05-22', 135.00),
(4, '2023-05-23', 245.00),
(2, '2023-05-24', 95.00),
(3, '2023-05-30', 195.00),
(1, '2023-06-03', 215.00),
(3, '2023-06-08', 455.00),
(2, '2023-06-08', 635.00),
(3, '2023-06-12', 140.00),
(1, '2023-06-13', 220.00),
(4, '2023-06-16', 150.00),
(2, '2023-06-18', 340.00);


