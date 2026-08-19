#!/bin/bash

TARGET_URL="http://192.168.13.131"
SERVICE_NAME="nginx"
WEBHOOK_URL="https://discordapp.com/api/webhooks/1528053625421566072/aR2NMR5QtLXlE9Dawe3zhzz2wnyNgJ9oD9B0kbeoC4dVwlNZ0tw48Sk-SfXKGhgWygC0"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$TARGET_URL")

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "Service $SERVICE_NAME aman (HTTP $HTTP_STATUS)"
    exit 0
else
    echo "Service $SERVICE_NAME bermasalah (HTTP $HTTP_STATUS)!"
    echo "Memulai proses pemulihan (restart $SERVICE_NAME)..."
    # Masukkan logika restart dan kirim alert di sini

    ssh wiraaja1@192.168.13.131 "sudo systemctl restart $SERVICE_NAME"

curl -H "Content-Type: application/json" \
     -X POST \
     -d "{\"content\": \"⚠️ **ALERT**: Service $SERVICE_NAME tumbang (HTTP $HTTP_STATUS) dan telah di-restart otomatis!\"}" \
     "$WEBHOOK_URL"

fi


