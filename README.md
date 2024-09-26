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