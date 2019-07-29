module Main exposing (Model, Msg(..), init, main, subscriptions, update, view, viewLink)

import Compat.Browser as Browser
import Compat.Browser.Dom as Dom
import Compat.Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Task
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , c : Int
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        _ =
            Debug.log "flags" flags
    in
    ( Model key url 0, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            let
                focusTask =
                    if model.c % 2 == 0 then
                        Debug.log "focus" "hey1"

                    else
                        Debug.log "focus" "hey2"
            in
            ( { model | url = url, c = model.c + 1 }
            , Task.attempt (always NoOp) (Dom.focus focusTask)
            )

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ text "The current URL is: "
        , b [] [ text (Url.toString model.url) ]
        , ul []
            [ viewLink "#/home"
            , viewLink "#/profile"
            , viewLink "#/reviews/the-century-of-the-self"
            , viewLink "#/reviews/public-opinion"
            , viewLink "#/reviews/shah-of-shahs"
            ]
        , input [ id "hey1", placeholder "hey1" ] []
        , input [ id "hey2", placeholder "hey2" ] []
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
