module Types where

import Control.Monad.Trans.Reader
import Control.Monad.Trans.State.Strict
import Control.Monad.Trans.Writer.Lazy
import Data.Picture
import Text.Parsec

data Modifier
  = Rotate Double
  | Fade Double
  deriving (Show)

type Path = String

type Parser a
   = ParsecT String () (StateT [[Modifier]] (WriterT String (ReaderT String IO))) a
