local localDir  = "/PRIVATE/SONY/VOICE/NHK-FM"             -- �]������t�@�C��������t�H���_
local server    = "ftp.gol.com"   -- FTP�T�[�o�[��IP�A�h���X(FlashAir�ɐڑ��� ipconfig �Ŋm�F)
local serverDir = "/private/data/FlashAir/"             -- FTP�T�[�o�[�̓]����t�H���_
local user      = "ip0601170243"  -- FTP���[�U�[��
local pass      = "Z#5uqBpt"      -- FTP�p�X���[�h
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
