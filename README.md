# Practice of UnboxedSums in GHC
[![Build Status](https://travis-ci.org/nwtgck/unboxed-sums-prac-haskell.svg?branch=master)](https://travis-ci.org/nwtgck/unboxed-sums-prac-haskell)

## Run

```bash
stack build && stack exec unboxed-sums-prac-exe
```

## Usage of `UnboxedSums`

Here is whole code of a simple usage found in [app/SimpleUse.hs](app/SimpleUse.hs).

```hs
{-# LANGUAGE UnboxedSums #-}

module SimpleUse where

-- (Use UnboxedSums as function parameter)
func :: (# Int | Char | Bool #) -> Maybe Char
func (#  | ch | #) = Just ch
func _             = Nothing


-- (COMPILE ERROR: Top-level bindings for unlifted types aren't allowed:...)
-- globalUnboxedSum :: (# Int | Bool #)
-- globalUnboxedSum = (# 1 |  #)

run :: IO ()
run = do
    -- (COMPILE PASS!)
    let localUnboxedSum :: (# Int | Bool #)
        localUnboxedSum =  (# 1 |  #)

    print (func (# 1 | | #))
    -- => Nothing
    print (func (#   | 'a' | #))
    -- => Just 'a'
    
```

Here is `SumShow` instantiation. You can find whole code in [app/SumShowPrac.hs](app/SumShowPrac.hs).

```hs
-- (from: https://www.reddit.com/r/haskell/comments/6q6yau/unboxed_sums_ghc_panic/)
{-# LANGUAGE UnboxedSums #-}
{-# LANGUAGE TypeInType #-}

module SumShowPrac where

-- (from: https://github.com/gingerhot/haskell-base/blob/dbd1c3f0cf64e8c76c945530a805f7637dcdf777/testsuite/tests/deriving/should_fail/T12512.hs)
import GHC.Prim

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
```