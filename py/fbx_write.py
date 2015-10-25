# !/usr/bin/env python

# Blender has moved to Python 3!

import sys
import os
import bpy

for sysarg in sys.argv:
    print(sysarg)

py_args = sys.argv[sys.argv.index('--') + 1]
py_args = py_args.split(' ')

for arg in py_args:
    if (arg.startswith('basedir:')):
        basedir = arg.split('basedir:')[1]
    else:
        # can supply filename(s) with or without extension
        pdb_code = os.path.splitext(arg)[0]
        abs_file_in = os.path.join(basedir, 'structures/wrl', pdb_code+'.wrl')
        # This is the base directory, used for saving files
        molecule = bpy.ops.import_scene.x3d(
                filepath = abs_file_in
        )
        abs_file_out = os.path.join(basedir,'structures/fbx',pdb_code+'.fbx')
        bpy.ops.export_scene.fbx(
                filepath = abs_file_out
        )
        bpy.ops.wm.quit_blender()
