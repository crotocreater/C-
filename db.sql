
CREATE TABLE account (
	i_Id INT PRIMARY KEY, 
	s_UserName nvarchar(1000) not null,
	s_PassWord varchar (1000) not null, 
	s_Email varchar (1000) not null unique,
	s_Image varchar(1000), 
	s_Role varchar(20) not null, 
	s_Active varchar(20) not null, 
	d_CreateDate date, 
	d_LastUpdate date, 
	s_SecurityQuestion nvarchar(1000), 
	s_SecurtyAnswer nvarchar(1000),
	i_isActive int not null check (i_isActive = 1 OR i_isActive = 0)
);


INSERT INTO account (
    i_Id, 
    s_UserName, 
    s_PassWord, 
    s_Email, 
    s_Image, 
    s_Role, 
    s_Active, 
    d_CreateDate, 
    d_LastUpdate, 
    s_SecurityQuestion, 
    s_SecurtyAnswer, 
    i_isActive
) 
VALUES (
    1, -- ID tài khoản admin (cần đảm bảo là duy nhất)
    'admin', -- Tên tài khoản
    'admin@123', -- Mật khẩu (nên mã hóa trước khi lưu)
    'admin@example.com', -- Email
    NULL, -- Ảnh đại diện (có thể để NULL nếu không có)
    'Admin', -- Vai trò
    'Active', -- Trạng thái kích hoạt
    GETDATE(), -- Ngày tạo (lấy ngày hiện tại)
    GETDATE(), -- Ngày cập nhật cuối (để NULL vì mới tạo)
    'What is your birthday', -- Câu hỏi bảo mật
    '05062005', -- Câu trả lời bảo mật
    1 -- Trạng thái hoạt động (1 = hoạt động, 0 = không hoạt động)
);


DELETE [dbo].[account] WHERE i_Id = 1;

SELECT * FROM account


CREATE TABLE useinformation (
    i_id INT PRIMARY KEY REFERENCES [dbo].[account](i_Id), -- Khóa chính, tham chiếu khóa ngoại
    s_FullName NVARCHAR(1000) NOT NULL, -- Họ và tên
    d_BirthDay DATE NOT NULL, -- Ngày sinh
    d_StartWork DATE NOT NULL, -- Ngày bắt đầu làm việc
    s_Active VARCHAR(100) NOT NULL, -- Trạng thái hoạt động
    s_Job NVARCHAR(100) NOT NULL, -- Nghề nghiệp
    s_Sex VARCHAR(10) NOT NULL, -- Giới tính
    s_Address NVARCHAR(1000) NOT NULL, -- Địa chỉ
    i_Age int CHECK (i_Age >= 18 AND i_Age <= 60) -- Tính tuổi và ràng buộc
);


INSERT INTO useinformation (
    i_id, 
    s_FullName, 
    d_BirthDay, 
    d_StartWork, 
    s_Active, 
    s_Job, 
    s_Sex, 
    s_Address, 
	i_Age
)
VALUES (
    1, -- ID tương ứng với tài khoản admin trong bảng account
    N'ĐỖ VIỆT HOÀNG', -- Họ và tên
    '2005-06-05', -- Ngày sinh
    GETDATE(), -- Ngày bắt đầu làm việc (ngày hiện tại)
    'active', -- Trạng thái hoạt động
    'Admin', -- Vai trò/Nghề nghiệp
    'Nam', -- Giới tính
    N'Ninh Dân - Thanh Ba - Phú Thọ', -- Địa chỉ
	19
);


DELETE [dbo].[useinformation] WHERE i_id = 1

SELECT * FROM [dbo].[useinformation]




CREATE TABLE category (
	i_id int primary key,
	s_NameCategory text not null, 
	s_Discription text, 
);

CREATE TABLE subcategory (
	i_id int primary key,
	s_NameCategory text not null, 
	s_Discription text,
	i_Category int references category(i_id)
);

CREATE TABLE product (
    i_id INT PRIMARY KEY, -- ID sản phẩm, khóa chính
    s_ProductName NVARCHAR(255) NOT NULL, -- Tên sản phẩm
    s_Description NVARCHAR(MAX), -- Mô tả sản phẩm
    s_ProductImage NVARCHAR(1000), -- Hình ảnh sản phẩm (URL hoặc đường dẫn)
    i_Totals INT CHECK(i_Totals >= 0), -- Tổng số lượng sản phẩm (cho phép 0 nếu hết hàng)
    i_Status INT CHECK(i_Status = 1 OR i_Status = 0), -- Trạng thái sản phẩm (1 = Active, 0 = Inactive)
    i_Rating INT CHECK(i_Rating > 0 AND i_Rating <= 5), -- Đánh giá sản phẩm (1 đến 5 sao)
    d_CreatedDate DATE NOT NULL DEFAULT GETDATE(), -- Ngày tạo sản phẩm
    d_UpdatedDate DATE NULL, -- Ngày cập nhật sản phẩm
	f_Price FLOAT CHECK(f_Price >= 0), 
	s_Discription NVARCHAR(1000),
	i_TotalPay INT CHECK(i_TotalPay >= 0),
    i_CategoryID INT REFERENCES [dbo].[subcategory](i_id)
);


CREATE TABLE Colors (
    Color_ID int PRIMARY KEY,
    Color_Name VARCHAR(50) NOT NULL
);

CREATE TABLE Sizes (
    Size_ID int PRIMARY KEY,
    Size_Name VARCHAR(10) NOT NULL
);


CREATE TABLE productPropery (
	i_ProductID INT REFERENCES [dbo].[product](i_id), 
	i_SizeID INT REFERENCES [dbo].[Sizes](Size_ID), 
	i_ColorID INT REFERENCES [dbo].[Colors](Color_ID),
	i_Total INT CHECK(i_Total >= 0), 
	PRIMARY KEY (i_ProductID, i_SizeID, i_ColorID)
);


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
