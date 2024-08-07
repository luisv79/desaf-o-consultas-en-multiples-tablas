CREATE DATABASE desafio3_Luis_Valladares_079;

USE desafio3_Luis_Valladares_079;

-- creación de tabla 'usuarios'.

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL
);


-- Ingreso de datos a la tabla usuarios.

INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('admin@ejemplo.com', 'Admin', 'Usuario', 'administrador'),
('maria@ejemplo.com', 'Maria', 'Jimenez', 'usuario'),
('pedro@ejemplo.com', 'Pedro', 'Perez', 'usuario'),
('jose@ejemplo.com', 'Jose', 'Carrizo', 'usuario'),
('claudia@ejemplo.com', 'Claudia', 'Hernandez', 'usuario');

 -- Creación de la tabla posts.

 CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL,
    destacado BOOLEAN NOT NULL,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);


-- Ingreso de datos a la tabla posts.

INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Post 1', 'Contenido escrito para el post 1', '2024-01-01 10:00:00', '2024-01-01 10:00:00', TRUE, 1),
('Post 2', 'Contenido escrito para el post 2', '2024-01-02 10:00:00', '2024-01-02 10:00:00', TRUE, 1),
('Post 3', 'Contenido escrito para el post 3', '2024-01-03 10:00:00', '2024-01-03 10:00:00', FALSE, 2),
('Post 4', 'Contenido escrito para el post 4', '2024-01-04 10:00:00', '2024-01-04 10:00:00', FALSE, 3),
('Post 5', 'Contenido escrito para el post 5', '2024-01-05 10:00:00', '2024-01-05 10:00:00', FALSE, NULL);


-- Creación de la tabla comentarios.

CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    usuario_id BIGINT,
    post_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);


-- Ingreso de datos a la tabla coentarios.

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Escrito del comentario 1', '2024-01-01 12:00:00', 1, 1),
('Escrito del comentario 2', '2024-01-02 12:00:00', 2, 1),
('Escrito del comentario 3', '2024-01-03 12:00:00', 3, 1),
('Escrito del comentario 4', '2024-01-04 12:00:00', 1, 2),
('Escrito del comentario 5', '2024-01-05 12:00:00', 2, 2);



-- Cruzar los datos de las tablas usuarios y posts.

SELECT usuarios.nombre, usuarios.email, posts.titulo, posts.contenido
FROM usuarios
JOIN posts ON usuarios.id = posts.usuario_id;


-- Muestra los posts de los administradores.

SELECT posts.id, posts.titulo, posts.contenido
FROM posts
JOIN usuarios ON posts.usuario_id = usuarios.id
WHERE usuarios.rol = 'administrador';

-- Cuenta la cantidad de posts de cada usuario.

SELECT usuarios.id, usuarios.email, COUNT(posts.id) AS cantidad_posts
FROM usuarios
LEFT JOIN posts ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.email;


-- Muestra el email del usuario que ha creado más posts.

SELECT usuarios.email
FROM usuarios
JOIN posts ON usuarios.id = posts.usuario_id
GROUP BY usuarios.email
ORDER BY COUNT(posts.id) DESC
LIMIT 1;

 -- Muestra la fecha del último post de cada usuario.

 SELECT usuarios.id, usuarios.email, MAX(posts.fecha_creacion) AS ultima_fecha
FROM usuarios
JOIN posts ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.email;


-- Muestra el título y contenido del post con más comentarios.

SELECT posts.titulo, posts.contenido
FROM posts
JOIN comentarios ON posts.id = comentarios.post_id
GROUP BY posts.id
ORDER BY COUNT(comentarios.id) DESC
LIMIT 1;

-- Muestra el título de cada post, el contenido de cada post y el contenido de cada comentario asociado.

SELECT posts.titulo, posts.contenido AS post_contenido, comentarios.contenido AS comentario_contenido, usuarios.email
FROM posts
JOIN comentarios ON posts.id = comentarios.post_id
JOIN usuarios ON comentarios.usuario_id = usuarios.id;


-- Muestra el contenido del último comentario de cada usuario.

SELECT usuarios.email, comentarios.contenido
FROM usuarios
JOIN comentarios ON usuarios.id = comentarios.usuario_id
WHERE comentarios.fecha_creacion = (
    SELECT MAX(c.fecha_creacion)
    FROM comentarios c
    WHERE c.usuario_id = usuarios.id
);


-- Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT usuarios.email
FROM usuarios
LEFT JOIN comentarios ON usuarios.id = comentarios.usuario_id
GROUP BY usuarios.id
HAVING COUNT(comentarios.id) = 0;



