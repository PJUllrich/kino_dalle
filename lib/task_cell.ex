defmodule KinoDalle.TaskCell do
  use Kino.JS, assets_path: "lib/assets/task_cell"
  use Kino.JS.Live
  use Kino.SmartCell, name: "DALL-E Cell"

  @impl true
  def init(attrs, ctx) do
    session = attrs["session"] || ""

    fields = %{
      "size" => attrs["size"] || "256x256",
      "count" => attrs["count"] || "4",
      "session" => session,
      "session_secret" => attrs["set_session"] || "",
      "use_session_secret" => Map.has_key?(attrs, "session_secret") || session == ""
    }

    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_connect(ctx) do
    payload = %{
      fields: ctx.assigns.fields
    }

    {:ok, payload, ctx}
  end

  @impl true
  def to_attrs(%{assigns: %{fields: fields}}) do
    fields_keys =
      if fields["use_session_secret"],
        do: ~w|session_secret size count|,
        else: ~w|session size count|

    Map.take(fields, fields_keys)
  end

  @impl true
  def to_source(attrs) do
    attrs |> to_quoted() |> Kino.SmartCell.quoted_to_string()
  end

  defp to_quoted(attrs) do
    quote do
      text_input = Kino.Input.textarea("Text")
      form = Kino.Control.form([text: text_input], submit: "Run")
      frame = Kino.Frame.new()
      size = unquote(attrs["size"])

      columns =
        case size do
          "256x256" -> 4
          "512x512" -> 3
          _ -> 2
        end

      count =
        unquote(attrs["count"])
        |> String.to_integer()
        |> case do
          count when count < 1 -> 1
          count when count > 10 -> 10
          count -> count
        end

      form
      |> Kino.Control.stream()
      |> Kino.listen(fn %{data: %{text: text}} ->
        Kino.Frame.render(frame, Kino.Markdown.new("Running..."))

        {:ok, res} =
          KinoDalle.TaskCell.run_prompt(
            text,
            size,
            count,
            unquote(quoted_session(attrs))
          )

        for %{"url" => url} <- res do
          {:ok, res} = Req.get(url)
          Kino.Image.new(res.body, :png)
        end
        |> Kino.Layout.grid(columns: columns)
        |> then(&Kino.Frame.render(frame, &1))
      end)

      Kino.Layout.grid([form, frame], boxed: true, gap: 16)
    end
  end

  def run_prompt(prompt, size, count, session) do
    {:ok, res} =
      Req.post("https://api.openai.com/v1/images/generations",
        json: %{
          prompt: prompt,
          size: size,
          n: count
        },
        headers: [
          {"Authorization", "Bearer #{session}"},
          {"Content-Type", "application/json"}
        ]
      )

    case res.status do
      200 -> {:ok, res.body["data"]}
      _ -> raise "\nStatus: #{inspect(res.status)}\nError: #{inspect(res.body)}"
    end
  end

  defp quoted_session(%{"session" => session}), do: session

  defp quoted_session(%{"session_secret" => ""}), do: ""

  defp quoted_session(%{"session_secret" => session_secret}) do
    quote do
      System.fetch_env!(unquote("LB_#{session_secret}"))
    end
  end

  @impl true
  def handle_event("update_field", %{"field" => field, "value" => value}, ctx) do
    updated_fields = to_updates(ctx.assigns.fields, field, value)
    ctx = update(ctx, :fields, &Map.merge(&1, updated_fields))
    broadcast_event(ctx, "update", %{"fields" => updated_fields})

    {:noreply, ctx}
  end

  defp to_updates(fields, "variable", value) do
    if Kino.SmartCell.valid_variable_name?(value) do
      %{"variable" => value}
    else
      %{"variable" => fields["variable"]}
    end
  end

  defp to_updates(_fields, field, value), do: %{field => value}
end
