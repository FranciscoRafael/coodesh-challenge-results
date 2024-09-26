# Documentação do projeto sobre SQL  e banco de dados. 

## Introdução

Este projeto tem por objetivo analisar e gerenciar as operações de vendas e estoque de um sistema de uma empresa. O esquema de banco de dados abrange áreas criticas como dados de clientes, pedidos, produtos, funcionários e lojas, com o intuito de gerenciar e facilitar a gestão integrada. 

A primeira parte então, consiste na criação das tabelas para o sistema. Onde há uma ligação entre elas, para que possam se comunicar e facilitar o acesso de diversas formas possíveis. 

### Criação das tabelas
Cada tabela foi projetada com chaves primárias e estrangeira de acordo com a estrutura passada. 

#### Tabela de Clientes: 

```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY, 
    first_name VARCHAR(255), 
    last_name VARCHAR(255), 
    phone VARCHAR(255),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(255)
);
```
**Decisões**:  
- customer_id é uma chave primária - identificador único para cada cliente. 

#### Tabela de Funcionários

```sql
CREATE TABLE staffs (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(255),
    active VARCHAR(255),
    store_id INT, 
    manager_id INT,
    FOREIGN KEY (store_id)  REFERENCES stores(store_id)
);
```

**Decisões:**
- staff_id é a chave primária - identificador único de cada staff
- store_id é uma chave estrageira que referencia a tabela de stores (cada funcionário trabalha em uma loja específica). 

#### Tabela de Lojas 

```sql
CREATE TABLE stores (
    store_id INT PRIMARY KEY, 
    store_name VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(255)
); 
```

**Decisões:**
- store_id é a chave primária - identificador único para cada loja. 

#### Tabela de Pedidos 

```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT, 
    store_id INT, 
    staff_id INT,
    order_status VARCHAR(255),
    order_date DATE,
    required_date DATE,
    shipped_date DATE, 
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)

);
```

**Decisões:** 
- order_id é a chave primária - identificador único de cada pedido. 
- customer_id, store_id e staff_id são chaves estrangerias que garante que cada pedido esteja relacionado a uma loja, a um cliente e ao funcionário que fez o pedido. 

#### Tabela de Itens de Pedido

```sql
CREATE TABLE order_items (
    order_id INT, 
    item_id INT, 
    product_id INT, 
    quantity INT, 
    list_price DECIMAL (10, 2),
    discount DECIMAL (10, 2), 
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id), 
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

**Decisões:** 
- É uma chave primária composta por order_id e item_id, já que um pedido pode conter vários items e cada item em um pedido tem um identificador exclusivo. 
- product_id é uma chave estrageira que referencia a tabela products para garantir que cada item do pedido seja um produto válido


#### Tabela de Produtos

```sql
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    brand_id INT, 
    category_id INT, 
    model_year INT, 
    list_price DECIMAL (10, 2),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
```

**Decisões:** 
 - product_id é a chave primeira - identificador único de cada produto
 - brand_id e category_id são chaves estrangeiras para vincular cada produto a uma categoria e uma loja 


 #### Tabela de Estoque

 ```sql
 CREATE TABLE stocks (
    store_id INT, 
    product_id INT, 
    quantity INT,
    PRIMARY KEY (store_id, product_id), 
    FOREIGN KEY (store_id) REFERENCES stores(store_id), 
    FOREIGN KEY (product_id) REFERENCES products(product_id)

);
```

**Decisões:** 
- Chave primeira composta por store_id e product_id para referenciar no estoque cada produto e cada loja. 
- As chaves estrangeiras store_id e product_id garentem a relação do estoque com cada loja. 


#### Tabela de Marcas

```sql
CREATE TABLE brands ( 
    brand_id INT PRIMARY KEY, 
    brand_name VARCHAR(255)
);
```

**Decisões:** 
- brand_id como chave primária para idenficiar unicamente cada loja. 

#### Tabela de Categorias: 

```sql
CREATE TABLE categories ( 
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255)
);
```

**Decisões:** 

- caterogy_id - chave primária para garantir cada categoria com identificador único


## Descrição das Queries Pedidas

#### Listar clientes que não realizaram compras. 

**Objetivo:** Identificar cliedntes que estão registrados no sistema mas não realizaram nenhuma compra


```sql
--- LISTAR TODOS OS CLIENTES QUE NAO REALIZARAM UMA COMPRA - CASO DE LEFT JOIN ---
SELECT c.customer_id, c.first_name, c.last_name, c.email 
FROM customer c
LEFT JOIN orders o  ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

**Explicação:** Esta query usa um LEFT JOIN para conectar a tabela customers com orders e seleciona os clientes para os quais não existem registros de compra - na tabela de orders. 


#### Listar Produtos que não foram Comprados

```sql
--- LISTAR TODOS OS PRODUTOS QUE NAO FORAM COMPRADOS - CASO DE LEFT JOIN ---
SELECT p.product_id, p.product_name, p.list_price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id is NULL;
```


**Explicação:** Esta query verifica a existência de produtos na tabela de order_items, utilizando LEFT JOIN para conectar a taela de order_items e products, afim de garantir quais produtos estariam em order_items. 


#### Listar produtos sem Estoque

```sql
--- LISTAR OS PRODUTOS QUE NÃO TEM ESTOQUE - CASO DE JOIN ---
SELECT p.product_id, p.product_name, s.quantity
FROM products p
JOIN stocks s ON p.product_id = s.product_id
WHERE s.quantity == 0;
```
**Explicação:** Essa consulta junta as tabelas products e stocks para encontrar produtos cuja a quantidade em estoque é zero. 

#### Agrupar Vendas por Marca em Cada Loja
```sql
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
```

**Explicação:** Essa query conta quantas vezes os produtos de cada marca foram vendidos em cada loja. 
As tabelas envolvidas são: 
- products - Contém informações sobre os produtos, incluindo a marca de cada um. 
- brands - Contém o nome de cada marca. 
- ordem_item - Contém informações sobre os itens vendidos em cada pedido
- orders - Contém informações sobre os pedidos, incluindo a loja onde foram feitos. 
- stores - Contém as informações sobre cada loja. 
Usou-se JOIN para conectar as tabelas de modo que possa correlacionar os itens vendidos com suas respectivas marcas e lojas. O GROUP BY será usado para agrupar os resultados pela loja e pela marca. 

#### Listar os Funcionarios que não estejam relacionados a um Pedido

```sql
--- AGRUPAR A QUANTIDADE DE VENDA DE CADA MARCA POR LOJA - CASO DE JOIN EM VÁRIAS TABELAS--- 
SELECT s.staff_id, s.first_name, s.last_name, s.email
FROM staffs s
LEFT JOIN orders o ON s.staff_id = o.staff_id
WHERE o.order_id is NULL;
```

**Explicação:** Utiliza um LEFT JOIN para combinar a tabela de funcionários e de pedidos (staffs e orders) baseada no staff_id, ou seja, identificando pelo funcionário. O LEFT JOIN garante que os registros da tabela de funcionários sejam incluidos no resultado, mesmo que não haja um registro correspondende na tabela de pedidos. Em seguida, o WHERE, filtra os resultados onde order_id é NULL, ou seja, não há vendas associadas ao funcionário staff_id. 

### Execução. 

Para executar estas queries: 
- Ter um sisteam de gerenciamento de banco de dados compatível com SQL, como MySQL, PostgreSQL, etc. 
- Importar o database_schema.sql para criar as tabelas. 
- Executar as queries acima no seu sistema de gerenciamento ou via script, como Python.

