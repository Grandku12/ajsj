# Grandfuscator Key System Integration Guide

Panduan ini menjelaskan cara menghubungkan **Key Generator** di web dengan script Lua Anda (Growtopia/Roblox/dll).

## 1. Persiapan GitHub (`key.lua`)

Pastikan file `key.lua` di repository `Grandku12/ajsj` memiliki struktur awal seperti ini agar Key Generator bisa memasukkan key baru dengan benar.

**File:** `https://github.com/Grandku12/ajsj/blob/main/key.lua`

```lua
-- Database Key Grandfuscator
-- Format: keys["KEY-XXXX"] = TIMESTAMP_EXPIRY

keys = {
    -- Key Generator akan otomatis menambahkan key di sini
    -- Contoh: ["KEY-TEST1"] = 1798765432, 
}
```

---

## 2. Script Loader (Client Side)

Ini adalah script yang Anda berikan kepada pengguna (atau di-obfuscate). Script ini bertugas meminta Key, mendownload database dari GitHub, mengecek validitas, dan menjalankan script asli jika valid.

### Contoh Code Lua (Universal/Growtopia Executor)

Sesuaikan fungsi `http.request` dengan executor yang Anda gunakan (misal: PowerKuy, Genta, dll).

```lua
-- === KONFIGURASI ===
local raw_key_url = "https://raw.githubusercontent.com/Grandku12/ajsj/main/key.lua"
local main_script_url = "https://raw.githubusercontent.com/Grandku12/ajsj/main/script_asli_anda.lua" -- Script rahasia
-- ===================

-- Dialog Input Key (Contoh Sederhana)
-- Ganti ini dengan dialog GUI executor Anda
print("Masukkan Key Anda:")
local user_key = "KEY-DARI-INPUT-USER" -- Ganti variabel ini dengan hasil input dialog

-- Fungsi Helper untuk Download
function downloadContent(url)
    -- Ganti dengan fungsi HTTP request executor Anda
    -- Contoh umum:
    local client = http.request("GET", url)
    if client.response_code == 200 then
        return client.body
    end
    return nil
end

print("Memeriksa Key...")

-- 1. Inisialisasi tabel keys global
keys = {}

-- 2. Download Database Key dari GitHub
local key_data = downloadContent(raw_key_url)

if not key_data or key_data == "" then
    print("Gagal terhubung ke server database.")
    return
end

-- 3. Load String Lua dari GitHub agar tabel 'keys' terisi
local load_db, err = load(key_data)
if not load_db then
    print("Error parsing database: " .. err)
    return
end

load_db() -- Eksekusi database untuk mengisi tabel 'keys'

-- 4. Validasi Key
local expiry_time = keys[user_key]

if expiry_time then
    local current_time = os.time()
    
    if current_time < expiry_time then
        local days_left = math.floor((expiry_time - current_time) / 86400)
        print("Key Valid! Akses Diterima.")
        print("Sisa Waktu: " .. days_left .. " Hari.")
        
        -- 5. Jalankan Script Asli (Load & Execute)
        local script_content = downloadContent(main_script_url)
        if script_content then
            local run_script, script_err = load(script_content)
            if run_script then
                run_script()
            else
                print("Error pada script utama: " .. script_err)
            end
        else
            print("Gagal mendownload script utama.")
        end
    else
        print("Key Kadaluarsa (Expired). Silahkan generate key baru di web.")
    end
else
    print("Key Tidak Valid / Tidak Ditemukan.")
end
```

## 3. Cara Kerja Sistem Auto-Delete

Di Web `KeyGenerator.tsx`, kami telah menambahkan fitur **Lazy Cleanup**.

1. Setiap kali halaman Key Generator dibuka (terutama oleh Owner), sistem akan mengecek tanggal kadaluarsa semua key.
2. Jika ada key yang `expiry timestamp < waktu sekarang`, sistem akan:
   - Menghapus key dari Firebase Database.
   - Mendownload file `key.lua` dari GitHub.
   - Menghapus baris key tersebut dari file.
   - Mengupload ulang file bersih ke GitHub.

Ini menjaga file `key.lua` tetap bersih dan tidak penuh dengan sampah key lama.
