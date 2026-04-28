# =====================================================
# Dockerfile - "la receta para empacar nuestra app"
# =====================================================
# Un Dockerfile es un archivo de texto que describe COMO
# construir una imagen de contenedor. Pensemoslo como una
# receta de cocina: cada linea es un paso.
# =====================================================

# Imagen base oficial de Node.js (ligera, version 20)
# "alpine" significa que usa Alpine Linux: super ligera (~50MB)
FROM node:20-alpine

# Definimos un directorio de trabajo dentro del contenedor
# (como hacer "cd /app" antes de cualquier cosa)
WORKDIR /app

# Copiamos PRIMERO el package.json
# Truco DevOps: si solo cambia el codigo pero no las dependencias,
# Docker reutiliza la capa de "npm install" -> builds mas rapidos
COPY package.json ./

# Instalamos solo dependencias de produccion
# (esta app no tiene dependencias, pero esta es la buena practica)
RUN npm install --omit=dev

# Ahora si copiamos el codigo de la aplicacion
COPY src/ ./src/

# Documentamos que el contenedor escucha en el puerto 3000
EXPOSE 3000

# Por seguridad, NO corremos como root.
# Esto es DevSecOps en accion.
USER node

# Comando que se ejecuta cuando arranca el contenedor
CMD ["node", "src/index.js"]
