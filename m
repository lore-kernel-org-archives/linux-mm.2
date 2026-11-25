Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93EC606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WlLAo1lN
Received: by kanga.kvack.org (Postfix)
	id E38816B09F8; Wed, 25 Nov 2026 07:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F996B09FA; Wed, 25 Nov 2026 07:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CF56B09FD; Wed, 25 Nov 2026 07:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD4656B09F8
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:59:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49EE9A8597
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:59:53 +0000 (UTC)
X-FDA: 85473648666.10.C9959DC
Received: from mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1146B20005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:59:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WlLAo1lN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611591;
	b=X9C0cPkxM7h9uyxGhr9x/KmN3GTEQ1MouoUJJdxojBCbjZ8mP4fV/z3OGDQk3kfbsqb2Rh
	QqbDD7Lx80hFFCECXAYqB+tYp1ke865fZpRy9WwXaNxB/5MPVaVEYfPey19lcl1jDqiTXJ
	v+7Ar8hWbo5/6Js+8ovVHfEBCzYqbmw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+Mpazxl4ZEIYEZU/rJ/n2zn5OgZbseL/gkYDzd+dwc=;
	b=Tnto/c+Gs3vlwkt1KzT8Xlw1PJivlAqNyM7cJcv/UYMT8TR+PgIPCGQdBDl98zynt/ynGk
	otAOtUqSD9xpTPfXH+2MtEPgzUPfAVX7cu/XRCL6TdGF0duRuhQxyocAYGsXrC+M9GeZIK
	BA1ZrOFEDoml/qJgekrkpWwJvAtconQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WlLAo1lN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zvbWqo5iHc5+akdiEM8RCy5BVcALG0xIAZNTE1kuK1g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795611589; v=1; x=1796216389;
 b=WlLAo1lNv8iH8o8n7VKHCUvl64e1kpI2IsRlzaCwY6+dbLfZfSDMqqydjcG/Q86vXMhwJxKD
 3sv55vXnXLodBR2IYxDuicHdb53cJLoVW8mPo0Y6vSi2wkUJqS5CHPrasjLHwthS8z+A4UBJ8BS
 lZl0z11fI4v/9d5VuYCe1wlk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 89e5829b4aa7431a;
	Wed, 25 Nov 2026 12:59:49 +0000
X-Mizu-Trace-ID: 89e5829b4aa7431a
X-Migadu-Flow: FLOW_OUT
Message-ID: <0b27c4ca-4c5d-4693-9153-51ab365e06b0@linux.dev>
Date: Wed, 25 Nov 2026 20:59:34 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 12/16] mm/mglru: Restrict eviction accounting to
 eligible zones
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev,
 kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 zhuhui@kylinos.cn, sidchintamaneni@gmail.com
References: <20261114200803.23129-1-baohua@kernel.org>
 <20261114200803.23129-13-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-13-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1146B20005
X-Stat-Signature: fs4mubobwwg5pckpkyuie4f5qtwnaxbi
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795611590-734898
X-HE-Meta: U2FsdGVkX18wNwaF+50G8hSxAgtWK7tbtPxMCPqgXrXOYnfx+USzhejeZzMtag447Xrh/u8k1QtWVvEAzUQjpPCb615PFlCouJpxPrVf1kJhStYFOpk0G3q5Nepau9rkWnAppSP3vhx0pTs57UjGvvHrvuli00ObjM8Hmt3/U7H0ne9EnMwa6zTXV91idX7tIwzcTiUUmAoJdrHcZv6Cxpuqm+wYKA+H1e6/0Eiq8umr+zYZ77E8ZV7Z7iuulUvyftpEyMEJyApKUUo89m7d1M8EvoLUpgb9/CZSvhIiD+7IYi9pJXdNLvKOxLbRixTq2X68B+2iOwBuw6XL5hT5hkWC+AT/jQeqGsl2cXy+tCuzlVaFEZmInjDGGXQ0/2csgVHhLW7Kz+7wce3H/sjkyKcNFFSS+xB1dvgUAcyigE85UM//YMV5r3abZRjBmFxjW3TNU525pshPYEZO1cESP1Na8kh9mWvhGOg4pFTV7Mb6XJiQKxcd+dLHrMxOk+Fv1InSnHtIw6wQtmhVIo0XkLLvjOG3Itld99Gv0ACt7f08dwXkIRRBs8bnQ+POJ+mWCeDRVSEGWDTl5zLsIzrGn+vs/MN0SRSpSD1n5ImgG06aDDsM5/cSKYnfS32sFTqPNO1SgW7A97G3jO9rc6P2LNxJy4X+c0a7Y4Y80YoONufV0AgSyDABiUxUXqYldPnOe4K5IfHJGPN71BjOKmLVpVNmYjjMnvujDJZDuwvI7g7RkzkUKgS96StF7SbZv8aDIRZiVSMARInaUowusttFuAzbxrjrl17LhN44tZCbpbsM3pmJbK2l05F3dtyftBCeF0vxIwM7Rxw71t/vlNs5lwTtiMcb5T1yMzHR+BxW8U9HxmU0+5Va16LMRBi5SZbTnvGrAIAqqBA+yqwCp9h6ASiEaFuSFB6m1oJpEgaDwerbu6FxVDmuWmb3VY/6fNfI8V+EduOAstG1jaeudIO
 2yKZsvSk
 5cDXEcUOMm+pLmeuU24YZnxWsGyAJjoplsYlh9YCrxfqbnIoHxPTMQQ6DdCr+w5E1M8cC4ESfksKqI/AuHYFwGOr9PlCtVF06GBxryG1g+YUrTZG42XrpaR1LmrBoPH0zX8kGSbi1lO/mRjArmULX7pXlI01Hjas9zV9sfkwOHcUtyMk/hvxBdbvV0aU4aqPsdyJgwIFEQvClGooMjbkE27z2dO4Fl63Nnkh7DbbeZKX6knQPGgMsobXX03q8teUjB7ARuVAFnyswNxuItUJQawxQXQRM53AeCJWBBgx1vDcsMSmHcq23tOhkBPgpIWjH+W7jJ19Gnb9jZ/zEOfj79PzErIyMz+MTmwFsr9RAUrwx7LY671nCccmIbgHOlpc1qJRX4V10LcxpPTVypXCErMM1xlzxOndEDwKRTgw4PAFMDniIdNZgxGF+T1nKJvF9rtZIDUxTuXCzPORaPRcuCb9I6R72Y27RAbAJZ87Z82CNEUA/UPYbXqY5KaiOgm7AdaIJc3rvQNRAbFnQkfM5lZXepYz3AJWqotaOyTWF6Nt4o61IyOgNJSJOguU2UVn3aR6g4whfGCmReuxPcFEJzkbj3SjPLx0v/rWCjEpAf5zd/Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
> For both lruvec_evictable_size() and lru_gen_imbalanced(),
> only count eligible zones up to sc->reclaim_idx. This avoids
> overestimating the number of pages available for scanning and
> allows aging to proceed more promptly when eligible zones
> contain few folios.
> 
> lru_gen_age_node() uses lruvec_is_reclaimable() to determine
> whether any memcg has generations old enough to reclaim under
> min_ttl. If none are reclaimable, it may trigger OOM. However,
> lruvec_is_reclaimable() also uses lruvec_is_sizable() to
> estimate the LRU size.
> 
> Previously, lruvec_is_sizable() counted folios across all zones.
> With accounting now restricted to zones up to sc->reclaim_idx,
> the estimated size may be significantly smaller, potentially
> leading to premature OOM.
> 
> To avoid this and simplify the implementation, allow
> lru_gen_age_node() to count folios from all zones.
> 
> Note that min_ttl currently has several issues and does not
> work as expected.
> 
> First, reclaim does not enforce min_ttl on a per-memcg basis,
> so folios from memcgs whose generations are all younger than
> min_ttl can still be reclaimed.
> 
> Second, the LRU size check is coupled with the min_ttl check,
> which can lead to premature OOM. For example, consider a system
> with 100 memcgs, each containing fewer than 16 MB of evictable
> folios. At priority 12, shifting each memcg's LRU size by
> sc->priority can yield zero, causing all memcgs to be considered
> unreclaimable even if their generations are older than min_ttl.
> 
> These issues should be addressed in a separate patch series
> rather than as part of this eviction accounting change.
> 
> Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/trace_vmscan.h |  4 ++--
>   mm/vmscan.c       | 27 +++++++++++++++------------
>   mm/vmscan.h       |  7 ++++---
>   3 files changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index 565c56428364..9dafdb5bd3ce 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -488,9 +488,9 @@ TRACE_EVENT(mm_mglru_aging,
>   			unsigned long seq = max_seq - MAX_NR_GENS + 1 + i;
>   
>   			__entry->nr_anon[i] =
> -				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq);
> +				lruvec_gen_size(lrugen, LRU_GEN_ANON, seq, MAX_NR_ZONES);
>   			__entry->nr_file[i] =
> -				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq);
> +				lruvec_gen_size(lrugen, LRU_GEN_FILE, seq, MAX_NR_ZONES);
>   		}
>   		__entry->nid = lruvec_pgdat(lruvec)->node_id;
>   		__entry->priority = sc->priority;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6d942f192e63..c9e22a5cbb51 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4207,8 +4207,9 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
>   	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
>   }
>   
> -static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> -				  unsigned long nr[])
> +static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc,
> +				  int swappiness, unsigned long nr[],
> +				  int max_zone)
>   {
>   	int type;
>   	unsigned long seq;
> @@ -4221,16 +4222,17 @@ static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
>   
>   	for_each_evictable_type(type, swappiness) {
>   		for (seq = min_seq[type]; seq <= max_seq; seq++)
> -			nr[type] += lruvec_gen_size(lrugen, type, seq);
> +			nr[type] += lruvec_gen_size(lrugen, type, seq, max_zone);
>   	}
>   }
>   
> -static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
> +static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc,
> +		int max_zone)
>   {
>   	unsigned long total, sizes[ANON_AND_FILE];
>   	int swappiness = get_swappiness(lruvec, sc);
>   
> -	lruvec_evictable_size(lruvec, swappiness, sizes);
> +	lruvec_evictable_size(lruvec, sc, swappiness, sizes, max_zone);
>   	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
>   
>   	/* whether the size is big enough to be helpful */
> @@ -4249,7 +4251,8 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
>   	if (mem_cgroup_below_min(NULL, memcg))
>   		return false;
>   
> -	if (!lruvec_is_sizable(lruvec, sc))
> +	/* counting all zones to avoid premature OOM */
> +	if (!lruvec_is_sizable(lruvec, sc, MAX_NR_ZONES))
>   		return false;
>   
>   	gen = lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
> @@ -5099,9 +5102,9 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
>   	for_each_evictable_type(type, swappiness) {
>   		unsigned long seq;
>   
> -		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
> +		youngest[type] = lruvec_gen_size(lrugen, type, max_seq, sc->reclaim_idx + 1);
>   		for (seq = min_seq[type]; seq < max_seq; seq++)
> -			old[type] += lruvec_gen_size(lrugen, type, seq);
> +			old[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
>   	}
>   
>   	/* the vast majority of pages sit in the youngest gen */
> @@ -5136,7 +5139,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
>   {
>   	unsigned long total;
>   
> -	lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +	lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
>   	total = nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
>   
>   	total = apply_proportional_protection(memcg, sc, total);
> @@ -5323,7 +5326,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>   	if (need_rotate)
>   		return MEMCG_LRU_YOUNG;
>   
> -	if (lruvec_is_sizable(lruvec, sc))
> +	if (lruvec_is_sizable(lruvec, sc, sc->reclaim_idx + 1))
>   		return 0;
>   
>   	/* one retry if too small */
> @@ -5853,7 +5856,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
>   			char mark = full && seq < min_seq[type] ? 'x' : ' ';
>   
>   			seq_printf(m, " %10lu%c",
> -				   lruvec_gen_size(lrugen, type, seq), mark);
> +				   lruvec_gen_size(lrugen, type, seq, MAX_NR_ZONES), mark);
>   		}
>   
>   		seq_putc(m, '\n');
> @@ -5906,7 +5909,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
>   		if (sc->nr_reclaimed >= nr_to_reclaim)
>   			return 0;
>   
> -		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
>   		lru_gen_balance_scan(lruvec, swappiness,
>   				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
>   
> diff --git a/mm/vmscan.h b/mm/vmscan.h
> index c6b583fc7493..c2cea36289f3 100644
> --- a/mm/vmscan.h
> +++ b/mm/vmscan.h
> @@ -117,14 +117,15 @@ struct scan_control {
>   };
>   
>   #ifdef CONFIG_LRU_GEN
> -/* The number of pages of @type in the generation @seq, summed over all zones */
> +/* Number of pages of @type in generation @seq below @max_zone */
>   static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
> -					    int type, unsigned long seq)
> +					    int type, unsigned long seq,
> +					    int max_zone)
>   {
>   	int gen = lru_gen_from_seq(seq);
>   	unsigned long size = 0;
>   
> -	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
> +	for (int zone = 0; zone < max_zone; zone++)
>   		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
>   
>   	return size;

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


