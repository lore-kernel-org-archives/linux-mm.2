Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA88FC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D975F6B0092; Wed, 19 Aug 2026 06:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6ED36B0098; Wed, 19 Aug 2026 06:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CACC16B009E; Wed, 19 Aug 2026 06:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A41226B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:16:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16C7F804BE
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:16:26 +0000 (UTC)
X-FDA: 85117614372.20.5339621
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F0A140004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:16:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HerHLKK5;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787134584;
	b=cVw3rquuZkpq8iVrn/9BHzAMpxrsBHHCaHXIm1wrjCT672/eL2JukM550mzIhwMO0G6gUG
	DffNc/lLu4sP0KfUYcbNh275eihZ74pGJqz/x9GetiqM9x4x9glRk8bYovPaYKNmspyX8u
	OzxybPtz53wBY7K6+nqjGalCjB2c2h8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HerHLKK5;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787134584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmnuBxXNb1Zq0BPUmnkR8geAaVLu/w9JNxhhZ3lWKTI=;
	b=RuZ+c2Eibef+c8X7FIDMfkoH0/S/A5VVBJoii04Ot1qrjdurwECd0qu76p1paHEGkyOXus
	WgnNR+DZLCm+7W2/yXaLwaDwUyBd4MExbxAll/m+WL2lwqdaYr1LsHfQzJbwlCIin7SzbQ
	RStBLMNo6QWuPUVz9NHVSMmqtTefZVQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lrdTAluOUYWs62O0PpRF6nh/ALgtREIgbj5lfiADRdg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787134581; v=1; x=1787739381;
 b=HerHLKK5iA7jemF1t+gQ978L4Z6+gpvBPttI933WycTGV7uSciIYX4Iguw7qtWWuJOy/K6J2
 ZGE/Us7iRZjIX5CMzKVygkdn5mFDUBvYGE8AvC97sAuj0VzWTss9FuZm/bOeO/m9+upUaHau3TC
 Zi+I5n85Jw0OVzN2QNaB2i8Y=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 572f4396708aeda8;
	Wed, 19 Aug 2026 10:16:21 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 19 Aug 2026 18:16:13 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
Message-ID: <aoWCbV6J7xsiZrTw@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
X-Rspamd-Queue-Id: 8F0A140004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: g3tnbdkqcodgisdj4c467mcggfcnsk9u
X-HE-Tag: 1787134582-381493
X-HE-Meta: U2FsdGVkX19+gZGh3YJAPcYKZMUATiq59iUYmo8ghKIBRJ5yCHaJ7L4haIsecqxka5F6eQDQkD+YrWxIuCIHaVKtrd+rJ7y255EG/ETms+Zq3lHxsRQ18rCGL1QQyxbhpspfo6FG6lRndJYzUBWD8Aa/MpP178AnWew2WZT5sXlJbpKHRx+xO4/zI1ZBALA+zMZyUwlfp8ecKuOTR+FgpUSoUQ3k0I4vx5VyFkcVY+HymJ/5DfGVqHjS3ycAk/DPDR7q9wD3e96O3fEaqn8T4UL3ax0W6LHozMBcSG/yUeCyBY5rWY2AHcN/fzxXhD5IJiVJU2xhHtyvd9hrAZXtA/4w9cSJkCjz7I5e4Jh7LKGmYlNgQguI7O23DTfQDco7WZK8OQ+jVEbKK7awnvN59Z7uq4Q5pVDSrc/gIhGE2uiRLb3rpOXn/dssraMlfQFOrpe8gnZtOIpEzUKo+EKyOjxDjNUnNCBJ797kHO3qaK981rWoyCu5FLW7YSZ+NFRj891cmo1xR2Yj0alR8/hvjy9NUfSOS50BsRoKlWMlY/PM7OU9xqBjWKOFEFY7soDymv23iEkuFAL4zWal86gREWmS6xt0XP9QhAdFBA5brF9GPjQS8budOYmmOojzm/W4ysrnJM63re1xDWtiKKVSY21AwUTbw6e7L9TT3aVUkFqjplLS4Ebnlec+RWa5suFJ6u1MHrMCtyapzBimFBDS8rV8yyCxWRBznGLLujEqVgR3OrQqFMs7CqhuWxhhCjJ1E5QNXKr06h9f+3eKhM/F0kAOad9JE143IN8QaFqXQ23nOGEQhIJeH+xV+7Ale3qU8cmwKG6yC8GoKl9e7dEFVbGSt2Zy7uzIGzinL5Idp1AZObkrhforuwlXwZTRq/P9XrP/OZSc40oi2seC7SPcC5GyXA4kHyRqQ9kljWSOU9oE2Ym/+TuDLCi2KiFn8Mcsfw+hdZisoziwi2C7U0O
 ivJly5GA
 R0QYN6roTfh+UxuZKiRDtiajvLTPvoIH9ZZDg9Lpf0zQNEOC4VWKh7dryOgIFx9mlTuShyjJMlDajRQox0lwFFNzk6RQeTxRCMbXx5YoIlPdaF4WMBqQX8iqfLeB6D/0nCT1WfYiOsHAHHZU6OLMTWpdiQuCKEmXW4Cvn3YCp/63JJsQ0Rbo67M2zZjDc5fu/yAkSV5FyChjsT78Y0OYLmCV59hYqQuNb501elC3/Qz3bCuxvQfDye4DAZJ2Amc5KbkPEvMc2nADkbtG5/k5WNWff10xTRG7qUyRSyK8MeWf0DQZ5lMyQHw7C0Ch+Z0afUCzwJE7a8jzvOf9HOCVMdbicawz0KmloK13YkT/O+yF4WAE6fUPsS+mVSPpJ7Pz+GhFL7Cj5lCaCgz9ce9hyI6BGDhBa7vYA+WTJI6Ko5i+BQ5GzgdzW2PAMDMITLneWR6ariyP2RlyJ/Nu3q800G1n0ZBaI6QVRHTvPDZo6RcAxZrOW4DWhL51A8LqHjlT9As/sJ8xXNSCc+93xZLw60LkK+J3FO6ZqXJZ0qrbxj7s2TqLolj6QcCsbYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> read_ctrl_pos() encodes the tier range in a single "tier" parameter
> via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> as the end. This is hard to follow, maintain, or extend. Tier values
> 0..3 select a single tier, while tier == MAX_NR_TIERS selects the
> full range.
> 
> Replace it with explicit (tier_min, tier_max) parameters using a
> closed [tier_min, tier_max] interval, and add LRU_TIER_MIN and
> LRU_TIER_MAX for the tier bounds. The call sites now become
> self-documenting:
> 
>   - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
>                     (tier, tier) for each subsequent tier
>   - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range
> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mmzone.h |  2 ++
>  mm/vmscan.c            | 18 ++++++++++--------
>  2 files changed, 12 insertions(+), 8 deletions(-)

To be honest, I like the old version better. The complexity is
encapsulated inside the function, and tier_idx can reflect if it's
operating on a specific tier or the whole tier. Anyway, this is also
good:

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 32d9354a754f..d0b5c6217d25 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -492,6 +492,8 @@ enum lruvec_flags {
>   * folio->flags, masked by LRU_REFS_MASK.
>   */
>  #define MAX_NR_TIERS		4U
> +#define LRU_TIER_MIN		0U
> +#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
>  
>  #ifndef __GENERATING_BOUNDS_H
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a819be6b7ae9..a613bb8d7271 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3198,8 +3198,8 @@ struct ctrl_pos {
>  	int gain;
>  };
>  
> -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
> -			  struct ctrl_pos *pos)
> +static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> +			  int tier_max, int gain, struct ctrl_pos *pos)
>  {
>  	int i;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> @@ -3208,7 +3208,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
>  	pos->gain = gain;
>  	pos->refaulted = pos->total = 0;
>  
> -	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
> +	for (i = tier_min; i <= tier_max; i++) {
>  		pos->refaulted += lrugen->avg_refaulted[type][i] +
>  				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
>  		pos->total += lrugen->avg_total[type][i] +
> @@ -4804,9 +4804,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>  	 * This value is chosen because any other tier would have at least twice
>  	 * as many refaults as the first tier.
>  	 */
> -	read_ctrl_pos(lruvec, type, 0, 2, &sp);
> -	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
> -		read_ctrl_pos(lruvec, type, tier, 3, &pv);
> +	read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
> +	for (tier = LRU_TIER_MIN + 1; tier <= LRU_TIER_MAX; tier++) {
> +		read_ctrl_pos(lruvec, type, tier, tier, 3, &pv);
>  		if (!positive_ctrl_err(&sp, &pv))
>  			break;
>  	}
> @@ -4827,8 +4827,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  	 * Compare the sum of all tiers of anon with that of file to determine
>  	 * which type to scan.
>  	 */
> -	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
> -	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
> +	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
> +		      swappiness, &sp);
> +	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
> +		      MAX_SWAPPINESS - swappiness, &pv);
>  
>  	return positive_ctrl_err(&sp, &pv);
>  }
> 
> -- 
> 2.55.0
> 
> 

