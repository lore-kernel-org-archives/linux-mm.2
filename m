Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3729CD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 04:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA5E6B0006; Sun, 14 Dec 2025 23:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C24C6B0008; Sun, 14 Dec 2025 23:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8676B000A; Sun, 14 Dec 2025 23:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0626B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:13:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AA3D140DE9
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:13:10 +0000 (UTC)
X-FDA: 84220385340.28.6DD450E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3034940002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:13:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X7Y7eIok;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765771988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tfnd8QOpt3biOWyVmRNtULIkeysgwJ1eAPZzg5ISCgk=;
	b=fGx2ekWHGN40kj23cd5JXwnziW7KKEsos8XQGHTUQQ7z5ciFKAVnzVmy4oepSmh8gZ/7ZZ
	lYX5o2MGyDUkT98HnYz1DeTE0gnrmz9kIxZdM2wFe+RLXHJdS/RFzHon8LH7wh//gcLJjD
	OMxlNq62HwIEpgbOrX0NpPS6h48H9Yk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X7Y7eIok;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765771988; a=rsa-sha256;
	cv=none;
	b=wyEdIjR/EDyxpAfkRLP+/SP7R49f1S6rt/d4Gzb4Oxc9jrOqHZ13a5A8ktnkqall++widy
	XadGjY98rPmUNrUsRpz5x6KutObmuElPKCLHpDnZvRgUd+Ez00FU9B7PxknMQbipReBjju
	Ip+PFA4lP1PHaUyjTGvC4uvFc4nLoLs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765771987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tfnd8QOpt3biOWyVmRNtULIkeysgwJ1eAPZzg5ISCgk=;
	b=X7Y7eIok70fh0XIR8PqqdBIH6OdXmn39oxfmqCsl1TZ6qCF2L5kApSdSpo3oDLnqo41Mgn
	s/LQBvc/37xCK4suBDngm601JC4hkNbMzlqAyoddm2ZKrz7oMmDsFLtQV6SnT5usIrv/Yj
	aJgtlWy6ALcOKbxtmEPfGbOk9MaQbWU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-RTWczNdqM_6uP8R1vnF15w-1; Sun,
 14 Dec 2025 23:13:00 -0500
X-MC-Unique: RTWczNdqM_6uP8R1vnF15w-1
X-Mimecast-MFC-AGG-ID: RTWczNdqM_6uP8R1vnF15w_1765771978
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9CC91956050;
	Mon, 15 Dec 2025 04:12:56 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E9A819560B4;
	Mon, 15 Dec 2025 04:12:54 +0000 (UTC)
Date: Mon, 15 Dec 2025 12:12:45 +0800
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
Subject: Re: [PATCH v4 10/19] mm, swap: consolidate cluster reclaim and
 usability check
Message-ID: <aT+KvZplFPimgStY@MiWiFi-R3L-srv>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-10-cb7e28a26a40@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205-swap-table-p2-v4-10-cb7e28a26a40@tencent.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam02
X-Stat-Signature: kafd6xu689iq7ar1eh3yek51141ohhnc
X-Rspam-User: 
X-Rspamd-Queue-Id: 3034940002
X-HE-Tag: 1765771988-535145
X-HE-Meta: U2FsdGVkX1+V6C7+JiZnjpJuOwVzYD/wXs471zqN90BvdhM4N26nyVT4fpEO5Nn27XxLBKOG/eJQoPh7f0DrjuamGfdE5M5ObBDC9MdxZrr/g2/S158k60DAlPNUUBae+iMPlYoOlXAGMumZL7R7AwrSB95HlxflMllUneST7dbTbdR68PvUQBJq7QvcYr/iBRFRwpFJV+eVlEXrEOVimPSHYUB8Ygb2kM+QZWXwlXVdWXc7zB4Yg/1VfrK5jrBLwQswhWltwW70YujhNQ3t29qHfHEAZkdi/63lMwv5sdTG3mHl10YMRFu0XKYPDuG3VqpRJvO18/c/5IvS4VafeBtg19jwbXzuCFphITJ+5mSVfyQKSZDWoRAejmebKSf2Z5nirc1LTPKa/OiMQvkM2bcic2Nkfy+UjkKmczWBxGOQeHGb3bx9lG6lJ1Afg8UFUgumnMPy30HUxDSzlxcPSUUsIvA8B4oHRx8h8DROBzWcBMA37fNmpm7ZGJWzkQkEHmNlav+gYlNVRVNDjQEL5tcRkaZoKCyWKt6YNCpiwBQScoJ8UUJUJkFUt7L9Z31ebaQ20cJworfsgZusLlqsdTLUq/tGyg6JM/PAYsBo7W8cDJQI/rONzDM3UsX97vH48gGgdCesylf+AOVAa48afJSewuRzF8FnMX5vCTWr0ZymYl1Fj8focSPt3DTY6fD6r791r+AF5Sb4GVv7luetrq/M35lIse+T20WnDvsJZWUu9b2RMd2TU+cWVrXzHT9HylIvKo4qZ8NVpmvGk6J4Eyetrg70+8M31pGQ2qHRwaYgvU77J7bTxpCg1xhpx9t7lIl2xJCgQBVpMG5Yu4HxuITC2WFDKhLgrltVC9gVxz9W8U7M9zgTerWdT7RxAJCpuAG+g0EX1FTskYQ7rdSdkKGwaTIIVRctUqp4VtCKf3Kqxxgufy6QIwC6Xu9vFhC80rp++g5m9b6W5EJypue
 oUldShJW
 h9OiQ4sW8endRHSHwgtSBe6HWaovlxr7mXnIXA0iw2Id234sGmkcjHq4NrdDFjMEry0Q9eVOf7/sZTyT2KsfqmLcrbhX+zYfF5s+377G3Mt06M6U=
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
> Swap cluster cache reclaim requires releasing the lock, so the cluster
> may become unusable after the reclaim. To prepare for checking swap
> cache using the swap table directly, consolidate the swap cluster
> reclaim and the check logic.
> 
> We will want to avoid touching the cluster's data completely with the
     ~~~~~~~~
    'want to' means 'will'?

> swap table, to avoid RCU overhead here. And by moving the cluster usable
> check into the reclaim helper, it will also help avoid a redundant scan of
> the slots if the cluster is no longer usable, and we will want to avoid
                                                       ~~~~~~~~~~~~
                                                        this place too.
> touching the cluster.
> 
> Also, adjust it very slightly while at it: always scan the whole region
> during reclaim, don't skip slots covered by a reclaimed folio. Because
> the reclaim is lockless, it's possible that new cache lands at any time.
> And for allocation, we want all caches to be reclaimed to avoid
> fragmentation. Besides, if the scan offset is not aligned with the size
> of the reclaimed folio, we might skip some existing cache and fail the
> reclaim unexpectedly.
> 
> There should be no observable behavior change. It might slightly improve
> the fragmentation issue or performance.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 45 +++++++++++++++++++++++++++++----------------
>  1 file changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5a766d4fcaa5..2703dfafc632 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
>  	return 0;
>  }
>  
> +/*
> + * Reclaim drops the ci lock, so the cluster may become unusable (freed or
> + * stolen by a lower order). @usable will be set to false if that happens.
> + */
>  static bool cluster_reclaim_range(struct swap_info_struct *si,
>  				  struct swap_cluster_info *ci,
> -				  unsigned long start, unsigned long end)
> +				  unsigned long start, unsigned int order,
> +				  bool *usable)
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
                 ~~~~~ '++offset' is conflicting with nr_reclaim
                 returned from __try_to_reclaim_swap(). can you explain?
>  out:
>  	spin_lock(&ci->lock);
> +
> +	/*
> +	 * We just dropped ci->lock so cluster could be used by another
> +	 * order or got freed, check if it's still usable or empty.
> +	 */
> +	if (!cluster_is_usable(ci, order)) {
> +		*usable = false;
> +		return false;
> +	}
> +	*usable = true;
> +
> +	/* Fast path, no need to scan if the whole cluster is empty */
> +	if (cluster_is_empty(ci))
> +		return true;
> +
>  	/*
>  	 * Recheck the range no matter reclaim succeeded or not, the slot
>  	 * could have been be freed while we are not holding the lock.
> @@ -900,9 +918,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
>  	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
>  	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
>  	unsigned int nr_pages = 1 << order;
> -	bool need_reclaim, ret;
> +	bool need_reclaim, ret, usable;
>  
>  	lockdep_assert_held(&ci->lock);
> +	VM_WARN_ON(!cluster_is_usable(ci, order));
>  
>  	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
>  		goto out;
> @@ -912,14 +931,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
> +			ret = cluster_reclaim_range(si, ci, offset, order, &usable);
> +			if (!usable)
>  				goto out;
>  			if (cluster_is_empty(ci))
>  				offset = start;
> 
> -- 
> 2.52.0
> 


