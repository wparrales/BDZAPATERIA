USE [BDZAPATERIA]
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_CLIENTE_DETALLE_FACTURAS_CON_PRODUCTOS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle 
--						de los productos que han sido comprados por el 
--						cliente, considerando también la información 
--						general de las facturas y además únicamente las 
--						facturas con el estado FACTURADO, ya que podrían 
--						haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_CLIENTE_DETALLE_FACTURAS_CON_PRODUCTOS]
	@IDCLIENTE		INT
AS
BEGIN

	SELECT F.IDFACTURA,F.FECHA,F.TOTAL,P.IDPRODUCTO ,P.NOMBRE_P,PRESENTACION_P,
	SUM(CANTIDAD) AS CANTIDAD, 
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 

	FROM FACTURAS F 
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA = FP.IDFACTURA
	INNER JOIN PRODUCTOS P ON FP.IDPRODUCTO = P.IDPRODUCTO
	WHERE F.ESTADO = 'FACTURADO' AND F.IDCLIENTE = @IDCLIENTE 
	GROUP BY F.IDFACTURA,F.FECHA,F.TOTAL,P.IDPRODUCTO, P.NOMBRE_P,PRESENTACION_P
	ORDER BY P.NOMBRE_P  ASC 

	--En mi país el valor del Impuesto es de 15% utilice este valor como referencia en la prueba.

END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_CLIENTE_DETALLE_FACTURAS_CON_PRODUCTOS_RANGO_FECHAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle 
--						de los productos que han sido comprados por el 
--						cliente, en un rango de fechas específico 
--						considerando también la información 
--						general de las facturas y además únicamente las 
--						facturas con el estado FACTURADO, ya que podrían 
--						haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_CLIENTE_DETALLE_FACTURAS_CON_PRODUCTOS_RANGO_FECHAS]
	@IDCLIENTE		INT,
	@FECHAINICIAL	DATE,
	@FECHAFINAL		DATE

AS
BEGIN

	SELECT F.IDFACTURA,F.FECHA,F.TOTAL,P.IDPRODUCTO ,P.NOMBRE_P,PRESENTACION_P,
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

	--En mi país el valor del Impuesto es de 15% utilice este valor como referencia en la prueba.

END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_CLIENTE_DETALLE_PRODUCTOS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle 
--						de los productos que han sido comprados por el 
--						cliente, considerando únicamente las facturas 
--						con el estado FACTURADO, ya que podrían haber 
--						facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_CLIENTE_DETALLE_PRODUCTOS]
	@IDCLIENTE		INT
AS
BEGIN

	SELECT P.IDPRODUCTO ,P.NOMBRE_P,PRESENTACION_P,
	SUM(CANTIDAD) AS CANTIDAD, 
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 

	FROM FACTURAS F 
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA = FP.IDFACTURA
	INNER JOIN PRODUCTOS P ON FP.IDPRODUCTO = P.IDPRODUCTO
	WHERE F.ESTADO = 'FACTURADO' AND F.IDCLIENTE = @IDCLIENTE 
	GROUP BY P.IDPRODUCTO, P.NOMBRE_P,PRESENTACION_P
	ORDER BY P.NOMBRE_P  ASC 

	--En mi país el valor del Impuesto es de 15% utilice este valor como referencia en la prueba.

END

GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_CLIENTE_DETALLE_PRODUCTOS_RANGO_FECHAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle 
--						de los productos que han sido comprados por el 
--						cliente, además se utilizan los filtros de rango
--						de fechas para poder filtrar solo lo comprado 
--						en dicho rango de fechas además considerando 
--						únicamente las facturas con el estado FACTURADO, 
--						ya que podrían haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_CLIENTE_DETALLE_PRODUCTOS_RANGO_FECHAS]
	@IDCLIENTE		INT,
	@FECHAINICIAL	DATE,
	@FECHAFINAL		DATE
AS
BEGIN

	SELECT P.IDPRODUCTO ,P.NOMBRE_P,PRESENTACION_P,
	SUM(CANTIDAD) AS CANTIDAD, 
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, 
	SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 

	FROM FACTURAS F 
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA = FP.IDFACTURA
	INNER JOIN PRODUCTOS P ON FP.IDPRODUCTO = P.IDPRODUCTO
	WHERE F.ESTADO = 'FACTURADO' AND F.IDCLIENTE = @IDCLIENTE  AND FECHA BETWEEN @FECHAINICIAL AND @FECHAFINAL
	GROUP BY P.IDPRODUCTO, P.NOMBRE_P,PRESENTACION_P
	ORDER BY P.NOMBRE_P  ASC 

	--En mi país el valor del Impuesto es de 15% utilice este valor como referencia en la prueba.
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_CLIENTE_LISTADO_FACTURAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle 
--						de las facturas que ha realizado el cliente
--						solo se mostrarán las facturas con el estado 
--						FACTURADO, ya que podrían haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_CLIENTE_LISTADO_FACTURAS]
	@IDCLIENTE		INT
AS
BEGIN

	SELECT F.IDFACTURA,F.FECHA,F.TOTAL
	FROM FACTURAS F 
	WHERE F.ESTADO = 'FACTURADO' AND F.IDCLIENTE = @IDCLIENTE 
	GROUP BY F.IDFACTURA,F.FECHA,F.TOTAL
	ORDER BY F.IDFACTURA   ASC 
		
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_CLIENTE_LISTADO_FACTURAS_RANGO_FECHAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle 
--						de las facturas que ha realizado el cliente
--						solo se mostrarán las facturas con el estado 
--						FACTURADO, ya que podrían haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_CLIENTE_LISTADO_FACTURAS_RANGO_FECHAS]
	@IDCLIENTE		INT,
	@FECHAINICIAL	DATE,
	@FECHAFINAL		DATE
AS
BEGIN

	SELECT F.IDFACTURA,F.FECHA,F.TOTAL
	FROM FACTURAS F 
	WHERE F.ESTADO = 'FACTURADO' AND F.IDCLIENTE = @IDCLIENTE  AND FECHA BETWEEN @FECHAINICIAL AND @FECHAFINAL
	GROUP BY F.IDFACTURA,F.FECHA,F.TOTAL
	ORDER BY F.IDFACTURA   ASC 

	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_PRODUCTO_DETALLADO]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle
--						de lo facturado de un producto, con la información
--						de las facturas y clientes,  solo se considerarán
--						las facturas con el estado FACTURADO, ya que 
--						podrían haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_PRODUCTO_DETALLADO]
	@IDPRODUCTO		INT
AS
BEGIN

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
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_PRODUCTO_DETALLADO_RANGO_FECHAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle
--						de lo facturado de un producto, según un rango de 
--						fechas seleccionado, mostrando la información
--						de las facturas y clientes,  solo se considerarán
--						las facturas con el estado FACTURADO, ya que 
--						podrían haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_PRODUCTO_DETALLADO_RANGO_FECHAS]
	@IDPRODUCTO		INT,
	@FECHAINICIAL	DATE,
	@FECHAFINAL		DATE
AS
BEGIN

	SELECT F.IDFACTURA,FECHA,C.NOMBRE_C,
	SUM(CANTIDAD) AS CANTIDAD,
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 
	FROM FACTURAS F 
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA = FP.IDFACTURA
	INNER JOIN CLIENTES C ON C.IDCLIENTE = F.IDCLIENTE
	WHERE F.ESTADO = 'FACTURADO' AND FP.IDPRODUCTO = @IDPRODUCTO  AND FECHA BETWEEN @FECHAINICIAL AND @FECHAFINAL
	GROUP BY F.IDFACTURA,FECHA,C.NOMBRE_C
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_PRODUCTO_TOTAL]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el total
--						facturado de un producto solo se considerarán
--						las facturas con el estado FACTURADO, ya que 
--						podrían haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_PRODUCTO_TOTAL]
	@IDPRODUCTO		INT
AS
BEGIN

	SELECT SUM(CANTIDAD) AS CANTIDAD,
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 
	FROM FACTURAS F 
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA = FP.IDFACTURA
	WHERE F.ESTADO = 'FACTURADO' AND FP.IDPRODUCTO = @IDPRODUCTO 

END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_PRODUCTO_TOTAL_RANGO_FECHAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el total
--						facturado de un producto en un rango de fechas
--						específico, solo se considerarán
--						las facturas con el estado FACTURADO, ya que 
--						podrían haber facturas anuladas.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_PRODUCTO_TOTAL_RANGO_FECHAS]
	@IDPRODUCTO		INT,
	@FECHAINICIAL	DATE,
	@FECHAFINAL		DATE
AS
BEGIN

	SELECT SUM(CANTIDAD) AS CANTIDAD,
	SUM(CANTIDAD*PRECIO_VTA) AS SUBTOTAL1,
	CAST(SUM((CANTIDAD*DESCUENTO_POR_CANTIDAD)+(CANTIDAD*PRECIO_VTA*DESCUENTO_POR_PORCENTAJE/100.00)) AS DECIMAL(18,2)) AS DESCUENTO,
	SUM(SUBTOTAL) AS SUBTOTAL2, SUM(CASE APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END) AS IMPUESTO, 
	SUM((SUBTOTAL)+(CASE FP.APLICA_IMPUESTO_FL WHEN 'S' THEN 0.15*SUBTOTAL ELSE 0 END)) AS TOTAL_CON_IMPUESTO 
	FROM FACTURAS F 
	INNER JOIN FACTURAS_PRODUCTOS FP ON F.IDFACTURA = FP.IDFACTURA
	WHERE F.ESTADO = 'FACTURADO' AND FP.IDPRODUCTO = @IDPRODUCTO AND FECHA BETWEEN @FECHAINICIAL AND @FECHAFINAL 
		
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_RANGO_FECHAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle
--						de la facturación para un rango de fechas 
--						específico.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_RANGO_FECHAS]
	@FECHAINICIAL	DATE,
	@FECHAFINAL		DATE
AS
BEGIN

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
	WHERE F.ESTADO = 'FACTURADO' AND FECHA BETWEEN @FECHAINICIAL AND @FECHAFINAL 
	GROUP BY F.IDFACTURA,FECHA,C.NOMBRE_C,	P.IDPRODUCTO ,P.NOMBRE_P,PRESENTACION_P
	ORDER BY F.IDFACTURA ASC,P.NOMBRE_P ASC
		
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_SOLO_CLIENTES_UNICOS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra los clientes
--						que han comprado al menos una vez, solo se 
--						consideran las facturas con estado FACTURADO.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_SOLO_CLIENTES_UNICOS]
	
AS
BEGIN

	SELECT F.IDCLIENTE, C.NOMBRE_C , C.IDENTIFICACION_C , C.PAIS_C , C.TELEFONO_C ,COUNT(IDFACTURA) AS CANTIDAD_FACTURAS_REALIZADAS
	FROM FACTURAS F
	INNER JOIN CLIENTES C ON F.IDCLIENTE = C.IDCLIENTE 
	WHERE F.ESTADO = 'FACTURADO'
	GROUP BY F.IDCLIENTE, C.NOMBRE_C , C.IDENTIFICACION_C , C.PAIS_C , C.TELEFONO_C 
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_SOLO_CLIENTES_UNICOS_RANGO_FECHAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra los clientes
--						que han comprado al menos una vez en un rango de
--						fechas específico, solo se consideran las facturas 
--						con estado FACTURADO.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_FACTURACION_SOLO_CLIENTES_UNICOS_RANGO_FECHAS]
	@FECHAINICIAL	DATE,
	@FECHAFINAL		DATE
AS
BEGIN

	SELECT F.IDCLIENTE, C.NOMBRE_C , C.IDENTIFICACION_C , C.PAIS_C , C.TELEFONO_C ,COUNT(IDFACTURA) AS CANTIDAD_FACTURAS_REALIZADAS
	FROM FACTURAS F
	INNER JOIN CLIENTES C ON F.IDCLIENTE = C.IDCLIENTE 
	WHERE F.ESTADO = 'FACTURADO' AND FECHA BETWEEN @FECHAINICIAL AND @FECHAFINAL
	GROUP BY F.IDCLIENTE, C.NOMBRE_C , C.IDENTIFICACION_C , C.PAIS_C , C.TELEFONO_C 
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_FACTURACION_SOLO_CLIENTES_UNICOS_RANGO_FECHAS]    Script Date: 04/06/2020 03:37:24 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =====================================================================
-- Autor:				Wilfredo Parrales
-- Fecha de Creación:	04/06/2020
-- Descripción:			Procedimiento Almacenado que muestra el detalle 
--						de movimientos de inventario de un producto.
-- =====================================================================

CREATE PROCEDURE [dbo].[SP_REPORTE_MOVIMIENTO_INVENTARIO]
	@IDPRODUCTO		INT
AS
BEGIN

	SELECT IDMOVIMIENTO,FECHA_M,TIPO_M,CONCEPTO, 
	CASE MI.TIPO_M WHEN 'SALIDA' THEN -CANTIDAD ELSE CANTIDAD END AS CANTIDAD,
	SUM(case MI.TIPO_M when 'SALIDA' then -CANTIDAD else
		CANTIDAD 
		end
		) OVER (PARTITION BY MI.IDPRODUCTO
		ORDER BY MI.IDMOVIMIENTO ASC) AS SALDO_ACUMULADO
	
	FROM MOVIMIENTO_INVENTARIO MI
	WHERE IDPRODUCTO = @IDPRODUCTO  
	ORDER BY IDMOVIMIENTO ASC 

END