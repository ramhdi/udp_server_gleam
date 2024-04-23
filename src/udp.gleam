pub type Socket

pub type IpAddress =
  #(Int, Int, Int, Int)

@external(erlang, "udp_ffi", "open_socket")
pub fn open_socket(port: Int) -> Result(Socket, String)

@external(erlang, "udp_ffi", "send_message")
pub fn send_message(
  socket: Socket,
  ip: IpAddress,
  port: Int,
  msg: String,
) -> Result(Nil, String)

@external(erlang, "udp_ffi", "receive_message")
pub fn receive_message(socket: Socket) -> Result(#(IpAddress, Int, String), Nil)
