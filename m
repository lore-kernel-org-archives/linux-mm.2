Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD681C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57B96B007B; Fri,  7 Aug 2026 05:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C089B6B0088; Fri,  7 Aug 2026 05:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E1D6B008A; Fri,  7 Aug 2026 05:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87FCF6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:52:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85F7C1A029B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:52:33 +0000 (UTC)
X-FDA: 85074008586.15.5131F70
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id A47C540003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:52:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GMd/eMdQ";
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786096351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXDhYioTwAOUajrsTQB8n+o6j0Q1jbDcqbcrYXrO0QY=;
	b=l0ATY+8uLJapB098A1fRUbi1na7rv3TGyWKCAVpU3U9UWjx44Rj4fde3T1Nq/y4/JCE0X3
	OITI8TQIHsS0U8XYTiH8Yy8rAYyUMLpGKrtSZGlPfDQu/XpFKXy/L4QXJqqC0MzQXPsvwU
	rKkLjblXPYgm1CtDrY2i3Ocwf+LSTmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786096351;
	b=1NPAW6OfYuACew8qu445ycdrKE9kmxfslGky1gJicdJI3dzmGR1YBDMK4JyD1gmsjZcmf/
	SMMysYfecmxSeJ5/yezuUQOTq8WjuFWNHIr/ko257doaJfKZle2Mp/l8Qy97Q7+rpL5b3D
	nuhLQYAyNJN3FUEGrSGCShx5Gwer6Vg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GMd/eMdQ";
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 7 Aug 2026 17:52:20 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786096349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fXDhYioTwAOUajrsTQB8n+o6j0Q1jbDcqbcrYXrO0QY=;
	b=GMd/eMdQNlAHrlTtKAsrYqWIjkMNNrOBQjDFDON52EqRUIqZrUNU8SRBWv/ocgmciNiYAD
	vP5Qe1+ODXgwvb1a97Eb94bPGNMJ3tkTD5vC0X1KpBsNOZH2Hxi95ongXzCZCYpAYKnGMR
	xvkPTcYVKfUIS0NQOGSQwrRZfPvn89k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	her0gyugyu@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/swap: scan by cluster in find_next_to_unuse()
Message-ID: <anWq1NW8xsmR3O80@MiWiFi-R3L-srv>
References: <20260806193228.458685-1-youngjun.park@lge.com>
 <20260806193228.458685-3-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806193228.458685-3-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A47C540003
X-Rspam-User: 
X-Stat-Signature: xhx3ersj3z79np3pcnc34edes9761gt7
X-HE-Tag: 1786096351-386135
X-HE-Meta: U2FsdGVkX18MD4DG13hHgzTFldlA/PsYN490i+i+L/eiq1cF44gbeaJc1FSjNy2Zo3evwqHQhIRoflPp6RLpJxacQni+TsrJk6PiNMEOzxz1JZNJHdkC9i25xVU3epB/tuGKr+fnWh8C/xO7Ag2JBF9dvzcAqO+e4AbKtQLls8jrXATr6kcO/DPCLyn6j2IRL5EGWJq7c5pmn8EomNjhfEJFoJQZMY6Qrr4ME6FsYULD/MpdiGiVkKgMz1nhz0d1UXKitpSkNOLHXaGPQVhSk9X9LNlIP1ehzSJJPnbs0VPdxWx6Xel4jPHojJcFpowDcYmFmab1V9e+2R8heSi0wiE5GsFAsCZHIfP6E3eTyjTTxMHbAqqjrPHqanyVsZj1wf04yZ2kuNxAvEVVf82+/zcNqWNcQsx1GjYwHtHmjBt16IM0Ko0JAwRv2Rt2FVr7uyA5i9Qz8lVO6MccroWNqpmuD+kscJoZQyr373Oc4nmh2XpEJ9W6WM4Pbeec7G7Rn5bTODlJOzlOKMd1fygD/vjEN3JyQ4NxzhhBOTybxJpwcAM2Pb2sFB1Hm0hCmCdheK9KBLX9Af8uA7gDgGQjz9WWROOLYGeoXZp1RK/uysG2WWLM/y/O5cWJ5eD0fxdBrXbky114SvGRnKiB6vxSlhchBjkohx5YkSfM7duPCcFR0nmZCJRbpfK7PPHSGUV9MspYiLN811YGoapBDZ6jaEUrufPPOnUobVjcg4LCy1l5NpCE+B37qEnGAYmyL+XALaziB4MHslGEOxdI6xxLn2Ij4WVzFG/QkapeOK0bENpjz7nhfLzfkHsWpJ+XivgcbrujABru1ZjTRULdj8GRRanvb7Oa8QonHZ7kCf23RCgtn84EUHsB2QaVqwzDrKR9ISu3Ugq/h5MYRJbZk7kreqBW6jnUHbiP+12C1OOGTKgHCHQL0//y5PB6/t4uNIJLGMwUiVRuXAQ9k21K/DL
 IVpaU9oI
 uRXa15UDJoPtfL5p1iBUwbZjuCR5xZWV8ZTthvDM4fZGuYZBnYsIUJKRLpvy6wMb7oGJA5EtFqJmZQyw3DOk62dURA2pBX3Aaw+AfgbAUmecoeFwZ3Ex2+prXlgu+/fPIELOrrX/mjKOLJfIVwiIcy3sKH2yVSyuuAp4iy1MQjXIMN1cZA5HJYzt/RRHqmdOE/0ROO9a2j6eAWXDyCrNuFmGpPn28uv0u2XGqUrflIW9n75i3058SKk1vppAY5PI3oPacM1RjV+Sx2H+kzHC10EKFJ0G3P8HXK9toq8qlGNgKvtmTVUgaLuO1CZq5xYZreSkezEABjJDLTQmd+4vft5eUbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/26 at 04:32am, Youngjun Park wrote:
> find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
> restarts that walk on each retry, so the cost scales with the size of
> the device rather than with the few slots the shmem and mmlist passes
> could not free.  It has caused stalls before.
> 
> The flat walk predates the swap table.  Slot state now lives in a per
> cluster table, and wait_for_allocation() stops all allocation before
> try_to_unuse() runs, so a cluster that holds no slot in use stays that
> way.  Skip such a cluster instead of reading all of its entries.
> 
> Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
> answered those stalls with a cond_resched() every 256 offsets.  A walk
> bounded by one cluster no longer needs that counter.  The loop now runs
> at most SWAPFILE_CLUSTER times before it returns or reschedules, the
> same bound swap_reclaim_full_clusters() already scans between
> cond_resched() calls.
> 
> The scan end is clamped to si->max, so the walk stops there rather than
> running into the masked tail of the last cluster.
> 
> ci->count is read without ci->lock, so READ_ONCE() marks the read for
> KCSAN.  Allocation is already stopped, so the count can only drop, and a
> slot stops being counted only after its folio has left the swap cache.
> An empty cluster therefore holds nothing for try_to_unuse() to act on.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  mm/swapfile.c | 43 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index dea2d3b36e06..0d24efd32eb0 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -370,8 +370,6 @@ static void discard_swap_cluster(struct swap_info_struct *si,
>  	}
>  }
>  
> -#define LATENCY_LIMIT		256
> -
>  static inline bool cluster_is_empty(struct swap_cluster_info *info)
>  {
>  	return info->count == 0;
> @@ -2763,7 +2761,9 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
>  static unsigned int find_next_to_unuse(struct swap_info_struct *si,
>  					unsigned int prev)
>  {
> -	unsigned int i;
> +	struct swap_cluster_info *ci;
> +	unsigned long i, end;
> +	unsigned int ci_off;
>  	unsigned long swp_tb;
>  
>  	/*
> @@ -2772,19 +2772,36 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
>  	 * hits are okay, and sys_swapoff() has already prevented new
>  	 * allocations from this area (while holding swap_lock).
>  	 */
> -	for (i = prev + 1; i < si->max; i++) {
> -		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
> -					i % SWAPFILE_CLUSTER);
> -		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
> -			break;
> -		if ((i % LATENCY_LIMIT) == 0)
> +	i = prev + 1;
> +	while (i < si->max) {
> +		ci = __swap_offset_to_cluster(si, i);
> +		end = min_t(unsigned long,
> +			    ALIGN_DOWN(i, SWAPFILE_CLUSTER) + SWAPFILE_CLUSTER,
> +			    si->max);
> +
> +		/*
> +		 * An empty cluster has no slot in use, so skip it whole.
> +		 * A slot is uncounted only after its folio left the swap
> +		 * cache, so there is nothing here for try_to_unuse() to act on.
> +		 * Count only drops here, so a READ_ONCE() without ci->lock is
> +		 * enough, unlike in every other cluster_is_empty() caller.
> +		 */
> +		if (!READ_ONCE(ci->count)) {
> +			i = end;
>  			cond_resched();
> -	}
> +			continue;
> +		}
>  
> -	if (i == si->max)
> -		i = 0;
> +		ci_off = i % SWAPFILE_CLUSTER;
> +		for (; i < end; ci_off++, i++) {
> +			swp_tb = swap_table_get(ci, ci_off);
> +			if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
> +				return i;

I would remove ci_off to save one local variable, but it's only personal
preference, not strong opinion.

	for (; i < end; i++) {
	    swp_tb = swap_table_get(ci, i % SWAPFILE_CLUSTER);
	    ...
	}

Other than the nitpick, this is a great optimization patch.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>


> +		}
> +		cond_resched();
> +	}
>  
> -	return i;
> +	return 0;
>  }
>  
>  static int try_to_unuse(unsigned int type)
> -- 
> 2.48.1
> 
> 

