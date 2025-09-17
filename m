Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB75CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85E68E002C; Wed, 17 Sep 2025 10:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36E58E0003; Wed, 17 Sep 2025 10:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73BA8E002C; Wed, 17 Sep 2025 10:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A592A8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:38:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 642771A0587
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:38:31 +0000 (UTC)
X-FDA: 83898998022.10.83AE034
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BAC23C0008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:38:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b90Md3nL;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758119910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xH0CxH1sst+TBwDERDGYqFGRzS3ZB+E+pvfDx8IJe5g=;
	b=vMPlRLr3DTv7BJ9owJsCiuWN1NTHf3icKIDS8humF+UC/1dCbsUoqZ0bFxwRs+wi8Sz6sC
	w5gnOOtd6k8RW38NTmJf6WRYmbire+1Hp/pnl0e+3PwwGvYIhkgXohpnsI6XLiqYF++Ue9
	XzBKJmjSD8jugmaN9Fw3w/22lhoLLF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758119910; a=rsa-sha256;
	cv=none;
	b=mewvV+1G0DFnwZDFVR+QHwUeBzeV2s7FdZe1s9Ok5aMT1HPe7MGsyw4LBDT/OdOppDMHPL
	asv33iRt/5FEnjcGGaX6BVgH5Scd2jEubOWEgJWwjj90fdZ2r/8TbW9V9Cnudhxryn2RxL
	gsi/TxqUZYfUwFqOm14wDqJynUN9DzA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b90Md3nL;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52C3444E46;
	Wed, 17 Sep 2025 14:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340F6C4CEF0;
	Wed, 17 Sep 2025 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758119908;
	bh=yXQMzE7u7vJaWF+q6evpHmh8mnMRx6jAmJ0dmD7uxfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b90Md3nLg06AdbPclruBh+rd1NWg7t+FS3LkQzq4szbDX498eIhaNARcp+1IrXyOI
	 SPgHbuuasO4C+9du0cQTx7OacTI43kME4HB9h8Ap5XWux0egahlrtxkEdbW0TlE0Kq
	 ymMNXCwakoDrKnqAOojTA9u99vLlx+64aYCqUhoe+r/YBUu0RLyu5KOX1FTNB7q8f6
	 T5dbDZGR5I5mor4KLhpj1sj3oOEiBYDx3VYLmRDW29FaKFr5P2iyYc+0olaeHN9O0B
	 l7rvvwAAwdmiJ2Q8ET+ksGXNeOHg4FZvIMSlnMYivz3pNtil5U04nvjx8vfIxyFgD6
	 R3ASHM9Pp9hog==
Date: Wed, 17 Sep 2025 17:38:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] kho: make sure page being restored is actually
 from KHO
Message-ID: <aMrH3NQzFrmMbEd3@kernel.org>
References: <20250917125725.665-1-pratyush@kernel.org>
 <20250917125725.665-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917125725.665-2-pratyush@kernel.org>
X-Rspamd-Queue-Id: BAC23C0008
X-Stat-Signature: wgxq9b53p7tke49of5dn5zhmsytcde8d
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758119909-786134
X-HE-Meta: U2FsdGVkX18lrjDuPjBEoRmaemuF4+wlEae0wEpChebS4I6NyrtpSjbZxWUtA6xvKDW3q4HGj0Pdkg1gAPeDJPHSBCz18/z8qpbUlUXKlRNfWP7UsyBcbL2f7gGlYMIqMwOkidCMb2o2O1OgF7e5jncqjpl0sw7JyTZpdfPnyU3y/k9FToP4qxXOz50nd/pzcLhXIcL+twimtRyBkf6f2E5P8SvFllqgdMGnsniYwIdJ+hMqXfboNiz75RaBsG/BU01LQDtF5lB0vQWF2H3byK6v/Z7HYJjAIPrQ3mlRbspJCjm78hvi6Ig1jo8aInsiSUXU8Hxa50UQa0lT8qu/Cmo7kJGLuv1oOYopQ04jhqaJEY6BkiHEAZlGbGZYWxPrk1aOBHdbxnRaad7mHoFbFNowtjxQ8rWSEdriLjxvFbNzbMj3PEKxoJs2QDI+siIuzOQjU9N5t8ZZ/th4aelzncIo9EtZXjzCB+lyxA0HfJK9n0GL/QcXyhdsEVBeiynvXmFqUUn1paA+gjjr08JaoRf8OZXipzqqqPOxNS7SA01hC1DFc66kQOsJ3KSlCUZWVZGfDbNrufHEwG9hOxShjbf+Duf5ZKJWMfPMvrbpVabZ7WuGnQdrIMdeMjXRt0stpUoTtSNc5E4pg9RuVinOoy14InE3mApvT46lnQTH3hx0yOczfyzxp/RJCzSiCifv1AuMHGi2w9A59U7tND0AflPiPNj7rLhaRgvtF1Gt8vnVX36f3lqr15eN3IcBiYyruq/xdb5ZA5Y4pP50UOGEMjqNbw6Fd+/L02NFOPl66ZAVQIGyTmee1LH4rfs6a8SMf0iynMTDsIxAsz1ihEjNdchogZMjPfub6N5UUz/GakGj6KtXCVH2gvBQ2lLlOv89L9LrbsAaznPtXRkRhLapbgAATCcTTj33lakdv3Jx5u67h0jWD0jeJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 02:56:54PM +0200, Pratyush Yadav wrote:
> When restoring a page, no sanity checks are done to make sure the page
> actually came from a kexec handover. The caller is trusted to pass in
> the right address. If the caller has a bug and passes in a wrong
> address, an in-use page might be "restored" and returned, causing all
> sorts of memory corruption.
> 
> Harden the page restore logic by stashing in a magic number in
> page->private along with the order. If the magic number does not match,
> the page won't be touched. page->private is an unsigned long. The union
> kho_page_info splits it into two parts, with one holding the order and
> the other holding the magic number.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Notes:
>     Changes in v2:
>     
>     - Add a WARN_ON_ONCE() if order or magic is invalid.
>     - Add a comment explaining why the magic check also implicitly makes
>       sure phys is order-aligned.
>     - Clear page private to make sure later restores of the same page error
>       out.
>     - Move the checks to kho_restore_page() since patch 1 now moves sanity
>       checking to it.
> 
>  kernel/kexec_handover.c | 41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 69cab82abaaef..911fda8532b2e 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -32,6 +32,22 @@
>  #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
>  #define PROP_SUB_FDT "fdt"
>  
> +#define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
> +
> +/*
> + * KHO uses page->private, which is an unsigned long, to store page metadata.
> + * Use it to store both the magic and the order.
> + */
> +union kho_page_info {
> +	unsigned long page_private;
> +	struct {
> +		unsigned int order;
> +		unsigned int magic;
> +	};
> +};
> +
> +static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
> +
>  static bool kho_enable __ro_after_init;
>  
>  bool kho_is_enabled(void)
> @@ -186,16 +202,24 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  static struct page *kho_restore_page(phys_addr_t phys)
>  {
>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> -	unsigned int nr_pages, order;
> +	union kho_page_info info;
> +	unsigned int nr_pages;
>  
>  	if (!page)
>  		return NULL;
>  
> -	order = page->private;
> -	if (order > MAX_PAGE_ORDER)
> +	info.page_private = page->private;
> +	/*
> +	 * deserialize_bitmap() only sets the magic on the head page. This magic
> +	 * check also implicitly makes sure phys is order-aligned since for
> +	 * non-order-aligned phys addresses, magic will never be set.
> +	 */
> +	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER))
>  		return NULL;
> -	nr_pages = (1 << order);
> +	nr_pages = (1 << info.order);
>  
> +	/* Clear private to make sure later restores on this page error out. */
> +	page->private = 0;
>  	/* Head page gets refcount of 1. */
>  	set_page_count(page, 1);
>  
> @@ -203,8 +227,8 @@ static struct page *kho_restore_page(phys_addr_t phys)
>  	for (unsigned int i = 1; i < nr_pages; i++)
>  		set_page_count(page + i, 0);
>  
> -	if (order > 0)
> -		prep_compound_page(page, order);
> +	if (info.order > 0)
> +		prep_compound_page(page, info.order);
>  
>  	adjust_managed_page_count(page, nr_pages);
>  	return page;
> @@ -341,10 +365,13 @@ static void __init deserialize_bitmap(unsigned int order,
>  		phys_addr_t phys =
>  			elm->phys_start + (bit << (order + PAGE_SHIFT));
>  		struct page *page = phys_to_page(phys);
> +		union kho_page_info info;
>  
>  		memblock_reserve(phys, sz);
>  		memblock_reserved_mark_noinit(phys, sz);
> -		page->private = order;
> +		info.magic = KHO_PAGE_MAGIC;
> +		info.order = order;
> +		page->private = info.page_private;
>  	}
>  }
>  
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

