-- Trabajo Práctico 03 - Modelo relacional simplificado de Mba'apo
-- Autor: Arnaldo Espínola Ramírez
-- Motor: MySQL 8 / InnoDB / UTF8MB4

CREATE DATABASE IF NOT EXISTS maapo_tp03
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE maapo_tp03;

CREATE TABLE region (
  id_region INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(30) NOT NULL UNIQUE,
  estado ENUM('activo','inactivo') NOT NULL DEFAULT 'activo'
);

CREATE TABLE departamento (
  id_departamento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_region INT UNSIGNED NOT NULL,
  nombre VARCHAR(60) NOT NULL UNIQUE,
  estado ENUM('activo','inactivo') NOT NULL DEFAULT 'activo',
  CONSTRAINT fk_departamento_region FOREIGN KEY (id_region) REFERENCES region(id_region)
);

CREATE TABLE ciudad (
  id_ciudad INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_departamento INT UNSIGNED NOT NULL,
  nombre VARCHAR(80) NOT NULL,
  estado ENUM('activo','inactivo') NOT NULL DEFAULT 'activo',
  CONSTRAINT uq_ciudad_departamento UNIQUE (id_departamento, nombre),
  CONSTRAINT fk_ciudad_departamento FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE usuario (
  id_usuario BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NULL,
  rol ENUM('cliente','profesional','administrador') NOT NULL DEFAULT 'cliente',
  proveedor_oauth VARCHAR(30) NULL,
  proveedor_id VARCHAR(150) NULL,
  estado ENUM('activo','bloqueado','pendiente') NOT NULL DEFAULT 'activo',
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE perfil_profesional (
  id_perfil BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_usuario BIGINT UNSIGNED NOT NULL UNIQUE,
  id_ciudad INT UNSIGNED NOT NULL,
  nombre_comercial VARCHAR(120) NOT NULL,
  descripcion VARCHAR(500) NOT NULL,
  whatsapp VARCHAR(25) NOT NULL,
  direccion VARCHAR(160) NULL,
  horario_atencion VARCHAR(150) NULL,
  verificado BOOLEAN NOT NULL DEFAULT FALSE,
  destacado BOOLEAN NOT NULL DEFAULT FALSE,
  slug VARCHAR(160) NOT NULL UNIQUE,
  CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_perfil_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

CREATE TABLE servicio (
  id_servicio INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  descripcion VARCHAR(250) NULL,
  estado ENUM('activo','inactivo') NOT NULL DEFAULT 'activo'
);

CREATE TABLE profesional_servicio (
  id_perfil BIGINT UNSIGNED NOT NULL,
  id_servicio INT UNSIGNED NOT NULL,
  experiencia_anios TINYINT UNSIGNED NULL,
  PRIMARY KEY (id_perfil, id_servicio),
  CONSTRAINT fk_ps_perfil FOREIGN KEY (id_perfil) REFERENCES perfil_profesional(id_perfil) ON DELETE CASCADE,
  CONSTRAINT fk_ps_servicio FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

CREATE TABLE publicacion (
  id_publicacion BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_perfil BIGINT UNSIGNED NOT NULL,
  id_servicio INT UNSIGNED NULL,
  tipo ENUM('producto','servicio') NOT NULL,
  titulo VARCHAR(160) NOT NULL,
  descripcion TEXT NOT NULL,
  precio_normal DECIMAL(12,2) NULL,
  precio_oferta DECIMAL(12,2) NULL,
  stock INT UNSIGNED NULL,
  destacado BOOLEAN NOT NULL DEFAULT FALSE,
  estado ENUM('borrador','publicado','pausado') NOT NULL DEFAULT 'borrador',
  slug VARCHAR(180) NOT NULL UNIQUE,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT ck_precio_oferta CHECK (precio_oferta IS NULL OR precio_normal IS NULL OR precio_oferta <= precio_normal),
  CONSTRAINT fk_publicacion_perfil FOREIGN KEY (id_perfil) REFERENCES perfil_profesional(id_perfil),
  CONSTRAINT fk_publicacion_servicio FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
);

CREATE TABLE imagen_publicacion (
  id_imagen BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_publicacion BIGINT UNSIGNED NOT NULL,
  archivo VARCHAR(255) NOT NULL,
  texto_alternativo VARCHAR(180) NOT NULL,
  orden TINYINT UNSIGNED NOT NULL DEFAULT 1,
  CONSTRAINT uq_imagen_orden UNIQUE (id_publicacion, orden),
  CONSTRAINT fk_imagen_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion) ON DELETE CASCADE
);

CREATE TABLE favorito (
  id_usuario BIGINT UNSIGNED NOT NULL,
  id_publicacion BIGINT UNSIGNED NOT NULL,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_publicacion),
  CONSTRAINT fk_favorito_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
  CONSTRAINT fk_favorito_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion) ON DELETE CASCADE
);

CREATE TABLE resena (
  id_resena BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_usuario BIGINT UNSIGNED NOT NULL,
  id_perfil BIGINT UNSIGNED NOT NULL,
  puntuacion TINYINT UNSIGNED NOT NULL,
  comentario VARCHAR(500) NULL,
  estado ENUM('visible','oculta','reportada') NOT NULL DEFAULT 'visible',
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_resena_usuario_perfil UNIQUE (id_usuario, id_perfil),
  CONSTRAINT ck_resena_puntuacion CHECK (puntuacion BETWEEN 1 AND 5),
  CONSTRAINT fk_resena_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_resena_perfil FOREIGN KEY (id_perfil) REFERENCES perfil_profesional(id_perfil)
);

CREATE TABLE conversacion (
  id_conversacion BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_cliente BIGINT UNSIGNED NOT NULL,
  id_perfil BIGINT UNSIGNED NOT NULL,
  id_publicacion BIGINT UNSIGNED NULL,
  estado ENUM('abierta','cerrada') NOT NULL DEFAULT 'abierta',
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultima_actividad DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_conversacion_cliente FOREIGN KEY (id_cliente) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_conversacion_perfil FOREIGN KEY (id_perfil) REFERENCES perfil_profesional(id_perfil),
  CONSTRAINT fk_conversacion_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion)
);

CREATE TABLE mensaje (
  id_mensaje BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_conversacion BIGINT UNSIGNED NOT NULL,
  id_emisor BIGINT UNSIGNED NOT NULL,
  tipo ENUM('texto','oferta','sistema') NOT NULL DEFAULT 'texto',
  contenido TEXT NOT NULL,
  monto_oferta DECIMAL(12,2) NULL,
  estado_oferta ENUM('pendiente','aceptada','rechazada') NULL,
  leido BOOLEAN NOT NULL DEFAULT FALSE,
  creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_mensaje_conversacion FOREIGN KEY (id_conversacion) REFERENCES conversacion(id_conversacion) ON DELETE CASCADE,
  CONSTRAINT fk_mensaje_emisor FOREIGN KEY (id_emisor) REFERENCES usuario(id_usuario)
);
