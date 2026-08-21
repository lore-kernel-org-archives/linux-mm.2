Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9132FC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79986B009B; Thu, 20 Aug 2026 21:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51BA6B009D; Thu, 20 Aug 2026 21:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940826B009F; Thu, 20 Aug 2026 21:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6685A6B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:45:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D7A7A1D2F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:45:01 +0000 (UTC)
X-FDA: 85123583202.08.5C97F1D
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	by imf18.hostedemail.com (Postfix) with ESMTP id 66E121C0002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:44:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=up7tUo4Y;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787276699;
	b=eefken7AtTAuhaHn4h0Lgie+0mQE8M3YBJLo1likiZuHqWoVeuO2f9TbHmO1Ow2OBvN7sL
	8hp0deWOdV/+Enh3jB/n5K+w1HGmhCIeAq1YzT9PC6B+I7RnVtrV/l8DTqP7gXB/yHlmnH
	25caQbosf7pPsnpdwho37KZnKxofJIA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=up7tUo4Y;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787276699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R29iz+PsKrJ4+9WEpi6D/5zazk0+9hCXN6GIjSipsoU=;
	b=G9WM4lCvCcRX/FkMiLKxRICvL4O+Mte8wo+VXKH6QQ7EScq0cbod6wvLk2+jJ6mmZucDK+
	xg7lrWsKp8ETaBTnrXLvJQV3HkUIYZXGcLz6mzhBJI0gcoSWxmuryQY42QOe5BtON62baI
	1PHO2KLHFKyYD5TuQ7MJ4+2C29PYdSs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0k5ukuEriWuoe7c2VoM3YZKYW2oeG0da9ih3CxjEuA0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787276697; v=1; x=1787881497;
 b=up7tUo4YgCUXj7FUDCBGWA8ED+06bcSO1wmDtDvyYyNEBXGdJuzq0CZDbv33vflSZjOMOo5G
 eHsi1nrG8uPh714S50l5Zi9ZEduQ9OW9ddHna1LmwpEoEQkGndfy1GeVAOUkXWoDOrrModW/v6P
 RZ65tVkZ4H26MzNqKUhPO4RQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 06a7fe33c891c8f4;
	Fri, 21 Aug 2026 01:44:57 +0000
X-Mizu-Trace-ID: 06a7fe33c891c8f4
X-Migadu-Flow: FLOW_OUT
Message-ID: <d81c3050-37d7-4448-b1da-cdeb0521665d@linux.dev>
Date: Fri, 21 Aug 2026 09:44:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/mglru: improve scan_folios() exhaustion detection
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com,
 linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com,
 mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com,
 yuanchu@google.com
References: <20260820045603.68809-1-baohua@kernel.org>
 <20260820045603.68809-3-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260820045603.68809-3-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 66E121C0002
X-Rspam-User: 
X-Stat-Signature: g1w44bcmfxb3xmieqi5izw6t7kmw7mw4
X-Rspamd-Server: rspam06
X-HE-Tag: 1787276699-698451
X-HE-Meta: U2FsdGVkX18pGGylAmT3uhn67LVaKZgGqpyDSkERHthwntwhfpas5/R2btRD0FVKEyr2c5zzE1IwmA9qgH2ydU0U8sNi0rIuGuQWiIFjbdOpwvImSajmBjPYrTkwMReHdJ7goIZedlN5vE3YUCxk7dy+7P/+nAvS+WGRXQUEFCI+sxXriGVfGO4y9x0FGhJHX6iIOtrEJdJASVqKX6Xj/GwKmbWbui06c//rMgly86+ahHxtPlgFrC/ptvmUvMWDpObnh8ahLvZi8lOpYR08xrH460THSPnKPEcdmTGqveZ1ucEXuCT/ENnRhKt788ANokyhyH6FJaxK9ACaPvbdiq0qd5gHyaFJov4RXW+uiRQXlZ5fXPDDKD99zGo//swJAPI6q8dMnmPqCDKCbrd2N0VvsoNod5q+/nEW75VgD+cFpTML1yhsB/mp5bpGoV7mJzSDlSRw1tnfYypQ27UpS9T/1lrJrhH45U/5+HeHraXxsiVfJoGvKqTJ775MX3CDbLm94HYq1PzV+duAiGyohw3kzUhYl0ZV9MAPC0FXYjyjWhIPGEziecNHbAIRtJlpEfDPdx2awK+WCwum967i+cgvckyZQ2LlkaCTjdTAguJvnu0L2hCKJvI0AglCYGOoRnkBf94PXcPSm4oZEr/1QwUyT1xlUKgjyAtUbKbEDch6gxpnO5rRBjZ0I8r8gnlfjlt6Lvfj09sUBlNRFVoq7EAkZXYb7ekTHlc3mTFJ1FI5HLZnCxdCWW5ByarQNHVX5tW2iNgOrVhSr7PgqDb9383GY2BTXcLg9vWIHr/6B0y4hOpVjhjQw8jp8sJ69w/gqAAYhB71KkdufaKgY+HjfIvdc8TXIfiJHBPIcgHNV+H2PyRhPStn5JtzkH9ZM2ec4kgL5PCF8/gJcE/3k8WuM0zk0imDRn8YiygM7Q+VShMWP82Jm5ScsRDPwgvzEYFGMakYMET400x4ozSVxzD
 weMFp+Bc
 dFmP+TKQBYOi9QDgdWRaoSmtLiT+/Fc9/Zzn9H3ECcgVJ9+mmKs+OieqCq8XhXA/9OQCzHOodzZxUB3iLtj4cIQJlxFebuu8yC2YdunUk2uwOqWY72dpc6H3WJnY0VEcRV9dGmCoDW3yYFor8K2Gkj/WKod+MVe154yOqoOj2Bt73E0xxZWSpCNuG2DoGf2hsdQM4CNY+gbidZv/avUL9vub431TMMbjmsV0sjw2EMTeUQEs7O8QtYIm28xS5kiXA8wUNnqQMYY7mDjjUZE5CIG8xHxNtfvYnxi2wk2k0VoUbXOdr5EkWPbDHbVskw+INXyx2Yv8q1LxEcHSpzsO0dBCHMZE33xnB6L45GiBB6OmJuoLdnLvg3e+zHBC/V9Yk0Sc9IUT63XP3Rn9YsDOy9k6LJoeLS9PuC/aUHOwBJ48r4VXCtCRF+E8bq39NpBBMmfGpQ0XheGtP2rE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/2026 12:56 PM, Barry Song (Xiaomi) wrote:
> Commit 16b475d2ac3c ("mm/mglru: avoid reclaim type fall back when
> isolation makes no progress") uses scanned == 0 to determine
> whether scan_folios() has exhausted a reclaim type. However,
> this is not always sufficient. It is possible for scanned > 0,
> while the oldest reclaimable generation is exhausted after the
> first scan_folios() call.
> 
> We detect early_stop in scan_folios(). If we stop early for any reason,
> it means the current reclaim type is not exhausted yet. If early_stop is
> never reached, it means we have exhausted the current oldest generation
> without hitting any scanning limit.
> 
> Another issue is that if the lruvec has 4 generations, we might have
> exhausted the oldest generation while the second oldest generation is
> still reclaimable. In that case, this type is not exhausted yet.
> 
> Add an exhausted output argument to scan_folios() so it can
> explicitly report whether the reclaimable lists for the current
> type have been exhausted.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 28 ++++++++++++++++++++++------
>   1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d5cc30b667ad..1f2e574b0061 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4721,7 +4721,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>   
>   static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		       struct scan_control *sc, int type, int tier,
> -		       struct list_head *list, int *isolatedp)
> +		       struct list_head *list, int *isolatedp,
> +		       bool *exhausted)
>   {
>   	int i;
>   	int gen;
> @@ -4732,12 +4733,15 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	int skipped = 0;
>   	unsigned long remaining = nr_to_scan;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +	bool early_stop = false;
>   
>   	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>   	VM_WARN_ON_ONCE(!list_empty(list));
>   
> -	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
> +	if (get_nr_gens(lruvec, type) == MIN_NR_GENS) {
> +		*exhausted = true;
>   		return 0;
> +	}
>   
>   	gen = lru_gen_from_seq(lrugen->min_seq[type]);
>   
> @@ -4768,8 +4772,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   				skipped_zone += delta;
>   			}
>   
> -			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH)
> +			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH) {
> +				early_stop = true;
>   				break;
> +			}
>   		}
>   
>   		if (skipped_zone) {
> @@ -4778,8 +4784,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			skipped += skipped_zone;
>   		}
>   
> -		if (!remaining || isolated >= MIN_LRU_BATCH)
> +		if (!remaining || isolated >= MIN_LRU_BATCH) {
> +			early_stop = true;
>   			break;
> +		}
>   	}
>   
>   	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
> @@ -4790,6 +4798,13 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   				scanned, skipped, isolated,
>   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>   
> +	/*
> +	 * If we didn't stop early, all reclaimable folios in the current
> +	 * generation have been scanned. We are exhausted if this is the last
> +	 * reclaimable generation.
> +	 */
> +	*exhausted = !early_stop &&
> +		     lrugen->min_seq[type] + MIN_NR_GENS == lrugen->max_seq;
>   	*isolatedp = isolated;
>   	return scanned;
>   }
> @@ -4847,11 +4862,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
>   	int type = get_type_to_scan(lruvec, swappiness);
>   	int total_scanned = 0, scanned, tier;
> +	bool exhausted;
>   
>   retry:
>   	tier = get_tier_idx(lruvec, type);
>   	scanned = scan_folios(nr_to_scan, lruvec, sc,
> -			      type, tier, list, isolated);
> +			      type, tier, list, isolated, &exhausted);
>   
>   	total_scanned += scanned;
>   	if (*isolated) {
> @@ -4864,7 +4880,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	 * We are running out of the current reclaim type. Fall back to
>   	 * the other type if allowed.
>   	 */
> -	if (!scanned && type_fallback_allowed) {
> +	if (exhausted && type_fallback_allowed) {
>   		type = !type;
>   		type_fallback_allowed = false;
>   		goto retry;

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong


