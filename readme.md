# Strigoi Examples

List of examples for the [Strigoi][sg] static site generator.

## Installation

Install the requirements:

    npm install

## Running

Generate all the examples in `gen/`:

    ./run

Generate the longest example name that starts with 09:

    ./run 09

Generate in `correct/`:

    ./run 09 --save

Generate  in `gen/` and diff with `correct/`:

    ./run 09 --verify

Use `--install` with projects that require installation first.

## License

MIT

[sg]: https://github.com/paul-nechifor/strigoi
