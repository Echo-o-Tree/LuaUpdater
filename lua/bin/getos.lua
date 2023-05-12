--==============================================================
--	filename:		getos.lua
--	Name:			Get OS platform and Native Commands
--	Author:			EchoTree
--	Date:				11/30/2022
--	Descrip:			A simple script to get your os platform and commands
--==============================================================
oSystem = {}																					-- sets a dummy var to assign methods to
osc = {}																							-- ditto
file = {}																							-- and again
curl = {}

gpAlpha = io.popen('cd'):read()
gpLuaBin = gpAlpha..'\\lua\\bin\\'
gpInclude = gpAlpha..'\\include\\'
gpLuaInt = gpLuaBin..'lua.exe'
gpWXLuaInt = gpLuaBin..'wxLua.exe'
gpCurlFolder = gpAlpha..'MBINCompilerDownloader\\'
gpCurlEXE = gpCurlFolder..'curl.exe'

function oSystem:Get()																							-- Method "Get" for oSystem
    local envMacOS = 'CI_PRODUCT_PLATFORM'													-- Environment variable for macos
    local envLinuxOS = 'DESKTOP_SESSION'															-- Environment variable for LinuxOS
    local envWindowsOS = 'OS'																				-- Environment variable for Windows OS
    if(os.getenv(envMacOS) == 'macOS') then														-- Tries the env var for MacOS first, if it's not mac, then
        print('Using MacOS')
        osPlatform = 'macOS'
    elseif(os.getenv(envLinuxOS) == not('gnome' or 'ubuntu')) then				-- tries several different distros for linux, if it returns nil, you will have to add your distro's desktop_session value
        print('Using Linux OS')
        osPlatform = 'Linux'
    elseif(os.getenv(envWindowsOS) == 'Windows_NT') then							-- tries the env var for windows
        -- print('Using Windows OS')
        osPlatform = 'Windows'
    end
    return osPlatform
end

osPlatform = oSystem:Get()																					-- sets the osPlatform var equal to the result returned by the oSystem:Get() method
if(osPlatform == 'Windows') then																		-- checks if the platform is windows
	Start = 'start '																										-- sets the var Start to the os start cmd
	Pause = 'pause'																									-- sets the var Pause to the os pause cmd
	Mkdir = ' mkdir '																									-- sets the var Mkdir to the os Make Directory cmd
	Deldir = 'rd '																											-- sets the var Deldir to the os Remove Directory cmd
	Echo = 'echo '																										-- sets the var Echo to the os print cmd
	Ping = 'ping '																											-- sets the var Ping to the os Ping cmd
	IfNotExist = 'if not exist '																					-- you get the point lol
	Wait = 'timeout /t '
--[[																																-- uncomment this line to add the linux commands. note, you'll have to add the cmds in yourself
elseif(osPlatform == 'Linux') then																			-- checks if the platform is Linux
	Start = ' '
	Pause = ' '
	Mkdir = ' '
	Deldir = ' '
	Echo = ' '
	Ping = ' '
	IfNotExist = ' '
--]]
--[[																																-- uncomment this line to add macos commands
elseif(osPlatform == 'macOS')																				-- checks if the platform is macOS
	Start = ' '
	Pause = ' '
	Mkdir = ' '
	Deldir = ' '
	Echo = ' '
	Ping = ' '
	IfNotExist = ' '
--]]
--[[
else																																
	Start = ' '
	Pause = ' '
	Mkdir = ' '
	Deldir = ' '
	Echo = ' '
	Ping = ' '
	IfNotExist = ' '
--]]
end

function file:new(NewPath, FileName)																-- adding a simple new file method to lua's file system
	FilePath = NewPath..FileName																			-- sets a Global FilePath as the Path and FileName
	local file = io.open(NewPath..FileName, 'w')													-- Opens the FilePath with the 'w' write instruction. THIS WILL OVERWRITE ANY FILE WITH THE SAME PATH!!! IF YOU WANT TO EDIT OR APPEND, TRY BELOW
	return file
end

function file:append(FilePath)																				-- adding a simple append method
	local file = io.open(FilePath, 'a')																		-- opens the FilePath with the 'a' append instruction. This will add new characters/lines/whatever below the previously existing contents of the file
	return file
end

function osc:Start(application)																			-- Method 'Start' for osc var
	os.execute(Start..application)																			-- Takes a single input (application) and starts it from the cmd line. 
end

function osc:Pause()																								-- Method 'Pause'
	os.execute(Pause)																								-- is pause, but in lua
end

function osc:Mkdir(makedirectory)																	-- Method 'Mkdir'
	os.execute(IfNotExist..makedirectory..Mkdir..makedirectory)					-- checks if a directory exists, and, if it doesnt, makes it
end

function osc:Deldir(deldirectory)																		-- Method Deldir
	os.execute(Deldir..deldirectory)																		-- delets the specified directory. DO NOT USE ON SYSTEM FILES
end

function osc:Ping(pingable)																					-- Method Pings
	os.execute(Ping..pingable)																				-- Pings stuff
end

function osc:Echo(printable)																				-- Method Echo
	os.execute(Echo..printable)																				-- it's Echo, but cross platform
end

function osc:Wait(seconds)																					-- Method wait
	os.execute(Wait..' '..seconds)																			-- timeout with interuptable countdown
end

function osc:GetPath()
	lpath = io.popen('cd'):read()
	return lpath
end

function osc:lua(luascript)																					-- Method lua
	os.execute(gpLuaInt..' '..luascript)																	-- Runs a lua script from the included 5.4.4 lua interpreter. you can set your own interpreter above
end

function osc:wxLua(wxluascript)																			-- Method wxLua
	os.execute(gpWXLuaInt..' '..wxluascript)														-- same as abovem but runs the script through the wxLua interpreter.
end

function curl:download(...)
	value = os.execute(...)
	print ( value )
end

--[[
osc:Start('calc.exe') 										-- starts the executable file
osc:Echo('Hello World')									-- echos the text on the cmdline
osc:Pause()														-- pauses
--osc:Mkdir('c:\\New\\filepath\\here') 	--	creates a new directory if it doesn't already exist
--osc:Deldir('c:\\New\\filepath\\here')		-- deletes a directory. DO NOT USE ON SYSTEM32!!!!!!!!!!!!!!
osc:Ping('192.168.1.1')									-- pings the selected address
osc:Wait(60)													-- waitaminute
--]]