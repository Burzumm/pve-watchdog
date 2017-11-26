#!/usr/bin/env bash
# ping qemu-guest-agent and restart VM on ANY error

VM="101 102 103"

telegram="username"
email="email@server.tld"
header="[$(basename $0) @ $(hostname)]"

disable="watchdog.disable"
logger="/usr/bin/logger"
mail="/usr/bin/mail"
php="/usr/bin/php"
qm="/usr/sbin/qm"

dir=$(dirname "$0")

alert() {
	text=$(printf "$header\n$1\n")
	$logger "$text"										# alert to syslog
	printf "$text" | $mail -s "$header" "$email"		# alert to email
	$php "$dir/telebot/send.php" "$telegram" "$text"	# alert to telegram
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
		$qm shutdown $ID --skiplock 1 --forceStop 1 --timeout 60
		$qm start $ID --skiplock 1
		alert "Time: $time\nProblem: $name unreachable\nDetails: $error\nAction: force restart"
	else
		echo "$($qm list)"
	fi
done
