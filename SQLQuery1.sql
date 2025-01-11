CREATE TABLE Orders (
    i_OrderID INT PRIMARY KEY IDENTITY(1,1),
    i_UserID INT NOT NULL, -- Liên kết đến bảng `useinformation`
    f_OrderDate DATETIME DEFAULT GETDATE(), -- Ngày tạo đơn
    f_TotalAmount DECIMAL(18,2) NOT NULL, -- Tổng tiền
    Status NVARCHAR(50), -- Trạng thái đơn hàng (Pending, Completed, Canceled, etc.)
    PaymentMethod NVARCHAR(50), -- Phương thức thanh toán (Cash, Credit Card, etc.)
    FOREIGN KEY (i_UserID) REFERENCES useinformation(i_id)
);
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL, -- Liên kết đến bảng `Orders`
    ProductID INT NOT NULL, -- Liên kết đến bảng `product`
    SizeID INT, -- Liên kết đến bảng `Sizes`
    ColorID INT, -- Liên kết đến bảng `Colors`
    Quantity INT NOT NULL, -- Số lượng sản phẩm
    Price DECIMAL(18,2) NOT NULL, -- Giá của sản phẩm
    Total DECIMAL(18,2) NOT NULL, -- Thành tiền (Quantity * Price)
    FOREIGN KEY (OrderID) REFERENCES Orders(i_OrderID),
    FOREIGN KEY (ProductID) REFERENCES product(i_id),
    FOREIGN KEY (SizeID) REFERENCES Sizes(Size_ID),
    FOREIGN KEY (ColorID) REFERENCES Colors(Color_ID)
);
