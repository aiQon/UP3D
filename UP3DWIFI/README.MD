=== OPENWRT BUILD FOR TL-WR703N ===
1. in openwrt build env copy package/UP3DWIFI to the package folder ==> openwrt/package/UP3DWIFI
2. copy ".config" to openwrt folder (stripped down to support IPv4 only but with LUCI)
3. in openwrt folder run:  make V=99
4. go to folder "openwrt/bin/ar71xx" to find the "openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-sysupgrade.bin"
5. transfer and install the sysupgrade to your router

In case you already run a recent (libmusl) build of openwrt on your router you also can just install the ipkg:
a. find the "up3dwifi_xxxx-xx-xx-master_ar71xx.ipk" in "/openwrt/bin/ar71xx/packages/base"
b. transfer the image to your router (e.g. to /tmp)
c. install it on your router by running:  opkg install up3dwifi_xxxx-xx-xx-master_ar71xx.ipk
