# Hiển thị thông báo và yêu cầu người dùng nhập Y/N
Write-Host "AutoRDPWRAP By @RVMOD_VN"
$choice = Read-Host "Do you want to use? (Y/N)"

if ($choice -eq 'Y' -or $choice -eq 'y') {

    Write-Host "`nDownloading RDPWrap..." -ForegroundColor Green

    # Tải file RDPWrap.zip
    Invoke-WebRequest -Uri "https://github.com/RVMODDEPZAI/AUTO_RDPWRAP/raw/refs/heads/main/RDPWrap.zip" -OutFile "$env:TEMP\RDPWrap.zip"

    Write-Host "Extracting files..." -ForegroundColor Green

    # Giải nén
    Expand-Archive -Path "$env:TEMP\RDPWrap.zip" -DestinationPath "$env:TEMP" -Force

    Write-Host "Running install.bat..." -ForegroundColor Green

    # Chạy install.bat với quyền admin và đợi 30 giây
    $install = Start-Process -FilePath "$env:TEMP\RDPWrap\install.bat" -Verb RunAs -Wait
    Start-Sleep -Seconds 30

    Write-Host "Moving files to C:\Program Files\RDP Wrapper..." -ForegroundColor Green

    # Tạo thư mục đích nếu chưa có
    $destination = "C:\Program Files\RDP Wrapper"
    if (-Not (Test-Path $destination)) { New-Item -ItemType Directory -Path $destination }

    # Di chuyển toàn bộ file
    Move-Item -Path "$env:TEMP\RDPWrap\*" -Destination $destination -Force

    Write-Host "Running autoupdate.bat..." -ForegroundColor Green

    # Chạy autoupdate.bat với quyền admin và đợi 30 giây
    Start-Process -FilePath "$destination\autoupdate.bat" -Verb RunAs -Wait
    Start-Sleep -Seconds 30

    Write-Host "`nAll tasks completed successfully!" -ForegroundColor Green
}
else {
    Write-Host "`nOperation cancelled by user." -ForegroundColor Yellow
}