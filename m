Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114A5CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5096B0088; Tue, 12 May 2026 06:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295446B008A; Tue, 12 May 2026 06:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1840F6B008C; Tue, 12 May 2026 06:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 069B56B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:10:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A01168CC97
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:10:46 +0000 (UTC)
X-FDA: 84758348892.30.2362F1D
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CB4CA0008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:10:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CLTBUa70;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778580645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhNXofBJzMZ4LJ0hPZudDkIz4qghFLBmis7XZf0b3lc=;
	b=iwFHHIR+9bt5K0iz75nYtYiF3MuqX6Bi/Ea1JTwywEra5fNnXdCh0kzIE6e9yOsnmSjyVo
	gyrlRlusZjWBg9JEuNOA9pIYdhY40Jc647MoPQr1olACP0A+LY6ZmDvqGxcmNAEOD4Vp+8
	2cLVwyg6+tEnwMJehLp41IUBgjqTS40=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CLTBUa70;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778580645; a=rsa-sha256;
	cv=none;
	b=SiTxzxbSspTmMf+U/TkRdhF/86VMl/x+ZBtIcux5SMR1rG6rMzhmU3PvRzsoowbPPs0UAC
	akN5CYameqtI36CxQVaB5+iazbpZGBCnQd3nrkRsJRV0X8/lhJVnG3Udv7+ZPo4JaowW8K
	zOjXUd2M6LCGM8rQDzV3cMPGXAK1jZk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778580637; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VhNXofBJzMZ4LJ0hPZudDkIz4qghFLBmis7XZf0b3lc=;
	b=CLTBUa70abtciVrBaCuWKtyv0llhvUvttZDSfQ3l1r2akWB88Wm0RuFuFbmrYMAOQrsF9BU9gkKha8EnPRR6F+JIi/5tG+QZahhPZMBvMCmMSHHe8GGqHvgxDuZGMcAekEEJTMMfVXR8COJUTlsHAw05ycwyCptHmuDW2DZ05xk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X2qAZik_1778580633;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2qAZik_1778580633 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 18:10:34 +0800
Message-ID: <d5341d37-5644-4446-a406-9a7251b83399@linux.alibaba.com>
Date: Tue, 12 May 2026 18:10:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/12] mm, swap: unify large folio allocation
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260421-swap-table-p4-v3-5-2f23759a76bc@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CB4CA0008
X-Stat-Signature: j9rgcfxhf3ruumfpc5peahemidj9mjgp
X-HE-Tag: 1778580641-479487
X-HE-Meta: U2FsdGVkX1+kG/Qdq2j54K6iBC6ezOQuR4buUpW/fl0NlONa8LnXpAMQ3gStzufkCCt0vAnNW7lYrkwlakgQ4ziWS77Ef9fy4ypP43i/exzPICNIQ/fodZdKhMuCukFnCnuYYS+uEbIoQHwx+GgvtH0lfrevkGQ75y9KwOiOmOLv+mEUd4PVUaHkYv06sFef8dR3a9ryCdsJK1Dk54LGFyo9evxTboY/JcChXYp4v9gVHMxVT5oRgRwGiTeTv2tP/teYNvVA9eL+jWltAx3fnygoN5a4PrSutDfgLCb85jfAQWL3ofp089AWf/mPLa9CpIbPxA8XL7itAYPr53i5scNK0g/fyKoZyp+TEqfZ/qVcnYgEa966BELpTa8puGTBuGw4z3unqV8Y7T4fiAjNwStFn9+iXx9LD9kdqtQyDuSPmkBMbz2BRBlF0wwtNFkenjsQqdSCrtRYHz2adPFF3sNLnNTOV2RL3TT7MIE++JQ/+HxfbwXEHRs5HnFZS9UwGsnY7LMMqK4DdRgTj3C5rzzERdh0gm/HYIanE6TVKCx76AC7HMQVp1tm9uLoZhUdIqx+JVghjouTbh3r+OtOqSAGWiiP65gjGaGAovgEn1d1b7PrnIPdN2/PyrcGwoe/gWT/ZB+nMrancAZtVKNEY5Z2oWB0KTOPiXCdnaqGo2/drcxDG4Wv9D4hxDFLTlgAN3ZvQ3MTcroeqJDao755D4KdYAC2wCMDPXiQrqr8QnA8oB+suCMaqbiQNtmoixOId4Gs4Gr/DBJ99N0ElBlwRw5OcKcyWftCw35rriVg6k+Ur4Ezhja5V/J7ltSylELZlr9LG/DWJcrSOtLyhzB9vQycBLnQ+CdmjXNAlIwkahNYehEPdRJVuUAPfhl+CvR+mQjrvid9SNUq6iFILyBh+4/Y3dcy1O49RLtJQErtXK3Hn1iXtSjd1WMXEyaEC2EPJERE2B5Z0Msuy2oZOCm
 wK02qmZN
 c4jDVFA1cqJJ+T22R0UzXx9ixwQrzOGlwPhxnuvXYCS+PL7tmQpLALQYVKWXE6drnBeAIMQnKbGgUDEn3PVmPdHoAioSJEziqjYLklZ3jbhF5m/JBi9FPSeHeN1f0UkthuPNQnYRT1XtsqZ2iWrcOqUi/DN/v8kU6venOf6awLqTqy7AIR49ye2stgQYP/4M7fk7M8kNSEmBGb9CzNzITQya5XOVI3+qoDlEMfYSp6mAuEKDeEmnQBvVqw1FIHYO6w8jB9mh4HxGiL+/E5arxSM8UUV557ZiZgnRxM660rJs9pxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/21/26 2:16 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Now that direct large order allocation is supported in the swap cache,
> both anon and shmem can use it instead of implementing their own methods.
> This unifies the fallback and swap cache check, which also reduces the
> TOCTOU race window of swap cache state: previously, high order swapin
> required checking swap cache states first, then allocating and falling
> back separately. Now all these steps happen in the same compact loop.
> 
> Order fallback and statistics are also unified, callers just need to
> check and pass the acceptable order bitmask.
> 
> There is basically no behavior change. This only makes things more
> unified and prepares for later commits. Cgroup and zero map checks can
> also be moved into the compact loop, further reducing race windows and
> redundancy
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/memory.c     |  77 ++++++------------------------
>   mm/shmem.c      |  94 +++++++++---------------------------
>   mm/swap.h       |  30 ++----------
>   mm/swap_state.c | 145 ++++++++++----------------------------------------------
>   mm/swapfile.c   |   3 +-
>   5 files changed, 67 insertions(+), 282 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..404734a5bcff 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4593,26 +4593,6 @@ static vm_fault_t handle_pte_marker(struct vm_fault *vmf)
>   	return VM_FAULT_SIGBUS;
>   }
>   
> -static struct folio *__alloc_swap_folio(struct vm_fault *vmf)
> -{
> -	struct vm_area_struct *vma = vmf->vma;
> -	struct folio *folio;
> -	softleaf_t entry;
> -
> -	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vmf->address);
> -	if (!folio)
> -		return NULL;
> -
> -	entry = softleaf_from_pte(vmf->orig_pte);
> -	if (mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
> -					   GFP_KERNEL, entry)) {
> -		folio_put(folio);
> -		return NULL;
> -	}
> -
> -	return folio;
> -}
> -
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   /*
>    * Check if the PTEs within a range are contiguous swap entries
> @@ -4642,8 +4622,6 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
>   	 */
>   	if (unlikely(swap_zeromap_batch(entry, nr_pages, NULL) != nr_pages))
>   		return false;
> -	if (unlikely(non_swapcache_batch(entry, nr_pages) != nr_pages))
> -		return false;
>   
>   	return true;
>   }
> @@ -4671,16 +4649,14 @@ static inline unsigned long thp_swap_suitable_orders(pgoff_t swp_offset,
>   	return orders;
>   }
>   
> -static struct folio *alloc_swap_folio(struct vm_fault *vmf)
> +static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
>   {
>   	struct vm_area_struct *vma = vmf->vma;
>   	unsigned long orders;
> -	struct folio *folio;
>   	unsigned long addr;
>   	softleaf_t entry;
>   	spinlock_t *ptl;
>   	pte_t *pte;
> -	gfp_t gfp;
>   	int order;
>   
>   	/*
> @@ -4688,7 +4664,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>   	 * maintain the uffd semantics.
>   	 */
>   	if (unlikely(userfaultfd_armed(vma)))
> -		goto fallback;
> +		return 0;
>   
>   	/*
>   	 * A large swapped out folio could be partially or fully in zswap. We
> @@ -4696,7 +4672,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>   	 * folio.
>   	 */
>   	if (!zswap_never_enabled())
> -		goto fallback;
> +		return 0;
>   
>   	entry = softleaf_from_pte(vmf->orig_pte);
>   	/*
> @@ -4710,12 +4686,12 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>   					  vmf->address, orders);
>   
>   	if (!orders)
> -		goto fallback;
> +		return 0;
>   
>   	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
>   				  vmf->address & PMD_MASK, &ptl);
>   	if (unlikely(!pte))
> -		goto fallback;
> +		return 0;
>   
>   	/*
>   	 * For do_swap_page, find the highest order where the aligned range is
> @@ -4731,29 +4707,12 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>   
>   	pte_unmap_unlock(pte, ptl);
>   
> -	/* Try allocating the highest of the remaining orders. */
> -	gfp = vma_thp_gfp_mask(vma);
> -	while (orders) {
> -		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> -		folio = vma_alloc_folio(gfp, order, vma, addr);
> -		if (folio) {
> -			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
> -							    gfp, entry))
> -				return folio;
> -			count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> -			folio_put(folio);
> -		}
> -		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> -		order = next_order(&orders, order);
> -	}
> -
> -fallback:
> -	return __alloc_swap_folio(vmf);
> +	return orders;
>   }
>   #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
> -static struct folio *alloc_swap_folio(struct vm_fault *vmf)
> +static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
>   {
> -	return __alloc_swap_folio(vmf);
> +	return 0;
>   }
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> @@ -4859,21 +4818,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>   	if (folio)
>   		swap_update_readahead(folio, vma, vmf->address);
>   	if (!folio) {
> -		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
> -			folio = alloc_swap_folio(vmf);
> -			if (folio) {
> -				/*
> -				 * folio is charged, so swapin can only fail due
> -				 * to raced swapin and return NULL.
> -				 */
> -				swapcache = swapin_folio(entry, folio);
> -				if (swapcache != folio)
> -					folio_put(folio);
> -				folio = swapcache;
> -			}
> -		} else {
> +		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
> +		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> +			folio = swapin_entry(entry, GFP_HIGHUSER_MOVABLE,
> +					     thp_swapin_suitable_orders(vmf),
> +					     vmf, NULL, 0);
> +		else
>   			folio = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE, vmf);
> -		}
>   
>   		if (!folio) {
>   			/*
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5916acf594a8..17e3da11bb1d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -159,7 +159,7 @@ static unsigned long shmem_default_max_inodes(void)
>   
>   static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   			struct folio **foliop, enum sgp_type sgp, gfp_t gfp,
> -			struct vm_area_struct *vma, vm_fault_t *fault_type);
> +			struct vm_fault *vmf, vm_fault_t *fault_type);
>   
>   static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
>   {
> @@ -2017,68 +2017,24 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>   }
>   
>   static struct folio *shmem_swap_alloc_folio(struct inode *inode,
> -		struct vm_area_struct *vma, pgoff_t index,
> +		struct vm_fault *vmf, pgoff_t index,
>   		swp_entry_t entry, int order, gfp_t gfp)
>   {
> +	pgoff_t ilx;
> +	struct folio *folio;
> +	struct mempolicy *mpol;
> +	unsigned long orders = BIT(order);
>   	struct shmem_inode_info *info = SHMEM_I(inode);
> -	struct folio *new, *swapcache;
> -	int nr_pages = 1 << order;
> -	gfp_t alloc_gfp = gfp;
> -
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> -		if (WARN_ON_ONCE(order))
> -			return ERR_PTR(-EINVAL);
> -	} else if (order) {
> -		/*
> -		 * If uffd is active for the vma, we need per-page fault
> -		 * fidelity to maintain the uffd semantics, then fallback
> -		 * to swapin order-0 folio, as well as for zswap case.
> -		 * Any existing sub folio in the swap cache also blocks
> -		 * mTHP swapin.
> -		 */
> -		if ((vma && unlikely(userfaultfd_armed(vma))) ||
> -		     !zswap_never_enabled() ||
> -		     non_swapcache_batch(entry, nr_pages) != nr_pages)
> -			goto fallback;
>   
> -		alloc_gfp = thp_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
> -	}
> -retry:
> -	new = shmem_alloc_folio(alloc_gfp, order, info, index);
> -	if (!new) {
> -		new = ERR_PTR(-ENOMEM);
> -		goto fallback;
> -	}
> +	if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
> +	     !zswap_never_enabled())
> +		orders = 0;
>   
> -	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
> -					   alloc_gfp, entry)) {
> -		folio_put(new);
> -		new = ERR_PTR(-ENOMEM);
> -		goto fallback;
> -	}
> +	mpol = shmem_get_pgoff_policy(info, index, order, &ilx);
> +	folio = swapin_entry(entry, gfp, orders, vmf, mpol, ilx);
> +	mpol_cond_put(mpol);
>   
> -	swapcache = swapin_folio(entry, new);
> -	if (swapcache != new) {
> -		folio_put(new);
> -		if (!swapcache) {
> -			/*
> -			 * The new folio is charged already, swapin can
> -			 * only fail due to another raced swapin.
> -			 */
> -			new = ERR_PTR(-EEXIST);
> -			goto fallback;
> -		}
> -	}
> -	return swapcache;
> -fallback:
> -	/* Order 0 swapin failed, nothing to fallback to, abort */
> -	if (!order)
> -		return new;
> -	entry.val += index - round_down(index, nr_pages);
> -	alloc_gfp = gfp;
> -	nr_pages = 1;
> -	order = 0;
> -	goto retry;
> +	return folio;
>   }

IIUC, in the __swap_cache_alloc() implementation in patch 4, when shmem 
swapin falls back to order 0, it doesn't adjust the swap entry value 
like here. Because the original swap entry may not correspond to the 
swap entry for the order 0 index.

Of course, I haven't tested this yet, just pointing it out for you to 
double check.

