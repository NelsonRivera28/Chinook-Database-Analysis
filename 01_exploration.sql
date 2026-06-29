# 1. Número total de clientes

SELECT
    COUNT(CustomerId) AS numero_clientes
FROM Customer;


# 2. Número total de facturas

SELECT
    COUNT(InvoiceId) AS numero_facturas
FROM Invoice;


# 3. Número total de canciones/tracks en catálogo

SELECT
    COUNT(TrackId) AS numero_tracks
FROM Track;


# 4. Rango de fechas cubierto por las ventas

SELECT
    DATE(MIN(InvoiceDate)) AS primera_fecha_venta,
    DATE(MAX(InvoiceDate)) AS ultima_fecha_venta,
    DATEDIFF(MAX(InvoiceDate), MIN(InvoiceDate)) AS dias_cubiertos
FROM Invoice;


# 5. Número de géneros, artistas y álbumes

SELECT
    (SELECT COUNT(GenreId) FROM Genre) AS numero_generos,
    (SELECT COUNT(ArtistId) FROM Artist) AS numero_artistas,
    (SELECT COUNT(AlbumId) FROM Album) AS numero_albumes;


# 6. Países donde hay clientes

SELECT
    Country AS pais,
    COUNT(CustomerId) AS numero_clientes
FROM Customer
GROUP BY
    Country
ORDER BY
    numero_clientes DESC,
    pais;


# 7. Vista rápida de facturas con cliente

SELECT
    i.InvoiceId AS id_factura,
    DATE(i.InvoiceDate) AS fecha_factura,
    COALESCE(c.Company, CONCAT(c.FirstName, ' ', c.LastName)) AS cliente,
    c.Country AS pais_cliente,
    i.BillingCountry AS pais_facturacion,
    ROUND(i.Total, 2) AS total_factura
FROM Invoice i
JOIN Customer c
    ON i.CustomerId = c.CustomerId
ORDER BY
    i.InvoiceDate
LIMIT 20;


# 8. Número de facturas por cliente

SELECT
    c.CustomerId AS id_cliente,
    COALESCE(c.Company, CONCAT(c.FirstName, ' ', c.LastName)) AS cliente,
    c.Country AS pais,
    COUNT(i.InvoiceId) AS numero_facturas
FROM Customer c
LEFT JOIN Invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY
    c.CustomerId,
    c.Company,
    c.FirstName,
    c.LastName,
    c.Country
ORDER BY
    numero_facturas DESC;


# 9. Número de canciones por género en el catálogo

SELECT
    g.Name AS genero,
    COUNT(t.TrackId) AS numero_tracks
FROM Genre g
LEFT JOIN Track t
    ON g.GenreId = t.GenreId
GROUP BY
    g.GenreId,
    g.Name
ORDER BY
    numero_tracks DESC;


# 10. Número de álbumes por artista

SELECT
    a.Name AS artista,
    COUNT(alb.AlbumId) AS numero_albumes
FROM Artist a
LEFT JOIN Album alb
    ON a.ArtistId = alb.ArtistId
GROUP BY
    a.ArtistId,
    a.Name
ORDER BY
    numero_albumes DESC;
    
# Resumen general del dataset

SELECT 'Clientes' AS metrica, COUNT(*) AS valor
FROM Customer

UNION ALL

SELECT 'Facturas' AS metrica, COUNT(*) AS valor
FROM Invoice

UNION ALL

SELECT 'Tracks' AS metrica, COUNT(*) AS valor
FROM Track

UNION ALL

SELECT 'Géneros' AS metrica, COUNT(*) AS valor
FROM Genre

UNION ALL

SELECT 'Artistas' AS metrica, COUNT(*) AS valor
FROM Artist

UNION ALL

SELECT 'Álbumes' AS metrica, COUNT(*) AS valor
FROM Album;