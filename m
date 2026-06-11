Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A55CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662566B0005; Wed, 10 Jun 2026 23:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611946B0088; Wed, 10 Jun 2026 23:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501886B008C; Wed, 10 Jun 2026 23:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7AA6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:39:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6DDD4C1A79
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:39:39 +0000 (UTC)
X-FDA: 84866227278.22.9F9D063
Received: from outbound.ci.icloud.com (ci-2003a-snip4-2.eps.apple.com [57.103.91.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5990A4000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:39:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=rIsKZwI5;
	spf=pass (imf01.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.91.133 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781149177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o6caUXppn7wd8ZpqomzcgxxZjM0QFD+AX38QGp9TRNQ=;
	b=C68uKciCas0YLk6hWn5xHofKGmke5coNR0EMxf5ftXzpwCHYfUCq7sg4itgPNznkawk1Qy
	ylMjuFrqWCkHHLHZlg5NDqsoQNHQ4N5+0hdva7t4sPKjgWMnmNvj9WUgi0CEJUbPUV+ZdQ
	fg3+PQPJzW8+sXGF5oNrvBGFHHStj7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781149177;
	b=S4RWCnfurqbby//9iJ59ziosXCEO2+PfZeNgoq+1sEbLAkKYkoHRW0XDc4jllX5YgQaW52
	o8BCheiz3MRMSs+ZELz7lmJQI75GwOlRALo/9vlQS1NkrDRE9qVifYmAmFVw3+jOOBqq4j
	G+706YFZEOgJ7CoSfsNeqOwqT+Q9UQ8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=rIsKZwI5;
	spf=pass (imf01.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.91.133 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-2 (Postfix) with ESMTPS id C50261800190;
	Thu, 11 Jun 2026 03:39:32 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1LHVwEWRxBDUkdXwdLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXloRHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQUZWgJDXEo6fhZFWlhacBRjOH84fCpwMXBVfi4GVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1781149176; x=1783741176; bh=o6caUXppn7wd8ZpqomzcgxxZjM0QFD+AX38QGp9TRNQ=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=rIsKZwI5x1YgPWneDJXTJCiGWwQNmJnGNSRzijcLjcLidikUpaF/eoeNai7KsQn9xCPnVYXR0T5iocmEXIqpwJCJoar9QzR3FFiXscCmJW9u4z/qYHdqxnf08fe4o1u2BMe6KaJKKUvsxuSBXo/G+SGe+SrlamleIpB2jgIbLjUr+HQG+YxzjOa28HP47nzSrxcz5hUlihJZodjqUuYldesQOa0Brgp20qk03TAKqzsH7QmzcYXlwaQBnGd0uzHe7EnlEAwRjEeddf0ZZnwdA8HKL2Wllt4JWru5OJ1vMQmuULbJxzHCcVhXSdTUnmbWAW/mQnVD00PAATuWKAGfHA==
Received: from localhost (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-2 (Postfix) with ESMTPSA id 9E70918005E5;
	Thu, 11 Jun 2026 03:39:31 +0000 (UTC)
Date: Thu, 11 Jun 2026 11:39:27 +0800
From: Luka Bai <lukafocus@icloud.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 0/5] mm/khugepaged: add collapse hint machanism for
 khugepaged and use in mglru
Message-ID: <aiot7xJGnv7o1BdZ@LUKABAI-MC1>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
 <aigm-6ykF91FtZBx@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aigm-6ykF91FtZBx@lucifer>
X-Authority-Info-Out: v=2.4 cv=fJg0HJae c=1 sm=1 tr=0 ts=6a2a2df7
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=GvQkQWPkAAAA:8 a=N5UaLuuoV0N6cSTO2EUA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: tRwV-_ZufEtNfyIgIgg95W4JdqwJe7Hs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfX3uxySk8LF+rZ
 82G5I7GswJACO49TzY/IjCga2UkO1hEjQOUNqByN9VWFayY3EHyNo+TDZZCPqQqPaPXcr4bNy8K
 wNN4iJZjqF4DLAjVDSxIadM0s4QEFk57Tvs1+sfMTvs8ppC733tq+jPdIum3EHCJOrPcjK5mDBr
 a72GVtMz+0lRUVf/F4R79FF01uUGyCcJNxpETtwzKlFWv14cDd075NZP4TsM+gG1bpVmEde+4k3
 1C9ReP0ySnkmhMpGxTAoClInhFny5Rg1brPXhioxNd7ew8A4k6JHW1hEetlm8ZOD/5RpKZRXqM4
 J6GANbDM3LJyor1Z4womn9OHgrfKkZXQbTSuXLEOzawmBTMw5CKagbncfeecEA=
X-Proofpoint-ORIG-GUID: tRwV-_ZufEtNfyIgIgg95W4JdqwJe7Hs
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5990A4000C
X-Stat-Signature: a8gdark9n5mpdwc7eytxjyotrxgyric8
X-HE-Tag: 1781149177-114906
X-HE-Meta: U2FsdGVkX19nOZyipq/ZRF/HgE5PK6PC0c5RBLBEzXZupNWk1KDUYFNJoj0jwhnOZJPwJHRPXo3KAs7pz2c5AJUhiczUoVVX1qZBzLtERciUYjJnLKaKNCPSEZzQb1Q8eCWcfMLHHZp93bQn6IkCmIn5O+WiiMauOwgYDb+E/SLMoa1FiuhNPJ1lMvdi6QaBcLeAQV8cD3XZrrmFv4ZJUa1VV4KwtKgGx5thyZQCza6Ck3IZwZOLptS11zLXBwJl2W+NJ0vF9uujUVOx3iuNue59wd12ELSLqymdWO+TNa+RLjdna0Kpuvgnk7LzFS8vL5kIfOPH8xKc3o5SOcn/+8mP5PYwHNXQuN9ONlB9O2n4TIyqs79vtWXM9Fl6+rbDIsKDQBjCqmFs+9fX6QyX0HYNkVB7l8Gh0YQOJkLAM0Pyhuke5t+M3vn+XiNUTI+kpzghe2Na7fm/mZOb3NYCY+1U8oL3TF+yLbmwTD+OGC49ZlLZRnakaI3R8TbOYwFuL81X7QaIMnjrIp3SSWrsPitwI+cF6lwIxDSGu+7S/GcTeiXY6mbm+aoElCZFTNmmNAEFyl7RarD7nTPTPnW/qGQvgjYGSZEnmnii3CleFnx9okDXV32qmlJp+0/uOYaqrPpW3fIrvjZ5ZWhtgEoJnxZew6Juf5Y7tDAvFdoYAr+A2cqVH9Q9PlgOq20nhqygfxPfSJMFBDHT6bZdlawImQjsmeCZ1dQwsaPOubC0V7c2SkcPci/FJ39I5hDOHC1KRbStBJRdxDYBMTC/o53VjgvAvopTAY8eVluW7v7tG26w/8MYuJRD2QZxcA8LXhZsJrZf1JYBN9ShItRijs2qMWrgsGCmnCAnv5u4aot2ZfaH9YEXEiwaxKvnSVfB/WipO0N4qTtJlGnExe/twF45iO8yYs1zLeizAmsw6yxcHKQagKBlRktLze42qrhXNKY1nrkW0yNruETsQTQN2Cy
 buWwXBwT
 v+RsY7kq7PGiX2EwW4EoeAr019zdB+6KcaCVe8Bkq6a1XHy4XCu/C5n08IEnabAccW3uz1G9qob8FxnLXNgQmYfdzD43tOvyKpHRmGLhtDtfPt99seymjg4/g8oAWwvoLF1yzJ2B2lEDqufESEZqBMRSMc809SN4CtVWKdUPS6kMKh4rqYOVThq4hG7aPiMzt1GJkiQYEEHMFmBrt9fxxRLQsE19xwuFKlDnyqtj91rCN8KLKzK5X+QRfQcfO6WAHgdoowTzH7F/qZKVTkIf/SbDEJeTq2j6VkQMYbEVaiEbyv570kc9xmNvtzC5czLTW30UjaLXKNCEvduZnLEcF5hQc9VUJ1k4pYAtN6+XL9RoYM9T1Id+ohGdl9fK8tHBBhT2lHjY7EAMDE65YB47U7MyNtKJmOr+2WgnuQh8Js2C8FoBlX8xoI00eqSsKc8KEE8IJhlcw0KPsVdo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 Tue, Jun 09, 2026 at 05:06:39PM +0100，Lorenzo Stoakes 写道：

Hi Lorenzo,

Thanks for the reply. :)

> Hi Luka,
> 
> This should have been an RFC (equally, your other recent THP submission, [0]).
>

Sorry for the mistake on the type of submission. I didn't know the difference
between an RFC and a normal submission...:) I've searched for it and will use
the correct type since today, thanks for the reminding!

> THP maintainer resource is highly constrained right now and we simply lack the
> bandwidth for larger work at the moment.
> 
> In addition, I don't think we want to see any further major changes to THP
> without without significant work first being done to rework and improve
> the existing code base.
> 
> We have a lot of technical debt and adding more on top is building on sand,
> really.
> 
> In general, we expect newcomers to the community to become familiar to the code
> base through smaller changes (and also be useful to help with review) first, prior to
> submitting larger changes.
> 
> So we currently don't really have the resource to review this series at the
> moment, so I suggest you focus firstly on finding ways to refactor and improve
> the khugepaged code.
> 
> Thanks, Lorenzo
> 

Thanks for the suggestions! I'd love to join the community to refactor and improve
the THP code :). I'll try to do more reviews and make smaller changes on THP to
get more familiar with the THP codes. 

And for this revision, should we consider doing THP hinting (or any other naming
that has the similar goal like THP=auto as mentioned by Nico) after the
reconstruction? From my perspective it could make some help to the overall
performance of THP. Or maybe we can directly include that semantics in our THP
reconstruction? Thanks. :)

Best regards,
Luka

> [0]:https://lore.kernel.org/all/20260501-thp_cow-v1-0-005377483738@tencent.com/
> 
> On Sun, May 31, 2026 at 12:27:16PM +0800, Luka Bai wrote:
> > Khugepaged is a background daemon for collapsing feasible pages together
> > into a transparent hugepage in all sorts of orders up to PMD_ORDER. However,
> > it doesn't have any preference in its collapsing and just iterate through
> > all the qualified mm_struct, and scan their page tables from the beginning
> > to the end. It is quite inefficient especially for large address spaces
> > considering how slow the khugepaged can be, and may waste many hugepage
> > resources collapsing memory areas that are seldomly accessed.
> >
> > We would like to give khugepaged some preference hints when we found
> > certain areas are good condidates for collapsing. For example, if some memory
> > areas are frequently accessed, then we know that it's valuable to merge
> > them into a bigger folio since it will reduce many tlb misses.
> >
> > For example, MGLRU has walk_mm() and lru_gen_look_around() that are used to
> > scan frequently accessed areas to save some works on rmap walking and
> > generation elevation. By the same time, they are able to find those
> > hot memory areas, it should be valuable to merge these areas into folios.
> > MADV_COLLAPSE can be used, but that will cost too much time and will
> > harm the performance of reclaimation and slow down the process that may
> > enter the slow path of memory allocation. So the better choice shoule be to
> > tell khugepaged to asynchronously do it.
> >
> > We add a khugepaged collapse hint framework in this patchset. The caller can
> > call khugepaged_add_collapse_hint() to add hints for khugepaged to make it
> > prioritize collapsing these specific address we found before doing Round-Robin
> > scanning. Each mm_slot which belongs to a mm_struct in the previous
> > mm_slots_hash is now a khugepaged_mm_slot, it comprises the old mm_slot
> > struct and a number of NR_KHUGEPAGED_PRIORITY_LEVEL struct
> > khugepaged_collapse_requests. The request struct for each mm_struct will
> > be put in the global struct khugepaged_priority_queue with respect to its
> > priority when __khugepaged_enter() is called on this mm (we give each mm request
> > structs for hint dispersion and balancing across all the mm_structs that will
> > be added in the future patches), and all the hints will be put in these request
> > structs. Each hint will have the target address and the target vma struct. An
> > example of the framework is like below:
> >
> > global collapse hints queues:
> > prio 0 ------()----------------------------------()---------------
> >             mm_slot0(process A)                mm_slot1(process B)
> >                |                                               |
> >            hint0---hint1---hint2---hint3       hint4---hint5---hint6
> >
> > prio 1 ------()----------------------------------()---------------
> >             mm_slot0(process A)                mm_slot1(process B)
> >                |                                               |
> >              -------                                       hint7---hint8
> >
> > The khugepaged will try to scan queues from highest priority (which is prio 0 in
> > the graph above) to the lowest priority (which is prio 1 in the graph), then go
> > through the list, and check out all the struct khugepaged_mm_slot (which are the
> > mm_slot0 and mm_slot1 in the graph above), so it will start from mm_slot0 in queue
> > of priority 0. Then khugepaged will scan all the hints listed in the slot (hint0 ~
> > hint3 in the above graph). After handling one hint (no mater success or fail on
> > collapsing), the hint will be deleted. If one khugepaged_mm_slot doesn't have any
> > hints in it, khugepaged will skip it and scan the next mm_slot in the same priority;
> > if there is no hint in the queue of prio 0 anymore, khugepaged will scan the ones
> > of prio 1; if there is no hint in any prio queues, it will fallback to do Round-Robin
> > scanning like before.
> >
> > khugepaged_add_collapse_hint() is for adding hints, and it only gets called
> > by walk_mm() and lru_gen_look_around() right now. In the future we may
> > call it in more scenorios when we found hot memory areas. For example: in damon.
> >
> > We tested the performance by using valkey-server (based on redis) together with
> > memtier_benchmark to simulate a gauss distribution on the get/set operations on
> > a 160G, 64core x86 VM. The dataset is about 3G. After preloading db, the testing
> > parameter was like below:
> > memtier_benchmark -s 127.0.0.1 -p 6379 \
> >       --ratio=1:1 \
> >       --key-pattern=G:G \
> >       --key-minimum=1 --key-maximum=3000000 \
> >       --key-median=2000000 \
> >       --key-stddev=150000 \
> >       -d 1024 \
> >       -t 1 -c 10 \
> >       -n 2500000 \
> >       --pipeline=32 \
> >       --hide-histogram
> >
> > Since we wanted to see the influence of khugepaged collapse hints on the reduction of
> > tlb misses, we made khugepaged do scanning every 1 second, and used the userspace
> > interface to do walk_mm() for the cgroup which valkey-server was set into every 2 seconds.
> > We made sure the server was all 4k pages before we run test, and only khugepaged could
> > collapse them into large folios. We enable the anonymous THP of order 9, which is pmd
> > size in most setup. We used perf stat to monitor the tlb misses statistics.
> >
> > After repeated tests, we could see dTLB-load-misses with a 13.50% reduction, and saw
> > dTLB-store-misses with a 5% reduction compared to the setup without any collapse
> > hint. The final throughput for the memtier_benchmark was about 2% to 5% improvement
> > on average, which was not that obvious compared to the tlb miss reduction. We believed
> > that was because there were too many factors to influence the final result of a random
> > redis test, so the influence of tlb misses to the final throughput were compromised by
> > other factors.
> >
> > Patch Details:
> > ========
> > * Patch 1 is to add the basic khugepaged hint framework like we introduced
> >   above. Details can be seen in the commit itself and the comments in the
> >   codes.
> > * Patch 2 is to add a slab_cache for khugepaged_collapse_hint which can
> >   improve the performance of allocating and freeing the hints.
> > * Patch 3 is to add a deduplication machanism for the hints so that we will
> >   not add a hint that points to a repeated address.
> > * Patch 4 is to add the accounting for successful collapses initiated by
> >   hint or non-hint.
> > * Patch 5 is to add the collapse hint in lru_gen_look_around() and walk_mm()
> >   of mglru.
> >
> > Thanks for reading. Comments and suggestions are very welcome!
> >
> > Signed-off-by: Luka Bai <lukabai@tencent.com>
> > ---
> > Luka Bai (5):
> >       mm/khugepaged: add framework for khugepaged collapse hint
> >       mm/khugepaged: use slab cache instead of normal kmalloc
> >       mm/khugepaged: add deduplication when adding new collapse hint
> >       mm/khugepaged: add accounting for successful hint or non-hint collapse
> >       mm/khugepaged: add khugepaged collapse hint in mglru reference checking
> >
> >  include/linux/huge_mm.h    |   2 +
> >  include/linux/khugepaged.h |  20 ++
> >  include/linux/mmzone.h     |  17 +-
> >  mm/huge_memory.c           |   4 +
> >  mm/khugepaged.c            | 460 ++++++++++++++++++++++++++++++++++++++++++++-
> >  mm/rmap.c                  |  27 ++-
> >  mm/vmscan.c                |  33 +++-
> >  7 files changed, 549 insertions(+), 14 deletions(-)
> > ---
> > base-commit: e1af79f3291a268adf4e149e1faba3052743e898
> > change-id: 20260530-thp_collapse_hint-ec92bd943797
> >
> > Best regards,
> > --
> > Luka Bai <lukabai@tencent.com>
> >

