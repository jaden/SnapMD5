@echo off
REM Copy files to be deployed into the Deploy directory

set deploy=.\Deploy
set build=.\build

IF EXIST %deploy% GOTO CONT
mkdir %deploy%
:CONT
copy /Y %build%\SnapMD5.exe %deploy%\SnapMD5.exe
copy /Y Readme.txt %deploy%\Readme.txt
copy /Y license.txt %deploy%\license.txt