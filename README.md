# Marc-Cup
## What is Marc-Cup
Marc-Cup is a lua parser for a simple custom markup language.

I will use this library as a way to render my blog articles, so the features
will mostly only suit my needs, but if you have an idea on how to improve the
parser and/or features, feel free to create an issue for it!

# Features and syntax
- Paragraphs, separated by an empty line
- Titles, using the markdown `#, ##, …` syntax for the different levels
- Inline code, using the markdown syntax `` `inline code` ``, with \\ to escape
  backticks (and only backticks)
- Block of code, using something close to the markdown syntax, allowing to add
  numbers to the lines. Note that those have to be on an independant paragraph
  (surounded by empty lines).
````
```language:starting_line
code
code
```
````
- Links, using the markdown `[description](url)` syntax
- Emphasis, with brackets, allowing nested emphases `{like {this}.}`

## Why Marc-Cup
Marc is the french word for coffee grounds. Since my username has coffee in it,
and it sounds like markup, I figured Marc-Cup would be an okay pun.
