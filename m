Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99368CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E3E8E0005; Fri,  5 Sep 2025 12:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0150D8E0001; Fri,  5 Sep 2025 12:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D288E0005; Fri,  5 Sep 2025 12:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D56668E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:21:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97D5F1602D7
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:21:52 +0000 (UTC)
X-FDA: 83855712864.15.B24ADC5
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf21.hostedemail.com (Postfix) with ESMTP id 72D211C0015
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:21:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TMub8T2A;
	spf=pass (imf21.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757089310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SihwygswkUbDkI6TEnNcbeL2/U8m9DIalmjgcknmvOM=;
	b=DxPMSlgCm+5FcBqsVhA0VWIvievB3YKOzDG3SEIxsxN4WobRmmay7tD6ahxz6BaSFLH4Rf
	tleVuUV2+OBTaz/wIe+uSNoE5gIQhlTmmXr+L6PL1K9wwOmA7brRugLwyQ49FErs8R2PU6
	zM6cUTWtsWx9N8BGW+8s4BongnKSvt4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TMub8T2A;
	spf=pass (imf21.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757089310; a=rsa-sha256;
	cv=none;
	b=Ang5Ab56mWa6IAKn1K88FGK1ZbxmRC6E6z2pXjJQ2JYuQHC8Y1E2b8kBQBgMQaIGvEjL6e
	iHo0vU1L9OeYze24ehhI+RXwCLfxuOihGYxagGhmMh0y0sZEzcCxI88s2PahhJltcZoIrv
	u1739R8Elm7XhUS0HLPMAO5YVim+taI=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250905162148euoutp02604d107873dc75c605be1c2733dda215~ib2qaX6dY1912019120euoutp02_;
	Fri,  5 Sep 2025 16:21:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250905162148euoutp02604d107873dc75c605be1c2733dda215~ib2qaX6dY1912019120euoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757089308;
	bh=SihwygswkUbDkI6TEnNcbeL2/U8m9DIalmjgcknmvOM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=TMub8T2AywFu0rH6DpstDybTJowRFDNOBYLDkp6Xzd7qGqwZ8ouj39Pirm529DkBN
	 NnHkZVznzmV8UpKTT429M04YfUlrnl7jwCyuT5my78L0ccVnDyJcAFZshVqjrwHKoZ
	 N2bRFb+07AkY+pQ3ta9ua+sPeKgv85ar3t0gyurM=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250905162147eucas1p221ca4e33b0e6396d02908377c6c5b919~ib2pcEwbH0974409744eucas1p2p;
	Fri,  5 Sep 2025 16:21:47 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250905162145eusmtip2342879dbc38ddfe0bbff0062e179f725~ib2nn8yb40979609796eusmtip2i;
	Fri,  5 Sep 2025 16:21:45 +0000 (GMT)
Message-ID: <087e7f3d-1e0d-4efe-822f-72d16d161a60@samsung.com>
Date: Fri, 5 Sep 2025 18:21:44 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v5 07/16] dma-mapping: convert dma_direct_*map_page to
 be phys_addr_t based
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>, Alexander Potapenko
	<glider@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Danilo
	Krummrich <dakr@kernel.org>, David Hildenbrand <david@redhat.com>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>, Jens Axboe
	<axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet
	<corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
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
In-Reply-To: <6b2f4cb436c98d6342db69e965a5621707b9711f.1756822782.git.leon@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250905162147eucas1p221ca4e33b0e6396d02908377c6c5b919
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250902144935eucas1p253de9e94315de54325cc61dea9c76490
X-EPHeader: CA
X-CMS-RootMailID: 20250902144935eucas1p253de9e94315de54325cc61dea9c76490
References: <cover.1756822782.git.leon@kernel.org>
	<CGME20250902144935eucas1p253de9e94315de54325cc61dea9c76490@eucas1p2.samsung.com>
	<6b2f4cb436c98d6342db69e965a5621707b9711f.1756822782.git.leon@kernel.org>
X-Stat-Signature: t1o5id51ws5zojeczazouksgo516iom4
X-Rspam-User: 
X-Rspamd-Queue-Id: 72D211C0015
X-Rspamd-Server: rspam01
X-HE-Tag: 1757089310-110239
X-HE-Meta: U2FsdGVkX184eQuRwX374VH1PVu58wnqypbWmh42m3hyYFVP9K6IaGZld64/wCfpmVRawBaGZlQ/tBnmIx4HBic3zQIPce7Jo+QdiZlSgmhKuA5QG+uYxqeuAQukBteCAOxJpims8OLILXCM6vr5ASTgTmB8Gi4RCbsMlG9CKuKEnH922SiWSzRpml6eWrqNawIuk1dxMIfK8Ep6h+KjyJv3/uI5BD6LPJKkoxXptIiRhYlMOtAdtLABYi1BMzCsjY58Tr+Rx/KX3TrzNEHnKeADBot67PGDI7VWsxA2ojSsI+ErTmle1fGq6rfGxB9yoQWPR7V4S4GBtldT/HyabLdqHAa1QZWBOXWdHKPEMaWsehV7wu24dSC2vJE/9iS8e7EY/cCbJFvERj7S+AmAzIfJ2fRQxIoLH6A/DPvPcGrV3jUyXKWruKVcKg4pCdSojBwwgzKhapQjZChniNXF+kG5N3zuV926r8QCrk1ZinL85dmGu/j2Zp1Acs/PuWv6nubn+BueLlvIhisCHLOVk/ppKkIsOub6KcBP1s8R5QBHOY9NDWSy5/tz43J4qjIdOVLda38hHNwBAGM1u+fBLmv7CQEMQhhcws8f9MoI6kTQS8OB6pDvETwCqVeetimEnzmf/eiXZW9RMSZ//Z0Oz9Xa/Z/IkYcrRiS5RXugpSAzTkoGRSI4JUfW/15PSa4iQyWwT6CRAnP7y7pRbg5cGnqf3jqpys/BywUbYvsS3WqpRWOB0KIjUWheEvIFvYzCNd3kvNPrkOeJuE0D/oL+KZTMcl3Yf2A7xUhWFHsr8EIELkcCEE9WXeahk96KiwFppeoXmG9JV8ProKEZ9WWeIBle71muEibSDeZ4+tFcWd17aAQC9caMsqkXGfnPSy4e30QtjKKMJ1BgeBa1XOFPc9+mxAz7Ux/C8WTsxuFDz5jI0TVOiTrMwHP3mXT763r1R1Ks34KqM6sf+WUkzbi
 t2LvPrEO
 8zCYQyrJIAQEvsYgpGZtSxqLRMslb/bkR77dps6okt4P5+3XySEzC0ExFEkjwlGnp7l1oGFXTcvljhbYTxIiHUCmD2Yg0kGr0typiHzhxllEld2TrqGUs0n4nP7eIICKxifjen699hjLO9Nv+4/5s9Lg7JETyqm4DX9FATp3XNSI1oTm/9CKxe1uLdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.2025 16:48, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Convert the DMA direct mapping functions to accept physical addresses
> directly instead of page+offset parameters. The functions were already
> operating on physical addresses internally, so this change eliminates
> the redundant page-to-physical conversion at the API boundary.
>
> The functions dma_direct_map_page() and dma_direct_unmap_page() are
> renamed to dma_direct_map_phys() and dma_direct_unmap_phys() respectively,
> with their calling convention changed from (struct page *page,
> unsigned long offset) to (phys_addr_t phys).
>
> Architecture-specific functions arch_dma_map_page_direct() and
> arch_dma_unmap_page_direct() are similarly renamed to
> arch_dma_map_phys_direct() and arch_dma_unmap_phys_direct().
>
> The is_pci_p2pdma_page() checks are replaced with DMA_ATTR_MMIO checks
> to allow integration with dma_direct_map_resource and dma_direct_map_phys()
> is extended to support MMIO path either.
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   arch/powerpc/kernel/dma-iommu.c |  4 +--
>   include/linux/dma-map-ops.h     |  8 ++---
>   kernel/dma/direct.c             |  6 ++--
>   kernel/dma/direct.h             | 57 +++++++++++++++++++++------------
>   kernel/dma/mapping.c            |  8 ++---
>   5 files changed, 49 insertions(+), 34 deletions(-)
>
> diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
> index 4d64a5db50f3..0359ab72cd3b 100644
> --- a/arch/powerpc/kernel/dma-iommu.c
> +++ b/arch/powerpc/kernel/dma-iommu.c
> @@ -14,7 +14,7 @@
>   #define can_map_direct(dev, addr) \
>   	((dev)->bus_dma_limit >= phys_to_dma((dev), (addr)))
>   
> -bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr)
> +bool arch_dma_map_phys_direct(struct device *dev, phys_addr_t addr)
>   {
>   	if (likely(!dev->bus_dma_limit))
>   		return false;
> @@ -24,7 +24,7 @@ bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr)
>   
>   #define is_direct_handle(dev, h) ((h) >= (dev)->archdata.dma_offset)
>   
> -bool arch_dma_unmap_page_direct(struct device *dev, dma_addr_t dma_handle)
> +bool arch_dma_unmap_phys_direct(struct device *dev, dma_addr_t dma_handle)
>   {
>   	if (likely(!dev->bus_dma_limit))
>   		return false;
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index f48e5fb88bd5..71f5b3025415 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -392,15 +392,15 @@ void *arch_dma_set_uncached(void *addr, size_t size);
>   void arch_dma_clear_uncached(void *addr, size_t size);
>   
>   #ifdef CONFIG_ARCH_HAS_DMA_MAP_DIRECT
> -bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr);
> -bool arch_dma_unmap_page_direct(struct device *dev, dma_addr_t dma_handle);
> +bool arch_dma_map_phys_direct(struct device *dev, phys_addr_t addr);
> +bool arch_dma_unmap_phys_direct(struct device *dev, dma_addr_t dma_handle);
>   bool arch_dma_map_sg_direct(struct device *dev, struct scatterlist *sg,
>   		int nents);
>   bool arch_dma_unmap_sg_direct(struct device *dev, struct scatterlist *sg,
>   		int nents);
>   #else
> -#define arch_dma_map_page_direct(d, a)		(false)
> -#define arch_dma_unmap_page_direct(d, a)	(false)
> +#define arch_dma_map_phys_direct(d, a)		(false)
> +#define arch_dma_unmap_phys_direct(d, a)	(false)
>   #define arch_dma_map_sg_direct(d, s, n)		(false)
>   #define arch_dma_unmap_sg_direct(d, s, n)	(false)
>   #endif
> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index 24c359d9c879..fa75e3070073 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -453,7 +453,7 @@ void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sgl,
>   		if (sg_dma_is_bus_address(sg))
>   			sg_dma_unmark_bus_address(sg);
>   		else
> -			dma_direct_unmap_page(dev, sg->dma_address,
> +			dma_direct_unmap_phys(dev, sg->dma_address,
>   					      sg_dma_len(sg), dir, attrs);
>   	}
>   }
> @@ -476,8 +476,8 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
>   			 */
>   			break;
>   		case PCI_P2PDMA_MAP_NONE:
> -			sg->dma_address = dma_direct_map_page(dev, sg_page(sg),
> -					sg->offset, sg->length, dir, attrs);
> +			sg->dma_address = dma_direct_map_phys(dev, sg_phys(sg),
> +					sg->length, dir, attrs);
>   			if (sg->dma_address == DMA_MAPPING_ERROR) {
>   				ret = -EIO;
>   				goto out_unmap;
> diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
> index d2c0b7e632fc..3f4792910604 100644
> --- a/kernel/dma/direct.h
> +++ b/kernel/dma/direct.h
> @@ -80,42 +80,57 @@ static inline void dma_direct_sync_single_for_cpu(struct device *dev,
>   		arch_dma_mark_clean(paddr, size);
>   }
>   
> -static inline dma_addr_t dma_direct_map_page(struct device *dev,
> -		struct page *page, unsigned long offset, size_t size,
> -		enum dma_data_direction dir, unsigned long attrs)
> +static inline dma_addr_t dma_direct_map_phys(struct device *dev,
> +		phys_addr_t phys, size_t size, enum dma_data_direction dir,
> +		unsigned long attrs)
>   {
> -	phys_addr_t phys = page_to_phys(page) + offset;
> -	dma_addr_t dma_addr = phys_to_dma(dev, phys);
> +	dma_addr_t dma_addr;
>   
>   	if (is_swiotlb_force_bounce(dev)) {
> -		if (is_pci_p2pdma_page(page))
> -			return DMA_MAPPING_ERROR;
> +		if (attrs & DMA_ATTR_MMIO)
> +			goto err_overflow;
> +
>   		return swiotlb_map(dev, phys, size, dir, attrs);
>   	}
>   
> -	if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
> -	    dma_kmalloc_needs_bounce(dev, size, dir)) {
> -		if (is_pci_p2pdma_page(page))
> -			return DMA_MAPPING_ERROR;
> -		if (is_swiotlb_active(dev))
> -			return swiotlb_map(dev, phys, size, dir, attrs);
> -
> -		dev_WARN_ONCE(dev, 1,
> -			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
> -			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
> -		return DMA_MAPPING_ERROR;
> +	if (attrs & DMA_ATTR_MMIO) {
> +		dma_addr = phys;
> +		if (unlikely(dma_capable(dev, dma_addr, size, false)))

"!dma_capable(dev, dma_addr, size, false)" in the above line.

It took me a while to find this after noticing that this patchset breaks booting some of me test systems.


> +			goto err_overflow;
> +	} else {
> +		dma_addr = phys_to_dma(dev, phys);
> +		if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
> +		    dma_kmalloc_needs_bounce(dev, size, dir)) {
> +			if (is_swiotlb_active(dev))
> +				return swiotlb_map(dev, phys, size, dir, attrs);
> +
> +			goto err_overflow;
> +		}
>   	}
>   
> -	if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> +	if (!dev_is_dma_coherent(dev) &&
> +	    !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
>   		arch_sync_dma_for_device(phys, size, dir);
>   	return dma_addr;
> +
> +err_overflow:
> +	dev_WARN_ONCE(
> +		dev, 1,
> +		"DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
> +		&dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
> +	return DMA_MAPPING_ERROR;
>   }
>   
> -static inline void dma_direct_unmap_page(struct device *dev, dma_addr_t addr,
> +static inline void dma_direct_unmap_phys(struct device *dev, dma_addr_t addr,
>   		size_t size, enum dma_data_direction dir, unsigned long attrs)
>   {
> -	phys_addr_t phys = dma_to_phys(dev, addr);
> +	phys_addr_t phys;
> +
> +	if (attrs & DMA_ATTR_MMIO)
> +		/* nothing to do: uncached and no swiotlb */
> +		return;
>   
> +	phys = dma_to_phys(dev, addr);
>   	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
>   		dma_direct_sync_single_for_cpu(dev, addr, size, dir);
>   
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 58482536db9b..80481a873340 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -166,8 +166,8 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
>   		return DMA_MAPPING_ERROR;
>   
>   	if (dma_map_direct(dev, ops) ||
> -	    arch_dma_map_page_direct(dev, phys + size))
> -		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
> +	    arch_dma_map_phys_direct(dev, phys + size))
> +		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
>   	else if (use_dma_iommu(dev))
>   		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
>   	else
> @@ -187,8 +187,8 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
>   
>   	BUG_ON(!valid_dma_direction(dir));
>   	if (dma_map_direct(dev, ops) ||
> -	    arch_dma_unmap_page_direct(dev, addr + size))
> -		dma_direct_unmap_page(dev, addr, size, dir, attrs);
> +	    arch_dma_unmap_phys_direct(dev, addr + size))
> +		dma_direct_unmap_phys(dev, addr, size, dir, attrs);
>   	else if (use_dma_iommu(dev))
>   		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
>   	else

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


