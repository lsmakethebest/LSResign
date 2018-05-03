# Resign
ipa重签名


### 先到企业账号里创建一个APP ID任意此处假设为com.liusong.resign
### 然后创建此APP id的描述文件并下载到本地
### 然后修改 entitlements.plist里的XXXXX成自己的teamid
![image](https://github.com/lsmakethebest/Resign/blob/master/1.png)
### cd 到resigh.sh 目录下
### 运行脚本 参数顺序: ipa位置 描述文件  plist   证书名称  注意证书名需要加双引号 因为中间可能有空格
```./resign.sh /Users/liusong/Desktop/ipa/test/test.ipa  /Users/liusong/Desktop/ipa/commytogoresign.mobileprovision /Users/liusong/Desktop/ipa/entitlements.plist "iPhone Distribution: XXXXX  Technology Co., Ltd"```
### 会在同目录下 生成一个name-resign.ipa
### 也可以修改签名后的应用bundleid即修改info.plist里的bundleid，打开resign.sh里的注释即可

