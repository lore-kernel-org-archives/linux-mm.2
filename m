Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C7A606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fy1CbYfr
Received: by kanga.kvack.org (Postfix)
	id 90E7E6B05B2; Tue,  3 Nov 2026 12:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BED66B05B3; Tue,  3 Nov 2026 12:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE7F6B05B4; Tue,  3 Nov 2026 12:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 559976B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:29:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7334140470
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:29:10 +0000 (UTC)
X-FDA: 85394493660.20.AFC9FB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 37DF120006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:29:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fy1CbYfr;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793726949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pE2Np3lykFq0oDsMz7rUAvpVPt/uIba14MNTRAnJoec=;
	b=bj6yxfFPdVl209jX+kye5lC2HBhyfvkpXEHkfI91b9dYOgIvkHmcCDoh6fEaz159vrI4VE
	I0vxBwIeTmEpQj4UIIMGa+9Eoykp+6C2D+PG68Rn2d5isZH+WXjSDu5PW5DfzHBBRxTVcX
	RbaIbNA6KZrj4e0mNgHY74gdyIWbRPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793726949;
	b=mSRvGam1ES4DNZWP7G8lb7ZUNiwnIpvqekvAkd1agaqexeo0phD/2/4IX+0YRjMWU1syvr
	j1YHMocDvFOnLd0BCGjYLJbO//wMr3eP6mQxAohSUz+EvxTXntbgO/EYf9wijsSRhpbR4B
	1Qgo8uVMa8PS4veqZ+BmdcUjIX8Y62o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fy1CbYfr;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49BBC40B91;
	Tue,  3 Nov 2026 17:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1F21F000C1;
	Tue,  3 Nov 2026 17:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793726948;
	bh=pE2Np3lykFq0oDsMz7rUAvpVPt/uIba14MNTRAnJoec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fy1CbYfrBs/Oux4o7jViXIGWEjIp2SDX+seRNw7Osj6jbA3F09gjrUVe3UA/OnvLt
	 VhGGVqXvEKuqTUhqp3qaK3noQrRPsl6TJbZKaM+bX+Kqq2+MZVjVfzkhaQy7WJLmgm
	 Mmp/LSVU75Ud8eS4Z92xbyopCXI39NYTrhXg9YTq/V1RW+G2UfGCoT6t1ow8LUtiWw
	 8PdgVvYMPG1bANAUARF5B3jAKQZpbP2PwgCVQX8z9xHdPR87XKeoDJya1dqbcpfZtK
	 IRdvMVLjIFD1aiFS+19JQ8/rZKQdHmsBcQrNPyyeW6kaNTOz3GNkmibgE9INLsL2jx
	 P91CV6KLqp8KA==
Message-ID: <28a08334-b52f-49ca-a209-624520864605@kernel.org>
Date: Tue, 3 Nov 2026 18:29:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: more checks for
 alloc_contig_frozen_range() with __GFP_COMP
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zhenghui Hao <zhenghui.hao@qq.com>,
 Brendan Jackman <brendan.jackman@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261102-free-pfn-on-alloc-contig-range-error-path-v2-1-a9fe939a85c3@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261102-free-pfn-on-alloc-contig-range-error-path-v2-1-a9fe939a85c3@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nmc6tfat8iwfqi5pkja7f9gqf6ajih84
X-Rspamd-Queue-Id: 37DF120006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793726950-281024
X-HE-Meta: U2FsdGVkX1/rxOIpmP3V5c3NDFHDk2+/GS8z7Xi135HQ9NJlmlbqD+pXKjqq4Fglbk6B9WZ7BVirSEOlnOSX2RFOQ0YMKjdwuXVlR/YOnFq6gSFQSjv/hvpDTcbcaEHbR42KsZTk1KxvAvcsSGmdVgt0k69g5JsFvBvqsG1451s2tlnfjX1Uk5z/2klWaps8r3YD/cC8VoIwbMS8/755kF1D4ZYfvYBvMcNe8NAK+CfLXXXpJB3Tf2kmn/XTBC44SjC8uu0IC1HaAUybHhcEJWUnn3NdyLafMGxp5NH6bKK6yJC6EH5e+FDol1hOUnteiyGxKJZeHoWwvWIE8zZ3GP0jLX5k3ffMFhNi0GaNvSjml+dgm7993aKp7rXDi4Tpm/xR/KvoVv+ABRu2i/hxDMTtTwpmnxQSB37L4pU1daZZ6DTPOUcqO9KSThY+mw9dH7PWJyPngveTaVpEMcgE55iBFmYch8QlZKskvyqUYF+Q0ymTjjfa7byw1EozcWQF4x2Ux+co02mOaYskrWLEfFR5bpZF9/7uNJeokGk5FXcYVg5sffODY9fal69OIl2GJfpQSZhctwgP7arwikaeDjvxlzB3PP5KWRWmrL7HSGovSNiKRsX6zFnPK/KtYHRma+MPHCuFRDl/NyPuq303zRc/yh1czg/BapyVgK1Ddx443MmfWMTcFPe6LNCAbxz09HC2bOOqtYR9oYEIFRQz6rZBTFVDMA92zK/HDYyOvgqv0lRUkQmJ7gMBwp/ETpdAELHCaiK6sMDKGPEZar3gHHAAr59T7Qp5PtDr+xalfCcW6ARdx3hdV2PLXkYf0OUUl5TkZ+1zUY3cEy9258UOMpyky6JZA4JwOC2ROsP6iT547hTZuxKuksa17iBQRfzxyp+eN6ThPsaHBKRqp0adgoZxykZy9A2lFCA7lWwHHiJFZeOYSnfSUpXczj9yDWKe2Zc62+NMCz6aMwWq8PS
 sO69EmZX
 7rEw+ZWFfY8mXc2sfaDF1mwmoiRzeRiMxvOIzLbKPVTi4VhGHPsycMUNbapoRUz+DUkqRE+0DHuBPzMp+83IJwhlgUuKsDHFoAD30mnNIFnnA5iZCguKscha+YWxXOSUCcPpUzfnJXyFqCQM+4L9+4EP7z3N7s+pJLZMBrHrG3QTyVvnHsQsRPHmCjNfXbx5mD7+6Z0+Xb9CdkDG9dgdLxJgFpoM5Zc7blYgf6owTgMWMU9rBBR1xJGmYVhmTgSvOWjMLgUUT2ZbAgBvC1p3TC+NEBkfHPJi9ZsB0USxVhwpTv3dbkKFWQ4dhZozeVsbGDD/XpHpyDCWDVmOqiDtRrXKudY6LDRW0IsVtjmL2qm32BSxT4RSHKdVNQoLB7AROilmrRUKopL89Sv+s6C9Sd4I/0dV4LGmsBIaB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 17:24, Zi Yan wrote:
> When alloc_contig_frozen_range() is called with __GFP_COMP, certain inputs
> can cause a mismatch between a requested range and its allocated range,
> leading to the WARN at the end of the function and page leaks. No in-tree
> user passes such inputs. Add checks to prevent it:
> 
> 1. the order is at least MAX_PAGE_ORDER: free pages during isolation can
>    merge up to MAX_PAGE_ORDER, extending the allocated range beyond the
>    requested range;
> 2. the number of pages in the range is a power of 2: ilog2() can round
>    down, so that the compound page will not cover the requested range;
> 3. start and end are naturally aligned to nr_pages: a compound page must be
>    naturally aligned, and the unaligned range can also lead to a mismatched
>    allocated range.
> 
> Because of check 2, the same power of 2 at the end is redundant and
> removed.
> 
> Add a comment on the WARN path to clarify it should not be reachable, so no
> one in the future will try to fix the impossible page leak.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f%40nvidia.com?part=1
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> Sashiko reports that if alloc_contig_frozen_range() with __GFP_COMP can
> allocate a free page range different from the requested range, the function
> triggers a WARN and returns EINVAL without freeing the allocated PFNs and
> causes free memory leaks. Add checks to prevent it.
> 
> The is_power_of_2() check and start PFN alignment check are added with the
> help of LLM.
> ---
> Changes in v2:
> 1. added 3 checks for __GFP_COMP to prevent the allocated range from
>    mismatching the requested range, which can trigger the warning.
> 2. removed the redundant power of 2 check at the end of the function.
> 3. added a comment on the WARN path to clarify it becomes unreachable.
> 4. dropped Fixes tag.
> - Link to v1: https://lore.kernel.org/r/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com
> ---
>  mm/page_alloc.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)

Applied to page_alloc/for-next, thanks!

> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 15ff5c1feef4f..003911ef393be 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7326,12 +7326,24 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  					    PB_ISOLATE_MODE_OTHER;
>  
>  	/*
> -	 * In contrast to the buddy, we allow for orders here that exceed
> -	 * MAX_PAGE_ORDER, so we must manually make sure that we are not
> -	 * exceeding the maximum folio order.
> +	 * The use of __GFP_COMP has the following requirements:
> +	 * 1. the order cannot exceed MAX_FOLIO_ORDER (>MAX_PAGE_ORDER is OK);
> +	 * 2. the order is at least MAX_PAGE_ORDER to ensure at the end
> +	 *    outer_start and outer_end match start and end respectively;
> +	 * 3. the number of pages in the range is a power of 2;
> +	 * 4. start and end are naturally aligned to nr_pages.
> +	 *
> +	 * 3 and 4 are also the requirements for __GFP_COMP pages in general.
>  	 */
> -	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
> -		return -EINVAL;
> +	if (gfp_mask & __GFP_COMP) {
> +		const unsigned long nr_pages = end - start;
> +
> +		if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER ||
> +				 order < MAX_PAGE_ORDER ||
> +				 !is_power_of_2(nr_pages) ||
> +				 !IS_ALIGNED(start, nr_pages)))
> +			return -EINVAL;
> +	}
>  
>  	gfp_mask = current_gfp_context(gfp_mask);
>  	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
> @@ -7428,12 +7440,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  			__free_contig_frozen_range(outer_start, start - outer_start);
>  		if (end != outer_end)
>  			__free_contig_frozen_range(end, outer_end - end);
> -	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
> +	} else if (start == outer_start && end == outer_end) {
>  		struct page *head = pfn_to_page(start);
>  
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
>  	} else {
> +		/* Unreachable with the __GFP_COMP checks above */
>  		ret = -EINVAL;
>  		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
>  		     start, end, outer_start, outer_end);
> 
> ---
> base-commit: afb4eea28037fa55c4560313ecbd8a1e1da8369a
> change-id: 20260629-free-pfn-on-alloc-contig-range-error-path-acc001232468
> 
> Best regards,
> --  
> Yan, Zi
> 


