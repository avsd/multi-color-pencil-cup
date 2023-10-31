#!/usr/bin/env bash

openscad-nightly pencilbox.scad -D variant='"v1inner"' -o pencil-cup-v1-wood.stl
openscad-nightly pencilbox.scad -D variant='"v1outer"' -o pencil-cup-v1-color.stl
openscad-nightly pencilbox.scad -D variant='"v2inner"' -o pencil-cup-v2-wood.stl
openscad-nightly pencilbox.scad -D variant='"v2outer"' -o pencil-cup-v2-color.stl
