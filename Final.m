function [ Price, V ] = Final(C_P, Method, S, X, r, T, vol, Smax, M, N)
%격자구성
dS=(Smax-0)/M; %주가간격 설정
grid_S=[Smax:-dS:0]'; % 주가노드 구성

dt=(T-0)/N; %시간간격 설정
grid_T=T:-dt:0; %시간노드 구성

grid_i=0:1:N; %첨자(시점)
grid_j=M: -1: 0; %첨자(주가위치)

V=zeros(M+1, N+1); %각 노드별 옵션가치 저장 행렬

% 여기부터 작성

% 만기 및 결정경계
if C_P=='C'
    V(:,N+1)=max(grid_S-X,0); %만기 조건
    V(M+1,:)=0; %LowerBC
    V(1,:)=Smax-X*exp(-r*dt*(N-grid_i)); %UpperBC
elseif C_P=='P'
    V(:,N+1)=max(X-grid_S,0); %만기 조건
    V(M+1,:)=X*exp(-r*dt*(N-grid_i)); %LowerBC
    V(1,:)=0; %UpperBC
end

%계수행렬
switch Method
    case 'EXP'
        df=1/(1+r*dt);
        Exp_a=df*(-0.5*r*grid_j*dt+0.5*vol^2*(grid_j.^2)*dt);
        Exp_b=df*(1-vol^2*(grid_j.^2)*dt);
        Exp_c=df*(0.5*r*grid_j*dt+0.5*vol^2*(grid_j.^2)*dt);
    case 'IMP'
        Imp_a=0.5*r*grid_j*dt-0.5*vol^2*(grid_j.^2)*dt
        Imp_b=1+vol^2*(grid_j.^2)*dt+r*dt;
        Imp_c=-0.5*r*grid_j*dt-0.5*vol^2*(grid_j.^2)*dt;
end

%연립방정식 풀이
switch Method
    case 'EXP'
        for h=N:-1:1
            for k=2:M
                V(k,h)=Exp_a(k)*V(k+1,h+1)+Exp_b(k)*V(k,h+1)+Exp_c(k)*V(k-1,h+1);
                if C_P=='C'
                    V(k,h)=max(V(k,h), grid_S(k)-X);
                elseif C_P=='P'
                    V(k,h)=max(V(k,h), X-grid_S(k));
                end
            end
        end
    case 'IMP'
        A=diag(Imp_a(2:M-1),1)+diag(Imp_b(2:M))+diag(Imp_c(3:M),-1); %행렬 A
        [L,U]=lu(A);
        B_b=zeros(size(A,2),1);
        for h=N:-1:1
            B_b(1)=Imp_a(2)*V(1,h); %행렬 B
            V(2:M,h)=U\(L\(V(2:M,h+1)-B_b)); 
        end
end

% 여기까지 작성

Price = interp1(grid_S,V(:,1),S,'linear');    

end

