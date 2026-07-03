/* 
=========================================
VIX - Rakamin Academy
Tugas Akhir: Analisis Kinerja Bisnis Kimia Farma (2020-2023)
Peserta: Attar Hanif Kautsar (attarhk.job@gmail.com)
Tamggal: 2 Juli 2026
=========================================
*/

WITH base_data AS (
  SELECT 
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    p.price AS actual_price,
    t.discount_percentage,
    t.rating AS rating_transaksi
  FROM `kimia_farma.kf_final_transaction` AS t
  LEFT JOIN `kimia_farma.kf_kantor_cabang` AS c 
    ON t.branch_id = c.branch_id
  LEFT JOIN `kimia_farma.kf_product` AS p 
    ON t.product_id = p.product_id
)

SELECT 
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,
  
  -- Membuat kolom persentase laba sesuai ketentuan harga
  CASE 
    WHEN actual_price <= 50000 THEN 0.10
    WHEN actual_price > 50000 AND actual_price <= 100000 THEN 0.15
    WHEN actual_price > 100000 AND actual_price <= 300000 THEN 0.20
    WHEN actual_price > 300000 AND actual_price <= 500000 THEN 0.25
    WHEN actual_price > 500000 THEN 0.30
  END AS persentase_gross_laba,
  
  -- Menghitung nilai nett_sales (harga setelah diskon)
  (actual_price - (actual_price * discount_percentage)) AS nett_sales,
  
  -- Menghitung nilai nett_profit (keuntungan dari nett_sales dikalikan persentase laba)
  (actual_price - (actual_price * discount_percentage)) * 
  CASE 
    WHEN actual_price <= 50000 THEN 0.10
    WHEN actual_price > 50000 AND actual_price <= 100000 THEN 0.15
    WHEN actual_price > 100000 AND actual_price <= 300000 THEN 0.20
    WHEN actual_price > 300000 AND actual_price <= 500000 THEN 0.25
    WHEN actual_price > 500000 THEN 0.30
  END AS nett_profit,
  
  rating_transaksi

FROM base_data;