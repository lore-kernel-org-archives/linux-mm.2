Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A93D2D0E8
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD156B0005; Tue, 13 Jan 2026 08:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550B06B008A; Tue, 13 Jan 2026 08:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432306B008C; Tue, 13 Jan 2026 08:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0B46B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:09:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBD2F133D27
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:09:39 +0000 (UTC)
X-FDA: 84326972478.10.0FD221C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5B9C61A000F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:09:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=he4nxkmu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9INIt8ZC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L3MVY4Fs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="CU/L/Y80";
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768309777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIiny1vZ64O9oq3h+HMX+5IRUmdaD2DDrx5wZTHdXc0=;
	b=P9BY9vJnGsMbIBGOw62pNYA11W5D4RLbVGwF30Z/KaQWAtPxCYi1zPndssSldlF+1PBBqV
	igyqEBf3w6YS/7rSRfep6zHfPVGRQFAZvo+P/D6LLrjT5jPAAM4apwMvQKpW9e3ViwQ8Rs
	WsP4d8mOEwe74vsA+lbFCkFxJdbrEVY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=he4nxkmu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9INIt8ZC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L3MVY4Fs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="CU/L/Y80";
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768309777; a=rsa-sha256;
	cv=none;
	b=koAIE08MYJ1Z7xS8N7vPMuwp8Ah/ZitYCtHqxcbGGsJKOItE0ywXWg8/AhLusqfnj8no53
	G9KVyxgIcdSOmJrJOU0PybDmIZNXHxezlouCplz8mSYDXYdNiwu6lbqoyxTllPpCUwRVIw
	RAGdbRCBQqGSg3WELFfRk1U1Ntk/93A=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 996545BCCA;
	Tue, 13 Jan 2026 13:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768309775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIiny1vZ64O9oq3h+HMX+5IRUmdaD2DDrx5wZTHdXc0=;
	b=he4nxkmuWzN3/gfcDTtA+t3171gX7bx0foMZ8v6sFWmZixWVb542bQR/KZBnnLuyWBAIoj
	jE4vl7WFHp68g/VnDLVE/nacid69kbxFE1zb3V8RiA0RLSEA5y+FFojh23GAJhLX3kScl3
	/91qUVCiRqP4PNXe4yNjPmID429nq+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768309775;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIiny1vZ64O9oq3h+HMX+5IRUmdaD2DDrx5wZTHdXc0=;
	b=9INIt8ZC3kSlnuKdcRwKXXOeBbxYJ7TiVqdo7RD4yLmvmHdrEJQy2+StaVxMJ8SzHrXnxn
	fTf3kY8poQ6VGRAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768309774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIiny1vZ64O9oq3h+HMX+5IRUmdaD2DDrx5wZTHdXc0=;
	b=L3MVY4FsJrsDayEdRdXo/FC3Sc4zfufICzKTedm6Iml0u2C7jyuY9oQ0WfMwrIRJgl834+
	dhdgMrwskzQlNc5CneYWf34trey6UZqhgALCwvZPV7n9I/leLQH19yNz/55UwdVJXoDB5R
	eYkkzQId5poZaDgPvzJi7UTer5SEJQA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768309774;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zIiny1vZ64O9oq3h+HMX+5IRUmdaD2DDrx5wZTHdXc0=;
	b=CU/L/Y80jO8HWUI1QyzcAd6MMuC7un332e7lvk8MquLzhV5MRFzu4l0yah7Yv8c15MbIw0
	lYwGyulI8XablpCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 854E33EA63;
	Tue, 13 Jan 2026 13:09:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5ldRIA5EZmklfQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 13:09:34 +0000
Message-ID: <342a2a8f-43ee-4eff-a062-6d325faa8899@suse.cz>
Date: Tue, 13 Jan 2026 14:09:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 01/20] mm/slab: add rcu_barrier() to
 kvfree_rcu_barrier_on_cache()
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
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-1-98225cfb50cf@suse.cz>
 <aWWpE-7R1eBF458i@hyeyoo> <6e1f4acd-23f3-4a92-9212-65e11c9a7d1a@suse.cz>
 <aWY7K0SmNsW1O3mv@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <aWY7K0SmNsW1O3mv@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5B9C61A000F
X-Stat-Signature: kw4ip7thkot1eseh4ya33euumk75biir
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768309777-498916
X-HE-Meta: U2FsdGVkX1+UyaadEEXfV2emqYA6I9OepTFIoW2yiofd6QVSeivg7JZkhoANX0VHS5dqxrb3QM3WT/UnyABNp+GUMX4BgiPJz+vNnt+tR6LGp4fSPHSRKLd/paToSYqEuCzD95jHqN0kxOla9NiNtSKWWiTCyoptroGUhQ5EbfQDOeOamOc6/PudppcAUPzMjYjtE16LI2i3R0b8wSpyVbA7W1HDEUXOfcnuz9OM3/cfQXtpaR/Xqv0i1LiJTKgfNtZTWiQUmHIQttP8RyarDt/vUyG19dw4BMdnivyfqiA60s2qywCWQGuHCMKu0z9eKIdXuv/r+M5YTxIMuX/1uZMPmtXL1G+P18UYCt11rZp+GVf5nKr20jCwF74XoEpokRxPiDG7KuDEDDSvOBjtSDXaFnvaYU6U7Q6GlwACEkV0AqI7ZR6/FL/GqhLko1SK7TBA/2XLkatbFH5wnvejY9ztq1s4B7GIBNwK6NS7rsOwKJxHAAEiy6teGGm7sZgCYq+v7syNpEQy3StJGOunIyCPchg8HnBIvPDI3ibaWdxvVYgXmvCKe3fYTGDctllLKbMcu4EQNMTAfpwLHytkAL8CzwEQ+OUJ29ocVs2u4tFlwION6Hm8b+v8e+pyrIlfpQ5oMFqWeQP0idojpiRFo1fk8eEFDG9Ht36WM76lmZDdQcQnCiQrj7ZyfbhZ3ZEup9IQYk66GvODBQ9DWmeR5vtpxd7ZlRnj9GSgi+wtjehG+qeDQ3NMM9lubfDUekqeEhk0e/SE676ltBCiRzpWasLunEFwJS4vYmz5ZyRya3a+ZULxy2256Wze0bq7GYwAFbhu8LM8JmqPP75reJXUfjVRbv+Y4Bxpuj7VTcyrQq4xmkMdqVtW8tszLvIlfkYMsODSU40ChNLd6zHqIpUVL2NbBT/uMSW4pVCxbKVgIM6oUX0Tt077UpfGs5dea3Sl9AaElzUvBURHF/+BbFa
 eet5hpjT
 4F93zwxZAko4jgJzzbkmK4iXW57q5P8TFZE5WOsQgf2dh/6xzU0yjizjSBUnqyYfM+vslTuQK1CTa/atbQZYVMP9ZeCCK0qk53ojuectevP7vxtKrinKUCfh8/y7FbTnzBZwr5lxwFH8E3ywvuCWSxo1xSE6GmCrjA3fX/AD5tCNE31oGkidcljgSxjm178hFdLo+u2A/ad6TrINga7bPn0YAKSgBj3uU1OxhzAX8amfaUTpBcdlPe2lc4Vb6tRrruEETVU9U7ZdHzKDxA9k5ArSXpMFLc0sQPrg75q7vwXCYlViVABII5LoscAl7MvC3FvPuiqz0j4sF/QwRFFwXe684F1VOiwJXAVOnQwnL1lE7jdkJvk3Bh/VIsady3zP/wHnx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 1:31 PM, Harry Yoo wrote:
> On Tue, Jan 13, 2026 at 10:32:33AM +0100, Vlastimil Babka wrote:
>> On 1/13/26 3:08 AM, Harry Yoo wrote:
>>> On Mon, Jan 12, 2026 at 04:16:55PM +0100, Vlastimil Babka wrote:
>>>> After we submit the rcu_free sheaves to call_rcu() we need to make sure
>>>> the rcu callbacks complete. kvfree_rcu_barrier() does that via
>>>> flush_all_rcu_sheaves() but kvfree_rcu_barrier_on_cache() doesn't. Fix
>>>> that.
>>>
>>> Oops, my bad.
>>>
>>>> Reported-by: kernel test robot <oliver.sang@intel.com>
>>>> Closes: https://lore.kernel.org/oe-lkp/202601121442.c530bed3-lkp@intel.com
>>>> Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>>>> ---
>>>
>>> The fix looks good to me, but I wonder why
>>> `if (s->sheaf_capacity) rcu_barrier();` in __kmem_cache_shutdown()
>>> didn't prevent the bug from happening?
>>
>> Hmm good point, didn't notice it's there.
>>
>> I think it doesn't help because it happens only after
>> flush_all_cpus_locked(). And the callback from rcu_free_sheaf_nobarn()
>> will do sheaf_flush_unused() and end up installing the cpu slab again.
> 
> I thought about it a little bit more...
> 
> It's not because a cpu slab was installed again (for list_slab_objects()
> to be called on a slab, it must be on n->partial list), but because

Hmm that's true.

> flush_slab() cannot handle concurrent frees to the cpu slab.
> 
> CPU X                                CPU Y
> 
> - flush_slab() reads
>   c->freelist
>                                      rcu_free_sheaf_nobarn()
> 				     ->sheaf_flush_unused()
> 				     ->__kmem_cache_free_bulk()
> 				     ->do_slab_free()
> 				       -> sees slab == c->slab
> 				       -> frees to c->freelist
> - c->slab = NULL,
>   c->freelist = NULL
> - call deactivate_slab()
>   ^ the object freed by sheaf_flush_unused() is leaked,
>     thus slab->inuse != 0

But for this to be the same "c" it has to be the same cpu, not different
X and Y, no?
And that case is protected I think, the action by X with
local_lock_irqsave() prevents an irq handler to execute Y. Action Y is
using __update_cpu_freelist_fast to find out it was interrupted by X
messing with c-> fields.


> That said, flush_slab() works fine only when it is guaranteed that
> there will be no concurrent frees to the cpu slab (acquiring local_lock
> in flush_slab() doesn't help because free fastpath doesn't take it)
> 
> calling rcu_barrier() before flush_all_cpus_locked() ensures
> there will be no concurrent frees.
> 
> A side question; I'm not sure how __kmem_cache_shrink(),
> validate_slab_cache(), cpu_partial_store() are supposed to work
> correctly? They call flush_all() without guaranteeing there will be
> no concurrent frees to the cpu slab.
> 
> ...probably doesn't matter after sheaves-for-all :)
> 
>> Because the bot flagged commit "slab: add sheaves to most caches" where
>> cpu slabs still exist. It's thus possible that with the full series, the
>> bug is gone. But we should prevent it upfront anyway.
> 
>> The rcu_barrier() in __kmem_cache_shutdown() however is probably
>> unnecessary then and we can remove it, right?
> 
> Agreed. As it's called (after flushing rcu sheaves) in
> kvfree_rcu_barrier_on_cache(), it's not necessary in
> __kmem_cache_shutdown().
> 
>>>>  mm/slab_common.c | 5 ++++-
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>>>> index eed7ea556cb1..ee994ec7f251 100644
>>>> --- a/mm/slab_common.c
>>>> +++ b/mm/slab_common.c
>>>> @@ -2133,8 +2133,11 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>>>>   */
>>>>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>>>>  {
>>>> -	if (s->cpu_sheaves)
>>>> +	if (s->cpu_sheaves) {
>>>>  		flush_rcu_sheaves_on_cache(s);
>>>> +		rcu_barrier();
>>>> +	}
>>>> +
>>>>  	/*
>>>>  	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
>>>>  	 * on a specific slab cache.
> 


