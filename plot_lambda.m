
lamf = load('sub-NIH_cortex8k_ceb5k_lambda.mat');

lam = lamf.var;

lam2 = lam ./ sum(lam) *100;


Attack_Rate = [1 2 5 9 15 20 25 30 35 40 45];

Average_Packets  = lam2;
Interval = 1:length(lam2);

plot(Interval,Average_Packets,'k');

hold on;

scatter(Interval(:,1:8),Average_Packets(1:8,:),'filled');

scatter(Interval(:,9:end),Average_Packets(9:end,:),'filled','k');

xlabel('Gradient number');
ylabel('Varience explained by gradient');
%set(gca,'xticklabel',[])
%set(gca,'xtick',[])

ax = gca;
ax.YAxis.TickDirection = 'out';

box off
ax2 = axes('Position',get(gca,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
set(ax2,'YTick', []);
set(ax2,'XTick', []);
box on


hold off;