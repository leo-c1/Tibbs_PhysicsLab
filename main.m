function main()
    fig = figure('Name', 'Voltage Lab', 'NumberTitle', 'off', 'MenuBar', 'figure', 'ToolBar', 'figure', 'Position', [100, 100, 800, 600]);

    % create axes
    ax = axes('Parent', fig, 'Position', [.3 .1 .65 .8]);
    %buttons
    loadBtn = uicontrol('Style', 'pushbutton', 'String', 'Load CSV', 'Position', [20, 550, 100, 30], 'Callback', {@loadFile, ax});
    vectorBtn = uicontrol('Style', 'pushbutton', 'String', 'Plot Vectors', 'Position', [20, 500, 100, 30], 'Callback', {@plotVectors, ax});
    coordBtn = uicontrol('Style', 'pushbutton', 'String', 'Get Coordinates', 'Position', [20, 450, 100, 30], 'Callback', {@getCoordinates, ax});
    plotGraphBtn = uicontrol('Style', 'pushbutton', 'String', 'Plot Graph', 'Position', [20, 400, 100, 30], 'Callback', {@plotGraph, ax});
    clearGraphBtn = uicontrol('Style', 'pushbutton', 'String', 'Clear Graph', 'Position', [20, 350, 100, 30], 'Callback', {@clearGraph, ax});

    % store axes in userdata
    set(fig, 'UserData', ax);
end

function loadFile(source, eventdata, ax)
    [fileName, filePath] = uigetfile({'*.csv'}, 'Select CSV File');
    if fileName
        fullPath = fullfile(filePath, fileName);
        try
            data = csvread(fullPath);
            set(ax, 'UserData', data);
        catch
            errordlg('Error loading file', 'File Error');
        end
    end
end

function plotGraph(source, eventdata, ax)
    data = get(ax, 'UserData');
    if isempty(data)
        errordlg('No data to plot', 'Plot Error');
        return;
    end

    % plot
    axes(ax);
    surf(ax, data);
    title(ax, 'Surface Plot');
    xlabel(ax, 'X');
    ylabel(ax, 'Y');
    zlabel(ax, 'Z');
end

function clearGraph(source, eventdata, ax)
    cla(ax); % clear axes
end

function plotVectors(source, eventdata, ax)
    % get data from userdata
    data = get(ax, 'UserData');

    if isempty(data)
        errordlg('No data to plot vectors for', 'Plot Error');
        return;
    end

    %plot in x y
    [X, Y] = meshgrid(1:size(data, 2), 1:size(data, 1));
    Z = zeros(size(data)); % Vectors start from the XY plane

    % calculate gradients
    [dx, dy] = gradient(data);
    dz = zeros(size(dx));

    % plot vectors
    hold(ax, 'on');
    quiver3(ax, X, Y, Z, dx, dy, dz, -2);
    hold(ax, 'off');N
end

function getCoordinates(source, eventdata, ax)
    % some black magic idk
    [x, y] = ginput(1);

    data = get(ax, 'UserData');
    [X, Y] = meshgrid(1:size(data, 2), 1:size(data, 1));

    z = interp2(X, Y, data, x, y);

    if isnan(z)
        zStr = 'NA';
    else
        zStr = sprintf('%.2f', z);
    end

    msgbox(sprintf('X: %.2f, Y: %.2f, Z: %s', x, y, zStr), 'Coordinates');
end
main();

