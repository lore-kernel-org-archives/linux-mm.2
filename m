Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6303C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 18:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC5D6B007B; Thu, 31 Jul 2025 14:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C806B0089; Thu, 31 Jul 2025 14:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192326B008A; Thu, 31 Jul 2025 14:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09F926B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:35:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88D745C454
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:35:04 +0000 (UTC)
X-FDA: 83725411728.21.55A1888
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9DC1C40019
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:35:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GqaV5H2t;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of fvdl@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753986902; a=rsa-sha256;
	cv=none;
	b=WU3i6j10IRt93ZYb+GtczdnYS5lac4fW19D2d9fDIdQ4MC5diMC+Bi8rsZjrPo2wQ+LCOj
	5ztjZwjornUuEirsMHHvKvEAmD541ay1CQMLOw51E4ktJM5FsVsgLcQxVrqXe4j8hTWlzl
	bzCndMreF1YmBCjPiyJFJULLM4UeJrE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GqaV5H2t;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of fvdl@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753986902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sl94WIxMtBCkU36kfiKWNKynhVQAmpLF1VjfHVNOmI=;
	b=4qg+ig1XT7Riga4Vfph4zHDHJ1+58QVHQ6EzPALqVDk3SgyJabEAtedtCBixImDx8QTRsS
	qFnLI2gNPE8qU3urzuf7A41vVCpr+EU0iXNqj/Z8ijSxWOmBNA3ufMnB6qn1CgPIs30thH
	PrvkwsuK5OKqfhl4Ltezeh/3mPtAlrw=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso30311cf.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753986902; x=1754591702; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3sl94WIxMtBCkU36kfiKWNKynhVQAmpLF1VjfHVNOmI=;
        b=GqaV5H2trmIvh6FLJVCwUuFwpgUoFCoWBbyCcBoy4Aj4lqTGxHDU+WCxaXhWowKnbl
         OQmtkU6tGZsYUz177vk6RQzltKRcQd/WW3Mb+1Ig6INZPpxKlypZObnOx+vXoYIQYOoA
         XysHlHo+sWhtRbgVkmIbCQNq5F5aoYuHtVickbXoxlmqjdEi2TpwByeGUbxIbUGO3wpK
         eF1bL3TzuzNJulFwUculD8CKtCNXjq7e8kJ+CQtPIK+ila3vaWYmwX8HQFK14kMlsQMz
         CBnSY92ptuxjX1qUzIpLQc0XqIZHnAoBPC3nzScchpvS+M6a9LqqpSyn5YClGjQ7ZhXt
         HXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753986902; x=1754591702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3sl94WIxMtBCkU36kfiKWNKynhVQAmpLF1VjfHVNOmI=;
        b=g4L+SCMbzhGS093bpu9nWM7twVSGZROfLZvoU6krz6lIzlTR2eVk5jjxvu73DEjN5O
         q5q3mbc0balUNplC3mUrnYYglZR7nTvPG01ontcexNM+VYDU0JeiaKuCwzLJuNqOOxQU
         B1Ddy7LAVyAdbQsvmFM2Jg7q4vw3xf+zFbwngOSOQQ9aTlz0Nnm79PTNIW9D9vn1Xp5d
         OYsc2qmTxsi46UnSIx/gkjdwFxw3JcvzjEKgwohxe74AEew4Vj/hzHvW/y9SHMKy/m8w
         Vllk/C454EllcL7e3mCcfk+Q79sz9oJtV0yuOaDbAEUU2o0RAIULY/QFrnRf7wh+PIBf
         KE9A==
X-Forwarded-Encrypted: i=1; AJvYcCUUKa9u/nBzsAYeSA0/9L/L66gCe+p+qXpSnqXAZTFdlwFcYeypE5xIP0QN6sDIplytjLngnBsp9g==@kvack.org
X-Gm-Message-State: AOJu0YyX3sqPX2Qt5ACv35Y1FB3+YXxABHnC4m47A5cwlVsRCpwRuziW
	OE16pCM0aaHIc+Q3gb8r+fMgV1mgWeUz5thhpQBpdyAD/Tl4TJ89yw5Q4cxSwEL/6YbTmzpbChu
	cPiOMaZcSXNw+Az+hNEXZytBcqVHaKX+wt2KRCw+m
X-Gm-Gg: ASbGncv6S0pKFvjt5GIsPoUyKOZE1CIjKxmjNbvJeKA9lu7b//x8T1I5bdoyDZXAQy0
	YVQYnG8n+v+hhr5J9YfL3hLnhoMGgKLPFCa0Qssj1r9+wL+jRp0SsQIM8W3+AeDPdJ7dzUf1y9Z
	9gA2xI6R3w7lpz4ilAecZKAbuBmJPnFVCWJbV2A7iJBSf2Z9IBT9b1pDISwxh8LOLypqKxpPahZ
	+FE
X-Google-Smtp-Source: AGHT+IG8dwAOmNJsGh6zbRM/I8aJX8Oc13ieikcMJPqAfmSx5slCeVWy09nxhdeNWTrV7C3cx23F34V9sDwqMcPRfbM=
X-Received: by 2002:a05:622a:28d:b0:4a7:1743:106b with SMTP id
 d75a77b69052e-4aefe4c6e4bmr401021cf.6.1753986901330; Thu, 31 Jul 2025
 11:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
In-Reply-To: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
From: Frank van der Linden <fvdl@google.com>
Date: Thu, 31 Jul 2025 11:34:50 -0700
X-Gm-Features: Ac12FXyPY6jyMNK1z0Sa1pOKvQufurZYXqkKaBQWTzR7vxpq5Jd4_LdZXos92u0
Message-ID: <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
Subject: Re: Realtime threads delayed due to kcompactd0
To: Alexander Krabler <Alexander.Krabler@kuka.com>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Dennis Schimmel <Dennis.Schimmel@kuka.com>, 
	Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fs1ww81ea777n494m7boamajy4xo584e
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DC1C40019
X-Rspamd-Server: rspam02
X-HE-Tag: 1753986902-620858
X-HE-Meta: U2FsdGVkX1/nFCc0oW3cTdCN9mUDOmrbF70CnpKwgLkzQbSpfFAh05qVgtK++qSF9f/wLh/8lE7itkj8DOJ2qTXiGkxnEUuM50VgM+ZhY5v0FLUeX+lTl8NrRMXLAMRXYtZdZ2SFVM7++wpkvGaNuV+7hgftn+BLMu9t0PgBCvo4Jd+ou+4uAHna3kDsW3tzV6exSb9QqRL7TWWwD3BR/nx3JSSv/+TPa7lECdaLb/zKgpz8lyHeMY4IPKZBos8lMh53smA1vyI2vsYHspJW1IvV3gKCs3I55nBtZKyhDpVUOh6nL/TRWEl2qEulU+z2hps/0dsC1d1+ehLyf4bGGi26qQ7YfImK9tkQOf4JAJqwxhPRhH6CJePzYvo7YV9WET7mNoIbFgyI9rWSL1yH74WvQO5lLlEw4IT7qQ3DHq0sHrgB7aZ/tbnLAK+iVp+KksU2VKYy0IcbV0bIkdU1Qfr7YzfNU3KeIBs5/lqtMDgsaO6JT0uVmbpyBIfgqo1CPr5/SH+2dz+M97jwi7zhIFyTNyEXi4WqpZ9qQPzGocO9c6M32Rt6X0Eza91rvXFP5Y+Ayvay8LQaGCgXXSQIoPMsKTMe8at9IAc/xMixgTk1fIxTEYvo2HYp+Jd5+yV2HcylpLNiEpMK2nKXB33Z7/W5YG6K/qNsySf80rXFRJ1+jMxwauNwQpgu3/WapwJdAj4sUHOqIA9XpX2c8ucYMxZ73VwHcc5zMg6W+9Is1eJRM5BGV6dGFwbH7/VZCNHGjTeocfWUn5UURplxrVPHTVW7pDKtI1wdNoVtOWM3RNzrrJEwyV0j2qbPv6k77uQ4SWtkMToum89XzRYfkg+HNPqM/o952/AgPj64o9sEqXPk5ursxoQYYNRtCYkxDlYRaE742sxoGATFt8uO7Sl4FOGfzFOUgImefgnB6uEs5ApU6TT9C2W92z53x8K0Et3IZlc5nqIzFE8CtDu09qE
 x12UWeon
 4mtD7zTkqrkcPttHFr99SHq0JZehSRaGTwxEtmDlyFHBjw90IihfqkfDfdbRoLfkDnp7QtXEPhsanNCB8wtVXCyefAX3sB2XwTkgnWv4xZsxm3VwDglb9volnx4XKH/r5GpUcJjfPXCjm0JoBe2i5O+Rn666UuEwTyC0NYEMQx0V3cmS8wVGbYne3qcohcODRbyXw2b1iVzR9GDxBG0TlzJoFmEmQ9wMQXSRl9Gyu9RvaXWhaiM0z957Ts5rctmFH7a1pYlMCtwXvXE35IZCbWVvcwsvXiIxcyPVyBPecsaZIE+KqxlDQvTkrWvh9g5VV+X6LI9/O4lLoNYo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 10:30=E2=80=AFPM Alexander Krabler
<Alexander.Krabler@kuka.com> wrote:
>
> Hi all,
>
> some of our realtime tasks get delayed from time to time due to activity =
of kcompactd0.
> Out of nothing, realtime tasks go into uninterruptable sleep for some tim=
e.
> This delay can be as much as 1.1ms, which is not acceptable for us.
>
> Our hardware is an aarch64-based SOC with 8 A72 cores, kernel is 6.12.17 =
with PREEMPT_RT.
> We have CONFIG_COMPACTION and CONFIG_MIGRATION enabled.
>
> Here are some snippets from ftrace:
>              kcompactd0-88    [001] 13112.100041: mm_compaction_begin:  z=
one_start=3D0x80000 migrate_pfn=3D0x80000 free_pfn=3D0xffe00 zone_end=3D0x1=
00000, mode=3Dsync
> ...
>              kcompactd0-88    [001] 13112.159782: mm_compaction_isolate_m=
igratepages: range=3D(0x85800 ~ 0x85841) nr_scanned=3D65 nr_taken=3D32
>              kcompactd0-88    [001] 13112.159810: mm_compaction_isolate_f=
reepages: range=3D(0xddc40 ~ 0xddc48) nr_scanned=3D8 nr_taken=3D8
>              kcompactd0-88    [001] 13112.160002: irq_handler_entry:    i=
rq=3D11 name=3Darch_timer
>              kcompactd0-88    [001] 13112.160012: irq_handler_exit:     i=
rq=3D11 ret=3Dhandled
>              kcompactd0-88    [001] 13112.160121: mm_compaction_migratepa=
ges: nr_migrated=3D32 nr_failed=3D0
>              kcompactd0-88    [001] 13112.160122: mm_compaction_finished:=
 node=3D0 zone=3DDMA      order=3D-1 ret=3Dcontinue
>              kcompactd0-88    [001] 13112.160185: mm_compaction_isolate_m=
igratepages: range=3D(0x85841 ~ 0x85a00) nr_scanned=3D447 nr_taken=3D166
>              kcompactd0-88    [001] 13112.160204: mm_compaction_isolate_f=
reepages: range=3D(0xddc48 ~ 0xddd80) nr_scanned=3D312 nr_taken=3D196
>               tRealtime-16499 [004] 13112.160511: sched_switch:         t=
Realtime:16499 [25] D =3D=3D> tKRC:16479 [39]
>               tRealtime-16499 [004] 13112.160512: kernel_stack:         <=
stack trace >
> =3D> __schedule (ffffcde843022d6c)
> =3D> schedule (ffffcde843023464)
> =3D> io_schedule (ffffcde8430235ec)
> =3D> migration_entry_wait_on_locked (ffffcde8424a1ad8)
> =3D> migration_entry_wait (ffffcde84254c400)
> =3D> do_swap_page (ffffcde8424f7fac)
> =3D> __handle_mm_fault (ffffcde8424f8b64)
> =3D> handle_mm_fault (ffffcde8424f9bc0)
> =3D> do_page_fault (ffffcde843030380)
> =3D> do_translation_fault (ffffcde84303072c)
> =3D> do_mem_abort (ffffcde84222f674)
> =3D> el0_ia (ffffcde84301eb20)
> =3D> el0t_64_sync_handler (ffffcde84301f020)
> =3D> el0t_64_sync (ffffcde842211514)
>              kcompactd0-88    [001] 13112.160557: sched_pi_setprio:     c=
omm=3Dkcompactd0 pid=3D88 oldprio=3D39 newprio=3D120
>              kcompactd0-88    [001] 13112.160569: sched_waking:         c=
omm=3DtKRC pid=3D16479 prio=3D39 target_cpu=3D004
>              kcompactd0-88    [001] 13112.160986: sched_waking:         c=
omm=3DtKRC pid=3D16479 prio=3D39 target_cpu=3D004
>              kcompactd0-88    [001] 13112.161412: sched_waking:         c=
omm=3DtOther pid=3D16520 prio=3D40 target_cpu=3D004
>              kcompactd0-88    [001] 13112.161457: sched_pi_setprio:     c=
omm=3Dkcompactd0 pid=3D88 oldprio=3D40 newprio=3D120
>              kcompactd0-88    [001] 13112.161465: sched_waking:         c=
omm=3DtOther pid=3D16520 prio=3D40 target_cpu=3D004
>              kcompactd0-88    [001] 13112.161654: sched_waking:         c=
omm=3DtRealtime pid=3D16499 prio=3D25 target_cpu=3D004
>
> In our setup kcompactd0 gets enough CPU time (on core 1), however, it see=
ms strange that it doesn't get the priority inherited from blocked realtime=
 tasks.
> (It does for short amounts of time, which seems to be due to the locks in=
side migration_entry_wait_on_locked.)
>
> Is there anything we can do here?
>
> Thanks,
> Alexander

Yes, we have (likely) seen this issue too, in a !CONFIG_PREEMPT setting.

The basic problem is that the calling thread (kcompactd or it could be
any thread that goes in to direct compaction) creates a resource that
needs to be waited for until it's done, in the form of the migration
PTEs. Since a migration PTE is not a lock that is held by the thread
doing the migration, there is no priority inheritance in the realtime
case, and priority inversion can happen.

This issue has always been there, but it has been made more prominent
with batch migration. With batch migration, all migration PTEs are set
up in the first step, followed by a TLB flush, and then the copy / new
map setup is done. So, the migration PTEs stick around for longer, and
the chance that other threads block on them is higher. For the
!CONFIG_PREEMPT case, the cond_resched() in the loop can also cause
the thread creating the migration PTEs to be descheduled while a
number of migration PTEs are in place, so there is a similar priority
inversion chance.

Not sure what the right thing to do would be. Either explicitly boost
the priority of a thread temporarily during migrate_pages_batch, or
mitigate the issue by dealing with 'busy' pages more quickly in
migrate_pages_batch.

- Frank

