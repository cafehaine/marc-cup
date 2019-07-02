# Marc-Cup
## What is Marc-Cup
Marc-Cup is a lua parser for a simple custom markup language.

I will use this library as a way to render my blog articles, so the features
will mostly only suit my needs, but if you have and idea on how to improve the
parser and/or features, feel free to create an issue for it!

# Features and syntax
- Titles, using the markdown `#, ##, …` syntax for the different levels
- Inline code, using the markdown syntax `\x60inline code\x60`
- Block of code, using something close to the markdown syntax, allowing to add
  numbers to the lines:
```
\x60\x60\x60language:starting_line
code
code
\x60\x60\x60
```
- Links, using the markdown `[description](url)` syntax
- Emphasis, with brackets, allowing nested emphases `{like {this}.`

## Why Marc-Cup
Marc is the french word for coffe grounds. Since my username has coffee in it,
and it sounds like markup, I figured Marc-Cup would be an okay pun.
