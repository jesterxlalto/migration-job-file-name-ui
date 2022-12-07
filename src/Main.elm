module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text, input, label)
import Html.Attributes exposing (class, type_, for, id, placeholder)
import Html.Events exposing (onClick)


type alias Model =
    { count : Int }


initialModel : Model
initialModel =
    { count = 0 }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | count = model.count + 1 }

        Decrement ->
            { model | count = model.count - 1 }


view : Model -> Html Msg
view model =
    div [ class "w-full h-full"]
        [ div [ class "flex flex-col"][
            div [class "flex flex-col"][
              label [for "year", class "p-2"][text "Description:"]
            , input [type_ "text", id "year", placeholder "create orders", class "p-2 border-2"][]
            ]
            , div [class "h-[20px]"][]
            , div [class "flex flex-row"][
                label [for "year", class "p-2"][text "Your Filename:"]
                , input [type_ "text", id "year", placeholder "create orders", class "p-2 border-2"][]
            ]
        ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
