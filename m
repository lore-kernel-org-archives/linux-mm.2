Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A73606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 01:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e+zYDn0c
Received: by kanga.kvack.org (Postfix)
	id A8DEB6B05B0; Thu, 26 Nov 2026 20:58:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64836B05B1; Thu, 26 Nov 2026 20:58:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B666B05B2; Thu, 26 Nov 2026 20:58:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27A706B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:58:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B02011C2689
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:58:09 +0000 (UTC)
X-FDA: 85479238698.18.3E933CC
Received: from mta1.migadu.com (out-236.mta1.migadu.com [95.215.58.236])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E352180003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:58:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e+zYDn0c;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.236 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795744688;
	b=rVY0MYGDsgm7QX/9LxwEtHlHotJWLZgh0+QeiAoWlgjt4aDIipB2Cu++2wq0PSuoWk19QG
	/na1d/g6cvSNrc/QjVgtvxdZJ+g3xXIl7tKeymukjvUFtKUHeMJc6d76F6Th3Dq1wu4taQ
	d2/rtAXI0/Bq0nSpjcEXkzzAoB4FuPg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795744688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=quOpidQ65ertMcQcQVEDfa++3yyN2utCqBeIGYCv1ks=;
	b=vlbAkVtrLDsOynJH2UFxhKeITP+IgQcOxcSzq3HWD+DjB8h1Vwa1+9D7iCKoWA3iaU6yyb
	CMtkFEurNJCt7t+DH8KsVjzxa6prercjfhS/+VvlAq/4H2VYg/yco8CM/U8dKVRUrY4h4T
	gVCMSWTWlc0WlqGsczKMsnREA5UDgho=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e+zYDn0c;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.236 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9hlSR5VAEGqnYObJ1uVH8pENVu6NTSK1bKdnIjboNOk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795744686; v=1; x=1796349486;
 b=e+zYDn0cdynntZCO1CbkKm5jtjyjn6T1bu3vb4oTDAzaob16Ui/Xef0J/cTg55KxpIeb7cEo
 +PaCnmcgUs3Xeafq2H4jgstj39CwqI6V/rdcrVvBKowRay9V/m/+9Jjd2GTmZ/4c13Jcwg6cHwy
 8TX4blr4L0ziUMQFWmVzpIuc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 46990cf407084ce6;
	Fri, 27 Nov 2026 01:58:06 +0000
X-Mizu-Trace-ID: 46990cf407084ce6
X-Migadu-Flow: FLOW_OUT
Message-ID: <7976acea-9e05-46e8-b0e4-31aa27af6e98@linux.dev>
Date: Fri, 27 Nov 2026 09:57:57 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/16] mm/mglru: balance anon and file scan budget by
 refault rate
To: Kairui Song <ryncsn@gmail.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org, axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev,
 kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org,
 shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 zhuhui@kylinos.cn, sidchintamaneni@gmail.com
References: <20261114200803.23129-1-baohua@kernel.org>
 <20261114200803.23129-8-baohua@kernel.org>
 <5238e574-ed22-4781-aac2-b91a6b2d911e@linux.dev>
 <awf7WGiaC4LVLYhA@KASONG-MC4>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <awf7WGiaC4LVLYhA@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aiyu9z8d6nys9i3ggs8yk3pfg4zr6cp1
X-Rspamd-Queue-Id: 9E352180003
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795744687-880273
X-HE-Meta: U2FsdGVkX18/hROnaKPFpFv6ZAt2X8uX6CXjaJaDKDJMxMhQhGFU/BXvWhqPiCcSxhneVyYgGXzri9NDRDqFsUX5nYIO21XZpsBQ3itoe9fIh74JjuS2BVt4f6/VNJmGKsK2PPIvO/rNuZYZEJiWoI3MALoypRnZdOnW4GLdaQJ94MupWZx352LWykT3AoJRya6MnPLB8J6XFU0bEIK3f/poTOelwAo1nlD9E0xUojvpKUCNxLlqeh/BGnSo5JLd/LN9ySZMWB4YZxzVM1FHzSBGhtsteA62UhK1V+ejq7K9QKRL+XNoAa2Sl5X50LYdVPppLWMA69NM3fkx++0Y5vBStacFME1mCSiqygTrzcZHVEaBNFZV6bSOSQLOayzS4++ielT1gdqb1Men0hHXMAVE+K8jpY1LTAt+PsJ7iELy+YCO3QzLKFpfzkZa6G1AQVFfchVchk6ic3AR5J9N7M4BBsaE6Rq8Htfvw8zizCUbEkY3GVkp5jXSG2wyo9l1+uujbSdbDtGaLHGuBIxIE4J4KGyYJXIjjIE1Sp5H+ZfGBx0POZILL7zuK/ZpDdATDw/top1E0tucFViQIbzZMY81Qofsn0ishp5TXPW4WVX87lc8+kPo1HXNbfK5kHaRwzd5/ZDQcIVPOP/Fp7d8wJLwvBnITqNcf9ahHjwSSTXxr2Gk38g5/Y8cy0QVTaheHD7b0kQ1odpHwwwkknjtO68Np7C5T3PPcc+bJkXhixYj9Ul7aQMjsIGDWOy00xX9oTkohW1yViP4stRAEY+Bg2FOmohku8CfUMs1H6IWp9ebCnjgOg7vIOpuzq91dFc6oE5HP8udVDeMimRQmFe8upUiuvl91PcJr3YUzbr6HVvQcD8p70HzexoxuAZhn4ixXLCaJdcZLirPJdhDCiJYAvV6jb0KH7fezG8eGPmVjS/YQN/h0Gf3B6KIr34E3tYHh4avDO5dfw/7nsmn72z
 sbDLqJWi
 WDqI2TZ6DeZkXrJQcBya1TTj2dTPfQc38HoLhs494EhzF66oKQM607Vq6GlnGF0C7Hvs1y+1Lpsqw95Ju5xCht8ub91tYMePjnaENRNhc+auD9hqVFyqOWIGmdHVZ7+vij5Geuf5/j21OOLw2ZSHnIPWHoHR2zYtEJsmanhthDpub9EW0g8+7imPFy5Xj0XdmJntRDQr9xY/zI8hGL93c/6y9Uh9oelQPk/A5kkqoYgqZ54f4u9W7xWCrxVq4u4j59PcZ7psen6gtjl4cf8yYr1/+FvK9WhfpUEl1U6ShKq44TSmRD0pnkFK+vz6S1mPxRghsL66mORmteafDxnq5O8E/U+b5WETMdNRlzIIPhxX0AirQT+Im8ZXdDR5Tzd3o1joxxumSowoHya4IFzcLtOaPf7aLE0JfAKSErPAr6Pf/wDzKqH6NpY737+pacmN/UtTksXA4vi215TCcPG5Optn+nTL8MxQQVUvC4D1FvZ4xk9ACrkJPaqPAFtqVS1mPckvGiU0maGdzHIzSLzHTCCsT86hWj2Lus09Sox5N+eN4eVMpwG95q1RE55mS6BKrBZ8bLVfSsIerA0yTuTxDuPNSdYYeegVHwhqUcgFjZ6esifO1lQPz5gwmC7mwCdrG+n+p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/26/2026 6:37 PM, Kairui Song wrote:
> On Thu, Nov 19, 2026 at 05:48:38PM +0800, Ridong Chen wrote:
>>
>>
>> On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Replace get_type_to_scan() and isolate_folios(), which selected one
>>> type per batch, with a proportional split of the scan budget between
>>> anon and file, and scan both types each round.
>>>
>>> lru_gen_balance_scan() splits the total by
>>>
>>>           anon : file = swappiness * r_file * w_anon :
>>>                         (MAX_SWAPPINESS - swappiness) * r_anon * w_file
>>>
>>> where r_anon and r_file are the per-type refault rates scaled by
>>> 4096, clamped to [1, 4096]; a rate at the 4096 ceiling means the type
>>> refaults at least as often as it is evicted. The w factors bias the
>>> split toward the LRU sizes at mild swappiness and follow the IO cost
>>> ratio at the extremes. Both rate accumulators start at MIN_LRU_BATCH,
>>> so a type without eviction history reads as 100% until evictions
>>> accumulate, and the floor of 1 keeps a type that never refaults from
>>> zeroing out the other type's share. Swappiness 0 and
>>> SWAPPINESS_ANON_ONLY keep their single-type behavior; at swappiness ==
>>> MAX_SWAPPINESS the file factor is zero, so anon gets the whole budget,
>>> as in the classical LRU; swappiness 1 no longer forces file-only
>>> scanning as the old code did.
>>>
>>> The proportional protection and priority reduction are applied to the
>>> total once, before the split, and each budget is capped at its type's
>>> evictable size. Regular reclaim derives the total from the evictable
>>> sizes, so the budgets sum to it. The proactive path re-splits the
>>> remaining target each round, so eviction keeps working while either
>>> type makes progress, until the target is met or no progress is
>>> possible. The debugfs scan_control gets .priority = DEF_PRIORITY so
>>> eviction starts from the oldest gen and reports the default priority
>>> in the tracepoints.
>>>
>>> Note that we are already lenient with the debugfs proactive
>>> reclaim interface. We may reclaim one generation ahead even
>>> at `DEF_PRIORITY`, and with extreme swappiness values such
>>> as 1 and 200, we may not fall back to the other type.
>>>
>>> To address these cases and preserve the behavior of the
>>> previous model before scan-budget-based reclaim, we would
>>> need to add another flag to `scan_control`. However, this
>>> may not be worthwhile for a debugfs interface that is likely
>>> to be rarely used, especially given that we already have
>>> memory-level and node-level proactive reclaim interfaces.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> Co-developed-by: Gaofei Lyu <lyugaofei@xiaomi.com>
>>> Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
>>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>>> ---
>>>    mm/vmscan.c | 219 +++++++++++++++++++++++++++++++++-------------------
>>>    1 file changed, 138 insertions(+), 81 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index f7fbe91fedf3..18cf1c084e78 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -4863,79 +4863,110 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>>>    	return tier - 1;
>>>    }
>>> -static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>>> +/*
>>> + * Balance the anon vs file scan budget using MGLRU's per-type refault
>>> + * rates, where swappiness is the relative IO cost of anon vs file (see
>>> + * Documentation/admin-guide/sysctl/vm.rst).
>>> + *
>>> + * On entry, nr[] holds the evictable size of each type, on return it
>>> + * holds each type's scan budget, bounded by its evictable size.
>>> + *
>>> + * LRU lock not needed: a stale snapshot merely skews the split for one pass,
>>> + * and MGLRU aging averages the fault rate so we can simply read it, no need
>>> + * to do any extra work here. If reclaim is blocked by unfair type hotness or
>>> + * stall aging, the priority will raise and a raised priority drives the
>>> + * aging.
>>> + *
>>> + * Calculation is basically based on following formula with a LRU size bias:
>>> + *
>>> + * anon : file = swappiness * r_file * w_anon :
>>> + *               (MAX_SWAPPINESS - swappiness) * r_anon * w_file
>>> + *
>>> + * r_file / r_anon: refault rate for file / anon.
>>> + * w_file / w_anon: LRU size weight of file / anon.
>>> + *
>>> + * We don't calculate the scan cost. MGLRU uses lazy promotion, which will
>>> + * cancel the scan budget naturally.
>>> + */
>>> +static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
>>> +		unsigned long total_scan, unsigned long nr[])
>>>    {
>>> -	struct ctrl_pos sp, pv;
>>> +	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>>> +	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
>>> +	u64 anon_scan, file_scan, total;
>>> +	u64 anon_weight, file_weight;
>>> +	int size_bias;
>>> -	if (swappiness <= MIN_SWAPPINESS + 1)
>>> -		return LRU_GEN_FILE;
>>> +	total = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
>>> +	if (!total)
>>> +		return;
>>> -	if (swappiness >= MAX_SWAPPINESS)
>>> -		return LRU_GEN_ANON;
>>> -	/*
>>> -	 * Compare the sum of all tiers of anon with that of file to determine
>>> -	 * which type to scan.
>>> -	 */
>>> -	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
>>> -		      swappiness, &sp);
>>> -	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
>>> -		      MAX_SWAPPINESS - swappiness, &pv);
>>> +	if (swappiness <= MIN_SWAPPINESS) {
>>> +		nr[LRU_GEN_ANON] = 0;
>>> +		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
>>> +		return;
>>> +	}
>>> -	return positive_ctrl_err(&sp, &pv);
>>> -}
>>> +	if (swappiness == SWAPPINESS_ANON_ONLY) {
>>> +		nr[LRU_GEN_FILE] = 0;
>>> +		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
>>> +		return;
>>> +	}
>>> -static inline bool is_single_type_reclaim(int swappiness)
>>> -{
>>> -	return swappiness == MIN_SWAPPINESS ||
>>> -	       swappiness == SWAPPINESS_ANON_ONLY;
>>> -}
>>> +	for (int type = LRU_GEN_ANON; type <= LRU_GEN_FILE; type++) {
>>> +		int hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
>>> +		/* start at MIN_LRU_BATCH to smooth the rate on gen start */
>>> +		u64 refaulted = MIN_LRU_BATCH, evicted = MIN_LRU_BATCH;
>>> -static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>> -			  struct scan_control *sc, int swappiness,
>>> -			  struct list_head *list, int *isolated,
>>> -			  int *isolate_type, int *isolate_scanned)
>>> -{
>>> -	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
>>> -	int type = get_type_to_scan(lruvec, swappiness);
>>> -	int total_scanned = 0, scanned, tier;
>>> -	bool tried = false;
>>> +		for (int tier = 0; tier < MAX_NR_TIERS; tier++) {
>>> +			refaulted += READ_ONCE(lrugen->avg_refaulted[type][tier]);
>>> +			refaulted += atomic_long_read(&lrugen->refaulted[hist][type][tier]);
>>> -retry:
>>> -	tier = get_tier_idx(lruvec, type);
>>> -	scanned = scan_folios(nr_to_scan, lruvec, sc,
>>> -			      type, tier, list, isolated);
>>> +			evicted += READ_ONCE(lrugen->avg_total[type][tier]);
>>> +			evicted += atomic_long_read(&lrugen->evicted[hist][type][tier]);
>>> +		}
>>> -	total_scanned += scanned;
>>> -	if (*isolated) {
>>> -		*isolate_type = type;
>>> -		*isolate_scanned = scanned;
>>> -		return total_scanned;
>>> +		/*
>>> +		 * The rate scaled by 4096 to survive integer division, clamped
>>> +		 * to [1, 4096] (~0% - 100%), the floor of 1 keeps a type that
>>> +		 * never refaults from zeroing out the other type's share.
>>> +		 */
>>> +		refault_rate[type] = mul_u64_u64_div_u64(refaulted, 4096, evicted);
>>> +		refault_rate[type] = clamp_t(u64, refault_rate[type], 1, 4096);
>>>    	}
>>>    	/*
>>> -	 * We are running out of the current reclaim type. Fall back to
>>> -	 * the other type if allowed.
>>> +	 * The more extreme the swappiness, the wider the IO cost gap between
>>> +	 * anon and file, so the split should follow the IO cost ratio rather
>>> +	 * than the sizes. With a mild swappiness, balance the scan by the
>>> +	 * actual LRU size more.
>>>    	 */
>>> -	if (!scanned && !tried && type_fallback_allowed) {
>>> -		type = !type;
>>> -		tried = true;
>>> -		type_fallback_allowed = false;
>>> -		goto retry;
>>> -	}
>>
>> Hi Kairui, Barry,
>>
>> A question about the size weight:
>>
>>> +	size_bias = max(1, min(swappiness, MAX_SWAPPINESS - swappiness));
>>> +	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
>>> +	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
>>> +
>>
>> In the classic LRU, get_scan_count() weights each type by its own size
>> only.
> 
> Hi Ridong
> 
>>
>> Here each weight also includes the other type's size / size_bias. So
>> around swappiness 100 the split follows the sizes like the classic LRU,
>> but near swappiness 1 or 199 the sizes cancel out and the split follows
>> swappiness only.
>>
>> For example, anon 3G, file 100M, same refault rate, anon share of the
>> scan budget:
>>
>> 	  swappiness   classic   this patch
>> 		 100         97%        96%
>> 		  10         62%        28%
>> 		   1         13%       0.5%
>>
>> Having two behaviors in one formula is a bit confusing. What is the
>> reason for this blending, and is there data behind it? Would weighting
>> each type only by its own size, like get_scan_count(), work as well?
> 
> Your numbers are right, but get_scan_count() isn't just balancing by size:
> swappiness goes through calculate_pressure_balance(), and the cost there is
> refault IO plus rotation cost, size turns that pressure into a page count.
> 
> With w = own size we'd match your classic column exactly, the bias is the
> only difference. And the bias is there on purpose: 0 and 201 are single-type
> and never reach the formula, while 1/200 are their counterparts, which is what
> get_type_to_scan() used to hard-code. If the user asks for an extreme setting
> then we respect it, and 15/16 and 16/16 make those ends exact. And this also
> matches the other parts:
> 
> We don't use classic's cost accounting here. The rotation part is gone
> with lazy promotion: a young folio stays in its gen instead of being rotated,
> so the budget is bounded by the evictable size automatically. And the refault
> part is already kept per type and tier by MGLRU PID, and aging averages it
> so we can read it locklessly, a stale snapshot only skews one pass.
> 
> So that's the whole model, it is a bit different but works well.
> Barry posted a lot of test data through v1 to v9, the swappiness sweeps
> (1/60/100/150/200, with per-type pgscan and refault) show the balance moving
> as described, including the ends.
> 
> There could be some pitfall with PID's ineffective protection for
> high swappiness so with high swappiness you may observe a worse
> refault after this, however it is not caused by this, same problem
> exists for file heavy workloads, and will be solved with MGLRU-FG.

Thanks for the explanation, that makes sense.

-- 
Best regards
Ridong


