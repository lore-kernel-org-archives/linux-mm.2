Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 662FACD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 16:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFAB46B0005; Tue,  9 Jun 2026 12:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1E66B008A; Tue,  9 Jun 2026 12:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FDB6B008C; Tue,  9 Jun 2026 12:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B09E16B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:06:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A0C6C24E4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:06:51 +0000 (UTC)
X-FDA: 84860852622.08.3C594C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96165A001B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:06:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4L0SJ2Z;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781021209;
	b=q+L2uM/LdTmJatlq1SVAPQAkQJf+hJrtAT8ImLai4JgkeNuWonEO6felIIT+WPz2Z/xved
	mpwVI2ygA7kwiExWitmLLjMoJqWlIiAp3XjGSxqZyVwDTVByslF/UI6fB9FhBIiI+0K7wB
	+WT3q0kFLFCjh9dbb+chaJPEq7KvfTI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4L0SJ2Z;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781021209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7bPkYE1hFsis/eoaT2/5xDkAIy0RidKljZP5cGSxLs=;
	b=5Dw8/y3lo9cnIsbwUNOj5hKaPc0otABBmiprPB9cUn1iDnNt7WigR9DlPlY3RxB0vvLjlx
	pqf/wsilrEAwCLTmf/TuWWS1FytCiOsmRZJEdjDjwAc3JXTZ3i1OmoWs13+4/LvagLbBtp
	Op3+9pMbNI8nS6QTn6g683ga4g5HF2c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0129C6020B;
	Tue,  9 Jun 2026 16:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF171F00893;
	Tue,  9 Jun 2026 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781021208;
	bh=R7bPkYE1hFsis/eoaT2/5xDkAIy0RidKljZP5cGSxLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l4L0SJ2ZH3PV+2JxncwHHIlSpkjYIYLAmL1DL+y4+CDxMbMymG0WCtp5xgzy5cfuk
	 SR6gNhlmRrvBoRBPzscl5gzDA5rO6XarRaSH4UpzT0lQuXcfqXfkM1XxA5q26McktH
	 wJ6YbU8BfWIfBVs2T9mdvVB5EdkAqMCf0SDoMciGb1qShLkLsdFWEtqAJxRppxsybT
	 tmzWw/BzTmuXq4G80sTi//X6LoesYZN+MXuY7aBkfsyctFM4k/eaYqwsiXiojxjLXk
	 KWawDp1bc36drpcL+LQUbc0gOLyuUyH3WMcs2Ib55m6CWlhiQ5CBtWhCHQ9YSEH5CP
	 yeRX2hpLSdhHA==
Date: Tue, 9 Jun 2026 17:06:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Luka Bai <lukafocus@icloud.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Message-ID: <aigm-6ykF91FtZBx@lucifer>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
X-Rspamd-Queue-Id: 96165A001B
X-Stat-Signature: mnbe4py4wy9name6zo8kjpiun7yz7tph
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781021209-138731
X-HE-Meta: U2FsdGVkX18y/77cCTdC0ADhjv1g1LHkA5Ag2jvMQHVAZ2TdBRDRiaFbAjKY8A723WQZ93wf3nHz6WqadLm5rmwdjUvyOmRTTiIrsiAoRfaqVrc8A3yw7K/0tvWH5SnDqLK7crMsDAA2/aMucG5ND3nyDAV21530odh5L3qULTcGUxZqpg4VaEI5CzCt6HAV7IKyNyH4DaZvN5ZYHB3hgPKueub/UY2UdZkFYoPCRifWyVSxInHtNLYOj0S06Lx7OufWtVf1Flc/zBrEvWAdDqaX6Uj0DAzevexQ+ftbPWJRXVJNnDsTLTtpw2lp4h5JeHSMn7QhX7iEfwPfiTxQGQbaa5V7oIjpi/6njo/aSy56Jtb332kbkrs0g+siPlO9vLMquQihiUWCKu4UZwF0ruP5kdxPfnEYFU91uL3TcLhci/T/TfYkAIzyllID9L3HkBO+qt+zCGAy4Tvv/YTS+mUi9H4k8jSeOJm09LrcSs1lXhbzAYvGCqitSNGAIuHnW534GP+0ziP/lV3yICko2GBuy05+YpF5iXAIz+4L7RmW2E9p4KzhLpUnTkxHtV/sENu+PXs1DHDD8ZdJbj4m8DhX3tbwyH38xYP4FFkxoVxPHD0NUJml7d5L8D3Gi43twlHsOwEbjPJMAi+hW3LU4O6GX8oBguMipPSu3TDQww7vIpLP0SJ3/uaeqQsvMUuL5ewQqrW7cf/V6mDLFl59qFlK5krw1oaucNNt4M0MUgpewT3jGjEXptNBoRDD6YeU//bn9VqmvqzMiC+fI9FshN7LxhXOq+DU53wYXeWqLlizxMkZ0mYY3Sb0SJENp1nVECiNX/ybOsFYj8V9lo5eXNY4Pi97ZmCq5SzA769HZpaIBTzihaxn2dl9aOFL6oc0Fz/dx6GP6KVDw78KNcnSfcDXToK2JYh4priNIJO/C5IT187yTXf4+P4A3TfXDl4kCJpGV//vTBFBdWeq8XR
 /D82Qs+X
 ijCM1fYBfKFAVQjvDz1DcJ+PKwvFdivWyFQDOZcGuieQkTHRqlB516KPgllLTT7QZ/tl/pY4yTrqBWrngm8tT9a+XyoP6Odx8iS1hR51TddZc6z+0MzqrkW7Muq59sB0FiNTcyJ7c3eRFvHGiax4qlH5KQD61hbNLZILWZGGVI8iUdO9v+u2H5foIcSSdkMaF0tXES830zTWKhqtXSFFu8zFU7WIK96KdBjuCvjJbTpNEl/5SobaWh/RT4b5mxsA7lddAlj0tHM87IWnBu0K5cOIN6JbQ+Ew6WC8lHMOSjCMHKcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luka,

This should have been an RFC (equally, your other recent THP submission, [0]).

THP maintainer resource is highly constrained right now and we simply lack the
bandwidth for larger work at the moment.

In addition, I don't think we want to see any further major changes to THP
without without significant work first being done to rework and improve
the existing code base.

We have a lot of technical debt and adding more on top is building on sand,
really.

In general, we expect newcomers to the community to become familiar to the code
base through smaller changes (and also be useful to help with review) first, prior to
submitting larger changes.

So we currently don't really have the resource to review this series at the
moment, so I suggest you focus firstly on finding ways to refactor and improve
the khugepaged code.

Thanks, Lorenzo

[0]:https://lore.kernel.org/all/20260501-thp_cow-v1-0-005377483738@tencent.com/

On Sun, May 31, 2026 at 12:27:16PM +0800, Luka Bai wrote:
> Khugepaged is a background daemon for collapsing feasible pages together
> into a transparent hugepage in all sorts of orders up to PMD_ORDER. However,
> it doesn't have any preference in its collapsing and just iterate through
> all the qualified mm_struct, and scan their page tables from the beginning
> to the end. It is quite inefficient especially for large address spaces
> considering how slow the khugepaged can be, and may waste many hugepage
> resources collapsing memory areas that are seldomly accessed.
>
> We would like to give khugepaged some preference hints when we found
> certain areas are good condidates for collapsing. For example, if some memory
> areas are frequently accessed, then we know that it's valuable to merge
> them into a bigger folio since it will reduce many tlb misses.
>
> For example, MGLRU has walk_mm() and lru_gen_look_around() that are used to
> scan frequently accessed areas to save some works on rmap walking and
> generation elevation. By the same time, they are able to find those
> hot memory areas, it should be valuable to merge these areas into folios.
> MADV_COLLAPSE can be used, but that will cost too much time and will
> harm the performance of reclaimation and slow down the process that may
> enter the slow path of memory allocation. So the better choice shoule be to
> tell khugepaged to asynchronously do it.
>
> We add a khugepaged collapse hint framework in this patchset. The caller can
> call khugepaged_add_collapse_hint() to add hints for khugepaged to make it
> prioritize collapsing these specific address we found before doing Round-Robin
> scanning. Each mm_slot which belongs to a mm_struct in the previous
> mm_slots_hash is now a khugepaged_mm_slot, it comprises the old mm_slot
> struct and a number of NR_KHUGEPAGED_PRIORITY_LEVEL struct
> khugepaged_collapse_requests. The request struct for each mm_struct will
> be put in the global struct khugepaged_priority_queue with respect to its
> priority when __khugepaged_enter() is called on this mm (we give each mm request
> structs for hint dispersion and balancing across all the mm_structs that will
> be added in the future patches), and all the hints will be put in these request
> structs. Each hint will have the target address and the target vma struct. An
> example of the framework is like below:
>
> global collapse hints queues:
> prio 0 ------()----------------------------------()---------------
>             mm_slot0(process A)                mm_slot1(process B)
>                |                                               |
>            hint0---hint1---hint2---hint3       hint4---hint5---hint6
>
> prio 1 ------()----------------------------------()---------------
>             mm_slot0(process A)                mm_slot1(process B)
>                |                                               |
>              -------                                       hint7---hint8
>
> The khugepaged will try to scan queues from highest priority (which is prio 0 in
> the graph above) to the lowest priority (which is prio 1 in the graph), then go
> through the list, and check out all the struct khugepaged_mm_slot (which are the
> mm_slot0 and mm_slot1 in the graph above), so it will start from mm_slot0 in queue
> of priority 0. Then khugepaged will scan all the hints listed in the slot (hint0 ~
> hint3 in the above graph). After handling one hint (no mater success or fail on
> collapsing), the hint will be deleted. If one khugepaged_mm_slot doesn't have any
> hints in it, khugepaged will skip it and scan the next mm_slot in the same priority;
> if there is no hint in the queue of prio 0 anymore, khugepaged will scan the ones
> of prio 1; if there is no hint in any prio queues, it will fallback to do Round-Robin
> scanning like before.
>
> khugepaged_add_collapse_hint() is for adding hints, and it only gets called
> by walk_mm() and lru_gen_look_around() right now. In the future we may
> call it in more scenorios when we found hot memory areas. For example: in damon.
>
> We tested the performance by using valkey-server (based on redis) together with
> memtier_benchmark to simulate a gauss distribution on the get/set operations on
> a 160G, 64core x86 VM. The dataset is about 3G. After preloading db, the testing
> parameter was like below:
> memtier_benchmark -s 127.0.0.1 -p 6379 \
>       --ratio=1:1 \
>       --key-pattern=G:G \
>       --key-minimum=1 --key-maximum=3000000 \
>       --key-median=2000000 \
>       --key-stddev=150000 \
>       -d 1024 \
>       -t 1 -c 10 \
>       -n 2500000 \
>       --pipeline=32 \
>       --hide-histogram
>
> Since we wanted to see the influence of khugepaged collapse hints on the reduction of
> tlb misses, we made khugepaged do scanning every 1 second, and used the userspace
> interface to do walk_mm() for the cgroup which valkey-server was set into every 2 seconds.
> We made sure the server was all 4k pages before we run test, and only khugepaged could
> collapse them into large folios. We enable the anonymous THP of order 9, which is pmd
> size in most setup. We used perf stat to monitor the tlb misses statistics.
>
> After repeated tests, we could see dTLB-load-misses with a 13.50% reduction, and saw
> dTLB-store-misses with a 5% reduction compared to the setup without any collapse
> hint. The final throughput for the memtier_benchmark was about 2% to 5% improvement
> on average, which was not that obvious compared to the tlb miss reduction. We believed
> that was because there were too many factors to influence the final result of a random
> redis test, so the influence of tlb misses to the final throughput were compromised by
> other factors.
>
> Patch Details:
> ========
> * Patch 1 is to add the basic khugepaged hint framework like we introduced
>   above. Details can be seen in the commit itself and the comments in the
>   codes.
> * Patch 2 is to add a slab_cache for khugepaged_collapse_hint which can
>   improve the performance of allocating and freeing the hints.
> * Patch 3 is to add a deduplication machanism for the hints so that we will
>   not add a hint that points to a repeated address.
> * Patch 4 is to add the accounting for successful collapses initiated by
>   hint or non-hint.
> * Patch 5 is to add the collapse hint in lru_gen_look_around() and walk_mm()
>   of mglru.
>
> Thanks for reading. Comments and suggestions are very welcome!
>
> Signed-off-by: Luka Bai <lukabai@tencent.com>
> ---
> Luka Bai (5):
>       mm/khugepaged: add framework for khugepaged collapse hint
>       mm/khugepaged: use slab cache instead of normal kmalloc
>       mm/khugepaged: add deduplication when adding new collapse hint
>       mm/khugepaged: add accounting for successful hint or non-hint collapse
>       mm/khugepaged: add khugepaged collapse hint in mglru reference checking
>
>  include/linux/huge_mm.h    |   2 +
>  include/linux/khugepaged.h |  20 ++
>  include/linux/mmzone.h     |  17 +-
>  mm/huge_memory.c           |   4 +
>  mm/khugepaged.c            | 460 ++++++++++++++++++++++++++++++++++++++++++++-
>  mm/rmap.c                  |  27 ++-
>  mm/vmscan.c                |  33 +++-
>  7 files changed, 549 insertions(+), 14 deletions(-)
> ---
> base-commit: e1af79f3291a268adf4e149e1faba3052743e898
> change-id: 20260530-thp_collapse_hint-ec92bd943797
>
> Best regards,
> --
> Luka Bai <lukabai@tencent.com>
>

