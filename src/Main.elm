import Browser

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Json.Decode exposing (Decoder, map2, field, string, at, list)
-- import Debug exposing (log)

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

type alias Model =
  { searchResult: List Article
  , searchInput: String
  }

-- The type for the Article
type alias Article =
  { webTitle: String
  , webUrl: String
  }

-- On initialisation we set
-- searchResult to be Empty
-- searchInput to an empty string
-- and we don't want to trigger any commands so use non
init : () -> (Model, Cmd Msg)
init _ =
  ( Model [] "", Cmd.none)


-- These are the types of messages that can be sent to the update
-- function. 
-- ChangeText comes from updating the text input
-- GotSearch comes from a search result returning
type Msg
  = ChangeText String
  | GotSearch (Result Http.Error (List Article))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  -- let _ = Debug.log "articles" msg
  -- in
  case msg of
    -- if we change the input text, update it in the model, and
    -- trigger a command to get the new search results
    ChangeText newSearch ->
      ({ model | searchInput = newSearch}, getGuardianContent newSearch)
    GotSearch result ->
      case result of
        Ok articles ->
          ({ model | searchResult = articles}, Cmd.none)
        Err _ ->
          (model, Cmd.none)

-- Subscriptsions. Not doing anything with this one
-- yet
subscriptions: Model -> Sub Msg
subscriptions model = Sub.none


-- View. This is where we render the model to HTML
view : Model -> Html Msg
view model =
  div [] [
    header [] [
    h1 [] [text "Portable Guardian Search"]
    ]
    , section [] [
      h2 [] [text "Search"],
      label [] [ text "Enter your search terms" ],
      input [value model.searchInput, onInput ChangeText] []
    ]
    , section [] [
      h2 [] [text "Results"]
      , renderArticleList model.searchResult
    ]
  ]

renderArticleList : List Article -> Html msg
renderArticleList articles =
  ul [] (List.map renderArticle articles)

renderArticle: Article -> Html msg
renderArticle article =
  li [] [
    a [href article.webUrl] [text article.webTitle]
  ]    
    
-- HTTP

-- This is triggered by the ChangeText msg being sent
-- when the user types into the textfield.
-- It fires of the request to the guardian API and
-- funnels the result through the articlesDecoder to 
-- get a list of Articles back
getGuardianContent : String -> Cmd Msg
getGuardianContent searchString = 
  Http.get
    { url = "https://content.guardianapis.com/search?api-key=8be83646-3939-4c63-8d4b-dfd9515399e3&q=" ++ searchString
    , expect = Http.expectJson GotSearch articlesDecoder
    }

-- JSON Decoder for the search result. 
-- this first one is the entrypoint and references
-- down into response.results
articlesDecoder: Decoder (List Article)
articlesDecoder = 
  field "response" (field "results" (list articleDecoder))

-- This one uses map2 to map two(2) fields back to the Article type
-- Needs to be in the same order as the type definition(?)
-- If there were three fields we would need map3 
articleDecoder : Decoder Article
articleDecoder =
  map2 Article
    (field "webTitle" string)
    (field "webUrl" string)