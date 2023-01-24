-- A continuación, se deben realizar las siguientes consultas sobre la base de datos:
-- 1. Mostrar el nombre de todos los jugadores ordenados alfabéticamente.
select Nombre from jugadores order by nombre;
-- 2. Mostrar el nombre de los jugadores que sean pivots (‘C’) y que pesen más de 200 libras,
-- ordenados por nombre alfabéticamente.
select Nombre, Posicion, Peso from jugadores where Posicion = 'C' and Peso > 200;
-- 3. Mostrar el nombre de todos los equipos ordenados alfabéticamente.
select Nombre from equipos order by Nombre;
-- 4. Mostrar el nombre de los equipos del este (East).
select Nombre, Conferencia from equipos where Conferencia = 'East';
-- 5. Mostrar los equipos donde su ciudad empieza con la letra ‘c’, ordenados por nombre.
select * from equipos where Ciudad like 'C%' order by Nombre;
-- 6. Mostrar todos los jugadores y su equipo ordenados por nombre del equipo.
select Nombre, Nombre_equipo from jugadores order by Nombre_equipo; 
-- 7. Mostrar todos los jugadores del equipo “Raptors” ordenados por nombre.
select * from jugadores where Nombre_equipo = 'Raptors' order by Nombre;
-- 8. Mostrar los puntos por partido del jugador ‘Pau Gasol’.
select e.temporada, e.Puntos_por_partido from estadisticas e, jugadores j where e.jugador = j.codigo and j.Nombre = 'Pau Gasol';
-- 9. Mostrar los puntos por partido del jugador ‘Pau Gasol’ en la temporada ’04/05′.
select e.temporada, e.Puntos_por_partido from estadisticas e, jugadores j where e.jugador = j.codigo and j.Nombre = 'Pau Gasol' and e.temporada = '04/05';
-- 10. Mostrar el número de puntos de cada jugador en toda su carrera.
select j.nombre ,sum(e.Puntos_por_partido) as 'Puntos Total' from estadisticas e, jugadores j where e.jugador = j.codigo group by e.jugador;
-- 11. Mostrar el número de jugadores de cada equipo.
select Nombre_equipo, count(codigo) from jugadores group by Nombre_equipo;
-- 12. Mostrar el jugador que más puntos ha realizado en toda su carrera.
select j.nombre ,sum(e.Puntos_por_partido) as 'Puntos_total' 
from estadisticas e, jugadores j 
where e.jugador = j.codigo group by e.jugador order by Puntos_total desc limit 1;
-- 13. Mostrar el nombre del equipo, conferencia y división del jugador más alto de la NBA.
select e.Nombre, e.Conferencia, e.Division, j.Nombre, j.Altura 
from equipos e, jugadores j 
where e.nombre = j.Nombre_equipo and j.Altura = (select max(Altura) from jugadores);
-- Opcional extra. Mostrar la suma de los puntos por partido de todos los jugadores españoles donde el equipo donde juegan este en ‘Los Angeles’.
select sum(Puntos_por_partido) as Puntos from estadisticas where jugador = 
	(select codigo 
	from jugadores 
	where Procedencia = 'Spain'
	and Nombre_equipo in
		(select Nombre from equipos where Ciudad = 'Los Angeles'));


-- 14. Mostrar la media de puntos en partidos de los equipos de la división Pacific.
select ( (sum(puntos_local) + (select sum(puntos_visitante) from partidos where equipo_visitante in (select Nombre from equipos where Division = 'Pacific'))) / 2) as Puntos_total 
from partidos where equipo_local in (select Nombre from equipos where Division = 'Pacific');
-- 15. Mostrar el partido o partidos (equipo_local, equipo_visitante y diferencia) con mayor
-- diferencia de puntos.
-- // MÉTODO 1
select * 
from partidos 
where abs(puntos_local - puntos_visitante) = (select max(abs(puntos_local - puntos_visitante)) from partidos);
-- 16. Mostrar la media de puntos en partidos de los equipos de la división Pacific.
select ( (sum(puntos_local) + (select sum(puntos_visitante) from partidos where equipo_visitante in (select Nombre from equipos where Division = 'Pacific'))) / 2) as Puntos_total 
from partidos where equipo_local in (select Nombre from equipos where Division = 'Pacific');
-- // MÉTODO 2
select avg(Puntos) from(
	select sum(puntos_local) as Puntos from partidos where equipo_local in (select Nombre from equipos where Division = 'Pacific')
	union
	select sum(puntos_visitante) as Puntos from partidos where equipo_visitante in (select Nombre from equipos where Division = 'Pacific')
) t;
-- 17. Mostrar los puntos de cada equipo en los partidos, tanto de local como de visitante.
select t.equipo, sum(t.puntos) as Puntos_total  from (
select equipo_local as equipo, sum(puntos_local) as puntos from partidos group by equipo
union all
select equipo_visitante as equipo, sum(puntos_visitante) as puntos from partidos group by equipo
) t group by t.equipo;
-- 18. Mostrar quien gana en cada partido (codigo, equipo_local, equipo_visitante,
-- equipo_ganador), en caso de empate sera null.
select codigo, equipo_local, equipo_visitante, 
case when puntos_local > puntos_visitante then equipo_local
when puntos_local < puntos_visitante then equipo_visitante
else null end as equipo_ganador from partidos;