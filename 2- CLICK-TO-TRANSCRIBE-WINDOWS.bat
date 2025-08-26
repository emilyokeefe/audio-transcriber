@echo off
setlocal
echo 1) Put audio into "1 - Put-Audio-Files-Here"
echo 2) This will create its own environment and transcribe
echo.

REM ensure folders
if not exist "1 - Put-Audio-Files-Here" mkdir "1 - Put-Audio-Files-Here"
if not exist "3 - Read-Your-Transcripts-Here" mkdir "3 - Read-Your-Transcripts-Here"
if not exist "4 - Finished-Audio-Moved-Here" mkdir "4 - Finished-Audio-Moved-Here"
if not exist "5 - Ignore-This-Folder" mkdir "5 - Ignore-This-Folder"

pushd "5 - Ignore-This-Folder"

REM Create venv if missing
if not exist .venv (
    echo Creating virtual environment...
    python -m venv .venv
    if errorlevel 1 (
        echo ERROR: Failed to create virtual environment.
        pause
        exit /b 1
    )
    call .venv\Scripts\activate.bat
    echo Upgrading pip...
    python -m pip install --upgrade pip
    echo Installing required package: assemblyai...
    pip install assemblyai
) else (
    call .venv\Scripts\activate.bat
)

REM Show Python version
python --version

REM Run your script
python transcribe_all.py

REM Show completion message
echo.
echo Done. Open "3 - Read-Your-Transcripts-Here".
endlocal
pause