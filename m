Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322CAFA1FC7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2B16B0088; Wed, 22 Apr 2026 11:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5535D6B008A; Wed, 22 Apr 2026 11:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468D76B008C; Wed, 22 Apr 2026 11:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34BB26B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:47:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B493B89791
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:47:18 +0000 (UTC)
X-FDA: 84686620956.08.4C178FF
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 924811C0016
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:47:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KUlydVeN;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776872836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgv+a25H/FpWU/HbGzAT+b07NIf/XnGJt4/r5qF/r1A=;
	b=FTRYgNjBOxhg1Q4h1hgHVydprfMyN54hD11RxWIFbdmTwRtZWoQ4rt3pPxS+stsqvIwqAf
	LMUryOd3E1I8++HBVuAM29UF7Zs+StKHYBGPAMw3Mgy+S661pVD88zm/lJxDIMtRyo0f3j
	SS+0w6xhO6aWdk/NVDwRbQa4fL6/dNA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KUlydVeN;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776872836; a=rsa-sha256;
	cv=none;
	b=bcWBG0UR/de0qAI+OCcYbT4yonHoYxG8TFgoqRg+1hIBcwqwypxDhW18mkek6ir03axNMY
	pWkG2Y7EY9wAo/mwqZ/q0WVa4GnxzFMi3MPXi+hq6uUNmR/kLuRGhLEaJWq/R5xvitKRat
	JyIzFnC8Powd75yLFh/lceCm1jAH9Xo=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cbc593a67aso506344385a.2
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1776872835; x=1777477635; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lgv+a25H/FpWU/HbGzAT+b07NIf/XnGJt4/r5qF/r1A=;
        b=KUlydVeNhTonTK/t3KxsO+qgELTpbu6x2jo2RtzxC5oxL6V4l2efBbVGWmucvgkd+p
         ECamm50H/BELz12SiOvg5EMun0SPphbRlNHpXKlDniKPi0NMqlp0Blw/0SWXq2An4wFO
         NMwVx1yzjQmHz9Y0/6RsV1nVtlPR42nAlQr02wYVERCbiNz/8oqs1yoAfsxjc3KEbxSe
         R6igc/F0QUyBTCYo3kgZoe1hT8AosN/1K/AS/qYRgK2OBPNMNs9qlGIe5Yey48+e5ADT
         rKHPV6k641c+F3Wfu1ppEE69OENcFsAqB0t23rr9kWZvEf/Q29uM3X5jc9whKtCIK+af
         kC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776872835; x=1777477635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lgv+a25H/FpWU/HbGzAT+b07NIf/XnGJt4/r5qF/r1A=;
        b=aK1BNNWshwGdIpsYr7h+lfQqtR9je7AvGG7ybt5Q1UtEhwJe7IhJcu6pxaHyXs5RHC
         VEgeVf5xrKrGKStk4GC990epGIuu3UyynCM7EceCXAPXxkt9TlY7ZnGNWwLgzs+Ev5SS
         Z+92jtGLe7sWk9qO+V5pX38B3+bibaU+5HAN38iO4CgznjLrDsFADPGQ/mXtuDhG8PAT
         mZVh28+pwDgTSPWlW+oyVz95J8Yd/r/sNjOXnB+QD16HlLYnMKnXNr8nnmKiQgIqN7v3
         H8HowZ0tRIMhdPm7UN6WeT+gH16jhGm+p9cnX0PSJIFJCO+db9u0NHlbT4wQbjx0r6EW
         3FBA==
X-Forwarded-Encrypted: i=1; AFNElJ8A+tOABS4Rky4Ra7BGq1TvxDB62RF+/HzYgvcAkd14uSR+qrM9nHpNQth6KrEFDcxlwqTNnBN86g==@kvack.org
X-Gm-Message-State: AOJu0YwuIGcA3lraXj5aZCn0aA6MO7/eG3UhRq/r87nMY391gJ8t/w1G
	H5CKpkAUUD6CiUB7R+BLNnopi6jTtggeNOQXZOA97bimD6n8c3wSoWxlRs0NoJ/vHZg=
X-Gm-Gg: AeBDietK8ww1EPIUNfiel0m33Y+rbKg67e02KkZ5Z20PAu7GUaupZZL5i5v3vCNnick
	nuwUNGB0h75A5tG/q46U37tG6ft245kR2b0P8fbpPv6VwndePR3UZ1922TsXypOQVtxmXAydqOE
	fw5bvaUkJlGfCVFz9MTef26qK5IP98hGoR1aqlQKkbiD5dQJ2uEHCuEYH7Uf/X0gye5JsrG8BHS
	jM7xLarqBeXLVrVuPIJf0eV/7ey7Vct7GQL4i2RSPhryW2loMQSLLzh0ilUCA48v8yfcPe9rWvS
	HhH4V3vhTKqoCqG7dQ4fX5uLldyAsOXPAs5oRzKH/wHkx7gK43AIIFmQBxwroIIgkdZupW4naYo
	/biHhD4PN/KqJrNzTaensRjQI/NpquItSol9AGxbggEDuYrcOfpA/J8JKj7jJhY+EOzyGzZrEIg
	DcVqQ20r5J8EgZW7eapn7ueS3faIPo3CN4
X-Received: by 2002:a05:620a:9368:b0:8ec:a621:a3aa with SMTP id af79cd13be357-8eca6d8d612mr1395914485a.2.1776872835336;
        Wed, 22 Apr 2026 08:47:15 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae97347sm131144816d6.41.2026.04.22.08.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 08:47:14 -0700 (PDT)
Date: Wed, 22 Apr 2026 11:47:10 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wang Lian <wanglian@kylinos.cn>, Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [RFC PATCH v2] mm: Improve pgdat_balanced() to avoid
 over-reclamation for higher-order allocation
Message-ID: <aejtfpBUu7gNV6Tk@cmpxchg.org>
References: <20260422021842.78495-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422021842.78495-1-baohua@kernel.org>
X-Stat-Signature: sxzqaajphdwb6ezsrrhim6qxb4grx8zb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 924811C0016
X-HE-Tag: 1776872836-185771
X-HE-Meta: U2FsdGVkX18KzG4jDmGFl3WNWRtgegvullQrEtBPBLO3yrCV3hVhssktzW8FIUuR+EhGKNPURxAOCG7ot9qDP2SmapsLCDMJf0NF7Jc8lbz3r3HT/Vj6E8UOwt3XCvl46bIYzi1mXkZEhOAGjiV0zVLiD/vUMLjras59KcIezc9JBUQ87PrsV1FV5Lw0BiFIgYmB7Q9NOemUrsG4d3cTKdtltX8UMr6gIz30G/c46R9TFglBQEqF+UlcFEGIEoylvbZTEuW3Cw/Dcs0J9Yz8uefh/4urr8OwfImnXz91uDy6ryByIyuLuyeOx6H8IxNZkREec4AuBCVqKK1Ob+xVIa9EizY3GFJJ6rcBq1CF3Cg7pTxcPNstVQ9KZk9Kie5fJgXP27NzNlMjT0dT1t+ndOepOcOerX9usnJTxQ5FN+pr7/kZiF/XXHzrQY5srQb+2WLbrIPpuHZjJKlS0+FgOcdlHqFUkEuZJvFu23XCDE3dDCuZhnSO6Kt/66rKPw0zKthUcmUPa10mt2OWm6jvfCw87v4EXBDzvCOt+P0xbXiRubdHvAYRSLH/+9alEIEkeBpgieJmxB/yBLGEAZA8Mx91G2DcfUkPpRPgBt37Pnp3St+BWBnfZPszGvR3VvlBAoPOz/EywBFtIdFUqNyuETVQF78BBYjtmpnoaAL4idObDgBAoqV+CR25KyMZ3+iEuQDgrRb/fUTszjfHzo9kfEigDCZVNuvEQhb5gF3LP+/1tOuBZplClDpWS2Lb4dO4h3ggbz34kVBh4AveDWFXmvBFTWW35Ybos9FajLuKHYkgiReyIglEhtfTzD1fChjrpLpmj2E0RJjLE1yMhEdchO/f3p/0AVKKNcrBL57DTLncIKumAiVkS2s9hTXnWm/HsjA/YH9gudTuudZsUoPmOYK1ovfW0M0Vdyjgyod9lY/MYjdyTgZRdhDxUhi9QwZK4xBrXOp16g0sBsDsZbv
 MA+8JIKH
 wiATZH92TNOy87Ty5cXvAYjr4dxWP1mbSGBkb/1ZtQFfsFH6eS9nQKB2pajjau7rPn2ukcaWUoSspESBsvTlSydLMoCJUdUGza6dsOcylo6c+ONh0dUvHJxXX9TI8PjbNZf2PzLzD3YMRdRf7G1C3w8jushMPRsASAPPg0y3r4cXtgrv6IOOd95+cFR1hPm2yllF0RbFb8aHSpogrNnuEGjYl2+RMklQ8k7Kehn/6Dfg8NJRJcBUWbK1ulK8/DgWQBcnjPvJpP0+nTSTapDoNVBjKjliuqRsFpaT5TINzSGoHi+HSpm+ML7Djpythph34yozF3s8ZNPd3YY7w+brPQlHYh3GxVOgtJM1sT5k9wL7kN/U0PjOOG7/WHPeFnx4QMd5/219MJZgrm8/WdK0O2WlwbCue/KNtPfEgouGi783G6IgrUIidJYpHwNzvTaxYDny6zKCvmBCGt14LpsPgLd0pMDlI9nNyLOtl0hVCCv0C8jenUAvFQLwpKYpzwgIRwlunw+w1XZyHOOcS8uspyammoBu6jrYZg/YHgjL3KplEL59iDJouIcrlH3kQnlMCu84LjyrysxQ6FK+sPMnZmPTlkXN2vO6dEf4CWUZoTOry8SE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On Wed, Apr 22, 2026 at 10:18:42AM +0800, Barry Song (Xiaomi) wrote:
> We may encounter cases where the system still has plenty of free
> memory, but cannot satisfy higher-order allocations. On phones, we
> have observed that bursty network transfers can cause devices to
> heat up. Baolin and Kairui have seen similar behavior on servers.
> 
> Currently, kswapd behaves as follows: when a higher-order allocation
> is issued with __GFP_KSWAPD_RECLAIM, pgdat_balanced() returns false
> because __zone_watermark_ok() fails if no suitable higher-order
> pages exist, even when free memory is well above the high watermark.
> As a result, kswapd_shrink_node() sets an excessively large
> sc->nr_to_reclaim and attempts aggressive reclamation:
> 
>  for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
>  	sc->nr_to_reclaim += max(high_wmark_pages(zone), SWAP_CLUSTER_MAX);
>  }
> 
> We have an opportunity to re-evaluate the balance by resetting
> sc->order to 0 after shrink_node() with the following code
> in kswapd_shrink_node():
>  /*
>   * Fragmentation may mean that the system cannot be rebalanced for
>   * high-order allocations. If twice the allocation size has been
>   * reclaimed then recheck watermarks only at order-0 to prevent
>   * excessive reclaim.
>   */
>  if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
>  	sc->order = 0;
> 
> But we have actually scanned and over-reclaimed far more than
> compact_gap(sc->order).

Do you have traces for how much it overshoots?

> If higher-order allocations continue, we may see persistently high
> kswapd CPU utilization coexisting with plenty of free memory in the
> system.
> 
> We may want to evaluate the situation earlier at the beginning.
> If there is plenty of free memory, we could avoid triggering
> reclamation with an excessively large sc->nr_to_reclaim value
> and instead prefer compaction.
> 
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Co-developed-by: Wang Lian <wanglian@kylinos.cn>
> Co-developed-by: Kunwu Chan <chentao@kylinos.cn>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  -RFC v1 was "mm: net: disable kswapd for high-order network
>   buffer allocation":
>  https://lore.kernel.org/linux-mm/20251013101636.69220-1-21cnbao@gmail.com/
> 
>  mm/vmscan.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..4f9668aa8eef 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6964,6 +6964,13 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		if (__zone_watermark_ok(zone, order, mark, highest_zoneidx,
>  					0, free_pages))
>  			return true;
> +		/*
> +		 * Free pages may be well above the watermark, but if
> +		 * higher-order pages are unavailable, kswapd may still
> +		 * trigger excessive reclamation.
> +		 */
> +		if (order && compaction_suitable(zone, order, mark, highest_zoneidx))
> +			return true;

I've tried this in the past, but it was regressing huge page requests
under memory pressure and with higher levels of concurrency:

https://lore.kernel.org/linux-mm/20250411182156.GE366747@cmpxchg.org/

The compaction gap is sized for a single allocation, but
kswapd/kcompactd are a shared resource for potentially hundreds or
thousands of incoming requests. So if there is high demand for
contiguous memory this isn't enough - kswapd gives up too early,
kcompactd efficiency drops, you get storms of direct
reclaim/compaction, and still poor allocation success rates. Continued
kswapd wakeups mean that there is ongoing unsatisfied demand. The
system has to keep moving forward.

That said, it's well possible that we're overshooting that progress
buffer due to running reclaim scans with a high order. It might be a
better idea to look into that?

