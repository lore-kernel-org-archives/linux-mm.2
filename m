Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E01F9D2D0EA
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F82F6B0089; Tue, 13 Jan 2026 07:49:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A29A6B008C; Tue, 13 Jan 2026 07:49:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFD76B0092; Tue, 13 Jan 2026 07:49:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 293C66B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:49:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AED75137873
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:49:49 +0000 (UTC)
X-FDA: 84326922498.30.E3A5E62
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id C9CC5100005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:49:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jLU6Ree+;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768308588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXIxaaUrGFoA3E6hwhyauqFe+XDhkHXUkgt2L3qneUY=;
	b=A1mWebXR3PdVHEYhWP8aPKBW0OEcWWgjsGaNYQoe2gq8uaScOGS2A65DtbJB0gehOmCu+r
	xk3EJwiK/R7llTL8tozuU0Eig70wGr/V9fcdKF1IEeepFXMFlJDlA6C/HoiUK/GaPdeo9G
	apVeMa4LNKmX3KLd3sq5PYjW9oj0jGQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jLU6Ree+;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768308588; a=rsa-sha256;
	cv=none;
	b=txco6CqdCJHCwApR3EjQ5a9xcePUZoMxyqk1yhmnPkV9iPN3eFVmvf4jJD4A6ljBXQkyhN
	ISTKpvUx+QumFHadS9pudTPSHvDHiQemEuMSbdjqZIVAs/i2Cw2sortvaT9ma3jhInr9ow
	USrvLSjldUv1rjh5prcTq3iDl02C3+I=
Date: Tue, 13 Jan 2026 20:49:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768308585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sXIxaaUrGFoA3E6hwhyauqFe+XDhkHXUkgt2L3qneUY=;
	b=jLU6Ree+r24DyTvStABI0J3kzJMvugG/W65z/zvvIraHAhGCMhkhqhANfLFqn5X+eY2SiZ
	Cbo19z5LofX7nxip9ep2nFeZwcYbs5JKCnUMFdxWfEFLBNSrhb4ifcFNL5iUv7VWcTFMX8
	N87hBg6WI/1NbfFcNDKKgdibHEDwG2E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC v2 05/20] slab: introduce percpu sheaves bootstrap
Message-ID: <leaboap7yhlnvuxnxvqtl5kazbseimfq3efwfhaon74glfmmc3@paib6qlfee3i>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-5-98225cfb50cf@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112-sheaves-for-all-v2-5-98225cfb50cf@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5f7h6xgfy1dzd37obr3z71nsef7t4zgo
X-Rspamd-Queue-Id: C9CC5100005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768308587-156896
X-HE-Meta: U2FsdGVkX1/mq3x+qT1Jyp1R2mvcb6HI99qW/yUHEoa0MREyRYF5wSS91eG+beAH+SYedhn7+Ac+//kWbLmdruSQyLSObqZ39KZu5WoBd9taT+rTVdlom0tFdVKDv/juC98xhEA9oDY2j9sOdCo6kAP24IHlZSgUQoC0AKfIwLzw1UDBxfMomfvFxSOQtpVzhAEVeAOeqP/mzk/Ch+3s7HhfGpBsNHInKdxg222ksGO2DVzQiJ/03oc2WP6ZkB9z5H5vTK6DQW8x6yqRHpKrwxw6DW8yjxNoFcxCQzV7EESCnqp01LCxUDO5KG2aFLQk6QpaIADbFr7lNzULf1Noh0hjfrHoN1OY/n/aTN54eH+DP7I1QRa50sNYL4cMCwEXJ/KaNpdmQ6APMRhsZ9PFbFMx9UTcNhevUtUbjxg2pl9KyxlfuPC+E4I6fq4vDrV0bIcb2E69pDS16oNG5epS84NJKNgSe+eSpkotfOY71YrsorcY644xqZrtiOOZ35HQ6gEdHYYUDSidGBSx0tPjfU3m7QLw3+RVccRgHFL7nKLcFBVra8pOjeRBgI+gOTV3mUs8um+9IygP1fzEhvEK7dgQFtkrOd0BfTBRvCE57G8AycqIh/rI4AyiiaVGRjU59z0y23XspbArEWxTGJGc8Q2JNMxRxr7TD4GEhmvbp1PHqaOD081qx0fB+sfecRXePhH+9MvziIAGDJr/BwpgC418mc234rWW7KYGishij6X+hxE33NfLJNyleS/1NTvkr+I6RYayfOXwVOf9HomXKpdvHSFMAgDLIwjIzTj+WYHzF2bvXHazaJDW77gtEwI/TS6sC/stjU7PXaKIt9EfttT3mxfaobBaO3dtO3UAZuJ3ZqcqhSW8BrMLe03JhI9B53vdt6CwxF9GykCI9RwipBhee1BNDWD5et5msYCICK+MqXzQJft5AR9r+SpdWJyeKW6Rf1Ie8WTYYLRCUjX
 Uo8Px0t+
 +BmVOvlF4yp74Ehispb3/Ws4OvpK1pjlpem+lwMCC78DBWN8gJ36ScAHQqWNMZO8fn6KTAzxtC84ceJblZYnAzidfFiT30g3rRxUmKFT0ytzlhcgV9OBaPnH1yU/75htJnPvunxOr0vUeMzeqgSnQfaUc1Y6fchpmtj9tbdPnYKfRPpVMkXNlVpV2q1GMTuRbo1Q0kWvggzublkD1Bza4cFziMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 04:16:59PM +0100, Vlastimil Babka wrote:
> Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
> sheaves enabled. Since we want to enable them for almost all caches,
> it's suboptimal to test the pointer in the fast paths, so instead
> allocate it for all caches in do_kmem_cache_create(). Instead of testing
> the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
> kmem_cache->sheaf_capacity for being 0, where needed.
> 
> However, for the fast paths sake we also assume that the main sheaf
> always exists (pcs->main is !NULL), and during bootstrap we cannot
> allocate sheaves yet.
> 
> Solve this by introducing a single static bootstrap_sheaf that's
> assigned as pcs->main during bootstrap. It has a size of 0, so during
> allocations, the fast path will find it's empty. Since the size of 0
> matches sheaf_capacity of 0, the freeing fast paths will find it's
> "full". In the slow path handlers, we check sheaf_capacity to recognize
> that the cache doesn't (yet) have real sheaves, and fall back. Thus
> sharing the single bootstrap sheaf like this for multiple caches and
> cpus is safe.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 69 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 6e05e3cc5c49..06d5cf794403 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2855,6 +2855,10 @@ static void pcs_destroy(struct kmem_cache *s)
>  		if (!pcs->main)
>  			continue;
>  
> +		/* bootstrap or debug caches, it's the bootstrap_sheaf */
> +		if (!pcs->main->cache)
> +			continue;
> +
>  		/*
>  		 * We have already passed __kmem_cache_shutdown() so everything
>  		 * was flushed and there should be no objects allocated from
> @@ -4052,7 +4056,7 @@ static void flush_cpu_slab(struct work_struct *w)
>  
>  	s = sfw->s;
>  
> -	if (s->cpu_sheaves)
> +	if (s->sheaf_capacity)
>  		pcs_flush_all(s);
>  
>  	flush_this_cpu_slab(s);
> @@ -4179,7 +4183,7 @@ static int slub_cpu_dead(unsigned int cpu)
>  	mutex_lock(&slab_mutex);
>  	list_for_each_entry(s, &slab_caches, list) {
>  		__flush_cpu_slab(s, cpu);
> -		if (s->cpu_sheaves)
> +		if (s->sheaf_capacity)
>  			__pcs_flush_all_cpu(s, cpu);
>  	}
>  	mutex_unlock(&slab_mutex);
> @@ -4979,6 +4983,12 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  
>  	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
> +	/* Bootstrap or debug cache, back off */
> +	if (unlikely(!s->sheaf_capacity)) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		return NULL;
> +	}
> +
>  	if (pcs->spare && pcs->spare->size > 0) {
>  		swap(pcs->main, pcs->spare);
>  		return pcs;
> @@ -5165,6 +5175,11 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		struct slab_sheaf *full;
>  		struct node_barn *barn;
>  
> +		if (unlikely(!s->sheaf_capacity)) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			return allocated;
> +		}
> +
>  		if (pcs->spare && pcs->spare->size > 0) {
>  			swap(pcs->main, pcs->spare);
>  			goto do_alloc;
> @@ -5244,8 +5259,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
>  	if (unlikely(object))
>  		goto out;
>  
> -	if (s->cpu_sheaves)
> -		object = alloc_from_pcs(s, gfpflags, node);
> +	object = alloc_from_pcs(s, gfpflags, node);
>  
>  	if (!object)
>  		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
> @@ -6078,6 +6092,12 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  restart:
>  	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
> +	/* Bootstrap or debug cache, back off */
> +	if (unlikely(!s->sheaf_capacity)) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		return NULL;
> +	}
> +
>  	barn = get_barn(s);
>  	if (!barn) {
>  		local_unlock(&s->cpu_sheaves->lock);
> @@ -6276,6 +6296,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  		struct slab_sheaf *empty;
>  		struct node_barn *barn;
>  
> +		/* Bootstrap or debug cache, fall back */
> +		if (!unlikely(s->sheaf_capacity)) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			goto fail;
> +		}
> +
>  		if (pcs->spare && pcs->spare->size == 0) {
>  			pcs->rcu_free = pcs->spare;
>  			pcs->spare = NULL;
> @@ -6401,6 +6427,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  	if (likely(pcs->main->size < s->sheaf_capacity))
>  		goto do_free;
>  
> +	if (unlikely(!s->sheaf_capacity))
> +		goto no_empty;
> +
>  	barn = get_barn(s);
>  	if (!barn)
>  		goto no_empty;
> @@ -6668,9 +6697,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
>  		return;
>  
> -	if (s->cpu_sheaves && likely(!IS_ENABLED(CONFIG_NUMA) ||
> -				     slab_nid(slab) == numa_mem_id())
> -			   && likely(!slab_test_pfmemalloc(slab))) {
> +	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
> +	    && likely(!slab_test_pfmemalloc(slab))) {
>  		if (likely(free_to_pcs(s, object)))
>  			return;
>  	}
> @@ -7484,8 +7512,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>  		size--;
>  	}
>  
> -	if (s->cpu_sheaves)
> -		i = alloc_from_pcs_bulk(s, size, p);
> +	i = alloc_from_pcs_bulk(s, size, p);
>  
>  	if (i < size) {
>  		/*
> @@ -7696,6 +7723,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
>  
>  static int init_percpu_sheaves(struct kmem_cache *s)
>  {
> +	static struct slab_sheaf bootstrap_sheaf = {};
>  	int cpu;
>  
>  	for_each_possible_cpu(cpu) {
> @@ -7705,7 +7733,28 @@ static int init_percpu_sheaves(struct kmem_cache *s)
>  
>  		local_trylock_init(&pcs->lock);
>  
> -		pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
> +		/*
> +		 * Bootstrap sheaf has zero size so fast-path allocation fails.
> +		 * It has also size == s->sheaf_capacity, so fast-path free
> +		 * fails. In the slow paths we recognize the situation by
> +		 * checking s->sheaf_capacity. This allows fast paths to assume
> +		 * s->pcs_sheaves and pcs->main always exists and is valid.
> +		 * It's also safe to share the single static bootstrap_sheaf
> +		 * with zero-sized objects array as it's never modified.
> +		 *
> +		 * bootstrap_sheaf also has NULL pointer to kmem_cache so we
> +		 * recognize it and not attempt to free it when destroying the
> +		 * cache
> +		 *
> +		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
> +		 * caches with debug enabled, and all caches with SLUB_TINY.
> +		 * For kmalloc caches it's used temporarily during the initial
> +		 * bootstrap.
> +		 */
> +		if (!s->sheaf_capacity)
> +			pcs->main = &bootstrap_sheaf;
> +		else
> +			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
>  
>  		if (!pcs->main)
>  			return -ENOMEM;
> @@ -7803,7 +7852,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
>  			continue;
>  		}
>  
> -		if (s->cpu_sheaves) {
> +		if (s->sheaf_capacity) {
>  			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
>  
>  			if (!barn)
> @@ -8121,7 +8170,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
>  	flush_all_cpus_locked(s);
>  
>  	/* we might have rcu sheaves in flight */
> -	if (s->cpu_sheaves)
> +	if (s->sheaf_capacity)
>  		rcu_barrier();
>  
>  	/* Attempt to free all objects */
> @@ -8433,7 +8482,7 @@ static int slab_mem_going_online_callback(int nid)
>  		if (get_node(s, nid))
>  			continue;
>  
> -		if (s->cpu_sheaves) {
> +		if (s->sheaf_capacity) {
>  			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
>  
>  			if (!barn) {
> @@ -8641,12 +8690,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>  
>  	set_cpu_partial(s);
>  
> -	if (s->sheaf_capacity) {
> -		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
> -		if (!s->cpu_sheaves) {
> -			err = -ENOMEM;
> -			goto out;
> -		}
> +	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);

Since we allocate cpu_sheaves for all SLUB caches, the "if (!s->cpu_sheaves)"
condition in has_pcs_used() should be always false in practice (unless I'm
misunderstanding something). Would it make sense to change it to "if
(!s->sheaf_capacity)" instead?

Also, while trying to understand the difference between checking s->cpu_sheaves
vs s->sheaf_capacity, I noticed that most occurrences of "if (s->cpu_sheaves)"
(except the one in __kmem_cache_release) could be expressed as "if
(s->sheaf_capacity)" as well.

And Perhaps we could introduce a small helper around "if (s->sheaf_capacity)" to
make the intent a bit more explicit.

-- 
Thanks,
Hao

> +	if (!s->cpu_sheaves) {
> +		err = -ENOMEM;
> +		goto out;
>  	}
>  
>  #ifdef CONFIG_NUMA
> @@ -8665,11 +8712,9 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>  	if (!alloc_kmem_cache_cpus(s))
>  		goto out;
>  
> -	if (s->cpu_sheaves) {
> -		err = init_percpu_sheaves(s);
> -		if (err)
> -			goto out;
> -	}
> +	err = init_percpu_sheaves(s);
> +	if (err)
> +		goto out;
>  
>  	err = 0;
>  
> 
> -- 
> 2.52.0
> 

