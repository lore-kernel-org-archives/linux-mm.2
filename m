Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C468EC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 06:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0ADE6B0092; Mon, 24 Aug 2026 02:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB806B0096; Mon, 24 Aug 2026 02:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1D76B0099; Mon, 24 Aug 2026 02:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 938FC6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:47:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21D50A047B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:47:56 +0000 (UTC)
X-FDA: 85135232952.29.B65AE30
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5256B180003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:47:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vZTUFyFZ;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787554074;
	b=0FshAfRCZygSDNMW2LzrBLK+YdjRnpuDOKGugJPO+VcKu+hJMjP1Ai6I1xM/9oj7Zmyz9X
	ukcMy+N4od0+SQUMc92gnmKOHt0Yc5cFb+rmIYVgPczT7lIQL0ZNUdHsZKNat3hh+sHW8f
	yvAv1YHNSWbdyQB2CsWJEgcxujg3NoU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vZTUFyFZ;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787554074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GK/MIea32e4NUGMWanxCuajUxRGuMhSI8qj69sbXJ1U=;
	b=5ntLFztQN4m52gEyknV8OxH8dafxNae3G7rd1eiCfsKqD4OxYpNE8+vZqspC0VvjM2Eldt
	8ZWpVYE4IeAFZfRH2dRoIGsQAzty9hZ6sU0b+t+opvpn3SzWOnTZ7Dl9AgqyiEYrUYBceI
	FauRznh1Iu87oogsbICUOcaV2Pba80k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787554069; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=GK/MIea32e4NUGMWanxCuajUxRGuMhSI8qj69sbXJ1U=;
	b=vZTUFyFZQwgrcxU7k7MIP3l7irUMQwnKP7b9P30/o+JQpBr6baaMVIk5xmUCMHKdzdXO2pVWbmakTqqYrvuJHV05VLsXA9/yLkdBW9otjlKsICoDj30SWVrxiByZDjLgh/g8LwL2FSzaLuZFjbnzxbw/uERAQABEGoM3XXGMHx4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9U.yEG_1787554065;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9U.yEG_1787554065 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 24 Aug 2026 14:47:46 +0800
Message-ID: <5e0b17f1-a9db-4317-aa4f-924c6c767ee1@linux.alibaba.com>
Date: Mon, 24 Aug 2026 14:47:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/mglru: improve scan_folios() exhaustion detection
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com
References: <20260820045603.68809-1-baohua@kernel.org>
 <20260820045603.68809-3-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260820045603.68809-3-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5256B180003
X-Rspam-User: 
X-Stat-Signature: db6jm73wd6arxmtrorrao8dtkyfet5nj
X-Rspamd-Server: rspam06
X-HE-Tag: 1787554071-846026
X-HE-Meta: U2FsdGVkX18QyySur7wAvEK91E9t89N9b04dEMoz7fepHhFvnwwl2XSs6jCI/GXrVZf2yFEUy6nDW3RRTGW/qU7LmH+IoKtafoCJdGPiWDVkuMmp+VSljNBiyYtiOREgqV37mwU0bmELpvSaV6GaDKfn+5ccSAuycW2u5u1LlL6fPtuqsVTFDII6bGomEvcKUp2LbRKqXhnP4310we8Noi7owJ3O3gBBmn7Tzp5jv3yFqta5Zh1jHnjqNR0ciBmSG4HRwDZl7JfTMFdPCZlY9ugI/KHDHDOwrAcsV0KJ3Mp3gl+4SF1U+oG7qnVgAnrtpWYOMjl63Hh6mGnC5o3QBTtKweJIpeSzHVN1k1nG+g88teRcjeSfs8ypQOAVsGoN+amUeh291lhwSMqI9yAbmYR9GAVahuyQiZMo89RmbQBIdTPNcTCCj2FvKmrbwH3w5M5Yuq7AfiDIKWu4XwXI4R/nu7PGTbjEMszRqpna5ibVCItzJqq89VQEA1jKudWN/jtD7IpTkCgcPju8pmoJEaxUE//N3NV8xMpHUBtVQ5OJyBD9B805a3dyAHjQIdm5wjtQjsmHZvhIi7XGAdPSD2X9dLYsPFk5MQ+Vj5EqDAgEiXt8cf8nIBiNOe9GCg4SbI61AXW1BkITgwbDmPCQeMmiSK5T3XKLkQTYSVw9R8gwIpOQofi/4Rvx4V+vTfrhdG2lu72VF4E0h+T5LhhrR+xiUc/ge+8PBM01dhlC3EYAgZD5Oaoeea+oK4JLK/CqHpilHhQtnpOZLu01zpt9CTM25uiQajxWuArtt4lDpTRDnjmTyBAIaP+Ogv0jysiUXI7N1APGSxPr2C/5o3a0a12g9yRm7RgtxSdHarqv01Lk1MmprZK22bRvk/uuShkYwdzTnpBiYmAkrBIDDy1zzeHhk8ZEafrFtvPUs3d0YTT5r3InV8kF7RrhD8KQboWpqhpxlUNDt+J2KB+bFSH
 tH0Do6CM
 /b8udNieLjJMgNaAXZxZ0mPKXAw7if1/YUUShgYzWUQsvmDa6rjnSzZ1Kk/nwNdHw+JbFGPrSjyTK+JyiEvURQ8WPmkpmNCVvOxP6w2o33IGkfGgGX3O4eO7B+RXh/kkZzzmlZvIIJ9TISctDzsVQD4R3UqoNLFNSshHKcH+6XomrFRj3576lpb/F94B1rLZ15tM37uPN9RHbfn/WcAYAhrhHy2yAMgCaS9kMqAC4rqorx74dcDyKHZg8dSlav3C5nxhEleStrV5PxauUer2NDsovQebgbymq2sjyqtH/78d7J5orreeWn1C11h3T+9GSkffEVYT4wEhiETebQuzJHi8tsxHD29fQI2jB3Yw5E7qYqkZsBXJiECHClliFGeOurB9kKKdpdj/4QrSnBoB7w82WcO2pu5YM7OgEz/XUuLnRmddO8rVghLewnfm8cCwRctEZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
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

LGTM. One nit below.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

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

Nit: using get_nr_gens() looks more readable to me:

*exhausted = !early_stop && get_nr_gens(lruvec, type) == MIN_NR_GENS + 1;

