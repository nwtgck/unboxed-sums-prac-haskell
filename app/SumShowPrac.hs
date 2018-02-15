-- (from: https://www.reddit.com/r/haskell/comments/6q6yau/unboxed_sums_ghc_panic/)
{-# LANGUAGE UnboxedSums #-}
{-# LANGUAGE TypeInType #-}

module SumShowPrac where

-- (from: https://github.com/gingerhot/haskell-base/blob/dbd1c3f0cf64e8c76c945530a805f7637dcdf777/testsuite/tests/deriving/should_fail/T12512.hs)
import GHC.Prim
import GHC.Types
import GHC.Exts

class SumShow (a :: TYPE rep) where
    sumShow :: a -> String
  
instance (Show a, Show b) => SumShow ((# a | b #)) where
    sumShow (# a |    #) = show a
    sumShow (#   | b  #) = show b

instance (Show a, Show b, Show c) => SumShow ((# a | b | c #)) where
    sumShow (# a |   |  #)  = show a
    sumShow (#   | b |   #) = show b
    sumShow (#   |   | c #) = show c

instance (Show a, Show b, Show c, Show d) => SumShow ((# a | b | c | d #)) where
    sumShow (# a |   |   |   #) = show a
    sumShow (#   | b |   |   #) = show b
    sumShow (#   |   | c |   #) = show c
    sumShow (#   |   |   | d #) = show d


myShow3 :: (Show a, Show b, Show c) => (# a | b | c #) -> String
myShow3 (# a |   |  #)  = show a
myShow3 (#   | b |   #) = show b
myShow3 (#   |   | c #) = show c

run :: IO ()
run = do
    putStrLn (sumShow ((# 1 |       #) :: (# Int | Bool #)))
    -- => 1
    putStrLn (sumShow ((#   | True  #) :: (# Int | Bool #)))
    -- => True

    putStrLn (sumShow ((# 'a' | |         #) :: (# Char | Int | String #)))
    -- => 'a'
    putStrLn (sumShow ((#     | | "hello" #) :: (# Char | Int | String #)))
    -- => "hello"
    
    
    
    