module Reactor exposing (..)

import Browser
import Url exposing (Url)
import Browser.Navigation as Nav
import Main exposing (view, update, subscriptions, Msg(..), Model)
import Main
import Html


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init = \_ -> Main.init { remotePlayServerUrl = "test" }
