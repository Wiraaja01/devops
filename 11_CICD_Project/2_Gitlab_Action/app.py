from http.server import HTTPServer, BaseHTTPRequestHandler

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b"Hello World")

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 5000), RequestHandler)
    server.serve_forever()
