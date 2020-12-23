defmodule UdpClientServer do
  @moduledoc """
  Documentation for UdpClientServer.
  """

  @default_server_port 1337
  @local_host {127, 0, 0, 1}

  def launch_server do
    launch_server(@default_server_port)
  end

  def launch_server(port) do
    IO.puts("Launching server on localhost on port #{port}")
    server = Socket.UDP.open!(port)
    serve(server)
  end

  def serve(server) do
    {data, client} = server |> Socket.Datagram.recv!()
    IO.puts("Received: #{data}, from #{inspect(client)}")

    send_data(server, data, client)
    IO.puts("Sent: #{data}, to #{inspect(client)}")

    serve(server)
  end

  @doc """
  Sends data to server and recv msg from server
  """
  def echo(data, to) do
    Task.async(fn ->
      server = Socket.UDP.open!()
      send_data(server, data, to)
      {data, client} = server |> Socket.Datagram.recv!()
      IO.puts("Received: #{data}, from Server #{inspect(client)}")
    end)
  end

  @doc """
  Sends `data` to the `to` value, where `to` is a tuple of
  { host, port } like {{127, 0, 0, 1}, 1337}
  """
  def send_data(server, data, to) do
    Socket.Datagram.send!(server, data, to)
  end
end
