Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FAD61073C8D
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E213D6B0089; Wed,  8 Apr 2026 06:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2986B0092; Wed,  8 Apr 2026 06:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8546B0093; Wed,  8 Apr 2026 06:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B91766B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:55:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B5D21A0A94
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:55:53 +0000 (UTC)
X-FDA: 84635083386.18.9A7BE0B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id A540CC0003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:55:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ivz8OBwp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775645751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7pk7+2SrMvldzc+4U5mhy1CoMp/H9X1AjSvNIqAgSU=;
	b=eyExTefjhW/OxGwbeXlLPkNXaateS3N9VqzQB+RSNu47JsSU1mvgp0ncXqMQ5m9c3qRk22
	Tpys7iCV3yw+dr4ftrdb3wEJdh893WyFMWrPPukK5uOu6gp6SxfofZK3fGqpvuQwU3gE0E
	xBcE25RY7a/X7M1URJNcDA7WGUXGkOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775645751; a=rsa-sha256;
	cv=none;
	b=DfIeSUsPchGL6rtbVh84z4n33bOB+X2wEx3h6AjqOIjRhLbaTmFvO70l3cHMsb+23dt4Cc
	SfBsW5zd6tnRjYMGqjPcup9fIwFKN/JzM3vzioXLo3G6zPmYmXoko/GGjbi+HOmq8imxpm
	6OJ9JQrGeupAbKZQ9QErHbAODmpheBI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ivz8OBwp;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8C413161;
	Wed,  8 Apr 2026 03:55:44 -0700 (PDT)
Received: from [10.164.148.132] (unknown [10.164.148.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 142E83F632;
	Wed,  8 Apr 2026 03:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775645750; bh=12DWaVF8Vvq5Zd6EKvM59d/YIQTeYLlw8tBqiZQllUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ivz8OBwpsW5cQV+wAkYMFtf3Ru6LoCIwapyqRJlX/gvnHB4pYHgJ+q6s3wOMSbGkB
	 0Ci2NwamPVMH4UiMsn3VeIE7bR/5STGDwB54rPJvFu1Ufnrhki6Ag+HjFScyVbx51c
	 4rli5EBHXWN9pXrpGZTev3n2cxusKJ2HaT1qfS9A=
Message-ID: <85c9a072-12af-4683-be59-9600584d8bf7@arm.com>
Date: Wed, 8 Apr 2026 16:25:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <1e7427c6-b6e5-4a3a-a600-bef9ac2bf3e0@arm.com>
 <CAGsJ_4xqxmHWBahN-yX10XcEwaHpvypCkwWDLHMY_1P_SzCeMg@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4xqxmHWBahN-yX10XcEwaHpvypCkwWDLHMY_1P_SzCeMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A540CC0003
X-Stat-Signature: 6hq9jdymx3u8e5d9ew6f8k4krggwespx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775645751-467578
X-HE-Meta: U2FsdGVkX1/fNX91OT4YNHvjB4jP1N59uj+qV8K5KGwmvCoEiXxTOXZ2fqg+BDjmLUAGAJrZVttK3UD6/K/+8S61hfiYkGyijviX2QDh50sWGsbak3rpCsI0Vl5tOtRu0Ewj5oZ78wgrVQnt9Z49tx67pEAaunBec6dieeriBBG46lv72s22GkicFE0d3NH4MkoYDz/d28tCW0Mcxp0dB0Uzsf/veI0UqVXv2uJWLfUY825ipO7TB0fnQcBZuzgEaunIYhE83iNTTY+8GKYbju4C0RzeCdE98c5mKJjbV+oGYUib1Zt5738RiGhGJYZWgPxmcyxxpjVfYJoQU7jKdzmikj1XxdCEWIMdy2oRBW3KXzk2uLGnHPL35o+5pNq1XeFzmqMgfWPCZmGsBFF4jztmH6t1eGn3Hh35hNw4gsfiTxeQ7xwbLKfBVgqyB9PVSlEsG1+ciOusvmXJbsLSGiLvnt3+W5KRRsUStR6c7MdMGAqLoG9mwLZ9hVNypvB+JB/A6heHYlZmJnLJ7R5+fmaby4Olw521ooYDA1KCvQQtiArEaBrBw8SaXyF8tRFdZ/oDw4sgxNe10nqzgeFKGVSVlrvprsvYN4IsmNMjp1HDNMnJhZqWCzS8Xl+vgkmWqdbpivz+TZKr0joKppN0kejJ4IgDG3vUH/JHGgDKHgo/VfDxkfU2uKZ1/EM6ZeRPwzInYXP8GQZid8olV+/uVGav2A4xrHmzyh6T3x4Jg1uRkiEotKVBYkuBni68Yr/F5EX1yayfwQVLaisfq9xCA+DFUn1mjUTiF5HGA0Va3ioKwv+KXv5u/QjwO7fxahKoeXkCdI1Ky7/LSSztp+CcLSY+SHKSDFNHI0D1PblArgUUIJrcgZERz/ZFZhorOlghgB6AkhBrnpoNd9po4HofGaErq8kbrLf+oUb3sOosJPIU/GfWr0Tf4OSzivUPvei1jwRcQHho710lf8gfwPL
 PhzWI1Ap
 K4qTQlfQfGy0rQGvSDfgPaSKPpzDkIyFKPYeY1Ag2e2gvSBABeoX1fJarjrJ92wMmrsIlsoE4A2cv/3v2LUnpNVjRJ2sbw/9FG6Z9Bmt3qrJh400ALD36/fqYiMzb5EflxSweQZlMpVHQVYQybThTK+ytWn2K6rxdneJg4J72Avylx86AiQmFmkAOkWxe5I2VNOEdTg4Fb9NO7G76tGrBTa6Jy4WCqJ9QZh3Nc2Lt06Y7lUV+C2Rwj7Uk+hubfXYNF9eNZ0LY6lEp1D67YLdMUQpW+dluoMvfQ4ZJyYLdYr0MYagsmt1d5VknR4yhtX/mK5Vhtf6Tx5a+YqNSU17CM074C8E896V95G/zhPxuGmbyTS9oTUQXnEGPukY0/V/udcj/qzpTUsKuoRPaWoNqve8glLvoFCULqbj0yBQXKbfaO+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 4:21 pm, Barry Song wrote:
> On Wed, Apr 8, 2026 at 5:14 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
>>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
>>> is physically fully or partially contiguous. Two techniques are used:
>>>
>>> 1. Avoid page table zigzag when setting PTEs/PMDs for multiple memory
>>>    segments
>>> 2. Use batched mappings wherever possible in both vmalloc and ARM64
>>>    layers
>>>
>>> Patches 1–2 extend ARM64 vmalloc CONT-PTE mapping to support multiple
>>> CONT-PTE regions instead of just one.
>>>
>>> Patches 3–4 extend vmap_small_pages_range_noflush() to support page
>>> shifts other than PAGE_SHIFT. This allows mapping multiple memory
>>> segments for vmalloc() without zigzagging page tables.
>>>
>>> Patches 5–8 add huge vmap support for contiguous pages. This not only
>>> improves performance but also enables PMD or CONT-PTE mapping for the
>>> vmapped area, reducing TLB pressure.
>>>
>>> Many thanks to Xueyuan Chen for his substantial testing efforts
>>> on RK3588 boards.
>>>
>>> On the RK3588 8-core ARM64 SoC, with tasks pinned to CPU2 and
>>> the performance CPUfreq policy enabled, Xueyuan’s tests report:
>>>
>>> * ioremap(1 MB): 1.2× faster
>>> * vmalloc(1 MB) mapping time (excluding allocation) with
>>>   VM_ALLOW_HUGE_VMAP: 1.5× faster
>>> * vmap(): 5.6× faster when memory includes some order-8 pages,
>>>   with no regression observed for order-0 pages
>>>
>>> Barry Song (Xiaomi) (8):
>>>   arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE
>>>     setup
>>>   arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple
>>>     CONT_PTE
>>>   mm/vmalloc: Extend vmap_small_pages_range_noflush() to support larger
>>>     page_shift sizes
>>>   mm/vmalloc: Eliminate page table zigzag for huge vmalloc mappings
>>>   mm/vmalloc: map contiguous pages in batches for vmap() if possible
>>>   mm/vmalloc: align vm_area so vmap() can batch mappings
>>>   mm/vmalloc: Coalesce same page_shift mappings in vmap to avoid pgtable
>>>     zigzag
>>>   mm/vmalloc: Stop scanning for compound pages after encountering small
>>>     pages in vmap
>>>
>>>  arch/arm64/include/asm/vmalloc.h |   6 +-
>>>  arch/arm64/mm/hugetlbpage.c      |  10 ++
>>>  mm/vmalloc.c                     | 178 +++++++++++++++++++++++++------
>>>  3 files changed, 161 insertions(+), 33 deletions(-)
>>>
>>
>> On Linux VM on Apple M3, running mm-selftests:
> 
> Dev, thanks for your report. Sorry for the silly typo—
> Xueyuan’s vmalloc/vmap tests don’t trigger that case yet.
> 
> it should be fixed by:
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index bf31c11ebd3b..25b9fce1ec6a 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -110,7 +110,7 @@ static inline int num_contig_ptes(unsigned long
> size, size_t *pgsize)
>                 contig_ptes = CONT_PTES;
>                 break;
>         default:
> -               if (size < CONT_PMD_SIZE && size > 0 &&
> +               if (size < PMD_SIZE && size > 0 &&
>                                 IS_ALIGNED(size, CONT_PTE_SIZE)) {
>                         contig_ptes = size >> PAGE_SHIFT;
>                         *pgsize = PAGE_SIZE;
> @@ -365,7 +365,7 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int
> shift, vm_flags_t flags)
>         case CONT_PTE_SIZE:
>                 return pte_mkcont(entry);
>         default:
> -               if (pagesize < CONT_PMD_SIZE && pagesize > 0 &&
> +               if (pagesize < PMD_SIZE && pagesize > 0 &&
>                                 IS_ALIGNED(pagesize, CONT_PTE_SIZE))
>                         return pte_mkcont(entry);

Yeah indeed the problem was that a PMD chunk was being treated as 512 ptes
rather than 1 PMD. This fixes it.

> 
>>
>>  ./run_vmtests.sh -t "hugetlb"
>>
>> TAP version 13
>> # -----------------------
>> # running ./hugepage-mmap
>> # -----------------------
>> # TAP version 13
>> # 1..1
>> # # Returned address is 0xffffe7c00000
>>
>>
>>
>> [   30.884630] kernel BUG at mm/page_table_check.c:86!
>> [   30.884701] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>> [   30.886803] Modules linked in:
>> [   30.887217] CPU: 3 UID: 0 PID: 1869 Comm: hugepage-mmap Not tainted 7.0.0-rc5+ #86 PREEMPT
>> [   30.888218] Hardware name: linux,dummy-virt (DT)
>> [   30.889413] pstate: a1400005 (NzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>> [   30.889901] pc : page_table_check_clear.part.0+0x128/0x1a0
>> [   30.890337] lr : page_table_check_clear.part.0+0x7c/0x1a0
>> [   30.890714] sp : ffff800084da3ad0
>> [   30.890946] x29: ffff800084da3ad0 x28: 0000000000000001 x27: 0010000000000001
>> [   30.891434] x26: 0040000000000040 x25: ffffa06bb8fb9000 x24: 00000000ffffffff
>> [   30.891932] x23: 0000000000000001 x22: 0000000000000000 x21: ffffa06bb8997810
>> [   30.892514] x20: 0000000000113e39 x19: 0000000000113e38 x18: 0000000000000000
>> [   30.893007] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>> [   30.893500] x14: ffffa06bb7013780 x13: 0000fffff7f90fff x12: 0000000000000000
>> [   30.893990] x11: 1fffe0001a1282c1 x10: ffff0000d094160c x9 : ffffa06bb568a858
>> [   30.894479] x8 : ffff5f95c8474000 x7 : 0000000000000000 x6 : ffff00017fffc500
>> [   30.894973] x5 : ffff000191208fc0 x4 : 0000000000000000 x3 : 0000000000004000
>> [   30.895449] x2 : 0000000000000000 x1 : 00000000ffffffff x0 : ffff0000c071f1b8
>> [   30.895875] Call trace:
>> [   30.896027]  page_table_check_clear.part.0+0x128/0x1a0 (P)
>> [   30.896369]  page_table_check_clear+0xc8/0x138
>> [   30.896776]  __page_table_check_ptes_set+0xe4/0x1e8
>> [   30.897073]  __set_ptes_anysz+0x2e4/0x308
>> [   30.897327]  set_huge_pte_at+0xec/0x210
>> [   30.897561]  hugetlb_no_page+0x1ec/0x8e0
>> [   30.897807]  hugetlb_fault+0x188/0x740
>> [   30.898036]  handle_mm_fault+0x294/0x2c0
>> [   30.898283]  do_page_fault+0x120/0x748
>> [   30.898539]  do_translation_fault+0x68/0x90
>> [   30.898796]  do_mem_abort+0x4c/0xa8
>> [   30.899011]  el0_da+0x2c/0x90
>> [   30.899205]  el0t_64_sync_handler+0xd0/0xe8
>> [   30.899461]  el0t_64_sync+0x198/0x1a0
>> [   30.899688] Code: 91001021 b8f80022 51000441 36fffd41 (d4210000)
>> [   30.900053] ---[ end trace 0000000000000000 ]---
>>
>>
>>
>> The bug is at
>>
>> BUG_ON(atomic_dec_return(&ptc->file_map_count) < 0);
>>
>> My tree is mm-unstable, commit 3fa44141e0bb.
>>
> 
> Thanks
> Barry


