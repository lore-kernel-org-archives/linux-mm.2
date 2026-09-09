Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A39C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B256B00A0; Wed,  9 Sep 2026 05:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802BA6B00A1; Wed,  9 Sep 2026 05:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718D16B00A2; Wed,  9 Sep 2026 05:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5075B6B00A0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:34:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20032120159
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:06 +0000 (UTC)
X-FDA: 85193712492.05.153A18D
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F94D4000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qGFwFM9t;
	spf=pass (imf01.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UV0/+f1l1BoLThd42Ew9ojQmpG98ujp+B6DNFtXMLB0=;
	b=RPb1R4Lgv5icL0pTnCR21kvxofyRPN7dJYwFfdTGx+iEMlNdeZjVjMjr6oKAFCwYPRiX68
	Q6FgGqBahW3ctI4JDzNZq7vQu87O3TuSOJebdVB7jKb6qguOC2e9y852b2yS783LbeyONe
	3AFBmThKNk0veqXDhZ+scp1cx3f2L0Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qGFwFM9t;
	spf=pass (imf01.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946444;
	b=eQavoIpEsVL1LDGuX8rd0XdKF3Oe9cWEBUCCphV/y6kEnZTFV8y1vGouGMbaVULG0eAcYr
	L9URSr/bGe+HDv+iWMxA3AeuJV9Z8ptnYeOvr9VvMkQgxPcHXNxvnp63pFVEjzcsg365Hc
	pizyU4RvjB/zEbuN5ej7ju9kP4/YKSw=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260909093401euoutp0250b9a9a2388e6dc00f47f54902d9caf0~TnU9pet751633116331euoutp021
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260909093401euoutp0250b9a9a2388e6dc00f47f54902d9caf0~TnU9pet751633116331euoutp021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788946441;
	bh=UV0/+f1l1BoLThd42Ew9ojQmpG98ujp+B6DNFtXMLB0=;
	h=Date:Subject:To:From:In-Reply-To:References:From;
	b=qGFwFM9tX/POMB+cQXb+N3gFZtllUteEnaYW/feAzpisaHwTmSrLknMNODUX+2+UL
	 QIFUXIjgsWhk54Q+6dHd5FmBOwbLGezgtyHlrwzcYMHn381fM3QogCqd6nesWjrxad
	 bsOo4TD+5t/1/mAha5R/CuffwjY9IqfOmSLpPYhM=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260909093401eucas1p1978a50cffbadcd28189328b8a35181f1~TnU9aG9Mo1629716297eucas1p1H;
	Wed,  9 Sep 2026 09:34:01 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260909093358eusmtip199556b4956c3d189eaf7446be74818ee~TnU7Tv7y41967519675eusmtip1Q;
	Wed,  9 Sep 2026 09:33:58 +0000 (GMT)
Message-ID: <c694433e-4006-40f9-81a0-f1de58f0c93e@samsung.com>
Date: Wed, 9 Sep 2026 11:33:58 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2] dma-mapping: use exact allocation for DMA pages
To: Qingfang Deng <qingfang.deng@linux.dev>, Robin Murphy
	<robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David
	Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
	Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
	Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260903012914.312305-1-qingfang.deng@linux.dev>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260909093401eucas1p1978a50cffbadcd28189328b8a35181f1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260903012931eucas1p1d558f849340fa7b92074201c28f7937b
X-EPHeader: CA
X-CMS-RootMailID: 20260903012931eucas1p1d558f849340fa7b92074201c28f7937b
References: <CGME20260903012931eucas1p1d558f849340fa7b92074201c28f7937b@eucas1p1.samsung.com>
	<20260903012914.312305-1-qingfang.deng@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 5ap18ffa8ijqr9esptfja8p7zt5uc1xg
X-Rspamd-Queue-Id: 8F94D4000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1788946443-154598
X-HE-Meta: U2FsdGVkX19bvx7Z5UWoVnUD4z0pzqptQ3cE9D8D9xL0/4MhGD1wgeCCWgYiWwQWsQD1Iip6lrm+bhMkBPH+FVVwhxgjYeCfocbCuExeEPp2uaXJG8nALoBzRnNUmtQ7JpDlHKrEZmqGu95qgZAxt9UO6iTL1iEnq4CsJ/LGTHyOgpIAJdvf/wLkVcBcKMXpOQoVjvznpKqu1MF226vm+mD46FQj6JslU1pC1t2ZO5AvAmHx7l8wg4gXld+ehfJDtc2mb0oyrpWRYedKgVf8iIsDIP7fjHVpeq7qxmpXe/WdbIViTacTRA5d0y9kcCQ12QblSk8i2jky2c4L85bzWLqcYToctlgyeYvtSkaRezw7yJvYgIIsDyUHUO0ymqtJoNMi8d3Kt2OvaeN6wgC3ImaaOQ1vvou8EnTfAasTvm7CIggeeE7hn7ogkuaWM9BcTtNiYNXXl8GvW/2Xdy6vzHmNkaHwqEIYTbKfeuBiA21h14ey6g1PD4ki/qtucjxmmwQJ4wFOhybzvKywPdshjlGLpp4BztDdvl7hegGoojBxTuhVJoXLZP41WWgEAEk0oOft2rCu8clxzrDMtVLn7pJlqbBbaa53A+BfYF8lDc015Vu2eJeo8gH09Rkp9uyVb1py1+aYoD9hhkajUlQ5wV0u2NN2m/v9A02Vv3gMMoluu//dgHRbcZAVIFcRpgugG/mWK+j5Hs+aw8Il+kifqlTQY5Gj6ofrkOMltbaBDiPmhV9ENR6LtnCqCp4NQX69CchW8D0AWGlfpA2Y1/qAeU0JdFvgI7ZzRkT0FhNQZ0Zh455RUsY/0wZ97Mg+J7dkLDq6CuP5zgshJ0jRV0t4cXNNfq9IbpiWWtVPqNflWkQvi5uShkaMyT2xNcdCc6wXxwSVQFH+0uIWRMNOuP3FCORRzGGlHmdK5BYPOwROk3kjzD7Y2gZCUAlq3Sfhbwpo/LYLy2vRF0K3XWA+BQW
 urKUYnmC
 Nycd8GUuPABYB7cmfcLk6XbBMBRoRn0RdCyVSQuIvjKUKgwsp8woQ5Q5RF6dVyKdkAtha00pMB8AOHmg/5bZtVZi//hqfm3pSVt/+CEDirDp78/eJytQKunuyE/AGdFQNniB2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.2026 03:29, Qingfang Deng wrote:
> DMA page allocation fallbacks use alloc_pages_node() with get_order(size),
> wasting the unused tail for non-power-of-two requests.
>
> Use alloc_pages_exact_nid() and free_pages_exact() so that a buddy
> fallback retains only requested pages.
>
> Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Applied to dma-mapping-for-next, thanks!
> ---
> v2: drop __meminit to fix section mismatch
>
> v1:
> https://lore.kernel.org/linux-iommu/20260901085348.53140-1-qingfang.deng@linux.dev/
> ---
>  drivers/iommu/dma-iommu.c   | 10 ++++++----
>  include/linux/dma-map-ops.h |  2 +-
>  include/linux/gfp.h         |  2 +-
>  kernel/dma/contiguous.c     |  6 +++---
>  kernel/dma/direct.c         |  8 +++++---
>  kernel/dma/ops_helpers.c    | 11 +++++++----
>  mm/page_alloc.c             |  2 +-
>  7 files changed, 24 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 58c624513cd4..8f262c83802c 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1628,10 +1628,12 @@ static void *iommu_dma_alloc_pages(struct device *dev, size_t size,
>  	void *cpu_addr;
>  
>  	page = dma_alloc_contiguous(dev, alloc_size, gfp);
> -	if (!page)
> -		page = alloc_pages_node(node, gfp, get_order(alloc_size));
> -	if (!page)
> -		return NULL;
> +	if (!page) {
> +		cpu_addr = alloc_pages_exact_nid(node, alloc_size, gfp);
> +		if (!cpu_addr)
> +			return NULL;
> +		page = virt_to_page(cpu_addr);
> +	}
>  
>  	if (!coherent || PageHighMem(page)) {
>  		pgprot_t prot = dma_pgprot(dev, PAGE_KERNEL, attrs);
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index 8fae2b7deb20..3ef3003713a6 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -143,7 +143,7 @@ static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
>  static inline void dma_free_contiguous(struct device *dev, struct page *page,
>  		size_t size)
>  {
> -	__free_pages(page, get_order(size));
> +	free_pages_exact(page_address(page), size);
>  }
>  #endif /* CONFIG_DMA_CMA*/
>  
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 872bc53f32ec..aa4601805f21 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -329,7 +329,7 @@ void *alloc_pages_exact_noprof(size_t size, gfp_t gfp_mask) __alloc_size(1);
>  
>  void free_pages_exact(void *virt, size_t size);
>  
> -__meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mask) __alloc_size(2);
> +void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mask) __alloc_size(2);
>  #define alloc_pages_exact_nid(...)					\
>  	alloc_hooks(alloc_pages_exact_nid_noprof(__VA_ARGS__))
>  
> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index 66093460584e..90937dc7c627 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -451,8 +451,8 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
>   *
>   * This function releases memory allocated by dma_alloc_contiguous(). As the
>   * cma_release returns false when provided pages do not belong to contiguous
> - * area and true otherwise, this function then does a fallback __free_pages()
> - * upon a false-return.
> + * area and true otherwise, this function then does a fallback
> + * free_pages_exact() upon a false-return.
>   */
>  void dma_free_contiguous(struct device *dev, struct page *page, size_t size)
>  {
> @@ -476,7 +476,7 @@ void dma_free_contiguous(struct device *dev, struct page *page, size_t size)
>  	}
>  
>  	/* not in any cma, free from buddy */
> -	__free_pages(page, get_order(size));
> +	free_pages_exact(page_address(page), size);
>  }
>  
>  /*
> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
> index da665ca22d5c..ea64453d7370 100644
> --- a/kernel/dma/direct.c
> +++ b/kernel/dma/direct.c
> @@ -120,6 +120,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
>  	int node = dev_to_node(dev);
>  	struct page *page;
>  	u64 phys_limit;
> +	void *va;
>  
>  	WARN_ON_ONCE(!PAGE_ALIGNED(size));
>  
> @@ -133,9 +134,9 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
>  		dma_free_contiguous(dev, page, size);
>  	}
>  
> -	while ((page = alloc_pages_node(node, gfp, get_order(size)))
> -	       && !dma_coherent_ok(dev, page_to_phys(page), size)) {
> -		__free_pages(page, get_order(size));
> +	while ((va = alloc_pages_exact_nid(node, size, gfp)) &&
> +	       !dma_coherent_ok(dev, virt_to_phys(va), size)) {
> +		free_pages_exact(va, size);
>  
>  		if (IS_ENABLED(CONFIG_ZONE_DMA32) &&
>  		    phys_limit < DMA_BIT_MASK(64) &&
> @@ -146,6 +147,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
>  		else
>  			return NULL;
>  	}
> +	page = va ? virt_to_page(va) : NULL;
>  
>  	return page;
>  }
> diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
> index 6b5f9208d31c..5cdf3f60cf47 100644
> --- a/kernel/dma/ops_helpers.c
> +++ b/kernel/dma/ops_helpers.c
> @@ -67,10 +67,13 @@ struct page *dma_common_alloc_pages(struct device *dev, size_t size,
>  	phys_addr_t phys;
>  
>  	page = dma_alloc_contiguous(dev, size, gfp);
> -	if (!page)
> -		page = alloc_pages_node(dev_to_node(dev), gfp, get_order(size));
> -	if (!page)
> -		return NULL;
> +	if (!page) {
> +		void *va = alloc_pages_exact_nid(dev_to_node(dev), size, gfp);
> +
> +		if (!va)
> +			return NULL;
> +		page = virt_to_page(va);
> +	}
>  
>  	phys = page_to_phys(page);
>  	if (use_dma_iommu(dev))
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c4dc61ec663e..d3a135dfcdd3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5637,7 +5637,7 @@ EXPORT_SYMBOL(alloc_pages_exact_noprof);
>   *
>   * Return: pointer to the allocated area or %NULL in case of error.
>   */
> -void * __meminit alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mask)
> +void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mask)
>  {
>  	unsigned int order = get_order(size);
>  	struct page *p;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


