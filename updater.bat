@echo off

set gpAlpha=%cd%
set gpLuabin=%cd%\lua\bin
set lua=%gpLuabin%\lua.exe

%lua% updater.lua

pause