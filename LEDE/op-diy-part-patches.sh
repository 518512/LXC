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
# Modify default IP
sed -i 's/192.168.1.1/10.5.2.1/g' package/base-files/files/bin/config_generate

rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-adguardhome

# openclash packages
git clone --depth=1 -b master https://github.com/vernesong/OpenClash.git package/openclash
mv openclash/luci-app-openclash package/luci-app-openclash && rm -rf openclash
pushd luci-app-openclash/tools/po2lmo
popd

git clone --depth=1 https://github.com/fw876/helloworld.git ssr-plus

# ADG packages
#git clone --depth=1 -b master https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 https://github.com/rufengsuixing/luci-app-adguardhome.git luci-app-adguardhome

#主题
# rm -rf feeds/luci/applications/luci-app-argon-config
# rm -rf feeds/kenzo/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# rm -rf feeds/luci/themes/luci-theme-argon
# rm -rf feeds/kenzo/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
sed -i '41,59d' feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm

#mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

## update golang 1.23
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

##passwall
git clone https://github.com/xiaorouji/openwrt-passwall.git package/passwall
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall-packages
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"

# git checkout v23.05.3

./scripts/feeds update -a
./scripts/feeds install -a
