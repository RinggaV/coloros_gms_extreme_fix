#!/system/bin/sh
# 定义模块路径
MODDIR=${0%/*}
TARGET_FILE="/data/oplus/os/bpm/sys_elsa_config_list.xml"
BACKUP_FILE="$MODDIR/sys_elsa_config_list.xml.bak"
SOURCE_FILE="$MODDIR/data/oplus/os/bpm/sys_elsa_config_list.xml"

# 等待系统完全启动
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 5
done

# --- [新增] 1. 解锁系统框架对 GMS 的隐藏限制 ---
# 这个命令能清空 HansPackageManager 中的 GMS 限制名单
settings put secure google_restric_info 0

# --- [优化] 2. 针对 BPM 配置文件的备份与替换 ---
if [ -f "$SOURCE_FILE" ]; then
    # 解除可能存在的 i 属性锁定
    chattr -i "$TARGET_FILE"

    # 仅在尚未备份时执行备份（避免每次开机重复覆盖备份）
    if [ ! -f "$BACKUP_FILE" ]; then
        cp "$TARGET_FILE" "$BACKUP_FILE"
        chattr +i "$BACKUP_FILE"
    fi

    # 直接拷贝替换目标文件
    cp "$SOURCE_FILE" "$TARGET_FILE"
    chattr +i "$TARGET_FILE"
fi

# --- [新增] 3. 注入安卓原生 Doze (打盹) 白名单 ---
# 确保 GMS 拥有原生层面的不优化权限
dumpsys deviceidle whitelist +com.google.android.gms
dumpsys deviceidle whitelist +com.google.android.gsf

# --- [保留] 4. 执行原有的防火墙修复脚本 ---
if [ -f "$MODDIR/firewall_fix.sh" ]; then
    sh "$MODDIR/firewall_fix.sh" &
fi
