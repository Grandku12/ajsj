-- listkey.lua
-- Upload file ini ke GitHub dan ambil link RAW-nya.

local valid_keys = {
    -- Format: ["KEY"] = TIMESTAMP_KADALUARSA
    -- Gunakan https://www.unixtimestamp.com/ untuk konversi waktu
    -- [AUTOSAVE_MARKER]
    ["GRAND-DEMO-KEY"] = 2147483647, -- Key Permanen (Tahun 2038)
    ["GRAND-TRIAL-1DAY"] = os.time() + 86400, -- Key 24 Jam dari sekarang
}

return valid_keys
