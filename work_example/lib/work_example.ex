defmodule WorkExample do
  def hash_new_password do
    %{  bcrypt: Comeonin.Bcrypt.hashpwsalt("supersecurepassword"),
        pbkdf2: Comeonin.Pbkdf2.hashpwsalt("supersecurepassword") }
  end

  def send_result_to(pid) do
    send pid, {:ok, WorkExample.hash_new_password}
  end

  def run_local do
    1..12
    |> Enum.to_list
    |> Enum.map(fn(_) ->
      pid = spawn_link WorkExample, :send_result_to, [self]
      pid
    end)
    |> Enum.map(fn(_) ->
      receive do
        {:ok, result} ->
          result
      end
    end)
  end

  def run_on_nodes do
    me = self
    1..12
    |> Enum.to_list
    |> Enum.chunk(3)
    |> Enum.map(fn(_) ->
      pid1 = Node.spawn_link :"rpi@rpi-one.lan", WorkExample, :send_result_to, [me]
      pid2 = Node.spawn_link :"rpi@rpi-two.lan", WorkExample, :send_result_to, [me]
      pid3 = Node.spawn_link :"rpi@rpi-three.lan", WorkExample, :send_result_to, [me]

      [pid1, pid2, pid3]
    end)
    |> List.flatten
    |> Enum.map(fn(_) ->
      receive do
         {:ok, result} ->
           result
      end
    end)
  end
end
