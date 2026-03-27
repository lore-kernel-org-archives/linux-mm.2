Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C8010ED666
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D0D6B0096; Fri, 27 Mar 2026 08:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4343B6B0098; Fri, 27 Mar 2026 08:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371026B0099; Fri, 27 Mar 2026 08:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 269056B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:26:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA1DBBE713
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:26:25 +0000 (UTC)
X-FDA: 84591765930.26.D1B5E9F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8605740011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:26:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="q8Uvnk/M";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774614384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHVn4NmXjmnTdA6sAi+rLYxhmcF6ObZDwozOZJ+zKX4=;
	b=AQnk5g4Yzwb/HtpIEO5uGYtw4Q1ShpQL94venrnKolzQc18lbqpIIjNOWtCuVyILSZffaH
	xdGam7IUKna4SxAZU3YQ4SdFzg8nuH9CJCTS6d3hM00Y6CbYWrPYoFcnBGUNm0fpgA3h13
	HbSB3vR7TSCYExPBhXkXHJnCbz/II4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774614384; a=rsa-sha256;
	cv=none;
	b=JQC/IZg9YEzEE3qJJNAas15uzOpWgHGmaodsb063d2Bh4cgHJoWN7rGJgwQEQXHGiVEs7x
	5o5WCxHJowZfacXpHYPb3wv6K611g//Efv3A626O6BK3RXkhtmP/83EoyxGCHsDkewhX3m
	44kgeE2/FC2xtVmJy2bAdS0A0rG7nD4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="q8Uvnk/M";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 773232BC0;
	Fri, 27 Mar 2026 05:26:16 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21A223F641;
	Fri, 27 Mar 2026 05:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774614382; bh=3b/hWGfyYHUW6app5fUiIeJn8/Q3oXHdpndPl/twz4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q8Uvnk/MiNqXPUx5lsc6/r4nOTgcGl6iLl/9H20jXWBrMBxpzGv8KQv/uJ3e8M9QQ
	 VavljMayMpegvZLFdL1PgADtsO2tBFFZnYVwUJxKMy767ZRvS+3AQRS0ruN8tPy3qe
	 Sgsf8LReOo2OMWkjyoBMlFChAbMBx6rv1uGrBG4s=
Date: Fri, 27 Mar 2026 12:26:13 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: vbabka@kernel.org, harry.yoo@oracle.com, akpm@linux-foundation.org,
	hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	stern@rowland.harvard.edu, linux@roeck-us.net,
	andy.shevchenko@gmail.com, hch@lst.de, Jeff.kirsher@gmail.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
Message-ID: <acZ3ZUXhFHpSXzYS@arm.com>
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
X-Rspamd-Queue-Id: 8605740011
X-Stat-Signature: 4yfjatq4oesjeje991sobr5fjb7a5qus
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774614383-748766
X-HE-Meta: U2FsdGVkX1+CLmn9EkYWQmuUnj4nwFoXSxmXBZ3nChqMKmrlKHdG8Volw+Evgu1ps2TSDuF5Nccyu0p/m/2BupiqNirxkIh9rpijSWyMWaoFLTo6pn6hIDfX+ybJ39NdYtUfkSUFAsu6m1yIPiFFzyd++WEKXwOVz43J6iCwMWTa5yN/FrNpo2MDcF6uYkgbjBd0aJykiwVO5fweMbyx0nDYGKiWnvHE2cgr1U4ZeuJq82gUKKsn/BHZ6Nqqr2Tusy9Mok0oXUw0hCDJkTpKfN3pxjGBLYRkOafNMOWM87zZuHZzkFQ+JSclnXza9qdNzlfqwSrd5bn6RiKSJndW7iWYQcsr7W72FLWTO/XX9trmdX9MY1a9jp19p+tYwqkRF34Gp0EL6cS9zoMgZBCmguvQ4uGg5F3F8SzyKmZfpD8yxftWYyxPqtqNQLxge1YidWE46O+PfPTWjKCPOmI6ZzfXv/pBIylPU6dI/kX6WqUJ0nqv27opykg4hMSuxcV2IHNRGO49akRdpE/9apM0t/cc3sPf8NSPrNad43rtmpJIZEvD8+yKr4tGukBV9lrfv8a5dGw14oyIFcL1DwMADJy3m+t5cfipSuTX2Lb7vqHasThT4CfkVXHZ4fjyBT3hMchtW4qSDuXpnHtG/yx3UrZZdj0gG2w8oAuBuueJN8Vp9PHSqlrqs8nqb77gQYqlyTwo4g02zL16u7eAEfbHYly+FVJ/wehW3Yyp2edSwntsxEjdtoFIA9q+s1vWrf5VvpWDrk0aN7E4UYw7FbA4s4gwXIPcdkqP/2brmhiN0puXRvSWvmIJezSxsHbs0dQfIhZerjAGS8w3/KLioXHlTqJBfRoxKRXWYtyPrcpC0nK87vve8NUuBU7GmcO4KVonwH2JPugW6GxN/Bdicuy+P08grtPK7zx0o/7v7auxgz3VzfLpPRnkhNJuR15XD9BbejcZiZJpalJ7Hs1m6Is
 TVNU5OE0
 mpUXourr8mpQVvCADA/wr7b7x4IXOvMR3M2rvBK+KXdrRnghHtGalQyPDnVeaFH+UvagO5e2DWtNRj67OQ75i953xhGapesE+tzmk7xbqTIPWrtlr8vz8h/Q5CfBgHNJBrIYwW7mHyug0T3ire1PoHZSWw5DjcFWKz4KsFofyaYcMrGpnPdAWd8KVeS8FGIgTlF4MSjagbxC594eYio2/gPZZibugxlvqzZpvKVQx11sHVAeslVdznfVfQFTxyTIqq6L2YLmG7eLF0oSBa96qMP9qAG/+hMv6PkUbOtb5aUmUUsk5V/NGq7znluFMMRS+8GvkWjs+6mhp4lBx2uZiHSrgwTn5ULRnlJzZjkNqNpiqv9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Marek, Robin

On Fri, Mar 27, 2026 at 10:58:46AM +0500, Mikhail Gavrilov wrote:
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

This indeed has come up regularly in the past years.

> +/*
> + * Align memory allocations to cache lines if DMA API debugging is active
> + * to avoid false positive DMA overlapping error messages.
> + */
> +#ifdef CONFIG_DMA_API_DEBUG
> +#ifndef ARCH_KMALLOC_MINALIGN
> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
> +#elif ARCH_KMALLOC_MINALIGN < L1_CACHE_BYTES
> +#undef ARCH_KMALLOC_MINALIGN
> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
> +#endif
> +#endif

TL;DR: I think this is fine:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

I'm not sure that's the best way to hide the warning but there
are no great solutions either. On one hand, we want the DMA debug to
capture potential problems on architectures it's not running on. OTOH,
we also want to avoid false positives on coherent architectures/devices.
I don't think reconciling the two requirements is easy.

When DMA_API_DEBUG is enabled, the above will change the x86 behaviour
that could have implications beyond DMA (e.g. may not catch some buffer
overflow because it's within L1_CACHE_BYTES). Similarly for non-coherent
architectures that select DMA_BOUNCE_UNALIGNED_KMALLOC (arm64 and riscv
currently). arm64 defines ARCH_DMA_MINALIGN to 128 but
ARCH_KMALLOC_MINALIGN to 8 (why 128 is larger than L1_CACHE_BYTES is
another matter but let's ignore it for now).

More of a thinking out loud, we have:

1. Coherent architectures - alignment doesn't matter

2. Non-coherent architectures with:
   a) Sufficiently large ARCH_KMALLOC_MINALIGN
   b) Small ARCH_KMALLOC_MINALIGN but DMA_BOUNCE_UNALIGNED_KMALLOC
   c) Broken config - forgot to set ARCH_DMA_MINALIGN or bouncing

We can ignore (2.c), the aim of the DMA debug is to catch wrong uses in
drivers. If drivers is the only goal, the above change will do when
running on (1) or (2.a) hardware - it will catch sub-L1_CACHE_BYTES
buffers from drivers while assuming kmalloc() machinery is safe.
However, if running on (2.b) it won't catch anything that may be
problematic on (2.a) since the DMA debug ignores the overlap.

We could make DMA_BOUNCE_UNALIGNED_KMALLOC dependent on !DMA_API_DEBUG
but it would be nice to be able to sanity-check the bouncing logic.
Well, it wasn't checking it before and with commit 03521c892bb8
("dma-debug: don't report false positives with
DMA_BOUNCE_UNALIGNED_KMALLOC"), we made this clear that overlapping will
be ignored.

Irrespective of whether we disable bouncing with DMA_API_DEBUG, maybe we
could replace the above commit with:

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 3928a509c44c..488045ef6245 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -175,7 +175,7 @@ dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	if (!is_mmio)
 		kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
-	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
+	debug_dma_map_phys(dev, dma_to_phys(addr), size, dir, addr, attrs);

 	return addr;
 }

Anyway, this I think is unrelated to the proposed change affecting x86,
more of a how to make the DMA API debugging more useful when running on
arm64 or riscv.

-- 
Catalin

