Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF7ADCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46038E000B; Tue,  9 Sep 2025 11:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5EF8E0003; Tue,  9 Sep 2025 11:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B978E000B; Tue,  9 Sep 2025 11:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC4888E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:38:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A708C05E5
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:38:47 +0000 (UTC)
X-FDA: 83870119494.01.2B91BD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05FEE18000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:38:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZeNwSRUy;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757432325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLblLw6v5k8EZG3lKUkbVetrV5WMZeBLjgmgqaAwl3M=;
	b=75ulFTf3nIPC+JWn0uMFlJZtxNN4Bu+z6ak5lQQwsC4U8JxTf1+lMyJ2WDQFWT5ZlznN5l
	RqsIroF/mXTi2JMZcVXUiqvOvD68oNc8xPP0fyZrExwmqy8IO1yH9PckZBgcQylvmTSBbV
	cSoyQ8dMKGSV6bkQkBQ4nbAtW+xYSNY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZeNwSRUy;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757432325; a=rsa-sha256;
	cv=none;
	b=FKyd8b1BjrotCagbE5j/h5GYZmPZQrjAwO7+vMHivJI93zifmg8MgdxwGhH5qiF9yWqwQt
	oUOw6QV7BQcsAij6DSkBll+ufu/VzZ7zFSkTysTNGVW1ZRRVh5VhRZvygn9zxN5Imm/APC
	pUOzzDgDhinCJynnU+zqVXZLmm4982Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCF4644D27
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C153FC4CEF9
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757432323;
	bh=H59vSg6yqfeTagI2KSz0Mh1AfpBoCyroWytvOOs3WK4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZeNwSRUyi9tF9LsPemQ+0THBknwkv8YOxgR7tleEpBzdPsaACKTvX3/TSLmqwVPZc
	 doSr+a62KpXTOE9kA7z+bvAKQhaKOLVunEewU68i/MsfvHrd8jiPBITcEMe3yzLiar
	 Fyk6jdXPZN4F53RViFM96NMa0toe0bXjYRB3mFSxc9+eAYeYqrQCoXV7Xzrjf2XNC+
	 Bk4bCla7U31Bo5+5/+7QM6Mx64S84FvK/MJmIp1BvkyGnPSBC8Xu48UOeC9fIpag+D
	 xH9p8aP3hdMIdtQo5yr0AmEfdycPmwjE6sue7UgdQoU/Ary3CGUs3g+TbVL3upndGB
	 /BZvGTDGSKU1Q==
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-408c236c500so508355ab.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:38:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVZgI31AwbO1GySijcZWfPnbBQWURCQNXq87jwY90TSMYU/Adci1zgkofvji2stId7BxGBb8uSe8A==@kvack.org
X-Gm-Message-State: AOJu0YxxQZBosJFJ18u4zaFsMYluRUEosKUtSd+DAhUGV8AFiInLki5y
	wqHf0fHZQeocuDI+qbHmQiSckbKftwOR250KiCcMaY50fZfIs3u3h4a8zgbCWDbDwrJ0n1xvdU5
	Izo40Rmg2ivMomucgYYCMs22hwgYlz+8wQ6n7L42J
X-Google-Smtp-Source: AGHT+IGBqVO3oKD8XjGxL3juBwWFjRrPmj4mgsVkHCfdV6oZc06DcMQABIJXslbc8xt54PHxByce6Tv2wQ2REfxHIBc=
X-Received: by 2002:a05:6e02:219a:b0:40b:590b:7d98 with SMTP id
 e9e14a558f8ab-40b590b7e67mr11544725ab.8.1757432322295; Tue, 09 Sep 2025
 08:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <CAMgjq7Ca6zOozixPot3j5FP_6A8h=DFc7yjHKp2Lg+qu7gNwMA@mail.gmail.com>
In-Reply-To: <CAMgjq7Ca6zOozixPot3j5FP_6A8h=DFc7yjHKp2Lg+qu7gNwMA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 9 Sep 2025 08:38:29 -0700
X-Gmail-Original-Message-ID: <CAF8kJuN7cw2TBKvjPZQER8Yh586pwahMSSou5P0=TFL+vtd1=Q@mail.gmail.com>
X-Gm-Features: Ac12FXyeFnTZyXJdqqEHEE7Eg5jvsdu3zTidMhrtm5s_2H33PC3oRecmiAsko9Q
Message-ID: <CAF8kJuN7cw2TBKvjPZQER8Yh586pwahMSSou5P0=TFL+vtd1=Q@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Kairui Song <ryncsn@gmail.com>
Cc: Lei Liu <liulei.rjpt@vivo.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, 
	Hao Jia <jiahao1@lixiang.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Oleg Nesterov <oleg@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Fushuai Wang <wangfushuai@baidu.com>, 
	"open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 05FEE18000F
X-Stat-Signature: 9n35qqu7hxjeam6s6cb7y3m1bxh43c6x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757432324-490072
X-HE-Meta: U2FsdGVkX19F3CUHswQWQ8yrP1xgX448J11CZxudLnSTJyzBX4jy6Fan7GOJ+dTgywC1xVo+lZCJSymygDjo+FC95xT1NAuy/Bfn26jnyjXiDT1e8rMuYDzZ+c4AzkcADc2TKif/E5HY+ija+zb9Dxw7uaPwJahijXB7fg3/1J1QkoLOPUZ1UAtO107rP4xMsIdTbezyJiQN4e6knHOp9MZVEjaP9x2nFaP57LovOTgDMqvvP8J5wgpli2SiUqcNtT0nLdNqphg7TQxEihPqKCd9fZLoyt64gL70tjirgQTCFj+c8s+HjSZ+c+IielJONwjtzOTNs9auFuv0nGhKBZtTy5ivd13OrnBItryMorG8yAymQF6byQlucA0IBTs+MROdULE9tmz/dr3bVSFFk6W+xxOrcqu6sUQggF8ENur9M2OopWxCLTfMm4EvD3jdJv8s6bAPu6J2kTlaWA6/OrnjuqWEzksxlE7lnFmOl99Dj6F2NMiNK4XZ/Na4+a80i1Y626FYOrJLDtLbZJaCC7PSf7DZdWAGBtRqpxneO295MsxXEqBpSRM4cgFDWgKZqib9dqmdN1VLg4bmzsZc9Ow/S4QlhC1ub0mGkvHFEvEHuJaWn+rJv3NLCNhJXSSyXOHySlJXX7HT7mkl+ZzxKHlb94cjcjyw5NkxclD7pO3jrdy5B0DfU4pq4ECesbcHS1+DQ+o1OQ05f+qtbUqWC5vR+sI+DRxCQzFAldUNFj+ybp0wGhSBPluNjmYkzqLgmzVrhzB/t6DkHenw87lVqOtbHmjFkf7fsj/9QR+1aJpn0QDEZtf8FAXqdOrgFcoxDvMA4hHP8KhaHg6CyRhs+8Jex2H6BkR0zWmg0qyAaeQjbqlSNVwfUrb8IO3Bq9eAKYpDMxGWxTSYoU7cUPSOlJFwHN/0pu3/U9xIV/N0HAkvq8IuoBHOblTMuIEW2TbypDiMZ0K7ol9vvG8fYbb
 Hd5xarpx
 6Nm06PsshHbwJ6Ktqf1Aoy2st3gUh/7vaETzGlgqX2jRQejIrOhusQszSgynLJwXcm3kAYy1Nzf3QOdE4HLqF3j1bv2Q85UDdeyeRFiPkDFZUSpdd4k7jarolBEJgkqculVn2dmfEUy9Ga00ktDJBjEHTJ/fMXuw7nvZHG0/AUfg9pNF7hRIzkzaptJc1LDoI7LGzLnF/Wd+p04fDtGaGJ6JBLURhMfZKgwBnC0ARMZ9Dm/JLHJxYRUsA5vSc4rCbUb3tHq2WxgyEDiwpTeFTrmW1ABzGh3hyi9mfeSXHM3kypbmwWDmE1VBL1bQ8kSBtvgpxEAmPxJuCn9GlG/f2RvOKkau7VF/1v/V/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 12:31=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Sep 9, 2025 at 3:04=E2=80=AFPM Lei Liu <liulei.rjpt@vivo.com> wro=
te:
> >
>
> Hi Lei,
>
> > 1. Problem Scenario
> > On systems with ZRAM and swap enabled, simultaneous process exits creat=
e
> > contention. The primary bottleneck occurs during swap entry release
> > operations, causing exiting processes to monopolize CPU resources. This
> > leads to scheduling delays for high-priority processes.
> >
> > 2. Android Use Case
> > During camera launch, LMKD terminates background processes to free memo=
ry.
> > Exiting processes compete for CPU cycles, delaying the camera preview
> > thread and causing visible stuttering - directly impacting user
> > experience.
> >
> > 3. Root Cause Analysis
> > When background applications heavily utilize swap space, process exit
> > profiling reveals 55% of time spent in free_swap_and_cache_nr():
> >
> > Function              Duration (ms)   Percentage
> > do_signal               791.813     **********100%
> > do_group_exit           791.813     **********100%
> > do_exit                 791.813     **********100%
> > exit_mm                 577.859        *******73%
> > exit_mmap               577.497        *******73%
> > zap_pte_range           558.645        *******71%
> > free_swap_and_cache_nr  433.381          *****55%
> > free_swap_slot          403.568          *****51%
>
> Thanks for sharing this case.
>
> One problem is that now the free_swap_slot function no longer exists
> after 0ff67f990bd4. Have you tested the latest kernel? Or what is the
> actual overhead here?
>
> Some batch freeing optimizations are introduced. And we have reworked
> the whole locking mechanism for swap, so even on a system with 96t the
> contention seems barely observable with common workloads.
>
> And another series is further reducing the contention and the overall
> overhead (24% faster freeing for phase 1):
> https://lore.kernel.org/linux-mm/20250905191357.78298-1-ryncsn@gmail.com/
>
> Will these be helpful for you? I think optimizing the root problem is
> better than just deferring the overhead with async workers, which may
> increase the overall overhead and complexity.

+100.

Hi Lei,

This CC list is very long :-)

Is it similar to this one a while back?

https://lore.kernel.org/linux-mm/20240213-async-free-v3-1-b89c3cc48384@kern=
el.org/

I ultimately abandoned this approach and considered it harmful. Yes, I
can be as harsh as I like for my own previous bad ideas. The better
solution is as Kairui did, just remove the swap slot caching
completely. It is the harder path to take and get better results. I
recall having a discussion with Kairui on this and we are aligned on
removing the swap slot caching eventually . Thanks Kairui for the
heavy lifting of actually removing the swap slot cache. I am just
cheerleading on the side :-)

So no, we are not getting the async free of swap slot caching again.
We shouldn't need to.

Chris




>
>
> > swap_entry_free         393.863          *****50%
> > swap_range_free         372.602           ****47%
> >
> > 4. Optimization Approach
> > a) For processes exceeding swap entry threshold: aggregate and isolate
> > swap entries to enable fast exit
> > b) Asynchronously release batched entries when isolation reaches
> > configured threshold
> >
> > 5. Performance Gains (User Scenario: Camera Cold Launch)
> > a) 74% reduction in process exit latency (>500ms cases)
> > b) ~4% lower peak CPU load during concurrent process exits
> > c) ~70MB additional free memory during camera preview initialization
> > d) 40% reduction in camera preview stuttering probability
> >
> > 6. Prior Art & Improvements
> > Reference: Zhiguo Jiang's patch
> > (https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.com=
/)
> >
> > Key enhancements:
> > a) Reimplemented logic moved from mmu_gather.c to swapfile.c for clarit=
y
> > b) Async release delegated to workqueue kworkers with configurable
> > max_active for NUMA-optimized concurrency
> >
> > Lei Liu (2):
> >   mm: swap: Gather swap entries and batch async release core
> >   mm: swap: Forced swap entries release under memory pressure
> >
> >  include/linux/oom.h           |  23 ++++++
> >  include/linux/swapfile.h      |   2 +
> >  include/linux/vm_event_item.h |   1 +
> >  kernel/exit.c                 |   2 +
> >  mm/memcontrol.c               |   6 --
> >  mm/memory.c                   |   4 +-
> >  mm/page_alloc.c               |   4 +
> >  mm/swapfile.c                 | 134 ++++++++++++++++++++++++++++++++++
> >  mm/vmstat.c                   |   1 +
> >  9 files changed, 170 insertions(+), 7 deletions(-)
> >
> > --
> > 2.34.1
> >
> >
>

