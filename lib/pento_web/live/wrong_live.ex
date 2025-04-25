defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign_new_game(socket)}
  end

  defp assign_new_game(socket) do
    assign(socket,
      score: 0,
      message: "Make a guess:",
      secret_number: Enum.random(1..10),
      won: false
    )
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
    <h2>
      {@message}
    </h2>
    <br />
    <div>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold
          py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          {n}
        </.link>
      <% end %>
    </div>
    <br />
    <%= if @won do %>
      <.link
        patch={~p"/guess"}
        class="bg-green-500 hover:bg-green-700 text-white font-bold
        py-2 px-4 border border-green-700 rounded m-1"
      >
        Restart Game
      </.link>
    <% end %>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    secret_number = socket.assigns.secret_number
    message = "Your guess: #{guess}. Wrong. Guess again."
    guessed_number = String.to_integer(guess)

    if guessed_number === secret_number do
      {
        :noreply,
        assign(
          socket,
          message: "You guessed correctly!",
          score: socket.assigns.score + 10,
          won: true
        )
      }
    else
      {
        :noreply,
        assign(
          socket,
          message: message,
          score: socket.assigns.score - 1
        )
      }
    end
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign_new_game(socket)}
  end
end
