Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA392C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5CCB6B00E2; Thu,  3 Sep 2026 03:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D2E6B00E4; Thu,  3 Sep 2026 03:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC8D6B00E5; Thu,  3 Sep 2026 03:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 845AD6B00E2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:33:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2520FA4341
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:33:04 +0000 (UTC)
X-FDA: 85171634688.09.BD4D81B
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id C9A6E1A0006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:33:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=bQV1zXZ4;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788420782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Rh82UpIZQ7NIonfNGs8YTQqWSqGT+MHCSLTl6BXJFs=;
	b=P+nRinWLFHc+8YPU6QzUzfBJGEDFhP8kW6R04dhegMvrmabttEStBQVi23K+ynk3Q0Py5U
	yl0Zzw8+X/Ymn38kQFOgIETaE26KqWahMKpAicBEfopOnWpjoqMEg0zTaN8Bv5iy2XnSxe
	uCDCHJRJea60QsFcvcn8LVEgoqpojRI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788420782;
	b=gktWICSV7D8Ak5B0A9n9XENHSkFnU9iUHeMalX0n6dRxpFNf5GjOjKUZ8O5C6YphxJSQsk
	2Z7FED5+PBL/i8J0iBeQj/rWFOxbhdrUH+VtL0sQa6rcI6zGLKot6lhJSCz/5DwJYycxrv
	QsVJKsdcadtXmeskoys67oX3kaNr5IA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=bQV1zXZ4;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260903073300euoutp01f932cc3b5b8312ed22b276d0d0ac5943~RvzldRbJd3111131111euoutp01L;
	Thu,  3 Sep 2026 07:33:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260903073300euoutp01f932cc3b5b8312ed22b276d0d0ac5943~RvzldRbJd3111131111euoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788420780;
	bh=4Rh82UpIZQ7NIonfNGs8YTQqWSqGT+MHCSLTl6BXJFs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=bQV1zXZ4+kSUiD1UtpA8m7+DEFdp3b+UJT/x0X50HERkYva4J2b8M/D3zL6qOxYy5
	 6lfDF3e+/r2d8teE3hZUKOHqLhKuqFmsKNY1MOeHj8gIqcQh65i9ERtw7Ct1LVadGN
	 is0YSAfIOwuPbjiTdffjbCDzJGY3smVOZSHQSVyY=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260903073259eucas1p1129fec57788d227a159662ed4bbd4068~Rvzk9e9k82315423154eucas1p1i;
	Thu,  3 Sep 2026 07:32:59 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260903073256eusmtip1b94b6b13230ed6f62847ad6ac2a1cf65~RvzhrjUza3241332413eusmtip1J;
	Thu,  3 Sep 2026 07:32:56 +0000 (GMT)
Message-ID: <859ff0c6-6c3f-47c1-95f5-0428d06f0b87@samsung.com>
Date: Thu, 3 Sep 2026 09:32:55 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v6 09/10] of: reserved_mem: mark /memreserve/ entries as
 MEMBLOCK_NODUMP
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
In-Reply-To: <20260902073116.802752-10-chenwandun1@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260903073259eucas1p1129fec57788d227a159662ed4bbd4068
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260902073334eucas1p1b0e997e1f1c9752bc9f48229d7922443
X-EPHeader: CA
X-CMS-RootMailID: 20260902073334eucas1p1b0e997e1f1c9752bc9f48229d7922443
References: <20260902073116.802752-1-chenwandun1@gmail.com>
	<CGME20260902073334eucas1p1b0e997e1f1c9752bc9f48229d7922443@eucas1p1.samsung.com>
	<20260902073116.802752-10-chenwandun1@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9A6E1A0006
X-Stat-Signature: t1peo6hbksutft8omqwtz3wwp379zesy
X-HE-Tag: 1788420781-728981
X-HE-Meta: U2FsdGVkX1811pzUbW9AroSKa1bYazgwSyhkV5diY5EfPja1Qx8dSRj+ZxVFM9+4chiYOwQVgmVOtUrhQyD8QX0DG+Kec5tvZ08PWPEnlQR0MrKPtF2q7KoMCh0SfTX206xqljFsTPq+6iWE+8Ek7akPbXeAaTiLfWgPP9r2mtD8TpmMMD/VQa+HWTFT2xejoGQ7tee+TLCQAcypbZPi5VkoIUgd97f95eFUg9OHqaL9O02apSS8gpqZNkERzP03EBclQB6H6B83oLga22gMND/2Tmq4ty1VMEF0jzDB8Qw7wDzqIVSv8p2tt/BKnXTgc96XnMqDcAqZM3yL3HK5Ch3U/CNIy6clAvBSQk1R76fgVZ0JaMoYd1PlE5MNfyAZcmmb/jMXAuba5tXU+aAbfuxSi424trSMZO53cyEsP8dAHz88rrWdoYniLNvJMcorINgn1ruMPVAJ3Lrxguxkk/5+XuwNg8l/tIs9O7lY/0qOij6QuvMD0eERZAI+m2mTT2+aqsFZWS8/rdzvMN7w9FI0EhJO/fHyxafhAs6bFJJ05SKGo8twpVSTkn9nJUlb2bhcstJodedmqvyVdZjIL8RNN6CRqdCCmegMAtuc1mRZ0TeS7EBYrqVM2L4KXS4s1i151dAxosOZ/bnFKCXLQcoGcZZucEvu4SnaEu+/KNqe7/BVv9sCpyg5XxMHLIBe1hP4PWuYQL9IOw4CczHE9f1axjAcdpE52ubVqCzPFzCYI2F+qPi7xtEEhMTphshZplceMWwIpJnEGCZ3b3ABdC9KpH1AmdpYjLHJmkrajzMXITQG4bU5SiiILprno8iCc5uSG8uGP2J18mbl8oKISHhYiOEWGOzOgB7B+QjGPZqhIVnIARb5zyq+JKPnSNJXbPGWHXth2CodoDKR17VEE22p0t78trr6mi8k/kuLel0H6dLCC06N0Pwy+1ZpXsFPlUzDAQGvPtLM63mA/jI
 f3vFZna5
 BYQ9g20I8khhkefwM9xGMfGaqNEzpyyxa0J6ytq8KkSBsI2xTmppSxqvA2kALdANdwyntbAGdhJOBAbeASnFPLCSFGyz00HB+iKiZmxF32oZF54U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.2026 09:31, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> The /memreserve/ entries are memory reservations made by the bootloader
> or firmware, their contents are not needed for kernel crash analysis,
> so mark them MEMBLOCK_NODUMP to have kdump omit them from the vmcore.
>
> Entries that overlap a dumpable region (such as CMA) are left unmarked,
> because the pages of a dumpable region may carry crash-relevant data.
>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/of/fdt.c             |  1 +
>  drivers/of/of_private.h      |  1 +
>  drivers/of/of_reserved_mem.c | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+)
>
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 286fd4db6312..9a727941b5af 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -1286,6 +1286,7 @@ void __init unflatten_device_tree(void)
>  	/* Save the statically-placed regions in the reserved_mem array */
>  	fdt_scan_reserved_mem_late();
>  	fdt_mark_reserve_mem_nodump();
> +	fdt_mark_memreserve_nodump();
>  
>  	/* Populate an empty root node when bootloader doesn't provide one */
>  	if (!fdt) {
> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
> index 505735732c13..6497404ec751 100644
> --- a/drivers/of/of_private.h
> +++ b/drivers/of/of_private.h
> @@ -188,6 +188,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
>  int fdt_scan_reserved_mem(void);
>  void __init fdt_scan_reserved_mem_late(void);
>  void __init fdt_mark_reserve_mem_nodump(void);
> +void __init fdt_mark_memreserve_nodump(void);
>  
>  bool of_fdt_device_is_available(const void *blob, unsigned long node);
>  
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index f29a07e8fb23..a42cf6eac55b 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -251,6 +251,39 @@ static void __init __rmem_check_for_overlap(void)
>  	}
>  }
>  
> +void __init fdt_mark_memreserve_nodump(void)
> +{
> +	u64 base, size;
> +	int n;
> +	const void *fdt = initial_boot_params;
> +
> +	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
> +		return;
> +
> +	if (!fdt)
> +		return;
> +
> +	for (n = 0; ; n++) {
> +		int i;
> +
> +		if (fdt_get_mem_rsv(fdt, n, &base, &size))
> +			break;
> +		if (!size)
> +			break;
> +
> +		for (i = 0; i < reserved_mem_count; i++) {
> +			struct reserved_mem *rmem = &reserved_mem[i];
> +
> +			if (rmem->dumpable &&
> +			    base < (u64)rmem->base + (u64)rmem->size &&
> +			    (u64)rmem->base < base + size)
> +				break;
> +		}
> +		if (i == reserved_mem_count)
> +			memblock_mark_nodump(base, size);
> +	}
> +}
> +
>  /**
>   * fdt_scan_reserved_mem_late() - Scan FDT and initialize remaining reserved
>   * memory regions.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


