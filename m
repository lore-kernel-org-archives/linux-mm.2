Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF50606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 07:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dE2LtCSf
Received: by kanga.kvack.org (Postfix)
	id 5FF116B064E; Wed, 21 Oct 2026 03:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589606B0650; Wed, 21 Oct 2026 03:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4511B6B0651; Wed, 21 Oct 2026 03:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA0F6B064E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:28:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89F0C160482
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:28:31 +0000 (UTC)
X-FDA: 85345805622.16.72F45D6
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1E69EC0007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:28:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dE2LtCSf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792567709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NxXCENA5izIWUwsrnH3Nz2mrzDb9Ikv+qXSNgnFIzY=;
	b=xLdr7Hm9Yx6s6VIhhRazkC8EH8j1VPmVnb6EeG7xfIbMif8aBaTKlsh2RXPp5oiV5ueYjp
	o/hQF98qWntJiA4O/6rPDwHxVCXo55B8IaQKv/60MabR/AwBGj3BgpxBKtqsFv6W7LbYJw
	2/gKwsKWXe11a+5iZNh3HogIMLG5jsw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dE2LtCSf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792567709;
	b=KOrtgYkuxG76lsl5SAT4qlK2WSn6TNBZ8FFUHBvrvravHDO9fXzjwHxyTq5W16Kyz9qoLC
	TFuE8DjJ3iFQfflRwo0nP4FtJfBdmc+RJfmyLWzF0NT5usgg6qk7XpqmePKl+eWFaWcLIk
	7DI73T2yYWDwtXM1T+n8WK2FEhFyHAc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792567700; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7NxXCENA5izIWUwsrnH3Nz2mrzDb9Ikv+qXSNgnFIzY=;
	b=dE2LtCSfxUmQ7VoLO/Hik+OIOAj774RAzOBcaXWjZIF3S09LEYBV8jlogox+wilCJpnTWzdzYtzOGovcDQ1gV+pPwcLX8SXoXZpKeU1ibkEsQpuxVtLnPsTyzd3wmGdcWqNY5Kp3PoksfxigtSsuf72CkG54xZ6y5llTyjMNvR4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDFfURu_1792567698;
Received: from 30.74.144.135(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDFfURu_1792567698 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 15:28:19 +0800
Message-ID: <7f4daafd-a3c5-4ccc-80bd-05a7ac09e4ab@linux.alibaba.com>
Date: Wed, 21 Oct 2026 15:28:18 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache in MGLRU
To: Xiang Liu <liuxiang.277@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
References: <179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E69EC0007
X-Stat-Signature: 15e3wrp96tx8jqz4wsnntn1cxuc4qb9d
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792567705-872932
X-HE-Meta: U2FsdGVkX1+8wTcQQoNsi+pAZEpcheBnYoFvLW9NIosVqMezySfHReKQiBktqeQ3d5qobmMtcOsQ4sogqkMSE9SzYtoFIeCCd6CJQLXwVYz9KvzcF/eDiP4hAydUDUJKMsZffek01dplHiyLK8P+PICa2y7ZRq64u/nfOg/Ybgxj0ibWA5/XZSyZgShS6kTO/ODnf1wo/JETm2CPQLBQy1dr8i6T/RkFja36YzPfYttI0R2fHUH8pu3kbyfE3jyOjhX0pCcfsxWxafiOH4x8ikYHVgfBw7adm2nBNawntYuTv4Ppx456jD2q9/eolU7Do3oDioAh6yYbdZ/MlpGtOvyFOiVLm33Fe1EnPTjP3FU7h0AdNN5v2TgvXMmi7BKy5VL0B95IeC0Citvhlloo2pQdeiXvN0m3NHFoe0NckntI7KOeHeALYP1o4CjrFZtyqx+evrh23XGVbu3VZhFcqQSZtS4u9bknSYCvsISTzoPJGK8YQKJ7GAysAZUYc4k5CvoUwFrDgwjcWPuz7LLb2HfMMt1FJcBTuVJ5bljyMnu0mlMZT5A4yX0IsgYj1LyiGDP+nk6MFpdBhFu49nyipvJh9WWZTKwPOXSSDT8Jgr6fq7CO8EFzDZIlv7/cLqvLiYP9GRYRg8YQSUM9PiuXrp9WIe9ZtaydGTJHpt6JjrrzI4Z8WaaMBUrW8ai/NidGW97ttDDqwhhS+pbh0R2m26z6q6P9y/fHoTa+oUMoY2sSbpVi6qefwhR1ZAQQkuh/Ep9/9PfTwTrR71n7llDjKW4zMMwLKuhsVrQPR2hXvKhCNS73PQwEi5ZTmf9Q0reTYbdNLvFBGwi5RHdE3P0z/Q9Ntfu/TVNmubGyWFKOQYyTbiaMOclycxnGmDQ/MQegEGkN7E9iMBRqSyqkfTrB6aegRJgKig4uLm270g/82fpF5QpzJj1ElBYYIhzPHbHFvD7KGiYLBBljgkIB9Z2
 yVnCTwIM
 vrNMwFYcs9Y3IE4oHUDYX/m82wi2maRyUr9Afz8xIqaMPtqS85hRV1zn8d331hzpl12Vz3cj5K5rEupg5WpF4ndItt0/83JgmbK0Q69YbYTXZKrInApImGzWzexiPYAZTSiUAapVDoJz2ZP5QGaA8CeoLj5zyn894YtyEH5TwKRON/4Ga4xq0JzCv3DPwlM8XDY+M8OUE+IaUwN5Fv1sTu0ve6kvD4OpN9ZNqfRXmPbz+tqCzJ9tnFWNcJWOiuGnM/GmYfFocii7+4h88FoSSvko2/pumnBc/sLWvUhueHM+M1ULsr6qyMomyeAhLDVV3xlhwqvhtaqb/QbHufkjJxGAxL1IIwezpsQeWgD7/m1inGD5shPlnSK9DnPZBj2sQUCr3258TCcieg+YYu7SwLYAmXHQFHBkDA2BbPEh78pbUMspdaDMs2zasN19sgaY3MDQPIfWOwKqdztvPitngPV8MYX/NwxahiXa+MZpEPju/aOzKIz/R9mfFK2k+T6wxEfGmDzTVprD3vPStA8jePAVXD7VLlEyYncvUp5K1itGy6RMo3AEHyhp6QFcAs4+E3Mhy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 11:18 PM, Xiang Liu wrote:
> Bo Zhang's GFP_NOIO fix [1] avoids low-yield anonymous scanning in the
> traditional LRU but explicitly leaves MGLRU as a TODO. Address that case
> by applying can_reclaim_anon_pages() to MGLRU's scan policy.
> 
> Under GFP_NOIO, anonymous folios that need swap IO cannot be reclaimed.
> When swapcache is below 1/64 of the anon LRU, scanning anon can therefore
> spend substantial time isolating, sorting and processing folios with
> little reclaim progress. Reuse the existing eligibility check, including
> its swap and demotion handling, without adding another density threshold.
> 
> Introduce get_scan_swappiness() and use its result for the lruvec size
> estimate, scan budget, aging decision and eviction. This selects file when
> anon is effectively unreclaimable, while preserving explicit file-only
> and anon-only policies. For anon-only proactive reclaim, get_nr_to_scan()
> already returns 0 when anon cannot be reclaimed; do not duplicate that
> rejection in lruvec_is_sizable() or turn the request into file reclaim.
> 
> Size accounting must follow the scan policy as well. Otherwise an lruvec
> with no file pages and abundant unscannable anon can have a zero scan
> budget but still appear sizable to shrink_one(). With no aging to request
> rotation, it can remain in the old memcg generation and delay advancing
> to the next memcg generation. Share the policy between
> lruvec_is_sizable() and try_to_shrink_lruvec() to keep them consistent.
> 
> Use scan_swappiness to decide whether aging is needed, but keep the
> original swappiness when executing try_to_inc_max_seq(). In particular,
> file-only scanning with two file generations needs aging even if anon
> still has four generations. Passing a forced zero to the aging execution
> would instead let inc_min_seq() skip processing the oldest anon folios
> and could introduce a cold/hot inversion through the single-type shortcut.
> 
> The tradeoff is synchronous aging: with four anon generations and two
> file generations, advancing the shared max_seq can require moving the
> oldest anon folios to the next generation. Accept that cost to avoid
> low-yield anon eviction, without extending use of the existing shortcut.
> 
> The following measurements are carried over from v1, tested on mm-unstable
> at commit 55ff3dc8fced ("mm/hugetlb_cgroup: add trailing #endif comment for
> include guard"). They are not new runtime measurements of this v2 rebase.
> 
> The workload used dm-verity hash-block reads through dm-bufio, exercising
> the real allocation path with unchanged flags:
> 
>    verity_verify_io -> verity_hash_for_block -> verity_verify_level
>      -> dm_bufio_read_with_ioprio -> new_read -> __bufio_new -> alloc_buffer
> 
>    GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN
> 
> Allocation time spans alloc_buffer() entry to return with a valid buffer
> and data. Direct reclaim time spans try_to_free_pages() entry to return.
> Eviction and aging are the cumulative evict_folios() and
> try_to_inc_max_seq() times within that reclaim, respectively; aging
> already includes inc_max_seq(). These are wall-clock function timings,
> not end-to-end IO completion times.
> 
> 1. NOIO allocations under memory pressure
> 
> Generations evolved naturally, without forcing the four-anon/two-file
> layout. For successful allocations that entered direct reclaim, median
> times were as follows. Reclaim time sums the direct-reclaim episodes
> within each allocation before taking the median; eviction is likewise
> accumulated within each allocation.
> 
> Time (ms, median)            Baseline  Patched
> ===========================  ========  =======
> Successful alloc_buffer()     181.196    0.465
> Direct reclaim                181.185    0.131
> Eviction within reclaim       179.147    0.091
> 
> This run captured 28 valid buffers and no NULL returns on the baseline,
> versus 268 valid buffers and 62 NULL returns with v1; 28 and 266 successful
> allocations, respectively, entered direct reclaim. All reader operations
> completed. The table describes successful-call costs, not allocation
> failure probability or end-to-end IO speedup.
> 
> 2. Synchronous-aging cost
> 
> Prepare four anon generations and two file generations, with zero
> swapcache and pages in the oldest file generation. Verify these conditions
> at the NOIO reclaim entry, rather than relying only on preparation
> snapshots. Vary the oldest anon population to compare baseline eviction
> against the synchronous aging paid by the patch.
> 
> Each row is the first eligible successful allocation from an independently
> prepared trial at that size. Patched samples must actually execute aging
> and advance anon's oldest sequence. Oldest anon is its measured population
> at the matched entry; reclaim and its eviction/aging costs cover the
> associated try_to_free_pages() invocation, including other memcgs visited.
> 
> Kernel    Oldest anon  Allocation   Reclaim  Eviction    Aging
>                 (MiB)        (ms)      (ms)      (ms)     (ms)
> ========  ===========  ==========  ========  ========  =======
> Baseline     1755.266     131.704   131.699   127.985    1.672
> Patched      1840.422      38.316    38.311     0.307   37.785
> Baseline     4835.418     681.796   681.766   675.477    4.382
> Patched      4813.180      91.161    91.140     0.450   90.407
> Baseline     8941.582    1474.245  1474.202  1469.084    0.488
> Patched      9012.660     143.748   143.709     1.026  142.341
> Baseline    13104.676    1098.372  1098.354  1087.976    2.307
> Patched     13046.621     139.450   139.390     1.083  137.954
> Baseline    17187.043    2694.909  2694.902  2686.470    0.784
> Patched     17124.902     209.240   209.233     0.638  208.270
> 
> Across these recorded sizes, patched synchronous aging was cheaper than
> baseline eviction and successful allocation time decreased.
> 
> [1]
> https://patchew.org/linux/20260908062649.1045883-1-zhangbo56@xiaomi.com/
> 
> Signed-off-by: Xiang Liu <liuxiang.277@bytedance.com>
> ---
> Changes in v2:
> - Share the scan policy through get_scan_swappiness(), as suggested by Barry.
> - Explain why the aging decision uses the scan policy but aging execution
>    retains the original swappiness and its synchronous cost.
> - Remove lruvec_is_sizable()'s extra anon-only rejection; leave that handling
>    in get_nr_to_scan() and preserve anon-only requests in the helper.
> - Explain why the ordinary NOIO size adjustment is still needed for memcg
>    rotation, and keep the source comment concise.
> - Rebase onto the official mm-unstable head 3eb3e848d72c.
> 
> v1: https://lore.kernel.org/20261010141057.599595-1-liuxiang.277@bytedance.com/
> v1 test base: 55ff3dc8fced48c98667c19769c55103a23eabce
> Discussion: https://lkml.iu.edu/2610.1/08079.html
> 
> Regarding Barry's review:
> 
> The scan/aging split is intentional. should_run_aging() sees the restricted
> scan policy, while try_to_inc_max_seq() still receives the original
> swappiness. The comment now explains why this retains synchronous anon
> aging instead of introducing another use of the cold/hot shortcut.
> 
> The duplicate anon-only rejection is removed. get_scan_swappiness()
> preserves SWAPPINESS_ANON_ONLY, leaving get_nr_to_scan() responsible for
> returning 0 when that request cannot reclaim anon.
> 
> The ordinary NOIO size adjustment remains necessary: without it, a
> zero-file lruvec can get a zero scan budget but still look sizable due to
> anon. shrink_one() can then return 0 without rotation. Since shrink_many()
> visits the current memcg generation and that generation advances when its
> bins empty, this can delay reaching memcgs in the next generation.
> Both callers therefore share the helper rather than duplicate the policy.
> 
> 
>   mm/vmscan.c | 37 +++++++++++++++++++++++++++----------
>   1 file changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fc823fe3bd1f..e881b30dbe2e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -379,13 +379,6 @@ static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
>   	if (!sc || (sc->gfp_mask & __GFP_IO))
>   		return false;
>   
> -	/*
> -	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
> -	 * scanning type, so only apply this to the traditional LRU for now.
> -	 */
> -	if (lru_gen_enabled())
> -		return false;
> -
>   	if (memcg) {
>   		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
>   
> @@ -4351,12 +4344,35 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
>   	return total;
>   }
>   
> +/*
> + * Use the same policy for sizing, eviction and aging decisions, so anon
> + * excluded from scanning cannot prevent memcg rotation.
> + *
> + * Keep the original swappiness in try_to_inc_max_seq(): a forced zero
> + * would let inc_min_seq() skip the oldest anon folios and risk cold/hot
> + * inversions. Accept the synchronous aging cost instead.
> + */
> +static int get_scan_swappiness(struct lruvec *lruvec, struct scan_control *sc,
> +			       int swappiness)
> +{
> +	if (swappiness == MIN_SWAPPINESS || swappiness == SWAPPINESS_ANON_ONLY)
> +		return swappiness;
> +
> +	if (!can_reclaim_anon_pages(lruvec_memcg(lruvec),
> +				    lruvec_pgdat(lruvec)->node_id, sc))
> +		return MIN_SWAPPINESS;
> +
> +	return swappiness;
> +}
> +
>   static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
>   {
>   	unsigned long total;
>   	int swappiness = get_swappiness(lruvec, sc);
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   
> +	swappiness = get_scan_swappiness(lruvec, sc, swappiness);
> +
>   	total = lruvec_evictable_size(lruvec, swappiness);
>   
>   	/* whether the size is big enough to be helpful */
> @@ -5249,9 +5265,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   	bool need_rotate = false, should_age = false;
>   	long nr_batch, nr_to_scan;
>   	int swappiness = get_swappiness(lruvec, sc);
> +	int scan_swappiness = get_scan_swappiness(lruvec, sc, swappiness);

IMO, 'swappiness' and 'scan_swappiness' are really confusing. Why move 
this logic into get_swappiness()? In get_swappiness(), we already have 
some similar logic to adjust swappiness when there is no available swap 
space.

         if (!can_demote(pgdat->node_id, sc, memcg) &&
             mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
                 return 0;

>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   
> -	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
> +	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, scan_swappiness);
>   	while (nr_to_scan > 0) {
>   		int delta;
>   		DEFINE_MAX_SEQ(lruvec);
> @@ -5261,14 +5278,14 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   			break;
>   		}
>   
> -		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> +		if (should_run_aging(lruvec, max_seq, sc, scan_swappiness)) {
>   			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
>   				need_rotate = true;
>   			should_age = true;
>   		}
>   
>   		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
> -		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
> +		delta = evict_folios(nr_batch, lruvec, sc, scan_swappiness);
>   		if (!delta)
>   			break;
>   
> 
> base-commit: 3eb3e848d72cde2156447cc960ca321bb2ac41a9


