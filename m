Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A03EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB106B00A6; Wed,  1 Jul 2026 01:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074CB6B00A8; Wed,  1 Jul 2026 01:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59226B00A9; Wed,  1 Jul 2026 01:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B025D6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:42:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B7FEA021E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:42:26 +0000 (UTC)
X-FDA: 84939112692.11.550BEEA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 06B061C0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:42:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fjUXTQia;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782884544;
	b=j20WRU43a+vlNA0s1jwzUDCMA4bYsfjz0u5lWr2zRZv8fj5RqownM7dZy37+SYFzaRaHVr
	dMMIPkBKjMpa1UD2xdcMOPPICtyz1ojoIWmRKNijFy5O7FEArEAhG+hAt5L3fARHjmbnHd
	RaE+lhSbP85ZBRN+DxEId7aO7nVIvQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782884544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFkLokAplxEZbHSKyTCHmE1arb+1XgTRtTxlhOGqFac=;
	b=qJ8KoBdcH1SIHhNN36n7bqssvt3uzPMhb83tSke6P+mW1VypuvN80itdhFSj7C2CfIKItF
	HZJFexxWCOPdufLo8eGxCiTNoWDU3ZQakiHN2gYWj5+PzZFMB1fW94HwILuVqgx4H7p8TI
	KlMz5iiaINYxVdSKG8R5VYSq9ICHX/g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fjUXTQia;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AA8E2364;
	Tue, 30 Jun 2026 22:42:18 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C7323F905;
	Tue, 30 Jun 2026 22:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782884542; bh=Hn1g9R5Z8hjvzBeDVB/yavX32Z5EEPqnLXM9LxfbYXs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fjUXTQiaDXQglJl+QbVZ1KookWSK/G4jH25RrXefdflAm8CZr794+g3Q4iWKdI5U6
	 ecLhnqfBX6W+wI55G6PM8/w71uMaFj3z2LLCWYuhXWxUM0IUXUGEosOHXSz8GUS16/
	 gpvS10NvVNYdmrIg4OKNDJw7X73F7LCmumHHOLjw=
Message-ID: <c3ea35e4-833f-487f-8a8b-6f8f95b7ba95@arm.com>
Date: Wed, 1 Jul 2026 11:12:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: pgtable: free kernel page tables via RCU to fix
 ptdump UAF
To: David Carlier <devnexen@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20260630041012.5975-1-devnexen@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260630041012.5975-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: phqcrnync8k16bnb7s96sn8978jge5kr
X-Rspamd-Queue-Id: 06B061C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782884543-802800
X-HE-Meta: U2FsdGVkX1+S2k/InTl50hcNa7r4jVFfFhNYLLM0IesCgFwJPcJntCGyUHxhi1g/jIt6Ks6zgUahx0mPtpvhiTATI/KEQfmhIRBGMizLzH2lZ56wDHFZZknlz3UWv97Cv4P8/0WMtZ5HljPViv23AZctp8wXQBFkBfEDQwG84//OCQKbX/XEwfWK6etm9735VYx6eCUfsMinWqqnBNOQ+oDTGcfqJ30pSpcNPpcl7F0i/Iw3a96wvwxCk08fxRG3YW0XJqY9sRHtA11oQQpsOW0CwSHMcNXawWXGrzr9FO4pelIXX6eU3GLJ4oPAapEMGOeVR73nrT3vuYpACjkk0MGfPd+eUYsuzU8RzL6xpmszoH4SWt5/gIRODtDCqFihpiFEVZdmGIEFLqXSM2KXNmopGZboqY+oS0qbRR0bme3EMZvhZnFOSF+TBehr7LgEXy4AiHzCKFaB96BXTk2MF4uoZlUkLpOuksED6IsWdYBeyteFhciW8qBWd+XOr8HNHeXGVT/ogv6KD33DQvNOom37R7h/El7gb9FXlKBPHWBp7F8BwJSme5/OyauxGbU3IBE5qhHkYCQOu6ef1pRYwMafphAjtwQ4aVSz6tf/qQ9VSVILAwnTvML/VKOqCSaQ8GYkvYXNcPnIZGSoq757+xyPfkra6YqfmwW9XOUU4ORkQzmGKSxvJVNY5b18EnuO8fJivf1ptYHQeDU3fGNYZcPDFYI0ZuWdhugVZdsBbENlY/njK/JI7PqaRTNssfdutoCH9OAplcjwnOFemkBhUWKZNxrSUolv3MoobJTXyfxxtRa6CL+QblatEUTqaban9PYQP8/neFVb+AJAsfRC+jbp6JLayVJR2lExyyVGPDV/G42n3z6DdhbwCH42sb/Pz6+vpwHfiyjxOukm/ANOihldN56COJW4GJDfwX5dkaO3jUobU0wsKa2GGjxHTgnfGXH3DH6AA2JoSLd2eN2
 FtpgbnS5
 VSgoO1M0jB08sR/beWXzJqiY3Yj44gT7ITC0rud0qZNdGq4EjIpqveIT5Ws/U0BnqvplPgS11Iup7KTjzsFSp0pyT0/yVe9Nm13MFPA4Y57rvWoIVkKDF1kn+hSpkC1+uWfwswL9SKPYpJSK+VDN9hCYmYnuFaFXbo2M0RuzyPCJoHkuw6IlHhuWA2eBDgKDiPgfykc0RERik8ABnq1gh48zA2EZCeqoJXnGMxNv1YZrErxr09rcKPjDE6bbPPu/5qT9DIC0c7C4q3lXyo0t6SNF5IZT0zN7RMV/pC3jkjQnr96Pow3aGkTo/bLvLiuLhI8QCpXLo9RxZW6x6uc/8gpOTDCZB8kpc++R5t0QhZnyUgTtut8saRDZwcMJ33jHpuWprQqlJ40fxYHsF7pENg6uu+YT8nbiLG+QbdmZGtMAcCi5I7QXH5HCEugTmJskdUAYbeK/oV+k/YBGV2hZlTAtz5vVsP+AeGtJUNyUcnklhexbs2J3+cfAZ1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/06/26 9:40 am, David Carlier wrote:
> ptdump_walk_pgd() walks the kernel page tables under get_online_mems() and
> mmap_write_lock(&init_mm). Neither lock stops vmalloc from freeing a kernel
> PTE page underneath the walk.
> 
> When vmap_try_huge_pmd() promotes a range to a huge PMD it collapses the
> existing PTE table and frees it via pmd_free_pte_page(). On x86, riscv and
> powerpc this runs without the init_mm mmap lock; only arm64 takes it, and not
> on the block-split path. So ptdump can dereference a just-freed PTE page,
> which is the use after free syzbot hit in ptdump_pte_entry().
> 
> The race is not new. ptdump walks the whole kernel address space, including
> ranges other code is actively mapping, so it reads page tables it does not
> own. 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> only widened the window; the Fixes tag points there for that reason.
> 
> Every other walker works on a range it owns and is the only one mutating it:
> set_memory() on arm64/riscv/loongarch, the arm64 block-split path, the
> openrisc DMA path and the hugetlb_vmemmap remap. Nothing frees those ranges
> concurrently, so they cannot race and do not need RCU. ptdump is the only
> walker that traverses ranges it does not own.
> 
> Defer the free by an RCU grace period. pagetable_free_kernel() now frees via
> call_rcu() in both the async and non-async configs. The async path still
> flushes the TLB first, then queues the per-page RCU free. The page stays
> valid until any walk that may have observed it drops its RCU read lock.
> 
> On the read side ptdump_walk_pgd() takes the RCU read lock around the walk,
> and walk_page_range_debug() asserts it with RCU_LOCKDEP_WARN() for the
> init_mm case rather than taking it, matching pagewalk.c convention. A walker
> either sees the cleared PMD and skips, or keeps the page alive until it drops
> the lock. The owned-range walkers are unchanged.
> 
> ptdump callbacks now run under RCU, so they must not sleep. The arch
> note_page() and effective_prot() callbacks only format into the preallocated
> seq_file buffer, and the walker does not call cond_resched(); the only
> GFP_KERNEL marker setup runs before the walk.
> 
> Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---

Thanks.

Is my assessment correct that this patch deems commit fa93b45fd397
("arm64: Enable vmalloc-huge with ptdump") redundant? (in which
case I can send a partial revert for that)


> v5: reframe changelog around the pre-existing race and range ownership;
>     correct the mmap-lock description (arm64 is the exception, not x86);
>     move rcu_read_lock() into ptdump_walk_pgd() and assert it in
>     walk_page_range_debug(); drop walk_kernel_page_table_range_rcu(); fix the
>     pgtable-generic.c comment; document the no-sleep audit of the callbacks.
> v4: defer the free in both the async and non async configs, not just
>     the async one. Move the walk under a named
>     walk_kernel_page_table_range_rcu() helper instead of open coding
>     rcu_read_lock() in walk_page_range_debug().
> v3: take rcu_read_lock() in the init_mm branch of
>     walk_page_range_debug() rather than inside the lockless walker,
>     which the arm64 split paths also use with GFP_PGTABLE_KERNEL and
>     can sleep.
> v2: use call_rcu() instead of synchronize_rcu().
> ---
>  include/linux/mm.h   |  7 -------
>  mm/pagewalk.c        | 14 +++++++++-----
>  mm/pgtable-generic.c | 22 +++++++++++++++++++++-
>  mm/ptdump.c          |  2 ++
>  4 files changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..79408a17a1b0 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3695,14 +3695,7 @@ static inline void __pagetable_free(struct ptdesc *pt)
>  	__free_pages(page, compound_order(page));
>  }
>  
> -#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
>  void pagetable_free_kernel(struct ptdesc *pt);
> -#else
> -static inline void pagetable_free_kernel(struct ptdesc *pt)
> -{
> -	__pagetable_free(pt);
> -}
> -#endif
>  /**
>   * pagetable_free - Free pagetables
>   * @pt:	The page table descriptor
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 3ae2586ff45b..c0be87580989 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -620,7 +620,7 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
>   * Note: Be careful to walk the kernel pages tables, the caller may be need to
>   * take other effective approaches (mmap lock may be insufficient) to prevent
>   * the intermediate kernel page tables belonging to the specified address range
> - * from being freed (e.g. memory hot-remove).
> + * from being freed (e.g. memory hot-remove, vmap huge page promotion).
>   */
>  int walk_kernel_page_table_range(unsigned long start, unsigned long end,
>  		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
> @@ -643,7 +643,7 @@ int walk_kernel_page_table_range(unsigned long start, unsigned long end,
>   * Use this function to walk the kernel page tables locklessly. It should be
>   * guaranteed that the caller has exclusive access over the range they are
>   * operating on - that there should be no concurrent access, for example,
> - * changing permissions for vmalloc objects.
> + * changing permissions for vmalloc objects, or vmap huge page promotion.
>   */
>  int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end,
>  		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
> @@ -692,9 +692,13 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
>  	};
>  
>  	/* For convenience, we allow traversal of kernel mappings. */
> -	if (mm == &init_mm)
> -		return walk_kernel_page_table_range(start, end, ops,
> -						    pgd, private);
> +	if (mm == &init_mm) {
> +		RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
> +				 "RCU read lock must be held across kernel page table walk");
> +		return walk_kernel_page_table_range(start, end, ops, pgd,
> +							private);
> +	}
> +
>  	if (start >= end || !walk.mm)
>  		return -EINVAL;
>  	if (!check_ops_safe(ops))
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index b91b1a98029c..7a32e4821957 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -410,6 +410,13 @@ pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
>  	goto again;
>  }
>  
> +static void kernel_pgtable_free_rcu(struct rcu_head *head)
> +{
> +	struct ptdesc *pt = container_of(head, struct ptdesc, pt_rcu_head);
> +
> +	__pagetable_free(pt);
> +}
> +
>  #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
>  static void kernel_pgtable_work_func(struct work_struct *work);
>  
> @@ -434,8 +441,15 @@ static void kernel_pgtable_work_func(struct work_struct *work)
>  	spin_unlock(&kernel_pgtable_work.lock);
>  
>  	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
> +
> +	/*
> +	 * Debug walkers (ptdump) may walk ranges they do not own and race this
> +	 * free, so they walk under rcu_read_lock(). Free after a grace period:
> +	 * a walker either already saw the cleared PMD, or keeps the page alive
> +	 * until it drops the RCU lock.
> +	 */
>  	list_for_each_entry_safe(pt, next, &page_list, pt_list)
> -		__pagetable_free(pt);
> +		call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
>  }
>  
>  void pagetable_free_kernel(struct ptdesc *pt)
> @@ -446,4 +460,10 @@ void pagetable_free_kernel(struct ptdesc *pt)
>  
>  	schedule_work(&kernel_pgtable_work.work);
>  }
> +#else
> +void pagetable_free_kernel(struct ptdesc *pt)
> +{
> +	/* Defer the free by a grace period; see kernel_pgtable_work_func(). */
> +	call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
> +}
>  #endif
> diff --git a/mm/ptdump.c b/mm/ptdump.c
> index 973020000096..50cd96a33dfd 100644
> --- a/mm/ptdump.c
> +++ b/mm/ptdump.c
> @@ -178,11 +178,13 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
>  
>  	get_online_mems();
>  	mmap_write_lock(mm);

mmap write lock is not required anymore no?


> +	rcu_read_lock();

Is there a possibility of RCU stall here? For example a system with
lots of physical memory will have a huge linear map.

>  	while (range->start != range->end) {
>  		walk_page_range_debug(mm, range->start, range->end,
>  				      &ptdump_ops, pgd, st);
>  		range++;
>  	}
> +	rcu_read_unlock();
>  	mmap_write_unlock(mm);
>  	put_online_mems();
>  


