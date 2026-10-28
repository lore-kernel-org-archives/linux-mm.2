Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5718B606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 22:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lJHtAcnU
Received: by kanga.kvack.org (Postfix)
	id 7A43F6B05B1; Wed, 28 Oct 2026 18:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755496B05B3; Wed, 28 Oct 2026 18:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644A36B05B4; Wed, 28 Oct 2026 18:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35A406B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:21:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE901C0200
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:21:21 +0000 (UTC)
X-FDA: 85373457162.16.F0FD121
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	by imf18.hostedemail.com (Postfix) with ESMTP id A37E21C0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:21:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJHtAcnU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793226080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5PYntU4pcZbtBDlk3G303agmpMU/iAC4KlHp+fta+Pw=;
	b=SpHyDcMpAxrbh9NcKvgwUVWVE6jsZ1C8H6BSi96VJqaaWvjTFyejMr/LxigrgQclwRY7yG
	Kj46nfVwkWnBBbR23vstYnB044l8PHbF1GilnnFBpZwCxAtSqPYVsSYCXbI0frZ1Qm53ha
	7tErr6yX7oiuvVzFPQ9Y3SXSGBilmQM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJHtAcnU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793226080;
	b=QaFS2QQmNRWT4FpZ2KlXsRoOAaVVOxmf8VcO5j95RRvYpm/l0JUFFs/UJsUCTRL6NlpVaP
	Aa7DHRCCENeC9SnWSL7LeMpMsrFcX0az2HvhMQLFCHw3poUpSfs/d/TqdHTAHZhp/7SEdZ
	DKbkNBtvOhRLdvBzOlwbk16l4zRPa6s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KEyQW15tu0msESBhCETqAqGeyqCoqt8QavWxxHjja3M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793226078; v=1; x=1793830878;
 b=lJHtAcnUpgNiNEQx/U0cEz+4H7TDAHnctMsJXv4T8RmEkjcg5GWpbCsrUGSGy2NlII3gRhH8
 JLBEBTINIsfGA904OVz8EqbnUFrsWdzubvCqMKmirEyq5uoPcraQotyVWfgw4WOUM55m3YUXHKH
 DdOI0rV0cf1SjVZPSiYIyxk0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f80d48f7db07d649;
	Wed, 28 Oct 2026 22:21:18 +0000
X-Mizu-Trace-ID: f80d48f7db07d649
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 15:21:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "T.J. Mercier" <tjmercier@google.com>, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcontrol: fix NULL pointer deref from
 high_work_func() on dying memcg
Message-ID: <auJ1ID25dW55gT9h@linux.dev>
References: <20261028183537.605854-1-tjmercier@google.com>
 <auJzXV3nnPZA5GSr@cmpxchg.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auJzXV3nnPZA5GSr@cmpxchg.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A37E21C0006
X-Stat-Signature: 3mwqhxo19g7zfgeckqw5idmmt3xzqy53
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793226079-711249
X-HE-Meta: U2FsdGVkX1/2BztCmIofUFIklUhpkcxDa1e88mGTKE/m9awnoUZKrLGtVd/a8uAWQS2ZUuz0If2l94GTiVW25+B7QaocEGt4xhPqE6HoLbUdXcFnqa4pRP5hPA7euKPJgr4r/SpoE2cJfLSGWblPOYTXDIdQu11hJudq+AZefwaMnEC9m+Xer8GJonqRATs4XLJroWyaLYGzLK+bTt3vKHfCru3B/GdIbir/fx1CveAIT0QmZxc/m2RzGc8GCttTjdpydOYNqO4KGgSb/J81HT8cpBMS3RD388I6JaigawNQogq8YHUZKHlD7yQmFtRpf9EqJ43tKxMP56ykViRbJr1y/zEHzVVzdWqSDavkcV+UONz6uSWEopt1e2IXcCFrHWyL8edlM0xogUnpvgtCn702hZOLMJcQKneFvlob+bVZsaCJutKF/KxCPWEkRamwikJwRxqpYZ4YPueZY01tq1XoOtDBfz/ZVpV2Qc7nK1cVsqscisHe1h1ZF83YobeemLV9ZrSeQd6v6+NrEKqhu4HBzVZgacATUHtWortmEH64XkgyKrOKIZms1+1f86ZXfWJ47F7T65Ra2+N1QvgQFvzrpGVOtQGgm0yWkgtSRUghNePrIQ4BwX21H7edqLlVSiOKSRHmcM5qQUXryefmUU2m9XlJqD7W9WfLnFypojFRSOyklGJio2wilU6Tjw9Yk08ZFFb6LEuSEMijBYRHn70f9PWsu44ltM7DwQ8bncp1MDF4m2pxsmi76+j1yZNh7vavTUVlY0MdS7PZlw/MRM7jz1WBIH3giGO0WwgWSKZSC+ASAsqqmOSfnxAPr6jpAtUsNXR63rCVX71gJeEa8MaBD8YPnLyeySFVI6kyq2xhTLYV9iwn7ePaPWPzuyviu4eeGtfJo74aQbtdO6arcCcDzGgMSvGdD8aBymECzVWlink002EObNQCYAOkDbytgpb/nCWG+zu7meTOHrz
 H/Dr8d60
 vF8rgytEfw/lqlv4SsAqdSm8dR3s+6SfXVdLNbbeVsj4mhuW+Yd1zsDMLXmK7OPibfybPo9Qx/w2OTAPVjh/4/HuEXvff2xek4QBEJ0+bO8f3gFZdpg5UtzORgajyOrKCj32Nq0Im7hdRBxedQygsY75J1VXN09bYA5qUAzo/k1GLsXquUjHXpUsH+Qv2qGgPq3Vs8JeqKGfAy7C2Jr5f2ws/beAMjIgpK6m8L3A4lbpnNB+BXzkrVwMscjLIY/QK3udTLEP0C7gF/MnyfTBDC1RFtzEfBc+mFJjLlr+jlq7z5qjYg2uZlpOqFR4vflBpHqHo/93LVqX3ZBXwdKWxwoiJTsfbUg34dR+mM74D4gJshMAD/apgH7yryw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 06:12:45PM -0400, Johannes Weiner wrote:
> On Wed, Oct 28, 2026 at 11:35:37AM -0700, T.J. Mercier wrote:
> > When memory.high is exceeded in non-task context, try_charge_memcg()
> > schedules memcg->high_work without taking a reference on the memcg, and
> > high_work_func() invokes reclaim_high() without pinning the memcg.
> > 
> > cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
> > mem_cgroup_css_free(), so high_work_func() can start or still be running
> > reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> > called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
> > reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a
> > NULL pprev pointer.
> > 
> > With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
> > memcg/slab: obj_cgroup API"), objects charged to a child memcg are
> > reparented to its parent in mem_cgroup_css_offline() instead of holding
> > a reference on the child until uncharged. Subsequent uncharges of those
> > objects go to the parent, which can leave the child's memory use
> > permanently above its high limit, so any later charge on the offlined
> > memcg in non-task context schedules high_work.
> > 
> > This problem was first exposed when commit e4dde56cd208 ("mm: multi-gen
> > LRU: per-node lru_gen_folio lists") introduced the memcg LRU, and was
> > later widened from kernel memory to LRU folios when
> > commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying
> > memory cgroup for LRU folios") converted LRU folios to use obj_cgroup
> > reparenting.
> > 
> > Fix this by acquiring a reference with css_tryget_online() in
> > high_work_func() before calling reclaim_high(), and by resetting
> > memory.high and swap.high to PAGE_COUNTER_MAX in
> > mem_cgroup_css_offline() so that charges via references on an offlined
> > memcg do not trigger high_work on the dead child or skip checking live
> > ancestors in try_charge_memcg().
> > 
> > Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
> > Tainted: [B]=BAD_PAGE, [W]=WARN <- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> > Workqueue: events high_work_func
> > RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> > Call Trace:
> >  <TASK>
> >  ? read_ctrl_pos+0x22f/0x3f0
> >  shrink_lruvec+0x16cb/0x1b80
> >  ? ret_from_fork_asm+0x1a/0x30
> >  ? lapic_next_event+0x15/0x20
> >  ? clockevents_program_event+0x2bb/0x6f0
> >  ? lapic_next_event+0x15/0x20
> >  ? __pfx_shrink_lruvec+0x10/0x10
> >  ? __pfx_clockevents_program_event+0x10/0x10
> >  ? _raw_spin_lock+0x84/0xe0
> >  ? __pfx__raw_spin_lock+0x10/0x10
> >  ? kasan_save_stack+0x30/0x50
> >  ? psi_group_change+0x381/0x740
> >  ? __pfx_sched_clock_cpu+0x10/0x10
> >  ? save_fpregs_to_fpstate+0xc4/0x2c0
> >  ? finish_task_switch.isra.0+0x1de/0xac0
> >  ? __schedule+0xf62/0x42c0
> >  ? __pfx___schedule+0x10/0x10
> >  ? __pfx___irq_work_queue_local+0x10/0x10
> >  ? shrink_node+0x626/0x31e0
> >  shrink_node+0x626/0x31e0
> >  ? ring_buffer_unlock_commit+0x11d/0x5c0
> >  ? kswapd_clear_hopeless+0xa0/0x150
> >  ? __pfx_shrink_node+0x10/0x10
> >  ? 0xffffffffc0000095
> >  do_try_to_free_pages+0x255/0x13b0
> >  ? ring_buffer_unlock_commit+0x11d/0x5c0
> >  ? reclaim_high+0x10a/0x1b0
> >  try_to_free_mem_cgroup_pages+0x1f9/0x5a0
> >  ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
> >  ? irqentry_exit+0xc6/0x670
> >  reclaim_high+0x10a/0x1b0
> >  ? __pfx_reclaim_high+0x10/0x10
> >  ? process_one_work+0x5ff/0x1030
> >  ? __pfx_high_work_func+0x10/0x10
> >  process_one_work+0x6e2/0x1030
> >  ? __pfx___schedule+0x10/0x10
> >  ? __pfx_process_one_work+0x10/0x10
> >  worker_thread+0x422/0xbb0
> >  ? __pfx_worker_thread+0x10/0x10
> >  kthread+0x2cd/0x3a0
> >  ? recalc_sigpending+0x15c/0x200
> >  ? __pfx_kthread+0x10/0x10
> >  ret_from_fork+0x368/0x590
> >  ? __pfx_ret_from_fork+0x10/0x10
> >  ? __switch_to+0x588/0xf50
> >  ? __pfx_kthread+0x10/0x10
> >  ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> > 
> > Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> 
> Hrm, yes I suppose the work itself keeps the memcg allocated, but not
> from going deep into the destruction sequence. I was briefly wondering
> whether mglru shouldn't move its callback from css_released into
> css_free, but I think your fix is more robust after all: don't send a
> barely allocated memcg down the reclaim stack.
> 
> The _online variant of the tryget seems somewhat unnecessary. There is
> no real harm in reclaiming an offline group - and it was the standard
> way, before reparenting, to garbage collect an offline group with
> lingering pages. With the updated Fixes, this would look odd in
> backports to kernels without reparenting. The PAGE_COUNTER_MAX reset
> would also cause reclaim_high to bail.
> 
> So I wonder if css_tryget() would be simpler and just as correct. But
> no strong feelings either way:

css_tryget() is not safe after percpu_ref_exit() which can happen here. Only
css_tryget_online() is safe.



