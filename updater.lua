--[[================================================================================
--		Name:			Updater.lua
--		Author:			EchoTree
--		Date:				20230512
--		Verison:			1.0.0
--		Desc:				A simple lua script to pull info from github using some weird shit tbh
--		Copyright:	dunno what to put here, use it, don't sell it. ggnore
--===============================================================================--]]
require ('getos')

gVersion = '1.0.0'

gpAlpha						=		io.popen('cd'):read()
gpUpdateFolder		=		gpAlpha..'\\updates'
-- These below are for a special project :P
--gpCurlFolder 			=		gpAlpha..'\\MBINCompilerDownloader\\'
--gpCurlEXE 				=		gpCurlFolder..'curl.exe'

os.execute( 'if not exist '..gpUpdateFolder..' mkdir '..gpUpdateFolder)

local scriptname			= 'updater.lua'
local username				= 'Echo-o-Tree'
local repo						= 'LuaUpdater'
local branch					= 'main'
local github_url			= 'https://raw.githubusercontent.com/'..username..'/'..repo..'/'..branch..'/'..scriptname
local gh_api_url			= 'https://api.github.com/repos/'..username..'/'..repo..'/releases/latest'
local download_url		= gh_api_url

local curlcmd = 'curl -Ls '..download_url

local handle = io.popen(curlcmd)
local output = handle:read( '*a' )
handle:close()

local start_pos, end_pos = output:find('"browser_download_url"%s-:%s-"(.-)"')
local real_url
if start_pos and end_pos then
  real_url = output:match('"browser_download_url"%s-:%s-"(.-)"')
  real_url = real_url:gsub("\\/", "/")
--  print("Download URL:", real_url)
  real_url = real_url:gsub(".bat", ".lua") -- replace .bat with .lua
  curlcmd = 'curl -Ls '..real_url..' >'..gpUpdateFolder..'\\new_'..scriptname
--  print ( curlcmd )
else
  print("Could not find download URL in response")
end



--print ( real_url )
local remversion = string.match(real_url, "/v([%d%.]+)/updater%.lua")
print("Version:", remversion)

local function split_version(remversion)
  local parts = {}
  for part in string.gmatch(remversion, "%d+") do
    table.insert(parts, tonumber(part))
  end
  return parts
end

local version_rem = remversion
local version_current = gVersion
local parts1 = split_version(remversion)
local parts2 = split_version(gVersion)

for i = 1, 3 do
  if parts1[i] < parts2[i] then
    print('Remote Version: v'..remversion..' is older than Client Version: v'..gVersion)
    break
  elseif parts1[i] > parts2[i] then
    print('Remote Version: v'..remversion..' is newer than Client Version: v'..gVersion)
    -- Download the entire repository as a .zip file
    local gh_zip_url = 'https://github.com/'..username..'/'..repo..'/archive/refs/heads/'..branch..'.zip'
    local curlcmd_zip = 'curl -Ls '..gh_zip_url..' >'..gpUpdateFolder..'\\new.zip'
    os.execute(curlcmd_zip)
	-- Extract the files to a temporary directory
	local tempdir = gpAlpha..'\\temp'
	os.execute('if not exist '..tempdir..' mkdir '..tempdir)
	os.execute('powershell Expand-Archive -Path '..gpUpdateFolder..'\\new.zip -DestinationPath '..tempdir..' -Force')

	-- Delete the existing LuaUpdater directory in gpAlpha
	os.execute('if exist '..gpAlpha..'\\LuaUpdater rmdir /s /q '..gpAlpha..'\\LuaUpdater')

	-- Move the files to gpAlpha
	os.execute('powershell Move-Item -Force '..tempdir..'\\'..repo..'-main\\* '..gpAlpha..'\\')

	-- Remove the temporary directory
	os.execute('rmdir /s /q '..tempdir)
    break
  elseif i == 3 then
    print('Remote Version: v'..remversion..' is the same as Client Version: v'..gVersion)
  end
end

os.execute('pause')