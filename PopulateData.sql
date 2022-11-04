/*Written by Josh Kennerly and Justin Schulz*/

use Pizzeria;

INSERT INTO DISCOUNTS(DISCOUNT_ID, DISCOUNT_NAME, DISCOUNT_PERCENT, DISCOUNT_CASH) 
VALUES (1, 'Employee', 15, 0),
       (2, 'Lunch Special Medium', 0, 1.00),
       (3, 'Lunch Special Large', 0, 2.00),
       (4, 'Specialty Pizza', 0, 1.50),
       (5, 'Gameday Special', 20, 0);

INSERT INTO TOPPINGS(TOPPING_ID, TOPPING_NAME, TOPPING_PRICE, TOPPING_COST, TOPPING_INVENTORY, TOPPING_SMALL, TOPPING_MED, TOPPING_LARGE, TOPPING_XL)
VALUES (1, 'Pepperoni', 1.25, 0.2, 100, 2, 2.75, 3.5, 4.5),
       (2, 'Sausage', 1.25, 0.15, 100, 2.5, 3, 3.5, 4.25),
       (3, 'Ham', 1.5,  0.15, 78, 2, 2.5, 3.25, 4),
       (4, 'Chicken', 1.75, 0.50, 56, 1.5, 2, 2.25, 3),
       (5, 'Green Pepper', 0.5, 0.02, 79, 1, 1.5, 2, 2.5),
       (6, 'Onion', 0.5, 0.02, 85, 1, 1.5, 2, 2.75),
       (7, 'Roma Tomato', 0.75, 0.03, 86, 2, 3, 3.5, 4.5),
       (8, 'Mushrooms', 0.75, 0.1, 52, 1.5, 2, 2.5, 3),
       (9, 'Black Olives', 0.75, 0.1, 39, 0.75, 1, 1.5, 2),
       (10, 'Pineapple', 1, 0.25, 15, 1, 1.25, 1.75, 2),
       (11, 'Jalapenos', 0.5, 0.05, 64, 0.5, 0.75, 1.25, 1.75),
       (12, 'Banana Peppers', 0.5, 0.05, 36, 0.6, 1, 1.3, 1.75),
       (13, 'Regular Cheese', 1.5, 0.12, 250, 2, 3.5, 5, 7),
       (14, 'Four Cheese Blend', 2, 0.15, 150, 2, 3.5, 5, 7),
       (15, 'Feta Cheese', 2, 0.18, 75, 1.75, 3, 4, 5.5),
       (16, 'Goat Cheese', 2, 0.2, 54, 1.6, 2.75, 4, 5.5),
       (17, 'Bacon', 1.5, 0.25, 89, 1, 1.5, 2, 3);

INSERT INTO DISCOUNTS(PIZZA_CRUST, PIZZA_SIZE, PIZZA_COST, PIZZA_PRICE)
VALUES ('Small','Thin','3','0.5'),
	('Small','Original','3','0.75'),
	('Small','Pan','3.5','1'),
	('Small','Gluten-Free','4','2'),
	('Medium','Thin','5','1'),
	('Medium','Original','5','1.5'),
	('Medium','Pan','6','2.25'),
	('Medium','Gluten-Free','6.25','3'),		
       ('Large','Thin','8','1.25'),
	('Large','Original','8','2'),
	('Large','Pan','9','3'),
	('Large','Gluten-Free','9.5','4'),
	('XLarge','Thin','10','2'),
	('XLarge','Original','10','3'),
	('XLarge','Pan','11.5','4.5'),
	('XLarge','Gluten-Free','12.5','6');
