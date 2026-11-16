Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC800606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZBUdc5Uu
Received: by kanga.kvack.org (Postfix)
	id C4B4D6B05B0; Mon, 16 Nov 2026 07:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCCF6B05B1; Mon, 16 Nov 2026 07:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB5D6B05B2; Mon, 16 Nov 2026 07:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2856B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:28:01 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E40DFC0965
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:28:00 +0000 (UTC)
X-FDA: 85440909120.01.2DD5CF7
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6363140007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:27:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZBUdc5Uu;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794832079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kx5FtkmNVBJTIPMl0Mjj8C0dyNOu/3z6ThVSeBWYgAw=;
	b=yqoj2t8VyKEwB7B5DuxghX3sFRNJoqRg8O416MH1zwyBrtXUIObMTVAICwhXz7IYUcS9o9
	vdTgigrVTpklW4/roamBLxShcHf03174A9ebyy2kPjOzFMjmHcO93gDIIDe6GMRuoRoPtq
	fQjXuD2eEkPfwW4AUqGsyEwIs4uBpXs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794832079;
	b=hrItsmnR+eiHMe3JQ1V9EOoGYyFr1rUIaEkL5ItZaIcjUWIEq1V9Q7+RJxrE1AiVJcB02D
	5GnrBXanThd+qxo8szD39UYcfH4Un5PVA4LDH/slx7Et5c+icFI0edCeDJCpOcq74tRIL9
	PzMqjwhdeswlG5Nhbk+yUrAWsRN5X0o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZBUdc5Uu;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g6QVX7tnnVwAGTDOuJi5dF9bHqzxlFE9Z1IlVUFl1Qg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794832077; v=1; x=1795436877;
 b=ZBUdc5UuOAr3/V/ldU3f/8Lh399nVHUmdwT1a38w8vIjLjk5tEPg1HCHuUr7kRbEyG7k3ITJ
 iHXK3xeeAsMQCFjp/QNoalwt0OaUnWMm9BLuPnaiE00MxIQxRANnSmq+moH+r6NJdXvAEtoku4T
 LNgOZCb3Yos9B5uUpRamXATU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 060a218e1ec6539b;
	Mon, 16 Nov 2026 12:27:57 +0000
X-Mizu-Trace-ID: 060a218e1ec6539b
X-Migadu-Flow: FLOW_OUT
Message-ID: <d138bb44-3af2-46ec-b8eb-77307209c3e8@linux.dev>
Date: Mon, 16 Nov 2026 20:27:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/16] mm/mglru: reclaim from the oldest populated gen
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
 <20261114200803.23129-4-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-4-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6363140007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: pypx5nz313o7js1zd35dgj4q5xduk9sf
X-Rspam-User: 
X-HE-Tag: 1794832078-876423
X-HE-Meta: U2FsdGVkX1+gQYhRUZeCYLm95HIoBcF/UvVDdHCTC1vLpMoMpbs37qegmJy9VIN69ETc0qcS6cvjJKyhNkARIS5FLPesQhuhqdU0c0EeKQi3TQX5ELbgodfkSgXAx+y57+Y1qcE/iPMA7TraFy13nMw/uQ6JM1hQJFbll7GhJY8Tft5v3eJ5M0E4oqqidDqIB8SbCarAnpJYVAFCWVwiqRodEwFCH9M7PRa4pxHc/346ZLhkdQ/GLURIXRAHrKJRj7p9h8IHBMUbQkfQKa4AAtkqV8rT9fwHEjZx6NpJu1X4SNIVakBya6Y5VcspEV0n+zuFjxlMTtALss1mTYSEwz5jyCGgjqySAazYINn+1eVoRGK7Or9ncU+1L7xS1bgmJ8dxg5Ri6x0ZX3Aa1RHskmi4CU94ve61xf0TS6XsYb6gBxrYIASvSwv0bey1jE5uLpYMP61/ZisO065jfys69g3h1NkKQpzP2jDqoR74jqFKjS0UjgLycTg4+Lfy5iiXE4spf1LMbHL5BkkMz/RQXMWDsrZmwHFdTm0QhOGO2x9O0tHjnrD/RmiFvOt0I+14UgoercG49b5HjeonOnaNXuVBbcrTcZSjWHB7RUtwPMHXjuViwDs3clip3q6QdiKbb5SqnrSNoJvIEdF3DkRgm29BaaFGrMFSbCF5dpN2TqZ41T1HTLKcAojsCbeKu/x2IJNtYTJlY08wffAg2ARHy0fDi774Ou0REvZfdXOEWn58+Odft1b7gRK1OzRyQTzCCDavj8ac6+lvmBM3s6bITyMnHDQCc20f+BCdUc4NJwFQdfbMxg0WM28y+JAvNg7N6Onu7p0vONVZufjsUKEMbx9lTvTlu9Zk3xi54O5rjV1KGH6JDwaZcbXcQBajtWhCkkXoJ7l/5lsPD3eU9X9rx3UzQkxDS5X/SrTplrJp5FS1Fjq7yQkgUx0aiXyOldyrOH3rXWDWqG+mfe70eYo
 tqhxRdWP
 gXzGPYyKwLXR8v9LEfNlJYMLEkf913HRXjDkJU6YkNg81lbmNWvvmtQkxAmfeQ3x9o/wNJnBvaYtPtc5IZcGxaEt1nJ8IX3NH70kO2gTZW3H8IlHS5wMQAbc12FF1KY128OOKrHIFQjcRJ9+CJjPQuIpdCosoUbM6Sf/Wr+pAqb49PMng15C7zboR9dOic2WaRFDDUEJEaQ+ENzwH6ALTSYse8HyVAujM5iXNaZRNJJ3LNuzo9kczyiUih4wfpuEGlyptvOW8se3o2eEA0e4RVGwKIcDmRMRg4cl65z7GvNO/qxgL1WZUnxmMm/850PLURRh4fFI48miv0DdIacMvK2ISGMgHR/r2lGA2BHWx78b+IcGF1lAHxVKCEWCQFZiB4ZtPsai4FSzcsnsH/Q6jBwWuMLnOqrucfNoaWStxONCT04U=
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
> Currently MGLRU tries to keep the gen numbers of the two types in sync,
> avoiding reducing the gen number of one type when the other type has
> more gens, as described in the comment in try_to_inc_min_seq().
> 
> This makes scan_folios() stuck reclaiming the type with fewer gens: it
> always scanned the oldest gen of the type, even when that gen was
> empty, so reclaim made no progress on that type unless forced aging
> created a new gen and eliminated the dead empty gen.
> 
> There are other approaches, like lifting the gen number
> synchronization [1]. However, that would break the gen layout used by
> lru_gen_folio_seq(): newly added folios would no longer have a
> well-defined hotness according to their gen number, which reduces
> accuracy. It is also not pressure-aware, since with gentle reclaim we
> still want to respect the gen layout (hotness).
> 
> Instead, reclaim from whichever populated oldest gen is left, but only
> when the default reclaim priority can't satisfy the reclaimer's
> requirement. This is typical for swappiness limitations: e.g., low
> swappiness asks the reclaimer to reclaim from file, but file gens are
> drained, so the reclaim cycle fails and priority is raised.
> 
> At the default priority the scan quota is 1/4096 of the evictable
> size, and the old behavior is kept there to respect the hotness
> distribution. Once priority is raised, the quota is at least 1/2048,
> so the hotness bias introduced by reclaiming from a younger gen is
> bounded by that quota, which seems fair. Global reclaim for MGLRU may
> start with DEF_PRIORITY / 2 (1/64); the ratio is still reasonable at
> that point, and when global pressure is more critical, we should
> reclaim harder.
> 
> Note that scan_folios() still refuses to reclaim a type left with only
> MIN_NR_GENS gens, so a completely drained type still requires aging.
> This change only avoids scanning empty gens when populated reclaimable
> gens remain.
> 
> Link: https://lore.kernel.org/linux-mm/20260726122123.7614-4-baohua@kernel.org/ [1]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Barry Song <baohua@kernel.org>
> ---
>   mm/vmscan.c | 30 +++++++++++++++++++-----------
>   1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ae3e13b1fb27..1197e15065fe 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3312,11 +3312,9 @@ static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
>   }
>   
>   /* protect pages accessed multiple times through file descriptors */
> -static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> +static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, int old_gen)
>   {
> -	int type = folio_is_file_lru(folio);
> -	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> +	int new_gen;
>   	bool gen_increased;
>   
>   	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
> @@ -4679,7 +4677,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>    ******************************************************************************/
>   
>   static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
> -		       int tier_idx)
> +		       int min_gen, int tier_idx)
>   {
>   	int gen = folio_lru_gen(folio);
>   	int type = folio_is_file_lru(folio);
> @@ -4697,14 +4695,14 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   		return false;
>   
>   	/* promoted */
> -	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
> +	if (gen != min_gen) {
>   		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>   		return true;
>   	}
>   
>   	/* protected */
>   	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
> -		gen = folio_inc_gen(lruvec, folio);
> +		gen = folio_inc_gen(lruvec, folio, min_gen);
>   		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>   
>   		/* don't count the workingset being lazily promoted */
> @@ -4719,7 +4717,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   
>   	/* ineligible */
>   	if (zone > sc->reclaim_idx) {
> -		gen = folio_inc_gen(lruvec, folio);
> +		gen = folio_inc_gen(lruvec, folio, min_gen);
>   		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
>   		return true;
>   	}
> @@ -4762,17 +4760,27 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	int scanned = 0;
>   	int isolated = 0;
>   	int skipped = 0;
> +	unsigned long min_seq;
>   	unsigned long remaining = nr_to_scan;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   
>   	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>   	VM_WARN_ON_ONCE(!list_empty(list));
>   
> +	/*
> +	 * Respect the gen hotness distribution at low priority to avoid
> +	 * aging and scan cost, but prefer to satisfy the reclaimers request
> +	 * when under pressure to respect swappiness more and reduce IO cost.
> +	 */
> +	if (sc->priority == DEF_PRIORITY)
> +		min_seq = lrugen->min_seq[type];
> +	else
> +		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq - MIN_NR_GENS + 1);
> +
>   	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
>   		return 0;
>   
> -	gen = lru_gen_from_seq(lrugen->min_seq[type]);
> -
> +	gen = lru_gen_from_seq(min_seq);
>   	for (i = MAX_NR_ZONES; i > 0; i--) {
>   		LIST_HEAD(moved);
>   		int skipped_zone = 0;
> @@ -4790,7 +4798,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   
>   			scanned += delta;
>   
> -			if (sort_folio(lruvec, folio, sc, tier))
> +			if (sort_folio(lruvec, folio, sc, gen, tier))
>   				sorted += delta;
>   			else if (isolate_folio(lruvec, folio, sc)) {
>   				list_add(&folio->lru, list);

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


