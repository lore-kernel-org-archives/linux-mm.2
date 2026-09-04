Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D94C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58896B0088; Fri,  4 Sep 2026 02:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09B56B008A; Fri,  4 Sep 2026 02:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7B66B008C; Fri,  4 Sep 2026 02:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79CB56B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:50:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 111C016052C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:50:40 +0000 (UTC)
X-FDA: 85175156640.29.8FAC2FA
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A9EA40002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:50:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S2Gi565F;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788504638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUwnrTnO9K1+Dq0dCp0gfyukZzjfQW8mCiD3/Ac3fAA=;
	b=ovBuwAXW+dd4FxAKUmO144YWyKcmtKuXoinhWvOXJtPJdmFv0rxGHtsMd7OtGEa0tIso6/
	ARGIZ7qFOzuQ9ccdCvzRzjKZfB8Z959fwplGfvSF07ek8y7t3VFdH2oasoOjQxbwnmKMWY
	u9L5WokmD8SxQ/J28FuHNTlbI6W6tPk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S2Gi565F;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788504638;
	b=q1mRTIKMM9iYb/Ib6EI8GcSqGUxZpuDGKcoRJXsaKasjVJBGqHAlKPuLUB9uEcvNFcWjDT
	Ng0uPaf80nFHwmFYKqNwEK47eAyLcoLfMeLqERSWxcVkF6BgYmVxx8cpdCqIgjDfzbTY1y
	BXMZ8dAH/T9yTwX0qp584R7YUjt7uXI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788504633; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dUwnrTnO9K1+Dq0dCp0gfyukZzjfQW8mCiD3/Ac3fAA=;
	b=S2Gi565F0mAKIcyN952RVbJkby22sv8kB0twqwF2xok7BZUsN7LjCMvVyhgsmFLsk5SdTnkGBR3lvYjf1g+KMsS1SPUvyTrQExTgsAwI1dpWeUNFUQOrI02CjHazb0xkfiMZj+FZyr4jxjHplXqWEFFC3tVYQMXV9rmKFnwy9Ys=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XAHuDz3_1788504630;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAHuDz3_1788504630 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 14:50:32 +0800
Message-ID: <de28b6a7-7f51-4344-8139-1ec412604062@linux.alibaba.com>
Date: Fri, 4 Sep 2026 14:50:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: memcg: settle memory.high debt after THP faults
 with non-blocking gfp
To: Qinyun Tan <qinyuntan@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Xunlei Pang <xlpang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Chris Down <chris@chrisdown.name>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
 <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A9EA40002
X-Stat-Signature: jhw1yy9ptey3fs9o7ydfiqhud7173dz1
X-Rspam-User: 
X-HE-Tag: 1788504636-894264
X-HE-Meta: U2FsdGVkX1/PjmkV917Zg4M6vq2Z5GzfYDnGa/FBhNPfmbQWAG6eL4+URNGq2LdCbI45s1A0TY1UwCUgo4TglN12Lf6JOZsUF0N/GMrX8QSk9D6/uSz+RFCykAJsHIWr+gETZrC/TUvwrNYwy+qTTHOddz1CRsOdkJKa8aObPmVBzADLUjUug9P0E2x+k4atlfe5iYYqu3EK4e4RNG52RxxIHrbn117rv614s72qyglQj5n09gEH0vuTGgbKr4bK19wuOhDCYyBVDLWkVbI3S5OHUP/scPSGTpu+IXpU/z+RrokOkU2TdOskkfMto9bxBATcpzByUytBOFknxwq7tmXp27pszmHXXSSrT4kGOaHBTbuPxC5Bpg214KjsQfL8WeGWegXn2MoHMrAfoE519WMakgVTDN8SKHFNDAGUhMYWwKA2POTcFXa96nv2wk5wn15LOHlaqA+4XwMuhPe86i6QUEL5i6fqKs7C+k+OqM2qHKFjGqNo2XzAFnKljshH9jyz/H7TVpcYJ3/Vf8xO7Hl4ICw6CcFsl8pQpQelN8GUjQ+daWc4hNYH1g9ff1qRM4ryc8rBx4RLXx/Sdb4gPed+VcND/gDBLsDKTfzQsbnyGBALuYCZ4P7Hd+DEDNc5UemeFOF91EVjDDyrToZNiDjZcet56uiGFXEPv5U7sRl2j6JjG2UUQHWOlTwVrDQ09yJ+zRl79pLjZyGYDPsCpCRG29jx7aI/YvTtzXqJCKwu3Sk9gdp3zrakcO5z0KclNLNQEQjBk70tehuDdhWWPO65VbGkAOCGRyg3HyoMnr/EOw8lx0t89XgTbUautWs7yK0fC/PR4ANyR+gl4khonKqZ3QGFIXbsSFjQuAdDiP5FVOGuRR8urfLHWxNgWxh6PhzQCvyG7/uigvMwKqdknAnm8ki/eEiqEKZboLyGkULakqhQF+h9txlxmKuX2t2EsCZd831InoJarI2rvnK
 oMOIlsYl
 kBG6FXZKqXPMm7xdT1h7ozxn78FLnLJ0ecbyDpmPMErJm8dx9u4X1Kx5ixkcM9EYAKaQ61a+WALuz/aaTWUgjeXjOsdZsg7hLsrBGfe9JG8U0omtquBJJBjnKmnYBYVZlTLgBzHI/DdU0uEXWQOXX0OeNBQqh4sAQcMlxYE6/X+a6GdCr47Lpoa03xWn5BinQ3nkv/nRpQFXD8wKbc+y2dhAlpuD7uZySaQnBKpAfha+YID4FeMsmreZYYj3nq2iH/mAjqLA40GqhHiEpnirPP6Uwl+kPcY0QLKJ4PZjLcJU/TS+Jg61TQol4Jr2zCJCLIuiJQlf9ogJ3sw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:54 AM, Qinyun Tan wrote:
> Anonymous THP faults happening in a kernel loop that does not return
> to userspace -- the populate loop of a single mlock() call, or any
> GUP-driven population -- can drive a memcg's usage from memory.high
> all the way up to memory.max with zero reclaim and zero penalty
> sleep.
> 
> This defeats the containment memory.high is supposed to provide:
> above high, the documented promise is that "the processes of the
> cgroup are throttled and put under heavy reclaim pressure", and
> userspace OOM handlers (oomd, Kubernetes) rely on the high..max
> buffer as their reaction window.  Only after hitting memory.max does
> the non-blocking charge fail, THP fall back to 4K, and
> folio_prealloc()'s GFP_KERNEL charge finally restore throttling --
> by which point the entire buffer has been consumed.
> 
> memory.high is enforced at two points after a charge succeeds:
> 
>    1. from resume_user_mode_work() on return to userspace, requested
>       via set_notify_resume();
>    2. synchronously in try_charge_memcg() for large overcharges, added
>       by commit c9afe31ec443 ("memcg: synchronously enforce memory.high
>       for large overcharges"), gated on gfpflags_allow_blocking().
> 
> A populate loop does not return to userspace between faults, so gate
> 1 never runs.  Gate 2 is defeated by the charge gfp: since
> commit 3b3636924dfe ("mm, memcg: sync allocation and memcg charge
> gfp flags for THP"), the THP fault path passes the allocation gfp
> from vma_thp_gfp_mask() to mem_cgroup_charge().  With defrag=defer
> that gfp is GFP_TRANSHUGE_LIGHT | __GFP_KSWAPD_RECLAIM; with the
> default defrag=madvise and no MADV_HUGEPAGE it is plain
> GFP_TRANSHUGE_LIGHT.  Neither allows blocking.  This is the right
> policy for the physical allocation -- a THP is not worth direct
> compaction, fall back to 4K instead -- but try_charge_memcg() also
> interprets it as "this context cannot sleep" and skips the
> synchronous enforcement, even
> though fault context sleeps just fine (it holds the mmap or per-VMA
> read lock).
> 
> Fix this in the fault paths, which know their context can sleep:
> after a successful THP/mTHP charge, settle any accrued over-high
> debt via mem_cgroup_handle_over_high(GFP_KERNEL).  This reuses the
> existing throttling machinery (reclaim + calculate_high_delay()
> penalty sleep) and is a no-op read of
> current->memcg_nr_pages_over_high when there is no debt.

This doesn't convince me. If the user sets defrag=defer, it means large 
folio allocations should not block, so using gfpflags_allow_blocking() 
to decide whether to call mem_cgroup_handle_over_high() is reasonable.

If you call mem_cgroup_handle_over_high() directly in the allocation 
functions, it would definitely increase allocation latency. This is not 
what we expect when setting defrag=defer.

On the other hand, I wonder if briefly exceeding memory.high is really a 
problem in the real products. If this is only to fix the 
test_memcg_high_sync selftest below, which is full of magic numbers, I 
don't think it makes much sense.

> Deliberately not changed:
> 
>   - The charge gfp itself is kept coupled to the allocation gfp, so the
>     fail-fast behaviour at memory.max (charge fails -> fall back to 4K
>     instead of reclaiming or OOMing for a THP) that the coupling was
>     introduced for is fully preserved.
> 
>   - try_charge_memcg() is not touched: gfpflags_allow_blocking() is the
>     only signal it has, and it must stay conservative for callers that
>     genuinely cannot sleep.
> 
> The pre-existing selftest test_memcg_high_sync, added alongside the
> synchronous enforcement by commit 6323ec54b450 ("selftests: memcg:
> test high limit for single entry allocation"), readily reproduces
> this: it mlocks 200M against memory.high=30M and memory.max=140M
> with swap disabled, and expects high events with no max events.  On
> systems with transparent_hugepage/enabled=always it fails without
> this patch -- the population bursts through to memory.max -- and
> passes with it.
> 
> Fixes: c9afe31ec443 ("memcg: synchronously enforce memory.high for large overcharges")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
> 
> Note for stable backports: mem_cgroup_handle_over_high() only gained
> its gfp_mask argument in v6.6, from commit 9ea9cb00a82b ("mm:
> memcontrol: fix GFP_NOFS recursion in memory.high enforcement"); on
> older kernels the call sites take no argument.
> 
>   mm/huge_memory.c | 8 ++++++++
>   mm/memory.c      | 2 ++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..543ba4a74dc3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1329,6 +1329,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
>   		return NULL;
>   	}
>   
> +	/*
> +	 * The charge gfp encodes THP allocation policy and may not allow
> +	 * blocking, which makes try_charge skip its synchronous memory.high
> +	 * throttling. Fault context can sleep, so settle any over-high debt
> +	 * here instead of letting usage grow unthrottled up to memory.max.
> +	 */
> +	mem_cgroup_handle_over_high(GFP_KERNEL);
> +
>   	if (folio_memcg_alloc_deferred(folio)) {
>   		folio_put(folio);
>   		count_vm_event(THP_FAULT_FALLBACK);
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3d..24cbf2a26905 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5362,6 +5362,8 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>   			folio_put(folio);
>   			goto next;
>   		}
> +		/* Same reasoning as in vma_alloc_anon_folio_pmd(). */
> +		mem_cgroup_handle_over_high(GFP_KERNEL);
>   		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>   			folio_put(folio);
>   			goto fallback;


