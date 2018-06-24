#include <client_ws.hpp>
#include <server_ws.hpp>

using namespace std;
using WsServer = SimpleWeb::SocketServer<SimpleWeb::WS>;

int main() {
  WsServer server;
  server.config.port = 8080;

  auto &echo = server.endpoint["^/?$"];

  echo.on_message = [](shared_ptr<WsServer::Connection> connection, shared_ptr<WsServer::Message> message) {
    auto message_str = message->string();

    cout << "Server: Message received: \"" << message_str << "\" from " << connection.get() << endl;
    cout << "Server: Sending message \"" << message_str << "\" to " << connection.get() << endl;

    auto send_stream = make_shared<WsServer::SendStream>();
    *send_stream << message_str;

    cout << connection->remote_endpoint_address() << endl;

    connection->send(send_stream, [](const SimpleWeb::error_code &ec) {
      if(ec) {
        cout << "Server: Error sending message. " << "Error: " << ec << ", error message: " << ec.message() << endl;
      }
    });
  };

  echo.on_open = [](shared_ptr<WsServer::Connection> connection) {};
  echo.on_close = [](shared_ptr<WsServer::Connection> connection, int status, const string & /*reason*/) {};
  echo.on_error = [](shared_ptr<WsServer::Connection> connection, const SimpleWeb::error_code &ec) {};

  thread server_thread([&server]() {
    server.start();
  });

  server_thread.join();
}
