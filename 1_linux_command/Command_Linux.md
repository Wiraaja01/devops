# 🐧 Modul 1: Eksplorasi & Perintah Dasar Linux

Dokumentasi ini berisi ringkasan perintah CLI Linux yang dipelajari dan digunakan dalam manajemen server serta operasional DevOps.

---

## 1. Navigasi & Manajemen File/Direktori
* `pwd`: Menampilkan lokasi direktori saat ini (*Print Working Directory*).
* `ls -la`: Menampilkan daftar berkas & folder secara lengkap (termasuk berkas tersembunyi).
* `cd <nama_folder>`: Pindah ke folder tujuan.
* `mkdir -p project/app`: Membuat folder baru beserta sub-foldernya.
* `touch index.html`: Membuat file kosong baru.
* `cp file1.txt file2.txt`: Menyalin berkas.
* `mv file1.txt /tmp/`: Memindahkan atau mengubah nama berkas (*rename*).
* `rm -rf nama_folder`: Menghapus folder beserta isinya secara paksa.
* `chmod 755 script.sh`: Mengatur izin akses berkas (Read, Write, Execute).
* `chmod +x script.sh`: Memberikan izin eksekusi pada skrip Bash.
* `chown <ubuntu:ubuntu> <file.txt>`: Mengubah pemilik (*owner*) dan grup dari suatu berkas.

## 2. User dan Group
* `useradd` <username>: Menambahkan pengguna baru
* `passwd` <username>: Mengubah kata sandi pengguna.
* `usermod` -aG <group> <username>: Menambahkan pengguna ke grup.
* `groupadd` <groupname>: Membuat grup baru.
* `deluser` <username>: Menghapus pengguna.
* `delgroup` <groupname>: Menghapus grup.


## 3. Disk dan File System
* `df` -h: Menampilkan penggunaan disk dalam format yang mudah dibaca.
* `du` -sh <directory>: Menampilkan ukuran direktori.
* `fdisk` -l: Menampilkan partisi disk.
* `mkfs.ext4 /dev/sda1`: Membuat filesystem ext4 pada partisi.
* `mount /dev/sda1 /mnt`: Mount partisi ke direktori /mnt.
* `umount /mnt`: Unmount partisi dari /mnt.
* `fsck /dev/sda1`: Memeriksa dan memperbaiki filesystem.


## 4. Jaringan & Monitoring
* `ip a`: Menampilkan alamat IP lokal interface server.
* `ping -c 4 8.8.8.8`: Menguji konektivitas jaringan ke server luar.
* `curl -I https://google.com`: Menguji respon HTTP dari server tujuan.
* `ssh ubuntu@<IP_ADDRESS>`: Melakukan koneksi remote aman ke server Linux.
* `ps aux`: Menampilkan semua proses yang berjalan.
* `top`: Memantau penggunaan CPU dan memori secara real-time.
* `htop`: Versi lebih user-friendly dari top.
* `kill` <PID>: Menghentikan proses berdasarkan PID.
* `systemctl status` <service>: Menampilkan status layanan.
* `systemctl start/stop/restart` <service>: Mengelola layanan.
* `ss -tulnp`: Netstat untuk port yang terbuka
* `iptables`-L: Menampilkan aturan firewall


## 5. Manajemen Aplikasi
* `apt update`: Memperbarui daftar paket (untuk sistem berbasis Debian).
* `apt upgrade`: Menginstal pembaruan paket.
* `apt install` <package>: Menginstal paket.
* `apt remove` <package>: Menghapus paket.
* `yum update`: Memperbarui paket (untuk sistem berbasis Red Hat).
* `yum install` <package>: Menginstal paket.
