Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D883606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=vXUnHieI
Received: by kanga.kvack.org (Postfix)
	id A9E536B05B3; Mon, 16 Nov 2026 07:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75DC6B05B4; Mon, 16 Nov 2026 07:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B33B6B05B5; Mon, 16 Nov 2026 07:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67BC06B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:48:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0C111A08F9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:48:57 +0000 (UTC)
X-FDA: 85440961914.26.C2AAD3F
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 374681A0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:48:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=vXUnHieI;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+vj+2gwnCsvLuhkx5/eZ6hFIO5bSIxa0YO+wbxe2XI=;
	b=LJfX/X+L9z3VRh5l+qtoltVjfONIGa95j7ql5MRx/AO20LqYUAcSSB82niAxSMidnadxAk
	cFxlg2dI0lbhQTR7T6pzPr/N15U530lo9uI5oI6awbyrD6cBsXUBTrdUT+5f70/PpMTazZ
	6tpuybvljXS4CT2KnFpK8jWEoQQtrhU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833336;
	b=q+qSKGK0479770pRe9s5+Sio150t8spPUHCr53cXG8LUolF/cFH5dshPvJkFkP/aMCBc4U
	60PNNh39ARFAem5/Y1piFyFeOcf5RbR9fy59LPNeW8f+yLgsRqfy70yJv7q/bvcveJWGB/
	yHmYZLK433sWpAFZSp0uTTNw8bwLKkg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=vXUnHieI;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261116124853euoutp011c54477e4a3caf93faed9a5d97743d45~oh2gttuGE0188501885euoutp01Y
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:48:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261116124853euoutp011c54477e4a3caf93faed9a5d97743d45~oh2gttuGE0188501885euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794833333;
	bh=q+vj+2gwnCsvLuhkx5/eZ6hFIO5bSIxa0YO+wbxe2XI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=vXUnHieIz2yw+ObZTGg5tyMTifGqwLhsQ1gYBSiha8L5jipBAijhFM7gQ3PAXm81c
	 w0U1TKaoclXlzKfmNLWjueZ41UJuTJfo5KujIPpzcYH2sEvV2rB46NnMrEYD28ih8p
	 y0KSQM2UEzOvKv20NF6qT2YhtGWVCAcx5sggoxY0=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261116124852eucas1p1b150cae3b2b4f5dac6550d7236791c35~oh2gXEqqS3152131521eucas1p1p;
	Mon, 16 Nov 2026 12:48:52 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261116124851eusmtip129b1231d1435be7a0a2c4fa4d4861c9f~oh2fZOj-F3032230322eusmtip1O;
	Mon, 16 Nov 2026 12:48:51 +0000 (GMT)
Message-ID: <2be89ecd-2809-4182-b2c4-df062fcf68b6@samsung.com>
Date: Mon, 16 Nov 2026 13:48:51 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 05/40] dma-contiguous: add dma_get_numa_cma_area()
 accessor
To: Alexander Graf <graf@amazon.com>, linux-kernel@vger.kernel.org, Greg
	Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
Cc: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, Shuah
	Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>, linux-doc@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, David
	Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	nh-open-source@amazon.com, linux-mm@kvack.org, Jonathan Corbet
	<corbet@lwn.net>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <a1294df95fbe0a2ef5cc3585824d396854c7242c.1794393490.git.graf@amazon.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261116124852eucas1p1b150cae3b2b4f5dac6550d7236791c35
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261111224311eucas1p1eb735607894271094a8934b187647ad5
X-EPHeader: CA
X-CMS-RootMailID: 20261111224311eucas1p1eb735607894271094a8934b187647ad5
References: <cover.1794300002.git.graf@amazon.com>
	<CGME20261111224311eucas1p1eb735607894271094a8934b187647ad5@eucas1p1.samsung.com>
	<a1294df95fbe0a2ef5cc3585824d396854c7242c.1794393490.git.graf@amazon.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: c9o4o3oh7kadwyen4mfrjwh7j7yb4j3u
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 374681A0005
X-Rspam-User: 
X-HE-Tag: 1794833335-682236
X-HE-Meta: U2FsdGVkX19Oczk3klb7MmzSd4FwnTldzsgnbLgtvwCdoIp5YmnxGOO1XzZ8/HA9jtKvye5aqYtyLyrFLRpj5AiPYw6v0u820co8GTbrST56bpcfaQ3tUTG7II9tBjnhZF1WA3tlUpA4NNcJRWY9G1++mIPzQNU9MXvM+7RMW3LN91LwdOy/tfTW3IZ9NxL0mb6MTrk/ZowqDbmslQAktDz+pBWL/n4F/G3szHGOcqfaYc1r6KrE7+6Xu8BG+sFn/qOHlAVl3NxQRz14qzbG+Hx/voODcuebcK9Y7vX6djWBLuho+j5EZoY6+fLkLurWxg1MFCgJ34z9b9tFfIYPE3MLgTne6mEfVBu7QgI8lMP8WmmRfpdJmadWd77zcyEW41Cum5cdeXuFfwhDSvtvxxxPw3TpK0yv2pZXCa020NPtG4Hz48zbZVglmACuqwF1DuzVjN52NZGuVtfid5z11XOONvhuSs2N3/GgKrYPiYf7JFrCwRWHA6q1fMh3mFDzPupAnucraJmTY+8OEaExw7CQ9jZLd3qyRIzhiyV1oIA7w9qM3CwnZzzVheqceO7yjDwGl23h0hWcUxMjg+WW/e2+RX+azqDoZfU5Xcu3lIMFMEo71Ph+2s4YBuIuvGMq8VPIJm/WD3REDbXJ0/o9DXnEPwyJ+tzutMPJ7Q4I6t1iTKU7YUCoVKRhKpQY7awBHyXgpd8iX4vmaN4KsVQD+nNQTfi6bQW7iQIPQijZHkoFBJSQn0QoJsYRBtBjjCpj7590U2zOMetipYk41h8VrxQvOGk0XbNZImNqgFOMERaQ1Ola2l0WcrvhWPO5komm8LyCf28vM/cu8QXWCSrWYWYTzO9GabRIaHshu1rKJwqa9FD+ARoeN2NxjieZvTpdkzWdsriL4VWWsDXh3msLLqIfNrZS03ifDjWdr0JzmXYdZRxi32DoWEWysS79gG75NWU0u635sjLVDN9Hvuh
 fGfOfs4g
 3dHZ+9fuXCfLvVqmHKfDGB3DCyXhDDZAZDq48cwT203Zf1TupKtGyi1lgSSOL4v+YWOltSbIDqr4pXFmZQ5TBdlUMvb60HWUzsYeXDRQAZBEFqC6wEuWMCsDXgIGe7W8Mdc+wuMMTO+4Q1Ufv8uCzXaYVK/cSDIVPtheTdzfKgEWoUBJKLTIRgA7zVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11.11.2026 23:41, Alexander Graf wrote:
> With Nitro Sandboxes, we want to allocate per-NUMA memory from the DMA
> contiguous allocator, but have no per-NUMA struct device to pass in.
> dma_alloc_contiguous() takes the node from dev_to_node(dev), and the
> per-node areas sit in dma_contiguous_numa_area[], which is static.
>
> So instead, introduce dma_get_numa_cma_area(), which returns the generic
> per-NUMA DMA CMA area that cma_alloc() would use. This way, the
> nitro_enclaves driver can build its own generic CMA pool per-node
> allocation logic on top of those pools.
>
> Signed-off-by: Alexander Graf <graf@amazon.com>

Take a look at the following patch and the patchset it belongs to:

https://lore.kernel.org/all/20261106184433.761422-5-kuba@kernel.org/


> ---
>  include/linux/dma-map-ops.h |  7 +++++++
>  kernel/dma/contiguous.c     | 36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
>
> diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
> index afaf2c12189b8..5f7138ea6899a 100644
> --- a/include/linux/dma-map-ops.h
> +++ b/include/linux/dma-map-ops.h
> @@ -93,6 +93,7 @@ static inline void set_dma_ops(struct device *dev,
>  #ifdef CONFIG_DMA_CMA
>  struct cma *dev_get_cma_area(struct device *dev);
>  struct cma *dma_contiguous_get_area_by_idx(unsigned int idx);
> +struct cma *dma_get_numa_cma_area(int nid);
>  
>  void dma_contiguous_reserve(phys_addr_t addr_limit);
>  int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
> @@ -115,6 +116,12 @@ static inline struct cma *dma_contiguous_get_area_by_idx(unsigned int idx)
>  {
>  	return NULL;
>  }
> +
> +static inline struct cma *dma_get_numa_cma_area(int nid)
> +{
> +	return NULL;
> +}
> +
>  static inline void dma_contiguous_reserve(phys_addr_t limit)
>  {
>  }
> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index 90937dc7c627d..363b84284d087 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -443,6 +443,42 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
>  	return cma_alloc_aligned(dma_contiguous_default_area, size, gfp);
>  }
>  
> +/**
> + * dma_get_numa_cma_area() - get the CMA area a NUMA node can allocate from
> + * @nid: NUMA node id
> + *
> + * dma_alloc_contiguous() picks a per-node CMA area from dev_to_node(dev),
> + * which a caller cannot override on a per-request basis. This accessor
> + * returns the area a specific node can allocate from, so a caller can
> + * cma_alloc() from the node it wants.
> + *
> + * A per-node area comes from numa_cma= or cma_pernuma=, or from
> + * CONFIG_CMA_SIZE_PERNUMA, which reserves the default area's size on every
> + * online node on top of the default area itself, all three of which are
> + * CONFIG_DMA_NUMA_CMA. Where there is one online node this returns the default
> + * area, so a host that reserved only cma= reaches its reservation through this
> + * accessor as well, and that holds however CONFIG_DMA_NUMA_CMA is set.
> + *
> + * Return: the area @nid can allocate from, or NULL if @nid has none or is not
> + * a valid node (including NUMA_NO_NODE).
> + */
> +struct cma *dma_get_numa_cma_area(int nid)
> +{
> +	if ((unsigned int)nid >= MAX_NUMNODES)
> +		return NULL;
> +
> +#ifdef CONFIG_DMA_NUMA_CMA
> +	if (dma_contiguous_numa_area[nid])
> +		return dma_contiguous_numa_area[nid];
> +#endif
> +
> +	if (nr_online_nodes == 1 && node_online(nid))
> +		return dma_contiguous_default_area;
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(dma_get_numa_cma_area);
> +
>  /**
>   * dma_free_contiguous() - release allocated pages
>   * @dev:   Pointer to device for which the pages were allocated.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


