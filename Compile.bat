@echo off
setlocal enabledelayedexpansion

title Building mDNS-NetworkScanner EXE...
echo ============================================================
echo   Building NetScanNotebook / mDNS-NetworkScanner Executable
echo ============================================================
echo.

:: Get current directory
set "ROOT=%~dp0"
cd /d "%ROOT%"

:: Determine script to compile (checks for NetScanNotebook.py first, then fallbacks)
if exist "%ROOT%NetScanNotebook.py" (
    set "TARGET_SCRIPT=%ROOT%NetScanNotebook.py"
) else if exist "%ROOT%mDNS-NetworkScanner-GUI.py" (
    set "TARGET_SCRIPT=%ROOT%mDNS-NetworkScanner-GUI.py"
) else (
    echo [ERROR] Could not find 'NetScanNotebook.py' or 'mDNS-NetworkScanner-GUI.py' in this directory.
    goto ERROR_EXIT
)

:: Ensure python is accessible
where python >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Python is not installed or not added to system PATH.
    goto ERROR_EXIT
)

:: Install / verify PyInstaller is present using python -m
echo Checking for PyInstaller...
python -m pip install --quiet pyinstaller openpyxl zeroconf scapy mac-vendor-lookup

echo.
echo Building single executable file...
echo Target Script: %TARGET_SCRIPT%
echo.

:: Icon handling
set "ICON_PARAM="
if exist "%ROOT%app_icon.ico" (
    set "ICON_PARAM=--icon="%ROOT%app_icon.ico""
)

:: Run PyInstaller via Python module execution to prevent environment/path launcher issues
python -m PyInstaller ^
    --onefile ^
    --windowed ^
    --noconsole ^
    --clean ^
    --name "NetScanNotebook" ^
    %ICON_PARAM% ^
    "%TARGET_SCRIPT%"

if %ERRORLEVEL% neq 0 (
    echo.
    echo [ERROR] Build failed. Check error messages above.
    goto ERROR_EXIT
)

echo.
echo ============================================================
echo   BUILD SUCCESSFUL!
echo ============================================================
echo Executable generated at:
echo %ROOT%dist\NetScanNotebook.exe
echo ============================================================
echo.
pause
exit /b 0

:ERROR_EXIT
echo.
echo ============================================================
echo   BUILD FAILED!
echo ============================================================
pause
exit /b 1