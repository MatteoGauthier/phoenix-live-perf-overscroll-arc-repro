defmodule PhoenixElixirReproductionOverscrollWeb.TimerLive do
  use PhoenixElixirReproductionOverscrollWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, time: Time.utc_now(), timer_ref: nil)}
  end

  def handle_event("start_timer", _, socket) do
    if socket.assigns.timer_ref, do: :timer.cancel(socket.assigns.timer_ref)
    {:ok, timer_ref} = :timer.send_interval(1000, self(), :tick)
    {:noreply, assign(socket, timer_ref: timer_ref)}
  end

  def handle_event("stop_timer", _, socket) do
    if socket.assigns.timer_ref, do: :timer.cancel(socket.assigns.timer_ref)
    {:noreply, assign(socket, timer_ref: nil)}
  end

  def handle_info(:tick, socket) do
    {:noreply, assign(socket, time: Time.utc_now())}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto mt-10">
      <h1 class="text-3xl font-bold mb-4">Simple Timer</h1>
      <p class="text-xl mb-4">Current time: <%= @time |> Time.to_string() |> String.slice(0..7) %></p>
      <div class="space-x-4">
        <button phx-click="start_timer" class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
          Start Timer
        </button>
        <button phx-click="stop_timer" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">
          Stop Timer
        </button>
      </div>
    </div>
    """
  end
end
