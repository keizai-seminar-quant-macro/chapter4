%clear all;

%%
% �J���u���[�V����
m.beta  = 0.96; % �������q
m.gamma = 1.0;  % ���ΓI�댯���x(�َ��_�Ԃ̑�ւ̒e�͐��̋t��)
m.alpha = 0.40; % ���{���z��
m.delta = 1.00; % �Œ莑�{����(delta=1.0�̂Ƃ��͉�͉�������)

% ����Ԃ̒l
m.ykss = (1/m.beta-1+m.delta)/m.alpha;
m.kss = m.ykss^(1/(m.alpha-1));
m.yss = m.ykss*m.kss;
m.css = m.yss-m.delta*m.kss;

% m.kmax = 0.5;   % ���{�O���b�h�̍ő�l
% m.kmin = 0.05;  % ���{�O���b�h�̍ŏ��l (0�ɂ���Ɛ��Y���o���Ȃ��Ȃ�)
m.kmax = 1.2*m.kss;  % ���{�O���b�h�̍ő�l
m.kmin = 0.8*m.kss;  % ���{�O���b�h�̍ŏ��l (0�ɂ���Ɛ��Y���o���Ȃ��Ȃ�)

m.maxiter = 1000; % �J��Ԃ��v�Z�̍ő�l
m.tol  = 1.0e-8;  % ���e�덷(STEP 2)

%%
norms = zeros(3,2);
times = zeros(3,2);

nkvec = [3 5 9]';

for i=1:3

    %% STEP 1(a): �O���b�h����
    m.nk = nkvec(i);
    m.kgrid = polygrid(m.kmin,m.kmax,m.nk);
    m.T = polybas(m.kmin,m.kmax,m.nk,m.kgrid);
    m.invT = inv(m.T);

    % time iteration
    tic;
    [cfcn0 dif] = nti_cheb(m);
    times(i,1) = toc;

    err = calcerr(m,cfcn0);
    norms(i,:) = log10([mean(abs(err)) max(abs(err))]);
    
end

times(:,2) = times(:,1)/times(1,1);

disp(" Euler equation errors");
disp([round(norms,2)]);
disp(" Elasped time");
disp([round(times,2)]);