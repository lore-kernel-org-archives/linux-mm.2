Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26F56F5545A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 05:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F946B0005; Wed, 25 Feb 2026 00:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D736B0088; Wed, 25 Feb 2026 00:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329B66B008A; Wed, 25 Feb 2026 00:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAC96B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:32:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0DBE1C425
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:32:56 +0000 (UTC)
X-FDA: 84481859952.09.D7838CE
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id C51FDC0008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:32:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CImoPmkW;
	spf=pass (imf22.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771997575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jxsmk4aiLysalS58AwyTlC9Tr29Psn/XYPzl9fICvE=;
	b=plJKbkorLsoa5Q/7vB5TzTfNdkZi8lONSa0F7J9AsLrd6bOKvatlDILVzFqyAP2pkbwi3g
	PY+vqlmmjiHY4vDKAkD/LF4J/pxlPM7XOQFcsCFFIxWPlKm6VQHijsal3NayiigQCtf8EZ
	GUKvxXROpzmbB7a+OdkfRnvLvPA9LZ4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CImoPmkW;
	spf=pass (imf22.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771997575; a=rsa-sha256;
	cv=none;
	b=Alum2GsYlj/jc5PKGICpFB1EXmxRsqGvIq2Z0vhAOq2FzrVNatdzQEQaF7stARl0uSaYCN
	spK1H7s/VC0g2d4rf2x3DpbTgvb6pq09dSTWn5End/peShJ9BJ26GlOFXuiM+o6a4rYYTh
	R/6xzIuwEnuthf8am2g7tsLg+ljg+V8=
Date: Wed, 25 Feb 2026 13:32:36 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771997572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3jxsmk4aiLysalS58AwyTlC9Tr29Psn/XYPzl9fICvE=;
	b=CImoPmkWMFcn7OlwDBqgB1cnRI7RL/b+Mat+I9M1hfzD5B1PkeNq4CeDzLSqXk6xwyaR1H
	bmrCWwDjEjtUBZ8Uqx6GRXUxgzf7NprdKP27Jh2jt+/bzVyT3oGdf+m+HeqsJ7s5p1B/wB
	nQtrOmb8dWj+xkkojcknGNTqHHTRLY8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Ming Lei <ming.lei@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, surenb@google.com
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <qiqptuqsiaufeasf2xukfzoumiyoau3zfpokosn2amgc6zskc6@vl6ie2h2zj4m>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <aZ0wX_QuxNTxXHMj@hyeyoo>
 <aZ1qRhIGDAR7d56r@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ1qRhIGDAR7d56r@fedora>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ibzzjkiw8j8m3zhwhfk5xpd3xrzf7jwt
X-Rspam-User: 
X-Rspamd-Queue-Id: C51FDC0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1771997574-267644
X-HE-Meta: U2FsdGVkX19hDoNNdWI7L5yq2IufbtJ8GmGQgbKXH1C75kNAtpXQRN2uE6n1GxtfKSJn+fq8ASA6NtYGjNBoArXYohioWvSUACcVPQCGZColrrye8PeHnxzowIS9Uj+8D5yU3ugAOJHOhySjmwSNb624ndZA3xIngtjvNElyfNQVN7wtGomiE6X7huBTp30W5dl6wH+7ZdhnqpVL0sEWqhMIJ7bs602RuO3Bsp3uzVm6YjMI1PM8rHUW415QC58mDpE6fZZqZT84I4csuh8rxotRnvYwfTMtqRSyN7X5lImPrBA8j8Uo/MouM3PvnO7TunLbocnOChbeqYnr76/Z2bKNrrksPHMI6rZtX3sK51Nn8Diij4p9FZ3XExPBPinHzxOk19gIxtaSFhQGBm2zWs9uVx866wDv9trvfFKKmWGFMtvW+3+pth00H4bcaf4Rb7/8vPPHyNonh61JEBybjycT98h8sL+6mEpVllxzvVBJGQlI8j3j8Rd0zqow5PEKQnmZT+yD6bKwLxPfmstP9XipGyKI4y3qDAFE12sXU3ir5Ndvmhya3m1/4BWsUPTzRHRYJN9/7+mwXDLVUzJpsdPXHNVRF3R9XdwgVZOn5ivDHSflUc4qDWxsAY5BlZ2RUfVIGl7MF+g7KdET7TWU+C2bpW7iiRHvo3itDia+h4j2lFJkcrd+riYoviZqUgT1HWOQNWC1TDhrUIiI9sKdaosZfO8Q+AadCYbAbfYmXZRjDSrvWnqx222rTh+0mzRDRj5b6nfGf4IPJb8s2kHK7sH7dvb3TQwTCB39QMIPHcSyWCYOKEwKb27s1gJ1HbGm6z47icC+70R+GJZ4EJp0rSD72tazraFoDdFZnNbqhNuZwEv9G5AZKpuC3y9ZXXVPAQfTxI5qBdyVxOxviytgmpPIViyzbv55YldcVelkTupJgkDXTVjGPTNG2tIG8odab13po1jChuoATQf1f/k
 TytcodwS
 7w1mFFv+2RJXUfbAi0m7rXJ+zhV9mgYLVUMXy8BiPRqlKqfTVzVTcHLuAc1paZ+zjK+MZLMKXWEMklFwdT5Vl1vjWoUblXmaOBXAUTgaES+gxnPe/ZNUOjm4vY4SnOu1fB2W9SmC1XoamnTwzkRgEgardP9pmcco5B4NlYUiSer22GHbxasOCN2f0xKVVH+m6zq+k51kCeGA3lFaKTwzVoea8et4AgLSwMeWd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 05:07:18PM +0800, Ming Lei wrote:
> Hi Harry,
> 
> On Tue, Feb 24, 2026 at 02:00:15PM +0900, Harry Yoo wrote:
> > On Tue, Feb 24, 2026 at 10:52:28AM +0800, Ming Lei wrote:
> > > Hello Vlastimil and MM guys,
> > 
> > Hi Ming, thanks for the report!
> > 
> > > The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> > > 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> > > performance regression for workloads with persistent cross-CPU
> > > alloc/free patterns. ublk null target benchmark IOPS drops
> > > significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> > > drop).
> > > 
> > > Bisecting within the sheaves series is blocked by a kernel panic at
> > > 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> > > paths"), so the exact first bad commit could not be identified.
> > 
> > Ouch. Why did it crash?
> 
> [   16.162422] Oops: general protection fault, probably for non-canonical address 0xdead000000000110: 0000 [#1] SMP NOPTI
> [   16.162426] CPU: 44 UID: 0 PID: 908 Comm: (udev-worker) Not tainted 6.19.0-rc5_master+ #116 PREEMPT(lazy) 
> [   16.162429] Hardware name: Giga Computing MZ73-LM2-000/MZ73-LM2-000, BIOS R19_F40 05/12/2025
> [   16.162430] RIP: 0010:__put_partials+0x2f/0x140
> [   16.162437] Code: 41 57 41 56 49 89 f6 41 55 49 89 fd 31 ff 41 54 45 31 e4 55 53 48 83 ec 18 48 c7 44 24 10 00 00 00 00 eb 03 48 89 df 4c9
> [   16.162438] RSP: 0018:ff5117c0ca2dfa60 EFLAGS: 00010086
> [   16.162441] RAX: 0000000000000001 RBX: ff1b266981200d80 RCX: 0000000000000246
> [   16.162442] RDX: ff1b266981200d90 RSI: ff1b266981200d90 RDI: ff1b266981200d80
> [   16.162442] RBP: dead000000000100 R08: 0000000000000000 R09: ffffffffa761bf5e
> [   16.162443] R10: ffb6d4b7841d5400 R11: ff1b2669800575c0 R12: 0000000000000000
> [   16.162444] R13: ff1b2669800575c0 R14: dead000000000100 R15: ffb6d4b7846be410
> [   16.162445] FS:  00007f5fdccc23c0(0000) GS:ff1b267902427000(0000) knlGS:0000000000000000
> [   16.162446] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.162446] CR2: 0000559824c6c058 CR3: 000000011fb49001 CR4: 0000000000f71ef0
> [   16.162447] PKRU: 55555554
> [   16.162448] Call Trace:
> [   16.162450]  <TASK>
> [   16.162452]  kmem_cache_free+0x410/0x490
> [   16.162454]  do_readlinkat+0x14e/0x180
> [   16.162459]  __x64_sys_readlinkat+0x1c/0x30
> [   16.162461]  do_syscall_64+0x7e/0x6b0
> [   16.162465]  ? post_alloc_hook+0xb9/0x140
> [   16.162468]  ? get_page_from_freelist+0x478/0x720
> [   16.162470]  ? path_openat+0xb3/0x2a0
> [   16.162472]  ? __alloc_frozen_pages_noprof+0x192/0x350
> [   16.162474]  ? count_memcg_events+0xd6/0x210
> [   16.162476]  ? memcg1_commit_charge+0x7a/0xa0
> [   16.162479]  ? mod_memcg_lruvec_state+0xe7/0x2d0
> [   16.162481]  ? charge_memcg+0x48/0x80
> [   16.162482]  ? lruvec_stat_mod_folio+0x85/0xd0
> [   16.162484]  ? __folio_mod_stat+0x2d/0x90
> [   16.162487]  ? set_ptes.isra.0+0x36/0x80
> [   16.162490]  ? do_anonymous_page+0x100/0x4a0
> [   16.162492]  ? __handle_mm_fault+0x45d/0x6f0
> [   16.162493]  ? count_memcg_events+0xd6/0x210
> [   16.162494]  ? handle_mm_fault+0x212/0x340
> [   16.162495]  ? do_user_addr_fault+0x2b4/0x7b0
> [   16.162500]  ? irqentry_exit+0x6d/0x540
> [   16.162502]  ? exc_page_fault+0x7e/0x1a0
> [   16.162503]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

For this problem, I have a hypothesis which is inspired by a comment in the
patch "slab: remove cpu (partial) slabs usage from allocation paths":

/*
 * get a single object from the slab. This might race against __slab_free(),
 * which however has to take the list_lock if it's about to make the slab fully
 * free.
 */

My understanding is that this comment is pointing out a possible race between
__slab_free() and get_from_partial_node(). Since __slab_free() takes
n->list_lock when it is about to make the slab fully free, and
get_from_partial_node() also takes the same lock, the two paths should be
mutually excluded by the lock and thus safe.

However, I'm wondering if there could be another race window. Suppose CPU0's
get_from_partial_node() has already finished __slab_update_freelist(), but has
not yet reached remove_partial(). In that gap, another CPU1 could free an object
to the same slab via __slab_free(). CPU1 would observe was_full == 1 (due to the
previous get_from_partial_node()->__slab_update_freelist() on CPU0), and then
__slab_free() will call put_cpu_partial(s, slab, 1) without holding
n->list_lock, trying to add this slab to the CPU partial list. In that case,
both paths would operate on the same union field in struct slab, which might
lead to list corruption.

> 
> > 
> > > Reproducer
> > > ==========
> > > 
> > > Hardware: NUMA machine with >= 32 CPUs
> > > Kernel:   v7.0-rc (with slab/for-7.0/sheaves merged)
> > > 
> > >     # build kublk selftest
> > >     make -C tools/testing/selftests/ublk/
> > > 
> > >     # create ublk null target device with 16 queues
> > >     tools/testing/selftests/ublk/kublk add -t null -q 16
> > > 
> > >     # run fio/t/io_uring benchmark: 16 jobs, 20 seconds, non-polled
> > >     taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> > > 
> > >     # cleanup
> > >     tools/testing/selftests/ublk/kublk del -n 0
> > > 
> > > Good: v6.19 (and 41f1a08645ab, the mainline parent of the slab merge)
> > > Bad:  815c8e35511d (Merge branch 'slab/for-7.0/sheaves' into slab/for-next)
> > 
> > Thanks for such a detailed steps to reproduce :)
> > 
> > > perf profile (bad kernel)
> > > =========================
> > > 
> > > ~47% of CPU time is spent in bio allocation hitting the SLUB slow path,
> > > with massive spinlock contention on the node partial list lock:
> > > 
> > > +   47.65%     1.21%  io_uring  [k] bio_alloc_bioset
> > > -   44.87%     0.45%  io_uring  [k] kmem_cache_alloc_noprof
> > >    - 44.41% kmem_cache_alloc_noprof
> > >       - 43.89% ___slab_alloc
> > >          + 41.16% get_from_any_partial
> > >            0.91% get_from_partial_node
> > >          + 0.87% alloc_from_new_slab
> > >          + 0.65% allocate_slab
> > > -   44.70%     0.21%  io_uring  [k] mempool_alloc_noprof
> > >    - 44.49% mempool_alloc_noprof
> > >       - 44.43% kmem_cache_alloc_noprof
> > >          - 43.90% ___slab_alloc
> > >             + 41.18% get_from_any_partial
> > >               0.90% get_from_partial_node
> > >             + 0.87% alloc_from_new_slab
> > >             + 0.65% allocate_slab
> > > +   41.23%     0.10%  io_uring  [k] get_from_any_partial
> > > +   40.82%     0.48%  io_uring  [k] __raw_spin_lock_irqsave
> > > -   40.75%     0.20%  io_uring  [k] get_from_partial_node
> > >    - 40.56% get_from_partial_node
> > >       - 38.83% __raw_spin_lock_irqsave
> > >            38.65% native_queued_spin_lock_slowpath
> > 
> > That's pretty severe contention. Interestingly, the profile shows
> > a severe contention on the alloc path, but I don't see free path here.
> > wondering why only the alloc path is suffering, hmm...
> 
> free path looks fine.
> 
> +    2.84%     0.16%  kublk            [kernel.kallsyms]       [k] mempool_free
> +    2.66%     0.17%  kublk            [kernel.kallsyms]       [k] security_uring_cmd
> +    2.57%     0.36%  kublk            [kernel.kallsyms]       [k] __slab_free
> 
> > 
> > Anyway, I think there may be two pieces contributing to this contention:
> > 
> > Part 1) We probably made the portion of slowpath bigger,
> >         by caching a smaller number of objects per CPU
> > 	after transitioning to sheaves.
> > 
> > Part 2) We probably made the slowpath much slower.
> > 
> > We need to investigate those parts separately.
> > 
> > Regarding Part 1:
> > 
> > # Point 1. The CPU slab was not considered in the sheaf capacity calculation
> > 
> > calculate_sheaf_capacity() does not take into account that the CPU slab
> > was also cached per CPU. Shouldn't we add oo_objects(s->oo) to the existing
> > calculation to cache a number of objects similar to the CPU slab + percpu
> > partial slab list layers that SLUB previously had?
> > 
> > # Point 2. SLUB no longer relies on "Slabs are half-full" assumption,
> > # and that probably means we're caching less objects per CPU.
> > 
> > Because SLUB previously assumed "slabs are half-full" when calculating
> > the number of slabs to cache per CPU, that could actually cache as twice
> > as many objects than intended when slabs are mostly empty.
> > 
> > Because sheaves track the number of objects precisely, that inaccuracy
> > is gone. If the workload was previously benefiting from the inaccuracy,
> > sheaves can make CPUs cache a smaller number of objects per CPU compared
> > to the percpu slab caching layer.
> > 
> > Anyway, I guess we need to check how many objects are actually
> > cached per CPU w/ and w/o sheaves, during the benchmark.
> 
> In the workload `fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0`, queue depth
> is 128, so there should be 128 inflight bios on these 16 tasks/cpus.
> 
> > 
> > After making sure the number of objects cached per CPU is the same as
> > before, we could further investigate how much Part 2 plays into it.
> > 
> > Slightly off-topic, by the way, slab currently doesn't let system admins
> > set custom sheaf_capacity. Instead, calculate_sheaf_capacity() sets
> > the default capacity. I think we need to allow sys admins to set a custom
> > sheaf_capacity in the very near future.
> > 
> > > Analysis
> > > ========
> > > 
> > > The ublk null target workload exposes a cross-CPU slab allocation
> > > pattern: bios are allocated on the io_uring submitter CPU during block
> > > layer submission, but freed on a different CPU — the ublk daemon thread
> > > that runs the completion via io_uring_cmd_complete_in_task() task work.
> > > And the completion CPU stays in same LLC or numa node with submission CPU.
> > 
> > Ok, so a submitter CPU keeps allocating objects, while a completion CPU
> > keeps freeing objects.
> 
> Yes.
> 
> 
> Thanks, 
> Ming
> 

