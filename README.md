# Resign
ipa重签名


### 先到企业账号里创建一个APP ID任意此处假设为com.liusong.resign
### 然后创建此APP id的描述文件
### 然后修改 entitlements.plist里的XXXXX成自己的teamid
### 修改resign.sh里的证书名称
### cd 到resigh 目录下
### 运行脚本
### 会在同目录下 生成一个name-resign.ipa
### 也可以修改签名后的应用bundleid即修改info.plist里的bundleid，打开resign.sh里的注释即可
```./resign.sh /Users/liusong/Desktop/ipa/test/test.ipa  /Users/liusong/Desktop/ipa/commytogoresign.mobileprovision /Users/liusong/Desktop/ipa/entitlements.plist
