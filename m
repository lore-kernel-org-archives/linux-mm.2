Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643E3C5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5989A6B0092; Wed, 19 Aug 2026 05:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549DE6B0093; Wed, 19 Aug 2026 05:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E396B0095; Wed, 19 Aug 2026 05:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 250B46B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:25:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB1F980482
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:25:46 +0000 (UTC)
X-FDA: 85117486692.28.89EB450
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7509E1C0007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:25:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TRMks6LM;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787131544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfZIfo/SEd42BidWWjniFI4c8yolrhYimg9M2l4ITjM=;
	b=gN41NiQvrVCYKUmu+t0SZ5AaE3YIpeNdv0dVPOR7ntzAfRAiIBtFg7vC1FqCt4sCcFCfXN
	1G36mgaVoFj8/zuU+D9WuOvjgd38vJ2YamogvoVfqC+gmMijioyphGcuTR+qzNqTmCc5oz
	f1jJoPTUu5PNf6GWcL2cK5kZOonhwTM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TRMks6LM;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787131544;
	b=BmxNZ1q6V6mx5JOD+37aGP2wBoNeC/vF+cwv+OAwgnq9yKdkvmW/XkeP2WO9ugWVGHl78p
	UMRATsOFiI+a0zbyJ43wFoddv+P0oTSKz4WgwTTYgUDUHfFJh/oOAdUNB3KIUEx76FL1Un
	mVhDmmnsJMtxZuw4hHTDZKgb0J1Fo6k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787131538; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cfZIfo/SEd42BidWWjniFI4c8yolrhYimg9M2l4ITjM=;
	b=TRMks6LM23uKHQbe+TYJOWY137aUvdii/rJTZIy/Uy/ODQM60qnGAmDahcId6fsVUNw+LVunM+JkwbbVBGhRGCKR/8mLtwEukcs0hxiK4sOsubdLz04m7d3cpZRzX2LJ4594+JMeu1rvqSYPpkA/WRpTW8RBIpNxZjtYl+mfhEI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9G8Y5l_1787131534;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9G8Y5l_1787131534 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:25:35 +0800
Message-ID: <50e3710a-b63c-4460-b3a8-f9f98ad7e7ff@linux.alibaba.com>
Date: Wed, 19 Aug 2026 17:25:33 +0800
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
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7509E1C0007
X-Stat-Signature: z8qwrw676sngngco41ud8iauckbckdro
X-Rspam-User: 
X-HE-Tag: 1787131543-175609
X-HE-Meta: U2FsdGVkX1+dOJ0t1XuIB4t/u/6lWD1A8/wF/tC8te3bEvyZWBaOQ0yXZ9Gx53bo2UOPzAWRO/dnLJQCkQOMNgVXiJs2/wSUqcqIkB6vw21jmxdY/4c8HdqL+qq821S8fxuWXjpl50kCCuYve6wvqkDsUkzgWd0MYFqhKxPZkB5g503DjKn9sQ9miif9E0QuGDAMYfLBiAWFZ9FeKHvyum2emGk8hjUYRA4O5H1OYt8FNuPpEARYisYpWvpb0EVGQy4UZFew74PlSf51hBXyxhBIQi3M0+/gG1wNcZxv1RPK45QiF43lKV/l1Cpja3C/2cVYbir0qqXCFcpyEcipgOsSxyy4cH2vU+H1BNNp1W8hxojeB0Uk5b3PfqYRkvewtXC2MIeGi5ljMb/GlbDIlsnYZSVcBtv19sm3OEoBA3Ur3GPLfxoBkx47HqXPDTpbcHr0RSLVDqEREAbtoPuOrXV4Q9OeYSMWWrUHCxgOv0vYNCp4IQSHe0uZ1EyMryzXAMYHNG9kPiym+uMgRSugFbozIbzKndgyOLsDQQ/gQK3kBEkHwBJBmMjgn2LJi6MJDQ3PLnGnnn/jiV0McJ52gewIqq4KacFCuECEq7kUo517isGCyOIQSV+AG50leVgbWjdbICmA+YSyOcO+P2E0qV4c3T3FP2NeX/t81nOjEpZwijWSUeINHQNehkmCkUVVlDgghrPPP7yM8arh+rCJ3JZXL4RhHhrpR/EZN2l+LJtrsHRaoeFHWwGEBoguqUuXPncNHolQggvFgT7fOttP0RDaCYa6sh8UamGC19M+kcWVV4TEWATKdaUQh71mINT8URyYz3DKOSpKls3fwb5jg2dEffwdueh9bQIUjL3bgjDmwTPG1lGnfzaGcbNIX5uvFvrZ0/QW/OxRRY8z1eOkv1ajlkIm4HLfMFs3ALiQDelze5ya6HTngVRO3pu3jN9rwPB9bLHZl1HXc/Wz86j
 LujxRhDp
 He8GoUVDDZ7fXT1BxWgFWJfegKJ7GcMZxwo1/MGBJBtpbLePXCWbibtVu8ba0+CX1j6Q2cZxWACtylLgZk3twNfli/PPc2h+VBfXl0xxRwdI6j6nGky7eHZQVHevOrjqK4GgjdH3sKCcc1U564zeytyK3W/zmzdSJD8R8nxcBjRk/4xQmiLQVfqbDLDH6ucoVvxpDp1M03FQZ/Stn4vnhS2Sd3FbRU7uf5aCYVTLBKor2uDn87c80sxAyTyu8vEO+Ord6RCcn6HX1ff5ANfZn6ae+Xfz3b+euGrY8BaOf1OzffHqbXJ7e09KdlqaMTGMEEw9tFKlzoT7zQd3WLcjynlDkPRefM+CXDjL7zCQzzxRhI2Xo/49DO0EFfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
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
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Yes. More readable.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

