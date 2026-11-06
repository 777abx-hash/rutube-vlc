@echo off
set /p url="Вставьте ссылку на Rutube: "

:: получаем прямую HLS-ссылку через yt-dlp
set "TMPF=%TEMP%\rutube_%RANDOM%.txt"
yt-dlp -g --no-warnings "%url%" > "%TMPF%" 2>nul

set "M3U8="
set /p M3U8=<"%TMPF%"
del "%TMPF%" >nul 2>&1

if not defined M3U8 goto err

start "" "C:\Program Files\VideoLAN\VLC\vlc.exe" --file-caching=3000 --network-caching=3000 "%M3U8%"
exit /b

:err
echo.
echo Ошибка: не удалось получить ссылку на видео.
echo Проверьте ссылку или обновите yt-dlp:  pip install -U yt-dlp
echo.
pause
