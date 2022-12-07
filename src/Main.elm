module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text, input, label, h1)
import Html.Attributes exposing (class, type_, for, id, placeholder, value )
import Html.Events exposing (onClick, onInput )
import Task
import Time

type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , descriptionUserText : String }




type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | OnDescriptionUpdate String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        OnDescriptionUpdate userText ->
            ( { model | descriptionUserText = userText }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "w-full h-full"]
        [ div [ class "flex flex-col w-96"][
            div [class "flex flex-col"][
              label [for "year", class "p-2"][text "Description:"]
            , input [type_ "text", id "year", placeholder "create orders", value model.descriptionUserText, onInput OnDescriptionUpdate, class "p-2 border-2"][]
            ]
            , div [class "h-[20px]"][]
            , div [class "flex flex-row"][
                label [for "year", class "p-2"][text "Your Filename:"]
                , input [type_ "text", id "year", placeholder "create orders", class "p-2 border-2"][]
                , button [][text "Copy"]
            ]
            , showTime model
        ]
        ]

showTime model =
    let
        hour   = String.fromInt (Time.toHour   model.zone model.time)
        minute = String.fromInt (Time.toMinute model.zone model.time)
        second = String.fromInt (Time.toSecond model.zone model.time)
    in
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick

init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0) ""
  , Task.perform AdjustTimeZone Time.here
  )


main : Program () Model Msg
main =
     Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }