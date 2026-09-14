Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2461BC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7566B00A6; Mon, 14 Sep 2026 13:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357A46B00A7; Mon, 14 Sep 2026 13:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246A86B00A9; Mon, 14 Sep 2026 13:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E52356B00A6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:30:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CE5A1A01E3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:30:16 +0000 (UTC)
X-FDA: 85213056432.22.EA062E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id B028040017
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:30:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j+zdushg;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789407014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwHATyDTUJG1bFGec5Z0+aVtF0B4y/Jfy+rnYYyT19w=;
	b=k2BT1WCV7SUdL3xUlMBTXEjXWoPulRVknxrWYgcldmcyZF/VbDcIVo81dPkRwb+PpQ+xpM
	zBPNFNDdSLp9rfW2NgCTZ69S5BQZuwLU+hU5V4nwQUCXKfzCNLNToTTvqxpBB4K6BUDBWG
	tpQUkqJJx9X2XwbCmQyQF7CZ00gopQ0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j+zdushg;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789407014;
	b=2kOepEJPxZ+lXLftUv/J2DXrKF63SfwRnMlw35ygj+APV2ZOGEkP7rLrLDoUu4j/9pv6/m
	psgUoiXa2D28mlwEhHl81VJo43d38cbZh4VDx7l1ogvEUf2vzhznUBBbHFTAxL1hMOFZhD
	OBMjkjORBcqOpix6ZC9rlF6HURdAvwI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB9C11D13;
	Mon, 14 Sep 2026 10:30:09 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AED1D3F882;
	Mon, 14 Sep 2026 10:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789407013; bh=yglmwl9MFw/EmTJulVg8asVHDecs0CK0sHZegg8iNu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j+zdushgxOeYFTMddeV7hHZd8RxoShaL7jeUjoSCsB+nx4uvUxW4tdgFPH0BAFm6/
	 5AHJ2Hj3n1OfS6usERWgb2TdQO1m3OebyMT0Rs7ixEx0Em+r8VzvBVxZ/u2aiHu0+1
	 KeRn6/ttc7TBRyhWVrtovf/Bk34BmmwTUc/7KXK0=
Date: Mon, 14 Sep 2026 18:30:07 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Shivam Kalra <shivamkalra98@zohomail.in>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 11/17] mm/huge_memory: move filemap management into
 the file split helper
Message-ID: <aqgvHycVfCFI1FER@e129823.arm.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-11-39878b37dfb0@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915-swap-thp-cleanup-v5-11-39878b37dfb0@tencent.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B028040017
X-Stat-Signature: hwbbaqki8sngtcmexekrnw4h83a6ytpy
X-Rspam-User: 
X-HE-Tag: 1789407014-132506
X-HE-Meta: U2FsdGVkX18wrgnKsFffb0miu/dmZd5Ds+dt011Fcq5S1/oL5fI/q6dSaC0Sq06uqVqlZ3fOCYe1wsz/zE1fFZrn08B64wSic9/hUYvZ/vCcMagDjQWUL4+w79JFGq2YR+0GdiQY4tmDe8JdZRZzqD94+8LdQrAIRqQkYbQWcTjybrCqVkPwuzAfTar4wcXvBH6PYVkeomdba6kKEPo+VGW//h8pkCB+9u6XrWCDVLzmqB22OsQzyEi6g9RGKJiOjwhpoMWrJAzk3ZV1P0R7hAfmwZELIz0RbTAG00+uXp386LuT8LPlKMxToM1Eup1bwardulwA/6Dc/rG80GDo93lSW307TPVePcsYSH49WQyIR24WXUGoX4EpF4aUL4NaVrJe/UVe++d0MEF/lAVGdQUjcAnWND1jLC0YwxfsZwKLbLbaLjPnoHmJOuIxZnFqK1cIO1wQXj1UsweqT+d/Lc7zriyhJpwv63j966NQPCG+bBHF+aKr17GzkT9YnnKRaQGMc6soCC24w1Izxmt2xM2lj/OJfC1E4XMD4jHdqUbShWrsvqFiEw2pXOCmyWX+krcsy4jKeDoBsrTFRPPD5PBd/n3foNC/7AP189EXmoW4m50sHzPp2hw0cl6qKLCY5ROCuRuYOydzsa2uOElUNhjXc1IiDC0km4wje9YPWjX8G9b7dp4wdJxrQQMd3KCKWKYdC5YlejoZHqIVXFrwdpFqkRsNhYIiK7pRvT7vb7V4yqIiH6sstb6d/fhydIKyjTXSU33VN0qNcmOc+6Jt1bfj5MnVA5Bi5g5MxceF9/iyxHoeTi0yBxOAIwmbOVF2CkrrcAoZOrwwFZB8Lbk3ZZYjSd35D0LvQZWj9PqFmCZd0qxftX9xqGeyiefumRO5/3BOxoEiQn5eU50wwBj1nxw4a5mKynXDRDMmPlk7IMIZa6znYxEM3E3fCWixWdQPX6XWgK0j/cqdvdkCFE0
 eZR5c1c+
 rBG9Ur+dSJpoGDDC9DVMA15m3jDOEs+m9NGCf/Cx2CqnwcVeNTf7AvpIfV3sapNNNuVhDaLocsWeZDx/2whC2GWXQ95FIL0C8XQdwETfP8Rs61JgpwHT1Es6EBwtSv3075RqcvzKqjv26DC9Uz/+TIbSJq0dAGy/3Kx1Yw4+7RDldyUDJAxSrY2V5jJleSZPaHBC4lJgo4VAlL/nMmd84TE+ve8sCtmEeye0fARoiwo8gBKpt/BEfCjwPmT41aRtLAydAVFNDPB+iQ7dB1QwJQXtqOSXZBwovFzIav2/d81THE/hQ/FHEEPDoBINvOH8kJkwAe5VB3jTZ/js1n0D1hTOwHcpxM7DtL01YoEC69HTNFoCwofZ1c/5huBptZshggxLMnXb1SuZaDjkR/g7lxd7VlWG/k5QjSjuz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

On Tue, Sep 15, 2026 at 01:14:52AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Only file split needs the filemap and xarray handling and related
> variables.  Move them out of __folio_split() into the file helper so
> the helper is self-contained, and simplify the parameters.
> 
> No functional change.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 102 ++++++++++++++++++++++++-------------------------------
>  1 file changed, 44 insertions(+), 58 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 859aefda7356..8fc1dd5b8354 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4107,16 +4107,42 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  
>  static int __folio_freeze_split_file(struct folio *folio,
>  		unsigned int new_order, struct page *split_at,
> -		struct xa_state *xas, struct address_space *mapping,
>  		bool do_lru, struct list_head *list,
>  		enum split_type split_type)
>  {
> +	struct address_space *mapping = folio->mapping;
> +	XA_STATE(xas, &mapping->i_pages, folio->index);
>  	struct folio *end_folio = folio_next(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped = 0;
> +	unsigned int min_order;
>  	struct lruvec *lruvec;
>  	pgoff_t end;
> -	int ret;
> +	gfp_t gfp;
> +	int ret = 0;
> +
> +	min_order = mapping_min_folio_order(mapping);
> +	if (new_order < min_order)
> +		return -EINVAL;
> +
> +	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
> +	if (!filemap_release_folio(folio, gfp))
> +		return -EBUSY;
> +
> +	mapping_set_update(&xas, mapping);
> +
> +	if (split_type == SPLIT_TYPE_UNIFORM) {
> +		int old_order = folio_order(folio);
> +
> +		xas_set_order(&xas, folio->index, new_order);
> +		xas_split_alloc(&xas, folio, old_order, gfp);
> +		if (xas_error(&xas)) {
> +			ret = xas_error(&xas);
> +			goto fail_free;
> +		}
> +	}
> +
> +	i_mmap_lock_read(mapping);
>  
>  	/* Currently device private folios can only back anonymous memory. */
>  	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
> @@ -4134,15 +4160,15 @@ static int __folio_freeze_split_file(struct folio *folio,
>  
>  	ret = unmap_folio(folio);
>  	if (ret)
> -		return ret;
> +		goto fail_mmap_unlock;
>  
> -	xas_lock_irq(xas);
> +	xas_lock_irq(&xas);
>  
>  	/*
>  	 * Check if the folio is present in page cache.
>  	 * We assume all tail are present too, if folio is there.
>  	 */
> -	if (xas_load(xas) != folio) {
> +	if (xas_load(&xas) != folio) {
>  		ret = -EAGAIN;
>  		goto fail;
>  	}
> @@ -4169,7 +4195,7 @@ static int __folio_freeze_split_file(struct folio *folio,
>  	if (do_lru)
>  		lruvec = folio_lruvec_lock(folio);
>  
> -	ret = __split_frozen_folio(folio, new_order, split_at, xas,
> +	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
>  				   mapping, split_type);
>  
>  	/*
> @@ -4225,9 +4251,19 @@ static int __folio_freeze_split_file(struct folio *folio,
>  	 * If we want to use try_to_migrate() on file in unmap_folio,
>  	 * remember to add remap_anon_folio() and adapt it.
>  	 */
> -	xas_unlock_irq(xas);
> +	xas_unlock_irq(&xas);
> +fail_mmap_unlock:
>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
> +	/*
> +	 * Drop the mapping while the inode is still pinned. @folio stays
> +	 * locked and present in the page cache, so eviction cannot free
> +	 * the inode yet, nothing past this point may touch the inode or
> +	 * the mapping.
> +	 */
> +	i_mmap_unlock_read(mapping);
> +fail_free:
> +	xas_destroy(&xas);
>  	return ret;
>  }
>  
> @@ -4256,11 +4292,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		struct page *split_at, struct page *lock_at,
>  		struct list_head *list, enum split_type split_type)
>  {
> -	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>  	struct folio *end_folio = folio_next(folio);
>  	bool is_anon = folio_test_anon(folio);
>  	struct mem_cgroup *memcg, *old_memcg;
> -	struct address_space *mapping = NULL;
>  	struct anon_vma *anon_vma = NULL;
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
> @@ -4307,60 +4341,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  			goto out;
>  		}
>  		anon_vma_lock_write(anon_vma);
> -		mapping = NULL;
> -	} else {
> -		unsigned int min_order;
> -		gfp_t gfp;
> -
> -		mapping = folio->mapping;
> -		min_order = mapping_min_folio_order(mapping);
> -		if (new_order < min_order) {
> -			ret = -EINVAL;
> -			goto out;
> -		}
> -
> -		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
> -							GFP_RECLAIM_MASK);
> -
> -		if (!filemap_release_folio(folio, gfp)) {
> -			ret = -EBUSY;
> -			goto out;
> -		}
> -
> -		mapping_set_update(&xas, mapping);
> -
> -		if (split_type == SPLIT_TYPE_UNIFORM) {
> -			xas_set_order(&xas, folio->index, new_order);
> -			xas_split_alloc(&xas, folio, old_order, gfp);
> -			if (xas_error(&xas)) {
> -				ret = xas_error(&xas);
> -				goto out;
> -			}
> -		}
> -
> -		anon_vma = NULL;
> -		i_mmap_lock_read(mapping);
>  	}
>  
>  	if (is_anon)
>  		ret = __folio_freeze_split_anon(folio, new_order, split_at,
>  						true, list, split_type);
>  	else
> -		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
> +		ret = __folio_freeze_split_file(folio, new_order, split_at,
>  						true, list, split_type);
>  
> -	/*
> -	 * Drop the mapping while the inode is still pinned. @folio stays
> -	 * locked and present in the page cache until the loop below, so
> -	 * eviction cannot free the inode yet; @lock_at is not enough, it may
> -	 * be a tail beyond EOF that the split already dropped from the page
> -	 * cache. Nothing past this point may touch the inode or the mapping.
> -	 */
> -	if (mapping) {
> -		i_mmap_unlock_read(mapping);
> -		mapping = NULL;
> -	}
> -
>  	/*
>  	 * Unlock all after-split folios except the one containing
>  	 * @lock_at page. If @folio is not split, it will be kept locked.
> @@ -4384,14 +4373,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		anon_vma_unlock_write(anon_vma);
>  		put_anon_vma(anon_vma);
>  	}
> -	if (mapping)
> -		i_mmap_unlock_read(mapping);
>  out:
>  	/* restore to caller's old_memcg */
>  	set_active_memcg(old_memcg);
>  	mem_cgroup_put(memcg);
>  out_no_memcg:
> -	xas_destroy(&xas);
>  	if (is_pmd_order(old_order))
>  		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
>  	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
> 
> -- 
> 2.55.0
> 
> 

-- 
Sincerely,
Yeoreum Yun

