Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77499CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 08:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592666B0005; Sun, 17 May 2026 04:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BE76B0088; Sun, 17 May 2026 04:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD686B008C; Sun, 17 May 2026 04:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 241166B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 04:30:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCD868CD32
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:30:39 +0000 (UTC)
X-FDA: 84776240598.17.DA36D1C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9FFCDC0004
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:30:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="py7fXe9/";
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779006638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avCGmmlpduPyMmxXu4L2U/JHFJz33UTXV9xcOckh1EE=;
	b=O42a93lqQ1Z49jeaVVASqJAR4ObFin9z636JNIxbphvGb7EbNqOD59m5/xmE/fgUeQM9Dy
	iRu55zr66E/6k8xC+7rNPonv3yyChONdT2t/x1rOYW5Wtlly+QPCtxDuN53AXl9YLROQcR
	PG6lOLTYeNFX9B/nsDaO0fLtgVVuoqk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="py7fXe9/";
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779006638; a=rsa-sha256;
	cv=none;
	b=pkYoekZnHEj9qgQtiqn3thYsqK0TXF41itnOS/ttqMZFATafflHaeYSp46l1j4YV/fAWZb
	NUUc3pg/9ClMrLew+LS0JASckmfQHw5m4UO5lzh0jQQzJoW1TyY1YX9R+vtSs9dbPItepf
	Ffkjjky+NgTggmJQ9OztPXhrKsUMRwo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 270451BA8;
	Sun, 17 May 2026 01:30:31 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D5393F7B4;
	Sun, 17 May 2026 01:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779006636; bh=PbVeYUMCy9ZNw/I2WsvAf55Q0k0C2/CdKzJdQZTziy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=py7fXe9/czjeB0heNJ5RSDIctOMUxMxgjTQ5kr6lpxF4csSYrAnQjY/PNdv9YoPL/
	 9E22LdwVlq9BWS+A7c6OAA0aGG/jQn2NhrHoeMfHsAvqkxyuV6CgVjZmO53mU6XKPH
	 Ml+ccHkeVag4fv1j3UcMnBywIIOgA4Rkf5LMoJRU=
Date: Sun, 17 May 2026 09:30:31 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH RFC 6/8] mm/slab: allow changing sheaf_capacity at runtime
Message-ID: <agl8p8WkngbBdyZH@e129823.arm.com>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
 <20260516-sheaves-tuning-v1-6-221aa3e1d829@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260516-sheaves-tuning-v1-6-221aa3e1d829@kernel.org>
X-Stat-Signature: uizqt45rsd78ddyzyizs6gyzjnjqg4jm
X-Rspamd-Queue-Id: 9FFCDC0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779006637-146209
X-HE-Meta: U2FsdGVkX1+OEJraMOd3tWRhP9eEIRGLYU+xtzpZ6yekAJjT9Vatj9O7NI4Dh3jgrOML8TL69rg0ofbJaU3NtOe1eGm4YVScwXB1sB5K5aON8u9tYwFijoM9n9Za2mv7Lk9rhnJ7a03t9J60XCyXKBcjj6qp75yOAErwuIMincYP6eebMP98BFC95iUmSLchh32nCIliY1g12FmfVxy3rn9i6Yf2sQpiQVMXj9y73unyUv7tbBW85ys2I9nFNo4jWLqveRk5j7Rqejvup8H/OGDE5d3hbd0ARQfDILWCskmPdmzasU5EhjWxTFG5K9ZrYMFqqr4BZtEqG73MhgQatu+/dapKYJv+JR/eajllCBa9upWf84kXOQEqX30l+nN7cQyaEuNfu6Y10/WG7sEFk7/wtuEOip2mcEelo8EpsjXOFXwS0BO6eULm6Jy1iAI/FCsIkBG9BWe1eXhfjVYz5MtmwQWb0N3fdf6yWLf/O50EDIEKUd+cYwFZBx1Z2DD7ERzy9ydp+R0xx7DoCQ0pAMnin/IjOC+ZWJQ/IYxecQg6cCEfiSL2Wkyt6zN913CuzhOpb8Hqtn3S0K9xki0hlEFdfCBosP6coJYi+gtscMAED+a5yxsijA7TU2Y+D47jr6QVIJMSObo9AfrNqn2vVtg5AwRPOoi8XaNLd1PAHxy36iBeMBYTcq01Ba+KdaJKzD4yFBW7JGQaS+dSOwmVFhrPNEJpfzGmHoY9sWRfUffvgi50axojXYwWw76z8eNhtl8fSZKUX7m+BdMpLOYWkOfQUWjWtq3fnzBfEGTUcmU6EJl3+Y4FT/hkC94LJD0td29sqAwPQQPC8P7+OFHOWz0fNwu3d0j+Ey8Tpwkk3YewqT4KF1hOxd9ytjnuoOXlzcGTePQCgONmLfVNK4Ij6Ooxfn1zqhlrEpsAwugJZt8kJMAIcAxrrw1lABggrdXaUOwHmRjp7ZQohRQnOl8
 jFrILNNi
 rr0EqXrKGIZ5g8kAueZq8kG6Ds5mGybONMgtC8gLIAwQsqTzzoyH3dW4uVY2xaSJn2fB5iq9732/6+nkpEj0BeA8Va8esAX7g2G6gvjBUx260Fe8tq+MApqXXeyhXBRYgfMIESzfBZ32zNwBPa+DcjMk2MeE2DTYcnrJuuiZxfgcaaUGxGzAqBcBtxPBBbwHQNty3lBIINVYHAJqrCTMuUsKEv1eqpLvgPraURIe5u3km8GebTRnCCcgt6fDOIucagiQLuo5uJ1BroYanAAdSs/IEZykLCOMf5ZZR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

> Make the sheaf_capacity sysfs attribute writable so that the sheaf
> capacity can be tuned at runtime per-cache.
> 
> The steps to change sheaf capacity:
> 
>   1. Disable sheaves: make all online CPUs replace their main sheaves
>      with the bootstrap sheaf under local_lock and wait for completion.
>      For offline CPUs, update their pcs directly under cpu_hotplug_lock.
> 
>   2. Wait for pre-existing RCU callbacks to complete so that RCU sheaves
>      are returned to the barn.
> 
>   3. Shrink the cache to flush and free all existing sheaves.
> 
>   4. Re-enable sheaves with the new capacity by calling
>      bootstrap_cache_sheaves(). If this fails, sheaves remain disabled
>      for the cache.
> 
> Use slab_mutex to serialize sheaf capacity updates.
> 
> If sheaves of different capacities can coexist after several updates
> to the sheaf_capacity, performance becomes hard to predict. It is
> important to allow only a single capacity at any given point in time.
> 
> To achieve that, it is required to check whether the sheaf capacity is
> stale. However, performing this check without an expensive
> synchronization mechanism (SRCU, atomics, etc.) is inevitably racy.
> 
> Instead, a copy of sheaf capacity is stored in struct
> slub_percpu_sheaves and each CPU has its own copy of the capacity.
> With that, we can guarantee that this value remains stable under
> local_lock.
> 
> If local_lock is acquired while the sheaf capacity update is in
> progress, then either:
> 
>   1. Sheaves on the CPU have already been disabled (meaning pcs->main
>      points at bootstrap_sheaf, falling back to slowpath), or
> 
>   2. After releasing local_lock, percpu sheaves will be flushed and
>      disabled for the CPU, and all sheaves in the barn will be
>      flushed and freed.
> 
> It is guaranteed that no sheaf with stale capacity remains
> after the process is complete as long as certain rules are followed.
> 
> The new rules to avoid sheaves of a stale capacity:
> 
>   1. Hold local_lock when getting/putting sheaves from/to the barn.
> 
>   2. When allocating new sheaves, check whether pcs->capacity and
>      sheaf->capacity match after re-acquiring local_lock.
> 
>   3. If local_trylock fails, flush and free the sheaf. This should be
>      rare.
> 
> Per the above rules, rcu_free_sheaf() now tries to acquire the pcs lock
> and check whether the capacities match before putting the sheaf back
> to the barn.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slub.c | 386 +++++++++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 308 insertions(+), 78 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index c746c9b48728..7def24fdfae6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -425,6 +425,7 @@ struct slub_percpu_sheaves {
>  	struct slab_sheaf *main; /* never NULL when unlocked */
>  	struct slab_sheaf *spare; /* empty or full, may be NULL */
>  	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
> +	unsigned short capacity;
>  };
>  
>  static struct slab_sheaf bootstrap_sheaf = {};
> @@ -492,6 +493,30 @@ static inline struct node_barn *get_barn(struct kmem_cache *s)
>   */
>  static nodemask_t slab_nodes;
>  
> +
> +static inline
> +unsigned short get_pcs_capacity(struct kmem_cache *s,
> +				struct slub_percpu_sheaves *pcs)
> +{
> +	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> +	return pcs->capacity;
> +}
> +
> +static inline void set_pcs_capacity(struct kmem_cache *s,
> +				    struct slub_percpu_sheaves *pcs,
> +				    unsigned short capacity)
> +{
> +	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> +	pcs->capacity = capacity;
> +}
> +
> +static inline bool pcs_capacity_match(struct kmem_cache *s,
> +				      struct slub_percpu_sheaves *pcs,
> +				      struct slab_sheaf *sheaf)
> +{
> +	return get_pcs_capacity(s, pcs) == sheaf->capacity;
> +}
> +
>  /*
>   * Similar to slab_nodes but for where we have node_barn allocated.
>   * Corresponds to N_ONLINE nodes.
> @@ -507,6 +532,11 @@ struct slub_flush_work {
>  	struct work_struct work;
>  	struct kmem_cache *s;
>  	bool skip;
> +	/* for flushing sheaves */
> +	bool disable_sheaves;
> +	/* for enabling sheaves */
> +	void **sheaves;
> +	unsigned short capacity;
>  };
>  
>  static DEFINE_MUTEX(flush_lock);
> @@ -2774,6 +2804,10 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	if (gfp & __GFP_NO_OBJ_EXT)
>  		return NULL;
>  
> +	/* Sheaves have been disabled */
> +	if (!capacity)
> +		return NULL;
> +
>  	gfp &= ~OBJCGS_CLEAR_MASK;
>  
>  	/*
> @@ -2800,7 +2834,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
>  static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
>  						   gfp_t gfp)
>  {
> -	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
> +	return __alloc_empty_sheaf(s, gfp, data_race(s->sheaf_capacity));
>  }
>  
>  static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
> @@ -2999,10 +3033,10 @@ static void rcu_free_sheaf_nobarn(struct rcu_head *head)
>   * flushing operations are rare so let's keep it simple and flush to slabs
>   * directly, skipping the barn
>   */
> -static void pcs_flush_all(struct kmem_cache *s)
> +static void pcs_flush_all(struct kmem_cache *s, bool disable_sheaves)
>  {
>  	struct slub_percpu_sheaves *pcs;
> -	struct slab_sheaf *spare, *rcu_free;
> +	struct slab_sheaf *spare, *rcu_free, *main;
>  
>  	local_lock(&s->cpu_sheaves->lock);
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
> @@ -3013,8 +3047,23 @@ static void pcs_flush_all(struct kmem_cache *s)
>  	rcu_free = pcs->rcu_free;
>  	pcs->rcu_free = NULL;
>  
> +	if (disable_sheaves && pcs_has_sheaves(pcs)) {
> +		main = pcs->main;
> +		pcs->main = &bootstrap_sheaf;
> +		set_pcs_capacity(s, pcs, 0);
> +	} else {
> +		main = NULL;
> +	}
> +
>  	local_unlock(&s->cpu_sheaves->lock);
>  
> +	if (main) {
> +		sheaf_flush_unused(s, main);
> +		free_empty_sheaf(s, main);
> +	} else {
> +		sheaf_flush_main(s);
> +	}
> +
>  	if (spare) {
>  		sheaf_flush_unused(s, spare);
>  		free_empty_sheaf(s, spare);
> @@ -3022,8 +3071,6 @@ static void pcs_flush_all(struct kmem_cache *s)
>  
>  	if (rcu_free)
>  		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
> -
> -	sheaf_flush_main(s);
>  }
>  
>  static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
> @@ -3986,10 +4033,34 @@ static void flush_cpu_sheaves(struct work_struct *w)
>  	s = sfw->s;
>  
>  	if (cache_supports_sheaves(s))
> -		pcs_flush_all(s);
> +		pcs_flush_all(s, sfw->disable_sheaves);
> +}
> +
> +static void enable_cpu_sheaves(struct work_struct *w)
> +{
> +	struct kmem_cache *s;
> +	struct slub_flush_work *sfw;
> +	struct slab_sheaf *sheaf;
> +	struct slub_percpu_sheaves *pcs;
> +
> +	sfw = container_of(w, struct slub_flush_work, work);
> +
> +	s = sfw->s;
> +
> +	local_lock(&s->cpu_sheaves->lock);
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +	sheaf = sfw->sheaves[smp_processor_id()];
> +
> +	VM_WARN_ON_ONCE(pcs->rcu_free);
> +	VM_WARN_ON_ONCE(pcs->spare);
> +	VM_WARN_ON_ONCE(pcs->main != &bootstrap_sheaf);
> +
> +	pcs->main = sheaf;
> +	set_pcs_capacity(s, pcs, sfw->capacity);
> +	local_unlock(&s->cpu_sheaves->lock);
>  }
>  
> -static void flush_all_cpus_locked(struct kmem_cache *s)
> +static void flush_all_cpus_locked(struct kmem_cache *s, bool disable_sheaves)
>  {
>  	struct slub_flush_work *sfw;
>  	unsigned int cpu;
> @@ -3997,16 +4068,32 @@ static void flush_all_cpus_locked(struct kmem_cache *s)
>  	lockdep_assert_cpus_held();
>  	mutex_lock(&flush_lock);
>  
> -	for_each_online_cpu(cpu) {
> +	for_each_possible_cpu(cpu) {
>  		sfw = &per_cpu(slub_flush, cpu);
> -		if (!has_pcs_used(cpu, s)) {
> +
> +		if (cpu_online(cpu)) {
> +			/* Do not skip empty sheaves when disabling them */
> +			if (!disable_sheaves && !has_pcs_used(cpu, s)) {
> +				sfw->skip = true;
> +				continue;
> +			}
> +			INIT_WORK(&sfw->work, flush_cpu_sheaves);
> +			sfw->skip = false;
> +			sfw->s = s;
> +			sfw->disable_sheaves = disable_sheaves;
> +			queue_work_on(cpu, flushwq, &sfw->work);
> +		} else if (disable_sheaves) {
> +			struct slub_percpu_sheaves *pcs;
> +
>  			sfw->skip = true;
> -			continue;
> +			pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
> +			if (pcs->main != &bootstrap_sheaf) {
> +				sheaf_flush_unused(s, pcs->main);
> +				free_empty_sheaf(s, pcs->main);
> +				pcs->main = &bootstrap_sheaf;
> +				pcs->capacity = 0;
> +			}
>  		}
> -		INIT_WORK(&sfw->work, flush_cpu_sheaves);
> -		sfw->skip = false;
> -		sfw->s = s;
> -		queue_work_on(cpu, flushwq, &sfw->work);
>  	}
>  
>  	for_each_online_cpu(cpu) {
> @@ -4019,10 +4106,10 @@ static void flush_all_cpus_locked(struct kmem_cache *s)
>  	mutex_unlock(&flush_lock);
>  }
>  
> -static void flush_all(struct kmem_cache *s)
> +static void flush_all(struct kmem_cache *s, bool disable_sheaves)
>  {
>  	cpus_read_lock();
> -	flush_all_cpus_locked(s);
> +	flush_all_cpus_locked(s, disable_sheaves);
>  	cpus_read_unlock();
>  }
>  
> @@ -4690,10 +4777,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  	full = empty;
>  	empty = NULL;
>  
> -	if (!local_trylock(&s->cpu_sheaves->lock))
> -		goto barn_put;
> +	if (!local_trylock(&s->cpu_sheaves->lock)) {
> +		sheaf_flush_unused(s, full);
> +		free_empty_sheaf(s, full);
> +		return NULL;
> +	}
> +
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>  
> +	if (unlikely(!pcs_capacity_match(s, pcs, full))) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		sheaf_flush_unused(s, full);
> +		free_empty_sheaf(s, full);
> +		return NULL;
> +	}
> +
>  	/*
>  	 * If we put any empty or full sheaf to the barn below, it's due to
>  	 * racing or being migrated to a different cpu. Breaching the barn's
> @@ -4721,7 +4819,6 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  		return pcs;
>  	}
>  
> -barn_put:
>  	barn_put_full_sheaf(barn, full);
>  	stat(s, BARN_PUT);
>  
> @@ -5027,29 +5124,8 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
>  	if (unlikely(!size))
>  		return NULL;
>  
> -	if (unlikely(size > s->sheaf_capacity)) {
> -
> -		sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
> -		if (!sheaf)
> -			return NULL;
> -
> -		stat(s, SHEAF_PREFILL_OVERSIZE);
> -		sheaf->capacity = size;
> -
> -		/*
> -		 * we do not need to care about pfmemalloc here because oversize
> -		 * sheaves area always flushed and freed when returned
> -		 */
> -		if (!__kmem_cache_alloc_bulk(s, gfp, size,
> -					     &sheaf->objects[0])) {
> -			kfree(sheaf);
> -			return NULL;
> -		}
> -
> -		sheaf->size = size;
> -
> -		return sheaf;
> -	}
> +	if (unlikely(size > data_race(s->sheaf_capacity)))
> +		goto oversized;
>  
>  	local_lock(&s->cpu_sheaves->lock);
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
> @@ -5072,11 +5148,16 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
>  
>  	local_unlock(&s->cpu_sheaves->lock);
>  
> -
>  	if (!sheaf)
>  		sheaf = alloc_empty_sheaf(s, gfp);
>  
>  	if (sheaf) {
> +		if (size > sheaf->capacity) {
> +			sheaf_flush_unused(s, sheaf);
> +			free_empty_sheaf(s, sheaf);
> +			sheaf = NULL;
> +			goto oversized;
> +		}
>  		sheaf->pfmemalloc = false;
>  
>  		if (sheaf->size < size &&
> @@ -5087,6 +5168,28 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
>  		}
>  	}
>  
> +	return sheaf;
> +
> +oversized:
> +	sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
> +	if (!sheaf)
> +		return NULL;
> +
> +	stat(s, SHEAF_PREFILL_OVERSIZE);
> +	sheaf->capacity = size;
> +
> +	/*
> +	 * we do not need to care about pfmemalloc here because oversize
> +	 * sheaves area always flushed and freed when returned
> +	 */
> +	if (!__kmem_cache_alloc_bulk(s, gfp, size,
> +				     &sheaf->objects[0])) {
> +		kfree(sheaf);
> +		return NULL;
> +	}
> +
> +	sheaf->size = size;
> +
>  	return sheaf;
>  }
>  
> @@ -5106,27 +5209,25 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	struct slub_percpu_sheaves *pcs;
>  	struct node_barn *barn;
>  
> -	if (unlikely((sheaf->capacity != s->sheaf_capacity)
> -		     || sheaf->pfmemalloc)) {
> -		sheaf_flush_unused(s, sheaf);
> -		kfree(sheaf);
> -		return;
> -	}
> +	if (unlikely((sheaf->capacity != data_race(s->sheaf_capacity))
> +		     || sheaf->pfmemalloc))
> +		goto free_sheaf;
>  
>  	local_lock(&s->cpu_sheaves->lock);
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>  	barn = get_barn(s);
>  
> +	if (!pcs_capacity_match(s, pcs, sheaf)) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		goto free_sheaf;
> +	}
> +
>  	if (!pcs->spare) {
>  		pcs->spare = sheaf;
> -		sheaf = NULL;
>  		stat(s, SHEAF_RETURN_FAST);
> -	}
> -
> -	local_unlock(&s->cpu_sheaves->lock);
> -
> -	if (!sheaf)
> +		local_unlock(&s->cpu_sheaves->lock);
>  		return;
> +	}
>  
>  	stat(s, SHEAF_RETURN_SLOW);
>  
> @@ -5134,15 +5235,32 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	 * If the barn has too many full sheaves or we fail to refill the sheaf,
>  	 * simply flush and free it.
>  	 */
> -	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
> -	    refill_sheaf(s, sheaf, gfp)) {
> -		sheaf_flush_unused(s, sheaf);
> -		free_empty_sheaf(s, sheaf);
> -		return;
> +	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		goto free_sheaf;
> +	}
> +
> +	local_unlock(&s->cpu_sheaves->lock);
> +
> +	if (refill_sheaf(s, sheaf, gfp))
> +		goto free_sheaf;
> +
> +	local_lock(&s->cpu_sheaves->lock);
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +
> +	if (!pcs_capacity_match(s, pcs, sheaf)) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		goto free_sheaf;
>  	}
>  
>  	barn_put_full_sheaf(barn, sheaf);
> +	local_unlock(&s->cpu_sheaves->lock);
>  	stat(s, BARN_PUT);
> +	return;
> +
> +free_sheaf:
> +	sheaf_flush_unused(s, sheaf);
> +	free_empty_sheaf(s, sheaf);
>  }
>  
>  /*
> @@ -5839,11 +5957,18 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  
>  got_empty:
>  	if (!local_trylock(&s->cpu_sheaves->lock)) {
> -		barn_put_empty_sheaf(barn, empty);
> +		free_empty_sheaf(s, empty);
>  		return NULL;
>  	}
>  
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
> +
> +	if (unlikely(!pcs_capacity_match(s, pcs, empty))) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		free_empty_sheaf(s, empty);
> +		return NULL;
> +	}
> +
>  	__pcs_install_empty_sheaf(s, pcs, empty, barn);
>  
>  	return pcs;
> @@ -5884,6 +6009,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
>  	struct slab_sheaf *sheaf;
>  	struct node_barn *barn = NULL;
>  	struct kmem_cache *s;
> +	struct slub_percpu_sheaves *pcs;
>  
>  	sheaf = container_of(head, struct slab_sheaf, rcu_head);
>  	if (WARN_ON_ONCE(!sheaf->size)) {
> @@ -5905,11 +6031,20 @@ static void rcu_free_sheaf(struct rcu_head *head)
>  	 * slab so simply flush everything.
>  	 */
>  	if (__rcu_free_sheaf_prepare(s, sheaf))
> -		goto flush;
> +		goto flush_unlocked;
>  
>  	barn = get_barn_node(s, sheaf->node);
>  	if (!barn)
> -		goto flush;
> +		goto flush_unlocked;
> +
> +	if (!local_trylock(&s->cpu_sheaves->lock))
> +		goto flush_unlocked;
> +
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +	if (!pcs_capacity_match(s, pcs, sheaf)) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		goto flush_unlocked;
> +	}
>  
>  	/* due to slab_free_hook() */
>  	if (unlikely(sheaf->size == 0))
> @@ -5924,19 +6059,27 @@ static void rcu_free_sheaf(struct rcu_head *head)
>  	if (data_race(barn->nr_full) < MAX_FULL_SHEAVES) {
>  		stat(s, BARN_PUT);
>  		barn_put_full_sheaf(barn, sheaf);
> +		local_unlock(&s->cpu_sheaves->lock);
>  		return;
>  	}
>  
> -flush:
>  	stat(s, BARN_PUT_FAIL);
>  	sheaf_flush_unused(s, sheaf);
>  
>  empty:
>  	if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
>  		barn_put_empty_sheaf(barn, sheaf);
> +		local_unlock(&s->cpu_sheaves->lock);
>  		return;
>  	}
>  
> +	local_unlock(&s->cpu_sheaves->lock);
> +	free_empty_sheaf(s, sheaf);
> +	return;
> +
> +flush_unlocked:
> +	stat(s, BARN_PUT_FAIL);
> +	sheaf_flush_unused(s, sheaf);
>  	free_empty_sheaf(s, sheaf);
>  }
>  
> @@ -6006,12 +6149,18 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  			goto fail;
>  
>  		if (!local_trylock(&s->cpu_sheaves->lock)) {
> -			barn_put_empty_sheaf(barn, empty);
> +			free_empty_sheaf(s, empty);
>  			goto fail;
>  		}
>  
>  		pcs = this_cpu_ptr(s->cpu_sheaves);
>  
> +		if (unlikely(!pcs_capacity_match(s, pcs, empty))) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			free_empty_sheaf(s, empty);
> +			goto fail;
> +		}
> +
>  		if (unlikely(pcs->rcu_free))
>  			barn_put_empty_sheaf(barn, empty);
>  		else
> @@ -7650,6 +7799,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
>  		if (!pcs->main)
>  			return -ENOMEM;
>  
> +		pcs->capacity = s->sheaf_capacity;
>  	}
>  
>  	return 0;
> @@ -8050,7 +8200,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
>  	int node;
>  	struct kmem_cache_node *n;
>  
> -	flush_all_cpus_locked(s);
> +	flush_all_cpus_locked(s, /* disable_sheaves = */false);
>  
>  	/* we might have rcu sheaves in flight */
>  	if (cache_supports_sheaves(s))
> @@ -8334,7 +8484,7 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
>  
>  int __kmem_cache_shrink(struct kmem_cache *s)
>  {
> -	flush_all(s);
> +	flush_all(s, /* disable_sheaves = */false);
>  	return __kmem_cache_do_shrink(s);
>  }
>  
> @@ -8344,7 +8494,7 @@ static int slab_mem_going_offline_callback(void)
>  
>  	mutex_lock(&slab_mutex);
>  	list_for_each_entry(s, &slab_caches, list) {
> -		flush_all_cpus_locked(s);
> +		flush_all_cpus_locked(s, /* disable_sheaves = */false);
>  		__kmem_cache_do_shrink(s);
>  	}
>  	mutex_unlock(&slab_mutex);
> @@ -8479,7 +8629,11 @@ static int bootstrap_cache_sheaves(struct kmem_cache *s,
>  				   unsigned short capacity)
>  {
>  	struct kmem_cache_args empty_args = {};
> +	struct slub_flush_work *sfw;
>  	int node, cpu, err = 0;
> +	void **sheaves = NULL;
> +
> +	lockdep_assert_cpus_held();
>  
>  	if (!capacity)
>  		capacity = calculate_sheaf_capacity(s, &empty_args);
> @@ -8491,6 +8645,9 @@ static int bootstrap_cache_sheaves(struct kmem_cache *s,
>  	for_each_node_mask(node, slab_barn_nodes) {
>  		struct node_barn *barn;
>  
> +		if (s->per_node[node].barn)
> +			continue;
> +
>  		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
>  
>  		if (!barn) {
> @@ -8502,23 +8659,62 @@ static int bootstrap_cache_sheaves(struct kmem_cache *s,
>  		s->per_node[node].barn = barn;
>  	}
>  
> +	sheaves = kmalloc_array(nr_cpu_ids, sizeof(*sheaves),
> +				GFP_KERNEL | __GFP_ZERO);
> +	if (!sheaves) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* Do not queue the work if any of the allocations fails */
> +	for_each_possible_cpu(cpu) {
> +		sheaves[cpu] = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
> +
> +		if (!sheaves[cpu]) {
> +			err = -ENOMEM;
> +			goto out_free_sheaves;
> +		}
> +	}
> +
> +	mutex_lock(&flush_lock);
>  	for_each_possible_cpu(cpu) {
>  		struct slub_percpu_sheaves *pcs;
>  
>  		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
> +		sfw = &per_cpu(slub_flush, cpu);
>  
> -		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
> -
> -		if (!pcs->main) {
> -			err = -ENOMEM;
> -			break;
> +		if (!cpu_online(cpu) || slab_state == UP) {
> +			pcs->main = sheaves[cpu];
> +			pcs->capacity = capacity;
> +			sfw->skip = true;
> +		} else {
> +			INIT_WORK(&sfw->work, enable_cpu_sheaves);
> +			sfw->s = s;
> +			sfw->sheaves = sheaves;
> +			sfw->capacity = capacity;
> +			sfw->skip = false;
> +			queue_work_on(cpu, flushwq, &sfw->work);
>  		}
>  	}
>  
> -out:
> -	if (!err)
> -		s->sheaf_capacity = capacity;
> +	for_each_online_cpu(cpu) {
> +		sfw = &per_cpu(slub_flush, cpu);
> +		if (sfw->skip)
> +			continue;
> +		flush_work(&sfw->work);
> +	}
> +	mutex_unlock(&flush_lock);
>  
> +	kfree(sheaves);
> +	s->sheaf_capacity = capacity;
> +	return 0;
> +
> +out_free_sheaves:
> +	for_each_possible_cpu(cpu)
> +		if (sheaves[cpu])
> +			free_empty_sheaf(s, sheaves[cpu]);
> +	kfree(sheaves);
> +out:
>  	return err;
>  }
>  
> @@ -8533,6 +8729,7 @@ static void __init bootstrap_kmalloc_sheaves(void)
>  	struct kmem_cache *s;
>  	int idx;
>  
> +	cpus_read_lock();
>  	for_each_normal_kmalloc_cache(s, type, idx) {
>  		/*
>  		 * It's still early in boot so treat this as a failure to
> @@ -8542,6 +8739,7 @@ static void __init bootstrap_kmalloc_sheaves(void)
>  			panic("Out of memory when creating kmem_cache %s\n",
>  			      s->name);
>  	}
> +	cpus_read_unlock();
>  }
>  
>  void __init kmem_cache_init(void)
> @@ -8799,7 +8997,7 @@ long validate_slab_cache(struct kmem_cache *s)
>  	if (!obj_map)
>  		return -ENOMEM;
>  
> -	flush_all(s);
> +	flush_all(s, /* disable_sheaves = */false);
>  	for_each_kmem_cache_node(s, node, n)
>  		count += validate_slab_node(s, n, obj_map);
>  
> @@ -9111,7 +9309,39 @@ static ssize_t sheaf_capacity_show(struct kmem_cache *s, char *buf)
>  {
>  	return sysfs_emit(buf, "%hu\n", s->sheaf_capacity);
>  }
> -SLAB_ATTR_RO(sheaf_capacity);
> +static ssize_t sheaf_capacity_store(struct kmem_cache *s,
> +				    const char *buf, size_t length)
> +{
> +	unsigned short capacity;
> +	int err;
> +
> +	err = kstrtou16(buf, 10, &capacity);
> +	if (err)
> +		return err;
> +
> +	if (!cache_supports_sheaves(s))
> +		return -EOPNOTSUPP;
> +
> +	cpus_read_lock();
> +	mutex_lock(&slab_mutex);

This patchset looks good to me.
However, I’m not sure why we need slab_mutex here, as using only
flush_lock seems sufficient.

Some refactoring might be required, but it seems better to remove
the acquisition of slab_mutex here.

Am I missing something?

Thanks!

> +	flush_all_cpus_locked(s, /* disable_sheaves = */true);
> +	rcu_barrier();
> +	__kmem_cache_do_shrink(s);
> +	s->sheaf_capacity = 0;
> +	if (capacity) {
> +		err = bootstrap_cache_sheaves(s, capacity);
> +		if (err) {
> +			mutex_unlock(&slab_mutex);
> +			cpus_read_unlock();
> +			return err;
> +		}
> +	}
> +	mutex_unlock(&slab_mutex);
> +	cpus_read_unlock();
> +
> +	return length;
> +}
> +SLAB_ATTR(sheaf_capacity);
>  
>  static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
>  {
> 
> -- 
> 2.43.0
> 
> 

-- 
Sincerely,
Yeoreum Yun

