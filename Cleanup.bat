@echo off
setlocal enabledelayedexpansion

echo Cleaning unnecessary files...

rem Get the size and count of temporary files and prefetch files
for %%d in ("%temp%" "%systemdrive%\Windows\Prefetch") do (
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
        set "CleanupLocations=!CleanupLocations! "%%~nd""
    )
)

rem Ask the user for confirmation to proceed with cleaning
set "Confirm="
set /p "Confirm=Do you want to proceed with cleaning? (Y/N): "
if /i "%Confirm%"=="Y" (
    echo Cleaning unnecessary files...
    for %%d in (%CleanupLocations%) do (
        echo Cleaning %%d...
        del /f /q "%%~fd\*.*"
    )
    echo Unnecessary files cleaned.
) else (
    echo Cleaning canceled.
)

pause
