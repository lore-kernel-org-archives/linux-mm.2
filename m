Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33583C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77D66B0088; Mon, 14 Sep 2026 13:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01316B0092; Mon, 14 Sep 2026 13:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A5E6B0093; Mon, 14 Sep 2026 13:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC1A6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:27:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13DDD1C1900
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:27:34 +0000 (UTC)
X-FDA: 85213049628.17.E16EFD1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 23EE62000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:27:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cLl5svWQ;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFrka7gihK6XeoItmx56OonB9Uz/2EOErxS+Lpbel1g=;
	b=4RK9B0uwuD3cbe4i20zIPfizpMyRc3F2lDq7lleidK4s8R0Ijr1GuyujgBXEg4sj2oMZDP
	CSuKkn9ZBXgfBfJze3S2kMjEr9vayoILd640YIDHi/50an8ZzdEJwYAmLA06l4XY6rjWZL
	2PZWXCVIBkX8B3TPqoL8WyjcKUh7VGc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406852;
	b=b1aVrC9nLfFxula6r4+MJLtrRu2INBKdbuhnDuKVUpCZ8j+8H9MdVo450Xq0jgY4A9goaC
	ALsK1pnjPkEdrKW5hfoYZwrKnqPLavxlPTaP1WTHyci1RnFZb1eKlixOZ1L0gXPsGm+EEV
	HJlTXuguHO1JkLTKEFx4NqfmrPWCmTk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cLl5svWQ;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C7361CC4;
	Mon, 14 Sep 2026 10:27:27 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E52B93F882;
	Mon, 14 Sep 2026 10:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789406851; bh=QG6jcvw1X86kFU69w3hcseX3yObcaV7LewqsMepKLY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cLl5svWQM78Nu1mtOguvBASEnuYlWiNoPYp5zPrR2HVZtKfLqbWtwfMxly4tHb6EM
	 Kkq/iQ1zFUwR/cnZ4RElSK7pFwgLsMPp8b583drvfda8unRK1CFTSGODugo0S6x9Hn
	 6p6T1iWmLXkWiipqF9x/WwqIlWY1O4FnkqnKYcg8=
Date: Mon, 14 Sep 2026 18:27:25 +0100
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
Subject: Re: [PATCH v5 12/17] mm/huge_memory: move anon_vma handling into the
 anon split helper
Message-ID: <aqgufcIGKrQLtXua@e129823.arm.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-12-39878b37dfb0@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915-swap-thp-cleanup-v5-12-39878b37dfb0@tencent.com>
X-Stat-Signature: h9jfjr7zow567okwtp8m1qqfxoizhuw4
X-Rspam-User: 
X-Rspamd-Queue-Id: 23EE62000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789406851-415586
X-HE-Meta: U2FsdGVkX19MB0+bWVZoi93UG6pnyqHufde5rWQKraWtbJRfLDoPknxyqIkF/6/+7azFZ/THy9WF9ZsrvOP8W0Zp/ZQyNXtq92Xd2SfiaXufestg7JcHYE5j1M9TB0ArY9QYhwr7/gmmxd5xQK/L3ipE2Hak0nMz4p2YZtDkS0X3YXJUL3qcDGFGYtrbFiWmh+c4EuDmdqjZDR0xAWs0DBRTuyaovI8xUtTPJf284rZMdSTWTQR9GJwFTMyQ5u0oyG0Dw4Eqs4gU5tVxH4AdUosAFwljxjsvAyhWrD68g+ylvtrNGjIMNvZNO4wBFc0Odx99uhrY5UqaqlvE6HuNHlyiq8iWLcQWJYLrZK21w4LTXpHVS8aAbY9VB7ZlyR0Yr6ORSYjk8VpGkA3YJftMqSam3S1z2+92kw3iOSj4OHGmopuJ1wQTaSK/Sy7DM22R2XTR19RYQYNlKw+uWF22WiN84hOD/IVlpog3S04RvK2lbiGNcfzGt/GsEfh2XVOeTj+4skk3C5BFDR+UcEiZjQX/5xKM5amxcqbHlJpbhGbhQbUFebg5QvQe/qoSVu+PwPlLuckXXeM0CLIh6R/QUsLhQsqO2tz0nuL3msOX2qbSa5qj6YQ/DOAKcJy4YpVIwxiVBCi+1c9lqInoUK8y68ZR4i9tS2kNre9QrYi1TYHJYxJOCAYCI/bhBxwVK2OkYFpphkYM9YoYyNkQcjr3QdHcKPnj0M4DNLp+oiB4OmVjzjSAYZJwR6UpR5omesarHaUNZUsaXaD+2EfNCg1yErvIHqcFrz1KjKDyKZd/TsLU31XZg8VbUP0PCrGhtjzi4g31TPbAfpilP8quqs5iQH2FbtO9b9bVc4YryA9kkkwXXl+9pJ4CJaDveBvQAiCO2rMS5z2jhLXi7FP6EU1OUeggq+mVA6ELyny1IEVekyTtHudUCooSOK4ivjI6Mo/t8K3gqKEvgOEMNMLh5Z2
 YgU31MUR
 YUfOSS2ePXsxNU6+7OFnBjTq2Jyhne7Oo24xHluXdQ6Os+4sK9Bxw0bc1rq6SHR4tJYNnaK13YKzLiBMV1W7m4rRlk/JKQ+FHbswuYnOtwu/higYJUPe/9xB/AKuVqjvYKCDXvTbIwGRJF1IJeEtrCDggAZdr8rugqFA1aKZ52Ns0thbQImLRSUN/0TmOG6FxSaHMvSrSHckH/5hoJKmExRsz6fop3/W7/xBSij72X10H9UVi3Gria3o01Z957eD3lQlo9BkIHWoQO04KP95eyEGIJJGWK0mTxly0IHHCMDvmRzD5S3ZmryJdkEF3QvDbZgLOC6bHHRpQlz7myqdk8Ajy4VRyZ5ZuRoJ2zX853JMtQgkInW1od2zhKze4m9log7pkLa+kBCMjCbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LGTM.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

> From: Kairui Song <kasong@tencent.com>
> 
> Only anon split needs the anon_vma, and it only needs it to unmap and
> remap.  Move the folio_get_anon_vma()/anon_vma_lock_write() pair out of
> __folio_split() into the anon helper next to the folio_mapped()
> check that already gates unmap_folio().
> 
> This makes the anon_vma conditional on folio_mapped(), which is a
> behaviour change but should be fine.  folio_get_anon_vma() returns
> NULL whenever !folio_mapped(), so an anon folio with
> folio_mapcount() == 0 used to get -EBUSY from split_huge_page() and is
> now split instead.  A realistic case is a THP that has been fully
> swapped out and is still in the swap cache: swap PTEs do not contribute
> mapcount, so it is !folio_mapped() but still alive.
> 
> That should be safe and right to have because:
> 
> - folio_ref_freeze() below still rejects a folio that picked up any
>   reference, a mapping or a GUP pin, in the meantime.
> 
> - A parallel split is excluded by the folio lock.  The anon_vma
>   write lock was added to serialize split in commit 062f1af2170a
>   ("mm: thp: acquire the anon_vma rwsem for write during split"), when
>   split_huge_page() did not hold the folio lock throughout. commit
>   e9b61f19858a ("thp: reintroduce split_huge_page()") later made the
>   folio lock a caller requirement and added the folio_ref_freeze()
>   scheme, so that has been covered ever since.
> 
> - Unmapped path is already exercised by folio_split_unmapped(),
>   and the swap cache split already runs well for a partially
>   swapped-out mapped THP.
> 
> - A !folio_mapped() folio cannot become mapped meanwhile: mapping it
>   requires the folio lock.
> 
> For mapped folios the anon_vma write lock is now released before
> __folio_split() unlocks the after-split sub-folios, where previously it
> was held across that loop; that window is harmless as the sub-folios
> stay folio-locked and referenced until it.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 31 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8fc1dd5b8354..a4c2e38f4a6d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4029,16 +4029,38 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  	struct swap_cluster_info *ci = NULL;
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
> +	struct anon_vma *anon_vma = NULL;
>  	enum ttu_flags ttu_flags = 0;
>  	struct lruvec *lruvec;
> -	bool need_remap = false;
>  	int ret = 0;
>  
> +	/*
> +	 * Unmap/remap needs the anon_vma, so we first take a reference on
> +	 * it to prevent it from disappearing, and lock it for write here,
> +	 * letting unmap_folio() walk the rmap with TTU_RMAP_LOCKED.
> +	 *
> +	 * folio_mapped() is not stable here, but it can only change in
> +	 * one direction while the folio is locked. The mapcount can drop
> +	 * to zero at any time, zap_pte_range() takes no folio lock. It
> +	 * cannot go up: swapin, migration and uffd move all lock the folio
> +	 * before mapping it, and fork only copies PTEs that already exist.
> +	 *
> +	 * So if we see the folio mapped, the worst case is an empty rmap
> +	 * walk. If we see it unmapped, it stays unmapped and needs neither
> +	 * the reference nor the lock. Anything else needs a reference
> +	 * first and folio_ref_freeze() below catches it.
> +	 *
> +	 * Note a swapped-out THP counts as unmapped here as swap PTEs do
> +	 * not contribute mapcount, and they are splittable.
> +	 */
>  	if (folio_mapped(folio)) {
> -		need_remap = true;
> +		anon_vma = folio_get_anon_vma(folio);
> +		if (!anon_vma)
> +			return -EBUSY;
> +		anon_vma_lock_write(anon_vma);
>  		ret = unmap_folio(folio);
>  		if (ret)
> -			return ret;
> +			goto out_unlock;
>  	}
>  
>  	local_irq_disable();
> @@ -4096,11 +4118,16 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  		swap_cluster_unlock(ci);
>  out_no_split:
>  	local_irq_enable();
> -	if (need_remap) {
> +	if (anon_vma) {
>  		if (!ret && !folio_is_device_private(folio))
>  			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>  		remap_anon_folio(folio, 1 << old_order, ttu_flags);
>  	}
> +out_unlock:
> +	if (anon_vma) {
> +		anon_vma_unlock_write(anon_vma);
> +		put_anon_vma(anon_vma);
> +	}
>  
>  	return ret;
>  }
> @@ -4295,7 +4322,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	struct folio *end_folio = folio_next(folio);
>  	bool is_anon = folio_test_anon(folio);
>  	struct mem_cgroup *memcg, *old_memcg;
> -	struct anon_vma *anon_vma = NULL;
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int ret;
> @@ -4326,23 +4352,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	memcg = get_mem_cgroup_from_folio(folio);
>  	old_memcg = set_active_memcg(memcg);
>  
> -	if (is_anon) {
> -		/*
> -		 * The caller does not necessarily hold an mmap_lock that would
> -		 * prevent the anon_vma disappearing so we first we take a
> -		 * reference to it and then lock the anon_vma for write. This
> -		 * is similar to folio_lock_anon_vma_read except the write lock
> -		 * is taken to serialise against parallel split or collapse
> -		 * operations.
> -		 */
> -		anon_vma = folio_get_anon_vma(folio);
> -		if (!anon_vma) {
> -			ret = -EBUSY;
> -			goto out;
> -		}
> -		anon_vma_lock_write(anon_vma);
> -	}
> -
>  	if (is_anon)
>  		ret = __folio_freeze_split_anon(folio, new_order, split_at,
>  						true, list, split_type);
> @@ -4369,11 +4378,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		free_folio_and_swap_cache(new_folio);
>  	}
>  
> -	if (anon_vma) {
> -		anon_vma_unlock_write(anon_vma);
> -		put_anon_vma(anon_vma);
> -	}
> -out:
>  	/* restore to caller's old_memcg */
>  	set_active_memcg(old_memcg);
>  	mem_cgroup_put(memcg);
> 
> -- 
> 2.55.0
> 
> 

-- 
Sincerely,
Yeoreum Yun

