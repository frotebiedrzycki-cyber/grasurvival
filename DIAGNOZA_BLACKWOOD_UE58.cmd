@echo off
setlocal EnableExtensions
chcp 65001 >nul
title BLACKWOOD - Diagnoza kompilacji UE5.8

echo ==========================================
echo BLACKWOOD: Lost Signal - diagnostyka C++
echo ==========================================
echo.
set "PROJECT=%~dp0BlackwoodSurvival.uproject"
if not exist "%PROJECT%" (
    echo Umiesc ten plik obok BlackwoodSurvival.uproject
    echo albo wpisz pelna sciezke do .uproject:
    set /p "PROJECT=Sciezka: "
)
set "PROJECT=%PROJECT:"=%"
if not exist "%PROJECT%" (
    echo BLAD: Nie znaleziono %PROJECT%
    pause
    exit /b 2
)
for %%P in ("%PROJECT%") do set "PROJECT_DIR=%%~dpP"
set "ENGINE=E:\epic\UE_5.8"
if not exist "%ENGINE%\Engine\Build\BatchFiles\Build.bat" set "ENGINE=C:\Program Files\Epic Games\UE_5.8"
if not exist "%ENGINE%\Engine\Build\BatchFiles\Build.bat" (
    set /p "ENGINE=Sciezka do folderu UE_5.8: "
)
set "ENGINE=%ENGINE:"=%"
if not exist "%ENGINE%\Engine\Build\BatchFiles\Build.bat" (
    echo BLAD: Brak Build.bat w folderze %ENGINE%
    pause
    exit /b 3
)
set "LOG=%PROJECT_DIR%BLACKWOOD_KOMPILACJA_LOG.txt"
echo.
echo Projekt: %PROJECT%
echo Silnik: %ENGINE%
echo Log: %LOG%
echo.
echo Kompilowanie: BlackwoodSurvivalEditor / Win64 / Development
echo To moze potrwać. Nie zamykaj tego okna.
call "%ENGINE%\Engine\Build\BatchFiles\Build.bat" BlackwoodSurvivalEditor Win64 Development -Project="%PROJECT%" -WaitMutex -NoHotReload > "%LOG%" 2>&1
set "RESULT=%ERRORLEVEL%"
echo.
if "%RESULT%"=="0" (
    echo SUKCES: Kompilacja zakonczona kodem 0.
) else (
    echo BLAD: Kompilacja nie powiodla sie, kod %RESULT%.
    echo.
    echo --- Pierwsze komunikaty o bledach ---
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Content -LiteralPath $env:LOG | Select-String -Pattern '(?i)error C[0-9]+|error MSB[0-9]+|error:|fatal error|Exception while|CompilationResultException|error UBT' | Select-Object -First 35 | ForEach-Object { Write-Output $_.Line }"
)
echo.
echo PRZESLIJ DO CHATGPT PLIK:
echo %LOG%
echo.
pause
exit /b %RESULT%
