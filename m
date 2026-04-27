Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B97FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B5C6B0092; Mon, 27 Apr 2026 12:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052BC6B0093; Mon, 27 Apr 2026 12:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EABE06B0096; Mon, 27 Apr 2026 12:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAEFF6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0198C120E30
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:47:47 +0000 (UTC)
X-FDA: 84704766216.08.5ABA601
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 218D91C0013
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:47:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZhKAxlUM;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCMpB9OfZRwjYgRWTeLad5rLP/f0szDjd8Y8Qmp238s=;
	b=udXTMAIPA+WOIEhza6Q5HcQW+f12oYCXuyryQ142O53kZavjao7sG1ZDiBmapPhiO6Eo5i
	5946vPKh4YThQmuCQ4iqBj8MlS4bd08ZrEkSGYCbiTprBL/82NFoyavSy9jCK/2qWs1WEi
	eRbddZbILIYI8Kcdv5l0YiaWnAatY1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304866; a=rsa-sha256;
	cv=none;
	b=3xNqsUKA/a19bxA2xKMxKtS/EyjnXjvNsF7sRi42WKHGgEd4P+v/fDEZbh1jPUxjdRnk7X
	H/9AqnIMHGz3qVjvpWvkb0NsV7epc7CqcSGs4gQ5aotBr2RAFmwta0CEsIhXSZNeeHgGOj
	/Ozk9/IOktOVyTLMczXBtcUGgk2Ao0w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZhKAxlUM;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15BE443D08;
	Mon, 27 Apr 2026 15:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587BCC19425;
	Mon, 27 Apr 2026 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777304864;
	bh=6QyhfmdKWsqLeaywBIrX3y0EggSxtNipVXYb8EQYAwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZhKAxlUMRWyfsqXwj4T6Fkz9QSKKjgegXNz4WzuQTf9KMWkJPTy8ph3ZbZ8Bd7G46
	 xJ5aCLOxJGJOYWDfSGelgl4ysDhLuhxqeZFtBORtiihq6sI51VPoisfvYbhcKZ8p36
	 3tR/ImU/GqjtVQ/GzphvIuYx33SGJMOdNZNJN30om4ygH4JE0RjOS/TqVgGzUw+FOI
	 SDvDxURqQboX4OI5EBEumkv1SXxo4Uw9jIxuBBGFIzGR0qQTL6auU8ignQprGWLOuL
	 C9JTFrULcaNM517z8Wo3pF43BH71wWLgsmkkJGZ+zSIr5SoxrhC5h6q+QeB28oBwiY
	 lSQEF6WSZk6hA==
Message-ID: <8f5952c2-d710-46dc-8ba0-012db08c9578@kernel.org>
Date: Mon, 27 Apr 2026 17:47:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] mm/slab: wrap rcu sheaf handling with ifdef
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-7-harry@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260416091022.36823-7-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 218D91C0013
X-Rspam-User: 
X-Stat-Signature: 9q8rczqtpzmmx3zriobyw8t8dfhcjuyp
X-HE-Tag: 1777304865-844922
X-HE-Meta: U2FsdGVkX19mVZfwmpx8X4LViKn93Sei646SFTmOHkqarTvyaJW6446Ptq3muG6FHM0LASvOQVDAWCgD05xFl80d7r0vYQciyRq+EUbLQ3fvO/e18ZSO9ohju3BHfXvqyFfIgpCdqBFS9V2/MzmDgt4y616I/hWa0oZA/IA7JyIHJJPD9BtiVGl05UtvrKMps2Px9qwxxpHVCTpOxHGs3wkbdS1UmN0aqh07WuUL8ZNOrFCovLoJ5aq5iGYTJVRkIzADQ8AFA0bw0ubWDqXqu6f4ZfLIP4VnNT/St8MLL9FQdC2O5T5BlTp2NWEU3q5a2CN2P4RCC1VZNX0SNPw7kLMibaLX2bDwTblAYoFzsGf92qPQb0w+S3YYB0MOWqcnGFIl+OhuFmAEn52LAB3r4kCLc0OFqCu15kDGO10vYnQpjeo2gbXWHyAY4oBHUL0kdmtAJnOPSy7SIsO+MROmvnVpGmHib8U/XmgLzzx+6HnKUDqmZu315nCv3k0NCn3PWxtqnCsRqpedHPeFeiWuKfyCn8DfTuUg/QACwRWABfr9vTNG0knezBWxZ68YArmlWp+WhGBZIW3eG0zzj9V+k38xQWKR4VdxSkJApTaC0Xg5aZTi3eXuECFhIAtnjzm96AAeiRXjptqiHDt7hkSCiIwni1rCIdqjjtGROttf1+qAEqRk8w11cIoPi+i+YS61kyY6xI3bRa9Vw+Tnj/pfyIw+XX7ZDEhX+S4pHMja2TUvKJWqAZfi3EWC/HXBb05xNYZbxCTa8achFOD1rMDYB18xZNiQ5sMXYRg8uJSAFfcnLtcy7gYlCKw8gEu+Y/2Sgxl3G1RpScVFwCkUHEUQLX1KV4kgs1/l95ubQugv1XItH9vpY2KPeJc7iemIKJU0KxJAxM9VyKLL8IbOA8/yRZIxD3QSLl8dSctOl2jsCBNYylhT30d5iVe9tBF03ugbrpbx4hXCYngiLn2ZvaD
 1ckUN/x9
 Migge1qbJsWXBq6O3PU8MR0TN5yH6tzqjCjkHdi9LkuqtYgiQxxnmPP8hwkwC4gMJAojGFNQJKIIf9SWKogdVas+VB/4FGZmM/pgyx/pWQ/iLXYPaXjfL5qXOBEu1sQhMnQKpq/0glbzMBtr3dNffBeZZlcpcZ8GGro/C52biy+LmmfRI9aE2zXiNJfppyI7ncPj3oxZUcLz+jqyrTLZhG+hT0k8GUKeCqgemj051VVfsDqeR/HGzFu36HI4eJmAuyxTBVoFzCs1xCuNWMFGlj7qjJdEcLxR/QOab
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> Freeing objects via rcu sheaves is only done with
> CONFIG_KVFREE_RCU_BATCHED. Wrap the related functions and struct
> fields with ifdef to make this dependency explicit.

With SLUB_TINY we have recently took the approach of limiting it to only
necessary parts, and not care about unused code etc where it doesn't cause
issues. I think it's good to minimize the ifdef complexity, so maybe it's
possible to limit it only to allow compiling with no warnings (including
IIRC W=1 clang that IIRC is stricter about unused functions)?

> Also remove a TODO about implementing __kvfree_rcu_barrier_on_cache()
> for a specific slab cache, as there doesn't seem to be a simple and
> effective way to do so.

Ack.

> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slab.h        |  3 +++
>  mm/slab_common.c |  4 ----
>  mm/slub.c        | 27 +++++++++++++++++++++++++--
>  3 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index d7fd7626e9fe..bdad5f389490 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -409,9 +409,12 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
>  }
>  
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
>  void flush_all_rcu_sheaves(void);
>  void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
> +#endif
> +
>  void defer_kvfree_rcu_barrier(void);
>  
>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 46a2bee1662b..347e52f1538c 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2289,10 +2289,6 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  		rcu_barrier();
>  	}
>  
> -	/*
> -	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
> -	 * on a specific slab cache.
> -	 */
>  	__kvfree_rcu_barrier();
>  }
>  EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
> diff --git a/mm/slub.c b/mm/slub.c
> index d0db8d070570..91b8827d65da 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -421,7 +421,9 @@ struct slub_percpu_sheaves {
>  	local_trylock_t lock;
>  	struct slab_sheaf *main; /* never NULL when unlocked */
>  	struct slab_sheaf *spare; /* empty or full, may be NULL */
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
> +#endif
>  };
>  
>  /*
> @@ -2923,6 +2925,7 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
>  	sheaf->size = 0;
>  }
>  
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
>  				     struct slab_sheaf *sheaf)
>  {
> @@ -2965,6 +2968,7 @@ static void rcu_free_sheaf_nobarn(struct rcu_head *head)
>  
>  	free_empty_sheaf(s, sheaf);
>  }
> +#endif
>  
>  /*
>   * Caller needs to make sure migration is disabled in order to fully flush
> @@ -2978,7 +2982,10 @@ static void rcu_free_sheaf_nobarn(struct rcu_head *head)
>  static void pcs_flush_all(struct kmem_cache *s)
>  {
>  	struct slub_percpu_sheaves *pcs;
> -	struct slab_sheaf *spare, *rcu_free;
> +	struct slab_sheaf *spare;
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
> +	struct slab_sheaf *rcu_free;
> +#endif
>  
>  	local_lock(&s->cpu_sheaves->lock);
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
> @@ -2986,8 +2993,10 @@ static void pcs_flush_all(struct kmem_cache *s)
>  	spare = pcs->spare;
>  	pcs->spare = NULL;
>  
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  	rcu_free = pcs->rcu_free;
>  	pcs->rcu_free = NULL;
> +#endif
>  
>  	local_unlock(&s->cpu_sheaves->lock);
>  
> @@ -2996,8 +3005,10 @@ static void pcs_flush_all(struct kmem_cache *s)
>  		free_empty_sheaf(s, spare);
>  	}
>  
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  	if (rcu_free)
>  		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
> +#endif
>  
>  	sheaf_flush_main(s);
>  }
> @@ -3016,10 +3027,12 @@ static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
>  		pcs->spare = NULL;
>  	}
>  
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  	if (pcs->rcu_free) {
>  		call_rcu(&pcs->rcu_free->rcu_head, rcu_free_sheaf_nobarn);
>  		pcs->rcu_free = NULL;
>  	}
> +#endif
>  }
>  
>  static void pcs_destroy(struct kmem_cache *s)
> @@ -3056,7 +3069,9 @@ static void pcs_destroy(struct kmem_cache *s)
>  		 */
>  
>  		WARN_ON(pcs->spare);
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  		WARN_ON(pcs->rcu_free);
> +#endif
>  
>  		if (!WARN_ON(pcs->main->size)) {
>  			free_empty_sheaf(s, pcs->main);
> @@ -3937,7 +3952,11 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
>  
>  	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
>  
> -	return (pcs->spare || pcs->rcu_free || pcs->main->size);
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
> +	if (pcs->rcu_free)
> +		return true;
> +#endif
> +	return (pcs->spare || pcs->main->size);
>  }
>  
>  /*
> @@ -3995,6 +4014,7 @@ static void flush_all(struct kmem_cache *s)
>  	cpus_read_unlock();
>  }
>  
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  static void flush_rcu_sheaf(struct work_struct *w)
>  {
>  	struct slub_percpu_sheaves *pcs;
> @@ -4071,6 +4091,7 @@ void flush_all_rcu_sheaves(void)
>  
>  	rcu_barrier();
>  }
> +#endif /* CONFIG_KVFREE_RCU_BATCHED */
>  
>  static int slub_cpu_setup(unsigned int cpu)
>  {
> @@ -5825,6 +5846,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
>  	return true;
>  }
>  
> +#ifdef CONFIG_KVFREE_RCU_BATCHED
>  static void rcu_free_sheaf(struct rcu_head *head)
>  {
>  	struct slab_sheaf *sheaf;
> @@ -6005,6 +6027,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
>  	lock_map_release(&kfree_rcu_sheaf_map);
>  	return false;
>  }
> +#endif /* CONFIG_KVFREE_RCU_BATCHED */
>  
>  static __always_inline bool can_free_to_pcs(struct slab *slab)
>  {


