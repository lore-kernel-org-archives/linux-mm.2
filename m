Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C4E9F357D5
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45CB96B0005; Wed, 25 Feb 2026 02:07:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A516B0088; Wed, 25 Feb 2026 02:07:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBC56B008A; Wed, 25 Feb 2026 02:07:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 197ED6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:07:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90EFF16029C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:07:03 +0000 (UTC)
X-FDA: 84482097126.10.6BA3BA0
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90557100003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:07:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dzQKIHxm;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772003222; a=rsa-sha256;
	cv=none;
	b=tpvLQxtbQWh2N7FZ++DQupypg0lscccTVas+NlAuk2ksVkgCLi7ssvs9uif8tqkvstTeiE
	A9Fb6cI3A2fO5+2Cfwc26/f0t7vrNUrVmu62lVX6xkE3tEraS4SpxaL1Hl7G/F9QFDifO2
	Wu/IajGAFoHqGOCImEQSpZULdvarenk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dzQKIHxm;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772003222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XCqGwE2JITi+kn+HyNQ55mzrR4dNxt4VlIjP1tP+zg=;
	b=buLVnZCE6GpxPlFUUJNlAiZUBsmwRZ+K5eMigxKeF+1Te4U8XDqFYtKSMULUQRCy2ypK70
	XCJxKgLneNtxxumYxzSR0plBJIdE/NBMrnzWd/UBFwe7l4Tsj9BJqHzQXeDkJinwcImfWr
	mxM7Kb9nRoPQ85QgVkywayGnFJ8ZMaQ=
Date: Wed, 25 Feb 2026 15:06:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772003219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2XCqGwE2JITi+kn+HyNQ55mzrR4dNxt4VlIjP1tP+zg=;
	b=dzQKIHxm7dbe1pGFIYt7fFjcQk5E1h3vzOTZygUNDAm35NZPiwaM89uQx9OF+X3qbsJx90
	v5Nq9bqlyB7pQfueQt0u+7ki47sla6afPhY4Dbq5gK0yZn8vw34aZHVQlZM1BltVofHY0W
	/35Vct7R9sC8s7Gvtf1LSukzKw5M8zg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, surenb@google.com
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Message-ID: <zn7q75k7u2mspvmspwiao6245kmaahti3kwagablp3advcx5ga@5d36ctyi2a35>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <aZ0wX_QuxNTxXHMj@hyeyoo>
 <aZ1qRhIGDAR7d56r@fedora>
 <qiqptuqsiaufeasf2xukfzoumiyoau3zfpokosn2amgc6zskc6@vl6ie2h2zj4m>
 <aZ6cjpU36_EmXslf@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ6cjpU36_EmXslf@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 90557100003
X-Stat-Signature: 5k1he56r37pyjmef6dqoxq1mhz947zu5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772003221-839061
X-HE-Meta: U2FsdGVkX1+03XTwNnZUFwzw4sTD6lc8GsHMoycxqMib4Rdd4QG2RWFg0VHPhx5tvR2uJ/attv6/aeTndqBtQcbwWO8+pZq+Y+pusp49lRam2w5xwFFQxsnWwBn62l2+tVcNM9UngM41bqjm2DwWN3rduUH3Yn4YmroXa2F8+NfZBhazDYT/jPVyu9BcqkbXFPBO9ZwdM9IWZgV2f/VeE3I1gBxQ05g6uOMEFIe/olIjBir0woR0+G9yRByq9qj/auM9mIEa8NxGaGlPFYKKVgw3H4bR6DZNm9fDg7tioQ3AQe6Ny/n5qo5nFUASe/RmYM9YdEibo5+zja1TAP+K300+p1nyBEqnAqj+Kyj8ESrQvwr9PnVsaXe10UooYECpSbgij8t/PbJkulYOs8iGSovuNLfSwhotTP/EgkdADX31/H3ukqvp1bKhheZqczOIp2m3F2Vg0w6rJXdemmpJ1W0Nbwbhtpsw9qICI70n/ui3voy8sAs1/wG+eQnEtEjdhoTeSDQNhFQb1wOqXJAljh7foiKoXFz9cQ7Lj667PZl9pNqJougARjw/0jb6QBnEWbtwhFO/XRemoGTCP9vatWSpbv4x5L6SvA0Pf67csyfBKawFuCoQuNdq+N2vXIUGpboJPTVehlExZ+oHLxKKm2pPErK/M6qHrKgi/b5HUOMyrmOmLEUWTZ18Wq/8dAdKGTAXeVGwcVGPiCZb8ui8sXAkOCohjuVoafYMBJWGp6/OD5x4Lco4lKusJxkUmCdaxiSKB1YGR7nUETPuKRXzcLa7UGv6iy8JZhvO2+L5tEX+EQ6rYwb3Q5cXzYTDKNtQ2SDSIFTvhsNo6qocreJlcsPCSBz8ngCIRU0+L1GZWQvSJ6xxzKNHSv2dWJULTBu/flxIlayADHeqUKyACx/OKgFyCU+vt9yhFmjBVoQ8VVZdxIr0q/Chved1172CVoouWDkkl+j7/2Jq9ky8YtA
 rQ2MN8pt
 TZHYc3lzRLIPf7WUGEMG6OyJi03Kn94j/ZM7u37w6MonHMa62H4Z4aeL4cvSUSN9OEKGzCP9fjA0HzGTddZGjXCwzo0pYy3xY0Q6dX89/HwDis6CgGy9mtuWj7gYQfIivZQrvBCjnUeYUmoi377IDVSaeJjxiun1RWzD4JKqlqrDLnW4r55/usEfPSY3u0UIXwYhzwowjPRnv5TA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:54:06PM +0900, Harry Yoo wrote:
> On Wed, Feb 25, 2026 at 01:32:36PM +0800, Hao Li wrote:
> > On Tue, Feb 24, 2026 at 05:07:18PM +0800, Ming Lei wrote:
> > > Hi Harry,
> > > 
> > > On Tue, Feb 24, 2026 at 02:00:15PM +0900, Harry Yoo wrote:
> > > > On Tue, Feb 24, 2026 at 10:52:28AM +0800, Ming Lei wrote:
> > > > > Hello Vlastimil and MM guys,
> > > > 
> > > > Hi Ming, thanks for the report!
> > > > 
> > > > > The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> > > > > 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> > > > > performance regression for workloads with persistent cross-CPU
> > > > > alloc/free patterns. ublk null target benchmark IOPS drops
> > > > > significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> > > > > drop).
> > > > > 
> > > > > Bisecting within the sheaves series is blocked by a kernel panic at
> > > > > 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> > > > > paths"), so the exact first bad commit could not be identified.
> > > > 
> > > > Ouch. Why did it crash?
> > > 
> > > [   16.162422] Oops: general protection fault, probably for non-canonical address 0xdead000000000110: 0000 [#1] SMP NOPTI
> > > [   16.162426] CPU: 44 UID: 0 PID: 908 Comm: (udev-worker) Not tainted 6.19.0-rc5_master+ #116 PREEMPT(lazy) 
> > > [   16.162429] Hardware name: Giga Computing MZ73-LM2-000/MZ73-LM2-000, BIOS R19_F40 05/12/2025
> > > [   16.162430] RIP: 0010:__put_partials+0x2f/0x140
> > > [   16.162437] Code: 41 57 41 56 49 89 f6 41 55 49 89 fd 31 ff 41 54 45 31 e4 55 53 48 83 ec 18 48 c7 44 24 10 00 00 00 00 eb 03 48 89 df 4c9
> > > [   16.162438] RSP: 0018:ff5117c0ca2dfa60 EFLAGS: 00010086
> > > [   16.162441] RAX: 0000000000000001 RBX: ff1b266981200d80 RCX: 0000000000000246
> > > [   16.162442] RDX: ff1b266981200d90 RSI: ff1b266981200d90 RDI: ff1b266981200d80
> > > [   16.162442] RBP: dead000000000100 R08: 0000000000000000 R09: ffffffffa761bf5e
> > > [   16.162443] R10: ffb6d4b7841d5400 R11: ff1b2669800575c0 R12: 0000000000000000
> > > [   16.162444] R13: ff1b2669800575c0 R14: dead000000000100 R15: ffb6d4b7846be410
> > > [   16.162445] FS:  00007f5fdccc23c0(0000) GS:ff1b267902427000(0000) knlGS:0000000000000000
> > > [   16.162446] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   16.162446] CR2: 0000559824c6c058 CR3: 000000011fb49001 CR4: 0000000000f71ef0
> > > [   16.162447] PKRU: 55555554
> > > [   16.162448] Call Trace:
> > > [   16.162450]  <TASK>
> > > [   16.162452]  kmem_cache_free+0x410/0x490
> > > [   16.162454]  do_readlinkat+0x14e/0x180
> > > [   16.162459]  __x64_sys_readlinkat+0x1c/0x30
> > > [   16.162461]  do_syscall_64+0x7e/0x6b0
> > > [   16.162465]  ? post_alloc_hook+0xb9/0x140
> > > [   16.162468]  ? get_page_from_freelist+0x478/0x720
> > > [   16.162470]  ? path_openat+0xb3/0x2a0
> > > [   16.162472]  ? __alloc_frozen_pages_noprof+0x192/0x350
> > > [   16.162474]  ? count_memcg_events+0xd6/0x210
> > > [   16.162476]  ? memcg1_commit_charge+0x7a/0xa0
> > > [   16.162479]  ? mod_memcg_lruvec_state+0xe7/0x2d0
> > > [   16.162481]  ? charge_memcg+0x48/0x80
> > > [   16.162482]  ? lruvec_stat_mod_folio+0x85/0xd0
> > > [   16.162484]  ? __folio_mod_stat+0x2d/0x90
> > > [   16.162487]  ? set_ptes.isra.0+0x36/0x80
> > > [   16.162490]  ? do_anonymous_page+0x100/0x4a0
> > > [   16.162492]  ? __handle_mm_fault+0x45d/0x6f0
> > > [   16.162493]  ? count_memcg_events+0xd6/0x210
> > > [   16.162494]  ? handle_mm_fault+0x212/0x340
> > > [   16.162495]  ? do_user_addr_fault+0x2b4/0x7b0
> > > [   16.162500]  ? irqentry_exit+0x6d/0x540
> > > [   16.162502]  ? exc_page_fault+0x7e/0x1a0
> > > [   16.162503]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > 
> > For this problem, I have a hypothesis which is inspired by a comment in the
> > patch "slab: remove cpu (partial) slabs usage from allocation paths":
> > 
> > /*
> >  * get a single object from the slab. This might race against __slab_free(),
> >  * which however has to take the list_lock if it's about to make the slab fully
> >  * free.
> >  */
> > 
> > My understanding is that this comment is pointing out a possible race between
> > __slab_free() and get_from_partial_node(). Since __slab_free() takes
> > n->list_lock when it is about to make the slab fully free, and
> > get_from_partial_node() also takes the same lock, the two paths should be
> > mutually excluded by the lock and thus safe.
> > 
> > However, I'm wondering if there could be another race window. Suppose CPU0's
> > get_from_partial_node() has already finished __slab_update_freelist(), but has
> > not yet reached remove_partial(). In that gap, another CPU1 could free an object
> > to the same slab via __slab_free(). CPU1 would observe was_full == 1 (due to the
> > previous get_from_partial_node()->__slab_update_freelist() on CPU0), and then
> >
> > __slab_free() will call put_cpu_partial(s, slab, 1) without holding
> > n->list_lock, trying to add this slab to the CPU partial list.
> 
> If CPU1 observes was_full == 1, it should spin on n->list_lock and wait
> for CPU0 to release the lock. And CPU0 will remove the slab from the
> partial list before releasing the lock. Or am I missing something?
> 
> > In that case,
> > both paths would operate on the same union field in struct slab, which might
> > lead to list corruption.
> 
> Not sure how the scenario you describe could happen:
> 
> CPU 0					CPU1
> - get_from_partial_node()		
>   -> spin_lock(&n->list_lock)		
> 					- __slab_free()
>   -> __slab_update_freelist(),
>      slab becomes full
> 					-> was_full == 1
> 					-> spin_lock(&n->list_lock)

In __slab_free, if was_full == 1, then the condition
!(IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && was_full) becomes false, so it won't
enter the "if" block and therefore n->list_lock is not acquired.
Does that sound right.

-- 
Thanks,
Hao

> 					// starts spining
>   -> if (!new.freelist)
>   ->   remove_partial()
>   -> spin_unlock()
> 					-> spin_lock(&n->list_lock)
> 					   // acquired!
> 					-> slab_update_freelist()
> 					-> spin_unlock(&n->list_lock)
> 
> -- 
> Cheers,
> Harry / Hyeonggon

