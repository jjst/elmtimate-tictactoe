module UltimateTicTacToeTest exposing (tests)

import Test exposing (..)
import Expect exposing (..)
import ElmTestBDDStyle exposing (..)
import Debug
import UltimateTicTacToe exposing (..)
import Board
import Tuple3 exposing (..)
import TicTacToe
import Cell as C
import Player


orCrash : Result String a -> a
orCrash result =
    case result of
        Err s ->
            -- Thanks elm 0.19
            Debug.todo s

        Ok a ->
            a


initialBoard =
    init


tests : Test
tests =
    describe "An updated UltimateTicTacToeBoard Model"
        [ it "toggles the current player" <|
            expect
                (performMove Player.X { boardCoords = ( I1, I1 ), cellCoords = ( I1, I1 ) } initialBoard).currentPlayer
                to equal
                Player.O
        , let
            str =
                """
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            -------+-------+-------
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            -------+-------+-------
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            """
          in
            it "should construct a default board model" <|
                expect
                    (fromString Player.X Nothing str)
                    to equal
                    (Ok initialBoard)
        , let
            str =
                """
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            -------+-------+-------
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | x _ _
             _ _ _ | _ _ _ | _ _ o
            -------+-------+-------
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            """

            subBoard =
                TicTacToe.fromString
                    """
             _ _ _
             x _ _
             _ _ o
            """
                    |> orCrash
          in
            it "should contain the expected subboard" <|
                expect
                    (fromString Player.X Nothing str)
                    to equal
                    (Ok
                        { initialBoard
                            | board =
                                Board.indexedMap
                                    (\coords s ->
                                        if coords == ( I2, I3 ) then
                                            subBoard
                                        else
                                            s
                                    )
                                    initialBoard.board
                        }
                    )
        , let
            currentBoard =
                fromString Player.O
                    (Just ( I2, I2 ))
                    """
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            -------+-------+-------
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | o _ o | _ _ _
             _ _ _ | _ _ _ | _ _ _
            -------+-------+-------
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            """
                    |> orCrash

            expectedBoard =
                fromString Player.X
                    Nothing
                    """
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            -------+-------+-------
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | o o o | _ _ _
             _ _ _ | _ _ _ | _ _ _
            -------+-------+-------
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
             _ _ _ | _ _ _ | _ _ _
            """
                    |> orCrash

            move = { boardCoords = ( I2, I2 ), cellCoords = ( I2, I2 ) }

            nextBoardCoords =
                (performMove Player.O move currentBoard).currentBoardCoords
          in
            it "should send the opposite player to another board if the current one has been won" <|
                expect
                    nextBoardCoords
                    to equal
                    Nothing
        ]
