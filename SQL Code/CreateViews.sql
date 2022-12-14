/*Written by Josh Kennerly and Justin Schulz*/
use Pizzeria;

DROP VIEW IF EXISTS ProfitByPizza;

CREATE VIEW ProfitByPizza AS
SELECT
    PROFIT.PIZZA_SIZE AS PIZZA_SIZE,
    PROFIT.PIZZA_CRUST AS PIZZA_CRUST,
    CAST(TYPE_PROFIT AS DECIMAL(6,2)) AS PROFIT,
    LAST_ORDER_DATE
FROM
    (SELECT 
	PIZZA_SIZE,
        PIZZA_CRUST,
	ROUND(SUM(PIZZA_PRICE-PIZZA_COST),2) AS TYPE_PROFIT,
        MAX(PIZZA_DATE) AS LAST_ORDER_DATE
	FROM PIZZAS
	WHERE PIZZA_DATE BETWEEN '2022-01-01' AND '2022-12-31'
	GROUP BY PIZZA_SIZE,PIZZA_CRUST
   	)AS PROFIT
GROUP BY PIZZA_SIZE,PIZZA_CRUST
ORDER BY TYPE_PROFIT DESC;

SELECT * FROM ProfitByPizza;




DROP VIEW IF EXISTS ToppingPopularity;

CREATE VIEW ToppingPopularity AS
SELECT
    TOPPINGS.TOPPING_ID,
    COUNT(TOTAL_TOPS.TOPPING_ID) AS TOPPING_COUNT
FROM TOPPINGS, TOTAL_TOPS
WHERE TOPPINGS.TOPPING_ID = TOTAL_TOPS.TOPPING_ID
GROUP BY TOTAL_TOPS.TOPPING_ID
ORDER BY TOPPING_COUNT DESC, TOPPINGS.TOPPING_ID ASC;

SELECT * FROM ToppingPopularity;  





DROP VIEW IF EXISTS ProfitByOrderType;

CREATE VIEW ProfitByOrderType AS
SELECT
    ORDER_TYPE AS CUSTOMER_TYPE,
    DATE_FORMAT(ORDER_TIME,'%Y-%M') AS ORDER_DATE,
    ROUND(SUM(ORDER_PRICE),2) as TOTAL_ORDER_PRICE,
    ROUND(Sum(ORDER_COST),2) as TOTAL_ORDER_COST,
    ROUND(Sum(ORDER_PRICE-ORDER_COST),2) as PROFIT
FROM
    ORDERS
GROUP BY 
    MONTH(ORDER_TIME),
    ORDER_TYPE
UNION ALL
SELECT
    NULL,
    'Grand Total',
    ROUND(SUM(ORDER_PRICE),2) as TOTAL_ORDER_PRICE,
    ROUND(Sum(ORDER_COST),2) as TOTAL_ORDER_COST,
    ROUND(Sum(ORDER_PRICE-ORDER_COST),2) as PROFIT
FROM
    ORDERS;  
    
SELECT * FROM ProfitByOrderType;
