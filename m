Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DE2606A333
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 22:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BX8B97Hi
Received: by kanga.kvack.org (Postfix)
	id 645BC6B05B2; Wed, 28 Oct 2026 18:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EEBF6B05B3; Wed, 28 Oct 2026 18:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504936B05B4; Wed, 28 Oct 2026 18:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29BDD6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:18:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4E1A401FF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:17:59 +0000 (UTC)
X-FDA: 85373448678.22.A92A8B0
Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	by imf03.hostedemail.com (Postfix) with ESMTP id 617BF20006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:17:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BX8B97Hi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793225877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpSWS7Ui06hAkpcNHbyDS5vZBaaQrLDiEklt5UkbYFg=;
	b=MmiydJnEDpazU0i5iO+SKeGLEf35yjx1JtlAHXAOzM0cdtqbFm37jkJMDSbGT4srsZmig0
	VUzrAJf1FBzj8zlBU2vSwbKjjc8FZmu5t4CqhyWo/giKa3YggI92m6COy0X2OB5MuFeWQ6
	Bw+AXkmZ5yXPx2uv4w4NEcE/Mm1ngxY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BX8B97Hi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793225877;
	b=B13l0NdfuaUhV7MVl55R8l52vibRwPln2W9yuwhmjOy3xBwfPCyFV/EGQ8DXehJxMZ/V4Z
	Q5X5pOcWvHO5oVJvcscvTtI8aO6jDAwTVdmsWxzhU4cOfQOy8NZNpFHV//XVsx2Zk9RXXH
	+UYRNhPNgf8/4R9mLFt/soPtCljIxO4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VbaNcvUi+j2V6eONn/0BAQOhapdmIMHXd3ZJF4C31UQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793225876; v=1; x=1793830676;
 b=BX8B97Hi7wNu7DjxSnBywnPU+HKyUFgEUY6o0EcB6QN632dfmrfbTfsR9rILE36huILNYGUj
 ZKEuC520hgLHtN1EbPAA0oexgnAxZDbjINlsxeHbvZlxa0oV3q0vPIP9b7JTua4a5d1iHbsFyJB
 Lox1/rz76dT4ZyGXvx5zFT60=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c3003cbc5a0837a4;
	Wed, 28 Oct 2026 22:17:55 +0000
X-Mizu-Trace-ID: c3003cbc5a0837a4
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 15:17:50 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhengqi.arch@bytedance.com, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcontrol: fix NULL pointer deref from
 high_work_func() on dying memcg
Message-ID: <auJyok6AZtRqNtt4@linux.dev>
References: <20261028183537.605854-1-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028183537.605854-1-tjmercier@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 617BF20006
X-Stat-Signature: ca9ps44bmn4dswymp9j4jjcn7ji7kgj9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793225877-475211
X-HE-Meta: U2FsdGVkX18zf2mPkVGTKSRAMSI8xpR5wj7f8Nowh4Ya/yE6yGj6RsdRU4j0iL0DGDeU+uCsZh6W+pR6cJebJ7utmWnle/BUVEuhChoAwK2cVv7yrvhVzL9ZGSnPeTPrel8XGQC9SXQ8yNdmISzaE9O0tfGkhd6qYwn0h0gvxQ5zrmYqeZdVMQYm32itsHmkZjmA9hQdkd42fYTUrSb2ngyLmjq45wLVkoVR4YHu5LZaZKDr0TuszYHbaRvgj7CdtkLsjhMLzi5kdW5IBw9t5M+UvkDBdHJB2wsB9A3vV8AkybY3vxHQOwEZRyc0ymR28a//fMQgjYfnCy81Ck1DOczXxQVlK6qTb4+tSeR/dzgwPF19vARK8q/gdU5hNbOx9SM/yC/VveRAT422k2mPHlDkMn2u1w2YmL7vCZKV0v+5ghnG927JVGAv5TYZveM2fTJz3bD4urClo5GCZiLjM+nxVriFx6juo7rQm0fAGI1OlcHO9qEYpoP4F4MgbQF0/eLI4Afnl9MEAzdiCAqHiK6Grb5lyrAgmZd+1OnJDoVPAzAFMktT0HHoOwNHMl0H5/6DJ/WB3xypOX05FjyHHW3pzZ6de65lt5oP2OTxeujbrR+FkZF3WKuM3TCfC0O+mpY2F85lajLmALGan92DEJZ33WEWoG8ph2VwexiUI1tw+Ah9uzjhEe3/p0GRs6FOHzqKTOxpUhjEM8XjyFr1vPkeoIWJn2VPdUokHJf5DVmhAa1WTENLK/jzNDS9D+lI8AxmMWW1zeChD3VxFRHxW7oJxTWO56lXYIYh/nbGKmECdsggi+QXMbEHjUrFyPlydr5cxYHxtnjhZj6Uqc2UMY29QjYQM0qN+UzHGFEb0Il3HHWaCqlkLybaQVfeE33mZxK8DOequARJBpnfXdqPYSm0RMqIlZLNYvvqwZ2iYrnEAJx2vzwvDjQGKTATdiMfAYT5gegT5ryVIhDY+7V
 ShM1r/oH
 hPvvKuRqi670FXMrT3jgm5/+PsrJU16IwdEWccMhNAn+qIOC2TBwhGvc5BntR9PcdWS+6tqz3wOKgSuf+1IPWn018Msob0XLlQDoXgawBtQsGlEuaCjOYMr13lj7xGHKcx3TenOvzpb81MwGWOaMLEqv/ELxArHC3T3Unyg/0Y789kgiYlhiSLI+fxRT2Fo8TzmlWgnqSmG6IvolDCUrDnEToGNlgkXzE1LGHNhnOLX46nSNfb5eWdti/F1o+vXqyQxuNNoLxxJzA9mfv9ntdHcVQVDp6qzn/PGjsQJQWmd67Aicunsb/5phmXOrJo8B91SX32dDd23r2cE1g8TTtK8v6/Ui27Wien4Upn5C9yDcFlAdv6LgVIWb5rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:35:37AM -0700, T.J. Mercier wrote:
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a reference on the memcg, and
> high_work_func() invokes reclaim_high() without pinning the memcg.
> 
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
> mem_cgroup_css_free(), so high_work_func() can start or still be running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
> reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a
> NULL pprev pointer.
> 
> With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
> memcg/slab: obj_cgroup API"), objects charged to a child memcg are
> reparented to its parent in mem_cgroup_css_offline() instead of holding
> a reference on the child until uncharged. Subsequent uncharges of those
> objects go to the parent, which can leave the child's memory use
> permanently above its high limit, so any later charge on the offlined
> memcg in non-task context schedules high_work.
> 
> This problem was first exposed when commit e4dde56cd208 ("mm: multi-gen
> LRU: per-node lru_gen_folio lists") introduced the memcg LRU, and was
> later widened from kernel memory to LRU folios when
> commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying
> memory cgroup for LRU folios") converted LRU folios to use obj_cgroup
> reparenting.
> 
> Fix this by acquiring a reference with css_tryget_online() in
> high_work_func() before calling reclaim_high(), and by resetting
> memory.high and swap.high to PAGE_COUNTER_MAX in
> mem_cgroup_css_offline() so that charges via references on an offlined
> memcg do not trigger high_work on the dead child or skip checking live
> ancestors in try_charge_memcg().
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
> Tainted: [B]=BAD_PAGE, [W]=WARN <- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
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
> Cc: stable@vger.kernel.org
> Signed-off-by: T.J. Mercier <tjmercier@google.com>
> ---
> Changes since V1 (https://lore.kernel.org/all/20261023222313.3979455-1-tjmercier@google.com/)
> - Switch to Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>   from Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
>   per Muchun Song.
> - Reorder and update commit message content to describe reparenting
>   separately from the commits that exposed and then widened the problem.
> - Trim the backtrace a bit.
> 
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b..84f4a8fd4d16 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2457,7 +2457,10 @@ static void high_work_func(struct work_struct *work)
>  	struct mem_cgroup *memcg;
>  
>  	memcg = container_of(work, struct mem_cgroup, high_work);
> +	if (!css_tryget_online(&memcg->css))
> +		return;
>  	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);

The patch is correct but I think there are two very specific subtleties which
the commit message is not very explicit about.

First, I was wondering shouldn't we take reference before schedule_work() and
why this is safe. This is safe due to cancel_work_sync() in the
mem_cgroup_css_free() which will not free memcg until this there is no high
worker.

Second, cgroup core calls css_free() after percpu_ref_exit(). So, is it safe to
call css_tryget_online() on such css->refcnt. Yes css_tryget_online() is safe
but css_tryget() is not safe.


