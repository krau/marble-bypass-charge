#!/system/bin/sh
# KernelSU 模块「操作」按钮: 一键开/关旁路供电
MODDIR=${0%/*}
[ -f "$MODDIR/config" ] || MODDIR=$(dirname "$(readlink -f "$0")")
NODE=/sys/class/qcom-battery/night_charging
CONF=$MODDIR/config

[ -f "$CONF" ] || printf 'ENABLED=1\n' > "$CONF"
ENABLED=1
. "$CONF"

if [ "$ENABLED" = "1" ]; then
    chmod 660 "$NODE" 2>/dev/null
    echo 0 > "$NODE"
    printf 'ENABLED=0\n' > "$CONF"
    echo "旁路供电: 已关闭"
else
    chmod 660 "$NODE" 2>/dev/null
    echo 1 > "$NODE"
    chmod 440 "$NODE" 2>/dev/null
    printf 'ENABLED=1\n' > "$CONF"
    echo "旁路供电: 已开启 (充到 80% 后适配器直供, 节点已锁定)"
fi

CAP=/sys/class/power_supply/battery/capacity
CUR=/sys/class/power_supply/battery/current_now
echo "电量 $(cat $CAP)%   电流 $(cat $CUR) uA (负=充电)   节点 $(cat $NODE) $(ls -l $NODE | cut -d' ' -f1)"