Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C89DCD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8896B0088; Wed, 13 May 2026 21:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199D76B008A; Wed, 13 May 2026 21:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFCD6B008C; Wed, 13 May 2026 21:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEEC46B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:30:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C15F1A0234
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:30:18 +0000 (UTC)
X-FDA: 84764294916.03.2A7969A
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf25.hostedemail.com (Postfix) with ESMTP id 16770A000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:30:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V2XoUq65;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778722216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPUnOzhXDvJECTdzvl+JQVf7/fcb7TGaIsHe9vA4Gaw=;
	b=Q7X2TLK79vh8b3jbwaoMD4CGw4RdFCW60la+KYjAbAXoHkFhnNn0RWnBpeoyGUgxckNCii
	rfZpRVVoSloBkp8+KrwP+PcgNZyTfjwLzbKGoSrC22uX60yxAIZXGq9LNAmdaSrANObSl9
	GFKCQ9/+hMvBYxhkOsBl1Do6jbMuDVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778722216; a=rsa-sha256;
	cv=none;
	b=ikAA4KmXMp/J3q/OGE3NX39eoBBZKsZHf5Z5uRX6xdTAgMoD/S52GxDBO+rknhye1w/hj1
	quxiZ1X+faY5bP9BkA+g/25wSPYejc383QlGW20G9SGbqn9pDnhzWKrQtk6Rd6mCaCEo0w
	Nl292U6bkctkaZHI1/DakrDLv1i3814=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V2XoUq65;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778722212; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CPUnOzhXDvJECTdzvl+JQVf7/fcb7TGaIsHe9vA4Gaw=;
	b=V2XoUq65TSuZ4ZYbnnHLPsbPvsh0oEOPSxEo3w2r3gWsMrdSh4GlRfhfWkF0FVW5TtxcuxuJee2K8reZq4+mmV6dGEPbYaCuxxu7SYRIeoIpTN54AJpG7yVw452AIfZiE68rrficOWluAJztMrIGDQWfBSjk/yDu+/gL4e7XFss=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X2vCe.v_1778722209;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2vCe.v_1778722209 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 May 2026 09:30:10 +0800
Message-ID: <e6b8a27b-afd2-4004-9393-687ba8796188@linux.alibaba.com>
Date: Thu, 14 May 2026 09:30:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/12] mm, swap: unify large folio allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Michal Hocko <mhocko@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-5-2f23759a76bc@tencent.com>
 <d5341d37-5644-4446-a406-9a7251b83399@linux.alibaba.com>
 <CAMgjq7CPDk4hP-5hnV4Bth523W_Z+9hvg7Wo_upE-5rYCA0Mpw@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7CPDk4hP-5hnV4Bth523W_Z+9hvg7Wo_upE-5rYCA0Mpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 16770A000A
X-Stat-Signature: fz4yune46ia6aje475g46u3one3hfn76
X-Rspam-User: 
X-HE-Tag: 1778722214-966790
X-HE-Meta: U2FsdGVkX181LQt1EtwMNh0jidT3aEAdqCwho2Ttz83cdM5jZfQodWZ7I7kNBWPtAj9Wdtp3XXM0m5sbOpEpMwGqddR+2KxzV8JPm5yAsbdCOTJDuABHL8NuNQbjpCGpD/Er8qFc78rw69QMZnkr9A9i6D1yAPF0GKgZrtoW9OPybF8ZOQQ2PI6aAiYtcDU0UslExKPfRRSTKUa5/hXab8kpSvmPDsW0B5U66AWF74ZU2VcjnUB/ZNfOSgJ6KRWW/K2ADR/JzTISqTtzbb/0A+PRbdwcKMA1KHa+Yfn/ZHJk1aFtPWiF7JUCt+1VgIOGuHx5C0oY+SPBYqCeUyR42oM6uG1GRkOKyAVPc7oRQLoXnXy0feCiXwd35D5azlXcfZSi+7Q4H2gMc8yUqq9xlSsJ9AVPu3CVs9ydOZr+Wze9s1PyYAzlsPl7jJ8iaby4OlvQXSVBvbiIISjBQkIZqxKZMB2ZxKbwlnf9azPR8euq/BjwoR1oWxighHPJtXN47hQcgdFlPry2zVydtyi9vXdWzFzxP+5FH9YbOndGgJ+sl2JgSHCLQXxkuk3PtFnvFkDDsZ8n2oyM1StGOMV+BUqAloNlZXXNWeTPyhXGYToeQj6LHH4WWA0DbEaqQJUS3SOar1l5XncKQOteJvA6sWS6a7gxm95USPnHWOJl0J6ZYFjHc2Bpd5ihgNJvkmMTEaupvwyIW0oKMcSBHOP7LXR9kCLtDCM6SnzTeDosIzi3zr4MSYr8Lt6+iOgpvZwzcjuz+bELjdQkNJvMpVladRrq5+uCgf4ghtMvID+GkkYeLSP7IIg76S1LSImKw2TIdU/ubQ3KTwH8+c9jlzkeLYd5N72sX+7zpoewpeEE1Kr4YFkE3laHnkV+IQtukxsoptuHGVYbD6Um/wrhyXTX4oyJm6/II/lDHr66gSLU1bnypK4+Bi+9S5FKvLgV+cEpiT3Tg9EWfHGLCF3vyGf
 3FYVhAnc
 I4/DTktUqvllBv0+CPE7aubyighC2QsmIqmfBVQzZoF8AardlQGoOAyOXOYH1ogudlOahuycI8cEnJa5/922W30mdcsUkSElfQtGGsQUFxQGcG27S0UEwEx8zGl1lFi0DRZgQxz+3B0w/sY1OOOF1MITXckO5GhCtMm8k7PJnmomOlTM7kbZLvM0/px75NPVEWWcR7Yq2Qv7uYxFDg9v44qnnq0/oXyN/B517EIGEPR2n23Kg2owYWjx6LhfJtxCHWYkNQu/Y+3zL5rkmOteYit4cLmb+D3rR3GD6coU63LJFm424DYmCQmoQEjUWZWSjb6ai48Skcg+9YALu4dZIFr6BCEtyLd1jvvoD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/13/26 2:47 PM, Kairui Song wrote:
> On Tue, May 12, 2026 at 6:14 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> On 4/21/26 2:16 PM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Now that direct large order allocation is supported in the swap cache,
>>> both anon and shmem can use it instead of implementing their own methods.
>>> This unifies the fallback and swap cache check, which also reduces the
>>> TOCTOU race window of swap cache state: previously, high order swapin
>>> required checking swap cache states first, then allocating and falling
>>> back separately. Now all these steps happen in the same compact loop.
>>>
>>> Order fallback and statistics are also unified, callers just need to
>>> check and pass the acceptable order bitmask.
>>>
>>> There is basically no behavior change. This only makes things more
>>> unified and prepares for later commits. Cgroup and zero map checks can
>>> also be moved into the compact loop, further reducing race windows and
>>> redundancy
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>    mm/memory.c     |  77 ++++++------------------------
>>>    mm/shmem.c      |  94 +++++++++---------------------------
>>>    mm/swap.h       |  30 ++----------
>>>    mm/swap_state.c | 145 ++++++++++----------------------------------------------
>>>    mm/swapfile.c   |   3 +-
>>>    5 files changed, 67 insertions(+), 282 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index ea6568571131..404734a5bcff 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4593,26 +4593,6 @@ static vm_fault_t handle_pte_marker(struct vm_fault *vmf)
>>>        return VM_FAULT_SIGBUS;
>>>    }
>>>
>>> -static struct folio *__alloc_swap_folio(struct vm_fault *vmf)
>>> -{
>>> -     struct vm_area_struct *vma = vmf->vma;
>>> -     struct folio *folio;
>>> -     softleaf_t entry;
>>> -
>>> -     folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vmf->address);
>>> -     if (!folio)
>>> -             return NULL;
>>> -
>>> -     entry = softleaf_from_pte(vmf->orig_pte);
>>> -     if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
>>> -                                        GFP_KERNEL, entry)) {
>>> -             folio_put(folio);
>>> -             return NULL;
>>> -     }
>>> -
>>> -     return folio;
>>> -}
>>> -
>>>    #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>    /*
>>>     * Check if the PTEs within a range are contiguous swap entries
>>> @@ -4642,8 +4622,6 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
>>>         */
>>>        if (unlikely(swap_zeromap_batch(entry, nr_pages, NULL) != nr_pages))
>>>                return false;
>>> -     if (unlikely(non_swapcache_batch(entry, nr_pages) != nr_pages))
>>> -             return false;
>>>
>>>        return true;
>>>    }
>>> @@ -4671,16 +4649,14 @@ static inline unsigned long thp_swap_suitable_orders(pgoff_t swp_offset,
>>>        return orders;
>>>    }
>>>
>>> -static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>> +static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
>>>    {
>>>        struct vm_area_struct *vma = vmf->vma;
>>>        unsigned long orders;
>>> -     struct folio *folio;
>>>        unsigned long addr;
>>>        softleaf_t entry;
>>>        spinlock_t *ptl;
>>>        pte_t *pte;
>>> -     gfp_t gfp;
>>>        int order;
>>>
>>>        /*
>>> @@ -4688,7 +4664,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>>         * maintain the uffd semantics.
>>>         */
>>>        if (unlikely(userfaultfd_armed(vma)))
>>> -             goto fallback;
>>> +             return 0;
>>>
>>>        /*
>>>         * A large swapped out folio could be partially or fully in zswap. We
>>> @@ -4696,7 +4672,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>>         * folio.
>>>         */
>>>        if (!zswap_never_enabled())
>>> -             goto fallback;
>>> +             return 0;
>>>
>>>        entry = softleaf_from_pte(vmf->orig_pte);
>>>        /*
>>> @@ -4710,12 +4686,12 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>>                                          vmf->address, orders);
>>>
>>>        if (!orders)
>>> -             goto fallback;
>>> +             return 0;
>>>
>>>        pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>>>                                  vmf->address & PMD_MASK, &ptl);
>>>        if (unlikely(!pte))
>>> -             goto fallback;
>>> +             return 0;
>>>
>>>        /*
>>>         * For do_swap_page, find the highest order where the aligned range is
>>> @@ -4731,29 +4707,12 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>>
>>>        pte_unmap_unlock(pte, ptl);
>>>
>>> -     /* Try allocating the highest of the remaining orders. */
>>> -     gfp = vma_thp_gfp_mask(vma);
>>> -     while (orders) {
>>> -             addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
>>> -             folio = vma_alloc_folio(gfp, order, vma, addr);
>>> -             if (folio) {
>>> -                     if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
>>> -                                                         gfp, entry))
>>> -                             return folio;
>>> -                     count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
>>> -                     folio_put(folio);
>>> -             }
>>> -             count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
>>> -             order = next_order(&orders, order);
>>> -     }
>>> -
>>> -fallback:
>>> -     return __alloc_swap_folio(vmf);
>>> +     return orders;
>>>    }
>>>    #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
>>> -static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>>> +static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
>>>    {
>>> -     return __alloc_swap_folio(vmf);
>>> +     return 0;
>>>    }
>>>    #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>>
>>> @@ -4859,21 +4818,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>>        if (folio)
>>>                swap_update_readahead(folio, vma, vmf->address);
>>>        if (!folio) {
>>> -             if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
>>> -                     folio = alloc_swap_folio(vmf);
>>> -                     if (folio) {
>>> -                             /*
>>> -                              * folio is charged, so swapin can only fail due
>>> -                              * to raced swapin and return NULL.
>>> -                              */
>>> -                             swapcache = swapin_folio(entry, folio);
>>> -                             if (swapcache != folio)
>>> -                                     folio_put(folio);
>>> -                             folio = swapcache;
>>> -                     }
>>> -             } else {
>>> +             /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
>>> +             if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
>>> +                     folio = swapin_entry(entry, GFP_HIGHUSER_MOVABLE,
>>> +                                          thp_swapin_suitable_orders(vmf),
>>> +                                          vmf, NULL, 0);
>>> +             else
>>>                        folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
>>> -             }
>>>
>>>                if (!folio) {
>>>                        /*
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 5916acf594a8..17e3da11bb1d 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -159,7 +159,7 @@ static unsigned long shmem_default_max_inodes(void)
>>>
>>>    static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>>                        struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
>>> -                     struct vm_area_struct *vma, vm_fault_t *fault_type);
>>> +                     struct vm_fault *vmf, vm_fault_t *fault_type);
>>>
>>>    static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
>>>    {
>>> @@ -2017,68 +2017,24 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>>>    }
>>>
>>>    static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>> -             struct vm_area_struct *vma, pgoff_t index,
>>> +             struct vm_fault *vmf, pgoff_t index,
>>>                swp_entry_t entry, int order, gfp_t gfp)
>>>    {
>>> +     pgoff_t ilx;
>>> +     struct folio *folio;
>>> +     struct mempolicy *mpol;
>>> +     unsigned long orders = BIT(order);
>>>        struct shmem_inode_info *info = SHMEM_I(inode);
>>> -     struct folio *new, *swapcache;
>>> -     int nr_pages = 1 << order;
>>> -     gfp_t alloc_gfp = gfp;
>>> -
>>> -     if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>>> -             if (WARN_ON_ONCE(order))
>>> -                     return ERR_PTR(-EINVAL);
>>> -     } else if (order) {
>>> -             /*
>>> -              * If uffd is active for the vma, we need per-page fault
>>> -              * fidelity to maintain the uffd semantics, then fallback
>>> -              * to swapin order-0 folio, as well as for zswap case.
>>> -              * Any existing sub folio in the swap cache also blocks
>>> -              * mTHP swapin.
>>> -              */
>>> -             if ((vma && unlikely(userfaultfd_armed(vma))) ||
>>> -                  !zswap_never_enabled() ||
>>> -                  non_swapcache_batch(entry, nr_pages) != nr_pages)
>>> -                     goto fallback;
>>>
>>> -             alloc_gfp = thp_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
>>> -     }
>>> -retry:
>>> -     new = shmem_alloc_folio(alloc_gfp, order, info, index);
>>> -     if (!new) {
>>> -             new = ERR_PTR(-ENOMEM);
>>> -             goto fallback;
>>> -     }
>>> +     if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
>>> +          !zswap_never_enabled())
>>> +             orders = 0;
>>>
>>> -     if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
>>> -                                        alloc_gfp, entry)) {
>>> -             folio_put(new);
>>> -             new = ERR_PTR(-ENOMEM);
>>> -             goto fallback;
>>> -     }
>>> +     mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
>>> +     folio = swapin_entry(entry, gfp, orders, vmf, mpol, ilx);
>>> +     mpol_cond_put(mpol);
>>>
>>> -     swapcache = swapin_folio(entry, new);
>>> -     if (swapcache != new) {
>>> -             folio_put(new);
>>> -             if (!swapcache) {
>>> -                     /*
>>> -                      * The new folio is charged already, swapin can
>>> -                      * only fail due to another raced swapin.
>>> -                      */
>>> -                     new = ERR_PTR(-EEXIST);
>>> -                     goto fallback;
>>> -             }
>>> -     }
>>> -     return swapcache;
>>> -fallback:
>>> -     /* Order 0 swapin failed, nothing to fallback to, abort */
>>> -     if (!order)
>>> -             return new;
>>> -     entry.val += index - round_down(index, nr_pages);
>>> -     alloc_gfp = gfp;
>>> -     nr_pages = 1;
>>> -     order = 0;
>>> -     goto retry;
>>> +     return folio;
>>>    }
>>
>> IIUC, in the __swap_cache_alloc() implementation in patch 4, when shmem
>> swapin falls back to order 0, it doesn't adjust the swap entry value
>> like here. Because the original swap entry may not correspond to the
>> swap entry for the order 0 index.
>>
>> Of course, I haven't tested this yet, just pointing it out for you to
>> double check.
> 
> Thanks for pointing it out. No worry, we have the below change in this
> commit already:
> 
>                          /* Direct swapin skipping swap cache & readahead */
> -                       folio = shmem_swap_alloc_folio(inode, vma, index,
> -                                                      index_entry, order, gfp);
> -                       if (IS_ERR(folio)) {
> -                               error = PTR_ERR(folio);
> -                               folio = NULL;
> -                               goto failed;
> -                       }
> +                       folio = shmem_swap_alloc_folio(inode, vmf, index,
> +                                                      swap, order, gfp);
> 
> It's using swap instead of index_entry now, so __swap_cache_alloc will
> do the round down for large order instead and skip the round_down if
> ordedr is zero. So we are fine here.

OK. I overlooked this change here, then the shmem part looks good to me. 
I will do some testing once this patchset lands in the mm-new branch.

