function [track] = importTrack(N, tf)
%importTrack - returns the track constraints
%   input trackName
%   output:
%       track - Nx3x2 array where 
%           axis 1 is progress through the track
%           axis 2 is x/y/z coords of track boundary point
%           axis 3 is left/right boundaries,

    %% Toy problem
    t = linspace(0,tf,N)';
    phi = t/tf*2*pi;
    h = 2*sin(phi)*0.5;

    roundness = 10;
    r = 300*(1./(cos(phi).^roundness + sin(phi).^roundness)).^(1/roundness);
    pathcenter = [r.*cos(phi),r.*sin(phi)];
    theta = atan2(gradient(r.*sin(phi)),gradient(r.*cos(phi)));
    [v,i] = max(abs(diff(theta)));
    theta(i+1:end) = theta(i+1:end)+2*pi;
    path = pathcenter;
    totalD = sum(sqrt(gradient(path(:,1)).^2+gradient(path(:,2)).^2));
    lmin = -30;
    lmax = 30;

    % %% Real race track data
    % data = importposdata('position_data.csv');
    % % data = flipud(data); % if it's going the wrong direction (CCW)
    % cut = 950;
    % convlat = 111e3;
    % convlong = 111e3;
    % long = data.latitudedegrees;
    % long = smooth(long,50);
    % long = long(cut:(end-cut),1)*convlong;
    % lat = data.longitudedegrees; % so that drives counterclockwise
    % lat = smooth(lat,50);
    % lat = lat(cut:(end-cut),1)*convlat;
    % alt = data.altitudemeters;
    % alt = smooth(alt,100);
    % alt = alt(cut:(end-cut),1);
    % h = alt;
    % toCut = find(abs(gradient(long))<.01 & abs(gradient(lat))<0.01);
    % long(toCut) = [];
    % lat(toCut) = [];
    % h(toCut) = [];
    % num = size(h,1);
    % tf = 210;
    % t = linspace(0,tf,num)';
    % 
    % long = long-mean(long);
    % lat = lat-mean(lat);
    % 
    % dlat = gradient(lat);
    % dlong = gradient(long);
    % totalD = sum(sqrt(dlat.^2+dlong.^2));
    % d = cumsum(sqrt(dlat.^2+dlong.^2));
    % theta = atan2(dlong,dlat);
    % [v,i] = max(abs(diff(theta)));
    % theta(i+1:end) = theta(i+1:end)-2*pi;
    % 
    % 
    % %% define vars
    % 
    % N = 200;
    % tvals = linspace(0,210,N)';
    % dVals = totalD/N*(0:(N-1));
    % x = spline(d,lat,dVals)';
    % y = spline(d,long,dVals)';
    % theta = spline(d,theta,dVals)';
    % smooth(theta,100);
    % h = spline(d,h,dVals)';
    % t = tvals;
    % d = dVals;
    % vhiniteffect = (sqrt((max(h)-h)./(max(h)-min(h))))*sqrt(9.81)*2;
    % v = totalD/tf.*ones(N,1) + vhiniteffect-mean(vhiniteffect);
    % pathcenter = [x,y];
    % path = pathcenter;
    % 
    % lmin = -8;
    % lmax = 8;
    
    track = zeros(N,3,2);
    track(:,1:2,1) = pathcenter+lmin*[-sin(theta),cos(theta)];
    track(:,1:2,2) = pathcenter+lmax*[-sin(theta),cos(theta)];
    track(:,  3,:) = [h,h];
end