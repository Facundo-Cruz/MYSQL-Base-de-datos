-- 1. Mostrar el nombre de todos los pokemon.
select nombre from pokemon;

-- 2. Mostrar los pokemon que pesen menos de 10kg.
select * from pokemon where peso < 10;
-- 3. Mostrar los pokemon de tipo agua.
select p.nombre
from pokemon p inner join pokemon_tipo p2 on p.numero_pokedex = p2.numero_pokedex
inner join tipo t on p2.id_tipo = t.id_tipo
where t.nombre = 'Agua';
-- 4. Mostrar los pokemon de tipo agua, fuego o tierra ordenados por tipo.
select p.nombre, t.nombre
from pokemon p inner join pokemon_tipo p2 on p.numero_pokedex = p2.numero_pokedex
inner join tipo t on p2.id_tipo = t.id_tipo
where t.nombre in ('Agua','Fuego','Tierra');

-- 5. Mostrar los pokemon que son de tipo fuego y volador.
select p.nombre, t.nombre
from pokemon p inner join pokemon_tipo p2 on p.numero_pokedex = p2.numero_pokedex
inner join tipo t on p2.id_tipo = t.id_tipo
where t.nombre in ('Fuego','Volador');
-- 6. Mostrar los pokemon con una estadística base de ps mayor que 200.
select p.nombre, e.ps from pokemon p, estadisticas_base e 
where p.numero_pokedex = e.numero_pokedex and e.ps > 200;
-- 7. Mostrar los datos (nombre, peso, altura) de la prevolución de Arbok.
select nombre, peso, altura from pokemon where nombre = 'Ekans';
-- 8. Mostrar aquellos pokemon que evolucionan por intercambio.
select p1.* from pokemon p1 
inner join pokemon_forma_evolucion p2 on p2.numero_pokedex = p1.numero_pokedex
inner join forma_evolucion f on f.id_forma_evolucion = p2.id_forma_evolucion
inner join tipo_evolucion t on t.id_tipo_evolucion = f.tipo_evolucion
where t.tipo_evolucion = 'Intercambio';
-- 9. Mostrar el nombre del movimiento con más prioridad.
select distinct m.nombre 
from pokemon p1 inner join pokemon_movimiento_forma p2 on p1.numero_pokedex = p2.numero_pokedex
inner join movimiento m on p2.id_movimiento = m.id_movimiento 
where m.prioridad = (select max(prioridad) from movimiento);
-- 10. Mostrar el pokemon más pesado.
select * from pokemon where peso = (select max(peso) from pokemon);
-- 11. Mostrar el nombre y tipo del ataque con más potencia.
select m.nombre, t2.tipo 
from movimiento m inner join tipo t1 on m.id_tipo = t1.id_tipo
inner join tipo_ataque t2 on t1.id_tipo_ataque = t2.id_tipo_ataque where m.potencia = (select max(potencia) from movimiento);
-- 12. Mostrar el número de movimientos de cada tipo.
select t2.tipo, count(m.nombre) as cantidad
from movimiento m inner join tipo t1 on m.id_tipo = t1.id_tipo
inner join tipo_ataque t2 on t1.id_tipo_ataque = t2.id_tipo_ataque group by t2.tipo;
-- 13. Mostrar todos los movimientos que puedan envenenar.
select distinct m.nombre 
from pokemon p1 inner join pokemon_movimiento_forma p2 on p1.numero_pokedex = p2.numero_pokedex
inner join movimiento m on p2.id_movimiento = m.id_movimiento where m.descripcion like '%envenena%';
-- 14. Mostrar todos los movimientos que causan daño, ordenados alfabéticamente por nombre.
select nombre from movimiento where potencia <> 0 order by nombre;
-- 15. Mostrar todos los movimientos que aprende pikachu.
select distinct m.nombre 
from pokemon p1 inner join pokemon_movimiento_forma p2 on p1.numero_pokedex = p2.numero_pokedex
inner join movimiento m on p2.id_movimiento = m.id_movimiento 
where p1.nombre = 'Pikachu';
-- 16. Mostrar todos los movimientos que aprende pikachu por MT (tipo de aprendizaje).
select distinct m.nombre 
from pokemon p1 inner join pokemon_movimiento_forma p2 on p1.numero_pokedex = p2.numero_pokedex
inner join movimiento m on p2.id_movimiento = m.id_movimiento 
inner join forma_aprendizaje f on p2.id_forma_aprendizaje = f.id_forma_aprendizaje
inner join tipo_forma_aprendizaje tf on f.id_tipo_aprendizaje = tf.id_tipo_aprendizaje
where p1.nombre = 'Pikachu' and tf.tipo_aprendizaje = 'MT';
-- 17. Mostrar todos los movimientos de tipo normal que aprende pikachu por nivel.
select distinct m.nombre 
from pokemon p1 inner join pokemon_movimiento_forma p2 on p1.numero_pokedex = p2.numero_pokedex
inner join movimiento m on p2.id_movimiento = m.id_movimiento 
inner join forma_aprendizaje f on p2.id_forma_aprendizaje = f.id_forma_aprendizaje
inner join tipo_forma_aprendizaje tf on f.id_tipo_aprendizaje = tf.id_tipo_aprendizaje
inner join tipo t on m.id_tipo = t.id_tipo
where p1.nombre = 'Pikachu' and tf.tipo_aprendizaje = 'Nivel' and t.nombre = 'Normal';
-- 18. Mostrar todos los movimientos de efecto secundario cuya probabilidad sea mayor al 30%.
select e.efecto_secundario, m.probabilidad 
from efecto_secundario e inner join movimiento_efecto_secundario m on e.id_efecto_secundario = m.id_efecto_secundario
where m.probabilidad > 30;
-- 19. Mostrar todos los pokemon que evolucionan por piedra.
select p1.* from pokemon p1 
inner join pokemon_forma_evolucion p2 on p2.numero_pokedex = p1.numero_pokedex
inner join forma_evolucion f on f.id_forma_evolucion = p2.id_forma_evolucion
inner join tipo_evolucion t on t.id_tipo_evolucion = f.tipo_evolucion
where t.tipo_evolucion = 'Piedra';
-- 20. Mostrar todos los pokemon que no pueden evolucionar.
select p1.* from pokemon p1 
left join pokemon_forma_evolucion p2 on p2.numero_pokedex = p1.numero_pokedex
left join forma_evolucion f on f.id_forma_evolucion = p2.id_forma_evolucion
where f.id_forma_evolucion is null;
-- 21. Mostrar la cantidad de los pokemon de cada tipo.
select t.nombre, count(t.nombre) 
from pokemon p1 inner join pokemon_tipo p2 on p1.numero_pokedex = p2.numero_pokedex
inner join tipo t on p2.id_tipo = t.id_tipo group by t.nombre;