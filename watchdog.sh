#!/usr/bin/env bash
# ping qemu-guest-agent and restart VM on ANY error

VM="100 101"
email=`cat /etc/pve/user.cfg | awk '{split($0,a,":"); print a[7]}'`
header="[$(basename $0) @ $(hostname)]"

disable="watchdog.disable"
logger="/usr/bin/logger"
mail="/usr/bin/mail"
qm="/usr/sbin/qm"

dir=$(dirname "$0")

alert() {
    text=$(printf "$header\n$1\n")
    $logger "$text"                                     # alert to syslog
    printf "$text" | $mail -s "$header" "$email"        # alert to email
}
$logger "starting Watchdog..."

if [ -f "$dir/$disable" ]; then
    $logger "$disable"
    echo "$disable"
    exit 0
fi

for ID in $VM; do
    if ! error=$($qm agent $ID ping 2>&1); then
        time=$(date +'%T %m.%d.%Y')
        name=$($qm config $ID | grep '^name:' | awk '{print $2}')
        alert "Time: $time\nProblem: $name unreachable\nDetails: $error"
    else
        echo "$($qm list)"
    fi
done