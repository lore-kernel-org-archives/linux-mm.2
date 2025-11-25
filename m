Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D04FDD0E6E3
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5546B0026; Tue, 25 Nov 2025 08:46:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E8C6B002B; Tue, 25 Nov 2025 08:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F956B0088; Tue, 25 Nov 2025 08:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3ACA6B0026
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:46:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73848852AD
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:46:04 +0000 (UTC)
X-FDA: 84149253048.27.663FC85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A6D9440008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:46:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lcdV7eih;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764078362; a=rsa-sha256;
	cv=none;
	b=icaE9ItV61Dm+SrrOaBLEgiTmcxG1UDmIU7oeGDlDrqPCizRxiDIH/SQr3pRwmx85sffrM
	jZG+fAreZ+nCTBrZeBr4UMZqEutk0nlQAds/xojXJ1ZsH/yp3nN9kb6ZQhGTQjtNHS1Rv/
	9NOILXpH/nfnGyVnyL3hp8JrPxCjhBQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lcdV7eih;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764078362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUoeADxT0VkKE4h/ybzz40S3j/EuiATzB88i1IlDQLY=;
	b=E8PmlQj0w08eaHtQTqNUfkWl4kOXlLuNr0xZb1/H7d3MdNg7uR+PNrcK8MXvd0KIFEv07S
	pskYP4qoBek2PCRKCWn/yfNmPtO1y6BvXZDe8hpQqkgFVt2EmMXRgwAijO9uW1vAvAv5V5
	zEQcNvG+5tjTgFXAQxDaiE8vy7w4NPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76E8E43912;
	Tue, 25 Nov 2025 13:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AF1C4CEF1;
	Tue, 25 Nov 2025 13:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764078361;
	bh=dl+oPp/GipwLpjlWzXAhu4z0Q+oNDkuAziTjJDqxIrM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=lcdV7eihvC0Jk/3ytxRRdD1z9X+DUj1r2zKdiNuXwXfrjInezOai08J/l1JHj6y6q
	 D+oZEsGd2nN6o3kXIQ6Hy088r0O9Dlb/9MC9Au1CiJkAMgMVRjSydFAXbT2eCotU8F
	 II2V4q2c8Z+rvPfCFLeV28/11PtXgJSt2sNd8h1uS8EtuQ2DgwocXLVKC9H6jiB2ru
	 2zx5oQvc2/ZQhDpylsX1dMA1abJhOct5KJzQ8lbCY63KpVKCMDBZuqht6RmEZox3cI
	 jrTnIwweJX49Woo4OG0ceQ14IrUTVX2FD6S8CO/jCW7l3Tt16OnyPd2T56NNwyDCQa
	 3XwYpK9VfYeSQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kho: fix restoring of contiguous ranges of order-0
 pages
In-Reply-To: <20251125110917.843744-3-rppt@kernel.org> (Mike Rapoport's
	message of "Tue, 25 Nov 2025 13:09:17 +0200")
References: <20251125110917.843744-1-rppt@kernel.org>
	<20251125110917.843744-3-rppt@kernel.org>
Date: Tue, 25 Nov 2025 14:45:59 +0100
Message-ID: <mafs0pl96w7hk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6D9440008
X-Stat-Signature: 1mqsqzgdib5kfnk134xsffzkux1fzpft
X-HE-Tag: 1764078362-154167
X-HE-Meta: U2FsdGVkX1/9+FnWfbhRnqkJedjWQCWYK5+ug8hZkn48T19lIZ7YwKBLC/VV7kS0GRjqZQCDXhrXT8GpSa04ozKMdE0YZQQ+VEbAgnABqI1Hn57c9U5skIY4DK/MX0DjICEKwJBXVUSz3tzcTHqyTrKRDVZGD5R+klx+Bg53WunZvZCbeOj+ey07+J+IRWM91m93Nl+JzSK2K2McEC8BpE+87pmYae8P2wAoEF6cUibiqHsV+AquEmd+6ezQHbxufZJ2eFS0sTufPEkNiOniTtyHFSRANd/dqaeVS2iCWNR7e0yWcShBJDWoa3GnvPodV3XnpDCkU0FTBE4mhEeGUrwwPBGJ3c+P3UGWjOKI8rtdfURXs5XTUwA32eVK3zC7aOmQIoelDU03Gmx06hGZjHHyVUAXFCtr3TVNkKHtUNNdQtwfAiNlVpSeUvXAzOcdvucH/YF9x5Wld+j4/wttOQEfttvmQIkPYPZ7qg7JO0i8o3gq4vyFTkqMworRuBXlMOKbQbGpG1InR7yCJrV59M0Ero67A2ks6RMGijjPUGVRxfYUp5M/eZ1txPetTVirYZkaAycEmgoQCqEfWiiAKYidg7pAQAqfUJUO/S9tCryxmC8ARZAIluQufp97aa2Rr11cNSvfi+0UsTUQOeJi9okJvDSfmH0JSYZyNoKKisoaGEAflMd3cXVty4oFX8gGWXF0SEGtqbmGE3/6XxCvPRjemnb9wSj1rcvt9Y2QxDjsYFnx71nVPhSk6FSwRU7eNHtCJ/h5K9Oj06PviSbuV5CRyIThZxnuEV8tZfTAkJTvNidssmaEVGyt/n05LUg2bCu3ryW95z/6NQCJ3d9yzvxX28ayk7blXFO8/Rkfo+sgy/Pm+SbzBJEYRSjMX1GqmDfsc3ft5vh4zzWSqvV/4YbKw/PgrgzSjf2rk1yiRz76Sv6jrBV5Yfx4ZAE4EnJm+MKBE0z++ZfjyWVURI+
 rRtANG9N
 TvoTubkbMGATvim5gLkp6/wx1+hlaIEgqa61vvS8grpLEMJeWtzkmmcwXezdj+Yn8ixK8BWBbEn4e8bxinHy8Wa1ljEQ2lSJtl9mThWIfEjxGK0O3wHCZt4CPRfoT1ptn8A/N5DPbkdC5HLKd3JDhIajPOJfeqguUx8ml3Xl1DX7gCE3dyvrJGkx5sscZxep5fLIG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> When contiguous ranges of order-0 pages are restored, kho_restore_page()
> calls prep_compound_page() with the first page in the range and order as
> parameters and then kho_restore_pages() calls split_page() to make sure all
> pages in the range are order-0.
>
> However, since split_page() is not intended to split compound pages and
> with VM_DEBUG enabled it will trigger a VM_BUG_ON_PAGE().
>
> Update kho_restore_page() so that it will use prep_compound_page() when it
> restores a folio and make sure it properly sets page count for both large
> folios and ranges of order-0 pages.
>
> Reported-by: Pratyush Yadav <pratyush@kernel.org>
> Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index e64ee87fa62a..61d17ed1f423 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -219,11 +219,11 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  	return 0;
>  }
>  
> -static struct page *kho_restore_page(phys_addr_t phys)
> +static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  {
>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> +	unsigned int nr_pages, ref_cnt;
>  	union kho_page_info info;
> -	unsigned int nr_pages;
>  
>  	if (!page)
>  		return NULL;
> @@ -243,11 +243,16 @@ static struct page *kho_restore_page(phys_addr_t phys)
>  	/* Head page gets refcount of 1. */
>  	set_page_count(page, 1);
>  
> -	/* For higher order folios, tail pages get a page count of zero. */
> +	/*
> +	 * For higher order folios, tail pages get a page count of zero.
> +	 * For physically contiguous order-0 pages every pages gets a page
> +	 * count of 1
> +	 */
> +	ref_cnt = is_folio ? 0 : 1;
>  	for (unsigned int i = 1; i < nr_pages; i++)
> -		set_page_count(page + i, 0);
> +		set_page_count(page + i, ref_cnt);
>  
> -	if (info.order > 0)
> +	if (is_folio && info.order)

This is getting a bit difficult to parse. Let's separate out folio and
page initialization to separate helpers:

	/* Initalize 0-order KHO pages */
	static void kho_init_page(struct page *page, unsigned int nr_pages)
	{
		for (unsigned int i = 0; i < nr_pages; i++)
			set_page_count(page + i, 1);
	}
	
	static void kho_init_folio(struct page *page, unsigned int order)
	{
		unsigned int nr_pages = (1 << order);
	
		/* Head page gets refcount of 1. */
		set_page_count(page, 1);
	
		/* For higher order folios, tail pages get a page count of zero. */
		for (unsigned int i = 1; i < nr_pages; i++)
			set_page_count(page + i, 0);
	
		if (order > 0)
			prep_compound_page(page, order);
	}


>  		prep_compound_page(page, info.order);
>  
>  	adjust_managed_page_count(page, nr_pages);
> @@ -262,7 +267,7 @@ static struct page *kho_restore_page(phys_addr_t phys)
>   */
>  struct folio *kho_restore_folio(phys_addr_t phys)
>  {
> -	struct page *page = kho_restore_page(phys);
> +	struct page *page = kho_restore_page(phys, true);
>  
>  	return page ? page_folio(page) : NULL;
>  }
> @@ -287,11 +292,10 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
>  	while (pfn < end_pfn) {
>  		const unsigned int order =
>  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> -		struct page *page = kho_restore_page(PFN_PHYS(pfn));
> +		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
>  
>  		if (!page)
>  			return NULL;
> -		split_page(page, order);
>  		pfn += 1 << order;
>  	}

-- 
Regards,
Pratyush Yadav

