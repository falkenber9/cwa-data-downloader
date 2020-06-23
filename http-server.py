#!/usr/bin/python3

import http.server
import socketserver
import os

PORT = 31501

WEB_ROOT = "summary"

os.chdir(WEB_ROOT)
Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
