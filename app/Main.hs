{-# LANGUAGE UnboxedSums #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE MagicHash #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE UnboxedSums #-}
{-# LANGUAGE UnboxedTuples #-}
{-# LANGUAGE TypeInType #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}




-- (from: https://www.reddit.com/r/haskell/comments/6q6yau/unboxed_sums_ghc_panic/)

-- {-# LANGUAGE  UnpackedSumTypes #-}


module Main where

import Control.Monad.Identity

-- (from: https://github.com/gingerhot/haskell-base/blob/dbd1c3f0cf64e8c76c945530a805f7637dcdf777/testsuite/tests/deriving/should_fail/T12512.hs)
import GHC.Prim
import GHC.Types
import GHC.Exts

import qualified SimpleUse


xs :: (# Int | Char | Bool #) -> Int
xs (# i | | #) = i
-- x :: (# Int | Char | Bool #)
-- x = (# 1 | | #)



-- f :: (# Int | Bool | Char #) -> ()
-- f (# i | | #) = ()
-- f (# | b | #) = ()

-- newtype # Wrap a = Wrap a

-- type T a b c = Wrap ((# a | b | c #))

-- instance (Show a, Show b, Show c) => Show (T a b c) where
--   show (# a |   |  #)  = show a
--   show (#   | b |   #) = show b
--   show (#   |   | c #) = show c
  
-- instance (Show a, Show b, Show c) => Show (a, b, c) where
--   -- show (# a |   |  #)  = show a
--   -- show (#   | b |   #) = show b
--   -- show (#   |   | c #) = show c

-- instance Show ((# Int | Char | Bool #)) where
--   show (# a |   |  #)  = show a
--   show (#   | b |   #) = show b
--   show (#   |   | c #) = show c
  
-- class SumShow (a :: TYPE ('SumRep ['LiftedRep, 'LiftedRep]))
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
  

-- instance (SumShow a) => Show a where
--   show a = sumShow a

-- type Type = TYPE LiftedRep

-- class Sh (a :: TYPE rep) where
--   sh :: a -> String
--   pr :: a -> IO ()

-- instance Show a => Sh (a :: GHC.Types.Type) where
--   sh :: a -> String
--   sh = show

--   pr :: a -> IO ()
--   pr = print

-- class Sh (a :: TYPE rep) where
--   sh :: a -> String
--   pr :: a -> IO ()

-- deriving instance Show ( (# Int | Char | Bool #))

myShow :: (Show a, Show b, Show c) => (# a | b | c #) -> String
myShow (# a |   |  #)  = show a
myShow (#   | b |   #) = show b
myShow (#   |   | c #) = show c

main :: IO ()
main = do
  putStrLn "=============== SimpleUse ==============="
  SimpleUse.run
  -- let x :: (# Int | Char | Bool #)
  --     x = (# 1 | | #)
  -- putStrLn (sumShow x)
  -- return ()
  -- -- putStrLn (show x)
  -- -- putStrLn (myShow x)
