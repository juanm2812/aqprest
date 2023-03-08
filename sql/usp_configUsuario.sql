DELIMITER ;;
CREATE PROCEDURE `usp_configUsuario`(IN `_flag` INT(11), IN `_id_usu` INT(11), IN `_id_rol` INT(11), IN `_id_areap` INT(11), IN `_dni` VARCHAR(10), IN `_ape_paterno` VARCHAR(45), IN `_ape_materno` VARCHAR(45), IN `_nombres` VARCHAR(45), IN `_email` VARCHAR(100), IN `_usuario` VARCHAR(45), IN `_contrasena` VARCHAR(45), IN `_imagen` VARCHAR(45), IN `_turno_ing` VARCHAR(45), IN `_turno_sal` VARCHAR(45))
BEGIN
		DECLARE _filtro INT DEFAULT 1;
		
		IF _flag = 1 THEN
		
			SELECT count(*) INTO _filtro FROM tm_usuario WHERE usuario = _usuario;
		
			IF _filtro = 0 THEN
			
				INSERT INTO tm_usuario (id_rol,id_areap,dni,ape_paterno,ape_materno,nombres,email,usuario,contrasena,imagen,turno_ing,turno_sal) 
				VALUES (_id_rol,_id_areap,_dni,_ape_paterno,_ape_materno,_nombres,_email,_usuario,_contrasena,_imagen,_turno_ing,_turno_sal);
				
				SELECT _filtro AS cod;
			ELSE
				SELECT _filtro AS cod;
			END IF;
		
		end if;
		
		IF _flag = 2 THEN
			UPDATE tm_usuario SET id_rol = _id_rol, id_areap = _id_areap, dni = _dni, ape_paterno = _ape_paterno, ape_materno = _ape_materno, nombres = _nombres, email = _email, usuario = _usuario, contrasena = _contrasena, imagen = _imagen, turno_ing = _turno_ing, turno_sal = _turno_sal
			WHERE id_usu = _id_usu;
		END IF;
	END ;;
DELIMITER ;