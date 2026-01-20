Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E798D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 12:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D436B03E1; Tue, 20 Jan 2026 07:41:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4246B03E2; Tue, 20 Jan 2026 07:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20DA6B03E3; Tue, 20 Jan 2026 07:41:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCC776B03E1
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:41:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E604C591D5
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:41:15 +0000 (UTC)
X-FDA: 84352302510.29.87906A8
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id B3ED040017
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:41:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="r8EHeJ3/";
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768912874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXI4I+Ibj/Ldc6/+dbWsvhs8PZ/UM4pm3iJ+tzviRtk=;
	b=jsufD7TrVxyXFqS8huxaePRvNUpjjPC9IIYq6NFKeGIetXdEZgV/XutsGk6ep+YypjByJn
	F+q0ivdrs29aD96TH8Zi87E1cubj6XEmL6LOVa0xm4zZ1TJ4yIMX6Tn6nfS2eu+BmphWPa
	ItMTS4LUOtZPFEGy2NlhKNV0nv2YEQE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="r8EHeJ3/";
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768912874; a=rsa-sha256;
	cv=none;
	b=nmd4oiHmdqxIJAcqI3H9NP7UTpizXHp+NNQlS04ZMvmsVFdkUJ4ibFt4oznLnSkel7Jwkp
	Vf9BnjY2hy1jGpOaYi8EXdVXqU5PtKw5ktt19ntxfo3jRJWPxlxNO5JWJhC0Xn2QjJIJZT
	q8lK68W2rbTmbnjq2JHkUqunVjAJGO8=
Date: Tue, 20 Jan 2026 20:40:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768912869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SXI4I+Ibj/Ldc6/+dbWsvhs8PZ/UM4pm3iJ+tzviRtk=;
	b=r8EHeJ3/tA+oZKlDsLT/vbHm/tqAsa/nnHbzJXlvks6LvbWkvdW/kaiX+WKJ+5o24xtORc
	JDADDEXNSi0W6BytE/SPVfjzUDE12xxTmJu7MzxoiqIbhpi8ff19P0/r80hYtNIrcoYGww
	f921SI3MJy98tZJQqVcIbPZVszxRxiU=
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
Subject: Re: [PATCH v3 15/21] slab: remove struct kmem_cache_cpu
Message-ID: <dxrm4m545d4pzxmxjve34qwxwlw4kbmuz3xwdhvjheyeosa6y7@2zezo6xejama>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-15-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-15-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kujc93xq9yp7i8xbf3bt5eej4jeeey8b
X-Rspam-User: 
X-Rspamd-Queue-Id: B3ED040017
X-Rspamd-Server: rspam08
X-HE-Tag: 1768912873-107539
X-HE-Meta: U2FsdGVkX19H8rxjLSqul4QMIzLQXesPUNq9zTTnKcf8K1VxiYiTpnXPMrISGlk9PYt1VN8lbFSp+YUH4LNpX086EXLa/NPT/fBKannXmLPflTyrowzEEAWvjEtiy7q2CWJ1bsFfF4ae9LZyC+yBHooUBLRq7J20CIYFSF+7ApnduUg/YGu26aKoV/GcRkjEoUiUR4hZNbl9v7s6caWJU1No80KpfkzI6udW77wLKYRqU9pqBOuvL4gj+gmtZgKKrowS/gGzl/zqiYUjZBb22pRAH1TpddgGAkTpyk/pinG7Ji1LLRu08nEDSdxkgGeAgN8qGWGszlpSSOZX5ln9TzCjvUQt255xDXL+F7V/YgF8eCIY8SJX3OnYXI6pgOii8dtddq0U0eQg7T7cf253LT7WmWVZXfVlTZvDwtmtlJ5fZihTcxh/8Ff+LovT/J/V7Fj1xGEjCnpn8mh1wCW/vxjSnIWkw7ejbFe59u2XaL5BgJ7ula0Xjf9d43gSNTyAjpvqnC1urcGmx4D1YUK8KFF53qJYbLDx66TCO2jYW7c9I+o2SQmDXFYDYYAeG5VnMgRwcjmZOKNkznGz5wRSwA1y1H04kYD9XceuLmubxQhwY/Lyc2cUoqqmJSE8FEz7bAFt5GN/b226dMXtUMAceTP30lOSH2iUPlejcum0BMu+5126D/oWxXb6NwHa0UQdu5Cjm/IA7SuxPCu0qd8AvFF6ZdGNz6BcHcg9dLUVwZpr8REzkheZ8XdKnCCILkaGAaZM2MfXh+AgrQlwAWMeVmeRvuBIMp4+Kmge18IQIfKuwfGqRxheCFRRxneJoRg9LeCJL57VDAtWpHz5NXDrAi021oQFN0VbYzJ34mx5ttdL87zjh2gf3zvsJPfdbG3pPX9xok/Cw38VeAjG0Cb3Y05Xqs6fWUo23GcwKRCzy5bPIyGyCMqw/w0KQIEY+21ME7OLZ/DoH3cfbzmi0qn
 W9KYzpwC
 xlzWmhO2EtgWr0JzFb9VJjXj+hAVo0nlUn8pwqjCNfTBqPzFEvj0qYsxs+OQ1VOofYq91yRMSsEyg1mZl58v3i5foENLHrrVEo7T5ZLVWkMcc6CD0qKqcgi/7h/F2748tlsbXc9y5O0yWGv/uxNU1nAYY5rYfWg9hUjCmOcj3x6SUciz4Wr500wtxM3xj/QaUOnWXxD8y6WPjWzpZIDndKB4zcOWxXGs4yhTnTYsQaDNup9gwJljOxnp+ppyQsNKH+5E8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:35PM +0100, Vlastimil Babka wrote:
> The cpu slab is not used anymore for allocation or freeing, the
> remaining code is for flushing, but it's effectively dead.  Remove the
> whole struct kmem_cache_cpu, the flushing code and other orphaned
> functions.
> 
> The remaining used field of kmem_cache_cpu is the stat array with
> CONFIG_SLUB_STATS. Put it instead in a new struct kmem_cache_stats.
> In struct kmem_cache, the field is cpu_stats and placed near the
> end of the struct.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h |   7 +-
>  mm/slub.c | 298 +++++---------------------------------------------------------
>  2 files changed, 24 insertions(+), 281 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index e9a0738133ed..87faeb6143f2 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -21,14 +21,12 @@
>  # define system_has_freelist_aba()	system_has_cmpxchg128()
>  # define try_cmpxchg_freelist		try_cmpxchg128
>  # endif
> -#define this_cpu_try_cmpxchg_freelist	this_cpu_try_cmpxchg128
>  typedef u128 freelist_full_t;
>  #else /* CONFIG_64BIT */
>  # ifdef system_has_cmpxchg64
>  # define system_has_freelist_aba()	system_has_cmpxchg64()
>  # define try_cmpxchg_freelist		try_cmpxchg64
>  # endif
> -#define this_cpu_try_cmpxchg_freelist	this_cpu_try_cmpxchg64
>  typedef u64 freelist_full_t;
>  #endif /* CONFIG_64BIT */
>  
> @@ -189,7 +187,6 @@ struct kmem_cache_order_objects {
>   * Slab cache management.
>   */
>  struct kmem_cache {
> -	struct kmem_cache_cpu __percpu *cpu_slab;
>  	struct slub_percpu_sheaves __percpu *cpu_sheaves;
>  	/* Used for retrieving partial slabs, etc. */
>  	slab_flags_t flags;
> @@ -238,6 +235,10 @@ struct kmem_cache {
>  	unsigned int usersize;		/* Usercopy region size */
>  #endif
>  
> +#ifdef CONFIG_SLUB_STATS
> +	struct kmem_cache_stats __percpu *cpu_stats;
> +#endif
> +
>  	struct kmem_cache_node *node[MAX_NUMNODES];
>  };
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index 8746d9d3f3a3..bb72cfa2d7ec 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -400,28 +400,11 @@ enum stat_item {
>  	NR_SLUB_STAT_ITEMS
>  };
>  
> -struct freelist_tid {
> -	union {
> -		struct {
> -			void *freelist;		/* Pointer to next available object */
> -			unsigned long tid;	/* Globally unique transaction id */
> -		};
> -		freelist_full_t freelist_tid;
> -	};
> -};
> -
> -/*
> - * When changing the layout, make sure freelist and tid are still compatible
> - * with this_cpu_cmpxchg_double() alignment requirements.
> - */
> -struct kmem_cache_cpu {
> -	struct freelist_tid;
> -	struct slab *slab;	/* The slab from which we are allocating */
> -	local_trylock_t lock;	/* Protects the fields above */
>  #ifdef CONFIG_SLUB_STATS
> +struct kmem_cache_stats {
>  	unsigned int stat[NR_SLUB_STAT_ITEMS];
> -#endif
>  };
> +#endif
>  
>  static inline void stat(const struct kmem_cache *s, enum stat_item si)
>  {
> @@ -430,7 +413,7 @@ static inline void stat(const struct kmem_cache *s, enum stat_item si)
>  	 * The rmw is racy on a preemptible kernel but this is acceptable, so
>  	 * avoid this_cpu_add()'s irq-disable overhead.
>  	 */
> -	raw_cpu_inc(s->cpu_slab->stat[si]);
> +	raw_cpu_inc(s->cpu_stats->stat[si]);
>  #endif
>  }
>  
> @@ -438,7 +421,7 @@ static inline
>  void stat_add(const struct kmem_cache *s, enum stat_item si, int v)
>  {
>  #ifdef CONFIG_SLUB_STATS
> -	raw_cpu_add(s->cpu_slab->stat[si], v);
> +	raw_cpu_add(s->cpu_stats->stat[si], v);
>  #endif
>  }
>  
> @@ -1160,20 +1143,6 @@ static void object_err(struct kmem_cache *s, struct slab *slab,
>  	WARN_ON(1);
>  }
>  
> -static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
> -			       void **freelist, void *nextfree)
> -{
> -	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
> -	    !check_valid_pointer(s, slab, nextfree) && freelist) {
> -		object_err(s, slab, *freelist, "Freechain corrupt");
> -		*freelist = NULL;
> -		slab_fix(s, "Isolate corrupted freechain");
> -		return true;
> -	}
> -
> -	return false;
> -}
> -
>  static void __slab_err(struct slab *slab)
>  {
>  	if (slab_in_kunit_test())
> @@ -1955,11 +1924,6 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node,
>  							int objects) {}
>  static inline void dec_slabs_node(struct kmem_cache *s, int node,
>  							int objects) {}
> -static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
> -			       void **freelist, void *nextfree)
> -{
> -	return false;
> -}
>  #endif /* CONFIG_SLUB_DEBUG */
>  
>  /*
> @@ -3655,191 +3619,6 @@ static void *get_partial(struct kmem_cache *s, int node,
>  	return get_any_partial(s, pc);
>  }
>  
> -#ifdef CONFIG_PREEMPTION
> -/*
> - * Calculate the next globally unique transaction for disambiguation
> - * during cmpxchg. The transactions start with the cpu number and are then
> - * incremented by CONFIG_NR_CPUS.
> - */
> -#define TID_STEP  roundup_pow_of_two(CONFIG_NR_CPUS)
> -#else
> -/*
> - * No preemption supported therefore also no need to check for
> - * different cpus.
> - */
> -#define TID_STEP 1
> -#endif /* CONFIG_PREEMPTION */
> -
> -static inline unsigned long next_tid(unsigned long tid)
> -{
> -	return tid + TID_STEP;
> -}
> -
> -#ifdef SLUB_DEBUG_CMPXCHG
> -static inline unsigned int tid_to_cpu(unsigned long tid)
> -{
> -	return tid % TID_STEP;
> -}
> -
> -static inline unsigned long tid_to_event(unsigned long tid)
> -{
> -	return tid / TID_STEP;
> -}
> -#endif
> -
> -static inline unsigned int init_tid(int cpu)
> -{
> -	return cpu;
> -}
> -
> -static void init_kmem_cache_cpus(struct kmem_cache *s)
> -{
> -	int cpu;
> -	struct kmem_cache_cpu *c;
> -
> -	for_each_possible_cpu(cpu) {
> -		c = per_cpu_ptr(s->cpu_slab, cpu);
> -		local_trylock_init(&c->lock);
> -		c->tid = init_tid(cpu);
> -	}
> -}
> -
> -/*
> - * Finishes removing the cpu slab. Merges cpu's freelist with slab's freelist,
> - * unfreezes the slabs and puts it on the proper list.
> - * Assumes the slab has been already safely taken away from kmem_cache_cpu
> - * by the caller.
> - */
> -static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
> -			    void *freelist)
> -{
> -	struct kmem_cache_node *n = get_node(s, slab_nid(slab));
> -	int free_delta = 0;
> -	void *nextfree, *freelist_iter, *freelist_tail;
> -	int tail = DEACTIVATE_TO_HEAD;
> -	unsigned long flags = 0;
> -	struct freelist_counters old, new;
> -
> -	if (READ_ONCE(slab->freelist)) {
> -		stat(s, DEACTIVATE_REMOTE_FREES);
> -		tail = DEACTIVATE_TO_TAIL;
> -	}
> -
> -	/*
> -	 * Stage one: Count the objects on cpu's freelist as free_delta and
> -	 * remember the last object in freelist_tail for later splicing.
> -	 */
> -	freelist_tail = NULL;
> -	freelist_iter = freelist;
> -	while (freelist_iter) {
> -		nextfree = get_freepointer(s, freelist_iter);
> -
> -		/*
> -		 * If 'nextfree' is invalid, it is possible that the object at
> -		 * 'freelist_iter' is already corrupted.  So isolate all objects
> -		 * starting at 'freelist_iter' by skipping them.
> -		 */
> -		if (freelist_corrupted(s, slab, &freelist_iter, nextfree))
> -			break;
> -
> -		freelist_tail = freelist_iter;
> -		free_delta++;
> -
> -		freelist_iter = nextfree;
> -	}
> -
> -	/*
> -	 * Stage two: Unfreeze the slab while splicing the per-cpu
> -	 * freelist to the head of slab's freelist.
> -	 */
> -	do {
> -		old.freelist = READ_ONCE(slab->freelist);
> -		old.counters = READ_ONCE(slab->counters);
> -		VM_BUG_ON(!old.frozen);
> -
> -		/* Determine target state of the slab */
> -		new.counters = old.counters;
> -		new.frozen = 0;
> -		if (freelist_tail) {
> -			new.inuse -= free_delta;
> -			set_freepointer(s, freelist_tail, old.freelist);
> -			new.freelist = freelist;
> -		} else {
> -			new.freelist = old.freelist;
> -		}
> -	} while (!slab_update_freelist(s, slab, &old, &new, "unfreezing slab"));
> -
> -	/*
> -	 * Stage three: Manipulate the slab list based on the updated state.
> -	 */
> -	if (!new.inuse && n->nr_partial >= s->min_partial) {
> -		stat(s, DEACTIVATE_EMPTY);
> -		discard_slab(s, slab);
> -		stat(s, FREE_SLAB);
> -	} else if (new.freelist) {
> -		spin_lock_irqsave(&n->list_lock, flags);
> -		add_partial(n, slab, tail);
> -		spin_unlock_irqrestore(&n->list_lock, flags);
> -		stat(s, tail);
> -	} else {
> -		stat(s, DEACTIVATE_FULL);
> -	}
> -}
> -
> -static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
> -{
> -	unsigned long flags;
> -	struct slab *slab;
> -	void *freelist;
> -
> -	local_lock_irqsave(&s->cpu_slab->lock, flags);
> -
> -	slab = c->slab;
> -	freelist = c->freelist;
> -
> -	c->slab = NULL;
> -	c->freelist = NULL;
> -	c->tid = next_tid(c->tid);
> -
> -	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
> -
> -	if (slab) {
> -		deactivate_slab(s, slab, freelist);
> -		stat(s, CPUSLAB_FLUSH);
> -	}
> -}
> -
> -static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
> -{
> -	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
> -	void *freelist = c->freelist;
> -	struct slab *slab = c->slab;
> -
> -	c->slab = NULL;
> -	c->freelist = NULL;
> -	c->tid = next_tid(c->tid);
> -
> -	if (slab) {
> -		deactivate_slab(s, slab, freelist);
> -		stat(s, CPUSLAB_FLUSH);
> -	}
> -}
> -
> -static inline void flush_this_cpu_slab(struct kmem_cache *s)
> -{
> -	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
> -
> -	if (c->slab)
> -		flush_slab(s, c);
> -}
> -
> -static bool has_cpu_slab(int cpu, struct kmem_cache *s)
> -{
> -	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
> -
> -	return c->slab;
> -}
> -
>  static bool has_pcs_used(int cpu, struct kmem_cache *s)
>  {
>  	struct slub_percpu_sheaves *pcs;
> @@ -3853,7 +3632,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
>  }
>  
>  /*
> - * Flush cpu slab.
> + * Flush percpu sheaves
>   *
>   * Called from CPU work handler with migration disabled.
>   */
> @@ -3868,8 +3647,6 @@ static void flush_cpu_slab(struct work_struct *w)

Nit: Would it make sense to rename flush_cpu_slab to flush_cpu_sheaf for better
clarity?

Other than that, looks good to me. Thanks.

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

>  
>  	if (cache_has_sheaves(s))
>  		pcs_flush_all(s);
> -
> -	flush_this_cpu_slab(s);
>  }
>  
>  static void flush_all_cpus_locked(struct kmem_cache *s)
> @@ -3882,7 +3659,7 @@ static void flush_all_cpus_locked(struct kmem_cache *s)
>  
>  	for_each_online_cpu(cpu) {
>  		sfw = &per_cpu(slub_flush, cpu);
> -		if (!has_cpu_slab(cpu, s) && !has_pcs_used(cpu, s)) {
> +		if (!has_pcs_used(cpu, s)) {
>  			sfw->skip = true;
>  			continue;
>  		}
> @@ -3992,7 +3769,6 @@ static int slub_cpu_dead(unsigned int cpu)
>  
>  	mutex_lock(&slab_mutex);
>  	list_for_each_entry(s, &slab_caches, list) {
> -		__flush_cpu_slab(s, cpu);
>  		if (cache_has_sheaves(s))
>  			__pcs_flush_all_cpu(s, cpu);
>  	}
> @@ -7121,26 +6897,21 @@ init_kmem_cache_node(struct kmem_cache_node *n, struct node_barn *barn)
>  		barn_init(barn);
>  }
>  
> -static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
> +#ifdef CONFIG_SLUB_STATS
> +static inline int alloc_kmem_cache_stats(struct kmem_cache *s)
>  {
>  	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
>  			NR_KMALLOC_TYPES * KMALLOC_SHIFT_HIGH *
> -			sizeof(struct kmem_cache_cpu));
> +			sizeof(struct kmem_cache_stats));
>  
> -	/*
> -	 * Must align to double word boundary for the double cmpxchg
> -	 * instructions to work; see __pcpu_double_call_return_bool().
> -	 */
> -	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu),
> -				     2 * sizeof(void *));
> +	s->cpu_stats = alloc_percpu(struct kmem_cache_stats);
>  
> -	if (!s->cpu_slab)
> +	if (!s->cpu_stats)
>  		return 0;
>  
> -	init_kmem_cache_cpus(s);
> -
>  	return 1;
>  }
> +#endif
>  
>  static int init_percpu_sheaves(struct kmem_cache *s)
>  {
> @@ -7252,7 +7023,9 @@ void __kmem_cache_release(struct kmem_cache *s)
>  	cache_random_seq_destroy(s);
>  	if (s->cpu_sheaves)
>  		pcs_destroy(s);
> -	free_percpu(s->cpu_slab);
> +#ifdef CONFIG_SLUB_STATS
> +	free_percpu(s->cpu_stats);
> +#endif
>  	free_kmem_cache_nodes(s);
>  }
>  
> @@ -7944,12 +7717,6 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
>  
>  	memcpy(s, static_cache, kmem_cache->object_size);
>  
> -	/*
> -	 * This runs very early, and only the boot processor is supposed to be
> -	 * up.  Even if it weren't true, IRQs are not up so we couldn't fire
> -	 * IPIs around.
> -	 */
> -	__flush_cpu_slab(s, smp_processor_id());
>  	for_each_kmem_cache_node(s, node, n) {
>  		struct slab *p;
>  
> @@ -8164,8 +7931,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>  	if (!init_kmem_cache_nodes(s))
>  		goto out;
>  
> -	if (!alloc_kmem_cache_cpus(s))
> +#ifdef CONFIG_SLUB_STATS
> +	if (!alloc_kmem_cache_stats(s))
>  		goto out;
> +#endif
>  
>  	err = init_percpu_sheaves(s);
>  	if (err)
> @@ -8484,33 +8253,6 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
>  	if (!nodes)
>  		return -ENOMEM;
>  
> -	if (flags & SO_CPU) {
> -		int cpu;
> -
> -		for_each_possible_cpu(cpu) {
> -			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab,
> -							       cpu);
> -			int node;
> -			struct slab *slab;
> -
> -			slab = READ_ONCE(c->slab);
> -			if (!slab)
> -				continue;
> -
> -			node = slab_nid(slab);
> -			if (flags & SO_TOTAL)
> -				x = slab->objects;
> -			else if (flags & SO_OBJECTS)
> -				x = slab->inuse;
> -			else
> -				x = 1;
> -
> -			total += x;
> -			nodes[node] += x;
> -
> -		}
> -	}
> -
>  	/*
>  	 * It is impossible to take "mem_hotplug_lock" here with "kernfs_mutex"
>  	 * already held which will conflict with an existing lock order:
> @@ -8881,7 +8623,7 @@ static int show_stat(struct kmem_cache *s, char *buf, enum stat_item si)
>  		return -ENOMEM;
>  
>  	for_each_online_cpu(cpu) {
> -		unsigned x = per_cpu_ptr(s->cpu_slab, cpu)->stat[si];
> +		unsigned int x = per_cpu_ptr(s->cpu_stats, cpu)->stat[si];
>  
>  		data[cpu] = x;
>  		sum += x;
> @@ -8907,7 +8649,7 @@ static void clear_stat(struct kmem_cache *s, enum stat_item si)
>  	int cpu;
>  
>  	for_each_online_cpu(cpu)
> -		per_cpu_ptr(s->cpu_slab, cpu)->stat[si] = 0;
> +		per_cpu_ptr(s->cpu_stats, cpu)->stat[si] = 0;
>  }
>  
>  #define STAT_ATTR(si, text) 					\
> 
> -- 
> 2.52.0
> 

