@echo off
:: Kiểm tra quyền Admin
fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Yêu cầu quyền Administrator. Đang khởi động lại với quyền cao...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:: Nếu có quyền admin, bắt đầu chạy chương trình
mode con: cols=80 lines=25
color 0A
title AutoRDPWRAP By @RVMOD_VN

:header
cls
echo.
echo  ==================================================
echo       AutoRDPWRAP Installer By @RVMOD_VN
echo  ==================================================
echo.
echo        [1] Start Installation

set /p choice= Do you want to continue? (Y/N): 
if /i "%choice%" NEQ "Y" goto :cancel

call :animation "Preparing to download file..."
powershell -Command ^
$ProgressPreference = 'Continue'; ^
$url = 'https://github.com/RVMODDEPZAI/AUTO_RDPWRAP/raw/refs/heads/main/RDPWrap.zip'; ^
$output = $env:TEMP + '\RDPWrap.zip'; ^
Invoke-WebRequest -Uri $url -OutFile $output

call :animation "Extracting files..."
powershell -Command "Expand-Archive -Path $env:TEMP\RDPWrap.zip -DestinationPath $env:TEMP -Force"

call :animation "Running install.bat..."
start "" cmd /c "%TEMP%\RDPWrap\install.bat"
timeout /t 30 >nul
taskkill /im cmd.exe /f >nul 2>&1

call :animation "Moving files to Program Files..."
if not exist "C:\Program Files\RDP Wrapper" mkdir "C:\Program Files\RDP Wrapper"
xcopy /y /e /i "%TEMP%\RDPWrap\*" "C:\Program Files\RDP Wrapper\"

call :animation "Running autoupdate.bat..."
start "" cmd /c "C:\Program Files\RDP Wrapper\autoupdate.bat"
timeout /t 30 >nul
taskkill /im cmd.exe /f >nul 2>&1

call :animation "Installation completed successfully!"
echo.
echo  ==================================================
echo              Installation Completed!
echo  ==================================================
echo.
timeout /t 3 >nul
exit

:cancel
cls
echo.
echo  ==================================================
echo            Operation Cancelled by User
echo  ==================================================
timeout /t 2 >nul
exit

:animation
cls
echo.
echo  ==================================================
echo       AutoRDPWRAP Installer By @RVMOD_VN
echo  ==================================================
echo.
echo  %~1
call :loading
exit /b

:loading
setlocal EnableDelayedExpansion
for /l %%A in (1,1,20) do (
    set "line=!line!."
    cls
    echo.
    echo  ==================================================
    echo       AutoRDPWRAP Installer By @RVMOD_VN
    echo  ==================================================
    echo.
    echo  !line!
    timeout /t 1 >nul
)
endlocal
exit /b
