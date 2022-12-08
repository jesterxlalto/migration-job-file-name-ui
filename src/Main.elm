port module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text, input, label, h1, h5, span)
import Html.Attributes exposing (class, type_, for, id, placeholder, value, disabled, attribute)
import Html.Events exposing (onClick, onInput )
import Task
import Time
import Svg exposing (svg, path)
import Svg.Attributes exposing (fill, viewBox, fillRule, d, clipRule)

type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , descriptionUserText : String
    , filename : Maybe String
    , successfullyCopied : Bool
    , showingToast : Bool }




type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | OnDescriptionUpdate String
    | Copy
    | ReceiveCopySuccess Bool
    | DismissToast

port copyToClipboard : String -> Cmd msg
port copyReceived : (Bool -> msg) -> Sub msg

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
            ( { model | descriptionUserText = userText, filename = parseFilename model userText }, Cmd.none )

        Copy ->
            case model.filename of
                Nothing ->
                    ( model, Cmd.none )
                Just value ->
                    ( model, copyToClipboard value )
        
        ReceiveCopySuccess itWorked ->
            if itWorked then
                ( { model | successfullyCopied = True, showingToast = True }, Cmd.none )
            else
                ( { model | successfullyCopied = False, showingToast = False }, Cmd.none )

        DismissToast ->
            ( { model | showingToast = False }, Cmd.none )


-- 20220923091900
-- 2002 09 23 09 19:00
parseFilename : Model -> String -> Maybe String
parseFilename model userText =
    if userText == "" || userText == " " then
        Nothing
    else
        let
            year = stringFromInt (Time.toYear model.zone model.time)
            month = (Time.toMonth model.zone model.time)
            day = stringFromInt (Time.toDay model.zone model.time)
            hour = stringFromInt (Time.toHour model.zone model.time)
            minute = stringFromInt (Time.toMinute model.zone model.time)
            second = stringFromInt (Time.toSecond model.zone model.time)
        in
        "V"
        ++ year
        ++ (monthToString month)
        ++ day 
        ++ hour
        ++ minute
        ++ second
        ++ "__"
        ++ (spacesToUnderscores userText)
        ++ ".sql"
        |> Just

spacesToUnderscores : String -> String
spacesToUnderscores str =
    String.replace " " "_" str


monthToString : Time.Month -> String
monthToString month =
  case month of
    Time.Jan -> "01"
    Time.Feb -> "02"
    Time.Mar -> "03"
    Time.Apr -> "04"
    Time.May -> "05"
    Time.Jun -> "06"
    Time.Jul -> "07"
    Time.Aug -> "08"
    Time.Sep -> "09"
    Time.Oct -> "10"
    Time.Nov -> "11"
    Time.Dec -> "12"

stringFromInt : Int -> String
stringFromInt num =
    if num < 10 then
        "0" ++ String.fromInt num
    else
        String.fromInt num


view : Model -> Html Msg
view model =
    div [ class "p-4 w-full h-full dark:bg-gray-900"]
        [ div [ class "flex flex-col w-[500px] block p-6 bg-white border border-gray-200 rounded-lg shadow-md hover:bg-gray-100 dark:bg-gray-800 dark:border-gray-700 dark:hover:bg-gray-700"][
            div [class "flex flex-col"][
            flowbiteH5 [][text "What does your migration script do?"]
            , flowbiteLabel [for "year", class "p-2"][text "Description:"]
            , flowbiteInput [type_ "text", id "year", placeholder "create orders", value model.descriptionUserText, onInput OnDescriptionUpdate, class "p-2 border-2"][]
            ]
            , div [class "h-[60px]"][]
            , case model.filename of
                Nothing ->
                    div [class "flex flex-col gap-2 opacity-25"][
                        flowbiteH5 [][text "Copy your .sql filename below"]
                        , flowbiteLabel [for "year", class "p-2"][text "Filename:"]
                        , flowbiteInput [disabled True, type_ "text", id "yourFilename", class "p-2 border-2 bg-gray-200 text-gray-500"][]
                        , flowbiteButtonDisabled [ ][text "Copy"]
                    ]
                Just name ->
                    div [class "flex flex-col gap-2 "][
                        flowbiteH5 [][text "Copy your .sql filename below"]
                        , flowbiteLabel [for "year", class "p-2"][text "Filename:"]
                        , flowbiteInput [type_ "text", id "yourFilename", value name, class "p-2 border-2 bg-gray-200 text-gray-500"][]
                        , flowbiteButton [ onClick Copy][text "Copy"]
                    ]
            ]
            , if model.showingToast then
                flowbiteToast
            else
                span [][]
        ]

flowbiteH5 attributes contents =
    h5
        (attributes ++ [class "mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"])
        contents

flowbiteLabel attributes contents =
    label 
        (attributes ++ [class "block mb-2 text-sm font-medium text-gray-900 dark:text-white"])
        contents

flowbiteInput attributes contents =
    input
        (attributes ++ [class "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"])
        contents

flowbiteButton attributes contents =
    button
        (attributes ++ [class "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"])
        contents

flowbiteButtonDisabled attributes contents =
    button
        (attributes ++ [disabled True, class "py-2.5 px-5 mr-2 mb-2 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"])
        contents

        

flowbiteToast =
    div [ id "toast-success"
        , class "absolute bottom-5 left-5 flex items-center p-4 mb-4 w-full max-w-xs text-gray-500 bg-white rounded-lg shadow dark:text-gray-400 dark:bg-gray-800"
        , attribute "role" "alert" ][
        div [class "inline-flex flex-shrink-0 justify-center items-center w-8 h-8 text-green-500 bg-green-100 rounded-lg dark:bg-green-800 dark:text-green-200"][
            svg [attribute "aria-hidden" "true"
            , Svg.Attributes.class "w-5 h-5"
            , fill "currentColor"
            , viewBox "0 0 20 20"
            , attribute "xmlns" "http://www.w3.org/2000/svg" ][
                path [ fillRule "evenodd"
                    , d "M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    , clipRule "evenodd"][]
            ]
            , span [class "sr-only"][text "Check Icon"]
        ]
       , div [class "ml-3 text-sm font-normal"][ text "Filename copied to your clipboard!"]
        , button [type_ "button"
                , class "ml-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100 inline-flex h-8 w-8 dark:text-gray-500 dark:hover:text-white dark:bg-gray-800 dark:hover:bg-gray-700"
                , attribute "data-dismiss-target" "#toast-success"
                , attribute "aria-label" "Close"
                , onClick DismissToast][
                span [class "sr-only"][text "Close"]
                , svg [attribute "aria-hidden" "true", Svg.Attributes.class "w-5 h-5", fill "currentColor", viewBox "0 0 20 20"][
                    path [fillRule "eventodd", d "M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                    , clipRule "evenodd"][]
            ]
        ]
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Time.every 1000 Tick, copyReceived ReceiveCopySuccess]

init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0) "" Nothing False False
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