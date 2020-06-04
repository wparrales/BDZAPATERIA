--COMENTARIO:	ADJUNTO EL SCRIPT DE LOS PROCEDIMIENTOS ALMACENADOS CREADOS 
--				PARA GENERAR LA INFORMACIÓN SOLICITADA, AGREGUE VARIOS EN 
--				LOS CASOS DE LAS CONSULTAS PLANTEADAS, SIN EMBARGO COMO
--				LA INDICACIÓN DECÍA QUE AÑADIERAMOS EL ARCHIVO DE LAS 
--				CONSULTAS SELECIONÉ ALGUNAS UTILIZADAS EN LOS PROCEDIMIENTOS


-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Consulta que muestra a través el código de un cliente
--						los productos que han sido comprados por el 
--						cliente, considerando también la información 
--						general de las facturas y además únicamente las 
--						facturas con el estado FACTURADO, ya que podrían 
--						haber facturas anuladas. En esta consulta agregue
--						el filtro de un rango de fechas.
-- =====================================================================

BEGIN
	--Declaro las variables
	DECLARE	@IDCLIENTE		INT
	DECLARE @FECHAINICIAL	DATE
	DECLARE @FECHAFINAL		DATE

	--Asigno los valores
	SET	@IDCLIENTE		= 1				--(Pueden usar los clientes registrados los cuales son del 1 al 10)
	SET @FECHAINICIAL	= '01/05/2020'	--(El rango que poble fué del 01/05/2020 al 03/06/2020)
	SET @FECHAFINAL		= '15/05/2020'
	
	SELECT F.IDFACTURA,F.FECHA,F.TOTAL,
	P.IDPRODUCTO ,P.NOMBRE_P,PRESENTACION_P,
	SUM(CANTIDAD) AS CANTIDAD, 
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 

	FROM FACTURAS F 
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA = FP.IDFACTURA
	INNER JOIN PRODUCTOS P ON FP.IDPRODUCTO = P.IDPRODUCTO
	WHERE F.ESTADO = 'FACTURADO' AND F.IDCLIENTE = @IDCLIENTE  AND FECHA BETWEEN @FECHAINICIAL AND @FECHAFINAL 
	GROUP BY F.IDFACTURA,F.FECHA,F.TOTAL,P.IDPRODUCTO, P.NOMBRE_P,PRESENTACION_P
	ORDER BY P.NOMBRE_P  ASC 

END	



-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Consulta que muestra el detalle de lo facturado 
--						de un producto, con la información
--						de las facturas y clientes,  solo se considerarán
--						las facturas con el estado FACTURADO, ya que 
--						podrían haber facturas anuladas. Se considera
--						un rango de fechas.
-- =====================================================================

BEGIN
	--Declaro las variables
	DECLARE	@IDPRODUCTO		INT
	DECLARE @FECHAINICIAL3	DATE
	DECLARE @FECHAFINAL3	DATE

	--Asigno los valores
	SET	@IDPRODUCTO		= 17			--(Pueden usar los productos registrados los cuales son del 1 al 17)
	SET @FECHAINICIAL3	= '01/05/2020'	--(El rango que poble fué del 01/05/2020 al 03/06/2020)
	SET @FECHAFINAL3	= '15/05/2020'

	SELECT F.IDFACTURA,FECHA,C.NOMBRE_C,
	SUM(CANTIDAD) AS CANTIDAD,
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 
	FROM FACTURAS F 
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA = FP.IDFACTURA
	INNER JOIN CLIENTES C ON C.IDCLIENTE = F.IDCLIENTE
	WHERE F.ESTADO = 'FACTURADO' AND FP.IDPRODUCTO = @IDPRODUCTO 
	GROUP BY F.IDFACTURA,FECHA,C.NOMBRE_C
END
GO



-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Consulta que muestra el detalle de la facturación 
--						para un rango de fechas específico.
-- =====================================================================

BEGIN
	--Declaro las variables
	DECLARE @FECHAINICIAL4	DATE
	DECLARE @FECHAFINAL4	DATE

	--Asigno los valores
	SET @FECHAINICIAL4	= '01/05/2020'	--(El rango que poble fué del 01/05/2020 al 03/06/2020)
	SET @FECHAFINAL4	= '15/05/2020'

	SELECT 
	F.IDFACTURA,FECHA,C.NOMBRE_C,
	P.IDPRODUCTO ,P.NOMBRE_P,PRESENTACION_P,
	SUM(CANTIDAD) AS CANTIDAD,
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 
	FROM FACTURAS F 
	INNER JOIN CLIENTES C			 ON F.IDCLIENTE  = C.IDCLIENTE
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA  = FP.IDFACTURA
	INNER JOIN PRODUCTOS P			 ON P.IDPRODUCTO = FP.IDPRODUCTO 
	WHERE F.ESTADO = 'FACTURADO' AND FECHA BETWEEN @FECHAINICIAL4 AND @FECHAFINAL4 
	GROUP BY F.IDFACTURA,FECHA,C.NOMBRE_C,	P.IDPRODUCTO ,P.NOMBRE_P,PRESENTACION_P
	ORDER BY F.IDFACTURA ASC,P.NOMBRE_P ASC
		
END


-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Consulta que muestra los clientes
--						que han comprado al menos una vez, solo se 
--						consideran las facturas con estado FACTURADO.
-- =====================================================================

BEGIN

	SELECT F.IDCLIENTE, C.NOMBRE_C , C.IDENTIFICACION_C , C.PAIS_C , C.TELEFONO_C ,COUNT(IDFACTURA) AS CANTIDAD_FACTURAS_REALIZADAS
	FROM FACTURAS F
	INNER JOIN CLIENTES C ON F.IDCLIENTE = C.IDCLIENTE 
	WHERE F.ESTADO = 'FACTURADO'
	GROUP BY F.IDCLIENTE, C.NOMBRE_C , C.IDENTIFICACION_C , C.PAIS_C , C.TELEFONO_C 
	
END

