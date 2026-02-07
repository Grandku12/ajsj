-- listkey.lua
-- Upload file ini ke GitHub dan ambil link RAW-nya.

local valid_keys = {
    -- Format: ["KEY"] = TIMESTAMP_KADALUARSA
    -- Gunakan https://www.unixtimestamp.com/ untuk konversi waktu
    -- [AUTOSAVE_MARKER]
    ["GRAND-DEMO-KEY"] = 2147483647, -- Key Permanen (Tahun 2038)
    ["GRAND-TRIAL-1DAY"] = os.time() + 86400, -- Key 24 Jam dari sekarang

    ["KEY-DBMGX43M"] = 1770558449, -- User: 202005022
    ["KEY-J11RA7RM"] = 1770558464, -- User: 202005022
    ["KEY-F1LRLXOM"] = 1770559574, -- User: 202005022}

return valid_keys
