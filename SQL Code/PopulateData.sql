/*Written by Josh Kennerly and Justin Schulz*/

use Pizzeria;

DROP PROCEDURE IF EXISTS `ADD_CUSTOMER`;
DROP PROCEDURE IF EXISTS `ADD_PIZZA`;

DELIMITER //
CREATE PROCEDURE `ADD_CUSTOMER`(
	IN first_name VARCHAR(20),
   	IN last_name VARCHAR(20),
   	IN phone_number VARCHAR(20),
    	IN address VARCHAR(100)
)
BEGIN
	INSERT INTO CUSTOMER
	(CUSTOMER_FIRSTNAME, CustomerLastName, CustomerPhone, CustomerAddress)
	VALUES
		(first_name, last_name, phone_number, address);
END
//

CREATE PROCEDURE `ADD_PIZZA`(
	IN order_id INT,
	IN crust VARCHAR(20),
  	IN size VARCHAR(20)
)
BEGIN
	INSERT INTO pizza
		(CrustID, SizeID, OrderID, PizzaPrice, PizzaCost, PizzaDate, PizzaComplete)
		VALUES(
			crust,
			size,
			order_id,
			0,
			0,
			(SELECT CONVERT(OrderTime, DATE) as PizzaDate
			FROM customer_order
			WHERE OrderID = order_id),
			1);
END

//

INSERT INTO DISCOUNTS
	(DISCOUNT_ID, DISCOUNT_PERCENT, DISCOUNT_CASH) 
	VALUES 
		('Employee', 15, 0),
       		('Lunch Special Medium', 0, 1.00),
       		('Lunch Special Large', 0, 2.00),
       		('Specialty Pizza', 0, 1.50),
       		('Gameday Special', 20, 0);

INSERT INTO TOPPINGS
	(TOPPING_ID, TOPPING_PRICE, TOPPING_COST, TOPPING_INVENTORY, TOPPING_SMALL, TOPPING_MED, TOPPING_LARGE, TOPPING_XL)
	VALUES 
		('Pepperoni', 1.25, 0.2, 100, 2, 2.75, 3.5, 4.5),
       		('Sausage', 1.25, 0.15, 100, 2.5, 3, 3.5, 4.25),
       		('Ham', 1.5,  0.15, 78, 2, 2.5, 3.25, 4),
       		('Chicken', 1.75, 0.50, 56, 1.5, 2, 2.25, 3),
       		('Green Pepper', 0.5, 0.02, 79, 1, 1.5, 2, 2.5),
       		('Onion', 0.5, 0.02, 85, 1, 1.5, 2, 2.75),
       		('Roma Tomato', 0.75, 0.03, 86, 2, 3, 3.5, 4.5),
       		('Mushrooms', 0.75, 0.1, 52, 1.5, 2, 2.5, 3),
       		('Black Olives', 0.75, 0.1, 39, 0.75, 1, 1.5, 2),
       		('Pineapple', 1, 0.25, 15, 1, 1.25, 1.75, 2),
       		('Jalapenos', 0.5, 0.05, 64, 0.5, 0.75, 1.25, 1.75),
       		('Banana Peppers', 0.5, 0.05, 36, 0.6, 1, 1.3, 1.75),
       		('Regular Cheese', 1.5, 0.12, 250, 2, 3.5, 5, 7),
       		('Four Cheese Blend', 2, 0.15, 150, 2, 3.5, 5, 7),
       		('Feta Cheese', 2, 0.18, 75, 1.75, 3, 4, 5.5),
       		('Goat Cheese', 2, 0.2, 54, 1.6, 2.75, 4, 5.5),
       		('Bacon', 1.5, 0.25, 89, 1, 1.5, 2, 3);

INSERT INTO DISCOUNTS
	(PIZZA_CRUST, PIZZA_SIZE, PIZZA_COST, PIZZA_PRICE)
	VALUES 
		('Small','Thin','3','0.5'),
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


-- ORDER #1 --
        
INSERT INTO ORDERS
	(CUSTOMER_ID, ORDER_TYPE, ORDER_TIME, ORDER_PRICE, ORDER_COST, ORDER_COMPLETE, ORDER_TABLE_NUM)
    VALUES
	(null, 'DINE-IN', '2022-03-05 12:03:00', 0, 0, 1, 14);
        
CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Thin', 'Large');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 1),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Sausage', 0);
        
CALL UPDATE_TOPPINGS();

UPDATE ORDERS
    SET ORDER_PRICE = (
	SELECT SUM(PIZZA_PRICE)
    	FROM PIZZAS
    	WHERE ORDER_ID = (SELECT MAX(ORDER_ID) FROM PIZZAS)), 
    	ORDER_COST = (
    	SELECT SUM(PIZZA_COST)
    	FROM PIZZAS
    	WHERE ORDER_ID = (SELECT MAX(ORDER_ID) FROM PIZZAS))
    WHERE ORDER_ID = (SELECT MAX(ORDER_ID) FROM PIZZAS);
    
    
-- ORDER #2 --

INSERT INTO ORDERS
	(CUSTOMER_ID, ORDER_TYPE, ORDER_TIME, ORDER_PRICE, ORDER_COST, ORDER_COMPLETE, ORDER_TABLE_NUM)
    VALUES
	(null, 'DINE-IN', '2022-04-03 12:05:00', 0, 0, 1, 4);
        
CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Pan','Medium');     
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Feta Cheese', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Black Olives', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Roma Tomato', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Mushrooms', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Banana Peppers', 0);

INSERT INTO DISCOUNT_PIZZA
	(PIZZA_ID, DISCOUNT_ID)
	VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Lunch Special Medium'),
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Specialty Pizza');
    

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'Small');

INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Chicken', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Banana Peppers', 0);




-- ORDER #3 --

INSERT INTO ORDERS
	(CUSTOMER_ID, ORDER_TYPE, ORDER_TIME, ORDER_PRICE, ORDER_COST, ORDER_COMPLETE, ORDER_TABLE_NUM)
    VALUES
	(null, 'PICKUP', '2022-03-03 21:30:00', 0, 0, 1, null);
        
CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'Large');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 0);
        

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'Large');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 0),
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 0);
        

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'Large');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 0);
        
CALL UPDATE_TOPPINGS();

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'Large');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 0);
       
CALL UPDATE_TOPPINGS();

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'Large');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 0);
        
CALL UPDATE_TOPPINGS();

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'Large');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 0);
        
CALL UPDATE_TOPPINGS();

CALL ADD_CUSTOMER('Andrew', 'Wilkes-Krier', '864-254-5861', null);

CALL UPDATE_ORDEROUT('864-254-5861');

-- ORDER #4 --

INSERT INTO ORDERS
	(CUSTOMER_ID, ORDER_TYPE, ORDER_TIME, ORDER_PRICE, ORDER_COST, ORDER_COMPLETE, ORDER_TABLE_NUM)
    VALUES
	(null, 'DELIVERY', '2022-04-20 19:11:00', 0, 0, 1, null);

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'XLarge');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Four Cheese Blend', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 0), 
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Sausage', 0);
        
CALL UPDATE_TOPPINGS();

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'XLarge');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Four Cheese Blend', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Ham', 1), 
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pineapple', 1);
        
INSERT INTO DISCOUNT_PIZZA
	(PIZZA_ID, DISCOUNT_ID)
	VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Specialty Pizza');
        
CALL UPDATE_TOPPINGS();

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Original', 'XLarge');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Four Cheese Blend', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Jalapenos', 0), 
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Bacon', 0);

CALL UPDATE_TOPPINGS();

INSERT INTO DISCOUNT_ORDER
	(ORDER_ID, DISCOUNT_ID)
    VALUES
	((SELECT MAX(ORDER_ID) FROM ORDERS), 'Gameday Special');
    
CALL UPDATE_CUSTOMER_ADDRESS('864-254-5861', '115 Party Blvd, Anderson SC 29621');
    
CALL UPDATE_ORDEROUT('864-254-5861');

-- ORDER #5 --

INSERT INTO ORDERS
	(CUSTOMER_ID, ORDER_TYPE, ORDER_TIME, ORDER_PRICE, ORDER_COST, ORDER_COMPLETE, ORDER_TABLE_NUM)
    VALUES
	(null, 'PICKUP', '2022-03-02 17:30:00', 0, 0, 1, null);
        
CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Gluten-Free', 'XLarge');
        
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Goat Cheese', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Green Pepper', 0), 
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Onion', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Roma Tomato', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Mushrooms', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Black Olives', 0);
        
INSERT INTO DISCOUNT_PIZZA
	(PIZZA_ID, DISCOUNT_ID)
	VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Specialty Pizza');

CALL UPDATE_TOPPINGS();

CALL ADD_CUSTOMER('Matt', 'Engers', '864-474-9953', null);
        
CALL UPDATE_ORDEROUT('864-474-9953');

-- ORDER #6 --

INSERT INTO ORDERS
	(CUSTOMER_ID, ORDER_TYPE, ORDER_TIME, ORDER_PRICE, ORDER_COST, ORDER_COMPLETE, ORDER_TABLE_NUM)
    VALUES
	(null, 'DELIVERY', '2022-03-02 18:17:00', 0, 0, 1, null);
        
CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Thin', 'Large');
    
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Four Cheese Blend', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Green Pepper', 0), 
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Chicken', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Onion', 0),
        ((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Mushrooms', 0);
        
CALL UPDATE_TOPPINGS();

CALL ADD_CUSTOMER('Frank', 'Turner', '864-232-8944', '6745 Wessex St, Anderson SC 29621');

CALL UPDATE_ORDEROUT('864-232-8944');

-- ORDER #7 --

INSERT INTO ORDERS
	(CUSTOMER_ID, ORDER_TYPE, ORDER_TIME, ORDER_PRICE, ORDER_COST, ORDER_COMPLETE, ORDER_TABLE_NUM)
    VALUES
	(null, 'DELIVERY', '2022-04-13 20:32:00', 0, 0, 1, null);
        
CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Thin', 'Large');
    
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Four Cheese Blend', 1);
        
CALL UPDATE_TOPPINGS();

CALL ADD_PIZZA(
	(SELECT MAX(ORDER_ID) FROM ORDERS), 'Thin', 'Large');
    
INSERT INTO TOTAL_TOPS
	(PIZZA_ID, TOPPING_ID, TOPPING_EXTRA)
    VALUES
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Regular Cheese', 0),
	((SELECT MAX(PIZZA_ID) FROM PIZZAS), 'Pepperoni', 1);
        
CALL UPDATE_TOPPINGS();

CALL ADD_CUSTOMER('Milo', 'Auckerman', '864-878-5679', '879 Suburban Home, Anderson, SC 29621');

INSERT INTO DISCOUNT_ORDER
	(ORDER_ID, DISCOUNT_ID)
    VALUES
	((SELECT MAX(ORDER_ID) FROM ORDERS), 'Employee');

CALL UPDATE_ORDEROUT('864-878-5679');
