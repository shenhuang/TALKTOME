import 'dart:io';
import 'dart:convert' show UTF8;

Future main() async {
  var server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    3000,
  );
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    print('Received request ${request.method}: ${request.uri.toString()}');
    request.response
      ..write('Hello World')
      ..close();
  }
}