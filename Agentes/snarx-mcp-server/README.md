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
