$(function() {
    $('#informes').addClass("active");
    moment.locale('es');
    listar();

    $('#start').bootstrapMaterialDatePicker({
        time: false,
        format: 'DD-MM-YYYY',
        lang: 'es-do',
        cancelText: 'Cancelar',
        okText: 'Aceptar'
    });

    $('#end').bootstrapMaterialDatePicker({
        time: false,
        useCurrent: false,
        format: 'DD-MM-YYYY',
        lang: 'es-do',
        cancelText: 'Cancelar',
        okText: 'Aceptar'
    });

    $('#start,#end,#filtro_tipo_pago').change( function() {
        listar();
        if ($('#filtro_tipo_pago').val() == 2 || $('#filtro_tipo_pago').val() == 3) {
            $(".com_tars").css("display","block");
        } else {
            $(".com_tars").css("display","none");
        }
    });

    /* BOTON DATATABLES */
    var org_buildButton = $.fn.DataTable.Buttons.prototype._buildButton;
    $.fn.DataTable.Buttons.prototype._buildButton = function(config, collectionButton) {
    var button = org_buildButton.apply(this, arguments);
    $(document).one('init.dt', function(e, settings, json) {
        if (config.container && $(config.container).length) {
            $(button.inserter[0]).detach().appendTo(config.container)
        }
    })    
    return button;
    }
  
});

var listar = function(){

    var moneda = $("#moneda").val();
    ifecha = $("#start").val();
    ffecha = $("#end").val();
    id_tpag = $("#filtro_tipo_pago").selectpicker('val');

    var table = $('#table')
    .DataTable({
        buttons: [
            {
                extend: 'excel', title: 'Formas de pagos', className: 'dropdown-item p-t-0 p-b-0', text: '<i class="fas fa-file-excel"></i> Descargar en excel', titleAttr: 'Descargar Excel',
                container: '#excel', exportOptions: { columns: [0,1,2,3,4,5,6] }
            },
            {
                extend: 'pdf', title: 'Formas de pagos', className: 'dropdown-item p-t-0 p-b-0', text: '<i class="fas fa-file-pdf"></i> Descargar en pdf', titleAttr: 'Descargar Pdf',
                container: '#pdf', exportOptions: { columns: [0,1,2,3,4,5,6] }, orientation: 'landscape', 
                customize : function(doc){ 
                    doc.styles.tableHeader.alignment = 'left'; 
                    doc.content[1].table.widths = [60,'*','*','*','*','*','*','*'];
                }
            }
        ],
        "destroy": true,
        "responsive": true,
        "dom": "tip",
        "bSort": true,
        "ajax":{
            "method": "POST",
            "url": $('#url').val()+"informe/venta_fpago_list",
            "data": {
                ifecha: ifecha,
                ffecha: ffecha,
                id_tpag: id_tpag
            }
        },
        "columns":[
            {"data":"fec_ven","render": function ( data, type, row ) {
                return '<i class="ti-calendar"></i> '+moment(data).format('DD-MM-Y')
                +'<br><span class="font-12"><i class="ti-time"></i> '+moment(data).format('h:mm A')+'</span>';
            }},
            {"data":"Cliente.nombre","render": function ( data, type, row ) {
                return '<div class="mayus">'+data+'</div>';
            }},
            {"data":null,"render": function ( data, type, row ) {
                return data.desc_td
                +'<br><span class="font-12">'+data.numero+'</span>';
            }},
            {"data":null,"render": function ( data, type, row ) {
                return '<div class="mayus">'+data.codigo_operacion+'</div>';
            }},
            {"data":"comis_tar","render": function ( data, type, row ) {
                return '<div class="mayus">'+data+'</div>';
            }},        
            /*
            {"data":null,"render": function ( data, type, row) {
                return '<div class="text-right bold">'+moneda+' '+formatNumber(parseFloat(data.total) + parseFloat(data.descu))+'</div>'
                +'<p class="text-right m-b-0"><i>Dscto.: -'+formatNumber(data.descu)+'</i></p>';
            }},
            */
            {"data": null,
                "render": function(data, type, row){
                //var repartidor = (data.tipo_entrega == 1) ? '<i class="fas fa-bicycle"></i> '+data.Tipopago.nombre : '-';
                if(data.id_tpag == 1){
                    return '<span class="label label-success">'+data.Tipopago.nombre+'</span>';
                } else if(data.id_tpag == 2){
                    return '<span class="label label-info">'+data.Tipopago.nombre+'</span>';
                } else if(data.id_tpag == 3){
                    return '<span class="label label-warning">'+data.Tipopago.nombre+'</span>';
                } else if(data.id_tpag == 4){
                    return '<span class="label label-danger text-primary font-bold">C</span> <span class="text-primary font-bold">'+data.Tipopago.nombre+'</span>';
                } else if(data.id_tpag >= 5){
                    return '<span class="label label-light-primary">'+data.Tipopago.nombre+'</span>';
                }
            }},
            {"data":"total","render": function ( data, type, row) {
                return '<div class="text-right"> '+moneda+' '+formatNumber(data)+'</div>';
            }}
        ],
        "footerCallback": function ( row, data, start, end, display ) {
            var api = this.api(), data;

            var intVal = function ( i ) {
                return typeof i === 'string' ?
                    i.replace(/[\$,]/g, '')*1 :
                    typeof i === 'number' ?
                        i : 0;
            };
 
            efectivo_total = api
                .column( 6 /*, { search: 'applied', page: 'current'} */)
                .data()
                .reduce( function (a, b) {
                    return intVal(a) + intVal(b);
                }, 0 );

            comision_total = api
            .column( 4 /*, { search: 'applied', page: 'current'} */)
            .data()
            .reduce( function (a, b) {
                return intVal(a) + intVal(b);
            }, 0 );                


            operaciones = api
                .rows()
                .data()
                .count();

            $('.efectivo-total').text(moneda+' '+formatNumber(efectivo_total));
            $('.comision-total').text(moneda+' '+formatNumber(comision_total));
            // $('.tarjeta-total').text(moneda+' '+formatNumber(tarjeta_total));
            $('.pagos-operaciones').text(operaciones);
        }
    });
}