Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06504CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 09:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308346B00B9; Mon,  8 Jun 2026 05:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9456B00BB; Mon,  8 Jun 2026 05:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7C56B00BC; Mon,  8 Jun 2026 05:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05F126B00B9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 05:17:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 863641A09C0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:17:50 +0000 (UTC)
X-FDA: 84856193100.17.EDE7B45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D51F1140011
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 09:17:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWRw+Jgk;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780910269;
	b=2F5WARtKM1XC+j4Aj15uMlr45L6BBg/6SH99kFssWKc4hoqb2CGU+AvhvQXZTgA9Ozz2sx
	zjwshUY1GHtiiwT7OMAL1AUOb5HbS6hlwQT5L6N2s5vOddK6f7VEB/UiCwqcWxzIBRD+NY
	MucC2a0eOdzsPkB/mFLGebz3+zL8Fho=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XWRw+Jgk;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780910269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWkbOCUouHYbjTzgX3pi8tqFj79tIjOcod31gQxx/8o=;
	b=OAp1FijFmUcoFncMGx4lVxurDhrDOB0BJPRW62WVm1r8cSVpdnkaU9FBLB0L+YPH1al5lS
	1g1yL26IYd2CNlXSUl2KIYYKNHrs5MhJREaPvWPYMEgGeQCWGYsOHZ5FTrzHnDtVkGv3ub
	YdmxyZdAe4Y5x76LALbFGq7ijHOLDR8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B03843EFA;
	Mon,  8 Jun 2026 09:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB301F00893;
	Mon,  8 Jun 2026 09:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780910268;
	bh=SWkbOCUouHYbjTzgX3pi8tqFj79tIjOcod31gQxx/8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XWRw+JgkvfexbmhfrqCaFr7n4VEVXXvO/Kr05lIcuW0IVPItm1t2lsQQmCURkSiL5
	 Pjb0l19a29lbWN/2YYWP2irdwFiGf/xS4hSarz/yoT/pfxQNNoE9TngZHp2mc+r2zi
	 4Xut9YjZUP63SqjWx3J2u2PwH1VgDAv+daetG6xglzIlywLebcbnEj99vgUutWGsw9
	 +6/bM0lNcEtPsNiTC+UPBTxhfDVMn5HE86k/e880t4W60wgs7H4SNC6hbwTBQTc/2v
	 S+b/7xgF038VzbneOrN1pV4zFcug3u1V8cB5Y0Vu/++9d176HriqoW2V0FImOY7ETK
	 f8IRdRuqeJpYg==
Date: Mon, 8 Jun 2026 10:17:34 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <aiaHd3T42XyB3UBn@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Rspamd-Queue-Id: D51F1140011
X-Stat-Signature: c9knwgn8mx8zpcpu9egusknb581bs5ug
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780910268-747492
X-HE-Meta: U2FsdGVkX18l3z0wDolyEgMbjgT8ivVH/hLOAe7Vu6wADA10ytMnh0seIDn5IkdQmgdqPv9rKuBbCdENkFH29QmcVXuV56nKMnmJ2H1mEjSWhe/buYTSmyBXRIGObawPRWtmiQSIMGpOc6qg8GNDDhhNrMuObQ/OmhN8ROpoyEcQR4noEs1EWfzJIZLKgNjW5eHMj/XO+xSQSEc6siJ4PfY7+a86jfvpW6BR7vJjFjPvepaX9ckgNx7KB4YUCw9fIfxyvwD/QBNMbpr/HPfosDkuXwlErbfbdSLzZU4o3BD505jU8WmUm9PpnkXACUT+hvhc9sn9EgpUyPW1uNn9l6WPM7lyNnI5EcK3uSNBT2fRlqQl/z9X2Qelz0mDV95oC8g6N9CqCXETVc/vF789xexqm1cBHWEp65pH6SnFyZWWtIhDsgg++PGwvJE7jEE6pHqNowkQXRp84yKqYHpHZ27ZXlGRVskkccRzdtR4J8LAYEc4t2TcWVk8YRlFmUcbQFGqSQ+QRbo8kT1l41TRMVNCDjIJTL6ZvCnIOJcH84mk8COTpJhiJ07zBG0LQM8JlFXp566fbn5oLUYmFnVx+5+PH1gQ5laEqo59J4w+5h/GWXK9RR+mVqe7whhtMYdjQ0mr9oSTLPpOOe+B3CioM9bQ9eIAQo+nTSDZc/0eVRHV5MnAmPJT1QVopPb7XCmrVbbELfigv5DcYmuHeTePKaavX8LFrDNpAB8IjbyJ9c4IelFZW/IRbA6pW6b9laffDSlnqotNvSQx8lWBw9Sc8pVuhKV+2a+z9a6wEfNWFBIuHsjBz+wlckqJpzFkgf2HSL1AmqIyPuYbfa9q93z4hC0KWDHGNyIRuARhcZHPwMPh+mFBnMKDch1nIwJjD1os484/rKMw3X9Qdyw55vcWzMZznwcXwDSe2pZZKjUlrRuaHda8N0gNiYatQfNe47NykJwqkjI4kTs0K4kbvha
 YZj7dKgn
 NTPEUjhykxPF9x11gaDmYwwdZrY0xDEJGUU4lGmHBDGAkPG/1meqa7hwv6iEjU7So8Qi58Dt9RPu5KNPyMWRTHZ2zzB8b5Bqk6X7VxHF/Z9Ov5W5jqJHpAUQQa/oTNo+Gc2jkTrSKzDcgGuyQ1oh+Ca1Y41/Ygaq/G55QOl6qnt6db/KXkX8hHDac43z+zBN6GLklGBpcVdMTzHCUAhRK8ATpyQbktRvQUoKG8mDstP1nYNO3RGLgh/vVOyLYME4kT8LJs0Mj5v16gsGPdCkfDVOSylw1VcSKiIjcyrLl+xzYFTVdxnQEzzVkIzk0VHd+smywwCMClGcuJVZhRBXnYKlsXFRDuEH8i+er6QQxKfldbVyF94E32yL90A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:33:46AM -0400, Michael S. Tsirkin wrote:
> Further, on architectures with aliasing caches, upstream with init_on_alloc
> double-zeros user pages: once via kernel_init_pages() in
> post_alloc_hook, and again via clear_user_highpage() at the
> callsite (because user_alloc_needs_zeroing() returns true).
> This series eliminates that double-zeroing by moving the zeroing
> into the post_alloc_hook + propagating the "host
> already zeroed this page" information through the buddy allocator.
>
> For page reporting, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED (bit 6)
> is used. For the inflate/deflate path,
> VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE (bit 7) is used.
>
> Virtio spec: https://lore.kernel.org/all/cover.1778140241.git.mst@redhat.com
>
> Based on v7.1-rc6.  When applying on mm-unstable, two conflicts
> are expected:
> - kernel_init_pages() was renamed to clear_highpages_kasan_tagged()
>   in mm-unstable.  Use clear_highpages_kasan_tagged() in the
>   post_alloc_hook else branch.
> - FPI_PREPARED uses BIT(3) in mm-unstable.  Bump FPI_ZEROED to
>   BIT(4).
> Build-tested on mm-unstable at e9dd96806dbc:
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git zero-mm-unstable
>
> Patches 1-5: fixes/cleanups, dependencies of the zeroing patches.
> Patches 6-9: thread user_addr through page allocator, contig API,
>   and gigantic hugetlb allocation.
> Patches 10-16: folio_zero_user in post_alloc_hook, vma_alloc_zeroed
>   conversion, raw fault address threading.
> Patches 17-24: PG_zeroed flag, aliasing guard, buddy merge/split
>   tracking, FPI_ZEROED optimization, folio_put_zeroed.
> Patches 25-27: __GFP_ZERO callsite conversions (alloc_anon_folio,
>   vma_alloc_anon_folio_pmd) with memcg charge failure mitigation.
> Patches 28-29: hugetlb __GFP_ZERO + HPG_zeroed.
> Patches 30-35: page reporting zeroing (DEVICE_INIT_REPORTED),
>   disable indirect descriptors.
> Patches 36-37: inflate/deflate zeroing (DEVICE_INIT_ON_INFLATE).

This seems far too much for one series.

YOu're doing a bunch of mm stuff that seems relatively independent, then
putting the virtio stuff on top.

I think this should be broken out into separate series laying foundations
rather than doing it all in one go, which is also difficult for review
purposes.

Adding a new folio flag is contentious also for instance, we maybe want to
go bit-by-bit and ensure that each foundational element is acceptable
before doing the next bit rather than having it as part of a big series.

Looking through the changelog only adds to this feeling! Huge numbers of
changes, even relatively recently and I'm not sure all relevant maintainers
in mm have had a look through either.

Thanks, Lorenzo

>
> -------
>
> Performance with THP enabled on a 2GB VM, 1 vCPU, allocating
> 256MB of anonymous pages:
>
>   metric         baseline            optimized           delta
>   task-clock     232 +- 20 ms        51 +- 26 ms         -78%
>   cache-misses   1.20M +- 248K       288K +- 102K        -76%
>   instructions   16.3M +- 1.2M       13.8M +- 1.0M       -15%
>
> With hugetlb surplus pages:
>
>   metric         baseline            optimized           delta
>   task-clock     219 +- 23 ms        65 +- 34 ms         -70%
>   cache-misses   1.17M +- 391K       263K +- 36K         -78%
>   instructions   17.9M +- 1.2M       15.1M +- 724K       -16%
>
> Two flags track known-zero pages:
>   PG_zeroed (aliased to PG_private) marks buddy allocator pages that
>   are known to contain all zeros, either because the host zeroed
>   them during page reporting, or because they were freed via the
>   balloon deflate path.  It lives on free-list pages and is consumed
>   by post_alloc_hook() on allocation.
>   HPG_zeroed (stored in hugetlb folio->private bits) serves the same
>   purpose for hugetlb pool pages, which are kept in a pool and may
>   be zeroed long after buddy allocation, so PG_zeroed (consumed at
>   allocation time) cannot track their state.
>
> PG_zeroed lifecycle:
>
>   Sets PG_zeroed:
>   - page_reporting_drain: on reported pages when host zeroes them
>   - __free_pages_ok / __free_frozen_pages: when FPI_ZEROED is set
>     (balloon deflate path)
>   - buddy merge: on merged page if both buddies were zeroed
>   - expand(): propagate to split-off buddy sub-pages
>
>   Clears PG_zeroed:
>   - __free_pages_prepare: clears all PAGE_FLAGS_CHECK_AT_PREP flags
>     (PG_zeroed included), preventing PG_private aliasing leaks
>   - rmqueue_buddy / __rmqueue_pcplist: read-then-clear, passes
>     zeroed hint to prep_new_page -> post_alloc_hook
>   - __isolate_free_page: clear (compaction/page_reporting isolation)
>   - compaction, alloc_contig, split_free_frozen: clear before use
>   - buddy merge: clear both pages before merge, then conditionally
>     re-set on merged head if both were zeroed
>
> HPG_zeroed lifecycle (hugetlb pool pages, stored in folio->private):
>
>   Sets HPG_zeroed:
>   - alloc_surplus_hugetlb_folio: after buddy allocation with
>     __GFP_ZERO, mark pool page as known-zero
>
>   Clears HPG_zeroed:
>   - free_huge_folio: page was mapped to userspace, no longer
>     known-zero when it returns to the pool
>   - alloc_hugetlb_folio: cleared unconditionally on output
>   - alloc_hugetlb_folio_reserve: cleared after checking
>
> - The optimization is most effective with THP, where entire 2MB
>   pages are allocated directly from reported order-9+ buddy pages.
>   Without THP, only ~21% of order-0 allocations come from reported
>   pages due to low-order fragmentation.
> - Persistent hugetlb pool pages are not covered: when freed by
>   userspace they return to the hugetlb free pool, not the buddy
>   allocator, so they are never reported to the host.  Surplus
>   hugetlb pages are allocated from buddy and do benefit.
>
> - PG_zeroed is aliased to PG_private.  __free_pages_prepare() clears it
>   (preventing filesystem PG_private from leaking as false PG_zeroed).
>   FPI_ZEROED re-sets it after prepare for balloon deflate pages.
>   Is aliasing PG_private acceptable, or should a different bit be used?
>
> - With __GFP_ZERO, the folio is zeroed before mem_cgroup_charge().
>   If the charge fails (cgroup at limit), the zeroing work is wasted
>   and the folio is freed and retried at a smaller order.  Previously,
>   zeroing was done after a successful charge.  This is inherent to
>   the __GFP_ZERO approach.  Is this acceptable?
>
> - On architectures with aliasing caches, upstream with init_on_alloc
>   double-zeros user pages: once via kernel_init_pages() in
>   post_alloc_hook, and again via clear_user_highpage() at the
>   callsite (because user_alloc_needs_zeroing() returns true).
>   Our patches eliminate this by zeroing once via folio_zero_user()
>   in post_alloc_hook.  Not a critical fix (people who set init_on_alloc
>   know they are paying performance) but a nice cleanup anyway.
>
> Test program:
>
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <string.h>
>   #include <sys/mman.h>
>
>   #ifndef MADV_POPULATE_WRITE
>   #define MADV_POPULATE_WRITE 23
>   #endif
>   #ifndef MAP_HUGETLB
>   #define MAP_HUGETLB 0x40000
>   #endif
>
>   int main(int argc, char **argv)
>   {
>       unsigned long size;
>       int flags = MAP_PRIVATE | MAP_ANONYMOUS;
>       void *p;
>       int r;
>
>       if (argc < 2) {
>           fprintf(stderr, "usage: %s <size_mb> [huge]\n", argv[0]);
>           return 1;
>       }
>       size = atol(argv[1]) * 1024UL * 1024;
>       if (argc >= 3 && strcmp(argv[2], "huge") == 0)
>           flags |= MAP_HUGETLB;
>       p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);
>       if (p == MAP_FAILED) {
>           perror("mmap");
>           return 1;
>       }
>       r = madvise(p, size, MADV_POPULATE_WRITE);
>       if (r) {
>           perror("madvise");
>           return 1;
>       }
>       munmap(p, size);
>       return 0;
>   }
>
> Test script (bench.sh):
>
>   #!/bin/bash
>   # Usage: bench.sh <size_mb> <iterations> [huge]
>   # Feature negotiation (DEVICE_INIT_REPORTED/ON_INFLATE) is
>   # handled by QEMU command line flags,
>   SZ=${1:-256}; ITER=${2:-10}; HUGE=${3:-}
>   FLUSH=/sys/module/page_reporting/parameters/flush
>   CSV=/tmp/perf.csv
>   rmmod virtio_balloon 2>/dev/null
>   insmod /mnt/share/virtio_balloon.ko
>   echo 512 > $FLUSH
>   [ "$HUGE" = "huge" ] && echo $((SZ/2)) > /proc/sys/vm/nr_overcommit_hugepages
>   rm -f $CSV
>   echo "=== sz=${SZ}MB iter=$ITER $HUGE ==="
>   for i in $(seq 1 $ITER); do
>       echo 3 > /proc/sys/vm/drop_caches
>       echo 512 > $FLUSH
>       perf stat -e task-clock,instructions,cache-misses \
>           -x, -o $CSV --append -- /mnt/share/alloc_once $SZ $HUGE
>   done
>   [ "$HUGE" = "huge" ] && echo 0 > /proc/sys/vm/nr_overcommit_hugepages
>   rmmod virtio_balloon
>   awk -F, '/^#/||/^$/{next}{v=$1+0;e=$3;gsub(/ /,"",e);s[e]+=v;ss[e]+=v*v;n[e]++}
>   END{for(e in s){a=s[e]/n[e];d=sqrt(ss[e]/n[e]-a*a);printf "  %-16s %10.0f +- %8.0f (n=%d)\n",e,a,d,n[e]}}' $CSV
>
> Compile and run:
>   gcc -static -O2 -o alloc_once alloc_once.c
>   bash bench.sh 256 10            # regular pages
>   bash bench.sh 256 10 huge       # hugetlb surplus
>
> Note about Sashiko (sashiko.dev) false positives:
>   Sashiko's mm-alloc guideline says "Any optimization replacing
>   clear_user_highpage() with __GFP_ZERO is wrong on [cache-aliasing]
>   architectures". This is correct for mainline but not for this
>   series, which threads user_addr through the allocator so that
>   post_alloc_hook() calls folio_zero_user() with the dcache flush.
>   Suggested guideline update: add "unless the caller passes a
>   valid user address (i.e. not USER_ADDR_NONE) to vma_alloc_folio(),
>   alloc_contig_frozen_pages_user() etc., which reaches
>   post_alloc_hook() for the dcache flush".
>
> Pre-existing bugs found during review (not fixed, not made worse):
>   - do_swap_page() returns VM_FAULT_OOM on large-folio swapin race
>     instead of retrying.
>   - free_huge_folio() called with refcount==1 on
>     mem_cgroup_charge_hugetlb failure.
>   - memfd_alloc_folio() double-decrements resv_huge_pages on error.
>   - wait_event in virtballoon_free_page_report hangs on broken
>     virtqueue (pre-existing, same as old single-buffer code).
>   - tell_host() GFP_KERNEL under balloon_lock risks OOM deadlock.
>
> Changes since v9:
> - Fix W=1 kerneldoc warning on alloc_contig_frozen_pages_user_noprof.
> - Fix link error on !MMU configs (m68k, arm allnoconfig): move
>   folio_zero_user stub to new mm/folio_zero.h header.
> - Reorder patches: move PG_zeroed tracking and folio_put_zeroed
>   before __GFP_ZERO conversions, allowing folio_put_zeroed to
>   handle memcg charge failures.
> - Better handle memcg charge failures.
>
> Changes since v8 (address Sashiko v8 review findings):
> - Fix mempolicy interleave: combine vm_pgoff and VMA offset into
>   a single expression before shifting, fixing carry loss for
>   file-backed VMAs with unaligned vm_pgoff.
> - Fix memory-failure: wrap ClearPageHWPoison in retry path with
>   zone->lock (same race as TestSetPageHWPoison).
> - Fix stale comment: "folio_zero_user writes" -> "page zeroing"
>   in huge_memory.c __folio_mark_uptodate comment.
> - Drop rounddown_pow_of_two for page reporting capacity (no-op
>   for compiler optimization, halves batch size for non-power-of-2).
> - Reorder: move "mm: balloon: use put_page_zeroed" before
>   "virtio_balloon: implement DEVICE_INIT_ON_INFLATE" so the
>   ClearPageZeroed handling is in place before any page gets
>   the flag set.
> - Various commit log improvements (PowerPC note in aliasing
>   patch, memory-failure note about other HWPoison calls,
>   wording fixes).
>
> Changes since v7 (address Sashiko AI review findings):
> - Fix dcache flush on VIPT aliasing architectures: add
>   user_alloc_needs_zeroing() guard in post_alloc_hook to force
>   folio_zero_user for user pages when cache aliasing requires it.
>   Host-zeroed pages excluded (!zeroed).  Optimization preserved.
> - Fix folio_zero_user stub: replace macro with non-inline function
>   in mm/memory.c to avoid double-evaluation and missing include.
> - Fix C89 declaration-after-statement in free_huge_folio.
> - Fix CMA __GFP_ZERO: pass through to cma_alloc_frozen_compound
>   so HPG_zeroed accurately reflects whether page was zeroed.
> - Fix big-endian bitmap: use test_bit_le() for inflate_bitmap.
> - Fix migratepage: clear PageZeroed on old page before deflation.
> - Fix page_reporting flush: overflow-safe loop, add -EINTR on
>   signal, add code comment explaining double flush_delayed_work.
> - Add atomic ClearPageZeroed (CLEARPAGEFLAG) for balloon migration
>   path where zone->lock is not held.
> - Add VM_WARN_ON_ONCE for order>0 without __GFP_COMP in
>   post_alloc_hook (folio_zero_user requires compound metadata).
> - Add _noprof pattern for vma_alloc_zeroed_movable_folio to
>   preserve memory allocation profiling attribution.
> - Add PageReported propagation in split_large_buddy (was missing
>   from patch 2).
> - Add FPI_ZEROED guard: skip PageZeroed when page_poisoning
>   enabled and init_on_free disabled (poison overwrites zeroes).
> - Add DMA alignment comment for inflate_bitmap (ACCESS_PLATFORM
>   cleared, so not needed now).
> - Restore tell_host comment explaining vq buffer assumption.
> - Various code comments documenting design decisions.
> - Drop __GFP_ZERO from gather_surplus_pages: avoid shifting
>   zeroing from fault time to reservation time (mmap/fallocate).
>   Pool pages are zeroed at fault time via alloc_hugetlb_folio.
>   Fresh surplus allocations at fault time still benefit from
>   __GFP_ZERO + HPG_zeroed.
> - New patch: add alloc_contig_frozen_pages_user API with user_addr
>   for cache-friendly zeroing in the contiguous allocation path.
> - New patch: thread user_addr through gigantic hugetlb allocation
>   via alloc_contig_frozen_pages_user.
> - New patch: replace user_alloc_needs_zeroing() with aliasing-only
>   checks (cpu_dcache_is_aliasing || cpu_icache_is_aliasing) in the
>   post_alloc_hook guard.  Avoids redundant re-zero on non-aliasing.
> - New patch: serialize TestSetPageHWPoison with zone->lock in
>   memory_failure to fix pre-existing race with non-atomic buddy
>   flag operations (e.g. page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP).
> - New patch: disable VIRTIO_RING_F_INDIRECT_DESC in balloon to
>   prevent GFP_KERNEL allocation under balloon_lock (OOM deadlock).
> - New patch: skip kernel_init_pages for FPI_ZEROED when page
>   poisoning is not enabled (page already zero, skip redundant work).
>
> Also since v7 (address review by Gregory Price):
> - Drop from_pool bool in alloc_hugetlb_folio: use
>   folio_test_hugetlb_zeroed directly.  HPG_zeroed is set by
>   alloc_surplus_hugetlb_folio for fresh allocations, so the
>   check handles both pool and fresh pages.
> - Drop bool *zeroed output parameter from alloc_hugetlb_folio:
>   sink zeroing inside the function.  When __GFP_ZERO is set and
>   !folio_test_hugetlb_zeroed, call folio_zero_user internally.
> - Rename addr to user_addr in alloc_hugetlb_folio, align
>   internally with huge_page_mask.
> - Add Reviewed-by: Gregory Price tags on reviewed patches.
>
> New patches since v7:
> - mm: memory-failure: serialize TestSetPageHWPoison with zone->lock
> - mm: add alloc_contig_frozen_pages_user for cache-friendly zeroing
> - mm: hugetlb: thread user_addr through gigantic page allocation
> - mm: page_alloc: use aliasing checks instead of
>   user_alloc_needs_zeroing
> - virtio_balloon: disable indirect descriptors
> - mm: page_alloc: skip kernel_init_pages for FPI_ZEROED when safe
>
> Changes since v6 (address review by Gregory Price):
> - Rework hugetlb: use gfp_t parameter instead of bool zero /
>   bool *zeroed.  Sink zeroing inside alloc_hugetlb_folio().
>   Pass raw fault address (user_addr) for cache-friendly zeroing
>   on both pool-page and fresh allocation
>   paths.  (Suggested by Gregory Price)
> - Reorder compaction_alloc_noprof() to call prep_compound_page
>   before post_alloc_hook for consistency.
>   (Suggested by Gregory Price)
> - Reorder: interleave fix first, PageReported propagation and
>   capacity fix moved to front as dependencies.
> - Add USER_ADDR_NONE comments in mmap.c and internal.h explaining why -1 is
>   never a valid userspace address.
> - Fix err uninitialized warning in virtballoon_free_page_report().
> - Lots of commit log tweaks.
>
> Also in v7:
> - Fix hugetlb pool page zeroing to use vmf->real_address
>   (the actual faulting subpage) instead of vmf->address
>   (hugepage-aligned), preserving cache-friendly zeroing
>   locality that upstream had at the callsite.
> - Remove dead/broken alloc_hugetlb_folio !CONFIG_HUGETLB_PAGE
>   stub (returned NULL but callers check IS_ERR).
>
> Changes since v5:
> - Rebased onto v7.1-rc2.
> - Split alloc_anon_folio and alloc_swap_folio raw fault address
>   changes into separate patches.
> - In virtio, move PAGE_POISON check for DEVICE_INIT_REPORTED
>   from probe() to validate(), clearing the feature instead of
>   just gating host_zeroes_pages.  Same for confidential
>   computing check.
> - Fix bisectability: FPI_ZEROED definition and usage now in
>   the same patch.
> - Lots of commit log tweaks.
> - Reorder: REPORTED before ON_INFLATE.
> - Kerneldoc fixes.
>
> Changes since v4:
> With virtio spec posted, update to latest spec:
> - Add VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED (bit 6) for reporting.
> - Add VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE (bit 7) for inflate.
> - Per-page virtqueue submission, per-page used_len feedback.
> - Balloon migration preserves PageZeroed hint.
> - Page_reporting capacity bugfix for small virtqueues.
> - PG_zeroed propagation in split_large_buddy.
> - Disable both features for confidential computing guests.
> - Gate host_zeroes_pages on PAGE_POISON/poison_val: when PAGE_POISON
>   is negotiated with non-zero poison_val, device fills with poison
>   not zeros, so host_zeroes_pages must be false.
> - Disable ON_INFLATE when PAGE_POISON with non-zero poison_val.
> - Bound inflate bitmap reads by used_len from device.
> - Move ON_INFLATE poison_val check to validate() for proper
>   feature negotiation.
> - Fix NUMA interleave index for unaligned VMA start (new patch 1).
> - Drop vma_alloc_folio_user_addr: with the ilx fix, callers can
>   pass raw fault address to vma_alloc_folio directly.
> - Tested with DEBUG_VM, INIT_ON_ALLOC/FREE enabled.
>
> Changes since v3 (address review by Gregory Price and David Hildenbrand):
> - Keep user_addr threading internal: public APIs (__alloc_pages,
>   __folio_alloc, folio_alloc_mpol) are unchanged.  Only internal
>   functions (__alloc_frozen_pages_noprof, __alloc_pages_mpol) carry
>   user_addr.  This eliminates all API churn for external callers.
> - Add vma_alloc_folio_user_addr() (2/22) to separate NUMA policy
>   address from the zeroing hint address.  Fixes NUMA interleave
>   index corruption when passing unaligned fault address for
>   higher-order allocations.
> - Add per-page zeroed_bitmap to page_reporting_dev_info (17/22).
>   The driver's report() callback manages the bitmap.  Drain
>   checks it gated by the host_zeroes_pages static key.  This
>   matches the proposed virtio balloon extension at
>   https://lore.kernel.org/all/cover.1776874126.git.mst@redhat.com/
> - Clear PG_zeroed in __isolate_free_page() to prevent the aliased
>   PG_private flag from leaking to compaction/alloc_contig paths.
> - Do not exclude PG_zeroed from PAGE_FLAGS_CHECK_AT_PREP macro.
>   Instead, __free_pages_prepare() clears it (preventing filesystem
>   PG_private leaking as false PG_zeroed), and FPI_ZEROED sets it
>   after prepare.  Only buddy merge assertion is relaxed.
> - Initialize alloc_context.user_addr in alloc_pages_bulk_noprof.
> - Deflate and hugetlb changes are much smaller now.  Still, the
>   patchset can be merged gradually, if desired.
>
> Changes since v2 (address review by Gregory Price and David Hildenbrand):
> - v2 used pghint_t / vma_alloc_folio_hints API.  v3 switches to
>   threading user_addr through the page allocator and using __GFP_ZERO,
>   so post_alloc_hook() can use folio_zero_user() for cache-friendly
>   zeroing when the user fault address is known.
> - Use FPI_ZEROED to set PG_zeroed after __free_pages_prepare() instead
>   of runtime masking in __free_one_page (further refined in v4).
> - Drop redundant page_poisoning_enabled() check from mm core free
>   path, already guarded at feature negotiation time in
>   virtio_balloon_validate.  The balloon driver keeps its own
>   page_poisoning_enabled_static() check as defense in depth.
> - Split free_frozen_pages_zeroed and put_page_zeroed into separate
>   patches.  David Hildenbrand indicated he intends to rework balloon
>   pages to be frozen (no refcount), at which point put_page_zeroed
>   (21/22) can be dropped and the balloon can call
>   free_frozen_pages_zeroed directly.
> - Use HPG_zeroed flag (in hugetlb folio->private) for hugetlb pool
>   pages instead of PG_zeroed, since pool pages are zeroed long after
>   buddy allocation and PG_zeroed is consumed at allocation time.
> - syzbot CI found a PF_NO_COMPOUND BUG in the v2 pghint_t approach
>   where __ClearPageZeroed was called on compound hugetlb pages in
>   free_huge_folio.  The v3 HPG_zeroed approach avoids this.
> - Remove redundant arch vma_alloc_zeroed_movable_folio overrides
>   on x86, s390, m68k, and alpha (12/22). Suggested by David
>   Hildenbrand.
> - Updated benchmarking script to compute per-run avg +- stddev
>   via awk on CSV output.
>
> Changes v1->v2:
> - Replaced __GFP_PREZEROED with PG_zeroed page flag (aliased PG_private)
> - Added pghint_t type and vma_alloc_folio_hints() API
> - Track PG_zeroed across buddy merges and splits
> - Added post_alloc_hook integration (single consume/clear point)
> - Added hugetlb support (pool pages + memfd)
> - Added page_reporting flush parameter for deterministic testing
> - Added free_frozen_pages_hint/put_page_hint for balloon deflate path
> - Added try_to_claim_block PG_zeroed preservation
> - Updated perf numbers with per-iteration flush methodology
>
> Written with assistance from Claude (claude-opus-4-6).
> Reviewed by cursor-agent (GPT-5.4-xhigh).
> Everything manually read, patchset split and commit logs edited manually.
>
>
> Michael S. Tsirkin (37):
>   mm: mempolicy: fix interleave index calculation
>   mm: memory-failure: serialize TestSetPageHWPoison with zone->lock
>   mm: page_alloc: propagate PageReported flag across buddy splits
>   mm: page_reporting: allow driver to set batch capacity
>   mm: hugetlb: remove dead alloc_hugetlb_folio stub
>   mm: move vma_alloc_folio_noprof to page_alloc.c
>   mm: thread user_addr through page allocator for cache-friendly zeroing
>   mm: add alloc_contig_frozen_pages_user for cache-friendly zeroing
>   mm: hugetlb: thread user_addr through gigantic page allocation
>   mm: add folio_zero_user stub for configs without THP/HUGETLBFS
>   mm: page_alloc: move prep_compound_page before post_alloc_hook
>   mm: use folio_zero_user for user pages in post_alloc_hook
>   mm: use __GFP_ZERO in vma_alloc_zeroed_movable_folio
>   mm: remove arch vma_alloc_zeroed_movable_folio overrides
>   mm: alloc_anon_folio: pass raw fault address to vma_alloc_folio
>   mm: alloc_swap_folio: pass raw fault address to vma_alloc_folio
>   mm: page_reporting: skip redundant zeroing of host-zeroed reported
>     pages
>   mm: page_alloc: use aliasing checks instead of
>     user_alloc_needs_zeroing
>   mm: page_alloc: clear PG_zeroed on buddy merge if not both zero
>   mm: page_alloc: preserve PG_zeroed in page_del_and_expand
>   mm: page_alloc: propagate PG_zeroed in split_large_buddy
>   mm: add free_frozen_pages_zeroed
>   mm: page_alloc: skip kernel_init_pages for FPI_ZEROED when safe
>   mm: add put_page_zeroed and folio_put_zeroed
>   mm: use __GFP_ZERO in alloc_anon_folio
>   mm: vma_alloc_anon_folio_pmd: pass raw fault address to
>     vma_alloc_folio
>   mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
>   mm: hugetlb: add gfp parameter and skip zeroing for zeroed pages
>   mm: memfd: skip zeroing for zeroed hugetlb pool pages
>   mm: page_reporting: add per-page zeroed bitmap for host feedback
>   virtio_balloon: submit reported pages as individual buffers
>   virtio_balloon: disable indirect descriptors
>   mm: page_reporting: add flush parameter with page budget
>   virtio_balloon: skip zeroing for host-zeroed reported pages
>   virtio_balloon: disable reporting zeroed optimization for confidential
>     guests
>   mm: balloon: use put_page_zeroed for zeroed balloon pages
>   virtio_balloon: implement VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE
>
>  arch/alpha/include/asm/page.h       |   3 -
>  arch/m68k/include/asm/page_no.h     |   3 -
>  arch/s390/include/asm/page.h        |   3 -
>  arch/x86/include/asm/page.h         |   3 -
>  drivers/virtio/virtio_balloon.c     | 177 ++++++++++++++---
>  fs/hugetlbfs/inode.c                |   3 +-
>  include/linux/cma.h                 |   3 +-
>  include/linux/gfp.h                 |  18 +-
>  include/linux/highmem.h             |  15 +-
>  include/linux/hugetlb.h             |  18 +-
>  include/linux/mm.h                  |  13 ++
>  include/linux/page-flags.h          |  11 ++
>  include/linux/page_reporting.h      |  13 ++
>  include/uapi/linux/virtio_balloon.h |   2 +
>  mm/balloon.c                        |  10 +-
>  mm/cma.c                            |   6 +-
>  mm/compaction.c                     |   9 +-
>  mm/folio_zero.h                     |  18 ++
>  mm/huge_memory.c                    |  16 +-
>  mm/hugetlb.c                        | 138 ++++++++-----
>  mm/hugetlb_cma.c                    |   4 +-
>  mm/internal.h                       |  22 ++-
>  mm/memfd.c                          |  14 +-
>  mm/memory-failure.c                 |  10 +
>  mm/memory.c                         |  19 +-
>  mm/mempolicy.c                      |  75 +++----
>  mm/mmap.c                           |   6 +
>  mm/page_alloc.c                     | 297 +++++++++++++++++++++++-----
>  mm/page_reporting.c                 |  99 ++++++++--
>  mm/page_reporting.h                 |  12 ++
>  mm/slub.c                           |   4 +-
>  mm/swap.c                           |  20 +-
>  32 files changed, 792 insertions(+), 272 deletions(-)
>  create mode 100644 mm/folio_zero.h
>
> --
> MST
>

