Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9F7C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 09:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136B46B0088; Sun, 30 Aug 2026 05:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0836B008A; Sun, 30 Aug 2026 05:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECACE6B008C; Sun, 30 Aug 2026 05:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C23BE6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:43:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC4CA1C18C5
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:43:32 +0000 (UTC)
X-FDA: 85157448264.02.DBE403A
Received: from mta1.migadu.com (out-217.mta1.migadu.com [95.215.58.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDA12180002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:43:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ii8B1GFX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.217 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788083011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXl/DiezIY9pkE9XHR+teQ0/Nb5jZrePrjuyWCMJkkQ=;
	b=FZTN8txKf64ofUIbjEPvsy6imbvfBXaegIPFNLmQs82EF3wrg+UrlaOqHfgfOHbedi2BD6
	/tncqfgHFoU1etWpD1rbxZLo1B/14cnWUjNJDz8iHENHeDA3VcJ9d5rNDIRNLlyXVecxv8
	Cx44UGeK77OeFUGUMBl+dp3DzJ9b8gw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ii8B1GFX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.217 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788083011;
	b=Q5UIMN5RpPm216oxTDNCRbro/CDvNygYokrc8jNnV0EVHLa6WsdBRzZdWqkhnrUnl9ociN
	Jix8nLbvmeQY6hHeJf1KACasYW6wvlCL384uBlyC5BmvyXFhJO9JbSODEKH90iZd5/4yoi
	ve0P0/2xLO6AZTqcP37Ss3Ti7TZ6KKk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WLzeZ4W+JrfRBuJ4IDHnEXj5Yo3WA5fDEH3jQpf5dZg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788083009; v=1; x=1788687809;
 b=ii8B1GFXIP4C97TtjNGFHcTISARp+DTjIZA8SS0lxTod4xH+CLkW8kpFqAXKP6HUglSKjt7M
 o/h2fdjf13ZZv0k2zlzN6AyzDVd54LdjtCI7BDFETHvCsurlxq8kMkLFe51APXMuztPNqkE6HIu
 O+cW510HbcdvqGZTCxK1ttFQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b5dc266f82cf0c4a;
	Sun, 30 Aug 2026 09:43:19 +0000
X-Mizu-Trace-ID: b5dc266f82cf0c4a
X-Migadu-Flow: FLOW_OUT
Message-ID: <d469a60a-3aaf-43d3-955a-238042115a3e@linux.dev>
Date: Sun, 30 Aug 2026 17:43:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm/mglru: use explicit tier range in
 read_ctrl_pos()
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: u75kaj5r8f4zysw49ea5s4us318mbf4f
X-Rspamd-Queue-Id: CDA12180002
X-HE-Tag: 1788083010-921547
X-HE-Meta: U2FsdGVkX1/KHcxa2RKlRA0e19mhi3Br6FhXavq5hL1a+uZKLFGtPGvFMYk39aRCFDyZCocOQH7xHfpV0Q0fLHYHLbI8gTlkKgPdT5QTa/vckwg+aJrjmmDnjesgJPtNHdSvRF0hSYY2rD7z/ZUFeT0w8rZWQH+hCj/br6mwewAK+wzcPxGrsb4xJK+GngdJ2wmox70gRwCTJH9C0SzZozQyL4821KOAGG1NPO3orBLlyIjT9q5OHLtJ/vFGLwHpL7dcKo1YacYoIIbXpXeq4ibXrEr2BbtnCy8DBvaFDhf7SHzOsjVLynBu925xn8Sn1WVeD27HHnd66qWrMTLjPdS/YeRt0abG47z07CNvZpU95aGnQCzc5s+OzICn+gCibYtwAh1xPcUIlhHAMW/wqqeJupVSl2mfPxzISHnVs2LeC/jhFU9os+/lMj7/A4eeF2NYLneqkP+iv7MC2r11wxMsqAVtJ0A1mVWDMNf/UubXfW3YciP5bMh1/HrNPWMQ9ABh9XsYyBnBhH7jvoo84kuxfcssKLrYYQwCX38UBXA9RYKNvx22HrHPpXklvThHWeeLBY1orLBf3mknNGLIxUd8qxehsmMW1ENZ+HCWGzzS0L97wiEhIIdb/5i4/23tG+i471YSB1+SNq474CmZ1KbWan+Ldnu5bsfOQlohgKoS/fgUysHiOLje5jJk/GjXvzGHdgBJRkGAQDuVrGTF4oepfpugMQlkH/X6tULqfPZkOJWjp4ChpYK2C7puz9N6Ndodn4X3BRQl23cv0nKoPEFEApFPHswK20QCo9ZNVbdkBUPkSv5Z1tJoo/C+AR1hthWmA4oXCNETpxdV/Y/meGT8QMJTN9+/xaE7o3ISxpeEDeWvf3v5ZGBRlCqY62CRRzXvlFkXwxrsQUsdm4urrGOotg6pGuOSUW8vNrIkhkH75oGlJJaZsvAEcaf+yMb959E+2jL5YwmZBes9QS5
 9/qpd+vt
 ylvOKu1BgxMYZVaNElg5cEkuXiGpJl8pXU8UIx4gO/lm7RNVES23Lkp1nbcaidd6MkwBBLvUEHQB5KDhrxtCXIIUxPi4m1aU01FPOYAVCB3txu8FLtq0nxJdksCuB1FfvBppJhWaD6FAVdICSf9PjbUo8NOPM1TsbLkK3Ox1Q6FjymknRly55nvSU02y3Z03eDNncI/nXx2TUfuScWmkBS6uQOjEasCUSxEp4WVxbW6YJtmuHCBPGy9kzFW8cHFJbhKhu9O9CdrOqlHCeX9rfqb/aOvvlytqMy/R6FU9Hr/wkB36oq1F//xAxjHR1OosVdFcqd2WTkviX2tjIRu9uMK9GGtowqxB7gLePsXITljGUN8psAZBe2eQEVTix7UdPQkG3/gqNnjxzS10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/2026 1:53 AM, Kairui Song via B4 Relay wrote:
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
>    - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
>                      (tier, tier) for each subsequent tier
>    - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range
> 
> No functional change.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mmzone.h |  2 ++
>   mm/vmscan.c            | 18 ++++++++++--------
>   2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c9ecf370cd9f..9b27cf53bdbc 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -492,6 +492,8 @@ enum lruvec_flags {
>    * folio->flags, masked by LRU_REFS_MASK.
>    */
>   #define MAX_NR_TIERS		4U
> +#define LRU_TIER_MIN		0U
> +#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
>   
>   #ifndef __GENERATING_BOUNDS_H
>   
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 52ef4c3705bd..cdc2e44875da 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3198,8 +3198,8 @@ struct ctrl_pos {
>   	int gain;
>   };
>   
> -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
> -			  struct ctrl_pos *pos)
> +static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> +			  int tier_max, int gain, struct ctrl_pos *pos)
>   {
>   	int i;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> @@ -3208,7 +3208,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
>   	pos->gain = gain;
>   	pos->refaulted = pos->total = 0;
>   
> -	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
> +	for (i = tier_min; i <= tier_max; i++) {
>   		pos->refaulted += lrugen->avg_refaulted[type][i] +
>   				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
>   		pos->total += lrugen->avg_total[type][i] +
> @@ -4809,9 +4809,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>   	 * This value is chosen because any other tier would have at least twice
>   	 * as many refaults as the first tier.
>   	 */
> -	read_ctrl_pos(lruvec, type, 0, 2, &sp);
> -	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
> -		read_ctrl_pos(lruvec, type, tier, 3, &pv);
> +	read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
> +	for (tier = LRU_TIER_MIN + 1; tier <= LRU_TIER_MAX; tier++) {
> +		read_ctrl_pos(lruvec, type, tier, tier, 3, &pv);
>   		if (!positive_ctrl_err(&sp, &pv))
>   			break;
>   	}
> @@ -4832,8 +4832,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>   	 * Compare the sum of all tiers of anon with that of file to determine
>   	 * which type to scan.
>   	 */
> -	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
> -	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
> +	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
> +		      swappiness, &sp);
> +	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
> +		      MAX_SWAPPINESS - swappiness, &pv);
>   
>   	return positive_ctrl_err(&sp, &pv);
>   }
> 
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.
-- 
Best regards
Ridong


