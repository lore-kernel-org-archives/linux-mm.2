Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2A4C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43306B08D3; Mon, 17 Aug 2026 23:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AC36B08D4; Mon, 17 Aug 2026 23:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A572E6B08D5; Mon, 17 Aug 2026 23:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC426B08D3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:36:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10D37160A03
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:36:24 +0000 (UTC)
X-FDA: 85112977488.26.486A94F
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf20.hostedemail.com (Postfix) with ESMTP id A01081C0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:36:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="mwt/+vdK";
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787024182;
	b=tw2nRh8MEQseeFp326Z6AbdMK5ZrLP9/PNGHF5G0XxHhNLPikqOEgyxMIjOqMjMyl+pSsF
	8pWer5tfGMt7dgvilxJnIn14HCOn5hZ2VuUbzAheeyjXIuP9YBPQJtY+Cpa8oZZlXGXhSh
	WMfQkIQ0XnZ3JAJXdPkIjQ/BghUoPXE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="mwt/+vdK";
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787024182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLRJ4oNNFpYWGdiEIZ6Tl4aYLJPaTNBMq+3LGFYpe7Y=;
	b=5INE5E+zi+e8ZJIww481nmWX3wBmdVXjCKjBVG0KlfZn+IG7hn1Os9xmOzv2tx5wIKLFP1
	vFjXEFJv/D4hCXuCHuLqqMB9EzZV3cGwjJwUqqT/F3tyLmoyXMcNke0PRzcNU7KlJCKUrk
	4Ne0NCpRx3WI31UbFnHy8z7TMl126o4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787024175; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pLRJ4oNNFpYWGdiEIZ6Tl4aYLJPaTNBMq+3LGFYpe7Y=;
	b=mwt/+vdK51+Fg/ukA1fa7KvQj9uITU+MpXi9pGGyzhLqbZMGyyMh046LnqMV3PLUrQpM2djlQKG8Dz1aniPt9ej388ua9ElG+VZqUghjr1w2tfJTxh4hTn12WGV/M2npYupcBKL3LYoi7kRFbz478NuC82tyZg6SQwureQP8xmU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X9BvX3n_1787024174;
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9BvX3n_1787024174 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 18 Aug 2026 11:36:15 +0800
Message-ID: <e5c15b42-55e9-4912-9000-cd720a44b57b@linux.alibaba.com>
Date: Tue, 18 Aug 2026 11:36:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 2/2] mm/vmscan: apply too_many_isolated()
 throttling to MGLRU eviction
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1786950138.git.zhuhui@kylinos.cn>
 <858e2e0ae536bbe185267472d3c84a5684937131.1786950138.git.zhuhui@kylinos.cn>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <858e2e0ae536bbe185267472d3c84a5684937131.1786950138.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A01081C0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y7pzaies8mbfadizrkw8ssjfspu8un7e
X-HE-Tag: 1787024178-991284
X-HE-Meta: U2FsdGVkX19l2btGB4Y8cbxUl1/PMnj/7g4Bj9f0CM8xIX1zQ/njDeUqzeKaXstwJsxvkr9nX61pINkAGp4sRxzNhYcUoITVRa01RBa3WqeYeLVisMUECMzWNlfC8ZJyGy9LnxtH9ambzHt4o08vR6we9lpGluKiUzTpVmyJkxGTlMIK8TbpjxO+pS82m2Gm2s4BPaeUZa5VVAEdRCVz9VBBChEwr8S1RUo2B/RF654mHzuNEipHN2sD9RBmENSVHRRx4OMMlBuKqyuH9y6EyW1bI3M1pxl65KsyiNJcCKvqbmhtA0moEaQQvR60mj7DfnkshSUsV0XVkC8X1KN+0TKJrZdbdmk7S52JrEsS2eTkzD9h/xpNM6UbH8Tm9s1O0KLI1UUpXWbWjUV40B7h8otssqvPuCXujoF4ocvR5F5y/Rm3139YotdlA8F4FdsCSohn0mQcBTTyJCNRPuBcU5nzq9GyeK2E8YQr0FBNdA44sxEei9L7mmVgyQdkKnJzSpx9wPz2AlIjebsq2G43cIt62ieUnEhhrCibg/yUAPVz8o/h2m7IrA2/hw2BZnWYd70bLgODFDpt+0wkpK1qCB0Sh1v4pBWRPBC0tVgdrh8EOsaiONS6zeiyyhz750HyxlVM3QvypqSHgjGRb7CyqSwjhX1qLZNzgyEt206UR0D5ct/q9pb9Xw7ZMo7RLOI9MBhPlSEhsePsVFyOIuA4A8pwl/EJBhRoKHbt/txVERYkO1sz1hZwyqD/aTcm8p7u/CygJAI5xl3OZe0cKQUk7lyLiviulKHWffkJNs0QHDkdT++b7Qdez3P5woyy6Fck58P7xUtabP1n+9pnEd8L8Sn0JO69+XVGwmLiQS5ZHGV/7qzvPcn2x2dDUnacFh7rGSwdww1FUaCRxebbdHAv9Rb6IYl+rM6nHO/FI4SXKuW3MjYpuSyHITZkrBQ3l1t3qWCN5LMQ+l7fTv8xpbN
 crYlCFjw
 EDC91zhdK5EKDcZgzqHYYW1kt0serFKUvFvJ5p8uxCvhCRnJ7rZ8aMiaAoMvOrgI5wfgWjyrR+qWFcBKwsJO9Hbw2M76D7OJgpmYxodzQPKMFz+Q5zqRNED5ZbVgJbYwc+ZXf9mz53TaFFtr1n8yQzrwYHBO284PP8B42UCcQh5gzZE2/YXb/KGz8nT3bwWRBvOclFAoXoKb1Sn7egOqaF010oY0Jf58+oIECMTFNqKc+WiSDteSUti24jPZL9i/D80eQRvXcZLujsdYxy9BYIVhnWbJrZVhXeNQnmE8K9HfsVqCbXrZdHdTSE6NbYK6/hF3Iv9HIj6Tn1J80tjcy6vhLNyDpswlJIe3L8Zsood2033D6y9y0n1lJHk5AjMdqqP/XlXhlJerkRYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/17/26 3:11 PM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> The legacy path throttles direct reclaim in shrink_inactive_list()
> when too many isolated folios pile up, but MGLRU's evict_folios()
> isolates folios without this check, which can lead to unnecessary
> swapping, thrashing and OOM.
> 
> With the NR_ISOLATED counters now updated in evict_folios(), extract
> the throttling loop from shrink_inactive_list() into
> throttle_isolated() and reuse it in evict_folios(). The type to
> isolate is predicted with get_type_to_scan() since it is unknown
> until isolation.
> 
> If a fatal signal is pending, fake reclaim progress the same way the
> legacy path does, so the dying task exits reclaim quickly instead of
> being held in the throttle.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>   mm/vmscan.c | 67 ++++++++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 56 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fdc45d7d8fba..886a53f563ab 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1819,7 +1819,7 @@ bool folio_isolate_lru(struct folio *folio)
>    * the LRU list will go small and be scanned faster than necessary, leading to
>    * unnecessary swapping, thrashing and OOM.
>    */
> -static bool too_many_isolated(struct pglist_data *pgdat, int file,
> +static bool too_many_isolated(struct pglist_data *pgdat, bool file,
>   		struct scan_control *sc)
>   {
>   	unsigned long inactive, isolated;
> @@ -1856,6 +1856,37 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
>   	return too_many;
>   }
>   
> +/*
> + * Throttle reclaim if too many isolated folios are piling up. If this makes
> + * no progress, the caller is probably looping on unevictable folios, so give
> + * up. Returns false to tell the caller to stop reclaiming, and sets @fatal
> + * if the task received a fatal signal while waiting, so that the caller can
> + * bail out faster.
> + */
> +static bool throttle_isolated(struct pglist_data *pgdat, bool file,
> +			      struct scan_control *sc, bool *fatal)
> +{
> +	bool stalled = false;
> +
> +	*fatal = false;
> +	while (unlikely(too_many_isolated(pgdat, file, sc))) {
> +		if (stalled)
> +			return false;
> +
> +		/* wait a bit for the reclaimer. */
> +		stalled = true;
> +		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
> +
> +		/* We are about to die and free our memory. Return now. */
> +		if (fatal_signal_pending(current)) {
> +			*fatal = true;
> +			return false;
> +		}
> +	}
> +
> +	return true;

Returning ‘true’ or 'false' looks confusing to me, maybe use a readable 
variable 'is_throttled'?

> +}
> +
>   /*
>    * move_folios_to_lru() moves folios from private @list to appropriate LRU list.
>    *
> @@ -1992,19 +2023,14 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>   	bool file = is_file_lru(lru);
>   	enum node_stat_item item;
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> -	bool stalled = false;
> -
> -	while (unlikely(too_many_isolated(pgdat, file, sc))) {
> -		if (stalled)
> -			return 0;
> -
> -		/* wait a bit for the reclaimer. */
> -		stalled = true;
> -		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
> +	bool fatal;
>   
> +	if (!throttle_isolated(pgdat, file, sc, &fatal)) {
>   		/* We are about to die and free our memory. Return now. */
> -		if (fatal_signal_pending(current))
> +		if (fatal)
>   			return SWAP_CLUSTER_MAX;
> +
> +		return 0;
>   	}
>   
>   	lru_add_drain();
> @@ -4883,6 +4909,25 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	bool skip_retry = false;
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +	bool fatal;
> +
> +	/*
> +	 * The type to isolate is unknown until isolation, so predict it for
> +	 * the throttling check. isolate_folios() may still fall back to the
> +	 * other type, which is fine for this heuristic.
> +	 */
> +	type = get_type_to_scan(lruvec, swappiness);

Perhaps we could use 'for_each_evictable_type(i, swappiness)' to check 
each type's isolation?

> +	if (!throttle_isolated(pgdat, type, sc, &fatal)) {
> +		/*
> +		 * We are about to die and free our memory. Like the legacy
> +		 * path, pretend some pages were reclaimed so reclaim unwinds
> +		 * quickly instead of looping back into the throttle.
> +		 */
> +		if (fatal)
> +			sc->nr_reclaimed += SWAP_CLUSTER_MAX;
> +
> +		return 0;
> +	}
>   
>   	lruvec_lock_irq(lruvec);
>   


