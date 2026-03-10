Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2C1EA8550
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE2B46B0088; Tue, 10 Mar 2026 05:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65F96B0089; Tue, 10 Mar 2026 05:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A725F6B008A; Tue, 10 Mar 2026 05:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 92D346B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:38:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05F5F1C763
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:38:44 +0000 (UTC)
X-FDA: 84529653768.20.C66F1C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43732120010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:38:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BUxt8wfO;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773135522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75IjdLfM9eWDLulFYtzU469kBc72LHr4mHRxpVH4VbY=;
	b=ZHaVZyTDBEc8GkXYPhk/A4L9Yz7/XzTpS8kfklGR4Yg01M8lBlGkldoSB67ZtVjguoKZ8r
	P8Wg8Fr5A7cSunuZsz2++8iQ9axOgya1kM7cpVfFq8g46s1jXeEvGt31iXqecz4lVF6pJ1
	f3lbvNinp/PmBpMWNgUUctOOYiIttDM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BUxt8wfO;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773135522; a=rsa-sha256;
	cv=none;
	b=agSAoSFzqvf5Je4YP4G8ZxCiJCfEq7cOmDHNaEJAHfoTy/qnHaOnjomGhuvPYtKys99C57
	RVFgLzcjqK9hs6zxLjndUoeaeEdPxcts4/IPi4+EfRTkLuoEe7PX+I1VQIZCgEXZ/HTjHN
	SutV69RqoUByXSnpj5ckTxtT5ocfv+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5B3540E4C;
	Tue, 10 Mar 2026 09:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94734C19423;
	Tue, 10 Mar 2026 09:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773135520;
	bh=QFCMLLjD5AoMRGdEQvruMf8UGObBY3Dj/6+HoV5saew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BUxt8wfO93xFecEcgkid2H6mvvBKpZf9jmP44ISuqhpU0ioExKr0+P9uwTv0dNCvQ
	 f+ig3Z97RCrAcoRmzh7P7WO/ClZWcbRXax6bvegQy7oSNxOhUSCCRDWRQTAtaJTRSC
	 wfxH9G0rwWDh52tEnZXqh+qiauXV/3tFTi3wlae0qdaviHY2S1h5tsaleKC10rrwhV
	 hmohtc7KMOmmurODo460ucFXkIcyfhXz0bh8sYPMlnIJW6+QU6WZ3JZcXd2TSj9nT6
	 b50Jj2dGlc6X9JSIwoQFqZ1PyTWcc/YrcW0CXrjZB/MaiyDjYgPlircdGuCTwQ6OEH
	 ytUPjVgetJj7Q==
Date: Tue, 10 Mar 2026 09:38:30 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 8/9] mm/rmap: introduce folio_try_share_anon_rmap_ptes
Message-ID: <3ff22f08-5617-4c05-8fa0-1d808806e322@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-9-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-9-dev.jain@arm.com>
X-Rspamd-Queue-Id: 43732120010
X-Stat-Signature: jyc673h8ox5ki1rdhu3xo8bd49mk1f7f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773135522-526120
X-HE-Meta: U2FsdGVkX19fJ+u8hLNFWzHLskbvWZHCBrxeFfTJYclRMIE8yb5Q6gtAFf91aP5ken6j+8Jz/LegKeaCp2ccZSzRoEsjSiA+uGfkD5lSZdINqYTyQyZiHtGLHO/Yx8aB4HKyOjZ5SIf6+phgZ0NR9i/4ikgwV62lHm7ZD4x8BDnb4TeK8y49BIykNpvMNp9y0cUP4FAvD5HCk1ppC7fAJpC5REFNsk/dK3IepFJKwOk/1YTwnKpyhRoSbIUPGd6XeyewrbH0VVsgup+9zjynKQooD+F5uzB1SuOf4QojrJmKz847pI0340TGEKW0CgQUvqHZCRL/A+h8xIQM0X9fdcO/OD75tOe2SZ1TjV9m/k2sYI2WrK5l7vPzr9pGDqXhZrYtHuoai01RS1KgRtfN04zCg9gFhUQTjzXzHmY6ZSDI+kwGWX/OgVJDulML8v0a1qZuHQlJcpdwp4hbi35WG4oRj4V3Rf5V93qdEAw6fBs7yalnrArD56mAQO23Uf4uVOF+ub2X9agk4rCno3VQ2kKRXIxUqHeTtm4dvIcz1RCo4RdVGL4wxeZqVwVQ13nN5fdjSmT2l5M4pLgBRVGnbGyi4lPNv15H6tylVu7SdqaVJhAnAbbGhbTubC4IgQPXk/fzukVf3Q9YRnD+gSUBrViCYbG/m1mDBDAPbwVQ38cBQMSFnGQy03ZNMBD4WXA1ubSBuksWJBRcCEc3WMzrx6Z9J3ZIYA7FSj4tAhItb4cYoQJktslTCUQcy5L5yGe4pEvJ/+plvDRr1LijHogdzNETYRGXCu727eBZf4PfaNWmBubA0EIFzYJ/HxFcNl5VgcbiKc2LgIZhQGvRmIBtdT/SZmAF6vVPE4kNR/WMIIeU1bJPhGzDd40rnNzA9D0DZmPiTyfMwpQG8nkqsHP0TgxWfDOoE1AwGAB96sfYzQ6UVIlZRTwFlxbe+lMzEJ/bbZsE0cyAPtdN2vJATeG
 MBDn4FJS
 US00IGGVAQla1de5WnKFHg7YaqdfNurnJyEVa9NF5e4Z6xWM40E+T5s/ciiQ+ZHaGTS2FlIbY/nyZz/tmO50A+cU3kpQGUwiCpOSwZVLBanKdUw+njy/WesrhRRftg/pujYBHTSyG0unC9FF3uR9kEvAomfunvx3VKSa1qxTxPot3GoKxutjArvqf6wG37fQRF4kMxCgdml2OaGi8egbdU9S3VCkIFwOx6vMzLz2Aq6d/l6w99G6KMwMOEgBqcAVbiv8JqqV1FB2VR7zRTDVVfZOE3x+VndWJDDRUBYWbsdEffyezgH+CqM6HfBYgZyJzBs8E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:00:12PM +0530, Dev Jain wrote:
> In the quest of enabling batched unmapping of anonymous folios, we need to
> handle the sharing of exclusive pages. Hence, a batched version of
> folio_try_share_anon_rmap_pte is required.
>
> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
> to do some rmap sanity checks. Add helpers to set and clear the
> PageAnonExclusive bit on a batch of nr_pages. Note that
> __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR from the
> PMD path, but currently we only clear the bit on the head page. Retain this
> behaviour by setting nr_pages = 1 in case the caller is
> folio_try_share_anon_rmap_pmd.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/page-flags.h | 11 +++++++++++
>  include/linux/rmap.h       | 28 ++++++++++++++++++++++++++--
>  mm/rmap.c                  |  2 +-
>  3 files changed, 38 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0e03d816e8b9d..1d74ed9a28c41 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1178,6 +1178,17 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
>  	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>  }
>
> +static __always_inline void ClearPagesAnonExclusive(struct page *page,
> +		unsigned int nr)

You're randomly moving between nr and nr_pages, can we just consistently use
nr_pages please.

> +{
> +	for (;;) {
> +		ClearPageAnonExclusive(page);
> +		if (--nr == 0)

You really require nr to != 0 here or otherwise you're going to be clearing 4
billion pages :)

> +			break;
> +		++page;
> +	}
> +}

Can we put this in mm.h or somewhere else please, and can we do away with this
HorribleNamingConvention, this is new, we can 'get away' with making it
something sensible :)

I wonder if we shouldn't also add a folio pointer here, and some
VM_WARN_ON_ONCE()'s. Like:

static inline void folio_clear_page_batch(struct folio *folio,
					  struct page *first_subpage,
					  unsigned int nr_pages)
{
	struct page *subpage = first_subpage;

	VM_WARN_ON_ONCE(!nr_pages);
	VM_WARN_ON_ONCE(... check first_subpage in folio ...);
	VM_WARN_ON_ONCE(... check first_subpage -> first_subpage + nr_pages in folio ...);

	while (nr_pages--)
		ClearPageAnonExclusive(subpage++);
}

> +
>  #ifdef CONFIG_MMU
>  #define __PG_MLOCKED		(1UL << PG_mlocked)
>  #else
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 1b7720c66ac87..7a67776dca3fe 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -712,9 +712,13 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>  	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
>  	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
>
> +	/* We only clear anon-exclusive from head page of PMD folio */

Is this accurate? David? I thought anon exclusive was per-subpage for any large
folio...?

If we're explicitly doing this for some reason here, then why introduce it?

> +	if (level == PGTABLE_LEVEL_PMD)
> +		nr_pages = 1;
> +
>  	/* device private folios cannot get pinned via GUP. */
>  	if (unlikely(folio_is_device_private(folio))) {
> -		ClearPageAnonExclusive(page);
> +		ClearPagesAnonExclusive(page, nr_pages);

I really kind of hate this 'we are looking at subpage X with variable page in
folio Y, but we don't mention Y' thing. It's super confusing that we have a
pointer to a thing which sometimes we deref and treat as a value we care about
and sometimes treat as an array.

This pattern exists throughout all the batched stuff and I kind of hate it
everywhere.

I guess the batching means that we are looking at a sub-folio range.

If C had a better type system we could somehow have a type that encoded this,
but it doesn't :>)

But I wonder if we shouldn't just go ahead and rename page -> pages and be
consistent about this?

>  		return 0;
>  	}
>
> @@ -766,7 +770,7 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>
>  	if (unlikely(folio_maybe_dma_pinned(folio)))
>  		return -EBUSY;
> -	ClearPageAnonExclusive(page);
> +	ClearPagesAnonExclusive(page, nr_pages);
>
>  	/*
>  	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
> @@ -804,6 +808,26 @@ static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
>  	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
>  }
>
> +/**
> + * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
> + *				    mapped by PTEs possibly shared to prepare
> + *				   for KSM or temporary unmapping

This description is very confusing. 'Try marking exclusive anonymous pages
[... marking them as what?] mapped by PTEs[, or (]possibly shared[, or )] to
prepare for KSM[under what circumstances? Why mention KSM here?] or temporary
unmapping [why temporary?]

OK I think you mean to say 'marking' them as 'possibly' shared.

But really by 'shared' you mean clearing anon exclusive right? So maybe the
function name and description should reference that instead.

But this needs clarifying. This isn't an exercise in minimum number of words to
describe the function.

Ohhh now I see this is what the comment is in folio_try_share_anon_rmap_pte() :P

Well, I wish we could update the original too ;) but OK this is fine as-is to
matc that then.

> + * @folio:	The folio to share a mapping of
> + * @page:	The first mapped exclusive page of the batch
> + * @nr_pages:	The number of pages to share (batch size)
> + *
> + * See folio_try_share_anon_rmap_pte for full description.
> + *
> + * Context: The caller needs to hold the page table lock and has to have the
> + * page table entries cleared/invalidated. Those PTEs used to map consecutive
> + * pages of the folio passed here. The PTEs are all in the same PMD and VMA.

Can we VM_WARN_ON_ONCE() any of this? Not completely a necessity.

> + */
> +static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
> +		struct page *page, unsigned int nr)
> +{
> +	return __folio_try_share_anon_rmap(folio, page, nr, PGTABLE_LEVEL_PTE);
> +}
> +
>  /**
>   * folio_try_share_anon_rmap_pmd - try marking an exclusive anonymous page
>   *				   range mapped by a PMD possibly shared to
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 42f6b00cced01..bba5b571946d8 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2300,7 +2300,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>
>  			/* See folio_try_share_anon_rmap(): clear PTE first. */
>  			if (anon_exclusive &&
> -			    folio_try_share_anon_rmap_pte(folio, subpage)) {
> +			    folio_try_share_anon_rmap_ptes(folio, subpage, 1)) {

I guess this is because you intend to make this batched later with >1, but I
don't see the point of adding this since folio_try_share_anon_rmap_pte() already
does what you're doing here.

So why not just change this when you actually batch?

Buuuut.... haven't you not already changed this whole function to now 'jump'
ahead if batched, so why are we only specifying nr_pages = 1 here?

Honestly I think this function needs to be fully refactored away from the
appalling giant-ball-of-string mess it is now before we try to add in batching
to be honest.

Let's not accumulate more technical debt.


>  				folio_put_swap(folio, subpage, 1);
>  				set_pte_at(mm, address, pvmw.pte, pteval);
>  				goto walk_abort;
> --
> 2.34.1
>

Thanks, Lorenzo

