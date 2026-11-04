Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133CA606A334
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bp8OIvsC
Received: by kanga.kvack.org (Postfix)
	id 2B37B6B05B8; Wed,  4 Nov 2026 03:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2644F6B05B9; Wed,  4 Nov 2026 03:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153766B05BA; Wed,  4 Nov 2026 03:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D61066B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:24:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A0FCC01FB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:24:33 +0000 (UTC)
X-FDA: 85396750026.19.8033849
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 996B51C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:24:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bp8OIvsC;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793780671;
	b=hB65KISBIbNjCBBDL9VWnkf9G2u6IaH126yKASi0/8JD/LRy7X0zDcnd2Z7bu8hzALZx9F
	C+yWDjwKFL33rgTbBAz6qhnKPYDAhIIvXkkOJ7GpqMHo6U5iEnjFYqW8CtNnX+iP13gcR1
	oy7AHIkWpejoysdlQfQagoAOQhcH8VI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bp8OIvsC;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793780671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSK8AmOx9OzK8WyqhkvENBFW7dozxPrueXvm3eaVPYY=;
	b=6EMN7YPK/fXJW8D1YXur+094lQLdtSXfbVDu8eZ29IzoyK1xO9f9okEKtJ6OutwUU/QKTg
	vb98ZhBWWMA5WVeE80qF4ErLk0aU0nI+ziUFmiYe8HhR8CicCSm06JSlKs6NA0B4LPrntd
	GFx3xqKQrae1rYG5fkAek1m062YCmAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A2256022E;
	Wed,  4 Nov 2026 08:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62BC1F00919;
	Wed,  4 Nov 2026 08:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793780670;
	bh=HSK8AmOx9OzK8WyqhkvENBFW7dozxPrueXvm3eaVPYY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bp8OIvsC8sL//M2/yvtNnsIIaNY+RiYwUqELmJKWrNYAKGfXjz05sUs4j8dhic72A
	 /cVdRgK6UVd7Newd8rvneFHhzlr4wJCaAZ/cBvMB4/AQlHe1bVxluO4uimtu8YrWhb
	 L3XdAJoL8Wf0CjZjS9ynF6P/UWuL8UMRza1AQ6XUZQu1URDdF1uCTXu/5u9dls+zkr
	 2Z95I3mZsRcXUj5IwvdjucWLlGnxlNEeiNyIKSTVnuyCmNA+vTeNbrstwEON4dKC8y
	 mv/qZZkHXwA7mlLVj/uMqsaJOFwzkmSPXGgenbEPgJx/SgeRevp3HohwXTKhiTb9IS
	 Dr33j1b1ly9eQ==
Message-ID: <04807a53-8fed-46a0-b1cb-4b86d70636c5@kernel.org>
Date: Wed, 4 Nov 2026 09:24:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: Call call_rcu() directly from
 __kfree_rcu_sheaf() in any context
Content-Language: en-US
To: Puranjay Mohan <puranjay@kernel.org>, linux-mm@kvack.org
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20261016155340.3304319-1-puranjay@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261016155340.3304319-1-puranjay@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dyp71j4mm7hybzeddferuxnsjoqaqsde
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 996B51C0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793780671-959846
X-HE-Meta: U2FsdGVkX18b1jlzE8BgoHS1Jx6V7FPRrAKP4rwnaUcoszs6gGzD5rXrV/bLItWF/6MJkY8Zv2mwGeZPQxj2/ymcrJCWFxz6TigHqlJU3w/Remjcck+B6hWMEVyjsFqUdKXPAGQmPPjg1v2YgYSG0TA69nQ8DaLcBcxktgsL3TXOdTfLTkpsJTxl1UPiUE8tQ4sE0sVXljIy4Mjggw/lFtJlr/TSNOTJoPaDZv9rUAktivVLFdjcboIjcSnFOx7NNaP93RuhW9UbN6oQ5fFvPsMsnm7AF8xwBK+uWNH8dUjPcnX62REZf/JcB3G8FBTeeKuV7u4kJhxxYNvA20vsvPY4gdyILxu1FF9L4IIJAcdiHPf9ounjzXvdcJiCRL6nt52yAgTrA5EGSbPrcQaAncJdIsu77aESn/hZH+E3SrFqvyIYX7a1OjjOtk0FYjLgU0XX7IezZh3BQP2VdiG2A4x7g6Lf15i7lDO/p6zkXjO2BVImaCqbho0ccxx1xVKyIse3ldzO6SmKfjtT5lgCHNJXghi8z5ROKW6ySqFShe74ta3GZht/oO4V3r0z259nY9fcDbDINZQzOd3ffdHn3QIV2Q5rrdT5HN0iUA1vYIrlmpYiVk7UWt0nTo8l28mf2uF5FmnlnUdz1X3u0icJLAlvsVU5eUO2TF4rfT9TbHU2xccLSNLRzQ+9eO7vwtx+ByWpRWnFnmPCIquGeTin5P2U3lzz+I9O4a5OQDVwSJWkNRq36mmYHjiW6Thvu0WXMuuCU66JZFQG3YrYGkjb8tYf9P2ud7JEJkFPqpSICWpMCcQ+7Qc4wPYWdTpcRDLubLeL2DHjQRTisWI915zpn2OfleQBviWBsISHougkzbP8rLdQVASCIxvkY+0ODhhg20lsuan4/Mw1xGcLKr9cGFxZlVhBeqaqlNPAbiZu6uXnmsd7ZQUY2a37ByxFeGCr8sC0D1+hMLmlpcpxcAJ
 /9NqsYT6
 bht82cKsMT8tiPzOB9NExJZWTwhtO5ZhNG5HkaqF2JuPv03T6oPa4sMcdZkXx/kSJjGC3DeLMR8o37LsfUbueWtIsaM2NdqmaLna7o0kac0qG1DJEIcYOo6uO97xc4PYXhLou2AiwpALpZyLpWto9tQjrLWe32HCyuPqUsfbVcTdi5ZrYJu/lsJ6R1SGx1jdqBIFTO1pl2ouPN5FeOlzxP4fW/5CmfSnGtJUGrUKtaP41CfniDq1FjFsghNiKSsC9xgJ5yQAkZkuMNhJxrUzYPdG6ZFqSRPfgoichZIGn4zGnf2VIdOAi9/R71XqpmgbHiuABL3+BNSKL3vM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/16/26 17:53, Puranjay Mohan wrote:
> __kfree_rcu_sheaf() can run with allow_spin == false, e.g. from
> kfree_rcu_nolock(), where it may interrupt call_rcu() itself on the same
> CPU. call_rcu() was not reentrant, so commit 69abda97a09b2 ("mm/slab:
> extend deferred free mechanism to handle rcu sheaves") added a fallback:
> when !allow_spin and IRQs are disabled, the full rcu sheaf is put on a
> per-CPU llist and submitted to call_rcu() later from irq_work.
> 
> call_rcu() now handles this itself. When it is called with IRQs disabled
> (from NMI, or re-entered from instrumentation), it stages the callback on
> a per-CPU list and re-issues it from irq_work. Callers no longer need to
> guard against that, so always call call_rcu() directly and remove the
> rcu_sheaves llist and its irq_work handling.
> 
> Signed-off-by: Puranjay Mohan <puranjay@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/slub.c | 28 +++-------------------------
>  1 file changed, 3 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 8fbc6bf8ebc51..6c44f4495db5a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4145,7 +4145,6 @@ static void flush_all(struct kmem_cache *s)
>  struct deferred_percpu_work {
>  	struct llist_head objects;
>  	struct llist_head objects_by_rcu;
> -	struct llist_head rcu_sheaves;
>  	struct irq_work work;
>  };
>  
> @@ -4154,7 +4153,6 @@ static void deferred_percpu_work_fn(struct irq_work *work);
>  static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
>  	.objects = LLIST_HEAD_INIT(objects),
>  	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
> -	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
>  	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
>  };
>  
> @@ -6308,22 +6306,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>  	 * we flush before local_unlock to make sure a racing
>  	 * flush_all_rcu_sheaves() doesn't miss this sheaf
>  	 */
> -	if (rcu_sheaf) {
> -		/*
> -		 * With !allow_spin, we might have interrupted call_rcu()'s
> -		 * IRQ-disabled critical section. If IRQs are not disabled,
> -		 * we know that's not the case.
> -		 */
> -		if (unlikely(!allow_spin && irqs_disabled())) {
> -			struct deferred_percpu_work *dpw;
> -
> -			dpw = this_cpu_ptr(&deferred_percpu_work);
> -			if (llist_add(&rcu_sheaf->llnode, &dpw->rcu_sheaves))
> -				irq_work_queue(&dpw->work);
> -		} else {
> -			call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
> -		}
> -	}
> +	if (rcu_sheaf)
> +		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
>  
>  	local_unlock(&s->cpu_sheaves->lock);
>  
> @@ -6532,12 +6516,10 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  static void deferred_percpu_work_fn(struct irq_work *work)
>  {
>  	struct deferred_percpu_work *dpw;
> -	struct llist_head *objs, *objs_by_rcu, *rcu_sheaves;
> +	struct llist_head *objs, *objs_by_rcu;
>  	struct llist_node *llnode, *pos, *t;
> -	struct slab_sheaf *sheaf, *next;
>  
>  	dpw = container_of(work, struct deferred_percpu_work, work);
> -	rcu_sheaves = &dpw->rcu_sheaves;
>  	objs = &dpw->objects;
>  	objs_by_rcu = &dpw->objects_by_rcu;
>  
> @@ -6571,10 +6553,6 @@ static void deferred_percpu_work_fn(struct irq_work *work)
>  
>  		kvfree_call_rcu(head, objp);
>  	}
> -
> -	llnode = llist_del_all(rcu_sheaves);
> -	llist_for_each_entry_safe(sheaf, next, llnode, llnode)
> -		call_rcu(&sheaf->rcu_head, rcu_free_sheaf);
>  }
>  
>  static void defer_free(struct kmem_cache *s, void *head)
> 
> base-commit: e52c7c28dbece00f54dff26e1554df2fe59b02f3


