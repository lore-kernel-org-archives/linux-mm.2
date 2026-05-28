Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC7A3CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9546B009B; Thu, 28 May 2026 09:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479C96B009E; Thu, 28 May 2026 09:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368AE6B009F; Thu, 28 May 2026 09:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 230F06B009B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:32:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E53AF1C2059
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:32:25 +0000 (UTC)
X-FDA: 84816917850.16.7C0E924
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id B12A640018
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:32:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MiU8TddY;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779975142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mK9p/d9INJUnJjRfPuNzLbC2SvilH/rgU+fuHkGUigQ=;
	b=6dAx1SuX/kZMODZyMSoSAFvJdqqtBITYXBQK9SVBZUDv3bQx5zxsWO2GPT4aCHfy9cpAas
	/O8XcqQtmPfucVvO/qzebwzVaPBe08i5odxvuqOxgZpEuA9WUsiRXbAKsM85KfrBDIsnWu
	tO3rNC62EOcRNyG5pHPeL5El3ILelT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779975142; a=rsa-sha256;
	cv=none;
	b=y6PBw4oHSpfvVWMMNBjVqoCvB8EkPgubMWEEJtmdS4XSySN/ndErSDoTlXIRNrmIa43TJr
	502f5tr2sRYh09ZlHg++TDqsAUxHmezI9zagT7ZRqq6vWrpiWiqbcTUCBHb0q5u7KGG45d
	ACx99/Qvu5QCR3KDfJlj24Y7fjbgzyU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MiU8TddY;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <6f9c78b2-3846-4f75-bcc2-41bf91230513@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779975139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mK9p/d9INJUnJjRfPuNzLbC2SvilH/rgU+fuHkGUigQ=;
	b=MiU8TddYjqp0YAIW6vK65c2gTNAqz6sba9wwiZPfAp0DNVaVGgf9vBqL8/Y/aF1QY2Lx+v
	8i1v6Fs9OZ23Ha/H4jwGv+TCwXEvZj2aH13jAB4kcNqFRP5eBwWIwo9OXgpL+ZBSpnFDkH
	TE+tfrF66VN9lUdQeM2jyamvTO5NLDI=
Date: Thu, 28 May 2026 14:32:06 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-10-hannes@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260527204757.2544958-10-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B12A640018
X-Stat-Signature: zmagbpdosm8y7osy5g49ch8mmki9eea9
X-Rspamd-Server: rspam06
X-HE-Tag: 1779975142-516160
X-HE-Meta: U2FsdGVkX1+XKgYgSD6bWfvGWEVzJO6WLIU6+pgMznZ8W+8s1Vs1PiMe6uI2UXNRy/ERHcql/CLN/+Vorj9DMWDu+7KIcCSDojqEFS0EEsOPmKZ8BIqLjuJsLgQFud5Ca7A3i1SXDSPpXPdbeOJlc8+UtN1cP5Y6mmeU4WekFrhHND3sG9f6lYl3Q3TH2/IUpGrTh7L11kKWw9RzTEdSE1SikBL4T5JHTdrJLLA6pImX12iE+WaPcc0KrBSz7bCwc5Tcq5hEtHF4g1+BITS30/w4WY2cI8Cx6+GBpiaQU2THw0K1Zsfp+ejkOg89jMKgnT28Dwxz+ols+s85fR6/YdltzYKAloqHNdUEDFxrciMjUefnczd9sjYjxAKppwixeN/WQiOIrE64oJ5Z9Eus+oW9s8waF8wt1dFiacXjJRoNp5kLBkIg3BdogIxuQ1yilGsPFJCcN9jI+ZEGj9dyiOYzIWhgSlye4N+r/Z/tm59TubtqkGBcykMu3B9nvplX+TnZwEgUsEp6rX9jFB0YLogJXiGGRTV0dE+F5c2oVM3CUesRwuyQk9C282+/k9ptfpi4yz2Wn+5MP3ilG417Zf6W4sqQQQmNE10Ap1elpObx0Db2X3uM/1wio/ObzRra0y/dJvS5c84APmYyczlPr4csyPX8vKZYS85grmhbrh1DeRyZDSNvBl6TgUlRYEtRRTqHFwQ5cMmT/3+y5BQMZxh+AbiPIEVEQ970mAolXTgVIjf3W7IbPIGxxgZT3OqcyFWqYquE+UOy4s57X67L67gkhgfWmS056Uv1n8FDYJbqcDU87huqk4kSV2QwM2wW2MVXJRZphoNp84s49/kzwJD3wV9ZmytZNrti7IBemexQe6JhtRUZUbtPmZfuDudhJSIbJkIQGpnqwGtMlF+4ZffMjUa87D+051TCNBegRTTxn6ZPG0K3wbhB/BzSBr8Jd9bo0xCBCP4n/UZU0SQ
 RIRjVa8j
 d3PUhC0F+CPDtkvETmpBZq2jAH+tXp8oVin1f0AtHM0dqGQPKy7Md2ylRrnZrgDHUnzB4DWc0vmtjfv0dsJISfQ7w4aI6yYF106Sfq7OON3Lbx7x/QAI5LNGIxWzwnfgGMgMlE3DdpmPSPPYRDBtIhRJhi5F3Nqa7lPefrrl1ezLrFxidg8U954k8AqpNCUMjysTndZUq/1ECzaYxE+IK0iMP9vPM+StLyUgjEDCmFN/BWHD4uHhzAoWSpLEbu4fyH7g0wI2oUSaf3VTr12rzWYZD/5tF5nIqdQZZIidLmfbyQhfThIKa4dKMi2ZLHyo9hPd1079RrrFOpZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/05/2026 21:45, Johannes Weiner wrote:
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
> 
>         alloc/unmap
>           deferred_split_folio()
>             list_add_tail(memcg->split_queue)
>             set_shrinker_bit(memcg, node, deferred_shrinker_id)
> 
>         for_each_zone_zonelist_nodemask(restricted_nodes)
>           mem_cgroup_iter()
>             shrink_slab(node, memcg)
>               shrink_slab_memcg(node, memcg)
>                 if test_shrinker_bit(memcg, node, deferred_shrinker_id)
>                   deferred_split_scan()
>                     walks memcg->split_queue
> 
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
> 
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
> 
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> folio_memcg_alloc_deferred(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
> 
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.
> 
> Reported-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/huge_mm.h    |   7 +-
>  include/linux/memcontrol.h |   4 -
>  include/linux/mmzone.h     |  12 --
>  mm/huge_memory.c           | 364 +++++++++++++------------------------
>  mm/internal.h              |   2 +-
>  mm/khugepaged.c            |   5 +
>  mm/memcontrol.c            |  12 +-
>  mm/memory.c                |   4 +
>  mm/mm_init.c               |  15 --
>  mm/swap_state.c            |  10 +
>  10 files changed, 150 insertions(+), 285 deletions(-)
> 

[...]

> diff --git a/mm/memory.c b/mm/memory.c
> index 135f5c0f57bd..f22e61d8c8de 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5222,6 +5222,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  			folio_put(folio);
>  			goto next;
>  		}
> +		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> +			folio_put(folio);

Ah sorry, should have caught this in the previous version, do we need

count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);

here?

or maybe we just goto next instead of goto fallback and trty next
viable order?


> +			goto fallback;
> +		}
>  		folio_throttle_swaprate(folio, gfp);
>  		/*
>  		 * When a folio is not zeroed during allocation

