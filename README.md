# MyDNSFailOver
Simple Dns Failover Script to switch my dns from AdGuardhome to Openwrt DNS.<br/>
tested on Openwrt 19.07 

<h2><strong>Run</strong></h2> <br/>
Add crontab file too, ie: running every 2 minutes <br/>
<pre>
<code>*/2 * * * * /usr/bin/dns-failover.sh <br/>
</code>
</pre>
