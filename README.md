# E-Report - Sistem Pengaduan Masyarakat Digital

Aplikasi pelaporan dan pengaduan aspirasi masyarakat berbasis web yang dibangun menggunakan **Laravel 13** dan **Livewire 4**. Diadaptasi dan disempurnakan persis sesuai arsitektur dan antarmuka dari repositori referensi [Rapip-NA/E-Report](https://github.com/Rapip-NA/E-Report).

---

## 🚀 Fitur Utama

### 1. Autentikasi & Akun
- **Registrasi Warga**: Form pendaftaran akun warga dengan validasi nama, email unik, password terenkripsi, nomor WhatsApp, alamat, dan opsional foto profil.
- **Login Multi-Role**: Deteksi peran otomatis (*Warga* vs *Admin*).
  - Akun dengan role `warga` otomatis diarahkan ke `/warga/dashboard`.
  - Akun dengan role `admin` otomatis diarahkan ke `/admin/dashboard`.
- **Proteksi Rute & Middleware**: Rute dilindungi oleh middleware `auth` dan `role:warga` / `role:admin`.
- **Logout Aman**: Menggunakan metode HTTP POST dengan invalidasi sesi dan regenerasi token CSRF.

### 2. Panel Warga (`/warga`)
- **Dashboard Ringkasan**: Statistik total laporan, laporan berstatus *Pending*, *Diproses*, dan *Selesai*.
- **Buat Pengaduan Baru**: Upload bukti foto pengaduan (maks 2MB, jpg/png/webp), judul laporan, tanggal kejadian, dan rincian detail kejadian.
- **Riwayat Pengaduan Saya**: Daftar pengaduan milik warga yang bersangkutan dilengkapi pagination, pencarian berdasarkan judul/detail, dan filter berdasarkan status.
- **Detail Pengaduan**: Menampilkan detail lengkap laporan, foto pengaduan, badge status terkini, dan profil pelapor.
- **Edit Pengaduan**: Fitur edit laporan (hanya jika laporan berstatus `pending`). Warga dapat memperbarui judul, detail, tanggal, serta mengganti foto laporan.
- **Hapus Pengaduan**: Fitur hapus laporan (hanya jika status `pending`), file foto fisik otomatis dibersihkan dari penyimpanan disk.
- **Kelola Profil**: Memperbarui nama lengkap, nomor WhatsApp, alamat domisili, dan foto profil.

### 3. Panel Admin (`/admin`)
- **Dashboard Admin**: Ringkasan data pengaduan masuk seluruh warga dan monitoring status keseluruhan.
- **Kelola Semua Pengaduan**: Daftar pengaduan dari seluruh masyarakat dengan pencarian, filter status, dan pagination.
- **Tinjau & Ubah Status Pengaduan**:
  - Transisi status sekuensial yang ketat: `pending` ➔ `proses` ➔ `selesai`.
  - Tombol aksi transisi status real-time dengan Livewire.

---

## 🛠️ Teknologi & Stack

- **Framework**: Laravel 13 (`laravel/framework v13.39.0`)
- **Frontend Interaktif**: Livewire 4 (`livewire/livewire v4.4.8`)
- **Database**: MySQL (`e_report_belajar`)
- **Styling**: Tailwind CSS & Vanilla CSS kustom (Fonts & SVG Assets)
- **Icons**: Lucide Icons CDN
- **Testing**: PHPUnit / Laravel Test Suite (36 Feature Tests, 179 Assertions, 100% Pass)

---

## 🔑 Kredensial Login Bawaan

### Administrator:
- **URL**: `/login`
- **Email**: `admin@ereport.test`
- **Password**: `AdminSecret123!`

### Akun Warga (Demo):
Warga dapat langsung mendaftar baru melalui menu **Daftar Sekarang** di halaman login/landing page, atau menggunakan akun dari seed demo:
- **Password untuk semua akun demo warga**: `Password123!`
- Contoh email demo warga: Cek di database pada tabel `users` di mana `role = 'warga'`.

---

## 💻 Panduan Instalasi & Menjalankan

1. **Clone / Buka Proyek**:
   ```bash
   cd d:\ProjectTKIT\Report-Public
   ```

2. **Pastikan Dependensi Terpasang**:
   ```bash
   composer install
   ```

3. **Konfigurasi Environment (`.env`)**:
   Pastikan konfigurasi database di `.env` sudah sesuai dengan MySQL Anda:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=e_report_belajar
   DB_USERNAME=root
   DB_PASSWORD=root

   ADMIN_EMAIL=admin@ereport.test
   ADMIN_PASSWORD="AdminSecret123!"
   ```

4. **Migrasi Database & Seeder**:
   ```bash
   php artisan migrate:fresh --seed
   php artisan db:seed --class=DemoSeeder
   ```

5. **Symlink Storage**:
   ```bash
   php artisan storage:link
   ```

6. **Jalankan Server**:
   ```bash
   php artisan serve --port=8000
   ```
   Aplikasi siap diakses di: [http://localhost:8000](http://localhost:8000)

---

## 🧪 Menjalankan Automated Tests

Seluruh fitur telah diverifikasi menggunakan pengujian komprehensif:
```bash
php artisan test tests/Feature/EReportTest.php
```
Hasil:
```text
PASS  Tests\Feature\EReportTest
✓ 36 passed (179 assertions)
```
