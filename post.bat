@echo off

set version=1.0.0
TITLE reb0rnOS %version%
wscript "%windir%\Modules\FullscreenCMD.vbs"
set QC=32 

reg.exe add "HKCU\Environment" /f /t REG_SZ /v "Path" /d "C:\Windows\reb0rnOS"
reg.exe add "HKCU\Environment" /f /t REG_SZ /v "Temp" /d "C:\Users\ADMINI~1\AppData\Local\Temp"
reg.exe add "HKCU\Environment" /f /t REG_SZ /v "Tmp" /d "C:\Users\ADMINI~1\AppData\Local\Temp"
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /f /t REG_SZ /v "Temp" /d "C:\Users\ADMINI~1\AppData\Local\Temp"
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /f /t REG_SZ /v "Tmp" /d "C:\Users\ADMINI~1\AppData\Local\Temp"


SYSTEM\CurrentControlSet\Control\Session Manager\Environment

:SELECT_OPTIONS
cls
echo DISCLAIMER
echo(
echo You should NOT change from what you pick in what you select in the interactive section of the post install script.
echo(
echo A good example would be switching from Ethernet to wifi after you selected Ethernet
echo(
echo By continuing, you agree to have read the following disclaimer aswell as the unsupported channels 
echo(
echo If you need support, join the discord
pause

cls
:CHANGE-Language
echo CHANGE THE LANGUAGE OF THE KEYBOARD NOW RATHER THAN LATER AND CLOSE THE SETTINGS TAB AFTER DONE (THIS ESPECIALLY APPLIES AZERTY OR OTHER SPECIFIC KEYBOARD LAYOUTS)
timeout /t 30
start ms-settings:regionlanguage
timeout /t 30
cls & goto CONNECTION_TYPE

:CONNECTION_TYPE
echo [1/%QC%] What will be your primary internet connection type?
echo(
echo [1] Ethernet
echo( 
echo [2] Wi-Fi
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto WIFI_USER
)
if errorlevel 1 (
	cls & goto ETHERNET_USER
)

:ETHERNET_USER
ping 1.1.1.1 | find "bytes="
IF %ERRORLEVEL% EQU 0 (   
	goto VALID_ETHERNET
) ELSE (
	goto INVALID_CONNECTION_ETHERNET
)

:INVALID_CONNECTION_ETHERNET
cls
echo ERROR: You are not connected to the internet, check your connection details and try again.
pause
cls
goto ETHERNET_USER

:VALID_ETHERNET
PowerRun.exe /SW:0 "Reg.exe" add "HKLM\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "Start" /t REG_DWORD /d "4" /f
PowerRun.exe /SW:0 "Reg.exe" add "HKLM\SYSTEM\CurrentControlSet\Services\NativeWifiP" /v "Start" /t REG_DWORD /d "4" /f
PowerRun.exe /SW:0 "Reg.exe" add "HKLM\SYSTEM\CurrentControlSet\Services\vwifibus" /v "Start" /t REG_DWORD /d "4" /f
PowerRun.exe /SW:0 "Reg.exe" add "HKLM\SYSTEM\CurrentControlSet\Services\vwififlt" /v "Start" /t REG_DWORD /d "4" /f
PowerRun.exe /SW:0 "Reg.exe" add "HKLM\SYSTEM\CurrentControlSet\Services\wdiwifi" /v "Start" /t REG_DWORD /d "4" /f
PowerRun.exe /SW:0 "Reg.exe" add "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "Start" /t REG_DWORD /d "4" /f
cls & goto GRAPHICS

:WIFI_USER
cls
echo The script will now timeout for 5 minutes...
echo(
echo Please connect to your wifi network with the network icon at the bottom right of the screen
wscript "%windir%\Modules\FullscreenCMD.vbs"
timeout /t 300
cls
ping 1.1.1.1 | find "bytes="
IF %ERRORLEVEL% EQU 0 (   
	goto VALID_WIFI
) ELSE (
	goto INVALID_CONNECTION_WIFI
)

:INVALID_CONNECTION_WIFI
cls
echo ERROR: You are not connected to the internet, check your connection details and try again.
pause
cls & goto WIFI_USER

:VALID_WIFI
wscript "%windir%\Modules\FullscreenCMD.vbs"
cls & goto GRAPHICS

:GRAPHICS
cls
echo [2/%QC%] What GPU do you have in your system?
echo(
echo [1] AMD GPU
echo( 
echo [2] NVIDIA GPU
echo(
echo [3] DO NOT INSTALL DRIVER
echo(
choice /c:123 /n > NUL 2>&1
if errorlevel 3 (
	cls & goto WEBCAM
)
if errorlevel 2 (
	cls & goto NVIDIADRIVER
)
if errorlevel 1 (
	cls & goto AMDDRIVER
)

:NVIDIADRIVER
echo Available NVIDIA Drivers:
echo(
echo 419.35
echo 425.31
echo 441.41
echo 442.74
echo 456.71
echo 457.30
echo 457.51
echo 461.92
echo 466.11
echo 466.77
echo 472.12
echo 522.25
echo 526.47
echo 526.98
echo 528.24
echo 531.41
echo Another driver that is not listed (Press 0)
echo(
set /p NVIDIADRIVER="enter what driver you would like to use: "
set NVIDIADRIVER=%NVIDIADRIVER: =%

if "%NVIDIADRIVER%" EQU " =" cls & goto INVALID_NVIDIA
if "%NVIDIADRIVER%" EQU "=" cls & goto INVALID_NVIDIA

for %%i in (skip SKIP 457.30 441.41 391.35 425.31 442.74 457.51 461.92 466.11 466.77 419.35 456.71 472.12 522.25 526.98 528.24 531.41 0) do (
    if %NVIDIADRIVER% EQU %%i (
		cls & goto NVIDIA
	)
)

:INVALID_NVIDIA
cls
echo Invalid input
echo(
goto NVIDIADRIVER

:NVIDIA
cls
if %NVIDIADRIVER% EQU SKIP goto DIRECTX
cls & echo Downloading %NVIDIADRIVER%
echo(
if "%NVIDIADRIVER%" EQU "419.35" (
	curl -L "https://us.download.nvidia.com/Windows/419.35/419.35-desktop-win10-64bit-international-whql-rp.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "425.31" (
	curl -L "https://us.download.nvidia.com/Windows/425.31/425.31-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "441.41" (
	curl -L "https://us.download.nvidia.com/Windows/441.41/441.41-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "442.74" (
	curl -L "https://us.download.nvidia.com/Windows/442.74/442.74-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "456.71" (
	curl -L "https://us.download.nvidia.com/Windows/456.71/456.71-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "457.30" (
	curl -L "https://us.download.nvidia.com/Windows/457.30/457.30-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "457.51" (
	curl -L "https://us.download.nvidia.com/Windows/457.51/457.51-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "461.92" (
	curl -L "https://us.download.nvidia.com/Windows/461.92/461.92-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "466.11" (
	curl -L "https://us.download.nvidia.com/Windows/466.11/466.11-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "466.11" (
	curl -L "https://us.download.nvidia.com/Windows/466.77/466.77-desktop-win10-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "472.12" (
	curl -L "https://us.download.nvidia.com/Windows/472.12/472.12-desktop-win10-win11-64bit-international-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "522.25" (
	curl -L "https://us.download.nvidia.com/Windows/522.25/522.25-desktop-win10-win11-64bit-international-dch-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "526.47" (
	curl -L "https://us.download.nvidia.com/Windows/526.47/526.47-desktop-win10-win11-64bit-international-dch-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "526.98" (
	curl -L "https://us.download.nvidia.com/Windows/526.98/526.98-desktop-win10-win11-64bit-international-dch-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "528.24" (
	curl -L "https://us.download.nvidia.com/Windows/528.24/528.24-desktop-win10-win11-64bit-international-dch-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "531.41" (
	curl -L "https://us.download.nvidia.com/Windows/531.41/531.41-desktop-win10-win11-64bit-international-dch-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "535.98" (
	curl -L "https://us.download.nvidia.com/Windows/531.41/531.41-desktop-win10-win11-64bit-international-dch-whql.exe" -o "%temp%\%NVIDIADRIVER%.zip" --progress-bar
)
if "%NVIDIADRIVER%" EQU "0" (
	cls & goto WEBCAM
)
cls & echo Extracting driver...
7z.exe x -y -o"%temp%\%NVIDIADRIVER%" "%temp%\%NVIDIADRIVER%.zip" > NUL 2>&1
cd %temp%\%NVIDIADRIVER%
copy setup.exe %temp%
cls & echo Debloating driver...
for /f %%a in ('dir "%temp%\%NVIDIADRIVER%" /b') do (
	if "%%a" NEQ "Display.Driver" if "%%a" NEQ "NVI2" if "%%a" NEQ "EULA.txt" if "%%a" NEQ "ListDevices.txt" if "%%a" NEQ "setup.cfg" if "%%a" NEQ "setup.exe" (
		rd /s /q "%temp%\%NVIDIADRIVER%\%%a" > NUL 2>&1
		del /f /q "%temp%\%NVIDIADRIVER%\%%a" > NUL 2>&1
	)
)

"%windir%\Modules\strip_nvsetup.exe" "%temp%\%NVIDIADRIVER%\setup.cfg" "%temp%\%NVIDIADRIVER%\m_setup.cfg"
del /f /q "%temp%\%NVIDIADRIVER%\setup.cfg" > NUL 2>&1
REN "%temp%\%NVIDIADRIVER%\m_setup.cfg" "setup.cfg" > NUL 2>&1
cd %temp%
copy setup.exe %temp%\%NVIDIADRIVER%
cls & echo Installing %NVIDIADRIVER%... This may take some time so wait for the installer to finish installing the debloated driver!
"%temp%\%NVIDIADRIVER%\setup.exe" /s
cls & goto NVSETTINGS

:NVSETTINGS
Reg.exe add "HKCR\DesktopBackground\Shell\NVIDIA ControlPanel" /v "Icon" /t REG_SZ /d "C:\Windows\nvidia\nvidialogo.ico,0" /f
Reg.exe add "HKCR\DesktopBackground\shell\NVIDIA ControlPanel\command" /ve /t REG_SZ /d "C:\Windows\nvidia\nvcplui.exe" /f
Reg.exe delete "HKLM\SOFTWARE\Classes\Directory\background\shellex\ContextMenuHandlers\NvCplDesktopContext" /va /f

del "C:\ProgramData\NVIDIA Corporation\Drs\nvdrsdb0.bin"
del "C:\ProgramData\NVIDIA Corporation\Drs\nvdrsdb1.bin"

for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
			%= VIDEO =%
				%= ADJUST VIDEO IMAGE SETTINGS =%
					%= EDGE ENHANCEMENT - USE THE NVIDIA SETTING =%
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_Edge_Enhance" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP4_XEN_Edge_Enhance" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					%= EDGE ENHANCEMENT 0 =%
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_VAL_Edge_Enhance" /t REG_DWORD /d "0" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP4_VAL_Edge_Enhance" /t REG_DWORD /d "0" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP4_XALG_Edge_Enhance" /t REG_BINARY /d "0000000000000000" /f > NUL 2>&1
					%= NOISE REDUCTION - USE THE NVIDIA SETTING =%
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_Noise_Reduce" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP4_XEN_Noise_Reduce" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					%= NOISE REDUCTION - 0 =%
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_VAL_Noise_Reduce" /t REG_DWORD /d "0" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP4_VAL_Noise_Reduce" /t REG_DWORD /d "0" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP4_XALG_Noise_Reduce" /t REG_BINARY /d "0000000000000000" /f > NUL 2>&1
					%= DEINTERLACING - DISABLE "USE INVERSE TELECINE" =%
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XALG_Cadence" /t REG_BINARY /d "0000000000000000" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP4_XALG_Cadence" /t REG_BINARY /d "0000000000000000" /f > NUL 2>&1

				%= ADJUST VIDEO COLOR SETTINGS =%
					%= COLOR ADJUSTMENTS - WITH THE NVIDIA SETTINGS =%
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_Contrast" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_RGB_Gamma_G" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_RGB_Gamma_R" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_RGB_Gamma_B" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_Hue" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_Saturation" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_Brightness" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XEN_Color_Range" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP4_XEN_Color_Range" /t REG_DWORD /d "2147483649" /f > NUL 2>&1
					%= DYNAMIC RANGE - FULL =%
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XALG_Color_Range" /t REG_BINARY /d "0100000000000000" /f > NUL 2>&1
					Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "_User_SUB0_DFP2_XALG_Color_Range" /t REG_BINARY /d "0100000000000000" /f > NUL 2>&1
					
				%= DISABLE HDCP =%
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "RMHdcpKeyglobZero" /t REG_DWORD /d 1 /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "RmDisableHdcp22" /t REG_DWORD /d 1 /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "RmSkipHdcp22Init" /t REG_DWORD /d 1 /f > NUL 2>&1
				%= DEVELOPER - MANAGE GPU PERFORMANCE COUNTERS - "ALLOW ACCESS TO THE GPU PERFORMANCE COUNTERS TO ALL USERS" =%
				Reg.exe add "HKLM\System\ControlSet001\Control\Class\%%i" /v "RmProfilingAdminOnly" /t REG_DWORD /d "0" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f > NUL 2>&1
		)
	)
)
:: DESKTOP > ENABLE DEVELOPER SETTINGS 
Reg.exe add "HKLM\System\ControlSet001\Services\nvlddmkm\Global\NVTweak" /v "NvDevToolsVisible" /t REG_DWORD /d "1" /f > NUL 2>&1
:: ADJUST IMAGE SETTINGS WITH PREVIEW - "USE THE ADVANCED 3D IMAGE SETTINGS"
Reg.exe add "HKCU\Software\NVIDIA Corporation\Global\NVTweak" /v "Gestalt" /t REG_DWORD /d "513" /f > NUL 2>&1
:: CONFIGURE SURROUND, PHYSX - PROCESSOR: GPU
Reg.exe add "HKLM\System\ControlSet001\Services\nvlddmkm\Global\NVTweak" /v "NvCplPhysxAuto" /t REG_DWORD /d "0" /f > NUL 2>&1
:: MANAGE 3D SETTINGS - UNHIDE SILK SMOOTHNESS OPTION
Reg.exe add "HKLM\SYSTEM\ControlSet001\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d "1" /f > NUL 2>&1
:: DEVELOPER - MANAGE GPU PERFORMANCE COUNTERS - "ALLOW ACCESS TO THE GPU PERFORMANCE COUNTERS TO ALL USERS"
Reg.exe add "HKLM\System\ControlSet001\Services\nvlddmkm\Global\NVTweak" /v "RmProfilingAdminOnly" /t REG_DWORD /d "0" /f > NUL 2>&1
:: TELEMETRY - OPT OUT OF TELEMETRY
reg add "HKLM\Software\Nvidia Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /D 0 /f
:: TELEMETRY - TELEMETRY DATA TO 0
reg add "HKLM\System\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /D 0 /f

:: TRUE NO SCALING
for %%i in (Scaling) do (
    for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /s /f "%%i"^| findstr "HKEY"') do (
		reg add "%%a" /v "Scaling" /t REG_DWORD /d "1" /f  > NUL 2>&1
    )
)

cls & goto NVIDIA_PSTATES

:NVIDIA_PSTATES
cls
echo Would you like to disable p-states within the NVIDIA GPU driver? This will allow the GPU to run at boost clock consistently
echo(
echo WARNING: Temperatures may increase [ For this it's recommended to download MSI Afterburner further in the prompt and setting up fancurve or a static fanspeed ]
echo(
echo [1] Yes (highly recommended but ensure you have sufficient cooling/airflow in your case (Download MSI Afterburner and setup fanspeed levels))
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto GFE
)
if errorlevel 1 (
	cls & goto DISABLE_PSTATE
)

:DISABLE_PSTATE
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\ControlSet001\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
		     Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f > nul 2>&1
                   )
                )
             )
cls & goto GFE

:GFE
cls
echo Do you wish to download GFE (Requirement to use Shadowplay)
echo(
echo [1] Yes
echo(
echo [2] No
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto NVIDIASETTINGS
)
if errorlevel 1 (
	cls & goto GFEDOWNLOAD
)

:GFEDOWNLOAD
curl -L "https://uk.download.nvidia.com/GFE/GFEClient/3.27.0.112/GeForce_Experience_v3.27.0.112.exe" -o "%temp%\GFE.exe" --progress-bar
cls & echo Installing Geforce-Experience...
"%temp%\GFE.exe" /s
DevManView /uninstall "NVIDIA Virtual Audio Device (Wave Extensible) (WDM)" >nul 2>&1
DevManView /uninstall "NvModuleTracker Device" >nul 2>&1
DevManView /uninstall "NVVHCI Enumerator" >nul 2>&1
sc delete NvModuleTracker
sc delete nvvad_WaveExtensible
sc delete nvvhci

cls & goto NVIDIASETTINGS

:NVIDIASETTINGS
cls
echo Do you wish to setup the NVIDIA Settings automatically or instead manually dial them in?
echo(
echo [1] Auto
echo(
echo [2] Manual
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto NVSNO
)
if errorlevel 1 (
	cls & goto NVYES
)

:NVYES
cls
setlocal enabledelayedexpansion
IF EXIST "C:\Windows\system32\adminrightstest" (
	rmdir C:\Windows\system32\adminrightstest > nul
)
mkdir C:\Windows\system32\adminrightstest > nul
if %errorlevel% neq 0 (
	powershell "Start-Process \"%~nx0\" -Verb RunAs"
	if !errorlevel! neq 0 (
		powershell "Start-Process '%~nx0' -Verb RunAs"
		if !errorlevel! neq 0 (
			echo You should run this script as Admin in order to allow system changes
			echo The tweaker will now exit
			pause
			exit
		)
	)
	exit
)
rmdir C:\Windows\system32\adminrightstest > nul
cd /D "%~dp0\..\..\"
IF NOT EXIST "C:\Windows\Modules\nvprofile.nip" (
	echo Error: Profile not found
	echo Nothing to do
	pause
	exit
)
"C:\Windows\Modules\Inspector.exe" "C:\Windows\Modules\nvprofile.nip"
taskkill /f /im inspector.exe
cls & goto WEBCAM

:AMDDRIVER
echo Available AMD Drivers:
echo(
echo 20.4.2 
echo 20.8.3
echo 21.10.2
echo 22.2.2
echo 22.6.1
echo Another driver that is not listed (Press 0)
echo
set /p AMDDRIVER="Enter what driver you would like to use: "
set AMDDRIVER=%AMDDRIVER: =%

if "%AMDDRIVER%" EQU " =" cls & goto INVALID_AMD
if "%AMDDRIVER%" EQU "=" cls & goto INVALID_AMD

for %%i in (skip SKIP 20.4.2 20.8.3 21.10.2 22.2.2 22.6.1 0) do (
    if %AMDDRIVER% EQU %%i (
		cls & goto RADEON_SOFTWARE
	)
)

:INVALID_AMD
cls
echo Invalid input
echo(
goto AMDDRIVER

:RADEON_SOFTWARE
cls
echo Would you like to install the Radeon Software (control panel)?
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto AMD_NOPANEL
)
if errorlevel 1 (
	cls & goto AMD_PANEL
)

:AMD_NOPANEL
cls
echo Downloading %AMDDRIVER%
echo(
if %AMDDRIVER% EQU 20.4.2 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-20-4-2" https://drivers.amd.com/drivers/win10-radeon-software-adrenalin-2020-edition-20.4.2-may25.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% EQU 20.8.3 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-20-8-3" https://drivers.amd.com/drivers/beta/win10-radeon-software-adrenalin-2020-edition-20.8.3-sep8.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% EQU 21.10.2 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-21-10-2" https://drivers.amd.com/drivers/radeon-software-adrenalin-2020-21.10.2-win10-win11-64bit-oct25.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% EQU 22.2.2 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-22-2-2"  https://drivers.amd.com/drivers/non-whql-radeon-software-adrenalin-2020-22.2.2-win10-win11-64bit-feb.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% EQU 22.6.1 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-22-6-1"  https://drivers.amd.com/drivers/WHQL-AMD-Software-Adrenalin-Edition-22.6.1-Win10-Win11-June29.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% 0 (
	cls & goto WEBCAM
)
cls
cls & echo Extracting driver...
7z.exe x -y -o"%temp%\%AMDDRIVER%" "%temp%\%AMDDRIVER%.zip" > NUL 2>&1
cls & echo Debloating driver...
rd /s /q "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\amdlog" > NUL 2>&1
rd /s /q "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\amdfendr" > NUL 2>&1
rd /s /q "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\amdxe" > NUL 2>&1
rd /s /q "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\amdafd" > NUL 2>&1
:: INSTALL DRIVER
cls & echo Installing %AMDDRIVER%... This may take a few minutes be patient.
echo(
pnputil /add-driver "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\*.inf" /install

cls & goto AMD_TWEAK

:AMD_PANEL
cls
echo Downloading %AMDDRIVER%
echo(
if %AMDDRIVER% EQU 20.4.2 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-20-4-2" https://drivers.amd.com/drivers/win10-radeon-software-adrenalin-2020-edition-20.4.2-may25.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% EQU 20.8.3 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-20-8-3" https://drivers.amd.com/drivers/beta/win10-radeon-software-adrenalin-2020-edition-20.8.3-sep8.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% EQU 21.10.2 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-21-10-2" https://drivers.amd.com/drivers/radeon-software-adrenalin-2020-21.10.2-win10-win11-64bit-oct25.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% EQU 22.2.2 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-22-2-2"  https://drivers.amd.com/drivers/non-whql-radeon-software-adrenalin-2020-22.2.2-win10-win11-64bit-feb.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
if %AMDDRIVER% EQU 22.6.1 (
	curl -L -H "Referer: https://www.amd.com/en/support/kb/release-notes/rn-rad-win-22-6-1"  https://drivers.amd.com/drivers/WHQL-AMD-Software-Adrenalin-Edition-22.6.1-Win10-Win11-June29.exe -o "%temp%\%AMDDRIVER%.zip" --progress-bar
)
cls
cls & echo Extracting driver...
7z.exe x -y -o"%temp%\%AMDDRIVER%" "%temp%\%AMDDRIVER%.zip" > NUL 2>&1
cls & echo Debloating driver...
rd /s /q "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\amdlog" > NUL 2>&1
rd /s /q "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\amdfendr" > NUL 2>&1
rd /s /q "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\amdxe" > NUL 2>&1
rd /s /q "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\amdafd" > NUL 2>&1
:: INSTALL DRIVER
cls & echo Installing %AMDDRIVER%... This may take a few minutes be patient.
echo(
pnputil /add-driver "%temp%\%AMDDRIVER%\Packages\Drivers\Display\WT6A_INF\*.inf" /install

if %RADEON_SOFTWARE% EQU TRUE (
	for /f %%a in ('dir /b "!temp!\!AMDDRIVER!\Packages\Drivers\Display\WT6A_INF\B3*"') do (
		if exist "!temp!\!AMDDRIVER!\Packages\Drivers\Display\WT6A_INF\%%a\ccc2_install.exe" (
			7z.exe x -y -o"!temp!\!AMDDRIVER!_RADEONPANEL" "!temp!\!AMDDRIVER!\Packages\Drivers\Display\WT6A_INF\%%a\ccc2_install.exe" > NUL 2>&1
			"!temp!\!AMDDRIVER!_RADEONPANEL\CN\cnext\cnext64\ccc-next64.msi" /quiet /norestart
		) ELSE (
			>> !log! echo(
			>> !log! echo !date! !time! - AMD Contol panel installation failed.
		)
	)
)
cls & goto AMD_TWEAK

:AMD_TWEAK
cls
echo Would you like to disable powersaving , force max boost core clock frequency and disable thermal throttling within the AMD GPU driver?
echo
echo WARNING: Temperatures may increase and your GPU will not throttle if it exceeds a set temperature (Download either MSI Afterburner to setup a fancurve and or use MorePowerTool to force a specific fanspeed)
echo
echo [1] Yes (highly recommended but ensure you have sufficient cooling/airflow in your case)
echo 
echo [2] No
echo
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto AMD_PRE
)
if errorlevel 1 (
	cls & goto AMD_TWEAK1
)

:AMD_TWEAK1
if exist "C:\Program Files\AMD\CNext\CNext\Radeonsoftware.exe" start "" "C:\Program Files\AMD\CNext\CNext\Radeonsoftware.exe" atlogon
timeout 3 > NUL 2>&1
taskkill /F /IM RadeonSoftware.exe > NUL 2>&1
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do ( 
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableDMACopy" /t REG_DWORD /d "1" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableBlockWrite" /t REG_DWORD /d "0" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "StutterMode" /t REG_DWORD /d "0" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "EnableUlps" /t REG_DWORD /d "0" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d "1" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d "0" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "DisableDrmdmaPowerGating" /t REG_DWORD /d "1" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "KMD_RadeonBoostHotkey" /t REG_DWORD /d "0" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "KMD_ChillHotkey" /t REG_DWORD /d "0" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "KMD_DeLagHotKey" /t REG_DWORD /d "0" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "ShaderCache" /t REG_BINARY /d "3200" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Tessellation_OPTION" /t REG_BINARY /d "3200" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Tessellation" /t REG_BINARY /d "3100" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "VSyncControl" /t REG_BINARY /d "3000" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "TFQ" /t REG_BINARY /d "3200" /f > NUL 2>&1
			Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "KMD_EnableComputePreemption" /t REG_DWORD /d "0" /f > NUL 2>&1
)
Reg.exe add "HKCU\SOFTWARE\AMD\DVR" /v "DvrEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\DVR" /v "PrevInstantReplayEnable" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\DVR" /v "PrevInGameReplayEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\DVR" /v "PrevInstantGifEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\DVR" /v "ToggleRsPerfRecordingHotkey" /t REG_SZ /d "None" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\CN" /v "SystemTray" /t REG_SZ /d "false" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\CN" /v "AllowWebContent" /t REG_SZ /d "false" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\CN" /v "CN_Hide_Toast_Notification" /t REG_SZ /d "true" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\CN" /v "AnimationEffect" /t REG_SZ /d "false" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\CN" /v "UA_Pref" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\CN" /v "AutoUpdate" /t REG_DWORD /d "0" /f > NUL 2>&1
Reg.exe add "HKCU\SOFTWARE\AMD\CN\Performance" /v "HideMetricswhileRecordingMetrics" /t REG_DWORD /d "0" /f > NUL 2>&1
cls & goto AMD_PRERENDERED_FRAMES

:AMD_PRERENDERED_FRAMES
cls
echo How high should the amount of pre-rendered frames be set to?
echo
echo WARNING: This setting requires testing, the recommended value for most people is 1~ however it can also negatively impact performance, even if you have a high end system you might still occur into some stutters, it can be changed in the POST-Setup folder incase needed.
echo
echo [press 1] 0
echo 
echo [press 2] 1
echo 
echo [press 3] 2
echo 
echo [press 4] 3 (default)
echo
choice /c:1234 /n > NUL 2>&1
if errorlevel 4 (
	cls & goto AMD_PRERENDERED_FRAMES_4
)
if errorlevel 3 (
	cls & goto AMD_PRERENDERED_FRAMES_3
)
if errorlevel 2 (
	cls & goto AMD_PRERENDERED_FRAMES_2
)
if errorlevel 1 (
	cls & goto AMD_PRERENDERED_FRAMES_1
)

:AMD_PRERENDERED_FRAMES_1
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "KMD_DeLagEnabled" /t REG_DWORD /d "1" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Main3D_DEF" /t REG_SZ /d "0" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Main3D" /t REG_BINARY /d "3000" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3000" /f > NUL 2>&1
			)
cls & goto WEBCAM
:AMD_PRERENDERED_FRAMES_2
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "KMD_DeLagEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Main3D_DEF" /t REG_SZ /d "1" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Main3D" /t REG_BINARY /d "3100" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3100" /f > NUL 2>&1
			)
cls & goto WEBCAM
:AMD_PRERENDERED_FRAMES_3
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "KMD_DeLagEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Main3D_DEF" /t REG_SZ /d "2" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Main3D" /t REG_BINARY /d "3200" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3200" /f > NUL 2>&1
			)
cls & goto WEBCAM
:AMD_PRERENDERED_FRAMES_4
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do (
	for /f "tokens=3" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\%%i" /v "Driver"') do (
		for /f %%i in ('echo %%a ^| findstr "{"') do (
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i" /v "KMD_DeLagEnabled" /t REG_DWORD /d "0" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Main3D_DEF" /t REG_SZ /d "3" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "Main3D" /t REG_BINARY /d "3300" /f > NUL 2>&1
				Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Class\%%i\UMD" /v "FlipQueueSize" /t REG_BINARY /d "3300" /f > NUL 2>&1
			)
cls & goto WEBCAM

:WEBCAM
cls & echo [3/%QC%] Will you be using a webcam?
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto WEBCAM-DISABLE
)
if errorlevel 1 (
	cls & goto MSSMBIOS
)

:WEBCAM-DISABLE
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\swenum" /v "Start" /t REG_DWORD /d "4" /f
"%windir%\Modules\devmanview.exe" /disable "Plug and Play Software Device Enumerator" > NUL 2>&1
cls & goto MSSMBIOS

:MSSMBIOS
echo [3/%QC%] Does your game require the mssmbios driver to be enabled?
echo(
echo Select Yes if you play:
echo(
echo GTA
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto EPICGAMES
)
if errorlevel 1 (
	cls & goto MSSMBIOS-ENABLE
)

:MSSMBIOS-ENABLE
cls
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\mssmbios" /v "Start" /t REG_DWORD /d "1" /f > NUL 2>&1
"%windir%\Modules\devmanview.exe" /enable "Microsoft System Management BIOS Driver" > NUL 2>&1
cls & goto EPICGAMES

:EPICGAMES
echo [4/%QC%] Install Epicgames?
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto STEAM
)
if errorlevel 1 (
	cls & goto INSTALL_EPICGAMES
)

:INSTALL_EPICGAMES
echo Installing EpicGames
echo(
curl -L "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi" -o "%temp%\EpicGames.msi" --progress-bar
"%temp%\EpicGames.msi" /qn /norestart ALLUSERS=2 /L* "%temp%\Epic Games Launcher 1.1.195.0.log"
del /f /q "%temp%\EpicGames.msi" > NUL 2>&1
Reg.exe delete "HKLM\System\ControlSet001\Services\EpicOnlineServices" /f > NUL 2>&1
echo(
cls & goto STEAM

:STEAM
echo [5/%QC%] Install Steam?
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto RIOTGAMES
)
if errorlevel 1 (
	cls & goto INSTALL_STEAM
)

:INSTALL_STEAM
echo(
echo Installing Steam
echo(
curl -L "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe" -o "%temp%\Steam.exe" --progress-bar
"%temp%\Steam.exe" /S
del /f /q "%temp%\Steam.exe" > NUL 2>&1
Reg.exe DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Steam" /f >NUL 2>&1
echo(
cls & goto RIOTGAMES

:RIOTGAMES
echo [6/%QC%] Install Valorant (This will also install the RiotGames client where you can install all other Riotgames')
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto SPOTIFY
)
if errorlevel 1 (
	cls & goto INSTALL_RIOTGAMES
	
:INSTALL_RIOTGAMES
echo(
echo Installing RiotGames
echo(
curl -L "https://valorant.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.eu.exe" -o "%userprofile%\Desktop\Valorant.exe" --progress-bar
echo(
cls & goto SPOTIFY

:SPOTIFY
echo [7/%QC%] Install Spotify. This is a old spotify version, some newer features might be lacking however it is to ensure that the spotify is useable?
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto OBS
)
if errorlevel 1 (
	cls & goto INSTALL_SPOTIFY
)

:INSTALL_SPOTIFY
echo Installing Spotify
echo(
curl -L "https://shorturl.at/nrY38" -o "%temp%\Spotify.exe" --progress-bar
"%temp%\Spotify.exe" /S
del /f /q "%temp%\Spotify.exe" > NUL 2>&1
taskkill /f /im spotify.exe
echo(
echo Removing automatic updates from spotify
icacls "%localappdata%\Spotify\Update" /reset /T > NUL 2>&1
del /s /q "%localappdata%\Spotify\Update" > NUL 2>&1
mkdir "%localappdata%\Spotify\Update" > NUL 2>&1
icacls "%localappdata%\Spotify\Update" /deny "%username%":W > NUL 2>&1
del "%appdata%\Spotify\SpotifyMigrator.exe" > NUL
del "%appdata%\Spotify\SpotifyStartupTask.exe" > NUL
powershell -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%userprofile%\Desktop\Spotify.lnk'); $S.TargetPath = '%appdata%\Spotify\Spotify.exe'; $S.Save()" > NUL 2>&1
cls & goto SPOTIFY_DEBLOAT

:SPOTIFY_DEBLOAT
echo Do you want to debloat spotify. Some functionality stuff might be removed when debloating apps.
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto MSIAFTERBURNER
)
if errorlevel 1 (
	cls & goto SPOTIFY_DEBLOAT1
)

:SPOTIFY_DEBLOAT1
taskkill /f /im spotify.exe
Reg.exe DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Spotify" /f >NUL 2>&1
del /f /s /q "%appdata%\Spotify\SpotifyMigrator.exe" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\SpotifyStartupTask.exe" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Buddy-list.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Concert.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Concerts.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Error.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Findfriends.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Legacy-lyrics.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Lyrics.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Show.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\Apps\Buddy-list.spa" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\am.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ar.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ar.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\bg.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\bn.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ca.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\cs.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\cs.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\da.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\de.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\de.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\el.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\el.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\en-GB.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\en-GB.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\es.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\es.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\es-419.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ca.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\es-419.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\et.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fa.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fi.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fi.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fil.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fr.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fr.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fr-CA.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\af.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\bn.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fa.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\is.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\mr.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pa-PK.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sr.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\zh-CN.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\am.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\da.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\fil.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\kn.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\nb.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pt-PT.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sw.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\zu.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\az.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\gu.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\lt.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\it.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ne.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ro.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ta.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\bg.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\hi.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\lv.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\iv.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\or.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sk.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\te.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\bho.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\et.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\hr.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ml.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\mi.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pa-IN.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pa-LN.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sl.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\si.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ur.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\kn.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\gu.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\he.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\he.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\hi.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\hr.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\hu.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\hu.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\id.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\id.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\it.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\it.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ja.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ja.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\kn.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ko.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ko.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\lt.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\lv.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ml.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\mr.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ms.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ms.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\nb.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\nl.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\nl.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pl.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pl.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pt-PT.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pt-BR.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\pt-BR.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\zh-TW.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\uk.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ro.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ru.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ru.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sk.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sl.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sr.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sv.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sv.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\sw.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\ta.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\te.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\th.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\th.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\tr.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\tr.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\uk.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\vi.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\vi.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\zh-CN.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\zh-Hant.mo" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\locales\zh-TW.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\libEGL.dll" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\libGLESv2.dll" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\chrome_100_percent.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\chrome_200_percent.pak" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\crash_reporter.cfg" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\d3dcompiler_47.dll" >NUL 2>&1
del /f /s /q "%appdata%\Spotify\snapshot_blob.bin" >NUL 2>&1
cls & goto MSIAFTERBURNER

:MSIAFTERBURNER
echo [8/%QC%] Install MSIAfterburner?
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto OBS
)
if errorlevel 1 (
	cls & goto INSTALL_MSIAFTERBURNER
)

:INSTALL_MSIAFTERBURNER
echo Installing MSIAfterburner
echo(
curl -L "https://shorturl.at/klCQ9" -o "%temp%\MSIAfterburner.zip" --progress-bar
7z.exe x -y -o"%temp%\MSIAfterburner" "%temp%\MSIAfterburner.zip" > NUL 2>&1
"%temp%\MSIAfterburner\MSIAfterburnerSetup465.exe" /S
echo(
cls & goto OBS

:OBS
echo [9/%QC%] Install OBS
echo(
echo [1] Old-OBS Version
echo( 
echo [2] New-OBS Version (Latest version)
echo(
echo [3] NONE
choice /c:123 /n > NUL 2>&1
if errorlevel 3 (
	cls & goto DISCORD
)
if errorlevel 2 (
	cls & goto OBS-NEW
)
if errorlevel 1 (
	cls & goto OBS-OLD
)

:OLD-OBS


:NEW-OBS


:DISCORD
echo [9/%QC%] Install Discord?
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto SOFTWARES
)
if errorlevel 1 (
	cls & goto INSTALL_DISCORD
)

:INSTALL_DISCORD
echo(
@echo off
echo Installing discord... Do not interact with the discord window!
curl -L "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x86" -o "%temp%\Discord.exe" --progress-bar
"%temp%\Discord.exe"
wscript "%windir%\Modules\FullscreenCMD.vbs"
wscript "%windir%\Modules\FullscreenCMD.vbs"
timeout /t 1
wscript "%windir%\Modules\FullscreenCMD.vbs"
wscript "%windir%\Modules\FullscreenCMD.vbs"
timeout /t 1
wscript "%windir%\Modules\FullscreenCMD.vbs"
wscript "%windir%\Modules\FullscreenCMD.vbs"
timeout /t 13
taskkill /f /im discord.exe
cls & goto DEBLOAT_DISCORD

:DEBLOAT_DISCORD
echo Do you wish to debloat discord. Some functionality sided things of discord might be negatively impacted, reinstalling discord will revert. 
echo(
echo The script might not always be updated due to discord updating from time to time.
echo(
echo [1] Yes
echo( 
echo [2] No
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto SOFTWARES
)
if errorlevel 1 (
	cls & goto DEBLOAT_DISCORD1
)

:DEBLOAT_DISCORD1
set discordver=1.0.9013
echo.
if not exist "%userprofile%\AppData\Local\Discord" (
	echo Discord is not installed!
	exit /b
)

for %%a in ("%userprofile%\AppData\Local\Discord\app-*") do (
	if not exist "%userprofile%\AppData\Local\Discord\app-%%a\modules" (
		echo ERROR: can not find discord install path.
		exit /b
	)
)
taskkill /F /IM Discord.exe > NUL 2>&1
echo Debloating Discord...

del /f /q "%userprofile%\AppData\Local\Discord\Update.exe" > NUL 2>&1
del /f /q "%userprofile%\AppData\Local\Discord\SquirrelSetup.log" > NUL 2>&1
del /f /q "%userprofile%\AppData\Local\Discord\Discord_updater_rCURRENT.log" > NUL 2>&1
rd /s /q "%userprofile%\AppData\Local\Discord\packages" > NUL 2>&1
rd /s /q "%userprofile%\AppData\Local\Discord\download" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_cloudsync-1" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_erlpack-1" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_spellcheck-1" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_game_utils-1" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_krisp-1" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_overlay1-1" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_overlay1-2" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_overlay2-1" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_overlay2-2" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_rpc-1" > NUL 2>&1
RD /s /q "%userprofile%\AppData\Local\Discord\app-%discordver%\modules\discord_spellcheck-2" > NUL 2>&1

del /f /q "%userprofile%\Desktop\Discord.lnk" > NUL 2>&1

set TARGET='%userprofile%\AppData\Local\Discord\app-%discordver%\Discord.exe'
set SHORTCUT='%userprofile%\Desktop\Discord.lnk'
set PWS=powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile

%PWS% -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut(%SHORTCUT%); $S.TargetPath = %TARGET%; $S.Save()"
echo(
cls
:SOFTWARES
cls & echo Is there any mouse / keyboard softwares thats required for your personal use. (Keep in mind, try to keep the install the least bloated that it can be)
echo(
echo [1] Logitech
echo( 
echo [2] Steelseries GG
echo(
echo [3] Razer
echo(
echo [4] Wootility
echo(
echo [5] Continue without downloading any softwares
choice /c:12345 /n > NUL 2>&1
if errorlevel 5 (
	cls & goto TWEAK
)
if errorlevel 4 (
	cls & goto Wootility
)
if errorlevel 3 (
	cls & goto Razer
)
if errorlevel 2 (
	cls & goto Steelseries-GG
)
if errorlevel 1 (
	cls & goto Logitech
)

:LOGITECH
echo Is there any mouse / keyboard softwares thats required for your personal use. (Keep in mind, try to keep the install the least bloated that it can be)
echo(
echo [1] Logitech G Hub (Download this if multiple devices needs configuration i.e, not just your mouse but also audio peripherals)
echo( 
echo [2] Logitech Onboard Memory Manager (Recommended to use if Mouse is the only thing that needs configured)
echo(
choice /c:12 /n > NUL 2>&1
)
if errorlevel 2 (
cls & goto LOMM
)
if errorlevel 1 (
cls & goto LGHUB
)

:LOMM
echo Installing Logitech Onboard Memory Manager
echo(
curl -L "https://download01.logi.com/web/ftp/pub/techsupport/gaming/OnboardMemoryManager.exe" -o "%userprofile%\Desktop\OnboardMemoryManager.exe" --progress-bar
echo(
cls & goto SOFTWARES2

:LGHUB
echo Installing Logitech G Hub
echo(
curl -L "https://shorturl.at/hmoCF" -o "%temp%\LGHUB.exe" --progress-bar
"%temp%\LGHUB.exe" --silent
del /f /q "%temp%\LGHUB.exe" > NUL 2>&1
echo(
cls & goto SOFTWARES2

:Steelseries-GG
echo Installing Steelseries GG (There is no silent switch for Steelseries-GG, a shortcut has been created on the desktop to manually install it after)
echo(
curl -L https://steelseries.com/gg/downloads/gg/latest/windows -o "%userprofile%\Desktop\SteelseriesSetup.exe" --progress-bar
cls & goto SOFTWARES2

:Wootility
echo Installing Wootility (There is no silent switch for Wootility, a shortcut has been created on the desktop to manually install it after)
echo(
curl -L "https://api.wooting.io/public/wootility/download?os=win&branch=lekker" -o "%userprofile%\Desktop\WootilitySetup.exe" --progress-bar
cls & goto SOFTWARES2

:RAZER
echo Installing Razer Synapse 3.0 (There is no silent switch for Razer Synapse, a shortcut has been created on the desktop to manually install it after)
echo(
curl -L "https://rzr.to/synapse-3-pc-download" -o "%userprofile%\Desktop\RAZERSetup.exe" --progress-bar
cls & goto SOFTWARES2

:SOFTWARES2
echo Do you wish to download further more softwares, i.e go back to the software tab or continue. 
echo(
echo [1] Back to software tab
echo( 
echo [2] Continue
echo(
choice /c:12 /n > NUL 2>&1
if errorlevel 2 (
	cls & goto BROWSER
)
if errorlevel 1 (
	cls & goto SOFTWARES
)

:BROWSER
cls
echo What browser should be installed?
echo(
echo [1] Google Chrome
echo(
echo [2] Firefox
echo(
echo [3] Brave
echo(
echo [4] OperaGX
choice /c:1234 /n > NUL 2>&1
if errorlevel 4 (
	cls & goto OPERAGX
)
if errorlevel 3 (
	cls & goto BRAVE
)
if errorlevel 2 (
	cls & goto FIREFOX
)
if errorlevel 1 (
	cls & goto GOOGLECHROME
)

:GOOGLECHROME
cd "C:\Browser\Chrome"
ChromeSetup.exe /silent /install

net stop gupdate
sc delete gupdate
net stop googlechromeelevationservice
sc delete googlechromeelevationservice
net stop gupdatem
sc delete gupdatem
rmdir /s /q "C:\Program Files (x86)\Google\Temp"
C:\Program Files (x86)\Google
taskkill /f /im "GoogleUpdate.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateSetup.exe" >nul 2>&1
taskkill /f /im "GoogleCrashHandler.exe" >nul 2>&1
taskkill /f /im "GoogleCrashHandler64.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateBroker.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateCore.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateOnDemand.exe" >nul 2>&1
taskkill /f /im "GoogleUpdateComRegisterShell64.exe" >nul 2>&1 
rmdir "C:\Program Files (x86)\Google\Update" /s /q
rmdir /s /q "C:\Program Files\Google\GoogleUpdater" /s /q
cd /d "C:\Program Files\Google\Chrome\Application\"
if exist C:\Program Files\Google\Chrome\Application\chrmstp.exe takeown /F C:\Program Files\Google\Chrome\Application\chrmstp.exe /R /A & icacls C:\Program Files\Google\Chrome\Application\chrmstp.exe /grant Administrators:(F) /T
dir chrmstp.exe /a /b /s
del chrmstp.exe /a /s
schtasks /delete /f /tn GoogleUpdateTaskMachineUA{179D918B-9BE9-4D1B-9FA2-D0B2D2491030} >nul 2>&1
schtasks /delete /f /tn GoogleUpdateTaskMachineCore{A0256FF4-D45E-420B-90B3-7D05AF116614} >nul 2>&1
reg delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{950E9395-8BFF-4D96-8731-A3BD3F3C3ABD}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{8EB03C8D-6422-494A-A237-B87232D89A24}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8EB03C8D-6422-494A-A237-B87232D89A24}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{950E9395-8BFF-4D96-8731-A3BD3F3C3ABD}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineCore" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineUA" /f >nul 2>&1
cls & goto TWEAK

:FIREFOX
curl -L "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-GB" -o "%temp%\Firefox Setup.exe" --progress-bar
cls & echo Debloating firefox...
7z.exe x -y -o"%temp%\Firefox Setup" "%temp%\Firefox Setup.exe" > NUL 2>&1
for %%a in (crashreporter.exe crashreporter.ini maintenanceservice.exe maintenanceservice_installer.exe minidump-analyzer.exe pingsender.exe updater.exe) do (
	del /f /q "%temp%\Firefox Setup\core\%%a" > NUL 2>&1
)
cls & echo Installing firefox...
if exist "C:\Program Files\Mozilla Firefox" rd /s /q "C:\Program Files\Mozilla Firefox" > NUL 2>&1
move /y "%temp%\Firefox Setup\core" "C:\Program Files" & ren "C:\Program Files\core" "Mozilla Firefox"
Reg.exe add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableAppUpdate" /t REG_DWORD /d "1" /f > NUL 2>&1
"C:\Program Files\Mozilla Firefox\uninstall\helper.exe" /SetAsDefaultAppGlobal
rd /s /q "C:\Program Files\Mozilla Firefox\uninstall" > NUL 2>&1

taskkill /f /im maintenanceservice.exe
taskkill /f /im uninstall.exe
net stop MozillaMaintenance
sc delete MozillaMaintenance
rmdir "C:\Program Files (x86)\Mozilla Maintenance Service" /s /q
del /f "C:\Program Files\Mozilla Firefox\maintenanceservice_installer.exe"
del /f "C:\Program Files\Mozilla Firefox\maintenanceservice.exe"
del /f "C:\Program Files\Mozilla Firefox\updater.exe"
del /f "C:\Program Files\Mozilla Firefox\crashreporter.exe"
del /f "C:\Program Files\Mozilla Firefox\maintenanceservice.exe"
del /f "C:\Program Files\Mozilla Firefox\maintenanceservice_installer.exe"
del /f "C:\Program Files\Mozilla Firefox\minidump-analyzer.exe"
del /f "C:\Program Files\Mozilla Firefox\pingsender.exe"
cls & goto TWEAK

:BRAVE
cd "C:\Browser\Brave"

start brave_installer-x64.exe --install --silent

taskkill /f /im "BraveUpdate.exe" >nul 2>&1
taskkill /f /im "brave_installer-x64.exe" >nul 2>&1
taskkill /f /im "BraveCrashHandler.exe" >nul 2>&1
taskkill /f /im "BraveCrashHandler64.exe" >nul 2>&1
taskkill /f /im "BraveCrashHandlerArm64.exe" >nul 2>&1
taskkill /f /im "BraveUpdateBroker.exe" >nul 2>&1
taskkill /f /im "BraveUpdateCore.exe" >nul 2>&1
taskkill /f /im "BraveUpdateOnDemand.exe" >nul 2>&1
taskkill /f /im "BraveUpdateSetup.exe" >nul 2>&1
taskkill /f /im "BraveUpdateComRegisterShell64" >nul 2>&1
taskkill /f /im "BraveUpdateComRegisterShellArm64" >nul 2>&1
sc stop brave
sc stop bravem
sc delete brave >nul 2>&1
sc delete bravem >nul 2>&1
sc delete BraveElevationService >nul 2>&1
rmdir /s /q "C:\Program Files (x86)\BraveSoftware\Update" /s /q >nul 2>&1

schtasks /delete /f /tn BraveSoftwareUpdateTaskMachineCore{2320C90E-9617-4C25-88E0-CC10B8F3B6BB} >nul 2>&1
schtasks /delete /f /tn BraveSoftwareUpdateTaskMachineUA{FD1FD78D-BD51-4A16-9F47-EE6518C2D038} >nul 2>&1
reg delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{AFE6A462-C574-4B8A-AF43-4CC60DF4563B}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{56CA197F-543C-40DC-953C-B9C6196C92A5}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{0948A341-8E1E-479F-A667-6169E4D5CB2A}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0948A341-8E1E-479F-A667-6169E4D5CB2A}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{56CA197F-543C-40DC-953C-B9C6196C92A5}" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\BraveSoftwareUpdateTaskMachineCore" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\BraveSoftwareUpdateTaskMachineUA" /f >nul 2>&1
cls & goto TWEAK

:OPERAGX
curl -L "https://net.geo.opera.com/opera_gx/stable/windows" -o "%temp%\Firefox Setup.exe" --progress-bar
OperaGXSetup.exe /silent /allusers=1 /launchopera=0 /setdefaultbrowser=0
cls & goto TWEAK

:TWEAK
cls
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /format:value') do set /a RAM=%%i + 100000
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "%RAM%" /f > NUL 2>&1

echo(
cls & echo Setting all device's priority to undefined...
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI"^| findstr "HKEY"') do (
			for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe delete "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f > NUL 2>&1
		)
	)
	
cls & echo DISABLING HIPM, DIPM, HDDPARKING
for %%a in (EnableHIPM EnableDIPM EnableHDDParking) do for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%a" ^| findstr "HKEY"') do reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f > NUL 2>&1

cls & echo DISABLE INTEL DRIVERS ON AMD SYSTEMS AND VICE VERSA
for /F "tokens=* skip=1" %%n in ('wmic cpu get Manufacturer ^| findstr "."') do set CPUManufacturer=%%n
if %CPUManufacturer% EQU AuthenticAMD (
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iagpio" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iai2c" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iaLPSS2i_GPIO2" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iaLPSS2i_GPIO2_BXT_P" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iaLPSS2i_I2C" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iaLPSS2i_I2C_BXT_P" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iaLPSSi_GPIO" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iaLPSSi_I2C" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iaStorAVC" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\iaStorV" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\intelide" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\intelpep" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\intelppm" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
)

if %CPUManufacturer% EQU GenuineIntel (
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\AmdK8" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\AmdPPM" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\amdsata" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\amdsbs" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
	PowerRun.exe /SW:0 reg.exe add "HKLM\System\CurrentControlSet\Services\amdxata" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
)

cls & echo "Enabling MSI mode & Setting all devices to undefined!"
::
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID^| findstr /l "PCI\VEN_"') do Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /l "PCI\VEN_"') do Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /l "PCI\VEN_"') do Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /l "PCI\VEN_"') do Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f >nul 2>&1
for /f %%i in ('wmic path Win32_SoundDevice get PNPDeviceID^| findstr /l "PCI\VEN_"') do Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "0" /f >nul 2>&1
for /f "tokens=*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\PCI"^| findstr "HKEY"') do (
			for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do Reg.exe delete "%%a\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f > NUL 2>&1
		)
)

cls & echo Removing Rivatuner
RD /s /q "C:\Program Files (x86)\RivaTuner Statistics Server" > NUL 2>&1
RD /s /q "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\RivaTuner Statistics Server"  > NUL 2>&1

cls & echo CONFIGURING AUTORUNS
Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{AFE6A462-C574-4B8A-AF43-4CC60DF4563B}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{29D03007-F8B1-4E12-ACAF-5C16C640D894}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{834F4B4B-2375-46D7-AB12-546EF47FC46F}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{8B76D8B3-FDFD-4A7D-B89A-C0787A05BE76}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{CFDB528C-406A-4C14-9533-64C65AA183BB}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{06C2AEAE-A87D-43BA-B84E-AE7E4A11C897}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{06C2AEAE-A87D-43BA-B84E-AE7E4A11C897}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{29D03007-F8B1-4E12-ACAF-5C16C640D894}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{834F4B4B-2375-46D7-AB12-546EF47FC46F}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8B76D8B3-FDFD-4A7D-B89A-C0787A05BE76}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{CFDB528C-406A-4C14-9533-64C65AA183BB}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\AMDInstallUEP" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineCore" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineUA" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\StartCN" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\StartDVR" /f > NUL 2>&1
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Terminal Server\Wds\rdpwd" /v "StartupPrograms" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "DeleteFlag" /t REG_DWORD /d "1" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{89B4C1CD-B018-4511-B0A1-5476DBF70820}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Open-Shell Start Menu" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\WOW6432Node\Microsoft\Active Setup\Installed Components\{89B4C1CD-B018-4511-B0A1-5476DBF70820}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{0E76D7E3-DA81-46BD-A750-C06B6B660CB4}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0E76D7E3-DA81-46BD-A750-C06B6B660CB4}" /f > NUL 2>&1
Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Background Update 308046B0AF4A39CB" /f > NUL 2>&1
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64win" /f > NUL 2>&1
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wowarmhw" /f > NUL 2>&1
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64" /f > NUL 2>&1
Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64cpu" /f > NUL 2>&1
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SppExtComObj.exe" /f > NUL 2>&1
Reg.exe delete "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{9459C573-B17A-45AE-9F64-1857B5D58CEE}" /f > NUL 2>&1
schtasks /delete /tn * /f
sc delete FvSvc
sc delete "Steam Client Service"

cls & echo CONFIGURING AUTORUNS WITH TRUSTEDINSTALLER
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{8A69D345-D564-463c-AFF1-A69D9E530F96}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{AFE6A462-C574-4B8A-AF43-4CC60DF4563B}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{29D03007-F8B1-4E12-ACAF-5C16C640D894}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{834F4B4B-2375-46D7-AB12-546EF47FC46F}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{8B76D8B3-FDFD-4A7D-B89A-C0787A05BE76}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Logon\{CFDB528C-406A-4C14-9533-64C65AA183BB}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{06C2AEAE-A87D-43BA-B84E-AE7E4A11C897}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{06C2AEAE-A87D-43BA-B84E-AE7E4A11C897}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{29D03007-F8B1-4E12-ACAF-5C16C640D894}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{834F4B4B-2375-46D7-AB12-546EF47FC46F}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8B76D8B3-FDFD-4A7D-B89A-C0787A05BE76}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{CFDB528C-406A-4C14-9533-64C65AA183BB}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\AMDInstallUEP" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineCore" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\GoogleUpdateTaskMachineUA" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\StartCN" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\StartDVR" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Terminal Server\Wds\rdpwd" /v "StartupPrograms" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\System\CurrentControlSet\Services\AMD External Events Utility" /v "DeleteFlag" /t REG_DWORD /d "1" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Active Setup\Installed Components\{89B4C1CD-B018-4511-B0A1-5476DBF70820}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /v "Open-Shell Start Menu" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\WOW6432Node\Microsoft\Active Setup\Installed Components\{89B4C1CD-B018-4511-B0A1-5476DBF70820}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain\{0E76D7E3-DA81-46BD-A750-C06B6B660CB4}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0E76D7E3-DA81-46BD-A750-C06B6B660CB4}" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla\Firefox Background Update 308046B0AF4A39CB" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64win" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wowarmhw" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\System\CurrentControlSet\Control\Session Manager\KnownDLLs" /v "_wow64cpu" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SppExtComObj.exe" /f > NUL 2>&1
PowerRun.exe /SW:0 Reg.exe delete "HKLM\SOFTWARE\Microsoft\Active Setup\Installed Components\{9459C573-B17A-45AE-9F64-1857B5D58CEE}" /f > NUL 2>&1

cls & echo Disabling scheduled tasks...
for %%i in (
	"\Microsoft\Windows\Application Experience\StartupAppTask"
	"\Microsoft\Windows\Autochk\Proxy"
	"\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
	"\Microsoft\Windows\Chkdsk\ProactiveScan"
	"\Microsoft\Windows\Chkdsk\SyspartRepair"
	"\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan"
	"\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery"
	"\Microsoft\Windows\Defrag\ScheduledDefrag"
	"\Microsoft\Windows\DiskCleanup\SilentCleanup"
	"\Microsoft\Windows\DiskFootPrint\Diagnostics"
	"\Microsoft\Windows\DiskFootPrint\StorageSense"
	"\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation"
	"\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
	"\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
	"\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
	"\Microsoft\Windows\Registry\RegIdleBackup"
	"\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
	"\Microsoft\Windows\Time Synchronization\SynchronizeTime"
	"\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
	"\Microsoft\Windows\UpdateOrchestrator\Reboot"
	"\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
	"\Microsoft\Windows\UpdateOrchestrator\USO_Broker_Display"
	"\Microsoft\Windows\UPnP\UPnPHostConfig"
	"\Microsoft\Windows\User Profile Service\HiveUploadTask"
	"\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
	"\Microsoft\Windows\WindowsUpdate\Scheduled Start"
	"\Microsoft\Windows\WindowsUpdate\sih"
	"\Microsoft\Windows\Wininet\CacheTask"
) do (
	Schtasks.exe /Change /Disable /TN %%i > NUL 2>&1
	Powerrun.exe /SW:0 schtasks.exe /Change /Disable /TN %%i
)

cls & echo Removing GHUB Bloat if GHUB were installed.
Reg.exe DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "LGHUB" /f >NUL 2>&1
Reg.exe DELETE "HKLM\SYSTEM\CurrentControlSet\Services" /v "logi_joy_vir_hid" /f >NUL 2>&1
sc delete logi_joy_vir_hid
sc delete logi_joy_xlcore
devmanview /uninstall "Logitech G HUB Virtual Keyboard"  >nul 2>&1
devmanview /uninstall "Logitech G HUB Virtual Keyboard"  >nul 2>&1
devmanview /uninstall "Logitech G HUB Virtual Keyboard"  >nul 2>&1
devmanview /disable "Logitech G HUB Virtual Mouse"   >nul 2>&1
devmanview /disable "Logitech G HUB Virtual Bus Enumerator"   >nul 2>&1



cls & echo Disabling write cache buffer on all drives...
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do reg.exe add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t REG_DWORD /d "1" /f > NUL 2>&1
	)
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do reg.exe add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t REG_DWORD /d "1" /f > NUL 2>&1
	)
)

cls & echo Removing the rest of nvidia bloat
reg add "HKLM\Software\Nvidia Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /D 0 /f
reg add "HKLM\System\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /D 0 /f
reg add "HKCU\SOFTWARE\NVIDIA Corporation\Global\GFExperience" /v "NotifyNewDisplayUpdates" /t REG_DWORD /D 0 /f

if exist C:\Program Files\Nvidia Corporation\Display.NvContainer\Plugins\LocalSystem\DisplayDriverRAS takeown /F C:\Program Files\Nvidia Corporation\Display.NvContainer\Plugins\LocalSystem\DisplayDriverRAS /R /A & icacls C:\Program Files\Nvidia Corporation\Display.NvContainer\Plugins\LocalSystem\DisplayDriverRAS /grant Administrators:(F) /T

if exist "C:\Program Files\Nvidia Corporation\Display.NvContainer\Plugins\LocalSystem\DisplayDriverRAS" takeown /F "C:\Program Files\Nvidia Corporation\Display.NvContainer\Plugins\LocalSystem\DisplayDriverRAS" /R /A & icacls "C:\Program Files\Nvidia Corporation\Display.NvContainer\Plugins\LocalSystem\DisplayDriverRAS" /grant Administrators:(F) /T

rd /s /q "C:\Program Files\Nvidia Corporation\Display.NvContainer\Plugins\LocalSystem\DisplayDriverRAS"

if exist C:\Program Files\Nvidia Corporation\DisplayDriverRAS takeown /F C:\Program Files\Nvidia Corporation\DisplayDriverRAS /R /A & icacls C:\Program Files\Nvidia Corporation\DisplayDriverRAS /grant Administrators:(F) /T

if exist "C:\Program Files\Nvidia Corporation\DisplayDriverRAS" takeown /F "C:\Program Files\Nvidia Corporation\DisplayDriverRAS" /R /A & icacls "C:\Program Files\Nvidia Corporation\DisplayDriverRAS" /grant Administrators:(F) /T

rd /s /q "C:\Program Files\Nvidia Corporation\DisplayDriverRAS"

if exist C:\ProgramData\Nvidia Corporation\DisplayDriverRAS takeown /F C:\ProgramData\Nvidia Corporation\DisplayDriverRAS /R /A & icacls C:\ProgramData\Nvidia Corporation\DisplayDriverRAS /grant Administrators:(F) /T

if exist "C:\ProgramData\Nvidia Corporation\DisplayDriverRAS" takeown /F "C:\ProgramData\Nvidia Corporation\DisplayDriverRAS" /R /A & icacls "C:\ProgramData\Nvidia Corporation\DisplayDriverRAS" /grant Administrators:(F) /T

rd /s /q "C:\ProgramData\Nvidia Corporation\DisplayDriverRAS"

if exist "C:\Program Files\NVIDIA Corporation\NvTopps\_NvTopps.dll" takeown /F "C:\Program Files\NVIDIA Corporation\NvTopps\_NvTopps.dll" /A & icacls "C:\Program Files\NVIDIA Corporation\NvTopps\_NvTopps.dll" /grant Administrators:(F)

if exist C:\Program Files\NVIDIA Corporation\NvTopps\_NvTopps.dll takeown /F C:\Program Files\NVIDIA Corporation\NvTopps\_NvTopps.dll /A & icacls C:\Program Files\NVIDIA Corporation\NvTopps\_NvTopps.dll /grant Administrators:(F)

del /s /q "C:\Program Files\NVIDIA Corporation\NvTopps\_NvTopps.dll"

"%windir%\devmanview.exe" /disable "@System32\drivers\usbxhci.sys,#1073807361;%1 USB %2 eXtensible Host Controller - %3 (Microsoft);(NVIDIA,3.10,1.10)"

for /f "delims=" %a in ('where /r C:\ *NvTelemetry*') do (if exist "%a" (del /f /q /s "%a"))

for /f "delims=" %a in ('where /r C:\ *DisplayDriverRAS.dll*') do (if exist "%a" (del /f /q /s "%a"))

for /f "delims=" %a in ('where /r C:\ *NvTelemetry.dll*') do (if exist "%a" (del /f /q /s "%a"))

cls & echo Disabling USB Powersavings 1 extra time.
for %%a in (
	EnhancedPowerManagementEnabled
	AllowIdleIrpInD3
	EnableSelectiveSuspend
	DeviceSelectiveSuspended
	SelectiveSuspendEnabled
	SelectiveSuspendOn
	EnumerationRetryCount
	ExtPropDescSemaphore
	WaitWakeEnabled
	D3ColdSupported
	WdfDirectedPowerTransitionEnable
	EnableIdlePowerManagement
	IdleInWorkingState
) do for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%a" ^| findstr "HKEY"') do reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f > NUL 2>&1

cls & echo Disabling preemption
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "0" /f > NUL 2>&1

cls & echo Spectre and meltdown configured
wmic cpu get name | findstr "Intel" >nul && (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d 0 /f
)
wmic cpu get name | findstr "AMD" >nul && (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d 64 /f
)

reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "InactivityShutdownDelay" /t REG_DWORD /d "4294967295" /f

rd /s /q "%temp%" & mkdir "%userprofile%\AppData\Local\Temp"

shutdown -r -t 0 /c "Restarting reb0rnOS"