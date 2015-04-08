# Sinatra Indices

[![Build Status](https://travis-ci.org/mxlje/sinatra-index.svg?branch=master)](https://travis-ci.org/mxlje/sinatra-index)

The problem: you want the path `/` to serve `public/index.html` and
`/foo/`, to serve to `public/foo/index.html`.

This is a fork of [elitheeli/sinatra-index](https://github.com/elitheeli/sinatra-index).

I adjusted it to add a trailing slash with a 301 redirect.



## Usage

```ruby
require 'sinatra'
require 'sinatra-index'

configure do
  register Sinatra::Index
  use_static_index 'index.html'
end

# ... Sinatra routes ...
```
