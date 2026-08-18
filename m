Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77DD8C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D2A6B0135; Mon, 17 Aug 2026 22:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E4F6B0137; Mon, 17 Aug 2026 22:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720976B0138; Mon, 17 Aug 2026 22:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0136B0135
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:52:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0D00C0A6E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:52:19 +0000 (UTC)
X-FDA: 85112866398.29.1E3A559
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	by imf08.hostedemail.com (Postfix) with ESMTP id DCF66160003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:52:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SpY6/shO";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787021538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJiH0ESi9xTkHt1Q5jRKh80eFTAjQdb7DvPeehsC1/I=;
	b=cCE5BR7oeqGgpYxEdltEJB97PKf4tCf5wVb4IJUoSztfoWJYv+l1EWgrQm5Q/MdTg/7wzy
	BMJ1pSfkYg8wLQECqvEw5+k6y8Q2B491/xgSh2LWRDw8M9S66g5wNkL9UnvbpJXOF1WYpG
	Wu9DCtOoHZyUM9lj0kFapbTN0eC3Y2Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SpY6/shO";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787021538;
	b=NA/UhHEII8urAMZ4xM7UW8YPTcp2tdvsGBgDb9zrGWeMUD8VTrXjyfXNSSj7pR1A7iA12x
	PGcuA3yynC0wD+l63vaB1xA246+aLz7uCZ/lGcw1Jv5NGizSsAcCqZB2ZilNLUVCXIPxZc
	sdBs0oBk8Iw6tf8C4L4u34PZCINbDYY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+tjcYmM4+1lY/ufxesPT9Adlqs9FR04NAEFsPbm6s8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787021536; v=1; x=1787626336;
 b=SpY6/shOZ3utvqYsXQXYPFvHPOv51bEh6uJjaMySYjay6u1j3+cknzXzsrfUlK0/x6Q0DSa9
 9oYN+U75Mi8SLfb8gwmt7wzcMC6UJrT9cJXVP2e6JPatAoSTZ2MjkBeWuKTouvo+xhnCwp4IYAH
 ItZnps/mpdDhpqu4/H6ItHkA=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 9923006abc1b77f9;
	Tue, 18 Aug 2026 02:52:06 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 10:52:02 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 06/15] mm/mglru: use explicit tier range in
 read_ctrl_pos()
Message-ID: <aoPI0hlFe1uOPeFO@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
X-Stat-Signature: 6afk8g5z7nktgmqyg6mhtithxq7qthxy
X-Rspamd-Queue-Id: DCF66160003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787021537-78760
X-HE-Meta: U2FsdGVkX1832k/Bo1P0tywzquz05c5+7sAtxOf0Tk0vPtTINhpCHwD12Kw9GaFnGvA0tGlyb+gBT8yT8D+9nLH/ojIiS8lNk53IGb+7QoK3Y+qgKY0pgJq4saFC2YDLECZEs7VdMXc5dXTwoQUaKgB1sZBsnAjMhUowB7EC2Ejh8J/ehxajI2+apBie+7bJgSGN9MYjzPjmj3l5/+va0fJjX4Swqa6/w5fK7AfYXe8KXlwFBMtOenDIT+8Fdu0q0P4F27puTkChdzc2EV5tTgJN0HRExZWtXlYPHxxECluwblTFMzd3a4xOiRb/BsyvPdbjkV7eYdPrqUxIrX8/GrIMpc6Jh+BTlDAFnCi0nGHoZMbvmUcGB7xGkOD2iyeBWyPO7VTGe1yQZJNNH01cHFXit350mpxD10MZjFJH80T1YEA3WquaC/G5TRNY8KDnMbrg6yKC84Rs7slJWQgJEP3PeNz6rIyV5k52ozjt6z1h2diERkJfAf2kySSPj8TMBMwWSkdroDvXrIanOy9oWK3fRGQhO6qkUHU3TNpn3lQegwgZsvYQjhJz8TbrKJWmtz4NZKZAAxEXOUGlu91yGwnGl+2aLdO7up9JgOio2wYzxwYj6WEk4s0YOsKaaAQSOSefUEhLTAFqU3Pemyqro481n7G2CZActe7xIIIEZQ2R3L4M6H7Orp/3pZ0+7lF7SWk+IWXyjmJ9baEQ4N2TYt3JONzIYXMYEFE/4IQHU82SvJxYIXbG+Mlz7B4cwY+sfGChspID+BeJ3pPXNZahbXu+ccxWV5JdftTMWSM/iMGrhC5wefYB/GvoR5r2RnIWA8Tz1xI3qJGz96qtvTPoxhhRvppMiDuzb0sd9bFMORJ/iPDRszSW5oEcU5R+rXp+oBO06oeobmtcyNv6pyYoybOB2SgSCXs70Z0mF7qKopKm3ejlj/m4vgnpGP4kVwnTX1D8mYJ81NhRdoL3Krk
 DnKHLCBi
 dAuR+16VpI/PMmMBSck0s1sbuiaYowf4C/qKM7MjnUr1mf4cOk/kppoUhqG6rWRZYecWsgxnnHFnCQ6NpLw9YkOBzH4H5T7Ds+VjRHeEqH6YgV09mz0/HHrLJKMBt7BD45ZEf5J/6GTBYq+vSWBnGwB+KUpP+psBTSKHwEWl9bNbJME93oPn/1cwPlc6Vy9o/7ypnXp2HOLvvn4GMv2K642f96v3SO2n1aOoOHJeeY05OUFoRBpOWcLH7EdhmGCj29RNWyldITVzenXgzTkiJgJEY6sXgp5qEP/xVQhANXty1mVH1wtHTLiae89aCmXXY9v+bRTq+tDx4DS28X4bX9s84CTb8uqwvNa4XpUoU57jDcB3yCkEW7tv8S47EvKt8mDPwIqno2GGHJxENDoCGTaFeiqybERkdvvNA0/h3/pUySE6ZM+BkP3X71zCFal7poQ2XbUpCEhEF5CAqP3dC40y1oWJFH1mFNCjrG5eQpC2xYx8UvK8VPTUidBSXKdc52rvyzHWXGDevUdQdf8W9A8yD9FM/0DFS5ckO53GTf+2+vEXu0M/99uhSmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> read_ctrl_pos() encodes the tier range in a single "tier" parameter
> via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> as the end.  This is hard to follow or maintain or extend. Tier
> values 0..3 select a single tier, while tier == MAX_NR_TIERS selects
> the full range.
> 
> Replace it with explicit (tier_min, tier_max) parameters using a
> half-open [tier_min, tier_max) interval, which is the conventional C
> idiom.  The call sites become self-documenting:
> 
>   - get_tier_idx:   (0, 1) for tier 0, (tier, tier+1) for each tier
>   - get_type_to_scan: (0, MAX_NR_TIERS) for the full range

I agree with the complexity, while I am starting to like the original
style once I understand it. Maybe add sentences to explain it?

Anyway, leave this to other reviewers.

> 
> No functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c2ea92c2b69e..a359d5a1ff41 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3192,8 +3192,8 @@ struct ctrl_pos {
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
> @@ -3202,7 +3202,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
>  	pos->gain = gain;
>  	pos->refaulted = pos->total = 0;
>  
> -	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
> +	for (i = tier_min; i < tier_max; i++) {
>  		pos->refaulted += lrugen->avg_refaulted[type][i] +
>  				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
>  		pos->total += lrugen->avg_total[type][i] +
> @@ -4805,9 +4805,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>  	 * This value is chosen because any other tier would have at least twice
>  	 * as many refaults as the first tier.
>  	 */
> -	read_ctrl_pos(lruvec, type, 0, 2, &sp);
> +	read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);
>  	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
> -		read_ctrl_pos(lruvec, type, tier, 3, &pv);
> +		read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
>  		if (!positive_ctrl_err(&sp, &pv))
>  			break;
>  	}
> @@ -4828,8 +4828,8 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  	 * Compare the sum of all tiers of anon with that of file to determine
>  	 * which type to scan.
>  	 */
> -	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
> -	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
> +	read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, MAX_NR_TIERS, swappiness, &sp);
> +	read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
>  
>  	return positive_ctrl_err(&sp, &pv);
>  }
> 
> -- 
> 2.55.0
> 
> 

