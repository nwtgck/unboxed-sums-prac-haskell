-- (from: https://www.reddit.com/r/haskell/comments/6q6yau/unboxed_sums_ghc_panic/)
{-# LANGUAGE UnboxedSums #-}
{-# LANGUAGE TypeInType #-}

module EitherConverter where

-- (from: https://github.com/gingerhot/haskell-base/blob/dbd1c3f0cf64e8c76c945530a805f7637dcdf777/testsuite/tests/deriving/should_fail/T12512.hs)
import GHC.Prim

  
toEither2 :: (# a | b #) -> Either a b
toEither2 (# a |   #) = Left a
toEither2 (#   | b #) = Right b

toEither3 :: (# a | b | c #) -> Either (Either a b) c
toEither3 (# a |   |   #) = Left (toEither2 (# a |   #))
toEither3 (#   | b |   #) = Left (toEither2 (#   | b #))
toEither3 (#   |   | c #) = Right c

toEither4 :: (# a | b | c | d #) -> Either (Either (Either a b) c) d
toEither4 (# a |   |   |   #) = Left (toEither3 (# a |   |   #))
toEither4 (#   | b |   |   #) = Left (toEither3 (#   | b |   #))
toEither4 (#   |   | c |   #) = Left (toEither3 (#   |   | c #))
toEither4 (#   |   |   | d #) = Right d


fromEither2 :: Either a b -> (# a | b #)
fromEither2 (Left a)  = (# a |   #)
fromEither2 (Right b) = (#   | b #)

fromEither3 :: Either (Either a b) c -> (# a | b | c #)
fromEither3 (Left (Left a))  = (# a |   |   #)
fromEither3 (Left (Right b)) = (#   | b |   #)
fromEither3 (Right c)        = (#   |   | c #)




run :: IO ()
run = do
    putStrLn "------ toEitherN -------"
    print (toEither2 ((# 1 |       #) :: (# Int | Bool #)))
    -- Left 1
    print (toEither2 ((#   | True  #) :: (# Int | Bool #)))
    -- Right True
    print (toEither3 ((# 'a' |    |         #) :: (# Char | Int | String #)))
    -- Left (Left 'a')
    print (toEither3 ((#     | 98 |         #) :: (# Char | Int | String #)))
    -- Left (Right 98)
    print (toEither3 ((#     |    | "hello" #) :: (# Char | Int | String #)))
    -- Right "hello"
    