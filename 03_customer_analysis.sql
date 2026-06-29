# Queremos encontrar el mejor cliente de cada país según gasto total.

WITH gasto_total AS (
	SELECT
		c.CustomerId AS Id_cliente,
		COALESCE(c.Company, CONCAT(c.FirstName, ' ', c.LastName)) AS cliente,
		c.Country AS pais,
        SUM(i.Total) AS total_gastado
	FROM
		invoice i
	JOIN customer c
		ON i.CustomerId = c.CustomerId
	GROUP BY
		c.CustomerId,
		c.Company,
        c.Firstname,
        c.Lastname,
        c.Country
),
posicion_ranking_cliente AS (
SELECT 
	id_cliente,
    cliente,
    pais,
    total_gastado,
    ROW_NUMBER() OVER(
							PARTITION BY pais
                            ORDER BY total_gastado DESC
                            ) AS posicion_ranking
FROM
	gasto_total
)
SELECT
	id_cliente,
    cliente,
    pais,
    total_gastado,
    posicion_ranking
FROM 
	posicion_ranking_cliente
WHERE 
	posicion_ranking = 1
ORDER BY
	total_gastado DESC;


# ¿Qué clientes están por encima de la media de gasto de su país?


WITH gasto_por_cliente AS (
    SELECT
        c.CustomerId AS id_cliente,
        COALESCE(c.Company, CONCAT(c.FirstName, ' ', c.LastName)) AS cliente,
        c.Country AS pais,
        SUM(i.Total) AS total_gastado
    FROM Invoice i
    JOIN Customer c
        ON i.CustomerId = c.CustomerId
    GROUP BY
        c.CustomerId,
        c.Company,
        c.FirstName,
        c.LastName,
        c.Country
),
comparacion_media_pais AS (
    SELECT
        id_cliente,
        cliente,
        pais,
        total_gastado,
        AVG(total_gastado) OVER (
            PARTITION BY pais
        ) AS media_pais,
        total_gastado - AVG(total_gastado) OVER (
            PARTITION BY pais
        ) AS diferencia_vs_media
    FROM gasto_por_cliente
)
SELECT
    id_cliente,
    cliente,
    pais,
    ROUND(total_gastado, 2) AS total_gastado,
    ROUND(media_pais, 2) AS media_pais,
    ROUND(diferencia_vs_media, 2) AS diferencia_vs_media
FROM comparacion_media_pais
WHERE diferencia_vs_media > 0
ORDER BY
    pais,
    total_gastado DESC;

# ¿Qué clientes compran más veces y cuánto gastan en total?

SELECT
    c.CustomerId AS id_cliente,
    COALESCE(c.Company, CONCAT(c.FirstName, ' ', c.LastName)) AS cliente,
    c.Country AS pais,
    COUNT(i.InvoiceId) AS numero_compras,
    ROUND(SUM(i.Total), 2) AS total_gastado,
    ROUND(AVG(i.Total), 2) AS ticket_medio
FROM Invoice i
JOIN Customer c
    ON i.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.Company,
    c.FirstName,
    c.LastName,
    c.Country
ORDER BY
    numero_compras DESC,
    total_gastado DESC;
    
# Clientes rentables pero poco frecuentes
## Compran pocas veces, pero tienen un ticket medio alto

WITH metricas_cliente AS (
    SELECT
        c.CustomerId AS id_cliente,
        COALESCE(c.Company, CONCAT(c.FirstName, ' ', c.LastName)) AS cliente,
        c.Country AS pais,
        COUNT(i.InvoiceId) AS numero_compras,
        SUM(i.Total) AS total_gastado,
        AVG(i.Total) AS ticket_medio
    FROM Invoice i
    JOIN Customer c
        ON i.CustomerId = c.CustomerId
    GROUP BY
        c.CustomerId,
        c.Company,
        c.FirstName,
        c.LastName,
        c.Country
),
comparacion_ticket AS (
    SELECT
        id_cliente,
        cliente,
        pais,
        numero_compras,
        total_gastado,
        ticket_medio,
        AVG(ticket_medio) OVER () AS media_ticket_cliente
    FROM metricas_cliente
)
SELECT
    id_cliente,
    cliente,
    pais,
    numero_compras,
    ROUND(total_gastado, 2) AS total_gastado,
    ROUND(ticket_medio, 2) AS ticket_medio,
    ROUND(media_ticket_cliente, 2) AS media_ticket_cliente,
    ROUND(ticket_medio - media_ticket_cliente, 2) AS diferencia_vs_media
FROM comparacion_ticket
WHERE numero_compras <= 7
  AND ticket_medio > media_ticket_cliente
ORDER BY
    ticket_medio DESC,
    total_gastado DESC;   

# Segmentación de clientes según gasto total

WITH metricas_cliente AS (
    SELECT
        c.CustomerId AS id_cliente,
        COALESCE(c.Company, CONCAT(c.FirstName, ' ', c.LastName)) AS cliente,
        c.Country AS pais,
        COUNT(i.InvoiceId) AS numero_compras,
        SUM(i.Total) AS total_gastado,
        AVG(i.Total) AS ticket_medio
    FROM Invoice i
    JOIN Customer c
        ON i.CustomerId = c.CustomerId
    GROUP BY
        c.CustomerId,
        c.Company,
        c.FirstName,
        c.LastName,
        c.Country
)
SELECT
    id_cliente,
    cliente,
    pais,
    numero_compras,
    ROUND(total_gastado, 2) AS total_gastado,
    ROUND(ticket_medio, 2) AS ticket_medio,
    CASE
        WHEN total_gastado >= 45 THEN 'High value'
        WHEN total_gastado >= 40 THEN 'Medium value'
        ELSE 'Low value'
    END AS segmento_cliente
FROM metricas_cliente
ORDER BY
    total_gastado DESC;
    
# Clientes dormidos: clientes cuya última compra fue antes de una fecha determinada

SELECT
    c.CustomerId AS id_cliente,
    COALESCE(c.Company, CONCAT(c.FirstName, ' ', c.LastName)) AS cliente,
    c.Country AS pais,
    DATE(MIN(i.InvoiceDate)) AS primera_compra,
    DATE(MAX(i.InvoiceDate)) AS ultima_compra,
    COUNT(i.InvoiceId) AS numero_compras,
    ROUND(SUM(i.Total), 2) AS total_gastado,
    ROUND(AVG(i.Total), 2) AS ticket_medio
FROM Invoice i
JOIN Customer c
    ON i.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.Company,
    c.FirstName,
    c.LastName,
    c.Country
HAVING
    MAX(i.InvoiceDate) < '2025-01-01'
ORDER BY
    ultima_compra ASC;
