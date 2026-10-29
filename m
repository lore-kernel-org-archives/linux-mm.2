Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793CA606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ssV03S9k
Received: by kanga.kvack.org (Postfix)
	id 72F006B05B1; Thu, 29 Oct 2026 16:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0DC6B05B4; Thu, 29 Oct 2026 16:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F69E6B05B5; Thu, 29 Oct 2026 16:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DDCC6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:21:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5A571C3C4E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:21:38 +0000 (UTC)
X-FDA: 85376784276.24.C682061
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9745A1A0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:21:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ssV03S9k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793305297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxeoRDyZbXsp21/9MeO6A2aaiq2+hlIXpRLxI4zLeDQ=;
	b=WRfiDTo90I9ZzMugvP1Q6Jt6J8cUfGCtYs6p0+YXxk87HvFk/F1Tlf5BNY86Pcc4YBfz+j
	m66/TqJMsvQX3L47uXShC+TPC5+uO/K8V1/ABB8SA2IT2wp28LMxuauNSjbRa7osKAUbfa
	XU+guykO3rviYgWsEx94VF8MDbX5YjI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ssV03S9k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793305297;
	b=rGvCcgxpf/cnmx0nvykxUkevD+nPklf0dvsxBQ1d+ssxZaR1n9s+DGXPsIrL+pju93VVF/
	NQsVPhBP0s+AGm1p6h/KSJvudYYZ1s73wys9QPwgLJkGNWnJUy1Z1XWry867/Btz8K8FZ9
	SU+XwYq2Gzo7o2+T31SbLhakFC3CspA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FJhtU1xpH0NBjch92Ltx/yhaAPmDS8a/U1CLjsXM7/s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793305295; v=1; x=1793910095;
 b=ssV03S9kgAXb1E4HdWgJ7iMY4bFad++jClMYusrwwCiIQZZwu1OZSPegc/+GZFjjT51I99hy
 5DykCLZbFWFB6zCieW/Tsqa1l0XzkJZdHiBSJvOFFSKA4h8FgRFCCoeFDNehFl5mbDfu3e+WGmC
 ytkXA9qhujcR0xzsY4ZSF4vw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6ce485be16b92af5;
	Thu, 29 Oct 2026 20:21:34 +0000
X-Mizu-Trace-ID: 6ce485be16b92af5
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 13:21:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, jp.kobryn@linux.dev, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: memcontrol: fix NULL pointer deref and UAF from
 high_work_func() on dying memcg
Message-ID: <auOqqI6SxvpzUNI7@linux.dev>
References: <20261029201858.2932905-1-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029201858.2932905-1-tjmercier@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9745A1A0006
X-Stat-Signature: fpt4xnn4rpfmuc9smx5om3843mohyz9k
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793305296-368872
X-HE-Meta: U2FsdGVkX18EUoMO8KTzbQYOguJXnuZ3WUExzVs7BQcDWLiXYv328fO/Q9A612pFqD/rL7gkOLI/2Jw4hGGKbhrm8Im006Qxsx0H5Ov5jnMEbXMy9+qCcVJ7fLB9Coifk2YtoCIeMODrKUNyvRE14kRo6cHzZmoFnPTKRVmjYoBiBVW/kMG01cUgjq8Z5qddEmrrznCY/uLGOHrlYsub9sZIRk45gPWlj86qbmO2vEMVqkXmQ08hyUwx1kzol4EZyOftUlBTJu8/H3r4Y/EzPckgKdxjOYDh7OFniKSUHuJ4CDus5u2So2BvEncp9++8NLZv/TW2BTOKhhgMptWRZ4FPsf+7GGuUemcZeUhGuyPqIiBXKG+X2fIKJntszNuBieOve/eVTzeR6+ZPe7hP4PCShl1cYwxjDBu5h/8U62xO0iIUR2q7DZLvb4XXWtZ7oZC8abubdBkQZfOvhsfx6mRy0heULbstyGIOz5cdG+y3es4IGBbqZ0W+LqsqBNb5NDDfbx1LGEN3r6xxJ7NeWXZqiRfrdTX/t/cxu/Y833MPNHcKoJPe7sKvIOiw00L36az1xWRu36ZgoEZaT8JdcjWyq6vXZrZ+5mtsFHDmlmq4xAsg47XG7AXp6ngQ+ZwHNrXvvHExVYQ+vqWc6o/AAycpNvmU6/r53saZSyKsiJFWIh5wAEpM7MpHoPwUKRqYMrZe4ET+kQ1kP7PkjVO033R4xBUCNFu5PQWPQrQkrBXD4CLX1h0iA/ap5iihvsv7lirdgCrSYSKRWlmW2OQ/o+i5VhpQu3xz2A7FRiN/BRmsVQg4WrsIVLZKUjXEljDCcPGXuADurtZfSWcmbVia3u1jQ0+Nkga0OqpQ2p8iNfC2Bp0jlEaCG9U5wJ85P8D/S13oynJ47oejMa60AcLJxS/4X9KN3RsG+k3lwELBBKD/gWM9zFQgJSdFj18uudUQ5izFD84sI69dHdqP4EI
 3/k55wMC
 nKu8JSay7M9H3bQdy4s8seRp60YOFy8AWqDMtuHGCymSifL8dMd5GNrvYlXQ+6PQfF9tjRA3L04cHmVcu5Q3TpK5j7zEF/mSkoG9B447DQOqJsGRFK5fjZY/kJzaLTjyA/6fNdCg6P7rEyEhh1M12gOHTxquz5PaD3C+dV82k+5KK0JNM1m4p7CNX5FKp/tKZ91hn9cNlqiM4z514pSwBecfkuvKZN8zMM5H3pGSGUeuOhom7AcysJ2hC/ClrvkXOuvnqpBa+6FuWBZv6oyA3VxxB16MCvF8Wmwqu4w6vZtk3h0sl5fEf6yDZQJmNb1gLVG2p29SRDI6BUTyCEV6RPQOJvHvokDuS1jFj1tu7OT0zQj/pXgEewMxUy2lcdOfZagYmcSbNBICKGiKS3IJNOU2MogpfL7qAiCK50iJMuplk/H4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 01:18:58PM -0700, T.J. Mercier wrote:
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a reference on the memcg, and
> high_work_func() invokes reclaim_high() without pinning the memcg.
> 
> With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
> memcg/slab: obj_cgroup API"), objects charged to a child memcg are
> reparented to its parent in mem_cgroup_css_offline() instead of holding
> a reference on the child until uncharged. Subsequent uncharges of those
> objects go to the parent, which can leave the child's memory use
> permanently above its high limit, so any later charge on the offlined
> memcg in non-task context schedules high_work. This was later widened
> from kernel memory to LRU folios when commit f1cf8d2f36dc ("mm:
> memcontrol: eliminate the problem of dying memory cgroup for LRU
> folios") converted LRU folios to use obj_cgroup reparenting.
> 
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
> mem_cgroup_css_free(), so high_work_func() can start or still be running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
> reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a
> NULL pprev pointer. This issue is specific to MGLRU and was introduced
> with the memcg LRU in commit e4dde56cd208 ("mm: multi-gen LRU: per-node
> lru_gen_folio lists").
> 
> With either traditional LRU or MGLRU, css_free_rwork_fn() calls
> css_rstat_exit() which frees per-CPU rstat data before calling
> mem_cgroup_css_free(). If reclaim_high() is still running, rstat updates
> via mod_lruvec_state() -> __css_rstat_updated() cause a use-after-free
> on the per-CPU rstat data. This was introduced when commit 5da3bfa029d6
> ("cgroup: use separate rstat trees for each subsystem") moved
> css_rstat_exit() ahead of ss->css_free().
> 
> Fix both problems by acquiring a reference with css_tryget_online() in
> high_work_func() before calling reclaim_high(), and by resetting
> memory.high and swap.high to PAGE_COUNTER_MAX in
> mem_cgroup_css_offline() so that charges via references on an offlined
> memcg do not trigger high_work on the dead child and skip checking live
> ancestors in try_charge_memcg().
> 
> Acquiring the reference in high_work_func() rather than before
> scheduling high_work is safe because mem_cgroup_css_free() calls
> irq_work_sync() and cancel_work_sync() which cancels pending work and
> waits for an already running high_work_func() to complete before
> mem_cgroup_free() frees the memcg. css_tryget_online() uses
> percpu_ref_tryget_live() and is safe to call after percpu_ref_exit()
> before the cgroup is freed unlike css_tryget().
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
> Tainted: [B]=BAD_PAGE, [W]=WARN  <-- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> Call Trace:
>  <TASK>
>  ? read_ctrl_pos+0x22f/0x3f0
>  shrink_lruvec+0x16cb/0x1b80
>  ? ret_from_fork_asm+0x1a/0x30
>  ? lapic_next_event+0x15/0x20
>  ? clockevents_program_event+0x2bb/0x6f0
>  ? lapic_next_event+0x15/0x20
>  ? __pfx_shrink_lruvec+0x10/0x10
>  ? __pfx_clockevents_program_event+0x10/0x10
>  ? _raw_spin_lock+0x84/0xe0
>  ? __pfx__raw_spin_lock+0x10/0x10
>  ? kasan_save_stack+0x30/0x50
>  ? psi_group_change+0x381/0x740
>  ? __pfx_sched_clock_cpu+0x10/0x10
>  ? save_fpregs_to_fpstate+0xc4/0x2c0
>  ? finish_task_switch.isra.0+0x1de/0xac0
>  ? __schedule+0xf62/0x42c0
>  ? __pfx___schedule+0x10/0x10
>  ? __pfx___irq_work_queue_local+0x10/0x10
>  ? shrink_node+0x626/0x31e0
>  shrink_node+0x626/0x31e0
>  ? ring_buffer_unlock_commit+0x11d/0x5c0
>  ? kswapd_clear_hopeless+0xa0/0x150
>  ? __pfx_shrink_node+0x10/0x10
>  ? 0xffffffffc0000095
>  do_try_to_free_pages+0x255/0x13b0
>  ? ring_buffer_unlock_commit+0x11d/0x5c0
>  ? reclaim_high+0x10a/0x1b0
>  try_to_free_mem_cgroup_pages+0x1f9/0x5a0
>  ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
>  ? irqentry_exit+0xc6/0x670
>  reclaim_high+0x10a/0x1b0
>  ? __pfx_reclaim_high+0x10/0x10
>  ? process_one_work+0x5ff/0x1030
>  ? __pfx_high_work_func+0x10/0x10
>  process_one_work+0x6e2/0x1030
>  ? __pfx___schedule+0x10/0x10
>  ? __pfx_process_one_work+0x10/0x10
>  worker_thread+0x422/0xbb0
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x2cd/0x3a0
>  ? recalc_sigpending+0x15c/0x200
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x368/0x590
>  ? __pfx_ret_from_fork+0x10/0x10
>  ? __switch_to+0x588/0xf50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Fixes: 5da3bfa029d6 ("cgroup: use separate rstat trees for each subsystem")
> Cc: stable@vger.kernel.org
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


