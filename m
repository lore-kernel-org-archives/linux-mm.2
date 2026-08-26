Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5246EC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FEBD6B0088; Wed, 26 Aug 2026 09:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6346B008C; Wed, 26 Aug 2026 09:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8F16B0092; Wed, 26 Aug 2026 09:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 270636B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:16:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7617D140361
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:16:26 +0000 (UTC)
X-FDA: 85143469572.06.FFCD6D6
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6F9E140008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:16:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=SDP1qw3M;
	spf=pass (imf09.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787750184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rx3zqcOgBMNdvWRHnyDvlfZnynx8EEyzAHso3JsbmAA=;
	b=WFGexrWqQX6ZHnXvnVX2CfT29Fxv2Ea4Qd/eoU8I28gW526vMSigxvN1EMo0UdufTffakb
	jH1D5uM4ax4cca55Pj6AO7FwtpUw2aA+ocwqvPA7PdNAHBPwF5ER27e6Vv5sjYxrJ4EXnb
	ZRCW4TSzyUP0MIOJQHSXmAlI0TDM990=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787750184;
	b=hY6g6JTJcj5TJpQIOozjkWc+gw9dEEAjI9Zr/sBOUXu/L2vYVC5T3Zf2SBcp4i/AvTVsul
	kmoSHQ7rZw3sSPE5ojH809UJuWsyUwEa/B5u3a49rheDxCnLHqRwsrO1oVZK3Y3rBxDtN6
	OPEzoaKDb7vbW0wu7IlN7QGDFKRBBas=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=SDP1qw3M;
	spf=pass (imf09.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260826131621euoutp01b122177b299393bd003d1701f8fef579~PXVGPpr-t0254202542euoutp01D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:16:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260826131621euoutp01b122177b299393bd003d1701f8fef579~PXVGPpr-t0254202542euoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787750182;
	bh=Rx3zqcOgBMNdvWRHnyDvlfZnynx8EEyzAHso3JsbmAA=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=SDP1qw3M5ntmu1AwgewRnrgU3G3D77HeUMw5ytAvw+g6S4Rrj8ylptGzd5VVopwrL
	 Ibl4RLC3ddXE2EQ7oPKonvufswM9/YRoXoPBFkXPoq1ezFTqElimEYGMBp6IrdETWd
	 JF0RCZ/V9Jzsx3JKcDr4PibFx+Z6G0dzcHU6yWBk=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260826131621eucas1p252dc76f83701618d60b3713500c10a2c~PXVF5uMMi1135311353eucas1p2U;
	Wed, 26 Aug 2026 13:16:21 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260826131621eusmtip17e59151fa7014cb894754f178bade425~PXVFie79E1334913349eusmtip1K;
	Wed, 26 Aug 2026 13:16:21 +0000 (GMT)
Message-ID: <aa0fc15c-eb46-4abc-9260-7aaa8a39c040@samsung.com>
Date: Wed, 26 Aug 2026 15:16:20 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 2/5] of: reserved_mem: reject static regions
 overlapping no-map memory
To: Wandun Chen <chenwandun1@gmail.com>, robh@kernel.org,
	saravanak@kernel.org, rppt@kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260818092420.2859026-3-chenwandun1@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260826131621eucas1p252dc76f83701618d60b3713500c10a2c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260818092441eucas1p1fde9b887efa0fcfb6d158623c47d7d99
X-EPHeader: CA
X-CMS-RootMailID: 20260818092441eucas1p1fde9b887efa0fcfb6d158623c47d7d99
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
	<CGME20260818092441eucas1p1fde9b887efa0fcfb6d158623c47d7d99@eucas1p1.samsung.com>
	<20260818092420.2859026-3-chenwandun1@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6F9E140008
X-Stat-Signature: fkjfum9ubychdycouc36q7mdnkg8fzcz
X-HE-Tag: 1787750183-820122
X-HE-Meta: U2FsdGVkX19Rd1Wj6W8Lz3nUxL1rU1vUDh1cGV1jRToyQH5EBKM8GR8i40FNvmNCdBIHOti8QZTlzbDgX53ur9GssHZ6b9LSjekBaSnzihvo0xdVtFX8MNmCR9XW9+VI1PgkXnVcvdpdvkp9Rwr1bsCxEUG2l9A47EHcuMAR3qJ1tnph0k1JySzT3kw7fdHo2+/EhS/JdHQaqbIEJnSbJawlTpIVgP2InhGaC0Yc5K2u55yk+PfXkMp7ivW3ro02ntij8NsnJPh2hXmGBAEo/93Qxf8ttuHzQy/nPcow0cevGnVtNUAI/JlIF2Wr8gGUBz6nlfWhDmJpfmSBK3DrSCopLPYzK113TrGhwjpyddxr8a07QfxANOUTgj9DHFKzu0TgWH62ElEwX4sI8UydcYf9toGBcIEx/LRPXVNDUMBrFlcQIdJ/V7xlEQiuZjPncwD7cI+1KhzGSUhkeFZpfKftIpDmNIncsiZg/KaaSmbr+zSRa1z0tpuAReTrKl/2djQ1rikkhIdyJj/f7s/B9Jd4ivEoHXyObIuiZd8I63R+azgGSaWb1qH5H5SEMBWNuK+FIdvj+Vp0tRpiHhBFYv7L1o1uCxQRppsZYwZqj8mGq5jKxqKJjUlt+E/QsLD+xdNxObouRr9lJduHEwvGROi3aPMk1thBUG7H2MTR06RAGFG85babwo0HcrHgOKDeaNodr2R7qb6QvEBtd/KtzaVd8Jiui2oekV2WDyvFNCcWuADIGnb7exehEfh6yXRsrprfON2lQONGVdPzw0JYH64qNIA1vu7VeaAyl8IrSNn86RtrrdKLun1H1oAj+q6yK1eTwr+czCUsdG+sH1UlrQ5cLK3I4y2vUf9xIPQEl2Bw1kJAI0rKz8pLjSYYoA1pXY3fQ4fKYTYtaX64DE1AsWr/0kn8+RiRpWDg0TvcVz2YyOBa/i/U8AWxe2J1EYfdRQIi6GQAlGPUvLGMYVG
 HgfVI1fh
 rJAH+y7wzTnhjqqJgCZxhhZ97zEuWz+JsmiOeW09rWJ5+5UlTJ0nYw9bY0/gE191BAFWBjqa9u4oTZaJqFYm++Kb2pfcZbbyqa4yLKFzMc5qG/UPL3ATg1MivdNLp9M2G7ST1n4Q8YLtI9r5CIzv8ik3DF92t2r9I8tJFUNzEhWUfxjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.2026 11:24, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> Static no-map reserved-memory regions are marked in memblock.memory rather
> than memblock.reserved. So the reservation overlap check does not reject
> a static region that overlaps existing no-map memory.
>
> Both regions can then be initialized and hand the same physical memory to
> different reserved-memory drivers. So reject a static region that overlaps
> existing no-map memory.
>
> Sashiko found this issue in [1].
>
> Fixes: 86588296acbf ("fdt: Properly handle "no-map" field in the memory region")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Link: https://protect2.fireeye.com/v1/url?k=c110879a-a8abef28-c1110cd5-905a08a8515a-5165b48469b02786&q=1&e=6166144c-5cef-48c6-9f6f-b36a72f258ac&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fmessage%2F20260814084718.29C341F000E9%2540smtp.kernel.org [1]
> ---
>  drivers/of/of_reserved_mem.c |  3 ++-
>  include/linux/memblock.h     |  1 +
>  mm/memblock.c                | 14 ++++++++++++++
>  3 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index c6e73d710ee1..9fb2e4c29443 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -152,7 +152,8 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
>  		 * if the region isn't memory as it won't be mapped.
>  		 */
>  		if (memblock_overlaps_region(&memblock.memory, base, size) &&
> -		    memblock_is_region_reserved(base, size))
> +		    (memblock_is_region_reserved(base, size) ||
> +		     memblock_overlaps_nomap(base, size)))
>  			return -EBUSY;
>  
>  		return memblock_mark_nomap(base, size);
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index d62db9e776cf..27d68fbb3157 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -148,6 +148,7 @@ int memblock_physmem_add(phys_addr_t base, phys_addr_t size);
>  void memblock_trim_memory(phys_addr_t align);
>  unsigned long memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
>  				     phys_addr_t base2, phys_addr_t size2);
> +bool memblock_overlaps_nomap(phys_addr_t base, phys_addr_t size);
>  bool memblock_overlaps_region(struct memblock_type *type,
>  			      phys_addr_t base, phys_addr_t size);
>  bool memblock_validate_numa_coverage(unsigned long threshold_bytes);
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 9ce86349a29f..4cabfe365ac4 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -202,6 +202,20 @@ memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1, phys_addr_t base2,
>  	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
>  }
>  
> +bool __init memblock_overlaps_nomap(phys_addr_t base, phys_addr_t size)
> +{
> +	struct memblock_region *region;
> +
> +	memblock_cap_size(base, &size);
> +	for_each_mem_region(region) {
> +		if (memblock_is_nomap(region) &&
> +		    memblock_addrs_overlap(base, size, region->base, region->size))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  bool __init_memblock memblock_overlaps_region(struct memblock_type *type,
>  					phys_addr_t base, phys_addr_t size)
>  {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


