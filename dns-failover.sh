#!/bin/sh

ADGUARD="192.168.3.xxx"
ADGDNS="192.168.3.xxx#5354"
CONFIG_PATH="dhcp.@dnsmasq[0]"
CURRENT_DNS=$(uci get $CONFIG_PATH.server 2>/dev/null)

ping -c 1 -W 1 $ADGUARD > /dev/null

if [ $? -eq 0 ]; then
    # AdGuard is UP
    if [ "$CURRENT_DNS" != "$ADGDNS" ]; then
        uci set $CONFIG_PATH.noresolv='1'
        uci delete $CONFIG_PATH.server 2>/dev/null
        uci add_list $CONFIG_PATH.server="$ADGDNS"
        uci commit dhcp
        /etc/init.d/dnsmasq restart
        logger -t dns-failover "AdGuard is up. Using $ADGDNS as DNS"
    fi
else
    # AdGuard is DOWN
    if [ "$CURRENT_DNS" = "$ADGDNS" ]; then
        uci set $CONFIG_PATH.noresolv='0'
        uci delete $CONFIG_PATH.server
        uci commit dhcp
        /etc/init.d/dnsmasq restart
        logger -t dns-failover "AdGuard down. Reverted to default WAN DNS"
    fi
fi

