Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6595CCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FBAD6B0005; Fri, 15 May 2026 09:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC616B0088; Fri, 15 May 2026 09:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A04D6B008C; Fri, 15 May 2026 09:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1878F6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:46:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3528A00F1
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:46:41 +0000 (UTC)
X-FDA: 84769779402.29.39B518D
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9ADB01A0002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:46:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o9nDjNQ4;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778852799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQQlXEojFrhAWvISNt7oswBAwMsNYhE0qQ6ZhcIht6A=;
	b=4kpZmAJ9Q9atwF3cbnqiRCnTc8drf76LubipBn/liBi6SxpMXYiEATjtawelyFbfri9pnB
	op1WGSQvBlI8XOQ+dLIlJMOr4joyG/d/a6BVRrNVgGar9UmlUm+OrMPItpv6BNC1CQjwkR
	LDdG/YWgFvRuRU9lqN3jkaHzFbxFOKM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o9nDjNQ4;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778852799; a=rsa-sha256;
	cv=none;
	b=igYbLXkW5ixo62AZ1fITzL1dbVd9VXPEKiduf5IFXy/4+cJwLivVvLmJoxaqXYhGjPWOHL
	U3FHkq/MGWFEI1rJHPnWcomQE4pxMm1m6HsC3WACOBszxj4WWA4Q6I5eLlc74nY3eJGfq8
	hJm/LbkQnDYFEfjajvDW/FyTjmPWh44=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c736261ee8dso4340664a12.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 06:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778852798; x=1779457598; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UQQlXEojFrhAWvISNt7oswBAwMsNYhE0qQ6ZhcIht6A=;
        b=o9nDjNQ41t1Wz21sLLSb2av28NPKpS3ZRrZa5YgxrM/gUROphe42Q8HbNyjaA4uVN+
         dgmuGXVMc7b1Qr4NCNN0ITP+ZeHwLXo2Cecp7/4ocZ0KF/b8ZuuTI/N6Qq4fPAbSC+SB
         N2KD3Gbl0JKe/KIRAiqEF3O9htTzkFlsINdzSuwFLOSs0iBwCKVs6yM6Rm8zk9VWpQP0
         17D9uxPUqwKdrqiYSqo/md+zMmJdsRRSvBUxrEfH16IFhn6AqCUNwfMAMgbePQuA3EGX
         Rw/32OkrtkWTIrR4vAIwtIT7m3huVfvIsTywh+E3j+dyucJLLaQwKIcKmz+6J3VkXcZO
         3KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778852798; x=1779457598;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQQlXEojFrhAWvISNt7oswBAwMsNYhE0qQ6ZhcIht6A=;
        b=S5mZsEJhGROZB4oel8tK8V9bJ/9I09GKu0QoleAV/3f07RIYYnuwATNV5iXOQjRr57
         uyBHdlhFwbWKNP81wLVV81Yv1EVbDxog9OES4o1LaiYyJj1z4JP5uEnASc227kBvqc8A
         aswelyWs2DIWJjpUc9HNIw7rf0Oh5VvYxlRK9cvtjLuS9zkB4hyskmGJK4FPIet5DkDv
         fxHaeuG5RXpx97mSXjV74QWFfyY0s1VxLAoGsV57H4ETeyR8bVmWUltcGnPldFIhJCnA
         DNhdTXcwjlSywINIKRs0tlt4m1q2zP3cYdHpVMaVpgRFwXM4zIHOTVjcme+mADlWsftY
         eyFQ==
X-Gm-Message-State: AOJu0Yw7J3v0XBu/gIvmQO/1ageX3XbJSJV0eTa0ev6+XUcVemJ3hdkA
	X0ED6H7z/C2RvAaUZdqj50kzN77d9nxSAh66BBlbpUybO4k+12Cx5EDM
X-Gm-Gg: Acq92OElmXiKlrW+Qzcff3ya1P7wlKwLiGWVdY/wOuyFYiemWPIRTMyVenTbEXmmRyK
	mmmomu4jqCs81JIZj4ygwjNFIfaOnIS+iQnslQvFa1bv2HDaUyWsW+jTnp0p5FLaMPWoLKJf6PU
	PloM/JjlPYIjHCeDlKcuOXLGups9Z6OxAXPhHqwcCFqU3LVb89qTfxGbSeX3oZkS0Av9qdF37JM
	CVeUr1F7rIbg10xZ53dhiVoeNNpdKFb+69jr13S79Hy5lbr8uza7+IgBYlXbKNzm7rQbeZGztDN
	lPDlwXHo04sTpzyvBXLhf36stXRUSxkWDzLp+bwuum2UDninDlrXX0xVzH/OLUUGw2gxNn/F4Qc
	Q7e7E9pzKeu7kDl2Hp/5cQPgGC7h+coBx1RoBQptjPoc5SzYVXCEKMFQRyhQ6ZFLxIXd3VzPR2t
	QMQCUBn9P8YOasb/9qv18o0p2aj1AqOrS20c+tP2/r0ftetZqp+Be+sxcXHBg=
X-Received: by 2002:a05:6a20:748b:b0:3a2:edff:297c with SMTP id adf61e73a8af0-3b22e13754amr4680422637.0.1778852798288;
        Fri, 15 May 2026 06:46:38 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19776733sm6017763b3a.13.2026.05.15.06.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 06:46:37 -0700 (PDT)
Date: Fri, 15 May 2026 21:46:30 +0800
From: Kairui Song <ryncsn@gmail.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v4 04/12] mm, swap: add support for stable large
 allocation in swap cache directly
Message-ID: <agcdxIFQ8QBI9R6z@KASONG-MC4>
References: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
 <20260515-swap-table-p4-v4-4-f1b49e845a8d@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260515-swap-table-p4-v4-4-f1b49e845a8d@tencent.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9ADB01A0002
X-Rspam-User: 
X-Stat-Signature: zisnswuj3nxk3uz3u994u8j67xp9gux6
X-HE-Tag: 1778852799-592606
X-HE-Meta: U2FsdGVkX18Ewa2yDG6TjYglT7M1l2slfqaE7Vbkil++avCpWpXQskkwVYYktdLTpNo0KAuGjwK2n8w71v4OOQYxARxCRKQVF42fRbTZRNikUI9td8t00i2CAE6zSvqX6vYozuSyfL26wfZc0wf8cZyzwPYvCrzXyxw2rKRNjVlIKS7CGT3Gf1+64INv2bWSW+uAr8UfNOIwigI5WzWkVOqXwPR8eLJOG+Ym8ulEp3cO2vBrk73hd5Vm97z6y3ZA+lEUlB9OkUPFKuGOL/97iy83AxL3HRpWbZGPUoH2gYZGvGsfU0XwOJqcJ6dIaHgiauZMZXoi9DINkgnVL1QaVbFeB5HhzWmcdM323NA/nE7EwMQx0t2cBH72brqxLbu/wGPcgi0A9n1omLb/0xjbrZ9gk1f8IdoBsqKGaUxDsyxD6bO1J17aCMHrVcQdaRgEGJso6kkW6Tmt8r7hThI1uppVbV1AokG1auBxynP2iLu19Tz+lbt5H7lB1p9tXXgVXX2LEkXP5v13zUV+9J+WrWZiQFPuqEopCYmCMDPEsQXgY9mgEKub8I8qKa1wnUZQnbnmZxr3ALmL6mYm3poPFV0OsmHMmpALYt190fXzCP+FLkSdyyd6NRy6A+bobaLwABnM9eyqmhC02hMImfC+1/c/epQHrKSNWoXZZETT7ktO4lES5FpsCbRLYjJJOtsEwLyqu0cPjRzWPg6qqftRI9fMDBcrN5NR8kibYa8GvvthcImBPPDGbLAlwgKohI4dHK1cJewF8Dxrel+cuq8pAGnwNPJEHd9ajJIpZTjfPKPgI0gTkeNXoar3uGSTWtZIqUrsAnp3U1ifB9dbAUp+82KazxKM0smdnbcGCGfzIp3AmlCh4BJ6441N/yXFGET5NeAV8pfqFW8qxYAeVglCBM2uyZBIe3YggzhVL4/vaVvsb2FDusQgihE9/mDG9LB64rIxBeHKzAxmawwOdYh
 Kyn/bc96
 UV09ZEzqwD3iFUM4VCHuY9NFfNd1C6gT4l+cMS+4401wmo1VRU3COJMxwNCgeFLGSADY0ahKUq1PERnAUxoAIasHVHApdJvtsHFsyJVHAuYHLMeKc5d+iIuAS5mgEDVFDju4rR0NvYT0XftnI68rfeLtYmpl45bPXuhwi4yXMzbpAsNYub1ob/Gu5GqHtKPrg6w3ZLWBWeJUxJqDUnJV2HceVyc1amP2DEWzW7+e2EKkJw+AGQfW+mBm+1LmJ4sMqLdAzyRMgCGrLpVoIyE+gavSX90sX1CQxG+AVGvKHfAW7E53sFUlt5TNMW9kWl89Y0KfOTr6CRDr5jT88GeTqpdvaprOGV+ZZ2ejEMurweIJKHJ8S27HWANIyhKZdKPHOuHHwy7xmCf8f22w1/QqDRpNAjRFX44YTVd/PJ4byzxVxlcxSmpy0BvdRu9BCg9Y+V6hNAPl72i0xHrB3J8RuEr1xsPyaD8jErt/D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 05:54:17PM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To make it possible to allocate large folios directly in swap cache,
> provide a new infrastructure helper to handle the swap cache status
> check, allocation, and order fallback in the swap cache layer
> 
> The new helper replaces the existing swap_cache_alloc_folio. Based on
> this, all the separate swap folio allocation that is being done by anon
> / shmem before is converted to use this helper directly, unifying folio
> allocation for anon, shmem, and readahead.
> 
> This slightly consolidates how allocation is synchronized, making it
> more stable and less prone to errors. The slot-count and cache-conflict
> check is now always performed with the cluster lock held before
> allocation, and repeated under the same lock right before cache
> insertion. This double check produces a stable result compared to the
> previous anon and shmem mTHP allocation implementation,  avoids the
> false-negative conflict checks that the lockless path can return — large
> allocations no longer have to be unwound because the range turned out to
> be occupied — and aborts early for already-freed slots, which helps
> ordinary swapin and especially readahead, with only a marginal increase
> in cluster-lock contention (the lock is very lightly contended and stays
> local in the first place). Hence, callers of swap_cache_alloc_folio() no
> longer need to check the swap slot count or swap cache status
> themselves.
> 
> And now whoever first successfully allocates a folio in the swap cache
> will be the one who charges it and performs the swap-in. The race window
> of swapping is also reduced since the loop is much more compact.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h       |   3 +-
>  mm/swap_state.c | 234 +++++++++++++++++++++++++++++++++++++++-----------------
>  mm/zswap.c      |   2 +-
>  3 files changed, 168 insertions(+), 71 deletions(-)
> 
> diff --git a/mm/swap.h b/mm/swap.h
> index ad8b17a93758..6774af10a943 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -280,7 +280,8 @@ bool swap_cache_has_folio(swp_entry_t entry);
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_del_folio(struct folio *folio);
> -struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
> +struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
> +				     unsigned long orders, struct vm_fault *vmf,
>  				     struct mempolicy *mpol, pgoff_t ilx);
>  /* Below helpers require the caller to lock and pass in the swap cluster. */
>  void __swap_cache_add_folio(struct swap_cluster_info *ci,
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 89fa19ec13f6..cd4543ff5e47 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -139,10 +139,10 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>  
>  /**
>   * __swap_cache_add_check - Check if a range is suitable for adding a folio.
> - * @ci: The locked swap cluster.
> - * @ci_off: Range start offset.
> - * @nr: Number of slots to check.
> - * @shadow: Returns the shadow value if one exists in the range.
> + * @ci: The locked swap cluster
> + * @targ_entry: The target swap entry to check, will be rounded down by @nr
> + * @nr: Number of slots to check, must be a power of 2
> + * @shadowp: Returns the shadow value if one exists in the range.
>   *
>   * Check if all slots covered by given range have a swap count >= 1.
>   * Retrieves the shadow if there is one.
> @@ -151,26 +151,40 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>   * Return: 0 if success, error code if failed.
>   */
>  static int __swap_cache_add_check(struct swap_cluster_info *ci,
> -				  unsigned int ci_off, unsigned int nr,
> -				  void **shadow)
> +				  swp_entry_t targ_entry,
> +				  unsigned long nr, void **shadowp)
>  {
> -	unsigned int ci_end = ci_off + nr;
> +	unsigned int ci_off, ci_end;
>  	unsigned long old_tb;
>  
>  	lockdep_assert_held(&ci->lock);
> -	if (WARN_ON_ONCE(ci_off >= SWAPFILE_CLUSTER))
> -		return -EINVAL;
>  
> +	/*
> +	 * If the target slot is not swapped out or already cached, return
> +	 * -ENOENT or -EEXIST. If the batch is not suitable, could be a
> +	 * race with concurrent free or cache add, return -EBUSY.
> +	 */
>  	if (unlikely(!ci->table))
>  		return -ENOENT;
> +	ci_off = swp_cluster_offset(targ_entry);
> +	old_tb = __swap_table_get(ci, ci_off);
> +	if (swp_tb_is_folio(old_tb))
> +		return -EEXIST;
> +	if (!__swp_tb_get_count(old_tb))
> +		return -ENOENT;
> +	if (swp_tb_is_shadow(old_tb) && shadowp)
> +		*shadowp = swp_tb_to_shadow(old_tb);
> +
> +	if (nr == 1)
> +		return 0;
> +
> +	ci_off = round_down(ci_off, nr);
> +	ci_end = ci_off + nr;
>  	do {
>  		old_tb = __swap_table_get(ci, ci_off);
> -		if (unlikely(swp_tb_is_folio(old_tb)))
> -			return -EEXIST;
> -		if (unlikely(!__swp_tb_get_count(old_tb)))
> -			return -ENOENT;
> -		if (swp_tb_is_shadow(old_tb))
> -			*shadow = swp_tb_to_shadow(old_tb);
> +		if (unlikely(swp_tb_is_folio(old_tb) ||
> +			     !__swp_tb_get_count(old_tb)))
> +			return -EBUSY;
>  	} while (++ci_off < ci_end);
>  
>  	return 0;
> @@ -241,15 +255,13 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
>  {
>  	int err;
>  	void *shadow = NULL;
> -	unsigned int ci_off;
>  	struct swap_info_struct *si;
>  	struct swap_cluster_info *ci;
>  	unsigned long nr_pages = folio_nr_pages(folio);
>  
>  	si = __swap_entry_to_info(entry);
>  	ci = swap_cluster_lock(si, swp_offset(entry));
> -	ci_off = swp_cluster_offset(entry);
> -	err = __swap_cache_add_check(ci, ci_off, nr_pages, &shadow);
> +	err = __swap_cache_add_check(ci, entry, nr_pages, &shadow);
>  	if (err) {
>  		swap_cluster_unlock(ci);
>  		return err;
> @@ -404,6 +416,140 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>  	}
>  }
>  
> +/*
> + * Try to allocate a folio of given order in the swap cache.
> + *
> + * This helper resolves the potential races of swap allocation
> + * and prepares a folio to be used for swap IO. May return following
> + * value:
> + *
> + * -ENOMEM / -EBUSY: Order is too large or in conflict with sub slot,
> + *                   caller should shrink the order and retry
> + * -ENOENT / -EEXIST: Target swap entry is unavailable or cached, the caller
> + *                    should abort or try to use the cached folio instead
> + */
> +static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> +					swp_entry_t targ_entry, gfp_t gfp,
> +					unsigned int order, struct vm_fault *vmf,
> +					struct mempolicy *mpol, pgoff_t ilx)
> +{
> +	int err;
> +	swp_entry_t entry;
> +	struct folio *folio;
> +	void *shadow = NULL;
> +	unsigned long address, nr_pages = 1UL << order;
> +	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
> +
> +	VM_WARN_ON_ONCE(nr_pages > SWAPFILE_CLUSTER);
> +	entry.val = round_down(targ_entry.val, nr_pages);
> +
> +	/* Check if the slot and range are available, skip allocation if not */
> +	spin_lock(&ci->lock);
> +	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL);
> +	spin_unlock(&ci->lock);
> +	if (unlikely(err))
> +		return ERR_PTR(err);
> +
> +	/*
> +	 * Limit THP gfp. The limitation is a no-op for typical
> +	 * GFP_HIGHUSER_MOVABLE but matters for shmem.
> +	 */
> +	if (order)
> +		gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
> +
> +	if (mpol || !vmf) {
> +		folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
> +	} else {
> +		address = round_down(vmf->address, PAGE_SIZE << order);
> +		folio = vma_alloc_folio(gfp, order, vmf->vma, address);
> +	}
> +	if (unlikely(!folio))
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Double check the range is still not in conflict */
> +	spin_lock(&ci->lock);
> +	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow);
> +	if (unlikely(err)) {
> +		spin_unlock(&ci->lock);
> +		folio_put(folio);
> +		return ERR_PTR(err);
> +	}
> +
> +	__folio_set_locked(folio);
> +	__folio_set_swapbacked(folio);
> +	__swap_cache_do_add_folio(ci, folio, entry);
> +	spin_unlock(&ci->lock);
> +
> +	if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm : NULL,
> +					   gfp, entry)) {
> +		spin_lock(&ci->lock);
> +		__swap_cache_do_del_folio(ci, folio, entry, shadow);
> +		spin_unlock(&ci->lock);
> +		folio_unlock(folio);
> +		/* nr_pages refs from swap cache, 1 from allocation */
> +		folio_put_refs(folio, nr_pages + 1);
> +		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* For memsw accounting, swap is uncharged when folio is added to swap cache */
> +	memcg1_swapin(entry, 1 << order);
> +	if (shadow)
> +		workingset_refault(folio, shadow);
> +
> +	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> +	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> +
> +	/* Caller will initiate read into locked new_folio */
> +	folio_add_lru(folio);
> +	return folio;
> +}
> +
> +/**
> + * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
> + * @targ_entry: swap entry indicating the target slot
> + * @gfp: memory allocation flags
> + * @orders: allocation orders, must be non zero
> + * @vmf: fault information
> + * @mpol: NUMA memory allocation policy to be applied
> + * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> + *
> + * Allocate a folio in the swap cache for one swap slot, typically before
> + * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
> + * @targ_entry must have a non-zero swap count (swapped out).
> + *
> + * Context: Caller must protect the swap device with reference count or locks.
> + * Return: Returns the folio if allocation succeeded and folio is in the swap
> + * cache. Returns error code if failed due to race, OOM or invalid arguments.
> + */
> +struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> +				     unsigned long orders, struct vm_fault *vmf,
> +				     struct mempolicy *mpol, pgoff_t ilx)
> +{
> +	int order, err;
> +	struct folio *ret;
> +	struct swap_cluster_info *ci;
> +
> +	if (WARN_ON_ONCE(!orders))
> +		return ERR_PTR(-EINVAL);
> +
> +	ci = __swap_entry_to_cluster(targ_entry);
> +	order = highest_order(orders);
> +	while (orders) {
> +		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
> +					 vmf, mpol, ilx);
> +		if (!IS_ERR(ret))
> +			break;
> +		err = PTR_ERR(ret);
> +		if (err && err != -EBUSY && err != -ENOMEM)
> +			break;
> +		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> +		order = next_order(&orders, order);
> +	}

I just realized that with !CONFIG_TRANSPARENT_HUGEPAGE,
next_order(&orders, order) won't modify orders so this loop won't
break properly for !CONFIG_TRANSPARENT_HUGEPAGE build.

So V4 is not correct here. I did a "cleanup" since V4 removed
the forced order 0 fallback. The cleanup is wrong. We need to revert
this loop part back to V3 by squashing this:

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 7701fa4b981c..60f93995e492 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -508,13 +508,13 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 
        ci = __swap_entry_to_cluster(targ_entry);
        order = highest_order(orders);
-       while (orders) {
+       for (;;) {
                ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
                                         vmf, mpol, ilx);
                if (!IS_ERR(ret))
                        break;
                err = PTR_ERR(ret);
-               if (err && err != -EBUSY && err != -ENOMEM)
+               if (!order || (err && err != -EBUSY && err != -ENOMEM))
                        break;
                count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
                order = next_order(&orders, order);

---

Other than that this should be good.

