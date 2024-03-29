@echo off
rem Backup script to backup/restore REAPER AppData
rem Current Version: 1.0
rem This script now uses 7-Zip for some features. 7-Zip is licensed under GNU LGPL license (see 7z-license.txt) - visit www.7-zip.org to view source and download the GUI version of this great program.
rem
rem ***Change Log***
rem ***Add changes here*** Author - changes made - date (MM.DD.YYYY) - start verison # - end version #
rem hwguyturnsw - Initial Release - 04.05.2020 - v0.00a - v0.33a
rem hwguyturnsw - Making Beta Release - 04.05.2020 - v0.33a - v0.34b
rem hwguyturnsw - Fix "mode_set" if statement, add OS test, tab completion test - 10.09.2020 - v0.35b
rem hwguyturnsw - (Issue #3) Fixed version number in welcome statement, added more to the welcome statement - 03.05.2021 - v0.36b
rem hwguyturnsw - (Issue #4) Made script use 7z if the user wants - 08.13.2022 - v1.0
rem
rem ***Update Current Version number when changes made***
rem
rem ***Operating Systems Tested***
rem ***Add OS Tests here*** Tester - OS - Version - (Build #####) - date (MM.DD.YYYY)
rem hwguyturnsw - Windows 10 Pro - Version 1909 - (Build 18363.720) - 04.05.2020
rem hwguyturnsw - Windows 10 Pro - Version 2004 - (Build 19041.508) - 10.09.2020
rem hwguyturnsw - Windows 10 Pro - Version 2004 - (Build 19041.804) - 03.05.2021
rem hwguyturnsw - Windows 10 Pro - Version 21H2 - (Build 19044.1826) - 08.13.2022
rem hwguyturnsw - Windows 10 Pro - Version 22H2 - (Build 19045.2251) - 12.07.2022
rem
rem Initialization of script
:init
echo Welcome to the REAPER backup/restore script
echo v1.0 - Release
echo:
echo This program will backup or restore the REAPER App Data Files from REAPER that contain your Effects, data, FX Chains
echo MIDI note names, presets, templates etc... and yes your REAPER license files (if applicable; and if stored there)
echo:
echo If you are backing up to an area I've already backed up to before then I will only copy files that have changed
echo since the last backup. If the program says I've copied 0 files then no files have changed since the last time I
echo I was used. This saves time in program execution.
echo:
echo You can press ? when I ask you something if you don't understand.
echo:
echo:
set mode_set=
echo Are we backing up or recovering today?
echo 1: Backing up (Folder)
echo 2: Backing up (with 7z)
echo 3: Recovering
echo 4: Recovering (with 7z)
echo 5: I don't know how I got here...
set /p mode_set=
if /i "%mode_set%"=="1" goto go_backup
if /i "%mode_set%"=="2" goto go_backup_7z
if /i "%mode_set%"=="3" goto go_recovery
if /i "%mode_set%"=="4" goto go_recovery_7z
if /i "%mode_set%"=="5" goto go_exit
if /i "%mode_set%"=="?" goto nogo_0
if "%mode_set%" LSS "1" goto error_0
if "%mode_set%" GTR "5" goto error_0

rem Backup start
:go_backup
echo I will need the path in which to backup the files from REAPER in the format of:
echo drive letter:\folder\sub folder\sub folder
echo:
echo Example: E:\
echo Example: F:\My Backups\Studio Work
echo:
echo I can even use network areas to back up to as well!
echo:
echo Example: \\server\share
echo:
echo I will create a folder for the data in the directory you tell me.
echo:
pause
goto get_backup_path

rem I need the backup path and set the variable
:get_backup_path
echo Tell me the path you want to backup to:
set /p backup_path=
echo:
if /i "%backup_path%"=="?" goto nogo_1
rem Check path existance, if not error out
if exist "%backup_path%" goto backup_cmd
if not exist "%backup_path%" goto error_1
rem If path exists go ahead

rem Backup command
:backup_cmd
echo Found it!
set backupcmd=xcopy /s /c /d /e /h /i /r /y
echo ### Backing Up REAPER AppData Files ###
%backupcmd% %AppData%\REAPER "%backup_path%\reaper_app_data"
goto completed_backup_successfully

rem The script copied files to backup dir
:completed_backup_successfully
echo:
echo Backup Completed Successfully
echo:
echo:
echo Target Path
echo *******************************************
echo %backup_path%\reaper_app_data
echo *******************************************
echo:
echo:
echo I will open target folder for you at exit
pause
start "" "%backup_path%\reaper_app_data\"
exit

rem Backup 7z start
:go_backup_7z
echo I will need the path in which to backup the files from REAPER in the format of:
echo drive letter:\folder\sub folder\sub folder
echo:
echo Example: E:\
echo Example: F:\My Backups\Studio Work
echo:
echo I can even use network areas to back up to as well!
echo:
echo Example: \\server\share
echo:
echo I will create a zip file for the data in the directory you tell me.
echo:
pause
goto get_backup_path_7z

rem I need the backup path and set the variable 7z
:get_backup_path_7z
echo Tell me the path you want to backup to:
set /p backup_path=
echo:
if /i "%backup_path%"=="?" goto nogo_1
rem Check path existance, if not error out
if exist "%backup_path%" goto backup_cmd_7z
if not exist "%backup_path%" goto error_1
rem If path exists go ahead

rem Backup command 7z
:backup_cmd_7z
echo Found it!
set backupcmd=7za a
echo ### Backing Up REAPER AppData Files ###
%backupcmd% "%backup_path%\reaper_app_data.zip" "%AppData%\REAPER\*"
goto completed_backup_successfully_7z

rem The script copied files to backup dir 7z
:completed_backup_successfully_7z
echo:
echo Backup Completed Successfully
echo:
echo:
echo Target Path
echo *******************************************
echo %backup_path%
echo *******************************************
echo:
echo:
echo I will open target folder for you at exit
pause
start "" "%backup_path%"
exit

rem Recovery start
:go_recovery
echo I will need the path in which to recover the files from REAPER in the format of:
echo drive letter:\folder\sub folder\sub folder
echo:
echo Example: E:\reaper_app_data
echo Example: F:\My Backups\Studio Work\reaper_app_data
echo:
echo I can even use network areas to recover from as well!
echo:
echo Example: \\server\share\reaper_app_data
echo:
pause
goto get_recovery_path

rem I need the backup path and set the variable
:get_recovery_path
echo Tell me the path you want to recover from:
set /p recovery_path=
echo:
rem Check path existance, if not error out
if /i "%recovery_path%"=="?" goto nogo_2
if exist "%recovery_path%" goto recovery_cmd
if not exist "%recovery_path%" goto error_2
rem If path exists go ahead

rem Recovery command
:recovery_cmd
echo Found it!
set recoverycmd=xcopy /s /c /d /e /h /i /r /y
echo ### Recovering REAPER AppData Files ###
%recoverycmd% "%recovery_path%" %AppData%\REAPER
goto completed_recovery_successfully

rem The script copied files to recovery dir
:completed_recovery_successfully
echo:
echo Recovery Completed Successfully
echo:
echo:
echo Target Path
echo *******************************************
echo "%AppData%\REAPER"
echo *******************************************
echo:
echo:
echo I will open target folder for you at exit
pause
start "" "%AppData%\REAPER\"
exit

rem Recovery from 7z file
:go_recovery_7z
echo I will need the path of your REAPER zip file resides in the format of:
echo drive letter:\folder\sub folder\sub folder\7z-file.zip
echo:
echo Example: E:\reaper_app_data.zip
echo Example: F:\My Backups\Studio Work\reaper_app_data.zip
echo:
echo I can even use network areas to recover from as well!
echo:
echo Example: \\server\share\reaper_app_data.zip
echo:
pause
goto get_recovery_path_7z

rem Get 7z backup file path
:get_recovery_path_7z
echo Tell me the path of your zip file you want to recover from:
set /p recovery_path_7z=
echo:
rem Check path existance, if not error out
if /i "%recovery_path_7z%"=="?" goto nogo_2
if exist "%recovery_path_7z%" goto recovery_cmd_7z
if not exist "%recovery_path_7z%" goto error_2
rem If path exists go ahead

rem Recover files from 7z file
:recovery_cmd_7z
echo Found it!
set recoverycmd7z=7za x -o%AppData%\REAPER -y "%recovery_path_7z%"
echo ### Recovering REAPER AppData Files ###
%recoverycmd7z%
goto completed_recovery_7z

rem Completed 7z file recovery
:completed_recovery_7z
echo:
echo Recovery Completed Successfully
echo:
echo:
echo Target Path
echo *******************************************
echo "%AppData%\REAPER"
echo *******************************************
echo:
echo:
echo I will open target folder for you at exit
pause
start "" "%AppData%\REAPER\"
exit

rem Error nothing chosen
:error_0
echo If you choose not to decide you still have made a choice!
pause
exit

rem Error out sequence and go back to path sequence
:error_1
echo:
echo ERROR! Path not found, or some other Windows error.
echo:
echo Not completed successfully!
echo Check path, I will ask you again...
echo:
pause
goto get_backup_path

rem Error out sequence and go back to path sequence
:error_2
echo:
echo ERROR! Path not found, or some other Windows error.
echo:
echo Not completed successfully!
echo Check path, I will ask you again...
echo:
pause
goto get_recovery_path

rem Question mark handler 0
:nogo_0
echo It seems you don't understand...
echo:
echo I need to know whether you want to backup or recover REAPER App Data
echo:
echo Press 1, 2, 3 or 4
echo:
pause
goto init

rem Question mark handler 1
:nogo_1
echo It seems you don't understand...
echo:
echo I just need to know the place you want me to store the files for backup.
echo It can be a flash drive, an external hard drive, or a network share folder.
echo It can also be anywhere on your computer you want. Just tell me where. I will
echo create a directory called "reaper_app_data" inside it so it doesn't get messy.
echo I just need it told to me in a language I understand. Your computer will show
echo you the information I need. Just open "My Computer" or "This PC" and open the 
echo drive of your destination and find the folder where you want the files.
echo The Windows Explorer window shows the relative path, looks like where the web 
echo address would show in Firefox, or some other web browser. Click on it and the 
echo full address will show, copy that EXACTLY and I will figure out the rest.
echo Ready to try?
echo:
pause
goto get_backup_path

rem Question mark handler 2
:nogo_2
echo It seems you don't understand...
echo:
echo I just need to know the place you want to restore the files from.
echo You probably used me before to backup your REAPER App Data.
echo Just tell me the location where you backed up your files.
echo It could have been a flash drive, an external hard drive, a network
echo shared folder, or even a CD (kudos for being old school) If I created the
echo backup then I need the files inside "reaper_app_data" in order to work correctly
echo I just need it told to me in a language I understand. Your computer will show
echo you the information I need. Just open "My Computer" or "This PC" and open the 
echo drive of your destination and find the folder where the files are.
echo The Windows Explorer window shows the relative path, looks like where the web 
echo address would show in Firefox, or some other web browser. Click on it and the 
echo full address will show, copy that EXACTLY and I will figure out the rest.
echo Ready to try?
echo:
pause
goto get_recovery_path

rem Not sure how user got here? Exit out
:go_exit
echo:
echo I don't think you want to be here...
echo See ya later!
echo:
pause
exit
