module Main where

import qualified SimpleUse
import qualified SumShowPrac
import qualified EitherConverter


main :: IO ()
main = do
  putStrLn "=============== SimpleUse ==============="
  SimpleUse.run
  putStrLn "=============== SumShowPrac ==============="
  SumShowPrac.run
  putStrLn "=============== EitherConverter ==============="  
  EitherConverter.run
