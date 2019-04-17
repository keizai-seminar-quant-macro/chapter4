function [cfcn0 dif] = nti(m)

options = optimoptions('fsolve','Display','none'); % fsolve�̃I�v�V����(�œK���̌��ʂ��\���ɂ���)

% *** �����̊ ***
it = 1;          % ���[�v�E�J�E���^�[
dif2 = 1.0;      % ����֐��̌J��Ԃ��덷
%options.TolFun = 1.0e-10; % fsolve�̃I�v�V����(�œK���̋��e�덷)

disp(' ')
disp('-+- Solve a neoclassical growth model with time iteration -+-');
disp(' ')

%% STEP 1(b): ����֐��̏����l�𓖂Đ���
% ��͉� (for k'=g(k))
p_true = m.beta*m.alpha*(m.kgrid.^m.alpha);

% ����֐��̏�����
cfcn0 = m.kgrid;
%cfcn0 = m.css/m.kss*m.kgrid; % m.nk=21�̂Ƃ��͐���֐��̌`����������???
%cfcn0 = m.kgrid.^m.alpha - p_true;
%cfcn0 = m.css*ones(nk,1);
cfcn1 = zeros(m.nk,1);

% �J��Ԃ��덷��ۑ�����ϐ���ݒ� 
dif = zeros(2,m.maxiter);

%% STEP 4: ����֐����J��Ԃ��v�Z
while (it < m.maxiter && dif2 > m.tol)

    fprintf('iteration index: %i \n', it);
    fprintf('policy function iteration error: %e\n', dif2);

    for i = 1:m.nk

        capital = m.kgrid(i);
        wealth = capital.^m.alpha + (1.-m.delta).*capital;

        % MATLAB�̍œK���֐�(fsolve)���g���Ċe�O���b�h��̐���֐��̒l��T��
        % �œK���̏����l�͌Â�����֐��̒l
        cons = fsolve(@EulerEq,cfcn0(i,1),options,m,capital,cfcn0);
        % �œK���̏����l�͒���Ԃ̒l: ����ł͉����Ȃ�
        % cons = fsolve(@EulerEq2,css,options,m,capital,cfcn0);
        cfcn1(i,1) = cons;
        kprime = wealth-cons;
        % �O���b�h���ƂɍœK���̌��ʂ��m�F
        %disp([cons capital wealth kprime]);
        %pause

    end

    % �J��Ԃ��v�Z�덷���m�F
    dif2 = max(abs(cfcn1-cfcn0));

    % �����r���̌J��Ԃ��v�Z�덷��ۑ�
    dif(2,it) = dif2;

    % ����֐����A�b�v�f�[�g
    cfcn0 = cfcn1;

    it = it + 1;

end