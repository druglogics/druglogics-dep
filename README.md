# druglogics_dep

This module is a repository of the libraries needed to install the 
[BNReduction tool](https://github.com/alanavc/BNReduction) for computing the 
steady states in the DrugLogics pipeline.

## Install

The installation process for Macalay2 v1.6 (later versions won't work), boost 
v1.55 and the `BNReduction` script is as follows:

```
git clone https://bitbucket.org/asmundf/druglogics_dep.git

cd druglogics_dep
dpkg -i dep/libpari-gmp3_2.5.0-2ubuntu1_amd64.deb
dpkg -i dep/Macaulay2-1.6-common.deb
dpkg -i dep/Macaulay2-1.6-amd64-Linux-Ubuntu-14.04.deb
unzip dep/bnet_reduction-master.zip -d dep
tar jxfv dep/boost_1_71_0.tar.bz2 -C dep/bnet_reduction-master/
cd dep/bnet_reduction-master/
make clean
make install
```

To test the `BNReduction` script you can run the `Testing_BNReduction.sh` to 
see if all tests pass:

```
./Testing_BNReduction.sh
```

## DrugLogics-specific installation

To correctly use the `BNReduction` script in the DrugLogics pipeline do the 
following:

1) Place the location of the bnet directory, containing the `BNReduction.sh` file, 
in the environment variable _BNET_HOME_:

```
export BNET_HOME=/pathTo/druglogics_dep/dep/bnet_reduction-master
echo $BNET_HOME
```

There are various ways to set this environment variable permanently and one of 
them is to write `export BNET_HOME=/path` to a file in `/etc/profile.d/`, 
e.g. in `/etc/profile.d/bnet.sh`.

2) To significantly reduce the computation time for the steady state calculation, 
a *reduced version* of the BNReduction script that does not use the M2 library
can be used. This way though, **either one or no steady states can be found**. 
We have been using the reduced way to run the `BNReduction` script because the 
input boolean models are self-contained (no inputs) and so this significantly 
reduces the fixpoint attractors (making the use of the M2 library unnecessary 
since the reduced version outputs the same steady state). We have made a 
new script that supports both execution modes (full and reduced):

```
# from druglogics_dep dir
cp BNReduction.sh dep/bnet_reduction-master
```

Thus, `./BNReduction.sh file.dat` uses the M2 library but running 
`./BNReduction.sh file.dat reduced` does not.
