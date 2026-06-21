# Trabajo Práctico 03 — Mba'apo

**Alumno:** Arnaldo Espínola Ramírez  
**Asignatura:** Programación Web Avanzada  
**Tema:** Prototipo funcional y modelado de datos de un sistema informático  
**Año:** 2026

## Descripción

Prototipo académico basado en Mba'apo, una plataforma que conecta a personas que necesitan productos o servicios con profesionales y prestadores de Paraguay. Este paquete se creó separado del sistema original para no modificar su código ni su base de datos.

## Contenido

- `index.html`: landing page principal.
- `css/styles.css`: identidad visual, animaciones y diseño responsive.
- `js/app.js`: galería dinámica, filtros, búsqueda, favoritos simulados y validación del formulario.
- `database/modelo_maapo.sql`: modelo relacional normalizado a 3FN.
- `docs/modelo-der-maapo.png`: DER completo exportado desde MySQL Workbench.
- `docs/Trabajo_Practico_03_Arnaldo_Espinola_Ramirez.pdf`: documento académico final.
- `docs/Trabajo_Practico_03_Arnaldo_Espinola_Ramirez.docx`: versión editable con el formato de la facultad.
- `assets/img`: recursos gráficos utilizados por el prototipo.

## Ejecución

1. Descargar o clonar el repositorio.
2. Abrir `index.html` en el navegador.
3. También puede copiarse la carpeta dentro de `htdocs` y ejecutarse mediante Apache.
4. No se requiere instalar dependencias ni configurar una base de datos para visualizar la landing.

## Funcionalidades demostradas

- Navegación adaptable con menú para celulares.
- Búsqueda de publicaciones.
- Filtros por servicios, productos y destacados.
- Galería construida desde un arreglo JavaScript mediante el DOM.
- Favoritos simulados.
- Animaciones al hacer scroll y contadores.
- Formulario validado con JavaScript.
- Accesibilidad básica y respeto a `prefers-reduced-motion`.

## Nota sobre la base de datos

El archivo SQL representa la arquitectura propuesta para la siguiente etapa. La landing usa arreglos JavaScript para simular los datos, tal como solicita el Trabajo Práctico 03.
