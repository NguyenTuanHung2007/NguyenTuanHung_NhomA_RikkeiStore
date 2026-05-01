-- PHẦN D1: TẠO CẤU TRÚC BẢNG (DDL)
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    current_address TEXT,
    current_phone VARCHAR(20) NOT NULL
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    current_price DECIMAL(15,2) NOT NULL CHECK (current_price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL CHECK (status IN ('Pending', 'Paid', 'Cancelled')),
    total_money DECIMAL(15,2) NOT NULL DEFAULT 0 CHECK (total_money >= 0),
    shipping_name VARCHAR(255) NOT NULL,
    shipping_phone VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(15,2) NOT NULL CHECK (price >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- PHẦN D2: CHÈN DỮ LIỆU MẪU (DML)
-- Chèn 5 danh mục
INSERT INTO Categories (name) VALUES ('Electronics'), ('Clothing'), ('Books'), ('Home Decor'), ('Sports');

-- Chèn 5 người dùng
INSERT INTO Users (email, password, full_name, current_address, current_phone) VALUES
('nguyenvana@gmail.com', 'pwd1', 'Nguyen Van A', '123 Ba Dinh, Ha Noi', '0912345678'),
('tranbibi@gmail.com', 'pwd2', 'Tran Thi B', '456 District 1, HCM', '0922345678'),
('lephuocc@gmail.com', 'pwd3', 'Le Phuoc C', '789 Hai Chau, Da Nang', '0932345678'),
('phamvand@gmail.com', 'pwd4', 'Pham Van D', '111 Ninh Kieu, Can Tho', '0942345678'),
('hoangthie@gmail.com', 'pwd5', 'Hoang Thi E', '222 Hong Bang, Hai Phong', '0952345678');

-- Chèn 5 sản phẩm
INSERT INTO Products (category_id, name, current_price, stock_quantity) VALUES
(1, 'Laptop Rikkei', 1500.00, 50),
(1, 'Smartphone Rikkei', 800.00, 100),
(2, 'T-Shirt Rikkei', 25.00, 200),
(3, 'SQL Book', 40.00, 30),
(4, 'Desk Lamp', 15.00, 10);

-- Chèn 5 đơn hàng
INSERT INTO Orders (user_id, order_date, status, total_money, shipping_name, shipping_phone, shipping_address) VALUES
(1, '2025-01-10 10:00:00', 'Paid', 1525.00, 'Nguyen Van A', '0912345678', '123 Ba Dinh, Ha Noi'),
(2, '2025-02-12 11:30:00', 'Paid', 1600.00, 'Tran Thi B', '0922345678', '456 District 1, HCM'),
(1, '2025-02-14 15:00:00', 'Pending', 40.00, 'Nguyen Van A', '0912345678', '123 Ba Dinh, Ha Noi'),
(3, '2025-02-15 09:00:00', 'Cancelled', 15.00, 'Le Phuoc C', '0932345678', '789 Hai Chau, Da Nang'),
(4, '2025-02-16 14:20:00', 'Paid', 825.00, 'Pham Van D', '0942345678', '111 Ninh Kieu, Can Tho');

-- Chèn 7 chi tiết đơn hàng (liên kết dữ liệu)
INSERT INTO Order_Details (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1500.00), (1, 3, 1, 25.00), (2, 2, 2, 800.00), (3, 4, 1, 40.00), (4, 5, 1, 15.00), (5, 2, 1, 800.00), (5, 3, 1, 25.00);

-- PHẦN D3: TRUY VẤN DỮ LIỆU (DQL)
-- Câu 1: Lấy danh sách tất cả đơn hàng gồm order_id, order_date, full_name của khách hàng và total_money
SELECT o.order_id AS order_id, o.order_date AS order_date, u.full_name AS full_name, o.total_money AS total_money FROM Orders AS o
JOIN Users AS u 
ON o.user_id = u.user_id;

-- Câu 2: Tìm tất cả sản phẩm thuộc danh mục 'Electronics'
SELECT p.product_id AS product_id, p.name AS product_name, p.current_price AS price FROM Products AS p
JOIN Categories AS c 
ON p.category_id = c.category_id 
WHERE c.name = 'Electronics';

-- Câu 3: Tìm danh sách tất cả người dùng bao gồm user_id, full_name và email
SELECT u.user_id AS user_id, u.full_name AS full_name, u.email AS email FROM Users AS u;

-- Câu 4: Tính tổng số tiền thu được từ tất cả các đơn hàng trong hệ thống
SELECT SUM(o.total_money) AS total_revenue FROM Orders AS o;

-- Câu 5: Tính tổng số lượng sản phẩm đã bán được theo từng sản phẩm cụ thể
SELECT p.product_id AS product_id, p.name AS product_name, SUM(od.quantity) AS total_quantity FROM Order_Details AS od
JOIN Products AS p 
ON od.product_id = p.product_id 
GROUP BY p.product_id, p.name;

-- Câu 6: Tìm sản phẩm có tổng số lượng bán ra lớn nhất trong hệ thống
SELECT p.product_id AS product_id, p.name AS product_name, SUM(od.quantity) AS total_quantity FROM Order_Details AS od
JOIN Products AS p 
ON od.product_id = p.product_id 
GROUP BY p.product_id, p.name 
ORDER BY total_quantity DESC 
LIMIT 1;

-- Câu 7: Lấy danh sách đơn hàng kèm theo tên khách hàng, tổng tiền và tổng số lượng sản phẩm trong mỗi đơn
SELECT o.order_id AS order_id, u.full_name AS full_name, o.total_money AS total_money, SUM(od.quantity) AS total_items FROM Orders AS o
JOIN Users AS u 
ON o.user_id = u.user_id 
JOIN Order_Details AS od 
ON o.order_id = od.order_id 
GROUP BY o.order_id, u.full_name, o.total_money;

-- Câu 8: Tìm danh sách các sản phẩm chưa từng xuất hiện trong bất kỳ đơn hàng nào
SELECT p.product_id AS product_id, p.name AS product_name FROM Products AS p
LEFT JOIN Order_Details AS od 
ON p.product_id = od.product_id 
WHERE od.product_id IS NULL;

-- Câu 9: Tìm danh sách những người dùng đã từng mua hàng và số lượng đơn hàng họ đã đặt
SELECT u.user_id AS user_id, u.full_name AS full_name, COUNT(o.order_id) AS total_orders FROM Users AS u
JOIN Orders AS o 
ON u.user_id = o.user_id 
GROUP BY u.user_id, u.full_name;

-- Câu 10: Tìm các sản phẩm có giá hiện tại cao hơn mức giá trung bình của tất cả sản phẩm trong kho
SELECT p.product_id AS product_id, p.name AS product_name, p.current_price AS current_price FROM Products AS p
WHERE p.current_price > (SELECT AVG(p2.current_price) FROM Products AS p2);

-- Câu 11: Tìm danh sách người dùng có tổng chi tiêu cho mua sắm lớn hơn mức chi tiêu trung bình của các khách hàng
SELECT u.user_id AS user_id, u.full_name AS full_name, SUM(o.total_money) AS total_spent FROM Users AS u
JOIN Orders AS o 
ON u.user_id = o.user_id 
GROUP BY u.user_id, u.full_name 
HAVING total_spent > (SELECT AVG(sub.user_total) FROM (SELECT SUM(o2.total_money) AS user_total FROM Orders AS o2 GROUP BY o2.user_id) AS sub);

-- Câu 12: Tìm đơn hàng có giá trị tổng hóa đơn lớn nhất trong toàn bộ hệ thống
SELECT o.order_id AS order_id, o.total_money AS max_value FROM Orders AS o
ORDER BY o.total_money DESC 
LIMIT 1;

-- Câu 13: Tìm danh mục sản phẩm mang lại tổng doanh thu cao nhất cho cửa hàng
SELECT c.category_id AS category_id, c.name AS category_name, SUM(od.quantity * od.price) AS total_revenue FROM Categories AS c
JOIN Products AS p 
ON c.category_id = p.category_id 
JOIN Order_Details AS od 
ON p.product_id = od.product_id 
GROUP BY c.category_id, c.name 
ORDER BY total_revenue DESC 
LIMIT 1;

-- Câu 14: Tìm top 3 sản phẩm bán chạy nhất dựa trên số lượng, ưu tiên sản phẩm có ID nhỏ hơn nếu số lượng bằng nhau
SELECT p.product_id AS product_id, p.name AS product_name, SUM(od.quantity) AS total_sold FROM Products AS p
JOIN Order_Details AS od 
ON p.product_id = od.product_id 
GROUP BY p.product_id, p.name 
ORDER BY total_sold DESC, p.product_id ASC 
LIMIT 3;

-- Câu 15: Tìm danh sách những người dùng đăng ký tài khoản nhưng chưa từng đặt bất kỳ đơn hàng nào
SELECT u.user_id AS user_id, u.full_name AS full_name FROM Users AS u
LEFT JOIN Orders AS o 
ON u.user_id = o.user_id 
WHERE o.order_id IS NULL;