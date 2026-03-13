Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C9F105F7BF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086B66B0088; Fri, 13 Mar 2026 11:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050BE6B0089; Fri, 13 Mar 2026 11:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E954F6B008A; Fri, 13 Mar 2026 11:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAD456B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:58:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75E72B6166
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:58:09 +0000 (UTC)
X-FDA: 84541496298.02.866C8F6
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8DAE120012
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:58:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=joSnFRuz;
	spf=pass (imf29.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773417487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ieUQ9T9O1bHeOhUgIIKiQfh7WD6HzjAhG1ncXlVkUo=;
	b=HkgjOXPkx0PEvO/rQslWmRoGR/UKKu4E0iU7d2rmHqXoB/7oiYfcw394iHREWLHivYE4uE
	S2cu2FpEIrPLYBQ2AlrZirHIBfRGWrs3zgk/Dvk/N1RgtRB/voateI7iHbRdmS3zfQqWTW
	MudIk7GLga8SePI89Ev4E6jzpdONkfQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=joSnFRuz;
	spf=pass (imf29.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773417487; a=rsa-sha256;
	cv=none;
	b=h/fpHXIo5+81C19Z+xC4qSQ50ijBJaCuM+jfhQ+8XrP1xkAmB2hJdmRiNnXeMPgORau4Tz
	mw/4SvHq7FaWVtaGD8fA7/V8caVlpp2GRMz16qv1qxnaBTAatXuD30OT6Xl9iZU5c6R/6H
	xSzhGTtJ84aoe0HjZF3k29e6Ufqhz7M=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260313155804euoutp02a26460414ea15419ceead7c3a65b42b3~ccc5ljjVg2237922379euoutp02C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260313155804euoutp02a26460414ea15419ceead7c3a65b42b3~ccc5ljjVg2237922379euoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773417484;
	bh=6ieUQ9T9O1bHeOhUgIIKiQfh7WD6HzjAhG1ncXlVkUo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=joSnFRuzKGMafB3uqqrZ8kfaf5nPMzmp9dgUUaMe2qCh6lxSfQSCDx1eAshZOuVkv
	 kHbLICoGPElDefOltmzaODY/5FCDpLIUJFwWYfmngnkqfmOctxUjDHR/ALQgUdh+90
	 AYRHlXK1X/fmW1U+pCyUiaL3WHcDtXuY1bOffYuI=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260313155804eucas1p115ea56ef18ed8be8372835bd39ee456b~ccc5XOx1S0294202942eucas1p1o;
	Fri, 13 Mar 2026 15:58:04 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260313155803eusmtip29fb3ec660de0d1392912e5d729d57b40~ccc4nYSwU0077400774eusmtip2b;
	Fri, 13 Mar 2026 15:58:03 +0000 (GMT)
Message-ID: <b272e3e9-d48f-4f0d-95bc-2ed668bc0bee@samsung.com>
Date: Fri, 13 Mar 2026 16:58:02 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 3/7] of: reserved_mem: switch to ops based OF_DECLARE()
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260313150802.1121442-4-m.szyprowski@samsung.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313155804eucas1p115ea56ef18ed8be8372835bd39ee456b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150811eucas1p28cd933ea257af5dabaad214618214050
X-EPHeader: CA
X-CMS-RootMailID: 20260313150811eucas1p28cd933ea257af5dabaad214618214050
References: <20260313150802.1121442-1-m.szyprowski@samsung.com>
	<CGME20260313150811eucas1p28cd933ea257af5dabaad214618214050@eucas1p2.samsung.com>
	<20260313150802.1121442-4-m.szyprowski@samsung.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C8DAE120012
X-Rspamd-Server: rspam08
X-Stat-Signature: 8dop935ss7dr33njky875xqth3si19bi
X-HE-Tag: 1773417486-849530
X-HE-Meta: U2FsdGVkX1/hp57RaecSDBy/jV48sIyv3xXsEdL9hob4azNrQd4L8fEAYRKwwgTDnOBmUm0gTuE6hqKdTObPJXT6Q8HzGHwdmwfcG/+soEA9wzzuWheEnr4xOPbvzL9Jde80Ztcv29ciQS2zRqHF27ruPj0ZmJsCmGVAU22njLktRwaLmNwXPcwffz39FLwNdwvG0y6TF5OSD8sPyXLPazCl3IQPX92Kq88oJkBkj8F8jQduKFIeeeBqJ4G8cY6VDGl9dzChJWr4ZOjMqCRK5xjTMwNrO5MPAvLTeVUN0OsFt284/31Y/3RAcDdw2f5cI/Oyl7vRzS6ekzviI62tLcwcgn20c5u19vaP1CwcgGzPTPV/UwK4hFANLVlMQL3A4EBwGZ+Bo5QoAj7EqT3qZwInX7WjjqzPp3Q/grfSiPvo1wX9xzp5Yc+bp8SOif6NJ+blJW1ce4PWP0UKfF3MmHebF3r6tmdSD+Lg+jhZ7cDf2tVOfgJSSunREvySE/3PiAHPZUdHFDL9JWU3kdVoDuRwt1O6iO/CsMEu1Pej862B/zl+1j/mqbiANfcztCKIKSbKiU4q50BeUFV6NhAJuD90ZwZoQFXGTVh6jGw0dz9IX8Wf3why39ohPKtYKuU0V62o/d3M+NV4VPYq+RhaXkR90j3rG5pi1plKURCaUoqfgJ9bGUtGZWAvm983vQwI90lwUEfsWe56wG4nKQA6LW3DjaAE9ZJKVXoikqjDMlEQuZORweEymUvqLPFtQstEcYXwCWeZ4lUoDjDRnVPBvT24cIBlP59bJA72xppAzbotrU6qos6Z/Qrh8XcSzNP1Z16PdGbFp/QoqVPh65fd0K1/VuOMGdvsyWcesoTQKRFtfk1CS8xKCnMUlLpV0AK46auYqfVO6AXdkVTaZKIscrnmhIxWIzkJqviu3TzqFOcUKsA0kK14UtB/zRtoesD4sTWirPhk2CQX8ET/OSU
 CQEe3aza
 w/W5Ql1PM3CqHRLnVVis/LNSxBIV2Ap3ftaLh9WC4022Y0rDOy6cYvSLRRu6WKZuiNirvsCj1I8VqNddg+AtmVQB9bYNMJUXxHudN1VsKqkuBgKiIVQSzq42KaW28UWiuQ1x7HSdYQ2mYmEraFuCI0NC9yq81V3CstA1uTLQBJejn5qM3rDtx+WUCzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.03.2026 16:07, Marek Szyprowski wrote:
> Move init function from OF_DECLARE() argument to the given reserved
> memory region ops structure and then pass that structure to the
> OF_DECLARE() initializer. This makes it possible in the future to add
> more functions called by the generic code before given memory region is
> initialized and rmem object created.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   drivers/memory/tegra/tegra210-emc-table.c | 14 ++++++++------
>   drivers/of/of_reserved_mem.c              |  5 +++--
>   include/linux/of_reserved_mem.h           | 15 ++++++++-------
>   kernel/dma/coherent.c                     | 13 +++++++------
>   kernel/dma/contiguous.c                   | 15 ++++++++-------
>   kernel/dma/swiotlb.c                      | 13 +++++++------
>   6 files changed, 41 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/memory/tegra/tegra210-emc-table.c b/drivers/memory/tegra/tegra210-emc-table.c
> index ac1d1e13482a..f6395bc9dbc8 100644
> --- a/drivers/memory/tegra/tegra210-emc-table.c
> +++ b/drivers/memory/tegra/tegra210-emc-table.c
> @@ -70,11 +70,6 @@ static void tegra210_emc_table_device_release(struct reserved_mem *rmem,
>   	memunmap(timings);
>   }
>   
> -static const struct reserved_mem_ops tegra210_emc_table_ops = {
> -	.device_init = tegra210_emc_table_device_init,
> -	.device_release = tegra210_emc_table_device_release,
> -};
> -
>   static int tegra210_emc_table_init(unsigned long node,
>   				   struct reserved_mem *rmem)
>   {
> @@ -85,5 +80,12 @@ static int tegra210_emc_table_init(unsigned long node,
>   
>   	return 0;
>   }
> +
> +static const struct reserved_mem_ops tegra210_emc_table_ops = {
> +	.node_init = tegra210_emc_table_init,
> +	.device_init = tegra210_emc_table_device_init,
> +	.device_release = tegra210_emc_table_device_release,
> +};
> +
>   RESERVEDMEM_OF_DECLARE(tegra210_emc_table, "nvidia,tegra210-emc-table",
> -		       tegra210_emc_table_init);
> +		       &tegra210_emc_table_ops);
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 9aff460a0420..675f1c1c6627 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -492,14 +492,15 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
>   
>   	for (i = __reservedmem_of_table; ret == -ENODEV &&
>   	     i < &__rmem_of_table_sentinel; i++) {
> -		reservedmem_of_init_fn initfn = i->data;
> +		const struct reserved_mem_ops *ops = i->data;
>   		const char *compat = i->compatible;
>   
>   		if (!of_flat_dt_is_compatible(node, compat))
>   			continue;
>   
> -		ret = initfn(node, rmem);
> +		ret = ops->node_init(node, rmem);
>   		if (ret == 0) {
> +			rmem->ops = ops;
>   			pr_info("initialized node %s, compatible id %s\n",
>   				rmem->name, compat);
>   			break;
> diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
> index 5159938bfe03..dc00502a6b69 100644
> --- a/include/linux/of_reserved_mem.h
> +++ b/include/linux/of_reserved_mem.h
> @@ -18,19 +18,20 @@ struct reserved_mem {
>   };
>   
>   struct reserved_mem_ops {
> +	int	(*node_init)(unsigned long fdt_node, struct reserved_mem *rmem);
>   	int	(*device_init)(struct reserved_mem *rmem,
>   			       struct device *dev);
>   	void	(*device_release)(struct reserved_mem *rmem,
>   				  struct device *dev);
>   };
>   
> -typedef int (*reservedmem_of_init_fn)(unsigned long node,
> -				      struct reserved_mem *rmem);
> -
>   #ifdef CONFIG_OF_RESERVED_MEM
>   
> -#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
> -	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
> +#define RESERVEDMEM_OF_DECLARE(name, compat, ops)			\
> +	static const struct of_device_id __of_table_##name		\
> +		__used __section("__reservedmem_of_table")		\
> +		__aligned(__alignof__(struct of_device_id))		\
> +		 = { .compatible = compat, .data = ops }
>   
>   int of_reserved_mem_device_init_by_idx(struct device *dev,
>   				       struct device_node *np, int idx);
> @@ -48,8 +49,8 @@ int of_reserved_mem_region_count(const struct device_node *np);
>   
>   #else
>   
> -#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
> -	_OF_DECLARE_STUB(reservedmem, name, compat, init, reservedmem_of_init_fn)
> +#define RESERVEDMEM_OF_DECLARE(name, compat, ops)			\
> +	_OF_DECLARE_STUB(reservedmem, name, compat, init, void *)
>   
>   static inline int of_reserved_mem_device_init_by_idx(struct device *dev,
>   					struct device_node *np, int idx)
> diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
> index 64f9ba618e19..bcdc0f76d2e8 100644
> --- a/kernel/dma/coherent.c
> +++ b/kernel/dma/coherent.c
> @@ -362,10 +362,6 @@ static void rmem_dma_device_release(struct reserved_mem *rmem,
>   		dev->dma_mem = NULL;
>   }
>   
> -static const struct reserved_mem_ops rmem_dma_ops = {
> -	.device_init	= rmem_dma_device_init,
> -	.device_release	= rmem_dma_device_release,
> -};
>   
>   static int __init rmem_dma_setup(unsigned long node, struct reserved_mem *rmem)
>   {
> @@ -388,7 +384,6 @@ static int __init rmem_dma_setup(unsigned long node, struct reserved_mem *rmem)
>   	}
>   #endif
>   
> -	rmem->ops = &rmem_dma_ops;
>   	pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
>   		&rmem->base, (unsigned long)rmem->size / SZ_1M);
>   	return 0;
> @@ -405,5 +400,11 @@ static int __init dma_init_reserved_memory(void)
>   core_initcall(dma_init_reserved_memory);
>   #endif /* CONFIG_DMA_GLOBAL_POOL */
>   
> -RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
> +static const struct reserved_mem_ops rmem_dma_ops = {
> +	.node_init	= rmem_dma_setup,
> +	.device_init	= rmem_dma_device_init,
> +	.device_release	= rmem_dma_device_release,
> +};
> +
> +RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", &rmem_dma_ops);
>   #endif
> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index e6fc6906b5c0..efeebda92537 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -470,11 +470,6 @@ static void rmem_cma_device_release(struct reserved_mem *rmem,
>   	dev->cma_area = NULL;
>   }
>   
> -static const struct reserved_mem_ops rmem_cma_ops = {
> -	.device_init	= rmem_cma_device_init,
> -	.device_release = rmem_cma_device_release,
> -};
> -
>   static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
>   {
>   	bool default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
> @@ -499,7 +494,6 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
>   	if (default_cma)
>   		dma_contiguous_default_area = cma;
>   
> -	rmem->ops = &rmem_cma_ops;
>   	rmem->priv = cma;
>   
>   	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
> @@ -511,5 +505,12 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
>   
>   	return 0;
>   }
> -RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
> +
> +static const struct reserved_mem_ops rmem_cma_ops = {
> +	.node_init	= rmem_cma_setup,
> +	.device_init	= rmem_cma_device_init,
> +	.device_release = rmem_cma_device_release,
> +};
> +
> +RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", &rmem_cma_ops);
>   #endif
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index f3a12e15a951..327525181b8a 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -1855,11 +1855,6 @@ static void rmem_swiotlb_device_release(struct reserved_mem *rmem,
>   	dev->dma_io_tlb_mem = &io_tlb_default_mem;
>   }
>   
> -static const struct reserved_mem_ops rmem_swiotlb_ops = {
> -	.device_init = rmem_swiotlb_device_init,
> -	.device_release = rmem_swiotlb_device_release,
> -};
> -
>   static int __init rmem_swiotlb_setup(unsigned long node,
>   				     struct reserved_mem *rmem)
>   {
> @@ -1875,5 +1870,11 @@ static int __init rmem_swiotlb_setup(unsigned long node,
>   	return 0;
>   }
>   
> -RESERVEDMEM_OF_DECLARE(dma, "restricted-dma-pool", rmem_swiotlb_setup);
> +static const struct reserved_mem_ops rmem_swiotlb_ops = {
> +	.node_init = rmem_swiotlb_setup,
> +	.device_init = rmem_swiotlb_device_init,
> +	.device_release = rmem_swiotlb_device_release,
> +};
> +
> +RESERVEDMEM_OF_DECLARE(dma, "restricted-dma-pool", &rmem_swiotlb_ops);
>   #endif /* CONFIG_DMA_RESTRICTED_POOL */

It looks that this chunk got lost during the rebase, sorry for the noise:

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 327525181b8a..44b566d20e04 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1864,7 +1864,6 @@ static int __init rmem_swiotlb_setup(unsigned long 
node,
             of_get_flat_dt_prop(node, "no-map", NULL))
                 return -EINVAL;

-       rmem->ops = &rmem_swiotlb_ops;
         pr_info("Reserved memory: created restricted DMA pool at %pa, 
size %ld MiB\n",
                 &rmem->base, (unsigned long)rmem->size / SZ_1M);
         return 0;


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


