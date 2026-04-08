Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F462FD5F94
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4846B0088; Wed,  8 Apr 2026 04:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56556B0089; Wed,  8 Apr 2026 04:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BDC6B008A; Wed,  8 Apr 2026 04:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C74BA6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:27:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AC1AC2C39
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:27:56 +0000 (UTC)
X-FDA: 84634710552.07.C55F31A
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 50D7A100008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:27:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775636874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qlLht5FZXAgY/dXsccRVorUksFD2m2uBlNMCQYM/FAU=;
	b=GfrXmQGOpqhJWbxtgZLxfIc9ohOe3tNGO6YS+2jwrMS/OKOmpAXXEloa9azoJKfp+XxN7H
	aGP8AFVXXJAb3GXb6T4KFT2CW18UX/iDh7HeDIv36tVb5EOxskW40GFM19eMmiA5KF14NY
	44LbBCWTrttfgs272a2jKvIzxODJWA8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775636874; a=rsa-sha256;
	cv=none;
	b=rOpHRV4QgwUzhoRCfCqqFZFt0qctJ+FRf5slJvOvpgel99qC+BHiwlJWsezHzROO7661Pt
	wSJGms5NbQTMEGaZsLuJD+e4A2QSF+qRYesskFPLK0zhzn2RhnZNs+N+JhMhlVgAlVErTl
	3HEh/Zs9yBziA/fDpKUSoduLZVbE2zk=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4frGQ93vr9zYQtr3
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:27:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6021E4058D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:27:47 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgBHS9uBEdZpZ4E8Dw--.57995S2;
	Wed, 08 Apr 2026 16:27:47 +0800 (CST)
Message-ID: <bfe3e2ef-fd72-4130-86c3-3f0b5ea44a1b@huaweicloud.com>
Date: Wed, 8 Apr 2026 16:27:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/14] mm/mglru: scan and count the exact number of
 folios
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
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
 <20260407-mglru-reclaim-v4-5-98cf3dc69519@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260407-mglru-reclaim-v4-5-98cf3dc69519@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHS9uBEdZpZ4E8Dw--.57995S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JFyxAr4Dur4rtr43Kw4Uurg_yoW3GF4Upa
	9xG342yFW8Jr43KrWvqr4rCr43CrWfJ34DAry3Aw1SkFn3XFy8Ka13Gw1UtrWUuryDCFWF
	v3W7KrZ7u3WjqrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50D7A100008
X-Stat-Signature: hqs6w6n3ergjxe5russnfs9fr3cuamy5
X-Rspam-User: 
X-HE-Tag: 1775636871-738776
X-HE-Meta: U2FsdGVkX181f4cfYeQVDsYW+n1nerLwKcg+f4PcrxnycE56iq8yKLENE8/a4K1u/eXswxl4JHqF3w2R6P1g596Pwc2hFO2IYGLzSLCL1ryOX/bGNGzCHyH5gAQKYQvSJZ2u+m7lSOMWtG/0RHZCrmxbXEp182X5ECwT3oQiX5LU0cQUyZl/NzdJSqfp4/s3tD+3AwNorX3mFzZRKhGht8X5a3GtgeRm3yEI3C+3OfUVkctj+fWtpbvAjDyxyEZSs/QC4NSf3pMBk7hCCqjxvUsJ0dcZkhixBgSwQFxiUe9ECs2xHus8E4SrX3XPHvxVYUWX1wPL+HCUn+YslQZuqsNlLym9qPWD313gLyYslWMCnQhyswk2P21p3RLb5Ue+RHeQXOzSr2PLlpqYBOo9lSygZFCGg3LfVU3+ymZANnJijc8CJqiKLStJ866DtKxAGZrKJ5K/8QoQA7ZXZ3/VejLNSKWEc3JCTuHbbn5/iXk0c1IBw8WIDqE55w/Ef1mZ3o/U1Hp9OQD1XE8SZ+TB0aanzPKdzEd1DQrOoEPmJUmUUoaUh/f1deU1ZMlmFjueWTn/FnOfIpv+amDDRpMh1okWeC+QNywU+mtNlJC+RTOWgdDcBzXKIHPhg7cIYwUlp1m2rGbYDk+2zTNixMBZCBmG6PoAaqUSMf2wLHW/dXhdvQbJ2J4+wgulj4oxSNtpQ7AwSN70Nuev/XYWexX6j9Zan0B+1Yn7H0VIv7pIzKk4UmWQF3O74G1dZK20C6dhP4dJqKFY086gIHy2LNuHeNFUynZe51DvlUUef7Xz3OlGYvbjzRVP0xp+f856IOJhp4oGj/i3nMA/lBhNNb8dxftJlATwvYifzyI88Fjwf2fia17irpBNjDVGy5q05jCsCytXoLxLf+lrr92a0ShKNVJHtWSZgdgQJvJVwBKsYsoUxKBeU4T6Wigo48QGXW2I6P0n+OsNKlmbr0p2lWR
 sWk39Zkc
 Xi/ooQKxXOFXS6FJ0PxeN6TdkcL91g+uTG7ywD7sUtKBzPVvzkRTT366SFxf7rllpwh7r2JmVX4vunRh3p6yNCL5E/PYJhgOg1WrU55SkYQf7ETE+wBJI1cXgld+yqmyRc2KySFP/2QbCtRbSicaRbf6DC0TnwF8ad7eqJNdqDJTGwer8T/H9p+1ZCVnhxsXlp6gnilQSgapJw28/cqoFZzDg4kXFopIcckITPHt+XueuvnG8x1Q+TQ/MAfyjoHEeE/Y+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/7 19:57, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Make the scan helpers return the exact number of folios being scanned
> or isolated. Since the reclaim loop now has a natural scan budget that
> controls the scan progress, returning the scan number and consume the
> budget should make the scan more accurate and easier to follow.
> 
> The number of scanned folios for each iteration is always positive and
> larger than 0, unless the reclaim must stop for a forced aging, so
> there is no more need for any special handling when there is no
> progress made:
> 
> - `return isolated || !remaining ? scanned : 0` in scan_folios: both
>   the function and the call now just return the exact scan count,
>   combined with the scan budget introduced in the previous commit to
>   avoid livelock or under scan.
> 
> - `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
>   scan count was kind of confusing and no longer needed to, as scan
>   number should never be zero as long as there are still evictable
>   gens. We may encounter a empty old gen that return 0 scan count,
>   to avoid that, do a try_to_inc_min_seq before isolation which
>   have slight to none overhead in most cases.
> 
> - `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
>   the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
>   naturally returns 0 when only two gens remain and breaks the loop.
> 
> Also change try_to_inc_min_seq to return void, as its return value is
> no longer used by any caller. Move the call before isolate_folios so
> that any empty gens created by external folio freeing are flushed, and
> add another call after isolate_folios to also flush empty gens that
> isolation itself may create.
> 
> The scan still stops if there are only two gens left as the scan number
> will be zero, this behavior is same as before. This force gen protection
> may get removed or softened later to improve the reclaim a bit more.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 60 ++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 462ca0fa2ba3..d3fd5bb56cce 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3878,10 +3878,9 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	return true;
>  }
>  
> -static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
> +static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>  {
>  	int gen, type, zone;
> -	bool success = false;
>  	bool seq_inc_flag = false;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	DEFINE_MIN_SEQ(lruvec);
> @@ -3907,11 +3906,10 @@ static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>  
>  	/*
>  	 * If min_seq[type] of both anonymous and file is not increased,
> -	 * we can directly return false to avoid unnecessary checking
> -	 * overhead later.
> +	 * return here to avoid unnecessary checking overhead later.
>  	 */
>  	if (!seq_inc_flag)
> -		return success;
> +		return;
>  
>  	/* see the comment on lru_gen_folio */
>  	if (swappiness && swappiness <= MAX_SWAPPINESS) {
> @@ -3929,10 +3927,7 @@ static bool try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>  
>  		reset_ctrl_pos(lruvec, type, true);
>  		WRITE_ONCE(lrugen->min_seq[type], min_seq[type]);
> -		success = true;
>  	}
> -
> -	return success;
>  }
>  
>  static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
> @@ -4686,7 +4681,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>  
>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  		       struct scan_control *sc, int type, int tier,
> -		       struct list_head *list)
> +		       struct list_head *list, int *isolatedp)
>  {
>  	int i;
>  	int gen;
> @@ -4756,11 +4751,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>  	if (type == LRU_GEN_FILE)
>  		sc->nr.file_taken += isolated;
> -	/*
> -	 * There might not be eligible folios due to reclaim_idx. Check the
> -	 * remaining to prevent livelock if it's not making progress.
> -	 */
> -	return isolated || !remaining ? scanned : 0;
> +
> +	*isolatedp = isolated;
> +	return scanned;
>  }
>  
>  static int get_tier_idx(struct lruvec *lruvec, int type)
> @@ -4804,33 +4797,36 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  
>  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  			  struct scan_control *sc, int swappiness,
> -			  int *type_scanned, struct list_head *list)
> +			  struct list_head *list, int *isolated,
> +			  int *isolate_type, int *isolate_scanned)

Nit: too many parameters for this function.


>  {
>  	int i;
> +	int scanned = 0;
>  	int type = get_type_to_scan(lruvec, swappiness);
>  
>  	for_each_evictable_type(i, swappiness) {
> -		int scanned;
> +		int type_scan;
>  		int tier = get_tier_idx(lruvec, type);
>  
> -		*type_scanned = type;
> +		type_scan = scan_folios(nr_to_scan, lruvec, sc,
> +					type, tier, list, isolated);
>  
> -		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
> -		if (scanned)
> -			return scanned;
> +		scanned += type_scan;
> +		if (*isolated) {
> +			*isolate_type = type;
> +			*isolate_scanned = type_scan;
> +			break;
> +		}
>  
>  		type = !type;
>  	}
>  
> -	return 0;
> +	return scanned;
>  }
>  
>  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  			struct scan_control *sc, int swappiness)
>  {
> -	int type;
> -	int scanned;
> -	int reclaimed;
>  	LIST_HEAD(list);
>  	LIST_HEAD(clean);
>  	struct folio *folio;
> @@ -4838,19 +4834,23 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	enum node_stat_item item;
>  	struct reclaim_stat stat;
>  	struct lru_gen_mm_walk *walk;
> +	int scanned, reclaimed;
> +	int isolated = 0, type, type_scanned;
>  	bool skip_retry = false;
> -	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  
>  	lruvec_lock_irq(lruvec);
>  
> -	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
> +	/* In case folio deletion left empty old gens, flush them */
> +	try_to_inc_min_seq(lruvec, swappiness);
>  
> -	scanned += try_to_inc_min_seq(lruvec, swappiness);
> +	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
> +				 &list, &isolated, &type, &type_scanned);
>  
> -	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
> -		scanned = 0;
> +	/* Isolation might create empty gen, flush them */
> +	if (scanned)
> +		try_to_inc_min_seq(lruvec, swappiness);
>  
>  	lruvec_unlock_irq(lruvec);
>  
> @@ -4861,7 +4861,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
>  	sc->nr_reclaimed += reclaimed;
>  	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> -			scanned, reclaimed, &stat, sc->priority,
> +			type_scanned, reclaimed, &stat, sc->priority,
>  			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>  
>  	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
> 

This patch makes the code easier to follow. Looks good to me.

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong


