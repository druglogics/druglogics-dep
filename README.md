# druglogics_dep

This module is a repository of the libraries needed to install the [BNReduction tool](https://github.com/alanavc/BNReduction) for computing the steady states in the DrugLogics pipeline.

## How to Install

The installation process for Macalay2 v1.6 (later versions won't work), boost v1.55 and the BNReduction script is as follows:


```
git clone https://bitbucket.org/asmundf/druglogics_dep.git

cd druglogics_dep
dpkg -i dep/libpari-gmp3_2.5.0-2ubuntu1_amd64.deb
dpkg -i dep/Macaulay2-1.6-common.deb
dpkg -i dep/Macaulay2-1.6-amd64-Linux-Ubuntu-14.04.deb
unzip dep/bnet_reduction-master.zip -d dep
tar jxfv dep/boost_1_55_0.tar.bz2 -C dep/bnet_reduction-master/
cd dep/bnet_reduction-master/
make clean
make install
```

To test BNReduction you can run 'Testing_BNReduction.sh' to see if all tests pass:

```
./Testing_BNReduction.sh
```

## DrugLogics-specific installation

- The location of the bnet directory, containing the `BNReduction.sh` file, must be in the environment variable _BNET_HOME_:

```
export BNET_HOME=/pathTo/druglogics/druglogics_dep/dep/bnet_reduction-master
echo $BNET_HOME
```

- To significantly reduce the computation time for the steady state calculation, a _reduced version_ of the BNReduction script that does not use the M2 library can be applied. This way though, we can find either one or no fixed points, but never more than one. The module that computes tha steady states will search for the reduced script inside the bnet directory and if it doesn't find it, it will run the normal one. So, to enable this, do:

```
cd /pathTo/druglogics_dep
cp BNReductionReduced.sh dep/bnet_reduction-master
```