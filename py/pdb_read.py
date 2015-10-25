# !/usr/bin/env python

import chimera
from chimera import runCommand as rc
import sys
import os

for arg in sys.argv:
    if (arg.startswith('basedir:')):
        basedir = arg.split('basedir:')[1]
        print basedir
        # This is the base directory, used for saving files
    elif (len(arg) == 4):
        pdb_code = arg.lower()
        molecule = chimera.openModels.open(arg, type='PDB')
        rc('wait 1')
        rc('export '+basedir+'/structures/wrl'+'/'+pdb_code+'.wrl')

# converted models to .wrl

rc('stop now')
