#!/bin/bash

if [[ "$#" != "2" && "$#" != "1" ]]; then                                                        
  echo "Specify at most two arguments:"
  echo "1) inputfile (.dat)"
  echo "2) \`reduced\` -> runs the script without using the M2 library (non-obligatory)"
  exit 1                                                
fi

inputfile="$1"
mode="$2"

if [[ "$#" == "2" && "$mode" != "reduced" ]]; then
  echo "Use \`reduced\` mode if you don't want to use the M2 library"
  exit 1
fi

dir=$(dirname $0);
bnet_dir=$(echo "$(cd $dir && pwd)")

if [ "$mode" == "reduced" ]; then
  $bnet_dir/BuildAndNot/BuildAndNot < "$inputfile" |                            
  $bnet_dir/NetReductionBoost/NetReduction |                                    
  $bnet_dir/MapFixedPoints/MapFixedPoints > "$inputfile".fp
else	
  $bnet_dir/BuildAndNot/BuildAndNot < "$inputfile" | 
  $bnet_dir/NetReductionBoost/NetReduction > "$inputfile".red;
  $bnet_dir/ToPolynomial/ToPolynomial < "$inputfile".red > "$inputfile".poly;

  echo 'filename="'"$inputfile".poly'"; file=openOutAppend("'"$inputfile".red'"); 
        file<< "\n\nFIXED_POINTS_REDUCED\n";
        F=lines(get(filename)); if #F==0 then (file<< "1 \n\n"; close(file); exit);
        needsPackage "FPGB"; QR=makeRing(#F,2); 
        F=apply(F,f->(value f)_QR); 
        solutions = modifyOutput(T3(F,QR,toList(#F:1)), QR); 
        file<<#solutions<<"\n";
        scan(solutions,   ss->(s:="";scan(ss,si->(s=s|toString(si)|" "));file<<s; file<<"\n";));  
        close(file);' | M2 > M2.log

  $bnet_dir/MapFixedPoints/MapFixedPoints  < "$inputfile".red > "$inputfile".fp 

  rm "$inputfile".poly;
  rm "$inputfile".red;
fi
