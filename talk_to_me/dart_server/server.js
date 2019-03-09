const http = require('http');
var message = "";
const server = http.createServer((request, response) => {
    request.on('data', chunk => {
        console.log("Client Message: " + chunk.toString());
        message += chunk.toString();
        response.end("Server Response: " + message + " received as message.");
    });
});
server.listen(3000);