-module(udp_ffi).
-export([open_socket/1, send_message/4, receive_message/1]).

-spec open_socket(integer()) -> {ok, port()} | {error, term()}.
open_socket(Port) ->
    case gen_udp:open(Port, [binary, {active, true}]) of
        {ok, Socket} -> {ok, Socket};
        {error, Reason} -> {error, Reason}
    end.

-spec send_message(port(), inet:ip_address(), integer(), binary()) ->
    {ok, nil} | {error, term()}.
send_message(Socket, IP, Port, Message) ->
    case gen_udp:send(Socket, IP, Port, Message) of
        ok -> {ok, nil};
        {error, Reason} -> {error, Reason}
    end.

-spec receive_message(port()) -> {ok, {inet:ip_address(), integer(), binary()}} | {error, timeout}.
receive_message(Socket) ->
    receive
        {udp, Socket, IP, Port, Message} ->
            {ok, {IP, Port, Message}}
    after 5000 ->
        {error, timeout}
    end.
