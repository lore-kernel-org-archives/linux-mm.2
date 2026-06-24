Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0ABCDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 09:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA846B0088; Wed, 24 Jun 2026 05:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A5E6B008A; Wed, 24 Jun 2026 05:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571516B008C; Wed, 24 Jun 2026 05:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 239506B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:23:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D5A9166CE6
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:23:07 +0000 (UTC)
X-FDA: 84914267214.18.2936E5A
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf12.hostedemail.com (Postfix) with ESMTP id 403A34000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:23:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782292985;
	b=1VCi3AOigiEOevGp+IkCWk9Hbhx7se3lpNEOSWY3ODqh6zlGLFHGQtlnsl8+WCwiD2wFqH
	+sgQCZg35UQ0zTRvw2zVxxVJpyDJGz74CgmTxwV3TbCDSbXddGNOmP/tyxHnpcW75pamRt
	uqbCMaU/78GPlVXU1uha5T7bwu3SN3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782292985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=kpVKcTu96HDQ3cTK53oXJVWkKE+RxRvrisL2ae6W1Wc=;
	b=jZh5HkkTo+lPRhzLW9aUBCtSjbu2RfJnewDbRu7YPGtzIENFFhUVuOFfXyNhO2EnzJm3Tc
	5CxPxND8R2rJNw7KACjFrdgpyrBghXPv/L+e13YxeiJJR+dHJZXQYJ8vod3DS21/zZptUL
	LCCRS2Gm1f1xLRQJkF8kc9C+xgYlihs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4glc0s4dBQz55y2K;
	Wed, 24 Jun 2026 17:22:53 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 65O9MVt2030121;
	Wed, 24 Jun 2026 17:22:32 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 24 Jun 2026 17:22:34 +0800 (CST)
X-Zmail-TransId: 2afb6a3ba1dab39-72770
X-Mailer: Zmail v1.0
Message-ID: <20260624172234202jw3y4yP1YfgOYbPCQdVIw@zte.com.cn>
Date: Wed, 24 Jun 2026 17:22:34 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <hao.li@linux.dev>, <cl@gentwo.org>,
        <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBmb3ItbmV4dCB2MyA3LzldIG1tL3NsYWI6IGludHJvZHVjZSBrZnJlZV9yY3Vfbm9sb2NrKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65O9MVt2030121
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 24 Jun 2026 17:22:53 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A3BA1ED.002/4glc0s4dBQz55y2K
X-Stat-Signature: n1h968mmpg9bfeih6yfd8kzm8tgtdm44
X-Rspamd-Queue-Id: 403A34000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782292984-723129
X-HE-Meta: U2FsdGVkX1+X+qrwahcJk0AAGNkGkh/GHFNTt8SE1DSDxkYvSEwFPB53Ga0a2WKjgmdu9vFQTk+EDiqU7X96H7QZdTE8io2bv6WcbBeLWVu1Lw6ndm9bWUKHcUejhDcEvzv3d3msUCnCiiBvsLe9GIdQjAX2C6cHIP3yJunjXBT+tfYID2DiUJzOVguvs84uPyTcabIDdH5UJTNXgqsm0SnHxGfpssbGbdXcrpou/LOfgiLTSCby0rjAqFbRWclNYJ3kv6vx7oTxm6BrHm0Ui0QAp4SUUmt0lquVnU44C4ipyuToLYuDDxqEhxPmZ8vRiy+6SiEK85VgiEDNVh0+Jp8dqYJOJnZrMhkRlG4Ov85eLV9kNgGD9LQuRFCMIIplYylVX7OGBKlDY+6MxwiNakMhC/aAZcwcoUyDYKoY4m1cKdQQFlbW0bOEfygp6ri7N20CxC1g2Lvms17NvCxIutMpKENOsIOaOcd8hFLbZsobR1k9rPrqcCyjIQkPtWEp0jYxFBrNRfB9UipC+a0claFZ+cMHDcZgqVwBpMlBIV7rvck6OeYrpl1qokxrtpgnX1I3+rQdKtMU7GbA+JMqKkDqCRTNesdevucLYq+0PD22OPkH3vCGtTes0mqJVHeNmKxu+PWZ3zspht1uRxmul4WEKU51AGL3H9yXOzJrLVdox4A8Gw+WlnNCtSTqcMeZDmLq9bdCtxUQuI7EQOZohYjUD/Cv4j3V+YtZs9ihpMos6xUvyAvVQQBki7lDClMNJRsxp6urePDlcvI55KLgOUAYOXPtBOGkZaPnwpbKsKh4Y3TEKULYydOKGwe7Tji4FG7mjE5pHq72UUtGxIdNeC3IFERP4aY9YOERZsQhDn1a8/t8rSGJabIw9QwEXfH2+b9cMC3Ct+4v2p+HhjOOhKZeE40k9/YgbbDbrMuYNuMD6IWzLpC34vo3oPhPvVP4K0qCsuzbTKcCXRMofvT
 8ykmyhBQ
 r6ZfRbPl+UI1FEKGf1ykh60UtqilCLp9KERmcKMGoHwqAY6tDNql4OcNwW4rNUFNwzzlHKCK8sapEJRgVBS0bJMCSzZSO8SPA8XzMw9zp2GetUHPyX4nK0kQfcWrYf25YenQmg6aQHlT0hTs8IdmZpDHQqxAR6mEyOJa8ONA0NBudkK4Wi35zj9Nj/4J7tTemwnENVdA8GsUAyaebz9ncGdrObTRIO+5eL6d1NAfQy2ByYXdLtuZNPa1IMCyukp1hRXYV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> Currently, k[v]free_rcu() cannot be called in unknown context since
> it could lead to a deadlock when called in the middle of k[v]free_rcu().
> 
> Make users' lives easier by introducing kfree_rcu_nolock() variant,
> now that kfree_rcu_sheaf() is available on PREEMPT_RT and
> __kfree_rcu_sheaf() handles unknown context.
> 
> Unlike k[v]free_rcu(), kfree_rcu_nolock() does not fall back to
> the kvfree_rcu batching when the sheaves path fails, and falls back to
> defer_kfree_rcu() instead. In most cases, the sheaves path is expected
> to succeed and it's unnecessary to add complexity to the existing
> kvfree_rcu batching.
> 
> Since defer_kfree_rcu() can be called on caches without sheaves, move
> deferred_work_barrier() and rcu_barrier() outside the branch in
> kvfree_rcu_barrier_on_cache().
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Hi Harry,

Thanks for the series. These patches fill a clear functional gap in the
existing free APIs by adding an RCU-deferred free interface for contexts
where kfree_rcu() cannot safely be used.

> ---
>  include/linux/rcupdate.h | 12 ++++++++++++
>  mm/slab.h                |  1 +
>  mm/slab_common.c         | 22 ++++++++++++++++++++--
>  mm/slub.c                | 23 ++++++++++++++++++++++-
>  4 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 5e95acc33989..3025249bfcb5 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -1099,6 +1099,7 @@ static inline void rcu_read_unlock_migrate(void)
>   * In mm/slab_common.c, no suitable header to include here.
>   */
>  void kvfree_call_rcu(struct rcu_head *head, void *ptr);
> +void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr);
>  
>  /*
>   * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
> @@ -1122,6 +1123,17 @@ do {								\
>  		kvfree_call_rcu(NULL, (void *) (___p));		\
>  } while (0)
>  
> +/* kfree_rcu_nolock() supports 2-arg variant only */
> +#define kfree_rcu_nolock(ptr, krhf)					\
> +do {									\
> +	typeof (ptr) ___p = (ptr);					\
> +									\
> +	if (___p) {							\
> +		BUILD_BUG_ON(offsetof(typeof(*(ptr)), krhf) >= 4096);	\
> +		kfree_call_rcu_nolock(&((___p)->krhf), (void *) (___p));\
> +	}								\
> +} while (0)
> +
>  /*
>   * Place this after a lock-acquisition primitive to guarantee that
>   * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applies
> diff --git a/mm/slab.h b/mm/slab.h
> index 961581e35ec8..a493c5201e96 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -745,6 +745,7 @@ void __check_heap_object(const void *ptr, unsigned long n,
>  			 const struct slab *slab, bool to_user);
>  
>  void deferred_work_barrier(void);
> +void defer_kfree_rcu(struct rcu_head *head);
>  
>  static inline bool slub_debug_orig_size(struct kmem_cache *s)
>  {
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 807924a94fb0..5a39e6225160 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1263,6 +1263,23 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
>  EXPORT_TRACEPOINT_SYMBOL(kfree);
>  EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
>  
> +void kfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
> +{
> +	struct slab *slab;
> +	struct kmem_cache *s;
> +
> +	VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_slab(ptr));
> +
> +	slab = virt_to_slab(ptr);
> +	s = slab->slab_cache;
> +
> +	if (__kfree_rcu_sheaf(s, ptr, /* allow_spin = */ false))
> +		return;
> +

One consistency issue to address here: kfree_rcu_sheaf() only calls
__kfree_rcu_sheaf() for objects belonging to the local NUMA node. This
avoids filling a CPU's per-CPU sheaves with objects from remote slabs.

kfree_call_rcu_nolock() currently skips that check and may therefore
place remote-node objects into the local CPU's RCU sheaf.

Could you add the same local-node check used by kfree_rcu_sheaf()
before calling __kfree_rcu_sheaf(), and route remote-node objects
directly to the defer_kfree_rcu() fallback path instead?

--
With Best Regards,
Shengming

> +	defer_kfree_rcu(head);
> +}
> +EXPORT_SYMBOL_GPL(kfree_call_rcu_nolock);
> +
>  #ifndef CONFIG_KVFREE_RCU_BATCHED
>  
>  void kvfree_call_rcu(struct rcu_head *head, void *ptr)
> @@ -2120,10 +2137,11 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  		cpus_read_lock();
>  		flush_rcu_sheaves_on_cache(s);
>  		cpus_read_unlock();
> -		deferred_work_barrier();
> -		rcu_barrier();
>  	}
>  
> +	/* kfree_rcu_nolock() might have deferred frees even without sheaves */
> +	deferred_work_barrier();
> +	rcu_barrier();
>  	__kvfree_rcu_barrier();
>  }
>  EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
> diff --git a/mm/slub.c b/mm/slub.c
> index 4850629774b2..19018a979445 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4075,6 +4075,7 @@ static void flush_all(struct kmem_cache *s)
>  
>  struct deferred_percpu_work {
>  	struct llist_head objects;
> +	struct llist_head objects_by_rcu;
>  	struct llist_head rcu_sheaves;
>  	struct irq_work work;
>  };
> @@ -4083,6 +4084,7 @@ static void deferred_percpu_work_fn(struct irq_work *work);
>  
>  static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
>  	.objects = LLIST_HEAD_INIT(objects),
> +	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
>  	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
>  	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
>  };
> @@ -6392,12 +6394,13 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  static void deferred_percpu_work_fn(struct irq_work *work)
>  {
>  	struct deferred_percpu_work *dpw;
> -	struct llist_head *objs, *rcu_sheaves;
> +	struct llist_head *objs, *objs_by_rcu, *rcu_sheaves;
>  	struct llist_node *llnode, *pos, *t;
>  
>  	dpw = container_of(work, struct deferred_percpu_work, work);
>  	rcu_sheaves = &dpw->rcu_sheaves;
>  	objs = &dpw->objects;
> +	objs_by_rcu = &dpw->objects_by_rcu;
>  
>  	llnode = llist_del_all(objs);
>  	llist_for_each_safe(pos, t, llnode) {
> @@ -6428,6 +6431,13 @@ static void deferred_percpu_work_fn(struct irq_work *work)
>  
>  		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
>  	}
> +
> +	llnode = llist_del_all(objs_by_rcu);
> +	llist_for_each_safe(pos, t, llnode) {
> +		struct rcu_head *head = (struct rcu_head *)pos;
> +
> +		call_rcu(head, kvfree_rcu_cb);
> +	}
>  }
>  
>  static void defer_free(struct kmem_cache *s, void *head)
> @@ -6443,6 +6453,17 @@ static void defer_free(struct kmem_cache *s, void *head)
>  		irq_work_queue(&dpw->work);
>  }
>  
> +void defer_kfree_rcu(struct rcu_head *head)
> +{
> +	struct deferred_percpu_work *dpw;
> +
> +	guard(preempt)();
> +
> +	dpw = this_cpu_ptr(&deferred_percpu_work);
> +	if (llist_add((struct llist_node *)head, &dpw->objects_by_rcu))
> +		irq_work_queue(&dpw->work);
> +}
> +
>  void deferred_work_barrier(void)
>  {
>  	int cpu;
> 
> -- 
> 2.53.0

