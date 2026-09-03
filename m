Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F42C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35356B00E1; Thu,  3 Sep 2026 03:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6356B00E2; Thu,  3 Sep 2026 03:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7856B00E3; Thu,  3 Sep 2026 03:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA4C6B00E1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:32:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2BF9E1603E2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:32:47 +0000 (UTC)
X-FDA: 85171633974.11.0690645
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id D9A3C140007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:32:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Be3mug4n;
	spf=pass (imf23.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788420765;
	b=Ype+y4GTMwiwOIu2aUGdylIxrvUGM6V5uJVQJVaxusJCpClCVgaSBGNdAWCuY1HI0GWv42
	rjfoWpZwDA05i2nvmJVY+HJMY97OxwXbrnlQm9EgBWyk4POz1f5xGCbcLJ1quL05p01/Us
	Uvk6fhd54RZTsNS5iwDL9xKmK4sf3T8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Be3mug4n;
	spf=pass (imf23.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wHQNtUzqWMJSc1lx6xZnDlVX8u6lqdGivmRj3Xx4g8=;
	b=Rt/e0pm/1e7Co4j/WlGpqNz2mXOAFnYtW81mWP0SBkHdUTRdp6Ly1b1Z6HLZluzttFkXG2
	2yWiN7gFAYaUEsTKZ/wsAVPL3u1RO8HFLgWiv9F8UaYCiex8xo27yLc/Eim7bvnRtNx6Z1
	ztuUq8pQwJFGbmuARt9vPlsco00NkR8=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260903073242euoutp028273f8b6ecd56cd872bd07708e437933~RvzVL078Z1675416754euoutp02g;
	Thu,  3 Sep 2026 07:32:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260903073242euoutp028273f8b6ecd56cd872bd07708e437933~RvzVL078Z1675416754euoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788420762;
	bh=+wHQNtUzqWMJSc1lx6xZnDlVX8u6lqdGivmRj3Xx4g8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Be3mug4nDx3cwq9l0zEJz6bxShgUmWFhNerr8aSB3+JpOhp9ELT8C2JQyOj6fiw4U
	 63hQQKr92t6934Lz4jr0aWYWf9gs/krroQ4w+aFShXYrTDqv0AAefQ0qxhBjgLrOnp
	 2H+8ACOP+2hdFtmyQM7P43B6v62oHP8TSEfYlJfI=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260903073242eucas1p1bf766543283c23d9923ef581b9056525~RvzU88Ke02312023120eucas1p1b;
	Thu,  3 Sep 2026 07:32:42 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260903073239eusmtip2a4493b60653a6ab9ea0e63ade61f9b93~RvzSMWeKp1596215962eusmtip2K;
	Thu,  3 Sep 2026 07:32:39 +0000 (GMT)
Message-ID: <2d0d36ba-db8f-454b-a90b-8eea69e97452@samsung.com>
Date: Thu, 3 Sep 2026 09:32:38 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v6 08/10] of: reserved_mem: mark /reserved-memory
 entries with MEMBLOCK_NODUMP
To: Wandun Chen <chenwandun1@gmail.com>, catalin.marinas@arm.com,
	will@kernel.org, chenhuacai@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org, baoquan.he@linux.dev,
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org
Cc: mark.rutland@arm.com, kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260902073116.802752-9-chenwandun1@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260903073242eucas1p1bf766543283c23d9923ef581b9056525
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260902073459eucas1p282f20730a9f6dce75cf5a406714b8ed0
X-EPHeader: CA
X-CMS-RootMailID: 20260902073459eucas1p282f20730a9f6dce75cf5a406714b8ed0
References: <20260902073116.802752-1-chenwandun1@gmail.com>
	<CGME20260902073459eucas1p282f20730a9f6dce75cf5a406714b8ed0@eucas1p2.samsung.com>
	<20260902073116.802752-9-chenwandun1@gmail.com>
X-Rspam-User: 
X-Stat-Signature: jpf8jgiu1fjrw51dhnb9say4hcpgkdhm
X-Rspamd-Queue-Id: D9A3C140007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788420764-71075
X-HE-Meta: U2FsdGVkX1+4IOHn4MAiexseWF3MrbpDKhIUIq6NGpUWlRBB7DGB7wDY19z058yiNtZwY5vET1DHKui4V37BHtQX0246+zjVPbGVvpQ3h0q4m+GPF8mejckaIopBkXo08qCOkljPl7/ckQdXPbGe3MqD43BLBqfPrmbpGoYLT9jYinybPPCN91cbOHYnpW11uSaeS8oTLga9ubxseyfsec3MBRukup/SV3TD4XgN/RKCw1gDqP0qIPuUc9AsSQHm11tH28IKKDvA+QNrgbGAFJKuxIZvZbp52vPOB2A4GZ3DSTSqojOsG9eW9vAn1dib1ghYDmqYvEZO8kUENSBufC9ZFg6UDJuMUvXepD17CP9FWVKGfvRC3f8RJQB1Hs/Y79GjmTg+lyaLDHZxuaV2ZF4417Rbr0j02ALrYFDuW3moT7HA8CfHmixPNC8yFrZFMpwj/Lze4AEXeO9qTA3RnE/OkdzOPgnmx6+mAnkS/E5aK5ygb3NXJgduPCWKnJZsqnTNADC9bwN56vxaOnogQWQy7M5I/dV1kfZUfVNVNo/J9/e11jWpDhaPLPPB/rDX3MveenbyPvwgPFaPq+wgi2mg8gH0c4so+W4KxydG3zBho/2EZ1ND70aNX9f/OuwlIAsqqpYFxa/1lludjqVVQOWmDtcSA2vnZ7xH1fIcSU/Vs8CJjUB3rFGl/x/RlA0t5J+5r5Y7f5GWxl+anARMIrIubs9Zzptbwq430htCIYHEkmfmNRfPLH8hZODScZL6/BKWuoZ+DwToxtqcdH6HkrtdWUMErtz+FoYyN6ZlsF+OVILXlHiGqdeOP5yk8oMiIqIYYhFHZMJLbaci/dAP04TBZv1YPQ+nZ7tdzL142eHvyAODKHuoWBJU7XAj/Sttc81FT6WfxE00cFpGyXlFD/fWm//uWtu0SrnmfNXveHe21a/TV3op7gxrF45K/J838M5TgvFL9QvrayIM/5u
 Jjz00p/g
 fCL4DvnYA75JKNGs0KpTf1NA6HoJPD9K/27AktmV+T+rKqkNXQYQfufQIeXojwOK2d/DA9VbEKeERik5gR3nSZCaSdUI+NA5krTgmkfVE7HecdPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.2026 09:31, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> Mark non-dumpable reserved-memory regions with MEMBLOCK_NODUMP so
> kdump can omit them from the vmcore.
>
> The marking is guarded by CONFIG_CRASH_DUMP so non-kdump kernels do not
> pay the cost of splitting memblock.memory entries at NODUMP boundaries.
>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/of/fdt.c             |  1 +
>  drivers/of/of_private.h      |  1 +
>  drivers/of/of_reserved_mem.c | 15 +++++++++++++++
>  3 files changed, 17 insertions(+)
>
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index a64afc3ded3d..286fd4db6312 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -1285,6 +1285,7 @@ void __init unflatten_device_tree(void)
>  
>  	/* Save the statically-placed regions in the reserved_mem array */
>  	fdt_scan_reserved_mem_late();
> +	fdt_mark_reserve_mem_nodump();
>  
>  	/* Populate an empty root node when bootloader doesn't provide one */
>  	if (!fdt) {
> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
> index 0ae16da066e2..505735732c13 100644
> --- a/drivers/of/of_private.h
> +++ b/drivers/of/of_private.h
> @@ -187,6 +187,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
>  
>  int fdt_scan_reserved_mem(void);
>  void __init fdt_scan_reserved_mem_late(void);
> +void __init fdt_mark_reserve_mem_nodump(void);
>  
>  bool of_fdt_device_is_available(const void *blob, unsigned long node);
>  
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index 8c9d6395d6a3..f29a07e8fb23 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -677,6 +677,21 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
>  	reserved_mem_count++;
>  }
>  
> +void __init fdt_mark_reserve_mem_nodump(void)
> +{
> +	struct reserved_mem *rmem;
> +	int i;
> +
> +	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
> +		return;
> +
> +	for (i = 0; i < reserved_mem_count; i++) {
> +		rmem = &reserved_mem[i];
> +		if (rmem->size && !rmem->dumpable)
> +			memblock_mark_nodump(rmem->base, rmem->size);
> +	}
> +}
> +
>  struct rmem_assigned_device {
>  	struct device *dev;
>  	struct reserved_mem *rmem;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


