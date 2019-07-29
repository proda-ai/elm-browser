module Compat.Browser exposing (application, Document, UrlRequest(..))

{-| Browser simulation module

@docs application, Document, UrlRequest

-}

import Compat.Browser.Navigation as Navigation
import Html exposing (Html, div)
import Navigation exposing (Location)
import Url exposing (Url)


{-| type UrlRequest
-}
type UrlRequest
    = Internal Url
    | External String


stringToMaybe : String -> Maybe String
stringToMaybe s =
    if String.isEmpty s then
        Nothing

    else
        Just s


translateLocation : Location -> Url
translateLocation location =
    let
        protocol =
            case location.protocol of
                "https:" ->
                    Url.Https

                _ ->
                    Url.Http
    in
    { protocol = protocol
    , host = location.hostname
    , port_ = Result.toMaybe <| String.toInt location.port_
    , path = location.pathname
    , query = stringToMaybe <| String.dropLeft 1 location.search
    , fragment = stringToMaybe <| String.dropLeft 1 location.hash
    }


{-| type alias Document msg
-}
type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


translateView : Document msg -> Html msg
translateView doc =
    div [] (.body doc)


{-| Simulates the 0.19 Browser.application using the 0.18 Navigation.programWithFlags
-}
application :
    { init : flags -> Url -> Navigation.Key -> ( model, Cmd msg )
    , view : model -> Document msg
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    , onUrlRequest : UrlRequest -> msg
    , onUrlChange : Url -> msg
    }
    -> Program flags model msg
application app =
    Navigation.programWithFlags (translateLocation >> app.onUrlChange)
        { init =
            \f l ->
                let
                    _ =
                        Debug.log "Flag2" f
                in
                app.init f (translateLocation l) Navigation.Key
        , update = app.update
        , view = app.view >> translateView
        , subscriptions = app.subscriptions
        }
