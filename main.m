function main()
    % Create the main window
    fig = figure('Name', 'Voltage Lab', 'NumberTitle', 'off', 'MenuBar', 'figure', 'ToolBar', 'figure', 'Position', [100, 100, 800, 600]);

    % Create axes for plotting
    ax = axes('Parent', fig, 'Position', [.3 .1 .65 .8]);

    % Add a button to load CSV files
    loadBtn = uicontrol('Style', 'pushbutton', 'String', 'Load CSV', 'Position', [20, 550, 100, 30], 'Callback', {@loadFile, ax});

    % Add a button to plot vectors
    vectorBtn = uicontrol('Style', 'pushbutton', 'String', 'Plot Vectors', 'Position', [20, 500, 100, 30], 'Callback', {@plotVectors, ax});

    coordBtn = uicontrol('Style', 'pushbutton', 'String', 'Get Coordinates', 'Position', [20, 450, 100, 30], 'Callback', {@getCoordinates, ax});

    % Store the axes in UserData of the figure for easy access
    set(fig, 'UserData', ax);
end

function loadFile(source, eventdata, ax)
    [fileName, filePath] = uigetfile({'*.csv'}, 'Select CSV File');
    if fileName
        fullPath = fullfile(filePath, fileName);
        try
            % Load data
            data = csvread(fullPath);

            % Plot data as a surface
            axes(ax);
            surf(ax, data);
            title(ax, 'Surface Plot');

            % Labeling the axes
            xlabel(ax, 'X');  % Label for X-axis
            ylabel(ax, 'Y');  % Label for Y-axis
            zlabel(ax, 'Z');  % Label for Z-axis
            % Store the data in UserData of the axes
            set(ax, 'UserData', data);
        catch
            errordlg('Error loading file', 'File Error');
        end
    end
end

function plotVectors(source, eventdata, ax)
    % Get the data from the UserData of the axes
    data = get(ax, 'UserData');

    if isempty(data)
        errordlg('No data to plot vectors for', 'Plot Error');
        return;
    end

    % Generate X and Y coordinates
    [X, Y] = meshgrid(1:size(data, 2), 1:size(data, 1));
    Z = zeros(size(data)); % Vectors start from the XY plane

    % Calculate the gradient (or any other vector field)
    [dx, dy] = gradient(data);
    dz = zeros(size(dx));  % No vertical component

    % Plot vectors using quiver3
    hold(ax, 'on');
    quiver3(ax, X, Y, Z, dx, dy, dz, -2);  % Adjust the scale factor as needed
    hold(ax, 'off');N
end

function getCoordinates(source, eventdata, ax)
    % Wait for a mouse click on the axes, then get the point
    [x, y] = ginput(1);

    % Get the data and create a matching grid
    data = get(ax, 'UserData');
    [X, Y] = meshgrid(1:size(data, 2), 1:size(data, 1));

    % Interpolate the Z value
    z = interp2(X, Y, data, x, y);

    % Check if z is NaN (happens if (x, y) is outside the grid)
    if isnan(z)
        zStr = 'NA';
    else
        zStr = sprintf('%.2f', z);
    end

    % Display the coordinates
    msgbox(sprintf('X: %.2f, Y: %.2f, Z: %s', x, y, zStr), 'Coordinates');
end

% Run the application
main();

