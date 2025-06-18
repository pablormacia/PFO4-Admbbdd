/* 1) Cree un procedimiento almacenado llamado "pa_traje_prenda" que seleccione el
codigo, nombre del traje, codigo de la prenda, nombre de la prenda y el stock de
aquellas prendas que tengan un stock superior o igual al enviado como parámetro.
Ejecute el procedimiento creado anteriormente
 */

 use vestuario;

drop procedure if exists pa_traje_prenda;

 delimiter //


 create procedure pa_traje_prenda(in p_stock int)
 begin
    select t.idTraje, t.nombre, p.codprenda, p.nombre, p.stock 
    from traje t 
    inner join trapre tp on t.idtraje=tp.codTraje
    inner join prenda p on tp.codprenda=p.codprenda
    where p.stock>p_stock;
end
//

delimiter ;

call pa_traje_prenda(10);
    
/* 2) Cree un procedimiento almacenado llamado "pa_prendas_actualizar_stock" , este
procedimiento debera tener dos parametros, el primero se pasara el codigo de la
prenda y en el segundo el nuevo valor del stock. El prodecimiento debera actualizar la
prenda con el nuevo valor de stock informado
 */

use vestuario;
drop procedure if exists pa_prendas_actualizar_stock;
delimiter //

create procedure pa_prendas_actualizar_stock(in p_codprenda int, in p_stock int)
begin
    update prenda set stock=p_stock where codprenda=p_codprenda;
end
//

delimiter ;
select * from prenda;

call pa_prendas_actualizar_stock(1020,7);

select * from prenda;

/* 3) Cree un procedimiento almacenado llamado "pa_obra" al cual le enviamos el codigo
de una obra y que nos retorne la cantidad de trajes que tiene esa obra en un parametro
de salida. Ejecute el procedimiento creado anteriormente. */

use vestuario;
drop procedure if exists pa_obra;
delimiter //

create procedure pa_obra(in p_codobra int, out p_cantidad int)
begin
    set p_cantidad = (select DISTINCT count(idTraje) 
                        from obratraje where idobra=p_codobra);
end
//

delimiter ;

select * from obratraje; 

call pa_obra(8775,@p_contador)

select @p_contador as "cantidad";

/* 4) Implementar una funcion que llamada f_codificado que recibe el nombre de la obra y
que nos retorne el nombre de la obra codificado con *** al final. (Resolver utilizando
alguna herramienta de IA y copiar las respuestas obtenidas hasta su resolución)
Ejemplo recibe El hombre del maletin y debe devolver El hombre del male***
Ejecute la funcion */

use vestuario;
drop function if exists f_codificado;
delimiter //

create FUNCTION f_codificado(f_nombreObra text) returns text
DETERMINISTIC
begin
    declare nombre_modificado text;
    IF CHAR_LENGTH(f_nombreObra) <= 3 THEN
        SET nombre_modificado = '***';
    ELSE
        SET nombre_modificado = CONCAT(LEFT(f_nombreObra, CHAR_LENGTH(f_nombreObra)- 3), '***');
    END IF;
    return nombre_modificado;
end
//

delimiter ;

select f_codificado("Hola");

/* Crear una “VISTA", que le permita visualizar cada obra, con el traje y la cantidad de
prendas que contiene */

use vestuario;

select * from obratraje;
select * from traje;
select * from trapre;
select * from prenda;

create or replace view obratrajeprendas(obra,traje,prendas) 
    as select o.nombre, t.nombre, count(tp.codtraje) from obra o
    inner join obratraje ot on o.idobra=ot.idobra
    inner join traje t on t.idtraje=ot.idtraje
    inner join trapre tp on tp.codtraje=t.idtraje
    group by o.nombre, t.nombre
    ;


select * from obratrajeprendas;