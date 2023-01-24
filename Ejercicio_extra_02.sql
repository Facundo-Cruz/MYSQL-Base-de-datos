-- A continuación, se deben realizar las siguientes consultas sobre la base de datos:
-- Consultas sobre una tabla

-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
select codigo_oficina, ciudad from oficina;
-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
select ciudad, telefono from oficina where pais = 'España';
-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un
-- código de jefe igual a 7.
select nombre, apellido1, apellido2, codigo_jefe email from empleado where codigo_jefe = 7;
-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
select puesto, nombre, apellido1, apellido2 from empleado where codigo_jefe is null;
-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean
-- representantes de ventas.
select nombre, apellido1, apellido2, puesto from empleado where puesto <> 'Representante Ventas';
-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
select nombre_cliente from cliente where pais = 'Spain';
-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
select distinct estado from pedido;
-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago
-- en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan
-- repetidos. Resuelva la consulta:
-- o Utilizando la función YEAR de MySQL.
-- o Utilizando la función DATE_FORMAT de MySQL.
-- o Sin utilizar ninguna de las funciones anteriores.
-- Metodo 1
select distinct codigo_cliente from pago where fecha_pago like '2008%';
-- Metodo 2
select distinct codigo_cliente from pago where year(fecha_pago) = 2008;

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
-- entrega de los pedidos que no han sido entregados a tiempo.
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_esperada < fecha_entrega;
-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
-- entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha
-- esperada.
-- o Utilizando la función ADDDATE de MySQL.
-- o Utilizando la función DATEDIFF de MySQL.
select DATEDIFF(DAY,'2006-01-19','2006-01-19') from pedido;
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where date_add(fecha_esperada, interval -2 day) >= fecha_entrega;
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where datediff(fecha_entrega, fecha_esperada) <= -2;
-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
select * from pedido where estado = 'Rechazado' and year(fecha_pedido) = 2009;
-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de
-- cualquier año.
select * from pedido where month(fecha_entrega) = 1;
-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal.
-- Ordene el resultado de mayor a menor.
select * from pago where year(fecha_pago) = 2008 order by fecha_pago desc;
-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en
-- cuenta que no deben aparecer formas de pago repetidas.
select distinct forma_pago from pago;
-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que
-- tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de
-- venta, mostrando en primer lugar los de mayor precio.
select * from producto where gama = 'Ornamentales' and cantidad_en_stock > 100 order by precio_venta desc;
-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo
-- representante de ventas tenga el código de empleado 11 o 30.
select * from cliente where ciudad = 'Madrid' and codigo_empleado_rep_ventas between 11 and 30;

-- Consultas multitabla (Composición interna)
-- Las consultas se deben resolver con INNER JOIN.
-- 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante
-- de ventas.
select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2 
from cliente c 
inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado;
-- 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus
-- representantes de ventas.
select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2 
from cliente c 
inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado 
and c.codigo_cliente 
in(select c.codigo_cliente from cliente c inner join pago p on c.codigo_cliente = p.codigo_cliente);
-- 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de
-- sus representantes de ventas.
select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2 
from cliente c 
inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado 
and c.codigo_cliente 
not in(select c.codigo_cliente from cliente c inner join pago p on c.codigo_cliente = p.codigo_cliente);
-- 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes
-- junto con la ciudad de la oficina a la que pertenece el representante.

select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
from cliente c inner join empleado e 
on c.codigo_empleado_rep_ventas = e.codigo_empleado inner join oficina o on e.codigo_oficina = o.codigo_oficina
and c.codigo_cliente 
in(select c.codigo_cliente from cliente c inner join pago p on c.codigo_cliente = p.codigo_cliente);

-- 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus
-- representantes junto con la ciudad de la oficina a la que pertenece el representante.

select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
from cliente c inner join empleado e 
on c.codigo_empleado_rep_ventas = e.codigo_empleado inner join oficina o on e.codigo_oficina = o.codigo_oficina
and c.codigo_cliente 
not in(select c.codigo_cliente from cliente c inner join pago p on c.codigo_cliente = p.codigo_cliente);

-- 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.

select o.linea_direccion1, o.linea_direccion2 
from cliente c inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado 
inner join oficina o on e.codigo_oficina = o.codigo_oficina 
and c.ciudad = 'Fuenlabrada';

-- 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad
-- de la oficina a la que pertenece el representante.
select c.nombre_cliente, e.nombre, e.apellido1, e.apellido2, o.ciudad
from cliente c inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado 
inner join oficina o on e.codigo_oficina = o.codigo_oficina;
-- 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
select nombre as nombre_Empleado, codigo_jefe 
from empleado; 
-- 9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
select distinct c.nombre_cliente 
from cliente c inner join pedido p on c.codigo_cliente = p.codigo_cliente 
and p.estado = 'Pendiente' and p.fecha_entrega is null;
-- 10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
select distinct p.gama from detalle_pedido d inner join producto p on d.codigo_producto = p.codigo_producto;

-- Consultas multitabla (Composición externa)
-- Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, JOIN.
-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select c.nombre_cliente, p.codigo_cliente 
from cliente c left join pago p on c.codigo_cliente = p.codigo_cliente 
where p.codigo_cliente is null;

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún
-- pedido.
select c.nombre_cliente, p.codigo_cliente 
from cliente c left join pedido p on c.codigo_cliente = p.codigo_cliente 
where p.codigo_cliente is null;
-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que
-- no han realizado ningún pedido.
select c.nombre_cliente from pago p right join cliente c on p.codigo_cliente = c.codigo_cliente 
left join pedido pe on c.codigo_cliente = pe.codigo_cliente where p.codigo_cliente is null and pe.codigo_cliente is null;
-- 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina
-- asociada.
select e.nombre, e.apellido1, e.apellido2 from empleado e left join oficina o on e.codigo_oficina = o.codigo_oficina where o.codigo_oficina is null;
-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente
-- asociado.
select e.nombre from empleado e left join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas where c.codigo_cliente is null;
-- 6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los
-- que no tienen un cliente asociado.
select e.nombre 
from oficina o right join empleado e on e.codigo_oficina = o.codigo_oficina 
left join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
where o.codigo_oficina is null and c.codigo_cliente is null;
-- 7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select p.nombre, d.codigo_pedido 
from producto p left join detalle_pedido d on p.codigo_producto = d.codigo_producto 
where d.codigo_pedido is null;
-- 8. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los
-- representantes de ventas de algún cliente que haya realizado la compra de algún producto
-- de la gama Frutales.

select distinct o.* 
from oficina o left join empleado e on o.codigo_oficina = e.codigo_oficina
left join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
left join pedido p on c.codigo_cliente = p.codigo_cliente 
left join detalle_pedido d on p.codigo_cliente = d.codigo_pedido
left join producto pr on d.codigo_producto = pr.codigo_producto
where pr.gama = 'Frutales' and e.codigo_empleado is null; 


-- 9. Devuelve un listado con los clientes que han realizado algún pedido, pero no han realizado
-- ningún pago.
select distinct cl.* 
from cliente cl left join pedido pe on cl.codigo_cliente = pe.codigo_cliente
left join pago pa on pe.codigo_cliente = pa.codigo_cliente where pa.codigo_cliente is null;
-- 10. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el
-- nombre de su jefe asociado.
select em.* 
from empleado em left join cliente cl on em.codigo_empleado = cl.codigo_empleado_rep_ventas
where cl.codigo_cliente is null;
-- Consultas resumen
-- 1. ¿Cuántos empleados hay en la compañía?
select count(codigo_empleado) as cant_empleados from empleado;
-- 2. ¿Cuántos clientes tiene cada país?
select pais, count(pais) from cliente group by pais;
-- 3. ¿Cuál fue el pago medio en 2009?
select avg(total) as pago_medio from pago where year(fecha_pago) = 2009;

-- 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el
-- número de pedidos.
select estado, count(estado) as cant from pedido group by estado order by cant desc;
-- 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
select max(precio_venta) as mas_caro, min(precio_venta) as mas_barato from producto;
-- 6. Calcula el número de clientes que tiene la empresa.
select count(*) as cant_clientes from cliente;
-- 7. ¿Cuántos clientes tiene la ciudad de Madrid?
select count(*) as cant_clientes from cliente where ciudad = 'Madrid';
-- 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
select count(*) as cant_clientes from cliente where ciudad like 'M%';
-- 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende
-- cada uno.
select e.nombre as representante_de_ventas, count(c.codigo_cliente) as cant_clientes 
from empleado e inner join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas 
group by representante_de_ventas;
-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.
select count(c.codigo_cliente) as cant_sin_representante_de_ventas 
from cliente c left join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado
where e.codigo_empleado is null;
-- 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado
-- deberá mostrar el nombre y los apellidos de cada cliente.
select distinct c.nombre_cliente, max(fecha_pedido) as ultimo_pedido, min(fecha_pedido) as primer_pedido
from cliente c inner join pedido p on c.codigo_cliente = p.codigo_cliente
group by p.codigo_cliente;
-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
select p.nombre as producto, d.codigo_producto as codigo_producto, count(d.codigo_producto) as cant_producto
from detalle_pedido d inner join producto p on d.codigo_producto = p.codigo_producto
group by d.codigo_producto;
-- 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de
-- los pedidos.

select sum(cant_producto) 
from(
select p.nombre as producto, d.codigo_producto as codigo_producto, count(d.codigo_producto) as cant_producto
from detalle_pedido d inner join producto p on d.codigo_producto = p.codigo_producto
group by d.codigo_producto
) t;
-- 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que
-- se han vendido de cada uno. El listado deberá estar ordenado por el número total de
-- unidades vendidas.
select p.nombre as producto, d.codigo_producto as codigo_producto, count(d.codigo_producto) as cant_producto
from detalle_pedido d inner join producto p on d.codigo_producto = p.codigo_producto
group by d.codigo_producto order by cant_producto desc limit 20;
-- 15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el
-- IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el
-- número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base
-- imponible, y el total la suma de los dos campos anteriores.
select sum(precio_unidad * cantidad) as base_imponible,
(sum(precio_unidad * cantidad) * 0.21) as IVA,
(sum(precio_unidad * cantidad)+(sum(precio_unidad * cantidad) * 0.21)) as total_facturado
from detalle_pedido; 
-- 16. La misma información que en la pregunta anterior, pero agrupada por código de producto.
select codigo_producto,
sum(precio_unidad * cantidad) as base_imponible,
(sum(precio_unidad * cantidad) * 0.21) as IVA,
(sum(precio_unidad * cantidad)+(sum(precio_unidad * cantidad) * 0.21)) as total_facturado
from detalle_pedido group by codigo_producto; 
-- 17. La misma información que en la pregunta anterior, pero agrupada por código de producto
-- filtrada por los códigos que empiecen por OR.
select codigo_producto,
sum(precio_unidad * cantidad) as base_imponible,
(sum(precio_unidad * cantidad) * 0.21) as IVA,
(sum(precio_unidad * cantidad)+(sum(precio_unidad * cantidad) * 0.21)) as total_facturado
from detalle_pedido
where codigo_producto like 'OR%'
group by codigo_producto; 
-- 18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se
-- mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21%
-- IVA)
select nombre, cantidad, total_facturado, total_facturado_más_IVA
from(
select p.nombre, sum(d.cantidad) as cantidad, 
sum((cantidad * precio_unidad)) as total_facturado, 
sum(((cantidad * precio_unidad)+((cantidad * precio_unidad)*0.21))) as total_facturado_más_IVA
from detalle_pedido d inner join producto p on d.codigo_producto = p.codigo_producto
group by p.nombre
) t where total_facturado_más_IVA > 3000;




-- Subconsultas con operadores básicos de comparación
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
select nombre_cliente
from cliente
where limite_credito = (select max(limite_credito) from cliente);
-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
select nombre
from producto
where precio_venta = (select max(precio_venta) from producto);
-- 3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta
-- que tendrá que calcular cuál es el número total de unidades que se han vendido de cada
-- producto a partir de los datos de la tabla detalle_pedido. Una vez que sepa cuál es el código
-- del producto, puede obtener su nombre fácilmente.)
select p.nombre, sum(d.cantidad) as cantidad
from producto p inner join detalle_pedido d on p.codigo_producto = d.codigo_producto
group by p.nombre order by cantidad desc limit 1;
-- 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar
-- INNER JOIN).

-- 5. Devuelve el producto que más unidades tiene en stock.
select nombre, cantidad from(
select nombre, sum(cantidad_en_stock) as cantidad
from producto
group by nombre
) t where cantidad = (select sum(cantidad_en_stock) as cantidad from producto group by nombre order by cantidad desc limit 1);

-- 6. Devuelve el producto que menos unidades tiene en stock.
select nombre, cantidad from(
select nombre, sum(cantidad_en_stock) as cantidad
from producto
group by nombre
) t where cantidad = (select sum(cantidad_en_stock) as cantidad from producto group by nombre order by cantidad limit 1);
-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto
-- Soria.
select nombre, apellido1, apellido2, email
from empleado 
where codigo_jefe = (select codigo_empleado from empleado where nombre = 'Alberto' and apellido1 = 'Soria');

-- Subconsultas con ALL y ANY
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
select nombre_cliente, limite_credito
from cliente
where limite_credito >= all (select limite_credito from cliente);
-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
select nombre from producto where precio_venta >= all(select precio_venta from producto);
-- 3. Devuelve el producto que menos unidades tiene en stock.
select nombre, cantidad_en_stock from producto where cantidad_en_stock <= any(select cantidad_en_stock from producto) order by cantidad_en_stock limit 1;
-- Subconsultas con IN y NOT IN
-- 1. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún
-- cliente.
select nombre, apellido1, puesto from empleado where codigo_empleado not in (select	codigo_empleado_rep_ventas from cliente);
-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select * from cliente where codigo_cliente not in(select codigo_cliente from pago);
-- 3. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
select * from cliente where codigo_cliente in(select codigo_cliente from pago);
-- 4. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select * from producto where codigo_producto not in(select codigo_producto from detalle_pedido);
-- 5. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que
-- no sean representante de ventas de ningún cliente.
select e.nombre, e.apellido1, e.apellido2, e.puesto, o.telefono
from empleado e inner join oficina o on e.codigo_oficina = o.codigo_oficina
where codigo_empleado not in(select codigo_empleado_rep_ventas from cliente);
-- Subconsultas con EXISTS y NOT EXISTS
-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún
-- pago.
select c.nombre_cliente from cliente c where NOT EXISTS (select * from pago p where c.codigo_cliente = p.codigo_cliente);
-- 2. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
select c.nombre_cliente from cliente c where EXISTS (select * from pago p where c.codigo_cliente = p.codigo_cliente);
-- 3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select p.* from producto p where NOT EXISTS(select * from detalle_pedido d where p.codigo_producto = d.codigo_producto);
-- 4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.
select p.* from producto p where EXISTS(select * from detalle_pedido d where p.codigo_producto = d.codigo_producto);