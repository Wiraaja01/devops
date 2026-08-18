#!/bin/bash

TARGET_USER="wiraaja1"
TARGET_IP="192.168.1.18"
CONTAINER_NAME="web-app-prod"
DISK_THRESHOLD=25

DISCORD_WEBHOOK_URL="https://discordapp.com/api/webhooks/1528053625421566072/aR2NMR5QtLXlE9Dawe3zhzz2wnyNgJ9oD9B0kbeoC4dVwlNZ0tw48Sk-SfXKGhgWygC0"

log_info()  { echo -e "\033[1;32m[INFO]\033[0m $1"; }
log_warn()  { echo -e "\033[1;33m[WARN]\033[0m $1"; }
log_error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

send_discord() {
    local message="$1"
    if [ -n "$DISCORD_WEBHOOK_URL" ]; then
        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": \"${message}\"}" \
             "$DISCORD_WEBHOOK_URL" > /dev/null 2>&1
    fi
}

log_info "Memulai pemeriksaan kesehatan VM 1 ($TARGET_IP)..."

#Cek Disk Usage VM 1 

DISK_USAGE=$(ssh ${TARGET_USER}@${TARGET_IP} "df / --output=pcent | tail -n 1 | tr -d ' %'")

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_warn "Penyimpanan VM 1 hampir penuh! Terpakai: ${DISK_USAGE}%"
    send_discord "⚠️ **[WARN]** Disk VM 1 mungkin sudah penuh bos! Terpakai: **${DISK_USAGE}%** (Batas: ${DISK_THRESHOLD}%)"
else
    log_info "Penyimpanan VM 1 Aman: ${DISK_USAGE}% terpakai."
fi

#Cek Status Docker Container

if ssh ${TARGET_USER}@${TARGET_IP} "sudo docker ps | grep -q ${CONTAINER_NAME}"; then
    log_info "Status Kontainer (${CONTAINER_NAME}): RUNNING 🟢"
else
    log_error "Status Kontainer (${CONTAINER_NAME}): DOWN / MATI! 🔴"
    send_discord "🚨 **[ALERT]** Kontainer \`${CONTAINER_NAME}\` di VM 1 mati! Mencoba Auto-Healing..."
    
    log_warn "Meluncurkan aksi Auto-Healing: Menyalakan kembali kontainer..."
    ssh ${TARGET_USER}@${TARGET_IP} "sudo docker start ${CONTAINER_NAME}"
    
    sleep 2
    if ssh ${TARGET_USER}@${TARGET_IP} "sudo docker ps | grep -q ${CONTAINER_NAME}"; then
        log_info "AUTO-HEALING SUKSES: Kontainer ${CONTAINER_NAME} berhasil dinyalakan ulang! 🟡"
        send_discord "🟡 **[AUTO-HEALED]** Kontainer \`${CONTAINER_NAME}\` di VM 1 berhasil dinyalakan kembali secara otomatis!"
    else
        log_error "AUTO-HEALING GAGAL: Kontainer tidak dapat dinyalakan ulang!"
        send_discord "🔴 **[CRITICAL]** Auto-Healing GAGAL! Kontainer \`${CONTAINER_NAME}\` di VM 1 tidak bisa dinyalakan ulang!"
    fi
fi

