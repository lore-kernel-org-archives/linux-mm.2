Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E823BCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5776B0088; Wed, 24 Jun 2026 10:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D656B008A; Wed, 24 Jun 2026 10:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CC16B00B0; Wed, 24 Jun 2026 10:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94E9E6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:28:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D392A0343
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:28:19 +0000 (UTC)
X-FDA: 84915036318.18.503D4CE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0229D1C000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:28:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KQkbv6XT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="F/Hd+Tmo";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KQkbv6XT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="F/Hd+Tmo";
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782311297;
	b=VcycWCvZ6ks4WaTzo4+udo1z6TOOiCACTGfnePPDrGbjF4R46MxYAfNvi6JzEAR6+Ysj6y
	fkDMr9ZHVRNM50Yjmon/3oa+wLOHZoXLr2Y7vqYyti9sNsgdckOmQAxf6+sLCS8gZXlZ8S
	CKZS0Uo6QRtGHNi0c4w7gOdK7XRy1jk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExC3wTG/pYX1uSPWpIMmjed8BsggjZ6ZCCx5gzuyEC8=;
	b=ppfTCGwEGzYwsCFG9hSjtxE15ab5F1fq9b6kXEIm8qbTJSSFDbm+lC20NAqMvV/Ekdm2Lz
	nwsj8hs80fK2VFrTRM70a2wuX0NGlS3a9SmmGOEw1UfV4Fr9QXeHhQp610oGo8Buim5gri
	fNLU8WH1YP61CM8+9PQxK7GVbTqOPe0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KQkbv6XT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="F/Hd+Tmo";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KQkbv6XT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="F/Hd+Tmo";
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E88F75F42;
	Wed, 24 Jun 2026 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782311295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ExC3wTG/pYX1uSPWpIMmjed8BsggjZ6ZCCx5gzuyEC8=;
	b=KQkbv6XTcaklRO9GsVwqPpY/SRJDC//NIRWVvfltHJFQK7EgaqNJTbtcD3ml+d4H9PZSb5
	YZcVPvTGZWudl8gKMI1NJveRuNXNAdrnyLHcOiNe5MF2psuFfQKi+h5AhJL3+pK/5G0ReY
	5lBKeKyvApf9AhuL0DbSyKBR/he9jZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782311295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ExC3wTG/pYX1uSPWpIMmjed8BsggjZ6ZCCx5gzuyEC8=;
	b=F/Hd+Tmo3itq/3SsPZ4O5AseJn1xNPyzRktS4MmVBIc9aUGYgvda/IDbcowcqT03+Rlal/
	DTJcdMpCy88+PMCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782311295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ExC3wTG/pYX1uSPWpIMmjed8BsggjZ6ZCCx5gzuyEC8=;
	b=KQkbv6XTcaklRO9GsVwqPpY/SRJDC//NIRWVvfltHJFQK7EgaqNJTbtcD3ml+d4H9PZSb5
	YZcVPvTGZWudl8gKMI1NJveRuNXNAdrnyLHcOiNe5MF2psuFfQKi+h5AhJL3+pK/5G0ReY
	5lBKeKyvApf9AhuL0DbSyKBR/he9jZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782311295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ExC3wTG/pYX1uSPWpIMmjed8BsggjZ6ZCCx5gzuyEC8=;
	b=F/Hd+Tmo3itq/3SsPZ4O5AseJn1xNPyzRktS4MmVBIc9aUGYgvda/IDbcowcqT03+Rlal/
	DTJcdMpCy88+PMCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4F95779A8;
	Wed, 24 Jun 2026 14:28:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cbznJH3pO2qRQwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 24 Jun 2026 14:28:13 +0000
Date: Wed, 24 Jun 2026 15:28:11 +0100
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
Subject: Re: [PATCH for-next v3 3/9] mm/slab: handle the !allow_spin case in
 kfree_rcu_sheaf()
Message-ID: <ajvn5-2yJxykPlbP@pedro-suse>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-3-70a54f3775bb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-kfree_rcu_nolock-v3-3-70a54f3775bb@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0229D1C000D
X-Stat-Signature: 18wocbd3c43gnmsgy3e8kw7nd5et16j9
X-HE-Tag: 1782311296-989028
X-HE-Meta: U2FsdGVkX19L511tyWLsVQi8MoaEPmXSOUQnqB/1n8teWToaJIQ0G2+1UDPeTDRFiR/gl4pmx8wcQakXZIe95h9lTTkr0MUc2o9qrawme1h1SYKR1Hpu7xWYcGIChr6ePlQv9VnSPgLfaR/oKD1XZ3wLuLmBZkt4K6/HosGliGyBkHEIU6twfs7QH1r2tGiruxODgZOu305QH4dnkoz8NedesTwxNAp5dlWwpWkZpP2WsUlxW2GMnA1HmwB6tYFVGXAzdFRQuTZk2P+5Yrlvfx8AMs0BpD4K9i2bb0Wsxr5jvrGi6Y0NVjimG2mdogQ2Ei2RlYcsDyHpON7lMN0TiEpr3KXTnx8/Ct6czFL+/r8s48SOTezOycu2RsJ2zog3pnM3ViWaTeXhRjts7ElJ0ci1b5C+SBTChuQAPw/znEtJVE0V7sg3wMl447CtPSu/zdNMFcrrqtHy0RChhGpqrGuwQxJ8TUu5kStPKWOOzIGk68QpC0v2S5g8/yqsm5iAnEjTw83syTnbSc4hDzkYb0opL4QmjvEdH+X0Ra84FCewIKd7Sq8zZWR58ZnAi9VLCHZEe4qsyB7zeTemoglbtVgQRqZ22+a0504PD7nI1xrR3feY12lg4nOpITX2BS3ac266e9CYz8Uyuz59OP7plHtvlkVMWg+b0NVG4h54f5vmWnMl6cV+rZj7EOeRakOyMN0Cyjf1o3po+3fqFFqSz3enmr6Mh01DWWtieI3/jIXJwMqNFrb4ylJrDGxHnrtl0/ooieT2g1Utq8UJZAdCfKbYj7AxbstrxTjE1kur98FKod8rAoBbrw7SUszumBNO0UrtD/spuvMLigsV40wAc8Wayl9QCLXTBPm/M/KlI420GbWKjttw73XezZL+L96NIJEG25t6DwrM7xu2J7tSK62YMShzoA1dxkzs8PF2pDd8CcMpyfn6aTk3xaSAZbSSkHZBB7Fu6TqI9HTruv+
 wlj03TXL
 BAMSRE20XD/9xvHmss87yST0ZT1oc5ViHtLRAO6lzF7s0lC/WyVgieM3TlQPKV83HvGn/JNriV9jXmrglOjvq/XNFOuf06lsjnETN/lWCPjJng1GVQqgelMsCQwiETVlMVKRTGuiLEBGVe3k23/7PVDhNz79V6R04vx7JQLDAY+wMbZZOv7xpRSXk10LAlNvBUBMHFlu+aMQlTi5JAc4PV3gX8aqhzFp2NeWNYODLFJwZof27nqUL4FYXNY8yxKsveQQ3JXlW5Cmwc3+PSPshUA0L6Algzuq1K+iA5mVy/MrlCruLrTonmKJ/xFGQKVUqP/FJohdk4mEAdNdBtiRk4nLYH9JV6MNzbVPripR7Hf1oPbv0Da71+N8sNTYsbusl6Z7SwxvBrlQV9twehGSPbpjRJIUsZ0prfAtL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 08:05:57PM +0900, Harry Yoo (Oracle) wrote:
> Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Try to get
> an empty sheaf from pcs->spare or the barn even when spinning is not
> allowed. Unlike __pcs_replace_full_main(), try harder to allocate
> an empty sheaf because the fallback path will be more expensive than
> kfree_nolock().
> 
> When trylock fails or the kernel observes non-NULL pcs->rcu_free after
> lock acquisition, free the sheaf instead of putting it to the barn.
> This is rare and not worth complicating the code.
> 
> Since call_rcu() cannot be called in an unknown context,
> kfree_rcu_sheaf() fails when the rcu sheaf becomes full.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/slab.h        |  2 +-
>  mm/slab_common.c |  2 +-
>  mm/slub.c        | 39 ++++++++++++++++++++++++++++++---------
>  3 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 509f330654b8..b1bd33a16544 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -429,7 +429,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
>  }
>  
> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
>  void flush_all_rcu_sheaves(void);
>  void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
>  
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index b6426d7ceec9..bc1a8ec938d9 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1605,7 +1605,7 @@ static bool kfree_rcu_sheaf(void *obj)
>  
>  	s = slab->slab_cache;
>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
> -		return __kfree_rcu_sheaf(s, obj);
> +		return __kfree_rcu_sheaf(s, obj, /* allow_spin = */ true);

Since this is stacked on top of the slab alloc flags work, could it pass slab
alloc flags instead of allow_spin?

>  
>  	return false;
>  }
> diff --git a/mm/slub.c b/mm/slub.c
> index 87ca154ccd80..b0d38d515386 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2815,7 +2815,8 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
>  	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
>  }
>  
> -static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
> +static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
> +			       bool allow_spin)
>  {
>  	/*
>  	 * If the sheaf was created with SLAB_ALLOC_NO_RECURSE flag then its
> @@ -2827,11 +2828,20 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>  		mark_obj_codetag_empty(sheaf);
>  
>  	VM_WARN_ON_ONCE(sheaf->size > 0);
> -	kfree(sheaf);
> +
> +	if (likely(allow_spin))
> +		kfree(sheaf);
> +	else
> +		kfree_nolock(sheaf);
>  
>  	stat(s, SHEAF_FREE);
>  }
>  
> +static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
> +{
> +	__free_empty_sheaf(s, sheaf, /* allow_spin = */ true);
> +}
> +
>  static unsigned int
>  refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
>  	       unsigned int max);
> @@ -3132,7 +3142,6 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
>   * intended action due to a race or cpu migration. Thus they do not check the
>   * empty or full sheaf limits for simplicity.
>   */
> -
>  static void barn_put_empty_sheaf(struct node_barn *barn, struct slab_sheaf *sheaf)
>  {
>  	unsigned long flags;
> @@ -6065,7 +6074,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
>   */
>  static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
>  
> -bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  	struct slab_sheaf *rcu_sheaf;
> @@ -6081,9 +6090,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>  
>  	if (unlikely(!pcs->rcu_free)) {
> -
>  		struct slab_sheaf *empty;
>  		struct node_barn *barn;
> +		unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;

which would make this logic more natural.

> +		gfp_t gfp = GFP_NOWAIT;
>  
>  		/* Bootstrap or debug cache, fall back */
>  		if (unlikely(!cache_has_sheaves(s))) {
> @@ -6103,7 +6113,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  			goto fail;
>  		}
>  
> -		empty = barn_get_empty_sheaf(barn, true);
> +		empty = barn_get_empty_sheaf(barn, allow_spin);
>  
>  		if (empty) {
>  			pcs->rcu_free = empty;
> @@ -6112,20 +6122,25 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  
>  		local_unlock(&s->cpu_sheaves->lock);
>  
> -		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
> +		if (unlikely(!allow_spin)) {
> +			alloc_flags = SLAB_ALLOC_TRYLOCK;
> +			gfp = 0;

and this as well (alloc_empty_sheaf() could derive gfp from whatever you
passed it, by simply knowing alloc_flags = TRYLOCK -> gfp = 0
(or gfp &= ~__GFP_RECLAIM)).

> +		}
> +
> +		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
>  
>  		if (!empty)
>  			goto fail;
>  
>  		if (!local_trylock(&s->cpu_sheaves->lock)) {
> -			barn_put_empty_sheaf(barn, empty);
> +			__free_empty_sheaf(s, empty, allow_spin);
>  			goto fail;
>  		}
>  
>  		pcs = this_cpu_ptr(s->cpu_sheaves);
>  
>  		if (unlikely(pcs->rcu_free))
> -			barn_put_empty_sheaf(barn, empty);
> +			__free_empty_sheaf(s, empty, allow_spin);
>  		else
>  			pcs->rcu_free = empty;
>  	}
> @@ -6143,6 +6158,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
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
> 
> -- 
> 2.53.0
> 

-- 
Pedro

