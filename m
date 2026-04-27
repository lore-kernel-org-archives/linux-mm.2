Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C93FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7003D6B0098; Mon, 27 Apr 2026 11:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1396B009B; Mon, 27 Apr 2026 11:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0076B009D; Mon, 27 Apr 2026 11:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7A86B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:05:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08C19120A82
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:05:14 +0000 (UTC)
X-FDA: 84704658948.18.6C8A809
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id B83371C001E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:05:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ZvPqTD/8";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKmktgMsLT8bswV/+6qn/5r6AsKY+Ic+6aIWG845vb4=;
	b=Y6J68SIy7JHfGnqOwwYApPU45FbwDCQQOasC4WEQ7nb5KiD2Zu2g2s7wpei5LMrF1glL9K
	QpTwylFGAxGb3RX7S40jHPenxx23k3ZHgvOC7HcFoaWNoQsH7VJFYdd+G6wH00SKmCW8WS
	sFPGnH1MTfWunlCO/h44NyMTE5Ageg0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302312; a=rsa-sha256;
	cv=none;
	b=rlskdY99+XRFr+JAJS5ouDor2Fvbv4WR8vnLDWJow/QjODM1OgrPxn2LFIpbquoU7IhCez
	OLOPOElEUQHeujgUEj+cH8RnFb0qbIaWM6YzzaiBZ8oqZNjCZFIbA4ph9FywsQQ2L/pMAq
	tnrgJ1hWnS5ZkJXnbldmiOJKQU4DvSo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ZvPqTD/8";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0699B1FC7;
	Mon, 27 Apr 2026 08:05:05 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 952753F7B4;
	Mon, 27 Apr 2026 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777302310; bh=LF4eMdK0ID4NJDAUmuKQ8VsmPWmO7w6FTTlpJhcDycs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZvPqTD/8uz+vouJEXQWe5V4WnPgvNPoD0zRcg/+h/FtE7s8IlA6PhWIUySQ6Ot+HJ
	 7KCalBDGW0j/7MxTtrtqV9TDUTDg/99gV52ADTb5nu8Ml/zvWGSKnJ6WAsgr+vS0FR
	 BRD/orHCUaiFgQi9kEUiKiBo8YlSGbTrzSKMfScs=
Message-ID: <fb022a6f-0faf-4742-8934-8a7ffae806f6@arm.com>
Date: Mon, 27 Apr 2026 20:34:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B83371C001E
X-Stat-Signature: k8p7xzkdmukbybh75esoueb3zz58rpid
X-Rspam-User: 
X-HE-Tag: 1777302311-161845
X-HE-Meta: U2FsdGVkX19LVPlxvVKyj3s5UEQzcEKlh4gmt27htO269R6W7A2GlAssbkNOSSxE9TzahR5Zb05cHNdTWikUxXR3P4DxeJ71KOddD8I4UyWGYp554qDrOkqyTE7w+YoUJYGjLLQbrd6XoNmQ7FaLYTykYVwRF3o51QIIpGuy1oyBlH8UcLWkJ3Sm6GgYlabTOqfCrVSq4Kdm/j++vQzh/GqUCk/TbuRz1mB8prLdvt0QoPAFMqVQeKNH00RVjXV6nlHE/312I9IkOKmwkHJFVOFrQfAh6iAgHGJy1OUYcwoumSpjAAK/ShiKMYODmV7otZj/3cYUxC5BR7uf9jegyNuPZ7L81x8xT67C5ez63VkxUZTuAv2HIlcvJ6PDXiDUd+dHxFFpLiy60VaPmBnCuE8EhF5fztpdDjHl4YEph0PMxEVDCi3rRQxUOZUf6oIE9Q3DU+N1ey2VgtR1lQfmFhdnZxNRQLxaV3HTYg30dH3Ko39qxU4frReubRLHm7XrSH8kWs+ICpKW4nChHqUCuE1cW+6HCc/oV/MmsWxxAxj/Z92h/YybnPTAtoNQ8FuUtUB/eoJzxlExKQqLQ/eDFSV4WsxHPHV84e/0FlLkfWqUwKlIpXsgvXzTYts8ZJC9CcLnYzfp//kzy8qy/iTXyeVzqx3KCmg8jMdpdqGxTVqMRSa1DLUVyV4kosA9tb0Hq+tAaUYDO6XgCuPfZvz/TxeBA3D54MQ2SfZK3peuM5esrxnO1pxUHIV95vBZYVBUlv/2QcI3jj2sSL8R706MbElrgzrrRneAYh2sV2t1KEKhAZLSnmB9rXlIjvCiQx5V2MYB0Dx1qbqLLGUwCULVMfDZoODhCsubHYTv75iFm8HJBhNacyuWrLEJwlAaofmMhsHPosuG52BZZfZ/tQqascIKBH6GeKKzyxxAXG2wbdynbZFtPQB8VVXCnKm3SXjzmdhTyx+cHfm/mlVX26b
 qd0L20bz
 UP43jHC1gmKlVfpEzBO5yhjuJqBPIDDmCUVuCVwxaPryz1Z05zWS1bKGnYdQow1YLZbQglqzR0/RgdkE7/d9FUa2d7g/oVFCLwaHPhILOv/7fnPEJOYxeRjsRRW6P/IxdCnZDv7w4p9n+mH9ylM9UktnVS3qPSRqT5VlQPyCDKYimsAV7yAyipjwsbF8XBHGYOlozFqp8DwwgT/Yk5pX5oLFSB8QJqNiJeWPgLW0YylXJTsbJGIwbzhjMNYjgYnChkSJbs76NNvd8stvEFQb5PHEnyPyhvbJbZqPUakwP8I3C7mX84J58NKJoEoLYUwBXKpIKVnCocenZ26c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> is physically fully or partially contiguous. Two techniques are used:
> 
> 1. Avoid page table zigzag when setting PTEs/PMDs for multiple memory
>    segments
> 2. Use batched mappings wherever possible in both vmalloc and ARM64
>    layers
> 
> Patches 1–2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
> CONT-PTE regions instead of just one.
> 
> Patches 3–4 extend vmap_small_pages_range_noflush() to support page
> shifts other than PAGE_SHIFT. This allows mapping multiple memory
> segments for vmalloc() without zigzagging page tables.
> 
> Patches 5–8 add huge vmap support for contiguous pages. This not only
> improves performance but also enables PMD or CONT-PTE mapping for the
> vmapped area, reducing TLB pressure.
> 
> Many thanks to Xueyuan Chen for his substantial testing efforts
> on RK3588 boards.
> 
> On the RK3588 8-core ARM64 SoC, with tasks pinned to CPU2 and
> the performance CPUfreq policy enabled, Xueyuan’s tests report:
> 
> * ioremap(1 MB): 1.2× faster
> * vmalloc(1 MB) mapping time (excluding allocation) with
>   VM_ALLOW_HUGE_VMAP: 1.5× faster
> * vmap(): 5.6× faster when memory includes some order-8 pages,
>   with no regression observed for order-0 pages
> 
> Barry Song (Xiaomi) (8):
>   arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE
>     setup
>   arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple
>     CONT_PTE
>   mm/vmalloc: Extend vmap_small_pages_range_noflush() to support larger
>     page_shift sizes
>   mm/vmalloc: Eliminate page table zigzag for huge vmalloc mappings
>   mm/vmalloc: map contiguous pages in batches for vmap() if possible
>   mm/vmalloc: align vm_area so vmap() can batch mappings
>   mm/vmalloc: Coalesce same page_shift mappings in vmap to avoid pgtable
>     zigzag
>   mm/vmalloc: Stop scanning for compound pages after encountering small
>     pages in vmap
> 
>  arch/arm64/include/asm/vmalloc.h |   6 +-
>  arch/arm64/mm/hugetlbpage.c      |  10 ++
>  mm/vmalloc.c                     | 178 +++++++++++++++++++++++++------
>  3 files changed, 161 insertions(+), 33 deletions(-)
> 

Hi Barry, have you got the chance to work on v2?

