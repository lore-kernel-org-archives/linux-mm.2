Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB5E8D37E5C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57EC6B0005; Wed, 14 Jan 2026 10:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E056A6B0088; Wed, 14 Jan 2026 10:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE83F6B0089; Wed, 14 Jan 2026 10:54:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB2086B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:54:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7121E1A0565
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:54:15 +0000 (UTC)
X-FDA: 84331016070.04.EE31B64
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4DD5E20003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:54:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fWOFHR1I;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768406053; a=rsa-sha256;
	cv=none;
	b=lMpJm1CmyaeFc67h81CCZXsTS2fp3cP/rE4s6+DwlotTyGqfeXv+Co900LAPaJOV5MOjUd
	u3tV8Yyk80AEMx9EblKI2q0nFEWOBN+Br6i7O+kXI96NSyaOdve34Kj6I5QDwLHOtfwyUi
	uZCeZBiNN1/EHcw9yhVlytJbg0uXkvQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fWOFHR1I;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768406053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xs1zwttE7p4/0ur/jP8GIFx6Rfs9HdyvBQXhSiEgK3o=;
	b=qQKAuzL+tX5PsE2FQhVSnOqmcVtNqLXurwnH0CJEWTWWbV9jNe+m3bUC6eqYRrp59772ei
	jRdfKSeu1hjGxVTRVS6DbK1QmJnkHu4aViVBMKoR7Zcgtx12iTYWz2Z6691i4BVMJT/DN2
	T5uSOg83CWk7mC+13O7YMMLzYKFQv/g=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42fbc305914so3748f8f.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768406051; x=1769010851; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xs1zwttE7p4/0ur/jP8GIFx6Rfs9HdyvBQXhSiEgK3o=;
        b=fWOFHR1IKSKbUCeEbGOKFBYz6SxCwpHjowR2cZM/MVn/1ECFvrKTOHsracNcHLgo66
         CdG8fch47C6+e77pmIaiWCFU9KvFrA1Y3ZZPbHseOkq9QjNWeqXXaxi4oDj671Jgdjs4
         xwh4hpdjlIqcVvzRxLy0bt7jppRiyQPR/ORnbBjObFOVK7ChFmKvBqNYKHjPrw4YG2TJ
         LyQ1D2sc7mRwBaqhryCpAcTkf3bSauDnRX+oeflmpkoEL48p4RUvNW444T619vCc6Xd0
         c4SbUdURYhunyrHgxbu2ArNly5cDRyjpHiqaUjIIXcsTucmN2lfb0Vaa6oC4jUmdTM3v
         TN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768406051; x=1769010851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xs1zwttE7p4/0ur/jP8GIFx6Rfs9HdyvBQXhSiEgK3o=;
        b=EF4uc31FYOm2EDo1tCE1Mf+hK1KfsoXFPBsWmmY2uRjl3Ugc6eLAd+5lpb/GsUHrvv
         sFLBo09SS5c+Kf/p3w5YBtHDb8lRZrv4eab/k5GXOB+joz2/j80QsAm0MRns29JDaAYb
         lSw0domhPIQnzUf7OqvWQxCW6+E8LRGXR7ObyLm4+OLHItn1nTMR4ZGPAw1iIlZOrTQv
         KM0GCT3WbZJ843WBSKNB/FvNKt/hR2hI1GRhqdykLzW2R+btlyd6J9bmDcoBa6KQ6BYz
         wIJzzZb7UPT5KU46nJIbuATw/eCSiXz/3puHta0IUgjNUVGoRRcBPyIZceLDL0iosv/Y
         VAkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAVCGT4lR0wWTR2z3TNeNGWbq4yLRJHrdDJZpvurDJfYaFN0kVpgBoSBWbJOlKXm6GeR8mDAOSfw==@kvack.org
X-Gm-Message-State: AOJu0YzMtc6fQ/hDdYF58BE8o5MinlHT+NW0hOPG9uXRTtIeZ3+HtvQ7
	IHJ936fjXITvCwHf1Z8tSTLJ5+j1LFxjPMlmfmygemyOFia3YRuG71whc+MX+d/hbBA=
X-Gm-Gg: AY/fxX6+rNIKvg89Ab+vn/m4thXhGU5O/2uB57lwicVBFhIYHoZkxBBlvXnphjmNvb4
	qo1kEfSCVKZwvP2iqAP8iHY6AFlTdKxMuLHNXlnf2JSp6N+/1QNmBdgqF8//BInsQnKMIWiJ6d/
	PnpK21bYiJ+ypDiG2dQlxvme7YHAZ7no/oW8JcToqA+KqcnubWI+LnDLxBImSt64BzsQEL0iI2b
	2r33I9lSg0gRrO2eWIovmwX70eQakubGRtgwK3UHBirsyxRFhGDEJGputtSrPK82SSKm0t6iI0z
	2lvInuOQCTV+L/PIC08Yv7IF6ygeSrIimitQ5W8ekIh5ki/vKxtal+iAUnmwW9aVXxPgxn5u+Vk
	/i3E+ytdYu2KZSMfcr4lkc4IAuQcHVEhKvsK1/6xR6e8TXs1JDuTW3J5cwW49nMaTQhjIusF3fs
	AfJHGUpljV1ysWprihA4r3Pph7
X-Received: by 2002:a05:6000:40e1:b0:431:54c:6f0 with SMTP id ffacd0b85a97d-4342c4f4d19mr3125206f8f.4.1768406051369;
        Wed, 14 Jan 2026 07:54:11 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe67csm50716588f8f.40.2026.01.14.07.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 07:54:10 -0800 (PST)
Date: Wed, 14 Jan 2026 16:54:09 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	stable@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: Fix OOM killer inaccuracy on large many-core
 systems
Message-ID: <aWe8IdTYEMJt3GTH@tiehlicka>
References: <20260114143642.47333-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114143642.47333-1-mathieu.desnoyers@efficios.com>
X-Rspam-User: 
X-Stat-Signature: zhakiobcgwh7q1opaxexcfo3wynoeaug
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4DD5E20003
X-HE-Tag: 1768406053-774519
X-HE-Meta: U2FsdGVkX1+rtvkcjFjePwDo6bXFYASmT+F34gqlaYbFUPMYZZT2LLMQj0C0lG41pnyksAZZGMM0Nc6f4/CcBxsNyKW9A9s7dbIrp5fCYjVYSWR6Xu3aY/iAI7nHzgLcfWZ60Ek6AH+OEvOI1hBN33TBTWklHe9PlF1FoL8ss/yK/p3c4ua+OUi5K+P9JnhY/dWmASzh3H/7y9di3KP7x0HROL6yYgZBTgp2O5sPyBK7hO0ZlObtOP5Af1jyOmso9ulTO+t2xwmf/fc8/FLgv7k2QQgsy341+GVIQMSJIh7pg2EXGR5+3/eFXPthV9zsItvKiAiOr1vIJTu3d8CTGk1rDF1Bd+QSvM1ek7eViln+ejbWlkMNgJyvtAao7VDweyAct7jR/qYg3HJ5i1lrp8eX5Fc/FDfa7EQZ8wbaXrXNMBASBuzvT2+d4IYbtzjN5A8j0SeMcNQKd+bMxVQ9mRyTTgBLfBbF6Ar/laQLZzH4cI3bNfc0aa2bJlRmawQhv4+ROICOg8nw0pHU/kk2hn+ecT94jdQdyV+fFAp5jcYfk0z00r5Nxs0RGfooffP6aGMiGntUyaNND2RsP0L4HbS96lAcXgt2mZu4l1XJWT5cMUUNnKO/jCcCiygvJMpU1MD5Dm9A48d6Xj5ydkTJYXQ6CczippMYSclAD5vSEUNCxSaS1aNQwph6ARHLtrSWGAk45zDPujiKCg8ZGibHurHhtgeXIZnbYHwZIPIpoHlpxAl3d98LHo0vahCt6OwK1AwMTuteM+KKGI3QbCfmmw93a8rjJKyJieRBBL2ziX/Il5Aj78ds7NUeHPwFeJkwF046jaC3DSntmbkNpoxRcLXkq35hVSbqjsX3TcrFe5PeOUE4Vrv82JAClDSECtb9cfwPGclO9FqbpVmsydj5FCIZ5K1BLn9Rba0QCKQzHDCxxQBVEuHxSUY/RAKSoYACuXplT6GQjomQL5b56Kw
 qyA4C+LO
 8sWbWUKneDsXEQRBEIZOa69jDFWu70IFLRDHEYiYUJhmtwW7sY9GzKnJPUJPZrWa5bQ8Jh7En9PkGl66l9yMb2pSuD//2RPETUSBFWEz8S4TjEEdCbD4mPE2UWnr2eh9uDcfnxKXZx1+Nop9+GmHPEt2pAPnug43QRNexmr2Tsj2K4xsM0R2Qxy9iN/IRcCN6d/24gg1T8fXo5ZgS0Xt0z7USXE3gfpeDXkEfagbMd9agCtENswLUkBK/jK8b2Ewp+TfhJjogmpOQXrfjWPizeoPTAZIDlZ+Fk7W1nsAU9UgFyI7TtJgEwaafMagQOkvq69Ieb33PmuUjb6KfVxA7djRouRBSYnIYcXZ4o2dXgXtmQ14FfOFz1Toh67D3asGcd+rhFeBJ8l5znSP1m5Mw/2bHKWshiQipgwnTbe8G5dZ6igcYCWmtkZ0UdIBuljXTcjpNuPFEGS9bPSgEiWDjeqwsKoTZ0lIiO5kZL7OnEd0vs2Huz0/WvJO7EueN9rc0kl49WomURVA0TD5P82i7pHicELwsV3SBnIf1DvBv/7jmDvZ6b5GEhmnCAhhMcCCYUHla
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-01-26 09:36:42, Mathieu Desnoyers wrote:
> Use the precise, albeit slower, precise RSS counter sums for the OOM
> killer task selection and console dumps. The approximated value is
> too imprecise on large many-core systems.
> 
> The following rss tracking issues were noted by Sweet Tea Dorminy [1],
> which lead to picking wrong tasks as OOM kill target:
> 
>   Recently, several internal services had an RSS usage regression as part of a
>   kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
>   read RSS statistics in a backup watchdog process to monitor and decide if
>   they'd overrun their memory budget. Now, however, a representative service
>   with five threads, expected to use about a hundred MB of memory, on a 250-cpu
>   machine had memory usage tens of megabytes different from the expected amount
>   -- this constituted a significant percentage of inaccuracy, causing the
>   watchdog to act.
> 
>   This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
>   into percpu_counter") [1].  Previously, the memory error was bounded by
>   64*nr_threads pages, a very livable megabyte. Now, however, as a result of
>   scheduler decisions moving the threads around the CPUs, the memory error could
>   be as large as a gigabyte.
> 
>   This is a really tremendous inaccuracy for any few-threaded program on a
>   large machine and impedes monitoring significantly. These stat counters are
>   also used to make OOM killing decisions, so this additional inaccuracy could
>   make a big difference in OOM situations -- either resulting in the wrong
>   process being killed, or in less memory being returned from an OOM-kill than
>   expected.
> 
> Here is a (possibly incomplete) list of the prior approaches that were
> used or proposed, along with their downside:
> 
> 1) Per-thread rss tracking: large error on many-thread processes.
> 
> 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
>    increased system time in make test workloads [1]. Moreover, the
>    inaccuracy increases with O(n^2) with the number of CPUs.
> 
> 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
>    error is high with systems that have lots of NUMA nodes (32 times
>    the number of NUMA nodes).
> 
> commit 82241a83cd15 ("mm: fix the inaccurate memory statistics issue for
> users") introduced get_mm_counter_sum() for precise proc memory status
> queries for some proc files.
> 
> The simple fix proposed here is to do the precise per-cpu counters sum
> every time a counter value needs to be read. This applies to the OOM
> killer task selection, oom task console dumps (printk).
> 
> This change increases the latency introduced when the OOM killer
> executes in favor of doing a more precise OOM target task selection.
> Effectively, the OOM killer iterates on all tasks, for all relevant page
> types, for which the precise sum iterates on all possible CPUs.
>
> As a reference, here is the execution time of the OOM killer
> before/after the change:
> 
> AMD EPYC 9654 96-Core (2 sockets)
> Within a KVM, configured with 256 logical cpus.
> 
>                                   |  before  |  after   |
> ----------------------------------|----------|----------|
> nr_processes=40                   |  0.3 ms  |   0.5 ms |
> nr_processes=10000                |  3.0 ms  |  80.0 ms |
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
> Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

OOM is a rare situation - therefore a slow path - and handling taking
care of a huge imprecesion is much more important than adding ~100ms
overhead to calculate more precise memory consuption.

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

-- 
Michal Hocko
SUSE Labs

