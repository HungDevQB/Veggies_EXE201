# Script PowerShell để cập nhật database VeggiesDB2
Write-Host "=== SCRIPT CẬP NHẬT DATABASE VEGGIESDB2 ===" -ForegroundColor Green
Write-Host ""

# Kiểm tra xem có đang ở đúng thư mục project không
if (-not (Test-Path "Veggies_EXE201.csproj")) {
    Write-Host "Lỗi: Không tìm thấy file Veggies_EXE201.csproj" -ForegroundColor Red
    Write-Host "Vui lòng chạy script này từ thư mục gốc của project" -ForegroundColor Red
    exit 1
}

Write-Host "1. Đang kiểm tra kết nối database..." -ForegroundColor Yellow

# Thông tin kết nối database
$serverName = "LEGION5"  # Thay đổi theo server của bạn
$databaseName = "VeggiesDB2"  # Database cụ thể
$sqlFile = "Scripts\VeggiesDB2_CompleteUpdate.sql"

Write-Host "   Server: $serverName" -ForegroundColor Gray
Write-Host "   Database: $databaseName" -ForegroundColor Gray
Write-Host "   SQL File: $sqlFile" -ForegroundColor Gray

# Kiểm tra xem file SQL có tồn tại không
if (-not (Test-Path $sqlFile)) {
    Write-Host "Lỗi: Không tìm thấy file $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host ""

Write-Host "2. Đang chạy script SQL..." -ForegroundColor Yellow

try {
    # Sử dụng sqlcmd để chạy script SQL
    $sqlcmdPath = "sqlcmd"
    
    # Kiểm tra xem sqlcmd có sẵn không
    $sqlcmdCheck = Get-Command $sqlcmdPath -ErrorAction SilentlyContinue
    if (-not $sqlcmdCheck) {
        Write-Host "Lỗi: Không tìm thấy sqlcmd. Vui lòng cài đặt SQL Server Command Line Utilities" -ForegroundColor Red
        Write-Host "Hoặc chạy script SQL thủ công trong SQL Server Management Studio" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Nội dung script SQL:" -ForegroundColor Cyan
        Write-Host "===================" -ForegroundColor Cyan
        Get-Content $sqlFile
        exit 1
    }

    # Chạy script SQL
    $sqlcmdArgs = @(
        "-S", $serverName,
        "-d", $databaseName,
        "-E",  # Sử dụng Windows Authentication
        "-i", $sqlFile
    )

    Write-Host "   Đang chạy: sqlcmd $($sqlcmdArgs -join ' ')" -ForegroundColor Gray
    
    $result = & $sqlcmdPath $sqlcmdArgs 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   Script SQL chạy thành công!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Kết quả:" -ForegroundColor Cyan
        Write-Host $result -ForegroundColor White
    } else {
        Write-Host "   Script SQL chạy thất bại với mã lỗi: $LASTEXITCODE" -ForegroundColor Red
        Write-Host ""
        Write-Host "Lỗi:" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "   Lỗi khi chạy script SQL: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Vui lòng chạy script SQL thủ công:" -ForegroundColor Yellow
    Write-Host "1. Mở SQL Server Management Studio" -ForegroundColor Yellow
    Write-Host "2. Kết nối đến server: $serverName" -ForegroundColor Yellow
    Write-Host "3. Chọn database: $databaseName" -ForegroundColor Yellow
    Write-Host "4. Mở file: $sqlFile" -ForegroundColor Yellow
    Write-Host "5. Chạy script" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

Write-Host "3. Đang build project..." -ForegroundColor Yellow

try {
    $buildResult = dotnet build --no-restore
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   Build thành công!" -ForegroundColor Green
    } else {
        Write-Host "   Build thất bại!" -ForegroundColor Red
        Write-Host "   Kết quả build:" -ForegroundColor Yellow
        Write-Host $buildResult -ForegroundColor Gray
    }
} catch {
    Write-Host "   Lỗi khi build: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

Write-Host "=== HOÀN THÀNH ===" -ForegroundColor Green
Write-Host "Database VeggiesDB2 đã được cập nhật với các cột mới" -ForegroundColor Green
Write-Host "Bây giờ bạn có thể chạy ứng dụng bình thường" -ForegroundColor Green
Write-Host ""
Write-Host "Lưu ý:" -ForegroundColor Yellow
Write-Host "- Nếu vẫn gặp lỗi, hãy kiểm tra connection string trong appsettings.json" -ForegroundColor Yellow
Write-Host "- Đảm bảo tên database và server đúng" -ForegroundColor Yellow
Write-Host "- Kiểm tra quyền truy cập database" -ForegroundColor Yellow
