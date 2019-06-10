#!/bin/bash

RED='\033[1;31m'      # 红
GREEN='\033[1;32m'    # 绿
CYAN='\033[1;36m'     # 蓝
RES='\033[0m'         # 清除颜色
 

echoRed(){
	echo -e "${RED}${1}${RES}"
}

echoGREEN(){
	echo -e "${GREEN}${1}${RES}"
}

echoCYAN(){
	echo -e "${CYAN}${1}${RES}"
}

if [ $# -lt 4 ]; then
	echoGREEN '请输入参数：'
	echoGREEN '\t参数1：ipa目录'
	echoGREEN '\t参数2：描述文件目录'
	echoGREEN '\t参数3：plist目录'
	echoGREEN "\t参数4：证书名称，注意用 \"\" 双引号包起来，因为有可能有空格"
	echoGREEN '\t参数5：新的bundleid，如果不修改可以不输入此参数'
	exit
fi


#参数顺序 ipa  .mobileprovision  plist 证书名称  新bundleid
echoGREEN '-----------------输入参数---------------------'
echoGREEN "参数1: "$1
echoGREEN "参数2: "$2
echoGREEN "参数3: "$3
echoGREEN "参数4:  ${4}"
echoGREEN "参数5: "$5
echoGREEN '---------------------------------------------'

if ! ([ -e "$1" ]); then
	echoRed "参数1：IPA文件不存在 "${1}
	exit
fi

if ! ([ -e "$2" ]); then
	echoRed "参数2：描述文件文件不存在 "${2}
	exit
fi

if ! ([ -e "$3" ]); then
	echoRed "参数3：plist文件不存在 "${3}
	exit
fi


cer_name=""
if ([ "$4" == "" ]); then
	echoRed "参数4：证书名称不能为空 ${4}"
	exit
else
	cer_name=$4;
fi
echoGREEN "签名证书名称: $4"



new_bundleid=""

if [ "$5" != "" ];then
    new_bundleid=$5;
fi

echoGREEN "新bundleid: "$5


# 描述文件路径
mobileprovision_file=$2

IpaFileName=$(basename $1 .ipa)

#存放ipa的目录
ipa_path=$(dirname $1)
unzip_path=${ipa_path}/temp_unzip

rm -rf ${ipa_path}/${IpaFileName}-resign.ipa

unzip -oq $1 -d ${unzip_path}

# 将描述文件转换成plist
mobileprovision_plist=${unzip_path}"/embedded.plist"

#生成plist主要是查看描述文件的信息
security cms -D -i $mobileprovision_file  > $mobileprovision_plist

teamId=`/usr/libexec/PlistBuddy -c "Print Entitlements:com.apple.developer.team-identifier" $mobileprovision_plist`
application_identifier=`/usr/libexec/PlistBuddy -c "Print Entitlements:application-identifier" $mobileprovision_plist`

#描述文件budnleid
mobileprovision_bundleid=${application_identifier/$teamId./}
echoGREEN '描述文件中的bundleid: '$mobileprovision_bundleid

rm -rf $mobileprovision_plist

#filePath  例如  xx.app   xx.appex  xx.dylib  xx.framework
signFile(){
	filePath=$1;
	suffixStr=${filePath##*.};
	newID=$new_bundleid;
	echoCYAN "正在签名  ${filePath}"
	if [ "$newID" != "" ] && [ "$suffixStr" != "framework" ] && [ "$suffixStr" != "dylib" ];then
		
		bundleId=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier " "${filePath}/Info.plist")
		ExtensionID=${bundleId/"$OldbundleId"/"$new_bundleid"} 
		/usr/libexec/PlistBuddy -c "Set CFBundleIdentifier $ExtensionID" "${filePath}/Info.plist"

		echoCYAN "bundlieId 旧ID：${bundleId}  新ID：${ExtensionID}"

		WKCompanionAppBundleIdentifier=`/usr/libexec/PlistBuddy -c "Print WKCompanionAppBundleIdentifier" "${filePath}/Info.plist" 2> /dev/null`
		if [ "$WKCompanionAppBundleIdentifier" != "" ];then
			echoCYAN "WKCompanionAppBundleIdentifier 旧ID：${WKCompanionAppBundleIdentifier}  新ID：${new_bundleid}"
			/usr/libexec/PlistBuddy -c "Set WKCompanionAppBundleIdentifier $new_bundleid" "${filePath}/Info.plist"
		fi
		WKAppBundleIdentifier=`/usr/libexec/PlistBuddy -c "Print NSExtension:NSExtensionAttributes:WKAppBundleIdentifier" "${filePath}/Info.plist" 2> /dev/null`
		if [ "$WKAppBundleIdentifier" != "" ];then
			NEW_WKAppBundleIdentifier=${WKAppBundleIdentifier/"$OldbundleId"/"$new_bundleid"} 
			echoCYAN "WKAppBundleIdentifier 旧ID：${WKAppBundleIdentifier}  新ID：${NEW_WKAppBundleIdentifier}"
			/usr/libexec/PlistBuddy -c "Set NSExtension:NSExtensionAttributes:WKAppBundleIdentifier ${NEW_WKAppBundleIdentifier}" "${filePath}/Info.plist"
		fi

	fi



	rm -rf "${filePath}/_CodeSignature"

	#拷贝配置文件到Payload目录下
	cp $mobileprovision_file ${filePath}/embedded.mobileprovision

	(/usr/bin/codesign -vvv -fs "$cer_name" --entitlements=entitlements.plist "$filePath") || {
		echoRed "签名失败 ${filePath}"
		rm -rf ${unzip_path}
		exit
	}
	echoCYAN "签名结束 ${filePath}"
}



AppPackageName=$(ls ${unzip_path}/Payload | grep ".app$" | head -1)
AppPackageName=$(basename $AppPackageName .app)
echoGREEN '包名：'$AppPackageName
OldbundleId=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier " "${unzip_path}/Payload/${AppPackageName}.app/Info.plist")
echoGREEN '旧bundleid：'$OldbundleId;


frameworkPath=${unzip_path}/Payload/${AppPackageName}.app/Frameworks

if [ -d "${frameworkPath}" ]; then
	echoCYAN '存在Frameworks'
	echoGREEN '开始签名Frameworks'
	for file in $frameworkPath/*; do
	    signFile $file
	done
	echoGREEN '签名Frameworks结束'
fi

PlugInsPath=${unzip_path}/Payload/${AppPackageName}.app/PlugIns

if [ -d "${PlugInsPath}" ]; then
	echoCYAN '存在普通扩展'
	echoGREEN '开始签名普通扩展'
	for file in $PlugInsPath/*; do
		signFile $file
	done
	echoGREEN '普通扩展签名结束'
fi

WatchAppPath=${unzip_path}/Payload/${AppPackageName}.app/Watch
if [ -d "${WatchAppPath}" ]; then
	WatchAppPackageName=$(ls ${WatchAppPath} | grep ".app$" | head -1)
	WatchAppPackageName=$(basename $WatchAppPackageName .app)
	watchPlugInsPath=${WatchAppPath}/${WatchAppPackageName}.app/PlugIns
	if [ -d "${watchPlugInsPath}" ]; then
		echoCYAN 'Watch APP 存在扩展'
		echoGREEN '开始签名Watch App的扩展'
		for file in $watchPlugInsPath/*; do
			signFile $file
		done
		echoGREEN 'Watch App的扩展签名结束'
	fi
	echoGREEN '存在Watch App'
	echoGREEN '开始签名Watch App'
	signFile "${WatchAppPath}/${WatchAppPackageName}.app"
	echoGREEN 'Watch App签名结束'

fi

echoGREEN '开始签名主App'
signFile "${unzip_path}/Payload/${AppPackageName}.app"
echoGREEN '主App签名结束'

cd $unzip_path
echoGREEN '开始压缩生成ipa'
zip -rq ${ipa_path}/${IpaFileName}-resign.ipa ./*
rm -rf ${unzip_path}/
echoGREEN '压缩完成'
echoGREEN "######################  重新签名成功  ##############################"

