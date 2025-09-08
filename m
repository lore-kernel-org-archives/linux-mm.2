Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19965CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7714C8E0017; Mon,  8 Sep 2025 08:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748CF8E0003; Mon,  8 Sep 2025 08:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610988E0017; Mon,  8 Sep 2025 08:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE5E8E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:26:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A940137B6F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:26:18 +0000 (UTC)
X-FDA: 83866005636.07.3AA2392
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7D05C0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:26:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sVdZd8po;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zFSsZDC6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sVdZd8po;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zFSsZDC6;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757334376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRQnfV7KacqgKnXu/9rxHwsFubE78Co0XLB4BS11uuo=;
	b=p1a5Ze+ihnaMKiD4clhjOnEYD7hEOb/WhRl3pWSSPsmsf8W/4IIQ/KIpaxDFaIS8L68pHG
	Bc5kcBCugshtySngKY9fFqG1VncTWjKF3tIEo6E1ENCYefA3XtSA1KzdIXJVKkAK0f9cqL
	lSPQMGRtcRGddFNVSS4UlCb8Q7uoCDM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sVdZd8po;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zFSsZDC6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sVdZd8po;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zFSsZDC6;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757334376; a=rsa-sha256;
	cv=none;
	b=x1bLzIna8Hrv4ZiF3sdvvyD+VFd68e/EamvYNUyjRpzyMyL0WS+Pt4U9yi4jXFSbbPyJya
	hh/I3yyXpQdwFGnQWQuExTEhS5tNV0aUTyhnMSkjKpm2Z7IfBZS5Pft0qOQ3dxpaXUX8cM
	htHyXTuHxsSILiFPssjwkNwqO91YCdI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 306546BF8D;
	Mon,  8 Sep 2025 12:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757334372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DRQnfV7KacqgKnXu/9rxHwsFubE78Co0XLB4BS11uuo=;
	b=sVdZd8po7eWGx5Ww9w3Avpn5gXpxLOF9LEyI3qvJoivDJ433rPmpDycz1Y/NWrxS024LC7
	BubEWxx8UPvfAB4uynAFWv1pyC8UUoUX9XpyW8BFVZUtkKFzMCtb6xQie2/sz1SjLWSVY9
	XuJRk4XhjLazNrPZUMpX1N7qLQV0xhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757334372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DRQnfV7KacqgKnXu/9rxHwsFubE78Co0XLB4BS11uuo=;
	b=zFSsZDC6Yc+HndyH6cao9U/6LThplTGnuWttOH5MYaPdxd/oRpmVEgE46ZRVwl7J3XlldY
	OHjot5ea72H9D9Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757334372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DRQnfV7KacqgKnXu/9rxHwsFubE78Co0XLB4BS11uuo=;
	b=sVdZd8po7eWGx5Ww9w3Avpn5gXpxLOF9LEyI3qvJoivDJ433rPmpDycz1Y/NWrxS024LC7
	BubEWxx8UPvfAB4uynAFWv1pyC8UUoUX9XpyW8BFVZUtkKFzMCtb6xQie2/sz1SjLWSVY9
	XuJRk4XhjLazNrPZUMpX1N7qLQV0xhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757334372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DRQnfV7KacqgKnXu/9rxHwsFubE78Co0XLB4BS11uuo=;
	b=zFSsZDC6Yc+HndyH6cao9U/6LThplTGnuWttOH5MYaPdxd/oRpmVEgE46ZRVwl7J3XlldY
	OHjot5ea72H9D9Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0DD4413946;
	Mon,  8 Sep 2025 12:26:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hSHfAWTLvmiqIwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Sep 2025 12:26:12 +0000
Message-ID: <be0ba18e-f752-4df3-a224-fc978431236c@suse.cz>
Date: Mon, 8 Sep 2025 14:26:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/21] slab: add opt-in caching layer of percpu sheaves
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-3-71c114cdefef@suse.cz>
 <aL672Jeqi99atefN@hyeyoo>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aL672Jeqi99atefN@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ookax6uxs9w7zsx6cdzmso4d3mg5f95y
X-Rspam-User: 
X-Rspamd-Queue-Id: C7D05C0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1757334375-711319
X-HE-Meta: U2FsdGVkX1/e4W4TjArwZztP3dArwa3gSN4Db/DLmqgQjHiK5mZqMp6aOBcx/HPhtx7LUaOZXUhksZryWr+b09jUZJj6kWsBG+SKLKkzUNVPz/66JRlxAocsPwoorh/Q2WuXW5pArlkbGtzeQ6zOXQvbZeiNYx9oi6RSTgG4X2oPccqubJvEtv/DEiJFqpUqnLmWqX3xxW6QzZq60/V1o5Y93qMHvGAuwgpOVtBpJCC2MMvY/iF8qp8Zdm5GGDSaOnBjFLOLlv5dHKNEv7euiT8kQ7Ru8ebPlmZ2DBzKVHKN9hCIt433uv4loD5Lu+//FXnz2dsqtn1rv4F42FrWYt9PgD7gUKKKGQWKs5Ox2URCB0x8WplUEa/cHClBhPbBkZEyV2exdmEGA31ZcLgHQtA672a+Aq46zW6tmAzrlFl3yM+a6VNUMEkX+ZSj6Fhp6wZfigvJJn+AI96mB8Ozs7E+e4d3ALkHPXJ0yGh492bD8SkiW03oln3uQn8Vo5azSR30HWq3S+mctJxq34n7tcZR6ln/Smxo3Im2p8+OChL4kZw0hlLyM5XbCQU9p4hGgCkGvvQ1M+S7WTg3Xi0DHH6K6RLOTCq6ohT1vIWaY7xCdkyVr11tff3ao5BbJr9BQ5NmB/Bb4gVqgHly3+D/YOAZVBs3IMqsg0AF7zXHnb13Bc7cLQtJcai4GT6qjZi82x8WWD0JMOhAGzAjBB6VXPNE47a3kcSyB4HIlsEK40pN4gOAreMYBdme8gdnMZxDdk/dt6zN1KkMYNi45J0XJUlDX+ONBbDICgliY9IId4hlR+jBWfB1svNbFuDZ42tPmJ6PRsUgJ72ipN51uDOVRTrE8Oplh8i3+cMN5dscSSLAX7EJUFlJ5B5KskKUR/eUb2fBXMQvRK7+C2Oibl8Nk6SL0v90/u9eIkdelb9H2da+4TdQSIiYsy9BEs4bhCugTmEWXoJbUQZOC5s4Ii/
 J1/RJX4s
 ojqk89e9ZYXTQDnFOmsyt+9/4tIJLp/DWvFZ4UdJQuJ6PxS378dUBh6XfEFN6uWh1k2ClqMeHqny+cDkv8yPsZWi+UIu210MshH2+hhjzd4LugyKKERjiExeX7rJlLlbg+EFwE5OfJeX0uWrPGY7wmbiaRnC913j2hjA4/s+CYql9qDU1N+pV8/66u53WE7SDPYkVhrCBZWll8voF66SGMqVcA/a00QphOCBfMpJmUHxd1EaT/VbJIGh3MHOmQY4qLoGUcS0khBTk+K4cRfU4IwFVLheHxoLIk1OZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/25 13:19, Harry Yoo wrote:
> On Wed, Sep 03, 2025 at 02:59:45PM +0200, Vlastimil Babka wrote:
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index bfe7c40eeee1a01c175766935c1e3c0304434a53..e2b197e47866c30acdbd1fee4159f262a751c5a7 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -163,6 +163,9 @@ int slab_unmergeable(struct kmem_cache *s)
>>  		return 1;
>>  #endif
>>  
>> +	if (s->cpu_sheaves)
>> +		return 1;
>> +
>>  	/*
>>  	 * We may have set a slab to be unmergeable during bootstrap.
>>  	 */
>> @@ -321,7 +324,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>>  		    object_size - args->usersize < args->useroffset))
>>  		args->usersize = args->useroffset = 0;
>>  
>> -	if (!args->usersize)
>> +	if (!args->usersize && !args->sheaf_capacity)
>>  		s = __kmem_cache_alias(name, object_size, args->align, flags,
>>  				       args->ctor);
> 
> Can we merge caches that use sheaves in the future if the capacity
> is the same, or are there any restrictions for merging that I overlooked?

I think we will be able to merge. It will make more sense if we get to
enabling sheaves for everything and set capacity automatically, with the
args->sheaf_capacity serving only as a lower bound. Right now we can leave
it as is I think.
>> +static bool has_pcs_used(int cpu, struct kmem_cache *s)
>> +{
>> +	struct slub_percpu_sheaves *pcs;
>> +
>> +	if (!s->cpu_sheaves)
>> +		return false;
>> +
>> +	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
>> +
>> +	return (pcs->spare || pcs->main->size);
>> +}
>> +
>> +static void pcs_flush_all(struct kmem_cache *s);
> 
> nit: we don't need these functions to flush sheaves if SLUB_TINY=y
> as we don't create sheaves for SLUB_TINY anymore?

I'll check but also if this is true I would expect to have a clang warning
report already. Maybe they are called but don't need to?
TBH we should get rid of SLUB_TINY at this point, maybe have only a boot
option that disables percpu caching and keep the code compiled.
>>  /*
>>   * Flush cpu slab.
>> @@ -3358,30 +3793,18 @@ struct slub_flush_work {
>>  static void flush_cpu_slab(struct work_struct *w)
>>  {
>>  	struct kmem_cache *s;
>> -	struct kmem_cache_cpu *c;
>>  	struct slub_flush_work *sfw;
>>  
>>  	sfw = container_of(w, struct slub_flush_work, work);
>>  
>>  	s = sfw->s;
>> -	c = this_cpu_ptr(s->cpu_slab);
>> -
>> -	if (c->slab)
>> -		flush_slab(s, c);
>> -
>> -	put_partials(s);
>> -}
>>  
>> -static bool has_cpu_slab(int cpu, struct kmem_cache *s)
>> -{
>> -	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
>> +	if (s->cpu_sheaves)
>> +		pcs_flush_all(s);
>>  
>> -	return c->slab || slub_percpu_partial(c);
>> +	flush_this_cpu_slab(s);
>>  } 
>> -#else /* CONFIG_SLUB_TINY */
>> -static inline void flush_all_cpus_locked(struct kmem_cache *s) { }
>> -static inline void flush_all(struct kmem_cache *s) { }
>> -static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu) { }
>> -static inline int slub_cpu_dead(unsigned int cpu) { return 0; }
>> -#endif /* CONFIG_SLUB_TINY */
>> -
>>  /*
>>   * Check if the objects in a per cpu structure fit numa
>>   * locality expectations.
>> @@ -4191,30 +4610,240 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>>  }
>>  
>>  /*
>> - * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
>> - * have the fastpath folded into their functions. So no function call
>> - * overhead for requests that can be satisfied on the fastpath.
>> - *
>> - * The fastpath works by first checking if the lockless freelist can be used.
>> - * If not then __slab_alloc is called for slow processing.
>> + * Replace the empty main sheaf with a (at least partially) full sheaf.
>>   *
>> - * Otherwise we can simply pick the next object from the lockless free list.
>> + * Must be called with the cpu_sheaves local lock locked. If successful, returns
>> + * the pcs pointer and the local lock locked (possibly on a different cpu than
>> + * initially called). If not successful, returns NULL and the local lock
>> + * unlocked.
>>   */
>> -static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
>> -		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
>> +static struct slub_percpu_sheaves *
>> +__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t gfp)
>>  {
>> -	void *object;
>> -	bool init = false;
>> +	struct slab_sheaf *empty = NULL;
>> +	struct slab_sheaf *full;
>> +	struct node_barn *barn;
>> +	bool can_alloc;
>>  
>> -	s = slab_pre_alloc_hook(s, gfpflags);
>> -	if (unlikely(!s))
>> +	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>> +
>> +	if (pcs->spare && pcs->spare->size > 0) {
>> +		swap(pcs->main, pcs->spare);
>> +		return pcs;
>> +	}
>> +
>> +	barn = get_barn(s);
>> +
>> +	full = barn_replace_empty_sheaf(barn, pcs->main);
>> +
>> +	if (full) {
>> +		stat(s, BARN_GET);
>> +		pcs->main = full;
>> +		return pcs;
>> +	}
>> +
>> +	stat(s, BARN_GET_FAIL);
>> +
>> +	can_alloc = gfpflags_allow_blocking(gfp);
>> +
>> +	if (can_alloc) {
>> +		if (pcs->spare) {
>> +			empty = pcs->spare;
>> +			pcs->spare = NULL;
>> +		} else {
>> +			empty = barn_get_empty_sheaf(barn);
>> +		}
>> +	}
>> +
>> +	local_unlock(&s->cpu_sheaves->lock);
>> +
>> +	if (!can_alloc)
>> +		return NULL;
>> +
>> +	if (empty) {
>> +		if (!refill_sheaf(s, empty, gfp)) {
>> +			full = empty;
>> +		} else {
>> +			/*
>> +			 * we must be very low on memory so don't bother
>> +			 * with the barn
>> +			 */
>> +			free_empty_sheaf(s, empty);
>> +		}
>> +	} else {
>> +		full = alloc_full_sheaf(s, gfp);
>> +	}
>> +
>> +	if (!full)
>> +		return NULL;
>> +
>> +	/*
>> +	 * we can reach here only when gfpflags_allow_blocking
>> +	 * so this must not be an irq
>> +	 */
>> +	local_lock(&s->cpu_sheaves->lock);
>> +	pcs = this_cpu_ptr(s->cpu_sheaves);
>> +
>> +	/*
>> +	 * If we are returning empty sheaf, we either got it from the
>> +	 * barn or had to allocate one. If we are returning a full
>> +	 * sheaf, it's due to racing or being migrated to a different
>> +	 * cpu. Breaching the barn's sheaf limits should be thus rare
>> +	 * enough so just ignore them to simplify the recovery.
>> +	 */
>> +
>> +	if (pcs->main->size == 0) {
>> +		barn_put_empty_sheaf(barn, pcs->main);
> 
> It should be very rare but it should do
> barn = get_barn(s); again after taking s->cpu_sheaves->lock?

Yeah but it shouldn't really matter which node we use for the empty sheaf
return. And in case of the full sheaf below it's actually better for
preserving numa locality to use the original barn.

