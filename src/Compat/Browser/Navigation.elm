module Compat.Browser.Navigation exposing (Key(..), back, forward, load, pushUrl, reload, reloadAndSkipCache, replaceUrl)

{-| Simulate the 0.19 Browser.Navigation with 0.18 Navigation

@docs Key, back, forward, load, pushUrl, reload, reloadAndSkipCache, replaceUrl

-}

import Navigation


{-| Key
-}
type Key
    = Key


{-| pushUrl
-}
pushUrl : Key -> String -> Cmd msg
pushUrl k s =
    Navigation.newUrl s


{-| replaceUrl
-}
replaceUrl : Key -> String -> Cmd msg
replaceUrl k s =
    Navigation.modifyUrl s


{-| back
-}
back : Key -> Int -> Cmd msg
back k i =
    Navigation.back i


{-| forward
-}
forward : Key -> Int -> Cmd msg
forward k i =
    Navigation.forward i


{-| load
-}
load : String -> Cmd msg
load =
    Navigation.load


{-| reload
-}
reload : Cmd msg
reload =
    Navigation.reload


{-| reloadAndSkipCache
-}
reloadAndSkipCache : Cmd msg
reloadAndSkipCache =
    Navigation.reloadAndSkipCache
