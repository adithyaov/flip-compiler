module Modifiers where

import Control.Applicative hiding ((<|>), many)
import Control.Monad
import Data.Picture
import Text.Parsec
import Text.Parsec.String
import Types
import Util

rotateP = do
  string "rotate"
  spaces
  Rotate <$> double

fadeP = do
  string "fade"
  spaces
  Fade <$> double

modifierP = rotateP <|> fadeP

handle (Rotate x) = rotate x Nothing
handle (Fade x) = fade x
