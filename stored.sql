USE [RVDESA]
GO
/****** Object:  StoredProcedure [dbo].[CON_PA_CONT_RESP_TRIBUTARIA]    Script Date: 26/10/2017 14:06:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CON_PA_CONT_RESP_TRIBUTARIA]
(
	--Parametros del procedimiento almacenado
	@opt INTEGER,
	@idpkus INTEGER,
	@codresp VARCHAR(2),
	@nomresp VARCHAR(200),
	@estresp BIT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	PRINT 'Procedimiento SYS_PA_CONT_RESP_TRIBUTARIA'
	
	--Validar si la llave primera es nula o vacia
	IF @idpkus IS NULL OR @idpkus = ''
	BEGIN
		SET @idpkus = 0
	END
	
	--Variable del resultado de la consulta
	DECLARE @resu INT
	DECLARE @resu1 INT
	DECLARE @resultado VARCHAR(50)
	
	--Variable 
	DECLARE @Usuoper VARCHAR(50)
	
	--Variable respuesta errores
	SELECT @Usuoper = suser_name()
	
	-- Seleccionar todas las responsabilidades
	IF @opt=1
	BEGIN
		BEGIN TRY
			BEGIN
				SELECT 
					PK_COD_CONT_RESP,
					CONT_COD_RESP,
					CONR_NOMBRE_RESP,
					CON_RES_ACTIVO
				FROM
					CON_RESP_TRIBUTARIA
			END
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS MSG
		END CATCH
		
	END
	
	-- Seleccionar una responsabilidad específica
	IF @opt=2
	
	BEGIN
		BEGIN TRY
			--Asignar 1 a la consulta
			SELECT 
				@resu1=1
			FROM
				CON_RESP_TRIBUTARIA
			WHERE
				PK_COD_CONT_RESP = @idpkus
			OR 
				CONT_COD_RESP LIKE '%' + @codresp + '%'
			OR 
				CONR_NOMBRE_RESP LIKE '%' + @nomresp + '%'
 			
 			--Seleccionar un registro respecto al id
 			IF 	@resu1 = 1
 			BEGIN
				SELECT 
					PK_COD_CONT_RESP, 
					CONT_COD_RESP, 
					CONR_NOMBRE_RESP,
					CON_RES_ACTIVO,
					'Datos Obtenidos' AS respuesta
				FROM 
					dbo.CON_RESP_TRIBUTARIA  
				WHERE
					PK_COD_CONT_RESP=@idpkus
				OR 
					CONT_COD_RESP=@codresp
				OR 
					CONR_NOMBRE_RESP LIKE '%' + @nomresp + '%'
			END
			ELSE
			BEGIN
				SELECT
				0 AS PK_COD_CONT_RESP,
				'' AS CONT_COD_RESP,
				'' AS CONR_NOMBRE_RESP,
				CONVERT (BIT, 0) AS CON_RES_ACTIVO,
				'No se encontraron registros' AS respuesta
			END	   
									
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS MSG
		END CATCH
	END
	
	--Insertar una nueva responsabilidad
	IF @opt=3
	BEGIN
		-- Inicializar resultado
		SET @resu = 0
		
		--Consulto si hay coincidencias
		SELECT 
			@resu=1
		FROM
			CON_RESP_TRIBUTARIA
		WHERE
			PK_COD_CONT_RESP = @idpkus
		OR 
			CONT_COD_RESP = @codresp
		OR 
			CONR_NOMBRE_RESP = @nomresp 
		
		--Verificar si el registro ya existe
		IF(@resu = 1)
		BEGIN
			SELECT 0 AS PK_COD_CONT_RESP , '0' AS CONT_COD_RESP ,'0' AS CONR_NOMBRE_RESP , CONVERT (BIT , 0) AS CON_RES_ACTIVO , 'La responsabilidad ya existe' AS respuesta
		END
		ELSE
		BEGIN
			BEGIN TRY
				BEGIN TRAN InsertarResponsabilidad
					BEGIN 
						-- Se hace la inserción en la tabla de responsabilidades
						INSERT INTO CON_RESP_TRIBUTARIA (CONT_COD_RESP , CONR_NOMBRE_RESP , CON_RES_ACTIVO) VALUES (@codresp, @nomresp , 1)
					
						SELECT 0 AS PK_COD_CONT_RESP , '0' AS CONT_COD_RESP ,'0' AS CONR_NOMBRE_RESP , CONVERT (BIT , 0) AS CON_RES_ACTIVO , 'Inserto responsabilidad:' AS respuesta
					
						--Registrar el evento
						SELECT @resultado = 'Inserto Responsabilidad: '+ @nomresp
						EXEC SYS_PA_AUD_INS_EVENTO 1, @Usuoper ,1,1,2,@resu
					END
				COMMIT TRAN InsertarResponsabilidad
			END TRY
			BEGIN CATCH
				ROLLBACK TRAN InsertarRespinsabilidad
					SELECT 0 AS PK_COD_CONT_RESP , 
						'0' AS CONT_COD_RESP , 
						'0' AS CONR_NOMBRE_RESP, 
						CONVERT(BIT, 0) AS CON_RES_ACTIVO,
						'No se creo la responsabilidad' AS respuesta
				
					-- Registrar el evento
					SELECT @resultado = 'Genero error'+ ERROR_MESSAGE()
					EXEC SYS_PA_AUD_INS_EVENTO 1, @Usuoper ,1,1,2,@resu
			END CATCH
		END
	END
	
	-- Actualización de una Responsabilidad
	IF @opt=4
	BEGIN
		BEGIN TRY
			BEGIN TRAN ActualizarResponsabilidad
				-- Actualizar los datos de una responsabilidad
				UPDATE 
					CON_RESP_TRIBUTARIA 
				SET 
					CONT_COD_RESP = @codresp,
					CONR_NOMBRE_RESP = @nomresp
				WHERE
					PK_COD_CONT_RESP = @idpkus
				
				-- Registrar el evento
				SELECT @resultado='Se actualizo el estado de la responsabilidad ' + @Usuoper
				EXEC SYS_PA_AUD_INS_EVENTO 1,@UsuOper,1,1,2,@resu	

				-- Verificar la actualización de la responsabilidad
				SELECT 
				0 AS PK_COD_CONT_RESP
				, '' AS CONT_COD_RESP
				, '' AS CONR_NOMBRE_RESP
				, CONVERT (bit , 0) AS CON_RES_ACTIVO	
				, 'Responsabilidad Actualizada' AS respuesta
			COMMIT TRAN ActualizarResponsabilidad
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN ActualizarResponsabilidad
				SELECT 
				0 AS PK_COD_CONT_RESP
				, '' AS CONT_COD_RESP
				, '' AS CONR_NOMBRE_RESP	
				, CONVERT (bit, 0) AS CON_RES_ACTIVO
				, 'Hubo un error durante la actualizacion' AS respuesta
				
				-- Registrar el evento
				SELECT @resultado='Genero error ' + @Usuoper
				EXEC SYS_PA_AUD_INS_EVENTO 1,@UsuOper,1,1,2,@resu	
		END CATCH
	END

	-- Cambiar el estado de una responsabilidad
	IF @opt=5
	BEGIN
		BEGIN TRY
			BEGIN TRAN EstadoResponsabilidad
				IF @estresp = 1
				BEGIN
						UPDATE
							CON_RESP_TRIBUTARIA
						SET 
							CON_RES_ACTIVO = 0
						WHERE
							PK_COD_CONT_RESP = @idpkus

						-- Verificar la actualización de la responsabilidad
					SELECT 
					0 AS PK_COD_CONT_RESP
					, '' AS CONT_COD_RESP
					, '' AS CONR_NOMBRE_RESP
					, CONVERT (bit , 0) AS CON_RES_ACTIVO	
					, 'Responsabilidad Actualizada' AS respuesta
			
					-- Registrar el evento
					SELECT @resultado='Se actualizo el estado de la responsabilidad ' + @Usuoper
					EXEC SYS_PA_AUD_INS_EVENTO 1,@UsuOper,1,1,2,@resu	
				END

				ELSE IF @estresp = 0
				BEGIN
					UPDATE
						CON_RESP_TRIBUTARIA
					SET
						CON_RES_ACTIVO = 1
					WHERE
						PK_COD_CONT_RESP = @idpkus

						-- Verificar la actualización de la responsabilidad
						SELECT 
						0 AS PK_COD_CONT_RESP
						, '' AS CONT_COD_RESP
						, '' AS CONR_NOMBRE_RESP
						, CONVERT (bit , 0) AS CON_RES_ACTIVO	
						, 'Responsabilidad Actualizada' AS respuesta
			
						-- Registrar el evento
						SELECT @resultado='Se actualizo el estado de la responsabilidad ' + @Usuoper
						EXEC SYS_PA_AUD_INS_EVENTO 1,@UsuOper,1,1,2,@resu	
				END

			
				ELSE
				BEGIN
					-- mensaje
						SELECT 
						0 AS PK_COD_CONT_RESP
						, '' AS CONT_COD_RESP
						, '' AS CONR_NOMBRE_RESP
						, CONVERT (bit , 0) AS CON_RES_ACTIVO	
						, 'No se actualizo la responsabilidad estado no permitido' AS respuesta
			
						-- Registrar el evento
						SELECT @resultado='No se permite actualizar la responsabilidad ' + @Usuoper
						EXEC SYS_PA_AUD_INS_EVENTO 1,@UsuOper,1,1,2,@resu	
				END
			COMMIT TRAN EstadoResponsabilidad
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN EstadoResponsabilidad
				SELECT 
				0 AS PK_COD_CONT_RESP
				, '' AS CONT_COD_RESP
				, '' AS CONR_NOMBRE_RESP	
				, CONVERT (bit, 0) AS CON_RES_ACTIVO
				, 'Hubo un error durante el cambio de estado de la responsabilidad' AS respuesta
				
				-- Registrar el evento
				SELECT @resultado='Genero error ' + @Usuoper
				EXEC SYS_PA_AUD_INS_EVENTO 1,@UsuOper,1,1,2,@resu	
		END CATCH
	END
END
PRINT 'Procedimiento CON_PA_CONT_RESP_TRIBUTARIA listo para su uso'