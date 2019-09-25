# MEP Tools
 Scripts and functions for extracting, comparing and analysing MEP ECG recordings from Visor2, Keypoint and the MagPro MEP monitor

Very much a work in progress

Notes on output file formats from different MEP recorders (Keypoint, MagPro, Visor2)

The main script is import MagPro_Visor2.m, which is divided into cells which are fairly self-explanatory. The first 3 cells contain import code for the 3 different formats of MEP file, which can then be plotted and processed by the following cells.

The scripts import_keypoint.m and import_ASA_Visor2.m also contain some potentially useful code, which may be organized and commented someday.

MagPro

MagPro output is stored in CSV files, the format of these can be seen by opening one of the files in a spreadsheet program such as Excel. These files are imported into MATLAB by the function MagProImport.m. The MagPro files can contain 1 - 10 MEPs, I think MagProImport can handle all possibilities, but I haven't tested it very thoroughly.

Visor2

Visor2 output is stored in .cnt, evt and .trg files that can be imported by use of the MATLAB import tools available at http://download.ant-neuro.com/matlab/ (see also https://www.ant-neuro.com/support/supporting-documentation-and-downloads). These have been included in the repository in the libeep... folder. The structure returned by read_eep_cnt contains trigger information that can be used to extract MEPs.

Note that the Visor2 output is minimally filtered in comparison to e.g. the Keypoint output, and therefore you may wish to perform some filtering on it before extracting the MEPs. This can be performed with the ANT Neuro "ASA" program that is on the Visor2 computer, abeit with a caveat. If you try to perform a band pass or band-stop filter via the ASA interface it will not work! To get around this problem Katharina at eemagine created a script ('ASA filter script.vbs') that performs a band pass filter between 0.3 and 1000Hz (equivalent to a 0.3Hz high-pass filter), and a band-stop / notch filter at 50Hz, to remove the mains oscillation. The output for this will be .cnt, .evt and .trg files in a '\output' directory. The filter script can be modified by adding or deleting lines with the following pattern: 'CurrentItem.FFTFilterData Array(".\Output"), "EEProbe", 'higpassfrequency', 'lowpassfrequency', 'steepness (24, 36db)', 0

Keypoint

Keypoint MEPs are saved as txt files. Files can be imported with the native MATLAB function "importdata". Note that the import code in import_MagPro_Visor2_Keypoint.m requires the sampling rate to be set as a parameters. The default rate is 48000Hz, but sampling rate and filters can be set in the Keypoint software.

The folders GrantMagProMEPs and GrantVisorMEPs contain MEPs recorded from Grant at approximately the same time with the same stimulator, for comparison. Similar with VladimirMagProMeps and VladimirVisorMeps. The folder test_001_x_No_Name folder contains example Keypoint MEP output.
