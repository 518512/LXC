## LEDE/ImmortalWrt/~~OpenWRT Official~~ X86_X64 & ArmV8 mini（主力更新）
> [!TIP]
> **插件：基础功能、IPV6、Wireguard、SSR Plus+、PW、OC、Argon 主题、Smartdns、upnp、ShutDown**

> [!WARNING]
> **待完成：统一OpenWRT Official mini配置文件，有几个插件冲突问题一直没找到方法**
> 
> **OpenWRT Official版请到：([518512/OpenWRT-LXC](https://github.com/518512/OpenWRT-LXC))**

> [!IMPORTANT]
> **待加入：mosdns（貌似暂时不支持LEDE了，https://github.com/sbwml/luci-app-mosdns/issues/252#issuecomment-2336829767 ）**

> [!NOTE]
> **维护记录**
> 
> **调整优化：20250715 利用chatgpt升级为Github Action的Matrix编译，同时编译不同版本及平台的固件**
> 
> **Matrix为最新日期编译，Matrix_Bak为历史编译存档，参考文件名编译日期**
> 
> **删除插件：20241402 remove ~~AdGuard Home~~**
>
> ~~待解决，直接使用管理界面无法打开，需更改uhttpd注释掉 443 相关的两行。 https://github.com/coolsnowwolf/lede/issues/11546 ！~~
> > **2024.11.15貌似修复了此问题，采用替换uhttpd配置文件的方式，貌似顺便修复了网口的问题,测试一下。目前只编译了X86_X64版**
>
> passwall源：https://github.com/xiaorouji/openwrt-passwall/discussions/1872
>
> SSRP+源：https://github.com/coolsnowwolf/lede/issues/11671


## 感谢

**[xYx-c/build-openwrt](https://github.com/xYx-c/build-openwrt) 、[Zane-E/ROOTFS](https://github.com/Zane-E/ROOTFS) 、[217heidai/OpenWrt-Builder](https://github.com/217heidai/OpenWrt-Builder) 、[db-one/OpenWrt-AutoBuild](https://github.com/db-one/OpenWrt-AutoBuild) 、[shidahuilang/openwrt](https://github.com/shidahuilang/openwrt) 、[haiibo/OpenWrt](https://github.com/haiibo/OpenWrt) 、[ophub/amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) 等等无私的大神分享及教程**

## 鸣谢

- [openwrt源码](https://github.com/openwrt/openwrt) 、[LEDE源码](https://github.com/coolsnowwolf/lede) 、[ImmortalWrt源码](https://github.com/immortalwrt/immortalwrt) 、[P3TERX大佬的云编译](https://github.com/P3TERX/Actions-OpenWrt) 、[Microsoft Azure](https://azure.microsoft.com)、[GitHub Actions](https://github.com/features/actions)

## License

[MIT](https://github.com/P3TERX/Actions-OpenWrt/blob/main/LICENSE) © [**P3TERX**](https://p3terx.com)

