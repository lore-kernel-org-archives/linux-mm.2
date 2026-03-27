Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B9E10ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B246B0095; Fri, 27 Mar 2026 10:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9326F6B0096; Fri, 27 Mar 2026 10:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F396B0098; Fri, 27 Mar 2026 10:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 783666B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:55:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B4021A0FFC
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:55:49 +0000 (UTC)
X-FDA: 84592142418.22.D71073D
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id B322B1C0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:55:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="bnojqI/e";
	spf=pass (imf20.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774623347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REUXe8UYNGwRNwOSyc6qufXzTOCwF72bk0Eo6/3HEGg=;
	b=Njletog+6uEABw/mKtE9i0P716iWzt57f+HBmEOZa1WwCiw1Va5dJPvhhri98iJKQins3h
	mePbOdJC1BcO3BOkc8ez7pYlYvd8uItOVP5qTw3QY8SKkNTH46lEk99AgUKlkKjvXLOAze
	KvrE27bIYXubQUlTkGdzSnFOm0hNSbU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="bnojqI/e";
	spf=pass (imf20.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774623347; a=rsa-sha256;
	cv=none;
	b=cUdcQf5KfWHavdwjC58YSks8fxRozNQmSuPnfvXHBKgzhkJHpN4DOSn7RQGUXNkpFvWmts
	bSUS4pZ2Ogi/ZAD3usc2IPH9Q927nJ9+YizjJK1bEyd+anDYEpywE5mmEK/lnfh8MTmJs3
	DvsZy/1BVURZaTXjEsuwdiMowz/lZVE=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260327145544euoutp01e16521b47734f0353ccc73f8e98b8ba3~guoeCwyAZ0599805998euoutp01f
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:55:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260327145544euoutp01e16521b47734f0353ccc73f8e98b8ba3~guoeCwyAZ0599805998euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774623344;
	bh=REUXe8UYNGwRNwOSyc6qufXzTOCwF72bk0Eo6/3HEGg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bnojqI/epEcuYRMSJKdrOewMzsAS5gYfTSJMyQ1OcYuVh307Kt4WAIJMCGhAImqNf
	 9p2XMXpUpPL2PjUBO+/6m7Z/mP5L2K5Munla/d0RozFaufulx1xdLKXIbwzSwLcrp9
	 /mrRbQDD84OjTjj5u3kdV0CRDd0tt8YcAsqqn1no=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260327145543eucas1p1ff8162bebd6e11976bf7be95ab3a2658~guodnd7MR2635526355eucas1p13;
	Fri, 27 Mar 2026 14:55:43 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260327145541eusmtip1ce5407db7b38952ac949b9394b6c8bdd~guobpmBSi0746707467eusmtip1G;
	Fri, 27 Mar 2026 14:55:41 +0000 (GMT)
Message-ID: <336a20f9-408e-49d1-9d56-60315bd01881@samsung.com>
Date: Fri, 27 Mar 2026 15:55:41 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Mikhail Gavrilov
	<mikhail.v.gavrilov@gmail.com>
Cc: vbabka@kernel.org, harry.yoo@oracle.com, akpm@linux-foundation.org,
	hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu, linux@roeck-us.net,
	andy.shevchenko@gmail.com, hch@lst.de, Jeff.kirsher@gmail.com, Robin Murphy
	<robin.murphy@arm.com>
Content-Language: en-US
In-Reply-To: <d2ed7315-72ff-43f3-bfaa-995025cb9419@samsung.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260327145543eucas1p1ff8162bebd6e11976bf7be95ab3a2658
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39
X-EPHeader: CA
X-CMS-RootMailID: 20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
	<CGME20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39@eucas1p1.samsung.com>
	<acZ3ZUXhFHpSXzYS@arm.com>
	<d2ed7315-72ff-43f3-bfaa-995025cb9419@samsung.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B322B1C0002
X-Stat-Signature: uhximinij49sm7i6kxcg8ymi4xyn88im
X-Rspamd-Server: rspam06
X-HE-Tag: 1774623346-813294
X-HE-Meta: U2FsdGVkX19m5LNQyvTIe+44qVDbMakUl8FUMINs8KG11tOEw6mz4w30nMLMeJ51ihMAUHH70Hz8ahdt60fkFyWXeQCAjQvzOPunpQnDfZ9afICaX2k+1Y1JMZrUkbxhenm+p13B3ASQxaqyCVy66PZ09/MGikMadcPjZDcv2VxVVaXfwwZJgFrxgQTlz9MmaBNf6HAbOFpwgqIT244iBvKClfZOAJWs9c0wroaItBnz8XVpmsLmO+CuXbhSyettoDBi/QLRBDbtFSfNx9jFrJHxyN6t0nmRfowoYwjMzQDEPn/29B0vaKKby7S6gButqogCC0iPK/rU0r8usNFAzO3n/TuJsL2svfeVUbdsrpe552GsyoJe2PKk3dYAJD44m0aC8wpHZTZ7KyqkZLeMF/ukoCu8wRnf0jZ3kcq2VW1JdZ+MH+0D9zwExa5nIHrOQJ4UuE/xP8g+xitjp7TTWQdpbO0GGKoSmikoNyI4WyKA5am5ekv/VfXAaFiorom2ZkrvxB57Im3q4NwK2OfG7uk2ciAY3q9aRaF6m4Ej7gznOVYQqvMXYd/6lEZP3tnYRELNKkQfWIXowtZ8mP583swb3HYWe0BOXnudfiA3Hya8Bg64fVc834STjlpnrdqMdDjEDE0Y06lNF6vDiSCJKaCG4CwEdJjosoPnUxkEqpFxzyn0yXFWAFg8SvfhhdzE97pyz+GhU4gOJCl5J4xsYemOCoDXQRWyJb4ey8XZ7to5fcRulcLnWJkfagyjtcjLcLu+LEbnqbAPpdKoZNHpuKbBTbIHVUkbB05RQr5xVSNaR+59KXp4q1njj9m7HdYrzxeSgT1HpSPovcawfXqLW9sTKvrKX29T+L/SK9Yf9W1X+djoS3lh0mOLQLXzeW47ngSmLeXsDrzN2m+67mbqGis+djUFAXqEhqb11zE6Iw6DGKp9i2i65dlq9q8rV15lkRnjbxr3Tp7GN4+Dllo
 FYe5nJSr
 VPkF0T2QbigjxAPduu9CjfCOyVNxQ6J90EDVaHEwBmg+xk7CPSCRiDSjWguhFzsTbyeBJ6pirykB3UXyQVSfuBb4onjx9POK7Wb/3uaY7Leq5/LiM/BJLM0EJsRTGdex8F8iU/aFOjVzI/xS5hvZ49WLJLYqR5dk8wDQ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.03.2026 15:09, Marek Szyprowski wrote:
> On 27.03.2026 13:26, Catalin Marinas wrote:
>> + Marek, Robin
>
> Thanks for adding me to the loop.
>
>> On Fri, Mar 27, 2026 at 10:58:46AM +0500, Mikhail Gavrilov wrote:
>>> When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
>>> tracks active mappings per cacheline and warns if two different DMA
>>> mappings share the same cacheline ("cacheline tracking EEXIST,
>>> overlapping mappings aren't supported").
>>>
>>> On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
>>> allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
>>> hub driver) frequently land in the same 64-byte cacheline.  When both
>>> are DMA-mapped, this triggers a false positive warning.
>>>
>>> This has been reported repeatedly since v5.14 (when the EEXIST check
>>> was added) across various USB host controllers and devices including
>>> xhci_hcd with USB hubs, USB audio devices, and USB ethernet adapters.
>> This indeed has come up regularly in the past years.
>>
>>> +/*
>>> + * Align memory allocations to cache lines if DMA API debugging is active
>>> + * to avoid false positive DMA overlapping error messages.
>>> + */
>>> +#ifdef CONFIG_DMA_API_DEBUG
>>> +#ifndef ARCH_KMALLOC_MINALIGN
>>> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
>>> +#elif ARCH_KMALLOC_MINALIGN < L1_CACHE_BYTES
>>> +#undef ARCH_KMALLOC_MINALIGN
>>> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
>>> +#endif
>>> +#endif
>> TL;DR: I think this is fine:
>>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>
>> I'm not sure that's the best way to hide the warning but there
>> are no great solutions either. On one hand, we want the DMA debug to
>> capture potential problems on architectures it's not running on. OTOH,
>> we also want to avoid false positives on coherent architectures/devices.
>> I don't think reconciling the two requirements is easy.
>>
>> When DMA_API_DEBUG is enabled, the above will change the x86 behaviour
>> that could have implications beyond DMA (e.g. may not catch some buffer
>> overflow because it's within L1_CACHE_BYTES). Similarly for non-coherent
>> architectures that select DMA_BOUNCE_UNALIGNED_KMALLOC (arm64 and riscv
>> currently). arm64 defines ARCH_DMA_MINALIGN to 128 but
>> ARCH_KMALLOC_MINALIGN to 8 (why 128 is larger than L1_CACHE_BYTES is
>> another matter but let's ignore it for now).
>
> IMHO enabling DMA_API_DEBUG should not change the kernel behavior, so I would prefer fixing this in DMA-debug code somehow.
>
>> More of a thinking out loud, we have:
>>
>> 1. Coherent architectures - alignment doesn't matter
>>
>> 2. Non-coherent architectures with:
>>     a) Sufficiently large ARCH_KMALLOC_MINALIGN
>>     b) Small ARCH_KMALLOC_MINALIGN but DMA_BOUNCE_UNALIGNED_KMALLOC
>>     c) Broken config - forgot to set ARCH_DMA_MINALIGN or bouncing
>>
>> We can ignore (2.c), the aim of the DMA debug is to catch wrong uses in
>> drivers. If drivers is the only goal, the above change will do when
>> running on (1) or (2.a) hardware - it will catch sub-L1_CACHE_BYTES
>> buffers from drivers while assuming kmalloc() machinery is safe.
>> However, if running on (2.b) it won't catch anything that may be
>> problematic on (2.a) since the DMA debug ignores the overlap.
>>
>> We could make DMA_BOUNCE_UNALIGNED_KMALLOC dependent on !DMA_API_DEBUG
>> but it would be nice to be able to sanity-check the bouncing logic.
>> Well, it wasn't checking it before and with commit 03521c892bb8
>> ("dma-debug: don't report false positives with
>> DMA_BOUNCE_UNALIGNED_KMALLOC"), we made this clear that overlapping will
>> be ignored.
>>
>> Irrespective of whether we disable bouncing with DMA_API_DEBUG, maybe we
>> could replace the above commit with:
>>
>> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
>> index 3928a509c44c..488045ef6245 100644
>> --- a/kernel/dma/mapping.c
>> +++ b/kernel/dma/mapping.c
>> @@ -175,7 +175,7 @@ dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
>>       if (!is_mmio)
>>           kmsan_handle_dma(phys, size, dir);
>>       trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
>> -    debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
>> +    debug_dma_map_phys(dev, dma_to_phys(addr), size, dir, addr, attrs);
>>
>>       return addr;
>>   }
>>
>> Anyway, this I think is unrelated to the proposed change affecting x86,
>> more of a how to make the DMA API debugging more useful when running on
>> arm64 or riscv.
>
> This is not enough, there is also a dma_map_sg_attrs() path.
>
> I've reverted 03521c892bb8 and added the following change:
>
> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c index 55e7ca8ceb86..bbada41143ea 100644 --- a/kernel/dma/debug.c +++ b/kernel/dma/debug.c @@ -18,6 +18,7 @@ #include <linux/uaccess.h> #include <linux/export.h> #include <linux/device.h> +#include <linux/dma-direct.h> #include <linux/types.h> #include <linux/sched.h> #include <linux/ctype.h> @@ -1241,7 +1242,8 @@ void debug_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size, entry->dev = dev; entry->type = dma_debug_phy; - entry->paddr = phys; + entry->paddr = IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) ? + dma_to_phys(dev, dma_addr) : phys; entry->dev_addr = dma_addr; entry->size = size; entry->direction = direction; @@ -1335,7 +1337,9 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg, entry->type = dma_debug_sg; entry->dev = dev; - entry->paddr = sg_phys(s); + entry->paddr = + IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) ? + dma_to_phys(dev, sg_dma_address(s)) : sg_phys(s);
> entry->size = sg_dma_len(s); entry->dev_addr = sg_dma_address(s); entry->direction = direction;
>
> thenran my tests on ARM64 and RV64 boards. Only one new warning has been reported (I didn't analyze it yet), so this might be indeed a better solution than skipping overlapping cache lines warnings when DMA_BOUNCE_UNALIGNED_KMALLOC is set.
>
Huh, the diff has been malformed by my mail client. Let's try again:

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 55e7ca8ceb86..bbada41143ea 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -18,6 +18,7 @@
 #include <linux/uaccess.h>
 #include <linux/export.h>
 #include <linux/device.h>
+#include <linux/dma-direct.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/ctype.h>
@@ -1241,7 +1242,8 @@ void debug_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,

        entry->dev       = dev;
        entry->type      = dma_debug_phy;
-       entry->paddr     = phys;
+       entry->paddr     = IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) ?
+                          dma_to_phys(dev, dma_addr) : phys;
        entry->dev_addr  = dma_addr;
        entry->size      = size;
        entry->direction = direction;
@@ -1335,7 +1337,9 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,

                entry->type           = dma_debug_sg;
                entry->dev            = dev;
-               entry->paddr          = sg_phys(s);
+               entry->paddr          =
+                       IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) ?
+                       dma_to_phys(dev, sg_dma_address(s)) : sg_phys(s);
                entry->size           = sg_dma_len(s);
                entry->dev_addr       = sg_dma_address(s);
                entry->direction      = direction;


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


