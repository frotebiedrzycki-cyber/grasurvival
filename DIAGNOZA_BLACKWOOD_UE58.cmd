@echo off
setlocal EnableExtensions DisableDelayedExpansion
title BLACKWOOD - DIAGNOSTYKA UE5.8
echo ===============================================
echo BLACKWOOD - DIAGNOSTYKA KOMPILACJI UE5.8
echo ===============================================
echo.
set "PROJECT=%~dp0BlackwoodSurvival.uproject"
if not exist "%PROJECT%" (
  echo Szukam BlackwoodSurvival.uproject w podfolderach...
  for /R "%~dp0" %%F in (BlackwoodSurvival.uproject) do if not defined FOUND_PROJECT if exist "%%~fF" set "FOUND_PROJECT=%%~fF"
)
if defined FOUND_PROJECT set "PROJECT=%FOUND_PROJECT%"
if not exist "%PROJECT%" (
  echo.
  echo Nie znalazlem projektu obok skryptu.
  echo Wklej pelna sciezke do pliku BlackwoodSurvival.uproject.
  echo Mozesz przeciagnac plik .uproject do okna CMD.
  set /p "PROJECT=Sciezka do pliku lub folderu: "
)
set "PROJECT=%PROJECT:"=%"
if exist "%PROJECT%\BlackwoodSurvival.uproject" set "PROJECT=%PROJECT%\BlackwoodSurvival.uproject"
if exist "%PROJECT%\BlackwoodSurvival\BlackwoodSurvival.uproject" set "PROJECT=%PROJECT%\BlackwoodSurvival\BlackwoodSurvival.uproject"
if not exist "%PROJECT%" (
  echo.
  echo BLAD: Nie znaleziono pliku:
  echo %PROJECT%
  echo.
  echo Sprawdz czy rozpakowales pelny ZIP, a nie samo archiwum z kodem.
  pause
  exit /b 2
)
for %%F in ("%PROJECT%") do set "PROJECT_DIR=%%~dpF"
echo.
echo ZNALEZIONO PROJEKT: %PROJECT%
set "ENGINE=E:\epic\UE_5.8"
if not exist "%ENGINE%\Engine\Build\BatchFiles\Build.bat" set "ENGINE=C:\Program Files\Epic Games\UE_5.8"
if not exist "%ENGINE%\Engine\Build\BatchFiles\Build.bat" (
  echo.
  echo Nie znalazlem Unreal Engine 5.8 w typowych lokalizacjach.
  set /p "ENGINE=Wpisz folder instalacji UE_5.8: "
)
set "ENGINE=%ENGINE:"=%"
if not exist "%ENGINE%\Engine\Build\BatchFiles\Build.bat" (
  echo BLAD: Nie znaleziono pliku Build.bat w %ENGINE%
  pause
  exit /b 3
)
set "LOG=%PROJECT_DIR%BLACKWOOD_KOMPILACJA_LOG.txt"
echo.
echo Silnik: %ENGINE%
echo Log: %LOG%
echo.
echo Rozpoczynam kompilacje. Poczekaj do zakonczenia.
call "%ENGINE%\Engine\Build\BatchFiles\Build.bat" BlackwoodSurvivalEditor Win64 Development -Project="%PROJECT%" -WaitMutex -NoHotReload >"%LOG%" 2>&1
set "RESULT=%ERRORLEVEL%"
echo.
if "%RESULT%"=="0" (
  echo SUKCES: Kod zostal skompilowany.
) else (
  echo BLAD KOMPILACJI: kod %RESULT%
  echo.
  echo Pierwsze znalezione bledy:
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Content -LiteralPath $env:LOG | Select-String -Pattern '(?i)error C[0-9]+|error MSB[0-9]+|error:|fatal error|CompilationResultException|error UBT' | Select-Object -First 35 | ForEach-Object { $_.Line }"
)
echo.
echo Przeslij tutaj plik:
echo %LOG%
echo.
pause
exit /b %RESULT%
