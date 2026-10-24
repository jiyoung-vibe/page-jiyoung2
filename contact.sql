-- 문의 표(contact)를 만든다.
-- 문의 하나 = 표 한 줄. 칸은 이름(name), 문의 내용(content), 작성 시각(created_at).
create table contact (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 20),
  content text not null check (char_length(content) between 1 and 500),
  created_at timestamptz not null default now()
);

comment on column contact.name is '이름';
comment on column contact.content is '문의 내용';
comment on column contact.created_at is '작성 시각';

-- 규칙(권한)을 켠다. 규칙이 켜지면 아래에서 허락한 일만 할 수 있다.
alter table contact enable row level security;
create policy "누구나 쓰기" on contact for insert with check (true);

-- 읽기·고치기·지우기 정책은 없다 → 공개 키로는 문의를 읽거나 고치거나 지울 수 없다
-- 공개 키(anon)로 들어온 사람에게 쓰기만 허락한다.
-- 새 프로젝트는 SQL로 만든 표를 공개 키에 자동으로 열지 않는다. 이 줄이 없으면 401 오류가 난다.
grant insert on table contact to anon, authenticated;
