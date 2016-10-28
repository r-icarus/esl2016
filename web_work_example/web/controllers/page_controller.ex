defmodule WebWorkExample.PageController do
  use WebWorkExample.Web, :controller

  def index(conn, _params) do
    passwords = %{  bcrypt: Comeonin.Bcrypt.hashpwsalt("supersecurepassword") }
    render conn, "index.json", passwords: passwords
  end
end
