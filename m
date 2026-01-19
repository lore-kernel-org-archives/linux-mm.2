Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7595CCF2DF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263FF6B0175; Mon, 19 Jan 2026 05:54:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231D46B0176; Mon, 19 Jan 2026 05:54:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A7A6B0177; Mon, 19 Jan 2026 05:54:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E52C06B0175
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:54:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A651DD20C1
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:54:23 +0000 (UTC)
X-FDA: 84348404406.18.CF01A24
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28DEB40007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:54:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="i+G/wKzO";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTUWSoZ8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="i+G/wKzO";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTUWSoZ8;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768820061; a=rsa-sha256;
	cv=none;
	b=nv8w7s/O5XD+WBJawCVbGa7pn9kf6+ZMC24KX2V0dS5tEth4yFZtSUpMa9nqB851gu4VQO
	DUXzivmczKq12bIZ9zfpXIjD/SojWeHYu1fFnG/U8BzZ+uEZzsSoOypWxSZg+bdIOPTf8x
	ymuW5jGCrVuiq1sKLY/+FZmju7RRcaA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="i+G/wKzO";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTUWSoZ8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="i+G/wKzO";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mTUWSoZ8;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768820061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ey0pNkWH40RKae/z7UghicYKnJcQmjtLJWpIQMJLIMw=;
	b=UJaCkE9JIqzdAe0GcbupPNPmaP5+oS2sDB9l+B5/Fk1lA7Huc+4l7+zB7sqgrd/O+9TX1o
	XqD83t7JEfqfX7OmEzTh7Mbm9Wynvua45GfR7vzEf2cKd5U9WlKHswzIyU0aYmeIUZkt5y
	tnq7Egb2D2GfaCbjI9RxyuFOxkm7/Sk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 136C55BD6E;
	Mon, 19 Jan 2026 10:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768820059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ey0pNkWH40RKae/z7UghicYKnJcQmjtLJWpIQMJLIMw=;
	b=i+G/wKzOdqJTLtu23kB8UjAeRrBrBGBXCydzkMm2uMsF93aqNNgJYL9q7zsf8sURdk3bYp
	ryZ52RYS7CUiS81Q1qTzXMQyMOe+V8S6oJVJXesnDYBvSDu091/KkHnw/xM3eRnZk52Phe
	dquwy3it9zHbuRMMTKH5H6vdEF3J4NY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768820059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ey0pNkWH40RKae/z7UghicYKnJcQmjtLJWpIQMJLIMw=;
	b=mTUWSoZ82Wh5tC2EkSwCa4mX8N+MeAezhTHKT2OKP4C1aCVapf2nz8rdQhkddrr/AsAA0Y
	V9HrkDZ52NmewWDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768820059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ey0pNkWH40RKae/z7UghicYKnJcQmjtLJWpIQMJLIMw=;
	b=i+G/wKzOdqJTLtu23kB8UjAeRrBrBGBXCydzkMm2uMsF93aqNNgJYL9q7zsf8sURdk3bYp
	ryZ52RYS7CUiS81Q1qTzXMQyMOe+V8S6oJVJXesnDYBvSDu091/KkHnw/xM3eRnZk52Phe
	dquwy3it9zHbuRMMTKH5H6vdEF3J4NY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768820059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ey0pNkWH40RKae/z7UghicYKnJcQmjtLJWpIQMJLIMw=;
	b=mTUWSoZ82Wh5tC2EkSwCa4mX8N+MeAezhTHKT2OKP4C1aCVapf2nz8rdQhkddrr/AsAA0Y
	V9HrkDZ52NmewWDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB6473EA63;
	Mon, 19 Jan 2026 10:54:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1ZyyM1oNbmkGKQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 19 Jan 2026 10:54:18 +0000
Message-ID: <e106a4d5-32f7-4314-b8c1-19ebc6da6d7a@suse.cz>
Date: Mon, 19 Jan 2026 11:54:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/21] slab: add optimized sheaf refill from partial
 list
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
 <aW3SJBR1BcDor-ya@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aW3SJBR1BcDor-ya@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 28DEB40007
X-Rspamd-Server: rspam06
X-Stat-Signature: 77fhxqgfk9gu9kesnj5mmmi7me95uq93
X-Rspam-User: 
X-HE-Tag: 1768820060-631570
X-HE-Meta: U2FsdGVkX1/VEEyiDjpG5GLjVNnKEpotRNVfsW36S8w6uBhLxv2o2EgcHo2hhz/Tvmv9FBiv3hAJ02nQ6a/dXqcsLK1k6zRXJ+xuvAsHVCYopMc019FTxh8zQjHLVlay4SSVVJ7wLI6R+9yFnwo4U9oDLdWHb5Q4VgK6Ks/gsTNBjDbhrejhS7h9ArlRfY0XZp6kIgm6vxavnsWiOBG9WZG0tdXg9HRCYGdVgpuQ2ginlylq1Lkcc0oroF8JEm0pguQJkMyniF/z5M0gcH9tKM9NfLXb1dHFv744ZEz5kJOrXPL3Y+UKBUtf9Bph1tZOU0MDsNZLxHWjSNmuPUox48ZzQ2MbQ1c1stPfIbcnUa/Fr+siwEoamSfoyyRSl8H5/st7qBlFe61Dba5z6efX+EbiNUPc8qfL5oihn4Zcy9w6YFkVf7WHSo9lvowNWQlxO3FrGfwo+g5iTVFz/tB6yyQJx0lvo84K8vd6UBm80rURN2yxhitWC17WwEaKnOdBY+YDtZdWJeB7mfYveJCjt9UN3ryGv3D79gO3ekcZIwhIMSjVuMekUMXfK7Z8fqfZn2bt5ePvkvuZxKPPq1GHQQ34qHrIVY0q5YG/zVj0ypNpzt5tVpcRkie5zE/5d/fh4muBOZ/SgoBrdq8syf1vFHGTfNt/gi24C7EfiHLfGVXVbaGA4GftxBkrjb+CCm7ys6xgglh6Mh+M9+6h7p4XP0wMSz6ibw8jKk3+n4Wp21vd5kO924FZSVVPWAqLtPv5VDyvvh6faslw3QsEAunlG8NP6GSxEWhc1zjAR+T7XUuVE0sDuvm1lJdCFkYbhh74sqYxaWii+xTYf7OZ7aBSf7gugDWbFoMg4+lZZ2m4J9MhP3i80v3DRLYYkZ3BixmuRQ2O3PIcYhSd4XsbtqekN9yXgn0/DyFGR3mKvyV1Tcg8Rcxwh6HX46x8oML8k9VwjkR8Nqoot7eLQ+L1mmd
 gB+clHxp
 hipt71QNPSxLnimX89TAzmBYd8VWZngJGrAMYzBKV/uclEt04A0YUrlYfN1cTQ8A0jVzTVH8DA6HUJI4VORC5tkIRdluMYo9dFZsY3XfQl5e9hKyv6mqRmCJOoZa/P9yHLZZJILEPy9/fltZ1IVUAkDuEF5xXimvN3ruQBXOlzjwI0PoCm6idtQbC39L6YhPtAYVshYSSAlIgdV0kQwsV4yctDgDEk7HXFYwPw7c3rKuusJVPZ/nXBDpIBSmmbYNgZ35F/YHh105Db8bSx3dk/7tRS/Pudwk6yhpw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 07:41, Harry Yoo wrote:
> On Fri, Jan 16, 2026 at 03:40:29PM +0100, Vlastimil Babka wrote:
>> At this point we have sheaves enabled for all caches, but their refill
>> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
>> slabs - now a redundant caching layer that we are about to remove.
>> 
>> The refill will thus be done from slabs on the node partial list.
>> Introduce new functions that can do that in an optimized way as it's
>> easier than modifying the __kmem_cache_alloc_bulk() call chain.
>> 
>> Extend struct partial_context so it can return a list of slabs from the
>> partial list with the sum of free objects in them within the requested
>> min and max.
>> 
>> Introduce get_partial_node_bulk() that removes the slabs from freelist
>> and returns them in the list.
>> 
>> Introduce get_freelist_nofreeze() which grabs the freelist without
>> freezing the slab.
>> 
>> Introduce alloc_from_new_slab() which can allocate multiple objects from
>> a newly allocated slab where we don't need to synchronize with freeing.
>> In some aspects it's similar to alloc_single_from_new_slab() but assumes
>> the cache is a non-debug one so it can avoid some actions.
>> 
>> Introduce __refill_objects() that uses the functions above to fill an
>> array of objects. It has to handle the possibility that the slabs will
>> contain more objects that were requested, due to concurrent freeing of
>> objects to those slabs. When no more slabs on partial lists are
>> available, it will allocate new slabs. It is intended to be only used
>> in context where spinning is allowed, so add a WARN_ON_ONCE check there.
>> 
>> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
>> only refilled from contexts that allow spinning, or even blocking.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slub.c | 284 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 264 insertions(+), 20 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 9bea8a65e510..dce80463f92c 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3522,6 +3525,63 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
>>  #endif
>>  static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
>>  
>> +static bool get_partial_node_bulk(struct kmem_cache *s,
>> +				  struct kmem_cache_node *n,
>> +				  struct partial_context *pc)
>> +{
>> +	struct slab *slab, *slab2;
>> +	unsigned int total_free = 0;
>> +	unsigned long flags;
>> +
>> +	/* Racy check to avoid taking the lock unnecessarily. */
>> +	if (!n || data_race(!n->nr_partial))
>> +		return false;
>> +
>> +	INIT_LIST_HEAD(&pc->slabs);
>> +
>> +	spin_lock_irqsave(&n->list_lock, flags);
>> +
>> +	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
>> +		struct freelist_counters flc;
>> +		unsigned int slab_free;
>> +
>> +		if (!pfmemalloc_match(slab, pc->flags))
>> +			continue;
>> +		/*
>> +		 * determine the number of free objects in the slab racily
>> +		 *
>> +		 * due to atomic updates done by a racing free we should not
>> +		 * read an inconsistent value here, but do a sanity check anyway
>> +		 *
>> +		 * slab_free is a lower bound due to subsequent concurrent
>> +		 * freeing, the caller might get more objects than requested and
>> +		 * must deal with it
>> +		 */
>> +		flc.counters = data_race(READ_ONCE(slab->counters));
>> +		slab_free = flc.objects - flc.inuse;
>> +
>> +		if (unlikely(slab_free > oo_objects(s->oo)))
>> +			continue;
> 
> When is this condition supposed to be true?
> 
> I guess it's when __update_freelist_slow() doesn't update
> slab->counters atomically?

Yeah. Probably could be solvable with WRITE_ONCE() there, as this is only
about hypothetical read/write tearing, not seeing stale values. Or not? Just
wanted to be careful.

>> +
>> +		/* we have already min and this would get us over the max */
>> +		if (total_free >= pc->min_objects
>> +		    && total_free + slab_free > pc->max_objects)
>> +			break;
>> +
>> +		remove_partial(n, slab);
>> +
>> +		list_add(&slab->slab_list, &pc->slabs);
>> +
>> +		total_free += slab_free;
>> +		if (total_free >= pc->max_objects)
>> +			break;
>> +	}
>> +
>> +	spin_unlock_irqrestore(&n->list_lock, flags);
>> +	return total_free > 0;
>> +}
>> +
>>  /*
>>   * Try to allocate a partial slab from a specific node.
>>   */
>> +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
>> +		void **p, unsigned int count, bool allow_spin)
>> +{
>> +	unsigned int allocated = 0;
>> +	struct kmem_cache_node *n;
>> +	unsigned long flags;
>> +	void *object;
>> +
>> +	if (!allow_spin && (slab->objects - slab->inuse) > count) {
>> +
>> +		n = get_node(s, slab_nid(slab));
>> +
>> +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
>> +			/* Unlucky, discard newly allocated slab */
>> +			defer_deactivate_slab(slab, NULL);
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	object = slab->freelist;
>> +	while (object && allocated < count) {
>> +		p[allocated] = object;
>> +		object = get_freepointer(s, object);
>> +		maybe_wipe_obj_freeptr(s, p[allocated]);
>> +
>> +		slab->inuse++;
>> +		allocated++;
>> +	}
>> +	slab->freelist = object;
>> +
>> +	if (slab->freelist) {
>> +
>> +		if (allow_spin) {
>> +			n = get_node(s, slab_nid(slab));
>> +			spin_lock_irqsave(&n->list_lock, flags);
>> +		}
>> +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
>> +		spin_unlock_irqrestore(&n->list_lock, flags);
>> +	}
>> +
>> +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> 
> Maybe add a comment explaining why inc_slabs_node() doesn't need to be
> called under n->list_lock?

Hm, we might not even be holding it. The old code also did the inc with no
comment. If anything could use one, it would be in
alloc_single_from_new_slab()? But that's outside the scope here.

>> +	return allocated;
>> +}
>> +
>>  /*
>>   * Slow path. The lockless freelist is empty or we need to perform
>>   * debugging duties.

>> +new_slab:
>> +
>> +	slab = new_slab(s, pc.flags, node);
>> +	if (!slab)
>> +		goto out;
>> +
>> +	stat(s, ALLOC_SLAB);
>> +
>> +	/*
>> +	 * TODO: possible optimization - if we know we will consume the whole
>> +	 * slab we might skip creating the freelist?
>> +	 */
>> +	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
>> +					/* allow_spin = */ true);
>> +
>> +	if (refilled < min)
>> +		goto new_slab;
> 
> It should jump to out: label when alloc_from_new_slab() returns zero
> (trylock failed).
> 
> ...Oh wait, no. I was confused.
> 
> Why does alloc_from_new_slab() handle !allow_spin case when it cannot be
> called if allow_spin is false?

The next patch will use it so it seemed easier to add it already. I'll note
in the commit log.

>> +out:
>> +
>> +	return refilled;
>> +}
> 


