Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E76D68BD4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A916B0088; Wed, 17 Dec 2025 22:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8466B008A; Wed, 17 Dec 2025 22:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A1B6B0092; Wed, 17 Dec 2025 22:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72D376B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:37:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2298913C18E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:37:42 +0000 (UTC)
X-FDA: 84231182364.17.9EE3AEE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 24EFE40002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:37:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OUbKNtDi;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766029060; a=rsa-sha256;
	cv=none;
	b=p6baB1DiQTbLBmnWh+9RXN63Da3x09o7mDN2bbgkb8urotWpeWCWtN0AO7wl1Dp9baDKJ+
	FcgEGsWG/Ln4MqbE7KdJ4V/zan35nFVwaJLiroYqLEsre94OeEJl4SZHK6AL5avMGZZZBn
	dPjZOmkqGaMGT0hGOLhaHIydXRrv1Ws=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OUbKNtDi;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766029060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qTD9MZk8GDLip2qcSZRvcJaRYYv76lWRQR+PrOB//U=;
	b=XPJ6saDUsJQw+gxOImntjUTGW7j1OHpTeGXMY+LVGIPU1T728CG2Ip0fUA1ufUHToWPo+h
	D8S52iFdZKg909pJNqYb0NAkW+lDj3KiCbansNW4Js/giTHOyGOE9Al7/nVp9a8BbNODJ6
	drs8XOvXvV6CtQKC0gSNCVeDFPZT8Zw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766029059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3qTD9MZk8GDLip2qcSZRvcJaRYYv76lWRQR+PrOB//U=;
	b=OUbKNtDikPrDYLi+m6bUSyfqlDpNfT7mWSSl7oSfQv3JC5Upn1Dl27PHhbWxYO1TqgOSOy
	toKD49BX9CsKbDJKXn7MU/QngrDEBJ8BJaiHDvdPwyI9JTGdRb/0FHiMLfPj9/o0H49c+9
	FvI1tKz/4vyXABZsi6yNeo5hkOaXi7s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-4gkqZ1yrM2if8ZS1n76vxQ-1; Wed,
 17 Dec 2025 22:37:36 -0500
X-MC-Unique: 4gkqZ1yrM2if8ZS1n76vxQ-1
X-Mimecast-MFC-AGG-ID: 4gkqZ1yrM2if8ZS1n76vxQ_1766029053
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50FE91955F34;
	Thu, 18 Dec 2025 03:37:33 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBD6E30001A2;
	Thu, 18 Dec 2025 03:37:30 +0000 (UTC)
Date: Thu, 18 Dec 2025 11:37:25 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4 13/19] mm, swap: remove workaround for unsynchronized
 swap map cache state
Message-ID: <aUN29S2CDv0KbfXj@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-13-cb7e28a26a40@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205-swap-table-p2-v4-13-cb7e28a26a40@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Queue-Id: 24EFE40002
X-Rspamd-Server: rspam04
X-Stat-Signature: paotsm9yzzkmym31kjnu3cipix6sby9a
X-HE-Tag: 1766029059-83581
X-HE-Meta: U2FsdGVkX180STBfEeuzYxlkPamwkbripOUQlENYe04pwsVIxshZO4TAbDoetwYTn1K6TBSGiZTPycJ7aT9Bwc0xpOFIOPVBctPLPAuvmGtai7X5+QSlR+vRF3m/i5sR/xO0MC8Bf/e8F71NG0onQGO/JbcTKbZVVHbXKwbsN0hKCDMD0IbJPIRa6AR5W9/vVXRpDwPiUzE6vh5MT/OxXijc7xOktVl4IsrGb8UYauHddLn6z2Ngw0Z/d5+wgQCXWTWXADka6tZrjMi/GKkYS7Q5BSq3bweMe9jnbAEMjLlTQ5VLbuWpg8+doBkpq7jsLTo0GGgwOEMEH3/yzGDWgPQpX8O2m2ldWe14KoPB4pdfZeW1hsWZX6FZFhKSrTUxEv/wE57cmeDGkO+YqGwYRkB47C8AlUtT3MkjOz6S0bS3hEnaClthOSLOUzzIFrErNNMz7OFqXsZyGmiFvyycAXAMormPsCH9oQWBBpEARWnsKATAbGlEdDtPnNtHtdy02virdeHGVtnM9ZZI+z4scQ2UpNMfQRyDteomofW+DqO4qjTXEoh6IKM67Yz3FBod1SNk22BJDcj/GfpJVDKfVfd/lsSN2OQZubvAR4oup/n9f9bg1bqQrCfyQ4JKqfuRoBhcsu1KWFT/unCoqLvnsbgA96ROcgl5HSbxkIWI8FAhtg71ibV+0q7PIi3RgiJRwENPz9zPl1yKjUsJyW1tTKHy8/L+ebylTDDSAaEHeHtJus9MGUT6YBWyUOW1efypAazV20O99v+dqAHKcZ8D8iqIQv4ZwbjW7kNt/EbXXOARZJu/Cj6nGADfKc07dvwyono1g8ozj/BVYGWESh6dWJMomOxS042JY/UT2j+qd4LnhZQtAZ9E94E+yh1Xfecf5RnLJgmv4tK8usBDAIZJX0Eu0Zw7uOdx8Jc7BYWv61tEn7dV++d4QKyc+SfE7/rnd7+P5XHSiIXM07tQgEc
 LmAxqWWV
 ECKLqr9XnOqxJPjPwbUak03H6LO09mKnESTybxQw80Om1by9ChsyLSHiSRTdq1+Ghxyr9k1ukJkPI80T/EcOVYL+u1bl4A6VrjIW1Ok0EVX4M/Prnf9SkzT2SDIZ9+gTu8OwAYgeWsQedwBLhqIXI11SWLE9GK9Jm/aJvewC0MaMoXQP0CMnCSut6+Zg8RaCysTkEKi1IDplK7tCtop7KmpwFrK+HLy/YPbAu08iEjA3z6Jqy/AN50noBEDIASDje5sWVYMggwJ6UBKkUIbm6wElpEGsyGPRh/VyyyaW4zs/jp2gNPsscVI3YucllDSAfu2bA6Fz1QY2cThI1iYY+ABOjd0wrvK5hTbiNxqKppf0TNBfQdhCMEknB34xdukVUWijKzad9j/S488ByqqgQDYkISj/aDAXTyRgqYEFM0yakQEVYs+DPGzJc2QwTDaRn6vcM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/05/25 at 03:29am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Remove the "skip if exists" check from commit a65b0e7607ccb ("zswap:
> make shrinking memcg-aware"). It was needed because there is a tiny time
> window between setting the SWAP_HAS_CACHE bit and actually adding the
> folio to the swap cache. If a user is trying to add the folio into the
> swap cache but another user was interrupted after setting SWAP_HAS_CACHE
> but hasn't added the folio to the swap cache yet, it might lead to a
> deadlock.
> 
> We have moved the bit setting to the same critical section as adding the
> folio, so this is no longer needed. Remove it and clean it up.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h       |  2 +-
>  mm/swap_state.c | 27 ++++++++++-----------------
>  mm/zswap.c      |  2 +-
>  3 files changed, 12 insertions(+), 19 deletions(-)

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/swap.h b/mm/swap.h
> index b5075a1aee04..6777b2ab9d92 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -260,7 +260,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
>  void swap_cache_del_folio(struct folio *folio);
>  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
>  				     struct mempolicy *mpol, pgoff_t ilx,
> -				     bool *alloced, bool skip_if_exists);
> +				     bool *alloced);
>  /* Below helpers require the caller to lock and pass in the swap cluster. */
>  void __swap_cache_del_folio(struct swap_cluster_info *ci,
>  			    struct folio *folio, swp_entry_t entry, void *shadow);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index df7df8b75e52..1a69ba3be87f 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -445,8 +445,6 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
>   * @folio: folio to be added.
>   * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
>   * @charged: if the folio is already charged.
> - * @skip_if_exists: if the slot is in a cached state, return NULL.
> - *                  This is an old workaround that will be removed shortly.
>   *
>   * Update the swap_map and add folio as swap cache, typically before swapin.
>   * All swap slots covered by the folio must have a non-zero swap count.
> @@ -457,8 +455,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
>   */
>  static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
>  						  struct folio *folio,
> -						  gfp_t gfp, bool charged,
> -						  bool skip_if_exists)
> +						  gfp_t gfp, bool charged)
>  {
>  	struct folio *swapcache = NULL;
>  	void *shadow;
> @@ -478,7 +475,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
>  		 * might return a folio that is irrelevant to the faulting
>  		 * entry because @entry is aligned down. Just return NULL.
>  		 */
> -		if (ret != -EEXIST || skip_if_exists || folio_test_large(folio))
> +		if (ret != -EEXIST || folio_test_large(folio))
>  			goto failed;
>  
>  		swapcache = swap_cache_get_folio(entry);
> @@ -511,8 +508,6 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
>   * @mpol: NUMA memory allocation policy to be applied
>   * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
>   * @new_page_allocated: sets true if allocation happened, false otherwise
> - * @skip_if_exists: if the slot is a partially cached state, return NULL.
> - *                  This is a workaround that would be removed shortly.
>   *
>   * Allocate a folio in the swap cache for one swap slot, typically before
>   * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
> @@ -525,8 +520,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
>   */
>  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
>  				     struct mempolicy *mpol, pgoff_t ilx,
> -				     bool *new_page_allocated,
> -				     bool skip_if_exists)
> +				     bool *new_page_allocated)
>  {
>  	struct swap_info_struct *si = __swap_entry_to_info(entry);
>  	struct folio *folio;
> @@ -547,8 +541,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
>  	if (!folio)
>  		return NULL;
>  	/* Try add the new folio, returns existing folio or NULL on failure. */
> -	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask,
> -					      false, skip_if_exists);
> +	result = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
>  	if (result == folio)
>  		*new_page_allocated = true;
>  	else
> @@ -577,7 +570,7 @@ struct folio *swapin_folio(swp_entry_t entry, struct folio *folio)
>  	unsigned long nr_pages = folio_nr_pages(folio);
>  
>  	entry = swp_entry(swp_type(entry), round_down(offset, nr_pages));
> -	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true, false);
> +	swapcache = __swap_cache_prepare_and_add(entry, folio, 0, true);
>  	if (swapcache == folio)
>  		swap_read_folio(folio, NULL);
>  	return swapcache;
> @@ -605,7 +598,7 @@ struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  
>  	mpol = get_vma_policy(vma, addr, 0, &ilx);
>  	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
> -					&page_allocated, false);
> +				       &page_allocated);
>  	mpol_cond_put(mpol);
>  
>  	if (page_allocated)
> @@ -724,7 +717,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  		/* Ok, do the async read-ahead now */
>  		folio = swap_cache_alloc_folio(
>  			swp_entry(swp_type(entry), offset), gfp_mask, mpol, ilx,
> -			&page_allocated, false);
> +			&page_allocated);
>  		if (!folio)
>  			continue;
>  		if (page_allocated) {
> @@ -742,7 +735,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  skip:
>  	/* The page was likely read above, so no need for plugging here */
>  	folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
> -					&page_allocated, false);
> +				       &page_allocated);
>  	if (unlikely(page_allocated))
>  		swap_read_folio(folio, NULL);
>  	return folio;
> @@ -847,7 +840,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  				continue;
>  		}
>  		folio = swap_cache_alloc_folio(entry, gfp_mask, mpol, ilx,
> -						&page_allocated, false);
> +					       &page_allocated);
>  		if (si)
>  			put_swap_device(si);
>  		if (!folio)
> @@ -869,7 +862,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  skip:
>  	/* The folio was likely read above, so no need for plugging here */
>  	folio = swap_cache_alloc_folio(targ_entry, gfp_mask, mpol, targ_ilx,
> -					&page_allocated, false);
> +				       &page_allocated);
>  	if (unlikely(page_allocated))
>  		swap_read_folio(folio, NULL);
>  	return folio;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index a7a2443912f4..d8a33db9d3cc 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1015,7 +1015,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  
>  	mpol = get_task_policy(current);
>  	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
> -				       NO_INTERLEAVE_INDEX, &folio_was_allocated, true);
> +				       NO_INTERLEAVE_INDEX, &folio_was_allocated);
>  	put_swap_device(si);
>  	if (!folio)
>  		return -ENOMEM;
> 
> -- 
> 2.52.0
> 


