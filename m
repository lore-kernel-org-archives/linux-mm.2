Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C08ECA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72448E001C; Fri,  5 Sep 2025 15:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49498E000E; Fri,  5 Sep 2025 15:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FCA8E001C; Fri,  5 Sep 2025 15:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A462D8E000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:48:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63814C01EB
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:48:21 +0000 (UTC)
X-FDA: 83856233202.17.A875965
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id AB656C000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:48:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BNC2kKtr;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757101699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlFguZzDa1gDa2NcavzMlT7KN/EZMPrHXL9R/2yav78=;
	b=bLVOjbrR6F3e8J6vpO1h0tvPUDD7mCQCTcyslpKgMo6ufumJzLo7qNyK+Ce7HfkU4snRLm
	0HlfNNamOPLAXr/DJx52C0UegeYhBU4ZJNwnn/zKFUPMGOdYr6bXofZ0IC71ZYUtChhaI3
	V4/pKhDuN9C/apbCzhhykwaDCNjhJbY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BNC2kKtr;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757101699; a=rsa-sha256;
	cv=none;
	b=1U+bvv1f8KEjB+Q8p+pN0Yz528N9puAHb3Yu16ithczWSreLbCa0xFKLGWE11zzfejpgh6
	XDK/cm/xxwhX4JC31bivyrZvAGvqRXsVe1XRsElW84vHplW+hc+mo6kCubMklNdzMtl/qa
	siZPYxCThSIOdrTa/HD8bBLHgr4vLkU=
Date: Fri, 5 Sep 2025 12:48:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757101698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlFguZzDa1gDa2NcavzMlT7KN/EZMPrHXL9R/2yav78=;
	b=BNC2kKtrNY5GmX1oRYXTXNwrByNxhW38l99wk/MDkGax7patpizyDPHaighP8ooIIGTJr5
	LcvvPQ/oXecwpXq9jWv2V0DJm2MDjtsh5rjwIgSVx3IfCC32OO6Og+bpKybfxbsMUjL+YM
	ny6gYNi782l0EpnFpHbWj/zkc/9xpEQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Peilin Ye <yepeilin@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Tejun Heo <tj@kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>, 
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf/helpers: Skip memcg accounting in
 __bpf_async_init()
Message-ID: <yl3kolod3l5ejeuqhfzv6o5lrpgx3jpthodpkihkbkp2nntit7@qnnd2p7i4j7u>
References: <20250905061919.439648-1-yepeilin@google.com>
 <CAADnVQKAd-jubdQ9ja=xhTqahs+2bk2a+8VUTj1bnLpueow0Lg@mail.gmail.com>
 <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AB656C000A
X-Rspam-User: 
X-Stat-Signature: 8wqoikjdhq815yqzekf1seoe3euzjtjg
X-Rspamd-Server: rspam09
X-HE-Tag: 1757101699-950536
X-HE-Meta: U2FsdGVkX18AfwuKi/7WSaIXutEag8MbCvQe6/2XVzmyBMYIC4NS0CBcLJEsK8UkcAjm9ZPbR6QKQQISZNgO885pBdNlLN2j7GXkjN40xvLHrOZYJD+utykxuczu6QBvfHOv4oVcqW9x3eeh7zAI/9+XpZc2WrUSxnjXUZzQDRkXMYkZNYH7wib06zuq3p5PTV/eSNYhqWUAi0l3eHa/zw5k85uXLU6aOwlEcmmY4TLL0yfOUZtJmmieJLtrNbSz5zs/Jkv3e0eG+lyrDReKoy/JDFDX7OXStejW1NRKDUDUd4sMdM1uwicJHziZfruu7E6Y8ck5PiIO7aOWKFif0n4LBqa9QplU9WocXdcpmcym9x45tFAT/EO1vVKY5thoPZlaozJZkgVX5lQhqp4zBZWMUzeuloNMt+G4ZdPUlnfyxXL8iVoUgvfwwKlaljO+UIWenIon+1pqJAZ88J8S2vHbl94DNXkejvyJGD1u7ZW8d4rrXGckEn217fuq7jJFqMKLTYKahLoMRZztru01qvAyzWBmzGyIDAaVdxyub1B2I0v9t1KjZuT6Gjl8HX06eLdKC2dMBAc6ckAnrEZj0uQl3ZRG353QsF9CSe/0OZDeykAU1cegUyohI5q8ZKTAFr2bUE2gqSozPJTzMEzTr4SRPQKXi+fqHFCy1WQOtXXo6PzbGhKjdzaatsTvLLPKkd77D43cmQUQBsUYvWYFW3m9tQoFmNiEJavALlbEX/HZM6ngk0rUY2n8lZ0WdmWfvhbQO8A+5vU4DBJjFHQqAeLzb4mB2O02wLVx8geIO91eDdVMHpBLQ3U9fKa+TRyHNGNYKudOTysYskEFbVEfdaBkb2adPlliAr/ovoB9t41MFYSv0GhCqnbncras0/NYS/g3BaY5gYE3YzcA04tTSbMq14uuSvY2UT7VubvxO+v0e+8JoRD+MhSVgYPGVbyav1/5IeK/E3P4tzeZerP
 uJNokx7U
 ZVaXWhR+wyspGRvvoqI4eWqrbSU929W1kiOYJor4sp8EKM3shG05ewd+L11S3KCX0n1feOlbkf5zOvjdplEGYDXyhmKdD0s0kQgc7TL0UscJ6Su7pbK4Kj+YDQVRuvnDHfXlQJtwRFkMFs82X7b7R9W68x8QF4F4Ikx4xv1xemiUCYXJfXlQS2lnUGAUR7Zo/sWCujUSzdC2eD/b38tBB+ATpR4bEDq9B6ogIjIyL7ItFuDsTfSK1+XJPeSCVpMQLBZKO0SAuOexz/vpmQh4KOby75ljy2mBEiJyhwqzS34Wb1MSt6ISRpEpMEgdU3U/a4P9hluwZD6dJGLA05ZIB2Om/BQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 10:31:07AM -0700, Shakeel Butt wrote:
> On Fri, Sep 05, 2025 at 08:18:25AM -0700, Alexei Starovoitov wrote:
> > On Thu, Sep 4, 2025 at 11:20 PM Peilin Ye <yepeilin@google.com> wrote:
> > >
> > > Calling bpf_map_kmalloc_node() from __bpf_async_init() can cause various
> > > locking issues; see the following stack trace (edited for style) as one
> > > example:
> > >
> > > ...
> > >  [10.011566]  do_raw_spin_lock.cold
> > >  [10.011570]  try_to_wake_up             (5) double-acquiring the same
> > >  [10.011575]  kick_pool                      rq_lock, causing a hardlockup
> > >  [10.011579]  __queue_work
> > >  [10.011582]  queue_work_on
> > >  [10.011585]  kernfs_notify
> > >  [10.011589]  cgroup_file_notify
> > >  [10.011593]  try_charge_memcg           (4) memcg accounting raises an
> > >  [10.011597]  obj_cgroup_charge_pages        MEMCG_MAX event
> > >  [10.011599]  obj_cgroup_charge_account
> > >  [10.011600]  __memcg_slab_post_alloc_hook
> > >  [10.011603]  __kmalloc_node_noprof
> > > ...
> > >  [10.011611]  bpf_map_kmalloc_node
> > >  [10.011612]  __bpf_async_init
> > >  [10.011615]  bpf_timer_init             (3) BPF calls bpf_timer_init()
> > >  [10.011617]  bpf_prog_xxxxxxxxxxxxxxxx_fcg_runnable
> > >  [10.011619]  bpf__sched_ext_ops_runnable
> > >  [10.011620]  enqueue_task_scx           (2) BPF runs with rq_lock held
> > >  [10.011622]  enqueue_task
> > >  [10.011626]  ttwu_do_activate
> > >  [10.011629]  sched_ttwu_pending         (1) grabs rq_lock
> > > ...
> > >
> > > The above was reproduced on bpf-next (b338cf849ec8) by modifying
> > > ./tools/sched_ext/scx_flatcg.bpf.c to call bpf_timer_init() during
> > > ops.runnable(), and hacking [1] the memcg accounting code a bit to make
> > > it (much more likely to) raise an MEMCG_MAX event from a
> > > bpf_timer_init() call.
> > >
> > > We have also run into other similar variants both internally (without
> > > applying the [1] hack) and on bpf-next, including:
> > >
> > >  * run_timer_softirq() -> cgroup_file_notify()
> > >    (grabs cgroup_file_kn_lock) -> try_to_wake_up() ->
> > >    BPF calls bpf_timer_init() -> bpf_map_kmalloc_node() ->
> > >    try_charge_memcg() raises MEMCG_MAX ->
> > >    cgroup_file_notify() (tries to grab cgroup_file_kn_lock again)
> > >
> > >  * __queue_work() (grabs worker_pool::lock) -> try_to_wake_up() ->
> > >    BPF calls bpf_timer_init() -> bpf_map_kmalloc_node() ->
> > >    try_charge_memcg() raises MEMCG_MAX -> m() ->
> > >    __queue_work() (tries to grab the same worker_pool::lock)
> > >  ...
> > >
> > > As pointed out by Kumar, we can use bpf_mem_alloc() and friends for
> > > bpf_hrtimer and bpf_work, to skip memcg accounting.
> > 
> > This is a short term workaround that we shouldn't take.
> > Long term bpf_mem_alloc() will use kmalloc_nolock() and
> > memcg accounting that was already made to work from any context
> > except that the path of memcg_memory_event() wasn't converted.
> > 
> > Shakeel,
> > 
> > Any suggestions how memcg_memory_event()->cgroup_file_notify()
> > can be fixed?
> > Can we just trylock and skip the event?
> 
> Will !gfpflags_allow_spinning(gfp_mask) be able to detect such call
> chains? If yes, then we can change memcg_memory_event() to skip calls to
> cgroup_file_notify() if spinning is not allowed.

Along with using __GFP_HIGH instead of GFP_ATOMIC in __bpf_async_init(),
we need the following patch:


From 32d310208ebe28eac562552849355c33ae4320f1 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Fri, 5 Sep 2025 11:15:17 -0700
Subject: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed

Generally memcg charging is allowed from all the contexts including NMI
where even spinning on spinlock can cause locking issues. However one
call chain was missed during the addition of memcg charging from any
context support. That is try_charge_memcg() -> memcg_memory_event() ->
cgroup_file_notify().

The possible function call tree under cgroup_file_notify() can acquire
many different spin locks in spinning mode. Some of them are
cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
just skip cgroup_file_notify() from memcg charging if the context does
not allow spinning.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 23 ++++++++++++++++-------
 mm/memcontrol.c            |  7 ++++---
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9dc5b52672a6..054fa34c936a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -993,22 +993,25 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 	count_memcg_events_mm(mm, idx, 1);
 }
 
-static inline void memcg_memory_event(struct mem_cgroup *memcg,
-				      enum memcg_memory_event event)
+static inline void __memcg_memory_event(struct mem_cgroup *memcg,
+					enum memcg_memory_event event,
+					bool allow_spinning)
 {
 	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
 			  event == MEMCG_SWAP_FAIL;
 
 	atomic_long_inc(&memcg->memory_events_local[event]);
-	if (!swap_event)
+	if (!swap_event && allow_spinning)
 		cgroup_file_notify(&memcg->events_local_file);
 
 	do {
 		atomic_long_inc(&memcg->memory_events[event]);
-		if (swap_event)
-			cgroup_file_notify(&memcg->swap_events_file);
-		else
-			cgroup_file_notify(&memcg->events_file);
+		if (allow_spinning) {
+			if (swap_event)
+				cgroup_file_notify(&memcg->swap_events_file);
+			else
+				cgroup_file_notify(&memcg->events_file);
+		}
 
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
@@ -1018,6 +1021,12 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
 		 !mem_cgroup_is_root(memcg));
 }
 
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
+{
+	__memcg_memory_event(memcg, event, true);
+}
+
 static inline void memcg_memory_event_mm(struct mm_struct *mm,
 					 enum memcg_memory_event event)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 257d2c76b730..dd5cd9d352f3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2306,12 +2306,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
+	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
 
-	if (!gfpflags_allow_spinning(gfp_mask))
+	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
 
@@ -2347,7 +2348,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
@@ -2414,7 +2415,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * a MEMCG_MAX event.
 	 */
 	if (!raised_max_event)
-		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	/*
 	 * The allocation either can't fail or will lead to more memory
-- 
2.47.3


