Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B34C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 02:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41056B0095; Wed, 19 Aug 2026 22:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF24A6B0098; Wed, 19 Aug 2026 22:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0736B009B; Wed, 19 Aug 2026 22:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83B206B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:34:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E29A640683
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:34:09 +0000 (UTC)
X-FDA: 85120078218.21.F62FAA3
Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB79E180006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:34:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHHiEc8H;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787193248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3FKgchKl2iciqSP4OsYCPnns9g5mnxmSgxwvJ2ehNw=;
	b=fmcShdGyu3VafFaPQ+7m4uF37DNFHqE2cOwiJ0B+hK81JLlVTvOJK/Xt90MPD/NTajap8l
	6NlEOpSV2M4rBYFkyjzXAskCfyIfqvASHP54zIb1Rchdsm4BelrjvWSnJzLRbuZ//M5w3B
	1oEu4/21QFNtRTdQSvTSb7n+0zm0VP0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHHiEc8H;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787193248;
	b=hQFfuBMP0dFZ05k7qrZjr6Apos6htIp0FSxU/rBa07+FHYmg182ssJTM3fglfDDv1EMMUK
	4bZY3NOjaY0aa5EIG1Y6lWro3xikP8TJG3AludkZAJsV/XwRtn59VFwtojrhozTG82Tacc
	P6ikfj9vFZafijVAwM5oXzc7OBZ9GO0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qdXHzSUxwpmaJcAXVJWX7kAdVmjNRVDzrI8Mlpevpb0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787193246; v=1; x=1787798046;
 b=vHHiEc8HsE50g1TTA1asajPx26yxXY/nbXpv8H2ik6HSUvsiwtrFk91GSTyVgLa6q6tSIyF8
 n22njOo0tEO+JoLbCTUVc2Pmp6qD910sQhhyRsyN+JNG05kuDQuHER78gxPWB2WbD713yt7tN3J
 gBiVxdqkgdZ997h2DOEN8st4=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 86ad4c34bd5dfc6f;
	Thu, 20 Aug 2026 02:34:05 +0000
X-Mizu-Trace-ID: 86ad4c34bd5dfc6f
X-Migadu-Flow: FLOW_OUT
Message-ID: <959366ca-4a7d-40db-8f56-0a35580dd971@linux.dev>
Date: Thu, 20 Aug 2026 10:33:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
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
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sod7pew59hu1m7sh5qwr91jp3p79xzfm
X-Rspamd-Queue-Id: BB79E180006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787193247-954613
X-HE-Meta: U2FsdGVkX1+JxfQ0tdMw0mW3TpZXbYIUHZ3PHv2ykZFVMEMz0ouN3c3Ueco0DQYkycLIxAAAPab4f8DNmTGWRXguFPmZaM6/pnt24OfwEnlQZTsbOcuTxi4CkTpHMB1xo/CGbdjFWfzOg9mNZJg62+tfsk9+2Mk5v0xsKZZAomRgza6Kv1+wmi22iZFK2xD+sEErPVVmsyMB2+O9XhPQwK2EphjNQyWkFea2sfMpFJvxL3C/w4tE4p+mNFbevBWgbRCBD0dh8u+wd3/udSkorDuDVYSbdcBAFqFEm3WXos5jdu2tcSCwTrXuX6+2Z4MLSDyU3s25P1hq5csSVNdxUHXj/KbstIZQIwOrEBO5iUNUekH4LzUxCZeShMr55OZuxEc8ombiKzVQ6+FPWzxRtQperSuPBL1i/Evkk+uXj3i7HK8aXt983yxgCIA9F59CbSRDDMdYdAlzQ+TzS0l7dEXTZETnJ4Kq1eDOO57BcAErR6yNMKOEir1Qa6ubk3yRJAbrmLZ5XIcSqUr1xgx1Od65SHSB3VjQTH1lEIaIigRG/kUX3/cNlfGrMuH3pRATte5A9aNEWcKJD8pUIUedgRJuiySHGLkVhWal87s93Y5EwShVd4x6RgDH4NVx3ldsj6P2PXkcPeRWOeya3/p7TZ2aYctMlx0/PseA7AEy+HjcNFkWFSrt30eSrnvFkKkFKi/oy4tlMMJbrtKpDGlJAt+7oyXOmOuqtcu5SlxoY6roxyk4iX3+l9C2Oca3iwJqXJEcicSZtwaiUD/Ai1FTlb8hi0cEHcb9CP1EMORkPxvoRGU2Mnq53s3jrknbUt7GuW5Gm5G8It9vxGfihBskrp192t7516XZpJGRZbPpouxJjSRGwZUtljVHpfO3dGhf4OKUf6BG90geVrP6L3Z8mJNmh7gtqqsTUd3ywD+zxL7+tyoHDWoexpQUs+dx5z4uYx1TsyNw1WpzooGf3Td
 1zmAhYet
 ZcykrZBRwXdD2akAXCkXhHLiwrBcz2O8a43qeadANfcoR9qMMrt9N3Fml18RoKgQDFfeOFZ30Wtu3GS3iLZeF+avR24+ct4cXwKQbyRIMfQH7ArCQEgea996ld+3HiLp6N8TQDTNilzFns7NZD4VaqeDixWMKbPP4NHr5jBj9X5V0WiNEKyLIOC4b49+pvRhf5dV3ACyk8lcE1O4geBIElEHBZ1Yjj5a9FOblg5lrEe4V4Zy9r2imnn5D1bnNZrmC5G/6qIdlzB75oDpAwzj78LhmoB+vhi4a/FH9G8hYQFmca3km1uGvFUbtGPcs1bWaB4UmzqBSbw/LOb875o17KQLoPL5412DJd3aohROeN5vAFdWiHMfK9y2tdaLvgZOA85/E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
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

Just like LRU_GEN_MAX and MAX_NR_GENS issue.
Why do we have to add LRU_TIER_MAX, can we just use [tier_min, MAX_NR_TIERS)?


> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mmzone.h |  2 ++
>   mm/vmscan.c            | 18 ++++++++++--------
>   2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 32d9354a754f..d0b5c6217d25 100644
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
> index a819be6b7ae9..a613bb8d7271 100644
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
> @@ -4804,9 +4804,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
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
> @@ -4827,8 +4827,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
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

-- 
Best regards
Ridong


