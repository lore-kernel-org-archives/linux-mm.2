Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFE7CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA2B8E0019; Wed, 15 Oct 2025 08:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A088E0002; Wed, 15 Oct 2025 08:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462508E0019; Wed, 15 Oct 2025 08:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324C38E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:10:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D22C3117053
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:10:49 +0000 (UTC)
X-FDA: 84000232218.05.CB6EBBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D47AC0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:10:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sd5Ito2z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760530248; a=rsa-sha256;
	cv=none;
	b=6V/e7p9EM0r5BsgIavCAEZ4iDmPnw7BuFPCicV31WXodLBlbx0SJniHNV+bK/KVueY3YBO
	dFL51Yur8zU94j3HWGxa75SZxlVOQ7peaZpVUIr67P2/j96AMTgqfqgqnVlAg2ceqlhPha
	8MXd/hBPJAgt5vBNxxgcCzsKnvy5GRs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sd5Ito2z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760530248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjcAu4D35+8ddYfP5ogyph4cHo9YUSa7agtex6ehUck=;
	b=cHTzpTKNV6E5adknr9mxbRiDNmrdT/n3cU9859daavKd21bglne5GIm5sxdKImunrJA2Ae
	DqmnSTOQ4al1JrXQB2ZwEhkmnZavGkjYyv109Fs9jLC4DrbcmSrL9rCVurNATV2PI3Mr/4
	q6qfJGvulsWLKfvtYiYLtrqLRddZGYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 344A463D25;
	Wed, 15 Oct 2025 12:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75197C4CEF8;
	Wed, 15 Oct 2025 12:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760530246;
	bh=FRp2nP/cabZWIQTDCFbnZuskgerA1RB/tXfMpaKNBeE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Sd5Ito2zl8yQO/MD6izBpbkQAVgwascCvAqBfIQR3xW8OA7rngdhvt9B6dIBGQnnd
	 bhQHJQIOObOA3A/qMXGlxL1uE5OhQ6OelV16v1EhWvOFiEnhTIvBdA7rogW4hJJzag
	 r9Y0enGq8mLUUp52YEJw6qQdUjCMN/LISe8He4d3+Ea30IeQSwxMBXFw0i3lhKeWYH
	 PPph2OZ2gtJCSO07L4BDV/0R6heC92LTIgWUNnjOHm3jOHxgd2y0bUQbiQnlKCMYes
	 5ByZB9EfQNHq1KKSeyzRb7pFFa6CxqjpNUSz6W5kUTxdKPfdJnIoncFtSo/9ETOtbp
	 9PKuHLBk3ADAQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  jasonmiu@google.com,  dmatlack@google.com,  skhawaja@google.com
Subject: Re: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
In-Reply-To: <20251015053121.3978358-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Wed, 15 Oct 2025 01:31:20 -0400")
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
	<20251015053121.3978358-2-pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 14:10:43 +0200
Message-ID: <mafs0zf9sjrgc.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ppm9di8oh1qr6km6dgtr8ei3ac4ccdq8
X-Rspamd-Queue-Id: 1D47AC0002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760530247-348113
X-HE-Meta: U2FsdGVkX1+GqvTFjbQQ8qKca4NS4JBmFkvuJ0FL08hHrZ2BPkz4IBfWMZcZ84YY6NCbO2QL07ZdqEluaQObYPNPzNcRfMlyQJ99Vkcwb7gsNJhMoIbjMUQGUoseyoGLTamNoyngxQ/tQywiwodz5wJNp98kzzo5UfefprHdlGMsar1R7s91NnhoYIkWkIlLdf5KjG8E4GYUG9BBRad0UUHQkOqUdgklUoLTHI+t95qkgG53GJomfdUUse8EPUOVYu0m+zPyjzFyKiINVE25IQoFsCvsmigtEWcN6BKeCg1UI7weg/HWQpzDcmRWU0CVJwopg9qlwoFKsd54A/5f9Nqnk76D/xEqv9JVSHH/XbPBH1bT8WKe8MMsK0FB8TGhq5aNJ+J4hnLN8NdEUif58DfqRpOrWAXltHANaE56xFiIVzc/hC5WKMQfed7DEM2Y9MmieYaSu3xqxEOPYXnXbmz2cJMfAhn0m/+iSFHLW3gl0WYLtD0PG9S3oRlaDLrULzSQImXw1mvmzmVFKVFU5qHeD6wJURMSXeVwsDAhdulYiNVCp1cEqTXqrlmLtaz1PtzBumuTOeB/HMzeocdY0m2pAEb0PCHhcZdwCbpGzVOBFFPcHCIfaDA8HUWl+8Z3N0wQzOIJIcIm3HgbaQ0kgrKy1d67Q0720bFH9QIpzy9YH/FDkmXJvll7HiDqO0diMY+srgWjqVKiejqprZi4bb7OcjHkI/8vPneLHKqq6YKCwxCIDrz9ankyOLfBtcXZoDmSD/XBedmdDgdRUGMcGR6SZr0TsYc1lZTS/Io98cPKbmBpl1NDIo7+3TgxyyIyDQP0pZ5ozRN88/xp1k4XcUiDxQfvujSogYaHJHTccqjGWQVMu6ip4q3VvsN6ljwil4WcHZw9eGoXH2G0buiZQbZ+9aILQADwxr5rCO72CVojlXqTsyxTJYLB0TWSylNH+IcOho456bS2Iwqgfea
 YTl5GsmO
 DIs+NUkfSsG2DQAmvXp9d7I1OQp+iAizEZMycLpIeIKNqsRueAc9frdJx42iF6Kt7IbFg4GQsRo+bzkqCGtete7b/WRFtTybPpTT0JFkJbgNAnmp5PGC2P5Q5Tpnvu27EbZtXo94SkfSo5/RY+pbmyTk+gcoDzqpotsRgqg8jUdEn2MrXvXTw2WFwmbIe8x/JGL7c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15 2025, Pasha Tatashin wrote:

> It is invalid for KHO metadata or preserved memory regions to be located
> within the KHO scratch area, as this area is overwritten when the next
> kernel is loaded, and used early in boot by the next kernel. This can
> lead to memory corruption.
>
> Adds checks to kho_preserve_* and KHO's internal metadata allocators
> (xa_load_or_alloc, new_chunk) to verify that the physical address of the
> memory does not overlap with any defined scratch region. If an overlap
> is detected, the operation will fail and a WARN_ON is triggered. To
> avoid performance overhead in production kernels, these checks are
> enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/Kconfig                   | 15 ++++++++++
>  kernel/liveupdate/kexec_handover.c          | 32 ++++++++++++++++++---
>  kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++++++
>  kernel/liveupdate/kexec_handover_internal.h |  9 ++++++
>  4 files changed, 70 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index 522b9f74d605..d119f4f3f4b1 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -27,4 +27,19 @@ config KEXEC_HANDOVER_DEBUGFS
>  	  Also, enables inspecting the KHO fdt trees with the debugfs binary
>  	  blobs.
>  
> +config KEXEC_HANDOVER_DEBUG
> +	bool "Enable Kexec Handover debug checks"
> +	depends on KEXEC_HANDOVER_DEBUGFS

Why the dependency on debugfs? Why can't the debug checks be enabled
independently?

> +	help
> +	  This option enables extra sanity checks for the Kexec Handover
> +	  subsystem.
> +
> +	  These checks verify that neither preserved memory regions nor KHO's
> +	  internal metadata are allocated from within a KHO scratch area.
> +	  An overlap can lead to memory corruption during a subsequent kexec
> +	  operation.

I don't think the checks that are done should be listed here since as
soon as another check is added this list will become out of date.

> +
> +	  If an overlap is detected, the kernel will print a warning and the
> +	  offending operation will fail. This should only be enabled for

This also describes the behaviour of the checks, which might change
later. Maybe for some checks the operation won't fail? I suppose just
leave it at "the kernel will print a warning"?

> +	  debugging purposes due to runtime overhead.
>  endmenu
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 5da21f1510cc..ef1e6f7a234b 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -141,6 +141,11 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);
>  
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> +		kfree(elm);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
>  	if (xa_is_err(res))
>  		res = ERR_PTR(xa_err(res));
> @@ -354,7 +359,13 @@ static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
>  
>  	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!chunk)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE))) {
> +		kfree(chunk);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	chunk->hdr.order = order;
>  	if (cur_chunk)
>  		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
> @@ -379,14 +390,17 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  	struct khoser_mem_chunk *chunk = NULL;
>  	struct kho_mem_phys *physxa;
>  	unsigned long order;
> +	int ret = -ENOMEM;
>  
>  	xa_for_each(&kho_out->track.orders, order, physxa) {
>  		struct kho_mem_phys_bits *bits;
>  		unsigned long phys;
>  
>  		chunk = new_chunk(chunk, order);
> -		if (!chunk)
> +		if (IS_ERR(chunk)) {
> +			ret = PTR_ERR(chunk);
>  			goto err_free;
> +		}
>  
>  		if (!first_chunk)
>  			first_chunk = chunk;
> @@ -396,8 +410,10 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  
>  			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
>  				chunk = new_chunk(chunk, order);
> -				if (!chunk)
> +				if (IS_ERR(chunk)) {
> +					ret = PTR_ERR(chunk);
>  					goto err_free;
> +				}
>  			}
>  
>  			elm = &chunk->bitmaps[chunk->hdr.num_elms];
> @@ -414,7 +430,7 @@ static int kho_mem_serialize(struct kho_out *kho_out)
>  
>  err_free:
>  	kho_mem_ser_free(first_chunk);
> -	return -ENOMEM;
> +	return ret;
>  }
>  
>  static void __init deserialize_bitmap(unsigned int order,
> @@ -737,6 +753,9 @@ int kho_preserve_folio(struct folio *folio)
>  	const unsigned int order = folio_order(folio);
>  	struct kho_mem_track *track = &kho_out.track;
>  
> +	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
> +		return -EINVAL;
> +
>  	return __kho_preserve_order(track, pfn, order);
>  }
>  EXPORT_SYMBOL_GPL(kho_preserve_folio);
> @@ -784,6 +803,11 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
>  	unsigned long failed_pfn = 0;
>  	int err = 0;
>  
> +	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
> +					nr_pages << PAGE_SHIFT))) {
> +		return -EINVAL;
> +	}
> +
>  	while (pfn < end_pfn) {
>  		const unsigned int order =
>  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
> index eb47f000887d..294d1d290142 100644
> --- a/kernel/liveupdate/kexec_handover_debug.c
> +++ b/kernel/liveupdate/kexec_handover_debug.c
> @@ -214,3 +214,21 @@ __init int kho_debugfs_init(void)
>  		return -ENOENT;
>  	return 0;
>  }
> +
> +#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
> +bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> +{
> +	phys_addr_t scratch_start, scratch_end;
> +	unsigned int i;
> +
> +	for (i = 0; i < kho_scratch_cnt; i++) {
> +		scratch_start = kho_scratch[i].addr;
> +		scratch_end = kho_scratch[i].addr + kho_scratch[i].size - 1;

Nit: wouldn't it be a tad bit simpler to do

		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;

> +
> +		if (phys <= scratch_end && (phys + size) > scratch_start)

and here

		if (phys < scratch_end && (phys + size) > scratch_start)

At least I find it slightly easier to understand, though I don't think
it makes too much of a difference so either way is fine.

> +			return true;
> +	}
> +
> +	return false;
> +}
> +#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
> diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
> index b3fc1957affa..92798346fa5a 100644
> --- a/kernel/liveupdate/kexec_handover_internal.h
> +++ b/kernel/liveupdate/kexec_handover_internal.h
> @@ -44,4 +44,13 @@ static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
>  					  void *fdt) { }
>  #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
>  
> +#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
> +bool kho_scratch_overlap(phys_addr_t phys, size_t size);
> +#else
> +static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
> +
>  #endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */

-- 
Regards,
Pratyush Yadav

