-- Dado o esquema de venda e produção há a necessidade de criar as tabelas no sistema de banco de dados. 

--tabela de clientes
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

--- TABELAS DE PRODUÇÃO

CREATE TABLE categories ( 
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255)
);

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

CREATE TABLE stocks (
    store_id INT, 
    product_id INT, 
    quantity INT,
    PRIMARY KEY (store_id, product_id), 
    FOREIGN KEY (store_id) REFERENCES stores(store_id), 
    FOREIGN KEY (product_id) REFERENCES products(product_id)

);

CREATE TABLE brands ( 
    brand_id INT PRIMARY KEY, 
    brand_name VARCHAR(255)
);
