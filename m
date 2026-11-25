Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26358606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P+C1/iYf
Received: by kanga.kvack.org (Postfix)
	id 3D2886B09C7; Wed, 25 Nov 2026 06:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3826E6B09C9; Wed, 25 Nov 2026 06:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272026B09CA; Wed, 25 Nov 2026 06:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECB3C6B09C7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:47:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06866160DBD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:47:54 +0000 (UTC)
X-FDA: 85473467268.12.BFA27AE
Received: from mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2612C0009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:47:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P+C1/iYf";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607272;
	b=4lY5vorI7g82gEwAFDsrmDyEShXSHJXfCnpKnp3hs/J+XgpKoVbGwVkGEcWejNVqoq0lFm
	34l++aDwXcdayxk2gowFGSvoYz5J9Cb3Ye3TIhjWCZAZnjuQ3l8K5cTg80NNfzHyy3Yi/5
	6X5m2FHjnaFVkYcUgkLvUtrZt5OIG5M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uftm8l0P1lvzgPJDRipge4Ec3j5A5wJyMrLil3kjAnw=;
	b=v1b9nBmYNlQSqH163PEXpzoxvBW6H3ZLoKcJ/5V/3zxQ2yPMrcRbAKv8Ox+RL3XI/xZc4Z
	9lq6vglURWQJzGhs77702bhUG52jWc/2s5/mtDme9/Sz1ls28n914UHhWZ3OZ8T+WTxfot
	oA0NBjp5CmsMs9+Hi3u4xkcdHN838Fg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P+C1/iYf";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.226 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KTH0YYon1dsjvvAs8tsQMpP7zzlJkAMRifqXz3mgGhY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795607270; v=1; x=1796212070;
 b=P+C1/iYfnEosQOpYi9uKy9YgO9VRcaQqk9Wv1TZpnJf/ttAtZ4XhRtQ7ZzqFU1VQ2oeNcZLH
 ks5VF2S6k4b8Qi7iudZ/mSwo2RTH+fiiYE+0Mv5S4Bn7KpK3Q74kNtR9tdQs/GMMyFigb60GOtN
 nWCM4UmbXUuw97w1Lh3O3JIQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fee1e389369225e6;
	Wed, 25 Nov 2026 11:47:50 +0000
X-Mizu-Trace-ID: fee1e389369225e6
X-Migadu-Flow: FLOW_OUT
Message-ID: <e2595c80-c223-472a-a756-d352161a3330@linux.dev>
Date: Wed, 25 Nov 2026 19:47:35 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/16] mm/mglru: Avoid placing rejected folios below
 populated gen
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
 <20261114200803.23129-10-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-10-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D2612C0009
X-Stat-Signature: je9a5w5j9tmzzss3qwpsgs47hkrno8zp
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795607271-907326
X-HE-Meta: U2FsdGVkX19f1tZtbG9OMN6HbqG3LDW0F0DeYANKf59kB3bNG0MmdhSEov2iltYQ1bfXTec1oxD5dg29b93v3lyWrMxWl2j6FvFJ/zOQSrbhVZ703d1oTmntaqDgfMd0L09bTJUvTYqIQ24WtdT6nORf8yixGEZhgEhJKv+ngQwwzZHyBkjrFVcXfa3Y5Zi1jVWG/d4RHZSPPeM7WuS/GmpD9/hPQHWp/C8/TP+vgafCu1vWcJa/2qJU07olylC35zQblG/vNi1EcAIPQgXPM9z0OALc37E3aOvP6PQGi9DiF9lAg2B0lXHMf2IONbHToAH4OXzdY+Gfn5t4Xbl1R1htmUjpa08jSeOjboE+t0iQxNW9jKr/tLRS5rdyuePzEDo4BV9dqyr/WNd7ZS0qiuJMVbzCpjWWcrabsxwiomm/Z4CUd++syWAbQAeokyOmGN/XyW9P5DFBZTCDcxQPek1wWnJeWGCspy3aXd1gERTAVY0Bt58cwLh8RxRgsPo3B3Jlh9eSTQZ6kP3gdo1Y2kGuCAifn1aWwv13ERx/R6WygwojzxWSakZeYJsgxkmo/vN3emAShuNX/x8PGN3XPRIk8bE8BXDty4/z/HOK4VLodNGHQx1FeszDOK+VzjJgh67dN2vboirZgNHHSe4cSRFK00xxeFWTtrM+r0CRuw2tw/6dy7ef4AaFQvQkQ7aXWXIux+xZ1NfXDMb2B4BKQ1axxLXl8ZXnPlrAhRZBtQATD8aBP70d9/kDtfrsLDLhlJjAlrRFGq1uA4oqcDiqysNXpgyY3QXXGLAQjjMV7SYyOinBe9WkXihwzxmRPXudJyzpoUv3f/ZYDm38Mh0rdanr/gKeFC2/cNu9pRE6m3p2pFLw1nkC55rQlGsJP4XIg2HcoLwbBYRIxjzJqNvZsiniuQ+0S9qik+yLeuv+3NVTbzj/Um58QlbVE9d4w9ekZ2PVjhYKLcJqO2alb/t
 TNlgySra
 eu1oox4+90sptwDAGPCT4tdMPNdQvFblRlESD3G6Fmb/R2qRh6o45ujba4VTHwpOAIcCpop6aJ01t507RPYmFPMHU4TKz3LCYQThaEoJ7pAcjGndgDenMHf2N4z5OXgi0sGNC8hgIwZKWs3ML1AwmnWPbBsRAyuvJDVhFENE/tCLb1CjgDK/sf6N2Dc7yadScw6eurBmcYu6YISoVMaiaGKPLhZrFxFoWh5yXmyKgcu2HsyBGu0Ov4sq+t6pW3H+nBNynlsaSYSRgHp315pYnmUQq8rMdXI2FwaiCoG35P7TdY3EV4KiwgGEvqka+qEOnnSweIVcLZ7XGvrXrbM0whXfT/+HtIDXg0hjH6JPlttwyAvgT7RN4OUBJ335LYgwj4vxK3KhdPHSlGNrhz95fCsK/P2ccR3aO73OPZ9POVN9PpZCyEbRKp5M0unJUiV7u9zQFPeBh/f2U1YKtK2FKIgchmIjm/Q80MLewPFkK2NefBFumYZMLY/1nqSzzLqHwB1vngidCR7+q/RwwdfyT/G+0gXwarEJdaPBOlWLSG/QvEFZbOtC24I65KGmcIDlcsgJK1uZDaQOdATSK4Dh3B0Situkgb8neTJLhNMc3NLZ7X8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
> We used to scan only the oldest generation in scan_folios(). In
> evict_folios(), we checked whether
> lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]. If so, the
> folio was marked active and moved to younger generations.
> 
> This was itself buggy, as folios in generation min_seq[type] - 1

Should this be min_seq[type] + 1?

> would not be marked active by folio_set_active(), potentially causing
> a cold/hot inversion.
> 
> Besides this issue, the old approach also differs from the current
> behavior, where we can scan fewer than two generations.
> Now that we can scan younger generations, including the youngest
> generation, this no longer prevents rejected folios from being placed
> in a generation below or at the populated generation. Such rejected
> folios would then be scanned again and again, resulting in extremely
> low `pg_steal/pg_scan` ratios. For example:
>    pgsteal_file: 2312605
>    pgscan_file:  36465693
>    reclamation efficiency: 6.34%
> 
> We pass `scanned_seq` to `move_folios_to_lru()` and make sure we either
> promote the folio or place it in the youngest generation when the
> populated generation is already the youngest one.
> Also, folio_set_active() is no longer needed.
> 
> With this change, the results become:
>    pgsteal_file: 2683815
>    pgscan_file:  4224244
>    reclamation efficiency: 63.53%
> 
> The sys time for building the kernel also decreased from 4m30.532s to
> 3m50.188s while swappiness==1.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---
>   include/linux/mm_inline.h | 22 +++++++++++++++++++++-
>   mm/vmscan.c               | 24 ++++++++++++------------
>   2 files changed, 33 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..f6f4bc9a704f 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -332,7 +332,8 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>   	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
>   }
>   
> -static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
> +static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
> +		unsigned long scanned_seq, bool reclaiming)
>   {
>   	unsigned long seq;
>   	unsigned long flags;
> @@ -347,6 +348,8 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   		return false;
>   
>   	seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
> +	if (scanned_seq != -1UL)
> +		seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
>   	gen = lru_gen_from_seq(seq);
>   	flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   	/* see the comment on MIN_NR_GENS about PG_active */
> @@ -362,6 +365,17 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   	return true;
>   }
>   
> +static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
> +{
> +	return __lru_gen_add_folio(lruvec, folio, -1UL, reclaiming);
> +}
> +
> +static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
> +		unsigned long scanned_seq)
> +{
> +	return __lru_gen_add_folio(lruvec, folio, scanned_seq, false);
> +}
> +
>   static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
>   {
>   	unsigned long flags;
> @@ -420,6 +434,12 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   	return false;
>   }
>   
> +static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
> +		unsigned long scanned_seq)
> +{
> +	return false;
> +}
> +
>   static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
>   {
>   	return false;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b538abf02578..0fef966b0a14 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1865,7 +1865,8 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
>    *
>    * Note: The caller must not hold any lruvec lock.
>    */
> -static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
> +static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq,
> +		bool do_rotate)
>   {
>   	int nr_pages, nr_moved = 0;
>   	struct lruvec *lruvec = NULL;
> @@ -1922,7 +1923,7 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
>   		    !folio_test_referenced(folio) &&
>   		    folio_ref_count(folio) == folio_expected_ref_count(folio))
>   			lruvec_add_folio_tail(lruvec, folio);
> -		else
> +		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
>   			lruvec_add_folio(lruvec, folio);
>   
>   		nr_pages = folio_nr_pages(folio);
> @@ -2041,7 +2042,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>   	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
>   					 lruvec_memcg(lruvec));
>   
> -	move_folios_to_lru(&folio_list, true);
> +	move_folios_to_lru(&folio_list, -1UL, true);
>   
>   	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
>   					stat.nr_demoted);
> @@ -2152,8 +2153,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
>   	/*
>   	 * Move folios back to the lru list.
>   	 */
> -	nr_activate = move_folios_to_lru(&l_active, false);
> -	nr_deactivate = move_folios_to_lru(&l_inactive, false);
> +	nr_activate = move_folios_to_lru(&l_active, -1UL, false);
> +	nr_deactivate = move_folios_to_lru(&l_inactive, -1UL, false);
>   
>   	count_vm_events(PGDEACTIVATE, nr_deactivate);
>   	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
> @@ -4753,7 +4754,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>   
>   static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		       struct scan_control *sc, int type, int tier,
> -		       struct list_head *list, int *isolatedp)
> +		       struct list_head *list, int *isolatedp,
> +		       unsigned long *scanned_seq)
>   {
>   	enum node_stat_item item;
>   	int zone_idx;
> @@ -4784,6 +4786,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		seq = lrugen->max_seq;
>   
>   	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
> +	*scanned_seq = seq;
>   	gen = lru_gen_from_seq(seq);
>   	max_gen = lru_gen_from_seq(max_seq);
>   
> @@ -4980,6 +4983,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	int tier, scanned, reclaimed;
>   	int isolated = 0, nr_isolated = 0;
>   	unsigned long total_reclaimed = 0;
> +	unsigned long scanned_seq;
>   	bool skip_retry = false;
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> @@ -4991,7 +4995,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   
>   	tier = get_tier_idx(lruvec, type);
>   	scanned = scan_folios(nr_to_scan, lruvec, sc,
> -			      type, tier, &list, &isolated);
> +			      type, tier, &list, &isolated, &scanned_seq);
>   	nr_isolated = isolated;
>   	if (nr_isolated)
>   		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
> @@ -5017,8 +5021,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>   
>   	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
> -		DEFINE_MIN_SEQ(lruvec);
> -
>   		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
>   		if (!folio_evictable(folio))
>   			continue;
> @@ -5037,11 +5039,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		 * so this effectively promotes them by at least one generation.
>   		 */
>   		folio_set_lru_refs(folio, 0);
> -		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
> -			folio_set_active(folio);
>   	}
>   
> -	move_folios_to_lru(&list, false);
> +	move_folios_to_lru(&list, scanned_seq, false);
>   
>   	walk = current->reclaim_state->mm_walk;
>   	if (walk && walk->batched) {

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


