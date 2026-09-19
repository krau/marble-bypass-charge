#!/system/bin/sh
# 开机完成后再确认一次: 框架/系统在启动期间可能把它改回 0
MODDIR=${0%/*}
[ -f "$MODDIR/config" ] || MODDIR=$(dirname "$(readlink -f "$0")")
NODE=/sys/class/qcom-battery/night_charging
CONF=$MODDIR/config
LOG=/data/local/tmp/bypass-charge.log

[ -f "$CONF" ] || printf 'ENABLED=1\n' > "$CONF"
ENABLED=1
. "$CONF"
[ "$ENABLED" = "1" ] || exit 0
[ -e "$NODE" ] || exit 1

if [ "$(cat "$NODE")" != "1" ]; then
    chmod 660 "$NODE" 2>/dev/null
    echo 1 > "$NODE"
    chmod 440 "$NODE" 2>/dev/null
    echo "$(date '+%m-%d %H:%M:%S') boot-completed.sh 重新启用 (启动期间被改回 0)" >> "$LOG"
fi
