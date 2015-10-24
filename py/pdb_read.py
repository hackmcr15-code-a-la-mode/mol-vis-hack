# !/usr/bin/env python

import chimera
import sys

for arg in sys.argv:
    molecule = chimera.openModels.open(arg, type='PDB')


print "done reading models"
