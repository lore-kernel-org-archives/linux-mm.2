Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF85CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432796B0088; Wed, 14 Oct 2026 09:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC246B0092; Wed, 14 Oct 2026 09:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285086B0095; Wed, 14 Oct 2026 09:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0D496B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:43:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BA841A0544
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:43:58 +0000 (UTC)
X-FDA: 85321350156.19.4D38750
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7076040003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:43:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a0uePfgJ;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791985436;
	b=LWmkcb/aJ6bKRR68lvKqd3heZA9xHY09f4xEAPosQjfhc0eEKKClepMdrd5zkuKaBzajJn
	nue1NPslt838PmQT2Ez/Cbw79kJFYkKwvqtbGEKZJGKC5WkTXdtw85S9tyCmiEpoRslS7o
	4RznAJcri05SCHoh9T/rOeiDMUT0l1A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a0uePfgJ;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791985436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CTpEY2fgBFPhbj7jy5387Ypkhk+L059LuG+GtxC4zU=;
	b=vH6Ndshl2sodU0tziLoJBjrw5DeQkcxueB5TYLYd/liij4Xpt0gwM8FBxQFVTK5mJoNpyD
	nUGPf7E3up+ZWlDzMtkZQ9k0Ije5UOxdSaFac7fRa4IqaZwID8Ndo3UxkLjQCPC0vY6Rmo
	zMdntASCcwURLFnzzqU5ri1PE0xal08=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DAF7A1570;
	Wed, 14 Oct 2026 06:43:51 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3ED6A3F7B4;
	Wed, 14 Oct 2026 06:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791985435; bh=MbZnv2aFyF7Ym5YMUYAQMddwf0kzFG8Yuq53XRxGvBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a0uePfgJ3M7g6AzfBFSq8n0o0CS2ReXcjjPBvbP4NBO1XBKIWzbkRPVXX/FXvC18x
	 ZBv9YIMxapU9BbupxpSBDBe71Z8onU2XAj1DkhmK+C4c7SnWHe2/hVU1iEKh9jobUD
	 b7ebjeOBq59RymK0dH8y6YcsgrB809oHV/h1p16c=
Message-ID: <13ebe0c7-35c2-45e2-a217-54723ff7f0ba@arm.com>
Date: Wed, 14 Oct 2026 19:13:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/5] mm/page_alloc: count guard pages as free again
 when their buddy merges
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20261007021250.1665929-1-riel@surriel.com>
 <20261007021250.1665929-2-riel@surriel.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261007021250.1665929-2-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7076040003
X-Stat-Signature: fxpmj47yr6knia7ztj7aqegdkdzkj4c9
X-HE-Tag: 1791985436-66972
X-HE-Meta: U2FsdGVkX19uJRNY1RPnDogbuMmHFrzZKHdz3dr1MC0bqN/Yt+k+C9YcPQIA/ByL2PRQw2wHAf8bFIi6eURqstZDfZoKaM8i8j3QqrTKiDui/XieN274mKx3K6PSj47CGx/Y7iyszRQkbLTEFnwigInGS+VUZoL5e0nyDPej9l0uhfFECouRmrWqloFKpSyK1KTudz4mAgaruZP2IdiepBaP6MZ1Fcs1XNdZmK7FxqOjc10a+UqqCgudSohX2LD9taifc687mzfdLsC44DIixLIh7o1zF2R6+vOHGMNi3GS6Tl3dXr5x/3IbcB4Tu07TZ4s+cD7Qs5KvAAeGRTH6c8XIytwRsRuYT15GUPitEPzfBLizcM9TzJ8zPTeZc+v0WZn38r2HuA0KZ1c4vZl/srvnKyOSOoKa7GgsVXzJLRO7cOv8ZeZUV7UERxPN1NWahKCzQgvGe2G1D2aZjWgmarmskjx//ksANeR2tiD80n2rRQjrYJK3srmRIaprQyLBMaugylLdFHVF4P1PJs9XWuaoesg1ePXOaHsnsUVevhhrHqxaI0l2c02yjydQGAyyNVVY4Z0t3Rjg9auJYRkHedIj9CAV5Q84m708fRTALa00xsXUh0JvAi2bEgnjt4bOOZ4F1RsQefS5Sw2CHpCurIsZ1H+EFP/BLwCIbq8mMLoaxdFZh/fKq4ju3VucR+P5CXO8YROwMakERqbS3LST/ZshLUaoEn2UmqXwRJ/Zq7gTi4P8esDzBziUPXAdhig/idXYS/ysoM+/a1i4THCzFV1384reuovCPoERTxreQQls21xYxTDt4iqXQrto9yj5mI8EuBr0/XyIXYSDbcfLjqtd9BQ0Itd+l4FdRjCeJYqIqAP63RrAQEOu4qOqM/zY8f0IHZa2LFiqlhh3MQWkQPa8RzLDmXnppwknoCgIaPaXFgXOT1xjQP5U9BsLZ/XXyXvQbi+sUQV6wkM0oFT
 OQEIX8Fj
 fHn22VcalXlyPLmy423Rw/GTAQJK3D1JAOZGfMbSL20mDbQOMWChCsRIXeJchjTwfTXEjHSxPqVcOTwfQljtQ09bfZeZ7BX4rwpKapO8k3jx/zo1S8Nd//3RWgga0AgsS7vWFCsyNvvccEo9cQe9uzJQX++fxIvdY5XpqkU6GlhK4BPkuseh+FixBY4NAvy78WHQGdLEelUKyyqc++I1gddyvBZuLF+VdGcoP0a8wzNhwcxkCIl3vKa6xvBmz55Bk5xIBh6ME3hAnqU5V2+kPyejTzafa0uVlB6v8ryzAb5KFTFG7rnfYmgF6cl+uws72/H1l2mf7iu54epQucoljxv8MpL6ZHfdkqimXJbI8NtoMBa8p4y95soA4eGAUqIVMZ9RRbzUwoyLMhz/R+6PPDNETR6Gawlyo5D/47/J9U4wfksA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/10/26 7:42 am, Rik van Riel wrote:
> With debug_guardpage_minorder set, expand() turns the unused halves of a
> split into guard pages, which page_del_and_expand() leaves out of the free
> counts. Freeing the allocated half credits only that half, and
> __free_one_page() then merges the guard buddy with clear_page_guard(),
> which no longer touches the counters.
> 
> The merged block goes on a free list with the guard pages never counted,
> so NR_FREE_PAGES falls behind the free lists by every guard that merges.
> Before commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
> accounting"), __set_page_guard() and __clear_page_guard() adjusted the
> counts themselves; that commit dropped both adjustments but kept the
> subtraction implicit in expand().
> 
> Count the guard pages under the merged block's migratetype when the
> buddy is cleared. account_freepages() skips an isolated block as it does
> for every other free page, and moving the block off the isolated list
> counts it then.
> 
> Booting a 16GB VM with debug_pagealloc=on debug_guardpage_minorder=1,
> check the difference in free pages reported between /proc/vmstat
> and /proc/buddyinfo.
> 
> At three points (idle, after a read and file-creation load, after
> a second load), check the difference between nr_free_pages and the
> buddyinfo numbers in the normal zone, as a number of pages:
> 
>                 idle   after load   after second load
>     unpatched   -130        79205               99121
>     patched      -16           45                   0
> 
> The small remaining difference seems to be due to the numbers
> not being read at exactly the same time, and is also seen
> without guard pages.
> 
> Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>

Probably send this separately? RFC on a fix will delay
the patch.


>  mm/page_alloc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c483..4658af97be010 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -988,10 +988,12 @@ static inline void __free_one_page(struct page *page,
>  		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
>  		 * merge with it and move up one order.
>  		 */
> -		if (page_is_guard(buddy))
> +		if (page_is_guard(buddy)) {
>  			clear_page_guard(zone, buddy, order);
> -		else
> +			account_freepages(zone, 1 << order, migratetype);
> +		} else {
>  			__del_page_from_free_list(buddy, zone, order, buddy_mt);
> +		}
>  
>  		if (unlikely(buddy_mt != migratetype)) {
>  			/*


