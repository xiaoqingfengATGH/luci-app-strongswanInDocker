# Copyright (C) 2020 xiaoqingfeng <xiaoqingfengatgm@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI for IPSec VPN Server In Docker
LUCI_DEPENDS:=+docker-ce +p7zip
LUCI_PKGARCH:=all
PKG_NAME:=luci-app-strongswanInDocker
PKG_VERSION:=1.0
PKG_RELEASE:=1-20200620
PKG_MAINTAINER:=Richard Yu <xiaoqingfengatgm@gmail.com>

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
