Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B495CC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68146B0092; Fri, 18 Sep 2026 04:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19F56B0093; Fri, 18 Sep 2026 04:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2426B0098; Fri, 18 Sep 2026 04:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1206B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:04:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 019861605C6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:04:44 +0000 (UTC)
X-FDA: 85226146530.28.5F0DC10
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7003840008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:04:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GM3c5Eao;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qk5GBb8q71h0OTX0FejewQwnd8QBnXRYigWqP30wroM=;
	b=8hmhUTvhzSE2Colmh6kVwiLtQhvEwH3BzZ9rruuhaNZPeC421sOZ5LKFaf5GYcuOZ5snBk
	MNd1l2jsREKdJVeCbQwFqCV5IZ7rL2Fyu1o/0OMwKQrbLLDHPYHnjVzmGGqwS1AX8CBp+G
	tjjgUqlYqwayIE6uuW6KNxDl0InSUiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718683;
	b=RsFrAMSl6DrBzAc2TfJShVYL4BlS+22JLMurI1xuT0e/ewjifEq8X6ug9ZtWwvWQl3K45Y
	gIKte4/gcQpi5cLrjY9+P3RuPo16bHFXJ9rWNub1V1VcanvCAzs+IpcV351ZuN2sr9YbAS
	zj8uhw0XZPZ+liVpwDvLgTKezmXJGs0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GM3c5Eao;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.138 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aMbcna5jLWNAqx3Ry2+7V7gyF2U3dGtOqExnDesb2fI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789718677; v=1; x=1790323477;
 b=GM3c5EaoyflUF7CWwtfTtu5IXbmYDA4S9MecRd3maV8jL/5eBAPLJhtz+IIeC27Bg8YeXroG
 sGJ10OP8XciAgkKoXHv3C/Q9rbV6R0sQRw623xarvpsk0LTGkyrGtTbGwOkNou2kuzaoTXZarC3
 ePWlB0u1vXPB9v/SPwZ13Bfk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e28637c2a9188785;
	Fri, 18 Sep 2026 08:04:36 +0000
X-Mizu-Trace-ID: e28637c2a9188785
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 16:04:33 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, robh@kernel.org,
	saravanak@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
	alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev,
	robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: Re: [PATCH v6 05/10] crash_core: replace for_each_mem_range() with
 for_each_mem_region()
Message-ID: <aqzwkVldaBWcMojx@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-6-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-6-chenwandun1@gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: u98d1j5y4eae6tkyhu8pwo8qqjd6qjb3
X-Rspamd-Queue-Id: 7003840008
X-HE-Tag: 1789718680-416328
X-HE-Meta: U2FsdGVkX183kaZu5i8MYQZ6R7R1d5N+u+ewDT4PjApad+scpL6D9etQpBFQ4QDtLE9/legr/O8eKDYKXnE1mmx5YOaXy72u6X66+whPDPYjHaOV97zK1JiYytTSRw6zLq0Sxp1YvQW2guYylIvFnMmsfceT+1ScwgPuV5twj5wFp7/sge51QLzXvWgdnCtczfhEJCu8qcRjfCLb40388pe98sIcLj1bnqWp8Ugr4mJN5IpUUCBrrDoVagFKLhyGiOECy6fkZ1cZ2JpxkDrAS7xsPcidPvR3yl57NA3iXd2G8FZcavMlQKNrXKs1oicQWgLIDVIXaFfw/zB7+jKAP51+YCtWifOkoDprs/xT4Poy4H6gBGZJ2BZLlahWAxUcpupNfP22cLVHI3cVmxuFPpzLigrrT9XvSPyJO1SocQBPnq+9J5z+2iLYLeLRuJFCqxZPgWxhAMoLVFWXK6QUU4FH9a1eUSM0u3wqE6S2C95XoqR1TxIFERHis+KCnIAB/vyyLTIDe84ADkaOhlod7t6/ua/AP543SrEAGbOv8NuJCtL/kvy86EIyQ/O1w91HSVY/kOujek2pg48S1IM0hdV9NbLk50B6LbOd1dbo4X2gqj2qSEcI1Pf1ZtaTE0u6SPlSCunfOh202RmfGYMVbjOnbZ89zw5/LWUIf/UL7ejZc4Hl8UTsGKXyBuMAhh24d9t2idmzQoc7+FwKJY0se2fJGHQzq0rEH8LhTGztAvUIQMbFDJfL8X3oyAlb8eQhnhoxkI/mKtE+NVMwnKRJFgDgxV0SSsGGGMacmxoZIobNCkdjJbUWqd1DISYn6dkMgoDfbTL1DG/asGw9+yK/3n7EmIXcbbf12U6vEjdt1HNF2QQlg3ZTWHD0GeSQraeass14e4zQAEaK3YYvOBCv+UsVe5RhR/aL5eqrTM0NEboglSv+21pToPokgl1R/Zal0T4LeLFOr7hCRU22OFl
 dfbaumKy
 UqEEvkEmBLRUDWj1MRtFrzT8N8MrSoI+eud3iHR+NQpKeFWq9pfysAVxSvyuVgAhaxHthHuMx06rKmjYbTHlN5VjPWc+fuWRWqqeB0vijNOEgwH+RWmViejAzUAhEuiMIYpLB0EArbPxYNFaGL+c41PEPQD5KRjCzRe8TTCEZ9K5ztPyhXzPUdbIMEemNzr3G3xCmu07swTBRIGe9qjvZVe5bDm8qqNvI57wmG+QuX9gHW70uNndvXQgaUrWu/UHc50P4eWeqDCpQTnPi1caO5u7C4qOEah3SFFI5xGZeRSbmixec7Nf5xQ1usxkcYbsor4K9eu6Ot34SpPn+L7qQYhM3167eGmmLMQEHq0tllUf0mks1Low+6ys83wlw9Vr1IxZd73Nccs+tqh6kGG8FsP6p58rGtr9V2mNl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 03:31pm, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
> weak defaults to for_each_mem_region(), which exposes struct
> memblock_region and per-region flags, and filter NOMAP regions explicitly
> via the new crash_should_skip_region() helper. This prepares for a
> subsequent patch to extend the skip filter.
> 
> No functional change.
> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> ---
>  kernel/crash_core.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)

Acked-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 3adee1ae120c..bd64cf585795 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -270,6 +270,12 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
>  	return 0;
>  }
>  
> +/* Exclude NOMAP regions from the vmcore. */
> +static bool crash_should_skip_region(struct memblock_region *reg)
> +{
> +	return memblock_is_nomap(reg);
> +}
> +
>  static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
>  {
>  	struct crash_mem *cmem;
> @@ -285,22 +291,25 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
>  unsigned int __weak arch_get_system_nr_ranges(void)
>  {
>  	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
> -	phys_addr_t start, end;
> -	u64 i;
> +	struct memblock_region *reg;
>  
> -	for_each_mem_range(i, &start, &end)
> +	for_each_mem_region(reg) {
> +		if (crash_should_skip_region(reg))
> +			continue;
>  		nr_ranges++;
> +	}
>  	return nr_ranges;
>  }
>  
>  int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
>  {
> -	phys_addr_t start, end;
> -	u64 i;
> +	struct memblock_region *reg;
>  
> -	for_each_mem_range(i, &start, &end) {
> -		cmem->ranges[cmem->nr_ranges].start = start;
> -		cmem->ranges[cmem->nr_ranges].end = end - 1;
> +	for_each_mem_region(reg) {
> +		if (crash_should_skip_region(reg))
> +			continue;
> +		cmem->ranges[cmem->nr_ranges].start = reg->base;
> +		cmem->ranges[cmem->nr_ranges].end = reg->base + reg->size - 1;
>  		cmem->nr_ranges++;
>  	}
>  	return 0;
> -- 
> 2.43.0
> 

