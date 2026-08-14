Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA601C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D576B0303; Fri, 14 Aug 2026 08:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6176B069E; Fri, 14 Aug 2026 08:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6039C6B069F; Fri, 14 Aug 2026 08:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35C8F6B0303
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:31:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 996D71602DB
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:31:28 +0000 (UTC)
X-FDA: 85099810656.02.18AFDA6
Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22DEE18000E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:31:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W/w2rW4p";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786710686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXOgeYwzbGgYvPyAG/0+VXSIgnH8IMwccTWvuqpNc9Q=;
	b=ToBiDS+Tknktdr3v8LjNEcxKQVj/BhmhHM43cLWezQjmvNrlpwIYqFvgsOS6IvoI17bULS
	9gbLrEQ8NkoPPlC0OzMl6VGqgd/F0t9XKrjdJvZFJwuWyNbz5RS/dJ133AV0w5cYdbVako
	FGaeakPqLdkNt95xeVwbeLMs6+F+UUA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W/w2rW4p";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786710686;
	b=lrP0EPwN8GvzsOc9woD+cIKxyEGlxH2Kr5B38PofJ0mqGRtZFFhAjapvrj3gmEqUfwK6dB
	yax/3Z7F2hcEr5aR7sBZwVQkGT/ht2nhBaRh8AoEXAMPLeLrLH9K/sAaeI+OybKZcbaQpN
	W8NJt9N9e8JtO15h3mJQaKUM6CtSmUA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rnrRWzbRgf3HtNAFJ/URJsD3/yE/SVL7fKG74rTrmYI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786710684; v=1; x=1787315484;
 b=W/w2rW4pK+yhwf1OJ0fpPek7hAde0PT4vxsE0sn+F12DPepk1a4tiVo6jxoTOcRd15MXqXLx
 d7lYxISGXVgq+1uAFN7ji+wL5bXlcPtxeBU/rb1VP7cueM8dsM2SRk/hsBQfYanI2YU+7ZbXXzu
 tihy96H3mTr8Cl78zP05Rs+U=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 2309f6b155db51af;
	Fri, 14 Aug 2026 12:31:24 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 13:31:23 +0100
Message-Id: <DKOO2SP5DOCP.1H09TE8XC0D5G@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>
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
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <anJylMTl6GeM8OHx@google.com>
In-Reply-To: <anJylMTl6GeM8OHx@google.com>
X-Rspam-User: 
X-Stat-Signature: x8zpa5yzmqnpo56s4jxxgxeg54a9io17
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 22DEE18000E
X-HE-Tag: 1786710685-127730
X-HE-Meta: U2FsdGVkX196Vd5HegN5Pr996mcfi4AUu+UK6/9L75SvFxxjGy9EDToO3CS9uNtiR24UuLGYlmAQU4l0PeRh1h+FN4ccKPU0fMWWd6rFV9eHmoytKQw733ggvyBxwoHJRpDPoqLVJUDv2jdEUsGRySM7Ia1nqrXp2d2ARXyHvdMXCcy41liKQrAN/+CBXZrO/XIWPlNruuuPatFCYIXBlJ/sZrNWEQ8tu6vgquI2JYtIq5QNLMnerLbNv/A5YiI/Qbg4lWPQJhqjgj9fvRVKVuIicvLlnta9+nrLrqZ18jOXNThHq/iBGhEuVKDZwRI9yE2LFavDLhCEDgtFX96d9ohephptY8wlu7NlATH98301QHo68ya6GuORqsdakTyli03I0fMIZPU8fljgDlyl5YRJeZo0Tb1ihhoAdlxXqAK8YYSgyd3bZBwf6sDhqh/J1CTyq/FR/Ld5defYtTB0zSWvWaKQMJdCbMKUjd/VseOyZ8MzKBRiIqyZnX0laqTqjGxVvjAciFSFTQgN3H0L9lB5Nu//Wt+uchnaBGnwBRyyQv4yWqktLYjaDiJxaxPXQED9xxdg+lpDR60Y16MlsGiulaVIDkNU/kTqdS1LpScsSBFFPDpSlI1CtSjPF39UxVbR6YjHXL4ecXd+RJqHZAfs2IMmKKaErInH9ntfIFYCAzyF6tbK7VUh4nS7vrutbZy8lEisf2Kzzlds3JEIqmuKGwOFnz3ZIN6PykMXyKzcW8dqD7Q4CFNJ9sEeJ1zQMcnnBR3Lnn1S3l9ALyb5dmyPfDyn+bppJak/ISyGolGNrwvUPvG2iDftuX3cdClF236cbeMYskhz3r4cUO9byODZ7R8gCZ/sQd+tpazg2RX4TN1ElaxZjeOVIIQafkwfBUsOwuELy6Bdb+XVr+XFsOqztsWpK1VaE8EEdyhip83OnQ+f8d00D0Ckt1l+xMBnPCBKbZ0R6BzbTDuAJS4
 ZXvsJJFo
 MZ7sfHeGAuiQwSidq2OQ5rPoGJaxytvydP7gtFBQDvAMEGfmu5dM3ii9WRRgwl2629X3YXZ9GiR7gafeCqo6DiSdOgHZfz31SsQ4A5lIjbw5N4JI9YYr/7aHyCxSQBMPOtCvMMhWLAPHNO/rKa82yEIaaMmrt2ZjqVj/gkhU4l+T5PWDNhhH++4EUth+rva/f2ozGypGQMJ4dHiAFpZ2hAGQbQs/Szjynyq3VNnqPdLxLbThs5uDL3/WrAABafHaWjYMPOSC5FPpxUJNe5TxKeg12McVLDLRAuTnezvC4e2h4hI2T0eGRbxi5EPfYAZCPHd7xVGetZPb6iSgRJW/hkb5BXJ9ohgCPbzyPYrUFORd2sIh9rmuW8M9Nh1XLtPcaGJBj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 5, 2026 at 12:41 AM BST, Yosry Ahmed wrote:
> On Sun, Jul 26, 2026 at 10:22:54PM +0000, Brendan Jackman wrote:
>> Currently FREETYPE_UNMAPPED allocs will always fail because, although th=
e
>> lists exist to hold them, there is no way to actually create an unmapped
>> page block. This commit adds one, and also the logic to map it back
>> again when that's needed.
>>=20
>> Doing this at pageblock granularity ensures that the pageblock flags can
>> be used to infer which freetype a page belongs to. It also provides nice
>> batching of TLB flushes, and also avoids creating too much unnecessary
>> TLB fragmentation in the physmap.
>>=20
>> There are some functional requirements for flipping a block:
>>=20
>>  - Unmapping requires a TLB shootdown, meaning IRQs must be enabled.
>>=20
>>  - Updating the pagetables might require allocating a pagetable to break
>>    down a huge page. This would deadlock if the zone lock was held.
>
> We also need to zero unmapped/sensitive pages before mapping them again,
> but seems like the current approach is to differ this to the caller,
> which makes sense. The only annoying part is that
> want_init_on_{free/alloc}() now silently skip the zeroing for those
> pages.

This does look annoying but I think it's actually all fine and correct.

- It's forbidden to allocate with ALLOC_UNMAPPED and __GFP_ZERO, so the
  __GFP_ZERO part of want_init_on_alloc() is still correct under
  ALLOC_UNMAPPED.

- I think init_on_alloc's job is kernel hardening, i.e. it's a roadbump
  for kernel exploit authors. If you have a bug that lets you read some
  uninitialised memory via the kernel then init_on_alloc means you see
  zeroes. But those vulns are automatically mitigated by ALLOC_UNMAPPED
  anyway so this is fine.

- There is a very strong ambient rule that you must ensure memory is
  zeroed before mapping it into userspace/VMs, but this is totally
  separate from init_on_alloc. And it's fine for filesystems or whatever
  to implement this however they want, __GFP_ZERO is just one way they
  can do it.

  This rule is totally separate from init_on_alloc, if you break it you
  are immediately creating a vulnerability instead of just a second-
  order weakness.

> We should document somewhere that the users of ALLOC_UNMAPPED are
> responsible for zeroing memory before freeing it?

So, no I don't think we need to document that, we just need to make sure
that the __GFP_ZERO restriction is clear.

> The current users currently always zero the pages on allocation as well,
> I am not sure if this should also be a general requirement, or perhaps
> only if want_init_on_alloc() is set?

>> This makes allocations that need to change sensitivity _somewhat_
>
> s/sensitivity/direct mapping status (or sth)?

Oops thanks.

>> similar to those that need to fallback to a different migratetype. But,
>> the locking requirements mean that this can't just be squashed into the
>> existing "fallback" allocator logic, instead a new allocator path just
>> for this purpose is needed.
>>=20
>> The new path is assumed to be much cheaper than the really heavyweight
>> stuff like compaction and reclaim. But at present it is treated as less
>> desirable than the mobility-related "fallback" and "stealing" logic.
>> This might turn out to need revision (in particular, maybe it's a
>> problem that __rmqueue_steal(), which causes fragmentation, happens
>> before __rmqueue_direct_map()), but that should be treated as a subseque=
nt
>> optimisation project.
>>=20
>> Adding alloc_flags to gfp_freetype() requires moving it to
>> mm/page_alloc.h so it can refer to ALLOC_UNMAPPED. It was already only
>> used in internal mm code.
>>=20
>> Now that unmapped pageblocks actually exist, exclude them from
>> migration. Migrating unmapped pages via the mermap should be possible
>> but that's something to be added later when needed.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> [..]
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
>
> Should we only check this if !want_mapped? IIUC we only need a TLB
> shootdown when unmapping.

Hm, I don't think we wanna zero a pageblock with IRQs off. The comment
should reflect that though.

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
>
> IIUC, this is called after __rmqueue() will have already failed in the
> caller with request_order (a potentially smaller order), so why are we
> trying this again here?

The __rmqueue() that failed was with the opposite value of
FREETYPE_UNMAPPED.

>> +	if (!page) {
>> +		/* Fallback to changing a block's migratetype. */
>> +		rmqm =3D RMQUEUE_CLAIM;
>> +		page =3D __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
>> +	}
>> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
>> +	if (!page)
>> +		return NULL;
>> +
>> +	/*
>> +	 * Now that IRQs are on it's safe to do a TLB shootdown, and now that =
we
>> +	 * released the zone lock it's possible to allocate a pagetable if
>> +	 * needed to split up a huge page.
>> +	 *
>> +	 * Note that modifying the direct map may need to allocate pagetables.
>> +	 * What about unbounded recursion? Here are the assumptions that make =
it
>> +	 * safe:
>> +	 *
>> +	 * - The direct map starts out fully mapped at boot. (This is not real=
ly
>> +	 *   an "assumption" as it's in direct control of page_alloc.c).
>> +	 *
>> +	 * - Once pages in the direct map are broken down, they are not
>> +	 *   re-aggregated into larger pages again.
>> +	 *
>> +	 * - Pagetables are never allocated with ALLOC_UNMAPPED.
>> +	 *
>> +	 * Under these assumptions, a pagetable might need to be allocated whi=
le
>> +	 * _unmapping_ stuff from the direct map during an ALLOC_UNMAPPED
>> +	 * allocation. But, the allocation of that pagetable never requires
>> +	 * allocating a further pagetable.
>> +	 */
>> +	err =3D set_direct_map_valid_noflush(page,
>> +				nr_pageblocks << pageblock_order, want_mapped);
>> +	if (err =3D=3D -ENOMEM || WARN_ONCE(err, "err=3D%d\n", err)) {
>> +		set_direct_map_valid_noflush(page,
>> +				nr_pageblocks << pageblock_order, !want_mapped);
>> +		spin_lock_irqsave(&zone->lock, irq_flags);
>> +		/* Important: free using _old_ freetype. */
>> +		__free_one_page(page, page_to_pfn(page), zone,
>> +				alloc_order, ft_other, FPI_SKIP_REPORT_NOTIFY);
>> +		spin_unlock_irqrestore(&zone->lock, irq_flags);
>> +		return NULL;
>> +	}
>> +
>> +	if (want_mapped) {
>> +		/* Exposing formerly-protected data; scrub it. */
>> +		clear_highpages_kasan_tagged(page, nr_pageblocks << pageblock_order);
>
> Shouldn't all unmapped memory be zeroed on free? If we solidify this
> assumption we can probably drop this here (and maybe replace it with an
> assertion)?

Hm, that's true. I guess just a question of whether we do indeed want to
make that a hard rule for ALLOC_UNMAPPED. I'm not too sure about that, I
only really added that unconditional zeroing because I wanted to keep
the prior behaviour of secretmem/GUEST_MEMFD_FLAG_NO_DIRECT_MAP, but
maybe it's undesirable to place such a big burden on ALLOC_UNMAPPED? It
would be nice to be able to easily expand this into more
direct-map-killing behaviour...

>> +	} else {
>> +		unsigned long start =3D (unsigned long)page_address(page);
>> +		unsigned long end =3D start + (nr_pageblocks << (pageblock_order + PA=
GE_SHIFT));
>> +
>> +		flush_tlb_kernel_range(start, end);
>> +	}
>> +
>> +	for (int i =3D 0; i < nr_pageblocks; i++) {
>> +		struct page *block_page =3D page + (pageblock_nr_pages * i);
>> +
>> +		set_pageblock_freetype_flags(block_page, freetype_flags(freetype));
>> +	}
>> +
>> +	if (request_order >=3D alloc_order)
>> +		return page;
>> +
>> +	/* Free any remaining pages in the block. */
>> +	spin_lock_irqsave(&zone->lock, irq_flags);
>> +	nr_freed =3D expand(zone, page, request_order, alloc_order, freetype);
>> +	account_freepages(zone, nr_freed, free_to_migratetype(freetype));
>> +	spin_unlock_irqrestore(&zone->lock, irq_flags);
>> +
>> +	return page;
>> +}
>> +#else /* CONFIG_PAGE_ALLOC_UNMAPPED */
>> +static inline struct page *__rmqueue_direct_map(struct zone *zone, unsi=
gned int request_order,
>> +				unsigned int alloc_flags, freetype_t freetype)
>> +{
>> +	return NULL;
>> +}
>> +#endif /* CONFIG_PAGE_ALLOC_UNMAPPED */
>> +
>>  static __always_inline
>>  struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zo=
ne,
>>  			   unsigned int order, unsigned int alloc_flags,
>> @@ -3433,13 +3580,15 @@ struct page *rmqueue_buddy(struct zone *preferre=
d_zone, struct zone *zone,
>>  			 */
>>  			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_HARDER)))
>>  				page =3D __rmqueue_smallest(zone, order, ft_high);
>> -
>> -			if (!page) {
>> -				spin_unlock_irqrestore(&zone->lock, flags);
>> -				return NULL;
>> -			}
>>  		}
>>  		spin_unlock_irqrestore(&zone->lock, flags);
>> +
>> +		/* Try changing direct map, now we've released the zone lock */
>> +		if (!page)
>> +			page =3D __rmqueue_direct_map(zone, order, alloc_flags, freetype);
>> +		if (!page)
>> +			return NULL;
>> +
>>  	} while (check_new_pages(page, order));
>> =20
>>  	/*
>> @@ -3660,6 +3809,8 @@ static void reserve_highatomic_pageblock(struct pa=
ge *page, int order,
>>  		return;
>> =20
>>  	ft_high =3D freetype_with_migrate(ft, MIGRATE_HIGHATOMIC);
>> +	if (freetype_idx(ft_high) < 0)
>> +		return;
>
> Does this belong in "mm/page_alloc: add support for freetypes with no
> freelist"?
>
>>  	if (order < pageblock_order) {
>>  		if (move_freepages_block(zone, page, ft, ft_high) =3D=3D -1)
>>  			return;
>> @@ -3975,13 +4126,15 @@ alloc_flags_nofragment(struct zone *zone, gfp_t =
gfp_mask)
>>  }
>> =20
>>  /* Must be called after current_gfp_context() which can change gfp_mask=
 */
>> -static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
>> +static inline unsigned int alloc_flags_cma(gfp_t gfp_mask, unsigned int=
 alloc_flags)
>>  {
>>  #ifdef CONFIG_CMA
>> -	if (free_to_migratetype(gfp_freetype(gfp_mask)) =3D=3D MIGRATE_MOVABLE=
)
>> -		return ALLOC_CMA;
>> +	if (free_to_migratetype(gfp_freetype(gfp_mask, alloc_flags)) =3D=3D MI=
GRATE_MOVABLE)
>> +		alloc_flags |=3D ALLOC_CMA;
>>  #endif
>> -	return ALLOC_DEFAULT;
>> +	alloc_flags |=3D ALLOC_DEFAULT;
>> +
>> +	return alloc_flags;
>>  }
>> =20
>>  /*
>> @@ -4770,7 +4923,7 @@ alloc_flags_slowpath(gfp_t gfp_mask, unsigned int =
order)
>>  	} else if (unlikely(rt_or_dl_task(current)) && in_task())
>>  		alloc_flags |=3D ALLOC_MIN_RESERVE;
>> =20
>> -	alloc_flags |=3D alloc_flags_cma(gfp_mask);
>> +	alloc_flags =3D alloc_flags_cma(gfp_mask, alloc_flags);
>> =20
>>  	if (defrag_mode)
>>  		alloc_flags |=3D ALLOC_NOFRAGMENT;
>> @@ -5085,7 +5238,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned in=
t order,
>> =20
>>  	reserve_flags =3D __gfp_pfmemalloc_flags(gfp_mask);
>>  	if (reserve_flags)
>> -		alloc_flags =3D alloc_flags_cma(gfp_mask) | reserve_flags |
>> +		alloc_flags =3D alloc_flags_cma(gfp_mask, alloc_flags) | reserve_flag=
s |
>>  				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
>
> Should we pass in ac->alloc_flags here to maintain equivalent
> functionality, maybe this:
>
> 		alloc_flags =3D alloc_flags_cma(gfp_mask, ac->alloc_flags) |
> 				reserve_flags | (alloc_flags & ALLOC_KSWAPD);

Um, what's the difference?

>> =20
>>  	/*
>> @@ -5307,7 +5460,11 @@ static inline bool prepare_alloc_pages(gfp_t gfp_=
mask, unsigned int order,
>>  	ac->highest_zoneidx =3D gfp_zone(gfp_mask);
>>  	ac->zonelist =3D node_zonelist(preferred_nid, gfp_mask);
>>  	ac->nodemask =3D nodemask;
>> -	ac->freetype =3D gfp_freetype(gfp_mask);
>> +	ac->freetype =3D gfp_freetype(gfp_mask, *alloc_flags);
>> +
>> +	/* Not implemented yet. */
>> +	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED && gfp_mask & __G=
FP_ZERO)
>
> Nit: Add more parentheses for readability?

Yup sounds good.


