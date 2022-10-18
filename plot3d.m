function plot3d(df)
    x1 = linspace(0, 1, size(df,1));
    x2 = linspace(0, 1, size(df,2));
    
    [X,Y] = meshgrid(x2,x1);
    fig1 = figure(1);
    set(fig1, 'position', [150 80 1600 900])
    ax1 = subplot(2,4,[2,3,6,7]);
    set(ax1, 'position', [0.287 0.05 0.3 0.9])
    surf(X, Y, df)
    view(2)
    colormap('gray')
    shading interp
    grid off
    axis off
    colorbar
end