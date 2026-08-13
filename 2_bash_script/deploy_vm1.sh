#!/usr/bin/env bash

#Script Name: deploy_vm1.sh
#Description: Untuk remote bootstraping penyiapan VM baru & container deployment
#Author: Wira DevOps Junior

set -euo pipefail

# 1. Definisi fungsi log (HARUS DI ATAS)
log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

log_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

log_warn() {
    echo -e "\033[1;33m[WARN]\033[0m $1"
}

#Cek koneksi di VM 1

TARGET_USER="wiraaja1"
TARGET_IP="192.168.1.13"
TARGET="$TARGET_USER@$TARGET_IP"
CONTAINER_NAME="web-app-prod"
APP_PORT="8080"

#Tahap 1 untuk cek konektivitas dari VM 1

log_info "Memeriksa konektivitas SSH ke VM 1 ($TARGET)..."
if ! ssh -o ConnectTimeout=5 "$TARGET" "echo ok" &>/dev/null; then
	log_error "Gagal terhubung ke $TARGET! Pastikan VM 1 menyala dan SSH Key terpasang"
	exit 1
fi
log_info "Koneksi SSH ke $TARGET berhasil"

#Coba cek Dockernya sudah up apa belom?

log_info "Menyiapkan dan memeriksa Docker di VM $TARGET"
ssh "$TARGET" 'bash -s' << 'EOF'
    # Semua perintah di dalam sini akan berjalan di dalam VM 1!
    if ! command -v docker &> /dev/null; then
        echo "Docker belum ada, menginstal..."
        # Tulis perintah install docker pakai sudo di sini
    else
        echo "Docker sudah siap!"
    fi
EOF

#Setting up container

log_info "Deploying aplikasi ($CONTAINER_NAME) di VM 1..."
ssh "$TARGET" "bash -s" << EOF
    set -euo pipefail
    # Hapus kontainer lama jika ada
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}\$"; then
        echo "[REMOTE] Menghentikan dan menghapus kontainer lama..."
        docker rm -f ${CONTAINER_NAME}
    fi

    # Jalankan kontainer Nginx baru sebagai sampel aplikasi
    echo "[REMOTE] Menjalankan kontainer baru di port ${APP_PORT}..."
    docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:80 nginx:alpine
EOF

# --- TAHAP 4: HEALTH CHECK AUTOMATION ---
log_info "Melakukan HTTP Health-Check ke http://${TARGET_IP}:${APP_PORT}..."
MAX_RETRIES=5
COUNT=0
HEALTHY=false

while [ $COUNT -lt $MAX_RETRIES ]; do
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://${TARGET_IP}:${APP_PORT}" || true)
    
    if [ "$HTTP_STATUS" -eq 200 ]; then
        HEALTHY=true
        break
    fi

    log_warn "Aplikasi belum siap (HTTP $HTTP_STATUS). Mencoba lagi dalam 3 detik... ($((COUNT+1))/$MAX_RETRIES)"
    sleep 3
    COUNT=$((COUNT + 1))
done

# --- TAHAP 5: VERIFIKASI AKHIR ---
if [ "$HEALTHY" = true ]; then
    log_info "--------------------------------------------------------"
    log_info "SUCCESS: Deployment selesai dan VM 1 Berjalan Normal!"
    log_info "Aplikasi dapat diakses di: http://${TARGET_IP}:${APP_PORT}"
    log_info "--------------------------------------------------------"
else
    log_error "CRITICAL: Deployment gagal! Aplikasi tidak merespons HTTP 200."
    exit 1
fi

# --- KONFIGURASI DISCORD ---
# Dapatkan URL Webhook dari Settings Channel Discord > Integrations > Webhooks
DISCORD_WEBHOOK_URL="https://discordapp.com/api/webhooks/1528053625421566072/aR2NMR5QtLXlE9Dawe3zhzz2wnyNgJ9oD9B0kbeoC4dVwlNZ0tw48Sk-SfXKGhgWygC0"

send_discord() {
    local status="$1"    # misal: "SUCCESS" atau "FAILED"
    local message="$2"   # isi pesan
    
    # Payload JSON sederhana yang dikirim ke Discord
    local payload=$(cat <<EOF
{
  "embeds": [{
    "title": "🚀 Deployment Status: $status",
    "description": "$message",
    "color": $( [ "$status" == "SUCCESS" ] && echo 3066993 || echo 15158332 ),
    "footer": { "text": "Control Node: WSL | Target: VM 1 ($TARGET_IP)" }
  }]
}
EOF
)

    # Kirim ke Discord menggunakan curl
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "$payload" \
         "$DISCORD_WEBHOOK_URL" &>/dev/null
}
