{-# LANGUAGE FlexibleContexts #-}

module Compiler where

import Control.Applicative hiding ((<|>), many)
import Control.Monad
import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import Control.Monad.Trans.State.Strict
import Control.Monad.Trans.Writer.Lazy
import Data.Functor
import Data.Hashable
import Data.Picture
import Modifiers
import System.Directory (doesFileExist)
import Text.Parsec
import Types
import Util

stringP = between (char '"') (char '"') (many $ satisfy (/= '"'))

setLineP :: Parser ()
setLineP = do
  string "set" *> spaces
  modList <- modifierP `sepBy` try (spaces *> char '>' *> spaces)
  liftS $ modify (++ [modList])

endLineP :: Parser ()
endLineP = do
  string "end" $> ()
  liftS $ modify init

pageLineP :: Parser ()
pageLineP = do
  modList <- concat <$> liftS get
  mapChain <- foldr ((.) . handle) identity . concat <$> lift get
  string "pane" *> spaces
  n <- positiveInt
  spaces
  f <- stringP
  ePic <- liftIO . readPicture $ f
  case ePic of
    Left err -> liftIO . print $ err
    Right pic -> do
      let fileHashedName = show (hash $ show modList ++ f) ++ ".png"
      out <- (\o -> o ++ "/" ++ fileHashedName) <$> liftR ask
      exists <- liftIO . doesFileExist $ out
      unless exists $ liftIO $ writePicturePng out (mapChain pic)
      replicateM_ n $
        liftW . tell $ "![" ++ fileHashedName ++ "](" ++ fileHashedName ++ ")\n"

blockP :: Parser ()
blockP = do
  try setLineP *> spaces
  many1 $ (pageLineP <|> blockP) *> spaces
  endLineP *> spaces

mainP :: Parser ()
mainP = do
  blockP
  eof
