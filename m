Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B742C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF476B00A0; Sun, 12 Jul 2026 03:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A69E6B00A1; Sun, 12 Jul 2026 03:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19FBD6B00A2; Sun, 12 Jul 2026 03:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD93A6B00A0
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:43:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A970140858
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:43:25 +0000 (UTC)
X-FDA: 84979334370.02.4A1BA84
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04677140006
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:43:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UM3JYBV9;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SN3Eqr9kVT0WJxI1+TbSrfMJ94BdyG0aA1uKrGqGcWc=;
	b=ph1NBKt/nxeSphlxlrrfQq2jzb3WZ/yKgQAdMi5h+TyYIhOIBCSf1hhxPxaevHchTi3VLP
	F40Nj3VDHIYVvYAkS8ZJ8Tsa9WJ5De7lVSf5OcDbD5KyjI7pxqT6MjSTXv18bwcSRUZQax
	co+DiKzM7/kHCWuVPGrUVi/2Myw5htA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UM3JYBV9;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783842203;
	b=uauPBFc3oL8uUPT+i7rs4+IYO9QKQq7bYf+7F6Mz3wQNXfW9fr3PfENb4Zk1z9wnnpCXVS
	oGEGzuXOpnLaBhlOwJ7jyrCSOOfms/CZLPNfH075nQjPBFzTq7SNZKhgue8esRTR+w/rGu
	6e7K8GfcKA1k4LMxissdPDfJd2YS2eA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BDC01682;
	Sun, 12 Jul 2026 00:43:17 -0700 (PDT)
Received: from [10.163.129.143] (unknown [10.163.129.143])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8ECF53F85F;
	Sun, 12 Jul 2026 00:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783842201; bh=UYx5fo7e+lxcyM59ISiOU13g5eIgoyjRrIVDtKL9jW0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UM3JYBV9OTPunMhOREV5sC8dPLz7aJpnp0FpbpEaiJeHy/lYgBBaRn2JyJ/+vUS9b
	 C7yMwQ1qtJP5l8lzEdfU1Sr3He1ud6P8jR573YExHwyIIZQC99cpw/T9zunBGIhJIL
	 tkpnh2iCeXxOpqU6JlnwaGudOBuSmCDc3g6D2EAM=
Message-ID: <d47ac961-4767-4ce4-9c75-f281beb24e42@arm.com>
Date: Sun, 12 Jul 2026 13:13:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/vmalloc: acquire init_mm read lock on huge vmap
 promotion
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 04677140006
X-Stat-Signature: 9hzq5waf9gmdr7cqnr3n7k4df8ynbe7q
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783842202-385786
X-HE-Meta: U2FsdGVkX18aipdOoHicdTcLJZUT/S0/wgmdBdhJ6HrwExgnRb04U8L8537IHu76Tn3JzZl2DeZsVhhWcuNfLMEKU4QMM48bQ761xD56rEt/hKEM2/HW5XO7wX6FYUfpWHP/gA4ZhQN+PkMFuVG9Y+Q5D1NY+Eccq+DTYq+DPA4eFE95xs3y8Axqd3DAexFros/HMFot2jjsCLekGWlznTPIzLcyjzm6DQ4i+uvm+J8I7QuFULmwLeuRzSr7ibRG1bvWh7ZwkZdZkPiXY3FRTPxxqRs0gx/BG4FcT2UYpOHa2TLJmJz7fB9aGoRDy7BAQu6Afd1Gp7nQZiryKrSvdGo+khXGz8kKO74GIXOuI54e4QNNSKOk/mytyp8u59NFzS5/xqdUz/9FTjtRAurWYrk2H3d/y201BGC2R8jOdo2pgqYLdVDgA6kNvjnwWmcRJgzWecuHRR8tkeUlrUIjL6heVWGyP5acsxx9P7+uEA8YPrRSc7kPhJmsGZDMOvMGM4QGDIo/24VbFq9ASiUQEBzXZV1sFqX6N7VbHt/eO5lPEfkdiX4F4PEvEZNYpWalsVCnIYohQLtDKYlp17omx9e09AZim97nWOMS06DjW3pX6L9LYdzMQ3SOHGYK0PliHXwqLd/D3L1QmEqhS7NnQkmduMKvfpBA62BaFDag/eZoEom369gdn6FN18fDw7q4KqOYrhb++MMO0sdPREdHzluVBltMnX9GJPcr09C1q9fkhZ7yixlWMHGanK7RgS23YKA+t44DRViGUD2CfsStONTlqLFgAmy7aOcZ8HL/dGl1OtHmyvxGuXBzUHtqBtAJefUztyP8aYGYpkDBub38JoKsNCuCySrKBuzvkGM4SRXkm2YD5hc/Dazx3irbJn7QTPAlY2eAeu4EjCf4u5ZJv2ZcC0OMn0izcmCp3rOQmxx1GEdZ5bLreL8IrkrS7BU2amQmsEZCqguwu1ExF1p
 zwlKvrX2
 A4iLrubluMvTUt89J9fhqjtflHgTTuzYgdX5BbFYmOmZZCYlH5kQ9mZmELWJWpdWP8fdvnRT486yYqNNzRL7oeMIlUiCctcGItcZSsWQzHypGPYiY/YuJ/9e/1sQoEAb2N8MMABukxSbWGwMgT25zfuTInBydsEecl2bitsdXDg1fdxAogs0bh+JwtjAYdEBmjF267WTohtXmdx4wYcSZYVpFSAyZBpJQAygOZFmNLGBOV9931Cmr2qoJVAKbZLpfjqRqVKXcqcZBoxBFFKAj/6YdWcmMCY+5kHnI6/FluHiio/PJYVHmDa3ZreArkDJpDXiZMuoc9lbHN54An/Fs6xJIhS0l5D2rBr+Jm/MCO61T+XnfLmqoDSGedcv5NMyfQy8Erh8OvrZQaaSKhg2rkAZHGVG6kLTeFGf5kxWO7D1o7lWHqpKE034yf2/Gch7qSueOtkgzD0tIMq+F5nzv16729Jk1Y+L62zQktDmCBaDM+hkCFGdesV0HXp1Ha15XboorRPCcKxE57quBmpffs89+HNDLrL/H5LI/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



[-----]

> We also define a guard class for mmap_read_trylock() so we can use
> cleanup.h to make the scope handling cleaner in the implementation.
> 

Will this cause backport problems, I think this scoped guard thingy is
not that old?


> One wrinkle here is commit fa93b45fd397 ("arm64: Enable vmalloc-huge with
> ptdump"), which addresses the issue for arm64 only by explicitly acquiring
> the mmap read lock on kernel page table freeing should a concurrent ptdump
> be in progress.
> 
> This is problematic as vmap may acquire the mmap read lock prior to ptdump
> attempting to acquire an mmap write lock, leading to a deadlock when the
> mmap read lock is slept upon on page table freeing due to rwsem
> anti-starvation.
> 
> We work around this by predicating the mmap lock being taken on
> !CONFIG_ARM64 for the time being.
> 
> With this patch applied, a follow up will partially revert commit
> fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump") and at that stage
> remove the arm64 ifdeffery.
> 
> We also update walk_page_range_debug() to assert the mmap write lock
> unconditionally and update the comment here to reflect this change.
> 
> The issue has existed as long as ptdump was available and vmap freed page
> tables when promoting to a huge leaf entry, that is, since commit
> b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table") for
> huge ioremap, and commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc
> mappings") for huge vmalloc.
> 
> Since the former is the earlier of the two we choose that for our Fixes
> tag.
> 
> This patch is based on work by David Carlier (linked), with gratitude!
> 
> Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
> Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mmap_lock.h |  1 +
>  mm/pagewalk.c             | 22 +++++++++++----------
>  mm/vmalloc.c              | 50 ++++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 54 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 04b8f61ece5d..6b5c2390cc30 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -621,6 +621,7 @@ static inline void mmap_read_unlock(struct mm_struct *mm)
>  
>  DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
>  	     mmap_read_lock(_T), mmap_read_unlock(_T))
> +DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
>  
>  static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
>  {
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 3ae2586ff45b..bbcfd68d0907 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -678,6 +678,8 @@ int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end
>   * will also not lock the PTEs for the pte_entry() callback.
>   *
>   * This is for debugging purposes ONLY.
> + *
> + * The mmap write lock must be held.
>   */
>  int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>  			  unsigned long end, const struct mm_walk_ops *ops,
> @@ -691,6 +693,16 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>  		.no_vma		= true
>  	};
>  
> +	/*
> +	 * When walking userland page tables, an mmap write lock must be held to
> +	 * account for munmap() downgrading to an mmap read lock when tearing
> +	 * down page tables.
> +	 *
> +	 * When walking kernel page tables, an mmap write lock must also be held
> +	 * to account for page table freeing on vmap huge page mapping.
> +	 */
> +	mmap_assert_write_locked(mm);
> +
>  	/* For convenience, we allow traversal of kernel mappings. */
>  	if (mm == &init_mm)
>  		return walk_kernel_page_table_range(start, end, ops,
> @@ -700,16 +712,6 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>  	if (!check_ops_safe(ops))
>  		return -EINVAL;
>  
> -	/*
> -	 * The mmap lock protects the page walker from changes to the page
> -	 * tables during the walk.  However a read lock is insufficient to
> -	 * protect those areas which don't have a VMA as munmap() detaches
> -	 * the VMAs before downgrading to a read lock and actually tearing
> -	 * down PTEs/page tables. In which case, the mmap write lock should
> -	 * be held.
> -	 */
> -	mmap_assert_write_locked(mm);
> -
>  	return walk_pgd_range(start, end, &walk);
>  }
>  
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1afca3568b9b..9d0f1fdd6af3 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -43,6 +43,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/shmparam.h>
>  #include <linux/page_owner.h>
> +#include <linux/cleanup.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/vmalloc.h>
> @@ -158,10 +159,25 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	if (!IS_ALIGNED(phys_addr, PMD_SIZE))
>  		return 0;
>  
> -	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
> -		return 0;
> +	if (!pmd_present(*pmd))
> +		return pmd_set_huge(pmd, phys_addr, prot);
>  
> -	return pmd_set_huge(pmd, phys_addr, prot);
> +	/*
> +	 * Kernel page table walkers either walk ranges they own exclusively
> +	 * using the mmap lock for mutual exclusion, or hold the mmap write lock
> +	 * on init_mm (ptdump being the motivating case).
> +	 *
> +	 * Therefore, acquire the mmap read lock to prevent use-after-free when
> +	 * freeing page tables.
> +	 */
> +#ifndef CONFIG_ARM64
> +	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
> +#endif
> +	{
> +		if (!pmd_free_pte_page(pmd, addr))
> +			return 0;
> +		return pmd_set_huge(pmd, phys_addr, prot);
> +	}
>  }
>  
Note that we do not need to take the lock around pmd_set_huge - we don't
care if ptdump observes a temporarily cleared pmd entry. So how about keeping
this outside the guard block. Otherwise right now we have an inconsistency:
for !pmd_present() we do pmd_set_huge() without locking, but for pmd_present()
we do pmd_set_huge() with locking.



