#### Expected Input
The script is used to analyse an antidromic action potential in a Mauthner cell resulting from field stimulation in the posterior zebrafish spinal cord. The script is made for .abf files, 10 sweeps each, 5s per sweep, 100kHz filter frequency. The filter and number of sweeps can be adjusted.

#### Adjustable Parameters
1. Distance between stimulating and recording electrodes. In  basic_analysis_pub.m, line 16. This value has to be adjusted for each individual fish.
2. Number of sweeps. In basic_analysis_pub.m, line 20.
3. Filter frequency. Can be adjusted  in basic_analysis_pub.m, line 23.
4. The time of stimulus artifact beginning (seconds). Can be adjusted in basic_analysis_pub.m, line 28.
5. Voltage threshold to pass to be cosidered as an action potential. Can be adjusted in parse_pub.m, line 14.

1 has to be adjusted for each fish, while 2, 3, 4 and 5 should be set prior to the first analysis and do not need to be altered later, as long as the .abf settings stay the same.

#### Instructions

1. Make sure that the folder you running from is set as current directory.
2. Run basic_analysis_pub.m
3. Select one or more .abf files for analysis when prompted from the same fish. Files from different fish have to be run separately.

#### Expected Output
If a single file was selected, the output will be an excel file AP velocity_your filename.xlsx. If mutiple files were selected, the output excel spreadsheet will be named AP velocity_your first filename_and_more.xlsx.

The final spreadsheet produced has sheets for latency, velocity, AP sizes, and action potential half-width in their own individual sheets from each sweep (rows 1-10). Values from different .abf files  will end up in the same excel sheet, but will have different columns with filenames as headers.

In sheet 'Velocity' the value entered as the distance between stimulating and recording electrode is also reported in meters.

The output excel file location will be the same as the origin of the files selected for the analysis (any folder).

#### Sample Files
The distance value is 1138 for Fish 1 and 1209 for Fish 2.

#### Contact
Feel free to get in touch with me skotuke@gmail.com with any questions or problems.
