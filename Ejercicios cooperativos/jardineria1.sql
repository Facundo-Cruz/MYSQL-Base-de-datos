-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
select codigo_oficina, ciudad from oficina;
-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
select ciudad, telefono from oficina where pais='españa';
/*3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un
código de jefe igual a 7.*/
select nombre, apellido1, apellido2, email from empleado where codigo_jefe=7;
-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
select puesto, nombre, apellido1, apellido2, email from empleado where codigo_jefe is null;
-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean
-- representantes de ventas.
select nombre, apellido1, apellido2, puesto from empleado where puesto not in ('representante ventas');
-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
select nombre_cliente, pais from cliente where pais='spain';
-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
select distinct estado from pedido;
/*8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago
en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan
repetidos. Resuelva la consulta:
- Utilizando la función YEAR de MySQL.
- Utilizando la función DATE_FORMAT de MySQL.*/
select codigo_cliente, fecha_pedido from pedido where  year (fecha_pedido)=2008;
select codigo_cliente, fecha_pedido from pedido where date_format(fecha_pedido, '%Y%')=2008;
SELECT codigo_cliente, estado, fecha_pedido FROM pedido WHERE fecha_pedido 
BETWEEN '2008-01-01' AND '2008-12-31' ;
SELECT codigo_cliente, estado, fecha_pedido FROM pedido WHERE FECHA_PEDIDO LIKE('2008%');
/*9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
entrega de los pedidos que no han sido entregados a tiempo.*/
SELECT CODIGO_PEDIDO, CODIGO_CLIENTE, FECHA_ESPERADA, FECHA_ENTREGA FROM PEDIDO
 WHERE FECHA_ENTREGA>FECHA_ESPERADA  ;
 /*10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha
esperada.
o Utilizando la función ADDDATE de MySQL.
o Utilizando la función DATEDIFF de MySQL.
DATEDIFF(DAY,'2006-01-19','2006-01-19')*/
SELECT CODIGO_PEDIDO, CODIGO_CLIENTE, FECHA_ESPERADA, FECHA_ENTREGA FROM PEDIDO WHERE
 DATEDIFF(FECHA_ESPERADA, FECHA_ENTREGA)>=2;
 SELECT CODIGO_PEDIDO, CODIGO_CLIENTE, FECHA_ESPERADA, FECHA_ENTREGA FROM PEDIDO WHERE
 adddate(FECHA_ESPERADA, interval -2 DAY)>= FECHA_ENTREGA;
 -- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
 SELECT CODIGO_PEDIDO, ESTADO, FECHA_ENTREGA FROM PEDIDO WHERE ESTADO = 'RECHAZADO'
 AND FECHA_ENTREGA LIKE ('2009%');
 /*12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de
cualquier año.*/
SELECT CODIGO_PEDIDO, FECHA_ENTREGA FROM PEDIDO WHERE month(FECHA_ENTREGA)='1';
/*13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal.
Ordene el resultado de mayor a menor.*/
 SELECT CODIGO_CLIENTE, FORMA_PAGO, TOTAL, FECHA_PAGO FROM PAGO WHERE YEAR(FECHA_PAGO)=2008 AND 
 FORMA_PAGO='PAYPAL' ORDER BY TOTAL DESC;
 /*14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en
cuenta que no deben aparecer formas de pago repetidas.*/
SELECT DISTINCT FORMA_PAGO FROM PAGO;
/*15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que
tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de
venta, mostrando en primer lugar los de mayor precio.*/
SELECT NOMBRE, CODIGO_PRODUCTO, GAMA, CANTIDAD_EN_STOCK, PRECIO_VENTA FROM PRODUCTO WHERE
CANTIDAD_EN_STOCK>100 AND gama='ORNAMENTALES' ORDER BY PRECIO_VENTA desc;
/*16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo
representante de ventas tenga el código de empleado 11 o 30.*/
SELECT CODIGO_CLIENTE, CIUDAD, CODIGO_EMPLEADO_REP_VENTAS FROM CLIENTE WHERE 
CODIGO_EMPLEADO_REP_VENTAS IN(11,30) AND CIUDAD='mADRID';




