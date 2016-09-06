// dockerfilepp-labels is a tool which adds new instructions to Dockerfile
// for adding dynamic labels as part of an image build process.
//
// It does that by post-processing a standard Dockerfile and replacing new
// instructions with valid snippets of Dockerfile.
//
// Under the hood dockerfilepp-labels uses the dockerfilepp library.
//
// Usage:
//
//    dockerfilepp-labels < Dockerfile
//    cat Dockerfil | dockerfile-labels
//
package main

import (
	"fmt"
	"github.com/garethr/dockerfilepp"
	"os"
	"os/exec"
	"strings"
	"time"
)

// gitsha returns the latest git SHA as a string. Requires a local git client.
func gitsha() string {
	out, err := exec.Command("git", "rev-parse", "HEAD").Output()
	if err != nil {
		fmt.Println(`A problem occured running git. Are you in git repository?
Try running git rev-parse HEAD locally.`)
		os.Exit(2)
	}
	return strings.Replace(string(out[:]), "\n", "", -1)
}

func main() {
	replacements := map[string]string{
		"DATETIME_LABEL": "LABEL com.example.datetime=\"" + time.Now().Format(time.RFC3339) + "\"",
		"VCS_LABEL":      "LABEL com.example.vcs-ref=\"" + gitsha() + "\"",
	}
	dockerfilepp.Process(replacements, `dockerfilepp-labels is a tool for adding new instructions to Dockerfile

Usage:

    dockerfilepp-labels < Dockerfile
    Dockerfile | dockerfilepp-labels

dockerfilepp-labels takes a Dockerfile on stdin and outputs to stdout a modified version
of the same Dockerfile which has been through the registered pre-processors.
It currently supports the following new instructions:

DATETIME_LABEL - Adds a LABEL with an RFC 3339 formatted date
VCS_LABEL - Adds a LABEL with the latest git SHA`)
}
