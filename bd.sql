CREATE DATABASE PeliculasV2;
USE PeliculasV2;

-- PAIS
CREATE TABLE Pais(
    id_pais INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    continente VARCHAR(100),
    idioma_oficial VARCHAR(100)
) ENGINE=InnoDB;

-- DIRECTOR
CREATE TABLE Director(
    id_director INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
) ENGINE=InnoDB;

-- ACTOR
CREATE TABLE Actor(
    id_actor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
) ENGINE=InnoDB;

-- GENERO
CREATE TABLE Genero(
    id_genero INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300),
    fecha_creacion DATE DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

-- CLASIFICACION
CREATE TABLE Clasificacion(
    id_clasificacion INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    edad_minima INT,
    descripcion VARCHAR(200)
) ENGINE=InnoDB;

-- PELICULA
CREATE TABLE Pelicula(
    id_pelicula INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    anio INT NOT NULL,
    duracion_minutos INT,
    sinopsis TEXT,
    id_clasificacion INT,
    id_pais INT,
    FOREIGN KEY (id_clasificacion) REFERENCES Clasificacion(id_clasificacion),
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais)
) ENGINE=InnoDB;

-- RELACION N:M PELICULA-GENERO
CREATE TABLE PeliculaGenero(
    id_pelicula INT,
    id_genero INT,
    importancia varchar(20),
    fecha_asignacion DATE,
    PRIMARY KEY (id_pelicula, id_genero),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
    FOREIGN KEY (id_genero) REFERENCES Genero(id_genero)
) ENGINE=InnoDB;

-- RELACION N:M PELICULA-DIRECTOR
CREATE TABLE PeliculaDirector(
    id_pelicula INT,
    id_director INT,
    rol ENUM('Director Principal','Co-Director','Productor Ejecutivo') DEFAULT 'Director Principal',
    PRIMARY KEY (id_pelicula, id_director),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
    FOREIGN KEY (id_director) REFERENCES Director(id_director)
) ENGINE=InnoDB;

-- RELACION N:M PELICULA-ACTOR
CREATE TABLE PeliculaActor(
    id_pelicula INT,
    id_actor INT,
    personaje VARCHAR(150),
    salario DECIMAL(10,2),
    tiempo_pantalla int,
    protagonista BOOLEAN DEFAULT FALSE,
    fecha_contrato DATE,
    PRIMARY KEY (id_pelicula, id_actor),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
    FOREIGN KEY (id_actor) REFERENCES Actor(id_actor)
) ENGINE=InnoDB;

-- PREMIOS
CREATE TABLE Premio(
    id_premio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(100),
    anio INT
) ENGINE=InnoDB;

-- RELACION N:M PELICULA-PREMIO
CREATE TABLE PeliculaPremio(
    id_pelicula INT,
    id_premio INT,
    resultado ENUM('Ganado','Nominado') DEFAULT 'Ganado',
    ceremonia VARCHAR(100),
    fecha DATE,
    PRIMARY KEY (id_pelicula, id_premio),
    FOREIGN KEY (id_pelicula) REFERENCES Pelicula(id_pelicula),
    FOREIGN KEY (id_premio) REFERENCES Premio(id_premio)
) ENGINE=InnoDB;

-- ============================
-- PAISES
-- ============================
INSERT INTO Pais (id_pais, nombre, continente, idioma_oficial) VALUES
(1, 'México', 'América', 'Español'), (2, 'Estados Unidos', 'América', 'Inglés'),
(3, 'Francia', 'Europa', 'Francés'), (4, 'Japón', 'Asia', 'Japonés'),
(5, 'Reino Unido', 'Europa', 'Inglés');

INSERT INTO Pais (id_pais, nombre, continente, idioma_oficial) VALUES
(6, 'Italia', 'Europa', 'Italiano'), (7, 'Alemania', 'Europa', 'Alemán'),
(8, 'India', 'Asia', 'Hindi'), (9, 'Australia', 'Oceanía', 'Inglés'),
(10, 'Brasil', 'América', 'Portugués');

INSERT INTO Pais VALUES
(11,'Argentina','América','Español'), (12,'España','Europa','Español'),
(13,'Canadá','América','Inglés'), (14,'Corea del Sur','Asia','Coreano'),
(15,'China','Asia','Mandarín'), (16,'Rusia','Europa','Ruso'),
(17,'Suecia','Europa','Sueco'), (18,'Noruega','Europa','Noruego'),
(19,'Egipto','África','Árabe'), (20,'Sudáfrica','África','Inglés');

INSERT INTO Pais VALUES
(21,'Chile','América','Español'), (22,'Colombia','América','Español'),
(23,'Perú','América','Español'), (24,'Países Bajos','Europa','Neerlandés'),
(25,'Bélgica','Europa','Neerlandés'), (26,'Suiza','Europa','Alemán'),
(27,'Turquía','Asia','Turco'), (28,'Irán','Asia','Persa'),
(29,'Tailandia','Asia','Tailandés'), (30,'Nueva Zelanda','Oceanía','Inglés');

-- ============================
-- CLASIFICACIONES
-- ============================
INSERT INTO Clasificacion (id_clasificacion, nombre, edad_minima, descripcion) VALUES
(1, 'PG-13', 13, 'Mayores de 13 años con supervisión'), (2, 'R', 18, 'Restringido para menores de 18 años'),
(3, 'G', 0, 'Apta para todo público'), (4, 'B15', 15, 'No recomendada para menores de 15 años'),
(5, 'NC-17', 18, 'Solo adultos');

INSERT INTO Clasificacion (id_clasificacion, nombre, edad_minima, descripcion) VALUES
(6, 'PG', 10, 'Apta para mayores de 10 años'), (7, 'M', 17, 'Contenido maduro'),
(8, 'U', 0, 'Universal, todo público'), (9, '12A', 12, 'Mayores de 12 años con supervisión'),
(10, '16', 16, 'No recomendada para menores de 16 años');

INSERT INTO Clasificacion VALUES
(11,'A',0,'Todo público'), (12,'B',12,'Adolescentes'),
(13,'C',18,'Adultos'), (14,'D',21,'Contenido explícito'),
(15,'E',0,'Educativo'), (16,'PG-10',10,'Supervisión'),
(17,'PG-15',15,'Adolescentes'), (18,'X',18,'Solo adultos'),
(19,'Y7',7,'Niños mayores'), (20,'TV-MA',18,'Maduro');

INSERT INTO Clasificacion VALUES
(21,'Infantil',0,'Niños'), (22,'Adolescente',13,'Jóvenes'),
(23,'Adulto',18,'Mayores'), (24,'Familiar+',7,'Con supervisión'),
(25,'Cine Arte',16,'Contenido artístico'), (26,'TV-14',14,'Televisión'),
(27,'TV-PG',10,'Televisión familiar'), (28,'TV-Y',0,'Niños'),
(29,'TV-Y7',7,'Niños mayores'), (30,'Especial',18,'Contenido especial');

-- ============================
-- GENEROS
-- ============================
INSERT INTO Genero (id_genero, nombre, descripcion, fecha_creacion) VALUES
(1, 'Acción', 'Películas con escenas intensas y físicas', '1980-01-01'), (2, 'Drama', 'Películas centradas en conflictos emocionales', '1970-01-01'),
(3, 'Animación', 'Películas animadas', '1960-01-01'), (4, 'Romance', 'Historias centradas en el amor', '1985-01-01'),
(5, 'Fantasía', 'Películas con elementos mágicos', '1950-01-01'); 

INSERT INTO Genero (id_genero, nombre, descripcion, fecha_creacion) VALUES
(6, 'Comedia', 'Películas humorísticas', '1960-01-01'), (7, 'Ciencia Ficción', 'Películas futuristas y tecnológicas', '1950-01-01'),
(8, 'Terror', 'Películas de miedo y suspenso', '1940-01-01'), (9, 'Documental', 'Películas basadas en hechos reales', '1930-01-01'),
(10, 'Musical', 'Películas con números musicales', '1920-01-01');

INSERT INTO Genero VALUES
(11,'Suspenso','Tensión constante','1975-01-01'), (12,'Aventura','Exploraciones y viajes','1965-01-01'),
(13,'Bélico','Guerras y conflictos','1945-01-01'), (14,'Western','Viejo oeste','1930-01-01'),
(15,'Misterio','Casos sin resolver','1955-01-01'), (16,'Biográfico','Basado en vidas reales','1980-01-01'),
(17,'Deporte','Historias deportivas','1990-01-01'), (18,'Histórico','Eventos del pasado','1970-01-01'),
(19,'Thriller','Alta tensión psicológica','1985-01-01'), (20,'Superhéroes','Personajes con poderes','2000-01-01');

INSERT INTO Genero VALUES
(21,'Cyberpunk','Tecnología y distopía','1990-01-01'), (22,'Psicológico','Enfoque mental','1980-01-01'), 
(23,'Crimen','Delincuencia organizada','1970-01-01'), (24,'Familiar','Para toda la familia','2000-01-01'), 
(25,'Road Movie','Viajes y rutas','1960-01-01'), (26,'Noir','Estilo oscuro','1940-01-01'),
(27,'Experimental','Narrativa no convencional','2000-01-01'), (28,'Corto','Duración corta','2010-01-01'),
(29,'Mockumentary','Falso documental','2005-01-01'), (30,'Steampunk','Tecnología antigua','1995-01-01');

-- ============================
-- DIRECTORES
-- ============================
INSERT INTO Director (id_director, nombre, apellido, fecha_nacimiento, id_pais) VALUES
(1, 'Guillermo', 'del Toro', '1964-10-09', 1), (2, 'Steven', 'Spielberg', '1946-12-18', 2),
(3, 'Christopher', 'Nolan', '1970-07-30', 5), (4, 'Hayao', 'Miyazaki', '1941-01-05', 4),
(5, 'Jean-Pierre', 'Jeunet', '1953-09-03', 3);

INSERT INTO Director (id_director, nombre, apellido, fecha_nacimiento, id_pais) VALUES
(6, 'Federico', 'Fellini', '1920-01-20', 6), (7, 'Wim', 'Wenders', '1945-08-14', 7),
(8, 'Satyajit', 'Ray', '1921-05-02', 8), (9, 'George', 'Miller', '1945-03-03', 9),
(10, 'Fernando', 'Meirelles', '1955-11-20', 10);

INSERT INTO Director VALUES
(21,'Alejandro','González Iñárritu','1963-08-15',1), (22,'Alfonso','Cuarón','1961-11-28',1),
(23,'Gary','Alazraki','1978-03-18',1), (24,'Alfonso','Cuarón','1961-11-28',1),
(25,'Guillermo','del Toro','1964-10-09',1), (26,'Fernando','Frías','1981-01-01',1),
(27,'Luis','Estrada','1962-01-17',1), (28,'Eugenio','Derbez','1961-09-02',1),
(29,'Roberto','Gavaldón','1909-06-07',1), (30,'Alfonso','Arau','1932-01-11',1);

INSERT INTO Director VALUES
(31,'Quentin','Tarantino','1963-03-27',2), (32,'Martin','Scorsese','1942-11-17',2),
(33,'Denis','Villeneuve','1967-10-03',13), (34,'Bong','Joon-ho','1969-09-14',14),
(35,'Pedro','Almodóvar','1949-09-25',12), (36,'Ridley','Scott','1937-11-30',5),
(37,'James','Cameron','1954-08-16',13), (38,'David','Fincher','1962-08-28',2),
(39,'Greta','Gerwig','1983-08-04',2), (40,'Patty','Jenkins','1971-07-24',2);

INSERT INTO Director VALUES
(41,'Damien','Chazelle','1985-01-19',2), (42,'Jordan','Peele','1979-02-21',2),
(43,'Ari','Aster','1986-07-15',2), (44,'Robert','Eggers','1983-07-07',2),
(45,'Luca','Guadagnino','1971-08-10',6), (46,'Park','Chan-wook','1963-08-23',14),
(47,'Gaspar','Noé','1963-12-27',3), (48,'Apichatpong','Weerasethakul','1970-07-16',29),
(49,'Taika','Waititi','1975-08-16',30), (50,'Neill','Blomkamp','1979-09-17',20);

-- ============================
-- ACTORES
-- ============================
INSERT INTO Actor (id_actor, nombre, apellido, fecha_nacimiento, id_pais) VALUES
(1, 'Salma', 'Hayek', '1966-09-02', 1), (2, 'Leonardo', 'DiCaprio', '1974-11-11', 2),
(3, 'Kate', 'Winslet', '1975-10-05', 5), (4, 'Rumi', 'Hiiragi', '1987-08-01', 4),
(5, 'Audrey', 'Tautou', '1976-08-09', 3);

INSERT INTO Actor (id_actor, nombre, apellido, fecha_nacimiento, id_pais) VALUES
(6, 'Marcello', 'Mastroianni', '1924-09-28', 6), (7, 'Bruno', 'Ganz', '1941-03-22', 7),
(8, 'Soumitra', 'Chatterjee', '1935-01-19', 8), (9, 'Mel', 'Gibson', '1956-01-03', 9),
(10, 'Wagner', 'Moura', '1976-06-27', 10);

INSERT INTO Actor VALUES
(21,'Gael','García Bernal','1978-11-30',1), (22,'Diego','Luna','1979-12-29',1),
(23,'Luis','Gerardo Méndez','1982-03-12',1), (24,'Yalitza','Aparicio','1993-12-11',1),
(25,'Ivana','Baquero','1994-06-11',3), (26,'Juan Daniel','García','1997-01-01',1),
(27,'Damián','Alcázar','1953-01-08',1), (28,'Eugenio','Derbez','1961-09-02',1),
(29,'Ignacio','López Tarso','1925-01-15',1), (30,'Lumi','Cavazos','1968-12-31',1);

INSERT INTO Actor VALUES
(31,'Brad','Pitt','1963-12-18',2), (32,'Angelina','Jolie','1975-06-04',2),
(33,'Tom','Hanks','1956-07-09',2), (34,'Scarlett','Johansson','1984-11-22',2),
(35,'Chris','Evans','1981-06-13',2), (36,'Robert','Downey Jr','1965-04-04',2),
(37,'Emma','Stone','1988-11-06',2), (38,'Ryan','Gosling','1980-11-12',13),
(39,'Keanu','Reeves','1964-09-02',13), (40,'Natalie','Portman','1981-06-09',2);

INSERT INTO Actor VALUES
(41,'Timothée','Chalamet','1995-12-27',2), (42,'Florence','Pugh','1996-01-03',5),
(43,'Daniel','Kaluuya','1989-02-24',5), (44,'Anya','Taylor-Joy','1996-04-16',5),
(45,'Zendaya','','1996-09-01',2), (46,'Joaquin','Phoenix','1974-10-28',2),
(47,'Margot','Robbie','1990-07-02',9), (48,'Adam','Driver','1983-11-19',2),
(49,'Rami','Malek','1981-05-12',2), (50,'Pedro','Pascal','1975-04-02',21);

-- ============================
-- PELICULAS
-- ============================
INSERT INTO Pelicula (id_pelicula, titulo, anio, duracion_minutos, sinopsis, id_clasificacion, id_pais) VALUES
(1, 'La Forma del Agua', 2017, 123, 'Una mujer se enamora de una criatura acuática.', 4, 1),
(2, 'Jurassic Park', 1993, 127, 'Un parque con dinosaurios se descontrola.', 1, 2),
(3, 'Inception', 2010, 148, 'Un ladrón roba secretos a través de los sueños.', 1, 2),
(4, 'El viaje de Chihiro', 2001, 125, 'Una niña entra en un mundo mágico lleno de espíritus.', 3, 4),
(5, 'Amélie', 2001, 122, 'Una joven parisina transforma la vida de quienes la rodean.', 3, 3);

INSERT INTO Pelicula (id_pelicula, titulo, anio, duracion_minutos, sinopsis, id_clasificacion, id_pais) VALUES
(6, 'La Dolce Vita', 1960, 174, 'Un periodista explora la vida nocturna romana.', 6, 6),
(7, 'Las Alas del Deseo', 1987, 128, 'Ángeles observan la vida en Berlín.', 7, 7),
(8, 'Pather Panchali', 1955, 125, 'Historia de una familia rural en India.', 8, 8),
(9, 'Mad Max', 1979, 93, 'Un policía lucha en un mundo violento.', 7, 9),
(10, 'Ciudad de Dios', 2002, 130, 'Crimen en las favelas de Brasil.', 7, 10);

INSERT INTO Pelicula VALUES
(21,'Amores Perros',2000,154,'Historias cruzadas en CDMX',2,1), (22,'Y tu mamá también',2001,106,'Viaje de dos amigos con una mujer',2,1),
(23,'Nosotros los Nobles',2013,108,'Familia rica aprende a trabajar',4,1), (24,'Roma',2018,135,'Vida de una trabajadora doméstica',4,1),
(25,'El laberinto del fauno',2006,118,'Fantasia en guerra civil',4,1), (26,'Ya no estoy aquí',2019,112,'Cultura kolombia en Monterrey',4,1),
(27,'La dictadura perfecta',2014,143,'Crítica política',4,1), (28,'Instructions Not Included',2013,115,'Padre soltero inesperado',4,1),
(29,'Macario',1960,91,'Hombre pobre conoce a la muerte',6,1), (30,'Como agua para chocolate',1992,105,'Amor y cocina tradicional',4,1);

INSERT INTO Pelicula VALUES
(31,'Parasite',2019,132,'Familia pobre se infiltra en rica',2,14), (32,'Titanic',1997,195,'Amor en tragedia marítima',1,2),
(33,'Gladiator',2000,155,'Venganza romana',2,5), (34,'The Dark Knight',2008,152,'Batman vs Joker',2,2),
(35,'Interstellar',2014,169,'Viaje espacial',1,2), (36,'Fight Club',1999,139,'Club secreto',2,2),
(37,'Forrest Gump',1994,142,'Vida extraordinaria',3,2), (38,'La La Land',2016,128,'Amor y música',4,2),
(39,'Matrix',1999,136,'Realidad simulada',2,2), (40,'Avatar',2009,162,'Mundo alienígena',1,2);

INSERT INTO Pelicula VALUES
(41,'Whiplash',2014,106,'Baterista y profesor exigente',2,2), (42,'Get Out',2017,104,'Terror social',2,2),
(43,'Hereditary',2018,127,'Terror familiar',2,2), (44,'The Lighthouse',2019,109,'Dos hombres en faro',2,2),
(45,'Call Me by Your Name',2017,132,'Romance en Italia',4,6), (46,'Oldboy',2003,120,'Venganza extrema',2,14),
(47,'Irreversible',2002,97,'Narrativa invertida',2,3), (48,'Uncle Boonmee',2010,114,'Reencarnación',4,29),
(49,'Jojo Rabbit',2019,108,'Niño en guerra',4,30), (50,'District 9',2009,112,'Alienígenas refugiados',2,20);

-- ============================
-- PELICULA-GENERO
-- ============================
INSERT INTO PeliculaGenero VALUES
(1,4,'Primario','2017-12-01'), (2,1,'Primario','1993-06-11'),
(3,1,'Primario','2010-07-16'), (4,3,'Primario','2001-07-20'),
(5,2,'Primario','2001-04-25');

INSERT INTO PeliculaGenero VALUES
(6,2,'Primario','1960-02-05'), (7,2,'Primario','1987-05-17'),
(8,2,'Primario','1955-08-26'), (9,1,'Primario','1979-04-12'),
(10,2,'Primario','2002-08-30');

INSERT INTO PeliculaGenero VALUES
(21,2,'Primario','2000-01-01'), (22,4,'Primario','2001-01-01'),
(23,6,'Primario','2013-01-01'), (24,2,'Primario','2018-01-01'),
(25,5,'Primario','2006-01-01'), (26,2,'Primario','2019-01-01'),
(27,6,'Primario','2014-01-01'), (28,6,'Primario','2013-01-01'),
(29,15,'Primario','1960-01-01'), (30,4,'Primario','1992-01-01');

INSERT INTO PeliculaGenero VALUES
(31,19,'Primario','2019-01-01'), (32,4,'Primario','1997-01-01'),
(33,13,'Primario','2000-01-01'), (34,20,'Primario','2008-01-01'),
(35,7,'Primario','2014-01-01'), (36,2,'Primario','1999-01-01'),
(37,2,'Primario','1994-01-01'), (38,10,'Primario','2016-01-01'),
(39,7,'Primario','1999-01-01'), (40,5,'Primario','2009-01-01');

INSERT INTO PeliculaGenero VALUES
(41,2,'Primario','2014-01-01'), (42,8,'Primario','2017-01-01'),
(43,8,'Primario','2018-01-01'), (44,22,'Primario','2019-01-01'),
(45,4,'Primario','2017-01-01'), (46,23,'Primario','2003-01-01'),
(47,22,'Primario','2002-01-01'), (48,27,'Primario','2010-01-01'),
(49,6,'Primario','2019-01-01'), (50,7,'Primario','2009-01-01');

-- ============================
-- PELICULA-DIRECTOR
-- ============================
INSERT INTO PeliculaDirector VALUES
(1,1,'Director Principal'), (2,2,'Director Principal'),
(3,3,'Director Principal'), (4,4,'Director Principal'),
(5,5,'Director Principal'); 

INSERT INTO PeliculaDirector VALUES
(6,6,'Director Principal'), (7,7,'Director Principal'),
(8,8,'Director Principal'), (9,9,'Director Principal'),
(10,10,'Director Principal');

INSERT INTO PeliculaDirector VALUES
(21,21,'Director Principal'), (22,22,'Director Principal'),
(23,23,'Director Principal'), (24,22,'Director Principal'),
(25,1,'Director Principal'), (26,26,'Director Principal'),
(27,27,'Director Principal'), (28,28,'Director Principal'),
(29,29,'Director Principal'), (30,30,'Director Principal');

INSERT INTO PeliculaDirector VALUES
(31,34,'Director Principal'), (32,37,'Director Principal'),
(33,36,'Director Principal'), (34,38,'Director Principal'),
(35,33,'Director Principal'), (36,38,'Director Principal'),
(37,32,'Director Principal'), (38,39,'Director Principal'),
(39,33,'Director Principal'), (40,37,'Director Principal');

INSERT INTO PeliculaDirector VALUES
(41,41,'Director Principal'), (42,42,'Director Principal'),
(43,43,'Director Principal'), (44,44,'Director Principal'),
(45,45,'Director Principal'), (46,46,'Director Principal'),
(47,47,'Director Principal'), (48,48,'Director Principal'),
(49,49,'Director Principal'), (50,50,'Director Principal');

-- ============================
-- PELICULA-ACTOR
-- ============================
INSERT INTO PeliculaActor VALUES
(1,1,'Elisa',2000000.00,90,TRUE,'2016-05-01'), (2,2,'Dr. Grant',5000000.00,80,FALSE,'1992-01-01'),
(3,2,'Dom Cobb',20000000.00,110,TRUE,'2009-01-01'), (3,3,'Mal',15000000.00,95,FALSE,'2009-01-01'),
(4,4,'Chihiro',500000.00,100,TRUE,'2000-01-01'), (5,5,'Amélie Poulain',1000000.00,120,TRUE,'2000-01-01');

INSERT INTO PeliculaActor VALUES
(6,6,'Marcello Rubini',100000.00,120,TRUE,'1959-01-01'), (7,7,'Ángel Damiel',200000.00,100,TRUE,'1986-01-01'),
(8,8,'Apu',50000.00,90,TRUE,'1954-01-01'), (9,9,'Max Rockatansky',300000.00,80,TRUE,'1978-01-01'),
(10,10,'Zé Pequeno',400000.00,95,TRUE,'2001-01-01');

INSERT INTO PeliculaActor VALUES
(21,21,'Octavio',2000000,120,TRUE,'1999-01-01'), (22,21,'Julio',1500000,100,TRUE,'2000-01-01'),
(22,22,'Tenoch',1500000,100,TRUE,'2000-01-01'), (23,23,'Javi Noble',1000000,100,TRUE,'2012-01-01'),
(24,24,'Cleo',500000,120,TRUE,'2017-01-01'), (25,25,'Ofelia',800000,100,TRUE,'2005-01-01'),
(26,26,'Ulises',300000,100,TRUE,'2018-01-01'), (27,27,'Gobernador',700000,110,TRUE,'2013-01-01'),
(28,28,'Valentín',2000000,110,TRUE,'2012-01-01'), (29,29,'Macario',100000,90,TRUE,'1959-01-01'),
(30,30,'Tita',500000,100,TRUE,'1991-01-01');

INSERT INTO PeliculaActor VALUES
(31,31,'Protagonista',3000000,120,TRUE,'2018-01-01'), (32,32,'Rose',5000000,150,TRUE,'1996-01-01'),
(33,31,'Maximus',4000000,140,TRUE,'1999-01-01'), (34,35,'Capitan',6000000,130,TRUE,'2007-01-01'),
(35,38,'Cooper',7000000,150,TRUE,'2013-01-01'), (36,31,'Tyler',3000000,120,TRUE,'1998-01-01'),
(37,33,'Forrest',8000000,140,TRUE,'1993-01-01'), (38,37,'Mia',2000000,110,TRUE,'2015-01-01'),
(39,39,'Neo',5000000,130,TRUE,'1998-01-01'), (40,34,'Neytiri',4000000,140,TRUE,'2008-01-01');

INSERT INTO PeliculaActor VALUES
(41,41,'Andrew',1000000,100,TRUE,'2013-01-01'), (42,43,'Chris',2000000,90,TRUE,'2016-01-01'),
(43,42,'Dani',1500000,95,TRUE,'2017-01-01'), (44,44,'Thomas',1200000,100,TRUE,'2018-01-01'),
(45,41,'Elio',2000000,120,TRUE,'2016-01-01'), (46,46,'Oh Dae-su',2500000,110,TRUE,'2002-01-01'),
(47,46,'Marcus',1800000,90,TRUE,'2001-01-01'), (48,50,'Boonmee',500000,100,TRUE,'2009-01-01'),
(49,47,'Rosie',2200000,100,TRUE,'2018-01-01'), (50,48,'Wikus',2000000,105,TRUE,'2008-01-01');

-- ============================
-- PREMIOS
-- ============================
INSERT INTO Premio (id_premio, nombre, categoria, anio) VALUES
(1, 'Oscar', 'Mejor Película', 2018), (2, 'Oscar', 'Mejor Dirección', 2018),
(3, 'Oscar', 'Mejores Efectos Visuales', 1994), (4, 'Oscar', 'Mejor Fotografía', 2011),
(5, 'Oscar', 'Mejor Película de Animación', 2003), (6, 'César', 'Mejor Película', 2002);

INSERT INTO Premio (id_premio, nombre, categoria, anio) VALUES
(7, 'Palma de Oro', 'Mejor Película', 1960), (8, 'Premio Europeo', 'Mejor Dirección', 1987),
(9, 'BAFTA', 'Mejor Película Extranjera', 1956), (10, 'Oscar', 'Mejor Montaje', 1980),
(11, 'Oscar', 'Mejor Dirección', 2004);

INSERT INTO Premio VALUES
(12,'Oscar','Mejor Actor',2020), (13,'Oscar','Mejor Actriz',2020),
(14,'Globo de Oro','Mejor Película',2020), (15,'BAFTA','Mejor Dirección',2019),
(16,'Cannes','Palma de Oro',2019), (17,'Goya','Mejor Película',2018),
(18,'Ariel','Mejor Película',2017), (19,'Oscar','Mejor Sonido',2015),
(20,'Oscar','Mejor Guion',2014), (21,'Globo de Oro','Mejor Actor',2013);

INSERT INTO Premio VALUES
(22,'Oscar','Mejor Sonido',2015), (23,'Oscar','Mejor Guion Original',2018),
(24,'BAFTA','Mejor Actor',2020), (25,'Cannes','Mejor Director',2019),
(26,'Globo de Oro','Mejor Película',2017), (27,'Ariel','Mejor Actor',2016),
(28,'Goya','Mejor Dirección',2015), (29,'Oscar','Mejor Banda Sonora',2014),
(30,'BAFTA','Mejor Fotografía',2013), (31,'Cannes','Palma de Oro',2010);

-- ============================
-- PELICULA-PREMIO
-- ============================
INSERT INTO PeliculaPremio VALUES
(1,1,'Ganado','Oscar','2018-03-04'), (1,2,'Ganado','Oscar','2018-03-04'),
(2,3,'Ganado','Oscar','1994-03-21'), (3,4,'Ganado','Oscar','2011-02-27'),
(4,5,'Ganado','Oscar','2003-03-23'), (5,6,'Ganado','César','2002-03-02');

INSERT INTO PeliculaPremio VALUES
(6,7,'Ganado','Cannes','1960-05-20'), (7,8,'Ganado','Premios Europeos','1987-12-01'),
(8,9,'Ganado','BAFTA','1956-02-15'), (9,10,'Nominado','Oscar','1980-04-14'),
(10,11,'Nominado','Oscar','2004-02-29');

INSERT INTO PeliculaPremio VALUES
(21,1,'Nominado','Oscar','2001-01-01'), (24,1,'Ganado','Oscar','2019-01-01'),
(25,2,'Ganado','Oscar','2007-01-01'), (29,1,'Nominado','Oscar','1961-01-01');

INSERT INTO PeliculaPremio VALUES
(31,12,'Ganado','Oscar','2020-02-01'), (32,13,'Ganado','Oscar','1998-03-01'),
(33,14,'Ganado','Golden Globes','2001-01-01'), (34,15,'Ganado','BAFTA','2009-01-01'),
(35,19,'Ganado','Oscar','2015-01-01'), (36,20,'Ganado','Oscar','2000-01-01'),
(37,21,'Ganado','Golden Globes','1995-01-01'), (38,14,'Nominado','Golden Globes','2017-01-01'),
(39,19,'Ganado','Oscar','2000-01-01'), (40,12,'Ganado','Oscar','2010-01-01');

INSERT INTO PeliculaPremio VALUES
(41,22,'Ganado','Oscar','2015-02-01'), (42,23,'Ganado','Oscar','2018-02-01'),
(43,24,'Nominado','BAFTA','2020-01-01'), (44,25,'Ganado','Cannes','2019-05-01'),
(45,26,'Nominado','Golden Globes','2017-01-01'), (46,27,'Ganado','Ariel','2016-01-01'), 
(47,28,'Nominado','Goya','2015-01-01'), (48,31,'Ganado','Cannes','2010-05-01'),
(49,29,'Nominado','Oscar','2020-01-01'), (50,30,'Ganado','BAFTA','2013-01-01');

-- =======================
-- 			CONSTRAINS 
-- =======================
ALTER TABLE pais ADD CONSTRAINT chk_continente CHECK (continente IN ('América', 'Europa', 'Asia', 'África', 'Antártida', 'Oceanía'));

ALTER TABLE Director ADD CONSTRAINT chk_fnac CHECK (fecha_nacimiento < '2026-01-01');

ALTER TABLE Actor ADD CONSTRAINT chk_fnactor CHECK (fecha_nacimiento < '2026-01-01');

ALTER TABLE genero ADD CONSTRAINT fc_genero CHECK (fecha_creacion <'2026-01-01');

ALTER TABLE pelicula ADD CONSTRAINT chk_anio CHECK (anio < '2026');

ALTER TABLE peliculaactor ADD CONSTRAINT chk_contrato CHECK (fecha_contrato < '2026-01-01');

ALTER TABLE peliculagenero ADD CONSTRAINT chk_fechaasig CHECK (fecha_asignacion < '2026-01-01');

ALTER TABLE premio ADD CONSTRAINT chk_panio CHECK (anio < '2027');

ALTER TABLE peliculagenero ADD CONSTRAINT chk_fechaasig CHECK (fecha_asignacion < '2026-01-01');

ALTER TABLE PeliculaGenero ADD CONSTRAINT chk_importancia CHECK (importancia IN ('Primario','Secundario'));

-- =======================
-- 				SELECT 
-- =======================
SELECT * FROM ACTOR;
SELECT * FROM CLASIFICACION;
SELECT * FROM DIRECTOR;
SELECT * FROM GENERO;
SELECT * FROM PAIS;
SELECT * FROM PELICULA;
SELECT * FROM PELICULAACTOR;
SELECT * FROM PELICULADIRECTOR;
SELECT * FROM PELICULAGENERO;
SELECT * FROM PELICULAPREMIO;
SELECT * FROM PREMIO;
SELECT * FROM USUARIO;

/*------------------------------------------------------------------------*/
/*---------------------- CREAR USUARIOS ----------------------*/
CREATE USER 'Aguilar'@'%' IDENTIFIED BY 'Pa1001';
GRANT SELECT, INSERT, UPDATE, ALTER, CREATE, DROP, DELETE
ON Peliculas.actor TO 'Aguilar'@'%'; 

CREATE TABLE Usuario (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    user VARCHAR(50),
    name VARCHAR(50),
    pass VARCHAR(255)
);

-- =================================
--                         Administrador
-- =================================
-- 						usuario: Dios
-- 						pass: admin
-- 						usuarhio: fabri
-- 					´	pass: Hola1234

-- =================================
-- 						Usuario Común
-- =================================
-- 						usuario: Pablo
-- 						pass: PabloAlberto

-- =================================
-- 						 Página Web
-- =================================
--  usuario:			 juan				fabri
--  pass:  				admin			Hola1234

use peliculasv2;
CREATE USER 'Susana'@'%' IDENTIFIED BY 'Susana';
GRANT SELECT ON peliculasv2.pelicula TO 'Susana'@'%';
GRANT SELECT ON peliculasv2.Clasificacion TO 'Susana'@'%';
GRANT SELECT ON peliculasv2.Pais TO 'Susana'@'%';
FLUSH PRIVILEGES;

CREATE USER 'Juan'@'%' IDENTIFIED BY 'Ivan';
GRANT SELECT ON peliculasv2.pelicula TO 'Juan'@'%';
GRANT SELECT ON peliculasv2.Clasificacion TO 'Juan'@'%';
GRANT SELECT ON peliculasv2.Pais TO 'Juan'@'%';

-- =================================
-- 		CREACION DE LA BITACORA
-- =================================

CREATE TABLE bitacora_pelicula (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    
    usuario VARCHAR(100),
    accion VARCHAR(20),
    
    id_pelicula INT,
    
    titulo_anterior VARCHAR(60),
	titulo_nuevo VARCHAR(60),
	
    anio_anterior int,
    anio_nuevo int,
	
    clas_anterior int,
    clas_nuevo int,
    
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE bitacora_pelicula
MODIFY clas_nuevo VARCHAR(100);

DELIMITER $$

CREATE TRIGGER pelicula_insert
AFTER INSERT ON pelicula
FOR EACH ROW
BEGIN
    DECLARE clasif_new VARCHAR(100);

    -- Obtener clasificación nueva
    SELECT nombre INTO clasif_new
    FROM clasificacion
    WHERE id_clasificacion = NEW.id_clasificacion;

    INSERT INTO bitacora_pelicula(
        usuario,
        accion,
        id_pelicula,
        titulo_nuevo,
        anio_nuevo,
        clas_nuevo
    )
    VALUES (
        USER(),
        'INSERT',
        NEW.id_pelicula,
        NEW.titulo,
        NEW.anio,
        clasif_new
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER pelicula_update
AFTER UPDATE ON pelicula
FOR EACH ROW
BEGIN
    DECLARE clasif_old VARCHAR(100);
    DECLARE clasif_new VARCHAR(100);

    -- Obtener clasificación anterior
    SELECT nombre INTO clasif_old
    FROM clasificacion
    WHERE id_clasificacion = OLD.id_clasificacion;

    -- Obtener clasificación nueva
    SELECT nombre INTO clasif_new
    FROM clasificacion
    WHERE id_clasificacion = NEW.id_clasificacion;

    INSERT INTO bitacora_pelicula(
        usuario,
        accion,
        id_pelicula,
        titulo_anterior,
        titulo_nuevo,
        anio_anterior,
        anio_nuevo,
        clas_anterior,
        clas_nuevo
    )
    VALUES (
        USER(),
        'UPDATE',
        NEW.id_pelicula,
        OLD.titulo,
        NEW.titulo,
        OLD.anio,
        NEW.anio,
        clasif_old,
        clasif_new
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER pelicula_delete
BEFORE DELETE ON pelicula
FOR EACH ROW
BEGIN
    DECLARE clasif_old VARCHAR(100);

    -- Obtener clasificación anterior
    SELECT nombre INTO clasif_old
    FROM clasificacion
    WHERE id_clasificacion = OLD.id_clasificacion;

INSERT INTO bitacora_pelicula(
        usuario,
        accion,
        id_pelicula,
        titulo_anterior,
        anio_anterior,
        clasificacion_anterior
    )
    VALUES (
        USER(),
        'DELETE',
        OLD.id_pelicula,
        OLD.titulo,
        OLD.anio,
        clasif_old
    );
END$$

DELIMITER ;

DROP TRIGGER pelicula_insert;
DROP TABLE bitacora_pelicula;

SELECT * FROM bitacora_pelicula;

-- =================================
-- 		CREACION DE FUNCIONES
-- =================================

DELIMITER $$

CREATE FUNCTION ranking_peliculas(p_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE total_ganados INT;

    -- Cuenta el total de premios ganados
    SELECT COUNT(*) INTO total_ganados
    FROM PeliculaPremio
    WHERE id_pelicula = p_id
    AND resultado = 'Ganado';

    -- Clasificación según premios
    IF total_ganados >= 10 THEN
        RETURN 'Es un éxito';
    ELSEIF total_ganados >= 5 THEN
        RETURN 'Moderado';
    ELSEIF total_ganados >= 1 THEN
        RETURN 'Reconocida';
    ELSE
        RETURN 'no tiene premios';
    END IF;

END $$
DELIMITER ;
-- consulta de la función
SELECT 
    titulo,
    ranking_peliculas(id_pelicula) AS nivel_exito
FROM Pelicula;

DELIMITER $$

CREATE FUNCTION total_ganado_actor(idActor INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(12,2);

    SELECT IFNULL(SUM(salario), 0)
    INTO total
    FROM PeliculaActor
    WHERE id_actor = idActor;

    RETURN total;
END $$

DELIMITER ;
SELECT 
    CONCAT(nombre, ' ', apellido) AS actor,
    total_ganado_actor(id_actor) AS total_ganado
FROM Actor;

-- =================================
-- 		CREACION DE PROCEDIMIENTOS
-- =================================

DELIMITER //
CREATE PROCEDURE VerificarClaveNula()
BEGIN
	SELECT id_pelicula, titulo
    FROM Pelicula
    WHERE id_pelicula IS NULL;
END //

-- CLAVE DE PRODUCTO REPETIDO
DELIMITER //
CREATE PROCEDURE verificarClaveRepetida()
BEGIN
    SELECT id_pelicula, COUNT(*) AS veces
    FROM Pelicula
    GROUP BY id_pelicula
    HAVING COUNT(*) > 1;
END//

-- CLAVE DE PRODUCTO QUE NO CUMPLA CON EL FORMATO
DELIMITER //
CREATE PROCEDURE verificarClaveFormato()
BEGIN
    SELECT id_pelicula, titulo
    FROM Pelicula
    WHERE id_pelicula <= 0;
END//

DELIMITER $$

-- =====================================
-- 1. VER TODAS LAS PELICULAS
-- =====================================
DELIMITER $$
CREATE PROCEDURE ver_peliculas()
BEGIN
SELECT * FROM Pelicula;
END $$

-- =====================================
-- 2. PELICULAS POR AÑO
-- =====================================

DELIMITER $$
CREATE PROCEDURE peliculas_por_anio(IN anio_busqueda INT)
BEGIN
SELECT titulo, anio
FROM Pelicula
WHERE anio = anio_busqueda;
END $$

-- =====================================
-- 3. PELICULAS CON DIRECTOR
-- =====================================

DELIMITER $$
CREATE PROCEDURE peliculas_con_director()
BEGIN
SELECT p.titulo, d.nombre, d.apellido
FROM Pelicula p
JOIN PeliculaDirector pd ON p.id_pelicula = pd.id_pelicula
JOIN Director d ON pd.id_director = d.id_director;
END $$

-- =====================================
-- 4. ACTORES DE UNA PELICULA
-- =====================================

DELIMITER $$
CREATE PROCEDURE actores_de_pelicula(IN idPelicula INT)
BEGIN
SELECT a.nombre, a.apellido, pa.personaje
FROM Actor a
JOIN PeliculaActor pa ON a.id_actor = pa.id_actor
WHERE pa.id_pelicula = idPelicula;
END $$

-- =====================================
-- 5. INSERTAR PELICULA
-- =====================================

DELIMITER $$
CREATE PROCEDURE insertar_pelicula(
IN titulo_p VARCHAR(200),
IN anio_p INT,
IN duracion INT,
IN sinopsis_p TEXT,
IN clasificacion INT,
IN pais INT
)
BEGIN
INSERT INTO Pelicula (titulo, anio, duracion_minutos, sinopsis, id_clasificacion, id_pais)
VALUES (titulo_p, anio_p, duracion, sinopsis_p, clasificacion, pais);
END $$

-- =====================================
-- 6. ACTUALIZAR DURACION DE PELICULA
-- =====================================

DELIMITER $$
CREATE PROCEDURE actualizar_duracion(
IN idPelicula INT,
IN nueva_duracion INT
)
BEGIN
UPDATE Pelicula
SET duracion_minutos = nueva_duracion
WHERE id_pelicula = idPelicula;
END $$

-- =====================================
-- 7. ELIMINAR PELICULA
-- =====================================

DELIMITER $$
CREATE PROCEDURE eliminar_pelicula(IN idPelicula INT)
BEGIN
DELETE FROM Pelicula
WHERE id_pelicula = idPelicula;
END $$

-- =====================================
-- 8. PELICULAS POR GENERO
-- =====================================

DELIMITER $$
CREATE PROCEDURE peliculas_por_genero(IN idGenero INT)
BEGIN
SELECT p.titulo, g.nombre AS genero
FROM Pelicula p
JOIN PeliculaGenero pg ON p.id_pelicula = pg.id_pelicula
JOIN Genero g ON pg.id_genero = g.id_genero
WHERE g.id_genero = idGenero;
END $$

-- =====================================
-- 9. PELICULAS PREMIADAS
-- =====================================

DELIMITER $$
CREATE PROCEDURE peliculas_premiadas()
BEGIN
SELECT p.titulo, pr.nombre, pp.resultado
FROM Pelicula p
JOIN PeliculaPremio pp ON p.id_pelicula = pp.id_pelicula
JOIN Premio pr ON pp.id_premio = pr.id_premio
WHERE pp.resultado = 'Ganado';
END $$

-- =====================================
-- 10. TOTAL DE PELICULAS POR PAIS
-- =====================================

DELIMITER $$
CREATE PROCEDURE total_peliculas_por_pais()
BEGIN
SELECT pa.nombre, COUNT(p.id_pelicula) AS total
FROM Pais pa
LEFT JOIN Pelicula p ON pa.id_pais = p.id_pais
GROUP BY pa.nombre;
END $$

CALL ver_peliculas();

CALL peliculas_por_anio(2010);

CALL actores_de_pelicula(3);

CALL insertar_pelicula('Nueva peli', 2024, 120, 'Descripción', 1, 1);
