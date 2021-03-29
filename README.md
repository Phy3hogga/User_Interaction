# User Interaction

Matlab scripts that provide some simple quality of life functions while providing simple user input. This is a supporting submodule for other repositories.

### Functions
#### Announce_Finish.m
Plays a stock matlab sound, designed for making clear that a script running in the background that takes a prolonged period of time to finish execution has ended. Allows for a reduced frequency of checking the progress of the script.
```matlab
Announce_Finish();
```

#### User_Select_Coordinate.m
Selects a user specified co-ordinate from an image within a structure.
```matlab
%Random data
Structure.Data.I = rand(50,50);
%Field I containing the data
Selection_Parameters.Image_Field = 'I';
%If the co-ordinate selection is absolute or relative to the centre of the image
Selection_Parameters.Relative_Center = true;
%Get X, Y co-ordinates of the user selection (interactive window)
[X, Y] = User_Select_Coordinate(Data, Selection_Parameters)
```
## Built With

* [Matlab R2018A](https://www.mathworks.com/products/matlab.html)
* [Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)

## References
* **Alex Hogg** - *Initial work* - [Phy3hogga](https://github.com/Phy3hogga)