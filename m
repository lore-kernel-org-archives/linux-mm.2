Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40FFAC5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 14:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC61D6B0377; Sat, 15 Aug 2026 10:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D276B0378; Sat, 15 Aug 2026 10:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9BD6B0379; Sat, 15 Aug 2026 10:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B788E6B0377
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:28:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EEA51A03ED
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:28:32 +0000 (UTC)
X-FDA: 85103734464.10.F34E6E5
Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	by imf11.hostedemail.com (Postfix) with ESMTP id E16A140004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 14:28:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LccT5TKV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786804110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgI0R75M/vliEV+knTawwtb0wMypqSB4Fv0BBMZZuwc=;
	b=GBColGkthL/DqGyK8ZFuL1OlO4rW1t6G4E9vk8w/eGf/HGraXMUaR8/JFTwX6Lu17hqDxK
	BnhME7uDH21xzbRbLIx8oyQgUI25Z9Wa9IR5o9Vv6q8cGxMfK3WIMBUX5/0LEcNE/pjesx
	WcI2/0xiHViIMft5o5CcNH9hmUFRLZ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LccT5TKV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.82 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786804110;
	b=8ISxRBlr2USPHr2QmUO7PFQOKhsroiDLm3rxc3jhIWITXa7Edl6BTL2qhyDsEtiYMtFjEy
	V9/8/bhj3CJlf1MF63ZGIs8rv9LxTOwA0HzHtm+0LjjqiJWu9HRNqw4nwHnq1FTy2PAmaJ
	YEVPzDoysGSyCCzCnQeShPFJrsErEys=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wptz7pbfxXelwLjsyLrsb4gBa8CCKoEKwLIMEkMPWy0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786804108; v=1; x=1787408908;
 b=LccT5TKVwsNxxKmWEGiTbR09kZsQWRA3+1J11ChNDZ89xF/+ggSL/zzGqQ0ThfFnG7/FwDVg
 F2oEX20Zw3K+XXrtkl970Txh0X07PzR7Wtv0+zS7O9y54SwQfafH11LaZt4kt0BLlyFr3CEquz2
 sSJWqgzReBKcIYdHAyzKefvc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 3f35d2d73d1366e7;
	Sat, 15 Aug 2026 14:28:28 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 15 Aug 2026 15:28:26 +0100
Message-Id: <DKPL6YQLP6NT.1747A5QR1D8VH@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anJ45UK0MWvskzlK@google.com>
In-Reply-To: <anJ45UK0MWvskzlK@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E16A140004
X-Rspamd-Server: rspam07
X-Stat-Signature: gys5aa8iutxqcnmkijge6qmpk8nx8ifc
X-HE-Tag: 1786804109-516540
X-HE-Meta: U2FsdGVkX1+euX97GCtw161dnfdWn2edVnYmVRwojmlxQmXun3eABmEOGFkfHRTREe1GjJyPVEgIZkuysNLCXNihKqujT8/WbJwQq5DOLMzOYaJR/000swJJAM2uY1New1nofF8VwP93o6iEEYI2KP+LdH4DYECLdTNPt293NdnmBkEgCD1Mi5yW3RO/NtsHLTT1vCnI1Jz+hQB5nZh7rx20G893G8MSjm0rtcHY22ttwsMzTE3EsubK0nZS2OCK7IYMhzJWpcqRsxDH93qp6gjY71AFyjY4uv/4Cp4LPhjvJhNGNZ0ktUgpO94HeLzqtdj30Q6XoIzoCTAZ0+lOLuD0LhrRbXhZl92YNoDTVEZrJVxvWFe5KPU+YvByU4YiO/JxScovlO5wqkpLtHSlY4hcfOKkbriCmS7JrgqYU/P3Fx7BkyEBK7fjn9KsY/PCia1fNyl6bP6Ka0ueRRZPyzqpueVrtZ4Y9Ewg3NM5SLUmgZ3Jr264lWqYUwvXKdygLa4Z1M8Q21mbGJg0rpGkATiVAxvVRwIz4bpiFmrWnET+WecJjCpaLwN+DoEScArBLMIOMXbzwSmgbnQAp/dtE7VZVXie5fksHnrz5vcnV7OKWuK8R/iJktuWAjId0YEk+5/VaJeuc8R5GCsJDD3KjJSGbKa9ObnJw8piO7iiYsFikxYKmtWtIkEaUmHP7x761KyjhEL6DIZ4LMoFZEgnq6osTVc/ilcazr5TBrFLPgMQyVrWe7+UYfEsLCTCnd23jNH3238TbvzAnMRcaD3UFhZprkkwPjn5RLMqmiqD7cTWdeYH6Kx3SrG40H6q3XFJcKDMYmY7860EsIfaCkfjIqPLnoPl9ySlodXt3PR9TgN+RNO1bGFwsjG8BlcFRosLuY4I+tLieq7oBw6dUiQaDVKN6J4eGoPD64DfZS26tj7iuVY0vsm22aBFIx6SvuBr+6jdtTEMhZyvaO5WxML
 A2I/F2W1
 mv7cHwStRrVObG5dVykxferXmt/o04f4YGuslIwEQ3Hl5efl8qGCF2QcdBxiScMGHcKRtMHIK+4FzAeNGPSkzlC5KESqvUw4jrfkjsCE23kq5KD7o0E2MPIJMAB20P/t3+Ixu/q5rcS5JoyXWTDa9bsXfofDtwRZgeeJMcCcCa7aV8C5uSTXp+JsJ6IRomc1YCN1JrhQzOzmAv2KXwec4/M7YLMwVcDgbeSHZDYv78eeF1fMGRH6xdA4U3aB//G0yfMJXAHdqiglyCcPIirnhAZqtbMrI4FHIiQ5HZqItPu3SMpsCwUPeWDFn2m9lKhIVYIl8iBj7iFc90s1zFcNqq9/2p/0ywNAELq8xA5VyQOQaA75ckpxY2tratFL8zChjW4vJYdf+rl37jQR8xJge8HQRGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 5, 2026 at 12:53 AM BST, Yosry Ahmed wrote:
>> @@ -3400,6 +3426,127 @@ static inline void zone_statistics(struct zone *=
preferred_zone, struct zone *z,
>>  #endif
>>  }
>> =20
>> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
>> +/* Try to allocate a page by mapping/unmapping a block from the direct =
map. */
>> +static inline struct page *
>> +__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
>> +		     unsigned int alloc_flags, freetype_t freetype)
>> +{
>> +	unsigned int ft_flags_other =3D freetype_flags(freetype) ^ FREETYPE_UN=
MAPPED;
>> +	freetype_t ft_other =3D migrate_to_freetype(free_to_migratetype(freety=
pe),
>> +						  ft_flags_other);
>> +	bool want_mapped =3D !(freetype_flags(freetype) & FREETYPE_UNMAPPED);
>> +	enum rmqueue_mode rmqm =3D RMQUEUE_NORMAL;
>> +	unsigned long irq_flags;
>> +	int nr_pageblocks, nr_freed;
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
>> +	if (!can_set_direct_map() || alloc_flags & ALLOC_NOLOCK)
>> +		return NULL;
>> +
>> +	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled))=
;
>> +
>> +	/*
>> +	 * Need to [un]map a whole pageblock (otherwise it might require
>> +	 * allocating pagetables). First allocate it.
>> +	 */
>> +	alloc_order =3D max(request_order, pageblock_order);
>> +	nr_pageblocks =3D 1 << (alloc_order - pageblock_order);
>> +	spin_lock_irqsave(&zone->lock, irq_flags);
>> +	/* First try a block that already has the right migratetype. */
>> +	page =3D __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
>> +	if (!page) {
>> +		/* Fallback to changing a block's migratetype. */
>> +		rmqm =3D RMQUEUE_CLAIM;
>> +		page =3D __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
>> +	}
>> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
>> +	if (!page)
>> +		return NULL;
>
> IIUC we only try to change an entire pageblock here, but what if we
> can't? If memory is fragmented enough that many pageblocks have few
> unmapped pages in them, how do we serve a mapped allocation (e.g. a slab
> allocation)?
>
> We'll go into reclaim/compaction, but there's a chance we'll end up with
> unexpected allocation failures or OOM kills even though we have free
> memory, because unmapped memory is not movable or reclaimable (as of
> now, at least).
>
> The same could happen if many pageblocks have few mapped but unmovable
> pages in them, and we make an unmapped allocation.

Yeah, although just to be clear: those unmovable/unreclaimable pages
are _already_ un{mov,reclaim}able, ALLOC_UNMAPPED doesn't change that.
So in the situation where they prevent compaction, we were already
somewhat in trouble re memory pressure. It's just that, with
ALLOC_UNMAPPED, the allocation failures can start hitting us for
lower-order allocations whereas before they only mattered for
higher-order ones.

How much worse is that? I'm not sure - my understanding from working
with GCE people was that if fragmentation prevents allocating hugetlb
pages for guest memory, yes in theory the system can fall back to base
pages, but in practice the perf hit from doing that is intolerable, i.e.
successful higher-order allocations are basically a hard requirement in
the real world already. Is that unique to GCE or are other workloads
like that too? I don't really know :/

The OTHER thing, trying to see this as zoomed-out as possible, is that
the "unmapped pages are un{mov,reclaim}able" thing is hopefully very
temporary? I'm pretty sure we want at least compaction for guest_memfd
[0]. If we extend ALLOC_UNMAPPED into any other areas I also expect that
to be the same. Secretmem is... well, whatever. So I think the "real"
fix is to support compaction.

[0]: https://lore.kernel.org/all/20260805-shivank-gmem-migrate-v3-9-00d8bde=
c4e1d@amd.com/

> I wonder if we still need a fallback case where a pageblock contains a
> mix of mapped and unmapped pages. We need to carefully handle such
> pageblocks:
> - For unmapped allocations, we need to unmap the relevant PTEs and
>   potentially do a TLB shootdown (if they were previously mapped). Maybe
>   we should always flush the TLB for simplicity for now.
> - For mapped allocations, we need to map the relevant PTEs. No TLB
>   shootdown should be needed.
>
> Assuming unmapped allocations are always zeroed by the users on alloc
> and free, we don't need to worry about zeroing pages either way.
>
> We may want to track the number of unmapped pages in such page blocks to
> now when it's fully mapped or fully unmapped and change its type, but
> maybe this can be a followup if needed.

... However, yes this might be unavoidable despite what I said above.
This was also DavidH's feeling when I chatted to him a few months back.
The hard parts of it are a) the tracking as you hinted at and b) in the
general case that means allocating pagetables.=20

So yeah I think it's probably doable but I _really_ want to avoid doing
it in this series if we possibly can.

