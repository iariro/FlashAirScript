local localDir  = "/PRIVATE/SONY/VOICE/NHK-FM"             -- 転送するファイルがあるフォルダ
local server    = "ftp.gol.com"   -- FTPサーバーのIPアドレス(FlashAirに接続後 ipconfig で確認)
local serverDir = "/private/data/FlashAir/"             -- FTPサーバーの転送先フォルダ
local user      = "ip0601170243"  -- FTPユーザー名
local pass      = "Z#5uqBpt"      -- FTPパスワード
local file = ""

-- find new file
max_mod = 0
for filename in lfs.dir(localDir) do
  filepath = localDir .. "/" .. filename
  mod = lfs.attributes( filepath, "modification" )
  if mod > max_mod then
    max_mod = mod
    file = filename
  end
end

print("File :" .. file .. " mod" .. max_mod .. "\r\n")

-- ftp put
local xferString = "ftp://"..user..":"..pass.."@"..server..serverDir
response = fa.ftp("put", xferString..file, localDir .. "/" .. file)
if response ~= nil then
    print("Success!")
else
    print("Fail :(")
end
