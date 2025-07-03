#!/bin/bash

# 🚀 Snarx MCP Server Setup Script
# Arquitectura clean code y mobile-first
# Autor: Snarx.io

set -e  # Exit on any error

echo "🚀 Iniciando setup del MCP Server..."
echo "📁 Arquitectura: Clean Code + Mobile First"
echo ""

# Verificar prerequisitos
echo "🔍 Verificando prerequisitos..."

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no encontrado. Por favor instala Node.js 18+ primero."
    echo "   Visita: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt "18" ]; then
    echo "❌ Node.js versión 18+ requerida. Tienes: $(node --version)"
    exit 1
fi

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm no encontrado. Por favor instala npm."
    exit 1
fi

echo "✅ Node.js $(node --version) detectado"
echo "✅ npm $(npm --version) detectado"
echo ""

# 1. Crear directorio del proyecto
echo "📁 Creando estructura del proyecto..."
mkdir -p snarx-mcp-server
cd snarx-mcp-server

# 2. Inicializar proyecto Node.js
echo "📦 Inicializando proyecto Node.js..."
npm init -y > /dev/null 2>&1

# 3. Instalar dependencias principales
echo "⬇️  Instalando dependencias principales..."
npm install express cors helmet compression morgan dotenv > /dev/null 2>&1
npm install @modelcontextprotocol/sdk > /dev/null 2>&1
npm install jsonschema uuid > /dev/null 2>&1

# 4. Instalar dependencias de desarrollo
echo "🛠️  Instalando dependencias de desarrollo..."
npm install -D typescript @types/node @types/express @types/cors > /dev/null 2>&1
npm install -D nodemon ts-node eslint prettier > /dev/null 2>&1
npm install -D @typescript-eslint/eslint-plugin @typescript-eslint/parser > /dev/null 2>&1
npm install -D jest @types/jest supertest @types/supertest > /dev/null 2>&1

# 5. Instalar dependencias adicionales para MCP
echo "🔗 Instalando dependencias MCP específicas..."
npm install ws express-rate-limit express-validator > /dev/null 2>&1
npm install sqlite3 redis ioredis > /dev/null 2>&1

# 6. Crear estructura de directorios clean
echo "🏗️  Creando arquitectura clean..."
mkdir -p src/{core,tools,resources,prompts,middleware,utils,types,tests}
mkdir -p src/{controllers,services,repositories,config}
mkdir -p src/tools/{database,filesystem,api}
mkdir -p src/resources/{providers,cache}
mkdir -p logs docs scripts

# 7. Crear archivos de configuración
echo "⚙️  Configurando TypeScript..."

# TypeScript config
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noImplicitThis": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"],
      "@/core/*": ["src/core/*"],
      "@/tools/*": ["src/tools/*"],
      "@/resources/*": ["src/resources/*"],
      "@/types/*": ["src/types/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
EOF

echo "🎨 Configurando ESLint y Prettier..."

# ESLint config
cat > .eslintrc.js << 'EOF'
module.exports = {
  parser: '@typescript-eslint/parser',
  extends: [
    '@typescript-eslint/recommended',
    'prettier'
  ],
  plugins: ['@typescript-eslint'],
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
  },
  rules: {
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/explicit-function-return-type': 'warn',
    '@typescript-eslint/no-explicit-any': 'warn',
    'prefer-const': 'error',
    'no-var': 'error',
  },
};
EOF

# Prettier config
cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
EOF

echo "🔐 Configurando variables de entorno..."

# Environment variables
cat > .env.example << 'EOF'
# Server Configuration
NODE_ENV=development
PORT=3000
HOST=localhost

# MCP Configuration
MCP_SERVER_NAME=snarx-mcp-server
MCP_SERVER_VERSION=1.0.0
MCP_MAX_CONNECTIONS=100

# Database
DATABASE_URL=sqlite://./data/mcp.db
REDIS_URL=redis://localhost:6379

# Security
JWT_SECRET=your-super-secret-jwt-key-here
API_KEY_SECRET=your-api-key-secret-here
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Logging
LOG_LEVEL=info
LOG_FILE=./logs/app.log

# Development
DEBUG=mcp:*
EOF

# Copy example to actual .env
cp .env.example .env

echo "🧪 Configurando testing con Jest..."

# Jest config
cat > jest.config.js << 'EOF'
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/tests/**',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};
EOF

echo "📜 Actualizando package.json con scripts..."

# Package.json scripts update
cat > package.json << 'EOF'
{
  "name": "snarx-mcp-server",
  "version": "1.0.0",
  "description": "Snarx.io MCP Server - Clean Architecture & Mobile First",
  "main": "dist/index.js",
  "scripts": {
    "start": "node dist/index.js",
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "build:watch": "tsc --watch",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src/**/*.ts",
    "lint:fix": "eslint src/**/*.ts --fix",
    "format": "prettier --write src/**/*.ts",
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

# Nodemon config
cat > nodemon.json << 'EOF'
{
  "watch": ["src"],
  "ext": "ts,json",
  "ignore": ["src/**/*.test.ts"],
  "exec": "ts-node src/index.ts",
  "env": {
    "NODE_ENV": "development"
  }
}
EOF

echo "🚫 Configurando .gitignore..."

# Gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.production
.env.test

# Logs
logs/
*.log

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# Database
data/
*.db
*.sqlite

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDEs
.vscode/
.idea/
*.swp
*.swo

# Temporary folders
tmp/
temp/

# Redis dump
dump.rdb
EOF

echo "🐳 Configurando Docker..."

# Docker configuration
cat > Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build application
RUN npm run build

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S mcp -u 1001

# Change ownership
RUN chown -R mcp:nodejs /app
USER mcp

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# Start application
CMD ["npm", "start"]
EOF

# Docker Compose
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  mcp-server:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=sqlite://./data/mcp.db
      - REDIS_URL=redis://redis:6379
    volumes:
      - ./data:/app/data
      - ./logs:/app/logs
    depends_on:
      - redis
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    restart: unless-stopped

volumes:
  redis_data:
EOF

echo "📚 Creando documentación..."

# README.md
cat > README.md << 'EOF'
# 🚀 Snarx MCP Server

Model Context Protocol server implementado con arquitectura clean y principios mobile-first.

## 🏗️ Arquitectura

```
src/
├── core/           # Lógica central del servidor MCP
├── tools/          # Implementación de herramientas MCP
├── resources/      # Gestión de recursos dinámicos
├── prompts/        # Sistema de prompts contextuales
├── controllers/    # Controladores HTTP
├── services/       # Lógica de negocio
├── repositories/   # Acceso a datos
├── middleware/     # Middleware personalizado
├── types/          # Definiciones TypeScript
└── config/         # Configuración
```

## 🚀 Quick Start

```bash
# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env

# Modo desarrollo
npm run dev

# Build y producción
npm run build
npm start
```

## 📱 Mobile First

Este servidor está diseñado con principios mobile-first:
- Respuestas optimizadas para conectividad limitada
- Compresión automática
- Rate limiting inteligente
- Timeouts optimizados

## 🧹 Clean Code

- Arquitectura hexagonal
- Separación de responsabilidades
- Testing automatizado
- Linting y formatting
- Documentación automática

## 🛠️ Scripts Disponibles

- `npm run dev` - Modo desarrollo con hot reload
- `npm run build` - Build para producción
- `npm run test` - Ejecutar tests
- `npm run lint` - Linting del código
- `npm run format` - Formatear código

## 🐳 Docker

```bash
# Build imagen
npm run docker:build

# Ejecutar contenedor
npm run docker:run

# Con Docker Compose
docker-compose up -d
```
EOF

# Crear directorio de datos
echo "📂 Creando directorios de datos..."
mkdir -p data logs

# Mensaje final
echo ""
echo "✅ ¡Proyecto MCP Server creado exitosamente!"
echo ""
echo "📁 Estructura del proyecto:"
echo "   📦 snarx-mcp-server/"
echo "   ├── 📂 src/           # Código fuente TypeScript"
echo "   ├── 📂 data/          # Base de datos SQLite"
echo "   ├── 📂 logs/          # Archivos de log"
echo "   ├── 🐳 Dockerfile     # Containerización"
echo "   ├── ⚙️  tsconfig.json  # TypeScript config"
echo "   └── 📋 package.json   # Dependencias y scripts"
echo ""
echo "🚀 Próximos pasos:"
echo "   cd snarx-mcp-server"
echo "   npm run dev"
echo ""
echo "📡 El servidor estará disponible en: http://localhost:3000"
echo ""
echo "💡 Tip: Ejecuta 'npm run dev' para iniciar el servidor en modo desarrollo"
echo "📚 Lee el README.md para más información sobre la arquitectura"
echo ""
echo "🎉 ¡Happy coding con MCP!"