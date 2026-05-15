Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 484B6CD4F47
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 17:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8521D6B0093; Fri, 15 May 2026 13:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8294F6B0095; Fri, 15 May 2026 13:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FC46B0096; Fri, 15 May 2026 13:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6267A6B0093
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:23:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECF3FC05DC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:46:23 +0000 (UTC)
X-FDA: 84770232246.18.B8A0215
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1901A1C000B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:46:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LgBuqkRO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3200HaggKCOoVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3200HaggKCOoVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778863582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0HQsDyo4+dkGqRSlyKJUkE9oJB6v6iQjX4Cvq2k71JY=;
	b=ebBWOgLmGOYpQRCiLnAxlC7aYmZoJ22CbuKVat+ynM35Gi+YclZ8XBNCI5fmlr47BrXnRj
	Gkp7BNxx7qvKpvrOPzCUc/Bp5DwLSK8rqeq5NBoKYMDYDELY9TJpGxjcG6R7qyXvYN4e4z
	GamY3xdj8AxeHv0/6gcKkOEpLPyoJCU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778863582; a=rsa-sha256;
	cv=none;
	b=Za5WgO+DvfeTgPOnhZHSfELZ0D3/juxXy5u+7OoPcwt5nI9yKbq5rYj+1yXbB6S4tjv8Km
	4zBkKxzkRjo+3FNsyjPsHfWkhxwQ8EEsHrNM+LtL/NBiS3KGTWRE+51wtGXUepjyzuzPZ/
	SR5ItDf1ZUTslYyhU9Ad14X0Tq4383s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LgBuqkRO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3200HaggKCOoVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3200HaggKCOoVMOWYMZNSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fdacf2616so56225e9.3
        for <linux-mm@kvack.org>; Fri, 15 May 2026 09:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778863580; x=1779468380; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0HQsDyo4+dkGqRSlyKJUkE9oJB6v6iQjX4Cvq2k71JY=;
        b=LgBuqkROe1nyULCVdaMBJzk8BbB9HI5YT6z6GELd2zYCHZ9S0LU+lbRGX1cviCkQwU
         yJz1hn+U4tKKxzcWJ3GTKUvxLue/q4YzXc1LBmc20kXqTBmOBSpUlq5OKta+/WZ6aOje
         s98+fXnjYfBflAFU9x4TobiOg8GKfeyhTvPYBpNY2ij0lh8ErUntomKCfUzFHRqVU2wR
         rpuBbS+bX7siuiCnY46DLE/dAVMH6mGi4MgIx4EAf4yc2rfYziyhn2qyRey9vBQHsi7Q
         uZx6zKH30fhVYDGJ24Tr0Rkc1D9N3HHrM6utVomDQo8v1+0MHdTVdGPx1+pX1RxZEit+
         3zXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778863580; x=1779468380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0HQsDyo4+dkGqRSlyKJUkE9oJB6v6iQjX4Cvq2k71JY=;
        b=OZkKuGfjtam5iEIDuXdmwUK1pwN3rQiQZgpGtWtM1lrXAzF/MJzFCnzJXFA7fRjTEM
         9IDbKudITR+EjI5BpeNfM20U9l5pTyf1G/YUcQwpWM9VWTxXFisxKo7skL45yqX5Nr7A
         NAIVefeEzOTEIkw+6uKkGMvUUFZdyW35TdQv8KmeYsOT81RI0ysHxk505FWHvLBQy9Gx
         jz539bVY4hfuLrjcVMrtwEaPcbUmBzw1kP2gRRFYnRQZISsP7HC527CbY6LNpeAlGA6v
         R4sQD9V7TWh2ANKBJcsWFfu0AW8gY2fbiw2LBrlXeCaejeteXHbDc/uc0/XkjEYoZ+1J
         FmFA==
X-Gm-Message-State: AOJu0YyARylFbZJSh6OjFhUIylc93Ots2I4HWhOfqYNsB2ju54JLp3yJ
	4rn1sWUybnMuwxcTVTczQrOotC+7+WjqD+o6IXsyPi6DUXDM0uHHmhlBqiJ2OqwToUY/upTwEQS
	9xwiYY/z+24X7VA==
X-Received: from wmjy18.prod.google.com ([2002:a7b:cd92:0:b0:48a:54ff:28c8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e87:b0:48a:768b:eea9 with SMTP id 5b1f17b1804b1-48fe60e51bamr73387595e9.4.1778863579933;
 Fri, 15 May 2026 09:46:19 -0700 (PDT)
Date: Fri, 15 May 2026 16:46:18 +0000
In-Reply-To: <7bfda0d8-2a7a-4337-8b55-d0c158df7839@kernel.org>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com> <7bfda0d8-2a7a-4337-8b55-d0c158df7839@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DIJEIELZ5DJU.26LYHOT4WR7A2@google.com>
Subject: Re: [PATCH v2 19/22] mm/page_alloc: implement __GFP_UNMAPPED allocations
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1901A1C000B
X-Stat-Signature: uadak5fhj7m85nwohzp645rdw576tmcm
X-Rspam-User: 
X-HE-Tag: 1778863581-222424
X-HE-Meta: U2FsdGVkX1+B0WMyk9ejz+Y3FGrtZTr/7fUAESpr3p6fTIyN1cy4oDS5BwbH07lvuW5OPziyxClEfV0q/jZGC7mOWhVeG3RZl7CjwgLs3hCI4Wh4wCx3IG4O/OWAhxSEqnzW2ZSFQO9puVvUNNyX8Fv0Oq+MMbDXD7KfLkYcNBIOc12T7RfW94XIpxXLFHkJC+r5b1juoOftalHXKWudDEx8PNb/RXNTe7L+Hh5WvXNnWFEBOmGT8wBOQZmM8lPGQ/tgDC9gnYLD7Bv3u5qRco+6N7yy3NjI6XVqWzMqIT8DUwQKfmJbHFW7tmD5g9IHufzJOYyut/f15niWb34nZ961Lhh/ZLlH954wPjhvUiCNw01vwlZFcbRQIefzsLW5nwoaasPD53Fk0AGUocPv0ZpRWx7KmvLSQfVRetTJZ2cuNzqVasuEsEg7mL9G4M5lz/1YfrmP5kZYzd46k3NeoZp9HnqtwOQMmwvu1so5luUSd+Ew6li4DYEMShQ7Q2iyNlWuvh9ZD38yV3uY/mFCp/vm2tXmmi/O0Kn+xNPbDp13jARTq32Rnn4fQBM4bC/kMfLhmmzexCFa5XXB78cNNJl8PoxiM9APocYAzn1ik0oSmszN3ehSAeyBo2lCabvSFCzOKOdMnqDaVXfpqVXladiElwol0DwQLuLm/30nV7GfNZUHIL9PLpgiA3En+1JOL7H5x9R+bkB1qmUP+fqHOSmyXHJ84jg5cmiEG6EeCr50UsHyrVU3ukwgljqd9h9VbOchqx+wrEZfHzsx5mr68VhlBXhoKO3s+aruHuU1GMxuNkcF9K3kU3PlpQQUP8dfdDiXlC1QNQ5hw8YSA8idhnHmUbhl7iBnE60V2aH+JVl+tPuc2agT5sjTrGcpZVfpM3Yi7dIiX8vEeuN6rE/AEwXHTmpqjzZ5RQMD/CEUU1jHbzqKLpnAugwTho9be9+2XRAUXmXe7uZG46N45Mi
 UVuZY1Ox
 AeJfz7Y3vsUQBLAl4YLuEZd1oPHGCUQPX1HleR+LwvYUW/qLtZqgYLrrjGc5aOnrE/+y9aPE+omrAbuzob6ahhl4j7ryH8wqEn91XGJn6sVzuSUqFsCiBCoXJBh4nAixz9VUg6HXM/vUfLwEnfpVT4jOiQ+yZVzNQIefjop2lvn1cvVvl/PEaEO/d3C5oyjIug8zKywq2dwgWpb5IyPt9pS9xLG3GMVPT/NASwwoerKZGOkc58wlxkOcyUC+C6t5jxnqOFp+TEAks1YK7mpm2eEGc6hG3ZSkbnoIkoc7vszI384752nH2tWwjQeuaVEYYi/nmLu9Vd9LQ70ynrOC9NJeZmOemTB9tGyeRTYAo3khu6n8xZCRKOBkIzYi9UHIDx+ooRQQ6yBzitrSywjYvw1wS11YLGj9ZQM4w+d0kJuCGTq1HWD6gZ+X/WMNPxUDWc3iPlJk170Ew1j/yTekg7uzZNcsQz7CAVXJcVJVpU5VtamuIi7KDVR/nnQC1DPwnvfg0Ig/Q+WVtbFpwOrTHm+CLacKYSQ08xwaTZels+EqBUT0M4hdeXpkeHksFDBR/y0CK4Z35vt/NH2Q5HUeoWk7XOQcULYeFu/xv7z+UQypl+ULH6/nEaNkw4LDkq9M8MiTsTiFOwgtxbI5crRWqzX8FflGsEfBvYahE6YWrw0r/zy5AdWS3rP7A80UYst3kb2BlJyjYszbxaAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 13, 2026 at 3:43 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 19:23, Brendan Jackman wrote:
>> Currently __GFP_UNMAPPED allocs will always fail because, although the
>> lists exist to hold them, there is no way to actually create an unmapped
>> page block. This commit adds one, and also the logic to map it back
>> again when that's needed.
>> 
>> Doing this at pageblock granularity ensures that the pageblock flags can
>> be used to infer which freetype a page belongs to. It also provides nice
>> batching of TLB flushes, and also avoids creating too much unnecessary
>> TLB fragmentation in the physmap.
>> 
>> There are some functional requirements for flipping a block:
>> 
>>  - Unmapping requires a TLB shootdown, meaning IRQs must be enabled.
>> 
>>  - Because the main usecase of this feature is to protect against CPU
>>    exploits, when a block is mapped it needs to be zeroed to ensure no
>>    residual data is available to attackers. Zeroing a block with a
>>    spinlock held seems undesirable.
>
> Did I overlook something or this patch doesn't do this whole block zeroing?
> Or is it handled by set_direct_map_valid_noflush itself?

Oops. At some point I was planning to defer the zeroing to another
series. I changed my mind about that but, apparently I forgot to
actually add the code back.

The code I deleted was in __rmqueue_direct_map() like this:

	if (want_mapped) {
		<zero the block>
	} else {
		unsigned long start = (unsigned long)page_address(page);
		unsigned long end = start + (nr_pageblocks << (pageblock_order + PAGE_SHIFT));

		flush_tlb_kernel_range(start, end);
	}

But actually I'm not sure that's what we want: At the moment, there's
actually a race condition when allocating __GFP_UNMAPPED|__GFP_ZERO:

1. Take page off freelist
2. Mermap it
3. Zero it
4. Mer-unmap it

I don't know, but some sort of CPU attack might support exploiting the
gap between 2 and 3 to leak any data left behind from a prior
allocation. (Like, maybe you can get the data into a uarch buffer during
the race window, then leak that data afterwards at leisure).

To mitigate that, we might want to effectively enforce
want_init_on_free() for unmapped blocks. And, if we do that, we
don't actually need to zero the block when flipping it back to mapped,
since there shouldn't be any user data in there.

Any thoughts on that? I have not tried to implement it yet, I might be
missing something that makes it impractical. Also I haven't read that
series that's doing zeroing through user addresses either, this might
have an interesting interaction with that.

>>  - Updating the pagetables might require allocating a pagetable to break
>>    down a huge page. This would deadlock if the zone lock was held.
>> 
>> This makes allocations that need to change sensitivity _somewhat_
>> similar to those that need to fallback to a different migratetype. But,
>> the locking requirements mean that this can't just be squashed into the
>> existing "fallback" allocator logic, instead a new allocator path just
>> for this purpose is needed.
>> 
>> The new path is assumed to be much cheaper than the really heavyweight
>> stuff like compaction and reclaim. But at present it is treated as less
>
> Uhh, speaking of compaction and reclaim... we rely on finding a whole free
> pageblock in order to flip it. If that doesn't exist, the whole
> get_page_from_freelist() will fail, and we might enter the
> reclaim/compaction cycle in __allow_pages_slowpath(). But since we might
> ultimately want an order-0 allocation, there won't be any compaction
> attempted, because that code won't know we failed to flip a pageblock. And
> the watermarks might look good and prevent reclaim as well I think? We
> should somehow indicate this, and handle accordingly. Might not be trivial.
> Or maybe reuse pageblock isolation code to do the migrations directly in
> __rmqueue_direct_map?

Ah, thanks, I suspect you are right.

I did fear there would be some sort of case where this "not-quite
reclaim" interacted badly with the actual reclaim, and I tried to test
it by running some stuff in parallel with stress-ng (allocating
__GFP_UNMAPPED via secretmem), and I didn't see a difference in the
effective availability of memory. However, I suspect testing this is
quite a deep art my "run these two commands that I copy pasted from an
LLM suggestion" test was just crap.

Do you have any workloads you can suggest for evaluating this kinda
thing? We would definitely see it in Google prod (I think we see this
kind of issue with our shrinker-based internal version of ASI distorting
reclaim behaviour in ways even more subtle than this) but that is not a
very practical experimental cycle...

>>  
>> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
>> +/* Try to allocate a page by mapping/unmapping a block from the direct map. */
>> +static inline struct page *
>> +__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
>> +		     unsigned int alloc_flags, freetype_t freetype)
>> +{
>> +	unsigned int ft_flags_other = freetype_flags(freetype) ^ FREETYPE_UNMAPPED;
>> +	freetype_t ft_other = migrate_to_freetype(free_to_migratetype(freetype),
>> +						  ft_flags_other);
>> +	bool want_mapped = !(freetype_flags(freetype) & FREETYPE_UNMAPPED);
>> +	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
>
> Why not RMQUEUE_CLAIM? We want to change the migratetype to ours as well,
> not just the unmapped flag?

Oh right, actually I think we need to do RMQUEUE_CLAIM _and_
RMQUEUE_NORMAL (or, some variant of RMQUEUE_CLAIM that also supports
allocating from blocks that already have the requested migratetype).

If we just switch it over to just RMQUEUE_CLAIM right now, while only
one migrateteype supports FREETYPE_UNMAPPED, I think that would actually
be broken: When allocating an unmapped block, (want_mapped=true) we
would always hit the freetype_idx<0 case in find_suitable_fallback().

But yeah we do need to do RMQUEUE_CLAIM too otherwise we'll miss
opportunities to allocate from other unmapped freetypes once those
exist.

>> +	unsigned long irq_flags;
>> +	int nr_pageblocks;
>> +	struct page *page;
>> +	int alloc_order;
>> +	int err;
>> +
>> +	if (freetype_idx(ft_other) < 0)
>> +		return NULL;
>> +
>> +	/*
>> +	 * Might need a TLB shootdown. Even if IRQs are on this isn't
>> +	 * safe if the caller holds a lock (in case the other CPUs need that
>> +	 * lock to handle the shootdown IPI).
>> +	 */
>> +	if (alloc_flags & ALLOC_NOBLOCK)
>> +		return NULL;
>> +
>> +	if (!can_set_direct_map())
>> +		return NULL;
>> +
>> +	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled));
>> +
>> +	/*
>> +	 * Need to [un]map a whole pageblock (otherwise it might require
>> +	 * allocating pagetables). First allocate it.
>> +	 */
>> +	alloc_order = max(request_order, pageblock_order);
>> +	nr_pageblocks = 1 << (alloc_order - pageblock_order);
>> +	zone_lock_irqsave(zone, irq_flags);
>> +	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
>> +	zone_unlock_irqrestore(zone, irq_flags);
>> +	if (!page)
>> +		return NULL;
>> +
>> +	/*
>> +	 * Now that IRQs are on it's safe to do a TLB shootdown, and now that we
>> +	 * released the zone lock it's possible to allocate a pagetable if
>> +	 * needed to split up a huge page.
>> +	 *
>> +	 * Note that modifying the direct map may need to allocate pagetables.
>> +	 * What about unbounded recursion? Here are the assumptions that make it
>> +	 * safe:
>> +	 *
>> +	 * - The direct map starts out fully mapped at boot. (This is not really
>> +	 *   an assumption" as its in direct control of page_alloc.c).
>> +	 *
>> +	 * - Once pages in the direct map are broken down, they are not
>> +	 *   re-aggregated into larger pages again.
>> +	 *
>> +	 * - Pagetables are never allocated with __GFP_UNMAPPED.
>> +	 *
>> +	 * Under these assumptions, a pagetable might need to be allocated while
>> +	 * _unmapping_ stuff from the direct map during a __GFP_UNMAPPED
>> +	 * allocation. But, the allocation of that pagetable never requires
>> +	 * allocating a further pagetable.
>> +	 */
>> +	err = set_direct_map_valid_noflush(page,
>> +				nr_pageblocks << pageblock_order, want_mapped);
>> +	if (err == -ENOMEM || WARN_ONCE(err, "err=%d\n", err)) {
>> +		zone_lock_irqsave(zone, irq_flags);
>> +		__free_one_page(page, page_to_pfn(page), zone,
>> +				alloc_order, freetype, FPI_SKIP_REPORT_NOTIFY);
>> +		zone_unlock_irqrestore(zone, irq_flags);
>> +		return NULL;
>> +	}
>> +
>> +	if (!want_mapped) {
>> +		unsigned long start = (unsigned long)page_address(page);
>> +		unsigned long end = start + (nr_pageblocks << (pageblock_order + PAGE_SHIFT));
>> +
>> +		flush_tlb_kernel_range(start, end);
>> +	}
>> +
>> +	for (int i = 0; i < nr_pageblocks; i++) {
>> +		struct page *block_page = page + (pageblock_nr_pages * i);
>> +
>> +		set_pageblock_freetype_flags(block_page, freetype_flags(freetype));
>> +	}
>> +
>> +	if (request_order >= alloc_order)
>> +		return page;
>> +
>> +	/* Free any remaining pages in the block. */
>> +	zone_lock_irqsave(zone, irq_flags);
>> +	for (unsigned int i = request_order; i < alloc_order; i++) {
>> +		struct page *page_to_free = page + (1 << i);
>> +
>> +		__free_one_page(page_to_free, page_to_pfn(page_to_free), zone,
>> +			i, freetype, FPI_SKIP_REPORT_NOTIFY);
>> +	}
>
> Could expand() be used here?

Hm, good point. It should probably look like what try_to_claim_block()
does...

Instead of figuring that out right now I'll just say this: if that works
I'll do it, if I find a reason why it doesn't I will add a comment
explaining it in the next version.

BTW my thinking is that clarity is the only important factor here, I am
confident that any speedup from this would disappear in the noise of the
TLB flushing etc. But, if it works then yeah I think it would actually
be clearer.

Thanks very much for this review, I really appreciate it!

