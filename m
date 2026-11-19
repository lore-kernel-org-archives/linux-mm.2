Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BF2606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dNDu9RIL
Received: by kanga.kvack.org (Postfix)
	id D51366B0699; Thu, 19 Nov 2026 12:43:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27F56B069B; Thu, 19 Nov 2026 12:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C653C6B06C1; Thu, 19 Nov 2026 12:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF2B6B0699
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:43:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3057740B3F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:43:16 +0000 (UTC)
X-FDA: 85452589992.06.FF2C642
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 78CA64000D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:43:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dNDu9RIL;
	spf=pass (imf12.hostedemail.com: domain of andi.shyti@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795110194;
	b=CBjl7wE5npfMOHP/IyI4EefSxIXA46X+GT7MF9rbSzl6SFf3Nc9a6tzNcybd98r/d4kWJW
	HwgRM4eWoAeOOr72BVg3CN07gtGRpR4rKPqaak7I/VQ7w9rVU/VsnnmbnCBS2ew7VOBjTT
	gabgzQA45yBQfBvwr78ZhGWH0dWpAxo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dNDu9RIL;
	spf=pass (imf12.hostedemail.com: domain of andi.shyti@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andi.shyti@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795110194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OP2Z6OwMvYcnCbVikE5bbFucvyV4pc4cThw1oGx4IIM=;
	b=ZgaNEWZqkV+zJ6EaQkdKHR6YKZ4SBEbYHhR28PsmOXOkEABZQ7Yajj2bOMvE7cXP7idGS6
	3qrDSCiXZnF+UHI8oqyFZCg8u1kvOfdUZbxvvT9F4uZztjhwxIxGviooTIcINVRNEfoiCc
	NLPu36LKhdW05CWUdQNfwe/k6iwFuYY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADDDF47441;
	Thu, 19 Nov 2026 17:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAB01F000C4;
	Thu, 19 Nov 2026 17:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795110193;
	bh=OP2Z6OwMvYcnCbVikE5bbFucvyV4pc4cThw1oGx4IIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dNDu9RILbXjxlt8R4ppKZSkXWe6g/BB83LL6uh8X6lPCUAn9gAW8mERhR4GGBRPf5
	 doQiFX9utToBExTiRfjinqkm3yFTnopZLd8l1oPjorvcPnAZAT+M09QFiarN/Yqw0j
	 GkV4FHjXkYc2YOk04s19UqNxfB/ZbP54SuIOnWgO/N1aubGa7SqhNEjz2CdT/Q6E+d
	 LoiRDln0arK6nQM1NVFaiD6LwhWhVMXE80W7mN5wgynFo/1a+h0brbNrULpaNPzgxl
	 +0bhuYIopQpzfSD+bFsEz7Ue8t0jafiNi9wlj1Msn9EjQDeuTh8pnYdC7ZwCtiaMq5
	 2Zj0HTPLBJacg==
Date: Thu, 19 Nov 2026 18:43:08 +0100
From: Andi Shyti <andi.shyti@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Andi Shyti <andi.shyti@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] drm/i915/gem: Skip writeback of shmem folios with extra
 references
Message-ID: <av8n42vx3Q7zvQK8@zenone.zhora.eu>
References: <20261119134243.3745282-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119134243.3745282-1-kas@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78CA64000D
X-Stat-Signature: ekxa44kkiubtkph8cdcbgz6wrc3phbzz
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795110194-304023
X-HE-Meta: U2FsdGVkX1+spgcXyPXGejYrCUSXXtLcV1CShB4D7ZS4aPbgjyvpwUVGRpIlgqoU2kUxgeqNRzi2sqvbkFxm92LQ8rVNUHZ4tSdCZjm3ExQtq5VRx8+imZ+OpYJGBpjbjpS7pz65lgToU1NRZmrcg/kIK107xOkMdSulkyekybPOXOLCAeHArAReNiHvN1YogGFWhpFioslqrBAWSMcSWZdToy0T2xa8Hus//gyhtHyRQejUc+V8j8GDic5cDO3xYkwvzaEQGV73SO6C+F/YYJ484HiKrpDWPu9AL90w7nD271L2y3y8aQWC1+PBwh6Pa9V42QN03mI5eQzmkINN1hCd9h46j+qlvXsuQ5LgRYAIf4vemEdnybnBnK17ROBB3Bhx1WXFgejaFYeL8vUF06/bJyaECQG2Z7mSZB/XNMd0qCWgxh1T9y/7McE9UtJdn2FGZICq/qlTRKIuh4yTYlmSeGFNw02ZcaeDzybW6fFb7B4Iim7Ffj0dQj5cfQGphqV9kGF7H31epowY6l4hARZXBXmkdn07+9bHqbUke1pcf+G/NLBtlRgWzrKpOUc48nilia92gDEu39NgvR8pEws3hNIsG5T0s5bQDRJBPiOEIFxDHrloP+csB7qCP+oB0YhtDkG6POCV0R2iR7NgkghNlqDpSQmSUUb9iD2yd4sfdrdfVzyMYZ5x5OMy+Pr4uWz2eg05M92sL5t1XULQ6IIna65THucJB81AgyoFsFQcUMfxw/Li9KnXAATOhZqBhNtki+3/N4CvCDAdaSr2zazi2Di2A0vF9T1Wqt/+GpvMvGS9NzWE6aMQc1iyZYx1pUGrGY8FAoeGnzckfcwLIy2oBtpVVjiFvaylB07hgFSBEKVBG/B3EbZiqKDI6u05wLBozuBMqBWLIdvHI67EJBblMhlE+FM504V2BKU9siLSqNJShw0oiIowG12kZSsDJ3Hcy4IzZIvwLCkzETz
 wr20lQW0
 qI7I/8rRpBCdxR4JefMZcOaj8Vt2gr+G9J9Ghgaj/cZZvua0Sl50vy87JkM0SH4zsfmmQ29Kbs0oI398dfT+SnvDjtWnyRd8WJnTvBso5clQJEd33J+5Z9IAkjjLVkkmRVbJueG18sFDjVwWYvdF7NYcD2SgdAtmm6TFK2OMZ8k9SIQuFXgYa39rW71QCZBq99FvW9M10knHK1KPf6OIaScNuY54OWjOlN5Id3y6MYmZBzeezdRVtmNgMOtqfi+mwK0Ta6vCXCwaWce1Dc/mKW4hZAfvJUvHOTdx/jCJAW9aRiKxkwPSYfOLFXI9pmChecrXY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kiryl,

On Thu, Nov 19, 2026 at 01:42:41PM +0000, Kiryl Shutsemau (Meta) wrote:
> __shmem_writeback() writes out every dirty folio that is not mapped. A
> folio stops being mapped when munmap() removes its rmap, but the TLB
> flush comes later. Until then another thread can still store to it
> through a stale TLB entry:
> 
>     CPU0 (munmap)            CPU1 (same mm)       CPU2 (i915 shrinker)
>     zap_huge_pmd()
>       folio_remove_rmap_pmd()
>                                                   __shmem_writeback()
>                                                     clear dirty
>                                                     !folio_mapped()
>                                                     shmem_write_folio()
>                              store via stale TLB
>     tlb_finish_mmu()
> 
> The store leaves the folio clean in the swap cache. Once reclaim frees
> it, the object reads back from swap without that store.
> 
> The legacy mmap ioctl maps the shmem file directly, and i915 mounts it
> with huge=within_size on some platforms, so the folio can be PMD-mapped.
> The core mm keeps the rmap until after the flush for PTEs, but not for
> shmem PMDs: shmem has no writeback, and pageout() refuses a folio with
> an extra reference.
> 
> Do the same here. The unmapping side holds its reference until the TLB
> is flushed, so a folio with references beyond the page cache and
> writeback_iter() is left to reclaim, as a mapped one already is.
> 
> Fixes: 2d6692e642e7 ("drm/i915: Start writeback from the shrinker")
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
> Found while reviewing David's fix for the same race on file PMDs, which
> leaves shmem out because shmem has no writeback:
> https://patch.msgid.link/20261116-dirty_file_pmd-v2-2-571883053174@kernel.org
> 
> Build-tested only.
> 
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index bf9e7480f0f5..748772c358ac 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -316,9 +316,15 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
>  	 * leaving only CPU mmapings around) and add those folios to the LRU
>  	 * instead of invoking writeback so they are aged and paged out
>  	 * as normal.
> +	 *
> +	 * The same goes for a folio with references beyond the page cache
> +	 * and writeback_iter(). A folio that was just unmapped can still be
> +	 * written through a stale TLB entry until the unmapping side flushes
> +	 * the TLB and drops its reference. pageout() checks the same.
>  	 */
>  	while ((folio = writeback_iter(mapping, &wbc, folio, &error))) {
> -		if (folio_mapped(folio))
> +		if (folio_mapped(folio) ||
> +		    folio_ref_count(folio) != 1 + folio_nr_pages(folio))

I don't think we need this fix in the current tree. The i915
writeback iterator already skips the shmem folio in the case you
describe, so the new refcount check doesn't change the outcome.

Thanks,
Andi

>  			folio_redirty_for_writepage(&wbc, folio);
>  		else
>  			error = shmem_write_folio(folio);
> 
> base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
> -- 
> 2.54.0
> 

