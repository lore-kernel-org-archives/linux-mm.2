Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD19ACD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6076B0102; Mon, 11 May 2026 11:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD856B0104; Mon, 11 May 2026 11:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB1E6B0105; Mon, 11 May 2026 11:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E60E6B0102
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:34:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B77F9A0199
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:34:22 +0000 (UTC)
X-FDA: 84755535564.01.99C6AB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C517D160009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:34:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIptnLmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513661; a=rsa-sha256;
	cv=none;
	b=QD+xFjX0WF9NFQxusnOPn2aq/uhlNkp1UizlxGhwoVthOXc/4APkwppzycKyR7JfRzup2m
	IP3rGs3vO1J4tGa2zig/OeeQ1jjOKtJ5vFjuR5JuLTmNd0nkvMbcBGRZzbRX+/ozB+3dxE
	SmG7Ei/pgMTKG+REDn6fVW7QdclAqkI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIptnLmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VxFa3aR1bmM9S/gAU1TvNFfz1rm7i0DFR7UQ5OcvDqA=;
	b=aR1Rw2zOTvDZLOZ+Q90GKsYOlYi2sshiU+p0dY2+ifk4KCkTLkzEDhs6yKDYTX6N/94HdX
	m3mPn9Vm837mYG3ygehHYLmsb6xWereZ8d7NY7Q/XTDGbxkl02q2c2lGqlUyuNjZPbd+/r
	jKJeHRktdK0b1FX006imTjZxPnmB2Bc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D15A643907;
	Mon, 11 May 2026 15:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2036C2BCB0;
	Mon, 11 May 2026 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778513659;
	bh=952v39NeMVM7xhL5cHT+arFmerxRxH8pXtydpSUq2zQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FIptnLmJpTUfVHvfKd6Ub0RZnpFzRcxC025n09XPH4d7g5dGphkWUqtWKcZBgCfib
	 YX4qzn1qN58aciECnmXExH/Oxf+UIRkrncx3agQf+Pc4vNZ5W3PGD3zJqmabG9GV6O
	 p/Gn3+xsO3SFk549TMK5hJe86jOucGSjqK/xsaS07UTZXeHwFkZrZH9aQofZ7u7G2Y
	 XBSd+aSrdpyj/LPeQYjIi8mCL1l1ZzaQCi9GCHdLSWCinpUZxQ/XG6O1FFY9IWud0X
	 iN2CMf0elMCVlr8pttXkFNV/2MpaSIh/S4A7fllLgMZ8PnrUI/oGhQXg36UjYFvZv/
	 rvHtPmhxGNnRQ==
Message-ID: <016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org>
Date: Mon, 11 May 2026 17:34:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/22] mm: introduce freetype_t
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pgiep7ns8bb5aeprue3cugya5eh1seph
X-Rspam-User: 
X-Rspamd-Queue-Id: C517D160009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778513660-648616
X-HE-Meta: U2FsdGVkX1/BaKa8NIdVa0CyjMIDIzSdACXocH0ZZlJnCxc7/DvND+U6JW5Ps8INLLe+tC0RFqFOlbtNNTroWsralc/WFBW2MXYlkvFseMMyqI2NWLqh4qgr54+nKgHFZPPWv6HW6OW621hBjSLAIRgoq6pVeOEJqn1c6N9bB41nvp7gArfum+aswAABYSZt1Q/eIS/xBTAutEtBEKn2kZApRR7OmQyTHPgZPRkEpFJomT6dTZvhUcihgiWcwSYTDDQ+IErKBd+oWC+zy5LF5f/OKG9zp7lPknYIJkH68di+25l/wNuLeDDRFFbzQ35P8ELc89l13yTcFMd20i8VbYC7J70TA90xugbCGJRZYFMsQEv7scGxFHNLc61bvvk+S0P+AzjXSivY9COxw1mssnf1pKUhNUcXfLi8RlqHkS1PFO/HFTDg2p7UuLaszf1WASfsgVZmfYIeq02kppnS/+FRtTTP7J1YTvhI1yBxL008PXVg9Lcj9yCSJElAa1D9JsLAolXUHrm1mCqhuZRES/HmEAl4KMB04IcCt6hibnoQx1CiqEXyUSQVdA+tXpw2KvkgvZz1bElf9MGRK50CL0Hu24lYqMXsk3QW3kBQu0sH/7ZvTYixWz8PU8lH+5HevuEWYaqAX+or55brB3K3CNxat3GEeKmsd1pgb51EXMsxeqzDlZHJgV93nAQ5uIk8y6bXCUuGZDliPcm0jJSQrfNB/kxiJvvbKhWjHzsOPF872YGtKPvlaX/QtlJF7rz3qm0R0TxDgGaoDz8ZCJUDPzWj5MtlU7tbz3tJJfQjbzdvBr5BqWMPuJjxzkmVJ9TdCPfh1VAehApMY/dCy4y8EyrhgqA9M6SJCmf1wZ9seWlOjXCyIaF+pqsGqqINnoErYmka6kvMQP1QGBaHIN2RV+/4JDvlHCIyQ1g10gSWzB9eFGFfR9SlvtEthQW1Tw5YvOZ2dYB521c1ETdco1n
 /wDCrBe/
 bH09ScjgAIoBH5ygrvJm76mMMufKG6ShwiYxfEL+6m6uZCKW4LGJrwMA0X9iYrj2yYSge+NSLhJ+1xSTDMRsRPmhwEegdR0CS7YQEiDVnPEIVaw/giO3cuG0mGZlJknUYP7+tveflIeqyC7zvUnrvz1CydYEFd+ZZjqfmtc6kSqWI5f1okrSzKhpNa3T+BDd/6DqFYcR19lGkf1y0zIAmUimFGX+FmsB3HMqguj02X+23XSnb79DOf3OXvQeOLp/yD2MpHMBcrcjSB2wQv61HyoU7avRonJqa2PRVuEy6HHRgXI6KCBQQJ/ZkeKwLsmm2mkHD7XBTPpQ221vMsi0Sug2ZYjYAJz2ju58u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> This is preparation for teaching the page allocator to break up free
> pages according to properties that have nothing to do with mobility. For
> example it can be used to allocate pages that are non-present in the
> physmap, or pages that are sensitive in ASI.
> 
> For these usecases, certain allocator behaviours are desirable:
> 
> - A "pool" of pages with the given property is usually available, so
>   that pages can be provided with the correct sensitivity without
>   zeroing/TLB flushing.
> 
> - Pages are physically grouped by the property, so that large
>   allocations rarely have to alter the pagetables due to ASI.
> 
> - The properties can be forced to vary only at a certain fixed address
>   granularity, so that the pagetables can all be pre-allocated. This is
>   desirable because the page allocator will be changing mappings:
>   pre-allocation is a straightforward way to avoid recursive allocations
>   (of pagetables).
> 
> It seems that the existing infrastructure for grouping pages by
> mobility, i.e. pageblocks and migratetypes, serves this purpose pretty
> nicely. However, overloading migratetype itself for this purpose looks
> like a road to maintenance hell. In particular, as soon as such
> properties become orthogonal to migratetypes, it would start to require
> "doubling" the migratetypes.
> 
> Therefore, introduce a new higher-level concept, called "freetype"
> (because it is used to index "free"lists) that can encode extra
> properties, orthogonally to mobility, via flags.
> 
> Since freetypes and migratetypes would be very easy to mix up, freetypes
> are (at least for now) stored in a struct typedef similar to atomic_t.
> This provides type-safety, but comes at the expense of being pretty
> annoying to code with. For instance, freetype_t cannot be compared with
> the == operator. Once this code matures, if the freetype/migratetype
> distinction gets less confusing, it might be wise to drop this
> struct and just use ints.
> 
> Because this will eventually be needed from pageblock-flags.h, put this
> in its own header instead of directly in mmzone.h.
> 
> To try and reduce review pain for such a churny patch, first introduce
> freetypes as nothing but an indirection over migratetypes. The helpers
> concerned with the flags are defined, but only as stubs. Convert
> everything over to using freetypes wherever they are needed to index
> freelists, but maintain references to migratetypes in code that really
> only cares specifically about mobility.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Seems mechanistic enough.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Some nits:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ac077d98019f3..018622aa19006 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -422,6 +422,37 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
>  	return test_bit(bitidx + pb_bit, bitmap_word);
>  }
>  
> +/**
> + * __get_pfnblock_freetype - Return the freetype of a pageblock, optionally
> + * ignoring the fact that it's currently isolated.
> + * @page: The page within the block of interest
> + * @pfn: The target page frame number
> + * @ignore_iso: If isolated, return the migratetype that the block had before
> + *              isolation.
> + */
> +__always_inline freetype_t

'static' too?

> +__get_pfnblock_freetype(const struct page *page, unsigned long pfn,
> +			bool ignore_iso)
> +{
> +	int mt = get_pfnblock_migratetype(page, pfn);
> +
> +	return migrate_to_freetype(mt, 0);
> +}
> +
> +/**
> + * get_pfnblock_migratetype - Return the freetype of a pageblock
> + * @page: The page within the block of interest
> + * @pfn: The target page frame number
> + *
> + * Return: The freetype of the pageblock
> + */
> +__always_inline freetype_t

And this is declared in a header so the __always_inline is not really
applicable?

(seems we should fix up get_pfnblock_migratetype too)


> +get_pfnblock_freetype(const struct page *page, unsigned long pfn)
> +{
> +	return __get_pfnblock_freetype(page, pfn, 0);
> +}
> +
> +
>  /**
>   * get_pfnblock_migratetype - Return the migratetype of a pageblock
>   * @page: The page within the block of interest

> @@ -2262,10 +2323,18 @@ find_suitable_fallback(struct free_area *area, unsigned int order,
>  
>  	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
>  		int fallback_mt = fallbacks[migratetype][i];
> +		/*
> +		 * Fallback to different migratetypes, but currently always with
> +		 * the same freetype flags.
> +		 */
> +		freetype_t fallback_ft = freetype_with_migrate(freetype, fallback_mt);
>  
> -		if (!free_area_empty(area, fallback_mt)) {
> -			if (mt_out)
> -				*mt_out = fallback_mt;
> +		if (freetype_idx(fallback_ft) < 0)
> +			continue;

How can this happen? Is it preparatory?

> +
> +		if (!free_area_empty(area, fallback_ft)) {
> +			if (ft_out)
> +				*ft_out = fallback_ft;
>  			return FALLBACK_FOUND;
>  		}
>  	}

