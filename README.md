# Tech_Haven
A database made for a little company called Tech Haven.

## Made By Cristopher Buitrago (Database: **Tech Haven**)

### Consultas

#### 1. Obtener la lista de todos los productos con sus precios

```sql
SELECT p.name, p.price
FROM product p;
```

#### 2. Encontrar todos los pedidos realizados por un usuario específico, por ejemplo, Juan Perez

```sql
SELECT o.id, o.orderDate AS Date, o.total
FROM orders o
JOIN user u
ON u.id = o.userId
WHERE o.userId = 1;
```

#### 3. Listar los detalles de todos los pedidos, incluyendo el nombre del producto, cantidad y precio unitario

```sql
SELECT od.orderId AS Order_ID, p.name AS Product, od.quantity, od.unitPrice AS Unit_Price
FROM order_detail od
JOIN product p
ON p.id = od.productId;
```

#### 4. Calcular el total gastado por cada usuario en todos sus pedidos

```sql
SELECT CONCAT(u.name,' ',u.lastName) AS User, SUM(o.total) AS Total_Spent
FROM orders o
JOIN user u
ON u.id = o.userId
GROUP BY User;
```

#### 5. Encontrar los productos más caros (precio mayor a $500)

```sql
SELECT p.name AS Product, p.price AS Price
FROM product p
WHERE p.price > 500;
```

#### 6. Listar los pedidos realizados en una fecha específica, por ejemplo, 2024-03-10

```sql
SELECT o.id, o.userId AS User_ID, o.orderDate AS Date, o.total
FROM orders o
WHERE o.orderDate = '2024-03-10';
```

#### 7. Obtener el número total de pedidos realizados por cada usuario

```sql
SELECT CONCAT(u.name,' ',u.lastName) AS User, COUNT(o.id) AS Total_Orders
FROM orders o
JOIN user u
ON u.id = o.userId
GROUP BY User;
```

#### 8. Encontrar el nombre del producto más vendido (mayor cantidad total vendida)

```sql
SELECT p.name AS product, SUM(od.quantity) AS quantity
FROM order_detail od
JOIN product p
ON p.id = od.productId
GROUP BY p.name
ORDER BY quantity DESC
LIMIT 1;
```

#### 9. Listar todos los usuarios que han realizado al menos un pedido

```sql
SELECT CONCAT(u.name,' ',u.lastName) AS User, u.email
FROM orders o
JOIN user u
ON u.id = o.userId
WHERE o.userId IS NOT NULL;
```

#### 10. Obtener los detalles de un pedido específico, incluyendo los productos y cantidades, por ejemplo, pedido con id 1

```sql
SELECT od.orderId AS Order_ID, CONCAT(u.name,' ',u.lastName) AS User, p.name AS
       product, od.quantity, od.unitPrice
FROM order_detail od
JOIN orders o
ON o.id = od.orderId
JOIN user u
ON u.id = o.userId
JOIN product p
ON p.id = od.productId
WHERE od.orderId = 1;
```

### Subconsultas

#### 1. Encontrar el nombre del usuario que ha gastado más en total

```sql
SELECT CONCAT(u.name,' ',u.lastName) AS User
FROM orders o
JOIN user u
ON u.id = o.userId
WHERE o.total = (
    SELECT MAX(o2.total)
    FROM orders o2
);
```

#### 2. Listar los productos que han sido pedidos al menos una vez

```sql
SELECT p.name AS Product
FROM order_detail od
JOIN product p
ON p.id = od.productId
WHERE od.productId IN (
    SELECT od2.productId
    FROM order_detail od2
    GROUP BY od2.productId
    HAVING COUNT(od2.productId) > 0
);
```

#### 3. Obtener los detalles del pedido con el total más alto

```sql
SELECT o.id, o.userId, o.orderDate, o.total
FROM orders o
WHERE o.total = (
    SELECT MAX(o2.total)
    FROM orders o2
);
```

#### 4. Listar los usuarios que han realizado más de un pedido

```sql
SELECT u.name AS User_Name
FROM orders o
JOIN user u
ON u.id = o.userId
WHERE u.id IN (
        SELECT o2.userId
        FROM orders o2
        GROUP BY o2.userId
        HAVING COUNT(o2.userId) > 1
    );
);
```

#### 5. Encontrar el producto más caro que ha sido pedido al menos una vez

```sql
SELECT p.name AS Product, p.price
FROM order_detail od
JOIN product p
ON p.id = od.productId
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM product p2
    WHERE p2.id IN (
            SELECT od2.productId
            FROM order_detail od2
        )   
);
```

### Procedimientos almacenados

#### 1. Crea un procedimiento almacenado llamado AgregarProducto que reciba como parámetros el nombre, descripción y precio de un nuevo producto y lo inserte en la tabla Productos.

```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS AgregarProducto $$

CREATE PROCEDURE AgregarProducto(
    IN nombre VARCHAR(100),
    IN descripcion TEXT,
    IN precio DECIMAL(10,2)
)
BEGIN 
    INSERT INTO product (name, description, price)
    VALUES (nombre, descripcion, precio);
END $$

DELIMITER ;

-- Example of usage
CALL AgregarProducto('New Product', 'This is a new product', 100.00);
```

#### 2. Crea un procedimiento almacenado llamado ObtenerDetallesPedido que reciba como parámetro el ID del pedido y devuelva los detalles del pedido, incluyendo el nombre del producto, cantidad y precio unitario.

```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS ObtenerDetallesPedido $$

CREATE PROCEDURE ObtenerDetallesPedido(
    IN pedidoId INT
)
BEGIN
    SELECT p.name, od.quantity, p.price
    FROM order_detail od
    INNER JOIN product p ON od.productId = p.id
    WHERE od.orderId = pedidoId;
END $$

DELIMITER ;

-- example of usage
CALL ObtenerDetallesPedido(1);
```

#### 3. Crea un procedimiento almacenado llamado ActualizarPrecioProducto que reciba como parámetros el ID del producto y el nuevo precio, y actualice el precio del producto en la tabla Productos .

```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS ActualizarPrecioProducto $$

CREATE PROCEDURE ActualizarPrecioProducto(
    IN productId INT,
    IN nuevoPrecio DECIMAL(10,2)
)
BEGIN
    UPDATE product
    SET price = nuevoPrecio
    WHERE id = productId;
END $$

DELIMITER ;

-- Example of usage
CALL ActualizarPrecioProducto(1, 120.00);
```

#### 4. Crea un procedimiento almacenado llamado EliminarProducto que reciba como parámetro el ID del producto y lo elimine de la tabla Productos .

```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS EliminarProducto $$

CREATE PROCEDURE EliminarProducto(
    IN inProductId INT
)
BEGIN
    -- update from order_detail the productId for null
    UPDATE order_detail
    SET productId = NULL, -- because the product was deleted
    WHERE productId = inProductId;

    -- delete from product the product with specific id
    DELETE FROM product
    WHERE id = inProductId;
END $$

DELIMITER ;

-- Example of usage
CALL EliminarProducto(1);
```

#### 5. Crea un procedimiento almacenado llamado TotalGastadoPorUsuario que reciba como parámetro el ID del usuario y devuelva el total gastado por ese usuario en todos sus pedidos.

```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS TotalGastadoPorUsuario $$

CREATE PROCEDURE TotalGastadoPorUsuario(
    IN inUserId INT,
    OUT totalGastado DECIMAL(10,2),
    OUT nombreUsuario VARCHAR(100)
)
BEGIN
    -- to get the name of the user
    SELECT name INTO nombreUsuario
    FROM user
    WHERE id = inUserId;

    -- to get the total_sent of a user
    SELECT SUM(od.quantity * p.price) INTO totalGastado
    FROM orders o
    JOIN order_detail od ON o.id = od.orderId
    JOIN product p ON od.productId = p.id
    WHERE o.userId = inUserId;

    SELECT nombreUsuario AS 'Usuario', totalGastado AS 'Total_Gastado';
END $$

DELIMITER ;


-- example of usage
CALL TotalGastadoPorUsuario(1, @totalGastado, @nombreUsuario);
```

