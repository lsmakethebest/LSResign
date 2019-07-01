# Resign
ipa重签名


- 1.先到账号里（企业账号或个人账号均可）创建一个APP ID任意此处假设为com.liusong.resign
- 2.然后创建此APP id的描述文件并下载到本地
- 3.cd 到resigh.sh 目录下
- 4.运行脚本 参数顺序: ipa位置 描述文件 证书名称 （注意证书名需要加双引号,因为中间可能有空格或者使用SHA-1值）
![image](https://github.com/lsmakethebest/Resign/blob/master/2.png)
```
./resign.sh /Users/liusong/Desktop/ipa/test/test.ipa  /Users/liusong/Desktop/ipa/commytogoresign.mobileprovision "iPhone Distribution: XXXXX  Technology Co., Ltd"
```
或者 -b 参数代表新bundleid --verbose代表显示日志过程
```
./resign.sh /Users/liusong/Desktop/ipa/test/test.ipa  /Users/liusong/Desktop/ipa/commytogoresign.mobileprovision 0EE9ABD67FE7F04A4AF8ED62D5E2B95F83FECCD6 -b com.liusong.newbundlleid --verbose
```
-  5.会在同目录下 生成一个name-resign.ipa

## 注意
- 1.使用的描述文件是app-store重签后安装不了，dev或ad-hoc重签没问题
- 2.导出app_store包，重签名后安装闪退，重签dev，ad_hoc没问题
- 3.要想签名带推送等service等的ipa ，要确保使用的描述文件也带此service，否则会导致ipa可以安装，但是注册推送失败，
- 4.如果自定义entitlement.plist文件 里面的key对应的值如果和描述文件里相同key的值不同会导致安装失败，此时必须以描述文件为准，比如aps-environment想要为production必须下载ad-hoc描述文件，如果想要development就得下载development描述文件，而不能直接改entitlement.plist里面的值
也不能在entitlements.plist文件里乱加key，否则会导致安装失败
- 5.bundleID可以改，但是改成新的bundleID，如果要推送则得用新bundleid的推送证书
