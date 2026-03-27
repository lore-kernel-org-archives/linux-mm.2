Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A649C10A88E5
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49F56B0092; Fri, 27 Mar 2026 10:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21156B0095; Fri, 27 Mar 2026 10:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37216B0096; Fri, 27 Mar 2026 10:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A2B846B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:09:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42D21161199
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:09:20 +0000 (UTC)
X-FDA: 84592025280.24.8F6F96D
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 61B52120013
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:09:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=IEtwusiy;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf29.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774620557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FllaRuqz/ndrQdv/IFjTF2PMiXOCm/8g8JGqiCXRtZ8=;
	b=maMXBt6oRHwGfbAyWyt0j9qFED4YSzw1NUV9PtFagx3z9F6JdeKsiBvoObguN8M+OwBOVv
	Uxd60TB4QFiSk6PNhbpB3iwWG0+OEgF7mLnLxdg9JZ+DAzxvLsrumhr5OeZ4cOmBFWX8R4
	P5+11/h6BRyaN8axiVRRAF5slm0Qpa8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774620557; a=rsa-sha256;
	cv=none;
	b=fdUNlvp4wG+iYHNzFdKz7jHuJnVLs8JpIGGPpcPxYw0Za0xK2EPIwUdp4wyuTeqsePIwq+
	hCzy74OccqfthtOMHtmggYDm/Guqnf7sQh15IY9bam4dy5HrRNqlR2hIGj/zIWxXJh+V4F
	S1z6cuQcBv4AoKCww6R/RCEf78NUyLA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=IEtwusiy;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf29.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260327140914euoutp01e76e201c9d1970e5dc3f3dc61c49ef44~gt-4Du4fC2064320643euoutp01M
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:09:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260327140914euoutp01e76e201c9d1970e5dc3f3dc61c49ef44~gt-4Du4fC2064320643euoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774620554;
	bh=FllaRuqz/ndrQdv/IFjTF2PMiXOCm/8g8JGqiCXRtZ8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=IEtwusiyymGgXTgefN5F2+tP3oGnBaysfmc5wcK8nupPsfZqjORP7h7wCyeegICe9
	 lxu1CtjuM/x3dsuNHEsfeRVcwk6iBQtdRUwKy5JNgDFiBPeccnY9nyx+ifDhLdzJgq
	 KCEhEkk/1Pqg1xKElvtpyCRYF77aefPTpmANE3Ok=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260327140914eucas1p19677ff7152b3f9bb8751546cf127d41b~gt-3sPh0s3007330073eucas1p1M;
	Fri, 27 Mar 2026 14:09:14 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260327140913eusmtip18997f7f0a8f811699c2317b9909b495b~gt-2n1yFW1792317923eusmtip1e;
	Fri, 27 Mar 2026 14:09:13 +0000 (GMT)
Message-ID: <d2ed7315-72ff-43f3-bfaa-995025cb9419@samsung.com>
Date: Fri, 27 Mar 2026 15:09:12 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
To: Catalin Marinas <catalin.marinas@arm.com>, Mikhail Gavrilov
	<mikhail.v.gavrilov@gmail.com>
Cc: vbabka@kernel.org, harry.yoo@oracle.com, akpm@linux-foundation.org,
	hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu, linux@roeck-us.net,
	andy.shevchenko@gmail.com, hch@lst.de, Jeff.kirsher@gmail.com, Robin Murphy
	<robin.murphy@arm.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <acZ3ZUXhFHpSXzYS@arm.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260327140914eucas1p19677ff7152b3f9bb8751546cf127d41b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39
X-EPHeader: CA
X-CMS-RootMailID: 20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
	<CGME20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39@eucas1p1.samsung.com>
	<acZ3ZUXhFHpSXzYS@arm.com>
X-Rspamd-Queue-Id: 61B52120013
X-Stat-Signature: cwmztwstnj9futyczrzu83wk6xjstfup
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774620557-924669
X-HE-Meta: U2FsdGVkX1/luYfFLAW9KCJVkgCKb6M3SLDjK0RYOziL2A3/UOERjGN9Wr6Qgo6+FLyHhbQRqUT+Zv6GHiF/GEv7bMWnU6Q/1DfO0Yb2IOe8f26hEd8HNnr8Phz9/GvZLVj3bIYl6OIOQ+WNvSBfIOHQbc96Xkwv7GnWJ64SqT410V0ooF3Y5TNts9GOgLJhMdE9ZOUztSVXKTWy2NVIDJjetwQP+VUA76JY5S/D1XV68ozIZeqjbwxLJK4UGZhSfdotNO+daCrbQ760ZsmWChAHsoXvCyo8AIhvjzaRk6NvQMklNBZguIZbUjG4ktmbHNF6NDA2H3Ud/XlxT8yH2K/fvnUe5LQlf8zcZwkIpZmp6K5st22UM5SFGN84SXN5Tv1prIrxew1eYIiImatqLlhWIBU4lIeQ5JLkxOXdtbPkp2ihzgMcgQXpu7gKj0bjSXVGBnXTCNokj3ERM0ZFNaLCd8DkzNBM81vqMTsY5ECyD2ehgCIb2k5PtJZhmc0wQYmy659vUPoJDG6FRGT6SHdy6B2mrl5poSyG3pjHApZpXLRh6p+KVyGUfNeT8Nn4lE2g7mexubzCYtnOiCz3IsM0Wjieq9FmbSBx2btRUhNUUFMjt5OXkj0OrTSmwH2d7Tfs4M7eFtIE+QMGjIx/9Glo7ktKjFsfmqqyKsqL/IGKIQgUMymC8Q9JTBiObSsW24RJI7zqiPC79G8Hb5OcKEzKABy82VWGw902KFaFk1lPb6WPh4r9OR860JwTn4CzWfFCUbBxcteSXXkaA/ZGCt3K+QgSP4ZgfnGtrANIoESAgN0SQV463WorDvPxXSrvACUmnYivgCSTQ++ZDdAm3T6LTBpZ2hjjwy41kGQTxsYCaqyGshB87/0ZGX3uYCLUC9Zx/HZy1O45fQZ3BSxbQ0JBhvdBNmzl6EDfTpS/++r1EeZk0pgC9dPQtiBpo/K2hbk7L6sCTyurYSceYUy
 1GeQkpAX
 0oc9uxXAXppSSrgxGTIEfZJ0UBdFR6mpBB2/T0/Xr+DR5951xae8HvU2TQHlgbOLSoTjvEJFiFkXXsYtnpM6+vF9zYYNyHmWfDJ1A1kjR/zuQYY8h0XmH79ywMrRnUp5uJTExNBio4Az1Bd9IcpVqrb7TOddnmL+93hBzZijQtHDk9PVIisnEoAco66qVOOn/SCmK6fee2sabWR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 27.03.2026 13:26, Catalin Marinas wrote:
> + Marek, Robin

Thanks for adding me to the loop.

> On Fri, Mar 27, 2026 at 10:58:46AM +0500, Mikhail Gavrilov wrote:
>> When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
>> tracks active mappings per cacheline and warns if two different DMA
>> mappings share the same cacheline ("cacheline tracking EEXIST,
>> overlapping mappings aren't supported").
>>
>> On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
>> allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
>> hub driver) frequently land in the same 64-byte cacheline.  When both
>> are DMA-mapped, this triggers a false positive warning.
>>
>> This has been reported repeatedly since v5.14 (when the EEXIST check
>> was added) across various USB host controllers and devices including
>> xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.
> This indeed has come up regularly in the past years.
>
>> +/*
>> + * Align memory allocations to cache lines if DMA API debugging is active
>> + * to avoid false positive DMA overlapping error messages.
>> + */
>> +#ifdef CONFIG_DMA_API_DEBUG
>> +#ifndef ARCH_KMALLOC_MINALIGN
>> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
>> +#elif ARCH_KMALLOC_MINALIGN < L1_CACHE_BYTES
>> +#undef ARCH_KMALLOC_MINALIGN
>> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
>> +#endif
>> +#endif
> TL;DR: I think this is fine:
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>
> I'm not sure that's the best way to hide the warning but there
> are no great solutions either. On one hand, we want the DMA debug to
> capture potential problems on architectures it's not running on. OTOH,
> we also want to avoid false positives on coherent architectures/devices.
> I don't think reconciling the two requirements is easy.
>
> When DMA_API_DEBUG is enabled, the above will change the x86 behaviour
> that could have implications beyond DMA (e.g. may not catch some buffer
> overflow because it's within L1_CACHE_BYTES). Similarly for non-coherent
> architectures that select DMA_BOUNCE_UNALIGNED_KMALLOC (arm64 and riscv
> currently). arm64 defines ARCH_DMA_MINALIGN to 128 but
> ARCH_KMALLOC_MINALIGN to 8 (why 128 is larger than L1_CACHE_BYTES is
> another matter but let's ignore it for now).

IMHO enabling DMA_API_DEBUG should not change the kernel behavior, so I 
would prefer fixing this in DMA-debug code somehow.

> More of a thinking out loud, we have:
>
> 1. Coherent architectures - alignment doesn't matter
>
> 2. Non-coherent architectures with:
>     a) Sufficiently large ARCH_KMALLOC_MINALIGN
>     b) Small ARCH_KMALLOC_MINALIGN but DMA_BOUNCE_UNALIGNED_KMALLOC
>     c) Broken config - forgot to set ARCH_DMA_MINALIGN or bouncing
>
> We can ignore (2.c), the aim of the DMA debug is to catch wrong uses in
> drivers. If drivers is the only goal, the above change will do when
> running on (1) or (2.a) hardware - it will catch sub-L1_CACHE_BYTES
> buffers from drivers while assuming kmalloc() machinery is safe.
> However, if running on (2.b) it won't catch anything that may be
> problematic on (2.a) since the DMA debug ignores the overlap.
>
> We could make DMA_BOUNCE_UNALIGNED_KMALLOC dependent on !DMA_API_DEBUG
> but it would be nice to be able to sanity-check the bouncing logic.
> Well, it wasn't checking it before and with commit 03521c892bb8
> ("dma-debug: don't report false positives with
> DMA_BOUNCE_UNALIGNED_KMALLOC"), we made this clear that overlapping will
> be ignored.
>
> Irrespective of whether we disable bouncing with DMA_API_DEBUG, maybe we
> could replace the above commit with:
>
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 3928a509c44c..488045ef6245 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -175,7 +175,7 @@ dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
>   	if (!is_mmio)
>   		kmsan_handle_dma(phys, size, dir);
>   	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
> -	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
> +	debug_dma_map_phys(dev, dma_to_phys(addr), size, dir, addr, attrs);
>
>   	return addr;
>   }
>
> Anyway, this I think is unrelated to the proposed change affecting x86,
> more of a how to make the DMA API debugging more useful when running on
> arm64 or riscv.

This is not enough, there is also a dma_map_sg_attrs() path.

I've reverted 03521c892bb8 and added the following change:

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c index 
55e7ca8ceb86..bbada41143ea 100644 --- a/kernel/dma/debug.c +++ 
b/kernel/dma/debug.c @@ -18,6 +18,7 @@ #include <linux/uaccess.h> 
#include <linux/export.h> #include <linux/device.h> +#include 
<linux/dma-direct.h> #include <linux/types.h> #include <linux/sched.h> 
#include <linux/ctype.h> @@ -1241,7 +1242,8 @@ void 
debug_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size, 
entry->dev = dev; entry->type = dma_debug_phy; - entry->paddr = phys; + 
entry->paddr = IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) ? + 
dma_to_phys(dev, dma_addr) : phys; entry->dev_addr = dma_addr; 
entry->size = size; entry->direction = direction; @@ -1335,7 +1337,9 @@ 
void debug_dma_map_sg(struct device *dev, struct scatterlist *sg, 
entry->type = dma_debug_sg; entry->dev = dev; - entry->paddr = 
sg_phys(s); + entry->paddr = + 
IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) ? + dma_to_phys(dev, 
sg_dma_address(s)) : sg_phys(s); entry->size = sg_dma_len(s); 
entry->dev_addr = sg_dma_address(s); entry->direction = direction;

thenran my tests on ARM64 and RV64 boards. Only one new warning has been 
reported (I didn't analyze it yet), so this might be indeed a better 
solution than skipping overlapping cache lines warnings when 
DMA_BOUNCE_UNALIGNED_KMALLOC is set.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


