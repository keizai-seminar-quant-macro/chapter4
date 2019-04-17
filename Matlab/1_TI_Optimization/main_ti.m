clear all;

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

m.kmax = 0.5;   % ���{�O���b�h�̍ő�l
m.kmin = 0.05;  % ���{�O���b�h�̍ŏ��l (0�ɂ���Ɛ��Y���o���Ȃ��Ȃ�)

%% STEP 1(a): �O���b�h����
m.nk   = 21;    % �O���b�h�̐�
m.kgrid = linspace(m.kmin, m.kmax, m.nk)';

m.maxiter = 1000; % �J��Ԃ��v�Z�̍ő�l
m.tol  = 1.0e-5;  % ���e�덷(STEP 2)

tic;

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
        % cons = fsolve(@EulerEq,css,options,m,capital,cfcn0);
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

disp(' ');
toc;

%% �ŏI�I�Ȑ���֐��������Ă��璙�~�֐����v�Z
pfcn0 = m.kgrid.^m.alpha + (1-m.delta)*m.kgrid - cfcn0;

%% ��͓I��
p_true = m.beta*m.alpha*(m.kgrid.^m.alpha);

%% �I�C���[����������덷�𑪒�
% ���̃O���b�h�ł̓I�C���[�������̌덷�̓[���ɂȂ邽�߁A�O���b�h���ׂ����Ƃ�
kgrid_err = linspace(m.kmin, m.kmax, (m.nk-1)*10+1)';
cons = interp1(m.kgrid,cfcn0(:,1),kgrid_err); % ���`���
LHS  = mu_CRRA(cons, m.gamma);

kp   = kgrid_err.^m.alpha + (1-m.delta)*kgrid_err - cons;
cnext = interp1(m.kgrid, cfcn0(:,1), kp);
rent = m.alpha.*kp.^(m.alpha-1.0) - m.delta;
RHS  = m.beta.*(1.+rent).*mu_CRRA(cnext,m.gamma);

err  = RHS./LHS-1.0;

%%
figure;
plot(m.kgrid, pfcn0, '-', 'Color', 'blue', 'LineWidth', 3);
hold on;
plot(m.kgrid, p_true, '--', 'Color', 'red', 'LineWidth', 3);
plot(m.kgrid, m.kgrid, ':', 'Color', 'black', 'LineWidth', 2);
xlabel('�����̎��{�ۗL�ʁFk', 'FontSize', 16);
ylabel("�����̎��{�ۗL�ʁFk'", 'FontSize', 16);
xlim([m.kmin m.kmax]);
xticks([0.05 0.1 0.2 0.3 0.4 0.5]);
xticklabels([0.05 0.1 0.2 0.3 0.4 0.5]);
legend('�ߎ���', '��͓I��', '45�x��', 'Location', 'NorthWest');
grid on;
set(gca,'FontSize', 16);
saveas(gcf,'Fig_pti2.eps','epsc2');

err2 = csvread("err_ndp.csv");
figure;
plot(kgrid_err, abs(err), '-', 'Color', 'blue', 'LineWidth', 3);
hold on;
plot(kgrid_err, abs(err2), '--', 'Color', 'red', 'LineWidth', 3);
xlabel('���{�ۗL�ʁFk', 'FontSize', 16);
ylabel('�I�C���[�������덷(��Βl)', 'FontSize', 16);
xlim([m.kmin m.kmax]);
xticks([0.05 0.1 0.2 0.3 0.4 0.5]);
xticklabels([0.05 0.1 0.2 0.3 0.4 0.5]);
legend('TI', 'VFI', 'Location', 'NorthEast');
grid on;
set(gca,'FontSize', 16);
saveas (gcf,'Fig_pti6.eps','epsc2');
