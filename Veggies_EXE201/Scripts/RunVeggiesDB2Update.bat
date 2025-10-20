@echo off
echo ========================================
echo    SCRIPT CAP NHAT DATABASE VEGGIESDB2
echo ========================================
echo.

REM Kiểm tra xem có đang ở đúng thư mục project không
if not exist "Veggies_EXE201.csproj" (
    echo Loi: Khong tim thay file Veggies_EXE201.csproj
    echo Vui long chay script nay tu thu muc goc cua project
    pause
    exit /b 1
)

echo 1. Dang kiem tra ket noi database...
echo    Server: LEGION5
echo    Database: VeggiesDB2
echo    SQL File: Scripts\VeggiesDB2_CompleteUpdate.sql
echo.

echo 2. Dang chay script SQL...

REM Kiểm tra xem file SQL có tồn tại không
if not exist "Scripts\VeggiesDB2_CompleteUpdate.sql" (
    echo Loi: Khong tim thay file Scripts\VeggiesDB2_CompleteUpdate.sql
    pause
    exit /b 1
)

REM Chạy script SQL bằng sqlcmd
sqlcmd -S LEGION5 -d VeggiesDB2 -E -i Scripts\VeggiesDB2_CompleteUpdate.sql

if %errorlevel% equ 0 (
    echo    Script SQL chay thanh cong!
) else (
    echo    Script SQL chay that bai voi ma loi: %errorlevel%
    echo.
    echo Vui long chay script SQL thu cong:
    echo 1. Mo SQL Server Management Studio
    echo 2. Ket noi den server: LEGION5
    echo 3. Chon database: VeggiesDB2
    echo 4. Mo file: Scripts\VeggiesDB2_CompleteUpdate.sql
    echo 5. Chay script
    pause
    exit /b 1
)

echo.

echo 3. Dang build project...
dotnet build --no-restore

if %errorlevel% equ 0 (
    echo    Build thanh cong!
) else (
    echo    Build that bai!
)

echo.
echo ========================================
echo           HOAN THANH
echo ========================================
echo Database VeggiesDB2 da duoc cap nhat voi cac cot moi
echo Bay gio ban co the chay ung dung binh thuong
echo.
echo Luu y:
echo - Neu van gap loi, hay kiem tra connection string trong appsettings.json
echo - Dam bao ten database va server dung
echo - Kiem tra quyen truy cap database
echo.
pause
