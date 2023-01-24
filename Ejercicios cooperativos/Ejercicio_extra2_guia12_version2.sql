/*A continuación, se deben realizar las siguientes consultas sobre la base de datos:
Consultas sobre una tabla*/
select * from cliente;
select * from detalle_pedido;
select * from empleado; 
select * from gama_producto;
select * from oficina;
select * from pago;
select * from pedido;
select * from producto;

/*1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.*/
select codigo_oficina, ciudad from oficina;

/*2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.*/
select ciudad,telefono from oficina where pais="españa";

/*3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un
código de jefe igual a 7.*/
select nombre, apellido1, email from empleado where codigo_jefe in(7);

/*4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.*/
select puesto, nombre, apellido1, email from empleado where codigo_jefe is null;

/*5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean
representantes de ventas.*/
select nombre, apellido1, puesto from empleado where puesto not in("representante ventas");
select nombre, apellido1, puesto from empleado where puesto not like"representante ventas";

/*6. Devuelve un listado con el nombre de los todos los clientes españoles.*/
select nombre_cliente, pais from cliente where pais ='spain';

/*7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.*/
select distinct estado from pedido;

/*8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago
en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan
repetidos. Resuelva la consulta:
o Utilizando la función YEAR de MySQL.
o Utilizando la función DATE_FORMAT de MySQL.
o Sin utilizar ninguna de las funciones anteriores.*/

select codigo_cliente, estado, fecha_pedido from pedido where date_format(fecha_pedido, '%Y')=2008 and estado in('entregado','pendiente');

SELECT codigo_cliente, estado, fecha_pedido FROM pedido
WHERE fecha_pedido BETWEEN '2008-01-01' AND '2008-12-31' having estado in('entregado','pendiente');


SELECT  codigo_cliente, estado, fecha_pedido  FROM pedido
WHERE YEAR(fecha_pedido) IN (2008) and estado in('entregado','pendiente');


SELECT codigo_cliente, estado, fecha_pedido FROM pedido
WHERE YEAR(fecha_pedido) BETWEEN 2008 AND 2008 and estado in('entregado','pendiente');


SELECT codigo_cliente, estado, fecha_pedido FROM pedido
WHERE fecha_pedido BETWEEN '2008-01-01' AND '2008-12-31' and estado in('entregado','pendiente');


/*9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
entrega de los pedidos que no han sido entregados a tiempo.*/
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega, estado from pedido where fecha_esperada< fecha_entrega having estado in('entregado');

/*10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos 
días antes de la fecha esperada.
o Utilizando la función ADDDATE de MySQL.
o Utilizando la función DATEDIFF de MySQL.*/
Select codigo_pedido , codigo_cliente, fecha_esperada, fecha_entrega from pedido where datediff(fecha_esperada, fecha_entrega)>=2;

select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_entrega <= date_add(fecha_esperada, interval -2 day);


/*11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.*/
select * from pedido where year(fecha_pedido) in(2009)and estado in('rechazado');

/*12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de
cualquier año.*/
Select * from pedido where estado like 'entregado' and date_format(fecha_pedido, '%c%')= 01;
-- C MES, Y AÑO Y DIA E

/*13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal.
Ordene el resultado de mayor a menor.*/
select forma_pago, fecha_pago from pago where date_format(fecha_pago, '%Y')=2008 order by fecha_pago desc;

select * from pago where year(fecha_pago) in(2008) having forma_pago like'paypal';

/*14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en
cuenta que no deben aparecer formas de pago repetidas.*/
select distinct forma_pago from pago;

/*15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que
tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de
venta, mostrando en primer lugar los de mayor precio.*/
select nombre, gama, precio_venta from producto where cantidad_en_stock>100 and gama="ornamentales" order by precio_venta desc;

/*16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo
representante de ventas tenga el código de empleado 11 o 30.*/
select nombre_cliente, ciudad from cliente where ciudad='madrid' and codigo_empleado_rep_ventas in(11,30);

/*Consultas multitabla (Composición interna)
Las consultas se deben resolver con INNER JOIN.
1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante
de ventas.*/
select c.nombre_cliente as "nombre cliente", e.nombre, e.apellido1  from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado;

/*2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus
representantes de ventas.*/
select c.nombre_cliente as "nombre cliente", e.nombre as "nombre representante", p.forma_pago from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado inner join pago p on  c.codigo_cliente=p.codigo_cliente;

/*3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de
sus representantes de ventas.*/
select c.codigo_cliente,c.nombre_cliente as "nombre cliente", e.nombre as "nombre representante" from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado where c.codigo_cliente not in(select p.codigo_cliente from pago p );

/*4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes
junto con la ciudad de la oficina a la que pertenece el representante.*/
select c.nombre_cliente as "nombre cliente", e.nombre as "nombre representante", p.forma_pago,o.ciudad from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado inner join pago p on  c.codigo_cliente=p.codigo_cliente
inner join oficina o on e.codigo_oficina=o.codigo_oficina;

/*5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus
representantes junto con la ciudad de la oficina a la que pertenece el representante.*/
select c.codigo_cliente,c.nombre_cliente as "nombre cliente", e.nombre as "nombre representante",o.ciudad from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado inner join oficina o on e.codigo_oficina=o.codigo_oficina
where c.codigo_cliente not in(select p.codigo_cliente from pago p );

/*6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.*/
select distinct o.linea_direccion1, o.linea_direccion2, c.ciudad from oficina o
inner join empleado e on e.codigo_oficina=o.codigo_oficina
inner join cliente c on c.codigo_empleado_rep_ventas=e.codigo_empleado where c.ciudad in ('Fuenlabrada');


/*7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad
de la oficina a la que pertenece el representante.*/
select c.nombre_cliente as "nombre cliente", e.nombre as "nombre representante", o.ciudad from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
inner join oficina o on e.codigo_oficina=o.codigo_oficina;

/*8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.*/
select e.nombre as "empleado", j.nombre as "jefe" from empleado e
inner join empleado j on e.codigo_jefe=j.codigo_empleado;

/*9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.*/
select c.nombre_cliente, p.fecha_esperada, p.fecha_entrega from cliente c
inner join pedido p on c.codigo_cliente=p.codigo_cliente where p.fecha_entrega>p.fecha_esperada;

/*10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.*/
select distinct pro.gama,c.nombre_cliente from producto pro
inner join detalle_pedido de on de.codigo_producto=pro.codigo_producto
inner join pedido p on de.codigo_pedido=p.codigo_pedido
inner join cliente c on c.codigo_cliente= p.codigo_cliente;


/*Consultas multitabla (Composición externa)
Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, JOIN.
1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/
select c.nombre_cliente, p.codigo_cliente   from cliente c
left join pago p on c.codigo_cliente=p.codigo_cliente where p.codigo_cliente is null;

/*2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún
pedido.*/

select c.nombre_cliente from pedido p 
right join cliente c on c.codigo_cliente=p.codigo_cliente where p.codigo_cliente is null;


/*3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que
no han realizado ningún pedido.*/
select c.nombre_cliente,c.codigo_cliente, c.ciudad from cliente c
left join pedido pe on c.codigo_cliente=pe.codigo_cliente
left join pago pa on c.codigo_cliente=pa.codigo_cliente where pa.codigo_cliente is null and pe.codigo_cliente is null;

/*4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina
asociada.*/
select e.nombre from empleado e 
left join oficina o on e.codigo_oficina=o.codigo_oficina where o.codigo_oficina is null;

/*5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente
asociado.*/
select e.


/*6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los
que no tienen un cliente asociado.
7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
8. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los
representantes de ventas de algún cliente que haya realizado la compra de algún producto
de la gama Frutales.
9. Devuelve un listado con los clientes que han realizado algún pedido, pero no han realizado
ningún pago.
10. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el
nombre de su jefe asociado.
Consultas resumen
1. ¿Cuántos empleados hay en la compañía?
2. ¿Cuántos clientes tiene cada país?
3. ¿Cuál fue el pago medio en 2009?
4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el
número de pedidos.
5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
6. Calcula el número de clientes que tiene la empresa.
7. ¿Cuántos clientes tiene la ciudad de Madrid?
8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende
cada uno.
52
10. Calcula el número de clientes que no tiene asignado representante de ventas.
11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado
deberá mostrar el nombre y los apellidos de cada cliente.
12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de
los pedidos.
14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que
se han vendido de cada uno. El listado deberá estar ordenado por el número total de
unidades vendidas.
15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el
IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el
número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base
imponible, y el total la suma de los dos campos anteriores.
16. La misma información que en la pregunta anterior, pero agrupada por código de producto.
17. La misma información que en la pregunta anterior, pero agrupada por código de producto
filtrada por los códigos que empiecen por OR.
18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se
mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21%
IVA)
Subconsultas con operadores básicos de comparación
1. Devuelve el nombre del cliente con mayor límite de crédito.
2. Devuelve el nombre del producto que tenga el precio de venta más caro.
3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta
que tendrá que calcular cuál es el número total de unidades que se han vendido de cada
producto a partir de los datos de la tabla detalle_pedido. Una vez que sepa cuál es el código
del producto, puede obtener su nombre fácilmente.)
4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar
INNER JOIN).
5. Devuelve el producto que más unidades tiene en stock.
6. Devuelve el producto que menos unidades tiene en stock.
7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto
Soria.
Subconsultas con ALL y ANY
1. Devuelve el nombre del cliente con mayor límite de crédito.
2. Devuelve el nombre del producto que tenga el precio de venta más caro.
3. Devuelve el producto que menos unidades tiene en stock.
Subconsultas con IN y NOT IN
1. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún
cliente.
2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
3. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
53
4. Devuelve un listado de los productos que nunca han aparecido en un pedido.
5. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que
no sean representante de ventas de ningún cliente.
Subconsultas con EXISTS y NOT EXISTS
1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún
pago.
2. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.*/