# 1. Facturación total, número de facturas y ticket medio general

SELECT
    ROUND(SUM(Total), 2) AS facturacion_total,
    COUNT(InvoiceId) AS numero_facturas,
    ROUND(AVG(Total), 2) AS ticket_medio
FROM Invoice;


# 2. Facturación por país

SELECT
    BillingCountry AS pais,
    ROUND(SUM(Total), 2) AS facturacion_total,
    COUNT(InvoiceId) AS numero_facturas,
    ROUND(AVG(Total), 2) AS ticket_medio
FROM Invoice
GROUP BY
    BillingCountry
ORDER BY
    facturacion_total DESC;


# 3. Países con más clientes y más ingresos

SELECT
    c.Country AS pais,
    COUNT(DISTINCT c.CustomerId) AS numero_clientes,
    ROUND(SUM(i.Total), 2) AS facturacion_total,
    ROUND(SUM(i.Total) / COUNT(DISTINCT c.CustomerId), 2) AS gasto_medio_por_cliente
FROM Customer c
JOIN Invoice i
    ON c.CustomerId = i.CustomerId
GROUP BY
    c.Country
ORDER BY
    facturacion_total DESC;


# 4. Ticket medio por país

SELECT
    BillingCountry AS pais,
    COUNT(InvoiceId) AS numero_facturas,
    ROUND(SUM(Total), 2) AS facturacion_total,
    ROUND(AVG(Total), 2) AS ticket_medio
FROM Invoice
GROUP BY
    BillingCountry
ORDER BY
    ticket_medio DESC;


# 5. Países por encima o debajo de la media de facturación por país

WITH facturacion_pais AS (
    SELECT
        BillingCountry AS pais,
        ROUND(SUM(Total), 2) AS facturacion_total,
        COUNT(InvoiceId) AS numero_facturas,
        ROUND(AVG(Total), 2) AS ticket_medio
    FROM Invoice
    GROUP BY
        BillingCountry
),
comparacion_media AS (
    SELECT
        pais,
        facturacion_total,
        numero_facturas,
        ticket_medio,
        AVG(facturacion_total) OVER () AS media_facturacion_paises,
        facturacion_total - AVG(facturacion_total) OVER () AS diferencia_vs_media
    FROM facturacion_pais
)
SELECT
    pais,
    facturacion_total,
    ROUND(media_facturacion_paises, 2) AS media_facturacion_paises,
    ROUND(diferencia_vs_media, 2) AS diferencia_vs_media,
    CASE
        WHEN diferencia_vs_media > 0 THEN 'Por encima'
        WHEN diferencia_vs_media < 0 THEN 'Por debajo'
        ELSE 'En la media'
    END AS estado_facturacion
FROM comparacion_media
ORDER BY
    facturacion_total DESC;