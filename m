Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94104CDE003
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892E46B0088; Wed, 24 Jun 2026 10:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86AA36B008A; Wed, 24 Jun 2026 10:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734BC6B0093; Wed, 24 Jun 2026 10:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7B56B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:37:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDC624038C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:37:30 +0000 (UTC)
X-FDA: 84915059460.11.81CC51E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id A94C0A0002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:37:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YyKj3973;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xkpX6Dx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YyKj3973;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xkpX6Dx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782311848;
	b=ZPPvtIHrhAPO1+tj/OMhOud7YoTw7eeswtVa2RMFpBqr0yOtUHtBAxWXf6mQb//Yf4edtP
	pym3NnU/EYfN25x9OL4ck+CugeIbOsXYmoFC11J/EZ3w7vt0udueulJZ0YAQ7Z/kxg+EVZ
	VWplRyphWOQRhnCHA9rTAvW6WgUur7A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGpCqhie84Lk+N3qc4OewQcNGuUPftRJsClpCvq+bXc=;
	b=Df/6UXVvzyNsuuOGeSwMdGiqFHPouRxuBJCH6KeF74LKdOkeapsujzGDIRXLUWXItz5gT5
	3Tkozvr07K03QhbamF85o16lexA/nLOdll10BuA9o2PZE7dz4iVZ904G9G1n9uvyWA++o3
	0xgB0Dv+Yz2GMIcQDSa3tjGWpfwFptI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YyKj3973;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xkpX6Dx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YyKj3973;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9xkpX6Dx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 68BD0713CB;
	Wed, 24 Jun 2026 14:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782311847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zGpCqhie84Lk+N3qc4OewQcNGuUPftRJsClpCvq+bXc=;
	b=YyKj3973y1Xg/Oexbfr+PBiwVs954B0yLiqrokAVRdaDVt9/vtrG8OemPouwnTr1MqpbF7
	D5VjEvClG4TtTsHZ7gd5ALruogq4zndLtwq5641bAN36cyXP1FMJWmVkELQkPn/g8gjlaz
	ClgxEBuAXe99303UYjSPsB1fLg3Unfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782311847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zGpCqhie84Lk+N3qc4OewQcNGuUPftRJsClpCvq+bXc=;
	b=9xkpX6DxD6Y3QtPtaDBmuzjK/5CJ9QAPJTFALvoAtKxaaRQPzzeGLmJAsdWQrT+eX5tMrW
	+gtrhTb44yjt4kCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782311847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zGpCqhie84Lk+N3qc4OewQcNGuUPftRJsClpCvq+bXc=;
	b=YyKj3973y1Xg/Oexbfr+PBiwVs954B0yLiqrokAVRdaDVt9/vtrG8OemPouwnTr1MqpbF7
	D5VjEvClG4TtTsHZ7gd5ALruogq4zndLtwq5641bAN36cyXP1FMJWmVkELQkPn/g8gjlaz
	ClgxEBuAXe99303UYjSPsB1fLg3Unfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782311847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zGpCqhie84Lk+N3qc4OewQcNGuUPftRJsClpCvq+bXc=;
	b=9xkpX6DxD6Y3QtPtaDBmuzjK/5CJ9QAPJTFALvoAtKxaaRQPzzeGLmJAsdWQrT+eX5tMrW
	+gtrhTb44yjt4kCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93E96779A8;
	Wed, 24 Jun 2026 14:37:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6z3cIKXrO2oJTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 24 Jun 2026 14:37:25 +0000
Date: Wed, 24 Jun 2026 15:37:23 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang@linux.dev>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [PATCH for-next v3 5/9] mm/slab: extend deferred free mechanism
 to handle rcu sheaves
Message-ID: <ajvrNoE81J-_4zsM@pedro-suse>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-5-70a54f3775bb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-kfree_rcu_nolock-v3-5-70a54f3775bb@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A94C0A0002
X-Rspam-User: 
X-Stat-Signature: hrbhi1qdu8k5erkf9ynciun7koa3efzi
X-HE-Tag: 1782311848-422156
X-HE-Meta: U2FsdGVkX1+bVWkPpvC19lDyegaU5pez756S4DdWBKPn3HV8H5fxM6Ezzq8oqHCXcO3vwRwssTIy92H+0KcupJRauyDLgBakw3fgDkG+ufNsNcsgKPjYOOyfpFJbUGTpq2uPefIQpQEpoff+QlEhaeA7LsgMvIHLpnBgggnlrYARRaeRYptoYCizZvmSo3rUC70ERdPtD5027HNkIIA8NT28VtDo5kdKIYCXkD4N7FPvmHMbsL+bH801nsr+oj10P14zHjqjyGrMH/2j137lxj4yWJGUvBwsBOgU4gA3cvaGY1u+wdK3HIgW46uFNzHRi2BnNM0fLTaSRRSEWa95qghjXXosMUFyHsCompKED8EBGUtDjRLUKa8molOT9qon4dtSSx+ATxI9k3YJTRl0rCLrZbknhTKJBLEu6ytrvjlaG5mKOuifm24pp5X/QcO5SUfZAMm4+VKBiytOa09SJdOSv0gF7YaatE4UqqmPuTiQ2yZg7lifVfL3aUDiV8z0YIMWEHleXFt0o0aYCtRPgg/se4WjjsR0HM9SLhPVFw+I/DPDqWPrGSYGoFbA5k7z/xmeakQvDLdUAX9xIBzvpgbZz1TG0KsEDgWGkGFNTYOxiRGTh6vlzaBoLXYQ6Q4MZyrkFAChPwEMd8kZeCRzzpHeJu2k7+B5XgQ7nrsAL2cS5RsXOvXFuIeTGVHBTtfz7i39z0Bmb2ZPU/XEsEt2kqs08eQT94dwz+zSndlOPAcHTe2AY85ztz0c0pWEVxL/lN3nxDKk/+Nj5cepo1z7wrUKfIkjBMTPwOQ+gnpCqf04hdafHPljWhXvrMPxHQZ+ej4tQvA1O+C/MNOqZTunhOUb67QfWzmBfMbLmcqZVZ+asez3dJp+iNANc/ZXVIxFMj2ZtYkX/ccxYJ2pyTScgNOs/As+es1SyIWXzC/NUNxD7hHEUeOVH7YK21nj5CzBPUbraRYzNoDop/0hZIB
 IzV8O2Gy
 WuYLuaHxVN8XaZhg/VUTReC756aMUybhcob4iAK6/jbQ/9If502DzrQgh8etbcqvsr7e43JRJrGvT2VaqmXCc7RVj87zgd2fOVyB0BFu907KnQnokHsNFJLF6DpIBFACwBw9EjReWllS3mgIvPVXAJshWvvaGN0Q/h20hDNAtQkdyYRe5U3A5mkjdK2vVbUNS6c5sD9yJbaajZCwtrD2cWwTjqFtrkaBOyioIuNzZZ0jyOS9oZCp467HJX+knkZx0cC+FCLv82Pj0sRIlWW3oYGWsffHxtRkIehQe+PIbrKkLouYkrakLGvckiDIdHtUO4YMoDc3so+KEP9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 08:05:59PM +0900, Harry Yoo (Oracle) wrote:
> __kfree_rcu_sheaf() cannot invoke call_rcu() when spinning is not
> allowed and IRQs are disabled. To relax the limitation, extend the
> deferred free fallback so that a full rcu sheaf can be submitted to
> call_rcu() via the existing IRQ work.
> 
> Since the deferred mechanism does more than deferred free of objects,
> rename the struct to deferred_percpu_work and adjust names accordingly.
> 
> When a sheaf is queued on an IRQ work, it is detached from
> pcs->rcu_free but call_rcu() is not invoked until the irq_work runs.
> To keep the kvfree_rcu barrier's promise, call irq_work_sync() on each
> CPU before calling rcu_barrier().
> 
> In the meantime, remove the TODO item as apparently there is no simple
> and effective way to achieve that.
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slab.h        |  2 +-
>  mm/slab_common.c |  7 ++---
>  mm/slub.c        | 79 ++++++++++++++++++++++++++++++++++----------------------
>  3 files changed, 51 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index b1bd33a16544..961581e35ec8 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -744,7 +744,7 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
>  void __check_heap_object(const void *ptr, unsigned long n,
>  			 const struct slab *slab, bool to_user);
>  
> -void defer_free_barrier(void);
> +void deferred_work_barrier(void);
>  
>  static inline bool slub_debug_orig_size(struct kmem_cache *s)
>  {
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index bc1a8ec938d9..55546b8385ff 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -551,7 +551,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  	}
>  
>  	/* Wait for deferred work from kmalloc/kfree_nolock() */
> -	defer_free_barrier();
> +	deferred_work_barrier();
>  
>  	cpus_read_lock();
>  	mutex_lock(&slab_mutex);
> @@ -2113,13 +2113,10 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  		cpus_read_lock();
>  		flush_rcu_sheaves_on_cache(s);
>  		cpus_read_unlock();
> +		deferred_work_barrier();
>  		rcu_barrier();
>  	}
>  
> -	/*
> -	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
> -	 * on a specific slab cache.
> -	 */

Perhaps could be worth detailing why this is not possible.

>  	__kvfree_rcu_barrier();
>  }
>  EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
> diff --git a/mm/slub.c b/mm/slub.c
> index 6a3552b70683..ba593c1c53d5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -418,6 +418,8 @@ struct slab_sheaf {
>  	union {
>  		struct rcu_head rcu_head;
>  		struct list_head barn_list;
> +		/* only used to defer call_rcu() in unknown context */
> +		struct llist_node llnode;
>  		/* only used for prefilled sheafs */
>  		struct {
>  			unsigned int capacity;
> @@ -4071,6 +4073,20 @@ static void flush_all(struct kmem_cache *s)
>  	cpus_read_unlock();
>  }
>  
> +struct deferred_percpu_work {
> +	struct llist_head objects;
> +	struct llist_head rcu_sheaves;
> +	struct irq_work work;
> +};
> +
> +static void deferred_percpu_work_fn(struct irq_work *work);
> +
> +static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
> +	.objects = LLIST_HEAD_INIT(objects),
> +	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
> +	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
> +};
> +
>  static void flush_rcu_sheaf(struct work_struct *w)
>  {
>  	struct slub_percpu_sheaves *pcs;
> @@ -4142,6 +4158,7 @@ void flush_all_rcu_sheaves(void)
>  	mutex_unlock(&slab_mutex);
>  	cpus_read_unlock();
>  
> +	deferred_work_barrier();
>  	rcu_barrier();
>  }
>  
> @@ -6158,12 +6175,6 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
>  	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>  		rcu_sheaf = NULL;
>  	} else {
> -		/* call_rcu() disables IRQs to protect percpu data structures */
> -		if (unlikely(!allow_spin && irqs_disabled())) {
> -			rcu_sheaf->size--;
> -			local_unlock(&s->cpu_sheaves->lock);
> -			goto fail;
> -		}
>  		pcs->rcu_free = NULL;
>  		rcu_sheaf->node = numa_node_id();
>  	}
> @@ -6172,8 +6183,18 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
>  	 * we flush before local_unlock to make sure a racing
>  	 * flush_all_rcu_sheaves() doesn't miss this sheaf
>  	 */
> -	if (rcu_sheaf)
> -		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
> +	if (rcu_sheaf) {
> +		/* call_rcu() disables IRQs to protect percpu data structures */
> +		if (unlikely(!allow_spin && irqs_disabled())) {
> +			struct deferred_percpu_work *dpw;
> +
> +			dpw = this_cpu_ptr(&deferred_percpu_work);
> +			if (llist_add(&rcu_sheaf->llnode, &dpw->rcu_sheaves))
> +				irq_work_queue(&dpw->work);
> +		} else {
> +			call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
> +		}
> +	}
>  
>  	local_unlock(&s->cpu_sheaves->lock);
>  
> @@ -6360,31 +6381,20 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  	}
>  }
>  
> -struct defer_free {
> -	struct llist_head objects;
> -	struct irq_work work;
> -};
> -
> -static void free_deferred_objects(struct irq_work *work);
> -
> -static DEFINE_PER_CPU(struct defer_free, defer_free_objects) = {
> -	.objects = LLIST_HEAD_INIT(objects),
> -	.work = IRQ_WORK_INIT(free_deferred_objects),
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
> -	struct defer_free *df = container_of(work, struct defer_free, work);
> -	struct llist_head *objs = &df->objects;
> +	struct deferred_percpu_work *dpw;
> +	struct llist_head *objs, *rcu_sheaves;
>  	struct llist_node *llnode, *pos, *t;
>  
> -	if (llist_empty(objs))
> -		return;
> +	dpw = container_of(work, struct deferred_percpu_work, work);
> +	rcu_sheaves = &dpw->rcu_sheaves;
> +	objs = &dpw->objects;
>  
>  	llnode = llist_del_all(objs);
>  	llist_for_each_safe(pos, t, llnode) {
> @@ -6408,27 +6418,34 @@ static void free_deferred_objects(struct irq_work *work)
>  		__slab_free(s, slab, x, x, 1, _THIS_IP_);
>  		stat(s, FREE_SLOWPATH);
>  	}
> +
> +	llnode = llist_del_all(rcu_sheaves);
> +	llist_for_each_safe(pos, t, llnode) {
	llist_for_each_entry_safe?

> +		struct slab_sheaf *rcu_sheaf = llist_entry(pos, struct slab_sheaf, llnode);
> +
> +		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
> +	}
>  }
>  

Otherwise LGTM!
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
 

-- 
Pedro

