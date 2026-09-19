#!/system/bin/sh
# 旁路供电
# 原理: 固件 night_charging=1 会让充电停在 80% 并保持(适配器直供, 电池 0 µA);
#       写完后 chmod 440 锁住节点, 防止系统/框架把它改回 0。
MODDIR=${0%/*}
[ -f "$MODDIR/config" ] || MODDIR=$(dirname "$(readlink -f "$0")")
NODE=/sys/class/qcom-battery/night_charging
CONF=$MODDIR/config
LOG=/data/local/tmp/bypass-charge.log

[ -f "$CONF" ] || printf 'ENABLED=1\n' > "$CONF"
ENABLED=1
. "$CONF"
[ "$ENABLED" = "1" ] || { echo "$(date '+%m-%d %H:%M:%S') 配置为关闭, 跳过" >> "$LOG"; exit 0; }

i=0
while [ ! -e "$NODE" ] && [ $i -lt 90 ]; do sleep 2; i=$((i + 1)); done
[ -e "$NODE" ] || { echo "$(date '+%m-%d %H:%M:%S') 节点不存在: $NODE" >> "$LOG"; exit 1; }

chmod 660 "$NODE" 2>/dev/null
echo 1 > "$NODE"
chmod 440 "$NODE" 2>/dev/null
echo "$(date '+%m-%d %H:%M:%S') service.sh 已启用并锁定 (值=$(cat $NODE) 权限=$(ls -l $NODE | cut -d' ' -f1))" >> "$LOG"
