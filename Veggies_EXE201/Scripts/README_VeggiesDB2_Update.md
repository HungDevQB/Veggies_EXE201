# Hướng dẫn cập nhật Database VeggiesDB2

## Mục đích
Script này sẽ cập nhật database VeggiesDB2 để hỗ trợ các tính năng mới:
- **Tính năng Seller**: Quản lý sản phẩm, đơn hàng, thống kê
- **Tính năng Activity Log**: Theo dõi hoạt động của người dùng

## Các thay đổi sẽ được thực hiện

### 1. Bảng Products
- ✅ Thêm cột `SellerId` (INT, NULL) - Liên kết với Users
- ✅ Thêm cột `UpdatedAt` (DATETIME2, NULL) - Thời gian cập nhật

### 2. Bảng Orders  
- ✅ Thêm cột `UpdatedAt` (DATETIME2, NULL) - Thời gian cập nhật

### 3. Bảng ActivityLogs
- ✅ Thêm cột `IpAddress` (NVARCHAR(50), NULL) - Địa chỉ IP

### 4. Foreign Keys
- ✅ `FK_Products_Users_Seller`: Products.SellerId → Users.UserId
- ✅ `FK_ActivityLogs_Users`: ActivityLogs.UserId → Users.UserId

### 5. Indexes (Tối ưu hiệu suất)
- ✅ `IX_Products_SellerId`: Tối ưu truy vấn sản phẩm theo seller
- ✅ `IX_ActivityLogs_UserId`: Tối ưu truy vấn log theo user
- ✅ `IX_ActivityLogs_CreatedAt`: Tối ưu truy vấn log theo thời gian
- ✅ `IX_Products_UpdatedAt`: Tối ưu truy vấn sản phẩm theo thời gian

## Cách chạy script

### Cách 1: Chạy tự động (Khuyến nghị)

#### Sử dụng PowerShell:
```powershell
# Mở PowerShell với quyền Administrator
# Chuyển đến thư mục project
cd "D:\DEV_FVC\EXE201\Veggies_EXE201\Veggies_EXE201"

# Chạy script
.\Scripts\RunVeggiesDB2Update.ps1
```

#### Sử dụng Batch:
```cmd
# Mở Command Prompt
# Chuyển đến thư mục project
cd "D:\DEV_FVC\EXE201\Veggies_EXE201\Veggies_EXE201"

# Chạy script
Scripts\RunVeggiesDB2Update.bat
```

### Cách 2: Chạy thủ công

1. **Mở SQL Server Management Studio**
2. **Kết nối đến server**: `LEGION5`
3. **Chọn database**: `VeggiesDB2`
4. **Mở file**: `Scripts\VeggiesDB2_CompleteUpdate.sql`
5. **Chạy script**

### Cách 3: Sử dụng Azure Data Studio

1. **Mở Azure Data Studio**
2. **Kết nối đến server**: `LEGION5`
3. **Chọn database**: `VeggiesDB2`
4. **Mở file**: `Scripts\VeggiesDB2_CompleteUpdate.sql`
5. **Chạy script**

## Kiểm tra kết quả

Sau khi chạy script thành công, bạn sẽ thấy:

```
=== HOÀN THÀNH CẬP NHẬT DATABASE VEGGIESDB2 ===
Database đã được cập nhật thành công với:
- Các cột mới cho tính năng Seller
- Các cột mới cho tính năng Activity Log
- Foreign Keys và Indexes để tối ưu hiệu suất
- Dữ liệu mẫu để test
```

## Troubleshooting

### Lỗi kết nối database
- Kiểm tra SQL Server có đang chạy không
- Kiểm tra tên server và database có đúng không
- Kiểm tra quyền truy cập database

### Lỗi sqlcmd không tìm thấy
- Cài đặt SQL Server Command Line Utilities
- Hoặc chạy script thủ công trong SSMS

### Lỗi permission denied
- Chạy PowerShell/Command Prompt với quyền Administrator
- Kiểm tra quyền truy cập database

### Lỗi build sau khi cập nhật
- Xóa thư mục `bin` và `obj`
- Chạy `dotnet clean`
- Chạy `dotnet build` lại

## Cấu trúc database sau khi cập nhật

### Bảng Products
```sql
ProductId (INT, PK)
ProductName (NVARCHAR)
Description (NVARCHAR)
Price (DECIMAL)
Stock (INT)
CategoryId (INT, FK)
VietGapCertificateUrl (NVARCHAR)
CultivationVideoUrl (NVARCHAR)
CreatedAt (DATETIME2)
ProductImage (NVARCHAR)
SellerId (INT, FK) -- MỚI
UpdatedAt (DATETIME2) -- MỚI
```

### Bảng Orders
```sql
OrderId (INT, PK)
UserId (INT, FK)
OrderDate (DATETIME2)
Status (NVARCHAR)
TotalAmount (DECIMAL)
ShippingAddress (NVARCHAR)
ShippingPhone (NVARCHAR)
Notes (NVARCHAR)
UpdatedAt (DATETIME2) -- MỚI
```

### Bảng ActivityLogs
```sql
LogId (INT, PK)
Action (NVARCHAR)
UserId (INT, FK)
Details (NVARCHAR)
CreatedAt (DATETIME2)
IpAddress (NVARCHAR(50)) -- MỚI
```

## Kết quả mong đợi

Sau khi hoàn thành:
- ✅ Database có đầy đủ các cột mới
- ✅ Project build thành công
- ✅ Ứng dụng chạy bình thường
- ✅ Các tính năng Seller và Activity Log hoạt động
- ✅ Không còn lỗi "Invalid column name"

## Hỗ trợ

Nếu gặp vấn đề:
1. Kiểm tra log lỗi chi tiết
2. Xác nhận tên server và database
3. Kiểm tra quyền truy cập
4. Thử chạy script thủ công trong SSMS
5. Kiểm tra connection string trong appsettings.json
