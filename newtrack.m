load('CircuitOfAmerica.mat')
bl=Track.bl;
br=Track.br;
cl=Track.cline;
xc=cl(1,:);yc=cl(2,:);
xl=bl(1,:);yl=bl(2,:);
xr=br(1,:);yr=br(2,:);
xnr=0.5*(xr+xc);
ynr=0.5*(yr+yc);
xnl=0.5*(xl+xc);
ynl=0.5*(yl+yc);
nl=[xnl;ynl;cl(3,:)];
nr=[xnr;ynr;cl(3,:)];
figure(1)
plot(xc,yc,'-')
hold on 
plot(xl,yl,'.-')
hold on
plot(xr,yr,'.-')
hold on
plot(xnl,ynl)
hold on 
plot(xnr,ynr)
xlabel('x[m]')
ylabel('y[m]')
hold on
nc=[nr(:,[1:25]),nl(:,[29:31]),[290.89,290.5622;-180.7056,-180.0815;0,0],nl(:,[41:42]),nr(:,50),...
    nl(:,[61:71]),cl(:,78),br(:,88),bl(:,104),nr(:,[123:141]),cl(:,149),nr(:,155),nl(:,162),...
    nr(:,[171]),cl(:,177),nl(:,[181:187]),br(:,198),cl(:,205),bl(:,210),nr(:,[219:225]),nl(:,231),nr(:,[243:270]),cl(:,276),...
    nl(:,[281:286]),cl(:,290),nr(:,[296:368]),bl(:,373),nr(:,[381:383]),bl(:,394),nl(:,[397]),br(:,403),nl(:,410),br(:,417),nl(:,429),...
    nl(:,435),nr(:,439)...
    bl(:,447),nr(:,[456:457]),nl(:,468:471),cl(:,478),br(:,484),cl(:,491),cl(:,502),br(:,509),nr(:,[514:524]),bl(:,533),nr(:,[542:555])...
    bl(:,560:562),nr(:,570:597)];
% plot(nc(1,:),nc(2,:))
% % legend('cline','left boundary','right boundary','new left boundary','new right boundary')
hold on
d=[];
sum_D=0;
for i=11:1:length(nc)-1
    D=sqrt((nc(1,i+1)-nc(1,i))^2+(nc(2,i+1)-nc(2,i))^2);
    sum_D=sum_D+D;
    d=[d,sum_D];
end
sum_D=0;
d_neg=[];
for i=11:-1:2
    D=-sqrt((nc(1,i-1)-nc(1,i))^2+(nc(2,i-1)-nc(2,i))^2);
    sum_D=sum_D+D;
    d_neg=[sum_D,d_neg];
end
arc_s=[d_neg,0,d]; 
%%%%%%%%%%%%%%%%%%%%%%theta calculation
sc=0:0.1:5700;
track=[spline(arc_s,nc(1,:),sc);spline(arc_s,nc(2,:),sc)];
% plot(track(1,:),track(2,:))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta=[];
for i=1:1:length(track)-1
    dx=track(1,i+1)-track(1,i);
    dy=track(2,i+1)-track(2,i);
    if dx>0
        if dy>0
            theta1=atan(dy/dx);
        end
        if dy<0
            if track(2,i+1)>0 && track(2,i)>0 && track(1,i+1)<600
                theta1=2*pi+atan(dy/dx);
            else
                theta1=atan(dy/dx);
            end
        end
    end
    if  dx<0
        if dy>0
            theta1=pi+atan(dy/dx);
        else
            theta1=pi+atan(dy/dx);
        end
    end
    theta=[theta,theta1];
end
theta1=2*pi+atan((nc(2,1)-nc(2,end))/(nc(1,1)-nc(1,end)));
theta=[theta1,theta];
track=[track;zeros(1,length(track))];
ts=[cos(theta);sin(theta)];
val_track =@(s)[interp1(sc,track(1,:),s);interp1(sc,track(2,:),s);interp1(sc,track(3,:),s)];
val_theta =@(s)interp1(sc,theta,s);
val_t=@(s)[interp1(sc,ts(1,:),s);interp1(sc,ts(2,:),s)]; 
new_track=struct('cline',nc,'arc_s',arc_s,'theta',theta,'bl',bl,'br',br,'track',track,'center',val_track,'ftheta',val_theta,'sc',sc,'ts',ts,'t',val_t);


plot(track(1,:),track(2,:),'LineWidth',2)
    