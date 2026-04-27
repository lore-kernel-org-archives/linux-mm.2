Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3817DFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709FB6B0088; Mon, 27 Apr 2026 09:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA8C6B008A; Mon, 27 Apr 2026 09:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0E06B008C; Mon, 27 Apr 2026 09:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCAD6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:32:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFAFE401ED
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:32:52 +0000 (UTC)
X-FDA: 84704426184.11.FD0BFF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2B9A8140011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:32:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nc6v+uxo;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777296771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p66gU3SgKX4mD9KPEHeVBQilZ3e6vl4LTKoi4O1R+4M=;
	b=bK4rj8YDDWKmiG/xRufARJ9i/I4WFBbmClMscm4bD7hBIZj/5IXt5MhPf2OlyyFuaA7tlm
	JkwJH+bKoZOqiwZc8eTC4CvhG7rtisT+dMGcHqTtDlu/rxV3R9NyvcpW9QmS67RPQm100z
	UAtoUHmhMO8GYqo5VPht0ToKTNNv6BE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777296771; a=rsa-sha256;
	cv=none;
	b=s4yGSGPLSb8nRfcY3a4smyUguwtY/2Z4i/7hpadpgJBAR2bYQ3kiCAC6S4O2LDBFuhViRo
	cSkrX4Rzya2qGQ810mSTfFnwledXPGwzql2FjVSoNlIR8FLx6PTymvQur21WN9IyEmHlRi
	Q7HzVrgeEDMfeU9buD3tJ34kmqnBdtc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nc6v+uxo;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A4E840620;
	Mon, 27 Apr 2026 13:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C974C19425;
	Mon, 27 Apr 2026 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296770;
	bh=j406OpvUZz+7ciHe1QoVQlcLC12P+QXTt0xUkv0HFTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nc6v+uxoJLbp7tjuc/ew2nH32fhXau6gnhIfzXNDVqZMhAxiRHj5oJhBI6ZMugdmp
	 /UYdNJRDR7DbZWbo0cxOC3lN2d3QUQSRMnZ1YlLl72F1SeglR2sdkldzLELbyReUe7
	 2MARoA01UaaRt7Sh9ZfikXvmRWCuHkt+9g+Fwc9q+Mk/QBstqaN3zKBQ/FV6trKpcS
	 zULqAUdLQFwX2PxnXgSXZdcz0YY10T4L3SqU+fX3d1KK+JFHOm6D3GTYYEOSSMNKDz
	 MqIboSkHwbTq0igsGJ/d/2r9utRZKQLU02TJBtEegidPCRP0G3d7AH1vt32JWZvo9o
	 cQN+KGbcqOwag==
Message-ID: <56381493-214b-406d-9121-f80be7658445@kernel.org>
Date: Mon, 27 Apr 2026 15:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] mm/slab: make kfree_rcu_nolock() work with sheaves
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
 <20260416091022.36823-6-harry@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260416091022.36823-6-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2B9A8140011
X-Rspam-User: 
X-Stat-Signature: 9h994sxcf96cwnzpj19tzghems9szinf
X-HE-Tag: 1777296771-63546
X-HE-Meta: U2FsdGVkX19Su727NX0E8NCEWeOO7sN6X+bj8XMoRIvGDQgpoNonGI4B2UoGNV3DjjMvfgDo5lr5j/K8OUzhqh8d4G3VU9o3+4EfDotalNVHm5Mse0YP52Q53D0OrGyeTYWReSmXXPPLTV7KOkGw7VgJZIO+ZdlqmD2sI2g/CYw3wP/m9cfaC6dg/a9TXYMiB8bDgzaGIWvtJmix3GqgS0j6Z0ebUXnZcfCOLO6/rHyI3GsmgmPGnAlCUZpzUDLvKT0eVaruW3H6tz5rMArKyw95hhauw5NYk8jhcnWFNjRPGVnsquW+3LFxGcLrCs6AH7vXItwvOhe+F3pr6CTHhWR9NEZQxMrF56OJy1zQeT7Phxj9B37Pkcm2cqJ5agzk8TX8L+ownID8rAOvH6S8nCj0r7HCb+gMxfDiIqM45lJdosB5dxs7ioJUqdiWJ/3dT2jbIkJMPq5+JJsgUOTVc8YefPhmJAzhXwLKrm7H+TVqwbdyXBJgC0KD3JOpLvBrxHiRdKJeIS6SCzP9++dS8jZdjwH+ZgUcd0sUdQjsfqpjBhEvkqJjgVzDSNBWeRsew5m226Fo6YTOxBJsJGBsurf+Uw8yHM05be/WGhlEBuKp6W6ZCpPKdpg2nhPv0QHU2dKUBaFpN+rhjIY6Nxn+vRyOeb0H2tp6PJoOpyP1fp4kduXZ1RmTzTCv2yEK0A0KiveFcaBW40fEoi5fogM/U6XAu+lewi+Xz2172YXCYsTVj2L9WoRgdxYQZuegwV6RyscdHRfx7iWSZ4TdADr9mUQyCxYOJ/0XCGifgRKPjTXNjdywcVdGvKIKGm1LFzBc4z9RQyclxMUND253awAZFuU6QvkJ+Aca6G92ZN7MvoCCBLBdRu8PRHLD1YG18lJetntoqphnudmJISvc89eUmgxurX+D9oxqL4i+knIINm0j+CTEWFXVRk9sERzK3C/UYEoWv4mSPxoQn8WvIxh
 BYAi3afh
 QUBkhZZ2zHYGlxfe048PSEulWToL4UiFSj7ONeKj319AG3aKiFe6OCsV++8BD94QbqVpYzsivPh/zc2MUdTJwC62BHRxLgBBH+QGJdgjE2gPi7ioOlLImmVKyLQKbyAzSsOq2lF6LGsn4lOIerHOq2kLPx7a/zfcVPycK63yeE3vI+3CbzJI2fWWTV5LIcDPlIJyU5zBpe/KQ0ub61SZvDaPj19D67plwl31N5Ha8AYmOM2QoQnuxmkqW+hDQz4NfdVluYTQQnHl3GRwh0fcFMbv9Bf9lqnrkKK9ucvO6i155lrqqZHB9bZQfQI5WxRuU7kY62pVu1Km7neY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Similar to
> __pcs_replace_full_main(), try to get an empty sheaf from pcs->spare or
> the barn, but don't add !allow_spin support for alloc_empty_sheaf() and
> fail early instead.
> 
> Since call_rcu() does not support NMI contexts, kfree_rcu_sheaf() fails
> when the rcu sheaf becomes full.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slab.h        |  2 +-
>  mm/slab_common.c |  7 +++----
>  mm/slub.c        | 14 ++++++++++++--
>  3 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index ae2e990e8dc2..d7fd7626e9fe 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -409,7 +409,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
>  }
>  
> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
>  void flush_all_rcu_sheaves(void);
>  void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
>  void defer_kvfree_rcu_barrier(void);
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e840956233dd..46a2bee1662b 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1716,7 +1716,7 @@ static void kfree_rcu_work(struct work_struct *work)
>  		kvfree_rcu_list(head);
>  }
>  
> -static bool kfree_rcu_sheaf(void *obj)
> +static bool kfree_rcu_sheaf(void *obj, bool allow_spin)
>  {
>  	struct kmem_cache *s;
>  	struct slab *slab;
> @@ -1730,7 +1730,7 @@ static bool kfree_rcu_sheaf(void *obj)
>  
>  	s = slab->slab_cache;
>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
> -		return __kfree_rcu_sheaf(s, obj);
> +		return __kfree_rcu_sheaf(s, obj, allow_spin);
>  
>  	return false;
>  }
> @@ -2111,8 +2111,7 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin)
>  				IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)))
>  		goto defer_free;
>  
> -	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
> -			(allow_spin && kfree_rcu_sheaf(ptr)))
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr, allow_spin))
>  		return;

I wonder if this patch is enough to drop (or reduce a lot) the PREEMPT_RT
incompatibility? It IIRC came from Ulad's review point [1] that since RT
spinlock is in fact a mutex, it's not unsafe to take it with e.g. disabled
preemption, and it's also why kfree_rcu_cpu uses a raw_spin_lock_t, etc.

But with kfree_rcu_sheaf now having allow_spin parameter and only doing a
trylock at most with that false, it should now be safe to allow it for
CONFIG_PREEMPT_RT, only pass allow_spin = false unconditionally there?

[1] https://lore.kernel.org/all/aL_uhPtztx7Ef0T2@pc636/

>  
>  	// Queue the object but don't yet schedule the batch.
> diff --git a/mm/slub.c b/mm/slub.c
> index 6f658ec00751..d0db8d070570 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5895,7 +5895,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
>   */
>  static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
>  
> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  	struct slab_sheaf *rcu_sheaf;
> @@ -5933,7 +5933,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  			goto fail;
>  		}
>  
> -		empty = barn_get_empty_sheaf(barn, true);
> +		empty = barn_get_empty_sheaf(barn, allow_spin);
>  
>  		if (empty) {
>  			pcs->rcu_free = empty;
> @@ -5942,6 +5942,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  
>  		local_unlock(&s->cpu_sheaves->lock);
>  
> +		/* It's easier to fall back than trying harder with !allow_spin */
> +		if (!allow_spin)
> +			goto fail;
> +
>  		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
>  
>  		if (!empty)
> @@ -5973,6 +5977,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>  		rcu_sheaf = NULL;
>  	} else {
> +		if (unlikely(!allow_spin)) {
> +			/* call_rcu() cannot be called in an unknown context */
> +			rcu_sheaf->size--;
> +			local_unlock(&s->cpu_sheaves->lock);
> +			goto fail;
> +		}
>  		pcs->rcu_free = NULL;
>  		rcu_sheaf->node = numa_node_id();
>  	}


