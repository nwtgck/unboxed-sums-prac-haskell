module Main where

import qualified SimpleUse
import qualified SumShowPrac


main :: IO ()
main = do
  putStrLn "=============== SimpleUse ==============="
  SimpleUse.run
  putStrLn "=============== SumShowPrac ==============="
  SumShowPrac.run
