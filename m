Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19629CA0EFF
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 03:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252906B00A5; Sun, 24 Aug 2025 23:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229A76B00A6; Sun, 24 Aug 2025 23:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1666D6B00AB; Sun, 24 Aug 2025 23:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 047A36B00A5
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 23:03:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8487F1A01A4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:03:00 +0000 (UTC)
X-FDA: 83813782920.29.04E6BDB
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf21.hostedemail.com (Postfix) with ESMTP id F1EEB1C000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:02:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jUDtO3+j;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756090978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDyIr1bDDorwY28+AGmaE7j4FXIULd86PhLUjg5+Yc8=;
	b=xNaY2i/o/wYM6bMjAYw7BG2DmyYyGRicsMtCQetTtX5S63LApITC5DlxiIWBLRQbUlf0OS
	H42XJ3+KbIGwbozj4V40lh/frH9XZyTXPPcMaob1J5IbjEVI6YOjsFjxtRihcfy3InAYAT
	WpbgUF4Vl+Miod/A1M8HTinGWNqSWkM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jUDtO3+j;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756090978; a=rsa-sha256;
	cv=none;
	b=6GLoSlP4NhUgZRWAgeJHs9SS1pFmCHTTk3EMLQwlI/HLghcHHiEZ6wRnpHIFDAAtO9iYLq
	1RXcakj8QdSPfiaKGEBoSRjlROD22/e+Tmb6fivj78QTKIUdHm1n+ijDor8Opqe3XbbUqa
	SYjBPX4EidVP2CPjVRar4HwVxdwy9iY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756090973; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YDyIr1bDDorwY28+AGmaE7j4FXIULd86PhLUjg5+Yc8=;
	b=jUDtO3+jbT8AD3KfX7spJLLQrgLJEWVBb2k5R93YaPI+pcxanjNCqsiecRCKzkFHXdKYENaj9duQDPXb6lMPIy7h6NpGy3m7Bp2vxPO53l2yJUw54oJ52hrwo/0Q/pRsp1aoJ1uDAZ7lCwAsWIdlrBMhRqhp1VuKUlAm9Bj86ak=
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmPuZG-_1756090970 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 Aug 2025 11:02:51 +0800
Message-ID: <0fc6e083-b7be-4144-a50c-d1a7a2e1c3a5@linux.alibaba.com>
Date: Mon, 25 Aug 2025 11:02:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] mm/shmem, swap: remove redundant error handling for
 replacing folio
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
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-6-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250822192023.13477-6-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F1EEB1C000B
X-Stat-Signature: uttqxafrxge4opufr61a9g9kooa5a5c1
X-Rspam-User: 
X-HE-Tag: 1756090976-556699
X-HE-Meta: U2FsdGVkX188WGn3uHq6GR1hlCAs7dRLswZK5Br2OCSiuyvQwTH8GgZuzy7oVwXzYE4xFJ1AncifZfunHfErryobBTobJUQjQiZaPwWY6ZBij4r6KI8gT1bgX9163WYrIWMmDpQlq7TBo9N791Ii6cpD22WTl8dExNhRaTK4ByGhyRJEHA0jXXJ9ZUEN1FuDj89n0HRxEIxI4I+SbnBR+xPeufloloNyYO6KFWYSsPO6mfzp67a82z9MG8x4c8ug6H+LuBGCPIc7DuFZ6Zsf0R8ycXlqnIOsXldxW2vjoPHJNQBGUIk7Mfy4Q58mWgc0hErUsXyFCb7PwUSeaRmommw4CjA1yJNwTuh8zMzlJMk5LrKGN0R5TLVLwbng105W3Gk0q6nZQOR7FbV1Byw+8g1+TWyqYGiOss066/fwdP1h9OqTokJps5L0H1gHWhvntxLFgBZYLPsGPs1hf60f2TFCg2XF3h8Wb37kCgiYIEwy8SGoENAbONyfOYCNvTyn7L7qrXgBzqVlXELq8iZcZdCBnNdXE+6A9PuglxqniUpn61noTQNPzBi9rElhOIK/Ntv8AE77V3WjoPprH8gZgxImFC69hSwKrTUgmKekWbb+szarAxgBsZ+UOXDidQUop4auVP12RaW9lnNvSyupYk6JBX1MmDsc2cQLLf/LHT2/ACqHBJ9+RnMXLlTz5hcUBrKXYsfsvrtYCdO5yUQgGcOwFnv8hskbg36Eex3ljaWHtpH6jcCCUwXgRnwBCcE/0Eq8rkWeaVRnJ11Omg+o96w52tinNkUXlsdz3MEGkb7NDNIj5NSOUlYmTJQIonZ2AWV1d6qFUL4Hx4TpeOwmkm7pugadHqSJkCDvsa9Lj6/01Xo2Zgz0xzKt7AxIZ4tddX4v5AdEOhG8+AO8pK+g0hIWcushDbhl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/23 03:20, Kairui Song wrote:
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
> ---
>   mm/shmem.c | 28 +++-------------------------
>   1 file changed, 3 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b4d39f2a1e0a..e03793cc5169 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2158,35 +2158,13 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
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

It looks like the shmem statistics update was mistakenly deleted?

( Continue to understand the whole series:) )

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
> +	folio_add_lru(new);
> +	*foliop = new;
>   
>   	folio_clear_swapcache(old);
>   	old->private = NULL;


