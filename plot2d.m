function plot2d(df)
    global plength lengthv lengthh
    
    %% ====== find index ====== %%
    [Value, Index] = max(df);
    [mValue, mIndex] = max(Value);
    hindex = Index(mIndex);
    
    %% ====== set x & y ====== %%
    xv = linspace(0, size(df,1), size(df,1));
    xvtheta = atand((size(df,1)/2-xv)*plength/lengthv);
    yv = (df(:,mIndex))*(1/mValue);
    xh = linspace(0, size(df,2), size(df,2));
    xhtheta = atand((xh-size(df,2)/2)*plength/lengthh);
    yh = (df(hindex,:))*(1/mValue);

    %% ====== Gaussian fitting ====== %%
    f1 = fit(xvtheta.', yv, 'gauss1');
    f2 = fit(xhtheta.', yh.', 'gauss1');

    %% ====== Vertical divergence angle ====== %%
    vfitdata = f1(xvtheta);
    [pks1, locs1] = findpeaks(vfitdata);
    vpks = pks1/2;
    for i = 2:size(yv,1)
        xv1 = xvtheta(i-1);
        yv1 = vfitdata(i-1);
        xv2 = xvtheta(i);        
        yv2 = vfitdata(i);
        if (yv1-vpks)*(yv2-vpks)<=0
            if (yv1-vpks) < (yv2-vpks)
                angle1 = round(xv2, 4);
                fprintf('angle1 : %f \n', angle1);
            else
                angle2 = round(xv1, 4);
                fprintf('angle2 : %f \n', angle2);
            end
        end
    end
    vd_angle = round(abs(angle1 - angle2),1);
    fprintf('vertical divergence angle = %f \n', vd_angle)
    vdx = linspace(angle1, angle2, vd_angle);
    vdy = ones(size(vdx,2),1)*vpks;

    vdlength = round(lengthv*tand(vd_angle),1);

    %% ====== Horizontal divergence  angle ====== %%
    hfitdata = f2(xhtheta);    
    [pks2, locs2] = findpeaks(hfitdata);    
    hpks = pks2/2;
    for i = 2:size(yh,2)
        xh1 = xhtheta(i-1);        
        yh1 = hfitdata(i-1);
        xh2 = xhtheta(i);
        yh2 = hfitdata(i);
        if (yh1-hpks)*(yh2-hpks)<=0
            if (yh1-hpks) < (yh2-hpks)
                angle3 = round(xh1, 4);
                fprintf('angle3 : %2f \n', angle3);
            else
                angle4 = round(xh2, 4);
                fprintf('angle4 : %2f \n', angle4);
            end
        end
    end
    hd_angle= round(abs(angle3 - angle4),1);
    fprintf('horizontal divergence angle = %f \n', hd_angle)
    hdx = linspace(angle3, angle4, 1000);
    hdy = ones(size(hdx,2),1)*hpks;

    hdlength = round(lengthh*tand(hd_angle),1);

    %% ====== Draw vertical plot ====== %%
    ax2 = subplot(2,4,4);
    set(ax2, 'position',[0.65 0.55 0.3 0.35])
    plot(f1, 'r-', xvtheta, yv, 'b.')
    hold on
    plot(vdx, vdy, 'g-', 'LineWidth', 2)
    legend('data', 'fitting', 'divergence angle')
    text((angle1+angle2), vpks-0.03, string(vd_angle), FontSize=15)
    xlim([(angle1+angle2)/2-10 (angle1+angle2)/2+10])
    ylim([-0.1 1.1])
    xlabel('Vertical angle (°)', FontSize=18)
    ylabel('Normalized intensity')
    title('Vertical direction (θ)', FontSize=20, FontWeight='bold')
    set(gca, 'FontSize', 13)
    hold off

    %% ====== Draw horizontal plot ====== %%
    ax3 = subplot(2,4,8);
    set(ax3,'position',[0.65 0.08 0.3 0.35])
    plot(f2, 'r-', xhtheta, yh, 'b.')
    hold on
    plot(hdx, hdy, 'g-', 'LineWidth', 2)
    legend('data', 'fitting', 'divergence angle')
    text((angle3+angle4)/2-hd_angle/2, hpks-0.1, string(hd_angle), FontSize=15)
    xlim([(angle3+angle4)/2-vd_angle (angle3+angle4)/2+vd_angle])
    ylim([-0.1 1.1])
    xlabel('Horizontal angle (°)', FontSize=18)
    ylabel('Normalized intensity')
    title('Horizontal direction (Ψ)', FontSize=20, FontWeight='bold')
    set(gca, 'FontSize', 13)
    hold off

    %% ====== Print angle and length ====== %%
    ax4 = subplot(2,4,1);
    set(ax4,'position',[0.001 0.75 0.05 0.05])
    plot(0,0)
    grid off
    axis off
    hold on
    len = strcat('Distance = ', string(lengthv), ' mm');
    vlen = strcat('Vertical FWHM Beam width = ', string(round(vdlength,2)), ' mm');
    vd = strcat('Vertical divergence angle = ', string(vd_angle), '°');
    hlen = strcat('Horizontal FWHM Beam width = ', string(hdlength), ' mm');
    hd = strcat('Horizontal divergence angle = ', string(hd_angle), '°');
    str1 = vlen + newline + newline + vd;
    str2 = hlen + newline + newline + hd;
    text(-0.5, 5, len, fontsize = 14, EdgeColor = 'k',FontWeight='bold')
    text(-0.5, 1, str1, fontsize = 14, EdgeColor = 'k', FontWeight='bold')
    text(-0.5, -4, str2, fontsize = 14, EdgeColor = 'k', FontWeight='bold')
end