-- Copyright 2018-2019 Lienol <lawlienol@gmail.com>
-- Copyright 2020 Richard <xiaoqingfengatgm@gmail.com>
module("luci.controller.strongswanInDocker", package.seeall)

function index()
    entry({"admin", "vpn"}, firstchild(), "VPN", 45).dependent = false
	
	entry({"admin", "vpn", "strongswanInDocker", "show"}, call("show_menu")).leaf = true
    entry({"admin", "vpn", "strongswanInDocker", "hide"}, call("hide_menu")).leaf = true
	
    if nixio.fs.access("/etc/config/strongswanInDocker") and
        nixio.fs.access("/etc/config/strongswanInDocker_show") then
            entry({"admin", "vpn", "strongswanInDocker"},
			alias("admin", "vpn", "strongswanInDocker", "settings"),
			_("IPSec VPN Server(Docker)"), 50).dependent = false
    end
	
    entry({"admin", "vpn", "strongswanInDocker", "settings"},
          cbi("strongswanInDocker/settings"), _("General Settings"), 10).leaf = true
    entry({"admin", "vpn", "strongswanInDocker", "users"}, cbi("strongswanInDocker/users"),
          _("Users Manager"), 20).leaf = true
    entry({"admin", "vpn", "strongswanInDocker", "status"}, call("status")).leaf =
        true
	entry({"admin", "vpn", "strongswanInDocker", "downloadStatus"}, call("downloadStatus")).leaf =
        true
	entry({"admin", "vpn", "strongswanInDocker", "startDownload"}, call("startDownload")).leaf =
        true
end

function status()
    local e = {}
    e.status = tonumber(luci.sys.exec("/etc/strongswanInDocker/getContainerState.sh"))
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end

function downloadStatus()
	local d = {}
	d.status = tonumber(luci.sys.exec("/etc/strongswanInDocker/getDownloadState.sh"))
	d.imageState = tonumber(luci.sys.exec("/etc/strongswanInDocker/getContainerState.sh"))
	d.downloadMsg = luci.sys.exec("/etc/strongswanInDocker/getDownloadMsg.sh")
	luci.http.prepare_content("application/json")
    luci.http.write_json(d)
end

function startDownload()
	local e = {}
    e.status = tonumber(luci.sys.exec("/etc/strongswanInDocker/download.sh"))
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end

function show_menu()
    luci.sys.call("touch /etc/config/strongswanInDocker_show")
    luci.http.redirect(luci.dispatcher.build_url("admin", "vpn", "strongswanInDocker"))
end

function hide_menu()
    luci.sys.call("rm -rf /etc/config/strongswanInDocker_show")
    luci.http.redirect(luci.dispatcher.build_url("admin", "status", "overview"))
end