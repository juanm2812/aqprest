<?php

define('EURO',chr(128));
$pdf = new FPDF_CellFiti('P','mm',array(72,150));
$pdf->AddPage();
$pdf->SetMargins(0,0,0,0);

 if($this->empresa['logo']){
	$url_logo = URL."public/images/".$this->empresa['logo'];
	$pdf->Image($url_logo,L_CENTER,2,L_DIMENSION,0);
	$pdf->Cell(72,L_ESPACIO,'',0,1,'C');
}
$pdf->Ln(3);
$pdf->SetFont('Helvetica', 'B', 10);
$pdf->Cell(72,4,utf8_decode($this->dato->desc_td),0,1,'C');
$pdf->Cell(72,4,utf8_decode($this->dato->ser_doc).'-'.utf8_decode($this->dato->nro_doc),0,1,'C');
$pdf->Ln(2);
$pdf->SetFont('Helvetica', '', 9);
$pdf->Cell(72,4,date('d-m-Y h:i A',strtotime($this->dato->fec_ven)),0,1,'C');
// if($this->dato->id_tped == 1){
// 	$pdf->Cell(72,4,utf8_decode('TIPO DE ATENCION').': '.utf8_decode($this->dato->Pedido->desc_salon).' - MESA: '.utf8_decode($this->dato->Pedido->nro_mesa),0,1,'');
// }else if ($this->dato->id_tped == 2){
// 	$pdf->Cell(72,4,'TIPO DE ATENCION: MOSTRADOR',0,1,'');
// }else if ($this->dato->id_tped == 3){
// 	$pdf->Cell(72,4,'TIPO DE ATENCION: DELIVERY',0,1,'');
// }
$pdf->Ln(2);
$pdf->MultiCell(72,4,'CLIENTE: '.utf8_decode($this->dato->Cliente->nombre),0,1,'');
// if($this->dato->Cliente->tipo_cliente == 1){
// $pdf->Cell(72,4,utf8_decode('DNI').': '.utf8_decode($this->dato->Cliente->dni),0,1,'');
// }else{
// $pdf->Cell(72,4,utf8_decode('RUC').': '.utf8_decode($this->dato->Cliente->ruc),0,1,'');
// }

 
// COLUMNAS
$pdf->SetFont('Helvetica', 'B', 9);
$pdf->Cell(5, 10, 'CANT.',0,0);
$pdf->Cell(42, 10, 'PRODUCTO', 0,0,'C');
$pdf->Cell(10, 10, 'P.U.',0,0,'R');
$pdf->Cell(15, 10, 'IMP.',0,0,'R');
$pdf->Ln(8);
$pdf->Cell(72,0,'','T');
$pdf->Ln(1);
 
// PRODUCTOS
$total = 0;

foreach($this->dato->Detalle as $d){

	if ($this->dato->consumo == '0') {
	$pdf->SetFont('Helvetica', '', 9);
	$pdf->Cell(10, 4, $d->cantidad,0,0,'L');
	$pdf->MultiCell(42,4,utf8_decode($d->nombre_producto),0,'L'); 
	$pdf->Cell(57, -4, $d->precio_unitario,0,0,'R');
	$pdf->Cell(15, -4, number_format(($d->cantidad * $d->precio_unitario),2),0,0,'R');
	$pdf->Ln(1);
	}

	if($d->cantidad > 0){
		$total = ($d->cantidad * $d->precio_unitario) + $total;
	}
}
if ($this->dato->consumo == '1') {
	$pdf->SetFont('Helvetica', '', 7);
	$pdf->Cell(10, 4, '1',0,0,'L');
	$pdf->MultiCell(42,4,utf8_decode($this->dato->consumo_desc),0,'L'); 
	$pdf->Cell(57, -4, $this->dato->total,0,0,'R');
	$pdf->Cell(15, -4, number_format(($this->dato->total),2),0,0,'R');
	$pdf->Ln(1);
}
 

$pdf->SetFont('Helvetica', '', 9);
$pdf->Cell(72,0,'','T');
$pdf->Ln(0);    
 

if($this->dato->desc_monto > 0){
$pdf->Ln(4); 
$pdf->Cell(37, 10, 'DESCUENTO', 0);    
$pdf->Cell(20, 10, '', 0);
$pdf->Cell(15, 10, '-'.number_format(($this->dato->desc_monto),2),0,0,'R');
// $pdf->Ln(4); 
}

//$pdf->Ln(4); 

if($this->dato->comis_del > 0){
	$pdf->Ln(4); 
	$pdf->Cell(37, 10, 'DELIVERY', 0);    
	$pdf->Cell(20, 10, '', 0);
	$pdf->Cell(15, 10, '('.number_format(($this->dato->comis_del),2).')',0,0,'R');
	// $pdf->Ln(4); 
	}
$pdf->SetFont('Helvetica', 'B', 9);
$pdf->Cell(37, 10, 'TOTAL', 0);    
$pdf->Cell(20, 10, '', 0);
$pdf->Cell(15, 10, number_format(($this->dato->total + $this->dato->comis_del - $this->dato->desc_monto ),2),0,0,'R');
$pdf->Ln(8);
$pdf->Ln(2);
$pdf->Cell(72,0,'','T');
if($this->dato->id_tpag == 1 && $this->dato->pago_efe > 0){
$pdf->Ln(0);
$pdf->Cell(37, 10, 'EFECTIVO', 0);    
$pdf->Cell(20, 10, '', 0);
$pdf->Cell(15, 10, number_format(($this->dato->pago_efe),2),0,0,'R');
} else if($this->dato->id_tpag == 2){
$pdf->Ln(0);
$pdf->Cell(37, 10, 'TARJETA', 0);    
$pdf->Cell(20, 10, '', 0);
$pdf->Cell(15, 10, number_format(($this->dato->pago_tar),2),0,0,'R');
} else if($this->dato->id_tpag == 3){
	$pdf->Ln(0);
	if($this->dato->pago_efe > 0){
	$pdf->Cell(37, 10, 'EFECTIVO', 0);    
	$pdf->Cell(20, 10, '', 0);
	$pdf->Cell(15, 10, number_format(($this->dato->pago_efe),2),0,0,'R');
	$pdf->Ln(4);
	} 
	if($this->dato->pago_tar > 0){
	$pdf->Cell(37, 10, 'TARJETA', 0);    
	$pdf->Cell(20, 10, '', 0);
	$pdf->Cell(15, 10, number_format(($this->dato->pago_tar),2),0,0,'R');
	$pdf->Ln(4);
	} 
	if($this->dato->pago_yape > 0){
	$pdf->Cell(37, 10, 'YAPE', 0);    
	$pdf->Cell(20, 10, '', 0);
	$pdf->Cell(15, 10, number_format(($this->dato->pago_yape),2),0,0,'R');
	$pdf->Ln(4);
	} 
	if($this->dato->pago_plin > 0 ){
	$pdf->Cell(37, 10, 'PLIN', 0);    
	$pdf->Cell(20, 10, '', 0);
	$pdf->Cell(15, 10, number_format(($this->dato->pago_plin),2),0,0,'R');
	$pdf->Ln(4);
	}if($this->dato->pago_tran >0){
	$pdf->Cell(37, 10, 'TRANFERENCIA', 0);    
	$pdf->Cell(20, 10, '', 0);
	$pdf->Cell(15, 10, number_format(($this->dato->pago_tran),2),0,0,'R');
	}
}
if(($this->dato->id_tpag == 1 OR $this->dato->id_tpag == 3 ) && $this->dato->pago_efe_none > 0){
$pdf->Ln(8);
$pdf->Cell(72,0,'','T');
$pdf->Ln(0);
$pdf->Cell(37, 10, 'PAGO CON', 0);    
$pdf->Cell(20, 10, '', 0);
$pdf->Cell(15, 10, number_format(($this->dato->pago_efe_none),2),0,0,'R');
$pdf->Ln(4);
$pdf->Cell(37, 10, 'VUELTO', 0);    
$pdf->Cell(20, 10, '', 0);
$vuelto = ($this->dato->pago_efe_none - $this->dato->pago_efe);
$pdf->Cell(15, 10, strtoupper(number_format(($vuelto),2)),0,0,'R');
} 

if($this->dato->id_tpag > 3) {
$pdf->Ln(0);
$pdf->Cell(37, 10, $this->dato->desc_tp, 0);    
$pdf->Cell(20, 10, '', 0);
$pdf->Cell(15, 10, number_format(($this->dato->pago_tar),2),0,0,'R');
}
if($this->dato->desc_tipo == 1){
$pdf->Ln(2);
$pdf->Cell(37, 4, 'CORTESIA', 0);   
$pdf->Cell(20, 4, '',0,0,'R');
$pdf->Cell(15, 4, '0.00',0,0,'R');
}
if($this->dato->desc_tipo == 3){
$pdf->Ln(2);
$pdf->Cell(37, 4, 'CREDITO PERSONAL', 0);   
$pdf->Cell(20, 4, '',0,0,'R');
$pdf->Cell(15, 4, number_format(($this->dato->desc_monto),2),0,0,'R');
}

if($this->dato->comis_tar > 0){
$pdf->Ln(4); 
// $pdf->Cell(37, 10, 'COM.TARJETA '.(Session::get('com_tar')).'%', 0);    
$pdf->Cell(37, 10, 'COM.TARJETA ('.number_format(($this->dato->comis_tar),2).')', 0);    
$pdf->Cell(20, 10, '', 0);
// $pdf->Cell(15, 10, '('.number_format(($this->dato->comis_tar),2).')',0,0,'R');
$pdf->Cell(15, 10, number_format(($this->dato->total + $this->dato->comis_del - $this->dato->desc_monto+$this->dato->comis_tar ),2),0,0,'R');
	// $pdf->Ln(4); 
}

$pdf->Ln(10);

$pdf->Ln(3);

if ($this->empresa['amazonas'] == 1) {
	if ($total_ope_exoneradas > 0 ) {
	$pdf->SetFont('Helvetica', '', 7);
	$pdf->MultiCell(72,4,utf8_decode('BIENES TRANSFERIDOS EN LA AMAZONÍA REGIÓN SELVAPARA SER CONSUMIDOS EN LA MISMA'),0,'C');
	$pdf->Ln(5);
	}
}

$pdf->SetFont('Helvetica', 'B', 9);
$pdf->Cell(72,0,'GRACIAS POR SU PREFERENCIA',0,1,'C');
$pdf->Ln(10);

$pdf->Output(utf8_decode($this->dato->ser_doc).'-'.utf8_decode($this->dato->nro_doc).'.pdf','I');