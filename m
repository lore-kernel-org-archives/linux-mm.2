Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 450B8CF8547
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E66C6B0012; Thu, 20 Nov 2025 01:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFB96B0022; Thu, 20 Nov 2025 01:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD8A6B0026; Thu, 20 Nov 2025 01:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA926B0012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:47:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E323DC070C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:47:54 +0000 (UTC)
X-FDA: 84130055268.08.13449FC
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf05.hostedemail.com (Postfix) with ESMTP id AFE5410000F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:47:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763621273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O7SUDZBedgcdkQbz39P6KzsbKvp2K2hbEcdsNeEtLH0=;
	b=wV7Cppm+pYxbn83cddfKyap/19aMlKwCPCc1HyBmXS8/lbpcODTtx/Bo7FHzQhNIgq79cT
	KW8nlLGKPRsJsBBy0+0hDBOdZLLYeK1siBQ6PaxrRDOsjvB0gJqGWtfKtrXPJFtEfN19Dg
	BGpRdFUBTww4vl2vBTh/ZPVygcsPwY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763621273; a=rsa-sha256;
	cv=none;
	b=eh5VnVl5kZmTINIF1/6GShM02UnW8x7/gbumN2fx7qdX5mKu5hT4MhDY0wpFQ/O5hqmBu/
	27uyscFJPIHN2+0KGMHiJpjczn5rV5dXFVWhg9/Zpb46Ea9p2L10QTz/wFLBK2cA/sUiBr
	VclBii5ILdy8O/Duax6m2xIw10aeIBg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 20 Nov 2025 15:47:47 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 20 Nov 2025 15:47:47 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 10/19] mm, swap: consolidate cluster reclaim and check
 logic
Message-ID: <aR65k5Xxl28MvMcf@yjaykim-PowerEdge-T330>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: AFE5410000F
X-Stat-Signature: w863utw8y9o13a48bbjq6rsq5mn8ot31
X-HE-Tag: 1763621271-904779
X-HE-Meta: U2FsdGVkX1/JSn5XuGdf3RHY1y0KNj70rVLjOZbLXBGPA5PcLjTusicshdRmlNKbTF+CjzDDoEDRlMtmjVytXJUcbqcebaotB3xL4HedOHDPtC3a34LeFiJr/C2lF5uqjI2oQtIlhAoKwvF3puLdoJBHrizh53ZE4n31TYEuSgLzhnJn9QHfubpoUTyqBlXevpJ9qXJgYJHYeglr1EnenqdunahtL03ME/JwcKkLONb9I+cz6BS5bgSXcC8VIC47pj2gaVL8E9IpX2Nokfk5iZUhCIwMHddRF8t9cIndU5jIBWpkKekrmSHGrbtiXG/qzxaO5XhVsmr8JdMwHwWcmxoFEKSqqm2sV6hzvSbbTVbV84ZUmKgskpzNSyWQmkQfiIByI6shSanYfGWrc91PT4bSu6PUy9MHtqrlvbNH+I4pBMHwPYpbhFUTQOP0QBoAQXvLNqpn3PdObmQ9tQrL04I0LU97t5qMjJA821Nc1NQwA4bMtFrk5VPes0UFEb+5CNU/rByIN1JK1sjC2DuYZf2wHZmqyH05/M1dP1qX4EZMPkZMeqtAqT989mB/fDYpj8TrY9GYMp7vEJhETuetLK/eMM9S2hd02L2B6uaISnU9etj30GnqLEieA+zygi23+Aek7ptA/7VJzteCHL97++IWqMOVYL8NqH9WheTZwuruyCsR7AzI+rbw/qhHkLUVQCHCS9ZvWeUKRsKVDpKQsV4oMKcsc/IAMsHXTYRkMB8qVqoLM38LY0BwVYWY2fAiOBYdvS291ReOJO3mWBMpAjQPpO+5y+fy0pN/y7w8VPSoKnx/oXMVmsgbho+S4XajEHSv9T/GxVgH0PsS2qhLVPNvgQZ+H4W6K7vm2inACcTVEEzcYh44Bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 02:11:51AM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Swap cluster cache reclaim requires releasing the lock, so some extra
> checks are needed after the reclaim. To prepare for checking swap cache
> using the swap table directly, consolidate the swap cluster reclaim and
> check the logic.
> 
> Also, adjust it very slightly. By moving the cluster empty and usable
> check into the reclaim helper, it will avoid a redundant scan of the
> slots if the cluster is empty.
> 
> And always scan the whole region during reclaim, don't skip slots
> covered by a reclaimed folio. Because the reclaim is lockless, it's
> possible that new cache lands at any time. And for allocation, we want
> all caches to be reclaimed to avoid fragmentation. And besides, if the
> scan offset is not aligned with the size of the reclaimed folio, we are
> skipping some existing caches.
> 
> There should be no observable behavior change, which might slightly
> improve the fragmentation issue or performance.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 45 +++++++++++++++++++++++----------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d2e60734ce8f..d57e83a4d0a7 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -778,42 +778,50 @@ static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
>  	return 0;
>  }
>  
> -static bool cluster_reclaim_range(struct swap_info_struct *si,
> -				  struct swap_cluster_info *ci,
> -				  unsigned long start, unsigned long end)
> +static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
> +					  struct swap_cluster_info *ci,
> +					  unsigned long start, unsigned int order)
>  {
> +	unsigned int nr_pages = 1 << order;
> +	unsigned long offset = start, end = start + nr_pages;
>  	unsigned char *map = si->swap_map;
> -	unsigned long offset = start;
>  	int nr_reclaim;
>  
>  	spin_unlock(&ci->lock);
>  	do {
>  		switch (READ_ONCE(map[offset])) {
>  		case 0:
> -			offset++;
>  			break;
>  		case SWAP_HAS_CACHE:
>  			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
> -			if (nr_reclaim > 0)
> -				offset += nr_reclaim;
> -			else
> +			if (nr_reclaim < 0)
>  				goto out;
>  			break;
>  		default:
>  			goto out;
>  		}
> -	} while (offset < end);
> +	} while (++offset < end);
>  out:
>  	spin_lock(&ci->lock);
> +
> +	/*
> +	 * We just dropped ci->lock so cluster could be used by another
> +	 * order or got freed, check if it's still usable or empty.
> +	 */
> +	if (!cluster_is_usable(ci, order))
> +		return SWAP_ENTRY_INVALID;
> +	if (cluster_is_empty(ci))
> +		return cluster_offset(si, ci);
> +
>  	/*
>  	 * Recheck the range no matter reclaim succeeded or not, the slot
>  	 * could have been be freed while we are not holding the lock.
>  	 */
>  	for (offset = start; offset < end; offset++)
>  		if (READ_ONCE(map[offset]))
> -			return false;
> +			return SWAP_ENTRY_INVALID;
>  
> -	return true;
> +	return start;
>  }
>  
>  static bool cluster_scan_range(struct swap_info_struct *si,
> @@ -901,7 +909,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
>  	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
>  	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);

The Original code. I'm wondering if there's an off-by-one error here. Looking at the code
below, it seems the design allows the end offset to go through the
logic as well. Shouldn't it be 'start + SWAPFILE_CLUSTER - 1' and
'si->max - 1'?

>  	unsigned int nr_pages = 1 << order;
> -	bool need_reclaim, ret;
> +	bool need_reclaim;
>  
>  	lockdep_assert_held(&ci->lock);
>  
> @@ -913,20 +921,13 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
>  		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
>  			continue;
>  		if (need_reclaim) {
> -			ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
> -			/*
> -			 * Reclaim drops ci->lock and cluster could be used
> -			 * by another order. Not checking flag as off-list
> -			 * cluster has no flag set, and change of list
> -			 * won't cause fragmentation.
> -			 */
> +			found = cluster_reclaim_range(si, ci, offset, order);
>  			if (!cluster_is_usable(ci, order))
>  				goto out;

This check resolves the issue I mentioned in my previous review.

> -			if (cluster_is_empty(ci))
> -				offset = start;
>  			/* Reclaim failed but cluster is usable, try next */
> -			if (!ret)
> +			if (!found)
>  				continue;
> +			offset = found;
>  		}
>  		if (!cluster_alloc_range(si, ci, offset, usage, order))
>  			break;

I think the reason cluster_is_usable() is checked redundantly here is
because cluster_reclaim_range() returns an unsigned int (offset), making
it impossible to distinguish error values.

What if we make offset an output parameter (satisfying the assumption
that it can be changed in reclaim_range) and return an error value
instead? This would eliminate the redundant cluster_is_usable() check
and simplify the logic. Also, the consecutive "offset = found, found =
offset" is a bit confusing, and this approach could eliminate that as
well.

What do you think?

Thnaks!

Youngjun Park
> -- 
> 2.51.2
> 
> 

