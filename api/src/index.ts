// File: api/src/index.ts

export interface Env {
	// This makes our D1 database available to the Worker
	DB: D1Database;
}

export default {
	async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
		const { pathname } = new URL(request.url);

		// Route: Get all breakers
		if (pathname === '/api/breakers' && request.method === 'GET') {
			try {
				const { results } = await env.DB.prepare('SELECT * FROM breakers ORDER BY number ASC').all();
				return Response.json(results);
			} catch (e) {
				return new Response(JSON.stringify({ error: e.message }), { status: 500 });
			}
		}

		// Route: Add a new breaker
		if (pathname === '/api/breakers' && request.method === 'POST') {
			try {
                // Read the request body as JSON
				const newBreaker = await request.json<{ number: number; amperage: number; description: string; room: string }>();

                // Basic validation
                if (!newBreaker.number || !newBreaker.description) {
                    return new Response(JSON.stringify({ error: "Breaker number and description are required." }), { status: 400 });
                }

				const { success } = await env.DB.prepare('INSERT INTO breakers (number, amperage, description, room) VALUES (?, ?, ?, ?)')
					.bind(newBreaker.number, newBreaker.amperage, newBreaker.description, newBreaker.room)
					.run();

				if (success) {
					return new Response(JSON.stringify({ message: 'Breaker added successfully' }), { status: 201 });
				} else {
					return new Response(JSON.stringify({ error: 'Failed to insert data' }), { status: 500 });
				}

			} catch (e) {
				return new Response(JSON.stringify({ error: e.message }), { status: 500 });
			}
		}

		// Fallback for all other requests
		return new Response('Not Found', { status: 404 });
	},
};