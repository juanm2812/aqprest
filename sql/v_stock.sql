
--
-- Temporary table structure for view `v_stock`
--

DROP TABLE IF EXISTS `v_stock`;
/*!50001 DROP VIEW IF EXISTS `v_stock`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_stock` (
  `id_tipo_ins` tinyint NOT NULL,
  `id_ins` tinyint NOT NULL,
  `ent` tinyint NOT NULL,
  `sal` tinyint NOT NULL,
  `est_a` tinyint NOT NULL,
  `est_b` tinyint NOT NULL,
  `debajo_stock` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;


--
-- Final view structure for view `v_stock`
--

/*!50001 DROP TABLE IF EXISTS `v_stock`*/;
/*!50001 DROP VIEW IF EXISTS `v_stock`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `v_stock` AS (select `a`.`id_tipo_ins` AS `id_tipo_ins`,`a`.`id_ins` AS `id_ins`,sum(`a`.`ent`) AS `ent`,sum(`a`.`sal`) AS `sal`,`b`.`est_a` AS `est_a`,`b`.`est_b` AS `est_b`,if(`a`.`ent` - `a`.`sal` > `b`.`ins_sto`,1,0) AS `debajo_stock` from (`v_inventario` `a` join `v_insprod` `b` on(`a`.`id_tipo_ins` = `b`.`id_tipo_ins` and `a`.`id_ins` = `b`.`id_ins`)) where `b`.`est_a` = 'a' and `b`.`est_b` = 'a' group by `a`.`id_tipo_ins`,`a`.`id_ins`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

