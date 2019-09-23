import Browser

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Json.Decode exposing (Decoder, map2, field, string, at, list)

-- This is mostly boilerplate and intialises the element with
-- what we define below
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- This is the 'state' for the 'Component'
-- In this case the model is a Record(object) with keys for
-- What we are searching for (searchInput)
-- And the result we get back (searchResult)
type SearchValue = Empty | Maybe (List Article)

type alias Model =
  { searchResult: SearchValue
  , searchInput: String
  }

-- On initialisation we set
-- searchResult to be Empty
-- searchInput to an empty string
-- and we don't want to trigger any commands so use non
init : () -> (Model, Cmd Msg)
init _ =
  ( Model Empty "", Cmd.none)


-- These are the types of messages that can be sent to the update
-- function. 
-- ChangeText comes from updating the text input
-- GotSearch comes from a search result returning
type Msg
  = ChangeText String
  | GotSearch (Result Http.Error (List Article))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    -- if we change the input text, update it in the model, and
    -- trigger a command to get the new search results
    ChangeText newSearch ->
      ({ model | searchInput = newSearch}, getGuardianContent newSearch)
    GotSearch result ->
      case result of
        Ok articles ->
          ({ model | searchResult = Just articles}, Cmd.none)
        Err _ ->
          (model, Cmd.none)

-- Subscriptsions. Not doing anything with this one
-- yet
subscriptions: Model -> Sub Msg
subscriptions model = Sub.none



view : Model -> Html Msg
view model =
  div [] [
    header [] [
    h1 [] [text "Portable Guardian Search"]
    ],
    section [] [
      h2 [] [text "Search"],
      label [] [ text "Enter your search terms" ],
      input [value model.searchInput, onInput ChangeText] []
    ],
    section [] [
      h2 [] [text "Results"]
    ]
  ]
  
-- HTTP

getGuardianContent : String -> Cmd Msg
getGuardianContent searchString = 
  Http.get
    { url = "https://content.guardianapis.com/search?api-key=8be83646-3939-4c63-8d4b-dfd9515399e3&q=" ++ searchString
    , expect = Http.expectJson GotSearch articlesDecoder
    }

type alias Article = {
    title: String
    ,link: String
  }

articlesDecoder: Decoder (List Article)
articlesDecoder = 
  at ["response.results"] ( list articleDecoder)
 
articleDecoder : Decoder Article
articleDecoder =
  map2 Article
    (field "name" string)
    (field "age" string)