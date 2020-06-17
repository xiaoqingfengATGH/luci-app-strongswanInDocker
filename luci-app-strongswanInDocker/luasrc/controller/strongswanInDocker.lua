-- Copyright 2018-2019 Lienol <lawlienol@gmail.com>
-- Copyright 2020 Richard <xiaoqingfengatgm@gmail.com>
module("luci.controller.strongswanInDocker", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/strongswanInDocker") then return end

    entry({"admin", "vpn"}, firstchild(), "VPN", 45).dependent = false
    entry({"admin", "vpn", "strongswanInDocker"},
          alias("admin", "vpn", "strongswanInDocker", "settings"),
          _("IPSec VPN Server"), 50).dependent = false
    entry({"admin", "vpn", "strongswanInDocker", "settings"},
          cbi("strongswanInDocker/settings"), _("General Settings"), 10).leaf = true
    entry({"admin", "vpn", "strongswanInDocker", "users"}, cbi("strongswanInDocker/users"),
          _("Users Manager"), 20).leaf = true
    entry({"admin", "vpn", "strongswanInDocker", "status"}, call("status")).leaf =
        true
end

function status()
    local e = {}
    e.status = luci.sys.call("/etc/strongswanInDocker/getContainerState.sh")
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
