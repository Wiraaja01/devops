# Automated Docker Container Deployment via Bash

Skrip otomatisasi Bash untuk melakukan remote deployment kontainer Docker (Nginx) dari Control Node (WSL) ke Target VM.

## 🚀 Fitur Skrip
- **Idempotent Deployment**: Mengecek dan membersihkan kontainer lama sebelum menjalankan yang baru.
- **Remote Execution**: Mengeksekusi perintah Docker di VM target secara otomatis via SSH.
- **Health-Check**: Memastikan aplikasi berjalan normal setelah deployment.
- **Logging System**: Format log berwarna untuk kemudahan debugging (`log_info`, `log_warn`, `log_error`).

## 🛠️ Cara Penggunaan
```bash
./deploy_vm1.sh

