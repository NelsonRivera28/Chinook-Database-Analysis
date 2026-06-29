    ## Análisis temporal de facturación en Chinook 
# 1. Facturación mensual
# 2. Facturación mensual vs mes anterior con LAG()
# 3. Porcentaje de variación mensual
# 4. Ventas acumuladas con SUM() OVER()

# 1, 2 y 3. Queremos ver la evolución mensual de ventas, comparando cada mes contra el anterior.

WITH facturacion_mensual AS (
    SELECT
        DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS mes,
        SUM(i.Total) AS ventas
    FROM Invoice i
    GROUP BY
        DATE_FORMAT(i.InvoiceDate, '%Y-%m')
),
facturacion_mensual_y_previa AS (
    SELECT
        mes,
        ventas,
        LAG(ventas) OVER (ORDER BY mes) AS ventas_mes_anterior,
        ventas - LAG(ventas) OVER (ORDER BY mes) AS diferencia,
        (ventas - LAG(ventas) OVER (ORDER BY mes)) 
            / LAG(ventas) OVER (ORDER BY mes) * 100 AS porcentaje_variacion
    FROM facturacion_mensual
)
SELECT
	mes,
    ROUND(ventas, 2) AS ventas,
    ROUND(ventas_mes_anterior, 2) AS ventas_mes_anterior,
    ROUND(diferencia, 2) AS diferencia,
    ROUND(porcentaje_variacion, 2) AS porcentaje_variacion,
    CASE
        WHEN diferencia < 0 THEN 'Baja'
        WHEN diferencia = 0 THEN 'Igual'
        WHEN diferencia > 0 THEN 'Sube'
        ELSE 'Sin mes anterior'
    END AS comportamiento
FROM facturacion_mensual_y_previa
ORDER BY mes ASC;

# 4. Queremos ver cuánto llevamos facturado acumulado mes a mes y qué porcentaje del total representa cada mes.

WITH facturacion_mensual AS (
    SELECT
		YEAR(i.Invoicedate) AS año,
        DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS mes,
        SUM(i.Total) AS ventas_mes
    FROM Invoice i
    GROUP BY
		YEAR(i.Invoicedate),
        DATE_FORMAT(i.InvoiceDate, '%Y-%m')
),
facturacion_mensual_acumulada AS (
	SELECT
		año,
		mes,
        ventas_mes, 
        SUM(ventas_mes) OVER(
							PARTITION BY año
                            ORDER BY mes) AS ventas_acumuladas
	FROM 
		facturacion_mensual
)
SELECT
	mes,
    ventas_mes,
    ventas_acumuladas,
    CONCAT(ROUND(ventas_mes / SUM(ventas_mes) OVER(
									PARTITION BY año
	) * 100, 0),' %') AS porcentaje_sobre_año
FROM
	facturacion_mensual_acumulada
ORDER BY
	año,
	mes ASC;

# EXTRA. Queremos saber qué meses facturaron por encima de la media mensual de su propio año.

WITH facturacion_mensual AS (
    SELECT
        YEAR(i.InvoiceDate) AS año,
        DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS mes,
        SUM(i.Total) AS ventas_mes
    FROM Invoice i
    GROUP BY
        YEAR(i.InvoiceDate),
        DATE_FORMAT(i.InvoiceDate, '%Y-%m')
),
facturacion_mas_media AS (
    SELECT
        año,
        mes,
        ventas_mes,
        AVG(ventas_mes) OVER (
            PARTITION BY año
        ) AS media_mensual_año
    FROM facturacion_mensual
)
SELECT
    año,
    mes,
    ROUND(ventas_mes, 2) AS ventas_mes,
    ROUND(media_mensual_año, 2) AS media_mensual_año,
    ROUND(ventas_mes - media_mensual_año, 2) AS diferencia_vs_media,
    CASE
        WHEN ventas_mes > media_mensual_año THEN 'Por encima'
        WHEN ventas_mes = media_mensual_año THEN 'Igual'
        WHEN ventas_mes < media_mensual_año THEN 'Por debajo'
    END AS estado
FROM facturacion_mas_media
ORDER BY
    año,
    mes ASC;
    
    