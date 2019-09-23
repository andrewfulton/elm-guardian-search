# Guardian(Elm)

An implementation of the Guardian Search code activity in [Elm][elm]. Mostly to see what elm even is and if I can make it do anything.

## Prerequisites
Install Elm, according to it's instructions.  
An API key for the [Guardian Open Platform][guardian] - update this in the `getGuardianContent` function in `Main.elm`

## Open questions
[] Does the JSON decoding work? Haven't got the types to align yet to find out if it actually works at runtime...
[] How to debounce triggering the search function


[elm]: https://elm-lang.org/
[guardian]: https://open-platform.theguardian.com/documentation/