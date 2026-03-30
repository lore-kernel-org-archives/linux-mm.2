Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B8BFF495F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 08:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B006B0092; Mon, 30 Mar 2026 04:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E027A6B0095; Mon, 30 Mar 2026 04:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F826B0096; Mon, 30 Mar 2026 04:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1FE36B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:15:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40587140590
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:15:05 +0000 (UTC)
X-FDA: 84602018970.14.E406858
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6631D140005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:15:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uzqR4INr;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774858502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZODsN0thY0LoA5mBOTgwAZIPwWkd72oa5M0lRWn5DA=;
	b=7V/267EWWU2Thrx1x7ISWifCwlu2BXceMctxSbQKGcukYyjU6+00glvrEZQdShH4kSkTgY
	DCVFH0BWPuHLx1lhk3EL20ZV5ylaWJJluWXNXxU3jiYj7WFA8FGZWImqIyn/1Bp44GnqxB
	Rt5+FtPP1fyQMgDQsqYLKPZlUAlllBo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uzqR4INr;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774858503; a=rsa-sha256;
	cv=none;
	b=X0cY9Fq7K+xj1Z6B2HsUSdtCmZsz/DBgX209gIXgYwYnZCcnw7f75Ts6FQdkflgICEH0Mg
	HMrpbBngKUMo19T6rpd8O8OqppY31EyUbH90fm7eNkBEjSF+FfroZaMh/SHRzIvzB4twTX
	IYDxp/PYsdPYw3Aybgt9yzIjUG+4MCw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774858499; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TZODsN0thY0LoA5mBOTgwAZIPwWkd72oa5M0lRWn5DA=;
	b=uzqR4INr0eFNGC6oFI+k1r5dBd9KiHlq13pY8LhhGmPDaN+y+KueiW4zmCrmVcXGH9RPnwTbwVrYMB/8NYg5CtnP0PJIVSJDERaO8NlI/dKUdDJZ/FquA4rrmZR9yhIAx0spvEECytbwFn3blUk1yBXRRs71QccePxBviDUW620=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X.x4OtT_1774858496;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.x4OtT_1774858496 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Mar 2026 16:14:56 +0800
Message-ID: <8150afe4-53ee-49ff-adfc-e29a483fd1f7@linux.alibaba.com>
Date: Mon, 30 Mar 2026 16:14:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/12] mm/mglru: relocate the LRU scan batch limit to
 callers
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-3-b53a3678513c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260329-mglru-reclaim-v2-3-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gmustrpr1jn63echhhj4piyh7a99rofo
X-Rspamd-Queue-Id: 6631D140005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774858501-380785
X-HE-Meta: U2FsdGVkX1+1pQOQ3xZsXJrkPYcJ/u7dacmlTgz90LrfNvAYcI6aBPZRMjw2sNOATH6GcgdHJQK+8DJ09Q2NlmeCtAF+DX9TREYPbAMPrhKQXuknaLi7Z/ZlAMktVlvzC1PHuy47d+CKxo/jWl8jP8uQnM/J3JoCMA1VThFKtxHzInS6yuGEboJvNdjf0XKue0QkdNR2uDf2rjwuSElv2U/2f2/NRj/UeyixVNXigOvFt7ox+qK7zh1IcjRTRMvVLVdS51OlL61SvZTRFMwHbw4rFm/0hALjEAAzI1JwaQusm6BcSnW2iOMn+aLCB6zkoVFS5h8GDygXIA6hO38sFyFlMv+xq9T2kgbPPj3oE7tsKeNt1JHnIN+Adbd4fCPeEgyAiMzHbrWlckjrE8HbGu6cEIMlPK2GOkI/BeswVq5TgSiyWIZZkWUvAEEANZjKmVBkbeLVzl5GMeuCp8AS/TtbYcC9IG3fs9y9oIX74Qa+mjtJl2a4BYr2qMRzOXhcOsBHwKOX/DcxRGuOPRzW6U6VwYiQkPdm7W8IoPN+BcjO55zwao5zKkWzkGdYaS7y/QA+3ylTVJcEMCbJFRVfVa/0Z6Ce/ZcyfFGQOQGC7ikeE1m3pMMc7abVHFWUpKr8mhH5wnG/WfDunI1cRpNX7+HzGHVKTFyyz/GVAtTURc4BD0Ik/H2RFQ3LryE1uVY0ujt9EGgI9ElBlC/PgOpTHaL+n+b+eX7vw8JjKztHywqkzZ41czQomVg7BlYqWRxuMWMqzL7FO3hkv9QncQKJjGn/QSIjoTneYAg5WeYbu+KpZB9vTskV6ZbPN/mmACO1vgg797ywgGjdRXbORH/lSXXNmZmqyLC2mV4jV1qvWozZg6Z0NL/TR8As92dMt6pEWM/DwB3eQqPRJ0MxUB/4i7VcJ1Cz8w60oOQq8JNAiQuOHYqQQQufYGtpCkLUVs/I4Fn0PxQdlOUuqfFJite
 RZuhTt8M
 fOKSOz1PBwmZh8zCeHBXlBJc6Oyu6tbQ1DnDncKEs6hQGv6RMEsIymBl1RpnImN8JZNIw18sK6I1f2L4cjItBpJYWPtFszDj/K61IcTjFkI1b4OHSqSnAVT60m311KsYTZ2p9Be5HXsQKWOAeWXCnbCCYuYxiv99CUcHlcPYsz0jG0eP0P5vcOUlV/+YWbLBQbNuX7sH6L7R00ksMXy3v/L+mgqX4pmK4kFBKfktiOeoz38iIksYqXcN7HTCbvisM9eCloYkk3WkFzytohppC0dugwUdDrWSYb8antMng/ZTXDYmQtBOZPAX6g/BQjM7INd2m+UB2wQrmkZF20L5d56JHBLq0f2Uu47CHgnWDLVkKttyL72eXfhpQK6AkWfm+jQA9UeuEU9jwmwmIbG48zSEFZdFnDPeCchgZ72LMPOGfwOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Same as active / inactive LRU, MGLRU isolates and scans folios in
> batches.  The batch split is done hidden deep in the helper, which
> makes the code harder to follow.  The helper's arguments are also
> confusing since callers usually request more folios than the batch
> size, so the helper almost never processes the full requested amount.
> 
> Move the batch splitting into the top loop to make it cleaner, there
> should be no behavior change.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Some nits as follows, otherwise LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/vmscan.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f336f89a2de6..963362523782 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	int scanned = 0;
>   	int isolated = 0;
>   	int skipped = 0;
> -	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
> -	int remaining = scan_batch;
> +	unsigned long remaining = nr_to_scan;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   
> +	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>   	VM_WARN_ON_ONCE(!list_empty(list));
>   
>   	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
> @@ -4751,7 +4751,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	mod_lruvec_state(lruvec, item, isolated);
>   	mod_lruvec_state(lruvec, PGREFILL, sorted);
>   	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
> -	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
> +	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>   				scanned, skipped, isolated,
>   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>   	if (type == LRU_GEN_FILE)
> @@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>   
>   static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   {
> -	long nr_to_scan;
> +	long nr_batch, nr_to_scan;

Nit: Since evict_folios() expects an unsgined long, why not define 
'unsigned long nr_batch'?

>   	unsigned long scanned = 0;
>   	int swappiness = get_swappiness(lruvec, sc);
>   
> @@ -4998,7 +4998,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   		if (nr_to_scan <= 0)
>   			break;
>   
> -		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
> +		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
> +		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
>   		if (!delta)
>   			break;
>   
> @@ -5623,6 +5624,7 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
>   static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
>   			int swappiness, unsigned long nr_to_reclaim)
>   {
> +	int nr_batch;

Nit: since 'nr_to_reclaim' is unsigned long, better to use unsigned long 
for 'nr_batch'.

>   	DEFINE_MAX_SEQ(lruvec);
>   
>   	if (seq + MIN_NR_GENS > max_seq)
> @@ -5639,8 +5641,8 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
>   		if (sc->nr_reclaimed >= nr_to_reclaim)
>   			return 0;
>   
> -		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
> -				  swappiness))
> +		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
> +		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
>   			return 0;
>   
>   		cond_resched();
> 

