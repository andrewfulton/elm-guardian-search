# Guardian(Elm)

An implementation of the Guardian Search code activity in [Elm][elm]. Mostly to see what elm even is and if I can make it do anything.

## Prerequisites
Install Elm, according to it's instructions.  
An API key for the [Guardian Open Platform][guardian] - update this in the `getGuardianContent` function in `Main.elm`

## Build
Run this in elm reactor OR  
run `elm make src/Main.elm` to build an index.html  
Currently being deployed to https://guardianelm.portable.now.sh/ with `now`

## Open questions
[] How to debounce triggering the search function


[elm]: https://elm-lang.org/
[guardian]: https://open-platform.theguardian.com/documentation/