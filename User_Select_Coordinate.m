%% Select a co-ordinate from Monitor_Data or Image
%:Inputs:
% - Data (Structure / Numeric Array) ; Monitor_Data structure or raw data
% - Selection_Parameters
% - Data_Name (char array) ; Name of the field in Monitor_Data.Data.([INSERT NAME HERE]) to show as selection image
%:Outputs:
% - [X, Y] (double) ; co-ordinates of selected pixel
function [X, Y] = User_Select_Coordinate(Data, Selection_Parameters)
    %% Input handling
    Continue = false;
    %Check parameters set
    if(exist('Selection_Parameters','var'))
        %validate and read in parameters from structure holding parameter values
        [Struct_Var_Value, Struct_Var_Valid] = Verify_Structure_Input(Selection_Parameters, 'Image_Field', '');
        if(Struct_Var_Valid)
            Image_Field = Struct_Var_Value;
        end
        [Struct_Var_Value, Struct_Var_Valid, Struct_Var_Default] = Verify_Structure_Input(Selection_Parameters, 'Relative_Center', false);
        if(Struct_Var_Valid || Struct_Var_Default)
            Relative_Center = Struct_Var_Value;
        end
    end
    %Raw input handling
    switch nargin
        case 0
            %Invalid input
            disp("No input provided");
        case {1, 2}
            if(isstruct(Data))
                %% Verify structure matches Monitor_Data format
                Fieldnames = fieldnames(Data);
                Required_Fieldnames = {'Data';'Date';'Detector_Stats';'Directory';'Energy';'Photons';'XData';'YData';'ZData';'component';'filename';'signal';'statistics';'title';'type'};
                Common_Fields = intersect(Fieldnames, Required_Fieldnames);
                Required_Fieldnames_Field_Check = length(setdiff(Common_Fields, Required_Fieldnames));
                Fieldnames_Field_Check = length(setdiff(Common_Fields, Fieldnames));
                if((Required_Fieldnames_Field_Check == 0) && (Fieldnames_Field_Check == 0))
                    %Structure matches
                    if(exist('Image_Field','var'))
                        if(ischar(Image_Field) || isstring(Image_Field))
                            if(isfield(Data.Data, Image_Field))
                                Data = Data.Data.(Image_Field);
                                Continue = true;
                            end
                        end
                    else
                        % default values to try
                        Default_Data_Names = {'I', 'I_Err', 'N'};
                        %Structure matches
                        for Default_Data_Name_Attempt = 1:length(Default_Data_Names)
                            Image_Field = Default_Data_Names{Default_Data_Name_Attempt};
                            if(ischar(Image_Field) || isstring(Image_Field))
                                if(isfield(Data.Data, Image_Field))
                                    Data = Data.Data.(Image_Field);
                                    Continue = true;
                                    disp(strcat("Using default Image_Field: ", Image_Field));
                                    break;
                                end
                            end
                        end
                    end
                end
            elseif(isnumeric(Data))
                %% ensure data is at least 2x2 array if an image is provided
                if((size(Data,1) > 1) && (size(Data,2) > 1))
                    Continue = true;
                end
            else
                %Invalid input
            end
        otherwise
            disp("Unknown input provided");
    end
    %% Default values for X and Y
    X = Inf;
    Y = Inf;
    %% If inputs are sufficient
    if(Continue)
        %% remove the bottom and top 1% of data
        Clim.Upper = prctile(Data(:), 99);
        Clim.Lower = prctile(Data(:), 1);
        Data(Data > Clim.Upper) = NaN;
        Data(Data < Clim.Lower) = NaN;
        %% Display figure
        %select figure for selection image
        Selection_Figure = figure();
        %display image
        imagesc(Data);
        %display title and ensure image is the correct orientation
        title('Select the centre of the Halo Profile');
        set(gca, 'YDir',' normal');
        %assume figure exists
        Selection_Valid = false;
        %get image sizes in X and Y
        Image_Size = size(Data);
        Width = Image_Size(1);
        Height = Image_Size(2);
        %Attempt co-ordinate selection
        while(~Selection_Valid && ishandle(Selection_Figure))
            %% Get selection points
            try
                [X, Y] = ginput;
            catch
                 Selection_Valid = true;
            end
            %% Validate selection
            if(length(X) > 1)
                X = X(end);
            end
            if(length(Y) > 1)
                Y = Y(end);
            end
            %% Check valid X and Y selection
            if((X <= Width) && (Y <= Height))
                Selection_Valid = true;
            end
        end
        %close figure when done
        close(Selection_Figure);
    end
    %% Output validation
    if(X == Inf)
        X = 0;
        disp("Invalid selection; defaulting X to 0");
    end
    if(Y == Inf)
        Y = 0;
        disp("Invalid selection; defaulting Y to 0");
    end
    %% If adjusting co-ordinates to be relative from the centre of the image
    if(Relative_Center)
        %Get center co-ordinates
        Center_X = Width / 2;
        X = X - Center_X;
        Center_Y = Height / 2;
        Y = Y - Center_Y;
    end
end