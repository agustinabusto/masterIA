import express, { Request, Response } from 'express';
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
app.get('/health', (_req: Request, res: Response) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0'
  });
});

// Root endpoint
app.get('/', (_req: Request, res: Response) => {
  res.json({
    message: '🚀 Snarx MCP Server está funcionando!',
    version: '1.0.0',
    architecture: 'Clean Code + Mobile First',
    endpoints: {
      health: '/health',
      mcp: {
        tools: '/mcp/tools',
        resources: '/mcp/resources',
        prompts: '/mcp/prompts'
      }
    },
    author: 'Snarx.io'
  });
});

// MCP Tools endpoint
app.get('/mcp/tools', (_req: Request, res: Response) => {
  res.json({
    tools: [
      {
        name: 'echo',
        description: 'Devuelve el mensaje que le envíes',
        inputSchema: {
          type: 'object',
          properties: {
            message: { 
              type: 'string',
              description: 'Mensaje a devolver'
            }
          },
          required: ['message']
        }
      },
      {
        name: 'get_system_info',
        description: 'Obtiene información del sistema',
        inputSchema: {
          type: 'object',
          properties: {}
        }
      }
    ]
  });
});

// MCP Resources endpoint
app.get('/mcp/resources', (_req: Request, res: Response) => {
  res.json({
    resources: [
      {
        uri: 'system://info',
        name: 'System Information',
        description: 'Información del sistema donde corre el servidor',
        mimeType: 'application/json'
      }
    ]
  });
});

// MCP Prompts endpoint
app.get('/mcp/prompts', (_req: Request, res: Response) => {
  res.json({
    prompts: [
      {
        name: 'analyze_code',
        description: 'Template para análisis de código',
        arguments: [
          {
            name: 'language',
            description: 'Lenguaje de programación',
            required: true
          },
          {
            name: 'code',
            description: 'Código a analizar',
            required: true
          }
        ]
      }
    ]
  });
});

// Error handling middleware
app.use((err: Error, _req: Request, res: Response, _next: any) => {
  console.error('Error:', err.message);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message,
    timestamp: new Date().toISOString()
  });
});

// 404 handler
app.use((_req: Request, res: Response) => {
  res.status(404).json({
    error: 'Not Found',
    message: 'Endpoint no encontrado',
    availableEndpoints: ['/', '/health', '/mcp/tools', '/mcp/resources', '/mcp/prompts']
  });
});

// Start server
app.listen(PORT, () => {
  console.log('\n🚀 Snarx MCP Server iniciado exitosamente!');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`📡 Servidor: http://localhost:${PORT}`);
  console.log(`🏥 Health:   http://localhost:${PORT}/health`);
  console.log(`🛠️  Tools:    http://localhost:${PORT}/mcp/tools`);
  console.log(`📚 Resources: http://localhost:${PORT}/mcp/resources`);
  console.log(`💬 Prompts:   http://localhost:${PORT}/mcp/prompts`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`🛠️  Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🏗️  Architecture: Clean Code + Mobile First`);
  console.log(`👨‍💻 Author: Snarx.io`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
});

export default app;
