# 1. ¿Qué géneros generan más facturación?

SELECT
    g.Name AS genero,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS total_facturado,
    SUM(il.Quantity) AS canciones_vendidas
FROM InvoiceLine il
JOIN Track t
    ON il.TrackId = t.TrackId
JOIN Genre g
    ON t.GenreId = g.GenreId
GROUP BY
    g.GenreId,
    g.Name
ORDER BY
    total_facturado DESC;
    

# 2. ¿Qué porcentaje de la facturación total representa cada género?

WITH facturacion_genero AS (
    SELECT
        g.Name AS genero,
        SUM(il.UnitPrice * il.Quantity) AS total_facturado
    FROM InvoiceLine il
    JOIN Track t
        ON il.TrackId = t.TrackId
    JOIN Genre g
        ON t.GenreId = g.GenreId
    GROUP BY
        g.GenreId,
        g.Name
)
SELECT
    genero,
    ROUND(total_facturado, 2) AS total_facturado,
    CONCAT(
        ROUND(total_facturado / SUM(total_facturado) OVER() * 100, 2),
        '%'
    ) AS porcentaje_total
FROM facturacion_genero
ORDER BY
    total_facturado DESC;
    
# 3. ¿Qué artistas generan más facturación?

SELECT
    a.Name AS artista,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS total_facturado,
    SUM(il.Quantity) AS canciones_vendidas
FROM InvoiceLine il
JOIN Track t
    ON il.TrackId = t.TrackId
JOIN Album alb
    ON t.AlbumId = alb.AlbumId
JOIN Artist a
    ON alb.ArtistId = a.ArtistId
GROUP BY
    a.ArtistId,
    a.Name
ORDER BY
    total_facturado DESC;
    
# 4. ¿Qué artistas tienen mucho catálogo pero baja facturación por canción?

SELECT
    a.Name AS artista,
    COUNT(DISTINCT t.TrackId) AS canciones_catalogo,
    ROUND(COALESCE(SUM(il.UnitPrice * il.Quantity), 0), 2) AS total_facturado,
    ROUND(
        COALESCE(SUM(il.UnitPrice * il.Quantity), 0) / COUNT(DISTINCT t.TrackId),
        2
    ) AS facturacion_por_cancion
FROM Track t
JOIN Album alb
    ON t.AlbumId = alb.AlbumId
JOIN Artist a
    ON alb.ArtistId = a.ArtistId
LEFT JOIN InvoiceLine il
    ON t.TrackId = il.TrackId
GROUP BY
    a.ArtistId,
    a.Name
ORDER BY
    canciones_catalogo DESC,
    facturacion_por_cancion ASC;
    
# 5. ¿Cuáles son las canciones más vendidas?

SELECT
    t.Name AS cancion,
    a.Name AS artista,
    g.Name AS genero,
    SUM(il.Quantity) AS unidades_vendidas,
    ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS total_facturado
FROM InvoiceLine il
JOIN Track t
    ON il.TrackId = t.TrackId
JOIN Genre g
    ON t.GenreId = g.GenreId
JOIN Album alb
    ON t.AlbumId = alb.AlbumId
JOIN Artist a
    ON alb.ArtistId = a.ArtistId
GROUP BY
    t.TrackId,
    t.Name,
    a.Name,
    g.Name
ORDER BY
    unidades_vendidas DESC,
    total_facturado DESC;
    
# 6. ¿Qué géneros tienen mucho catálogo pero bajo rendimiento comercial?

SELECT
    g.Name AS genero,
    COUNT(DISTINCT t.TrackId) AS canciones_catalogo,
    ROUND(COALESCE(SUM(il.UnitPrice * il.Quantity), 0), 2) AS total_facturado,
    ROUND(
        COALESCE(SUM(il.UnitPrice * il.Quantity), 0) / COUNT(DISTINCT t.TrackId),
        2
    ) AS facturacion_por_cancion
FROM Track t
JOIN Genre g
    ON t.GenreId = g.GenreId
LEFT JOIN InvoiceLine il
    ON t.TrackId = il.TrackId
GROUP BY
    g.GenreId,
    g.Name
ORDER BY
    canciones_catalogo DESC,
    facturacion_por_cancion ASC;
    
