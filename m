Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F2AEE2091
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 12:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3B46B0088; Fri,  6 Feb 2026 07:17:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB296B0092; Fri,  6 Feb 2026 07:17:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD416B0093; Fri,  6 Feb 2026 07:17:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 072826B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:17:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A63311AFF86
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:17:10 +0000 (UTC)
X-FDA: 84413931420.04.1DF3012
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8C3D0160005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:17:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e3q/qh22";
	spf=pass (imf08.hostedemail.com: domain of shicenci@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770380228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3KbSfDNXXjY/R2pjIovNPpLWPAa2pk5y4Jjv749wPk=;
	b=NzpVDzfXGJG6Ay4CDOnr3/gjNslYsOtBamI5geqxlpgIp2uFXmM8z0p52IhpRljR1pc2Iz
	1kgelnBdFNlsg1fxH+KntSHmqLmi/CvDB8QmoRG41mE2xfxwWG2PKmxDnhukxZ+j/N/zWH
	PvH+BqeaC7BwQc1KBqzmpdAiF8pj4L0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e3q/qh22";
	spf=pass (imf08.hostedemail.com: domain of shicenci@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=shicenci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770380228; a=rsa-sha256;
	cv=pass;
	b=6vnFsS5A5e6cV7XlEiqrZtz+Szj+lDKmOUUnfR+UTKJY+uQs9CHkHlX1lOUt88liqPUJc8
	Xn4aHmcuKageqzorTnILaDdDF0Uo9spv/dwwyvAVVvWMvzqF6cj8bTQGJfyARvjcyNJJ2W
	Ys6jBoAYEM3Qq3VZfOtCrUNkSoo60RI=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82361bcbd8fso441372b3a.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 04:17:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770380227; cv=none;
        d=google.com; s=arc-20240605;
        b=Vx59oke37apPfmYDf7b6os3QrW3XpAXudGlXNMjVaGvJtrWu9a5OdqfnckHPQ5F/NN
         SysX8CcvrFzxiSK+8lCKL3KECJlJNkPAFpAgXxvt26/dUN3WMSS6R4qfF8o3Os1VHCcL
         9t0F7v4NnBXFl5craoIiMi9IHOj+PZm5gCWfO7X0ljAqXp5T1s9jx3SbE3dOZzdeW3Nm
         rXCKAxMDYjB0DSq6qcAIWdcWFbyFV2wKomGaSpmXLPWwpD12ClBvOcxN8X65SYUTNYZF
         SnjG+9u+KAiV9d5SPlsq+eJh1L36BSXeqtq+qyq0UKh7fklaL79SeRRDVXPunoPCunj/
         l43Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d3KbSfDNXXjY/R2pjIovNPpLWPAa2pk5y4Jjv749wPk=;
        fh=U3hN0gkvU/0bjsc00SykdLieXae4QLMEznDtCwRIYgs=;
        b=UmBFjqRkW1RagzTz0fMJsIwPAcJhivgvx1V/2W3j9muL3LP4ZPcMxt8Y30Ifu+00+0
         pLjhJ56NZ6e7w5sqqjHSx/IhtaGRv42wn+VkMfoUJS8w/dTe10ZZ4bfcFinQdZfy/+Pb
         nS3Uq3Tn2RiIKoL004bnVpg19+zKpxESXdJ14ZBaqA6CyFMN0MHYUGyakFuZmKVLF59U
         W9XpK/IMcPRHO0mFppOpfXHIir7nrOEOxYV+UHCaUN8orKPgQTtPqShCOO7MjMIzIEWj
         I5z/SLZxssm7EzNvz40kCWPfsN/FOmHOEdunz+ZzOWOP7AOHSYr5K4AkJWGMtx+Mcyfr
         GxqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770380227; x=1770985027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d3KbSfDNXXjY/R2pjIovNPpLWPAa2pk5y4Jjv749wPk=;
        b=e3q/qh22TTnCPaoONY8gYu5pCKtZPTJom8lKx920HVx+vDDJZAI9kAt9haOJaCdnFg
         U/o2w7gA85u8A+3vhzWR2H3qDtxacDtNO++l4hgQwIdRnxuoZPds+G8GBqXvaJtlSxRs
         N5BJo0QHxkU34CmJtX3nApKN3MykvAW5U39/NIy1TrJBALWgemNZbXViuUrWIWsS2kY4
         GqqvIZEmOcv3qUkH/ommI1rmfvQDYDLJ2vEp0J5vYI2F59+p15TBcRsW93POTyuxkBOE
         MsD4DWpYXg/ANsJC6pIwOrCJkXbhJ5E6RLzgIvfNTczUAOx5CX9Q650VnE6nckXKNTFL
         vSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770380227; x=1770985027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d3KbSfDNXXjY/R2pjIovNPpLWPAa2pk5y4Jjv749wPk=;
        b=HTep0Br2V0RAQGcNLMLBb9EFGaNWW+KDjWuFjb4rYSHgtyqXvIOqCaMGI2ZqcOnwgg
         9y4DD/Jl3fbXVwnrJVLQex0soL1/2q9njbT3hT7Vl1M3jT55Vuy9oCTxNjydrlS3DBIS
         IXTZInGqnEiIKUKH3/rSUvH02jv3rDm/j/eZO+MPww8XgvK60ykx5j2H/2daCgg53DuK
         fTiMCOK5elsRzFdRDfW4ZaWXDi0znDoTSGFHv8LAqrjBtpLTWgMvvGrTDS+t0X0jGHdR
         RpS8pcMO/VvYCVeSp5VvvEgxULlBZsfEJc6ie5k5qWeEaOafxTVvjpbY0/b5odoVzb8j
         xXww==
X-Forwarded-Encrypted: i=1; AJvYcCXoZef0PJZfK5R58C6QZ05SXdGYBtvl77LKR9MYOxqfBlUUXk2nLIbC6tGYqy6+To597oO0uffi9g==@kvack.org
X-Gm-Message-State: AOJu0Yw7+GG+T/PcVqZKmeaEECzVtJtU6k926mnUwjVs+sAZSuGQJfsa
	UBQT9bttGJitHDctiCw33Vy0x82WM5VD6BiWYmtHe/uZFv0scXZ4gGHMfnEbgKcw2VETDHkWd0i
	9EYTckAk5oNLw8rf39xbqkK1pvdJPEBE=
X-Gm-Gg: AZuq6aLPmkLAZeqLqj0Uq6GxdnlGlCr4sso8VCrjN1LEhsCESTo/KTD9WmxtIlSHD2q
	NT2g9G6P4FAkoxdEjUTW2iMpnj57w4J/cx3kv23hgat+xyR5154UlNQrORQLdy1ZmE4U1vW/wwQ
	Fa6fJTJ423TpgEU/OmTcwy7bgSc3dGIT4D4yI6khgxxlM5Lqz/eUxa2BvbMAH9VJoic1OPqNfLB
	HwwdJKZ3amsuDdH0NjoDhriAb3HoVJgqFQl016bLmc+N6A5/Pz4nYmnAx9CmJ+X+kuPpLkZNgJW
	JAJ6cQ==
X-Received: by 2002:a05:6a20:72a2:b0:37e:4319:d7c8 with SMTP id
 adf61e73a8af0-393ad4043a5mr2428748637.75.1770380227170; Fri, 06 Feb 2026
 04:17:07 -0800 (PST)
MIME-Version: 1.0
References: <CAPHJ_V+75SmoRQmoQmAT0GfdP-JotzwW801uPHZtHyynwdSOgw@mail.gmail.com>
 <e5ae996b-b5de-46cf-8c1a-532e4852a412@linux.dev> <PS1PPF7E1D7501F6FE46DF307FFB8086E2FAB66A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
In-Reply-To: <PS1PPF7E1D7501F6FE46DF307FFB8086E2FAB66A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
From: Zw Tang <shicenci@gmail.com>
Date: Fri, 6 Feb 2026 20:16:55 +0800
X-Gm-Features: AZwV_QjejJSCC1v7jUQprGWkxeFN35WAUicWGf_C1T0bQ5M7jfVAg14PzKRDigk
Message-ID: <CAPHJ_VL=PVuevdXQC+XTRv9c_JrRDFeCZ8+z7qFvXE9nxHcFeQ@mail.gmail.com>
Subject: =?UTF-8?B?5Zue5aSNOiBbQlVHXSByY3UgZGV0ZWN0ZWQgc3RhbGwgaW4gc2htZW1fZmlsZV93cml0ZQ==?=
	=?UTF-8?B?X2l0ZXI=?=
To: Kunwu Chan <kunwu.chan@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"rcu@vger.kernel.org" <rcu@vger.kernel.org>
Cc: "hughd@google.com" <hughd@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"chrisl@kernel.org" <chrisl@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"paulmck@kernel.org" <paulmck@kernel.org>, "frederic@kernel.org" <frederic@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xpp7qqkfguhr9eoguu3s9emt9icx4n6w
X-Rspamd-Queue-Id: 8C3D0160005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770380228-956018
X-HE-Meta: U2FsdGVkX1/Kmkebq840gsTcjun1ir+nz3vL+tWMr1I0KxIwxLL+7I/cOcnG2s5vVHOgcSrvV5kDHyEw+VNC6whQbWtJcs2yb27tLL/KWpp2i/1y11JPzw3uMhVvMjCswvmfgi097HGhqCxHbRjtYEsDxKui1753Tb+8NTlctnUK+wesZlNbngKqNcIuNTZqd4j5UEI2sssR0wLzOTDBo28yfNZAcoG/Ol5j5vMUnivJfZdezPLQsv5BxTOIGUxskvzEOUhCjEF9g3LX6IeUH/WrzilRuALnKE5BrQutYnaXdXE1RLNBRin79g8cth5QD5nphhLY0QpaShlc+RqnnBiJVdp6ydqWo94b7232GuaSq5QSRsJVaVa0WUNo0NK07zGYeVmKMYBcIoAshGxVOUCh92V9o2ir8/hgk70Dckzw+XoxS9exhmU4r3g89eWFf8B+pbB0Bp3Nva59egaz6P3oPT0izgNtSFrvSs0QSiRw2E+YHTCr4x5zLmRWjmRFJA96CeiQENegTfCdCZTuObXx8cU9ZMbIkU6DCKCbCdU7KqxdIUXkR4sX0c4KZS+MuRG1ZmdwF9uB27ELVxEW4fVkvSDGcv2YZ4pIyNJNLJ5z0WHD2MDVRshR5jXQZ9pMO+2dYX8JfKpiTN62rsD41l4tLCWe+LRI9/0sPlQ71WCt9Yf3EgF6lUGrTzDQy1fw4qT9aENV06N4+7yUyyqwCTSs4MeHcNM9/wZYFYGFnNX5KiUJkK4Tn1nCrggjjjt+6R39Pj6CwEse7ReJynOkIxdL/CCEFr9dHAxlIje6saR5W8i2pMp0fd4yrxVDhk6rtdoVKHI4YwPMacNc1w3Rv0FqjBtMqBnTp4Zky8kxA+YbhaRiwMsQJT1cF6s3BJzyK/WPNuwv72jgO0ImgmPtikYR2Fasi1J7ix+iP5RI1skBAxUOGnViTf68cpzd47bEwEeGIN/WQo99zE2HxkI
 9XLsOZgI
 N1u/JveakvktfF3fFzFrjDL3b38md5QHXfyLRZUm5k4IWCLhPANqiiE2bJNZcfer9Gj84oyspv1b/9Y5uLULtZ6ptMU8YFYYcq98A9amLzRMkfA9ygKDMIddYYIU2vpX6ZCg9SOS8OkHR3CHhz8ptfiOLmY3sHjm8dA84zR3s/Q9hPyizL5VELD+4GpQJgG1vZlWikkabTjkNk+fTAWFdApFB1yY1GfaMxkSMvI/JjMJTB3yOqDtFiHJ6DrAvpoZBxBklh76aJ5itXEhob0JWF76fljx5b+4wfDHYbgtUy9FmiRhLyNJ4CDs+WWditIhdwu6zeKcBJOG/t6Wnffm0jvX2//klVob5rx9gKmZ27IZ3LJOb4lrRnU81HcqQ1ASICu37qQGlzeW8Z2kAmn93ueHuxd+z9slpsQBcYZtoS3B/SYTa3XRwD+PhGqAHEOdHybLHALSNTiZM5G/zws9P7Ubl1Lcefkbwh5Jacqm3varcRHk6qztS+wyZcKwwh3XbKvxYH9rl/ID1WMF8HFILa4LQd6c+hGgSX9szLwu7V42FpGc+kdqn+vFVjzM3qPF5jR/5oIVoryZqFpXV7aA+7z46xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, hi Kunwu,
thanks a lot for the suggestions.
I reran the reproducer with
CONFIG_PROVE_LOCKING=3Dy, CONFIG_LOCKDEP=3Dy, CONFIG_DEBUG_LOCK_ALLOC=3Dy e=
nabled.
Based on the lockdep-enabled run, here is what I can clarify:

Lockdep does not report any lock inversion, recursive locking, or
circular dependency.
The samples showing __mod_zone_page_state() do not appear to indicate
a blocking point; this frame indeed seems to be just where the task
was sampled.

From the timeline of the reports, the earliest problematic behavior
appears before the MM/LRU-heavy paths.
In the first hung-task report, multiple repro1 threads are already blocked =
in:

down_write()
 =E2=94=94=E2=94=80 rwbase_write_lock()
    =E2=94=94=E2=94=80 __rt_mutex_slowlock_locked()
       =E2=94=94=E2=94=80 rt_mutex_schedule()

via the do_vfs_ioctl() =E2=86=92 perf_fasync() path, and are in D state for
more than 143 seconds at that point.
After several threads are stuck there, the system degrades further:
other threads remain in R state, spending long, uninterrupted time in
MM allocation / LRU paths
(alloc_pages(), get_page_from_freelist(), __handle_mm_fault()),
without hitting reschedule points.
This then leads to RCU preempt stalls, and eventually workqueue lockups
(e.g. vmstat_shepherd, do_cache_clean, wb_workfn).
Lockdep=E2=80=99s =E2=80=9Cshow all locks held=E2=80=9D output does not sho=
w the blocked repro1
threads holding any MM/LRU/zone locks themselves; they typically only hold
the filesystem mutex at that point, which suggests the contended RT rwsem
is held elsewhere.
Overall, this currently looks less like a single blocking bug in
__mod_zone_page_state(), and more like a PREEMPT_RT-specific
starvation scenario,
where long-held RT rwsems in the ioctl/perf path combined with long CPU-bou=
nd
MM/LRU execution amplify into RCU starvation and workqueue lockups.
Below is the earliest hung-task report from the lockdep-enabled run
for reference:


[386.499937] INFO: task repro1:2066 blocked for more than 143 seconds.
[386.499956] Not tainted 6.19.0-rc7 #4
[386.499964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[386.499970] task:repro1 state:D stack:28400 pid:2066 tgid:2066 ppid:293 2
[386.500022] Call Trace:
[386.500027] <TASK>
[386.500037] __schedule+0x1198/0x3f00
[386.500069]  ? io_schedule_timeout+0x80/0x80
[386.500088]  ? kvm_sched_clock_read+0x16/0x20
[386.500111]  ? local_clock_noinstr+0xf/0xc0
[386.500125]  ? __rt_mutex_slowlock_locked.constprop.0+0xecd/0x30c0
[386.500148] rt_mutex_schedule+0x9f/0xe0
[386.500171] __rt_mutex_slowlock_locked.constprop.0+0xedc/0x30c0
[386.500197]  ? down_write_trylock+0x1a0/0x1a0
[386.500222]  ? lock_acquired+0xbd/0x340
[386.500245] rwbase_write_lock+0x744/0xa80
[386.500266]  ? perf_fasync+0xc0/0x130
[386.500284]  ? rt_mutex_adjust_prio_chain.isra.0+0x3240/0x3240
[386.500304]  ? kvm_sched_clock_read+0x16/0x20
[386.500329]  ? perf_fasync+0xc0/0x130
[386.500344]  ? local_clock+0x10/0x20
[386.500364]  ? lock_contended+0x189/0x420
[386.500385] down_write+0x6e/0x1e0
[386.500405] perf_fasync+0xc0/0x130
[386.500421]  ? perf_cgroup_css_free+0x50/0x50
[386.500440] do_vfs_ioctl+0x9b9/0x1480
[386.500457]  ? lock_vma_under_rcu+0x7ee/0xd90
[386.500475]  ? ioctl_file_clone+0xf0/0xf0
[386.500490]  ? lock_is_held_type+0xa0/0x110
[386.500506]  ? handle_mm_fault+0x5a6/0x9d0
[386.500526]  ? kvm_sched_clock_read+0x16/0x20
[386.502053]  ? local_clock_noinstr+0xf/0xc0
[386.502073]  ? handle_mm_fault+0x5a6/0x9d0
[386.502092]  ? exc_page_fault+0xb0/0x180
[386.502106]  ? kvm_sched_clock_read+0x16/0x20
[386.502129]  ? local_clock_noinstr+0xf/0xc0
[386.502142]  ? exc_page_fault+0xb0/0x180
[386.502154]  ? local_clock+0x10/0x20
[386.502174]  ? lock_release+0x258/0x3c0
[386.502196]  ? irqentry_exit+0xf0/0x6d0
[386.502213] __x64_sys_ioctl+0x112/0x220
[386.502232] do_syscall_64+0xc3/0x430
[386.502253] entry_SYSCALL_64_after_hwframe+0x4b/0x53
[386.502269] RIP: 0033:0x7f62f7922fc9
[386.502351] </TASK>
[386.502357] INFO: task repro1:2072 blocked for more than 143 seconds.
[386.502366] Not tainted 6.19.0-rc7 #4
[386.502373] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[386.502378] task:repro1 state:D stack:28400 pid:2072 tgid:2072 ppid:294 2
[386.502427] Call Trace:
[386.502431] <TASK>
[386.502439] __schedule+0x1198/0x3f00
[386.502463]  ? io_schedule_timeout+0x80/0x80
[386.502483]  ? mark_held_locks+0x50/0x80
[386.502505] rt_mutex_schedule+0x9f/0xe0
[386.502527] __rt_mutex_slowlock_locked.constprop.0+0xedc/0x30c0
[386.503218]  ? down_write_trylock+0x1a0/0x1a0
[386.503246]  ? lock_acquired+0xbd/0x340
[386.503269] rwbase_write_lock+0x744/0xa80
[386.503290]  ? perf_fasync+0xc0/0x130
[386.503306]  ? rt_mutex_adjust_prio_chain.isra.0+0x3240/0x3240
[386.503327]  ? kvm_sched_clock_read+0x16/0x20
[386.503351]  ? perf_fasync+0xc0/0x130
[386.503366]  ? local_clock+0x10/0x20
[386.503386]  ? lock_contended+0x189/0x420
[386.503407] down_write+0x6e/0x1e0
[386.503427] perf_fasync+0xc0/0x130
[386.503442]  ? perf_cgroup_css_free+0x50/0x50
[386.503461] do_vfs_ioctl+0x9b9/0x1480
[386.503476]  ? lock_vma_under_rcu+0x7ee/0xd90
[386.503493]  ? ioctl_file_clone+0xf0/0xf0
[386.503508]  ? lock_is_held_type+0xa0/0x110
[386.503524]  ? handle_mm_fault+0x5a6/0x9d0
[386.503543]  ? kvm_sched_clock_read+0x16/0x20
[386.504012]  ? local_clock_noinstr+0xf/0xc0
[386.504049]  ? exc_page_fault+0xb0/0x180
[386.504312]  ? irqentry_exit+0xf0/0x6d0
[386.504330] __x64_sys_ioctl+0x112/0x220
[386.504369] entry_SYSCALL_64_after_hwframe+0x4b/0x53
[386.504464] </TASK>[386.504470] INFO: task repro1:2073 blocked for
more than 143 seconds.
[386.504491] task:repro1 state:D stack:28400 pid:2073 tgid:2073 ppid:292 2
[386.504540] Call Trace:
[386.504544] <TASK>
[386.505300] __schedule+0x1198/0x3f00
[386.505347]  ? mark_held_locks+0x50/0x80
[386.505369] rt_mutex_schedule+0x9f/0xe0
[386.505391] __rt_mutex_slowlock_locked.constprop.0+0xedc/0x30c0
[386.505464] rwbase_write_lock+0x744/0xa80
[386.505988] down_write+0x6e/0x1e0
[386.506042] do_vfs_ioctl+0x9b9/0x1480
[386.506301] __x64_sys_ioctl+0x112/0x220
[386.506340] entry_SYSCALL_64_after_hwframe+0x4b/0x53
[386.506434] </TASK>
[386.506442] Showing all locks held in the system:
[386.506447] 4 locks held by pr/legacy/16:
[386.506456] 1 lock held by khungtaskd/37:
[386.506464] #0: ffffffff85041540 (rcu_read_lock){....}-{1:3}
[386.506503] 1 lock held by in:imklog/196:
[386.506513] 1 lock held by repro1/2040:
[386.506522] 1 lock held by repro1/2066:
[386.506532] #0: ffff88800784bc50 (&sb->s_type->i_mutex_key#17)
[386.507276] 1 lock held by repro1/2072:
[386.507284] #0: ffff88800784bc50 (&sb->s_type->i_mutex_key#17)
[386.507321] 1 lock held by repro1/2073:
[386.507328] #0: ffff88800784bc50 (&sb->s_type->i_mutex_key#17)
[427.459692] BUG: workqueue lockup - pool cpus=3D0 node=3D0 flags=3D0x0
nice=3D0 stuck for 40s!
[427.459779] workqueue events:
[427.459809]   pending: vmstat_shepherd, e1000_watchdog
[427.460020] workqueue events_freezable_pwr_efficient:
[427.460020]   in-flight: disk_events_workfn
[427.460052] workqueue writeback:
[427.460084]   in-flight: wb_workfn
[427.460231] Showing backtraces of running workers in stalled
CPU-bound worker pools
Message from syslogd@syzkaller at Feb 6 10:27:59 ... kernel:[
427.459692] BUG: workqueue lockup - pool cpus=3D0 node=3D0 flags=3D0x0
nice=3D0 stuc!

Thanks
Zw Tang

