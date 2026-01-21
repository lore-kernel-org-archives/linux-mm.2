Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144D4D262BC
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 03:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE506B0005; Tue, 20 Jan 2026 22:15:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DE66B0088; Tue, 20 Jan 2026 22:15:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA416B0089; Tue, 20 Jan 2026 22:15:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9E9E6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:15:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 839408C441
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:15:57 +0000 (UTC)
X-FDA: 84354506754.29.7EDDE72
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 924CF140006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:15:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=estNoMzQ;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768965355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ydyvkyDmvAMeNFXDxQm9BUdEMqVjpwfZLhoS4kB4sg=;
	b=A/LzwCAoPvcfah0O+69Yoo8Hne5jHWZuIwtqvIjo5UDpZvDroDnK0sCUZ+Wrb6VcGwLgqp
	p+Hdpq1r5yJMCwaMeyJDIqrhvhy5MCZUmrfITC3CqwLtBjBl1qM8bnLgyQFKxwQMThoALy
	tBkGIcs32UZEAEQbNlVdG2Ow++8huBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768965355; a=rsa-sha256;
	cv=none;
	b=AwcB+ju+N9YP7+xJL4glmpMKT5Cq168Fs+Vu5eJuILfBAMH18+wtzzicvBUTJ6IxXyeVr4
	KlDgLijgUUmvFT4UX04eXEJ6dGR1Ask4l5FHd8P8zqXCYcVQ8XhTKdjN6PvIArV+n90aS2
	PE1Rcik3zL6g9nYFMCkEhLB2rAR8zN4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=estNoMzQ;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 21 Jan 2026 11:15:37 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768965353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ydyvkyDmvAMeNFXDxQm9BUdEMqVjpwfZLhoS4kB4sg=;
	b=estNoMzQ1Vibm68OrSPj+KSNTT/q9ZivjkGi3L2L1IGPLaMO2lE0aKkBCdFLOX0ku8YgdU
	DA532YikRNmaOMQ0Gnkw1lC2UXiAx1cnKoRq0r4S3LoePGIHPbhAxb+OUs84R5aT07MtMc
	cSTrs2RQEYskZlxSWiaOLrBJt24SZeM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>, 
	akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	tim.c.chen@intel.com, yu.c.chen@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <rey5elthflgiygw4lf5zqldlof6nd5b2mq5is7zbgec7zqvr7a@izbte4jmotrq>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
 <3ozekmmsscrarwoa7vcytwjn5rxsiyxjrcsirlu3bhmlwtdxzn@s7a6rcxnqadc>
 <aW86/Nc2+bkopFd7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aW86/Nc2+bkopFd7@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 924CF140006
X-Rspam-User: 
X-Stat-Signature: 8utyfz6tr95nn1sonjmbnud3x6id3mw5
X-HE-Tag: 1768965355-878417
X-HE-Meta: U2FsdGVkX19nH+DUHjE/3UYJrDAwmLg8TmYed/Hpibc/npQ18krUBOvjcgZDuQkV6878d1EwtuPcuR8noh1PqydWS+KBVuKQUcVdhilXMJtSY3FJqBYH/e5Lcu90Y0XGc+GI6qjynDVB9H6/Seai8D/jUUzUP6JvolwQubLtveW/wmuGtMcDuYZWNXpxW1G5pweFZoB1iIIgQdtOdKq5+yPuht0mLcg4Z3aneC1l5yxH/fsrMBaAXSu3dB07yBkxvkeseLVZigqMbljSeN1XUjJgcD1Figwl2kfKm5KMeeGnHcSbK+21y0Rd6JFoWVnyxOIZdhGqgyMObeMQ3nw5l9nSUlngn2urv+Sb2sS9f9oL5dQv8IV/oTX43nzLZBL7ZyBo36613p5uRVbvLJYelrOC/wX3bhOPvq9JHCQa+EsHkS8oCafXCGQTesdRVw3ufSk5s/wcQRhn3lDmjvGlgjTAlUqoYcUOlSKQMIxnv30inU57CoUYaSx9QwvLPhXv8TIbZpvzozRo0uEuqUHUNkiasYL81/WDZc1GgysWb2Ea44hOguyQF2PHqI9nggbUrhgUH6bSg+S7Ca7pO1xCbHrzIpThULJaxBfMH0BScpszB8eBegXapJLA4Dg/cIr2glSvgc0c1shpgc6nHyre/KfDxD45dkeC4llrn4Xv27sJSwj91+vLGpZ1XUHJy4Q+VHHCHxsD1j1VpwAIqrwyWqoQAOlJ2MoJTrfimhJo4nXuGRoX93o1bVbuyLv3W8pNoQy2vGk9wnWiP5px0bWDKwXSTheNvNjdK7+6QOxMaBUs7hDlpz0oDt049vo0v7lKlGf9pE6CSnZPDe8r1qRBYWGJ+DGl5IV0AqwGJB0pZIzN20+QMuffg98IUIqDv3cEqCOoLoWyJYgh8eID2LO3JNAwQKg3FuFbS/rI6GMnAvb7CMC+nniAl26eD+zI3w5QT331ziAMqSFG9GyzkAo
 mYuLjMso
 FK4ZTmKASm4ula0Pdi9/13iO1Ngc86ED1/J8TdUM+nMrhyOFrVwmB/qY7puWo/Nj678AYUqH8lv2pMTNaBtYM+7EoMqWiNpiTSttFKUx2jAsDBOybsVplgWN+FGtV5/Z5ecwIokz9GbykCYHnq8/r/ieuBlQ1LhHuYHOIz4e9U/hvTQLy95SSzoHXYl+lfyRgUlWTQDg5R2vqCP7qAKbOFTPCC8Pid7IXbPHQL2ubGCEfFBsw1z4QkEy01IsXpz6I2I1NhVmu+Wujw8q6cG02uK8ogZ7hagHHzH31ZqpYjqn7UuBc3ZLSo0WKYmCp9iX2kUh4GjFGi4jN7BWt0P6dEx2tmIQwz5WaRvtY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 04:21:16PM +0800, Zhao Liu wrote:

Hi, Zhao,

Thanks again for your thorough testing and detailed feedback - I really
appreciate your help.

> > 1. Machine Configuration
> > 
> > The topology of my machine is as follows:
> > 
> > CPU(s):              384
> > On-line CPU(s) list: 0-383
> > Thread(s) per core:  2
> > Core(s) per socket:  96
> > Socket(s):           2
> > NUMA node(s):        2
> 
> It seems like this is a GNR machine - maybe SNC could be enabled.

Actually, my cpu is AMD EPYC 96-Core Processor. SNC is disabled, and
there's only one NUMA node per socket.

> 
> > Since my machine only has 192 cores when counting physical cores, I had to
> > enable SMT to support the higher number of tasks in the LKP test cases. My
> > configuration was as follows:
> > 
> > will-it-scale:
> >   mode: process
> >   test: mmap2
> >   no_affinity: 0
> >   smt: 1
> 
> For lkp, smt parameter is disabled. I tried with smt=1 locally, the
> difference between "with fix" & "w/o fix" is not significate. Maybe smt
> parameter could be set as 0.

Just to confirm: do you mean that on your machine, when smt=1, the performance
difference between "with fix" and "without fix" is not significant - regardless
of whether it's a gain or regression? Thanks.

> 
> On another machine (2 sockets with SNC3 enabled - 6 NUMA nodes), there's
> the similar regression happening when tasks fill up a socket and then
> there're more get_partial_node().

From a theoretical standpoint, it seems like having more nodes should reduce
lock contention, not increase it...

By the way, I wanted to confirm one thing: in your earlier perf data, I noticed
that the sampling ratio of native_queued_spin_lock_slowpath and get_partial_node
slightly increased with the patch. Does this suggest that the lock contention
you're observing mainly comes from kmem_cache_node->list_lock rather than
node_barn->lock?

If possible, could you help confirm this using "perf report -g" to see where the
contention is coming from?

> 
> > Here's the "perf report --no-children -g" output with the patch:
> > 
> > ```
> > +   30.36%  mmap2_processes  [kernel.kallsyms]     [k] perf_iterate_ctx
> > -   28.80%  mmap2_processes  [kernel.kallsyms]     [k] native_queued_spin_lock_slowpath
> >    - 24.72% testcase
> >       - 24.71% __mmap
> >          - 24.68% entry_SYSCALL_64_after_hwframe
> >             - do_syscall_64
> >                - 24.61% ksys_mmap_pgoff
> >                   - 24.57% vm_mmap_pgoff
> >                      - 24.51% do_mmap
> >                         - 24.30% __mmap_region
> >                            - 18.33% mas_preallocate
> >                               - 18.30% mas_alloc_nodes
> >                                  - 18.30% kmem_cache_alloc_noprof
> >                                     - 18.28% __pcs_replace_empty_main
> >                                        + 9.06% barn_replace_empty_sheaf
> >                                        + 6.12% barn_get_empty_sheaf
> >                                        + 3.09% refill_sheaf
> 
> this is the difference with my previous perf report: here the proportion
> of refill_sheaf is low - it indicates the shaeves are enough in the most
> time.
> 
> Back to my previous test, I'm guessing that with this fix, under extreme
> conditions of massive mmap usage, each CPU now stores an empty spare sheaf
> locally. Previously, each CPU's spare sheaf was NULL. So memory pressure
> increases with more spare sheaves locally.

I'm not quite sure about this point - my intuition is that this shouldn't
consume a significant amount of memory.

> And in that extreme scenario,
> cross-socket remote NUMA access incurs significant overhead — which is why
> regression occurs here.

This part I haven't fully figured out yet - still looking into it.

> 
> However, testing from 1 task to max tasks (nr_tasks = nr_logical_cpus)
> shows overall significant improvements in most scenarios. Regressions
> only occur at the specific topology boundaries described above.

It does look like there's some underlying factor at play, triggering a
performance tipping point. Though I haven't yet figured out the exact pattern.

> 
> I believe the cases with performance gains are more common. So I think
> the regression is a corner case. If it does indeed impact certain
> workloads in the future, we may need to reconsider optimization at that
> time. It can now be used as a reference.

Agreed — this seems to be a corner case, and your test results have been really
helpful as a reference. Thanks again for the great support and insightful
discussion.

-- 
Thanks,
Hao

