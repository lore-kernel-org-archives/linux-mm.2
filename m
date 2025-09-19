Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BE3CA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 02:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5BA280028; Thu, 18 Sep 2025 22:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC7D8E0008; Thu, 18 Sep 2025 22:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6095C280028; Thu, 18 Sep 2025 22:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 501098E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:49:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7B4113B222
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:49:12 +0000 (UTC)
X-FDA: 83904468144.19.65427B5
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf11.hostedemail.com (Postfix) with ESMTP id E52554000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:49:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eYMR3My2;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758250151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqZyQZcoeHlrOOiTQqItbAzvsXWRLXScDq7yxQ6zIhg=;
	b=dj7dlEN548R4UW6jlAqnb350uBXtoGfVwSGY/48ziSN2CE7+61o/YUb5/uFtfWYOymCNMQ
	KO2oHNsAOWKALZqnIemb3hVw0U1dRn7sJBQWWEtp8proCyQXUeZDLFs4bMIXJrj7sDW71l
	xepZ61LgN4nojdathuNRdMgWXAGIYbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758250151; a=rsa-sha256;
	cv=none;
	b=cZYo2wwcDmMGj+qkRcrtSIy+eEeNEVq/JsnU8XRZWbu/hTdhMo7tUZu1diarppI2GSr24G
	l8rkRsrLJ8E9/cbzFJtsN2UOXhdg2q8foBBPa30/VJaijP78EWZGt5SgK9dFAcP8lgfp7y
	2th/PGu3wSDl7Spt19HKID3n9hMj3CA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eYMR3My2;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 18 Sep 2025 19:49:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758250147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QqZyQZcoeHlrOOiTQqItbAzvsXWRLXScDq7yxQ6zIhg=;
	b=eYMR3My2q96I0w45HjiMc5eI+Tbb/qiY3f/qo5BwzEzCQO5RiSnBpuHfyj7mt61J+J3bY3
	PWXDdbCGHKao6O98bht2HJa0iu4W8ploFpkw0O6vbWMpeGFcdtG1FziqynjrtUwpaaBeQy
	mU2yaeddKDsJyFN2Isg5hUKU4R/IHi8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <5qi2llyzf7gklncflo6gxoozljbm4h3tpnuv4u4ej4ztysvi6f@x44v7nz2wdzd>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905201606.66198-1-shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E52554000E
X-Stat-Signature: wp3ax6mkxck4zxienxtxys1txtbsy1cw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758250150-267952
X-HE-Meta: U2FsdGVkX1+z81+46oaA9HZ5xI7VOxtM7wcUjBq30cGs2Ugko7li1xCo+ZhbNtVDHqDM/3BFaOwQAigWYOMs7SglI4FuxhblJ2jWJP0Cl0d2RTVxxETAwTX0pJAWH307kFSkthcU4oQVH7xtNJmOVLqgZYPaTYk4kQn2HS379GN+/nUoZ9edmoAx5LYnvlPybz+LX7v5AESWUKqqnDLjXOcPHMg0iFuFthzUVFdpLlLBkQOHk7MNkFciQAxxaID7dzCB4EcTRlyFbXvHSYntAfL2kO2fQwLfN/k1YYpLMj0v1g3Hsw29gwBATgK7RyuRSDdJL59TjyX4IE2kLsp1IBF5pOx/g6G6swbGXqdyjipX0kYwTNP+cazbciAzxtWWApzlPfTRMK7sPiMMGMcXg6bFowU7czaFejhOzVEZukMvUFTJxju/HX5J0XGFcry4YF8I/pAgygRRvqWbCEUM259RS9dz54kBDKzif2ZHiZKU0A9KnLoPz7GCTfzNIla4zKCg4t5DCAQyiEqaKQijWSugNk/9iksmFUKXZjewuHMf7MeBV7xvKqsHzBm8FikRa2ubMe69598xXXE9FT7JZNbvPDtCBWBmKEA/HYvpmB+4xubCCfrD8BHZFdAqYEMrbzGyP6N+uyUIh0XXNGU5JyGCp2y53RElz+JtWwUbieg36cN9VbMIjf6D1yVmlZbBrZIQ5KKYPMI9GW4jRxVMk8AK7Sc8nrRZcC4qEZ8ubOYkXG6mM4jrr/83Hzz658O7X6/C0KkU0oWZ3/d60GVUVArVQT5+MojhBmIEvSm0bj9Pm384mqdnGqyKQQ9iD6N3K6W42Bc/YMeuigklWLsHKaDKhYPf2/wXBQIo3tsTmVx/wRWRHwBXpu9cepKDbl0Am5dIbfK4YkFRmSOjCJxDsFc8/0y7DQgqm9qj/3cBGUi6GUTYfE5+S+XKbeEMRtIzh8vHgC2fsK0EkJ57ssy
 d5SNHIeJ
 jOL+3KI4JJjrj9dx/uCH1Sf1AzA63OFayS+HKy+/gC0I+klYEk39+Iv7XPQejxRyK812z3/bD0xSKebCaQvrfwQ2ckstEW3D9Z8sPNiu8Qtku7Hr/ifr+sOYXJgeY03+NqFb5L/6l8fkpR91F1iu3H0U4BwgnAsf0dKzBEYL1n+3PJZLMpQnXdUEpR8KPuklyYR57Efi9QdsxMIIS9UQuXJUj4Tk8DEtQBh47ZllKmchzTUmvQDqw2Rd8/nBybNPs1DRE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 01:16:06PM -0700, Shakeel Butt wrote:
> Generally memcg charging is allowed from all the contexts including NMI
> where even spinning on spinlock can cause locking issues. However one
> call chain was missed during the addition of memcg charging from any
> context support. That is try_charge_memcg() -> memcg_memory_event() ->
> cgroup_file_notify().
> 
> The possible function call tree under cgroup_file_notify() can acquire
> many different spin locks in spinning mode. Some of them are
> cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> just skip cgroup_file_notify() from memcg charging if the context does
> not allow spinning.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Here I am just pasting the irq_work based prototype which is build
tested only for now and sharing it early to show how it looks. Overall I
think it is adding too much complexity which is not worth it. We have to
add per-cpu irq_work and then for each memcg we have to add per-cpu
lockless node to queue the deferred event update. Also more reasoning is
needed to make sure the updates are not missed by the deferred work.

Anyways, this is the early prototype. Unless there are comments on how
to make it better, I will ask Andrew to just pick the previous patch I
sent.


From d58d772f306454f0dffa94bfb32195496c450892 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Thu, 18 Sep 2025 19:25:37 -0700
Subject: [PATCH] memcg: add support for deferred max memcg event

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h |  3 ++
 mm/memcontrol.c            | 85 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 16fe0306e50e..3f803957e05d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -69,6 +69,7 @@ struct mem_cgroup_id {
 	refcount_t ref;
 };
 
+struct deferred_events_percpu;
 struct memcg_vmstats_percpu;
 struct memcg1_events_percpu;
 struct memcg_vmstats;
@@ -268,6 +269,8 @@ struct mem_cgroup {
 
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
 
+	struct deferred_events_percpu __percpu *deferred_events;
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
 	struct wb_domain cgwb_domain;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e090f29eb03b..a34cb728c5c6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -132,6 +132,63 @@ bool mem_cgroup_kmem_disabled(void)
 	return cgroup_memory_nokmem;
 }
 
+struct deferred_events_percpu {
+	atomic_t max_events;
+	struct mem_cgroup *memcg_owner;
+	struct llist_node lnode;
+};
+
+struct defer_memcg_events {
+	struct llist_head memcg_llist;
+	struct irq_work work;
+};
+
+static void process_deferred_events(struct irq_work *work)
+{
+	struct defer_memcg_events *events = container_of(work,
+						struct defer_memcg_events, work);
+	struct llist_node *lnode;
+
+	while (lnode = llist_del_first_init(&events->memcg_llist)) {
+		int i, num;
+		struct deferred_events_percpu *eventsc;
+
+		eventsc = container_of(lnode, struct deferred_events_percpu, lnode);
+
+		if (!atomic_read(&eventsc->max_events))
+			continue;
+		num = atomic_xchg(&eventsc->max_events, 0);
+		if (!num)
+			continue;
+		for (i = 0; i < num; i++)
+			memcg_memory_event(eventsc->memcg_owner, MEMCG_MAX);
+	}
+}
+
+static DEFINE_PER_CPU(struct defer_memcg_events, postpone_events) = {
+	.memcg_llist = LLIST_HEAD_INIT(memcg_llist),
+	.work = IRQ_WORK_INIT(process_deferred_events),
+};
+
+static void memcg_memory_max_event_queue(struct mem_cgroup *memcg)
+{
+	int cpu;
+	struct defer_memcg_events *devents;
+	struct deferred_events_percpu *dmemcg_events;
+
+	cpu = get_cpu();
+	devents = per_cpu_ptr(&postpone_events, cpu);
+	dmemcg_events = per_cpu_ptr(memcg->deferred_events, cpu);
+
+	atomic_inc(&dmemcg_events->max_events);
+	// barrier here to make sure that if following llist_add returns false,
+	// the corresponding llist_del_first_init will see our increment.
+	if (llist_add(&dmemcg_events->lnode, &devents->memcg_llist))
+		irq_work_queue(&devents->work);
+
+	put_cpu();
+}
+
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
 static void obj_cgroup_release(struct percpu_ref *ref)
@@ -2307,12 +2364,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
 
@@ -2348,7 +2406,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	if (allow_spinning)
+		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	else
+		memcg_memory_max_event_queue(mem_over_limit);
 	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
@@ -2414,8 +2475,12 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * If the allocation has to be enforced, don't forget to raise
 	 * a MEMCG_MAX event.
 	 */
-	if (!raised_max_event)
-		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	if (!raised_max_event) {
+		if (allow_spinning)
+			memcg_memory_event(mem_over_limit, MEMCG_MAX);
+		else
+			memcg_memory_max_event_queue(mem_over_limit);
+	}
 
 	/*
 	 * The allocation either can't fail or will lead to more memory
@@ -3689,6 +3754,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 		free_mem_cgroup_per_node_info(memcg->nodeinfo[node]);
 	memcg1_free_events(memcg);
 	kfree(memcg->vmstats);
+	free_percpu(memcg->deferred_events);
 	free_percpu(memcg->vmstats_percpu);
 	kfree(memcg);
 }
@@ -3704,6 +3770,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 {
 	struct memcg_vmstats_percpu *statc;
 	struct memcg_vmstats_percpu __percpu *pstatc_pcpu;
+	struct deferred_events_percpu *devents;
 	struct mem_cgroup *memcg;
 	int node, cpu;
 	int __maybe_unused i;
@@ -3729,6 +3796,11 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	if (!memcg->vmstats_percpu)
 		goto fail;
 
+	memcg->deferred_events = alloc_percpu_gfp(struct deferred_events_percpu,
+						  GFP_KERNEL_ACCOUNT);
+	if (!memcg->deferred_events)
+		goto fail;
+
 	if (!memcg1_alloc_events(memcg))
 		goto fail;
 
@@ -3738,6 +3810,11 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 		statc->parent_pcpu = parent ? pstatc_pcpu : NULL;
 		statc->vmstats = memcg->vmstats;
+
+		devents = per_cpu_ptr(memcg->deferred_events, cpu);
+		atomic_set(&devents->max_events, 0);
+		devents->memcg_owner = memcg;
+		init_llist_node(&devents->lnode);
 	}
 
 	for_each_node(node)
-- 
2.47.3


