Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D47F210ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EFE96B00A5; Fri, 27 Mar 2026 10:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C77C6B00A6; Fri, 27 Mar 2026 10:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4049D6B00A7; Fri, 27 Mar 2026 10:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6E36B00A5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:30:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0CE2C712A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:30:51 +0000 (UTC)
X-FDA: 84592079502.30.C54F1E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C563C180004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:30:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIurt8od;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HCYzp5kutbVgV9HRECWFSd4SRWECw0P4fF34zAWj3I=;
	b=5x+d1v/EJQiEehuojaiTPrlUGRhsjOco5Q02XqVgPEt2Ggn+X1aSh3I4Upk0Vj7U8hVpvf
	AkiOZozPCvUIEULv9FAjYvGvnYqY3LiFupm/pQnfZvRprknQ0piPncBJIgWLRvY6xXs7CB
	Qa7K5oiF9606jXuDRgXP5heUv1eqQZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774621850; a=rsa-sha256;
	cv=none;
	b=GAYPNDM/S19ziFOLZUMsPcy4Cf9ShZmX+wYgpUUGBqDUTdi8i8r9NFPbID931l91dWMQXL
	3Jq9SvtHP1qHfWz+T0f9nXs2kaE72yBlt94lTGQMa486zlTtmfUPeE27tPE76Egky1o3Sv
	yWu63PKewN87DbxcM3ctA3XwF8mn0N4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mIurt8od;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4C8F406EE;
	Fri, 27 Mar 2026 14:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501EBC19423;
	Fri, 27 Mar 2026 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621848;
	bh=A3AG32T8PZTrNpV/U9zA1qs90v1zn+nJ4caUsIzeMTo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mIurt8odGENyMqk+aru8b/p2hCFuJlzO4y2pzcHa2jAPpDU3vsr+KOBlXNNq3MHIa
	 qFGjoQKkzkMocHAi6e0YyimGd0aGEMtsjRo0mkRH9+DgzEh+j2HhQTgzhkdhT1DOk8
	 RGl5xrQKvHtVvQTMkVCTnbSk81jlCPOk9aqUZd2Q96aLl3vitS2kYigHWfhGaD66cm
	 ZMBBGXmqeQSKcZJnvOjZBzQ1nfFSOE3WR7EVDkZ6qxkjtw914YgDydXvA/n90whQHP
	 PqkKZJEomam6mN3luXKZadiaWhqyuUGYaR3kLwi5cmvXZTGQB6n8RNYy3AelqoRu3F
	 myD4+DsrqUV9w==
Message-ID: <bfa5ff0a-8ef9-46cb-8881-396f71ed5be0@kernel.org>
Date: Fri, 27 Mar 2026 15:30:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
Content-Language: en-US
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: harry.yoo@oracle.com, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 stern@rowland.harvard.edu, linux@roeck-us.net, andy.shevchenko@gmail.com,
 hch@lst.de, Jeff.kirsher@gmail.com, Robin Murphy <robin.murphy@arm.com>
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
 <CGME20260327122625eucas1p10eabcb31aada4e11b5c2ebcff4cb3c39@eucas1p1.samsung.com>
 <acZ3ZUXhFHpSXzYS@arm.com> <d2ed7315-72ff-43f3-bfaa-995025cb9419@samsung.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <d2ed7315-72ff-43f3-bfaa-995025cb9419@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C563C180004
X-Stat-Signature: bqnqcifs4i7wngbk8abcg3mtffskqqtb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774621849-672409
X-HE-Meta: U2FsdGVkX1+uiTSQ7ljJPYtE409eW9TilcFDupH4gSF0sEySBXcjeglKziQI6QluyXXq89oftSigJSXqYqBuaqqnhLBj7fKFji228smlmaQ8I81edTZ98um9P/z28b3b0E4sOaabkD+aisoHv9dMuP1vzFftG0JesI8UAqrV91pic4ZEbm/d2lniYYEw5LM2HNQcjOJJxjTc9k1Jx0keDZPLOvogPYiML3CoqZ2wbydZAAaXQxoOLwDF8YDV0ew7th/lm8NI/nlCYguvTFrk3sxn/PIXIflhanmOEDD/2oK6nfxEbri10Gfoga9zPzsgS7yanoM0XDY2KpaYXSdzQddn2CUFB4PsSSUBnPTl2jo1JqHwlgyvihmuFVwaIxl4KKP8y3xRNeGjxuFggAOobLUhzFqDl7ApXG26TLU9106wGsPxLqXdOEb1qPtGXl7uyBZF/Z3KNOxi4Oq/MRNxi8oNOnpsTPmyOJ43SilZtuy4N74rrYycsvzFa/fXEruG5nv3NZqWSiHrYjtPYEKGvGbKg8gyci0j10CAv4nn0X57b8c09eXMfznbNq7egDx2z7UZyPMQ0dlClGiHcta/lbzccJp4O2W8S57lsImZvC7UrkfiAbSbGF+K7WLNfeXuEp1xUEcMK1Pitj6Ah9knk90jY6yGnamv5DSE7l+fpT80S8uTUOhfnaSw4iRzq+YDYuEeg20lIBt89X885G3p/bPVLGo7qROPF2baLrp7CQ/X3y72Z8GJ4OCSWjn32Di3RYNC/053OB8Mz8q2xtjYCeQylbeF0t0S1/wsQ1RVsY1ddgiQhXx3NUN/MWJ8mcp+Vfj0PqMcWWbQM4UjKMTvjFfr7EiukPlGDbDJuCwnRBBSG/mNRLRXasoILPko0R19weBz2SxdjLbZe2liQ35jCyNk9jLvs8xPvT9vZyri5C58kkRbVNOj6CQXB0Y7pBbc6up8ojthIv6N//Z2F6O
 SA+7lL7M
 0TNopDsYOX8LZRPoNKvpYgMVKZklHy3AiAbgXUey+Ox1kRAKC4y4DtRoUkJmhGPR7ZfaCQesUB5welhLMihRAmiwFq61krihyYoTD4zTZCe4CpSqDU6hGIpi1X5QdweILpSDW3GOiiqugXdIj8nVgRxagooRgSUhAvQVpqg4WLhODRttAqQ1mZO4MEO4u637FtyUZTT7C35w+ncIezLiBmpfk/nBYL4T/i68WIM1rcUIyMenH9Vzefj33PyjFUixTqVgtcPul/hnjw5WSWcTNMQbvuFbtmN/b2FnQ7jFYdoCmiZZIGBg7v4FVBqnHMr3UQg8ZZF4C9lxeohMhLpFU1HtHUhQ4ldQz2Cx6YRJnwFg3s6ZIaE7EmUQzcVZCitKCcIjFU4gKDl7Fsoje5jTrNUNLbUjWXhRE00BYA42wEJVUrA9BKLt31epj7WPMmkB7UZWB2iAddss0UcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 15:09, Marek Szyprowski wrote:
> Hi
> 
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
>>> hub driver) frequently land in the same 64-byte cacheline.  When both
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
>>> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
>>> +#elif ARCH_KMALLOC_MINALIGN < L1_CACHE_BYTES
>>> +#undef ARCH_KMALLOC_MINALIGN
>>> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
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
> IMHO enabling DMA_API_DEBUG should not change the kernel behavior, so I 
> would prefer fixing this in DMA-debug code somehow.

So what about Harry's proposal [1]? Mikhail seems to be on board? [2]

It seems it would achieve the goal that enabling DMA_API_DEBUG doesn't
change the kernel behavior? But I don't know this area too well so
maybe there's a catch.

[1] https://lore.kernel.org/all/acYlxRBhSMcwBnja@hyeyoo/
[2] https://lore.kernel.org/all/CABXGCsO_C8%2B%2B4%2BoPfZ%2BbQyrBnEGy5JFpXHkGNpfy%2B8%3D5BvVNfg@mail.gmail.com/

> 
>> More of a thinking out loud, we have:
>>
>> 1. Coherent architectures - alignment doesn't matter
>>
>> 2. Non-coherent architectures with:
>>     a) Sufficiently large ARCH_KMALLOC_MINALIGN
>>     b) Small ARCH_KMALLOC_MINALIGN but DMA_BOUNCE_UNALIGNED_KMALLOC
>>     c) Broken config - forgot to set ARCH_DMA_MINALIGN or bouncing
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
>>   	if (!is_mmio)
>>   		kmsan_handle_dma(phys, size, dir);
>>   	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
>> -	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
>> +	debug_dma_map_phys(dev, dma_to_phys(addr), size, dir, addr, attrs);
>>
>>   	return addr;
>>   }
>>
>> Anyway, this I think is unrelated to the proposed change affecting x86,
>> more of a how to make the DMA API debugging more useful when running on
>> arm64 or riscv.
> 
> This is not enough, there is also a dma_map_sg_attrs() path.
> 
> I've reverted 03521c892bb8 and added the following change:
> 
> diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c index 
> 55e7ca8ceb86..bbada41143ea 100644 --- a/kernel/dma/debug.c +++ 
> b/kernel/dma/debug.c @@ -18,6 +18,7 @@ #include <linux/uaccess.h> 
> #include <linux/export.h> #include <linux/device.h> +#include 
> <linux/dma-direct.h> #include <linux/types.h> #include <linux/sched.h> 
> #include <linux/ctype.h> @@ -1241,7 +1242,8 @@ void 
> debug_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size, 
> entry->dev = dev; entry->type = dma_debug_phy; - entry->paddr = phys; + 
> entry->paddr = IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) ? + 
> dma_to_phys(dev, dma_addr) : phys; entry->dev_addr = dma_addr; 
> entry->size = size; entry->direction = direction; @@ -1335,7 +1337,9 @@ 
> void debug_dma_map_sg(struct device *dev, struct scatterlist *sg, 
> entry->type = dma_debug_sg; entry->dev = dev; - entry->paddr = 
> sg_phys(s); + entry->paddr = + 
> IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) ? + dma_to_phys(dev, 
> sg_dma_address(s)) : sg_phys(s); entry->size = sg_dma_len(s); 
> entry->dev_addr = sg_dma_address(s); entry->direction = direction;
> 
> thenran my tests on ARM64 and RV64 boards. Only one new warning has been 
> reported (I didn't analyze it yet), so this might be indeed a better 
> solution than skipping overlapping cache lines warnings when 
> DMA_BOUNCE_UNALIGNED_KMALLOC is set.
> 
> Best regards


