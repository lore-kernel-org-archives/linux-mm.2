Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86BAEFB80E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A626B0088; Tue, 24 Feb 2026 02:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48856B0089; Tue, 24 Feb 2026 02:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20056B008A; Tue, 24 Feb 2026 02:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE3BC6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:02:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 759591B67A9
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:02:57 +0000 (UTC)
X-FDA: 84478457994.10.2DBB328
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7AC33180004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:02:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WtNckoYp;
	spf=pass (imf06.hostedemail.com: domain of avagin@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771916575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frq9C2KPzidXPSU+e6IcoqTvLL5USw8xYGm0brKzosM=;
	b=M9Xs1op1HxxJtI7JT6PMrvafwYhnOCn6cXnybLwwlTtdELo9U3MazPymgmFcElV+QSfu5S
	wQI5gIL9xM7w0aAoH9wZt0TzAA04+BvcXdLnIWKKNqGFFiilnOYepyBrrgdASaHeqW12Ah
	yjKXNhHIOjQnnvIqiMDs3ZzR6jYdhZE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WtNckoYp;
	spf=pass (imf06.hostedemail.com: domain of avagin@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771916575; a=rsa-sha256;
	cv=pass;
	b=zTGO0Kusqme0bKV60Zed5OEbU3GJoIOkTUaUJjGqnOVRAe5hq7bf98obZEeTrdGRABy6tO
	dIeg270M6RtftyQnrqjFaTm7hsbCT8fSSEEIL9mj8+trpl8f+Mr8xWAn9/ID3r2GHryTlE
	4w/Izozbhy5mKOsTjAF2y0duLvX+ZlY=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5033b64256dso381231cf.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:02:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771916574; cv=none;
        d=google.com; s=arc-20240605;
        b=BlmoV6n4XZHBQVHcpFc8r9yagt9FO+2OmCmMp+bZeaO1dTRQNRk0e8Z29VWZCIyzN2
         66RZ4WxOfi4jvm+07rCNRcL1NpVNq9cyT3N1gaAtHTeDB6B6tMDmHJAYJOajPzrQBggy
         uMMO8MCgXkP8pVfVVcAYaess9RYpN20FD26RiR5ABDz8PlygznFGDVkKj0qofw1401St
         Oa34CM2dYv0UdO/4blcSc7JEbSgumL0Z45HX6l6suwss5BXO5i0iWElUUuzz1LsTUVUZ
         lAIUWXKDJ+z6RhcDtuYAFA483VX7N5Eb+XbWvzlGJLL7uOvrWKT4EWS1jrHmnRN0uQyC
         3UxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=frq9C2KPzidXPSU+e6IcoqTvLL5USw8xYGm0brKzosM=;
        fh=sxgYLlMuvVHg76Chap8hhDm9kopeQuf1Cr791YMFBHQ=;
        b=l1Gc8mJL6ruUFSGQsSJNWxyEKwM7aZfawQ5zHUPwqdDdJBBLIHE5XEAj5lgD9PbJ7S
         Xw1WGWvxsGUUyhpKHMouJ0qyAAAx/YZzN8pbxhVPBFuqvW96JwqHSCFos+G0z+Q3L4t0
         PtpfoQ3Rvj4mVAc6GyxtU8Yqa8jDZ9Zbj9p+HNiuMn5JTNTOyzUk27pLOtGemeXNlMps
         IyEiG3NVoQO+jKrhRK/jn1M/TtwcIjWf14g4m5D4OUqFjDtfnKXCMunx/GNvIGZBjozN
         DQa8wsWSk7t/lMc3QLkxrJk6/D+7OuYzAqHmwg1IfBfbkFQejF8pA6w++a2TsNcbBxou
         rCnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771916574; x=1772521374; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frq9C2KPzidXPSU+e6IcoqTvLL5USw8xYGm0brKzosM=;
        b=WtNckoYpmhL+JNxu0V0mImsk0U/Kq4NgIl/xK7RLbk0cOUSuFdalsJ7XPMaPfI0KXn
         hpTKK/ms40vbbVMHydChRA/8JxSHWi5OyRh1JUFoRs0JrQq1FD2C8uKLQUKJfoujzOSt
         QZIonMVJD9oyZqBTbqRulrhlUU97gliIEGmvZ0zvqblvocV2M313OcUMn6zS2pt9gth6
         4l9wmgykFTBllwm64R0JH5dSpuhx6Q0dsiLuWWwoGscP3dv8csSQ9nwOEmIShB3pUAkz
         iZ7mPYM5bK4b1YLbrYyN5ATmNC1OO9jQCi/1lwmYpJSqq70UbMpqQS9wujtYB2yn4gOJ
         P7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771916574; x=1772521374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=frq9C2KPzidXPSU+e6IcoqTvLL5USw8xYGm0brKzosM=;
        b=dCdFrndY1KHAf0rCxQhJ6L9fufdSVexZ6Igd2CYzg2PeI5aaV3cbd5Uxj4esrGTjjO
         hviLQPXjBcuL5hiQPeI8kxvqLzREyXyuzZ46ESAvwx5hruUrqGvi9wW1JHP52gWsPo6G
         5ZpfTumET5rFDwJdCIyNa5BeXYQQeRBJUW50F6pXMFdod4pV23To6uRAZN/gEE2Y08KA
         olbWgN05npEJRNXcmPJMz7WYhRXYnWwVUIdaIjKeiq4uYdl5HBU2U2s30qQhdRbJxrCs
         zk/sntdlu08afibE6uTHP0oiBWme8PBWt0idP1Eyp3AcoTTzqG7iFZSrwALoNrZZi7q6
         0Lyg==
X-Forwarded-Encrypted: i=1; AJvYcCUxboq4tjfAaWN2MbZdWQ/5eO2/vVBmhuRxRSZrwaFLaycVB6c32GtHqMns2kcF5WdUaIsRs1qh6w==@kvack.org
X-Gm-Message-State: AOJu0YwbVKvnHBqS4czuWuyfIFUk0Xq/mPQm1oAM0xXvQBm/+1JnPxQE
	erU+DFvkG5dn+msa8NVoPmQbJOOy7ZqnEcVMu+yaHwllZXOWBjhNR3N0BWzpAmP4v4eSltsY3TF
	2vfe+eF7VGYo09fYgtj+dzzvPjJHU4yvK0Pbfmols
X-Gm-Gg: AZuq6aJbAYOhuKWB3DfzXtCjVyATPKKMMl6Hrpv/ULqZJCGyVAGrD5dZTBIdZ6gPAw9
	/AX5ZajOhZ7GoP3KfGMe+kMx2s6oMyx1lQT4Z594DggP6k2PjvXrnC3G0hZt9CLOWAAVE7AuUwY
	Btj3pZvWJRWa09DL09jYUydxTjo0QaRQOOe6bM1eN9JNUZab+GzLCYGI1Z+F88mopMrtJrW/OdH
	mMNzz+rZG5yJvVDwF7/Thi52JnZMNPLY192STX2HIE0O9DERuiv4/JzFeDWR4miuhbbzWEEsfXP
	3k0THic=
X-Received: by 2002:ac8:5dcc:0:b0:502:f1e0:dd3b with SMTP id
 d75a77b69052e-5072df09bebmr5503351cf.7.1771916574044; Mon, 23 Feb 2026
 23:02:54 -0800 (PST)
MIME-Version: 1.0
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com> <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
From: Andrei Vagin <avagin@google.com>
Date: Mon, 23 Feb 2026 23:02:43 -0800
X-Gm-Features: AaiRm51ZhFVywsR5m51jPKotKAiB8grG8YGfZOW5eJt7NCobjlO8q-Off9c89ts
Message-ID: <CAEWA0a63QxMRqCwpCUqb5iKih31LY-2zX+--SkMGcP-Y19PqpQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] pid_namespace: allow opening pid_for_children
 before init was created
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Jan Kara <jack@suse.cz>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Adrian Reber <areber@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7AC33180004
X-Stat-Signature: bq4zh1b8r4747rmozw8ju1nmgoiybjri
X-Rspam-User: 
X-HE-Tag: 1771916575-652535
X-HE-Meta: U2FsdGVkX18r/BiuiqvxO5AJVmSi68mfH9j1lybL6bht71mzg8PdwOGKTHPZyHeFEaSYMajyTrUhgI1i+oNnEYxruQHNDJ04O7DkpyMTdWkAb629mkN9UfLbSSA1GOTx2fnKlJAAuEXnH8kbrvVjDLhgtss/lYPAjHxEtfpgN0lE7FoTn3AKBfwZbKczzyUdjGUQuuFiT9q3vI3QNQAgWBvZ89M6ygFbJvL1Qt33AlABlDv0wkrDcrWt7VUKp2Tg5DrnV0B/X8NfdHKoYqhwiwMh9p3fi5ZU4Kblas1APCI6+gb5rCCpZei6JN0X9VNeQ3Iqt1jzj3euOYV0xXdZLKiU+DDkL1JcCYpSXdt5Qw4RW/ueZyNYVCY16QaXZ4nI+SaR+Y5vmvTVK+FICA1OATZD5HSPJ7+DoGQ36vnT/YUA3T7vRJClVKv3zJhHF0j+tOIs1Nuzyp8rBKhByH1kXeVGSK0GzpuoOfLPDi8PUcnaTBVzv9KlENoCKspAuR9VR4x6YvBOdWX/Pc9bC4R7XsK3113XxHd2sAnM+QOzfN0TtgSdTHIhSiiT3dijDsWRdkx+p/gIf68oxwj0OKsKReNJ/YPMBt1P2zsHaZQtUqlBnUiI3C7hHdkDYyGFBPldSNOQnK1x5n0LpLGnq/QBe4REO0FqhqaBoMEcpS9xxtvVKVGA72tuyvGUBLw4jzGjfatUl6oCbVbkAb9RWOOORnHjNbVVa+qn9TPPpXP7YovuWc7EwnMrFI4SftxOnQHF4NbrGcj7UmRAK/cDF89dN2C5QlOOTVSjNoEzt+LDumB9/iqUv6eHx0Chk68GsynyiITkYcYnwRH48zWID/Ylyt0Y1YWqVq/4ufDzVLK/ZJ4LLipltRfmG63cPNIDYMqPsUxqdFFZ24b9ElZuLxpMaWH+GiwujJQamCe3WNrSIRxVwn1ebhbce6WAB1C+zipmHiJtZOznk1w1K8NkNBg
 sKQzRnhC
 4J/Yizf8jgn5+ROmJLGL4OdlS3ChxS3PivXVyIAowypCKBhH/40Vy3+MHf04eH1Hp6OikWi5s2cEoPq/Ln+jDWmUylOuZ99TrQLtApYxsK+x6E3UWKNf1Wkm/U7ADy1LPvMrQvaIz0FGsnsiyVrkFR0zfUQoCDC6R3Oz97fRssIFQH/wa6EQdBkqPw44bDqAA759S/8OIrjUCrYk4E1xrDWCDjHeKwZU2rlkw+AFHS7mXYxhGrA6vwlk1Z5nIFXLqEMMx9Fkv+3IBcBoihKxRJyv8m/HD42tlYTECTjmZbFC5Vk02I3Lfiqq0EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 3:03=E2=80=AFPM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This effectively gives us an ability to create the pid namespace init as
> a child of the process (setns-ed to the pid namespace) different to the
> process which created the pid namespace itself.
>
> Original problem:
>
> There is a cool set_tid feature in clone3() syscall, it allows you to
> create process with desired pids on multiple pid namespace levels. Which
> is useful to restore processes in CRIU for nested pid namespace case.
>
> In nested container case we can potentially see this kind of pid/user
> namespace tree:
>
>                             Process
>                           =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>     User NS0 =E2=94=80=E2=94=80=E2=96=B6 Pid NS0 =E2=94=80=E2=94=80=E2=96=
=B6 Pid p0 =E2=94=82
>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
>         =E2=96=BC           =E2=96=BC     =E2=94=82         =E2=94=82
>     User NS1 =E2=94=80=E2=94=80=E2=96=B6 Pid NS1 =E2=94=80=E2=94=80=E2=96=
=B6 Pid p1 =E2=94=82
>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
>        ...         ...    =E2=94=82   ...   =E2=94=82
>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
>         =E2=96=BC           =E2=96=BC     =E2=94=82         =E2=94=82
>     User NSn =E2=94=80=E2=94=80=E2=96=B6 Pid NSn =E2=94=80=E2=94=80=E2=96=
=B6 Pid pn =E2=94=82
>                           =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>
> So to create the "Process" and set pids {p0, p1, ... pn} for it on all
> pid namespace levels we can use clone3() syscall set_tid feature, BUT
> the syscall does not allow you to set pid on pid namespace levels you
> don't have permission to. So basically you have to be in "User NS0" when
> creating the "Process" to actually be able to set pids on all levels.
>
> It is ok for almost any process, but with pid namespace init this does
> not work, as currently we can only create pid namespace init and the pid
> namespace itself simultaneously, so to make "Pid NSn" owned by "User
> NSn" we have to be in the "User NSn".
>
> We can't possibly be in "User NS0" and "User NSn" at the same time,
> hence the problem.
>
> Alternative solution:
>
> Yes, for the case of pid namespace init we can use old and gold
> /proc/sys/kernel/ns_last_pid interface on the levels lower than n. But
> it is much more complicated and introduces tons of extra code to do. It
> would be nice to make clone3() set_tid interface also aplicable to this
> corner case.
>
> Implementation:
>
> Now when anyone can setns to the pid namespace before the creation of
> init, and thus multiple processes can fork children to the pid
> namespace, we enforce that the first process created is always the init,
> and only allow other processes after the init sets
> pid_namespace->child_reaper.
>
> To avoid possible problems related to cpu/compiler optimizations around
> ->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
> everywhere we write it and use READ_ONCE everywhere we read it without
> explicit lock. Note: we already had READ_ONCE in nsfs_fh_to_dentry().
>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>
> --
> v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
> task_list lock for reading it. Rebase to master, and thus remove
> now excess pidns_ready variable.
>
> Note: I didn't find anything in copy_process() around setting the
> ->child_reaper which can influence the pid namespace, so it looks like
> the pid namespace is fully setup at the point when init sets
> ->child_reaper to receive more processes. Thus tasklist lock looks
> excess in pidns_for_children_get()'s ->child_reaper check and it should
> be safe not to have it in the corresponding checks in alloc_pid().
> ---
>  kernel/exit.c          | 2 +-
>  kernel/fork.c          | 2 +-
>  kernel/pid.c           | 5 +++--
>  kernel/pid_namespace.c | 9 ---------
>  4 files changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 8a87021211ae..567fc3b7b0f9 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -608,7 +608,7 @@ static struct task_struct *find_child_reaper(struct t=
ask_struct *father,
>
>         reaper =3D find_alive_thread(father);
>         if (reaper) {
> -               pid_ns->child_reaper =3D reaper;
> +               WRITE_ONCE(pid_ns->child_reaper, reaper);
>                 return reaper;
>         }
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e832da9d15a4..27d0cdbca67e 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2423,7 +2423,7 @@ __latent_entropy struct task_struct *copy_process(
>                         init_task_pid(p, PIDTYPE_SID, task_session(curren=
t));
>
>                         if (is_child_reaper(pid)) {
> -                               ns_of_pid(pid)->child_reaper =3D p;
> +                               WRITE_ONCE(ns_of_pid(pid)->child_reaper, =
p);
>                                 p->signal->flags |=3D SIGNAL_UNKILLABLE;
>                         }
>                         p->signal->shared_pending.signal =3D delayed.sign=
al;
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 3b96571d0fe6..e6116e131d8d 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -219,7 +219,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t=
 *arg_set_tid,
>                          * Also fail if a PID !=3D 1 is requested and
>                          * no PID 1 exists.
>                          */
> -                       if (tid !=3D 1 && !tmp->child_reaper)
> +                       if (tid !=3D 1 && !READ_ONCE(tmp->child_reaper))
>                                 goto out_abort;
>                         retval =3D -EPERM;
>                         if (!checkpoint_restore_ns_capable(tmp->user_ns))
> @@ -247,8 +247,9 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t=
 *arg_set_tid,
>                          * alreay in use. Return EEXIST in that case.
>                          */
>                         if (nr =3D=3D -ENOSPC)
> -
>                                 nr =3D -EEXIST;
> +               } else if (!READ_ONCE(tmp->child_reaper) && idr_get_curso=
r(&tmp->idr) !=3D 0) {

I think it is better to update pid_ns_ctl_handler to prevent setting
ns_last_pid in a pidns
without init. Otherwise, figuring out why fork returns EINVAL can be tricky=
.

> +                       nr =3D -EINVAL;
>                 } else {
>                         int pid_min =3D 1;
>                         /*

