Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606746075277
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=vbENG5pM
Received: by kanga.kvack.org (Postfix)
	id 73C566B00EF; Wed,  4 Nov 2026 15:36:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3656B05B0; Wed,  4 Nov 2026 15:36:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6031E6B05B1; Wed,  4 Nov 2026 15:36:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38E9F6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:36:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50C20C0868
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:36:28 +0000 (UTC)
X-FDA: 85398594456.12.4226961
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id D868F180007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:36:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vbENG5pM;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793824586;
	b=hk9/hnxCK1h4oWQJXSAocn9zLn9sPalPuJ24nHAacsFzxdrrjcOegZH4hm2sUwtbKyFzEv
	/BiNRYsPzite8s83icAzTPpTCGcIu7sKiXv6bmC/Bnsao3AgnHn1PU9RASIIZpht2obmAj
	G1aKiX1lwIp8F3pK5xzRxpKRdvMI5mo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vbENG5pM;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793824586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCMzvSK1epGA9+lRudwHqYr59t2ZKHW6DGF2kDO70B8=;
	b=oPPT1rbT0mu+B7iqRNe+Sggn+4xjgSl46eCgsU3h3nv63pisMkbhhZi9Js4nfS2WqCsDkm
	osbmo1eCFwMlJzr8c7DoYovGkIcz1oav5KKMcBYa9dTJwemVb7bavU8nfnK/SoTty3UhV+
	cyvkW3P4+pyuYCapwDahvIXnPZHywQg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vCMzvSK1epGA9+lRudwHqYr59t2ZKHW6DGF2kDO70B8=; b=vbENG5pMHkNsoywSCA4/ow+ZSS
	+QLr6VTAT+vMrmhfBcbmtbzorx0FMM64G40PhLCLv1mO79YD/mulJzFJqh75qhCVSdcs41b9Kcy3X
	isGkiRGDMTLfvqyeJwMi6EVEEz54nEfcskQpGFplXujV+Q4iH3apmbPmD93BXYTwceVgpjIdg/qeJ
	4Pnd5ZrXY6kwrXqrai1YXZHOpKL55+KA36auGuXXf7y/fNYN4hD3rRIvrm9ED+4P8IYZMgcda/0m3
	RW38iUf6/I/3BlXP/E/D96xzneTQ7Sjd48XXRDjxO9mltJSqRrSh8BQRxDW9y6SyCP86rA9Igqqsx
	1w3yIPHw==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOhiZ-0000000GqWd-1flq;
	Wed, 04 Nov 2026 20:36:23 +0000
Date: Wed, 4 Nov 2026 20:36:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: =?utf-8?B?6JGj6L6J?= <donghui@xiaomi.com>
Cc: "linux-rt-devel@lists.kernel.org" <linux-rt-devel@lists.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?utf-8?B?55Sw5a2d5paM?= <tianxiaobin@xiaomi.com>,
	=?utf-8?B?5p2O6bmP56iL?= <xiaoyaoli@xiaomi.com>,
	=?utf-8?B?5a6B5bem5paM?= <ningzuobin@xiaomi.com>,
	=?utf-8?B?5a6B5Y2a?= <ningbo1@xiaomi.com>
Subject: Re: [RFC] PREEMPT_RT: livelock between lockless page cache lookup
 and the folio freeze->removal window
Message-ID: <auuXR0SnvTx-T2iF@casper.infradead.org>
References: <c2ff0c66422c4e2d869499a1186ff0ae@xiaomi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2ff0c66422c4e2d869499a1186ff0ae@xiaomi.com>
X-Stat-Signature: or381p7njhhm16xiype4qubw9474f7iu
X-Rspamd-Queue-Id: D868F180007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793824585-589903
X-HE-Meta: U2FsdGVkX1/tUKvWfTd1PmGasKOY6ncxUurlJyKVqdG9R9H+PzHt4guHJvT8OaixCKTPFvOIvNESUyTqOFna67PsqxqrKKpWUGxy07Y5EqXPnkDPr0B+GIOs9MSsJFhzY1YwQXkQvr27M0BlkuigQHyGk2+TvNIqMRRsRg/0Bi9umKUJW4s1tH43YshLvkji2b8iJ7vuEHWhUpSvDU30fqINb13xrVG34Ycw8n8q8lX8dGt9n6uUVz2JRuCHYRt8uU6z/CY++bmfXQjb5XcL5iz8ykTs74tLDInFQ4HuyX06Kw36SFVPjSIQxLrnZaeYUdn96VTJgKHnR0GlnyDsE4x4i5TvnvydEwaFiaGx5KT2uc8rmwpWREqyIgRAV0ujYHWF2X9xHCex8x+fy3rrUZ1HdNno6g36R+nMFsWLuoIS3Sf+b3i69hn+BTp1aiIdKrlMQU4OBp7B4caKBk/jPGbWiQngcJPkVLhomLoWNi3GYdkhQNbeUXtbnYq41jLduGiKTt2Lx1LQfXjaamqE12nE98AYN3icthkywAX43Zuqsb+ln9ezI+B6s4Vx8Z0maC5q1pRF9KV9WPJfnjGRQqQt8hX6wIh0qOsL0g4hGKOA/hVKhQr9fywjHVBiXPl6ePoxhyCeNt1j0gTVyIdRbH4q8A2qtrvFGowlM8h4VWiMYZFsoKxQb3154P1jPl7NRwbF4fAC77Gxk2pRzosONTQZbz9TWXAd7eAoErlEPWlTQkEGv7574NJthLbLLPayRqkXPuEGWstALUV8V91wEMdN7/5v59CTADgyWwSiNF2mA3RF/6M1E5yWXnB4MibGv5100CC21MmKuY0u8BDYE+3LEpBYX0C4H/Ip5Vhkk1IdUA4EDk3xibTnpPpBDuAEN1a6QOX4C2mc9NPpuUbR9DZGo5pCe/Xiw9LNF0tGu4I37DwECO+PEXOQwl6Mdok6+ItidCj6j+ZmlWFqfjb
 9Vq63MXP
 z9Tm7F/1KJYhdcmGkDScVGQRnTC5ae7KlhTIpwBkNYgFw4HtSf1pypinDntSNGObh4VFZvybDvr8bwuNoNKSY4MpE2D1ssqz3XGsROjD9aFKATfcsWhO3ehEoXCA+Wru+sGklWOqAKb35FhPMqTmbryUh5Xjx6pACjKHxutmU2z51/iT+fbL7L+aR8LiLOXIfPABV9m8n/NFjeJ6XhWOjjXdNw8DyxGIJblmLQn4drn/MlJPQTOxOlHT6Z88E3hXKkvmowsJ1cgGK51ZE791OgQnmtXueyA4RCBd3IeZ++dYMQOsnbVtT7bZeX5tbMYHR0DXZmiicNNdOcVwZUDWy71i2l5g2vXt2+etC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 12:46:36PM +0000, 董辉 wrote:
> We hit a permanent livelock on a PREEMPT_RT system and traced it to an
> interaction between the lockless page cache lookup retry loop in
> filemap_get_entry() and the folio freeze -> xarray removal window in
> __remove_mapping() (and the migrate equivalents). On non-RT that window
> is atomic (IRQs disabled) and therefore bounded; on PREEMPT_RT it is
> preemptible and can become unbounded, which turns the "refcount == 0 is
> transient" assumption of the lookup path into a permanent spin.
> 
> The affected code is vanilla upstream (our mm/filemap.c, mm/vmscan.c
> and mm/migrate.c match 6.12 exactly); nothing vendor-specific is
> involved.
> 
> The obvious fix -- making the window non-preemptible on RT -- does not
> work for the reclaim path, which is the one we hit (section 4.1). We are
> deliberately not sending a patch yet: we would like to hear which
> fix direction upstream prefers before going further.

Thanks for bringing it to us early so we can discuss the right solution.
Much easier than trying to infer from a patch what the problem was
originally ;-)

> 1. Symptom
> ----------
> 
> - 6.12.73-rt15 (PREEMPT_RT), arm64, 20 CPUs.
> - A SCHED_FIFO 99 userspace workload was page-faulting on file-backed
>   code pages of a shared library (libc.so.6 in our case) while the system
>   was under memory pressure.
> - One CPU reported rcu_preempt self-detected stall every ~63 s from then
>   on: 670+ reports over the ~12 hours covered by our captured logs.
> - The next day, and again about two days after the first stall, we
>   inspected the machine over JTAG. It was still stuck, with the same
>   register values as in the first reports. It never recovered on its
>   own; only a reboot brought it back.
> - On that CPU the running task was spinning in filemap_get_entry() on a
>   folio whose _refcount was 0 (frozen) while the folio was still
>   reachable from the mapping's xarray.
> - kswapd0 was found preempted inside __remove_mapping(), its stack
>   ending in __filemap_remove_folio() -> filemap_unaccount_folio() ->
>   ... -> preempt_schedule(): the folio was already frozen (refcount 0,
>   off-LRU, unmapped) but not yet removed from the xarray, and the task
>   still held the xarray lock.
> 
> All 670 stall reports show the same task and the same folio. Their PC
> samples fall inside this retry loop, mostly in xas_load(); the path
> taken after a successful refcount increment was never sampled. A
> second, non-RT process later hung in the same loop on the same folio,
> showing that once such an entry exists, every reader of that page is a
> victim.
> 
> 2. Root cause
> -------------
> 
> 2.1 Reader: unbounded retry on refcount == 0
> 
> /* mm/filemap.c, filemap_get_entry() */
>        rcu_read_lock();
> repeat:
>        xas_reset(&xas);
>        folio = xas_load(&xas);
>        if (xas_retry(&xas, folio))
>               goto repeat;
>        /*
>        * A shadow entry of a recently evicted page, or a swap entry from
>        * shmem/tmpfs.  Return it without attempting to raise page count.
>        */
>        if (!folio || xa_is_value(folio))
>               goto out;
> 
>        if (!folio_try_get(folio))
>               goto repeat;
> 
> The loop treats refcount == 0 as a transient state and retries. It never
> sleeps or yields while doing so, and there is no retry bound, no timeout
> and no warning.

Right.  As you suggest later, this is intended to be a transient state
that des not need to be bounded, slept on or warned about; usually finding
a folio with a zero refcount isn't from a freeze but a stale folio pointer.

> 2.2 Writer: the window is bounded on non-RT
> 
> /* mm/vmscan.c, __remove_mapping() */
>        if (!folio_test_swapcache(folio))
>               spin_lock(&mapping->host->i_lock);
>        xa_lock_irq(&mapping->i_pages);
>        ...
>        refcount = 1 + folio_nr_pages(folio);
>        if (!folio_ref_freeze(folio, refcount))
>               goto cannot_free;
>        /* note: atomic_cmpxchg in folio_ref_freeze provides the smp_rmb */
>        ...
>               __filemap_remove_folio(folio, shadow);
>               xa_unlock_irq(&mapping->i_pages);
>        ...
> cannot_free:
>        xa_unlock_irq(&mapping->i_pages);
> 
> Readers on other CPUs can briefly observe the frozen folio even on
> non-RT -- that is what the retry loop is for. On non-RT, however,
> xa_lock_irq() disables IRQs and preemption, so the interval from
> folio_ref_freeze() to __filemap_remove_folio() cannot be preempted
> and cannot outlive the locked code path: the window is bounded, and
> the retry terminates after a few iterations.
> 
> 2.3 On PREEMPT_RT the window is unbounded -- this is the break
> 
> On PREEMPT_RT xa_lock_irq() maps to rt_spin_lock(): an rt_mutex
> plus migrate_disable() and rcu_read_lock(). It does not disable
> preemption. A task inside the freeze -> removal window can therefore be
> preempted, and the frozen folio stays visible in the xarray with
> refcount == 0 for as long as the holder is off-CPU -- the window is no
> longer bounded by the locked code path, but by scheduling.
> 
> migrate_disable() aggravates this: the holder is pinned to the CPU it
> was preempted on. The holder does not have to be kswapd: the same
> shrink_folio_list() -> __remove_mapping() path is used by direct
> reclaim, so any task allocating memory can be the victim.
> 
> 2.4 How it becomes permanent: priority inversion
> 
> In our case a SCHED_FIFO 99 task preempted the holder on the same CPU,
> then faulted on the very page being removed and entered the
> filemap_get_entry() spin. Two further SCHED_FIFO 99 threads of the
> same workload blocked on the same xarray lock; through priority
> inheritance the holder (kswapd) was boosted into the RT scheduling class
> at the same effective priority as the spinner. SCHED_FIFO does not
> time-slice among equal priorities, so a spinner that never blocks never
> gives the CPU back to the holder.
> 
> This is where self-healing is lost. While the holder remains CFS, the
> RT bandwidth limit (sched_rt_runtime_us, 950 ms per 1 s period by
> default) reserves CPU time for CFS tasks exactly so that a run-away RT
> task cannot lock up the machine (see
> Documentation/scheduler/sched-rt-group.rst); the holder can still run
> and close the window. Once PI pulls the holder into the RT class it is
> throttled together with the spinner and no longer benefits from that
> reserve. (With sched_rt_runtime_us = -1 even the CFS escape does not
> exist.)
> 
> The spinner is invisible to PI: it waits on the folio, not on the lock,
> so nothing ever boosts the holder on its behalf.

I think you mean that it spins on the folio refcount, rather than it
waiting on the folio (when people say "wait on the folio", usually
they're talking abut folio_lock()).

> The four necessary conditions:
> 
>   (a) frozen-but-visible folio -> reader spins
>       where: filemap_get_entry() retry loop
>   (b) window unbounded (holder preemptible, pinned)
>       where: PREEMPT_RT xa_lock_irq() semantics
>   (c) unyielding spinner on the same CPU
>       where: SCHED_FIFO 99 in the retry loop
>   (d) PI removes the holder's CFS bandwidth reserve
>       where: RT waiters on the same xarray lock
> 
> 3. Blast radius
> ---------------
> 
> We went through every folio_ref_freeze()/page_ref_freeze() user in
> 6.12. Two of them can freeze a regular file folio and leave it
> reachable from the page cache xarray, and on PREEMPT_RT both can be
> preempted there:
> 
>   - mm/vmscan.c, __remove_mapping()
>       trigger: reclaim -- kswapd or direct reclaim
>   - mm/migrate.c, __folio_migrate_mapping()
>       trigger: compaction / CMA / hotplug

There's also __folio_freeze_split_file().  I know PREEMPT_RT disables
TRANSPARENT_HUGEPAGE at the moment, but hopefully that restriction will
be lifted.

> Both hold the xarray lock from before the freeze until the folio has
> been removed, or replaced and unfrozen.
> 
> The unbounded refcount == 0 spin exists in several lookup loops, not
> just filemap_get_entry():
> 
> - filemap_get_entry() -- goto repeat, no bound
> - find_get_entry() -- goto reset/goto retry, no bound
> - filemap_get_folios_contig(), filemap_get_read_batch() -- goto retry,
>   no bound
> - ksm_get_folio() -- while (!folio_try_get(folio)) cpu_relax() with a
>   swapcache-flag escape
> 
> ksm.c documents the transient state explicitly ("however, it might
> mean that the page is under page_ref_freeze()..."), which suggests the
> frozen-but-visible window is a known state of the design -- the filemap
> loops simply have no bound on it.
> 
> 4. Fix directions we have considered
> ------------------------------------
> 
> 4.1 Direction A (writer side): restore non-RT atomicity of the window
> 
> The idea: on PREEMPT_RT, wrap the freeze -> xarray-removal interval in
> preempt_disable()/preempt_enable(), keeping the lock acquisition
> itself RT-semantic (it may sleep while waiting). Readers stay untouched
> and "refcount == 0 is transient" holds again, for every reader.
> 
> By inspection this works for __folio_migrate_mapping(). Its window,
> from the freeze to the xas_store() of the new folio, contains nothing
> that sleeps on RT: that xas_store() call is not wrapped by
> mapping_set_update(), so no update hook fires.
> 
> It does not work for __remove_mapping(), the site we hit. The
> removal itself takes a spinlock_t whenever shadow-node tracking changes:
> 
>        __filemap_remove_folio()
>          page_cache_delete()
>            mapping_set_update()   /* xa_update = workingset_update_node */
>            xas_store(&xas, shadow)
>              update_node()
>                xas_update()
>                  workingset_update_node()
>                    list_lru_add_obj() / list_lru_del_obj()
>                      spin_lock(&nlru->lock)    /* spinlock_t */
> 
> __delete_from_swap_cache() installs the same hook, so the swapcache
> branch is affected as well. This happens whenever an xa_node becomes
> shadow-only or stops being so, which is routine when reclaim evicts a
> run of file pages. shadow_nodes is a single list_lru whose per-node
> lock is shared by all mappings and by the shadow-node shrinker, so it
> can be contended. Unlike the other sleeping call we found, it cannot be
> moved out of the window: it is taken from inside the very xas_store()
> the window exists to cover.

Is it possible / wise to convert the nlru->lock to be a raw spinlock?

In the old days when the BKL was magic, we could take a mutex and choose
to sleep.  I don't think the preempt_disable() works like that.  It's
a bit annying because we'd be fine with being preempted after the folio
is replaced in the XArray.  It feels unutterably ugly to insert calls to
preempt_disable() / preempt_enable() / preempt_disable() /
preempt_enable() around all of this though.

> (The other sleeping call in this function, mem_cgroup_swapout() in the
> swapcache branch, could be moved: with memsw accounting it takes
> swap_cgroup's ctrl->lock in swap_cgroup_record(). It would have to
> stay under the xarray lock though, because memcg1_swapout() relies on
> interrupts being disabled by it on non-RT.)
> 
> Making direction A work for reclaim would need the shadow-node list_lru
> update to be decoupled from xas_store(), for example deferred until
> after xa_unlock_irq(). That is an xarray/workingset change affecting
> every page cache and swap cache deletion, which we do not want to
> attempt without guidance.

Yeah, I don't think this is a great approach either.

> 4.2 Direction B (reader side): bounded retry + blocking fallback
> 
> Every freezer listed in section 3 (Blast radius) holds the xarray lock until the folio
> is no longer frozen-and-visible. So a reader that keeps failing can
> simply wait for that lock: on PREEMPT_RT it sleeps on the rt_mutex,
> gives the CPU back, and priority inheritance boosts the holder. Once the
> lock has been acquired the window is closed, and the retry sees the
> final state of the slot.
> 
> This is the same fallback commit 0f8821da4845 uses in
> mnt_get_write_access() (fs/namespace.c): on PREEMPT_RT the spinner on
> MNT_WRITE_HOLD stops spinning and takes the writer's lock instead,
> specifically to avoid this livelock.
> 
> The change would be small (mm/filemap.c only, we estimate about 80 lines):
> 
> - Applies to the four filemap loops listed in section 3 (Blast radius).
> - Counts failed attempts; every 64 of them the reader calls
>   rcu_read_unlock(), then xas_lock_irq() + xas_unlock_irq(), then
>   rcu_read_lock(), resets the xa_state and retries the same index.
>   Nothing is skipped and nothing is returned early, so semantics do not
>   change: callers such as truncation still see every entry.
> - Only on PREEMPT_RT: the check compiles away otherwise, so non-RT
>   behavior is identical.
> - Only when preemptible(): callers that cannot sleep, such as some
>   BPF/perf paths reaching build_id_parse_nofault(), keep retrying as
>   before. An outer rcu_read_lock() does not need special handling:
>   PREEMPT_RT uses preemptible RCU, which allows blocking in a
>   read-side section (at the cost of a longer grace period).
> 
> We have not prototyped or tested this yet; the sketch is here so the
> trade-off can be judged before we invest in a patch series.
> 
> - Pros: covers the reclaim site that direction A cannot; covers every
>   freezer that follows the "hold the xarray lock" rule, including ones
>   added later; adds no non-preemptible window.
> - Cons: the lookups can now sleep on PREEMPT_RT in preemptible context,
>   and we have not audited all of their callers. Two things need checking:
>   that no caller holds a lock which is taken inside the xarray lock
>   (we spot-checked list_lru walkers and found no such caller, but this
>   was not exhaustive), and that every caller keeps the mapping alive
>   across the rcu_read_unlock(), not just by RCU.
> - Not covered: callers that cannot sleep can still spin, and so can
>   ksm_get_folio(), which has no mapping at hand to wait on. KSM is
>   disabled on our system, so we did not look further into it.
> 
> Our current view is that B addresses the path we hit, while A, at best,
> narrows the problem to the migrate path -- but we may be missing a
> reason why upstream would rather restructure the writer side.

But I don't like this either ;-(  Hope somebody comes up with a nicer
idea.

> 5. Questions
> ------------
> 
> 1. Is the "refcount == 0 is transient" assumption of the lockless
>    lookup path documented as depending on the freeze -> removal window
>    being non-preemptible? If so, PREEMPT_RT breaking it is arguably an
>    RT-side invariant break; if not, should the lookup loops grow a
>    bound?

I don't think it's _documented_.  But I do think it's intentional.

> 2. Given that the reclaim site cannot be made non-preemptible as long as
>    workingset_update_node() takes the list_lru spinlock_t from inside
>    xas_store(): is a reader-side fallback like direction B acceptable,
>    or would upstream rather decouple the shadow-node LRU update from
>    xas_store() and then fix the writers?
> 3. For direction B: is it acceptable that these lookups may sleep on
>    the xarray lock on PREEMPT_RT, in preemptible context only (the
>    same fallback commit 0f8821da4845 uses in mnt_get_write_access())?
>    Is
>    "every freezer holds the xarray lock until the folio is no longer
>    frozen-and-visible" an invariant we may rely on, and should it be
>    documented next to the lockless page cache protocol comment?
> 4. Are there other freeze sites we have missed?
> 5. Would a WARN_ON_ONCE() on excessive retry be acceptable as a
>    diagnostic, independent of the chosen fix?

No, I don't think we should do that.

> 6. Reproducer sketch
> --------------------
> 
> 1. Pin a SCHED_FIFO 99 task to CPU X; have it repeatedly page-fault on
>    file-backed code pages of a shared library under reclaim pressure.
> 2. Drive reclaim (memory pressure is enough; direct reclaim works too)
>    so a task runs __remove_mapping() for one of those pages on CPU X.
> 3. The FIFO task preempts the holder inside the freeze -> removal window
>    and faults on the frozen page -> spin.
> 4. Two more FIFO 99 threads of the same process fault on other pages of
>    the same mapping to block on the xarray lock and trigger PI.
> 
> Anonymized evidence (register sampling, stack traces of the three RT
> threads and kswapd, decoded structure dumps) is available on request.
> If direction B is the preferred one, we will turn the sketch above into
> a patch series and send it for review.
> 
> Best regards,
> Donghui
> #/******本邮件及其附件含有小米公司的保密信息，仅限于发送给上面地址中列出的个人或群组。禁止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制、或散发）本邮件中的信息。如果您错收了本邮件，请您立即电话或邮件通知发件人并删除本邮件！ This e-mail and its attachments contain confidential information from XIAOMI, which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender by phone or email immediately and delete it!******/#

