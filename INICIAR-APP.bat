@echo off
chcp 65001 >nul
title The Ladyhawkes - Content Factory
cd /d "%~dp0"

echo.
echo   ============================================
echo    THE LADYHAWKES - CONTENT FACTORY
echo    Melodic Hard Rock / AOR - Anos 80
echo   ============================================
echo.
echo    Servidor local: http://localhost:8081
echo    O navegador vai abrir sozinho em instantes.
echo.
echo    Para ENCERRAR o app: feche esta janela.
echo   ============================================
echo.

rem Abre o navegador (o servidor sobe logo abaixo)
start "" http://localhost:8081/

rem Sobe o servidor local servindo este index.html
where python >nul 2>nul
if %errorlevel%==0 (
  python -m http.server 8081
) else (
  py -m http.server 8081
)

echo.
echo  O servidor foi encerrado. Pode fechar esta janela.
pause >nul
