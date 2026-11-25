Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57476606A68F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=O3hLtJHG
Received: by kanga.kvack.org (Postfix)
	id 74D186B09FF; Wed, 25 Nov 2026 07:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7264F6B0A00; Wed, 25 Nov 2026 07:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662F86B0A01; Wed, 25 Nov 2026 07:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 409456B09FF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:54:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B409C80E94
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:54:10 +0000 (UTC)
X-FDA: 85473634260.06.F8DE9F8
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id A92E620007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:54:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O3hLtJHG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611249;
	b=dGoZLOTAK0agfVym3aB0okd5freUaiIiMYZ9YVida/YKC7i99VfmGGyoTv5TCqe+TgGeE6
	YLpUko1diiLpJSkwGn62I4h3n814h375iMtaGBJIxgxh59i1tytchdbw8f3gQMSg/OxzOP
	PAaPt0feZCw65bnhpLarMszXUlMGb+Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18hmBrQfpJAG5UTxwsqwNFDo+XibBBB6MlXV+5uOdH0=;
	b=5qvFp/rsAtd7xwjaoiVw2f07j7vEzRQvTrjsfFpiw9IE7rGRDYfjrNKbbZDnqkqpKoT6/9
	pqoUT4JQt/izCixewRMuB9AfY5o5lchVaSeOIFer3pD3+okFCsJozYX6l/vRwsQP0yzpX3
	DlVFtfbm3gHxzplSnI3leUJaZLB7SPg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O3hLtJHG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ovCyAeWyuFaTW58PgPzA1TUj7418UnVnjzM69URWLP8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795611243; v=1; x=1796216043;
 b=O3hLtJHGi4tR56GOBETUH7a4U9tLEMegC6iA0RoNnZOiVkU+MFNVAF8S9CjBdlIRTq32LRPi
 nWHOTMNtyWlNkUQCyqoC4bbzvNXTVM426zUzZcSDQMVaJ9+WSxRSfdX787HG00plUrtWYGCQZ2X
 LeCirW55f8grwqA/Sb94kxUs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f98bec9bc042860a;
	Wed, 25 Nov 2026 12:54:02 +0000
X-Mizu-Trace-ID: f98bec9bc042860a
X-Migadu-Flow: FLOW_OUT
Message-ID: <13af506e-fa83-4c35-8467-a07a26e1fa02@linux.dev>
Date: Wed, 25 Nov 2026 20:53:47 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/16] mm/mglru: Run aging when one type is drained
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
 <20261114200803.23129-12-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-12-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nwma9znyze43gf7i1ygd6pbqadjdzf69
X-Rspamd-Queue-Id: A92E620007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795611247-427701
X-HE-Meta: U2FsdGVkX1/avQOz9rUw+nhc4BhVNuExbh8YgNslTZW1V2itKrJvKoN/l/0eEWsueecYzJpRiF5Q/n7yQN0aDcQOIIJl5bsZPsL+oUz3OnqAJ0bY21aQdXajZNKCHtjpAmqwRrqLp+CZomwssrB/PKlV1b8bWpZV+v9JQm0BpvqQFbIiTiBIDOyFT5vrzis6UCp55pJ+ms38LWDz5YF5bbMlJ3tZIOQ2ZWw8YH7Qqj7Sjdf/FESv3PI0y79myskLe/0j3j5xCR2A3u5PbcfYFJFreRTK19yQylT/Et2YxOF8S5PLI+HDhjvMw/hv8JSD6+ViK9QY+2vLEGZ8OJ28WDUzt1of+pejat9PYaB+SGKBUEtW8XNwdrrW103QELueXNMCGs6ITGvOyrIpvk6vsNvK/ljf2bWj7mgL7ROpzeqTQeYiNKmo7lA/xtifXOR2+pD4jJ/rTxW1ppcv0R8dugncQPBzspL0kwYxlec8uzzKEGzeRO9AIItCLbu7Hxuud1yhpQmlx8b+w2EqjUE1ONDrSsLNB4v0iZw48JJLEB59n+EeYVqUNA9L8dc9nfrR0mRRTKEIwFmN0haBWeHolbeSOkEhuVB/dblbGrsLLmG8VOvf2OMvzCbug2WZIZX5i7JbDUnu3TY7ZVMsNOD6FebBPnqcQPvld5Uew+NX0CTKxoDKu1vF5D7VFTBU9hLzH0kogP919A/2PJx9KI8QU9v8+I3yzR9SE4yXEFvZp77XKg2SXFhqCCRfEUp5+yItS9PA8O4LM3mAEqGNP1rM5h+hx3iW080js4JZAb2MLN2pl7ATuqxsR3rRjQczWyipLnvcO1Nw2Ps6iNlxh5IPw5JpeHVLlRSPrTL0PVs+kR5AryU0jqTl2HaIDkVuCtRtN+UqcpubbR6pMz/nyOrch/oUU7BgEKYiOJfBFYHvapIV4S4FS5hM4erxQ4xUT6MObe4k1Aw9eMoTLXA3zyB
 sT3UxFGO
 7KjVoBHqx8r+bLH3ypi7a50WFIqHUbGarrd6AcOHE4+vgvMYgAKqOd1AqU5lJopwPvXs3fzVUinGqJfcVbRU82RQiuQYmTHrXjI7jt0v1rammcGZNQ40RlYr1kbPPL7ybRkEjbdA0hP6HXlWNcFf9BcOfShJ/Pk5nF1BIXicxp00F7i67ZigHxHe6TloMvliV031VLI6FmwHmEvjKUp++erYN5jMXHsJFMesMXu/th15XNVmf02fTSewtzz21x0WfojEdrFlo8CG6tEIlQzogvJKXQzvFh45AL3tOTRPAKwUjfU5sfJ2gQpgbsRsdtBYbIVp+g4K67RFEBFquvUFlbmEfn4EQtvItEWUAxlXIuVqrB002nwpVWh/LRfLK8b1FlQLK+xcriYijAIXrmBlQyxgtbt6SOMKAq3aWSGvvE/m+9gzrHYp0YPSDhOTWV6wTJEaudS74lpz3Vn2rcVNOOVF78eoX549c9UgRwpmnaflUw58wSiZdjlI6FG0GsVz1U3V1nOMOY/DAGBqiBn9vaMoIi7xxI5enFC62sPotoQgAJe2XtyaCKPyAWi0cWQzo9Vs1BmR+DMmf/Yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
> We may have remaining scan budget for anon or file but no folios
> in populatable generations to scan. In this case, `scan_folios()`
> may repeatedly scan that type without making progress, even when
> the other type still has populatable folios.
> 
> Run aging when a type is drained to make more folios available for
> reclaim. This also helps honor the scan budget distribution
> determined by swappiness.
> 
> Move aging after eviction to detect a lack of scan progress and
> avoid unnecessary aging when eviction can still make progress.
> 
> To avoid excessive aging, allow drained aging only once per
> `try_to_shrink_lruvec()` invocation. Also skip drained aging if
> another reclaimer has advanced `max_seq` during eviction.
> 
> At extreme swappiness values such as 1 and 200, reclaim initially
> focuses on the preferred type. Rely on imbalanced aging once
> `sc->priority` reaches `DEF_PRIORITY / 2`, rather than triggering
> drained aging for the unpreferred type. This avoids unnecessary
> aging and has shown better performance in testing.
> 
> If `evict_folio_lists()` returns zero, retry eviction once if
> `max_seq` has advanced since the aging decision.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 49 +++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 37 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1450542d709c..6d942f192e63 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5175,7 +5175,8 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>   }
>   
>   static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
> -			     struct scan_control *sc, int swappiness, unsigned long max_batch)
> +			     struct scan_control *sc, int swappiness,
> +			     unsigned long max_batch, bool *drained)
>   {
>   	int type;
>   	unsigned long batch, scanned, total_scanned = 0;
> @@ -5191,6 +5192,8 @@ static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
>   		batch = min(nr_to_scan[type], max_batch);
>   		scanned = evict_folios(batch, lruvec, sc, type, swappiness);
>   
> +		if (drained && !scanned)
> +			*drained = true;
>   		nr_to_scan[type] -= min(nr_to_scan[type], scanned);
>   		total_scanned += scanned;
>   	}
> @@ -5206,9 +5209,15 @@ static long evict_folio_lists(unsigned long nr_to_scan[], struct lruvec *lruvec,
>   static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   {
>   	unsigned long nr[ANON_AND_FILE];
> -	bool need_rotate = false, should_age = false;
> +	bool need_rotate = false, should_age = false, retried = false;
>   	int swappiness = get_swappiness(lruvec, sc);
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> +	/*
> +	 * Avoid aging the lagging, unpreferred type at extreme swappiness;
> +	 * rely on imbalanced aging once priority reaches AGING_PRIORITY
> +	 */
> +	bool allow_drained_age = sc->priority < DEF_PRIORITY &&
> +		swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS;
>   
>   	/*
>   	 * Proactive reclaim initiated by userspace for anonymous memory only.
> @@ -5226,22 +5235,17 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
>   
>   	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
> +		bool drained = false, do_drained_age;
>   		DEFINE_MAX_SEQ(lruvec);
> +		unsigned long new_seq;
> +		long scanned;
>   
>   		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
>   			need_rotate = true;
>   			break;
>   		}
>   
> -		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> -			trace_mm_mglru_aging(lruvec, sc, swappiness);
> -			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> -				need_rotate = true;
> -			should_age = true;
> -		}
> -
> -		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
> -			break;
> +		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH, &drained);
>   
>   		if (should_abort_scan(lruvec, sc))
>   			break;
> @@ -5253,6 +5257,27 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   		if (root_reclaim(sc) && should_age)
>   			break;
>   
> +		/*
> +		 * Allow drained aging only once per invocation and skip it if
> +		 * max_seq advanced concurrently during eviction
> +		 */
> +		new_seq = READ_ONCE(lruvec->lrugen.max_seq);
> +		do_drained_age = drained && allow_drained_age && max_seq == new_seq;
> +		allow_drained_age &= !do_drained_age;
> +		if (do_drained_age || should_run_aging(lruvec, new_seq, sc, swappiness)) {
> +			trace_mm_mglru_aging(lruvec, sc, swappiness);
> +			if (try_to_inc_max_seq(lruvec, new_seq, swappiness, false))
> +				need_rotate = true;
> +			should_age = true;
> +		}
> +
> +		if (!scanned) {
> +			/* Retry once if aging advanced max_seq */
> +			if (retried || new_seq == READ_ONCE(lruvec->lrugen.max_seq))
> +				break;
> +			retried = true;
> +		}
> +
>   		cond_resched();
>   	}
>   
> @@ -5885,7 +5910,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
>   		lru_gen_balance_scan(lruvec, swappiness,
>   				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
>   
> -		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
> +		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH, NULL))
>   			return 0;
>   
>   		cond_resched();

The logic looks correct to me, but try_to_shrink_lruvec() now carries
quite a few temporaries (need_rotate, should_age, retried,
allow_drained_age, drained, do_drained_age, new_seq), and it took me a
while to follow how the drained aging, the regular aging and the
retry interact. Not a blocker for this series, but it might be worth a
follow-up to move the aging decision into a helper, so the loop only
scans, ages and checks for exit.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


