--- LISTAR TODOS OS CLIENTES QUE NAO REALIZARAM UMA COMPRA - CASO DE LEFT JOIN ---
SELECT c.customer_id, c.first_name, c.last_name, c.email 
FROM customer c
LEFT JOIN orders o  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


--- LISTAR TODOS OS PRODUTOS QUE NAO FORAM COMPRADOS - CASO DE LEFT JOIN ---

SELECT p.product_id, p.product_name, p.list_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id is NULL;


--- LISTAR OS PRODUTOS QUE NÃO TEM ESTOQUE - CASO DE JOIN ---

SELECT p.product_id, p.product_name, s.quantity
FROM products p
JOIN stocks s ON p.product_id = s.product_id
WHERE s.quantity == 0;


--- AGRUPAR A QUANTIDADE DE VENDA DE CADA MARCA POR LOJA - CASO DE JOIN EM VÁRIAS TABELAS--- 

SELECT 
    st.store_name, 
    b.brand_name, 
    COUNT(oi.order_id) AS total_sold
FROM 
    order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN stores st ON o.store_id = st.store_id
JOIN products p ON oi.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
GROUP BY
    st.store_id,
    b.brand_id
ORDER BY
    s.store_name,
    b.brand_name; 


--- LISTAR TODOS OS FUNCIONÁRIOS QUE NAO ESTEJAM LISTADOS EM UM PEDIDO - CASO DE LEFT JOIN --- 
SELECT s.staff_id, s.first_name, s.last_name, s.email
FROM staffs s
LEFT JOIN orders o ON s.staff_id = o.staff_id
WHERE o.order_id is NULL;