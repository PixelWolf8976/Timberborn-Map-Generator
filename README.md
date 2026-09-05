This is a Godot project to read and edit Timberborn save files.
It will be very poorly programmed; this is just meant to be a visualization tool, not playable.

To access a save file, locate your .timber file, rename it to .zip, and unzip the file. The program needs the world.json file.

Terrain storage is pretty simple: it's a 3D binary array with a size of map size and a height of 24; a 1 means there is ground there, and a 0 means there is not. Not stored there is a flat layer at height 0 of solid ground that is always there, but not in the save file. Entities are also stored normally, with their name, ID, and position.

Water is not so simple; it is a 3d array with a size of the map size and a height of "layers". The values are either 0, if there is nothing there, or five numbers separated by colons, like A:B:C:D:E

Anything with a question mark is not that confident of a guess, with reasoning in parentheses

A is the height of the water after the last flow calculation ? (Dams can be, for example, .3 and another be .6, but visually be the same height)
B is the contamination percentage from 0.0-1.0, 1.0 meaning pure bad water
C is always 0 ? (I don't believe this is the case, but I have only ever seen it be 0)
D is the height at the bottom of the water, basically what block the water is sitting on
E is the height of the water before the last flow calculation ? (This is a pure and complete guess, nothing to back it up really; it is just low at sources, and the same as A everywhere else)
