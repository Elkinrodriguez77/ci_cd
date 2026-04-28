// =====================================================
// Aplicación demo para clase DevOps - Utadeo 2026
// =====================================================
// Esta es una API mínima en Node.js (sin frameworks pesados).
// La idea es que el código sea TAN simple que el foco de la
// clase NO sea el código, sino el PIPELINE que lo lleva a
// producción.
// =====================================================

const http = require('http');

const PORT = process.env.PORT || 3000;
// La VERSION viene del pipeline (la inyectamos desde GitHub Actions).
// Esto demuestra el concepto de "artefacto inmutable trazable".
const VERSION = process.env.APP_VERSION || 'dev';
const ENV = process.env.APP_ENV || 'local';

// Saludo configurable por variable de entorno (12-Factor App)
const SALUDO = process.env.SALUDO || 'Hola Utadeo - clase DevOps 2026';

const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');

  // Endpoint principal
  if (req.url === '/') {
    res.statusCode = 200;
    res.end(JSON.stringify({
      mensaje: SALUDO,
      version: VERSION,
      entorno: ENV,
      hora: new Date().toISOString()
    }));
    return;
  }

  // Health check - lo usa Kubernetes / load balancers para
  // saber si la app está viva. CONCEPTO CLAVE de DevOps.
  if (req.url === '/health') {
    res.statusCode = 200;
    res.end(JSON.stringify({ status: 'ok', version: VERSION }));
    return;
  }

  // Nuevo endpoint agregado via feature branch - demo Git Flow
  if (req.url === '/aboutme') {
    res.statusCode = 200;
    res.end(JSON.stringify({
      app: 'DevOps Demo - Utadeo',
      estudiantes: 'Arquitectura de Software 2026',
      pipeline: 'GitHub Actions → Render',
      nuevo_en_v2: true
    }));
    return;
  }

  // Endpoint que falla a propósito - lo usaremos en clase
  // para demostrar observabilidad / alertas.
  if (req.url === '/error') {
    res.statusCode = 500;
    res.end(JSON.stringify({ error: 'Esto es un error de prueba' }));
    return;
  }

  res.statusCode = 404;
  res.end(JSON.stringify({ error: 'No encontrado' }));
});

// Solo arrancamos el servidor si este archivo se ejecuta directamente.
// Esto permite que los tests importen la app sin levantar el servidor.
if (require.main === module) {
  server.listen(PORT, () => {
    console.log(`Servidor corriendo en puerto ${PORT} - version ${VERSION} - entorno ${ENV}`);
  });
}

module.exports = server;
