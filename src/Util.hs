module Util where

import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import Control.Monad.Trans.State.Strict
import Control.Monad.Trans.Writer.Lazy
import Text.Parsec
import Types

positiveInt :: Parser Int
positiveInt = rd <$> many1 digit
  where
    rd = read :: String -> Int

double :: Parser Double
double = rd <$> many1 digit
  where
    rd = read :: String -> Double

identity x = x

liftS ::
     StateT [[Modifier]] (WriterT String (ReaderT String IO)) a
  -> ParsecT String () (StateT [[Modifier]] (WriterT String (ReaderT String IO))) a
liftS = lift

liftW ::
     WriterT String (ReaderT String IO) a
  -> ParsecT String () (StateT [[Modifier]] (WriterT String (ReaderT String IO))) a
liftW = lift . lift

liftR ::
     ReaderT String IO a
  -> ParsecT String () (StateT [[Modifier]] (WriterT String (ReaderT String IO))) a
liftR = lift . lift . lift

liftIO ::
     IO a
  -> ParsecT String () (StateT [[Modifier]] (WriterT String (ReaderT String IO))) a
liftIO = lift . lift . lift . lift
