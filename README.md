# Proxmox VE VM watchdog

### Features

* pings `qemu-guest-agent` on defined PVE VM
* on success (all VM operational) outputs VM list
* on error (VM ping failed) forces VM shutdown (attempts grace shutdown first) then starts VM
* sends alert to syslog, email, Telegram
* ignores PVE locks (while backup task running)
* can be temporary disabled with `disable` file

### Requirements

* Proxmox VE node
* start with root privileges
* `qemu-guest-agent` installed in VM
* `Qemu Agent` activated for VM in PVE
* (optional) [**telebot**](https://github.com/dmitriypavlov/telebot) script for Telegram

### Usage
1. define a watchdog list in `VM` variable
2. define an email and (optional) Telegram account
3. set executable `chmod +x ./watchdog.sh`
4. add to cron with `crontab -e`:

`*/10 * * * * /root/watchdog.sh >/dev/null 2>&1`
