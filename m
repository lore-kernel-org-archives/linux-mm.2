Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9E0606A337
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eYAFlMAt
Received: by kanga.kvack.org (Postfix)
	id 2F26D6B00EF; Wed, 18 Nov 2026 05:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA6F6B05B3; Wed, 18 Nov 2026 05:51:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207546B05B4; Wed, 18 Nov 2026 05:51:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8A916B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:51:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5792F1206BA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:51:00 +0000 (UTC)
X-FDA: 85447922280.22.B0AF23E
Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2CC94C0007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:50:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eYAFlMAt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794999058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Itlfx11zXnBZntjOPS/51jfyw6vtkyZLDdFLWbHwde4=;
	b=D/0JCyeW7M6gfDwufJZuaE4i1KfJG+NhZqZ31IuTCNghyMh4t604M3vbCjqlJf9R8iZJSe
	lU7G42W9hhxnfXBAGCHmBIP+pDgWi3PIpNEtlwYUIa6JgPDZDbVDGpxlln/y4QwSwqFRqB
	5ixmBeA3N7GHf6jr3hRHLy1B/43LLHo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eYAFlMAt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794999058;
	b=RVtC2xs4StrFyvclH3MCTo8xFNK/4lEyd/FhvrUFX52biAbGRQIPPSmbbbxv6fSfLbkdAs
	nbs5eoirFroXiOqxh7HFLK4mWJFxgifvNXQWzTZQFCRAV8OBVKkpUTuOKQjlkvqsTO1+4o
	asjxOU0g0zTtmmyOFdGrBFYvArX/0zc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jURBODj3t0kFMsYUQPyoSVho8qNObWqngSiKtSuGKU8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794999056; v=1; x=1795603856;
 b=eYAFlMAtxY29YXjIMdemdCWgpIyxjvRqjYRTnDmDeAKezT3UY0Yg7uJ1+ea+xuePWWgnZnez
 VGJiDS7G5FrSgoL2hc3d6T/K1qYz4IQLfI618qiiQYsr+ZnPTj64yPLzWdpWYxuDT/1oDnyGp0j
 QiqUyayCJge2Y5pwsaR6m1jQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a7c0abf208a54be0;
	Wed, 18 Nov 2026 10:50:56 +0000
X-Mizu-Trace-ID: a7c0abf208a54be0
X-Migadu-Flow: FLOW_OUT
Message-ID: <923bb35e-df40-4c67-923d-f518290ccce3@linux.dev>
Date: Wed, 18 Nov 2026 18:50:38 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 04/16] mm/mglru: lift the forced protection of
 reclaimer
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
 <20261114200803.23129-5-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-5-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xo17uzojjr7fu6iiwbbnkzwocqw8i3yp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CC94C0007
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794999057-142948
X-HE-Meta: U2FsdGVkX1/vS7BhcK/G7m5VEXc2hEtQfI8ZNEQr+ObmQw/A8FU7OnXW9YScc8o8QqNaMWZEoeHh6DAKrOYJKV4SCxk6/+FwkIjOa7MdOj48hj2kbCtJe7g7DCYos+bVeK4TBVySd/IFyWsSd03t0A385aBDVbts2XGM1qMcnBbqw7F+uOELXuPXvVSX1TPOaN0QwC1NbZsSte6FJUyIqId6MwRVMgKBqfl149CVpwZMNlqakvGa0wsAoq8c6we227Et2ULhOq7GDffmzJQfrtvnMzC48yj3p5qg783a4j9S8BvNSDDynKahs69MLnETYccB7usCXjfTRXepQa4b5lqXhZkh8H3A9XzFmQBorxyLVYTNm7Mo42WvZUCOIyr/qD5AyAeV9vupqoTNQXgF168GCDK0tYq36SPL7NOBaQr3+DBOzKzW3knj+gKpqKBfFe9BUdxGLLTjcs+Y8DYI7Ciwf5EaVL2Vd5BH7+lSL5ic9ccybyHRmOEw6+HJBztURAPZGHo0EevxN8rf5bvTSFV4422O4pygMkuK5GgXyTNSMJASctk7DJxC7PGW+FGsWH6XN8YGZZPGxL+QezRszAtt0LmMiy5XzHr5NYiOQG/U1wSX8nSIKi93j/xs9NV71vxC+n/iahlGAlmPErCo7IKXmtBgvdeVbvuWx//deXL2+72DLMCsaOYU9CKHA6c2Fz6OtARV5AIl519WT7nj+/OsjBH8a5lfl+Cp3jETWjmpW0iWtEAzLG9nRIXWWmnVfhyQJ+CkZdapoLTk37HSYZFKiSIkdV4PQrngvJ0ywNDInpk/gXNM9u3KZeiiSM/EK3ipwFLncKHsMfHDuI8vWJDiC8XpEHUrrYNRxZCQRv4uQ+g5ccbsyBrgE5A14eZSfJiu5yXP2UKT2iGpulVKB59G3C88BQB6BnCIQekVO9DaEUmcPJ0ehgn/dMkrXnjcvRpL1xHJkOF2gdMzmin
 oa3oq2cb
 MSQpLnZEk4O2+sr1GOQy9MtnFFm736VC6Yj/bP+UxHDtaiHK7RGfzi6JK1Be1hlXKHsH6JGcc9b9vIqB2BmJPVfpwel1Nm1c1Au24ea1TzSRmjk375JmNoRfXEVs1VF787iq+erAfRx6ffQHbJ2Plj8hXtl6S24sS/TQuQOxYZdeSMLbce73JJg7l0I26YToF1/ZUmD+SI941d8Kt5vpUW1N1G+Bn+987TsvzrS53yUitHLMDcxbkl99KVm3yCP+/l+2Gr28eFPqU6xxLd0disrMNs1FM4v4pQi+dB4Rwv94S894pNZfm9ybKm/MPdNj5XhtQSPPYxnx6jvgjKdrOKqwshfOoE/K55StFEhgeNYtyAZscfbN4iD+JNTawkZ/SiBJIbNse+xQOp8xWnOXZo4r1AYQh/z2wQEMG+vWeiTCHfiykz+XzFSBKv9CdXyP3MRZQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> When a type is drained down to MIN_NR_GENS gens, the reclaimer will
> fail to make any progress on that type without aging.
> 
> However aging comes with a cost, and it will take time to finish. Even
> if we do aging more proactively, when under great pressure, gens will
> still be drained very fast so the new gens produced by aging can't catch
> up with the consumption. With MIN_NR_GENS setting blocking the reclaim,
> we will run into OOM. This OOM can be reproduced by the previous test
> program [1] used for fixing another aging problem [2]. When running in
> great pressure, certain workloads will keep seeing premature OOM with
> MGLRU, and never see any OOM with classical LRU.
> 
> This might get worse if we implement async aging, or avoid hotness
> inversion in aging, as they will slow down the aging process even more.
> 
> To fix this, let's first drop the get_nr_gens() == MIN_NR_GENS early
> return and let the raised-priority scan bound cover max_seq itself.
> 
> Mapped folios will still survive as the rmap PTE check will keep them.
> Unmapped cache folios may thrash more under heavy memory pressure.
> This should instead be addressed through refault-distance and
> frequency-aware promotion [3].
> 
> Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [1]
> Link: https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/ [2]
> Link: https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencent.com/ [3]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---
>   mm/vmscan.c | 34 +++++++++++++++++++++++++---------
>   1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1197e15065fe..603fb7c73f94 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4677,7 +4677,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>    ******************************************************************************/
>   
>   static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
> -		       int min_gen, int tier_idx)
> +		       int min_gen, int max_gen, int tier_idx)
>   {
>   	int gen = folio_lru_gen(folio);
>   	int type = folio_is_file_lru(folio);
> @@ -4694,12 +4694,22 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   	if (!folio_evictable(folio))
>   		return false;
>   
> -	/* promoted */
> +	/* promoted, or moved due to reparenting. */
>   	if (gen != min_gen) {
>   		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>   		return true;
>   	}
>   
> +	/*
> +	 * We are reclaiming the last gen left. Folios in this gen can no
> +	 * longer be promoted or protected, so just isolate them. The one
> +	 * exception is lru_gen_reparent_memcg(), which is handled above.
> +	 */
> +	if (min_gen == max_gen) {
> +		VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
> +		return false;
> +	}
> +
>   	/* protected */
>   	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
>   		gen = folio_inc_gen(lruvec, folio, min_gen);
> @@ -4754,15 +4764,16 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		       struct list_head *list, int *isolatedp)
>   {
>   	int i;
> -	int gen;
>   	enum node_stat_item item;
>   	int sorted = 0;
>   	int scanned = 0;
>   	int isolated = 0;
>   	int skipped = 0;
> +	int gen, max_gen;
>   	unsigned long min_seq;
>   	unsigned long remaining = nr_to_scan;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +	DEFINE_MAX_SEQ(lruvec);
>   
>   	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>   	VM_WARN_ON_ONCE(!list_empty(list));
> @@ -4775,18 +4786,24 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	if (sc->priority == DEF_PRIORITY)
>   		min_seq = lrugen->min_seq[type];
>   	else
> -		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq - MIN_NR_GENS + 1);
> -
> -	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
> -		return 0;
> +		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
>   
>   	gen = lru_gen_from_seq(min_seq);
> +	max_gen = lru_gen_from_seq(max_seq);
> +
>   	for (i = MAX_NR_ZONES; i > 0; i--) {
>   		LIST_HEAD(moved);
>   		int skipped_zone = 0;
>   		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
>   		struct list_head *head = &lrugen->folios[gen][type][zone];
>   
> +		/*
> +		 * If there is only one gen left, rotating the unreclaimable
> +		 * zone become meaningless, just skip them.
> +		 */
> +		if (gen == max_gen && zone > sc->reclaim_idx)
> +			continue;
> +
>   		while (!list_empty(head)) {
>   			struct folio *folio = lru_to_folio(head);
>   			int delta = folio_nr_pages(folio);
> @@ -4797,8 +4814,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
>   
>   			scanned += delta;
> -
> -			if (sort_folio(lruvec, folio, sc, gen, tier))
> +			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
>   				sorted += delta;
>   			else if (isolate_folio(lruvec, folio, sc)) {
>   				list_add(&folio->lru, list);

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


