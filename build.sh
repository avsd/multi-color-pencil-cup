#!/usr/bin/env bash

openscad-nightly pencilbox.scad -D variant='"v1inner"' -o pencilbox-v1-inner.stl
openscad-nightly pencilbox.scad -D variant='"v1outer"' -o pencilbox-v1-outer.stl
openscad-nightly pencilbox.scad -D variant='"v2inner"' -o pencilbox-v2-inner.stl
openscad-nightly pencilbox.scad -D variant='"v2outer"' -o pencilbox-v2-outer.stl
