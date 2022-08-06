--7.
SELECT
	C.CARTON_ID AS Carton_ID, 
	(C.LEN*C.WIDTH*C.HEIGHT) as Carton_Volume
FROM ORDERS.CARTON C
WHERE 
	(C.LEN*C.WIDTH*C.HEIGHT) >= (
		-- Subquery to take volume details from both Order_items and Product tables.
		SELECT 
			SUM(P.LEN*P.WIDTH*P.HEIGHT*OI.PRODUCT_QUANTITY) AS VOL -- Optimum carton value
		FROM ORDERS.ORDER_ITEMS OI
		INNER JOIN ORDERS.PRODUCT P 
			ON OI.PRODUCT_ID = P.PRODUCT_ID -- Join to get the LEN, WIDTH and HEIGHT
		WHERE
			OI.ORDER_ID = 10006 --Filtered the only Order ID 10006
		ORDER BY 
			(C.LEN*C.WIDTH*C.HEIGHT) ASC
	)
LIMIT 1;
-- Order by descending will arrange the outcome in decreasing order of Product of Len*Wodth*Height, and Limit 1 will display only 1 record

--8.
SELECT
	OC.CUSTOMER_ID AS Customer_ID,
	CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME) AS Customer_FullName,
	OH.ORDER_ID AS Order_ID,
	SUM(OI.PRODUCT_QUANTITY) AS Total_Order_Quantity
FROM ONLINE_CUSTOMER OC
INNER JOIN ORDER_HEADER OH
	ON OH.CUSTOMER_ID = OC.CUSTOMER_ID -- To connect the Order and Customer details.
INNER JOIN ORDER_ITEMS OI
	ON OI.ORDER_ID = OH.ORDER_ID -- To fetch the Product Quantity.
WHERE
	OH.ORDER_STATUS = 'Shipped' -- To check for order_status whether it is shipped.
GROUP BY
	OH.ORDER_ID
HAVING
	Total_Order_Quantity > 10 -- To check the Total Order Quality is greater than 10.
ORDER BY
	CUSTOMER_ID;

--9.
SELECT
	OC.CUSTOMER_ID AS Customer_ID,
	CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME) AS Customer_FullName,
	OH.ORDER_ID AS Order_ID,
	SUM(OI.PRODUCT_QUANTITY) AS Total_Order_Quantity
FROM ONLINE_CUSTOMER OC
INNER JOIN ORDER_HEADER OH
	ON OH.CUSTOMER_ID = OC.CUSTOMER_ID -- To connect the Order and Customer details.
INNER JOIN ORDER_ITEMS OI
	ON OI.ORDER_ID = OH.ORDER_ID -- To fetch the Product Quantity
WHERE
	OH.ORDER_STATUS = 'Shipped' 
	AND OH.ORDER_ID > 10060 -- To check for order_status whether it is shipped
GROUP BY
	OH.ORDER_ID
ORDER BY
	Customer_FullName;

--10.
SELECT
	PC.PRODUCT_CLASS_CODE AS Product_Class_Code,
	PC.PRODUCT_CLASS_DESC AS Product_Class_Description,
	SUM(OI.PRODUCT_QUANTITY) AS Total_Quantity,
	SUM(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) AS Total_Value
FROM ORDER_ITEMS OI
INNER JOIN ORDER_HEADER OH
	ON OH.ORDER_ID = OI.ORDER_ID -- Join to connect Online Customer
INNER JOIN ONLINE_CUSTOMER OC
	ON OC.CUSTOMER_ID = OH.CUSTOMER_ID
INNER JOIN PRODUCT P
	ON P.PRODUCT_ID = OI.PRODUCT_ID
INNER JOIN PRODUCT_CLASS PC
	ON PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
INNER JOIN ADDRESS A
	ON A.ADDRESS_ID = OC.ADDRESS_ID -- To retrive the country details.
WHERE
	OH.ORDER_STATUS ='Shipped'
	AND A.COUNTRY NOT IN('India','USA') --Order status as Shipped & country without India and USA.
GROUP BY
	PC.PRODUCT_CLASS_CODE,
	PC.PRODUCT_CLASS_DESC
ORDER BY 
	Total_Quantity DESC -- Order by Total_Quality
LIMIT 1;