Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 711EBFF495E
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAEE76B0095; Mon, 30 Mar 2026 03:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85906B0096; Mon, 30 Mar 2026 03:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2AF6B0098; Mon, 30 Mar 2026 03:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC2496B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:44:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 622BEE09C8
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:44:25 +0000 (UTC)
X-FDA: 84601941690.29.238AFCD
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8C3E140007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:44:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=YJrGmy8G;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf17.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774856663; a=rsa-sha256;
	cv=none;
	b=JhMHCPwlWCf5kwPb12DduVWIrP0w6DfLHbdjHaTFS1zWGUUBnz9DtqBhKYh94B5H0v09DI
	us7UUh3PXrCg0Z8nCc6UFJ3mtmls+x9/NDdQ6Ko9/JSN0c4wzLZAQ2OjV5+X5zk5Ft7OWb
	P60QYa/hRUCRp0/MMkn6rWZey7/yYxI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=YJrGmy8G;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf17.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774856663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QPMkW/TQgAobnAcPDNit13NRu4FKkyV5RCLsq0khvk=;
	b=Ojg9SzCqP4kGsuoSEU0XGWv6HXAcAcWiZmtVp7FszDR6+PpGvPTKLfO0Ono3FrOdca2hJ/
	G8Xxo/jQnkeHkGI7E/OLG+6tgy5ky2k1K68S4qtZ5YrgKwQNJpJtLZGh69Surl0BKRC7Wj
	qRF2CtSTQU66K8tJz5rD6S64Ic+epIA=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260330074420euoutp0298f1dbf20d3d9826bc22b132e67508e8~hjrqWCVKJ3061430614euoutp02p
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:44:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260330074420euoutp0298f1dbf20d3d9826bc22b132e67508e8~hjrqWCVKJ3061430614euoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774856660;
	bh=9QPMkW/TQgAobnAcPDNit13NRu4FKkyV5RCLsq0khvk=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=YJrGmy8GvOM3mmyK9kws4zdWGH1dA1A5Md3L+uoa7kf5NvPELnf3Rt57mYaxlDG6t
	 2ozhEK1FoWFGq1mvVoca4CpOlr/ImI6n+8NjrlUk96uadGEUy3tWeR/tKpv7Ran/pu
	 T8if3cS6Q8XI76uQgyu+XJnrqBi9AtDPw/6mAUHY=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260330074419eucas1p1cb351a1eec598b99842de25cb754e135~hjrqEFclI3155331553eucas1p1k;
	Mon, 30 Mar 2026 07:44:19 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260330074418eusmtip14412bd6a1082ddac8ec5e8950d587f4f~hjrpFeoW32902829028eusmtip1T;
	Mon, 30 Mar 2026 07:44:18 +0000 (GMT)
Message-ID: <6270d4f0-85e4-496d-8db4-87ccb791ca4d@samsung.com>
Date: Mon, 30 Mar 2026 09:44:18 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2] dma-debug: suppress cacheline overlap warning when
 arch has no DMA alignment requirement
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, robin.murphy@arm.com
Cc: iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-mm@kvack.org, harry@kernel.org,
	vbabka@kernel.org, akpm@linux-foundation.org, stern@rowland.harvard.edu,
	linux@roeck-us.net, andy.shevchenko@gmail.com, hch@lst.de,
	Jeff.kirsher@gmail.com, catalin.marinas@arm.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260327124156.24820-1-mikhail.v.gavrilov@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260330074419eucas1p1cb351a1eec598b99842de25cb754e135
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72
X-EPHeader: CA
X-CMS-RootMailID: 20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72
References: <CGME20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72@eucas1p1.samsung.com>
	<20260327124156.24820-1-mikhail.v.gavrilov@gmail.com>
X-Rspamd-Queue-Id: 8C3E140007
X-Stat-Signature: ouakj7baqa8pyoxt6c8xk8mkms4qawqp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774856662-183833
X-HE-Meta: U2FsdGVkX1/5qo8Q+iHT/oht87Dp18S97emXq2FpIaYMOoK/um02Z+ROgieMHmCeSW5kInbWO78SOFWGX187YOYSQYi9UYXZb4DUj5TnDT5XtcPQ9RY2WSAL6tFMqvDzHv/hwTMQgz+TNCDigle4r4TtAhD4KS/aeJrg21JphnHcm/klMwbuPgBLeQs/k9sXLVYuPzCO9s09LgdUw8tNEADp4ULt8sZWdEso7rhjzyMbMYM+pDyniAdmhP1hRwVI1ACiNFTdVfdnzl/j8qWOQFVpDcY0zFBTNUm6Xqra7ItD4EYJsEFjsUnc5SeHF1oGUaFvEQBQm2rOqe3lD74kvhnTr5hP3nJguXjEbgcNzXgCZz8TmscPlWpOWjn7yoUP/K1GEECXlvCfLdnw8lhrsPfRDkBRAszHgN3P0a451l5vd/VGbUTThY9/uMe+HpwrqGmv/7IWL+LmyiUhKTsDhHHje7MZYF7x2b9dn3MhtP8ukgG2JFEy8TuLG+bQaOYBrKTMiSg6En6/92EaNOb0ZUQR4Vfze9f9Vx3m3ZplDOqyLNdZtmGo9bkF+z0RP2Q+fPiHjX+c5iwdVUr9keHok1FHH2eoIIrN/BXnuLzSKesqb0pti5qNgVTRO0/of2M2UGSQz9n3+k7zi1vxc3XJ2J/hqYteOGzSfgaWzizjg/hkxZXTXWzU1zvkv2E2vBPpI8Fy22azC/QW2i5a49meR8S9vhM/zhK4IDpbgMMEfq4+NwtnB7w9fyT7shaCp6498uugPCb5eJ3IJdzBMM93zc5SGHD56xRSYFKz+8GgUPzjyu8Z6/SKru/Zf8HZ99m0nft3VaoRgyf9ebywyRDUao9zk6njNyxI8ADMCcwHVT20PET8/hDFvEFbpgu94tl709raYmopwJMyFiuCyy0EB5SNIfxo9KqbIJdPt28gyPFi7QJKMaWc8AnM04uljbp8AR29sxsarGNk0TH9TLX
 UsPjADVa
 FHqcMtU8S6wuU48pFn0B1FaLDUi7Poc61ZCUa2Abk2YM70efrt3ROGAaKMjnRcZhK3k3Fz912t2Z5OGSBlwapoiMeuS/vJDxD9SZl/o78Bp4oOQ9d2s7Cs3jLqDapbfmTYsVRvG5yaE6p+kaqGAPjLhNff5em/cIt4I1XqtuSZ/V0G+7pXWK9S3BID7jtslM8Lrj2RMHAbpLViQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.03.2026 13:41, Mikhail Gavrilov wrote:
> When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
> tracks active mappings per cacheline and warns if two different DMA
> mappings share the same cacheline ("cacheline tracking EEXIST,
> overlapping mappings aren't supported").
>
> On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
> allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
> hub driver) frequently land in the same 64-byte cacheline.  When both
> are DMA-mapped, this triggers a false positive warning.
>
> This has been reported repeatedly since v5.14 (when the EEXIST check
> was added) across various USB host controllers and devices including
> xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.
>
> The cacheline overlap is only a real concern on architectures that
> require DMA buffer alignment to cacheline boundaries (i.e. where
> ARCH_DMA_MINALIGN >= L1_CACHE_BYTES).  On architectures like x86_64
> where dma_get_cache_alignment() returns 1, the hardware is
> cache-coherent and overlapping cacheline mappings are harmless.
>
> Suppress the EEXIST warning when dma_get_cache_alignment() is less
> than L1_CACHE_BYTES, indicating the architecture does not require
> cacheline-aligned DMA buffers.
>
> Verified with a kernel module reproducer that performs two kmalloc(8)
> allocations back-to-back and DMA-maps both:
>
>   Before: allocations share a cacheline, EEXIST fires within ~50 pairs
>   After:  same cacheline pair found, but no warning emitted
>
> Fixes: 2b4bbc6231d7 ("dma-debug: report -EEXIST errors in add_dma_entry")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215740
> Suggested-by: Harry Yoo <harry@kernel.org>
> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

Applied to dma-mapping-fixes. Thanks!

> ---
>
> v1 -> v2:
>   - Moved fix from include/linux/slab.h (ARCH_KMALLOC_MINALIGN)
>     to kernel/dma/debug.c per Harry Yoo's suggestion.
>   - Instead of forcing cacheline-aligned allocations, suppress
>     the warning when the architecture has no DMA alignment
>     requirement (dma_get_cache_alignment() < L1_CACHE_BYTES).
>
> v1: https://lore.kernel.org/all/20260327055846.248829-1-mikhail.v.gavrilov@gmail.com/
>
> Reproducer module that triggers the bug reliably:
>   https://bugzilla.kernel.org/attachment.cgi?id=309769
>
>  kernel/dma/debug.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
> index 0677918f06a8..1a725edbbbf6 100644
> --- a/kernel/dma/debug.c
> +++ b/kernel/dma/debug.c
> @@ -615,6 +615,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
>  	} else if (rc == -EEXIST &&
>  		   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
>  		   !(entry->is_cache_clean && overlap_cache_clean) &&
> +		   dma_get_cache_alignment() >= L1_CACHE_BYTES &&
>  		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
>  		     is_swiotlb_active(entry->dev))) {
>  		err_printk(entry->dev, entry,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


