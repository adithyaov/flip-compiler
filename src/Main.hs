module Main where

import Compiler
import Control.Monad.Trans.Reader
import Control.Monad.Trans.State.Strict
import Control.Monad.Trans.Writer.Lazy
import Modifiers
import System.Environment
import Text.Parsec
import Types

main :: IO ()
main = do
  args <- getArgs
  case args of
    inputFile:outputDir:_ -> do
      input <- readFile inputFile
      (_, mdFile) <-
        runReaderT
          (runWriterT (runStateT (runParserT mainP () "sample.flip" input) []))
          outputDir
      writeFile (outputDir ++ "/result.md") mdFile
    _ ->
      print
        "Insufficient Args, min 2 args required, input file path and output dir path :-)"
