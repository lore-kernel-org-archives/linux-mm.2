Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F537CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F288E0006; Thu, 23 Oct 2025 03:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28B18E0002; Thu, 23 Oct 2025 03:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EE48E0006; Thu, 23 Oct 2025 03:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D24618E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:17:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54688C0A7B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:17:15 +0000 (UTC)
X-FDA: 84028522830.17.2BBB0D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91C8BA0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:17:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X+22Ya4t;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761203833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWmnBT5ngvr9njtbSftjLam5zRLuE1USc4qEDs4FVqE=;
	b=2y04SNpT+fo77cd5IGVx9+0jDqh9CFMoHKi3uKORZ94oFT8ZAjwSVngkQEHvBPtwyqcF+e
	vag6ayoK2lqUgchN2ahh23SRx0kOzA2Qu7ePqrzLorYBUnFcFaAApvDrSygP3BQy9+lgV2
	cZ9mEyAuAuoHVoYMRO5XusXFRJLlTK8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X+22Ya4t;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761203833; a=rsa-sha256;
	cv=none;
	b=N0v6+TVm+Dl6jcQTFFDAHxTus7X4yH7ddrx+TV5DJY3sAbrYrK99+sxaimMdUUGCp8BfrB
	0x9gxfx/mxz/OLvvWb0AiBQda9WVAgc2Ron4JWfyT1PXo9TjSOTxNyKLl1Qx/FVir5Es9R
	2vQ15Hit9A3nCyAKYvjNszvr1gskQ38=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54784404F2;
	Thu, 23 Oct 2025 07:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0099C4CEE7;
	Thu, 23 Oct 2025 07:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761203832;
	bh=aJYcehfYwCvCUDaOKLROIKDPOq2/3yfyKeSUDbsb094=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X+22Ya4tF4cs0PyG5qMCz9ZDJ5xI4RUMHO2k5YjnMwo/ncjwP3h8Lelvmdag4gBJx
	 0qlqSyk4jej73GsN0F96Jenh90MjO8BJReLdJ9j65POtT/4LB8Ve/s4vVumK3pXaCb
	 red9qoBGMqbSmvv/PfsJT2KkzkbDrlF7CNAn22IGKhrVAsVLz6cUWJgUbfcu865P+V
	 WDt6cdkd+Tl9nArdND+mKUCLV6eHE1sGb/tizDO69lcG00W1d6O08UtPJhJlaqsapL
	 jJWxp/LTkIKLfmArPg4Og52A9sEGFygDdVEdFqQ7oNxc5nTLALOh/GQ3UGdkPRFH0N
	 ZQnAgxyiGHL3g==
Date: Thu, 23 Oct 2025 10:17:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCHv7 4/7] kho: add interfaces to unpreserve folios and page
 ranges
Message-ID: <aPnWbzytZ3I0heDb@kernel.org>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022005719.3670224-5-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91C8BA0008
X-Stat-Signature: gjxudxnstwfe75ghhsey5gcits1hdyim
X-Rspam-User: 
X-HE-Tag: 1761203833-786101
X-HE-Meta: U2FsdGVkX19LPzglWXOKeWSMSuWRZ7Z3h92qmDA3Jv03qtFHe9s2PzqWBF29/ltUo797qtwIpeRH179QLiPxzPE0ageeg7JjEjbCI8H8QrFeFKxy0lfgrlt9J9nv66csP43iwzs51yt5mLvDFn1g6tvsMV0JqaNGRwz4CAYjyMOOeN2sgQ+2QUTj2d2/0t6oUUXbE0Qa8GeuxR0+Sr05Np3vC7WqByhq3qaqSOFL2E5OtBgF+BD8qxpNi1jDm/TB/zBGRjnkA4RDrdIFve3ywzP2QuJqB0lrPU3uZoGmcD83opPg24EQrkpGBKamjhhk1klm8Os7bzRjTg5fPl43JvCmA96eSN/7ksEvgsOvHxvAckMvMo+ml2gA/9sUFs9U3DQkXXB4yCnaZWfLhm2VzVolmAOexN7c+L5ls0Hc9oHbIGwxv4VZlSc4itPHPhw8JhplY9OneclLx+EunKf69dGsCoTOWN1w7ABhQiskeMutW2nZ3pqQzSVd3hBjyjTw9c2i0hP6d6uBU/2svoNqocw34au44v+C+VZbuHxRU8j7JElEn5tBd7D2J/Q0xh/Bt/f6yqrZsztfqUVwSCviwrhDVC5+0m/CBXAosB4geWUkE0tBHLfVT/4GHn6XC4V/luH8/xYdC00ped9+mLtOpgFoaG4VvgGDPhEg/CyUh9TfRai+U0Kmg6N/LYhhctepASfHumeP9TJRhdg1rvzHNfPRkzYKmFlmIA0+UB50ACDacDrSWhQuYBPhS3nGgTGUmHVxsSbTGRD/9u5UbkyfAIY0sQkUTbflbuc1TeUeAVuUsYdEkLu/ko2cpE3j/350HKfH7V6faHzqvCdAuCSFV01WFaFFG/5AtCZtInIGhO8Gy8jHV82/8BUUg59U30KhLY0uxFldx6p33VJ0wqUsQgYujSNdaxbwUFsZiW5LnlP5BUrBaUHv+oYEuZOwX36glKto55vgrTu8mEXhBdE
 7PIq3jbi
 Zk2Qu9Wt49bigC3NVKomcZANonR3bT3ztJ3V24sOixtYd77H9L8KZ/ibJb+0jl/7Ito/r7KK9YLtXIjqh/HOTxvZDvR0mqGNBKO370UGUH1gP3sAXnOntcsxoao1ga9r+yr24YiXpP35Ud0uNi7ii1ybCNzq753ep6rIOy4LmgJNLnVeStNxvAFUwSxdbuTFBDVMNgEOn9VqgRpQNV92sDbHkqOxRY6wOuUpBO3PNin0N2mGLqCEd5Ozh+i1A9xaICkWHQtm1MIReaSKK99e9cMNPepN+Bzj4CXFzNgI6rcFfqrE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 08:57:16PM -0400, Pasha Tatashin wrote:
> Allow users of KHO to cancel the previous preservation by adding the
> necessary interfaces to unpreserve folio and pages.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/kexec_handover.h | 12 +++++
>  kernel/kexec_handover.c        | 85 ++++++++++++++++++++++++++++------
>  2 files changed, 84 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 2faf290803ce..4ba145713838 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -43,7 +43,9 @@ bool kho_is_enabled(void);
>  bool is_kho_boot(void);
>  
>  int kho_preserve_folio(struct folio *folio);
> +int kho_unpreserve_folio(struct folio *folio);
>  int kho_preserve_pages(struct page *page, unsigned int nr_pages);
> +int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
>  int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
>  struct folio *kho_restore_folio(phys_addr_t phys);
>  struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
> @@ -76,11 +78,21 @@ static inline int kho_preserve_folio(struct folio *folio)
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int kho_unpreserve_folio(struct folio *folio)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
>  {
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline int kho_preserve_vmalloc(void *ptr,
>  				       struct kho_vmalloc *preservation)
>  {
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 0a4234269fe5..8412897385ad 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -157,26 +157,33 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
>  	return no_free_ptr(elm);
>  }
>  
> -static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
> -			     unsigned long end_pfn)
> +static void __kho_unpreserve_order(struct kho_mem_track *track, unsigned long pfn,
> +				   unsigned int order)
>  {
>  	struct kho_mem_phys_bits *bits;
>  	struct kho_mem_phys *physxa;
> +	const unsigned long pfn_high = pfn >> order;
>  
> -	while (pfn < end_pfn) {
> -		const unsigned int order =
> -			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> -		const unsigned long pfn_high = pfn >> order;
> +	physxa = xa_load(&track->orders, order);
> +	if (!physxa)
> +		return;
> +
> +	bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
> +	if (!bits)
> +		return;
>  
> -		physxa = xa_load(&track->orders, order);
> -		if (!physxa)
> -			continue;
> +	clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
> +}
> +
> +static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
> +			     unsigned long end_pfn)
> +{
> +	unsigned int order;
>  
> -		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
> -		if (!bits)
> -			continue;
> +	while (pfn < end_pfn) {
> +		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
>  
> -		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
> +		__kho_unpreserve_order(track, pfn, order);
>  
>  		pfn += 1 << order;
>  	}
> @@ -749,6 +756,30 @@ int kho_preserve_folio(struct folio *folio)
>  }
>  EXPORT_SYMBOL_GPL(kho_preserve_folio);
>  
> +/**
> + * kho_unpreserve_folio - unpreserve a folio.
> + * @folio: folio to unpreserve.
> + *
> + * Instructs KHO to unpreserve a folio that was preserved by
> + * kho_preserve_folio() before. The provided @folio (pfn and order)
> + * must exactly match a previously preserved folio.
> + *
> + * Return: 0 on success, error code on failure
> + */
> +int kho_unpreserve_folio(struct folio *folio)
> +{
> +	const unsigned long pfn = folio_pfn(folio);
> +	const unsigned int order = folio_order(folio);
> +	struct kho_mem_track *track = &kho_out.track;
> +
> +	if (kho_out.finalized)
> +		return -EBUSY;
> +
> +	__kho_unpreserve_order(track, pfn, order);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
> +
>  /**
>   * kho_preserve_pages - preserve contiguous pages across kexec
>   * @page: first page in the list.
> @@ -793,6 +824,34 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
>  }
>  EXPORT_SYMBOL_GPL(kho_preserve_pages);
>  
> +/**
> + * kho_unpreserve_pages - unpreserve contiguous pages.
> + * @page: first page in the list.
> + * @nr_pages: number of pages.
> + *
> + * Instructs KHO to unpreserve @nr_pages contigious  pages starting from @page.
> + * This call must exactly match a granularity at which memory was originally
> + * preserved by kho_preserve_pages, call with the same @page and
> + * @nr_pages). Unpreserving arbitrary sub-ranges of larger preserved blocks is
> + * not supported.
> + *
> + * Return: 0 on success, error code on failure
> + */
> +int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
> +{
> +	struct kho_mem_track *track = &kho_out.track;
> +	const unsigned long start_pfn = page_to_pfn(page);
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +
> +	if (kho_out.finalized)
> +		return -EBUSY;
> +
> +	__kho_unpreserve(track, start_pfn, end_pfn);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
> +
>  struct kho_vmalloc_hdr {
>  	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
>  };
> -- 
> 2.51.0.915.g61a8936c21-goog
> 

-- 
Sincerely yours,
Mike.

