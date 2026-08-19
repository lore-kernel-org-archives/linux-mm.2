Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90E2C5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 02:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82056B0092; Tue, 18 Aug 2026 22:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32F56B0093; Tue, 18 Aug 2026 22:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48EE6B0095; Tue, 18 Aug 2026 22:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5D96B0092
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:05:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E88C014038D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:05:28 +0000 (UTC)
X-FDA: 85116377136.04.AD55648
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6A40980002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:05:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nsrlyR68;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787105127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IJ+udYeSVoBfiYYNpFEoyjlx1n46S2SQFcy+SEEuRY=;
	b=JcUGle21eopbjfobI21qHKqUZrp0I4ZFSmrxVyCvmihO0OnqY4uW1sKM9U9s8A0KZQEB4h
	qA0q1LeZbWdTeyGOqlZ/C6C3eDjKFKRnrA7pqKWrpjvJUayPwUeY7+3jcUQ6L6PWrYTa/E
	sQCWz92MQxKZjK19eDtuE75dfwLqNxA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nsrlyR68;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787105127;
	b=HpKkK7UBTfFDriTA7B85w4opjvmSp3i1a0KfAnQePV9l4FDhQDnLkZNfuXZ0i61z5U5xeF
	ykgl07doCeMtU/vykTpSTVheAdMJtownlPLUD7UMCcRgK67Ecyt+GDy6IKDdYl4A0k1fQG
	4CSkH7ORhrJzuG7xJfHIiKxpq0Vumhg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=22tSUCGFrD68K1lRH+RPcG9Hyj3wJxpH/fb0Ypvsvz0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787105124; v=1; x=1787709924;
 b=nsrlyR68i6A5Q4oTHUqZn3S8b5Mce7piUJRhfM2cTSU5pqJspNY0X1jG4SyDTLnKLj+sGHfV
 GYMmIBZ5ipnpDBITbmBoGMwEI6VU6CoS9u57x4YAz7TJLfJf3UwbYqiUQviBXKvDFQLn+zjxglr
 PXc+/sqq92qm7dm7iwNoX2aQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 6217c15f338751e5;
	Wed, 19 Aug 2026 02:05:14 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <aa2507d8-8476-4090-b4a9-1cbd7225009b@linux.dev>
Date: Wed, 19 Aug 2026 10:05:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm/memcontrol: make lru_zone_size atomic and simplify
 sanity check
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-1-8dbbdac0d28c@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-1-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A40980002
X-Stat-Signature: s67wq6fgm9a44yrid685r1n9ndffi8kz
X-Rspam-User: 
X-HE-Tag: 1787105125-949976
X-HE-Meta: U2FsdGVkX1+YalDOBXto4nrNRYN7ap17ZMByFpZCWztAdFYhPa1zIEqVzedORN72Wm6kvXYJS4fxipe6ms3787durbBLIppYXOsP9HqHOmvedsBYXR9FUaZ9Gwa08ePV4XT91qJqSiodl0V23tBQEL6mFmoTr6BD4mvj/k6UZw+ATm0rFsnWPPA/26gWd8HeBzqTJVm1kdMSDLH5zdrclDwB76s09vRzG8Rs0oW4EsO2pINiKvBvZi5O2fvhgOIaTTmWAJyxGUxMFmxM6eyX4NCSf+I6e4qQu4HZVvJxLGo7rczfoRyDPrrSnCw5T9dx2zX/hHTJbUIZ1tTlthNwj8FobH/4+Pd5iEls2a8lHBdE+U7tmv3qN3VjVMqG1w7njKhf779b2/MDjU+0cZ6BloEJFuicKXi80QWtuG94WGj61P5uc+qaZMJRRb2PWvwo02dSpdZiIoHUgQb5FoXYQqs6XNql8UpSjF6d9KvdT+5daRVY8iKohVBspbPEqXr90mD46Tf0JSxV4dQG+nZt2WCsHFJ6Z03QYOnrK4QeDi/XsXT6N3trXdv91ZJ9t562kfcgb2k3uABYNeKKJw4CGMnXetpK4T05FriFE0T8vyEpxqq1gl22uVOzur7LulFfO9oFJWo4V7ewyUwoQ2iUZvzxeiGR/RNiHOj87O+SQUI5WA8yqE5zWPouEOsTXto3KwRIQfyktOCrNEjUkAHzvwKzdoq57XLP26eiL7tZuubThXgrBGzEB6xvK/V8SmLWmcGi2N5i0C/Imc64+tr0/He7brcVh4xyVZ6RBhng9YG9E3qj3I9KZ9EsF6b50HlkKL523w3dbrZKpymtO1WB4ANs1A4Qnj6PS46og+Hu8R6eKKJcjYEaUHZKxkEUaJAC43yhXYvGp88I8RLgXJDBlccWIfqlvu/YEY2vO6LHdl6ADnGg/FkpkrOO6Lx64cc6f/DswQHPOHT8kqxQ/MB
 Nfm1L1DP
 WBDJf3d9B7cUkcQgvLk+mN3Ojnn+IomCU3X3DpirpXlN0Q5ap91PzKbUQSY9rc+qoQLZx6OhmbdLfSv4mujEKVNMKNVp8Y3WJPXhY9buFufwUYOY2c2Qn53gdnBvsO60RbC40SOHdy9N5thNl1dquM6aYn1aP52Vktlzd2/8f0nSqUv2tM0UbUMY0I6RzbAExBv7widAnjj/UDZLLw247fvWd/fy2Oo+xYLj2OnyqMURUrAlCv0pNZW/YsTlejy4ThUMm9UJ4aM3nkPH11db/RbOMY2yTUfQqe35MMkUI+IOsR6GT8QIXCw/EoFm/wTbw2muNv/PrK85akjtwSjkkzgMrbXwRaZzhWkMA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> introduced a sanity check to catch memcg counter underflow, which was
> more of a workaround for another bug: lru_zone_size is unsigned, so
> underflow wraps it around and returns an enormously large number, then
> the memcg shrinker loops almost forever as the calculated number of
> folios to shrink is huge. That commit also checked if a zero value
> matches the empty LRU list, so we have to hold the LRU lock, and
> handle the positive and negative deltas separately.
> 
> But later commit b4536f0c829c ("mm, memcg: fix the active list aging
> for lowmem requests when memcg is enabled") already removed the LRU
> emptiness check, so handling the deltas separately is no longer
> needed. And if we just turn it into an atomic long, underflow isn't a
> big issue either, and can be checked at the reader side, which is
> called much less frequently than the updater.
> 
> So let's turn the counter into an atomic long and check at the reader
> side instead, which has a smaller overhead. The underflow correction
> is removed: a massive leak of the LRU size counter would indicate
> that something else has gone very wrong, and one should fix that
> leaking site instead. Besides, the updater-side sanity check is
> unlikely to catch the leaking site anyway: if a folio was removed
> without updating the counter while other folios remain on the LRU,
> the WARN only triggers much later, from a likely innocent callsite.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/memcontrol.h |  9 +++++++--
>   mm/memcontrol.c            | 18 +-----------------
>   2 files changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229..b13e3f056319 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
>   	/* Fields which get updated often at the end. */
>   	struct lruvec		lruvec;
>   	CACHELINE_PADDING(_pad2_);
> -	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> +	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>   	struct mem_cgroup_reclaim_iter	iter;
>   
>   	/*
> @@ -897,10 +897,15 @@ static inline
>   unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
>   		enum lru_list lru, int zone_idx)
>   {
> +	long val;
>   	struct mem_cgroup_per_node *mz;
>   
>   	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
> +	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
> +	if (WARN_ON_ONCE(val < 0))
> +		return 0;
> +
> +	return val;
>   }
>   
>   void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1d3339520809..9d0ee3d3bda7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
>   				int zid, long nr_pages)
>   {
>   	struct mem_cgroup_per_node *mz;
> -	unsigned long *lru_size;
> -	long size;
>   
>   	if (mem_cgroup_disabled())
>   		return;
>   
>   	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	lru_size = &mz->lru_zone_size[zid][lru];
> -
> -	if (nr_pages < 0)
> -		*lru_size += nr_pages;
> -
> -	size = *lru_size;
> -	if (WARN_ONCE(size < 0,
> -		"%s(%p, %d, %ld): lru_size %ld\n",
> -		__func__, lruvec, lru, nr_pages, size)) {
> -		VM_BUG_ON(1);
> -		*lru_size = 0;
> -	}
> -

This code is confusing, I used to try to remove it.

Well done.


> -	if (nr_pages > 0)
> -		*lru_size += nr_pages;
> +	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
>   }
>   
>   /**
> 

Looks good to me.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
-- 
Best regards
Ridong


