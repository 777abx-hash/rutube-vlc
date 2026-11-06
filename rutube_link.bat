@echo off
chcp 65001 >nul
setlocal EnableExtensions DisableDelayedExpansion
title Rutube -^> VLC

set /p "url=Вставьте ссылку на Rutube: "
if not defined url goto err

:: Берем название видео и HLS-ссылку одним запросом к yt-dlp
set "TMPF=%TEMP%\rutube_%RANDOM%%RANDOM%.txt"
set "PYTHONIOENCODING=utf-8"
yt-dlp --no-warnings --no-playlist -e -g "%url%" > "%TMPF%" 2>nul

set "TITLE="
set "M3U8="
for /f "usebackq eol= delims=" %%A in ("%TMPF%") do (
    if not defined TITLE (
        set "TITLE=%%A"
    ) else if not defined M3U8 (
        set "M3U8=%%A"
    )
)
del "%TMPF%" >nul 2>&1

:: Если имени нет, значит первая строка была ссылкой
if not defined M3U8 if defined TITLE set "M3U8=%TITLE%"
if not defined M3U8 goto err
if "%TITLE%"=="%M3U8%" set "TITLE="

if defined TITLE (
    echo Название: "%TITLE%"
    start "" "C:\Program Files\VideoLAN\VLC\vlc.exe" --file-caching=3000 --network-caching=3000 --meta-title="%TITLE%" "%M3U8%"
) else (
    start "" "C:\Program Files\VideoLAN\VLC\vlc.exe" --file-caching=3000 --network-caching=3000 "%M3U8%"
)
exit /b

:err
echo.
echo Ошибка: не удалось получить ссылку на видео.
echo Проверьте ссылку или обновите yt-dlp:  pip install -U yt-dlp
echo.
pause
