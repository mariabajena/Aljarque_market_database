--- Mercado de Aljaraque
---- Cambiar herencia
---- Puesto y almacen a _local
-----y trabajador y titular y personal auxiliar a persona.

------DROP ŻEBY USUNĄĆ TO CO SIĘ STWORZYŁO W POPRZEDNIM URUCHOMIENIU PROGRAMU
drop table sancion;
drop table asignacion;
drop table familiaridad;
drop table personal_auxiliar;
drop table espacio_reservado;
drop table licencia;
drop table titular;
drop table almacen;
drop table puesto;                        
drop table _local;
drop table trabajador;
drop table mercado;
drop table persona;


--alguien conectado con el mercado 
CREATE TABLE persona(
    dni char(9),
    nombre char(30),
    fecha_nacimiento date,
    
    primary key (dni)
);

--lugar con muchos _locales
CREATE TABLE mercado(
    nombre char(30),
    Encargado char(9),
    Horario char(200),
    Dias_laborales char(200),
    Domicilio char(50),
    
    primary key (nombre),
    foreign key (Encargado) references persona (dni)
);

--persona trabajando por un puesto 
CREATE TABLE trabajador(
    dni_t char(9),
    fecha_inicio date,
    fecha_fin date,
    numero_seguridad_social char(50),
    
    primary key (dni_t),
    foreign key (dni_t) references persona (dni)
);

--“habitación” en el mercado 
CREATE TABLE _local (
    numero int,
    nombre char(30), --nombre de mercado
    superficie int,
    
    primary key  (numero,nombre),
    foreign key (nombre) references mercado (nombre)
);

--_local con licencia 
CREATE TABLE puesto (
    numero int,
    nombre char(30),
    
    primary key (numero,nombre),
    foreign key (numero,nombre) references _local (numero,nombre)
);

--_local que puede ser compartido por varias puestos licencias
CREATE TABLE almacen (
    numero int,	--de _local 
    nombre char(30),	--de _local-->de mercado(FK)
    frigorifico bit,
    
    primary key (numero,nombre),
    foreign key (numero,nombre) references _local(numero,nombre)
);

--“jefe” del puesto
CREATE TABLE titular (
    dni char(9),
    
    primary key (dni),
    foreign key (dni) references persona(dni) --pomimo ze to jakby wewnatrzklasa, to i tak musimy robic to przez FK
);

--contrato donde tenemos escrito datos sobre el puesto
--cada vez que se cambia el titular se crea una licencia nueva
CREATE TABLE licencia (
    Identificador char(30), --Numero_de_serie(memoria)
    dni_titular char(9),
    numero_puesto int,
    nombre_mercado char(30),
    inicio date,
    vigencia date,
    denominacion_puesto char(40), --nombre del puesto
    renta int,
    deuda int,
    fecha_limite_deuda date,

    primary key (Identificador),
    foreign key (dni_titular) references titular (dni),
    foreign key (numero_puesto,nombre_mercado) references puesto (numero,nombre)
);

--porcentaje del almacén que alquila la licencia
CREATE TABLE espacio_reservado (
    identificador int,
    identificador_licencia char(30),
    numero int,--de almacen
    nombre char(30), --de almacen
    superficie int,
    espacio_frigorifico int,

    primary key (identificador),
    foreign key (identificador_licencia) references licencia (identificador),
    foreign key (numero,nombre) references almacen (numero,nombre)
);

--personas que trabajan por mercado pero no por puesto
CREATE TABLE personal_auxiliar (
    dni char(9),
    ocupacion char(30),

    primary key (dni),
    foreign key (dni) references persona (dni)
);

----relacion mientras Titular y Titular
--un mismo titular o su familia de primer orden no puede tener mas de 2 tipos de puesto iguales
CREATE TABLE familiaridad (
    dni_base char(9), --titular de un puesto
    dni_fam char(9), --titular de otro puesto

    primary key (dni_base,dni_fam), -- lo define la especifica relacion
    foreign key(dni_base) references titular(dni),
    foreign key(dni_fam) references titular(dni)
);


----tabla entre PERSONAL AUXILIAR Y MERCADO (porque tenemos uno a mucho, uno a mucho)
 CREATE TABLE asignacion (
    dni_personal char(9), ----FK references personal_auxiliar(dni) que es FK que references persona(dni)
    pert_mercado char(30),

    primary key(dni_personal,pert_mercado), -----la misma persona puede trabajar en varios mercados
    foreign key(dni_personal) references personal_auxiliar(dni),
    foreign key(pert_mercado) references mercado (nombre)
);

---SĄ PODPIĘTE POD LICENCIA
 CREATE TABLE sancion(
    licencia char(30), ---identificador de la clase licencia 
    tipo char(40), ---SOLO PUEDE TENER VALOR "LEVE", "GRAVE" Y "MUY GRAVE"
    motivo char(1000), ---EXPLICACION DE PORQUE LA LICENCIA HA OBTENIDO SANCION

    primary key (licencia), --to jest zle, bo może byc dużo sankcji do tej samej licencji, więc to nie identyfikuje jednoznacznie sankcji 
    foreign key (licencia) references licencia (identificador)
);

 ------DAR VALORES
insert into persona values ('45573999B','Paco','1995-02-11');
insert into persona values ('45512439B','Marcos','1995-02-11');
insert into persona values ('43312439B','Pedro','1995-02-11');
insert into persona values ('42312439V','Carlos','1895-11-12'); 
insert into persona values ('42356439Z','Frodo','1895-11-12'); 
insert into persona values ('42318939I','Golum','1895-11-12'); 
insert into persona values ('42312437H','Bilbo','1895-11-12'); 

----- 
insert into mercado values ('Aljaraque','42312439V','8am-2pm and 4pm-8pm','Lunes a Domingo por la mañana excepto festivos','Plaza mayor');

-----
insert into trabajador values ('45512439B','2000-02-10','2013-02-11','AOPC39443920109SS');
insert into trabajador values ('43312439B','2005-02-10','2014-02-11','AOPC39445520109SS');
insert into trabajador values ('45573999B','2002-02-10','2015-02-11','AOPC39455520109SS');

-----

insert into _local values (1,'Aljaraque',25);
insert into _local values (2,'Aljaraque',30);
insert into _local values (4,'Aljaraque',20);
insert into _local values (5,'Aljaraque',22);

---

insert into puesto values (1,'Aljaraque');
insert into puesto values (5,'Aljaraque');
---

insert into almacen values (2,'Aljaraque',B'1');
insert into almacen values (4,'Aljaraque',B'0');
---

insert into titular values ('42356439Z');
insert into titular values ('42318939I');
---

insert into licencia values ('ADA123980CHARLIE','42356439Z',1,'Aljaraque','2015-02-10','2020-01-10','Alimentos',200,100,'2018-12-29');

---

insert into espacio_reservado values (1,'ADA123980CHARLIE',2,'Aljaraque',1,1);


---

insert into personal_auxiliar values ('42318939I','Inspector de sanidad');

--- 

insert into familiaridad values ('42356439Z','42318939I');

---
insert into asignacion values ('42318939I','Aljaraque');
---

insert into sancion values ('ADA123980CHARLIE','Leve','Motivo standard por sancion leve');