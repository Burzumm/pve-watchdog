# Proxmox VE VM watchdog

### Features

* pings qemu-guest-agent of defined PVE VM
* on success (all VM operational) outputs VM list
* on error (VM ping failed) forces VM shutdown (attempts grace shutdown first) then starts VM
* sends alert to syslog, email, telegram
* ignores PVE locks (in case backup task is running)
* can be temporary disabled with `disable` file

### Requirements

* Proxmox VE node
* start with root privileges
* `qemu-guest-agent` installed in VM
* `Qemu Agent` activated for VM in PVE
* (optional) [telebot](https://github.com/dmitriypavlov/telebot) and `php-cli` for telegram

### Usage

* define a watchdog list in `VM` variable
* define an email and (optional) telegram account
* set executable `chmod +x ./watchdog.sh`
* add to cron with `crontab -e`

	`*/10 * * * * /root/watchdog.sh >/dev/null 2>&1`
