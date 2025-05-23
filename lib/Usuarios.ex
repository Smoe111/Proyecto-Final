defmodule ChatEmpresarial.Usuarios do
  use GenServer

  def crear_usuario(nombre) do
    case GenServer.start_link(__MODULE__, nombre, name: String.to_atom(nombre)) do
      {:ok, _pid} ->
        IO.puts("Usuario #{nombre} creado")
        start(nombre)
      {:error, reason} ->
        IO.puts("Error al crear el usuario: #{reason}")
    end
  end

  def init(nombre) do
    {:ok, %{nombre: nombre}}
  end

  def start(nombre) do
    case GenServer.call({:global, Proyecto.Servidor}, {:connect, nombre, self()}) do
      :ok ->
        IO.puts("Bienvenido a la sala de chat, #{nombre}!")
        comandos(nombre)
      {:error, reason} ->
        IO.puts("Error al entrar a la sala: #{reason}")
    end
  end

  def comandos(nombre) do
    IO.puts("""
    Escribe un comando para interactuar.
    /join nombre_sala               - Unirse a una sala de chat
    /create nombre_sala             - Crear una nueva sala de chat
    /leave                          - Abandonar la sala actual
    /history nombre_sala            - Consultar historial de mensajes de una sala
    /search nombre_sala palabra     - Buscar mensajes por palabra en una sala
    /list                           - Mostrar usuarios conectados
    /exit                           - Salir del chat
    """)
    # Proceso para leer comandos del usuario
    spawn(fn -> command_loop(nombre) end)
    # Proceso principal escucha mensajes en tiempo real
    listen(nombre)
  end

  defp listen(nombre) do
    receive do
      {:mensaje, mensaje} ->
        IO.puts(mensaje)
        listen(nombre)
    end
  end

  defp command_loop(nombre) do
    comando = IO.gets("> ") |> String.trim()
    case process_command(nombre, comando) do
      :exit -> :ok
      _ -> command_loop(nombre)
    end
  end

  defp process_command(nombre, comando) do
    case String.split(comando, " ") do
      ["/join", sala] ->
        join_sala(nombre, sala)
      ["/create", sala] ->
        create_sala(sala)
      ["/leave"] ->
        leave_sala(nombre)
      ["/history", sala] ->
        history(sala)
      ["/search", sala, palabra] ->
        search(sala, palabra)
      ["/list"] ->
        list_users()
      ["/exit"] ->
        exit_chat(nombre)
      _ ->
        IO.puts("Comando no reconocido")
    end
  end

  def create_sala(sala) do

    GenServer.cast(ChatEmpresarial.Servidor, {:create, sala})
  end

  def join_sala(usuario, sala) do
    GenServer.cast(ChatEmpresarial.Servidor, {:join, usuario, sala})
  end

  def send_mensaje(mensaje, sala, usuario) do

    GenServer.cast(ChatEmpresarial.Servidor, {:send, mensaje, sala, usuario})
  end

end
