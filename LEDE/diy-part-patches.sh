#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
function __error_msg() {
	echo -e "\033[31m[ERROR]\033[0m $*"
}
function __success_msg() {
	echo -e "\033[32m[SUCCESS]\033[0m $*"
}
function __warning_msg() {
	echo -e "\033[33m[WARNING]\033[0m $*"
}
function __info_msg() {
	echo -e "\033[36m[INFO]\033[0m $*"
}
function __red_color() {
	echo -e "\033[31m$*\033[0m"
}
function __green_color() {
	echo -e "\033[32m$*\033[0m"
}
function __yellow_color() {
	echo -e "\033[33m$*\033[0m"
}
function __blue_color() {
	echo -e "\033[34m$*\033[0m"
}
function __magenta_color() {
	echo -e "\033[35m$*\033[0m"
}
function __cyan_color() {
	echo -e "\033[36m$*\033[0m"
}
function __white_color() {
	echo -e "\033[37m$*\033[0m"
}

__yellow_color "开始执行补丁文件..."
	# 打补丁
	if [ -n "$(ls -A "$GITHUB_WORKSPACE/LEDE/patches" 2>/dev/null)" ]; then
		find "$GITHUB_WORKSPACE/LEDE//patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d './' -p1 --forward --no-backup-if-mismatch"
	fi

function merge_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
    git clone --depth=1 --single-branch $1
    mv $2 package/custom/
    rm -rf $repo
}
function drop_package(){
    find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}
function merge_feed(){
    if [ ! -d "feed/$1" ]; then
        echo >> feeds.conf.default
        echo "src-git $1 $2" >> feeds.conf.default
    fi
    ./scripts/feeds update $1
    ./scripts/feeds install -a -p $1
}
rm -rf package/custom; mkdir package/custom

curl -s https://raw.githubusercontent.com/sbwml/r4s_build_script/4a9fafefd67172e074fa62cbe3570c4e197376b3/openwrt/patch/apk-tools/9999-hack-for-linux-pre-releases.patch > package/system/apk/patches/9999-hack-for-linux-pre-releases.patch

# Modify default IP
sed -i 's/192.168.1.1/10.5.2.1/g' package/base-files/files/bin/config_generate

# poweroff
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

#主题
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/kenzo/luci-app-argon-config
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git feeds/luci/applications/luci-app-argon-config

rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/kenzo/luci-theme-argon
git clone -b 18.06 https://github.com/SpeedPartner/luci-theme-argon-18.06-patch.git feeds/luci/themes/luci-theme-argon
sed -i '41,59d' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm
# git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon

#微信推送
rm -rf feeds/kenzo/luci-app-wechatpush
rm -rf feeds/luci/applications/luci-app-serverchan
git clone -b openwrt-18.06 https://github.com/tty228/luci-app-serverchan.git feeds/luci/applications/luci-app-serverchan

#luci-app-adguardhome
rm -rf feeds/kenzo/luci-app-adguardhome
git clone https://github.com/Zane-E/luci-app-adguardhome.git feeds/kenzo/luci-app-adguardhome

#filebrowser
# rm -rf feeds/kenzo/luci-app-filebrowser
# git clone -b 18.06 https://github.com/xiaozhuai/luci-app-filebrowser feeds/kenzo/luci-app-filebrowser 原始无
# merge_package https://github.com/Lienol/openwrt-package openwrt-package/luci-app-filebrowser

#mosdns
rm -rf feeds/kenzo/luci-app-mosdns
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
merge_package https://github.com/sbwml/luci-app-mosdns luci-app-mosdns
merge_package https://github.com/sbwml/luci-app-mosdns luci-app-mosdns/mosdns

# 修改主题背景
# cp -f $GITHUB_WORKSPACE/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# xfsprogs
cp -f $GITHUB_WORKSPACE/patch/xfsprogs/Makefile feeds/packages/utils/xfsprogs/Makefile

# v2dat
cp -f $GITHUB_WORKSPACE/patch/v2dat/Makefile feeds/packages/utils/v2dat/Makefile

# golang1.22
# rm -rf feeds/packages/lang/golang
# git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

./scripts/feeds update -a
./scripts/feeds install -a
