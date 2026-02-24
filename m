Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90686F3C99B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40016B0089; Tue, 24 Feb 2026 10:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDC06B008A; Tue, 24 Feb 2026 10:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF09F6B008C; Tue, 24 Feb 2026 10:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAA3A6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:38:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C99689526
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:38:58 +0000 (UTC)
X-FDA: 84479758356.24.D5BCF43
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B7EC40019
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:38:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4lKfUfvh;
	spf=pass (imf07.hostedemail.com: domain of avagin@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=avagin@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8FKYJ3J0ekbbk4xcl7+J9bdYsFozs7WVni5ylJT0VM=;
	b=QdjlMNA+m++X3cnIplxGsi1S3pfLVhM+S9TbuXTyRzpOaSL3LTuXrjki/sem0p76Us9bxD
	fqJDeP8NmHwyQDwnx8aIMFPjkQYjerrd6irRd+n7SAJytHc0uASqp8DUzsO8t/6RSgVZ+T
	7twDDREfFkgC6l+MVika6UVjK7krkpQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771947536; a=rsa-sha256;
	cv=pass;
	b=dcRxYgD5I0j3D+Q/gm5INrbO1vbH2ZE28ZEi3e2OhLaRqsBTCPQ55Zbh6gptTaxer451e8
	6RYqDKbyg5EtZ1r0kHA8Xog/iLP9FGUCuThn5RLuowrRtRs7LEZ5HlkWR+YCeJ6dqtY1zl
	IrZYmNHRlymtGSYpS3sAWIJLNAMGnBU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4lKfUfvh;
	spf=pass (imf07.hostedemail.com: domain of avagin@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=avagin@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-505d3baf1a7so12741cf.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:38:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771947535; cv=none;
        d=google.com; s=arc-20240605;
        b=AtN4UEqBiqxv4NGkV1G0pjlwvdQCfnNEJvdw1kOk0gp2JSe7ZCdiaUJeDqbozyud3s
         aT7J4kSFjAqEvKKATIZgAs0bZQv3Ygy+PczrU89OZKN24HtxEBKHw3NgY0bFc/E+W11M
         Y9cjONWM3G/HIOg3bjQMWOnlwsMyt5n/fd1LHS2nrSHVD8TrwvGhJ2J7mOLp7DNbcXiL
         izXATcfb3V0j6obeQJS51lsci+N+8zXGW6K969vM27xAqlnep+H3Jka7mMynv5yIkfgJ
         TtP5vqG7bX1m+1iAG1C99VXLexgFW1WMhAgWrLYMvZcYZ3C88Hf6I0N4nUfaLhffxc9I
         19Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X8FKYJ3J0ekbbk4xcl7+J9bdYsFozs7WVni5ylJT0VM=;
        fh=4tlC4HxjNmWj0pXgIQTYckrsuWqDRGgm6OAL6PKJs1A=;
        b=ZARqB8KDQlYrLGaxWNk0mYFaCsm3G4iKQM4qbLGcKK3SEMWkBUm1Bc5FWmL46fz8In
         A4LpDO1eFhfuXnsjBrA40w34j2kGLhIpGFUWvL8ty4rWqlVHGp2oS36D24G9FNrHFTyZ
         J5a6KffXTg5CxNEk37r9oUfTNnCErT1dXTXdH2f1UusAqPm9rcGPy67tlav5V6UrfW4A
         Qb0NKOUSF1mll8/0K/xblybiHdMNqrcYuGhpGz2/mmOf+mYpg2OpCUgeShcFY3QHPlR0
         OhbYNVEGTCgQud8uCZSdobO0HU07lxaeXSmesCU9Xfeeb49d1fwuI0eRqPt2HUSEPPaN
         mXjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771947535; x=1772552335; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8FKYJ3J0ekbbk4xcl7+J9bdYsFozs7WVni5ylJT0VM=;
        b=4lKfUfvhMvjGeqMfFHhbS3g11KXhBeVeaBP71B4fqm3FOgUP+xKcfNzqboJdpC99zM
         k4r9bgOG4eI0sHiQxTBA0WKQbUHmAMKA/s51Eb/l0xhvvbVvAQYAupWvt6LeiATxD8uc
         Cc2MueBYRSreZeKpfIFilQihKtKwIsKYd2ac/i8LZ+Hi3B+Pkr80ZCgz2EZV2HH2P4M1
         CGEdggkdk3bLXU6yZJj60IdbH81QkzZmn+kU1KHgB5o00qiKakVyVH10ji0r10rA81tC
         1zCrf9ORB8q73/Ph/ELe6Aoyz+LqfJN9piVzJXwOTFhbDQGeCYRnhYNTNwpIeUlMyIyr
         FKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771947535; x=1772552335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X8FKYJ3J0ekbbk4xcl7+J9bdYsFozs7WVni5ylJT0VM=;
        b=s1l0tSsmWpCvteC6jmxmdt2UKskw2p8q9QdjdRbaZS9ly+yPJ1iU9CmdwLyg8lfPjt
         dlpsvS6iUChG8oED67fWmni5HGZD84U3JdsDI3gVQlMb8AEsxaE2/3Lz0Z4twNfimVye
         +hq/rJADh7AJmiV++aZm26geyua18axk81Uoqe0dNgnIG4SsWhJ5uFZFk+GOpI7+662F
         qWakGSZWk8isABiE6gMnxgAPg9vtnK9ILNeqYBox7PG9ROUsrkTrwCf1fbME8lPIJFXC
         1yxtaDvkIA+wBRt5Sed7I5pJUQCIviwcsAz6sJz59hnP09asn0J3rXd8t5O0REX1D9gv
         DMqw==
X-Forwarded-Encrypted: i=1; AJvYcCUglK7QGJrDFeCn08H4MBw9llSEOUlmK0xneYAzHSivjmx9uOwGA4VMguU28Cfh4E7n7c5h2BD4pg==@kvack.org
X-Gm-Message-State: AOJu0YyiuBAaSkPnnT+sMYT7TnXEL7ULdjF9+5/B3zugAXcLGBwQQf9f
	2PydtULZd0bPZd7gXHJOeRuFBtts2b/ENPXHH/7s4h8S0W5U6tVmCJKUuz5/4dEQlIYqeZZNU0z
	mJyWTFh5lr3MPsSMOcKy4OgjXY7J63DrJGTBMgJOf
X-Gm-Gg: AZuq6aLgJTYO3PoprAsUljdSSCHgDbS8TW+BxRHSaVh30xCcAyZqhDPzsy0fAy8Oa9U
	+rfgDCb9CU6nTaC8XpC3p1s0FawRzF5jcsMQDhwjlChYhmalh7lRsq0tpjOx5GpqrCB8P23L+Le
	TvdQzmiJea7OzePqhKeohj4g6zxg75O4qiFooXsDI1PYfKqAcUuhppVmr6xPLy1ss3ST/vSsiaO
	YB0ukZtIUXD1+s9MN7RoVyK0ywPsildq7CC5bRonHeP7eGkabzIEuVTPJtStEi+F2P8waze49o3
	uvwPZNE=
X-Received: by 2002:ac8:7fc9:0:b0:506:1f23:e22c with SMTP id
 d75a77b69052e-5072c945f63mr13855391cf.6.1771947534197; Tue, 24 Feb 2026
 07:38:54 -0800 (PST)
MIME-Version: 1.0
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
 <20260223200254.4104651-2-ptikhomirov@virtuozzo.com> <CAEWA0a63QxMRqCwpCUqb5iKih31LY-2zX+--SkMGcP-Y19PqpQ@mail.gmail.com>
 <4de06792-d8ea-4f2e-848d-0dfccdb64253@virtuozzo.com>
In-Reply-To: <4de06792-d8ea-4f2e-848d-0dfccdb64253@virtuozzo.com>
From: Andrei Vagin <avagin@google.com>
Date: Tue, 24 Feb 2026 10:38:41 -0500
X-Gm-Features: AaiRm52_3mgUzdXl_m6MyGgb0dC1GRQ33mHZxHL8f5gge7x-9SdxQdJcgRbqcA0
Message-ID: <CAEWA0a61jLQxULDMXLcpZn2M-cJXxzSMyCS8C4y=YkFfHAEYng@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: 3qdfd6wyc1aihx3me13uqryxzskimya6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6B7EC40019
X-HE-Tag: 1771947536-76642
X-HE-Meta: U2FsdGVkX1+K59ACdAnoKQ3OlyobrvQf63CKZa7inZKpgHYrkQ223s9DzYSxupwyAu3UGrhzJJ3l6uS0zwqANO3iYET3X+EdwxtuSQ87MZVoHSrgXI7yP1MaOqOvx0LeNbwy8VcT7/oW2/pIH2l5L2tarMMhNxUYAuJanGC8t7UiuCOx8AMpZ9KNwwTnWz3XNqiOHI+X9Ht0WbH7Xd0wuIl/Cj70sOqUdbJRebSA7hydjhsHxyWqJGfj5l7qv+cSyC48ggZSlUNDD2WDbY9HFJEOeVBxO0T98IDyiR4f5ud9pu0VXS9WOBrRXJ0Khe+cMbjTpDWjY/3XV/vUviRj9f4MlHEjenjH308VI+u/wKRZAtsfZHLM6OTM906mHDU44tiCrUfzIBrUvNxBx5J/t7h5yTvc+vFaqtRCeK9DBI4qmabSHV/53ulk7wp9Yjd57hJDm1o9lGExYgfkEBbScDuLbKvO9cxGthjjrNJUryoZB/DV5B4NOtPu7l/3WUOkfeHWsLi3A7ZPSdlLZvUzLD2NvXmJYaFE0+f/FB8ugx+WCicINS/FKDZu9OkkK9T7KI/a9ipMktZBGM+etoHZ+aXVcCFjcfkgidwsVq0Ii75kT7rHcKyn7Azov/M8dbW4UZmKf2PMd8IhM45I+szYpxJCqIQ2aMhOLfpF9aqARcTZZddq2fTjp6a5VSnygMCqn1c4R3c5bBi2gYT20/foh76brm/E2QGKPDnECCO7IlPie/J5eZKuvuPwUaPTPyH4rdCQZ/CYf5NWofTIciJ7h4YtGqxMgjh9I8FFAOy/s8mKYgc0N0ekuK8s8cu7KvM57PYhLdyDfcpTXuTwrFgdbX1JDLR0uCUSMClLfxqiRv/78Etk4ejcCTlxkZAYyEqOVCijDry30QyQIMjVXoBACM4u7IpQEzV/o+5EWS4z/8YXMpuQStLZBO2Ex9URVcg8OTXs4PDkwBXu0zYRvDR
 B0Jum6jg
 b0bCRTxzsMhqburei6mm4AwE8ZL+4jn9KiGHFLb5U7WsUYui9297yURLpPevW3N5rSIuiyO8V4LuIIunFwTYwf+wy1/8vsxS98mES7iPFc2xnkLf6C4vLrIop57uousmhBX/Q2c3ksOCVJowu7QyhCo5jQEWyyzNHA9OwseSuwwPKOM//FVzFkfZ8+vqaNDPVKJGSi4xQYgP6VXudYl2nPoBUaAL7t7PFNFLn9Bv1VZukwecCGEMkmpI0ETQ6+KxdfwPOGjbCD/usKMxeuR8/oT0CIgSS+HPpO/dV4SVs43b0yrEN+lhq7/tImbNuQDm9d5pLQMOb5mzkNaoVkKbpRYSSOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 5:38=E2=80=AFAM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
>
>
> On 2/24/26 08:02, Andrei Vagin wrote:
> > On Mon, Feb 23, 2026 at 3:03=E2=80=AFPM Pavel Tikhomirov
> > <ptikhomirov@virtuozzo.com> wrote:
> >>
> >> This effectively gives us an ability to create the pid namespace init =
as
> >> a child of the process (setns-ed to the pid namespace) different to th=
e
> >> process which created the pid namespace itself.
> >>
> >> Original problem:
> >>
> >> There is a cool set_tid feature in clone3() syscall, it allows you to
> >> create process with desired pids on multiple pid namespace levels. Whi=
ch
> >> is useful to restore processes in CRIU for nested pid namespace case.
> >>
> >> In nested container case we can potentially see this kind of pid/user
> >> namespace tree:
> >>
> >>                             Process
> >>                           =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >>     User NS0 =E2=94=80=E2=94=80=E2=96=B6 Pid NS0 =E2=94=80=E2=94=80=E2=
=96=B6 Pid p0 =E2=94=82
> >>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
> >>         =E2=96=BC           =E2=96=BC     =E2=94=82         =E2=94=82
> >>     User NS1 =E2=94=80=E2=94=80=E2=96=B6 Pid NS1 =E2=94=80=E2=94=80=E2=
=96=B6 Pid p1 =E2=94=82
> >>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
> >>        ...         ...    =E2=94=82   ...   =E2=94=82
> >>         =E2=94=82           =E2=94=82     =E2=94=82         =E2=94=82
> >>         =E2=96=BC           =E2=96=BC     =E2=94=82         =E2=94=82
> >>     User NSn =E2=94=80=E2=94=80=E2=96=B6 Pid NSn =E2=94=80=E2=94=80=E2=
=96=B6 Pid pn =E2=94=82
> >>                           =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >>
> >> So to create the "Process" and set pids {p0, p1, ... pn} for it on all
> >> pid namespace levels we can use clone3() syscall set_tid feature, BUT
> >> the syscall does not allow you to set pid on pid namespace levels you
> >> don't have permission to. So basically you have to be in "User NS0" wh=
en
> >> creating the "Process" to actually be able to set pids on all levels.
> >>
> >> It is ok for almost any process, but with pid namespace init this does
> >> not work, as currently we can only create pid namespace init and the p=
id
> >> namespace itself simultaneously, so to make "Pid NSn" owned by "User
> >> NSn" we have to be in the "User NSn".
> >>
> >> We can't possibly be in "User NS0" and "User NSn" at the same time,
> >> hence the problem.
> >>
> >> Alternative solution:
> >>
> >> Yes, for the case of pid namespace init we can use old and gold
> >> /proc/sys/kernel/ns_last_pid interface on the levels lower than n. But
> >> it is much more complicated and introduces tons of extra code to do. I=
t
> >> would be nice to make clone3() set_tid interface also aplicable to thi=
s
> >> corner case.
> >>
> >> Implementation:
> >>
> >> Now when anyone can setns to the pid namespace before the creation of
> >> init, and thus multiple processes can fork children to the pid
> >> namespace, we enforce that the first process created is always the ini=
t,
> >> and only allow other processes after the init sets
> >> pid_namespace->child_reaper.
> >>
> >> To avoid possible problems related to cpu/compiler optimizations aroun=
d
> >> ->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
> >> everywhere we write it and use READ_ONCE everywhere we read it without
> >> explicit lock. Note: we already had READ_ONCE in nsfs_fh_to_dentry().
> >>
> >> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> >>
> >> --
> >> v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
> >> task_list lock for reading it. Rebase to master, and thus remove
> >> now excess pidns_ready variable.
> >>
> >> Note: I didn't find anything in copy_process() around setting the
> >> ->child_reaper which can influence the pid namespace, so it looks like
> >> the pid namespace is fully setup at the point when init sets
> >> ->child_reaper to receive more processes. Thus tasklist lock looks
> >> excess in pidns_for_children_get()'s ->child_reaper check and it shoul=
d
> >> be safe not to have it in the corresponding checks in alloc_pid().
> >> ---
> >>  kernel/exit.c          | 2 +-
> >>  kernel/fork.c          | 2 +-
> >>  kernel/pid.c           | 5 +++--
> >>  kernel/pid_namespace.c | 9 ---------
> >>  4 files changed, 5 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/kernel/exit.c b/kernel/exit.c
> >> index 8a87021211ae..567fc3b7b0f9 100644
> >> --- a/kernel/exit.c
> >> +++ b/kernel/exit.c
> >> @@ -608,7 +608,7 @@ static struct task_struct *find_child_reaper(struc=
t task_struct *father,
> >>
> >>         reaper =3D find_alive_thread(father);
> >>         if (reaper) {
> >> -               pid_ns->child_reaper =3D reaper;
> >> +               WRITE_ONCE(pid_ns->child_reaper, reaper);
> >>                 return reaper;
> >>         }
> >>
> >> diff --git a/kernel/fork.c b/kernel/fork.c
> >> index e832da9d15a4..27d0cdbca67e 100644
> >> --- a/kernel/fork.c
> >> +++ b/kernel/fork.c
> >> @@ -2423,7 +2423,7 @@ __latent_entropy struct task_struct *copy_proces=
s(
> >>                         init_task_pid(p, PIDTYPE_SID, task_session(cur=
rent));
> >>
> >>                         if (is_child_reaper(pid)) {
> >> -                               ns_of_pid(pid)->child_reaper =3D p;
> >> +                               WRITE_ONCE(ns_of_pid(pid)->child_reape=
r, p);
> >>                                 p->signal->flags |=3D SIGNAL_UNKILLABL=
E;
> >>                         }
> >>                         p->signal->shared_pending.signal =3D delayed.s=
ignal;
> >> diff --git a/kernel/pid.c b/kernel/pid.c
> >> index 3b96571d0fe6..e6116e131d8d 100644
> >> --- a/kernel/pid.c
> >> +++ b/kernel/pid.c
> >> @@ -219,7 +219,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pi=
d_t *arg_set_tid,
> >>                          * Also fail if a PID !=3D 1 is requested and
> >>                          * no PID 1 exists.
> >>                          */
> >> -                       if (tid !=3D 1 && !tmp->child_reaper)
> >> +                       if (tid !=3D 1 && !READ_ONCE(tmp->child_reaper=
))
> >>                                 goto out_abort;
> >>                         retval =3D -EPERM;
> >>                         if (!checkpoint_restore_ns_capable(tmp->user_n=
s))
> >> @@ -247,8 +247,9 @@ struct pid *alloc_pid(struct pid_namespace *ns, pi=
d_t *arg_set_tid,
> >>                          * alreay in use. Return EEXIST in that case.
> >>                          */
> >>                         if (nr =3D=3D -ENOSPC)
> >> -
> >>                                 nr =3D -EEXIST;
> >> +               } else if (!READ_ONCE(tmp->child_reaper) && idr_get_cu=
rsor(&tmp->idr) !=3D 0) {
> >
> > I think it is better to update pid_ns_ctl_handler to prevent setting
> > ns_last_pid in a pidns
> > without init. Otherwise, figuring out why fork returns EINVAL can be tr=
icky.
>
> Hm, I think pid_ns_ctl_handler(), as it uses current active pid namespace=
 can
> only work if current is already fully (ns/pid) in the pid namespace, and =
thus
> the init is also already there. So it's implicitly protected from change
> before init creation.
>
> This check here is more for the concurrent alloc_pid() case. When one pro=
cess
> in alloc_pid() successfully allocated the pid and than, for instance, hit=
 the
> pidfs_add_pid() error and is going to free_pid(), but the pid 1 is remain=
s yet
> allocated from idr and the cursor is on 2 at the moment. At the same time=
 the
> concurrent process may get to alloc_pid(), and will see cursor on 2, it s=
hould
> not be able to create a process as this process will get pid 2 and will b=
e
> created before init.
>
> And in general (non concurrent case) it makes sense to only allow allocat=
ing 1,
> for the first process.

In this case, there is likely a race condition. Two alloc_pid() calls
can run concurrently,
where idr_get_cursor() returns 0 in both instances. Consequently, both
will attempt to
allocate PIDs, but only one will actually receive PID 1. I think this
check needs to
be moved after idr_alloc_cyclic() to verify the actual value that was alloc=
ated.


>
> >
> >> +                       nr =3D -EINVAL;
> >>                 } else {
> >>                         int pid_min =3D 1;
> >>                         /*
>
> --
> Best regards, Pavel Tikhomirov
> Senior Software Developer, Virtuozzo.
>

