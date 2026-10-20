Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFF3606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 09:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYZEcVcS
Received: by kanga.kvack.org (Postfix)
	id 8CD436B0149; Tue, 20 Oct 2026 05:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E3C6B014B; Tue, 20 Oct 2026 05:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76CDB6B014C; Tue, 20 Oct 2026 05:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8AC6B0149
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:23:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2CE31207F2
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:23:40 +0000 (UTC)
X-FDA: 85342467000.08.CBE31F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E4702000C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:23:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYZEcVcS;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792488219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrWQ+Cd5SFvOA24L5rQEXQXPIRohovlG1DOLfco3pHM=;
	b=nSil0fH2pHnXnKf8g41HtGFBcWmvjr9N8tGydxRyozL8OnaNirC+LnPlnJ0nMAi3l0Qgml
	e9pdDHVpCfTrGQJKGAiR2sbjvV1/70wj46/FytjpImNBUZ5+U0bE8T+WIAt4lgTORYs6KL
	+xkNmRdKBrxlvAl+OETz/ezyaZVMWmM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYZEcVcS;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792488219;
	b=c1CstN1RZ8YpwHXnL8vOFGuJ/LpcMK7swThryjzRbyiXa+B+zZfTwZwrWWTiv2W2W61RpP
	VIawJ2t4Nk4WVvlTMjPzwHFJN49YrtALVvC3takwWlQIIpifCVz0OX9T0pHwbjvNrdjtFN
	+emfTmNWelh3wF6LAV0l/1p4CAttZuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 783A160098;
	Tue, 20 Oct 2026 09:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00D91F000C4;
	Tue, 20 Oct 2026 09:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792488218;
	bh=LrWQ+Cd5SFvOA24L5rQEXQXPIRohovlG1DOLfco3pHM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SYZEcVcSAbskP2DhiGlNW5HinAr+cz0Ntp0gnvOj0VnhXOHOR0VCZ1Ku4o6DRbfcn
	 hfAksJrXN14BuU/Q4MmQqlAOmFKfrvezcJWXHDqRg1uqhn5oIMeG7CE3Mc8ppSiaaH
	 Txp1VW082tN2jqJUGpMimb5Q4KkPxH6zURsvd1gBixiALLj0S3U8oyoO5VdqRSe2Co
	 y1mqGI8/ve0qSQltcrThTinI558OMXpqLVJmguTbrZEIcA07uN6C6F1fK2VzY8uFum
	 np28g4gc2apqviNYRCM0EiM0Rz3/1UtX6E9rcX++tLf78Gef/20i8LgRoapLC9s3Ha
	 en7ZTG2DuvCmg==
Message-ID: <3225a379-a959-44b2-a2e8-02ca93759316@kernel.org>
Date: Tue, 20 Oct 2026 11:23:35 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: Call call_rcu() directly from
 __kfree_rcu_sheaf() in any context
Content-Language: en-US
To: Puranjay Mohan <puranjay@kernel.org>, linux-mm@kvack.org
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, RCU <rcu@vger.kernel.org>
References: <20261016155340.3304319-1-puranjay@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261016155340.3304319-1-puranjay@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E4702000C
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: jn1zcpg4u6im3egng74t7m6q1myu48xo
X-HE-Tag: 1792488218-828856
X-HE-Meta: U2FsdGVkX18JxevhuycRAVqtlIldn02eiBiZ+wSl9Pee8xVqdb+mK4vZPFhJgqoHj/fkt3w5fmTGzzaL6sCeYUKhP2YJFJKySoI23r3GWe4g/sDXNqzlDADctc04RikLDnNlrFOBCD0KN4QzMxWWUZWkNWCrD2lb7b1oJyOICpP75EmRCiHEe+wn1Ibu9WT8FsGJm/HyqVHyTu0kwX6n0ka2JqQqSQ10vjb+e6OdozO8mUDQMJKr2BxNmiqxU/RBRYbTxzRqgpygHrxykS6hjBWzQO8eedQZQ3I6YBRTtKheQH1LuDJ02pR2UgApcXD2gxzRYygRwHorBzYL2FGZCjFwm6m5eqr6NK7sknePNPyyWliXxt1sR7ulikI/VfbJsZL/8ocWK1YmaNkxpzN/mDYEEhcjtmVSzQD0qAFJR7WIPJtxUEjRrBaP95TvCu15O8Qu6JxGVMquMsLLLZ7z+c3t80iWyWDTsiPjCXneuEjT7fRVe32etjMJ0WZEWI5BTwqVXUneOHhJkJOZI5TmTni/dS9XKwjb+SJptDmSUED5xg++1YkGLDU/ksuFv3wRpkoE5PQN7qdHhEyk9gN+9dYz3VHUd6YN+zsWctGDZzzMOBOysoAV5uonApyYUl/5dZqGlyXgTGOw4Jz6PRGaTqGcnFdSWOKp3uK29n+OU7u0HCKaWYidifbHXjgxzQTJubX/r6XGRH+9jM0ueV4qJO9GbNSzczSmOF96GKiRdt9JH2cy6KcDcVXeJjSAHf6Wm7PziS9dAYKcuDkJFgDSLI9L3qrmuP6lpcU4NLPilVBlumrRBs4AVrARE09DJVGC09MkJVNg8wItdxvlO1V35TBgbRvIfNeF2Tg6h0SNx5HlmnHqUtMEwoQnUDBRo/gvqHeWNSWuT4PySWwFvFXRON/XX3rwnqSoXoKNcvUviYjWBnwaJISInoM3I6fug9jPLDsn4wNsRNXgeRFiJBx
 RmGWnjor
 cRDEl2n0KCOsF/kRmIaAEcZgfF/SG4YgRoeVIDrJYUXA4gX/mVZVcl7fQa1C/1Z8TJVc+atmor7+cdgB3vtnjcTZe3IXuuRox2jxvMr1RLTFXx8+gNVpr4KQh7kpenn2j7ncpntR23aHOpUzP1fTHlL7/A4MM27dSeo6JUQAkd0XQW6ZufhwIpUXmm4eRoTNRkiuRNwU9FgHKn8ztl8u34ujxILAR34TFozurzN6VkjLZgY7UKfmUqbZSUWIAPNsYk0E/yAhM+832kbNykp5WdGBwHxrtuCKdGP1c69gfrlCTd1xt5W5P0Vu/4LmQFXaCCPHBe46zKzyrgqA=
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

That's great! can you reference which commit does that? I assume it will be
merged in this 7.4 merge window?

Thanks,
Vlastimil

> (from NMI, or re-entered from instrumentation), it stages the callback on
> a per-CPU list and re-issues it from irq_work. Callers no longer need to
> guard against that, so always call call_rcu() directly and remove the
> rcu_sheaves llist and its irq_work handling.
> 
> Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
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


