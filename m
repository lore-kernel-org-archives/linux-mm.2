Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B10606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BPDTcX2t
Received: by kanga.kvack.org (Postfix)
	id 509116B05B2; Mon, 26 Oct 2026 22:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0F26B05B3; Mon, 26 Oct 2026 22:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41DB06B05BB; Mon, 26 Oct 2026 22:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 188AE6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:42:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B205120973
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:42:19 +0000 (UTC)
X-FDA: 85366857198.02.6550CF3
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8ED9540004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:42:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPDTcX2t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.35 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793068937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxplr2PW9T2cb7PCCoveVu/o9kyEMHS33OhsZEP7yEg=;
	b=x1cd9ot5y9HZGwXGjpCcxoEMG3/KdECTdoGjFvEvnUFPF7yXJHjsVWgVo3VehWqHwGJL/5
	Q52ijY6J6lbedZ37ju9ikW2p/IOvJvpghNo1zV6IkWJjiFFfuY6ddkEHVvd08P1veJflt3
	PCLn/cI5GHs5EMApI9aORpLH8UD4eBQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPDTcX2t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.35 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793068937;
	b=fQiuk4eqk1Uzl+caR8BWj6p9io4kHyuNYEhbPbyiLu/zf25bmkXDDbdntxYMvXy/C/DBlU
	1YuTSdx/ChCNa9XtcKWfHDaxTb/lW56YiIZK5d6+m6aF9S3fn9fqVls4B79/oDk2w0ddAx
	8rw+hL31va2G7B2HiXFECCuWTCHlnx8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gKD0g/74uU1V+yV//x6cgxOJGY2dkcadxe3i7Wn/Ix4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793068934; v=1; x=1793673734;
 b=BPDTcX2tewPh8K3dVXk77Sr2df88g6qwlBGHCcIJY3cgczQc9q3TgPCZU0zQoUfVEtXc3CmX
 tuNHro/GUwUgT54IYyl3ySyWZE5zWURLdED8fziqb2ERCqw3rKnpEKsMvsBu+HOTArKrlw//X3C
 ZzAwsfGyndtrv+GVkwA6oSNI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id a11537fa0e8ad6d7;
	Tue, 27 Oct 2026 02:42:14 +0000
X-Mizu-Trace-ID: a11537fa0e8ad6d7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm: memcontrol: fix NULL pointer deref in
 high_work_func() on dying memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261023222313.3979455-1-tjmercier@google.com>
Date: Tue, 27 Oct 2026 10:42:00 +0800
Cc: hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 zhengqi.arch@bytedance.com,
 akpm@linux-foundation.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DF7DBE4B-E0BA-423B-BDA7-DB07D1C9E564@linux.dev>
References: <20261023222313.3979455-1-tjmercier@google.com>
To: "T.J. Mercier" <tjmercier@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 8ED9540004
X-Stat-Signature: iurp89ffuxo4xenapedmbj795kcnn7pe
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793068937-464452
X-HE-Meta: U2FsdGVkX1/GLPZekkp3+6c21AWZ8YaWorDUDodP9hj6Ysnr1L4iPo8tso0IxAL6jse8RAqS4ymAT4avbRGNmN+jVDvCvRFSchtvRTioCKMeorU4e+TzZvuHiMaEd2IGOaU37XFfEz1Dmlx+2Ai/k0hFEIzKc7715Z+gt1u7Vwtgwg3H+ZUHq01fk3uTO0Q0JCyrNNWK9w6uwjRuGYn8cUAhzMFnXFPSHuWXPm2crnMkFrCJjDJGsNVuq8FzEPyNQ/9FzhyJ6TMU1MuJmnHuM+bdyvprbmupFxFdfUP6TkBpN95dpHVD3fUXVh2ILtGv9zYT/7rNJV8AlUO+r1zp9T9In8/krHC259XXfZin6Rof8gTEXNzhWGpCcsRWq4cO2ABwUacmpkly10ySsKjUzQGQur41jrhfvWV5R/fiZRmeZMQ8fLQgvdHeZNXs/M21MDFWsOUBvMpWKbFdgtBwmTFUBkP+qWmhCuaDBnk9wK1n2GS7tXQopgPJuqEx3qHf2TdPAUWHEljpVWD28neqsEVt/WVjmAw++V7UsMnSEVpUFiq3LDvJt8osm0ScCwCqAxgMGk5tWDBngrUBzX7DEEGi8XmboLO3Zy7eEcMHPltK2GTgH0rY4V7A+5dEq9sEI24tnP3aY8wT0XqBOyCpuViFj1AxWtdOWZUQxSfLqAclVrU74+Q5MZpEpEY7H+1GBiR/uA1lPH8JBHia3pkAbImYmpgGOqUSQZkAFpJYUwO2+BwOxwOA2LBXUQhL25Yyr2qCeI9g2sxsBu8RigE2Yz1UssrzSNE4XsmAPhLeNDDWFX3v26TFOvcpHpao0yE3Cut9i1bhsLhgypL0Dcwk/tRySJlEt7eRqnP/5j+7mdbr4RQw8XoXc2ETGrbOMR64q67TSHgJU2XQnotCKNmd3RfKVtTfMJWo899gvamLVCHvdaru9+hnDht762var/3olgu9LHEtmYM/ewJ3Fe5
 Sb/Tz6zk
 QXIlPR6DOIaC7SUx9yx5VbNv7HFJe176qFqYm/mZds8F7vPG+ov5SF8+S8WqO9dNwUqW8PgHyBhXh+tZqoN16pe+kSsPkjjzC+5UaW/8rNDIuHjkh1ULXS1UHReQsakHA32t2VOC01Vq8249iGHWQSWMC/WaLEBIVbJrO6dW9KIdyOsc+U+6YwWmXH1h05FmlypMzLb2IhdIuUREdzv7A0YNuALBe3tqiYE7ei42FWDaaSmRqtfQHtVvG4xSZdHo6DdAECGYDu8aK12yfUhV7OjhXNBiVlGiUlj4yC6CIOflc3/PWTfilkgmQD8WxRLR5N3EdiAi4QJZz/zr7978aV/41CWOKLsEakoKKXKmU3HarNRsVsYetj/YsCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 24, 2026, at 06:23, T.J. Mercier <tjmercier@google.com> wrote:
>=20
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a CSS reference on the =
memcg,
> and high_work_func() invokes reclaim_high() without pinning the memcg.
>=20
> Before commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
> dying memory cgroup for LRU folios"), memory usage above memory.high
> kept the memcg's refcount non-zero. With reparenting, folios and =
objcgs
> charged to a child memcg are reparented to its parent in
> mem_cgroup_css_offline(), leaving the offlined child's memory usage
> permanently above its memory.high even after its last reference is
> dropped.
>=20
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown =
in
> mem_cgroup_css_free(), so high_work_func() can start or still be =
running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. This
> causes lru_gen_rotate_memcg() to dereference a NULL pprev pointer.
>=20
> Fix this by acquiring a reference with css_tryget_online() in
> high_work_func() before calling reclaim_high(), and by resetting
> memory.high and swap.high to PAGE_COUNTER_MAX in
> mem_cgroup_css_offline() so that charges via references on an offlined
> memcg do not trigger high_work on the dead child or skip checking live
> ancestors in try_charge_memcg().
>=20
> Oops: general protection fault, probably for non-canonical address =
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           =
7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full) <- Taint from =
lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> Tainted: [B]=3DBAD_PAGE, [W]=3DWARN
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> Code: fd 7f 09 45 84 ed 0f 85 64 0c 00 00 48 89 cf c6 83 6a 07 00 00 =
00 48 c1 ef 03 88 83 69 07 00 00 48 b8 00 00 00 00 00 fc ff df <80> 3c =
07 00 0f 85 ec 0b 00 00 48 89 31 40 f6 c6 01 0f 85 4e 00
> RSP: 0018:ffa00000001ef4c8 EFLAGS: 00010046
> RAX: dffffc0000000000 RBX: ff1100000779e440 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ff1100000779b9b0 RDI: 0000000000000000
> RBP: ff110000bffd8e40 R08: 0000000000000000 R09: ff1100000779ebb8
> R10: ff1100000779ebb0 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: ffa00000001efb30 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ff1100011c0e7000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000251ac88 CR3: 0000000009d6c000 CR4: 0000000000751ef0
> PKRU: 55555554
> Call Trace:
> <TASK>
> ? read_ctrl_pos+0x22f/0x3f0
> shrink_lruvec+0x16cb/0x1b80
> ? ret_from_fork_asm+0x1a/0x30
> ? lapic_next_event+0x15/0x20
> ? clockevents_program_event+0x2bb/0x6f0
> ? lapic_next_event+0x15/0x20
> ? __pfx_shrink_lruvec+0x10/0x10
> ? __pfx_clockevents_program_event+0x10/0x10
> ? _raw_spin_lock+0x84/0xe0
> ? __pfx__raw_spin_lock+0x10/0x10
> ? kasan_save_stack+0x30/0x50
> ? psi_group_change+0x381/0x740
> ? __pfx_sched_clock_cpu+0x10/0x10
> ? save_fpregs_to_fpstate+0xc4/0x2c0
> ? finish_task_switch.isra.0+0x1de/0xac0
> ? __schedule+0xf62/0x42c0
> ? __pfx___schedule+0x10/0x10
> ? __pfx___irq_work_queue_local+0x10/0x10
> ? shrink_node+0x626/0x31e0
> shrink_node+0x626/0x31e0
> ? ring_buffer_unlock_commit+0x11d/0x5c0
> ? kswapd_clear_hopeless+0xa0/0x150
> ? __pfx_shrink_node+0x10/0x10
> ? 0xffffffffc0000095
> do_try_to_free_pages+0x255/0x13b0
> ? ring_buffer_unlock_commit+0x11d/0x5c0
> ? reclaim_high+0x10a/0x1b0
> try_to_free_mem_cgroup_pages+0x1f9/0x5a0
> ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
> ? irqentry_exit+0xc6/0x670
> reclaim_high+0x10a/0x1b0
> ? __pfx_reclaim_high+0x10/0x10
> ? process_one_work+0x5ff/0x1030
> ? __pfx_high_work_func+0x10/0x10
> process_one_work+0x6e2/0x1030
> ? __pfx___schedule+0x10/0x10
> ? __pfx_process_one_work+0x10/0x10
> worker_thread+0x422/0xbb0
> ? __pfx_worker_thread+0x10/0x10
> kthread+0x2cd/0x3a0
> ? recalc_sigpending+0x15c/0x200
> ? __pfx_kthread+0x10/0x10
> ret_from_fork+0x368/0x590
> ? __pfx_ret_from_fork+0x10/0x10
> ? __switch_to+0x588/0xf50
> ? __pfx_kthread+0x10/0x10
> ret_from_fork_asm+0x1a/0x30
> </TASK>
>=20
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying =
memory cgroup for LRU folios")

Hi T.J.,

Thanks for fixing this.

I have one question about the Fixes tag.

The changelog says that, before f1cf8d2f36dc, memory usage above
memory.high kept the memcg reference count non-zero. This is true for
LRU folios: before that commit, each charged LRU folio held a CSS
reference until it was uncharged.

However, I wonder whether objcg-based kmem already provided a reachable
path before f1cf8d2f36dc.

In particular, BPF alloc_bulk() mostly runs from irq_work. It obtains a
temporary memcg reference from a persistent objcg, uses =
set_active_memcg()
while performing __GFP_ACCOUNT allocations, and drops the temporary
reference after the allocation. The charge can therefore queue
memcg->high_work in non-task context without transferring a CSS
reference to the work item.

If this races with memcg offlining, objcg reparenting can redirect the
objcg to the parent while the old child's page-counter usage remains
above memory.high. Once the temporary CSS reference is dropped,
mem_cgroup_css_released() can call lru_gen_release_memcg() before the
queued high_work runs. The worker can then enter reclaim_high() and
rotate an already removed lrugen.list.

This path appears to have all the required pieces after:

  e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")

Commit 6867c7a33206 later changed the release operation to
hlist_nulls_del_init_rcu(), which explains the exact NULL pprev seen in
the reported crash. Before that, the same invalid second deletion would
instead encounter LIST_POISON2.

So f1cf8d2f36dc clearly broadens the problem to ordinary LRU folios, but
I am not very sure it is the first commit after which the underlying =
race is
reachable.

Is there an additional lifetime guarantee that prevents the pre-f1cf
objcg/kmem path above? If no, would the following be more appropriate?

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")

Thanks,
Muchun


