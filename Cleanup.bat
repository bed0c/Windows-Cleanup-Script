@echo off
setlocal enabledelayedexpansion

echo Windows Cleanup Script

rem List cleanup options
echo.
echo 1. Clean temporary files (%temp%)
echo 2. Clean prefetch files (%systemdrive%\Windows\Prefetch)
echo 3. Clean both
echo 4. Exit

set /p "choice=Enter your choice: "

if "%choice%"=="1" (
    set "cleanup_dirs=%temp%"
    set "cleanup_label=Temporary Files"
) else if "%choice%"=="2" (
    set "cleanup_dirs=%systemdrive%\Windows\Prefetch"
    set "cleanup_label=Prefetch Files"
) else if "%choice%"=="3" (
    set "cleanup_dirs=%temp% %systemdrive%\Windows\Prefetch"
    set "cleanup_label=Temporary and Prefetch Files"
) else if "%choice%"=="4" (
    echo Exiting script...
    exit /b
) else (
    echo Invalid choice. Please enter a valid option.
    pause
    exit /b
)

echo Cleaning %cleanup_label%...

rem Perform cleanup for each directory
for %%d in (%cleanup_dirs%) do (
    set "FileCount=0"
    set "TotalSize=0"
    for /r %%i in (%%d\*) do (
        set /a "FileCount+=1"
        for /f "tokens=3" %%s in ('dir /-c "%%i" ^| findstr /c:"File(s)"') do set "FileSize=%%s"
        set /a "TotalSize+=!FileSize!"
    )
    if !FileCount! gtr 0 (
        echo Total size of unnecessary files in %%~nd: !TotalSize! bytes
        echo Total number of unnecessary files in %%~nd: !FileCount!
    )
    echo Cleaning %%d...
    del /f /q "%%~fd\*.*"
)

echo Cleaning completed.
pause
