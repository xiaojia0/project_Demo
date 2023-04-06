

%plot the sh

sh = load('/mnt/silhouette.mat');
sh=sh.all_silhouette;

figure
plot(sh)

xlabel(' Number of clusters');

ylabel('Silhouette Coefficient');

title('Spectral clustering');

set(gca,'XTick',[0:2:50]);

grid on;
