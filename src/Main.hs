-- Attendance Decider
-- jmont

module Main (main) where

import System.Environment (getArgs)

main = do
    args <- getArgs
    putStrLn "Hello World"
    mapM putStrLn args
    return ()
