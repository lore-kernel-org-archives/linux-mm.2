Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB71BFD5F98
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 09:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED1E6B0088; Wed,  8 Apr 2026 05:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E426B0089; Wed,  8 Apr 2026 05:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3B76B008A; Wed,  8 Apr 2026 05:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9FC86B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:14:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EF965961C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:14:28 +0000 (UTC)
X-FDA: 84634827816.15.F51C2F5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id D17F4C0008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:14:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ghxk80zy;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775639666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkHCG5dhZchDvFXHA3IGDgcnM8tbJ/gx4ORHy85CrQo=;
	b=S+v3GroeXOtMULxfNDAN5/jxb6yjsYW2ftswVkjHGeuLU14Fyw/GuZm7meaHPBZeUX3JLt
	SB59SI39owGhIAPsvzJslnon5vX2Om8GhBjmKKd4xux02VIXDzMf4C2eSoahob1/w0IYn4
	czPp/OxNXIvQlOyXVuoXb8ZMqMh1Ju0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ghxk80zy;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775639666; a=rsa-sha256;
	cv=none;
	b=xUlZmYpgardAtQvoYWua/p04w+sJ08QkmSzbHmMT1ozQTqGVU1JiMpSt3aXl0i0HGHmN4N
	ATw+/FJ4NU9gvJ1OYjfY5Y/cwg4UGq4YHLWsyXdL/nD2LCxqWKPPZfrOy7A4mk/QNcTrHG
	pgfaFlpu3V76kTrdH3BEyYgdP3xS4lM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAF962720;
	Wed,  8 Apr 2026 02:14:18 -0700 (PDT)
Received: from [10.163.142.59] (unknown [10.163.142.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2387E3F641;
	Wed,  8 Apr 2026 02:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775639664; bh=d72bEFH3e2m4PCDJvyifqs2i7ZCFESpqNozQ8GzrTfg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ghxk80zyff7gDALCMKWg7f/MiqxnNUGlu88QNl2zWCW0b6XyuS9iTul4ptVmO4fni
	 9ibRuCeu8jxX4N5VERxc4am5wONI3uvo+DNbNpsT5HzljD5eY3NgYkFXJ6g3Pk+hqp
	 QmDlj/2VR5Y5yeFyWbHcB+M46P9UTUFTFt/Wqa0g=
Message-ID: <1e7427c6-b6e5-4a3a-a600-bef9ac2bf3e0@arm.com>
Date: Wed, 8 Apr 2026 14:44:16 +0530
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
X-Rspam-User: 
X-Stat-Signature: r5enp3arzfqqoyug7uuofcp4m73obnxw
X-Rspamd-Queue-Id: D17F4C0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775639665-527774
X-HE-Meta: U2FsdGVkX18uHyOnVZ2SRBwFxDdkl3HcoTgwHr/3LBfmokCSFxkMyIw1Ry8OpKwvPLcF0n/DF8kWpN18p0jEGDiM9aCT60rqaR8hY3DcUd59ZTj74xFn7FZ27TK9KsrmeqazzmG8JuDOM1vjI+heqz03B96A6lpQmP5pSqiiNRnPerEs5hK45ovifn5jwgzbgCT4DMoGHoHZ3vOsLQ9aOHjRGA013u3iEEkrwDuI/rDvsM7P2p68boOKgEYvrqEa7HKdi4VivTaZa19yDUWa98vRInWfjvDxvTetSWnfPTK6+15id+gEnmn85OseR+hDZJhKv2UmItN3NNF70QtODyq52YVW78SgmG7WQtoQZt4Zoi03AuqlQ7vQx//qGWj9SCXQM25fZCaDpCnqlsV/Yu7jurifUhbQYlRcl/pt2mpXc5URE3hbkOXRqo5BezXl29u3Ke30TBBSAyMo6u599ZGRrrRIxuIbP9Un/bCJRPp/x0CdwH38B1fmUJIfRrZj6CsEdAF7GKtdRO8gIaZK1rluHq4sZ+VfRd7iijH/c+hl4LtumuYGJ1vjGykgoMkwUfLfe8XBMmJMflsStJnObI65XosVZrqh2GJzB+Z/kC1PxNdfjvAj2N6jVPZbFQ+aMGPiWjdsszUqpvqLFqsZ0zJSiGXmyfpUOmer1mALrMuO23nunu0oOGzsHzU7aB7oCBcq1Wbwjg+gqkCnXwhfPPiqAXry0uvs1xf2VjdoiXnu7RbgWGA++tRRlI/1LZRycnUFvlx7iTLimqWIRTj6mMpvPWJJpVlx6i2xvfN4XBHspiyBkJGJhbv8R7hGfj18pmcTUIS7eTi/8lgbxKEjWdzR1kuRE2ODgv6P5AhwVqdnXSx6cLGAqN5GNtzO0YL0QqZMy7MPqARQ/V8OX2KIUJgHdUfAdjTlF3uaICiiompQs5vLb7tjLy46qMnEyBmPLj7yxSCBbtvTiwulLZM
 K50/YLsV
 1X12rTePQtoyoW6EnuzPKkYcoU5vy2hkMwkyPPQYEWBMAelHvCqFCdb2unSXlcC3fnd0OLX608Tz5QuhgIoaFBp7Zoc3D5wlS4LVl+t35nmctkwKjry62hRGTo71stXsnmde3vTb+h2e8WTBQMy6ipny7lqoAPEJH4PrbNHQcr7TLY6jPOR2fRPL2+EvlbrEifN/zptqYMF2f0qaz89iB00tqiv8XVw3sgdQOGBEvy0K6r0WnpLMu8wC7rZcW7PXFilxug8oXFDVQv6qqmUYA6AJ8J+kLYLxXINWCBEvO1D7O9ctBiihPUb0IbVgrQVUudwqqQInmeOBsjY4=
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

On Linux VM on Apple M3, running mm-selftests:

 ./run_vmtests.sh -t "hugetlb"

TAP version 13
# -----------------------
# running ./hugepage-mmap
# -----------------------
# TAP version 13
# 1..1
# # Returned address is 0xffffe7c00000



[   30.884630] kernel BUG at mm/page_table_check.c:86!
[   30.884701] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[   30.886803] Modules linked in:
[   30.887217] CPU: 3 UID: 0 PID: 1869 Comm: hugepage-mmap Not tainted 7.0.0-rc5+ #86 PREEMPT
[   30.888218] Hardware name: linux,dummy-virt (DT)
[   30.889413] pstate: a1400005 (NzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[   30.889901] pc : page_table_check_clear.part.0+0x128/0x1a0
[   30.890337] lr : page_table_check_clear.part.0+0x7c/0x1a0
[   30.890714] sp : ffff800084da3ad0
[   30.890946] x29: ffff800084da3ad0 x28: 0000000000000001 x27: 0010000000000001
[   30.891434] x26: 0040000000000040 x25: ffffa06bb8fb9000 x24: 00000000ffffffff
[   30.891932] x23: 0000000000000001 x22: 0000000000000000 x21: ffffa06bb8997810
[   30.892514] x20: 0000000000113e39 x19: 0000000000113e38 x18: 0000000000000000
[   30.893007] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[   30.893500] x14: ffffa06bb7013780 x13: 0000fffff7f90fff x12: 0000000000000000
[   30.893990] x11: 1fffe0001a1282c1 x10: ffff0000d094160c x9 : ffffa06bb568a858
[   30.894479] x8 : ffff5f95c8474000 x7 : 0000000000000000 x6 : ffff00017fffc500
[   30.894973] x5 : ffff000191208fc0 x4 : 0000000000000000 x3 : 0000000000004000
[   30.895449] x2 : 0000000000000000 x1 : 00000000ffffffff x0 : ffff0000c071f1b8
[   30.895875] Call trace:
[   30.896027]  page_table_check_clear.part.0+0x128/0x1a0 (P)
[   30.896369]  page_table_check_clear+0xc8/0x138
[   30.896776]  __page_table_check_ptes_set+0xe4/0x1e8
[   30.897073]  __set_ptes_anysz+0x2e4/0x308
[   30.897327]  set_huge_pte_at+0xec/0x210
[   30.897561]  hugetlb_no_page+0x1ec/0x8e0
[   30.897807]  hugetlb_fault+0x188/0x740
[   30.898036]  handle_mm_fault+0x294/0x2c0
[   30.898283]  do_page_fault+0x120/0x748
[   30.898539]  do_translation_fault+0x68/0x90
[   30.898796]  do_mem_abort+0x4c/0xa8
[   30.899011]  el0_da+0x2c/0x90
[   30.899205]  el0t_64_sync_handler+0xd0/0xe8
[   30.899461]  el0t_64_sync+0x198/0x1a0
[   30.899688] Code: 91001021 b8f80022 51000441 36fffd41 (d4210000)
[   30.900053] ---[ end trace 0000000000000000 ]---



The bug is at

BUG_ON(atomic_dec_return(&ptc->file_map_count) < 0);

My tree is mm-unstable, commit 3fa44141e0bb.


