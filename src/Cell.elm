module Cell exposing (Cell, drawCircle, drawCross, fromString, svgView)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Player exposing (..)
import String
import Svg exposing (..)
import Svg.Attributes as SA exposing (..)


type alias Cell =
    Maybe Player


fromString : String -> Result String Cell
fromString s =
    case String.toLower s of
        "o" ->
            Ok (Just Player.O)

        "x" ->
            Ok (Just Player.X)

        "_" ->
            Ok Nothing

        other ->
            Err <| "Invalid character: " ++ other


svgView : Maybe Player -> Cell -> msg -> Svg msg
svgView maybePlayer cell message =
    let
        rectAttrs =
            [ x "0", y "0", width "100", height "100", fillOpacity "0.0" ]

        onClickEvent =
            case cell of
                Nothing ->
                    [ onClick message ]

                Just _ ->
                    []

        clickArea =
            rect (rectAttrs ++ onClickEvent) []

        markDrawing =
            case cell of
                Nothing ->
                    drawGhost maybePlayer

                Just X ->
                    g [ SA.class "mark" ] [ drawCross ]

                Just O ->
                    g [SA.class "mark" ] [ drawCircle ]
    in
    g [] ([ markDrawing ] ++ [ clickArea ])

drawGhost maybePlayer =
    case maybePlayer of
        Nothing -> 
            g [] []
        Just X ->
            g [ SA.class "show-on-hover" ] [ drawCross ]
        Just O ->
            g [ SA.class "show-on-hover" ] [ drawCircle ]



drawCircle : Svg a
drawCircle =
    circle [ cx "50", cy "50", r "40", fillOpacity "0.0", SA.style "stroke:red;stroke-width:6" ] []


drawCross : Svg a
drawCross =
    g [ SA.style "stroke:blue;stroke-width:6" ]
        [ line [ x1 "10", y1 "10", x2 "90", y2 "90" ] []
        , line [ x1 "10", y1 "90", x2 "90", y2 "10" ] []
        ]
