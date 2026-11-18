Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954B2606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y02ImFVG
Received: by kanga.kvack.org (Postfix)
	id 79D7A6B00EF; Wed, 18 Nov 2026 06:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E666B05B0; Wed, 18 Nov 2026 06:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CBD6B05B1; Wed, 18 Nov 2026 06:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3BA6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:22:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B69A68073D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:22:42 +0000 (UTC)
X-FDA: 85448002164.21.9D42A43
Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8866D140005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:22:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y02ImFVG;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795000961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77LYkd6w+hlNQFCFED7fSwKj1hXKwNHIG4CKpCoNc2A=;
	b=ihJ0Bz6RKjv2+ztWUtoVmQZY1QqB2lUcZIgLv6OWt613i/C0wcPZCaVBgPbXYovqtBLHyy
	1bVPof8wxAUafwLGfJH57diOzV717Tm4OZDmC3pXGGPlVMxtgwS1GJEPxYoBAodfvOsNq1
	F2o3/FdgEfccW5dBW5QEEvzJGiyuHB0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795000961;
	b=NM3MBCvgW/WRskxGOZS2A4mdtFh4lwPEVNXdnenVoBDAqCKuRONt1qN25o6x6KhGdJXmWE
	GytsfztELl5pYnRguKfi1gcMSQJGsw+I3XbTk0yQvnevovgs8UxKaOQTSmHPv8KbsFYhMf
	GA6O567/6ccAF7AYQjND4MhuxGyjqqU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y02ImFVG;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sqf1F/p7j0Uf+RTtC3DdaK0iskYEuv41dl2cbLS6AHk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795000958; v=1; x=1795605758;
 b=Y02ImFVGyjtDOnuridr4UH21yzLqYUwLNlPHZxuiwlIAuBrwb4ZO78AKQW8gVaOoL1/v3xht
 vgOaoSI8ELrdTkfBVmG5tTrWl4QMDLhmc4peMM4Z0b92plBOxJVNFzSiMYAynoNerRic7n2WQpJ
 hvecQYmpkv5bmhi4sHhsKMr0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6e57789d0efec76c;
	Wed, 18 Nov 2026 11:22:38 +0000
X-Mizu-Trace-ID: 6e57789d0efec76c
X-Migadu-Flow: FLOW_OUT
Message-ID: <caceeef7-5148-4795-9947-dfcffff7b1f3@linux.dev>
Date: Wed, 18 Nov 2026 19:22:25 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/16] mm/mglru: skip zones above reclaim_idx instead
 of rotating them
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
 <20261114200803.23129-6-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-6-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8866D140005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: r78sb6yoadg5r6133xuxg39i16s6q7ju
X-HE-Tag: 1795000960-86455
X-HE-Meta: U2FsdGVkX19rTWQMYMoHGYoT0GcUk8qLU5jkRnGWEm+DmRrmk74aRHeqAx3GYJhZncQAQ8gEIg1lN1Q+GzqdGwi3jEgg2LtrHXHSHwtRah8EHmc97mclWlB+/+CMZlqzlFktOFl3BA6fE0EaIBtBeCcYdlG+KEsOva6V0RvfNKWcJJKunEQnYCzA8UoDY+TZIX7MTqnKz0NNlSpztAsJSjYbugN9AeAFWuiSH0OQYJMFwvbwOlczgvo2O8ijMb9X1F9bscuJCKklSxbiAbnfdD5O8pY6m2KJqyzgWwNiBzIJvTKu4jK8V+pX4sM5I2U5/KIQBOZe5YIAzJR6EW1sGv5/6F75vr9IgjDWCIqe22Igz1uppnIgGB0a8WGINIJTrX7lc4AWj80eY+fpc3V5EZu7bJt812pTJgxC1py631kgQ2H+6IhJEYeJZLM7Le+LRsbVxhzNxYd8aeqtZsDazqMErbDxs76NPe+zZWjU8tD+18oJ+Cqg92sOM60XZjQp2m8f/LS/YDQZVvHpg8dV8s5lKwUOAeMA/jbYUCcFM0AhRcEY+0E6sPdNIQQgPqGsotfZh23y96o9NyR+06gRRc3Y1eVLKDSFJbQL60E0i/2Qmg87sd8JFvh0HTQOQjoD/ZAk+uYMSydipu3DwLBUxY6tajpol22Iut/low0Zs3oNOw5pqGSDNgilQud68mSVZ94W5fWLWA4OzDl06ge1atf5j5lbx1DQGxsT9a0oT3OWRiu0GxNV0OOHfF+HUnzDUlSE5uPLMB3EstpIzr92wceE8agKqb+ZDE+TTkKdGf+fv9u/7kxmqRC+Tn9lv+vwHv3womrLkyaoz5aKG7ok0RKgjUnHH/+GMEhKTyBg/+lE2nh2HRMqD5Zo7FDGNe+gf10LUVvwxsO5UN8oZ+0NaNAp7TX7U+OXA6JcDoqs1LuwtqRoGT98oOFJ7oW3kB0bT4jVSYOk/L1O1mFVDC9
 fQbGcLEZ
 M7mAKWNewZbI9fh7yYlZufbgwh8y6W+UWpChLlk6LdoPBs7kOkO8LTZWJ1p93cncsY1Xmfsmc19wgD9qd3khkNKGV//P8FAANlHRdKkW8ecT2AALX2MoRp8cUFWAg7bojjnIiFveqi2mMGTUj2oS+3VAD0uiadIyBe54ouUWhCcSy7/HdiNcXo8hVJti3u6YJQrRDkBoLXtzaxVDHwcm5NEjhOXsiVKybRyxCIv/mv/zJ8EcEC4c+oHzCaTtBZPdHsgh22ogDYSCklg3GdcKEy9xC4hzRbNS+gtmjM68YFAp34lA8DiPCfsYrsecYodEOmCsPC8/7lx6iGeM/HYLBXhEyFqNclPin2MH/ClFJI1ddgCShonIUeWrfo9NZdpgNZ27uh1GK9BnOewiAnvlRhnd5GwcKIa3AWqr3lXArYSIxggmn7/X5jEN51fjbUYAM5aFK
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
> scan_folios() used to visit every zone. Folios in zones above
> sc->reclaim_idx can never be isolated, so sort_folio() rotated them to
> a younger generation, the "ineligible" branch, or, when only one gen
> was left, skipped them. This wasted scan work on every pass, and the
> rotation kept the protected folios from aging.
> 
> Restrict both the scan and the gen selection to the eligible zones,
> like the legacy LRU, which only isolates folios in zones up to
> reclaim_idx:
> 
> - lruvec_populated_min_seq() takes a zone_limit, so the oldest
>    populated gen is searched only among the zones the scan can
>    reclaim from. A gen populated only in protected zones no longer
>    stalls the scan.
> - scan_folios() iterates the eligible zones in the descending order
>    of the legacy zonelist walk, draining the zone at reclaim_idx
>    first.
> - The ineligible branch of sort_folio() is now dead and removed,
>    with a VM_WARN_ON_ONCE_FOLIO() guarding the new invariant.
> 
> try_to_inc_min_seq() still considers all zones, so min_seq[type] is
> only bumped once the oldest gen is empty everywhere. At DEF_PRIORITY
> the search bound stays min_seq[type], so the scan still starts from
> the oldest gen regardless of whether it is populated.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 47 +++++++++++++++++++----------------------------
>   1 file changed, 19 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 603fb7c73f94..b3ce4a550a62 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3992,7 +3992,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   
>   /* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
>   static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
> -					      unsigned long max_seq)
> +					      int zone_limit, unsigned long max_seq)
>   {
>   	int gen, zone;
>   	unsigned long min_seq;
> @@ -4003,7 +4003,7 @@ static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
>   	min_seq = READ_ONCE(lrugen->min_seq[type]);
>   	while (min_seq < max_seq) {
>   		gen = lru_gen_from_seq(min_seq);
> -		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> +		for (zone = 0; zone < zone_limit; zone++) {
>   			if (!list_empty(&lrugen->folios[gen][type][zone]))
>   				return min_seq;
>   		}
> @@ -4026,7 +4026,7 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>   	/* Requires at least MIN_NR_GENS gens for basic functionality */
>   	seq = lrugen->max_seq - MIN_NR_GENS;
>   	for_each_evictable_type(type, swappiness) {
> -		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
> +		min_seq[type] = lruvec_populated_min_seq(lruvec, type, MAX_NR_ZONES, seq + 1);
>   		if (min_seq[type] > lrugen->min_seq[type])
>   			seq_inc_flag = true;
>   	}
> @@ -4689,6 +4689,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   
>   	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
> +	VM_WARN_ON_ONCE_FOLIO(zone > sc->reclaim_idx, folio);
>   
>   	/* unevictable: let it through and the generic path will cull it */
>   	if (!folio_evictable(folio))
> @@ -4705,10 +4706,8 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   	 * longer be promoted or protected, so just isolate them. The one
>   	 * exception is lru_gen_reparent_memcg(), which is handled above.
>   	 */
> -	if (min_gen == max_gen) {
> -		VM_WARN_ON_ONCE(zone > sc->reclaim_idx);
> +	if (min_gen == max_gen)
>   		return false;
> -	}
>   
>   	/* protected */
>   	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
> @@ -4725,13 +4724,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   		return true;
>   	}
>   
> -	/* ineligible */
> -	if (zone > sc->reclaim_idx) {
> -		gen = folio_inc_gen(lruvec, folio, min_gen);
> -		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
> -		return true;
> -	}
> -
>   	return false;
>   }
>   
> @@ -4763,16 +4755,17 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		       struct scan_control *sc, int type, int tier,
>   		       struct list_head *list, int *isolatedp)
>   {
> -	int i;
>   	enum node_stat_item item;
> +	int zone_idx;
>   	int sorted = 0;
>   	int scanned = 0;
>   	int isolated = 0;
>   	int skipped = 0;
>   	int gen, max_gen;
> -	unsigned long min_seq;
> +	unsigned long seq;
>   	unsigned long remaining = nr_to_scan;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   	DEFINE_MAX_SEQ(lruvec);
>   
>   	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> @@ -4784,24 +4777,22 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	 * when under pressure to respect swappiness more and reduce IO cost.
>   	 */
>   	if (sc->priority == DEF_PRIORITY)
> -		min_seq = lrugen->min_seq[type];
> +		seq = lrugen->min_seq[type];
>   	else
> -		min_seq = lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
> +		seq = lrugen->max_seq;
>   
> -	gen = lru_gen_from_seq(min_seq);
> +	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
> +	gen = lru_gen_from_seq(seq);
>   	max_gen = lru_gen_from_seq(max_seq);
>   
> -	for (i = MAX_NR_ZONES; i > 0; i--) {
> +	/* Scan eligible zones in descending order. */
> +	for (zone_idx = sc->reclaim_idx; zone_idx >= 0; zone_idx--) {
>   		LIST_HEAD(moved);
>   		int skipped_zone = 0;
> -		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
> -		struct list_head *head = &lrugen->folios[gen][type][zone];
> +		struct zone *zone = &pgdat->node_zones[zone_idx];
> +		struct list_head *head = &lrugen->folios[gen][type][zone_idx];
>   
> -		/*
> -		 * If there is only one gen left, rotating the unreclaimable
> -		 * zone become meaningless, just skip them.
> -		 */
> -		if (gen == max_gen && zone > sc->reclaim_idx)
> +		if (!managed_zone(zone))
>   			continue;
>   
>   		while (!list_empty(head)) {
> @@ -4811,7 +4802,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>   			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
>   			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
> -			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
> +			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone_idx, folio);
>   
>   			scanned += delta;
>   			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
> @@ -4830,7 +4821,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   
>   		if (skipped_zone) {
>   			list_splice(&moved, head);
> -			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
> +			__count_zid_vm_events(PGSCAN_SKIP, zone_idx, skipped_zone);
>   			skipped += skipped_zone;
>   		}
>   

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


