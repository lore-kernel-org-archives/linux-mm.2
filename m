Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763C2C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1996B017B; Thu,  2 Jul 2026 21:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3636B017D; Thu,  2 Jul 2026 21:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEDB6B017E; Thu,  2 Jul 2026 21:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 139056B017B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:03:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E6791201DF
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:47:14 +0000 (UTC)
X-FDA: 84944416788.01.B8E4526
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89C1018000A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:47:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ng793fMZ;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783010832;
	b=T+KMRyE2KnpR6xi7NtTo6WZgsxwnMDAgBknG+8BDGJELpZIgPK73N5LIj7BxLdX5o5AG6a
	sS0m0CqkKAIhptBbc5DOTvElopC4oCcWVsaoIHeB3hBeDS4kbfCsVKCXXTIJlAUgeh910U
	Agb409YWUA/e8nSgKX0ZNBqYsRxbwZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783010832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=taOAjbXieJFMNm4bP1CgHm93WARmoJbQ3VZALpeoKYs=;
	b=JxDvWe7hT84DbN2IGfMO1gDb/34XX0u+alZdTbUa1TVgyr82CtMVs30qXvYlPELL+PwTgr
	JYq6PJRFelyyFHaV2uZfH7KdoPbNJ1d7//2u8w8ApTqPHFLn28RFspuHhpUPED26IZzCmQ
	OfYX7agrlzo8liMbsgtnDhsqwooGMS0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ng793fMZ;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B94C840B83;
	Thu,  2 Jul 2026 16:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3191F000E9;
	Thu,  2 Jul 2026 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010831;
	bh=taOAjbXieJFMNm4bP1CgHm93WARmoJbQ3VZALpeoKYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ng793fMZgoIdBJrF15JJRcVZc4Bd+e1Y5NlbggtZpjY40sADDO0g7AShASlnCbxTn
	 DULmdgFBcsXTUAqkhid4+Ghqkgk76u9EKOUrjSby0N5E+UBRVtc8efeMDRD3IByK4f
	 KiK0PBm5LkZpiwQCqgpdkpanN8QQnkdwH6Yy/jqyHYSR7oNcnunqWf+cxZsucx4rfd
	 DNPxHWL14kPBV6UTC8s+SccwkwjybjXqiKcRUo11fZnfUEPoNKr9CarED87qEIw6Tp
	 9dfE1AfX5ojzy6hll3aFSdibY+wokynzZwX2I4vZ7dzJ6lULKP3dZf6svsaZcsH7dF
	 Vtch1kZDF/LtA==
Date: Thu, 2 Jul 2026 17:47:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, yang@os.amperecomputing.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/huge_memory: set PG_has_hwpoisoned only after new
 folio head is established
Message-ID: <akaV3b1eziZ2bq21@lucifer>
References: <20260701174235.3173401-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701174235.3173401-1-riel@surriel.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89C1018000A
X-Rspam-User: 
X-Stat-Signature: opjwec7uie7hfszufyb99cibfuks3u58
X-HE-Tag: 1783010832-825995
X-HE-Meta: U2FsdGVkX1+XcHWjWE5hdGCPYJU79fW/6dfxNLMk3qGr/SU6NnqAIwdnQ89D9SZSRN7Xp6NjaehXUpR3Wd6jz9u2TR8H4OWL4A923z/8fUEGIUki7gxwI8afFFuNbHSLK84KTQY0AN05xvhPYdzMi1d6Grq6YYBy9lF3wEVh1rBc8rwM+lKyEMwWSS8fSUUkcy8EFH8J67rL5gNqPbtDaQxL03gArdZbQmClZD8tw7H45K2QT3pI9iQNM1KJ0aQU0xLBAh9p7GK5R0k33ytkGp0Gtrb+jXm2KoSHmBVW1UoLhoh5Eur8mriQxvDmng2s3IfiM3TtiKNNDAlcaYJJblDaJXU+F/U/NuIGJAPn1B6QzbHnvcYm76EZunxA8iQ/ZsndJwMKMsDRXf8U5nXkAM3yHEABKr5YrHZ2XTNHjVFKBWdP9ogO3VxFAWHcBiN01wZXdDkalifevp8Z24zNfLcQ9HxPXRfJDscFiuc1pNsPEn4/t6hxxivGPuRe7ORlOOpaDKyPulgOLrSWQuOikSUBmaKqjUSIRrHKd+K3rQQy765C+FpdTxypb8dvk8x6cir+B7zFv2f2peRN4arH9DTdoIu2FVGgrGs2PZT5+YDg9HHEzf+1J948ylKrV5rwCalfdIfLh9lprx7d9e1XuHrI21G3X1ZhwRg4olxqJK/d6g8dNfSQRpCLzT/xtizTMYFkkVc/M0Crrjrtao8M8Mp95p5Xsf0a2iq2+buoAu8OxDme6+/gNcgBkgGfNLZoyT14rfj2a5EFpNcFbz9C5cS1E43vc/VydfNU2hi4YNV9OUAewGRKktjqBGYVrG2c6SeJ3dVDKP+UAnAVyRn0X32r9U7yLWWMLIrSfB3+UuWBNJbmZuHdbPiRRqVGiZCdET4wfVo+jscFJeBj6RqUFAwwP6F/43kB7Hnlp/h9QQpqk7gu79M6HrTzYq3lfNQ8Z4ZMwPRLkw+OT2uc7Ba
 fTFFep7P
 WV3cy4UliGgCKb09CNP2iI7lUpdSYv7VyFJ+E/er4MRBB4ZhIcTK2DRcAReRMwVwBF72NFasks/6dvwRW8WDBpW3BNwX11XyUn8vHH1uVAVKBCfLrwZsYKsZZwFH2/9Ht3T2fRuluCH/7UddsZpnDveJATdwXPd7aajyx+vJXstBCziVFJU218Rg6fpI90gclpyh5MglhP+NxjfM6Yi73+JFEh3lpQ1klwZwn8ZOxe/WZCglMejdzkVyPGXCXyY6FziehPqmDsS10AtK41l86W9CSiAeCzr8RYSoHrlbge1gmnFA5WSpR+U38lm5MoD43E0VHt+h4IuncXiLv1onK7mUc+WPtQn93iQPASWKTgKZmVGSX1fZeST9VbzFe+dbakaeZGfLAjZPwaY8PfhtVytdpKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 01:42:34PM -0400, Rik van Riel wrote:
> __split_folio_to_order() copies the hwpoison state onto each new
> sub-folio while splitting a folio to a non-zero order.  It does so via
>
> 	if (handle_hwpoison && page_range_has_hwpoisoned(new_head, new_nr_pages))
> 		folio_set_has_hwpoisoned(new_folio);
>
> *before* clear_compound_head(new_head)/prep_compound_page(new_head, ...)
> turns @new_head from a tail page into a proper folio head.
>
> PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag, so folio_set_has_hwpoisoned()
> resolves to folio_flags(folio, 1).  With the new compound_info-based
> page-flags layout, folio_flags() asserts the page is not a tail:
>
> 	VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
> 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
>
> At the current call site @new_head still has the tail marker
> (compound_info bit 0 set, PG_head clear), so on CONFIG_DEBUG_VM kernels
> this hits:
>
>   kernel BUG at include/linux/page-flags.h:354
>   folio_flags+0x82
>   folio_set_has_hwpoisoned
>   __split_folio_to_order
>   __split_unmapped_folio
>   __folio_split
>   truncate_inode_partial_folio  (shmem hole-punch / MADV_REMOVE)
>
> Reproduced by syzkaller: hwpoison-inject a few subpages of a large shmem
> folio, then MADV_REMOVE (fallocate punch hole) on the same range, which
> splits the partial folio to a non-zero order.
>
> memory_failure() tries to split the poisoned folio to order 0 first, but
> that split is best-effort; when it fails the folio is left large with
> PG_has_hwpoisoned set, the case fa5a06170036 added this hwpoison copying
> for.
>
> Move the folio_set_has_hwpoisoned() call to after
> clear_compound_head()/prep_compound_page(), where @new_folio is a real
> order-new_order head folio (handle_hwpoison implies new_order != 0, so a
> second page always exists).  The flag still lands on the same struct page
> (page[1] of the new folio); only the ordering relative to compound-head
> setup changes, satisfying the FOLIO_SECOND_PAGE precondition.
>
> Fixes: fa5a06170036 ("mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order")
> Signed-off-by: Rik van Riel <riel@surriel.com>

The actual logic looks good, thanks for fixing this, and the comment is much
nicer now :) So:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> Assisted-by: Claude:claude-opus-4-8
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Cc: stable@vger.kernel.org
> ---
> v2:
>  - cleaned up comment (Lorenzo)
>  - consistent changelog grammar, plus rationale on why this path exists (David)
>  - Cc: stable (Zi)
>
>  mm/huge_memory.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..b5d1e9d4463d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3587,10 +3587,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  				 (1L << PG_dropbehind) |
>  				 LRU_GEN_MASK | LRU_REFS_MASK));
>
> -		if (handle_hwpoison &&
> -		    page_range_has_hwpoisoned(new_head, new_nr_pages))
> -			folio_set_has_hwpoisoned(new_folio);
> -
>  		new_folio->mapping = folio->mapping;
>  		new_folio->index = folio->index + i;
>
> @@ -3612,6 +3608,14 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  			folio_set_large_rmappable(new_folio);
>  		}
>
> +		/*
> +		 * PG_has_hwpoisoned is on the 2nd page, so set it after
> +		 * the compound head is prepped.
> +		 */

Great thanks!

> +		if (handle_hwpoison &&
> +		    page_range_has_hwpoisoned(new_head, new_nr_pages))
> +			folio_set_has_hwpoisoned(new_folio);
> +
>  		if (folio_test_young(folio))
>  			folio_set_young(new_folio);
>  		if (folio_test_idle(folio))
> --
> 2.53.0-Meta
>

Cheers, Lorenzo

