Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C044A606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KcoVZ9Ki
Received: by kanga.kvack.org (Postfix)
	id DD1B16B05B4; Wed, 28 Oct 2026 22:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D434C6B05B5; Wed, 28 Oct 2026 22:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34D86B05B6; Wed, 28 Oct 2026 22:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97A9C6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:11:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 370B81A01DA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:11:54 +0000 (UTC)
X-FDA: 85374038148.21.052013E
Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	by imf30.hostedemail.com (Postfix) with ESMTP id 073078000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:11:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KcoVZ9Ki;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793239912;
	b=V0bBr9obMiyMKkP1N26xqAfUcTSwIFXe0kbc0FkSzV54e/rcEiIFe/fo4b+LZfo4ArBZUA
	OvcmWxWd+n+y1P0MhFYKVCeRLtH3aWz3Wrx83UDi0Zf2x6nKOlTU+MwirerlsmOey1qsza
	/c2Tn+u8ZkY0g0Vhhe+BgQtlcGQT3fU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KcoVZ9Ki;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793239912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mVKxjTQ6UG8yet0iVDC28m2Sx/BGphnHT3RcdUiLOnw=;
	b=BvKSvqGbbXVtZCIc1D2s+znEATICgNhOrdj4CKPQwtdK68Ba6jv4kDGVCuXjYm3n6kha6k
	c+GaX+RCAwwOOAGRNfeRPR+C0ZUx0mNaP2x32EgDhVuldOclICWP6uURxAhODUrMQHDMct
	9YDxGb2nhDtFSczGaruPpRw+5lVlMKw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZQDzLzCYKeslFW51nWI96JVuF6FVhrDvErS7kuNB0xE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793239907; v=1; x=1793844707;
 b=KcoVZ9KiO7ifplBtH9vusLY0AzPaM1tqGMNzq0Y6J3apzT4pko9SLT/o6KFyMzGTB/qi5ZID
 Zi48Jpe34rZ644v4xEFbdD6xlpj537RTcNftZtjfP6IIzx2eiQ7UPGWr7iKOoLwsujDy9miu+e3
 zCnO04cDP4696Lg8o1cXz9rg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 252b47a0223e58b7;
	Thu, 29 Oct 2026 02:11:47 +0000
X-Mizu-Trace-ID: 252b47a0223e58b7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2] mm: memcontrol: fix NULL pointer deref from
 high_work_func() on dying memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261028183537.605854-1-tjmercier@google.com>
Date: Thu, 29 Oct 2026 10:11:26 +0800
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
Message-Id: <13AA7E01-2DAD-49CE-8C59-A99BBA917B99@linux.dev>
References: <20261028183537.605854-1-tjmercier@google.com>
To: "T.J. Mercier" <tjmercier@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: wajd8fx8p4scgkkg5nczzz4erpts3fu4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 073078000A
X-Rspam-User: 
X-HE-Tag: 1793239911-746127
X-HE-Meta: U2FsdGVkX1/78E8+I7HdeKUO0nRnREmmpz4LOjUtYysnVPL6bj3rvIJJOE/FQZp/cSAdxCbLJlmskOWw4HgItiMfmzczvOamKF7In3mGGTDfOvHVKdiCOQ0wKRxoz1QBhX56kbqlkJZasuYLv3eCO+pjXu7sBDrjuuS7JK3oerxqzAb620rGVrbPaeZSwbhCMs0nXnHL/U0roWp+noPb5isY1RXIebwD7BMeOmFiVm8oT7B9EXRnc4chdnDbAmCEBL29FLoXmvOF1FnKquix7rfOoRxjfOXg3rZnFBJx2DVEoepTin+NSSCeJGnKX/OXP+HyC4yoxHzeZbraTk2CtJOSprRSRflYxR/vuoLS1a8+cuONT3oL0lGbqAmUO6ukMZNpxBQryaKQKMkQZGLwGMQS/nrt7lVgC1qfaw2wHeyVYoDizsnZRQvB/MQEtBmfWFvnaqSbLvVEOiSsvUXI5W97BOIgs04oiQcDPZ9gVEXDZ+y2H+aqUQa24MALYUoi6+nrp5M7GZWMlslg3hyHdpYYXHlnQjXJCATOFiWVTijEDRdaYeBK5H0Xbf9PsrTkltSZx7fh+AT/vEF3G3W8GvbedXcD1+Dy3eT/Hfiv8ltYgZY8ZUS5trOTLjG5NqMj30Uc0hmzCGlHkbLa3RePELhVHknN6Djrcnn+IVCoBLTxf28FSU/AcoTkL0nupdjNDhsNHEUHT2vpNSVITQGr6kpnBtuenn+4Ec0K0tpZy3Ov32frMGe/hF9R5vlWYYJM2CsB7hE94M0H3k6gRU8rVfMovE2m1G06r2QPHi8XnAbTiybfWmIu5oda7KF8XP1955HV33GixuLROyJuWRz0lIQHkhllwFQAG1IeeDva+jleSSbrjrms2uHTR4k7fKF7VNGZfE8cfeawkoemy20eV9BuhfCFirdFmIG2uYfvZdXA9aSGgYBcAORNRNandhKbrOnQvE/5XP2yfcpnndV
 MWa1Y6GV
 7bZ3C2PnDkxsx/ZZpnUesmtiF35LBMQbK3WgjyMBzkSiC1HxgRQ1zAAzL1cjuStGJCS8iCSh/MqedIUjE+epIq/ebU2SCsOOSGlpmwbcHCkDAyX4Asv9ZmTsPpLwa5ebh7omxcg7fMboVPKcEbhsnpz13G4rxmpouLg76UOGd0gcmEZrYJaxxpEGSn1/syHdftNxgvEUAVBrSdHsQcIR6ZQvKdZl7D6VsJkP/yGbDEwfeAonYiJ0wmzYsEXrac0CJ1A9+ZoM1KHPKtc+AMEO3HddcgTWISpP6Z6wdsB90AZ8EdNIgP/AE68XY6XHfc2RYe8nj25LgkFb/uLgG3LoV6wJFyze959mRQEEkVVYWTdHJLQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 02:35, T.J. Mercier <tjmercier@google.com> wrote:
>=20
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a reference on the memcg, =
and
> high_work_func() invokes reclaim_high() without pinning the memcg.
>=20
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown =
in
> mem_cgroup_css_free(), so high_work_func() can start or still be =
running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
> reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences =
a
> NULL pprev pointer.
>=20
> With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
> memcg/slab: obj_cgroup API"), objects charged to a child memcg are
> reparented to its parent in mem_cgroup_css_offline() instead of =
holding
> a reference on the child until uncharged. Subsequent uncharges of =
those
> objects go to the parent, which can leave the child's memory use
> permanently above its high limit, so any later charge on the offlined
> memcg in non-task context schedules high_work.
>=20
> This problem was first exposed when commit e4dde56cd208 ("mm: =
multi-gen
> LRU: per-node lru_gen_folio lists") introduced the memcg LRU, and was
> later widened from kernel memory to LRU folios when
> commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying
> memory cgroup for LRU folios") converted LRU folios to use obj_cgroup
> reparenting.
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
7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
> Tainted: [B]=3DBAD_PAGE, [W]=3DWARN <- Taint from =
lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
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
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio =
lists")
> Cc: stable@vger.kernel.org
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


