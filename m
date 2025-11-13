Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7827ACD5BC2
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47C58E000F; Thu, 13 Nov 2025 06:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD10F8E0002; Thu, 13 Nov 2025 06:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98AB8E000F; Thu, 13 Nov 2025 06:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A28FE8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:00:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44F0713BECF
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:00:39 +0000 (UTC)
X-FDA: 84105290598.09.A86088A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5CACDC0010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:00:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XprYqLZl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763031637; a=rsa-sha256;
	cv=none;
	b=R6NwF3ivFYVoZBR3jaLIixACgYSiytHCFEkV+8c3pjw1VgvIxbotrUXc/EjfTAA0WipCP+
	s+YMSWLMSq3Y7lZ9xRKtpMvb6zOWvZDPj52VwDTeXhsaTmWMVYgs7ZGM+6sl1x5Rfr4BbF
	g2kn/2fd26qfF8Due04cQy5W64qyp+E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XprYqLZl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763031637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2OYDlLyDHW2bw4OxASUcB1RSTfdHVv/OWJshaK6ARlo=;
	b=WhFKlUaxo75CjHs0Y/hl35EAMxAd5S7M5F35xgQuYNYcKkIZ0E4peaV+/bsxpqA4OwoR3U
	3dZBYFOUket8LnnswWDZ+k5Jdax/IaOLq8IinalFAb0wUggI1gTYhGbz/K4F2Wb3/SedoS
	vcRMXlQgN10nHBLN2Yi4eU8GV69fRjk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51658405D3;
	Thu, 13 Nov 2025 11:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830DAC4CEF8;
	Thu, 13 Nov 2025 11:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763031636;
	bh=60CqqKZhKyJWhvXbxjipGwZaOFWeYx8t/B7NuToA0qM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XprYqLZl0n7S0uKqVe+CWa2LIB6Ck69UtfeF/nby7RAfR2gTWAOCSYAmCXZIkD9NY
	 p2b9pRk1jOsaovvn4m6GLJ+x1SjWdmxEKkCfo0FZ5rcyfQGOM+Qax1yjUkhljKcjJE
	 hGFz/mD/buVOCxa4jhShkdYg+2z99ADEx1QIbeg5p/n2pFuEPBeU1gp8YcfYhfHgM4
	 j5Q+OXwo5qXd8x40MMLMJYQ3tWpSjIYpQUF+O1etquIVAEgFN6dvwAppS4x1bRWBTo
	 9XmBVzGwaYs+I8qHma7t9haazKdJdjfIRXfpdbmZ0mCTV6jTDFr5ACh2Gt3XXV0deI
	 aIf2OK9jhTnUA==
Date: Thu, 13 Nov 2025 11:00:29 +0000
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 3/4] drivers/iommu-debug-pagealloc: Track IOMMU pages
Message-ID: <aRW6Tf_G2ObR__vE@willie-the-truck>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-4-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106163953.1971067-4-smostafa@google.com>
X-Rspamd-Queue-Id: 5CACDC0010
X-Rspamd-Server: rspam07
X-Stat-Signature: y67uinh9q9e7d8zoajnuoyg4mbwmx1i8
X-Rspam-User: 
X-HE-Tag: 1763031637-648173
X-HE-Meta: U2FsdGVkX1/6YX3HFfQCJdDDtjHxIIFR/LbWDFmbsjGqr/UR7MNiUXS7VzFJKqMG+PVsVR60Rm+2TkMgb6jUicuzwglxeCbr2esXDfBMGsKCCiJLTwJ1buSLMu/qHUlqGrT0EJ3yd6F853sjVW7okXSuaQzTxVManJD6Qa/FIDnTZd6q0/zLuxZNIR+hM9Sgcube5zV/MyLkGAEFqD8rkZT9FXPu0LWDVgiDpv3mJQ2AkOHwJicMYCyKaeCMaO/nzDIyvo0TCl2KAcXF4XOYUl1D8avgdUP9/dm7Ib8NiH5h85H40sgBVkyj46q8tcSjyHK1txFefxT7WWW0cWp9jT99U7XqCcxRSakSde+cGgfoNukkcfQi51LS6QJK09i4IlHDQyVwfYa7AZrqL3wQlTJSImlvmSniheQQcWRka7FqZ3irakaa6ODYbcr4QY4Mmd7XXCuFp0B3hSo3v2mKrbd340KdDj6x+wpUym10QZTHB5HUqnCAjZ7j4SVEiwPLZl0bzOEu3KWCG+AD0hwiiLL5SEgx/evY/Arc4Ip4PWmhV+TooqllJJJA/TLbUyXow7AZQ9c5ulCN7WkIhyKSEbazsyGyki90J3kGH4nPBMmLl2NBmgXZsq9ihPbk2ID6fnVoBJThIy4YjOKa8aI2At7s9TLBZMPwAO49Y414hMFCYSbJT4sWBc+szp4WA+p187hmBtqOBXH8opwmhvc7kdNcQ8NK8oF2SxT/zPa1TC/tGsCmwg99dbD+/piANf2HLjBkxO0OTgtjAnG3wPxPeGAF2Csi7N4irhgaFaKQ7ZYt+5XuGBoYwOsMbcUHxQqmrtcSENGv4nIOwQwxkm4BJaOcyAGA1h+qpdOLuXqPuhVdesB3w5DDOjGWDsm6LKOJTlYCmCftkipDAqVPd7M7GtMe16Mjoyt8jorB+SJ6C5VhIIIbhLtc0K8cBP+qaoLGwuMFBdSwiY2qEFQA69/
 FV/2ErpG
 pzsxigHHmf7HDnyKBx+kuoPngRw1bhO48LP9u3LULIgu9BBkRotiNq3NxX7ythE5TWnT8K6FhCYSCio3TopjNa5iyQYT5nbXgkvvlYnPprC6qteL2YTz8+3Q0HQvGBT5AbKk/lbAtBjbLQl+Zos/UEsJ4nRxw+END2uv5ZIkts5dFfaBrz2CzdtH1TyoL2Xfin4ASTvmz2I6JSPYMXDgQhs4+PHs6nsOr21OiZbaGhhC51GVRyQ4q4s02cGLreigIu3n62tgNv8olkySWmwYrzqh9GtqXhZgzKRnfHi0kt+tmphU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 04:39:52PM +0000, Mostafa Saleh wrote:
> Using the new calls, use an atomic refcount to track how many times
> a page is mapped in any of the IOMMUs.
> 
> For unmap we need to use iova_to_phys() to get the physical address
> of the pages.
> 
> We use the smallest supported page size as the granularity of tracking
> per domain.
> This is important as it possible to map pages and unmap them with
> larger sizes (as in map_sg()) cases.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 74 +++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> index a6a2f844b09d..0e14104b971c 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -27,16 +27,90 @@ struct page_ext_operations page_iommu_debug_ops = {
>  	.need = need_iommu_debug,
>  };
>  
> +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> +{
> +	struct page *page = phys_to_page(phys);
> +	struct page_ext *page_ext = page_ext_get(page);
> +
> +	return page_ext;
> +}
> +
> +static struct iommu_debug_metadate *get_iommu_data(struct page_ext *page_ext)
> +{
> +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> +}
> +
> +static void iommu_debug_inc_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
> +
> +	WARN_ON(atomic_inc_return(&d->ref) <= 0);

Is it worth dumping some information about the page in addition to the
WARN_ON()? That way, you might be able to benefit from other debug
options (e.g. PAGE_OWNER) if they are enabled.

> +	page_ext_put(page_ext);
> +}
> +
> +static void iommu_debug_dec_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
> +
> +	WARN_ON(atomic_dec_return(&d->ref) < 0);

nit: I can't see why you need memory ordering guarantees for the refcount,
so you could use the relaxed variants for the inc/dec operations.

> +	page_ext_put(page_ext);
> +}
> +
> +/*
> + * IOMMU page size might not match the CPU page size, in that case, we use
> + * the smallest IOMMU page size to refcount the pages in the vmemmap.
> + * That is important as both map and unmap has to use the same page size
> + * to update the refcount to avoid double counting the same page.
> + * And as we can't know from iommu_unmap() what was the original page size
> + * used for map, we just use the minimum supported one for both.
> + */
> +static size_t iommu_debug_page_size(struct iommu_domain *domain)
> +{
> +	return 1UL << __ffs(domain->pgsize_bitmap);
> +}
> +
>  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
>  {
> +	size_t off;
> +	size_t page_size = iommu_debug_page_size(domain);

Since this is a debug feature, is it worth checking other properties of
the arguments too? For example, that phys is non-zero and that phys +
size doesn't overflow?

> +	for (off = 0 ; off < size ; off += page_size) {
> +		if (!pfn_valid(__phys_to_pfn(phys + off)))
> +			continue;
> +		iommu_debug_inc_page(phys + off);
> +	}
>  }
>  
>  void __iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
>  {
> +	size_t off;
> +	size_t page_size = iommu_debug_page_size(domain);
> +
> +	for (off = 0 ; off < size ; off += page_size) {
> +		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
> +
> +		if (!phys || !pfn_valid(__phys_to_pfn(phys + off)))
> +			continue;

Hmm, it looks weird to add 'off' to both 'iova' _and_ the resulting
physical address. Is that correct?

> +		iommu_debug_dec_page(phys);
> +	}
>  }
>  
>  void __iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
>  {
> +	size_t off;
> +	size_t page_size = iommu_debug_page_size(domain);
> +
> +	for (off = 0 ; off < size ; off += page_size) {
> +		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
> +
> +		if (!phys || !pfn_valid(__phys_to_pfn(phys + off)))
> +			continue;
> +
> +		iommu_debug_inc_page(phys);
> +	}

You can make the bulk of this code common with the unmap function.

Will

