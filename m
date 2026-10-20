Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6494606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 07:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lCRPp85g
Received: by kanga.kvack.org (Postfix)
	id C39096B0418; Tue, 20 Oct 2026 03:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA216B041A; Tue, 20 Oct 2026 03:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9026B041B; Tue, 20 Oct 2026 03:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 878C26B0418
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:07:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D0E71C42DB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:07:18 +0000 (UTC)
X-FDA: 85342123356.27.BE14A61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CD7E140008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:07:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCRPp85g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792480037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=va85dGP8bTh3iNH3G4o59YOyEfW8Q3pdlTpaj4aMI0M=;
	b=vaZXzRqmw1QE3NCxJcpWVEVuGwJAsY+PODB0oBDK4tiVXnIX5p0F3T0by2qbT6sc6LsxmP
	UNYkzxcEuUkqnCpIkRSAc32L83k8HCNo0ZIvxOjZQoIKlSk4YI+KQSgNHqWrlBzRTtbj9A
	Xg3PhTrj8st6/mmSKSoIihAw57hNrCc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lCRPp85g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792480037;
	b=Ygolc34aUA2QTnPffJbq4m4CiPpuZmojOvYK/7Iz4Hy/SKJLFmAWrLdIvsXiZu4bvmfOE/
	+E/WbyMVNSSXhk1NRrEl+xxroaLbpj5778h7DBeNbK/geJoi/gnjqjYwBgoTooDjex9a0b
	PxIQtYPE/zC9zFYY7HvPm1nfBT14dnc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 542B5438A0;
	Tue, 20 Oct 2026 07:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD69C1F000C4;
	Tue, 20 Oct 2026 07:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792480035;
	bh=va85dGP8bTh3iNH3G4o59YOyEfW8Q3pdlTpaj4aMI0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lCRPp85gkA1330RWMyZ5bKiPPbXB4EYR3YGrg15qB9Mcsofye16ZLE8LLiHti+J2b
	 Gk6uOrQuPqqE0Hi4sVFa72ObcJj97rZGClMsR3H5ZY0HtAc5alLIKDH+EmDeDd6Lw1
	 u+tljg+1TG6lDCMUQpxFY9RCsIcYJzgoCqzT+7rLGZCeKF7GMNXfhAt/1DttrMxapN
	 mPBQrxOfz//7uxZsGlBTy2X2ROhTyHFMgIScEfxqEmC/nGcqCXp0kaXveTzkU0fFeV
	 YnCKW6TKLJQnVOuPImnfnSSBtG1qow5vv/LxjvM8g8FPWzqFqN2mvRrjqCr3QVaUTL
	 qrNdjxKDECKFg==
Message-ID: <0ec17401-556d-4a85-9657-23a21aed09a2@kernel.org>
Date: Tue, 20 Oct 2026 09:07:09 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: count guard pages as free again when their
 buddy merges
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, fvdl@google.com,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 Baoquan He <baoquan.he@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
 stable@vger.kernel.org
References: <20261016122304.5b1eba8e@fangorn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261016122304.5b1eba8e@fangorn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CD7E140008
X-Stat-Signature: ar5j3ju1ohp4n8bw4yhwtxqb36aqei7i
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792480036-749163
X-HE-Meta: U2FsdGVkX1/YiFHfXT1GxuRH9989U5A83tWNMxtLTUT0pOLXsI/4nWqgRP2aRoPqyQ8xfIkboSvqEyAB68f0pxvdZ/A7EKDjrVgyw+Mjs0aR5XxWkABtAYsHJgqqP8Ew2jd7UksrppyXtoJ2nNSDZWP0MuwsHLPy0Rst8KvSbHwNX1bEAOr8mWpUTpL2fUjIMrCMll2Nk1fB6FJd4sltSy8eG0FjBwV3vWpUNNMT+6H968riotJ5bbWJcEG0dNnNt/Xg5vmc2m3x03QBKrCgBd0w0s4B9ueDML5O+uUe8t+kalsm4Mb9QD73HJziAB5vUJQlVk/S4wxf9Jeg+r7ONNrYr0L1KUy5/cEjJMGeEeUUSNDKuKNh8xHa7lq3BIJiiYDVDbuHOpZjdchr/Q9cPIC+8TNFgoyUNnB+RpE9mleeAB8XF5JRgUBuZwq/fYYbALuOM9fs+2A24anMyQTuUlVnJkuyAxikxXpiw2DyP0YilaKG48keMjYhwK4E6IM+/ECxXxZQ958kTc0s/vY9CQifYOHDC5/9ZMbCTTx2bAwI5XuylI93JI6SmxK10ArvTvFVONyY74Wbs7TxChOwP3TYzwPPqFmXMwltJOKLz+LHn2hgfI2UMI5hs67T2+Ws4D3YhzrO5w0lPegWBgYJgnZOQXfm1Avz0nuTW7QAwu19XhYDA8+Y7xG+cBWjJLGXw5SBL24taIcJBkM7gt/J+zOz7NCGSyQ9SLBsIARMpcbSnrLYdlRh5cWF0EBcGmPx0O6YSIHa7EHJVLJvauVTlqA3wQV0t00Ilre/UXo5A5x9z5M/01HyMSiqa/EU6dMKSK5vT7kji+sFJKxq5fbLGU8y7fTIrmjBV7zlhAhkYChMk90I14uahWA95Zhy5YWQLDBHumjtkp+yUlORrwHt1+iM6zNvnNAeYcC7i1YZrCZedb7ffSrI5AZlLFNffU0jIDr5G33E+qHQCz3a7c3
 500qwcpz
 3PWi023pz5Y+QNbU1JQ4wuYy9cLy0+4bLzIeF1yw4iGxIAvEPyi1jWdZN/a2XM6x31a+JwsoljlbtG8aY0iXYipS4SIy6H6Yi4QbrhQk0SnVCIgOg860soOVKiTbYPHbA3M2CvvD6VTVBcYClMrSQcpICaCjCoFSJe8vgGLKYfRtHy+pSlv7wgLF6CnHeNDbKJlvZ5jBIMqvfrki+xAvpE8ougGtx2adkwgtsicHe3PuFFgA30uSCSEepe3DkAX6Y+3lIWNzTGzfbV2sGwunmCvFkxK8FSFSTy2eRPL7n7OQk6u0Y3gA7PPBY5zUWF5FzN+WKzlkxUKa9xGwJjn4YKP7t+D77qc1UmIG7k/AR4HI+nv1+ri6wJ/dAqEnDNUs/BqjDZt8OToAwhTU6X6y8xJTm/WFJnFZDP58Lq5fegPERRIRIGEZx5ELM2yS+HgIqm0Z/GTG9VKP611p3xlgMqGJ9UkGo9eBrLgQQsoXJohIsOqgujNtsestafi8kSVhZRn2hqL0mrihQg3k/d1dSsSBR7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/16/26 18:23, Rik van Riel wrote:
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
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
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
> 


