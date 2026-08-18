Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4411CC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4586B016A; Tue, 18 Aug 2026 05:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39BEF6B016E; Tue, 18 Aug 2026 05:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B2B76B016F; Tue, 18 Aug 2026 05:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0404C6B016A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:49:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 881ADC0BDE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:49:18 +0000 (UTC)
X-FDA: 85113917196.16.49CB2B3
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7397BC0003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:49:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Rl/6k4PN";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787046556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZKFR1PQyukjwZGxAUfYNi3ZGmoyx0palpGFooIOHLc=;
	b=dRBQt1xdwA9fPuZKLn10OX9ZyuUFzkzoOJyZpW+wpTVuKhLWSBkyAsjm6kuZoy6lxE07+7
	vIK2ZoW5Hb0xgXm3qpP4GjcEFDAf4GEmOyW+hSpdLtjjpog7sjrzWPYFjS3vqhhnSKf1Is
	KXpknX/CkfmQSj0D/ZxFppiaDn6DUBU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Rl/6k4PN";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787046556;
	b=RSal5BPzpi553wzp1m0hh8xhFA0bbF5qpmtnR2rlZG1V1zT0QxtKneASiBdqoV+FR+IGC4
	SqZLDgo4UgG9CPRbiXs5N/bYbrRiOdCR5apaY8c8Qg3/+uAdfXxTDQ7s+2Zfgt5hm4NF88
	nzN2IGRcNnlZetqQ5Mz7k6JSYFaSGO0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2Uhbt2+2COTExLsWXhEeqO6UUW90dxlA5mjtjkfkFo0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787046555; v=1; x=1787651355;
 b=Rl/6k4PNT8TtYbMaNxN4LQ0YNaYND1XgPmAq2uO7vVlEly8nIchLnHnV+eAchg9Hqef7+o22
 GwKXURJDUq9NnJzAlfihupiYH7DOfJxSScGN0289yAxQJxvJnqT5qFf++0blJMFyU7ZqhL9cAsX
 2Nqe8x0Fon8Npk5llOC/eOgo=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id c66cab44b678b77a;
	Tue, 18 Aug 2026 09:49:14 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 17:49:03 +0800
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	kasan-dev@googlegroups.com, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH RFC 2/5] mm/slab, kfence: support kfence objects in
 kfree_nolock()
Message-ID: <aoQo0OHkPTO0XmkY@fedora>
References: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
 <20260807-kfree_nolock_kmalloc-v1-2-ba993cbf7a60@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807-kfree_nolock_kmalloc-v1-2-ba993cbf7a60@kernel.org>
X-Stat-Signature: usri3x41jm1z78s67yjw16pbekm9bte6
X-Rspamd-Queue-Id: 7397BC0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787046556-945116
X-HE-Meta: U2FsdGVkX190XUTPZWJA1OWWN4NjoeZOVG+IaQSU/w8u5xOpOOFeag0EvayQz2BFHmwS0gJdDe2xG5koKKkiqqFoBLR3Z5z2v118qAxtMrRXM7N4SXVvR2h7rdS7PHwpoihtps+5hl985bEeWf/C/MTwhu/WglMmWZ5xJ93zHTT/l9m7asdPW9DaQPjapNTO3hM3RPZ/nbRDtLcp+zTtyx7YFNKPESMs03d7QjFzH3WegkCbZPNv9aCHhUqfpMpUALBFXA9guymS8i9USeTtsQ17VX6XU8ZKDRKFi6cyhi+Ez+E6YNhjljDBUuhl1imeU6syPgloBED1qcCdZGnudznPxlAQYON5LuD/YtEmhiUZpNYMEOXb2Map7YiaR7zpzDi6rcLxHnu0KrQPFaP1m2lFl643qCpzGjqCJQO578bWc8g3CXSZffDVkyKIv0zTOW+uFJUUbocQ2HHFuv1VVtYOma3OrC4g5tAdzDtlIX1sCZr0PHn6gp3AdalgAp3SXVGlb10DCsmLYclDgmqsDR1cIOrmqicxLKrPgVYA33BcCH02PEM+UC2Mp1DwePkR7T0Jh0bNXo9GvRI3w1eKSz8ijc/P4A6aAXj0nSBiquwlM4xu3LkbIjfkNEpnTwQTytbLRnVZuQUH7gZ9vatc+bdcfvAj/VhdxUtIdLeiOEVDjCfs31P8MkBMVbibxkEL6tAQ1nTx7y2M2Fbc/kbE5fcEOnKWQYxUk+lyC/mWlsFxXVBoiNMZB7owWvzRM/bEIoNrigNWLYiua522Bxlo4yDr5cH+EoP+TwDkdDZ//P9G3pTaED+McqQjmhz8j51sfvmvG9o+t/1fiXnsCBNSK3PABSXE+XryPUNbC+8EDCmzzjr79hSL0sF8fuqLVEmT4omCStJGqyrg8cKN6Y/Z/d5ibeia0Or3P+XqJ3/3gt1cgcgaMo4lkMU/aWkoXlPke4G7uGwGdyn56hg6MjH
 MDpRJWnf
 ANaH7eQBUIYGRyhr4y7IV03+GWXIc3dnGHmb8x9F/bOFEFg5CyiqmR8SuFl4ykuF70M3oFG0LvRTv+WmQkgj7ZSaarbXfFKJQre3Hfr3pL+QnN/PY6iAEc1WVIp60WaW02r6x/wZf2y4QGqZONNt7yuEVGm8ySpAKWerfpMaLJWSxtVDj6LyAeWl0REV0dWh5bNsNWxKyZlcQ+HbvlaKpFPNmK/jmHoegbpdMnIiIGaYIseYbYIe2VaBgXPAngj5EIPG+1IwFShaRjCq3iv4A01ZsWvP8y3fdYpRB3CMnZSdMEDgNs+xhvrs4VU/7ctQ9r3ZvU7ZDAUn0g33pXO3D5F6VIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 03:50:28PM +0200, Vlastimil Babka (SUSE) wrote:
> KFENCE objects are one of the reasons why kfree_nolock() cannot
> currently handle kmalloc() objects. They are however rare so we can
> simply defer their freeing to irq_work.
> 
> The only complication is where to put the llist node. We cannot use the
> freepointer location like in defer_free() because for some caches it may
> be outside the object area and KFENCE would detect writes there.
> 
> Since KFENCE already solves a similar situation when freeing objects
> from SLAB_TYPESAFE_BY_RCU caches with an rcu_head in its internal
> metadata, reuse that rcu_head also for the llist node. Introduce
> kfence_obj_to_llnode() and kfence_llnode_to_obj() so SLAB can work with
> this llist node without being exposed to KFENCE internals.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  include/linux/kfence.h |  5 +++++
>  mm/kfence/core.c       | 14 ++++++++++++++
>  mm/kfence/kfence.h     |  5 ++++-
>  mm/slub.c              | 39 ++++++++++++++++++++++++++++++++++++---
>  4 files changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> index e5822f6e7f27..00721c85258d 100644
> --- a/include/linux/kfence.h
> +++ b/include/linux/kfence.h
> @@ -188,6 +188,9 @@ static __always_inline __must_check bool kfence_free(void *addr)
>  	return true;
>  }
>  
> +struct llist_node *kfence_obj_to_llnode(void *addr);
> +void *kfence_llnode_to_obj(struct llist_node *llnode);
> +
>  /**
>   * kfence_handle_page_fault() - perform page fault handling for KFENCE pages
>   * @addr: faulting address
> @@ -235,6 +238,8 @@ static inline size_t kfence_ksize(const void *addr) { return 0; }
>  static inline void *kfence_object_start(const void *addr) { return NULL; }
>  static inline void __kfence_free(void *addr) { }
>  static inline bool __must_check kfence_free(void *addr) { return false; }
> +static inline struct llist_node *kfence_obj_to_llnode(void *addr) { return NULL; }
> +static inline void *kfence_llnode_to_obj(struct llist_node *llnode) { return NULL; }
>  static inline bool __must_check kfence_handle_page_fault(unsigned long addr, bool is_write,
>  							 struct pt_regs *regs)
>  {
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 6577bd76954e..42519d24687f 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -1271,6 +1271,20 @@ void __kfence_free(void *addr)
>  	}
>  }
>  
> +struct llist_node *kfence_obj_to_llnode(void *addr)
> +{
> +	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
> +
> +	return &meta->llnode;
> +}
> +
> +void *kfence_llnode_to_obj(struct llist_node *llnode)
> +{
> +	struct kfence_metadata *meta = container_of(llnode, struct kfence_metadata, llnode);
> +
> +	return (void *)meta->addr;
> +}
> +
>  bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs *regs)
>  {
>  	const int page_index = (addr - (unsigned long)__kfence_pool) / PAGE_SIZE;
> diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
> index 1f618f9b0d12..0fca1dc2c794 100644
> --- a/mm/kfence/kfence.h
> +++ b/mm/kfence/kfence.h
> @@ -58,7 +58,10 @@ struct kfence_track {
>  /* KFENCE metadata per guarded allocation. */
>  struct kfence_metadata {
>  	struct list_head list __guarded_by(&kfence_freelist_lock);	/* Freelist node. */
> -	struct rcu_head rcu_head;	/* For delayed freeing. */
> +	union {
> +		struct rcu_head rcu_head;	/* For delayed freeing. */
> +		struct llist_node llnode;	/* For kfree_nolock(). */
> +	};
>  
>  	/*
>  	 * Lock protecting below data; to ensure consistency of the below data,
> diff --git a/mm/slub.c b/mm/slub.c
> index 044db93d64a0..2d7648b96bfa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4050,6 +4050,7 @@ static void flush_all(struct kmem_cache *s)
>  
>  struct deferred_percpu_work {
>  	struct llist_head objects;
> +	struct llist_head objects_kfence;
>  	struct llist_head objects_by_rcu;
>  	struct llist_head rcu_sheaves;
>  	struct irq_work work;
> @@ -4059,6 +4060,7 @@ static void deferred_percpu_work_fn(struct irq_work *work);
>  
>  static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
>  	.objects = LLIST_HEAD_INIT(objects),
> +	.objects_kfence = LLIST_HEAD_INIT(objects_kfence),
>  	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
>  	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
>  	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
> @@ -6399,6 +6401,13 @@ static void deferred_percpu_work_fn(struct irq_work *work)
>  		stat(s, FREE_SLOWPATH);
>  	}
>  
> +	llnode = llist_del_all(&dpw->objects_kfence);
> +	llist_for_each_safe(pos, t, llnode) {
> +		void *obj = kfence_llnode_to_obj(pos);
> +
> +		__kfence_free(obj);
> +	}
> +
>  	llnode = llist_del_all(&dpw->objects_by_rcu);
>  	llist_for_each_safe(pos, t, llnode) {
>  		void *head = pos;
> @@ -6431,6 +6440,21 @@ static void defer_free(struct kmem_cache *s, void *obj)
>  		irq_work_queue(&dpw->work);
>  }
>  
> +static void defer_free_kfence(void *obj)
> +{
> +	struct deferred_percpu_work *dpw;
> +	struct llist_node *llnode;
> +
> +	/* kasan_reset_tag() is not necessary, kfence objects are not tagged */
> +	llnode = kfence_obj_to_llnode(obj);
> +
> +	guard(preempt)();
> +
> +	dpw = this_cpu_ptr(&deferred_percpu_work);
> +	if (llist_add(llnode, &dpw->objects_kfence))
> +		irq_work_queue(&dpw->work);
> +}
> +
>  void defer_kfree_rcu(struct kvfree_rcu_head *head)
>  {
>  	struct deferred_percpu_work *dpw;
> @@ -6758,10 +6782,13 @@ EXPORT_SYMBOL(kfree);
>  /*
>   * Can be called while holding raw_spinlock_t or from IRQ and NMI,
>   * but ONLY for objects allocated by kmalloc_nolock().
> - * Debug checks (like kmemleak and kfence) were skipped on allocation,
> - * hence
> + *
> + * In case kmemleak is enabled,
> + *
>   * obj = kmalloc(); kfree_nolock(obj);
> - * will miss kmemleak/kfence book keeping and will cause false positives.
> + *
> + * will miss kmemleak book keeping and will cause false positives.
> + *
>   * large_kmalloc is not supported either.
>   */
>  void kfree_nolock(const void *object)
> @@ -6793,6 +6820,12 @@ void kfree_nolock(const void *object)
>  	 * since they take spinlocks or not safe from any context.
>  	 */
>  	kmsan_slab_free(s, x);

sashiko did a really great job on the review :)

Also, I noticed the comment above here saying that debug_check_no_locks_freed()
and debug_check_no_obj_freed() were skipped "since they take spinlocks or
not safe from any context". With this patchset applied, do we still need to
skip them unconditionally, or would it make more sense to defer them to
deferred_percpu_work_fn?

(Btw, debug_check_no_locks_freed() doesn't actually seem to take spinlocks. it
seems we might not need to defer it at all and could just call it directly...)

-- 
Thanks,
Hao

