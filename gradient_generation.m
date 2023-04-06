       % load the surface
        
        g1=gifti('rh.pial_scale008_shifti_sm.surf.gii');
    
         gg2=gifti('Tmeansub-IONm01_ses-01_LR.func.gii');
        
        roinum = 5000;  % num of roi
        vertex = 286308;
       

        %  load label
       
        labelf = load('label_5k.mat');
        label = labelf.idx;


        %read data
        for sub = 1:39
 
            s1 = 'sub-*m';
            s2 = num2str(sub);
            s3 = '*';
            s4 = 'func.gii';
            session_name = strcat(s1,s2,s3,s4);

            session_ls = dir(session_name);  %%% find the smooth* files

            session_num = length(session_ls);  %%%
            
            cor_ceb_allses = zeros(roinum,roinum);
            
            for ses = 1:session_num
                
                    dataname = session_ls(ses).name ;
                    gg1 = gifti(dataname); 

                    surfdata=gg1.cdata;


%                 h = plot_hemispheres(label, g1);
%                 
%                 colormap(h.handles.figure,lines(num + 1))

               % mean the surf data

                timelength = size(surfdata,2);

                mean_surfdata = zeros(roinum,timelength);


                for r = 1:roinum   

                    mean_surfdata(r,:) = mean(surfdata(find(label==r),:));

                end



                % cor and mean the cor


                mean_surfdata = mean_surfdata';

                cor_ceb = corrcoef(mean_surfdata);

               % cor_ceb(isnan(cor_ceb)) = 0.00001;

                cor_ceb_allses = cor_ceb_allses + cor_ceb;
        
            end
            
            
               cor_ceb_mean = cor_ceb_allses ./ session_num ;
        
                % save the cor_ceb_mean 
                                 
                s5 = 'sub-m';
                s6 = num2str(sub);
                s7 = '_mean_cor_5k.mat';
                
                savename=strcat(s5,s6,s7);
                
                save(savename,'cor_ceb_mean','-v7.3');
                % map

                 gm = GradientMaps();

                 gm = gm.fit(cor_ceb_mean);

%                plot
%                plot_hemispheres(gm.gradients{1}(:,1:2),g1,'parcellation', label);
                
   
                % plot the component 
                %scree_plot(gm.lambda{1});
        
               % gradient_in_euclidean(gm.gradients{1}(:,1:3));
               % gradient_in_euclidean(gm.gradients{1}(:,1:2),g1,label);
                

                %save gradient

                label2=label;
                label3=label;
                label4=label;
                label5=label;
                label6=label;
                label7=label;
                label8=label;
                label9=label;
        

                for rr = 1:roinum
                    label2(label2==rr)=gm.gradients{1}(rr,1);
                    label3(label3==rr)=gm.gradients{1}(rr,2);
                    label4(label4==rr)=gm.gradients{1}(rr,3);
                    label5(label5==rr)=gm.gradients{1}(rr,4);
                    label6(label6==rr)=gm.gradients{1}(rr,5);
                    label7(label7==rr)=gm.gradients{1}(rr,6);
                    label8(label8==rr)=gm.gradients{1}(rr,7);
                    label9(label9==rr)=gm.gradients{1}(rr,8);
                end

                
                s5 = 'sub-m';
                s6 = num2str(sub);
                s7 = '_gradient1_5k.func.gii';
                s8 = '_gradient2_5k.func.gii';
                s9 = '_gradient3_5k.func.gii';
                s10 = '_gradient4_5k.func.gii';
                s11= '_gradient5_5k.func.gii';
                s12= '_gradient6_5k.func.gii';
                s13= '_gradient7_5k.func.gii';
                s14 = '_gradient8_5k.func.gii';
                
            
                ROI_name = strcat(s5,s6,s7);
                
                gg2.cdata=label2;
              
                saveg(gg2,ROI_name);
                
                %2

                ROI_name = strcat(s5,s6,s8);
                
                gg2.cdata=label3;
               
                saveg(gg2,ROI_name);
                %3
                
                ROI_name = strcat(s5,s6,s9);
                
                gg2.cdata=label4;
               
                saveg(gg2,ROI_name);
                %4
                
                  ROI_name = strcat(s5,s6,s10);
                
                gg2.cdata=label5;
               
                saveg(gg2,ROI_name);

                 %5            
                 ROI_name = strcat(s5,s6,s11);
                gg2.cdata=label6;
              
                saveg(gg2,ROI_name);
                
                 %6
                ROI_name = strcat(s5,s6,s12);
                
                gg2.cdata=label7;
               
                saveg(gg2,ROI_name);
                
                 %7
                ROI_name = strcat(s5,s6,s13);
                
                gg2.cdata=label8;
               
                saveg(gg2,ROI_name);

                %8
                  ROI_name = strcat(s5,s6,s14);
                
                gg2.cdata=label9;
               
                saveg(gg2,ROI_name);

        end
        
        

          
