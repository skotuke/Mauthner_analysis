#### Intro

The script is used to determin resting membrane potential of Mautner neuron (or any other neuron for that matter). It averages the first 5 seconds (adjustable) of the recording and returns the file name and a single value for voltage. It's up to the user to make sure that there are no action potentials fired in the first 5 seconds of the recording, as that will skew the final value.

#### Expected Input

The script is made for .abf files, any number of sweeps, any length each, 10kHz sampling frequency. The filter, sweep length and the duration of the window analysed can all be adjusted. 

#### Adjustable Parameters

1. Filter frequency. Analysis_RMP_pub.m, line 4.
2. The duration of window analysed. RMP_Mauthner_pub.m, line 20.

#### Instructions

1. Make sure that the folder you running from is set as current directory.
2. Make sure there are no action potentials or membrane voltage turbulences in the first 5 s (or whatever window you set) of the recording.
3. Run RMP_Mauthner_pub.m.
4. Select one or multiple  .abf files to be analysed by the script. Recordings made by different fish can be run together.
5. Once the script is finished, 'Finished.' will be printed out in the command window.

#### Expected Output

The output file will be an excel spreadsheet with two columns. The left column will be the list of .abf file names and the column of the right will carry the values of resting membrane potential for each corresponding file. 

The output file will be named RMP_your filename.xlsx for a single analysed file or RMP_your first selected filename_and_more.xlsx.

The output excel file location will be the same as the origin of the files selected for the analysis.

#### Sample Files
Two sample files are included from silent (Mauthner 1) and bursting (Mauthner 2) Mauthner neurons.

#### Contact
Feel free to get in touch with me skotuke@gmail.com with any questions or problems.