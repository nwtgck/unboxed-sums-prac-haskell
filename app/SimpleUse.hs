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
    