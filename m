Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5BF5CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BDE8E0019; Thu,  6 Nov 2025 09:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233418E0002; Thu,  6 Nov 2025 09:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149B38E0019; Thu,  6 Nov 2025 09:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 05FCD8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:27:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFD55C0116
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:27:40 +0000 (UTC)
X-FDA: 84080410680.27.7DBB5BF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1F304180011
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:27:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UM6v927M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NYryjSG6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UM6v927M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NYryjSG6;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762439258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzExTjpfTe0MsCrHd3btlVc/M393MGUafFxJXP1rOqU=;
	b=a7kU5BULTzqZdzDyC1JRoj0dvwaCe2qZ/13ZRcIUfeTti6mcs/KRwQR1aoT7xAaWwF4UOh
	tgVxNnQjWW6EPEhslVR18NxGN1f7Xu7tbzOCv3sx1ZlU+jMEncwPzoAF85VxL+7fuI/zAx
	/dUcqzMuuXh+D8tLpNf69T709hjNOhk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UM6v927M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NYryjSG6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UM6v927M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NYryjSG6;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762439258; a=rsa-sha256;
	cv=none;
	b=4D92KLXccpSVI6dCJ9pMZARl0oGcsyQlZ9UzDzSby/3mESjStzqeU1XBwFJd+gxC0ctvcX
	hoDkKNj+NvzEIIrLzxobTXN723w+7XG9iM29WLyR4RrwQ5rTQXQC9GOPfaq8zzfafc0uwY
	csrx0zgriVxirT2emChOyEZhwybA35c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5443E1F74C;
	Thu,  6 Nov 2025 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762439256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hzExTjpfTe0MsCrHd3btlVc/M393MGUafFxJXP1rOqU=;
	b=UM6v927MK9uy2gtWMa+VPRbV9jxn9KMXFoJmYRZtoQT0VdcNDppl1lRFLNJEmk6CsEZXLd
	0UtqFjt+CWWOgnfQG+OE6P0bm5+DeYrTbB/rACcPznkCPRcoRjMjsRgPAWsVg3fGj/uxkZ
	1Nm3Y6NlPiHFaSYoM3wynWWyJ+aPG48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762439256;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hzExTjpfTe0MsCrHd3btlVc/M393MGUafFxJXP1rOqU=;
	b=NYryjSG67m2GfIiui/LExEukeoRnUvrs0IPvhv1pO9QH47IQKpKQdFWMrYkZ2IBWXrcO5A
	RtL5OZHczIhKNDDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762439256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hzExTjpfTe0MsCrHd3btlVc/M393MGUafFxJXP1rOqU=;
	b=UM6v927MK9uy2gtWMa+VPRbV9jxn9KMXFoJmYRZtoQT0VdcNDppl1lRFLNJEmk6CsEZXLd
	0UtqFjt+CWWOgnfQG+OE6P0bm5+DeYrTbB/rACcPznkCPRcoRjMjsRgPAWsVg3fGj/uxkZ
	1Nm3Y6NlPiHFaSYoM3wynWWyJ+aPG48=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762439256;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hzExTjpfTe0MsCrHd3btlVc/M393MGUafFxJXP1rOqU=;
	b=NYryjSG67m2GfIiui/LExEukeoRnUvrs0IPvhv1pO9QH47IQKpKQdFWMrYkZ2IBWXrcO5A
	RtL5OZHczIhKNDDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 35FCF13A31;
	Thu,  6 Nov 2025 14:27:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ihm5C1iwDGmARAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 14:27:36 +0000
Message-ID: <b950d1a9-3686-4adc-ac2d-795b598ff1a5@suse.cz>
Date: Thu, 6 Nov 2025 15:27:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-mm@kvack.org
References: <20251031093517.1603379-1-hch@lst.de>
 <20251031093517.1603379-4-hch@lst.de>
 <1fff522d-1987-4dcc-a6a2-4406a22d3ec2@suse.cz>
 <20251106141306.GA12043@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251106141306.GA12043@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1F304180011
X-Stat-Signature: c1bbk37tsiqqn3thtsu8o5raueubtxzf
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762439257-727465
X-HE-Meta: U2FsdGVkX193wBah7IS17kPI5UbC9afOjv02NBAyHoVBJTvWgvdm0XdtCi61iazNrzB31YHZVp71kzc7nVVHMjJekjkh59TqymllC83/GlwyZaM0880O7TfjUIcgLWH3LY4yXrJStJzBMbTyseckrCn4BoyQNbA955TnZewlM6RZgx20UNwPwvZgD13eqZSfRPY6zBBbS1I+CJENrxqfrgaNgLqQNbYfJGVZ8sJRF+pwBNdsslvR50pVmCHt7pUzjMU8xrILNsGGzX86sclslhDhUcVAHzlcxXEI5aNuN1IIN+YsdWe1YjjEMb1hKJJ1kW2aSKzaKxjqyALhSgzNxgBEYGjw/dGltgmE5sW/wKtSWxeY5MZo2PzZuyb6c3PHYNHeuze53M6kXgdbQd76Bk66mcL9OBBaxZSAY2hMoIrYgw6HsZYphi/T3tKxxqxd3nGVN3tY1KhLGKWu9gE0tUdXlwXir8W+39U5Wdv01XCjXTXstQqDqotFvTA0bLJ8279AIrghFyvQJI6qXxcM5x2nCi/y6fF3Z4OrrML9R+TBTd7+Ds/DBYWbubJbfSiAq5GAl2Ju0Wg2tp4IfgnpRoRYUjBCnLzreHRntsl3mNNWILw23NmEu68Z1k7Qd/y9b8Xm1bcVwGz8PrCBDS3HXiVnDOja/yFVdHQqNjcjIACd3OWeb9BdrnjEs3QrDNCKFLrvCmKJwYth1ksG+7BguxPLKOcJvKOwDKU2pu+10D1JdZnBTXb1+bJQofNf0v3eZRfd62+3Y7JNHwTJ8WDH/CLUBK2DXqVQB1l4fPHZqAfTUPRKJKg/khfBOHOFC1hHVCPuhglH122wh5NgI/uig/VeNkMfS3cI1VAyfW97PslLzfCSTsl6vo3grbkiOBPvbNdu8hwjpOy/RDJR4Mc+QlF4C9e4QBtYaBDsf4P08WuAz1hwjCNNy9AYvrsnVV0QHglVZlUUojd6I1e9E1L
 TuA3xnTc
 VQLfWbsCwAe5j4Qw1h19UbvgodU0uymsExkFlDkKAdKnGC2NdldxP1rfGKCoES9Po57bpA8y4beFxUkbvuztZOeOIz8r84ofA15jCyUU0oY/PQ89ItyD8Vmh00Je+JXUcnGvT+iJnsERaNkaclZEDyiPeptQtXSAsNBFKe75YhJ3Hy0aAhGuHHDYqdxBhcQqOP/DXGjaOMzkz07EShqUd4xWohOyu3rMcWZpcn3NY8rbo7fu24vMZMdk7fFdn9e2/uWrA2MXhFE5tczYvDXm2yfB25C4vpXcZZoovyG+PMTyc1KExmEhUFw4A/lyEXSHttVGI3Qu77X4UDuw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/6/25 15:13, Christoph Hellwig wrote:
> On Wed, Nov 05, 2025 at 04:04:53PM +0100, Vlastimil Babka wrote:
>> > +	for (; i < count; i++) {
>> > +		if (!elem[i]) {
>> > +			if (should_fail_ex(&fail_mempool_alloc, 1,
>> > +					FAULT_NOWARN)) {
>> > +				pr_info("forcing pool usage for pool %pS\n",
>> > +					(void *)caller_ip);
>> > +				goto use_pool;
>> > +			}
>> 
>> Would it be enough to do this failure injection attempt once and not in
>> every iteration?
> 
> Well, that would only test failure handling for the first element. Or
> you mean don't call it again if called once?

I mean since this is (due to the semantics of mempools) not really causing a
failure to the caller (unlike the typical failure injection usage), but
forcing preallocated objecs use, I'm not sure we get much benefit (in terms
of testing caller's error paths) from the fine grained selection of the
first element where we inject fail, and failing immediately or never should
be sufficient.

>> >  	/*
>> > @@ -445,10 +463,12 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
>> >  	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
>> >  	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
>> >  		spin_unlock_irqrestore(&pool->lock, flags);
>> > -		return NULL;
>> > +		if (i > 0)
>> > +			mempool_free_bulk(pool, elem + i, count - i);
>> 
>> I don't understand why we are trying to free from i to count and not from 0
>> to i? Seems buggy, there will likely be NULLs which might go through
>> add_element() which assumes they are not NULL.
> 
> Yes, this looks like broken copy and paste.  The again I'm not even
> sure who calls into mempool without __GFP_DIRECT_RECLAIM reset, as
> that's kinda pointless.

Hm yeah would have to be some special case where something limits how many
such outstanding allocations can there be, otherwise it's just a cache to
make success more likely but not guaranteed.

>> Assuming this is fixed we might still have confusing API. We might be
>> freeing away elements that were already in the array when
>> mempool_alloc_bulk() was called. OTOH the pool might be missing less than i
>> elements and mempool_free_bulk() will not do anything with the rest.
>> Anything beyond i is untouched. The caller has no idea what's in the array
>> after getting this -ENOMEM. (alloc_pages_bulk() returns the number of pages
>> there).
>> Maybe it's acceptable (your usecase I think doesn't even add a caller that
>> can't block), but needs documenting clearly.
> 
> I'm tempted to just disallow !__GFP_DIRECT_RECLAIM bulk allocations.
> That feature seems to being a lot of trouble for no real gain, as
> we can't use mempool as a guaranteed allocator there, so it's kinda
> pointless.

Agree. If anyone comes up with a use case they can extend and actually test
these rollback paths.

>> So in theory callers waiting for many objects might wait indefinitely to
>> find enough objects in the pool, while smaller callers succeed their
>> allocations and deplete the pool. Mempools never provided some fair ordering
>> of waiters, but this might make it worse deterministically instead of
>> randomly. Guess it's not such a problem if all callers are comparable in
>> number of objects.
> 
> Yeah, which is the use case.

Good.

>> >   * This function only sleeps if the free_fn callback sleeps.
>> 
>> This part now only applies to mempool_free() ?
> 
> Both mempool_free and mempool_free_bulk.

But mempool_free_bulk() doesn't use the callback, it's up to the caller to
free anything the mempool didn't use for its refill.



