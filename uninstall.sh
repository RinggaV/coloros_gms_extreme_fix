#!/system/bin/sh
# 模块卸载脚本：恢复 sys_elsa_config_list.xml 原文件

TARGET_FILE="/data/oplus/os/bpm/sys_elsa_config_list.xml"
BACKUP_FILE="$MODPATH/sys_elsa_config_list.xml.bak"

if [ -f "$BACKUP_FILE" ]; then
    # 解锁备份文件（service.sh 中设置了 chattr +i）
    chattr -i "$BACKUP_FILE"

    # 解锁目标文件
    chattr -i "$TARGET_FILE"

    # 恢复备份到原位置
    cp "$BACKUP_FILE" "$TARGET_FILE"

    # 重新锁定目标文件（ColorOS 原始状态即为 +i）
    chattr +i "$TARGET_FILE"

    # 删除备份文件
    rm "$BACKUP_FILE"
fi