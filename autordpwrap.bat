@echo off
title AutoRDPWRAP By @RVMOD_VN
color 0A
echo AutoRDPWRAP By @RVMOD_VN
set /p userinput=Do you want to use? (Y/N): 

if /i "%userinput%" NEQ "Y" (
    echo Operation cancelled by user.
    timeout /t 2 >nul
    exit
)

echo.
echo Preparing to download file...
echo.

powershell -Command ^
$ProgressPreference = 'Continue'; ^
$url = 'https://github.com/RVMODDEPZAI/AUTO_RDPWRAP/raw/refs/heads/main/RDPWrap.zip'; ^
$output = $env:TEMP + '\RDPWrap.zip'; ^
Invoke-WebRequest -Uri $url -OutFile $output

echo.
echo Download completed!
echo Extracting file...
powershell -Command "Expand-Archive -Path $env:TEMP\RDPWrap.zip -DestinationPath $env:TEMP -Force"
echo Extraction completed!

echo.
echo Running install.bat...
powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%TEMP%\RDPWrap\install.bat' -WindowStyle Normal -Wait"
timeout /t 30 >nul

echo.
echo Moving files to C:\Program Files\RDP Wrapper...
if not exist "C:\Program Files\RDP Wrapper" mkdir "C:\Program Files\RDP Wrapper"
xcopy /y /e /i "%TEMP%\RDPWrap\*" "C:\Program Files\RDP Wrapper\"

echo.
echo Running autoupdate.bat...
powershell -WindowStyle Hidden -Command "Start-Process -FilePath 'C:\Program Files\RDP Wrapper\autoupdate.bat' -WindowStyle Normal -Wait"
timeout /t 30 >nul

echo.
echo All tasks completed successfully!
timeout /t 3 >nul
exit
