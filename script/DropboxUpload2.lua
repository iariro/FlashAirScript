
--150MBまでの最新のファイルを自動で探索しDropboxにアップロードするサンプル

--ファイルの書き込みをしないので安全。
--但し、書き込まれた時の特定フォルダ内最新1ファイルしかアップロードしない。

--捜索対象のフォルダ(空欄=root)
--末端に/を付けないこと。ファイル探索には成功するが、Dropbox側で怒られる
fpath = "/PRIVATE/SONY/VOICE/NHK-FM";

--ここにアクセストークン。自分用のAPI登録をしたなら、Generated access tokenで生成できる。
--公式のサンプルのように、appKeyやappSecretを使っていろいろする必要はない。
token = "2M8Phv3G3UAAAAAAAAAB6xdzvSBNMVfBWdc0XBYMyg8";

--アップロード先フォルダ
--App folder&#8211; Access to a single folder created specifically for your app.にしたなら、
--アプリフォルダ内にファイルができる。
--Full Dropbox&#8211; Access to all files and folders in a user's Dropbox.にしたなら
--自由に。ファイル破壊も発生するので注意。

--uploadDir="/someFolder"
uploadDir="";

--注意:CONFIGでIPアドレスを固定していると、接続してもやっぱり固定されているので色々失敗する。
--DHCP_Enabled=YESにすること。

--注意:STAモードもしくはBridgeモードにすること。
--        APPAUTOTIME=0とすること。(通信が切られかねないため)
--　　　 LUA_SD_EVENT=/dropbox_upload.luaのようにすること。(このファイルをdrobpx_upload.luaにした場合)


--作業用変数
filename = "";

--プロセス開始

   sleep(6000); --ファイル書き込み待機(カメラや使う機器が書き込み終了するまでにかかる時間に合わせて変更する。)
     　--ここを下手に短くすると、カメラがエラーを吐いたり、写真が破損したり、1つまえに撮影した画像がアップロードされたりする
 
--ファイル走査
 --http://dotnsf.blog.jp/archives/2015-09-16.htmlより、最新のファイルを探す
 last_filepath = ""
 max_mod = 0
 for filename in lfs.dir(fpath) do
  filepath = fpath .. "/" .. filename
  mod = lfs.attributes( filepath, "modification" )
  if mod > max_mod then
   max_mod = mod
   last_filepath = filepath
  end
 end

 --ファイルがなければ終了
 if(last_filepath == "")then print("No file."); goto EXIT; end;

 filename = last_filepath;

--アップロード処理開始

 --ファイル本体をデータに
 mes = "<!--WLANSDFILE-->";
 --ファイルサイズを取得
 len_s = lfs.attributes(filename,"size");

 --アップロード先パス設定
 uploadPath = uploadDir..filename;
 --Dropbox引数(上書き・通知の有無)
 dropboxArg = '{"path": "'.. uploadPath ..'","mode": "overwrite"}';

 --ヘッダー情報
 hed = {
  ["Content-Length"] = len_s,
  ["Authorization"] = "Bearer "..token,
  ["Dropbox-API-Arg"] = dropboxArg,
  ["Content-Type"] = "application/octet-stream"
 };

   --
 --リクエスト
 b,c,h = fa.request{
  url = "https://content.dropboxapi.com/2/files/upload",
  method = "POST",
  headers = hed,
  body = mes,
  file = filename,
  bufsize=1460*10
 };

 --エラーが帰ってきたらファイルに保存する
 if(c>200)then
  f=io.open("res","w")
  f:write(h)
  f:write(b)
  f:close();
   end

 --ブラウザでのデバッグ用
 print(dropboxArg);

 print(c)
 print(h)
 print(b)

::EXIT::
 --終了処理
