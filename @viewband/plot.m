function [obj, varargout] = plot(obj,varargin)
%@viewband/plot Plot function for viewband object.
%   OBJ = plot(OBJ) creates a raster plot of the neuronal
%   response.
%
%   Examples (Array Level):
%   vb = ProcessLevel(viewband,'Levels','Array');
%   InspectGUI(vb)
%
%   bs = ProcessLevel(hidata,'Levels','Array','FileName','bandfield.mat');
%   InspectGUI(bs,'Array','UseGMR','Objects',{'viewband',{'Heatmap','gamma'}})

Args = struct('LabelsOff',0,'GroupPlots',1,'GroupPlotIndex',1,'Color','b', ...
		'Channel',0, 'Array',0, 'Session',0, 'Day',0, ...
        'Heatmap','', ...
		'ReturnVars',{''}, 'ArgsOnly',0);
Args.flags = {'LabelsOff','ArgsOnly','Channel','Array','Session','Day'};
[Args,varargin2] = getOptArgs(varargin,Args);

% if user select 'ArgsOnly', return only Args structure for an empty object
if Args.ArgsOnly
    Args = rmfield (Args, 'ArgsOnly');
    varargout{1} = {'Args',Args};
    return;
end

% current figure
g = gcf;
% axis off
% delete(findall(findall(gcf,'Type','axe'),'Type','text')) %clear texts

if(~isempty(Args.NumericArguments))
	% plot one data set at a time

    n = Args.NumericArguments{1};
    
	if(Args.Channel || Args.Array || Args.Session || Args.Day) % when does this happen?
		if(Args.Channel)
		elseif(Args.Array)
		elseif(Args.Session)
		elseif(Args.Day)
        end
        
		if(~Args.LabelsOff)
% 			xlabel('')
% 			ylabel('')
        end
    else
        
        % Loading mat file
        sidx = find(obj.data.ChannelIndex>=n);
		sdstr = get(obj,'SessionDirs');
		cwd = pwd;
		sidx1 = sidx(1) - 1;
		cd(sdstr{sidx1})
        bf = load('bandfield.mat');
		cd(cwd)

        % Alpha power over time
        subplot(2,3,1)
        aph = permute(bf.alphaTime,[3 2 1])';
        plot(aph,'k'); hold on;
        plot([7 7],ylim,'b'); %trigger identity
        if (~Args.LabelsOff)
            title('Average alpha power');
            xlabel('Time bins');
            temp = ylim; text(0,1.05*temp(2),'cue offset','Color','blue');
        end
        % Alpha power heat map
        subplot(2,3,4)
        imagesc(bf.alphaPowerSpec,'AlphaData',~isnan(bf.alphaPowerSpec))
        set(gca,'color',[0 0 0],'xtick',[],'ytick',[]);
        colorbar; hold on
        for i = 1:size(bf.posterPosition,1) % poster positions
            plot(bf.posterPosition(i,1),bf.posterPosition(i,2),'r.','MarkerSize',40);
        end
        if (~Args.LabelsOff)
            title(strcat('SI: ',num2str(round(bf.alpha_locSI,2)),' p: ',num2str(bf.alphaPValue)));
        end
        
        % Gamma power over time
        subplot(2,3,2)
        plot(bf.gammaTime,'k'); hold on;
        plot([7 7],ylim,'b'); %trigger identity
        if (~Args.LabelsOff)
            title('Average gamma power');
            xlabel('Time bins');
            temp = ylim; text(0,1.05*temp(2),'cue offset','Color','blue');
        end
        % Gamma power heat map
        subplot(2,3,5)
        imagesc(bf.gammaPowerSpec,'AlphaData',~isnan(bf.gammaPowerSpec))
        set(gca,'color',[0 0 0],'xtick',[],'ytick',[]);
        colorbar; hold on
        for i = 1:size(bf.posterPosition,1) % poster positions
            plot(bf.posterPosition(i,1),bf.posterPosition(i,2),'r.','MarkerSize',40);
        end
        if (~Args.LabelsOff)
            title(strcat('SI: ',num2str(round(bf.gamma_locSI,2)),' p: ',num2str(bf.gammaPValue)));
        end
        
        % Theta power over time
        subplot(2,3,3)
        plot(bf.thetaTime,'k'); hold on;
        plot([7 7],ylim,'b'); %trigger identity
        if (~Args.LabelsOff)
            title('Average theta power');
            xlabel('Time bins');
            temp = ylim; text(0,1.05*temp(2),'cue offset','Color','blue');
        end
        % Theta power heat map
        subplot(2,3,6)
        imagesc(bf.thetaPowerSpec,'AlphaData',~isnan(bf.thetaPowerSpec))
        set(gca,'color',[0 0 0],'xtick',[],'ytick',[]);
        colorbar; hold on
        for i = 1:size(bf.posterPosition,1) % poster positions
            plot(bf.posterPosition(i,1),bf.posterPosition(i,2),'r.','MarkerSize',40);
        end
        if (~Args.LabelsOff)
            title(strcat('SI: ',num2str(round(bf.theta_locSI,2)),' p: ',num2str(bf.thetaPValue)));
        end
        
        % Title (channel #)
        if (~Args.LabelsOff)
            [bin, chn] = nptFileParts(sdstr{sidx1});
            delete(findall(gcf,'type','annotation'))
            annotation('textbox', [0 0.9 1 0.1], ...
                        'String', chn, ...
                        'FontSize', 16,...
                        'EdgeColor', 'none', ...
                        'HorizontalAlignment', 'center')
        end

%         f = openfig('bandfield.fig','invisible');
%         
%         if(~strcmp(Args.Heatmap,''))
%             
%             ax = findobj(f,'type','axes');
%             
%             if(strcmp(Args.Heatmap,'gamma')||strcmp(Args.Heatmap,'alpha')||strcmp(Args.Heatmap,'theta'))
%                 for i = 1:length(ax)
%                     if (length(ax(i).Title.String)>=13)
%                         if (strcmp(ax(i).Title.String(9:13),Args.Heatmap))
%                             newf =copyobj(ax(i), g);
%                             set(newf,'position','default');
%                         end
%                     end
%                 end
%             else
%                 disp('wrong input to Heatmap or the subplot titles have changed from 20 June 2018. Please edit line 88')
%             end
%         else
%             copyobj(allchild(f),g);
%             close(f)
%             cd(cwd)
%         end
    end
else
    if(~strcmp(Args.Heatmap,''))
        if strcmp(Args.Heatmap,'gamma')
            % Gamma power heat map
            gph = permute(obj.data.gammaPowerSpec,[3 2 1])';
            pp = permute(obj.data.posterPosition,[3 2 1])';
            imagesc(gph,'AlphaData',~isnan(gph))
            set(gca,'color',[0 0 0],'xtick',[],'ytick',[]);
            colorbar; hold on
            for i = 1:size(pp,1) % poster positions
                plot(pp(i,1),pp(i,2),'r.','MarkerSize',40);
            end
            if (~Args.LabelsOff)
                title(strcat('SI: ',num2str(round(obj.data.gamma_locSI,2)),' p: ',num2str(obj.data.gammaPValue)));
            end
        elseif strcmp(Args.Heatmap,'alpha')
            % Alpha power heat map
            aph = permute(obj.data.alphaPowerSpec,[3 2 1])';
            pp = permute(obj.data.posterPosition,[3 2 1])';
            imagesc(aph,'AlphaData',~isnan(aph))
            set(gca,'color',[0 0 0],'xtick',[],'ytick',[]);
            colorbar; hold on
            for i = 1:size(pp,1) % poster positions
                plot(pp(i,1),pp(i,2),'r.','MarkerSize',40);
            end
            if (~Args.LabelsOff)
                title(strcat('SI: ',num2str(round(obj.data.alpha_locSI,2)),' p: ',num2str(obj.data.alphaPValue)));
            end
        elseif strcmp(Args.Heatmap,'theta')
            % Theta power heat map
            tph = permute(obj.data.thetaPowerSpec,[3 2 1])';
            pp = permute(obj.data.posterPosition,[3 2 1])';
            imagesc(tph,'AlphaData',~isnan(tph))
            set(gca,'color',[0 0 0],'xtick',[],'ytick',[]);
            colorbar; hold on
            for i = 1:size(pp,1) % poster positions
                plot(pp(i,1),pp(i,2),'r.','MarkerSize',40);
            end
            if (~Args.LabelsOff)
                title(strcat('SI: ',num2str(round(obj.data.theta_locSI,2)),' p: ',num2str(obj.data.thetaPValue)));
            end
        else
            disp('Invalid Heatmap Input: Choose between alpha, gamma and theta')
        end
    else
        aph = permute(obj.data.alphaTime,[3 2 1])';
        gph = permute(obj.data.gammaTime,[3 2 1])';
        tph = permute(obj.data.thetaTime,[3 2 1])';
        plot(aph,'r'); hold on;
        plot(gph,'g');
        plot(tph,'b');
        plot([7 7],ylim,'b'); %trigger identity
        if (~Args.LabelsOff)
            title('Average \alpha,\gamma,\theta power');
            xlabel('Time bins');
            temp = ylim; text(0,1.05*temp(2),'cue offset','Color','blue');
            legend('\alpha','\gamma','\theta')
        end
    end
end


RR = eval('Args.ReturnVars');
lRR = length(RR);
if(lRR>0)
    for i=1:lRR
        RR1{i}=eval(RR{i});
    end 
    varargout = getReturnVal(Args.ReturnVars, RR1);
else
    varargout = {};
end
