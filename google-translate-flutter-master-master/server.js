const http = require('http');
var message = "";
const server = http.createServer((request, response) => {
    request.on('data', chunk => {
        console.log("Client Message: " + chunk.toString());
        message += chunk.toString() + "\n";
        response.end(message);
    });
});
server.listen(3000);