

print("Hello World!")
local file = io.open("log/Hello.txt", "a")
file:write("Hello There!\n")
file:close()

