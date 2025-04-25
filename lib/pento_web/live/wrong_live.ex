defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess:",
      secret_number: Enum.random(1..10))}
  end

  def render(assigns) do
    # Show a restart message and button when the user wins
    # Hint: checkout link/1 function using "patch"
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
    <h2>
      {@message}
    </h2>
    <br />
    <h2>
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
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    secret = socket.assigns.secret_number
    message = "Your guess: #{guess}. Wrong. Guess again."

    if String.to_integer(guess) === secret do
      {
        :noreply,
        assign(
          socket,
          message: "Correct - We have a Winner!",
          score: socket.assigns.score + 10
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
end
