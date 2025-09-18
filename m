Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4E5CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7E28E00EA; Thu, 18 Sep 2025 06:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FAF8E0093; Thu, 18 Sep 2025 06:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56848E00EA; Thu, 18 Sep 2025 06:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C21818E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:32:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D676140856
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:32:14 +0000 (UTC)
X-FDA: 83902006188.28.1DB5B49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 969684000B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:32:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smkYQj59;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758191532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5a5kwMi33I+A3Y2PADe+7+W+ASlKPSpUDe01fp//o8=;
	b=4OisgeT9drwEE62fb6EgKiLma3EJc+x6Uo3oDrIkki1B6aP5+NMGUDkm2wQr+sImXR6OKc
	okTQbOVzQdTmS8ooAoIycUOggXnUWAjCKnClNp/yau0k5b/Ewbaio0bQE5z37tTsuNGrSR
	WzCpQFaAK/WKDHEN9pR/nm1VLxd/7U8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758191532; a=rsa-sha256;
	cv=none;
	b=UVrLqxeY98A30M/Z1sVs6MZK8N7RRcJwqdCjwf8wHPltCk4rMeq+JPx59cwDqabf9gwqCB
	zTZCoA4tyPwkOYwi6CWQtRBR3HrJcR/RLmsg/BCiiSRZmdDGq+kj6gp9aTZ9R46cRUBbiw
	hcqcXNC6B9HvDsEWN8YjkFubWIAe9fg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smkYQj59;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DB6544A06;
	Thu, 18 Sep 2025 10:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772E8C4CEFC;
	Thu, 18 Sep 2025 10:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191531;
	bh=yy2/qGmH2QA2swtXgVVOAHnOxEMhRZ0NhObdYrFdpP8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=smkYQj59cJEB2MBpLMWEo/hAvXX7jkJTDCXOe2YP6B8kjmfCFAlaw29s3ux/BKgAB
	 BN87ihWMAGN0M8GH5XkkXR5gSQpGbFfOkSdZVWemcu7XAPnuioH89tfzj4ndhqDfRM
	 mrfhGj0JEG72SS2jkPZ4pVFACZ4hfclVKHHxc6f/4ESFCWacU7MYgbI6XOZ/g6HCZ9
	 Vmq73d/+GCK2p37SXDMw+YFGDctVpPmeikPcp/k3Um83y5bPqrAZTTxnAGCeF2lpS7
	 zLE1C7TdB7kXGrUvzq9wunjrmFRxhcoyiGYcu2Ij8YlqqHofGS5VPp0T5kp9hz09v+
	 KWqav/GLcplpA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,  Changyuan Lyu
 <changyuanl@google.com>,  Chris Li <chrisl@kernel.org>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] kho: replace kho_preserve_phys() with
 kho_preserve_pages()
In-Reply-To: <20250917174033.3810435-3-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
	<20250917174033.3810435-3-rppt@kernel.org>
Date: Thu, 18 Sep 2025 12:32:08 +0200
Message-ID: <mafs05xdggifr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 969684000B
X-Stat-Signature: uean1rezj4kywdz1qtgko85n5o83fdtw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758191532-580745
X-HE-Meta: U2FsdGVkX1/Icwt6eNbZK0kCkDarHbTdCXgZyutK9f6Hvs5QAZOvdVi5vFaUdpBeSwX52RoIPR3mxTgYYukde5fi6cB3I5Ty//2o5HAo0YnihUzRukjVLwmzInVhbJhfsRmzMuXf4HqCJYzpKDoKTob2WpnLOPNBZH1J2iDAEgYREFyCCV5LXLe0Xp3Yrxk6TgXu4waPCjaDtzZ6fWma4FnwHRs+o4yvzqlkRZmssR/EvKbiFEm3ZwLc7CjlVabBqJYj0nSr/gZXQjtz+ez/xbzg23BX5PbbjcG2B/RARnt1PTGSkjI8tkKFOO7RN90+jtPVlkrMHFvIwlcLcTI3GbbNzhGlCoi+ZVdJsMurI0u6kP+68za74QmHGmL+zPl0Fm5ZsyWbN12iLkmA43cgeouRiRQoQ6elM52JgLyPkM2ss9oO+nM8ionV1WSsSmVVx9hXY69UkHU1SqN9TfUq6CKmVCbW0ygArPYPRI1l3lIntD664HwTV9L+aOWJKnW5moPvrAY7X9Gky+vx37l83ViNcG2YzEYNyMTg0h9eXRCfwkPu7V8NNUfXdkp3+RaFX8lgIte+12O1Y14HDJq48XiVvQ3Jj7jdSvDHweClXrQ90tJyXRW6mLtdLV75TfnN5tIun9np62zk2JOhGFZN0Tx/EE8jL9kMWYsrk6sMk7rtggBVKq3NCMAi4cw8YpDUSmiQMkwtwHNBfQfDyHADlfV5i+ckCV23UxFp64VWW2K/2qedCx9m5U6iCqA9x93LFEcXmVbrtUNwM9VXo20bFOGYaguwnvcBDWC34YO77hxIkpPdz4gScaS1d+7fphj8bUEhvBRUBNbFAfJqcVp40pLfUHjQ0/M6DHG6XMJocRvTX0VOzgO3eZUZVBbIK3ENRUg8T6o4bHYnZQXxkqu4NGg7rXD3+ty96q2X5W07YeZ91Mkj5faeE7A5ZGJJ3Pl/l4ADyt0/WO85LNbIUoI
 uD6EbYBB
 fXr516FsUzwgb8AYJ+R/PHzGGR+64XK2wdPPLvwHh11regZvvrrcZwJ/Ih4xCB+Li/BTDajTd5rtGvrupjK+KnaNJ9pQO3rXu3eDlMW4UptbYFRgtUfZTaDALg5IuvXpcRBnx6RykRWd62Kz0fzqkfli/LtL0GgxNGGvfOMiHEX+34iEikUMBCRVuNeTslYCwQeWmDcjOtaix7Rk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Wed, Sep 17 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> to make it clear that KHO operates on pages rather than on a random
> physical address.
>
> The kho_preserve_pages() will be also used in upcoming support for
> vmalloc preservation.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/kexec_handover.h |  5 +++--
>  kernel/kexec_handover.c        | 25 +++++++++++--------------
>  mm/memblock.c                  |  4 +++-
>  3 files changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 348844cffb13..cc5c49b0612b 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -18,6 +18,7 @@ enum kho_event {
>  
>  struct folio;
>  struct notifier_block;
> +struct page;
>  
>  #define DECLARE_KHOSER_PTR(name, type) \
>  	union {                        \
> @@ -42,7 +43,7 @@ struct kho_serialization;
>  bool kho_is_enabled(void);
>  
>  int kho_preserve_folio(struct folio *folio);
> -int kho_preserve_phys(phys_addr_t phys, size_t size);
> +int kho_preserve_pages(struct page *page, unsigned int nr_pages);
>  struct folio *kho_restore_folio(phys_addr_t phys);
>  int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
>  int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
> @@ -65,7 +66,7 @@ static inline int kho_preserve_folio(struct folio *folio)
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
> +static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index f421acc58c1f..3ad59c5f9eaa 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -698,26 +698,23 @@ int kho_preserve_folio(struct folio *folio)
>  EXPORT_SYMBOL_GPL(kho_preserve_folio);
>  
>  /**
> - * kho_preserve_phys - preserve a physically contiguous range across kexec.
> - * @phys: physical address of the range.
> - * @size: size of the range.
> + * kho_preserve_pages - preserve contiguous pages across kexec
> + * @page: first page in the list.
> + * @nr_pages: number of pages.
>   *
> - * Instructs KHO to preserve the memory range from @phys to @phys + @size
> - * across kexec.
> + * Preserve a contiguous list of order 0 pages. Must be restored using
> + * kho_restore_page() on each order 0 page.

This is not true. The pages are preserved with the maximum order
possible.

	while (pfn < end_pfn) {
		const unsigned int order =
			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));

		err = __kho_preserve_order(track, pfn, order);
		[...]

So four 0-order pages will be preserved as one 2-order page. Restoring
them as four 0-order pages is wrong. And my proposed patch for checking
the magic [0] will uncover this exact bug.

I think you should either change the logic to always preserve at order
0, or maybe add a kho_restore_pages() that replicates the same order
calculation.

[0] https://lore.kernel.org/lkml/20250917125725.665-2-pratyush@kernel.org/

>   *
>   * Return: 0 on success, error code on failure
>   */
> -int kho_preserve_phys(phys_addr_t phys, size_t size)
> +int kho_preserve_pages(struct page *page, unsigned int nr_pages)
>  {
> -	unsigned long pfn = PHYS_PFN(phys);
> +	struct kho_mem_track *track = &kho_out.ser.track;
> +	const unsigned long start_pfn = page_to_pfn(page);
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +	unsigned long pfn = start_pfn;
>  	unsigned long failed_pfn = 0;
> -	const unsigned long start_pfn = pfn;
> -	const unsigned long end_pfn = PHYS_PFN(phys + size);
>  	int err = 0;
> -	struct kho_mem_track *track = &kho_out.ser.track;
> -
> -	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
> -		return -EINVAL;
>  
>  	while (pfn < end_pfn) {
>  		const unsigned int order =
> @@ -737,7 +734,7 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
>  
>  	return err;
>  }
> -EXPORT_SYMBOL_GPL(kho_preserve_phys);
> +EXPORT_SYMBOL_GPL(kho_preserve_pages);
>  
>  /* Handling for debug/kho/out */
>  
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 117d963e677c..6ec3eaa4e8d1 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2516,8 +2516,10 @@ static int reserve_mem_kho_finalize(struct kho_serialization *ser)
>  
>  	for (i = 0; i < reserved_mem_count; i++) {
>  		struct reserve_mem_table *map = &reserved_mem_table[i];
> +		struct page *page = phys_to_page(map->start);
> +		unsigned int nr_pages = map->size >> PAGE_SHIFT;
>  
> -		err |= kho_preserve_phys(map->start, map->size);
> +		err |= kho_preserve_pages(page, nr_pages);

Unrelated to this patch, but since there is no
kho_restore_{phys,pages}(), won't the reserve_mem memory end up with
uninitialized struct pages, since preserved pages are
memblock_reserved_mark_noinit()?

That would also be a case for kho_restore_pages() I suppose?

-- 
Regards,
Pratyush Yadav

