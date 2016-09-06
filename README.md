[![Build
Status](https://travis-ci.org/garethr/dockerfilepp-labels.svg)](https://travis-ci.org/garethr/dockerfilepp-labels)
[![Go Report
Card](https://goreportcard.com/badge/github.com/garethr/dockerfilepp-labels)](https://goreportcard.com/report/github.com/garethr/dockerfilepp-labels)
[![GoDoc](https://godoc.org/github.com/garethr/dockerfilepp-labels?status.svg)](https://godoc.org/github.com/garethr/dockerfilepp-labels)

`dockerfilepp-labels` is a trivial go application which takes a
Dockerfile on stdin and simply replaces some pre-defined values. The
idea is to make Dockerfile declarative again, making multiple
Dockerfiles doing the same thing easier to maintain.

The examples centre around populating dynamic label values, but this is
for demonstration purposes only. You could imagine building your own
library of DSL extensions in a similar way, or extending into a general
purpose tool. For this purpose most of the work has been split out into
a sepatatelibrary at [github.com/garethr/dockerfile](https://github.com/garethr/dockerfilepp).

## Problem

Dockerfile is wonderfully simple when it comes to hello-world examples,
but the line-orientated nature and evolving best practices mean than
it's common for some quite crazy imperative bash juggling to make it's
way into what is best suited to a declarative build description. See
the best practice for installing debian packages if you don't believe me.

The same hoops are often jumped through in multiple Dockerfiles, so the
complex implementation details are copied and pasted into many places,
making maintenance more costly.

## Usage

So, given the following Dockerfile. We note that it is:

* Concise and declarative
* Totally not going to work if you pass it to docker because of the
  non-standard instructions.

```dockerfile
FROM alpine:3.4
MAINTAINER Gareth Rushgrove "gareth@puppet.com"

DATETIME_LABEL
VCS_LABEL
```

So lets run that through `dockerfilepp-labels`. You can download a
suitable release from the Releases list on GitHub, or build your own
from this repo by running `make build`.

Once you have the binary you can use it like so:

```
cat Dockerfile | ./dockerfilepp-labels
```

This should output to stdout with a new Dockerfile which is going to
work as an input to `docker build`

```dockerfile
FROM alpine:3.4
MAINTAINER Gareth Rushgrove "gareth@puppet.com"

LABEL com.example.datetime="2016-09-06T10:53:35+01:00"
LABEL com.example.vcs-ref="da3a8068c237137b3b468445b482cc307545af4e"
```
