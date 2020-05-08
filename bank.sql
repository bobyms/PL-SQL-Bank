create or replace package bank as
  exception
    when ex1 then
      dbms_output.put_line("Account does not exist or balance is too low");
    when ex2 then
      dbms_output.put_line("Account does not exist or the value entered is negative");
    when ex3 then
      dbms_output.put_line("Already exists");
    when ex4 then
      dbms_output.put_line("Info does not exists or balance is wrong amount");
  /*1*/
  create or replace procedure cheat(x in varchar2) is
  declare
    lines dbms_output.chararr;
  begin
    dbms_output.put_line(""||x);
    dbms_output.get_lines(lines, 1); 
  end;

  create or replace procedure branch(address branch.addy%type) as
  begin
    declare num;
    select numb
    into num
    where addy = address
    from branch;
    call return(num);
  end;
  create function return(val varchar2)
  begin
    if val is null then
      return NULL
    else
      return val
    end if;
  end;
  /*2*/
  create or replace function open_branch(address branch.addy%type) as
    declare
      err := 0;
      num2 branch.numb%type;
      cas int;
    begin
    --checks if address is already used
    for add in (select addy from branch) loop
      if add = address then
        err = 1;
        raise ex3;
      end if;
    end loop;
    --checks if closed branch number can be used
    if err = 0 then
      for new in(select numb from branch) loop
        if err = 0 and new != numb then
            select right('00'+ new , 3)into new;
            execute immediate
            'insert into branch values(new, address)';
            dbms_output.put_line('New branch number: '||new);
            err = 1;
       end if;
     end loop;
     --checks if its the first to be added
       if err = 0 then
         select numb
         into new2
         from branch
         limit 1;
         if new2 is null then
           execute immediate
           'insert into customer values("00000", custo)';
           err=1;
         end if;
       end if;
     --takes next highest branch number
     if err = 0 then
      select numb
      into new2
      from branch
      order by numb desc limit 1;
      select cast(new2 as int) into cas;
      cas = cas + 1;
      select cast(cas as branch.numb%type) into new2;
      select right('00'+ new , 3)into new2;
      execute immediate
      'insert into branch values(new2, address)';
      dbms_output.put_line('New branch number: '||new2);
      err=1;
    end if;
   end if;
  end;

  /*3*/
  create or replace procedure close_branch(address branch.addy%type) as
  declare num branch.numb%type;
  begin
    select numb
    into num
    from branch
    where addy = address;
    if num is not null then
      execute immediate
      'delete from branch where addy = address';
    else
      raise ex4;
  end;
  /*4*/
  create or replace procedure create_customer(custo customer.name%type) as
    declare
      err := 0;
      new2 customer.c_numb%type;
      cas int;
    begin
    --checks if name already exists
    for nam in (select name from customer) loop
      if nam = custo then
        err = 1;
        raise ex3;
      end if;
    end loop;
    --checks if its the first to be added
      if err = 0 then
        select c_numb
        into new2
        from branch
        limit 1;
        if new2 is null then
          execute immediate
          'insert into customer values("00000", custo)';
          err=1;
        end if;
      end if;
     --takes next highest branch number
     if err = 0 then
      select c_numb
      into new2
      from branch
      order by c_numb desc limit 1;
      select cast(new2 as int) into cas;
      cas = cas + 1;
      select cast(cas as customer.c_numb%type) into new2;
      select right('0000'+ new2 , 5)into new2;
      execute immediate
      'insert into customer values(new2, custo)';
      err=1;
    end if;
  end;
  /*5*/
  create or replace procedure remove_customer(nam customer.name%type) as
    declare num customer.numb%type;
    begin
      select numb
      into num
      from customer
      where name = nam;
      if num is not null then
        execute immediate
        'delete from customer where name = nam';
      else
        raise ex4;
  end;
  /*6*/
  create or replace procedure open_account
    (n customer.name%type, a branch.addy%type, amount account.balance%type) as
    declare
      c1 customer.numb%type;
      b1 branch.numb%type;
      a1 account.numb%type;
      a2 account.numb%type;
      cas int;
      int count;
      select numb
      from customer
      into c1
      where name = n;

      select numb
      from branch
      into b1
      where addy = a;

      if amount > 0 and c1 is not null and b1 is not null
        for acc in(select numb from account order by numb desc limit 1
          where substr(acc, 1, 3) = b1)loop
          a1 = substr(acc, 4, 4);
          select cast(a1 as int) into cas;
          cas = cas + 1;
          select cast(cas as account.numb%type) into a1;
          select right('000'+ a1 , 4)into a1;
          select concat(b1,a1) into a2;
          execute immediate
          'insert into account values(a2, c1, 0)';
      else
        raise ex4;
  end;
  /*7*/
  create or replace procedure close_account(n account.numb%type) as
    declare num int;
    begin
      select balance
      into num
      from account
      where numb = n;

      if num is not null and num = 0 then
        execute immediate
        'delete from account where numb = n';
      else
        raise ex4;
  end;
  /*8*/
  create or replace procedure withdraw
    (ano account.numb%type, amount account.balance%type) as
     at account%rowtype;
 begin
      select *
      into at
      from account
      where numb = ano;
      if at.balance > amount and at is not null then
         update account
         set account.balance = account.balance – amount
         where account.numb = ano;
      else
        raise ex1;
      end if;
  end;

  /*9*/
  create or replace procedure deposit
    (ano account.numb%type, amount account.balance%type) as
    begin
    declare acc;
    select numb
    into acc
    from account
    where numb = ano;
     if amount > 0 and acc is not null then
        update account
        set account.balance = account.balance + amount
        where account.numb = ano;
     else
         raise ex2;
     end if;
     commit;
  end;

 /*10*/
 create or replace procedure transfer
   (ano1 account.numb%type, ano2 account.numb%type, amount account.balance%type) as
    begin
      declare bal account.balance%type;
      select balance
      into bal
      from account
      where numb = ano1;
      if bal is not null and bal >= amount then
        deposit(ano2, amount);
        withdraw(ano1, amount);
        commit;
      else
        raise ex1;
      end if;
 end;

 create or replace procedure show_branch(add branch.addy%type) as
   declare
    b_num branch.numb%type;
    b branch.numb%type;
    amount int;
    total int;
   begin
    select numb
    into b
    from branch
    where addy = add;
    if b is null then
      raise ex4;
    else
      for acc in (select numb from account)loop
        b_num = substr(acc, 1, 3);
        if b_num = b then
          select balance
          into amount
          from account
          where numb = acc;
          dbms_output.put_line('Account number: '||acc);
          dbms_output.put_line('Balance in account: '||amount);
          total = total+amount
        end if;
      end loop;
      dbms_output.put_line('Total in all accounts: '||total);
    end if;
  end;

 create or replace procedure show_all_branches() as
  declare
  begin
    for add in (select addy from branch) loop
      call show_branch(add);
    end loop;
 end;

 create or replace procedure show_customer(n customer.name%type) as
   declare
    num customer.numb%type;
    total int;
    amount int;
   begin
   select numb
   into num
   from customer
   where name = n;
   if num is not null then
    dbms_output.put_line('Customer number is '||num);
    for acc in(select numb from account where c_numb = num) loop
      select balance
      into amount
      from account
      where numb = acc;
      dbms_output.put_line('Account number '||acc);
      dbms_output.put_line('Has balance of '||amount);
      total = total + amount;
    end loop;
    dbms_output.put_line('Total balance in all accounts is '||total);
   else
    raise ex4;
 end;

end bank;
