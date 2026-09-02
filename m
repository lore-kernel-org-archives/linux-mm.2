Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A54C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13B96B0088; Wed,  2 Sep 2026 01:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4266B008A; Wed,  2 Sep 2026 01:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA4A6B008C; Wed,  2 Sep 2026 01:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4F016B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:27:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 410E0A0773
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:27:37 +0000 (UTC)
X-FDA: 85167689754.28.9A5D15C
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1CD6B40005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:27:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KByHsLpT;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788326855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwdv+UbQCGldirDEB3P2J/UCKAxWJ9JAmpEwFtpt4cI=;
	b=kg2aQ92terFeAUJ6tP3rkp/FYq70BOiELAABiFo7sBLQ2TSZd3cVnqfuCuU2KqFvWwq1UU
	LUkI3lFhyUI0zSBg/c8aSu6rVjJFTAJc8dwp3/NtlwaWzOwFITrHJS/vohh+ljRRCaOZVW
	JrEeyCMfEf7FuwGRdWc0Z/Z4/p5kSNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788326855;
	b=7Jy/rM20ODH9lWWYaqe1N/V5LL2BL37k5PCffoTAU1rn21jB94GgRUjrleGNwg+7dhMXYS
	eYQEjtPQK3X4D+8yEo9SU5oodb5wNh+BN4a5qLHMAfb6gtsFQHLLpnDxm0u5VyYiPt1YEz
	wAngVDBliTF5y2nC4qIdtnFbUHbwJWY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KByHsLpT;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788326850; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qwdv+UbQCGldirDEB3P2J/UCKAxWJ9JAmpEwFtpt4cI=;
	b=KByHsLpThHRaX4nYpHXA7a/eTJDA1x5k6u0D8azwrIUYWiRgpoDYgI5su/9y8ynM3UPZDjwhAQVwSsedkxrzecTsiaYiV8Xnmy/2omWsbKlq24Rtfy4TkPf21LtluyYL6ub5+hFjccWC8Jny9mYoRyCSDtCuI7N0EaipnHmdFhI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XABT1vy_1788326848;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XABT1vy_1788326848 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 13:27:29 +0800
Message-ID: <34fda62f-a2d0-4db8-9590-c8dc834674b8@linux.alibaba.com>
Date: Wed, 2 Sep 2026 13:27:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/damon/ops-common: use a page-aligned address in
 damon_ptep_mkold()
To: Nathan Gao <zcgao@amazon.com>, sj@kernel.org, akpm@linux-foundation.org
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 david@kernel.org, ryan.roberts@arm.com
References: <20260902031655.84721-1-zcgao@amazon.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260902031655.84721-1-zcgao@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1CD6B40005
X-Stat-Signature: f6nzqnnuz6rpmse4ujdj9wrguxfa79uf
X-HE-Tag: 1788326853-314759
X-HE-Meta: U2FsdGVkX1+jevUr5jhT6f6ZHujlM/JKURmQFuOkrc9DeYT9ZVW/ceOgJuHRmu5JMONtPIR1IVpFZDkgCQudQAt8tEYgO7vDb7DCgPIgbNC1MukSm83Igoh6txs5MHtinddrUc1FmXY7OFpWkgx1frhS68vggVsOYNLcrfXPjaVHwcET3oavianGvAb5pMaOvPgr3I3tRXXtgBJK3oxQePPblHP6ibBA2p6hVX0lHW4OC3TDoVd7mL9tDa97xy/XJB9hawZRbhIKJsZeGNoTdXBSRk7Py/HPmeFvy9lDD0weNs7zd9dDgOSzbGytQa95gjBKFtNuRvbx2T1nRAP+7ZUToERIqqnutD25LltQL5RpYnOUYBUd/+ZpPaUxhQLzhKFCHOo2DFAB1CW9igI7ymQysmsVbi2c8oKUghq7xuyE5EpEGFWi/YowbmUP79r03+izFWCgfYe6qgGw/JlqwpOwbye/qJZl0MvF/nQ6OfmPRYjmr57gKfXmaTzuQ4+HFdUyEjelKc0dHz+cSb0B6SOPwInR/SsGvU5Ym5k6OAwjGMS+TsulA/M9ZeK9GNBQ2stH41Ly53bxLqSEwrqzrgXvhTm/x8sRL4jymfJbnD5cffowuJi7FPNmsluzMxdv+sMCgkEQ0xwxfQnYFtV7PRyNQ7Xr+j1VOAtpud9Oc51r/JFSSaaIpWAZCBXCNW4ZOMq+PrZaJzEUJICPalYmSmZDqq0lgwwRDTlLTvw5Al0fOU5RgaKIRZ00TBQiCTGKQqRMjkDMF3VGSvaZ9cqfxBfMmubOg0ipdHUq+M2q9ZW21YQEZ2l6B7R+fMogmCaxAkZHZ8Sru2gAqJiecAW/69Z7A/B1c/j+pEbzCxkQ/THB03Y/o771f15RCne/BTOfr/CG+7iQmDdxl0Etu0LxPCQ2t8VBrs4ScMpfL3yzNFGXLJH7M8w48kOw0Aj5eLIXYQSzgSlRDsJT71suVaq
 pIgoVPJG
 r3FLi0yXiIK5EII4dZ0N7natB/68zjH4yP59Dsi2gbQOzw8/kNDg4kK6A/ThHRdze7wB9Zvjuc0Gq1iLu0woeg8Z7S+5EuC8aBfmoGvG3lcfWu7vvo0VNWUDwCQyvspD5876YG2FGgJxRR8ZI8aEbPBGJoIG2Q9UERTWUH+gJbDvcMsIxmUw0t2re76pJ17l85THfyrcTf0NKjuynHrtDVtJElJIkDrwJnoum4HOAATfxd5D8oSurYxbeVSQaLnHawYYHebXpc2+T2M7w2R5dqReovuRGIExiXWRLw/r/RGXEQg7mumDmp/BW94Ltz85k2zVIiLFQR43DbsQ98a4i1tY9WN1gIvLqsLtNixkfUFM+E2dA7PX6Tgmbm9rKBXgJOnFfItP5kT9injvVMb7uAch0T3prdzOu2Eaqnxc3VqHpE+w/NXoZ23DFHFYJEQtxKpz/stnRDEgd+4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 11:16 AM, Nathan Gao wrote:
> __damon_va_prepare_access_check() picks a random byte address within the
> region and stores it in r->sampling_addr. damon_va_mkold() passes it into
> a page table walk, which hands it to damon_ptep_mkold() as the address of
> the page to sample:
> 
>    damon_va_mkold(mm, r->sampling_addr)
>      damon_va_walk_page_range(mm, addr, addr + 1)
>        damon_mkold_pmd_entry()
>          damon_ptep_mkold(pte, vma, addr)
>            ptep_test_and_clear_young(vma, addr, pte)
>            mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
> 
> For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
> clearing of the young flag for large folios"), the contpte helper walked
> exactly CONT_PTES entries from the aligned-down page table pointer and
> used @addr only to pass down to each entry, so an unaligned value was
> harmless:
> 
>          ptep = contpte_align_down(ptep);
>          addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>          for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> 
> Now the range to walk is derived from @addr instead: end = addr +
> nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
> page of a contpte block, the sub-page offset puts end just past the
> block boundary, so the round-up lands a whole block further and the
> walk clears PTE_AF in CONT_PTES entries beyond the sampled block. For
> the last block in a page table page, those entries are past the end of
> that page, so the walk writes into the page that follows.
> 
> Triggered by the full 7.1/7.2 kernel selftest suite on arm64 (EC2
> c/m6g.4xlarge). The kernel sometimes crashes at or shortly after the
> DAMON test.
> 
> What the overrun does depends on the page that happens to follow the
> page table, so there is no single signature. If that page is read-only,
> the write faults in the sampling path itself:
> 
>    Unable to handle kernel write to read-only memory at virtual address ffff0003c5d2d000
>      FSC = 0x0f: level 3 permission fault
>      CM = 0, WnR = 1, TnD = 0, TagAccess = 0
>    CPU: 10 UID: 0 PID: 3487 Comm: kdamond.2
>    pc : contpte_test_and_clear_young_ptes+0x70/0xc0
>    lr : damon_ptep_mkold+0x1e8/0x1f8
>    Call trace:
>     contpte_test_and_clear_young_ptes+0x70/0xc0 (P)
>     damon_mkold_pmd_entry+0x150/0x170
>     walk_pmd_range+0x110/0x2b0
>     walk_pud_range+0x10c/0x208
>     walk_pgd_range+0x134/0x258
>     __walk_page_range+0x98/0x1b0
>     walk_page_range_vma_unsafe+0x90/0x148
>     walk_page_range_vma+0x28/0x40
>     damon_va_walk_page_range+0x114/0x2b8
>     damon_va_prepare_access_checks+0xec/0x1a8
>     kdamond_fn+0x534/0x770
>     kthread+0x128/0x138
>     ret_from_fork+0x10/0x20
> 
> Otherwise the page is writable, the PTE_AF clearing succeeds silently
> and the damage only surfaces later, in whatever happened to own the
> page, so the backtrace is unrelated to DAMON and differs between runs.
> 
> Pass a page-aligned address to the ptep_test_and_clear_young() call in
> damon_ptep_mkold(), which is the only place DAMON can reach
> contpte_test_and_clear_young_ptes() from. Nothing else sees the aligned
> address, and r->sampling_addr itself is left as is, so the sampling and
> region bookkeeping semantics are unchanged.
> 
> Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nathan Gao <zcgao@amazon.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

