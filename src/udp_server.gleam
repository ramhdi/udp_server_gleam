import gleam/int
import gleam/io
import udp

fn ip_to_string(ip: udp.IpAddress) -> String {
  let #(a, b, c, d) = ip
  int.to_string(a)
  <> "."
  <> int.to_string(b)
  <> "."
  <> int.to_string(c)
  <> "."
  <> int.to_string(d)
}

fn loop(socket: udp.Socket) {
  case udp.receive_message(socket) {
    Ok(#(ip, port, message)) -> {
      io.println("Received: ")
      io.println(message)

      let response =
        "Hello " <> ip_to_string(ip) <> ":" <> int.to_string(port) <> "!"

      case udp.send_message(socket, ip, port, response <> "\n") {
        Ok(_) -> io.println("Response sent")
        Error(_) -> io.println_error("Error sending response")
      }

      loop(socket)
    }

    Error(_) -> {
      io.println_error("Timeout")
      loop(socket)
    }
  }
}

pub fn main() {
  let socket = udp.open_socket(4000)
  case socket {
    Ok(socket) -> {
      io.println("Listening on port 4000")
      loop(socket)
    }

    Error(e) -> io.println_error(e)
  }
}
