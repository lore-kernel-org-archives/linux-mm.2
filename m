Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A9D1CCF9EB
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 05:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF8E8E00AC; Fri, 31 Oct 2025 01:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FEA8E0045; Fri, 31 Oct 2025 01:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A2A8E00AC; Fri, 31 Oct 2025 01:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D34FF8E0045
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:56:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DADC13A463
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:56:18 +0000 (UTC)
X-FDA: 84057349236.21.2DAD982
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf11.hostedemail.com (Postfix) with ESMTP id 237AF40006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:56:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761890176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=780NEEoCyYqY/ek37ZQ3UI3mhUtMqCohOTl5sH3G7n4=;
	b=4oBTF2bOl5Z86WxS/zJRZVL9Mk6m21cksCx8Nb42a5HPInG7eg7gKI2cu1samjL+wxBkPP
	PYa/m4AfRHmG5zbSgfcY8h9Bh5Fc/lci0JeLHazvZsC55JEtpUZxCad23j58+01Qe4ibkh
	btEsfKI8LFyHFbGPrg8sDUcXZE+Mdu8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761890176; a=rsa-sha256;
	cv=none;
	b=mBbzL629u8gEIV6GgX/9esbPG9mNqpZITXnf0qJyHiSW/fb6hDMZ8Mkn6V1cRCGt7hBQrh
	kbIXMqWPIByc9l350138vP628tXc1TTuirO8uydgbnzAxoJdhgWCVNupr5Gb/K0RZlHVl1
	JM5VjtP2143YoEt+HoPIUFrHN43TxqY=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Oct 2025 14:56:12 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 31 Oct 2025 14:56:12 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH 15/19] mm, swap: add folio to swap cache directly on
 allocation
Message-ID: <aQRPfIqCcMLyf6oX@yjaykim-PowerEdge-T330>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-15-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-swap-table-p2-v1-15-3d43f3b6ec32@tencent.com>
X-Stat-Signature: do6nqsjc4hmf5y43fcffsk4hjqnm9xje
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 237AF40006
X-HE-Tag: 1761890174-331873
X-HE-Meta: U2FsdGVkX19Y7liv+qThp00hZF2nyUK0lgL8PEvUV1gZ0XM7XHYJXM3/16S/UCm8EKflwcTiMbX6tocsYmBibDFYrDvUBOXEmZHbrKwzujpAelNDdRayM99W9gJyHxaETJiB0KelzSpND+gyBgHjkgxIkpk1jnActrpa3+GXovaETBb762jGJwNzIlZdm2O8QAvIqfT1ojRunbnuhLfhr1rCuECKIRv/OPVxs6ilE5aTcnDNTzvyT8es1RYpvJN3sKTsTh2q6Kpq6eoXHeGgquHNQsA4Z5wtkR8ep22PGa3TZsH2IsAEvhoZzBAS6vNU0+ZuO8GkvnaVrNRjyGx+1fhEBj2tUYb4t0Ye2hozsBnN8uvMFzFB1ZUGNzV5m6jEP1iFFYfYzK2DJOs/Rh4M8e/mp1Mbps4Sam2mx0mJs+Hz0rmIQ/Myq2Sn814dkT6qw7vq3VHLxvgA8iIkQGUr0D6kV3PG6fDfkie/9Kfx8YOkpl8xWuCXan87HnZXp/PhTHl4xlNcPinOaYPjwhnMMmVMbyL8CimFjG3nKkyLxSgrilwpUeTtwvyzPTF1ma64N0Ch3oi4nK1shm1kY9Dl4s6QlDBF4QYuSXBKbkCx/qCITAuu8It3hzWH9uwH6XjHS2UQnFsW9Z34c0vfemoEQQ13sAGbspQKRbCvaCCdgNGY0u1r161pW8UdHN3qBJ/Xa7xdBZmZMvigJAVtvpULYn0Tm4gqsgy6l6zSnE2dLvlvpDeW0uJkIuYiWHHxIBDYJmjVVIZDDqOAR3j1bjSSIWW0r/JnTCL+uwJ0xZwljo+M8uK51LDnnM0t4lLs9ZIDOeojJ2kgKvpSxCMr9EKuBhvT9q2GcRgu1yiIEsKcfsAQun/VqnbqCy9MRiM6jI/8GEk9hO5zMoXKX84nRlPvKGUhI14qU1VmShrHVYba5Q0LPjVh2Wt7RD1WutI7OQSSeM04nJ9bRaDxsuvELGN
 /OK8eUWc
 t6aVdJAz/O4O42Gq8+OoGJe4gyReqvY2pvFQEaoKrxkzuTBb5BHj9mgHpjpp8bEQhtHZX6RHTahO86O8bCvYxAvnj1VNE5OwzG6+eC46AqxtZWb/ZMUzMxLRE9PYabB/ywVpEXQe4HXS2aPesY4sS76mqLs42d7LDWV47oKeAlv6C25RGWEcy9T1DJHnDMIwsFkvgzhDeogFjcgbIYeway1xdpXRJBHzHgZJkcrC308P+E7E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:58:41PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>

Hello Kairui 

> The allocator uses SWAP_HAS_CACHE to pin a swap slot upon allocation.
> SWAP_HAS_CACHE is being deprecated as it caused a lot of confusion.
> This pinning usage here can be dropped by adding the folio to swap
> cache directly on allocation.
> 
> All swap allocations are folio-based now (except for hibernation), so
> the swap allocator can always take the folio as the parameter. And now
> both swap cache (swap table) and swap map are protected by the cluster
> lock, scanning the map and inserting the folio can be done in the same
> critical section. This eliminates the time window that a slot is pinned
> by SWAP_HAS_CACHE, but it has no cache, and avoids touching the lock
> multiple times.
> 
> This is both a cleanup and an optimization.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h |   5 --
>  mm/swap.h            |   8 +--
>  mm/swap_state.c      |  56 +++++++++++-------
>  mm/swapfile.c        | 161 +++++++++++++++++++++------------------------------
>  4 files changed, 105 insertions(+), 125 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index ac3caa4c6999..4b4b81fbc6a3 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -452,7 +452,6 @@ static inline long get_nr_swap_pages(void)
>  }
>  
>  extern void si_swapinfo(struct sysinfo *);
> -void put_swap_folio(struct folio *folio, swp_entry_t entry);
>  extern int add_swap_count_continuation(swp_entry_t, gfp_t);
>  int swap_type_of(dev_t device, sector_t offset);
>  int find_first_swap(dev_t *device);
> @@ -534,10 +533,6 @@ static inline void swap_put_entries_direct(swp_entry_t ent, int nr)
>  {
>  }
>  
> -static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
> -{
> -}
> -
>  static inline int __swap_count(swp_entry_t entry)
>  {
>  	return 0;
> diff --git a/mm/swap.h b/mm/swap.h
> index 74c61129d7b7..03694ffa662f 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -277,13 +277,13 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
> -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> -			 void **shadow, bool alloc);
>  void swap_cache_del_folio(struct folio *folio);
>  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
>  				     struct mempolicy *mpol, pgoff_t ilx,
>  				     bool *alloced);
>  /* Below helpers require the caller to lock and pass in the swap cluster. */
> +void __swap_cache_add_folio(struct swap_cluster_info *ci,
> +			    struct folio *folio, swp_entry_t entry);
>  void __swap_cache_del_folio(struct swap_cluster_info *ci,
>  			    struct folio *folio, swp_entry_t entry, void *shadow);
>  void __swap_cache_replace_folio(struct swap_cluster_info *ci,
> @@ -459,8 +459,8 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
>  	return NULL;
>  }
>  
> -static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> -				       void **shadow, bool alloc)
> +static inline void *__swap_cache_add_folio(struct swap_cluster_info *ci,
> +		struct folio *folio, swp_entry_t entry)
>  {
>  }

Just a nit,
void* return nothing. 

changed to void (original function prototype is return void)
or how about just remove If this is not used on !CONFIG_SWAP

> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index d2bcca92b6e0..85d9f99c384f 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -122,6 +122,34 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>  	return NULL;
>  }
>  
> +void __swap_cache_add_folio(struct swap_cluster_info *ci,
> +			    struct folio *folio, swp_entry_t entry)
> +{
> +	unsigned long new_tb;
> +	unsigned int ci_start, ci_off, ci_end;
> +	unsigned long nr_pages = folio_nr_pages(folio);
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> +
> +	new_tb = folio_to_swp_tb(folio);
> +	ci_start = swp_cluster_offset(entry);
> +	ci_off = ci_start;
> +	ci_end = ci_start + nr_pages;
> +	do {
> +		VM_WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)));
> +		__swap_table_set(ci, ci_off, new_tb);
> +	} while (++ci_off < ci_end);
> +
> +	folio_ref_add(folio, nr_pages);
> +	folio_set_swapcache(folio);
> +	folio->swap = entry;
> +
> +	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> +	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> +}
> +
>  /**
>   * swap_cache_add_folio - Add a folio into the swap cache.
>   * @folio: The folio to be added.
> @@ -136,23 +164,18 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>   * The caller also needs to update the corresponding swap_map slots with
>   * SWAP_HAS_CACHE bit to avoid race or conflict.
>   */
> -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> -			 void **shadowp, bool alloc)
> +static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> +				void **shadowp)

It is also a small thing.
"alloc" parameter removed then the comment might be updated.

Thanks,
Youngjun Park

