fromaddr = "iariro@gol.com"
toaddr = "iariro@gol.com"
a = fa.MailSend {
  from = fromaddr,
  headers = "To: "..toaddr.."\r\nFrom: "..fromaddr.."\r\nSubject: test",
  body = "Mail from FlashAir",
  server = "mail.gol.com",
  user = "kumagai",
  password ="Z#5uqBpt"
}
if a ~= nil then
    print("Success!")
else
    print("Fail :(")
end
