Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72E8606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vIGdM2HP
Received: by kanga.kvack.org (Postfix)
	id 8B9676B05B0; Mon, 16 Nov 2026 06:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A0D6B05B2; Mon, 16 Nov 2026 06:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7800A6B05B3; Mon, 16 Nov 2026 06:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59F0E6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:59:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4DDC4095D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:59:01 +0000 (UTC)
X-FDA: 85440836082.15.11ED2FA
Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7EF2D140005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:58:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vIGdM2HP;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794830340;
	b=uW0JkmiQoH59vlRc5PqBBSmsrCed/UBfp7J0BA54W4Jeg57jhKKaxmcLSooaaQP8hyPgsB
	JRZKL7/FNwB/682v26k1V54pIiXtiQiDqGo9ziQfFX5r4Wpq98fEDqtS6rqfjjfiFAzV6v
	nQ+Gi3ozg38F10+45jCWCmkBX7+Odqw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vIGdM2HP;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794830340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWVq0MgAQT8Gj3/maGoqBdOlfWXvORp1oF1E0uhrmv8=;
	b=ZJUQd2uHeXjUgfCNbCT5YCnJfjhgd7kNcwz510z65AO/Ffs2FywmySkzG8SSA4O5jTSI1P
	Bjoc00tCU0TQ7R+Pa3Q7DwQAa8x4UDTLPJ7pspl20Lj0KBN1ZHe7zew1M3GHSheefmDBVw
	esKLy0eSzigDiLvxevBPiFJzoM7ooS4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ly6e+I8kS/n5cbwSdAkWXpNs/8hJgpU5dlKHjyE+Pdk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794830337; v=1; x=1795435137;
 b=vIGdM2HPM2HqqMypxLwCmcglQ9A8eA7pGR7+hoQpDs4GQt7S77dgtb3cFLATMNUJ20ZjaMt8
 414jD3/i1ozlVGXPXixAGgpsNAUA38bJ2CcHK8o5UXoZaKWD/oF5cP0dRXhHaZhrZleIXd99Y7e
 y0qk4/gUXLgy+HWebzcVpFas=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 14d4939e5c5c90bb;
	Mon, 16 Nov 2026 11:58:57 +0000
X-Mizu-Trace-ID: 14d4939e5c5c90bb
X-Migadu-Flow: FLOW_OUT
Message-ID: <4d10c5e1-8805-40b5-8ea2-9fe62dbfc05a@linux.dev>
Date: Mon, 16 Nov 2026 19:58:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 02/16] mm/mglru: extract lruvec_populated_min_seq()
 helper
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
 <20261114200803.23129-3-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-3-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 43u3ohzmcxkz4wwzg3z8prak6dwonuwt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7EF2D140005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794830339-976611
X-HE-Meta: U2FsdGVkX19TrKmtbAmGN/bk3z7H52P42myG1fggzzmhswCp4t0kwSzkxgupguhNKxAKlKGVUGTTge6saVmZm/jq/6iJKYcrmp/rR5kpcUllzXvnX1VHlIOLnpMLqoOPwCTrPFb0pO9b9NcWuCO6upvniYtu+tlrNp6jH+vwPll3JwbDv89WeWEhcS05UIb1D6iqPYueZbNvPBEHmdyi+wLWUOMPNTRiT4IvJrABLIupnSV9qJbfb1cEYqlB8DtqU1upN9VdP/8vEjG7eqT8YOI1POhUnE4/zndpyEI5sMdf2rPKw02pGr+asaofk/keQEL02SfAg+R6GzDb9qVoja7agzzh09f37KEbwePwpxBdaUiWBmIuYAzXk9tLaSFaJuSeqC2WD/1sBrY9RzzENqousotm5tsIybqOnKo720eLMFpyVATM0PQXHW/njoz9WiMAl5KDbW2vR/uzgvD5fhAv2zY7FHo4zziwRVJNzxz6hpSLfhSsMW98GtCrf5yq5fJWe0e/fDFFkdeChlD8G8RfbA0Wfc4x0z1n2EhfIPjD62gH0n56b28mT8BPyXGx2uWu20LonV9KAhWurK4zYuzblQgpyx9wc3xeVBhfxTPXSnSmFSHTGFKCRiJNe6NDbYnC+xJlEioeWs44pUbGzVs9oiIqpXX354cDwRD+md23zhQl2LHzfYl8EfeCM5TkU/erhgOXnoSy3VWlb7yVpNav1uBVlwGmKC2l0Zw9316kb/y06Lzw7o62/H+YNSSuH4TNIZBXOXJmecQc51N9AOkbeJeETWa2zk7wGHBWP0Mn3JoD//Sw/bD0+Oz5wxTDgDGUQHWUyvlUTD8rK6Tg4ZK1KS0imWpd1kzF33oEVmMiCmCg10/7+MGpoZ1s4aXhYKkT42nwsDXEqJlSMHVmVjf2nGYDnRk8DGl3lDLHSIpcnRjSK8P/DpMi9njYQQwH7DHAuXUcuz9oDQztCwe
 C/zMxLtV
 czTaabipojNLIOp/0tf4ExurLtKx5lu3KYXJYokUn9c/40InMtHfDMnYHt0j1OBWEopmkSbauum+vfuGptTULFx26GVeuY7rDrRzwkyz41f2Ph4iz5wddU00I4WeziAyiSVcqJkyURVlpwmU9/5FrssnroWIC+z2JWp3wOZcGCYJaH7Qfnrg5Ev0F3QFvOCD3/jRgegss7p8GgekEUBlcsHMOfhYZYwLosK/N9j9vSuDysdfTvtqoiq5iQM91XPsBXiMXo9+7SOUkNZi5gmxhiKSqCGpj/nDXxAtBoemKwt2lDnVUCfdRWbHmPzKPea2y1QQw6NryoAriQXCmFtQQjm4P3EXk1+qWCAtSG6yiSAV30obSzOoRpZfTp7n78rv20hgho0SUYKuQYlLSQn2n1qkdC3c6GH5XE6Nl1vXTlFMJXQ7mTBFnevCbIc5R4PHEdGyGCJqSWDXugnWL76bLcHs+YA==
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
> The search for the oldest populated generation of a type, previously
> embedded in try_to_inc_min_seq(), is extracted into the new
> lruvec_populated_min_seq() helper. It returns the oldest populated seq
> of a given type, bounded by the given max_seq so the search never goes
> beyond it.
> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---
>   mm/vmscan.c | 45 +++++++++++++++++++++++++++++----------------
>   1 file changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 400f87fc51e1..ae3e13b1fb27 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3992,30 +3992,45 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   	return true;
>   }
>   
> +/* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
> +static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
> +					      unsigned long max_seq)
> +{
> +	int gen, zone;
> +	unsigned long min_seq;
> +	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +
> +	lockdep_assert_held(&lruvec->lru_lock);
> +
> +	min_seq = READ_ONCE(lrugen->min_seq[type]);
> +	while (min_seq < max_seq) {
> +		gen = lru_gen_from_seq(min_seq);
> +		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> +			if (!list_empty(&lrugen->folios[gen][type][zone]))
> +				return min_seq;
> +		}
> +		min_seq++;
> +	}
> +
> +	return max_seq;
> +}
> +
>   static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>   {
> -	int gen, type, zone;
> +	int type;
>   	bool seq_inc_flag = false;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   	DEFINE_MIN_SEQ(lruvec);
> +	unsigned long seq;
>   
>   	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
>   
> -	/* find the oldest populated generation */
> +	/* Requires at least MIN_NR_GENS gens for basic functionality */
> +	seq = lrugen->max_seq - MIN_NR_GENS;
>   	for_each_evictable_type(type, swappiness) {
> -		while (min_seq[type] + MIN_NR_GENS <= lrugen->max_seq) {
> -			gen = lru_gen_from_seq(min_seq[type]);
> -
> -			for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> -				if (!list_empty(&lrugen->folios[gen][type][zone]))
> -					goto next;
> -			}
> -
> -			min_seq[type]++;
> +		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
> +		if (min_seq[type] > lrugen->min_seq[type])
>   			seq_inc_flag = true;
> -		}
> -next:
> -		;
>   	}
>   
>   	/*
> @@ -4027,8 +4042,6 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
>   
>   	/* see the comment on lru_gen_folio */
>   	if (swappiness && swappiness <= MAX_SWAPPINESS) {
> -		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
> -
>   		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
>   			min_seq[LRU_GEN_ANON] = seq;
>   		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


