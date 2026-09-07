Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C47C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8189E6B00A0; Mon,  7 Sep 2026 06:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0066B00A1; Mon,  7 Sep 2026 06:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704D96B00A2; Mon,  7 Sep 2026 06:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 539C86B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:52:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA827140111
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:52:37 +0000 (UTC)
X-FDA: 85186652754.15.8B2B069
Received: from mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	by imf07.hostedemail.com (Postfix) with ESMTP id E439840009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:52:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FPmqLvNG;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMZIxO6CQ07igvYbrEPXnr0lkolqEoOTIlZqNcyzMSs=;
	b=nuV+iXfR5iSzKJy1gq3CCVmuK5ajZ55gX7xoASaO5UiYrokcaYrPGGEz6rol+Ch7JczodR
	oI88c/rJlMi7vu1wWqUwOSmty7hlHVdz29lnC87gbfO+DDWtUEpsGxOV1i8Hu3ChhDqPcz
	V92p3jMamaiJ1uDldYogq5GVUWI2Q6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778356;
	b=OwpSbDgIVWA3i8Qn07S2tiPO+clsCmhFgnjC2SWOA/91tI0W7DKRW5/lFddOfBQOyIO4pP
	kMFwO8wyf3vA8uPQC4h6aHCcLX6vsbweZSl0tPtgMY8Q3+wi2woCA/cmITKbhTsjgZo694
	YJsQ1cOwdNIMIPCKvgdM7Q5YISxDIw4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FPmqLvNG;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=veLSlCX5ITgmXND1QxVSP8GF9ucuQEFqR09oh1MjNvw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788778354; v=1; x=1789383154;
 b=FPmqLvNGSelN/rlCLIg1CFeJhLjvx/ZNnB1VtbTfOR1JatUfHPu91fAiwRam+L13YzIwllLp
 cSa9olUaOLstpW1uNAwVMAwzPu5/8kx5S3QcPK9ADFQzDf35mJfSZoft1m0Adep9ERkMPYXCU9F
 FB/A5gY31O10brAU9cAlSVEw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a4af63cff6f3130f;
	Mon, 07 Sep 2026 10:52:34 +0000
X-Mizu-Trace-ID: a4af63cff6f3130f
X-Migadu-Flow: FLOW_OUT
Message-ID: <eca414b4-9baf-4d2f-9842-373f5cc79d60@linux.dev>
Date: Mon, 7 Sep 2026 11:52:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
To: Qinyun Tan <qinyuntan@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Kairui Song <kasong@tencent.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
 <20260904033503.4067283-3-qinyuntan@linux.alibaba.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260904033503.4067283-3-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: giax34d4d51fkesps1wpi3gzp5t1ceq6
X-Rspamd-Queue-Id: E439840009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788778355-511587
X-HE-Meta: U2FsdGVkX1+zFcekw5bJRTq4lrURr1AV1ADBECxa7awBLET96GrgZoGpHiGqneHIN1qNmJ4IHOiuQ3OR5vCE/3iLauVw+EXnlm1FRil2ouYpQ4bQxxBlV3zKWYwN8O0yYd/mkyyUyqQR3jaFwfi765+3LMp0CVULWTekeR/fhWNkNKvadCSK2Lpdc8wZWtGl9qYYhjxyg8zsrZTKnaxeiBXqPBMZalF4wnwgV/yu8v40oUKx4TrvSfa7onn4gguZoyEcSAL2NZwE7ZcZIu5yfq9FWhSgZtWj5z1+jTlGJT3lhd6WZRwWYcHhRMBtZI/ioQCumSIRvRCyMRTqdIn7Tl2cqcEpCvUtUWzgCzTMx4QsBjr7vyN1iWiy0SKIY4CF8dtCTJ/mhPt9rn+fg/nDpkdh3iJ5/q2jZGRW6M8pJ2zeg/EXSh15GX4Uu0PGDVvdU1RuSWyBILxZfwnWCbtvMEv3Wjg95p7/rqxx2p5JaH/XBwV9NV/XV45cexDPX1YGQFevKGZdjhwDcAADK6qRDDmphPaU8w+8luDfLbD72Fe8dVGN+wE4knefgJ2AuyrmF8t237pZdSGLokvB8pU2l1lx0dqAm0umbHpWC/D/aDj0NTXvoLj4YxCERxLQPgZAe04afc6i6OGQo+mrw2i+Hrmk2jXkfmKU96MJtvnP6BC1CIgPaYLQP750qbuJWaDkxc+PaCA6UcUyYAAZYIEEEN1Esm/l8xHnlE/Fn3mP1PK6tWxoIxCg3t419su2NWnIvV6ZWEHrjgH1S14oCDcWf7n/BoSfBh2h74GfwuoCpux3De39kpH7pmxlzpzvq+vCi67DL+OtNwRxpsXued2R+H9YG2tuAL80rwv/CDNIHUgNW8H5dHXZ1NHWmTVGj5nkMXNAUquZXvg6X4i5uz7Gbrf4diCLKkVX4ODCPgaSRzoJeVGhQcrpzVdaQkUMmFCqMW+hOP/Ua6Nuj9DXO1G
 e0oQkR+D
 yQSP0AMR+p6TtI601DUTFRBcJZBscX7BOHkCtxCxuHtBJ7Dl2cmHceLUvv/NZ7EVc2hatyTKHu2zJP56VIz2u/JGZBzzMA4pTF6/SoFu1Wg5p48a5pCKKcO7zNhG/j/47ImtFjHvLP0diTvdPjcwPfrIz9eqS3dQt24RIX5XZPHMJPsQP0K4Kg5H93mGhA9jFNAMcdUDTS6BzSRIhfgVbbKFMzww5klceAfFZAdDmNxm3X/rqUsdd2aF2bbKjbo9sRbStGncc6cKhQ1OO7jrLOL9YMrWC56yEyODB+KVBQwoG8PH4WRK04JkLBlaZX1enEIdJQAuFuqxt8azG3zfQnEmJn9X4Wd5KhwLtsNuyvKOr2NM0nb252CbSUBOm2Q5e2zLtF2yUYPkvdupWYSyoReelH9F90jBCjM0X6Bv7FrNdjPdisj50Lu3BeO2+jyjMABI9wfuF4O7mbis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/09/2026 04:35, Qinyun Tan wrote:
> With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim
> never invokes the zswap shrinker: a cgroup under memory pressure does
> not write back its own zswapped pages to make room; they are only
> written back by global reclaim or once the global pool limit kicks in.
> 
> The zswap shrinker is registered memcg-aware but without
> SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
> before commit 03375203e1da ("mm: do not allocate shrinker info with
> cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online()
> check in shrink_slab_memcg(); since that commit it is demoted to
> non-memcg-aware at registration.  But the zswap shrinker is not a slab
> shrinker: it tracks zswap entries and resolves the owning memcg from
> the folio's objcg, independent of kmem accounting.
> 
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
> 
> Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
> under memcg reclaim with nokmem.
> 
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
>  mm/zswap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3e..8bcc2997d7719 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1263,8 +1263,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
>  {
>  	struct shrinker *shrinker;
>  
> -	shrinker =
> -		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
> +	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
> +				  SHRINKER_NONSLAB, "mm-zswap");
>  	if (!shrinker)
>  		return NULL;
>  

Acked-by: Usama Arif <usama.arif@linux.dev>


