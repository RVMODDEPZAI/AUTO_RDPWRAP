@echo off
:: Kiểm tra quyền Admin
fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Yêu cầu quyền Administrator. Đang khởi động lại với quyền cao...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: Bắt đầu cài đặt
echo AutoRDPWRAP By @RVMOD_VN
set /p userinput=Do you want to use? (Y/N): 

if /i "%userinput%" NEQ "Y" (
    echo Operation cancelled by user.
    timeout /t 2 >nul
    exit
)

:: Tải file nhanh
echo Downloading file...
powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest 'https://github.com/RVMODDEPZAI/AUTO_RDPWRAP/raw/refs/heads/main/RDPWrap.zip' -OutFile $env:TEMP\RDPWrap.zip"

:: Giải nén file nhanh
echo Extracting file...
powershell -Command "Expand-Archive -Path $env:TEMP\RDPWrap.zip -DestinationPath $env:TEMP -Force"

:: Chạy install.bat trong cửa sổ riêng
echo Running install.bat...
start "" cmd /c "%TEMP%\RDPWrap\install.bat"
timeout /t 30 >nul
taskkill /im cmd.exe /f >nul 2>&1

:: Đảm bảo di chuyển file trước khi chạy autoupdate.bat
echo Moving files to C:\Program Files\RDP Wrapper...
if not exist "C:\Program Files\RDP Wrapper" mkdir "C:\Program Files\RDP Wrapper"
xcopy /y /e /i "%TEMP%\RDPWrap\*" "C:\Program Files\RDP Wrapper\"

:: Chạy autoupdate.bat trong cửa sổ riêng
echo Running autoupdate.bat...
start "" cmd /c "C:\Program Files\RDP Wrapper\autoupdate.bat"
timeout /t 30 >nul
taskkill /im cmd.exe /f >nul 2>&1

:: Hoàn tất
echo Installation completed successfully!
timeout /t 3 >nul
exit
