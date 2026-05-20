Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C2A7CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46ABB6B0005; Wed, 20 May 2026 03:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B826B0088; Wed, 20 May 2026 03:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358886B0092; Wed, 20 May 2026 03:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2707E6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:25:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC5E989038
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:25:43 +0000 (UTC)
X-FDA: 84786963366.15.82FC0FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F10B7160009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:25:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XemDWMXv;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779261942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDyqx151XYnh6CsWtMJuKL4bIM/vvrXsshPFIbTLDeE=;
	b=Fxj2zuG2jEz/26aBXuoVRY1KdkJSQ6Gf9fxTgaXL1IUYfqdvqxqhcM2tmIo158Bzmb8Dl2
	y4ONVZGk7cGw/aOqd2QPMifr2+M14/dnkiMaFq+Cg28SJ1ctcMHMZnXlAM6cp0wdWZeHkK
	bSq/Ot3PaA9ITYcICB77MjJKN22Y9i4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XemDWMXv;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779261942; a=rsa-sha256;
	cv=none;
	b=l39R47xQVON2gvNASXSF9G89NPDYR7QaLrR/jPolt4PzS0GuWZRqY/uPQqRHxRmvUd8MWZ
	Nzbjxug+HIQeca65hr8CMYNJ5qgawGsHy+97tzWh9mhrX9Lm3PohE/jq6ygh8LS3sIUNHb
	0GrBEEVBzQj4rA/NdIcDcNxJJQceqKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2798740810;
	Wed, 20 May 2026 07:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837541F00893;
	Wed, 20 May 2026 07:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779261941;
	bh=tDyqx151XYnh6CsWtMJuKL4bIM/vvrXsshPFIbTLDeE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XemDWMXvAe0034jVFdHdnVxPz48ky+mESd2t2m7ebd9U8QHmdqkl914Mz7ddp5Qsm
	 bvdR6/Mh/QiRiFJ/kFM9mGAOz+ePgDbunbAoG6pLWDxURzAirzkWTFpho8Rf/K50Mw
	 KPjSqE4Xff7pmcJpEbEja/NxKmfTTz9H5SrqiYcjXuES/NmUIl71FYc01SeSKLQYIr
	 mRJBK1HJjdcuWA/RhdGQieC3sBxFp1IhrYkAlLFimJykGgnujVpBjcPFPhJ10Ec4z8
	 5oqVrGmdqnc/13c9zehqWH9A/9KUh2KXWs0FXYzRD0JBBk4hhpR/XxXh0eRwJDruip
	 VzKXa5e06RF0Q==
Message-ID: <dd058c86-35b7-4b95-a8ab-cb2f28237b6c@kernel.org>
Date: Wed, 20 May 2026 16:25:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] memcg: int16_t for cached slab stats
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-4-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260520053123.2709959-4-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F10B7160009
X-Rspamd-Server: rspam06
X-Stat-Signature: cxbxz3hdcmueczxnb44tqsiup3xiyxnh
X-HE-Tag: 1779261941-61981
X-HE-Meta: U2FsdGVkX1/7O3X7+ly+zFCt5bC3So1jP6xXQzXfWqjOlugKHcqOF2OJepnKR/B7K7vTjuw8HDAj/bxtE3SY95i0OzrIFxeVByVSzdnkkTl2lgnuiBRokKqK37jS18IAfr6Ogt6TgkawIUamGtLigGPkU3W1Vea8CFZL/BQD/js7LJusK8/y7WRV7DAtL4dMsMJ6+AYznkJQ/B5ACN/RJJRYugQ+WhkUtFnHaL2HHstE6nWiQi2qLvO/qepz1mjEKtpGMbmVLTaqDamk2SH6qrMUyhOMMfdu7J1PFARcqCgoGxRlEVdnRQpS1nvYy9YZwh6Znlz7S7U9OfHPrwKNiLQsjnPFcayjDYhHQS0G9SfsBB+vR5zNt32MtMcrYTy4kmhQdhR2m3h8eq5GUAttXR4hiBUSWKO29tQAQs/nRXn/g+e0FrsV+MFLG8PBmOhiSU4h+u9UDQDO4zEaJFYojtlcFiLnN3P/fQN3AHStAizmXRYN3Q0GDHy2dzlmx7u7fWv69won6HnnqJd/X8x9tAxcEMPG6i+543pGHPn9tTtscKOgKFqL2dmsYw2I4t7//f2OkteCNOyBdmfBWM/eAuqHeEbGeLvZvjQPK2B2e8uooc8ogoJZ+cFuT/UqEMJ4po9mulElf4EiP8w57FPEQqKZa3gRNPf/As1MuK1m5Q0Q+LRrDm0c7RbT2GnnnloBwOjPBO2Hrv91s/x4gterjNEgZN/8VPFxvzs3zCLPJkyK2E4VMhHulk19oKdAufvSPeIu4T9fMhvZ8J24891Tv821C7iG9VkE8xZs5suNjiUqzmIIgqDYs21uVWuG0raco2tJY7/QhBNRoPCUi4qSify5HptjIx5MWEFO1yulfZoJLmRYDVxbF2Xdg7TT5gQko29ILOqutSJv9Hv1o/lCwxNUKXZ93DJ1W7bf6C2JaYiZkP/u4zwN0heG3zlxz5n24eyMaWCLuMIH6+zJTl3
 97BXul/o
 Qb4tk2sfVIfAy3XYI471mkkXtwO5IYzsY0vH/l4jtOEP7RPTvU3gg2s/FiWr9I5kNgCUSQq+i51VTBWAAXX5wU5dONFgkVtL8YzTWjIZuuqUHPQj1IaT1rr08xNKzlM0Vhaplk9TEGUVVqwHKqBdcHPT6DTuvscfqpLO3pI2MTaRTcmqVdkejWnzS2UFVmfwPgoUVzt+h2+zBNMHLD/lXgNppo5pW1bRwbswHr2o9lpO8eKSIk4wfMKGRa4Oxc2g9Cag5Owr1Q2HaCILy6s57k4Lp8sGekCHjmWt/Z9Ed+9x95FW7DrYrXps5Po9tjdpL8rNHQsIiJY6RdA64/TrNkgQfUnnrrNVNmdDAt648+hDfNs5CTk1yN5JZyhHYGT6z+LSKBL6tpFAEWoEe2rrkJ3YlRWeMIUossBDlq7Cu+whF1SI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 2:31 PM, Shakeel Butt wrote:
> Currently struct obj_stock_pcp stores cached slab stats in 'int' which
> is 4 bytes per counter on 64-bit machines. Switch them to int16_t to
> shrink the cached metadata.
> 
> The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
> PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t. On 64KiB
> pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
> sufficiently long run of accumulations would overflow the cache. Add
> an explicit S16_MAX guard before each add: when the next add would
> push abs(*bytes) past S16_MAX, fold the cached value into @nr and
> flush directly via mod_objcg_mlstate() before the accumulation.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: kernel test robot <oliver.sang@intel.com>
> ---

So arches with 64KiB sizes won't benefit from

"Even for large object >= PAGE_SIZE, the vmstat data will still be 
cached locally at least once before pushing it out" case.

But its benefit is questionable (to me), might be ok.

>   mm/memcontrol.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b3d63d9f267c..1ed27fd06850 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3158,7 +3158,7 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
>   				struct obj_stock_pcp *stock, int nr,
>   				struct pglist_data *pgdat, enum node_stat_item idx)
>   {
> -	int *bytes;
> +	int16_t *bytes;
>   
>   	/*
>   	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
> @@ -3195,6 +3195,16 @@ static void __account_obj_stock(struct obj_cgroup *objcg,
>   
>   	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
>   					       : &stock->nr_slab_unreclaimable_b;
> +	/*
> +	 * To avoid overflow or underflow, flush directly if accumulating @nr
> +	 * would push the cached value past S16_MAX.
> +	 */
> +	if (abs(nr + *bytes) >= S16_MAX) {
nit: should be > S16_MAX?

> +		nr += *bytes;
> +		*bytes = 0;
> +		goto direct;
> +	}
> +
>   	/*
>   	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
>   	 * cached locally at least once before pushing it out.

FWIW:
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon


