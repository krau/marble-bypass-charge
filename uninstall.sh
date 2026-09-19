#!/system/bin/sh
# 模块卸载时: 解锁节点并恢复正常充电
NODE=/sys/class/qcom-battery/night_charging
[ -e "$NODE" ] && { chmod 660 "$NODE" 2>/dev/null; echo 0 > "$NODE"; }
rm -f /data/local/tmp/bypass-charge.log
