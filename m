Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0C4CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECCBF8E00FB; Wed, 29 Oct 2025 16:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7C398E00B2; Wed, 29 Oct 2025 16:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44678E00FB; Wed, 29 Oct 2025 16:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C24358E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:48:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A7891608F8
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:48:31 +0000 (UTC)
X-FDA: 84052340022.14.34E5C64
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 150C2180009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:48:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FX/p9nMP";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZjokwtAs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FX/p9nMP";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZjokwtAs;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761770909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXMm+8rNL3B9SMoW6XqHW2hL2qMAKNxXr/FwREZjE5o=;
	b=ZFhT5KXg8rF/S1O/4oOBwl71/vnTlUCoHL10Zw5CMu6pESo7gbTBY6yS4oYvVh9Cflihe7
	HbFRKU7tVAFKnl6jJxbuO+u1wes44OrD+ldUY5he4Wbu/Xl0Zt1FhPR+PXQMKbdbL9TdZu
	sLHsQY+ZmT0FfsmL7WA77Z4YqnuDuUA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FX/p9nMP";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZjokwtAs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FX/p9nMP";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZjokwtAs;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761770909; a=rsa-sha256;
	cv=none;
	b=unbkPVDimuj3WK6jYX23XNOUTWYKjlpsjbbT9i62ImD9gF0ln9mdSjcS9xyb9msnxUUcI1
	0E99vX040vck3cdw6SdDJzAnP4Mv0QQFeiNlOzvk/vi5zc4+zcu/0MQlpKjUFLYTcblSbW
	OA4Ref2rU02kSHzu6aZSccrvzuwZXJY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6D1095C797;
	Wed, 29 Oct 2025 20:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761770907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xXMm+8rNL3B9SMoW6XqHW2hL2qMAKNxXr/FwREZjE5o=;
	b=FX/p9nMPP4ug6Jsu/qy7odhm6sWqHzogKL/CxbhcQP3Q8U5iSySGa39tQJxpIha3tMgcUl
	NHIJtg3T2g3B+q5OtTTnphmmII9/R2QAubj1VsgCoiARgpaEvdRtHIKz8upfvx5iOCxNL7
	3dYC5PgQadjsbOYESpkSSaNX68o0GYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761770907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xXMm+8rNL3B9SMoW6XqHW2hL2qMAKNxXr/FwREZjE5o=;
	b=ZjokwtAsPjTgKPciEs3bMK5UID67Ixhyh/hEk3sgPaEQ+CImR8iyzR6Mo0hW6L5V/6RBXH
	FzyIe2x5AAWJ/RCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761770907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xXMm+8rNL3B9SMoW6XqHW2hL2qMAKNxXr/FwREZjE5o=;
	b=FX/p9nMPP4ug6Jsu/qy7odhm6sWqHzogKL/CxbhcQP3Q8U5iSySGa39tQJxpIha3tMgcUl
	NHIJtg3T2g3B+q5OtTTnphmmII9/R2QAubj1VsgCoiARgpaEvdRtHIKz8upfvx5iOCxNL7
	3dYC5PgQadjsbOYESpkSSaNX68o0GYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761770907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xXMm+8rNL3B9SMoW6XqHW2hL2qMAKNxXr/FwREZjE5o=;
	b=ZjokwtAsPjTgKPciEs3bMK5UID67Ixhyh/hEk3sgPaEQ+CImR8iyzR6Mo0hW6L5V/6RBXH
	FzyIe2x5AAWJ/RCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5083E1396A;
	Wed, 29 Oct 2025 20:48:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wxFIE5t9AmkgJgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 20:48:27 +0000
Message-ID: <113a75f7-6846-48e4-9709-880602d44229@suse.cz>
Date: Wed, 29 Oct 2025 21:48:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 09/19] slab: add optimized sheaf refill from partial
 list
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-9-6ffa2c9941c0@suse.cz>
 <aP8dWDNiHVpAe7ak@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aP8dWDNiHVpAe7ak@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 150C2180009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hzctc9ijsjiegjawjh853e31td8xbwam
X-HE-Tag: 1761770908-374461
X-HE-Meta: U2FsdGVkX194mVhXmo92E2H99x508IUm3mxAQsiu4iZUG6I0drXzG7R8eu8YmV8nvGBPN+mEewOAySnOwA0aV5mIjEm7XQLXhYVRLrzFfRcy1UODICleemozjpJBm4QyutLHhK+Qf9uR/SM2YJ7rcSk7gBBrZsUs7bNigaFwy4DwaouO8W0GjWIjM4HNGmxoGaUM+hBSDBy6s+eVApjusmoOi2L85b1YyTLqnw7Zg8MAlRl82/P25CTlgkUIfoH6Iv6jctXyIJJ39eUcRqMbwet3PssLHo1Uzk1ceDOA1PA+62DLP1zomQWLIuIlLXEPHLG9FJGtbWz2qMqQk/STlYqNEh4YxZtPFAdO5UHspENFI7MfHcbsSmCm5dkXryshuT7KAPTue0pgQXMTJHwi5T//OJBJGwQwZY+aqpESs59vQdhFWdb7AhA5jgMlFKekJa+O4rBRYTUsfJlremdmMXKbA4hFI+l3X+id9IoRx4AGZ6cSbOGVvOzDrIcoU8gXBKbWxDQjabGu6A3S/YbppuO3oPGBn4ZmcGq6f4gkszTNlWqAkoSNZbMnLAbDD+2YqB3QmEkkctLfOt2u2smXlti/ZotI6y9PIksC6tIGE96QFnt7G3JdoAtz9eXQTOnsXqDoFv7HeS5kGXBEghOy2xTTMfjr8SBgt8EIkh7xn5gIf4Xn63v1e0ygmqudpHdvdiT80/Ay/Vb4oYUxOSv0U9bzdhaDpwtgiRMagK9yQXiO1mSyFFnXYA5hC9SNm3UJKGPunofBNf18wSiKakLNZP0QXjUSvq5t+aZA9+zd4LmR/TYLpJeaVEIxTU1DJg0BQiRELaj7rRQ387fJoMfJEzj45ml9YCReSU5lHrA8qY5gP6H6nVkzcFf7jZdt4nPZifnBxVrxYhzbkOdeBpKfdrfxGPlKE8VUH1VGzj7zi+uyhAm3OsWM6jQ7le5ODJ7sO7akyWT7+BczhlcCsFQ
 1R5PoUhG
 p309wSSzUu3fCjD0t/+DzW0MBL80gHyTa7DjQOVXnOZ4iOxDuFeldZYvF4+QRzx+penr+Vb9inPg4z/OztW6sSoeypsYXo8GJ+U3X8SwznTBdJp0GkJ94z4q6aFgwyUwCYH0dq3Qe4pgUMdBcldEuUUE50BBAO+kdPvV+CHoj0TsWmFc24McykhwynTD83QTA8h2rzHumwiq55bShZ9oHvSidfQJZi7qgizxSIVRChNHpTGLi34E0PxmTy2SjcHbOWTfcVKlXKHdRq7t9bGlDg+ajDkEXQQrEVWaU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/27/25 08:20, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 03:52:31PM +0200, Vlastimil Babka wrote:
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
>> Introduce __refill_objects() that uses the functions above to fill an
>> array of objects. It has to handle the possibility that the slabs will
>> contain more objects that were requested, due to concurrent freeing of
>> objects to those slabs. When no more slabs on partial lists are
>> available, it will allocate new slabs.
>> 
>> Finally, switch refill_sheaf() to use __refill_objects().
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slub.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 230 insertions(+), 5 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index a84027fbca78..e2b052657d11 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3508,6 +3511,69 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
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
>> +	/*
>> +	 * Racy check. If we mistakenly see no partial slabs then we
>> +	 * just allocate an empty slab. If we mistakenly try to get a
>> +	 * partial slab and there is none available then get_partial()
>> +	 * will return NULL.
>> +	 */
>> +	if (!n || !n->nr_partial)
>> +		return false;
>> +
>> +	INIT_LIST_HEAD(&pc->slabs);
>> +
>> +	if (gfpflags_allow_spinning(pc->flags))
>> +		spin_lock_irqsave(&n->list_lock, flags);
>> +	else if (!spin_trylock_irqsave(&n->list_lock, flags))
>> +		return false;
>> +
>> +	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
>> +		struct slab slab_counters;
>> +		unsigned int slab_free;
>> +
>> +		if (!pfmemalloc_match(slab, pc->flags))
>> +			continue;
>> +
>> +		/*
>> +		 * due to atomic updates done by a racing free we should not
>> +		 * read garbage here, but do a sanity check anyway
>> +		 *
>> +		 * slab_free is a lower bound due to subsequent concurrent
>> +		 * freeing, the caller might get more objects than requested and
>> +		 * must deal with it
>> +		 */
>> +		slab_counters.counters = data_race(READ_ONCE(slab->counters));
>> +		slab_free = slab_counters.objects - slab_counters.inuse;
>> +
>> +		if (unlikely(slab_free > oo_objects(s->oo)))
>> +			continue;
>> +
>> +		/* we have already min and this would get us over the max */
>> +		if (total_free >= pc->min_objects
>> +		    && total_free + slab_free > pc->max_objects)
>> +			continue;

Hmm I think I meant to have break; here. Should deal with your concern below?

>> +		remove_partial(n, slab);
>> +
>> +		list_add(&slab->slab_list, &pc->slabs);
>> +
>> +		total_free += slab_free;
>> +		if (total_free >= pc->max_objects)
>> +			break;
> 
> It may end up iterating over all slabs in the n->partial list
> when the sum of free objects isn't exactly equal to pc->max_objects?

Good catch, thanks.

>> +	}
>> +
>> +	spin_unlock_irqrestore(&n->list_lock, flags);
>> +	return total_free > 0;
>> +}
>> +
>>  /*
>>   * Try to allocate a partial slab from a specific node.
>>   */
>> @@ -4436,6 +4502,38 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
>>  	return freelist;
>>  }
>>  
>>  /*
>>   * Freeze the partial slab and return the pointer to the freelist.
>>   */
>> @@ -5373,6 +5471,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
>>  	return ret;
>>  }
>>  
>> +static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
>> +				   size_t size, void **p);
>> +
>>  /*
>>   * returns a sheaf that has at least the requested size
>>   * when prefilling is needed, do so with given gfp flags
>> @@ -7409,6 +7510,130 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
>>  }
>>  EXPORT_SYMBOL(kmem_cache_free_bulk);
>>  
>> +static unsigned int
>> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
>> +		 unsigned int max)
>> +{
>> +	struct slab *slab, *slab2;
>> +	struct partial_context pc;
>> +	unsigned int refilled = 0;
>> +	unsigned long flags;
>> +	void *object;
>> +	int node;
>> +
>> +	pc.flags = gfp;
>> +	pc.min_objects = min;
>> +	pc.max_objects = max;
>> +
>> +	node = numa_mem_id();
>> +
>> +	/* TODO: consider also other nodes? */
>> +	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
>> +		goto new_slab;
>> +
>> +	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>> +
>> +		list_del(&slab->slab_list);
>> +
>> +		object = get_freelist_nofreeze(s, slab);
>> +
>> +		while (object && refilled < max) {
>> +			p[refilled] = object;
>> +			object = get_freepointer(s, object);
>> +			maybe_wipe_obj_freeptr(s, p[refilled]);
>> +
>> +			refilled++;
>> +		}
>> +
>> +		/*
>> +		 * Freelist had more objects than we can accomodate, we need to
>> +		 * free them back. We can treat it like a detached freelist, just
>> +		 * need to find the tail object.
>> +		 */
>> +		if (unlikely(object)) {
>> +			void *head = object;
>> +			void *tail;
>> +			int cnt = 0;
>> +
>> +			do {
>> +				tail = object;
>> +				cnt++;
>> +				object = get_freepointer(s, object);
>> +			} while (object);
>> +			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
>> +		}
> 
> Maybe we don't have to do this if we put slabs into a singly linked list
> and use the other word to record the number of objects in the slab.

You mean we wouldn't have to do the counting? I think it wouldn't help as
the number could become stale after we record it, due to concurrent freeing.
Maybe get_freelist_nofreeze() could return it together with the freelist as
it can get both atomically.
However the main reason for the loop is is not to count, but to find the
tail pointer, and I don't see a way around it?

>> +
>> +		if (refilled >= max)
>> +			break;
>> +	}
>> +
>> +	if (unlikely(!list_empty(&pc.slabs))) {
>> +		struct kmem_cache_node *n = get_node(s, node);
>> +
>> +		spin_lock_irqsave(&n->list_lock, flags);
> 
> Do we surely know that trylock will succeed when
> we succeeded to acquire it in get_partial_node_bulk()?
> 
> I think the answer is yes, but just to double check :)

Yeah as you corrected, answer is no. However I missed that
__pcs_replace_empty_main() will only let us reach here with
gfpflags_allow_blocking() true in the first place. So I didn't have to even
deal with gfpflags_allow_spinning() in get_partial_node_bulk() then. I think
it's the simplest solution.

(side note: gfpflags_allow_blocking() might be too conservative now that
sheafs will be the only caching layer, that condition could be perhaps
changed to gfpflags_allow_spinning() to allow some cheap refill).


