function [ Price, V ] = Final(C_P, Method, S, X, r, T, vol, Smax, M, N)
%���ڱ���
dS=(Smax-0)/M; %�ְ����� ����
grid_S=[Smax:-dS:0]'; % �ְ���� ����

dt=(T-0)/N; %�ð����� ����
grid_T=T:-dt:0; %�ð���� ����

grid_i=0:1:N; %÷��(����)
grid_j=M: -1: 0; %÷��(�ְ���ġ)

V=zeros(M+1, N+1); %�� ��庰 �ɼǰ�ġ ���� ���

% ������� �ۼ�

% ���� �� �������
if C_P=='C'
    V(:,N+1)=max(grid_S-X,0); %���� ����
    V(M+1,:)=0; %LowerBC
    V(1,:)=Smax-X*exp(-r*dt*(N-grid_i)); %UpperBC
elseif C_P=='P'
    V(:,N+1)=max(X-grid_S,0); %���� ����
    V(M+1,:)=X*exp(-r*dt*(N-grid_i)); %LowerBC
    V(1,:)=0; %UpperBC
end

%������
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

%���������� Ǯ��
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
        A=diag(Imp_a(2:M-1),1)+diag(Imp_b(2:M))+diag(Imp_c(3:M),-1); %��� A
        [L,U]=lu(A);
        B_b=zeros(size(A,2),1);
        for h=N:-1:1
            B_b(1)=Imp_a(2)*V(1,h); %��� B
            V(2:M,h)=U\(L\(V(2:M,h+1)-B_b)); 
        end
end

% ������� �ۼ�

Price = interp1(grid_S,V(:,1),S,'linear');    

end

