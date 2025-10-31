Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3D6CCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 05:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C188E0085; Fri, 31 Oct 2025 01:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263C08E0045; Fri, 31 Oct 2025 01:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0E58E0085; Fri, 31 Oct 2025 01:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05C9A8E0045
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:25:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92AE41A0388
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:25:36 +0000 (UTC)
X-FDA: 84057271872.03.1AB6177
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4118E100005
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:25:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761888335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqAuPk2wUFafneP8EmOrowAVp/6+UHRr0Gjz+pCww50=;
	b=VVD+AfKXb7eLKSyrz0tCR2zS+PU8uK3PyvPpRgLSOprQv9S2B8DIe/YRZ6fdpCmo2qLPn9
	wgpPdotIDR+c1Er4dbWNpNbB4N+f2sjGzeSAfdETDJIUAnSnEumN0hBbKyWmC/fk6I5W9k
	no8/7PPzLQ6wfORmwjHwj/xW8qSEePY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761888335; a=rsa-sha256;
	cv=none;
	b=W9Or8X0dsK4w/MwU80H/muLfxXWIgBFOwKGc0wBGDOAIBg5BLzWs1k5RB28zqUsHT2KuPJ
	LUIAveA0KgyAa5ZEFnVHV18FXw/MFGdphKUmoB2Y8j8SBTKoBHzoEUyorjAbETyY8AOeyt
	yKcgc4jkWneK9XSQ/HA+A3PyU4i5BTA=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 31 Oct 2025 14:25:29 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 31 Oct 2025 14:25:12 +0900
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
Subject: Re: [PATCH 10/19] mm, swap: consolidate cluster reclaim and check
 logic
Message-ID: <aQRIOMsAkDciWFw/@yjaykim-PowerEdge-T330>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-10-3d43f3b6ec32@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-swap-table-p2-v1-10-3d43f3b6ec32@tencent.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4118E100005
X-Stat-Signature: 95ycwat7s1i7eknau89ancpo5p13ykhm
X-Rspam-User: 
X-HE-Tag: 1761888332-70549
X-HE-Meta: U2FsdGVkX1/dFKVPcBOiwWS7zBnqDY8TbEysKBN6ErHXkTTqZUR9FaSBPWdWZI6A7bjqVoPcxlN+/iBpr8SMD6r7UzJRmV7WHhO87cmDo0KL9cxLSGm0IQBO7KL2VP8mhNyIgys6g/9y99zhd7a8+MzGlH0vQOF/gs3dcqo2WyrrtVwAUP6HObBwdZoWZ2NBlMuLWJwPmyE9fSt71kM/6cUSMNXGyDF9pPFWfcjaajk0fz67kRX24EEe0u9zYTwbg3uwW+HacH1nONjfJTlL2HuMVcy37S+Iuk01E45QMNPju6qSnYgEQ1Hh19dpY1Lp/hhPcsQp3M9nb8CVIM0SEksxm/RcAYiP8tbuQMp5ox/i8xgD9e5cjzJRHBcwwf09SMFsxxj65U0kQfvceW5iJLmZlugitajHR20dFDcGDKfZ+ylSYbLjow36mJLvfWyWzIdz6bRy7C6G8sT5azszsank8Z3CsQDJeuK3W1NQnvhmdQAr/gbt22jVQFjClD5ECD/yRAxlHWvO+301tXxw4QfkfadfjYq2dlXd6oPbTBwrmYNS/QaHTMB2ulIDa1X1p/qqYwpMbqDWijhl7G8g1bRnhYnPDiMiNd6rZDzwqnjBAOt5uIPhYLQzWoNeLqZln63+dY7PNJ8S4ncqpcBAJAz3O8C03X3jqGSqZadpceq9drSq2D/P09QuGffnxxYXnTle32kltpIYX6JxOSSQ/T3qnc4o7w+/H3BDCLanwFVKKOmM3pmnWI6dozyWrE4zOqQW+EmSflg/sG8URkpTn0bktcxAoLqX7N0csvrg4z9yNv0rL7cfjoPOVvGvLqxY+aRIp7vy69mjPgig1TRoct+QCUVeDgS3E2e8lYIhlYaH2RKKmU3UP+aUXmdAlrDh2Up9L1fevZV29uHbd1nTbDm6QB+ub/F4o9CXgV1JSZAKK3Nm0ClFaLfJ3bECntXPeRj7QS87+23KV3y4Yhx
 pX+oauN1
 rsXxxRlEpEbc9d5zeK144JHV+4TE5bFDVcxytqMWYQWeXPvoa04pIxtLoiZIn6LFfZG+73SJ+zzKMrOk7aemOaW57E6HqWq7OlJSJgIlhamXQHa66vqcSStGzEBd4EOTu9LOvJKvpeu1cKVAwy5SXbN6eFmhDVWYEhB6zjm9UzPaI2HosIXeP19TibUsvz+tCee45Seds1WIxaeUiE4g+j05dibIvG8KLDfnwYIhg4gdJBN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:58:36PM +0800, Kairui Song wrote:

> From: Kairui Song <kasong@tencent.com>
> 

Hello Kairu, great work on your patchwork. :)                                    
> Swap cluster cache reclaim requires releasing the lock, so some extra
> checks are needed after the reclaim. To prepare for checking swap cache
> using the swap table directly, consolidate the swap cluster reclaim and
> check the logic.
> 
> Also, adjust it very slightly. By moving the cluster empty and usable
> check into the reclaim helper, it will avoid a redundant scan of the
> slots if the cluster is empty.

This is Change 1

> And always scan the whole region during reclaim, don't skip slots
> covered by a reclaimed folio. Because the reclaim is lockless, it's
> possible that new cache lands at any time. And for allocation, we want
> all caches to be reclaimed to avoid fragmentation. And besides, if the
> scan offset is not aligned with the size of the reclaimed folio, we are
> skipping some existing caches.

This is Change 2

> There should be no observable behavior change, which might slightly
> improve the fragmentation issue or performance.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 47 +++++++++++++++++++++++------------------------
>  1 file changed, 23 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d66141f1c452..e4c521528817 100644
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

Change 2

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

Change 1

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
>  	unsigned int nr_pages = 1 << order;
> -	bool need_reclaim, ret;
> +	bool need_reclaim;
>  
>  	lockdep_assert_held(&ci->lock);
>  
> @@ -913,20 +921,11 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
> -			if (!cluster_is_usable(ci, order))
> -				goto out;
> -			if (cluster_is_empty(ci))
> -				offset = start;
> +			found = cluster_reclaim_range(si, ci, offset, order);
>  			/* Reclaim failed but cluster is usable, try next */
> -			if (!ret)

Part of Change 1 (apply return value change)

As I understand Change 1 just remove redudant checking.
But, I think another part changed also.
(maybe I don't fully understand comment or something)

cluster_reclaim_range can return SWAP_ENTRY_INVALID
if the cluster becomes unusable for the requested order. 
(!cluster_is_usable return SWAP_ENTRY_INVALID)
And it continues loop to the next offset for reclaim try.
Is this the intended behavior?

If this is the intended behavior, the comment:
    /* Reclaim failed but cluster is usable, try next */
might be a bit misleading, as the cluster could be unusable in this
failure case. Perhaps it could be updated to reflect this? 
Or I think any other thing need to be changed..? 
(cluster_is_usable function name change etc)

Thanks.
Youngjun Park

