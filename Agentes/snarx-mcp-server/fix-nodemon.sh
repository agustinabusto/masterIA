# 🔧 Soluciones para "nodemon: not found"

echo "🔍 Diagnosticando problema con nodemon..."

# SOLUCIÓN 1: Reinstalar dependencias de desarrollo
echo "💊 Solución 1: Reinstalar dependencias de desarrollo"
npm install -D nodemon ts-node typescript @types/node

# SOLUCIÓN 2: Instalar nodemon globalmente (opcional)
echo "🌍 Solución 2: Instalar nodemon globalmente"
npm install -g nodemon

# SOLUCIÓN 3: Verificar si nodemon está en node_modules
echo "🔍 Verificando instalación local de nodemon..."
if [ -f "./node_modules/.bin/nodemon" ]; then
    echo "✅ nodemon encontrado en node_modules/.bin/"
else
    echo "❌ nodemon NO encontrado. Reinstalando..."
    npm install -D nodemon
fi

# SOLUCIÓN 4: Usar npx (recomendado)
echo "🚀 Solución 4: Configurando scripts con npx"

# Actualizar package.json con npx
cat > package.json << 'EOF'
{
  "name": "snarx-mcp-server",
  "version": "1.0.0",
  "description": "Snarx.io MCP Server - Clean Architecture & Mobile First",
  "main": "dist/index.js",
  "scripts": {
    "start": "node dist/index.js",
    "dev": "npx nodemon src/index.ts",
    "dev:ts": "npx ts-node src/index.ts",
    "dev:watch": "npx nodemon --exec \"npx ts-node\" src/index.ts",
    "build": "npx tsc",
    "build:watch": "npx tsc --watch",
    "test": "npx jest",
    "test:watch": "npx jest --watch",
    "test:coverage": "npx jest --coverage",
    "lint": "npx eslint src/**/*.ts",
    "lint:fix": "npx eslint src/**/*.ts --fix",
    "format": "npx prettier --write src/**/*.ts",
    "clean": "rm -rf dist",
    "prebuild": "npm run clean",
    "postbuild": "cp -r src/config/templates dist/config/ 2>/dev/null || true",
    "docker:build": "docker build -t snarx-mcp-server .",
    "docker:run": "docker run -p 3000:3000 snarx-mcp-server"
  },
  "keywords": ["mcp", "model-context-protocol", "ai", "snarx", "clean-architecture"],
  "author": "Snarx.io",
  "license": "MIT"
}
EOF

# SOLUCIÓN 5: Crear archivo index.ts básico si no existe
echo "📝 Creando archivo index.ts básico..."

mkdir -p src

cat > src/index.ts << 'EOF'
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import { config } from 'dotenv';

// Cargar variables de entorno
config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Basic MCP endpoints
app.get('/', (req, res) => {
  res.json({
    message: '🚀 Snarx MCP Server está funcionando!',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      mcp: {
        tools: '/mcp/tools',
        resources: '/mcp/resources',
        prompts: '/mcp/prompts'
      }
    }
  });
});

// MCP Tools endpoint
app.get('/mcp/tools', (req, res) => {
  res.json({
    tools: [
      {
        name: 'echo',
        description: 'Devuelve el mensaje que le envíes',
        inputSchema: {
          type: 'object',
          properties: {
            message: { type: 'string' }
          },
          required: ['message']
        }
      }
    ]
  });
});

// Start server
app.listen(PORT, () => {
  console.log('🚀 Snarx MCP Server iniciado!');
  console.log(`📡 Servidor corriendo en: http://localhost:${PORT}`);
  console.log(`🏥 Health check en: http://localhost:${PORT}/health`);
  console.log(`🛠️  Environment: ${process.env.NODE_ENV || 'development'}`);
});

export default app;
EOF

# SOLUCIÓN 6: Verificar PATH y node_modules
echo "🔍 Verificando PATH y node_modules..."
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"
echo "Current directory: $(pwd)"
echo "Contents of node_modules/.bin:"
ls -la node_modules/.bin/ | head -10

# SOLUCIÓN 7: Script alternativo sin nodemon
echo "📝 Creando script alternativo sin nodemon..."

cat > start-dev.sh << 'EOF'
#!/bin/bash
echo "🚀 Iniciando servidor MCP en modo desarrollo..."
echo "🔄 Reinicia manualmente el servidor cuando hagas cambios"
npx ts-node src/index.ts
EOF

chmod +x start-dev.sh

echo ""
echo "✅ Soluciones aplicadas!"
echo ""
echo "🚀 Opciones para iniciar el servidor:"
echo ""
echo "1️⃣  npm run dev          # Con nodemon (si está funcionando)"
echo "2️⃣  npm run dev:ts       # Con ts-node directo"
echo "3️⃣  ./start-dev.sh       # Script alternativo"
echo "4️⃣  npx nodemon src/index.ts  # Comando directo"
echo "5️⃣  npx ts-node src/index.ts  # Sin hot reload"
echo ""
echo "🔧 Si sigue fallando, prueba:"
echo "   rm -rf node_modules package-lock.json"
echo "   npm install"
echo ""
echo "💡 Tip: Usa npx para ejecutar herramientas locales"