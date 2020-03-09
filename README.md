# Resign
ipa重签名 支持重签带扩展的app和带watch的app，支持重签名framework和dylib


- 1.先到账号里（企业账号或个人账号均可）创建一个APP ID任意此处假设为com.liusong.resign
- 2.然后创建此APP id的描述文件并下载到本地
- 3.cd 到resigh.sh 目录下
- 4.运行脚本 参数顺序: ipa位置 描述文件 证书SHA-1值 （注意需要加双引号,因为中间可能有空格，内部会自动过滤空格）
![image](https://github.com/lsmakethebest/LSResign/blob/master/2.png)
- SHA-1值可以直接从keychain拷贝过来，内部会自动过滤空格
```
./resign.sh /Users/liusong/Desktop/ipa/test/test.ipa  /Users/liusong/Desktop/ipa/commytogoresign.mobileprovision "63 3A 44 94 F3 C0 1F 3F B6 28 B6 DF 50 22 EF EF 92 05 9D A6"
```
-b 参数代表新bundleid 
-v 代表显示日志过程
```
./resign.sh /Users/liusong/Desktop/ipa/test/test.ipa  /Users/liusong/Desktop/ipa/commytogoresign.mobileprovision 0EE9ABD67FE7F04A4AF8ED62D5E2B95F83FECCD6 -b com.liusong.newbundlleid -v
```
-  5.会在同目录下 生成一个name-resign.ipa

## 注意
- 1.使用的描述文件是app-store重签后安装不了，dev或ad-hoc重签没问题
- 2.导出app_store包，重签名后安装闪退，重签dev，ad_hoc没问题
- 3.要想签名带推送等service等的ipa ，要确保使用的描述文件也带此service，否则会导致ipa可以安装，但是注册推送失败，
- 4.如果自定义entitlement.plist文件 里面的key对应的值如果和描述文件里相同key的值不同会导致安装失败，此时必须以描述文件为准，比如aps-environment想要为production必须下载ad-hoc描述文件，如果想要development就得下载development描述文件，而不能直接改entitlement.plist里面的值
也不能在entitlements.plist文件里乱加key，否则会导致安装失败
- 5.bundleID可以改，但是改成新的bundleID，如果要推送则得用新bundleid的推送证书
- 6.描述文件有推送能力，但是使用自定义的entitlement.plist没有配置推送能力，最终app不具有推送能力，也就是说最终app的权限以entitlement.plist为准而不是描述文件
