DELIMITER $$
CREATE PROCEDURE `usp_restEmitirVentaDet`(IN `_flag` INT(11), IN `_id_venta` INT(11), IN `_id_pedido` INT(11), IN `_fecha` DATETIME)
BEGIN
    
	DECLARE _idprod INT; 
	DECLARE _cantidad1 INT;
	DECLARE _precio1 FLOAT;
	DECLARE _receta INT;
	DECLARE _tipopedido INT;
	DECLARE _controlstock INT;
	DECLARE done INT DEFAULT 0;
	
	DECLARE _cantidadi INT;
	DECLARE _resultado INT;
	DECLARE _contador INT;
	
	DECLARE primera CURSOR FOR SELECT dv.id_prod, SUM(dv.cantidad) AS cantidad, dv.precio, pp.receta, p.id_tipo, pp.crt_stock  FROM tm_detalle_venta AS dv INNER JOIN tm_producto_pres AS pp
	ON dv.id_prod = pp.id_pres LEFT JOIN tm_producto AS p ON pp.id_prod = p.id_prod WHERE dv.id_venta = _id_venta GROUP BY dv.id_prod;
	DECLARE segunda CURSOR FOR SELECT i.id_tipo_ins,i.id_ins,i.cant,v.ins_cos FROM tm_producto_ingr AS i INNER JOIN v_insprod AS v ON i.id_ins = v.id_ins AND i.id_tipo_ins = v.id_tipo_ins WHERE i.id_pres = _idprod;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN primera;
	REPEAT
	
	FETCH primera INTO _idprod, _cantidad1, _precio1, _receta, _tipopedido, _controlstock;
	IF NOT done THEN
			
		
	
	UPDATE tm_detalle_pedido SET cantidad = (cantidad - _cantidad1) WHERE id_pedido = _id_pedido AND id_pres = _idprod AND estado <> 'i' AND cantidad > 0 ORDER BY fecha_pedido ASC LIMIT 1;
	
	 	SELECT COUNT(1) INTO _contador FROM tm_detalle_pedido WHERE id_pedido = _id_pedido AND id_pres = _idprod AND estado <> 'i' AND cantidad < 0 ORDER BY fecha_pedido ASC LIMIT 1;

		while _contador <> 0 do
			SELECT IFNULL(cantidad,0) INTO _resultado FROM tm_detalle_pedido WHERE id_pedido = _id_pedido AND id_pres = _idprod AND estado <> 'i' AND cantidad < 0 ORDER BY fecha_pedido ASC LIMIT 1;

	IF _resultado < 0 THEN
        UPDATE tm_detalle_pedido SET cantidad = 0 WHERE id_pedido = _id_pedido AND id_pres = _idprod AND estado <> 'i' AND cantidad < 0 ORDER BY fecha_pedido ASC LIMIT 1;
		
		UPDATE tm_detalle_pedido SET cantidad = (cantidad + _resultado) WHERE id_pedido = _id_pedido AND id_pres = _idprod AND estado <> 'i' AND cantidad <> 0 ORDER BY fecha_pedido ASC LIMIT 1; 
    END IF;
	
	SELECT COUNT(1) INTO _contador FROM tm_detalle_pedido WHERE id_pedido = _id_pedido AND id_pres = _idprod AND estado <> 'i' AND cantidad < 0 ORDER BY fecha_pedido ASC LIMIT 1;
    end while;
			
	 
	
		IF _receta = 1 OR _controlstock = 1 THEN
			
			IF _tipopedido = 2 OR (_controlstock = 1 AND _tipopedido = 1) THEN
				
				INSERT INTO tm_inventario (id_tipo_ope,id_ope,id_tipo_ins,id_ins,cos_uni,cant,fecha_r) VALUES (2,_id_venta,2,_idprod,_precio1,_cantidad1,_fecha);
			
			ELSEIF _tipopedido = 1 THEN
				
				block2: BEGIN
				
						DECLARE donesegunda INT DEFAULT 0;
						DECLARE _tipoinsumo2 INT;
						DECLARE _idinsumo2 INT;
						DECLARE xx FLOAT;
						DECLARE _cantidad2 FLOAT;
						DECLARE _precio2 FLOAT;
						DECLARE tercera CURSOR FOR SELECT i.id_tipo_ins,i.id_ins,i.cant,v.ins_cos FROM tm_producto_ingr AS i INNER JOIN v_insprod AS v ON i.id_ins = v.id_ins AND i.id_tipo_ins = v.id_tipo_ins WHERE i.id_pres = _idinsumo2;
						DECLARE CONTINUE HANDLER FOR NOT FOUND SET donesegunda = 1;
					
					OPEN segunda;
					REPEAT
			
					FETCH segunda INTO _tipoinsumo2,_idinsumo2,_cantidad2, _precio2;
						IF NOT donesegunda THEN
						
							IF _tipoinsumo2 = 1 OR _tipoinsumo2 = 2 THEN
							
								SET xx = _cantidad2 * _cantidad1;
								INSERT INTO tm_inventario (id_tipo_ope,id_ope,id_tipo_ins,id_ins,cos_uni,cant,fecha_r) VALUES (2,_id_venta,_tipoinsumo2,_idinsumo2,_precio2,xx,_fecha);
							
							ELSEIF _tipoinsumo2 = 3 then
							
								block3: BEGIN
										DECLARE donetercera INT DEFAULT 0;
										DECLARE _tipoinsumo3 INT;
										DECLARE _idinsumo3 INT;
										DECLARE yy FLOAT;
										DECLARE _cantidad3 FLOAT;
										DECLARE _precio3 FLOAT;
										DECLARE CONTINUE HANDLER FOR NOT FOUND SET donetercera = 1;
							
									OPEN tercera;
									REPEAT
							
									FETCH tercera INTO _tipoinsumo3,_idinsumo3,_cantidad3,_precio3;
										IF NOT donetercera THEN
											
										SET yy = _cantidad1 * _cantidad2 * _cantidad3;
										INSERT INTO tm_inventario (id_tipo_ope,id_ope,id_tipo_ins,id_ins,cos_uni,cant,fecha_r) VALUES (2,_id_venta,_tipoinsumo3,_idinsumo3,_precio3,yy,_fecha);
									
										END IF;
									UNTIL donetercera END REPEAT;
									CLOSE tercera;
									
								END block3;
								
							end if;
							
						END IF;
							
					UNTIL donesegunda END REPEAT;
					CLOSE segunda;
					
				END block2;
				
			END IF;
		END IF;	
	END IF;
	UNTIL done END REPEAT;
	CLOSE primera;
    END$$
DELIMITER ;