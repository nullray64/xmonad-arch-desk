import XMonad
import XMonad.Config.Desktop
import XMonad.Util.SpawnOnce
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run (spawnPipe, hPutStrLn)
import System.IO (hPutStrLn)

-- 1. Добавляем этот импорт для удобной работы с клавишами
import XMonad.Util.EZConfig (additionalKeysP)

main = do
    h <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    
    -- 2. "Накладываем" новые клавиши поверх конфига
    -- "M-p" перезапишет стандартный бинд dmenu
    xmonad $ myConfig h `additionalKeysP` 
        [ ("M-p", spawn "rofi -show drun") 
        , ("M-S-p", spawn "rofi -show run") -- Опционально: Shift+Mod+p для обычного run
	, ("M-S-l", spawn "betterlockscreen -l dim")
        ]

myConfig h = desktopConfig {
    terminal    = "alacritty"
  , modMask     = mod4Mask
  , borderWidth = 2
  , normalBorderColor  = "#4e4675"
  , focusedBorderColor = "#9d8aff"
  , workspaces = ["1:term","2:web","3:code","4:tg", "5:mail", "6:etc", "7:etc"]
  
  , logHook = dynamicLogWithPP $ def { 
        ppOutput = hPutStrLn h
      , ppCurrent = xmobarColor "#9d8aff" "" . wrap "[" "]"
      , ppHidden  = xmobarColor "#bd93f9" ""
      , ppTitle   = xmobarColor "#ff79c6" "" . shorten 50
      }
      
  , startupHook = do
      spawnOnce "setxkbmap -layout us,ru -option 'grp:caps_toggle,grp_led:caps'"
      spawnOnce "picom --vsync --backend glx"
      spawnOnce "betterlockscreen -w dim"
}

