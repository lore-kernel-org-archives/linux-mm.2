Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F9B2CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D94C8E000F; Fri,  5 Sep 2025 12:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0EF8E0001; Fri,  5 Sep 2025 12:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7038E000F; Fri,  5 Sep 2025 12:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4806B8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:27:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F16871A02F5
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:27:03 +0000 (UTC)
X-FDA: 83855725926.13.09B1192
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4BEFB100014
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:27:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="k7Zmm/l4";
	spf=pass (imf05.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757089622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JratdkJhfp1iQGSSFRxxu72lgWMqyE2NX54DSFPZHRY=;
	b=i+05HEI6MH3GQdn1RwhYg+o79zSRj288caaVzuP34KrR2lbvG/xLydEBAFsmfXFkNdYlXY
	QzSTqJMJD47kQc8wrbs2Rk+J8d80hBgmLLCrAyS/bx2dX1lsHWIyUzl43suKoH3hKCRQQH
	AwEryYZx4dG9cciB3nOcaN7TalTvvdU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="k7Zmm/l4";
	spf=pass (imf05.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757089622; a=rsa-sha256;
	cv=none;
	b=G+wCbH6g9hT2fq3hYyPxBh7Bv/Vv2IJwfFpMoVY0urz3ycYVSlj8bizqLIzJmy3QtRFMRX
	XfCTgixAxk7cYev2vyTj5yMBeefwvGW0LIFmUKDN5v2i7C2qj4CXmRcgviT9Q2jk7t9Utn
	csrHSN+fAdtnZJOLi6+QdApxdnIs5+k=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250905162659euoutp0209439914e512e98f87c7003f3b7cb2ad~ib7L2Tvq02121121211euoutp02j;
	Fri,  5 Sep 2025 16:26:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250905162659euoutp0209439914e512e98f87c7003f3b7cb2ad~ib7L2Tvq02121121211euoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757089619;
	bh=JratdkJhfp1iQGSSFRxxu72lgWMqyE2NX54DSFPZHRY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=k7Zmm/l4ml+LB1qItvZOEqZY+Sox4+FPDDVEoRVLzx1Wvrm8UN4/WmasRnz/XdrC4
	 Uz3NPTnr8v6KtMSyeOqg/plUlqcNjUQLJ68wa1aVQkIC0f+6gNInm3vAulUU4bbtBs
	 bFH/HZYMbbkZGGDU62q/7lnZ1i5322h/6rAkdcfU=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250905162658eucas1p1a568426150516afc440f0b45dae6597c~ib7LZwBNr2591525915eucas1p15;
	Fri,  5 Sep 2025 16:26:58 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250905162656eusmtip2af2311515d499a88f1b631068b965d1d~ib7JPIWTy2564625646eusmtip2E;
	Fri,  5 Sep 2025 16:26:56 +0000 (GMT)
Message-ID: <afcd9cd4-d563-41c3-9e50-7440365b9152@samsung.com>
Date: Fri, 5 Sep 2025 18:26:55 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v4 03/16] dma-debug: refactor to use physical addresses
 for page mapping
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>, Alexander Potapenko
	<glider@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Danilo
	Krummrich <dakr@kernel.org>, iommu@lists.linux.dev, Jason Wang
	<jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
	<joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Juergen Gross
	<jgross@suse.com>, kasan-dev@googlegroups.com, Keith Busch
	<kbusch@kernel.org>, linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Masami Hiramatsu <mhiramat@kernel.org>, Michael
	Ellerman <mpe@ellerman.id.au>, "Michael S. Tsirkin" <mst@redhat.com>, Miguel
	Ojeda <ojeda@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Stefano
	Stabellini <sstabellini@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <478d5b7135008b3c82f100faa9d3830839fc6562.1755624249.git.leon@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250905162658eucas1p1a568426150516afc440f0b45dae6597c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250819173739eucas1p104ee9e80546f92ef250115edd799fc6d
X-EPHeader: CA
X-CMS-RootMailID: 20250819173739eucas1p104ee9e80546f92ef250115edd799fc6d
References: <cover.1755624249.git.leon@kernel.org>
	<CGME20250819173739eucas1p104ee9e80546f92ef250115edd799fc6d@eucas1p1.samsung.com>
	<478d5b7135008b3c82f100faa9d3830839fc6562.1755624249.git.leon@kernel.org>
X-Stat-Signature: pmwsfbhbqu8uj4gofpdzgofjrwe8r6bc
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BEFB100014
X-Rspamd-Server: rspam01
X-HE-Tag: 1757089621-281861
X-HE-Meta: U2FsdGVkX1+rr25iEu6y+3xW7+ZnadDG1ReHuN2AIbROkTVscHxJWt0cSbaU+FCOdb7k0TPqfrW5QORJgmFHprxZ+jU6nodoBUPXDBIEjFdq9uKW/ezs6KdaxhJXy2MZlLTtfDPtSit2EvHc4Gx2YUaU8T+WnkYZr70XZ6ML17KxZrz3XL7CnE2+8k8N3Z4xnfmJkvgYvI0AOns0wFOS0jq0Rur0caKEG0ToLQ5paw6uMuwQyFI1PG1yuyGyrIm8ZuzSDFPeTVb1vLCeCWKn6kK6e3qt5v1QamNIalQIQ4E8DyEZp1vJyPjXp0uEMEvif+5B/D71lLlTeQ6VjdCBiNHwoxu7X+xVjkp5r4Fx34ecnueAS828AxgJiAq6h6LD/tQ+vHuDFD663pq7FShYUrNUUpBhxOhylWg5cA8Smk7MFzdbQLXkLcltMsH/DquupsXR6j4KeL2RqTQtySY1zVhEKsNJXHM0z+N851sXfvDeTv6wde2y31+LtPH+FYQl8fpX7McZUBatAXYzdJJPw6NX8FepHSSBTSnvPu5eyS5yZTd53ujYPlf3bAy1MwT1uuWW4iiX4IfFtd2Zm7mOXQ0a2dZEx1yyYfTFjCc6cYB0AwNEPM8r9WBhhxzun0NEPvKT5pWPflvnlb2rpuT7c9ARJAHzBe3FG3wcz+mJFCGpSOcAgz/9kx9JBWk6yFrvprJ2X3WRVkSiQRMwOQZ/q+SGLLtJVWSkIFSCiNdsLea7NIKoeJgZYzA0IQC9urwKb5t+U2GE6Ph0n/7m74XC7muJOmirPo+x7NX53hskU6KlFbL/q/vIYVIG4/Q+JvE1pd6ZvWqlTl6cmZfRApFqPE/+t73YTWktupothjyDAmIRmp8CVl0ax5ur1PgZ/orlKHWfIhIwic6eHz2yWF9j6x31vJPl1vZjQCKHXfUMjmCq5oh47PhLfsrZVBCvzAsybPJ3dI2DS/ClAppjRjv
 dvLmdd5B
 PzySwpaCrJG1sECErrIDcKn0jjtDWaow6L4jBYxtnNCbxBRucdz8p4vNIU6cTlNkgvxDOPRnFZ2dN0nzCynvGFef2GUrJxWK/T4tTU4/eoVDovFR6XrqENcIat+rnLjP3QjHNJJzEOADhxMc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.2025 19:36, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Convert the DMA debug infrastructure from page-based to physical address-based
> mapping as a preparation to rely on physical address for DMA mapping routines.
>
> The refactoring renames debug_dma_map_page() to debug_dma_map_phys() and
> changes its signature to accept a phys_addr_t parameter instead of struct page
> and offset. Similarly, debug_dma_unmap_page() becomes debug_dma_unmap_phys().
> A new dma_debug_phy type is introduced to distinguish physical address mappings
> from other debug entry types. All callers throughout the codebase are updated
> to pass physical addresses directly, eliminating the need for page-to-physical
> conversion in the debug layer.
>
> This refactoring eliminates the need to convert between page pointers and
> physical addresses in the debug layer, making the code more efficient and
> consistent with the DMA mapping API's physical address focus.
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

This change needs to be based on top of this patch 
https://lore.kernel.org/all/20250828-dma-debug-fix-noncoherent-dma-check-v1-1-76e9be0dd7fc@oss.qualcomm.com 
so the easiest way would be to rebase this patchset onto 
https://web.git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git/log/?h=dma-mapping-fixes 
branch (resolving conflicts is trivial) for the next version.

> ---
>   Documentation/core-api/dma-api.rst |  4 ++--
>   kernel/dma/debug.c                 | 28 +++++++++++++++++-----------
>   kernel/dma/debug.h                 | 16 +++++++---------
>   kernel/dma/mapping.c               | 15 ++++++++-------
>   4 files changed, 34 insertions(+), 29 deletions(-)
>
> diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
> index 3087bea715ed..ca75b3541679 100644
> --- a/Documentation/core-api/dma-api.rst
> +++ b/Documentation/core-api/dma-api.rst
> @@ -761,7 +761,7 @@ example warning message may look like this::
>   	[<ffffffff80235177>] find_busiest_group+0x207/0x8a0
>   	[<ffffffff8064784f>] _spin_lock_irqsave+0x1f/0x50
>   	[<ffffffff803c7ea3>] check_unmap+0x203/0x490
> -	[<ffffffff803c8259>] debug_dma_unmap_page+0x49/0x50
> +	[<ffffffff803c8259>] debug_dma_unmap_phys+0x49/0x50
>   	[<ffffffff80485f26>] nv_tx_done_optimized+0xc6/0x2c0
>   	[<ffffffff80486c13>] nv_nic_irq_optimized+0x73/0x2b0
>   	[<ffffffff8026df84>] handle_IRQ_event+0x34/0x70
> @@ -855,7 +855,7 @@ that a driver may be leaking mappings.
>   dma-debug interface debug_dma_mapping_error() to debug drivers that fail
>   to check DMA mapping errors on addresses returned by dma_map_single() and
>   dma_map_page() interfaces. This interface clears a flag set by
> -debug_dma_map_page() to indicate that dma_mapping_error() has been called by
> +debug_dma_map_phys() to indicate that dma_mapping_error() has been called by
>   the driver. When driver does unmap, debug_dma_unmap() checks the flag and if
>   this flag is still set, prints warning message that includes call trace that
>   leads up to the unmap. This interface can be called from dma_mapping_error()
> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> index e43c6de2bce4..da6734e3a4ce 100644
> --- a/kernel/dma/debug.c
> +++ b/kernel/dma/debug.c
> @@ -39,6 +39,7 @@ enum {
>   	dma_debug_sg,
>   	dma_debug_coherent,
>   	dma_debug_resource,
> +	dma_debug_phy,
>   };
>   
>   enum map_err_types {
> @@ -141,6 +142,7 @@ static const char *type2name[] = {
>   	[dma_debug_sg] = "scatter-gather",
>   	[dma_debug_coherent] = "coherent",
>   	[dma_debug_resource] = "resource",
> +	[dma_debug_phy] = "phy",
>   };
>   
>   static const char *dir2name[] = {
> @@ -1201,9 +1203,8 @@ void debug_dma_map_single(struct device *dev, const void *addr,
>   }
>   EXPORT_SYMBOL(debug_dma_map_single);
>   
> -void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
> -			size_t size, int direction, dma_addr_t dma_addr,
> -			unsigned long attrs)
> +void debug_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
> +		int direction, dma_addr_t dma_addr, unsigned long attrs)
>   {
>   	struct dma_debug_entry *entry;
>   
> @@ -1218,19 +1219,24 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
>   		return;
>   
>   	entry->dev       = dev;
> -	entry->type      = dma_debug_single;
> -	entry->paddr	 = page_to_phys(page) + offset;
> +	entry->type      = dma_debug_phy;
> +	entry->paddr	 = phys;
>   	entry->dev_addr  = dma_addr;
>   	entry->size      = size;
>   	entry->direction = direction;
>   	entry->map_err_type = MAP_ERR_NOT_CHECKED;
>   
> -	check_for_stack(dev, page, offset);
> +	if (!(attrs & DMA_ATTR_MMIO)) {
> +		struct page *page = phys_to_page(phys);
> +		size_t offset = offset_in_page(page);
>   
> -	if (!PageHighMem(page)) {
> -		void *addr = page_address(page) + offset;
> +		check_for_stack(dev, page, offset);
>   
> -		check_for_illegal_area(dev, addr, size);
> +		if (!PageHighMem(page)) {
> +			void *addr = page_address(page) + offset;
> +
> +			check_for_illegal_area(dev, addr, size);
> +		}
>   	}
>   
>   	add_dma_entry(entry, attrs);
> @@ -1274,11 +1280,11 @@ void debug_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>   }
>   EXPORT_SYMBOL(debug_dma_mapping_error);
>   
> -void debug_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
> +void debug_dma_unmap_phys(struct device *dev, dma_addr_t dma_addr,
>   			  size_t size, int direction)
>   {
>   	struct dma_debug_entry ref = {
> -		.type           = dma_debug_single,
> +		.type           = dma_debug_phy,
>   		.dev            = dev,
>   		.dev_addr       = dma_addr,
>   		.size           = size,
> diff --git a/kernel/dma/debug.h b/kernel/dma/debug.h
> index f525197d3cae..76adb42bffd5 100644
> --- a/kernel/dma/debug.h
> +++ b/kernel/dma/debug.h
> @@ -9,12 +9,11 @@
>   #define _KERNEL_DMA_DEBUG_H
>   
>   #ifdef CONFIG_DMA_API_DEBUG
> -extern void debug_dma_map_page(struct device *dev, struct page *page,
> -			       size_t offset, size_t size,
> -			       int direction, dma_addr_t dma_addr,
> +extern void debug_dma_map_phys(struct device *dev, phys_addr_t phys,
> +			       size_t size, int direction, dma_addr_t dma_addr,
>   			       unsigned long attrs);
>   
> -extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
> +extern void debug_dma_unmap_phys(struct device *dev, dma_addr_t addr,
>   				 size_t size, int direction);
>   
>   extern void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
> @@ -55,14 +54,13 @@ extern void debug_dma_sync_sg_for_device(struct device *dev,
>   					 struct scatterlist *sg,
>   					 int nelems, int direction);
>   #else /* CONFIG_DMA_API_DEBUG */
> -static inline void debug_dma_map_page(struct device *dev, struct page *page,
> -				      size_t offset, size_t size,
> -				      int direction, dma_addr_t dma_addr,
> -				      unsigned long attrs)
> +static inline void debug_dma_map_phys(struct device *dev, phys_addr_t phys,
> +				      size_t size, int direction,
> +				      dma_addr_t dma_addr, unsigned long attrs)
>   {
>   }
>   
> -static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
> +static inline void debug_dma_unmap_phys(struct device *dev, dma_addr_t addr,
>   					size_t size, int direction)
>   {
>   }
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 107e4a4d251d..4c1dfbabb8ae 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -157,6 +157,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
>   		unsigned long attrs)
>   {
>   	const struct dma_map_ops *ops = get_dma_ops(dev);
> +	phys_addr_t phys = page_to_phys(page) + offset;
>   	dma_addr_t addr;
>   
>   	BUG_ON(!valid_dma_direction(dir));
> @@ -165,16 +166,15 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
>   		return DMA_MAPPING_ERROR;
>   
>   	if (dma_map_direct(dev, ops) ||
> -	    arch_dma_map_page_direct(dev, page_to_phys(page) + offset + size))
> +	    arch_dma_map_page_direct(dev, phys + size))
>   		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
>   	else if (use_dma_iommu(dev))
>   		addr = iommu_dma_map_page(dev, page, offset, size, dir, attrs);
>   	else
>   		addr = ops->map_page(dev, page, offset, size, dir, attrs);
>   	kmsan_handle_dma(page, offset, size, dir);
> -	trace_dma_map_page(dev, page_to_phys(page) + offset, addr, size, dir,
> -			   attrs);
> -	debug_dma_map_page(dev, page, offset, size, dir, addr, attrs);
> +	trace_dma_map_page(dev, phys, addr, size, dir, attrs);
> +	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
>   
>   	return addr;
>   }
> @@ -194,7 +194,7 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
>   	else
>   		ops->unmap_page(dev, addr, size, dir, attrs);
>   	trace_dma_unmap_page(dev, addr, size, dir, attrs);
> -	debug_dma_unmap_page(dev, addr, size, dir);
> +	debug_dma_unmap_phys(dev, addr, size, dir);
>   }
>   EXPORT_SYMBOL(dma_unmap_page_attrs);
>   
> @@ -712,7 +712,8 @@ struct page *dma_alloc_pages(struct device *dev, size_t size,
>   	if (page) {
>   		trace_dma_alloc_pages(dev, page_to_virt(page), *dma_handle,
>   				      size, dir, gfp, 0);
> -		debug_dma_map_page(dev, page, 0, size, dir, *dma_handle, 0);
> +		debug_dma_map_phys(dev, page_to_phys(page), size, dir,
> +				   *dma_handle, 0);
>   	} else {
>   		trace_dma_alloc_pages(dev, NULL, 0, size, dir, gfp, 0);
>   	}
> @@ -738,7 +739,7 @@ void dma_free_pages(struct device *dev, size_t size, struct page *page,
>   		dma_addr_t dma_handle, enum dma_data_direction dir)
>   {
>   	trace_dma_free_pages(dev, page_to_virt(page), dma_handle, size, dir, 0);
> -	debug_dma_unmap_page(dev, dma_handle, size, dir);
> +	debug_dma_unmap_phys(dev, dma_handle, size, dir);
>   	__dma_free_pages(dev, size, page, dma_handle, dir);
>   }
>   EXPORT_SYMBOL_GPL(dma_free_pages);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


