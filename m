Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79A9DFF60D9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E2C6B008C; Tue, 31 Mar 2026 04:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746116B0095; Tue, 31 Mar 2026 04:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683326B0096; Tue, 31 Mar 2026 04:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5981C6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:04:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB6F71A0B93
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:04:41 +0000 (UTC)
X-FDA: 84605621562.20.3EC39E2
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8EC4C0006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:04:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JTnWCh3H;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774944280; a=rsa-sha256;
	cv=none;
	b=oHJapRkZrw2nRuEDJt4WN8q6ng41xsH96r/WRu0FBaeGEWG8gGxDZjBZ8HZNgWWPihcxyh
	LftcurBWjDa6yRpj8nowBULy8wAz+5vtnMqHojGfhP2qe9cZgYgem5gqBVCSeQil73PyV1
	p3vs0CChmRNb8kd2VMlERiGlD+hOS/4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JTnWCh3H;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774944280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTnq0mmzjppffXpYB5B4b2z/irJ0T8mlES9cozy6Bi0=;
	b=ub1r7YeD7eJ3TTHar+id0eb+YjSkD5UG6CfTvXZ2z9RilxQibpudCv1eHWI5T/Ec/hHxyM
	aCAUI6eV6uYDM/RyuUxGJYA68CaBPQsrD7HhpEUlofDj39+6/4lpHWDi+xin9eSnecWWn3
	VTzbUK/8cz5AbrNiC+CkYgcHbuMTZ+U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774944273; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aTnq0mmzjppffXpYB5B4b2z/irJ0T8mlES9cozy6Bi0=;
	b=JTnWCh3HWDMqmiPSLGlO5VbmojOhq+H6EOezOnXNIhdghl+FnfcQCV62hHo+HwbV4C96MQmYtjXGLZ/lgRX9dGQ36lAw3JruqjlWxkXuTVkiujNJgK6aaIjjykz62Irgl/fKMjWVzlKft9+FIfdzzqqKXvaWrKRqNCOX9+Z2/nI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X03ffKP_1774944271;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X03ffKP_1774944271 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 16:04:32 +0800
Message-ID: <3ef1cb78-5110-4326-bde1-d929f638b8f6@linux.alibaba.com>
Date: Tue, 31 Mar 2026 16:04:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/12] mm/mglru: scan and count the exact number of
 folios
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
 <20260329-mglru-reclaim-v2-5-b53a3678513c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260329-mglru-reclaim-v2-5-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D8EC4C0006
X-Stat-Signature: ucyo67uq375jp7nnut8hquuiurmag3sc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774944278-153538
X-HE-Meta: U2FsdGVkX19kOiYlPFW2PJgBu+jqU7tLv27f4o3QwlPYzmrv8/Zxzi28zUI8WmXqrPL6v6xbGJeerBs+G5GyIboA7uGKkOcFXOzBBdtHD5S6S4rG7kPteeljMOSSp3f7nFZEokP5Wv+9lGXYWVTL3wxy4UNIBTQOHo765ybTBpn0O9nJ8VnB2lsxGjE+7NuwJZctbHb3zm2t3cY0EzgEz9xpomV8Er9ysPYDcQ3xlYuxmdqlEmZR9xmA+bhRnA3+4F2U2xz4Mm9G7y2G99uMh8ehy+iijTbeQSJsoKD6/L6TgWYNyfN3NBq8CjtOB7YCqRd5B73gEYf77eE9GF+p46zKelmIVcRrYiIcqqF0q6pBuzeh2kfi0KZdw5x357uBc6Y9rcl0Z3hFr4wTCZ/5z9vlXPbX2ScsZzpzeycAA6Q5DvyzLSp1L9FaYEv73K06ih5rjvbDfmiptsrGhskCu9qemrGPilOjr+AxkeNlCUwNxFZCBuKbnhZFXLCuok3+cQnBXXg5Si4Sr7gv/sqLnovCsnNC0RzExy5LSLgpF1M97XoZv+fUbcqPyJwdiZ78KPgEBqMXPmBmTMwQUWhSKhWBVEzYzznVzDHhSUXyHFp8jLVy5gh3JJFBuUJGzCQyRkMMWs0FEmy/XmKDCHsniPAZfqqNZGVUwzii4pR3qF5XxqIdywRdopbGCC/xeEtsoDf4DKHd0fkpH3Q2Io16f+mh1ln24y6DIxpwXt8hMp34AqXYvrce5QM+Iy8NvCF0nT7S1e6UAZVT/2/79cY3Rw//9GIkibwA2hJQJC275cv5Bu4INWbw6d86blxSEkBojsbBb8xDtYCjngenx2is0ifYEiqFbnYS8gCrLjXOCzCm+P+UvEReaF9+4wrtErKCJTa35ibELG4RcvTPdD+lcsSE11kRYFsWyMGC6bMElGHyHbXYhZJTuaEgE9Rqbnk1SFbO1qu1fw0b3j39p8X
 qoU1eXjO
 V1t46bdvNxL4+vGYStTPazDoASN6YRoA/GXRxMRDwZ0sq40MRBBpnNuMNCZvhade9NKAOK4YhQwFnoPvx4Gn2kHXkyLwugsHyHxwejUCDvzaAjQOwWksAMmE0Y/lGTdZoBsY3q/wOC6Pd0MaF/26BsTmAFKXYnsPMmLinJLUg/Sre5ZXcoPUazxj1XX6K2LmZJSi8fb0MwhBTSqQ4kcazvdzRQd3zHF2buNX0IF26b05K0VM1pZ4M24kDsDzYD5qa/wP9j+nDb+Ra6qs1rjw93NuRS7ZpJWqsPdd8ZhD3OsRQkmGh7B5U0VICrBL1OsAz/k/Ty4L72aNj+9IaOyVvzTNE62ZWojS9+jJf/0+b/KntwWWZljlrO7cmamDbdQzmuVucjehA6z2hWqn1nfVe64K+Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Make the scan helpers return the exact number of folios being scanned
> or isolated. Since the reclaim loop now has a natural scan budget that
> controls the scan progress, returning the scan number directly should
> make the scan more accurate and easier to follow.
> 
> The number of scanned folios for each iteration is always positive and
> larger than 0, unless the reclaim must stop for a forced aging, so
> there is no more need for any special handling when there is no
> progress made:
> 
> - `return isolated || !remaining ? scanned : 0` in scan_folios: both
>    the function and the call now just return the exact scan count,
>    combined with the scan budget introduced in the previous commit to
>    avoid livelock or under scan.

Make sense to me.

> 
> - `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
>    scan count was kind of confusing and no longer needed too, as scan
>    number will never be zero even if none of the folio in oldest
>    generation is isolated.

Yes, agree.

> 
> - `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
>    the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
>    naturally returns 0 when only two gens remain and breaks the loop.
> 
> Also move try_to_inc_min_seq before isolate_folios, so that any empty
> gens created by external folio freeing are also skipped.

This part is somewhat confusing. You probably mean the case where the 
list of that gen becomes empty via isolate_folio(), right?

If that's the case, the original logic would remove the empty gens 
produced by isolate_folio() after calling try_to_inc_min_seq().

However, with your changes, this removal won't happen until the next 
eviction. Does this provide any additional benefits? Or could you 
describe how this change impacts your testing?

> The scan still stops if there are only two gens left as the scan number
> will be zero, this behavior is same as before. This force gen protection
> may get removed or softened later to improve the reclaim a bit more.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/vmscan.c | 46 +++++++++++++++++++++++-----------------------
>   1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ab81ffdb241a..c5361efa6776 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4686,7 +4686,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>   
>   static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		       struct scan_control *sc, int type, int tier,
> -		       struct list_head *list)
> +		       struct list_head *list, int *isolatedp)
>   {
>   	int i;
>   	int gen;
> @@ -4756,11 +4756,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>   	if (type == LRU_GEN_FILE)
>   		sc->nr.file_taken += isolated;
> -	/*
> -	 * There might not be eligible folios due to reclaim_idx. Check the
> -	 * remaining to prevent livelock if it's not making progress.
> -	 */
> -	return isolated || !remaining ? scanned : 0;
> +
> +	*isolatedp = isolated;
> +	return scanned;
>   }
>   
>   static int get_tier_idx(struct lruvec *lruvec, int type)
> @@ -4804,33 +4802,36 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>   
>   static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			  struct scan_control *sc, int swappiness,
> -			  int *type_scanned, struct list_head *list)
> +			  struct list_head *list, int *isolated,
> +			  int *isolate_type, int *isolate_scanned)
>   {

8 parameters:), can we reduce some of them?

>   	int i;
> +	int scanned = 0;
>   	int type = get_type_to_scan(lruvec, swappiness);
>   
>   	for_each_evictable_type(i, swappiness) {
> -		int scanned;
> +		int type_scan;
>   		int tier = get_tier_idx(lruvec, type);
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
>   		type = !type;
>   	}
>   
> -	return 0;
> +	return scanned;
>   }
>   
>   static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			struct scan_control *sc, int swappiness)
>   {
> -	int type;
> -	int scanned;
> -	int reclaimed;
>   	LIST_HEAD(list);
>   	LIST_HEAD(clean);
>   	struct folio *folio;
> @@ -4838,19 +4839,18 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	enum node_stat_item item;
>   	struct reclaim_stat stat;
>   	struct lru_gen_mm_walk *walk;
> +	int scanned, reclaimed;
> +	int isolated = 0, type, type_scanned;
>   	bool skip_retry = false;
> -	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   
>   	lruvec_lock_irq(lruvec);
>   
> -	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
> -
> -	scanned += try_to_inc_min_seq(lruvec, swappiness);
> +	try_to_inc_min_seq(lruvec, swappiness);
>   
> -	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
> -		scanned = 0;
> +	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
> +				 &list, &isolated, &type, &type_scanned);
>   
>   	lruvec_unlock_irq(lruvec);
>   
> @@ -4861,7 +4861,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
>   	sc->nr_reclaimed += reclaimed;
>   	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> -			scanned, reclaimed, &stat, sc->priority,
> +			type_scanned, reclaimed, &stat, sc->priority,
>   			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>   
>   	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
> 


