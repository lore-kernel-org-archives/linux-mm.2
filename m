Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 867F4CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B868E000D; Fri, 12 Sep 2025 04:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02A08E0001; Fri, 12 Sep 2025 04:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FBB8E000D; Fri, 12 Sep 2025 04:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B29CA8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:22:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 687711DF5F3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:22:13 +0000 (UTC)
X-FDA: 83879905746.25.12A409B
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57E3AC0004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:22:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="vJSZd/En";
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757665331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a04ysXcVM3EZCSALMoyb9EewsnLnr/d3s7vYk7XR0aY=;
	b=wLs1XYHo02FYF0WbIlDvzwQsQmMEI38pYeCHWcE6QRnG+aAIudvRUWbWx505q+G5Ip3WG4
	UlfiPW5VVFeLxkMMZVtrnoHexhFw3OnLEsNKiddfvUdDU6Tu1yzvJ6/jUw3Gfab5VTO/U4
	OPEiCBD/KkCd7/diDvwhZPFsQkRIyUU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="vJSZd/En";
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757665331; a=rsa-sha256;
	cv=none;
	b=OkonkykD9TVe/ciTasIG0J7P5GMMm2JpJPgS14SsPZaQ1qLzgxxj8XwRY+0Vu/WF5X7bZU
	Iyc/RrwHHhWlbfEN2rtOWvB/qQz1xXXJCsTmWJIjvQs4ce/WZocOVNfUXOyHl1DOdy4rsZ
	f4vhoD7g4PWg6nfERbbf2sf8dIQGOkM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757665327; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=a04ysXcVM3EZCSALMoyb9EewsnLnr/d3s7vYk7XR0aY=;
	b=vJSZd/Eni5fvWV9fn70eT3E3NtQyrlNxiY6iloyHUydK/+rv50EBYB8oP7S9MT6nKLGYOy2brV3E72/BBE6esjLLH+RWamTgGEZAKPa/LjUOPJ9LcaFyVmmYAMcdmOqgHAqjzb/TVSLisprT+3WblZwr7suKPs9OVv3sPkCCteE=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnqIOy8_1757665324 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 16:22:05 +0800
Message-ID: <0cb2bc82-1957-4efe-8c85-8558743dcf80@linux.alibaba.com>
Date: Fri, 12 Sep 2025 16:22:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/15] mm/shmem, swap: remove redundant error handling
 for replacing folio
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-10-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250910160833.3464-10-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 57E3AC0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tt4sosk4zjukegpzaa33mei7jk8yjrtu
X-HE-Tag: 1757665329-157600
X-HE-Meta: U2FsdGVkX1/ulK/jHkpnYYLOLvOcKBNehcoxVTjoOHEnJCZpfHVNAKfJ3NZ7T9Gob5DV4TQ8ttrbSbPFDbO9IU2zeVbyEGJA0RcLOXWde1AxEQRONggK7T133JYUwJ3uBFE7ZFDvXmrClewr3yKODIy5Wx+UszdX78EtV4Ir7jItIPlO0t4OKpGJSGv/SXYLBjocbrQrcNOtAQsM1xXGYm4bKx+4pdr7TmfuCUd1LIepI63pjXpT+rmy8TPNdlmzyo+7Ub1BIlpGtUWA4dZdkjmUATzbpj5x6s1O9nGfl+rQAIn1NmUHqA0fPj/9iqeGTwZbmzKM67/7inWMkxU1mFqhbOwWGJtKDrPvfLT+Kkcc2fZ0kwlkfQC9HxJndsKiKqw+FAR31iKyRwolYOolduFqAeW15bgE8rNLBqVaPKNZE4OM/PSUElrqVKlGvtwBzK7L4yUJzBGeyixD1PENxi7fPkAL9hZIOsJ/oCcp7Acgz2oe/4BzXLOXJ4ycOKq67mw3vY7eFa31OUPRJy4bkprY7IXNQAUe/ZMSW9CQ0IMBqiGqC0BGJ1hyohkfwu2RTMw54laRVaib+QlLMVGuhWlnLH/QWGUNenWEHgsqzwKo4aitgKOZC0eTbkThb7vPdd3QNmGORwsRU4oGeBl2wK0wYKS6AoPtZmJsRxPmDc/4Ll4sp3d2FoiZi7E+/pt1WEQM1mSQzG9cn15u3fcNMnNOs2u0TXn21hIqZhjDQjRb7XtxfQC8EkkTQ716FHL9yRLAJdOqL97QPZQheB9kUZpcMZxV6S3NdnObaO+20kaQ1bFgwZPvwdOpXO38hHHbxeaEqw2bSspiOg/JNkImFM4+GYm0gkDYFCATI8ZsEyDNwgEVoJ3FRGulV9B9oHNjMp9WzsmtnlM8/15b2gMJgb64FSToA21q1gcf10/ez26ou11P72bY6TikkM9SrbIe4Sx2UhzsV5QtRbEItB2
 yb76wsxw
 3V172358rGC0d0fXENRtCerdhKvyGgAWdWePjUGAu+pJryuOjpgEXky3X4BAYP3XDqgIiD3apThDgWFvnBSteRsBOdzRFuDWqHqma9ORS1HddCF6YqeBIheZkQRPYNcAlgpbRCop8TXiiZkwmK1Hmb2Q4rdhlzLl3LD2YdzcnG+t+kCk8fhMNkeSP05Pc1cdpWIs1seCGiNCFgGtg0HU6Xg3TD+6di8/RUotKBJlIYcyeXZXhZYzyrYcS+sdchrhFC6uWw5ATWMIj9PvSM995kwVhAPOrR9AUqLy12/Wh4ttL0xnvuGr/uIoES1jqOFz9cDLn6Nh92xW/JnaaUnhwzAaMWbyasIna5OVn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/11 00:08, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Shmem may replace a folio in the swap cache if the cached one doesn't
> fit the swapin's GFP zone. When doing so, shmem has already double
> checked that the swap cache folio is locked, still has the swap cache
> flag set, and contains the wanted swap entry. So it is impossible to
> fail due to an XArray mismatch. There is even a comment for that.
> 
> Delete the defensive error handling path, and add a WARN_ON instead:
> if that happened, something has broken the basic principle of how the
> swap cache works, we should catch and fix that.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>   mm/shmem.c | 42 ++++++++++++------------------------------
>   1 file changed, 12 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 410f27bc4752..5f395fab489c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1661,13 +1661,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>   		}
>   
>   		/*
> -		 * The delete_from_swap_cache() below could be left for
> +		 * The swap_cache_del_folio() below could be left for
>   		 * shrink_folio_list()'s folio_free_swap() to dispose of;
>   		 * but I'm a little nervous about letting this folio out of
>   		 * shmem_writeout() in a hybrid half-tmpfs-half-swap state
>   		 * e.g. folio_mapping(folio) might give an unexpected answer.
>   		 */
> -		delete_from_swap_cache(folio);
> +		swap_cache_del_folio(folio);
>   		goto redirty;
>   	}
>   	if (nr_pages > 1)
> @@ -2045,7 +2045,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>   	new->swap = entry;
>   
>   	memcg1_swapin(entry, nr_pages);
> -	shadow = get_shadow_from_swap_cache(entry);
> +	shadow = swap_cache_get_shadow(entry);

Again, there are still some issues with the patch split. The swapcache 
related APIs replacement should be placed in Patch 8, otherwise there 
will be buidling errors after applying Patch 8.

With this issue fixed:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   	if (shadow)
>   		workingset_refault(new, shadow);
>   	folio_add_lru(new);
> @@ -2121,35 +2121,17 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
>   	/* Swap cache still stores N entries instead of a high-order entry */
>   	xa_lock_irq(&swap_mapping->i_pages);
>   	for (i = 0; i < nr_pages; i++) {
> -		void *item = xas_load(&xas);
> -
> -		if (item != old) {
> -			error = -ENOENT;
> -			break;
> -		}
> -
> -		xas_store(&xas, new);
> +		WARN_ON_ONCE(xas_store(&xas, new));
>   		xas_next(&xas);
>   	}
> -	if (!error) {
> -		mem_cgroup_replace_folio(old, new);
> -		shmem_update_stats(new, nr_pages);
> -		shmem_update_stats(old, -nr_pages);
> -	}
>   	xa_unlock_irq(&swap_mapping->i_pages);
>   
> -	if (unlikely(error)) {
> -		/*
> -		 * Is this possible?  I think not, now that our callers
> -		 * check both the swapcache flag and folio->private
> -		 * after getting the folio lock; but be defensive.
> -		 * Reverse old to newpage for clear and free.
> -		 */
> -		old = new;
> -	} else {
> -		folio_add_lru(new);
> -		*foliop = new;
> -	}
> +	mem_cgroup_replace_folio(old, new);
> +	shmem_update_stats(new, nr_pages);
> +	shmem_update_stats(old, -nr_pages);
> +
> +	folio_add_lru(new);
> +	*foliop = new;
>   
>   	folio_clear_swapcache(old);
>   	old->private = NULL;
> @@ -2183,7 +2165,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
>   	nr_pages = folio_nr_pages(folio);
>   	folio_wait_writeback(folio);
>   	if (!skip_swapcache)
> -		delete_from_swap_cache(folio);
> +		swap_cache_del_folio(folio);
>   	/*
>   	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
>   	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
> @@ -2422,7 +2404,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   		folio->swap.val = 0;
>   		swapcache_clear(si, swap, nr_pages);
>   	} else {
> -		delete_from_swap_cache(folio);
> +		swap_cache_del_folio(folio);
>   	}
>   	folio_mark_dirty(folio);
>   	swap_free_nr(swap, nr_pages);


