Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86DCCA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 03:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18CD28E0006; Sun,  7 Sep 2025 23:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116F38E0001; Sun,  7 Sep 2025 23:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20238E0006; Sun,  7 Sep 2025 23:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA1E08E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 23:17:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 932CE16093D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:17:16 +0000 (UTC)
X-FDA: 83864622072.13.4C7B1D0
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 286B81A0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:17:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CYv9zcAP;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757301434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F27m7s5BT5f1gDzt8fNIBCug1ivyD0DMViJPGFeUZ+0=;
	b=EILiaSkPZurr8XAi5wEHkZwwmNhZr6xNzmFV6WUv8i62Dcedh0ggJ2fieUTYrO515hYW06
	iabA9+gJ0dp2X9sykzAeEb+lXq0pxxIkWbB+VSrxtWXLMNVPHJ18SI//uXhdk/XC2n0OAA
	+wQBIqbCv6j2nb5nRrZtnd2Zy2sfbT0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CYv9zcAP;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757301434; a=rsa-sha256;
	cv=none;
	b=eVEJHrmAc9a/ztDg0cBJ0owDaczjUAChzHU1TKS4fFDeQAiY8gpPM6yoXbActrbiK9V8kQ
	S8K3KCHTUF5DS2RWAl1g+Jf7c8wPSNP75UWPHJQUQ/Uk4sBhYLxPvbywODq8dIyw3GqiA3
	AB28SX0duKWK/BRFVnVkydrUBJvGpYM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757301428; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=F27m7s5BT5f1gDzt8fNIBCug1ivyD0DMViJPGFeUZ+0=;
	b=CYv9zcAPvLJ3tVEAOVnYyfnGz8lrLJbO0n2KKjPbp8ew64JxAiTKadphD2gMApFuPMqVd+ccgbB4edT/sdbkqyjENACbR4pwXWjysSNdNbqQ3fPC4hZfi5VRmpvmxAp5lxTWq/f+p680PMWK6MHR1HNfRkG0Fz0eNPf76nf2wGs=
Received: from 30.74.144.132(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnQYL4N_1757301426 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 11:17:07 +0800
Message-ID: <1ee09786-ed3c-485e-99e4-48c4d2b92ced@linux.alibaba.com>
Date: Mon, 8 Sep 2025 11:17:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/15] mm/shmem, swap: remove redundant error handling
 for replacing folio
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-9-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250905191357.78298-9-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sapifb1xajxemrqgsytpgq5hag1x931x
X-Rspam-User: 
X-Rspamd-Queue-Id: 286B81A0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1757301432-928066
X-HE-Meta: U2FsdGVkX19szRdePEChdBP0tsDUM03FYBuhkRM9mPmanL8OMFYBOrh6Ys5xpOSwHjyeL5AK2tluIMxXTT3uAMTWQ9MOQMC990uX0Byquhsw9BY8MZ7WF81Ri0tfRyS/vzHrDH10l5UQJ8H8Rc/Ezn7XXbIQTsLUu2bfEfGWqPScifOcM/wGLqb8fEAeap7+cUzWuurroHMHjADV9G5yPi0yKKjT7nn9TOUcHNXJrGruwspyWDRqu7RSjpVHM3m7r0uxBLlojv4bV4KitsylxqNZiQ1JRMRt8vJG7NWiy/NY149IrjZvdcR/p1J60IO7aANjAcr+GCYdnxIDb6C6DOBzisuJYAYFigyTXr8VLvF5Hv+sbMVbZW27o1j3uJx51i1fEw4I39nyPQ6mDugc9+f77ND/txT9ly8WTNmRTlOL2DlL+CT8Q+569n7bQfJUpODX9fMVIdrNa8TfjxbpQhP/iVa4D3ytJaU7P1F9w9EwFLoazGZxz2BwSFUlAyGydegW1yr93LB4VKdRg5s9Vc9NCjhJZBFrFG8zjcdbo+l/uWbAb0Ke9UApXfXdHss5KuzS2Ej4TzQm9uI3TJ/MDrWUhu0LQcx5h/DFolf42KS2uV1Jh/3Ijeu0b5qXK3QJCqdo8TZv0Q62xUM9MQWJc2V9i+Dg9JxPfTH4ZJqV0jyQM206f4IfzKPbA5xQ8HWtaGZUPlUjQ1gfxEomKG5j7DhG04hjrYfJ7r7teHaFOSiBa3tSL4u9b8l4Kz3O3qBxLgI8kbbDQZadr6Z45e8s1EdsUUiEM+r28M2VKnM3Z69KfHa6yar+itHERCwSuF0s5aZAZtqFvcdWApXxudph9RIyV4X+zlekcNjM3q2VxTYKJ4B+sRh6eWMIUqAGZq8Lq+HS09azjfuOHLw8T/w6ZpaTrMSjcVAqAqeVsMEXQ/ZxxFKe3FUQOj02SBjj2wQq56Bfzsxa/ewlKuWuUfs
 xBCwNee/
 LBmDX0bsgmfX+Y1qsMfqt0swAVGKvz1XJRP6yETDC9dTXqIspKxxVrXybtYUDewCHtFkxA7lJVr6US+XbKgAShRrzU7A7OpK6t1/ma2NHqoU+g9lDoC0mt2AZx35OfZ5cC549Oh4e2eJwh8T/r9pnE7xJSoSBlRQHwejz/C3lwHrPRujOYAZuKPl+drIFAW0N34oRTAcC6yqVsLHACeuM0oDKRcHBafbXVP/HkFO7FCrSoiboP2SsexEBJMBkCq4LwG7xKojff+057peUt4Trr5bvKqvBpOqrOD2ISQ/+Fi2k9DZxHdz9zYAR52HngnGGJ7TcEhHQSLUkZz5hVmLp7Dkme9/PL+J8LlakjHAKdai8UAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/6 03:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Shmem may replace a folio in the swap cache if the cached one doesn't
> fit the swapin's GFP zone. When doing so, shmem has already double
> checked that the swap cache folio is locked, still has the swap cache
> flag set, and contains the wanted swap entry. So it is impossible to
> fail due to an Xarray mismatch. There is even a comment for that.
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
> index 4e27e8e5da3b..cc6a0007c7a6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1698,13 +1698,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
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

You should reorganize your patch set, as the swap_cache_del_folio() 
function is introduced in patch 9.

>   	if (nr_pages > 1)
> @@ -2082,7 +2082,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>   	new->swap = entry;
>   
>   	memcg1_swapin(entry, nr_pages);
> -	shadow = get_shadow_from_swap_cache(entry);
> +	shadow = swap_cache_get_shadow(entry);

Ditto.

>   	if (shadow)
>   		workingset_refault(new, shadow);
>   	folio_add_lru(new);
> @@ -2158,35 +2158,17 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
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
> @@ -2220,7 +2202,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
>   	nr_pages = folio_nr_pages(folio);
>   	folio_wait_writeback(folio);
>   	if (!skip_swapcache)
> -		delete_from_swap_cache(folio);
> +		swap_cache_del_folio(folio);
>   	/*
>   	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
>   	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
> @@ -2459,7 +2441,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>   		folio->swap.val = 0;
>   		swapcache_clear(si, swap, nr_pages);
>   	} else {
> -		delete_from_swap_cache(folio);
> +		swap_cache_del_folio(folio);
>   	}
>   	folio_mark_dirty(folio);
>   	swap_free_nr(swap, nr_pages);


