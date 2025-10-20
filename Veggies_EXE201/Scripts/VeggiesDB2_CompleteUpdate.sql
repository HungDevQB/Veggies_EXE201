-- ========================================
-- SCRIPT CẬP NHẬT DATABASE VEGGIESDB2
-- Cho tính năng Seller và Activity Log
-- ========================================

USE [VeggiesDB2]
GO

PRINT 'Bắt đầu cập nhật database VeggiesDB2...'
PRINT ''

-- ========================================
-- 1. THÊM CÁC CỘT MỚI VÀO BẢNG PRODUCTS
-- ========================================

-- Thêm cột SellerId (Foreign Key đến Users)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'SellerId')
BEGIN
    ALTER TABLE Products ADD SellerId INT NULL;
    PRINT '✓ Đã thêm cột SellerId vào bảng Products';
END
ELSE
BEGIN
    PRINT '✓ Cột SellerId đã tồn tại trong bảng Products';
END
GO

-- Thêm cột UpdatedAt
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'UpdatedAt')
BEGIN
    ALTER TABLE Products ADD UpdatedAt DATETIME2 NULL;
    PRINT '✓ Đã thêm cột UpdatedAt vào bảng Products';
END
ELSE
BEGIN
    PRINT '✓ Cột UpdatedAt đã tồn tại trong bảng Products';
END
GO

-- ========================================
-- 2. THÊM CỘT MỚI VÀO BẢNG ORDERS
-- ========================================

-- Thêm cột UpdatedAt
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'UpdatedAt')
BEGIN
    ALTER TABLE Orders ADD UpdatedAt DATETIME2 NULL;
    PRINT '✓ Đã thêm cột UpdatedAt vào bảng Orders';
END
ELSE
BEGIN
    PRINT '✓ Cột UpdatedAt đã tồn tại trong bảng Orders';
END
GO

-- ========================================
-- 3. THÊM CỘT MỚI VÀO BẢNG ACTIVITYLOGS
-- ========================================

-- Thêm cột IpAddress
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ActivityLogs') AND name = 'IpAddress')
BEGIN
    ALTER TABLE ActivityLogs ADD IpAddress NVARCHAR(50) NULL;
    PRINT '✓ Đã thêm cột IpAddress vào bảng ActivityLogs';
END
ELSE
BEGIN
    PRINT '✓ Cột IpAddress đã tồn tại trong bảng ActivityLogs';
END
GO

-- ========================================
-- 4. TẠO FOREIGN KEY CONSTRAINTS
-- ========================================

-- Foreign Key: Products.SellerId -> Users.UserId
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Products_Users_Seller')
BEGIN
    ALTER TABLE Products 
    ADD CONSTRAINT FK_Products_Users_Seller 
    FOREIGN KEY (SellerId) REFERENCES Users(UserId) 
    ON DELETE SET NULL;
    PRINT '✓ Đã tạo Foreign Key: Products.SellerId -> Users.UserId';
END
ELSE
BEGIN
    PRINT '✓ Foreign Key Products.SellerId -> Users.UserId đã tồn tại';
END
GO

-- Foreign Key: ActivityLogs.UserId -> Users.UserId
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ActivityLogs_Users')
BEGIN
    ALTER TABLE ActivityLogs 
    ADD CONSTRAINT FK_ActivityLogs_Users 
    FOREIGN KEY (UserId) REFERENCES Users(UserId) 
    ON DELETE SET NULL;
    PRINT '✓ Đã tạo Foreign Key: ActivityLogs.UserId -> Users.UserId';
END
ELSE
BEGIN
    PRINT '✓ Foreign Key ActivityLogs.UserId -> Users.UserId đã tồn tại';
END
GO

-- ========================================
-- 5. TẠO INDEXES ĐỂ TỐI ƯU HIỆU SUẤT
-- ========================================

-- Index cho Products.SellerId
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_SellerId')
BEGIN
    CREATE INDEX IX_Products_SellerId ON Products(SellerId);
    PRINT '✓ Đã tạo Index: IX_Products_SellerId';
END
ELSE
BEGIN
    PRINT '✓ Index IX_Products_SellerId đã tồn tại';
END
GO

-- Index cho ActivityLogs.UserId
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ActivityLogs_UserId')
BEGIN
    CREATE INDEX IX_ActivityLogs_UserId ON ActivityLogs(UserId);
    PRINT '✓ Đã tạo Index: IX_ActivityLogs_UserId';
END
ELSE
BEGIN
    PRINT '✓ Index IX_ActivityLogs_UserId đã tồn tại';
END
GO

-- Index cho ActivityLogs.CreatedAt
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ActivityLogs_CreatedAt')
BEGIN
    CREATE INDEX IX_ActivityLogs_CreatedAt ON ActivityLogs(CreatedAt);
    PRINT '✓ Đã tạo Index: IX_ActivityLogs_CreatedAt';
END
ELSE
BEGIN
    PRINT '✓ Index IX_ActivityLogs_CreatedAt đã tồn tại';
END
GO

-- Index cho Products.UpdatedAt
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_UpdatedAt')
BEGIN
    CREATE INDEX IX_Products_UpdatedAt ON Products(UpdatedAt);
    PRINT '✓ Đã tạo Index: IX_Products_UpdatedAt';
END
ELSE
BEGIN
    PRINT '✓ Index IX_Products_UpdatedAt đã tồn tại';
END
GO

-- ========================================
-- 6. CẬP NHẬT DỮ LIỆU MẪU
-- ========================================

-- Gán sản phẩm hiện có cho admin làm seller mặc định
UPDATE Products 
SET SellerId = (SELECT TOP 1 UserId FROM Users WHERE Role = 'Admin')
WHERE SellerId IS NULL;

PRINT '✓ Đã gán sản phẩm hiện có cho admin làm seller mặc định';

-- Cập nhật UpdatedAt cho sản phẩm hiện có
UPDATE Products 
SET UpdatedAt = CreatedAt 
WHERE UpdatedAt IS NULL AND CreatedAt IS NOT NULL;

PRINT '✓ Đã cập nhật UpdatedAt cho sản phẩm hiện có';

-- Cập nhật UpdatedAt cho đơn hàng hiện có
UPDATE Orders 
SET UpdatedAt = OrderDate 
WHERE UpdatedAt IS NULL AND OrderDate IS NOT NULL;

PRINT '✓ Đã cập nhật UpdatedAt cho đơn hàng hiện có';

-- ========================================
-- 7. TẠO DỮ LIỆU MẪU CHO ACTIVITY LOGS
-- ========================================

-- Thêm một số activity log mẫu
IF NOT EXISTS (SELECT * FROM ActivityLogs WHERE Action = 'SYSTEM_INIT')
BEGIN
    INSERT INTO ActivityLogs (Action, UserId, Details, CreatedAt, IpAddress)
    SELECT 
        'SYSTEM_INIT' as Action,
        UserId,
        'Hệ thống khởi tạo - Tạo tài khoản ' + Role as Details,
        CreatedAt,
        '127.0.0.1' as IpAddress
    FROM Users 
    WHERE Role IN ('Admin', 'Seller');
    
    PRINT '✓ Đã tạo activity log mẫu cho users hiện có';
END
ELSE
BEGIN
    PRINT '✓ Activity log mẫu đã tồn tại';
END
GO

-- ========================================
-- 8. KIỂM TRA KẾT QUẢ
-- ========================================

PRINT ''
PRINT '=== KIỂM TRA KẾT QUẢ ==='

-- Kiểm tra cấu trúc bảng Products
PRINT 'Cấu trúc bảng Products:'
SELECT 
    COLUMN_NAME as 'Tên cột',
    DATA_TYPE as 'Kiểu dữ liệu',
    IS_NULLABLE as 'Cho phép NULL',
    CHARACTER_MAXIMUM_LENGTH as 'Độ dài tối đa'
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Products' 
ORDER BY ORDINAL_POSITION;

-- Kiểm tra cấu trúc bảng Orders
PRINT ''
PRINT 'Cấu trúc bảng Orders:'
SELECT 
    COLUMN_NAME as 'Tên cột',
    DATA_TYPE as 'Kiểu dữ liệu',
    IS_NULLABLE as 'Cho phép NULL',
    CHARACTER_MAXIMUM_LENGTH as 'Độ dài tối đa'
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Orders' 
ORDER BY ORDINAL_POSITION;

-- Kiểm tra cấu trúc bảng ActivityLogs
PRINT ''
PRINT 'Cấu trúc bảng ActivityLogs:'
SELECT 
    COLUMN_NAME as 'Tên cột',
    DATA_TYPE as 'Kiểu dữ liệu',
    IS_NULLABLE as 'Cho phép NULL',
    CHARACTER_MAXIMUM_LENGTH as 'Độ dài tối đa'
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ActivityLogs' 
ORDER BY ORDINAL_POSITION;

-- Kiểm tra Foreign Keys
PRINT ''
PRINT 'Foreign Keys đã tạo:'
SELECT 
    fk.name as 'Tên FK',
    OBJECT_NAME(fk.parent_object_id) as 'Bảng cha',
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) as 'Cột cha',
    OBJECT_NAME(fk.referenced_object_id) as 'Bảng tham chiếu',
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) as 'Cột tham chiếu'
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE fk.name IN ('FK_Products_Users_Seller', 'FK_ActivityLogs_Users');

-- Kiểm tra Indexes
PRINT ''
PRINT 'Indexes đã tạo:'
SELECT 
    i.name as 'Tên Index',
    OBJECT_NAME(i.object_id) as 'Bảng',
    COL_NAME(ic.object_id, ic.column_id) as 'Cột'
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
WHERE i.name IN ('IX_Products_SellerId', 'IX_ActivityLogs_UserId', 'IX_ActivityLogs_CreatedAt', 'IX_Products_UpdatedAt');

-- Thống kê dữ liệu
PRINT ''
PRINT 'Thống kê dữ liệu:'
SELECT 'Products' as 'Bảng', COUNT(*) as 'Số bản ghi' FROM Products
UNION ALL
SELECT 'Orders' as 'Bảng', COUNT(*) as 'Số bản ghi' FROM Orders
UNION ALL
SELECT 'ActivityLogs' as 'Bảng', COUNT(*) as 'Số bản ghi' FROM ActivityLogs
UNION ALL
SELECT 'Users' as 'Bảng', COUNT(*) as 'Số bản ghi' FROM Users;

PRINT ''
PRINT '=== HOÀN THÀNH CẬP NHẬT DATABASE VEGGIESDB2 ==='
PRINT 'Database đã được cập nhật thành công với:'
PRINT '- Các cột mới cho tính năng Seller'
PRINT '- Các cột mới cho tính năng Activity Log'
PRINT '- Foreign Keys và Indexes để tối ưu hiệu suất'
PRINT '- Dữ liệu mẫu để test'
PRINT ''
PRINT 'Bây giờ bạn có thể chạy ứng dụng bình thường!'
