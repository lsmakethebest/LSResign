# Resign
ipa重签名


- 1.先到企业账号里创建一个APP ID任意此处假设为com.liusong.resign
- 2.然后创建此APP id的描述文件并下载到本地
- 4.cd 到resigh.sh 目录下
- 5.运行脚本 参数顺序: ipa位置 描述文件  plist   证书名称   bundleId(可不传)   注意证书名需要加双引号,因为中间可能有空格
![image](https://github.com/lsmakethebest/Resign/blob/master/1560169611411.jpg)
```
./resign.sh /Users/liusong/Desktop/ipa/test/test.ipa  /Users/liusong/Desktop/ipa/commytogoresign.mobileprovision /Users/liusong/Desktop/ipa/entitlements.plist "iPhone Distribution: XXXXX  Technology Co., Ltd"
或者 -b 参数代表新bundleid --verbose代表显示日志过程
 ./resign.sh /Users/liusong/Desktop/ipa/test/test.ipa  /Users/liusong/Desktop/ipa/commytogoresign.mobileprovision 0EE9ABD67FE7F04A4AF8ED62D5E2B95F83FECCD6 -b com.liusong.newbundlleid --verbose
```
-  6.会在同目录下 生成一个name-resign.ipa
