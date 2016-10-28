defmodule WebWorkExample.PageView do
  use WebWorkExample.Web, :view

  def render("index.json", %{ passwords: passwords}) do
    passwords
  end
end
