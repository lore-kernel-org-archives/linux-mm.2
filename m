Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608D2C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2896B0098; Mon, 27 Jul 2026 06:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053E76B00B2; Mon, 27 Jul 2026 06:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84356B00B3; Mon, 27 Jul 2026 06:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B15FD6B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:52:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 248E116066D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:52:32 +0000 (UTC)
X-FDA: 85034242944.08.8E427E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 762DB140005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:52:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RRSWqDvT;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785149550;
	b=t+1oNZzu4i55+HHs0/CEiUJdKwp1JQ7qpZ4VIcaXtkTVnDqV73Jr1cx3pkDXgTuBqg14I8
	oKYIYTd83pHWs+QMbcvskje1Z+cvMWWqo94GrtZRstpbQ+oj/ppOCFtFS9H1GX5WCYQOCQ
	NHfFXZ8ElP1nMJEQUw517G4g/ZRXNzI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RRSWqDvT;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785149550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00LIXUvOaLfOfFLR8KL4kXbH6LSbYZj9ScEAROEus0A=;
	b=fzNb8p74uBs0Nte10U9NmAiME5IixPkozfoN5H9nXp09C49B4jUcshWEcb6+upJlS+n8xR
	98bsliJ9nZ9dNY5X2p6wMeMTWs++3OnBuqy4M+sj6rmUmMfPZpWpIg6eKuDnYoYizXWMbC
	TL6MqpnlzseknIbwkGGN6dO//yJ1UMg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53B384364D;
	Mon, 27 Jul 2026 10:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A28B1F000E9;
	Mon, 27 Jul 2026 10:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785149549;
	bh=00LIXUvOaLfOfFLR8KL4kXbH6LSbYZj9ScEAROEus0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RRSWqDvTqkJFaqCYCzXXgsnImK8fgb168F113cn4oGO5EY70fLN5d1DXcYoE+5hPz
	 1FN2odxd8bM9nLyeFkq4POOehPIdB96uq7WrDATPVReAyO8MhpKh7NnYrSjdFUttYK
	 4jkgX8zw/YqkE07LLZJKW7hcsrb5mHobtvzadECjvCt0Nf211ipfODsJGG1al3baUN
	 wiaGjIrscwYEgc2mn5FCAh/jMSjOJ8HkKx0qorNIyfLJsVFq3WULnuF0N0yXmXbfaH
	 +JhiAWz9gR7LkFkFNwFG/aQvMRZ9VjI1fusrUvvSBlNsnkWVf+JBf1to9txlIBEcXK
	 +muWrd4qyARyw==
Date: Mon, 27 Jul 2026 11:52:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Liu Song <liusong@linux.alibaba.com>, 
	Hao Peng <flyingpenghao@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/khugepaged: cap pageblock contribution to
 min_free_kbytes
Message-ID: <amc0w1IQAhHND1Dr@lucifer>
References: <20260716173504.760369-1-noren@nvidia.com>
 <alopMtyPYdn7vDoC@lucifer>
 <8E9B69B5-0FBA-4CE5-B737-B83AD1FE52C3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E9B69B5-0FBA-4CE5-B737-B83AD1FE52C3@nvidia.com>
X-Stat-Signature: irpgus9uecyb56u3yjni7xa8643qe377
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 762DB140005
X-Rspam-User: 
X-HE-Tag: 1785149550-96995
X-HE-Meta: U2FsdGVkX1/PE4c4r+i8oQY0KFkpZX4fKqwUS23ri3AlrD0PcuZtQ7OiKr4Udi/w4K5aVlMhhiDqvVhe/IdoIeQjfnmjVK20/rzVKZXNCG0zrRuys6g1AC/uYyUHPkSidyokiLJDQOBxSfTrBIzXT3oJvQA0qBovgIZzAzDHN8UtHmWmxZnz9NF0+h7X+xW60NbdBkPo/qFeXEdroRSnnvHf3QDcMeJOXO8xlByo2kvlq98IiqQYZ2EGGJudJ7USKctkUlKoeY+qa/pQo+ftWB3OgFdYq2hkyybylzwy2n1WPZadgcMbPUKGmWGJe3Cdi7xccmN/CljdROamGIlbpGyznr7Qx20WIol1xyYMvGI9b889dL4lHjj88Sul6Cgu0U6TpkvdgA0Vv54QVbRao0pytjBJKHvu3sOMuFP0UqITLfhovsaNcp+ZWkIxGlMkufaQlF7Nur3K7vWXYCaEIoixk0W1kdtvhR1X7hLS1H55JiSgvPuP9LB7PMW1MwgTgTBFHBnMoNdXns+U/IGnb1VtaYeVhXWjbAmx9olIn2Y+Dl1pOIBG0q9kAMI/4gblfZbbIqAQHZ/wl7Brq8Eef8eL6ILfoX4cfYAO3fvtBCpoc3OFJO1dmU/KHpnvfOabkQd2TxjAsoBqk3QA+73YkuXtmKcjIW/EtVbriiFSOw6fhI7JSpjWzDoCzX809typm/9lPZBbYxbH0objqMrj9hBT+6hQMEsom1ptxftrBo3wuAX9S6//wU1SRg/U6Rao0XrUngO4XiN1XVZXon+NlWLfAEKdIva/T/X1hCqS9wKvydqrP80AJuJ7S+2+u5QBcUBPMbBCBdwolq3BVHzZUBt7nymaPcYNs1ysYeBR2W3XH/A0idwO3VdEMYW0rIYe1roTRSGkEKJHomY3H1iLq4lhc3mO34FSpIzdxdAWDNA9/1UuNszUCVNGbQ9gKUIooxKOjRBmFL1WL0LtfNm
 Ym6jmv7l
 53Jux66maSaiYNq8llEBOeJHeftYTPN+GWn1XHRPTml/woKbWUZjaDU9e/78MTnwsmSi2FVYMagrnx1a7JlUIjdNQ1+KJi6nqOQioIjXp3NAPHyZDRBCATHcnVGHc5FKg3djomjCbQLBrbz9cyWrSNmU58KpVvIsj+NMI4OdZhWFEBT9Zxa5jX2NbS2qNgruhH5gC8OP1AU5dT85UBG/6iwjgFtKmuOGt0sxxInD7ksxRJ+s/eGsf39rIGztPdW29hPaVqhGzpQJwXpxqbzTcMzBXtzV51WJ29GGapu/GZrG+QgGOJcaB2asElj1lFb3CWCxIdx7inH3sfLzOUAUqNxwpRPZR8mbNNV3Sl6h7uszR2bRnH2u3MGBly+9Ea530/02GS0dQKXImGLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 10:58:45AM -0400, Zi Yan wrote:
> On 17 Jul 2026, at 9:36, Lorenzo Stoakes (ARM) wrote:
>
> > On Thu, Jul 16, 2026 at 08:35:04PM +0300, Nimrod Oren wrote:
> >> When THP is enabled, khugepaged can raise min_free_kbytes through
> >> set_recommended_min_free_kbytes(), using a heuristic that scales with
> >
> > Nitty, but that makes it sound like khugepaged (the process) itself comes in and
> > changes it, rather set_recommended_min_free_kbytes() sets it higher if
> > hugepage_enabled().
> >
> >> pageblock_nr_pages. With MIGRATE_PCPTYPES equal to 3, the formula
> >> accounts for 11 pageblocks for every eligible populated zone before
> >> capping the result at 5% of low memory.
> >>
> >> This is reasonable when a pageblock is 2MB, as on common 4KB page
> >> configurations, but scales poorly with larger base page sizes. With
> >> the default arm64 pageblock sizes, the contribution per eligible zone
> >> before the 5% cap is:
> >>
> >>   4KB pages:   2MB pageblock,   22MB per zone
> >>  16KB pages:  32MB pageblock,  352MB per zone
> >>  64KB pages: 512MB pageblock,  5.5GB per zone
> >>
> >> The 5% limit does not make this harmless. On an arm64 system with
> >> 128GB of RAM and 64KB pages, the current calculation resulted in
> >> roughly 6.3GB for min_free_kbytes. The corresponding aggregate min, low
> >> and high watermarks were 6.3GB, 7.8GB and 9.4GB.
> >
> > Yeah this is an ongoing issue (as you note below). We definitely need to find a
> > better solution.
> >
> >>
> >> Automatically maintaining multiple GB of additional free memory to
> >> improve the probability of 512MB THP allocations seems disproportionate
> >> for an opportunistic background optimization.
> >
> > The fact it's in khugepaged.c doesn't mean it's just about khugepaged, it's
> > about avoiding fragmentation for the purposes of obtaining THP pages which can
> > also be obtained from page fault and MADV_COLLAPSE.
> >
> >>
> >> This RFC proposes capping the pageblock contribution to the
> >> recommendation at 2MB. This would limit the contribution to 22MB per
> >> eligible zone while leaving configurations with pageblocks of 2MB or
> >> smaller unchanged.
> >
> > I guess you're trying to do the most conservative thing possible - but it's a
> > bit of a cheat really.
> >
> > I mean does it really make sense to reserve 2 MB for the purposes of obtaining
> > 512 MB PMDs? It's essentially giving up on the idea of getting PMD THP
> > altogether but pretending you are still doing so.
>
> Nimrod and I had a discussion about this. It seems that on 64KB base page
> systems, 2MB mTHP is more reasonable than 512MB. I also assumed that people
> might use 2MB mTHP instead. min_free_kbytes targets getting PMD THP when
> under memory pressure, otherwise PMD THP still can be obtained.

Yeah, it seems 512 MiB PMDs are really a special case. Though Usama
mentioned that he found that sizing to be useful on larger machines I
remember from LSF!

>
> But I also now realize that capping pageblock size at 2MB might also hurt
> other >4KB base page systems, like 16KB base pages, since its per zone
> reservation is 352MB, much bigger than 22MB.

Right.

I really don't think changing the pageblock is the right way forward,
without significant rework of how the pageblock stuff works.

I really dislike 'pretend page blocks are size X' and I also really dislike
'cap page block size without changing default assumptions about PMDs'.

The architecture where this matters meaningfully (arm64) is one where mTHP
is available so I think long-term a reworked defragmentation model that
accounts for mTHP as well as PMD-sized THP is the way forward.

(I also think it's a little crazy we go to lengths to defragment just for
PMD khugepaged).

>
> >
> > I wonder if it wouldn't just be better to explicitly check the page table
> > size and to not even bother trying for > 4 KiB with a comment explaining
> > that it's not a worthwhile trade-off.
> >
> > I think that'd be the more honest version of this patch wouldn't it?
> >
> > Or maybe we need not be so concerneda bout scaling across zones...
> >
> >>
> >> Earlier proposals to resolve this problem involved disabling default
> >> THP on affected systems [1], adding a knob to disable the
> >> recommendation [2], or deriving the recommendation from the largest
> >> enabled THP order [3]. A fixed cap requires no new knob and avoids
> >> large changes to global watermarks when THP policy is changed at
> >> runtime.
> >
> > How often are people turning THP completely off or on again though?
>
> Not only just turning THP on or off, but also enabling a new mTHP size
> or disabling an existing mTHP size. (e.g., anon_enabled_store() used
> by all mTHP anon_ctrl_attr_grp).

Right yeah, but my point is that set_recommended_min_free_kbytes() only
gives a different result if hugepage_enabled() is different.

>
> >
> >>
> >> Reducing PAGE_BLOCK_MAX_ORDER remains possible, but it is a build-time
> >> policy that changes pageblock granularity globally. Its effects extend
> >> beyond the scope of adjusting min_free_kbytes.
> >>
> >> [1] https://lore.kernel.org/all/CAPm50aLPxJCiVTqqwiz00oMNiqHggB84sXB3x=tv_HUAd5UktQ@mail.gmail.com/
> >> [2] https://lore.kernel.org/all/20230817035155.84230-1-liusong@linux.alibaba.com/
> >> [3] https://lore.kernel.org/all/20250606143700.3256414-1-usamaarif642@gmail.com/
> >>
> >> Signed-off-by: Nimrod Oren <noren@nvidia.com>
> >
> > Thanks in any case for taking a more pragmatic approach here.
> >
> >> ---
> >>  mm/khugepaged.c | 17 +++++++++++++----
> >>  1 file changed, 13 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 27e8f3077e80..c0570bbb1f4e 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -23,6 +23,7 @@
> >>  #include <linux/ksm.h>
> >>  #include <linux/pgalloc.h>
> >>  #include <linux/backing-dev.h>
> >> +#include <linux/sizes.h>
> >>
> >>  #include <asm/tlb.h>
> >>  #include "internal.h"
> >> @@ -3066,6 +3067,7 @@ void set_recommended_min_free_kbytes(void)
> >>  {
> >>  	struct zone *zone;
> >>  	int nr_zones = 0;
> >> +	unsigned long capped_pageblock_nr_pages;
> >>  	unsigned long recommended_min;
> >>
> >>  	if (!hugepage_enabled()) {
> >> @@ -3084,16 +3086,23 @@ void set_recommended_min_free_kbytes(void)
> >>  		nr_zones++;
> >>  	}
> >>
> >> -	/* Ensure 2 pageblocks are free to assist fragmentation avoidance */
> >> -	recommended_min = pageblock_nr_pages * nr_zones * 2;
> >> +	/*
> >> +	 * Limit the pageblock contribution to 2 MiB. Larger pageblocks can
> >> +	 * otherwise make min_free_kbytes disproportionately large.
> >> +	 */
> >> +	capped_pageblock_nr_pages =
> >> +		min(pageblock_nr_pages, SZ_2M / PAGE_SIZE);
> >
> > Yeah this just feels like a hack, to be honest "let's pretend a page block
> > is 2 MiB" essentially :)
> >
> >> +
> >> +	/* Ensure 2 capped units are free to assist fragmentation avoidance */
> >> +	recommended_min = capped_pageblock_nr_pages * nr_zones * 2;
> >>
> >>  	/*
> >> -	 * Make sure that on average at least two pageblocks are almost free
> >> +	 * Make sure that on average at least two capped units are almost free
> >>  	 * of another type, one for a migratetype to fall back to and a
> >>  	 * second to avoid subsequent fallbacks of other types There are 3
> >>  	 * MIGRATE_TYPES we care about.
> >>  	 */
> >> -	recommended_min += pageblock_nr_pages * nr_zones *
> >> +	recommended_min += capped_pageblock_nr_pages * nr_zones *
> >>  			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
> >
> > we're really getting into faking stuff out realms here - pretending a page
> > block is 2 MiB then doing calculations on it as if they were.
> >
> > We'd be better off (and more honest) with something like:
> >
> > -	if (!hugepage_enabled()) {
> > +	/* Avoid excessive memory reservation if page blocks are very large. */
> > +	if (!hugepage_enabled() || PAGE_SIZE > SZ_4K) {
> >
> > But that seems perhaps unwise.
> >
> > Maybe a simpler version would be to just attack the issue we actually have
> > with it - it uses too much damn memory :)
> >
> > So maybe something like the attached? (you'd probably want to make this a
> > sysctl or at least a defined value of course)
>
> The approach below makes sense to me. In terms of the actual cap size,
> I asked Codex to check what possible pageblock_size and their reserved
> sizes:
>
> 1. 1MB pageblock size (s390) and 11MB per zone,
> 2. 2MB pageblock size and 22MB per zone,
> 3. 8MB pageblock size and 88MB per zone,
> 4. 16MB pageblock size and 176MB per zone,
> 5. 32MB pageblock size and 352MB per zone,
> 6. 128MB pageblock size and 1.375GB per zone,
> 7. 512MB pageblock size and 5.5GB per zone.
>
> 1GB makes sense to me. 512MB might also work.

Yeah I felt this was a bit of a 'dumb' solution but ultimately if we are
saying 'restrict how much memory this uses to something sane' then that's
what we should just do.

It might be a good bandaid at least for this issue which is ongoing, well
known, and painful.

I think at 352MB per zone and 2-3 zones for 32 MiB pageblock, plus reserves
of 2*512 MiB for 512 MiB pageblock makes 1 GiB a sensible choice here
overall.

>
>
> >
> > General idea is - if we're going to cap, let's just cap instead of
> > pretending that page blocks are of a different size.
> >
>
> Sounds good to me. Thank you for the suggestion.

Thanks!

>
> >>
> >>  	/* don't ever allow to reserve more than 5% of the lowmem */
> >> --
> >> 2.45.0
> >>
> >
> > Cheers, Lorenzo
> >
> > ----8<----
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 617bca76db49..d9e1e7de5494 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -3092,9 +3092,13 @@ void set_recommended_min_free_kbytes(void)
> >  	recommended_min += pageblock_nr_pages * nr_zones *
> >  			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
> >
> > -	/* don't ever allow to reserve more than 5% of the lowmem */
> > +	/*
> > +	 * don't ever allow the reservation of more than 1 GiB or 5% of lowmem
> > +	 * (whichever is smaller).
> > +	 */
> >  	recommended_min = min(recommended_min,
> >  			      (unsigned long) nr_free_buffer_pages() / 20);
> > +	recommended_min = min(recommended_min, SZ_1G);
> >  	recommended_min <<= (PAGE_SHIFT-10);
> >
> >  	if (recommended_min > min_free_kbytes) {
>
>
> Best Regards,
> Yan, Zi

Cheers, Lorenzo

