Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E603BC531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 10:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10F46B00AF; Thu, 23 Jul 2026 06:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8236B00B1; Thu, 23 Jul 2026 06:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C276B00B2; Thu, 23 Jul 2026 06:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 743B56B00AF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:27:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBBD91C0974
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:27:39 +0000 (UTC)
X-FDA: 85019665038.05.B588589
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD01DA0008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:27:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784802457;
	b=O2zOsLXNz1ME993d6I88Wj+NSTOic0Wq8GSzckCZakJ6JwpDxR5qT+jzoHlgMPSC4g77sD
	RRpXccE61i77FoXl9i/cblz/FsU+ZtWh5n/5qpbooytfRhn3kHZc1r20NtWkbgJX7YkLS0
	aXgfEbgx8nPGKLYwUxqQ19IQ+Q5FeKI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784802457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xJLaY8iyBCXtHjA9o0y7TPGGm3hsMNid202Bj1u3nkM=;
	b=um6dQ1Ryvx8+LfFM6bCGSsWHN1jO8W+btEdRIlFjtzP43BHer2DF1sxKEHajYlsaud2wQ3
	1hO/iRUcU9nlomPYAqWVNKsJNkHF7PKfNP59IyBHcYkazHtQoxij5+534PaWP4gn/uDWAK
	Dx+hfKkEKs2yP0MQnueToz/odok9tvg=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h5S434j4Vz4yjjK;
	Thu, 23 Jul 2026 18:27:31 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 66NARPOw069720;
	Thu, 23 Jul 2026 18:27:25 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 23 Jul 2026 18:27:27 +0800 (CST)
X-Zmail-TransId: 2afa6a61ec8f45b-ef006
X-Mailer: Zmail v1.0
Message-ID: <20260723182727858gUQJ4TgRU2b6v1kdgpkfV@zte.com.cn>
In-Reply-To: <20260720-kfree_rcu_nolock-v4-4-964e03c41a4e@kernel.org>
References: 20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org,20260720-kfree_rcu_nolock-v4-4-964e03c41a4e@kernel.org
Date: Thu, 23 Jul 2026 18:27:27 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <ast@kernel.org>, <andrii@kernel.org>, <puranjay@kernel.org>,
        <ameryhung@gmail.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
        <rostedt@goodmis.org>, <paulmck@kernel.org>, <frederic@kernel.org>,
        <neeraj.upadhyay@kernel.org>, <joelagnelf@nvidia.com>,
        <josh@joshtriplett.org>, <boqun@kernel.org>, <urezki@gmail.com>,
        <mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
        <qiang.zhang@linux.dev>, <pfalcato@suse.de>, <surenb@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>, <rcu@vger.kernel.org>,
        <bpf@vger.kernel.org>, <harry@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBzbGFiL2Zvci1uZXh0IHY0IDQvOF0gbW0vc2xhYjogZXh0ZW5kIGRlZmVycmVkIGZyZWUgbWVjaGFuaXNtIHRvIGhhbmRsZSByY3Ugc2hlYXZlcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66NARPOw069720
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 23 Jul 2026 18:27:31 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A61EC93.000/4h5S434j4Vz4yjjK
X-Stat-Signature: is9jax1swjkccaxi4iodkw11gog5py85
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD01DA0008
X-Rspam-User: 
X-HE-Tag: 1784802456-475378
X-HE-Meta: U2FsdGVkX1/ctmDfyx1CI/qDI3v6Wf+ahlEVh2FAqwftr01+/I9HX1QYog/2pX6rfM5s/vUIJ1hrYCuASqJRKp9GflpR2amb96pQQ1Jtc3fpTXQsMPxpj7Jg5wMMbmET2WofvQw2nMiS0cScDYqZiX92um6Z6Z8av8TOfvTxgMgjPWh+uwfAJwSJLbPYIC1jQ8XN8cogHSjh2HrwhOMJxUUTNiFcRXcpiKIZzGR9Xq28LBTAquakl/WOMDBGNKdlFcQ881TYvx1vwal7qRBe6kj95QjL6b9qVf0DW5PA5GBogKTbE5lBKlhx1/2gWDXyxA7p4gbAXnnmMqn7JNs09bEM4v0uSvL+AQyweh+vvA6t8LuF16+KrK2Tw1+IjtZ+PsK4i4ZS/tk1ogfuTeyEeLXL5x2/AfF6y9YscpvuAuGtU+DShkCY7tvWO0L3ybs/Dfyhnqup3ym+DlpJIaMe2I2WT62KMVkH2Kph3twQ01a84JnHBDrVulT1hOPyRit0OHwlLupiX8uW/sLf5HmooRCiZmZqvieYBfcm0+SJS4X8xWsKcWaDrKB12NKzXMGwwhWJ6w5QYThZ6Lx2fiQqOXv4qtarih1ABJ35kRJAuhK+q9U8O0noc/cW+oOEmSDv2g2fqimdP4faVNeC3ZDH0zFmyWQjl/KwsZ0xhprFRADKcAMEGk5n4nDcYSKgqzJ0P+hS67sjD84AG5LxMD9lDGihmR/NZlVYkiNZowPsWwRIyKaCWp0u4ge9yfaxhWS9ounB7CWX0nKt3pfDIPRmRWq/s2b/bnTUqhbawBDjfICFxJwNDr/OJzXtFduhkikGr11ZVuDiDJfzAULVgjLRIJFh9fM2LOW3d52cMc/1VEQ61mLGY+65QmltQ5vIDEWmcMunfQ1k644+90tHlG0Jz9tItmYJIkWeKYj1FE5nj3FVKFDF6tVr4rpjIEJIU5zu+nVTxZCwkFH8fP7WxTM
 zM97jYnW
 /EuGXdWYeH8v2YeVhAyJ9Wx5rEYjBFQQ4hoyXMCLxS3NDd0YfsfjnRefeR1f+M5WgTmUySSPuUO48rW213JWrHVGhHuAQfPtic9D10aIZelPJcv6F0YWRwvJixiSJIYvkp0WrFsDN9PEpvTP/uDkva7+6zi0uGbE6oM1z/QdEVf3Bg0++H24AVDOLNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> __kfree_rcu_sheaf() cannot invoke call_rcu() when spinning is not
> allowed and IRQs are disabled. To relax the limitation, extend the
> deferred free fallback so that a full rcu sheaf can be submitted to
> call_rcu() via the existing IRQ work.
> 
> Since the deferred mechanism does more than deferred freeing of objects,
> rename the struct to deferred_percpu_work and adjust names accordingly.
> 
> When a sheaf is queued on an IRQ work, it is detached from
> pcs->rcu_free but call_rcu() is not invoked until the irq_work runs.
> To keep the kvfree_rcu barrier's promise, call irq_work_sync() on each
> CPU before calling rcu_barrier().
> 
> In the meantime, remove the TODO item as apparently there is no simple
> and effective way to achieve that. This is because, unlike sheaves,
> kfree_rcu() batches objects from different caches together.
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slab.h        |  2 +-
>  mm/slab_common.c |  7 ++---
>  mm/slub.c        | 85 +++++++++++++++++++++++++++++++++-----------------------
>  3 files changed, 53 insertions(+), 41 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 85ef2ebc9812..fdd293b3efa5 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -760,7 +760,7 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
>  void __check_heap_object(const void *ptr, unsigned long n,
>               const struct slab *slab, bool to_user);
>  
> -void defer_free_barrier(void);
> +void deferred_work_barrier(void);
>  
>  static inline bool slub_debug_orig_size(struct kmem_cache *s)
>  {
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e07b4e6d6679..9c9ae1384f47 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -551,7 +551,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
>      }
>  
>      /* Wait for deferred work from kmalloc/kfree_nolock() */
> -    defer_free_barrier();
> +    deferred_work_barrier();
>  
>      cpus_read_lock();
>      mutex_lock(&slab_mutex);
> @@ -2113,13 +2113,10 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>          cpus_read_lock();
>          flush_rcu_sheaves_on_cache(s);
>          cpus_read_unlock();
> +        deferred_work_barrier();
>          rcu_barrier();
>      }
>  

Hi Harry,

I noticed that your fix in [1] serializes defer_free_barrier() to
avoid concurrent irq_work_sync() waiters.

However, this patch still calls the renamed deferred_work_barrier()
outside that serialization scope, including the new call sites in
kvfree_rcu_barrier_on_cache() and flush_all_rcu_sheaves().

Is this series expected to depend on [1], with these call sites
moved under the same serialization? Or am I missing something?

[1]
https://lore.kernel.org/all/20260624-kmalloc-nolock-fixes-v1-4-fdf4d17351dd@kernel.org/

thanks,

--
With Best Regards,
Shengming

> -    /*
> -     * TODO: Introduce a version of __kvfree_rcu_barrier() that works
> -     * on a specific slab cache.
> -     */
>      __kvfree_rcu_barrier();
>  }
>  EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
> diff --git a/mm/slub.c b/mm/slub.c
> index 680fe64aff72..8afa6b47b1f2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -418,6 +418,8 @@ struct slab_sheaf {
>      union {
>          struct rcu_head rcu_head;
>          struct list_head barn_list;
> +        /* only used to defer call_rcu() in unknown context */
> +        struct llist_node llnode;
>          /* only used for prefilled sheafs */
>          struct {
>              unsigned int capacity;
> @@ -4077,6 +4079,20 @@ static void flush_all(struct kmem_cache *s)
>      cpus_read_unlock();
>  }
>  
> +struct deferred_percpu_work {
> +    struct llist_head objects;
> +    struct llist_head rcu_sheaves;
> +    struct irq_work work;
> +};
> +
> +static void deferred_percpu_work_fn(struct irq_work *work);
> +
> +static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
> +    .objects = LLIST_HEAD_INIT(objects),
> +    .rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
> +    .work = IRQ_WORK_INIT(deferred_percpu_work_fn),
> +};
> +
>  static void flush_rcu_sheaf(struct work_struct *w)
>  {
>      struct slub_percpu_sheaves *pcs;
> @@ -4148,6 +4164,7 @@ void flush_all_rcu_sheaves(void)
>      mutex_unlock(&slab_mutex);
>      cpus_read_unlock();
>  
> +    deferred_work_barrier();
>      rcu_barrier();
>  }
>  
> @@ -6136,16 +6153,6 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>      if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>          rcu_sheaf = NULL;
>      } else {
> -        /*
> -         * With !allow_spin, we might have interrupted call_rcu()'s
> -         * IRQ-disabled critical section. If IRQs are not disabled,
> -         * we know that's not the case.
> -         */
> -        if (unlikely(!allow_spin && irqs_disabled())) {
> -            rcu_sheaf->size--;
> -            local_unlock(&s->cpu_sheaves->lock);
> -            goto fail;
> -        }
>          pcs->rcu_free = NULL;
>          rcu_sheaf->node = numa_node_id();
>      }
> @@ -6154,8 +6161,22 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>       * we flush before local_unlock to make sure a racing
>       * flush_all_rcu_sheaves() doesn't miss this sheaf
>       */
> -    if (rcu_sheaf)
> -        call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
> +    if (rcu_sheaf) {
> +        /*
> +         * With !allow_spin, we might have interrupted call_rcu()'s
> +         * IRQ-disabled critical section. If IRQs are not disabled,
> +         * we know that's not the case.
> +         */
> +        if (unlikely(!allow_spin && irqs_disabled())) {
> +            struct deferred_percpu_work *dpw;
> +
> +            dpw = this_cpu_ptr(&deferred_percpu_work);
> +            if (llist_add(&rcu_sheaf->llnode, &dpw->rcu_sheaves))
> +                irq_work_queue(&dpw->work);
> +        } else {
> +            call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
> +        }
> +    }
>  
>      local_unlock(&s->cpu_sheaves->lock);
>  
> @@ -6354,31 +6375,21 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>      }
>  }
>  
> -struct defer_free {
> -    struct llist_head objects;
> -    struct irq_work work;
> -};
> -
> -static void free_deferred_objects(struct irq_work *work);
> -
> -static DEFINE_PER_CPU(struct defer_free, defer_free_objects) = {
> -    .objects = LLIST_HEAD_INIT(objects),
> -    .work = IRQ_WORK_INIT(free_deferred_objects),
> -};
> -
>  /*
>   * In PREEMPT_RT irq_work runs in per-cpu kthread, so it's safe
>   * to take sleeping spin_locks from __slab_free().
>   * In !PREEMPT_RT irq_work will run after local_unlock_irqrestore().
>   */
> -static void free_deferred_objects(struct irq_work *work)
> +static void deferred_percpu_work_fn(struct irq_work *work)
>  {
> -    struct defer_free *df = container_of(work, struct defer_free, work);
> -    struct llist_head *objs = &df->objects;
> +    struct deferred_percpu_work *dpw;
> +    struct llist_head *objs, *rcu_sheaves;
>      struct llist_node *llnode, *pos, *t;
> +    struct slab_sheaf *sheaf, *next;
>  
> -    if (llist_empty(objs))
> -        return;
> +    dpw = container_of(work, struct deferred_percpu_work, work);
> +    rcu_sheaves = &dpw->rcu_sheaves;
> +    objs = &dpw->objects;
>  
>      llnode = llist_del_all(objs);
>      llist_for_each_safe(pos, t, llnode) {
> @@ -6402,27 +6413,31 @@ static void free_deferred_objects(struct irq_work *work)
>          __slab_free(s, slab, x, x, 1, _THIS_IP_);
>          stat(s, FREE_SLOWPATH);
>      }
> +
> +    llnode = llist_del_all(rcu_sheaves);
> +    llist_for_each_entry_safe(sheaf, next, llnode, llnode)
> +        call_rcu(&sheaf->rcu_head, rcu_free_sheaf);
>  }
>  
>  static void defer_free(struct kmem_cache *s, void *head)
>  {
> -    struct defer_free *df;
> +    struct deferred_percpu_work *dpw;
>  
>      guard(preempt)();
>  
>      head = kasan_reset_tag(head);
>  
> -    df = this_cpu_ptr(&defer_free_objects);
> -    if (llist_add(head + s->offset, &df->objects))
> -        irq_work_queue(&df->work);
> +    dpw = this_cpu_ptr(&deferred_percpu_work);
> +    if (llist_add(head + s->offset, &dpw->objects))
> +        irq_work_queue(&dpw->work);
>  }
>  
> -void defer_free_barrier(void)
> +void deferred_work_barrier(void)
>  {
>      int cpu;
>  
>      for_each_possible_cpu(cpu)
> -        irq_work_sync(&per_cpu_ptr(&defer_free_objects, cpu)->work);
> +        irq_work_sync(&per_cpu_ptr(&deferred_percpu_work, cpu)->work);
>  }
>  
>  static __fastpath_inline
> 
> -- 
> 2.53.0

