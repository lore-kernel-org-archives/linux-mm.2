Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 689CFF532F6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854FC6B0005; Tue, 24 Mar 2026 04:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82CBA6B0088; Tue, 24 Mar 2026 04:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742656B0089; Tue, 24 Mar 2026 04:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 614C06B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:57:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C89591A1837
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:57:15 +0000 (UTC)
X-FDA: 84580352430.17.4155706
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8579240011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:57:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774342634; a=rsa-sha256;
	cv=none;
	b=F4DKgMo6POjmAjb+H+sW4C1UcDdsyi/ly/ljRXwYGDvgZzk+HdXt/tQOKnK5+wgHDvT68T
	TNy0l6K1cAebzqfwNJcewMfUoUygq9HebHC5NdpBkj9nWxboGRdbqmonbZt9GnBVhQVTvK
	Z2D+0lN2aLtfkWCxCQseYG1zeU5F6dI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774342634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sz0xeNVJrRFQyUEMm1eHZIRznmPl0y+111EPqkRhkVI=;
	b=EjEbStVVEwVz4zoloMhKUEmtDJ8QCaA5CSi85pM1AZoulTJAB6vQ1a3qZcqeZfPgOkBkVn
	jBgqbDm5DQNVXUz7iQsdN3q8lRaz5kbvLXdg/m3ewRXUkUhGhPWi016tfppBViw1VI0OXS
	Hh6saGcq+Je7Re7EDqp2rkMa7QOcP4Y=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fg3nP3VYWzYQtrT
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:56:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id DBDCA40590
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:57:05 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgB3o1DdUcJpXbwfCA--.50053S2;
	Tue, 24 Mar 2026 16:57:02 +0800 (CST)
Message-ID: <8b9e5300-c95f-40a6-bd8e-7c131a158281@huaweicloud.com>
Date: Tue, 24 Mar 2026 16:57:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] mm/mglru: simplify and improve dirty writeback
 handling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>,
 Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgB3o1DdUcJpXbwfCA--.50053S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JFy7GFyUCryfur18ur1rZwb_yoW3Gr13pF
	ZxKr9rAF4kJr43trZxZrsYkryakrWxKrW7JFy3Ww12kF1fXFW8KFy7Gw1rZrW7Cr98ZFyS
	vrW7KFWku3WqqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AK
	xVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wryl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jIks
	gUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: yiyw9g6n137kkooo8zh3iwdzugrp8xij
X-Rspamd-Queue-Id: 8579240011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774342630-560038
X-HE-Meta: U2FsdGVkX18fDbgBg40ZZj2u480/+0qoJp6CLaJGUnvRXLZhZZJHjlmdEFM6wr+yeXbNL7pepqsb/2A3R0X6jia8MGgDY0QDNb/9vcfOE6Rlp1jc+L670+HG9bN4RL/1LRPN1ZDpbluUZzE0A+erDH15FaXPL2OtiBP12MYpPGQc2vUqq5LbVbZPckKFDH8ttqIoKGJZ5YmsIylPQlKwz6mTSQJD3HMg8zDm2IDyXF/GO3ZsnZY1/6rzslO11n+/svEVbaY92CZJ7zTK+ZBSuGgEV9rTvUIA8qVJeEytswhjdGZDpXAXuRTkbm1H5E7a4p5ndnQl1PsthpOWCpAbDOtMgoQZRQulckP9O1kpGl0P3o8ec7Ik4tO5x7xRHvL6+NZ3oODU9NAd4oxWRt0Ogd9xEPrn381fIMuV1LriEn2kQ7VXm9gDJ0yTnFMfvJbQdva5w9cphu5s7nL1y2W1cLYlBvDLMOz8IR4+hkPdxd/N0hoPITjAtnBSRk0UT9Fa2gNsRQHV+vaozNChXpijseKAM7nyQ5y9ebihDnzPSr1tzc106xZ2yQWEu6pRqq1aZYFVLSntGBNBfRI1fDkzO42gD4U7T4uBygocSb7XYO4fu3Ob13uT3GuuUCaGfAGDYluHowgZH9rifqia4oXBk6TakvW+SHDbYfsiyYuv9zOJZQjMII3pASfNT9cO0iWK0lc9qTJ6iSHz83eOBvm+zVgc5+QA1Nl1S+BRKjaLAu94MD9RGxPt3qzPQG+8QkUItcpcJIe43bsyGxqM/0Rlk7NDyYRnFgzjhgESxxS1MH6eQWC/HUFuwGbrfojXxMvjc9yjrLNzqzPQdgeO7k2v5nsvjbPI3fRDmB373XblaeedScEFjO7f5bUbL3zawxdTyaRP8hxJi/2UrTrd/3bBYyx/Q/xHSgBXX3VT4l8GP32YXJ/goi8yJWRzzbHECNzC9p2RaMRGUozyD8NBlhF
 rRulKBme
 ifAzIOlajg0ehRJSf70j5rLQcgqn/EK2+pSi0FPJoXhpfgZ4lM3Wi+Bl/t8vHd/jyLKKkydJlYrBfBvL/FV77cwsyrYZVvOz2kHkk0qRESKhthvL487vy9QU/HUzBH2KZbPE5xDzTQq2Du0q+rWAM/jVvV6+6/9cS2qyn2NWAqZz+vGiKZI2EzvcMEC4K8DaHbWLirfy/AbKTkbhgfKNmdBUMp/h9qlkEGcsXt2x+7dJG5nk8Sjn+A8yqK01BVsf6sez3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/18 3:09, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current handling of dirty writeback folios is not working well for
> file page heavy workloads: Dirty folios are protected and move to next
> gen upon isolation of getting throttled or reactivated upon pageout
> (shrink_folio_list).
> 
> This might help to reduce the LRU lock contention slightly, but as a
> result, the ping-pong effect of folios between head and tail of last two
> gens is serious as the shrinker will run into protected dirty writeback
> folios more frequently compared to activation. The dirty flush wakeup
> condition is also much more passive compared to active/inactive LRU.
> Active / inactve LRU wakes the flusher if one batch of folios passed to
> shrink_folio_list is unevictable due to under writeback, but MGLRU
> instead has to check this after the whole reclaim loop is done, and then
> count the isolation protection number compared to the total reclaim
> number.
> 
> And we previously saw OOM problems with it, too, which were fixed but
> still not perfect [1].
> 
> So instead, just drop the special handling for dirty writeback, just
> re-activate it like active / inactive LRU. And also move the dirty flush
> wake up check right after shrink_folio_list. This should improve both
> throttling and performance.
> 
> Test with YCSB workloadb showed a major performance improvement:
> 
> Before this series:
> Throughput(ops/sec): 61642.78008938203
> AverageLatency(us):  507.11127774145166
> pgpgin 158190589
> pgpgout 5880616
> workingset_refault 7262988
> 
> After this commit:
> Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> pgpgin 101871227                        (-35.6%, lower is better)
> pgpgout 5770028
> workingset_refault 3418186              (-52.9%, lower is better)
> 
> The refault rate is 50% lower, and throughput is 30% higher, which is a
> huge gain. We also observed significant performance gain for other
> real-world workloads.
> 
> We were concerned that the dirty flush could cause more wear for SSD:
> that should not be the problem here, since the wakeup condition is when
> the dirty folios have been pushed to the tail of LRU, which indicates
> that memory pressure is so high that writeback is blocking the workload
> already.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
> ---
>  mm/vmscan.c | 44 +++++++++++++-------------------------------
>  1 file changed, 13 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b26959d90850..e11d0f1a8b68 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4577,7 +4577,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>  		       int tier_idx)
>  {
>  	bool success;
> -	bool dirty, writeback;
>  	int gen = folio_lru_gen(folio);
>  	int type = folio_is_file_lru(folio);
>  	int zone = folio_zonenum(folio);
> @@ -4627,21 +4626,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>  		return true;
>  	}
>  
> -	dirty = folio_test_dirty(folio);
> -	writeback = folio_test_writeback(folio);
> -	if (type == LRU_GEN_FILE && dirty) {
> -		sc->nr.file_taken += delta;
> -		if (!writeback)
> -			sc->nr.unqueued_dirty += delta;
> -	}
> -
> -	/* waiting for writeback */
> -	if (writeback || (type == LRU_GEN_FILE && dirty)) {
> -		gen = folio_inc_gen(lruvec, folio, true);
> -		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> -		return true;
> -	}
> -
>  	return false;
>  }
>  
> @@ -4748,8 +4732,6 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>  				scanned, skipped, isolated,
>  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> -	if (type == LRU_GEN_FILE)
> -		sc->nr.file_taken += isolated;
>  
>  	*isolatedp = isolated;
>  	return scanned;
> @@ -4814,11 +4796,11 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  
>  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  			  struct scan_control *sc, int swappiness,
> -			  int *type_scanned, struct list_head *list)
> +			  int *type_scanned,
> +			  struct list_head *list, int *isolated)
>  {
>  	int i;
>  	int scanned = 0;
> -	int isolated = 0;
>  	int type = get_type_to_scan(lruvec, swappiness);
>  
>  	for_each_evictable_type(i, swappiness) {
> @@ -4827,8 +4809,8 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  		*type_scanned = type;
>  
>  		scanned += scan_folios(nr_to_scan, lruvec, sc,
> -				      type, tier, list, &isolated);
> -		if (isolated)
> +				      type, tier, list, isolated);
> +		if (*isolated)
>  			return scanned;
>  
>  		type = !type;
> @@ -4843,6 +4825,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	int type;
>  	int scanned;
>  	int reclaimed;
> +	int isolated = 0;
>  	LIST_HEAD(list);
>  	LIST_HEAD(clean);
>  	struct folio *folio;
> @@ -4856,7 +4839,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  
>  	lruvec_lock_irq(lruvec);
>  
> -	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
> +	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list, &isolated);
>  
>  	try_to_inc_min_seq(lruvec, swappiness);
>  
> @@ -4866,12 +4849,18 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  		return scanned;
>  retry:
>  	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
> -	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
>  	sc->nr_reclaimed += reclaimed;
>  	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>  			scanned, reclaimed, &stat, sc->priority,
>  			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>  
> +	/*
> +	 * If too many file cache in the coldest generation can't be evicted
> +	 * due to being dirty, wake up the flusher.
> +	 */
> +	if (stat.nr_unqueued_dirty == isolated)
> +		wakeup_flusher_threads(WB_REASON_VMSCAN);
> +
>  	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
>  		DEFINE_MIN_SEQ(lruvec);
>  
> @@ -5023,13 +5012,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		cond_resched();
>  	}
>  
> -	/*
> -	 * If too many file cache in the coldest generation can't be evicted
> -	 * due to being dirty, wake up the flusher.
> -	 */
> -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
> -		wakeup_flusher_threads(WB_REASON_VMSCAN);
> -
>  	/* whether this lruvec should be rotated */
>  	return need_rotate;
>  }
> 

I may be missing something, but I think this change moves dirty/writeback
folios into `shrink_folio_list()` without moving the corresponding reclaim
feedback as well.

Before this patch, MGLRU mostly filtered dirty/writeback folios in
`sort_folio()`. After this patch they can be isolated and processed by
`shrink_folio_list()`, but the new code seems to only keep the flusher wakeup
and no longer feeds the resulting state back into `sc->nr.*` (`dirty`,
`congested`, `writeback`, `immediate`, `taken`).

Those counters are consumed later by reclaim/throttling logic, so shouldn't
MGLRU update them here too, similar to the classic inactive-LRU path?

-- 
Best regards,
Ridong


