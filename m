Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A70B108B917
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 12:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A836B0089; Fri, 20 Mar 2026 08:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01A16B008A; Fri, 20 Mar 2026 08:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F6B6B008C; Fri, 20 Mar 2026 08:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2B006B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:24:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6258756977
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:24:26 +0000 (UTC)
X-FDA: 84566359332.11.3C5664D
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id B1B62140018
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:24:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Lm+LMJ1N;
	spf=pass (imf23.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774009464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBoVOBx1I566RxpDMI+o2b7Nge6l1DhueDNqbVeTZ9I=;
	b=tSsJ38ElwBeBJUcHwNV2gGj2Nnv+v+BDumWDx+WkbvO9APab3MJy9dXOEAxOFY/CPq4b9y
	8x4LKgpmEFA3xB2Xuz4Yj5cf2dn0/fm8h3bf27EiuHIk4uh5+6UlgyaNV0itTvg7RW3OL3
	rGoVA4R248G/itnZ5ZBo2yaYXMJ9cpU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774009464; a=rsa-sha256;
	cv=none;
	b=AXNHsjmYJ6+DkoJ35+xgrprShw/45APS8hoLpUFDEmfMnqI+3JNO3PVkumuBwlSCyjhI4w
	GcgO8PMagcw/mUXvoURhCyzBbDxBS7A56wy9tsC/5bWOtj1/sFPYIcTZQ2dgv9Ri8e6i3C
	yOsXgf7W2c+Ui4RAcX4MoELka5lAN4c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Lm+LMJ1N;
	spf=pass (imf23.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260320122421euoutp029801716f72303c6c28f744ac6a365504~ejDS3wzgX0047100471euoutp02U
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:24:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260320122421euoutp029801716f72303c6c28f744ac6a365504~ejDS3wzgX0047100471euoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774009461;
	bh=zBoVOBx1I566RxpDMI+o2b7Nge6l1DhueDNqbVeTZ9I=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Lm+LMJ1N2KMDXYMK1DOJQHu+mcsmsRVm47PRbfNKkp8LdCVnjJF+uuVbrRgj1j9cG
	 U6RyPHSthJw3H1wRb6DJWdKEkegzlLK8kjUL4OkQza+IkqiKcpbdhiO2jqVXlE4EAI
	 pmpJvKXTiVmVuJGUhpk10ye6Ti+6l5/UoHmotHuQ=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260320122421eucas1p17d0a17d9bdd22b45c1e60c78271e1d65~ejDSnuv7b2308323083eucas1p1i;
	Fri, 20 Mar 2026 12:24:21 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260320122419eusmtip117bbdef1d0f760c12e7437f2d83e9ca0~ejDRniVoR0999509995eusmtip1m;
	Fri, 20 Mar 2026 12:24:19 +0000 (GMT)
Message-ID: <c60a3f30-6fc3-41ab-835a-2fdd887e18fd@samsung.com>
Date: Fri, 20 Mar 2026 13:24:18 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/8] dma-buf: heaps: Turn heaps into modules
To: Maxime Ripard <mripard@kernel.org>, Sumit Semwal
	<sumit.semwal@linaro.org>, Benjamin Gaignard
	<benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Robin Murphy
	<robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, David
	Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
	Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260320122421eucas1p17d0a17d9bdd22b45c1e60c78271e1d65
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260303101320eucas1p2eb4fea499364ef20825d0d73585a2555
X-EPHeader: CA
X-CMS-RootMailID: 20260303101320eucas1p2eb4fea499364ef20825d0d73585a2555
References: <CGME20260303101320eucas1p2eb4fea499364ef20825d0d73585a2555@eucas1p2.samsung.com>
	<20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
X-Rspam-User: 
X-Stat-Signature: j86dnrs96hgj955desp96d53oj189d8y
X-Rspamd-Queue-Id: B1B62140018
X-Rspamd-Server: rspam03
X-HE-Tag: 1774009463-514231
X-HE-Meta: U2FsdGVkX1+TRDzyfVouddNRxAw0c3JUy684iWY3OsIf9bDQifmS8E8XbBepAil1tp9vQ7A51IV+t/zSfSiVO7En+MY9kv3FFGLUSeVrjE0zsS26dnj8sN1DQ8o3UpJERGKKJvSIkDt2l7StTiVhkzxTiZyBzOk2NUDpMXYDGRWaGQpTLPlcke9f+HPkT4R61e1gketvCL1h6o65r8zitWHnmdV60/iCU8MRk74urMEOXbDedKIYIRiBmxWcWgDOGKqdHwmYcM+HjmU75yVUQ9hx8NOcGZjfjlIv2ve8BNb3ifkM1atT9PsZuqTkkjjPPBrL4aBcZask6Vjytn/JMilDFFa4nlUwd0Jy5EBntG5czuSc5d0/OPQlDuHDoadWFEK1yFDcTN6JMppoxw/9UO9tRgX2gOQ74/4Na0UvsKlGqVUnwJ2NV30Ql//iuS166qrjjZIAIRhsPDcu32JzmZJIFjaY86QXB0mrhRnLyxTtecj1q629lugiWviEw3RNQYZ0iIARAM4rBgaW75SMBtXEnz3Tj9KBjjasn02hN6Xe5Q3vNZukOUp+JNsytPqq/cz67hqXMGb3a1NMd/fNgUoJuBiELcEBR/P+Jalqw6/jspRz+KJt79J3XK6gjOVX4OR/OMq8FoMumDs9H3spTDMAcRj3v6EVfB0V7zrHsWK/bY6b/4l6WUHhDQRNT7ZpHQ32pQfnO5zdgeRrDH2Itnobxal4TDAzs5AUfRuvPfEQVksN2UIPsafVfs9HEE2HXRY7e3e2ORFzrWWOk82t7GNp856YLSrstNxETVLEJr12hTzFNhkGAoqrSy2BKCAuR/POJPkzrxxFIcehwDcAuUJNFif98vZmtnAMtzVcwF5iTuOJdtiLifgurd5nTP7uPqCvG+2d7gkPo1ARNTAdr4nUzxPmuT44bwvosSefrEk7QbocaPSOhiCHm3VNOHY2n/Sw2xXlErN0g+GQm30
 FonHS/VV
 POhpyNF16JVITo9Oc1ABbxLvJPN8yjnicIsPvlwCq78xVhXtBqoKnGVuew6uSd57X1ZMDebiUj38FKQ3lsQGr8k4NH7ro7Y1qAt2hEiweW1zqL5JlVYmxHbaZeDCAu/cvb2/e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maxime,

On 03.03.2026 11:13, Maxime Ripard wrote:
> The recent introduction of heaps in the optee driver [1] made possible
> the creation of heaps as modules.
>
> It's generally a good idea if possible, including for the already
> existing system and CMA heaps.
>
> The system one is pretty trivial, the CMA one is a bit more involved,
> especially since we have a call from kernel/dma/contiguous.c to the CMA
> heap code. This was solved by turning the logic around and making the
> CMA heap call into the contiguous DMA code.
>
> Let me know what you think,
> Maxime
>
> 1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wiklander@linaro.org/
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

I'm okay with the kernel/dma/contiguous.c changes. I only wonder how to 
properly merge them. There are other pending changes to 
kernel/dma/contiguous.c file [1] and if they finally get reviewed, I 
would like to merge both via dma-mapping-for-next tree. Then I can 
provide a stable branch for merging the remaining dma-buf pathes. Is it 
okay for You?

1. 
https://lore.kernel.org/all/20260313150802.1121442-1-m.szyprowski@samsung.com/ 



> ---
> Changes in v3:
> - Squashed cma_get_name and cma_alloc/release patches
> - Fixed typo in Export dev_get_cma_area commit title
> - Fixed compilation failure with DMA_CMA but not OF_RESERVED_MEM
> - Link to v2: https://lore.kernel.org/r/20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org
>
> Changes in v2:
> - Collect tags
> - Don't export dma_contiguous_default_area anymore, but export
>    dev_get_cma_area instead
> - Mentioned that heap modules can't be removed
> - Link to v1: https://lore.kernel.org/r/20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org
>
> ---
> Maxime Ripard (8):
>        dma: contiguous: Turn heap registration logic around
>        dma: contiguous: Make dev_get_cma_area() a proper function
>        dma: contiguous: Make dma_contiguous_default_area static
>        dma: contiguous: Export dev_get_cma_area()
>        mm: cma: Export cma_alloc(), cma_release() and cma_get_name()
>        dma-buf: heaps: Export mem_accounting parameter
>        dma-buf: heaps: cma: Turn the heap into a module
>        dma-buf: heaps: system: Turn the heap into a module
>
>   drivers/dma-buf/dma-heap.c          |  1 +
>   drivers/dma-buf/heaps/Kconfig       |  4 ++--
>   drivers/dma-buf/heaps/cma_heap.c    | 21 +++++----------------
>   drivers/dma-buf/heaps/system_heap.c |  5 +++++
>   include/linux/dma-map-ops.h         | 18 ++++++++++--------
>   kernel/dma/contiguous.c             | 37 ++++++++++++++++++++++++++++++++++---
>   mm/cma.c                            |  3 +++
>   7 files changed, 60 insertions(+), 29 deletions(-)
> ---
> base-commit: 499a718536dc0e1c1d1b6211847207d58acd9916
> change-id: 20260225-dma-buf-heaps-as-modules-1034b3ec9f2a
>
> Best regards,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


