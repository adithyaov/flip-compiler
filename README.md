# The Flip compiler
A compiler to make flip books :-)

Compiles `.flip` to `.md`

## Language
3 important type of statements

`set`, `pane`, `end`

eg,
```
set rotate 50 > modifier2 > fade 20
  pane 10 "mario_start.png"
  pane 10 "mario_mid.png"
  set modifier4
    pane 20 "luigi_enters.png"
  end
  pane 10 "mario_end.png"
end
```
`set` takes a sequence of modifiers and applies it in that order.

`pane` takes the number of pages to repeat the image, which is the second parameter.
Indentation is not required.

Currently 2 modifiers are supported, `rotate` and `fade`.

## Compiler features
1. Simple API to add more modifiers, currently 2 modifiers are supported, rotate and fade.
2. Deep Contexts, the environment stacks on top of each other and removed accordingly with `set` and `end`.

## Usage

```
flip-compiler input_path.flip output_directory
```
Note : `output_directory` should not have a trailing blackslash.
Make sure all the file paths in the `.flip` file are absolute.
