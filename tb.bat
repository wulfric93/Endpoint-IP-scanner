@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title TunnelBear VPN - Full Clean Checker

set "logfile=%~dp0TunnelBear_Log.txt"

if not exist "%logfile%" (
    echo. > "%logfile%"
    echo ================================================== >> "%logfile%"
    echo TunnelBear VPN Full Clean Log >> "%logfile%"
    echo Started: %date% %time% >> "%logfile%"
    echo ================================================== >> "%logfile%"
)

cls
echo.
echo [1;36mTunnelBear VPN - Full Clean Checker (All Countries)[0m
echo [1;36m=================================================[0m
echo Log: %logfile%
echo.
pause

:menu
cls
echo [1;36mTunnelBear VPN - All Servers[0m
echo [1;36m===========================[0m
echo.

set "num=1"

echo [1;35m=== North America ===[0m
call :add ca.lazerpenguin.com "Canada (General)"
call :add ca-montreal-tier2.lazerpenguin.com "Canada - Montreal"
call :add ca-toronto-tier2.lazerpenguin.com "Canada - Toronto"
call :add ca-vancouver-tier2.lazerpenguin.com "Canada - Vancouver"
call :add us.lazerpenguin.com "United States (General)"
call :add us-central.lazerpenguin.com "US - Central"
call :add us-central-x.lazerpenguin.com "US - Central (Balanced)"
call :add us-east.lazerpenguin.com "US - East"
call :add us-east-x.lazerpenguin.com "US - East (Balanced)"
call :add us-west.lazerpenguin.com "US - West"
call :add us-west-x.lazerpenguin.com "US - West (Balanced)"
call :add us-atlanta-tier2.lazerpenguin.com "US - Atlanta"
call :add us-chicago-tier2.lazerpenguin.com "US - Chicago"
call :add us-dallas-tier2.lazerpenguin.com "US - Dallas"
call :add us-denver-tier2.lazerpenguin.com "US - Denver"
call :add us-losangeles-tier2.lazerpenguin.com "US - Los Angeles"
call :add us-miami-tier2.lazerpenguin.com "US - Miami"
call :add us-newyork-tier2.lazerpenguin.com "US - New York"
call :add us-phoenix-tier2.lazerpenguin.com "US - Phoenix"
call :add us-saltlakecity-tier2.lazerpenguin.com "US - Salt Lake City"
call :add us-sanjose-tier2.lazerpenguin.com "US - San Jose"
call :add us-seattle-tier2.lazerpenguin.com "US - Seattle"
call :add us-stlouis-tier2.lazerpenguin.com "US - St. Louis"
call :add mx.lazerpenguin.com "Mexico"
echo.

echo [1;35m=== South America ===[0m
call :add ar.lazerpenguin.com "Argentina"
call :add br.lazerpenguin.com "Brazil"
call :add cl.lazerpenguin.com "Chile"
call :add co.lazerpenguin.com "Colombia"
call :add pe.lazerpenguin.com "Peru"
echo.

echo [1;35m=== Europe ===[0m
call :add at.lazerpenguin.com "Austria"
call :add be.lazerpenguin.com "Belgium"
call :add bg.lazerpenguin.com "Bulgaria"
call :add cy.lazerpenguin.com "Cyprus"
call :add cz.lazerpenguin.com "Czech Republic"
call :add de.lazerpenguin.com "Germany"
call :add dk.lazerpenguin.com "Denmark"
call :add fi.lazerpenguin.com "Finland"
call :add fr.lazerpenguin.com "France"
call :add gr.lazerpenguin.com "Greece"
call :add hu.lazerpenguin.com "Hungary"
call :add ie.lazerpenguin.com "Ireland"
call :add it.lazerpenguin.com "Italy"
call :add lt.lazerpenguin.com "Lithuania"
call :add lv.lazerpenguin.com "Latvia"
call :add md.lazerpenguin.com "Moldova"
call :add nl.lazerpenguin.com "Netherlands"
call :add no.lazerpenguin.com "Norway"
call :add pl.lazerpenguin.com "Poland"
call :add pt.lazerpenguin.com "Portugal"
call :add ro.lazerpenguin.com "Romania"
call :add rs.lazerpenguin.com "Serbia"
call :add si.lazerpenguin.com "Slovenia"
call :add es.lazerpenguin.com "Spain"
call :add se.lazerpenguin.com "Sweden"
call :add ch.lazerpenguin.com "Switzerland"
call :add gb.lazerpenguin.com "United Kingdom"
call :add uk.lazerpenguin.com "United Kingdom (Legacy)"
call :add ua.lazerpenguin.com "Ukraine"
echo.

echo [1;35m=== Asia ===[0m
call :add ae.lazerpenguin.com "United Arab Emirates"
call :add hk.lazerpenguin.com "Hong Kong"
call :add id.lazerpenguin.com "Indonesia"
call :add in.lazerpenguin.com "India"
call :add jp.lazerpenguin.com "Japan"
call :add kr.lazerpenguin.com "South Korea"
call :add my.lazerpenguin.com "Malaysia"
call :add ph.lazerpenguin.com "Philippines"
call :add sg.lazerpenguin.com "Singapore"
call :add tw.lazerpenguin.com "Taiwan"
echo.

echo [1;35m=== Oceania ===[0m
call :add au.lazerpenguin.com "Australia"
call :add nz.lazerpenguin.com "New Zealand"
echo.

echo [1;35m=== Africa ===[0m
call :add ke.lazerpenguin.com "Kenya"
call :add ng.lazerpenguin.com "Nigeria"
call :add za.lazerpenguin.com "South Africa"
echo.

echo.
set /p "choice=Enter number (q to quit): "
if /i "%choice%"=="q" goto :end

set "subdomain=!sub_%choice%!"
set "desc=!desc_%choice%!"

if not defined subdomain (
    echo [31mInvalid choice![0m
    timeout /t 2 >nul
    goto menu
)

cls
echo [1;34mTesting: %desc%[0m
echo Subdomain: %subdomain%
echo.

echo. >> "%logfile%"
echo -------------------------------------------------- >> "%logfile%"
echo Test: %date% %time% >> "%logfile%"
echo Server: %desc% ^| Subdomain: %subdomain% >> "%logfile%"

:: Reliable DNS using PowerShell
set "ips="
for /f "delims=" %%a in ('powershell -command "try { (Resolve-DnsName -Name %subdomain% -Server 8.8.8.8 -Type A -ErrorAction Stop).IPAddress | Sort-Object -Unique } catch { }"') do (
    set "ips=!ips! %%a"
)

if not defined ips (
    echo [31mNo IPs resolved — check internet or try later[0m
    echo No IPs resolved. >> "%logfile%"
    timeout /t 5 >nul
    goto menu
)

echo [1;32mResolved IPs:[0m
echo IPs: >> "%logfile%"
for %%i in (%ips%) do (
    echo    %%i
    echo    %%i >> "%logfile%"
)
echo.
echo Pinging all IPs...

set "tempfile=%temp%\tb_ping.tmp"
if exist "%tempfile%" del "%tempfile%"

set working=0
set "best_ip="
set "best_ms=9999"

for %%i in (%ips%) do (
    ping -n 4 -w 2000 %%i >nul 2>&1
    if !errorlevel! equ 0 (
        for /f "tokens=3 delims==" %%t in ('ping -n 4 -w 2000 %%i ^| find "Average"') do (
            set "ms=%%t"
            set "ms=!ms:ms=!"
            set "ms=!ms: =!"
            echo [32m%%i → !ms! ms[0m
            echo %%i → !ms! ms >> "%tempfile%"
            echo %%i → !ms! ms >> "%logfile%"
            set /a working+=1
            if !ms! lss !best_ms! (
                set "best_ms=!ms!"
                set "best_ip=%%i"
            )
        )
    ) else (
        echo [31m%%i → unreachable[0m
        echo %%i → unreachable >> "%logfile%"
    )
)

echo.
if %working%==0 (
    echo [31mNo responsive servers.[0m
) else (
    echo [1;32mWorking servers (fastest first):[0m
    sort "%tempfile%" /+10
    echo.
    echo [1;36mFastest: %best_ip% (!best_ms! ms)[0m
    echo Fastest: %best_ip% (!best_ms! ms) >> "%logfile%"
)

del "%tempfile%" 2>nul
echo Test ended: %time% >> "%logfile%"
echo -------------------------------------------------- >> "%logfile%"

echo.
set /p "again=Test another? (y/n): "
if /i "%again%"=="y" goto menu

:end
echo.
echo All tests saved to: %logfile%
pause
goto :eof

:add
set "sub_!num!=%~1"
set "desc_!num!=%~2"
echo [1;33m!num!)[0m %~2
set /a num+=1
exit /b
