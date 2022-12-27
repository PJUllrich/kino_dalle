# KinoDalle

A Livebook integration for OpenAI's `DALL-E v2`.

## Installation

Create a Livebook and add the following dependency:

```elixir
Mix.install([
  {:kino_dalle, github: "PJUllrich/kino_dalle"}
])
```

## Signup to OpenAI

1. Create an account with OpenAI [here](). You'll get plenty of free credits to get started.
2. Create an API Key [here](https://beta.openai.com/account/api-keys)
3. Open your Livebook, create a `DALL-E Cell` Smart cell.
4. Click on the `API Key` field and enter your OpenAI API Key

## Usage
1. Select the desired image size and the number of images you'd like to generate.
2. Click `Evaluate` above the Smart Cell.
3. Enter your prompt and hit `Run`.

