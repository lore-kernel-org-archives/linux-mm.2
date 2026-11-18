Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E77606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knsgeF4b
Received: by kanga.kvack.org (Postfix)
	id E51786B05BF; Wed, 18 Nov 2026 04:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01636B05C0; Wed, 18 Nov 2026 04:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9496B05C1; Wed, 18 Nov 2026 04:21:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F99C6B05BF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:21:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F8291606B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:21:12 +0000 (UTC)
X-FDA: 85447695984.16.33399D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B3F03140003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:21:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knsgeF4b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hcfafF7WXNr27PZx8i3XRebSUbFpd4N+v61QV1UymJI=;
	b=QyiQlsYFGhMiQubV8RJLMMC1z2gi1djHLxWv+fN+B/YH1VWx+U2CXUtSTDsdJo6NH7Rpi/
	y2hZSy3aazbsAGHnjH1ctP9bc+K7BXElZMDbt0b9ge4UASlxZgCy1HqVlWJX52TEHqd6fd
	AXVP70154cZLtoo9Pybyq0Q4xVidWIU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knsgeF4b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993670;
	b=2uKQ5udvePW9m7B12hgO+I8PSOqUILe/IwRsGopXkweiLiNKwoVdfFAknW2CCactf5QNA/
	ngY9eHrZj1kU7wRTqGSYx+tCOyrff9ULxzvazS1nEXOll6DP1urwpGayJORMvLnhJ94aHE
	VqM3lOsBovFmqIDhNx+6adCXa+btvDY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFCA244DE4;
	Wed, 18 Nov 2026 09:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1591F000C6;
	Wed, 18 Nov 2026 09:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794993669;
	bh=hcfafF7WXNr27PZx8i3XRebSUbFpd4N+v61QV1UymJI=;
	h=From:Subject:Date:To:Cc;
	b=knsgeF4b9Zqq2mXULZ2xDUqAb/MDVTZ+31aNGsl2OmkKsxj7SM9K/I2Lj6SDTusFD
	 9hn3x2iUPD2XD3WbebyB2J2xXayuyE73Sn3Ky9K4WLWz9BeyZWHhRnZ7+p0ohiRvFV
	 g5GLf9HbVwQ8zS+5KdLQ0diU096Vo88Bt0SPThWweEDxQwmV/wcF93W4HKjwfT9tCD
	 Bz5Xe9N9KyfO2Y9/NMR6p5PCaUrT3aRC4cy+5+H3Tqph4iONu6w6erA8A3Vet9so9g
	 tRJGA7FOrFEI0fuTpaJvs0XfYlvAt4KEugPS/Ya5RBtCLNLqKX7Eu1JHwu4ZFKcW8C
	 4EpRGHjPK/+YA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/4] mm: fixes for stale TLB entries due to delayed/batched
 TLB flushes
Date: Wed, 18 Nov 2026 10:20:35 +0100
Message-Id: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMQQrCMBAF0KuEv27ACcVqriJS2mbGjoRGMlaE0
 ruLunybt8G4Khui21D5paZlQXTUOEzzsNzYa0J0CIdwJKLWi2bupWQtveTVZt8l6tqzDGNIJzQ
 Oj8qi7195uf5t63jn6fl9sO8fqjXp1XQAAAA=
X-Change-ID: 20261114-file_folio_flush-7d1749fab2d8
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, 
 =?utf-8?q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>, 
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>, 
 Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, 
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7325; i=david@kernel.org;
 h=from:subject:message-id; bh=+XVlM1zarDt/HoTmPPZ/6LhCqrtwp0Vps9Eria3V5YE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+5r41r9qbeeLAswnm7KJNK1J4UnauMDBvn5PwZW1zT
 sqvN72CHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExEey3D/7TbJ1jt108/9L6z
 cun5WD6r4llqN/bFHdxta1lamnvapJGRYWXM4p7DnjP1Hu1T1niXlvvC/oakHv+VnPiFXzvYjkw
 RZwAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B3F03140003
X-Stat-Signature: ewdmrx81g14gy59yeknkybjzwq6qnwqi
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794993670-526301
X-HE-Meta: U2FsdGVkX19nHSLBK1eDxEa7M5cXDglWmKbtb2PcR5aBRoojclxTHZBySK3rWmkxKv3+X1UupnWxaFcPZhlFptlriQ/73UvTOaG3MNgrb8wCjfj34PZH6Hak4vwn/cJABHbscjhHSOSHIwUfiLwP6XLOBWz9INJ0yaat7iYeoMoT/0qBn4pIDWbW8Sz4J+MybZbmK7EKwGhgUcs4AeBZnu52xqf1BZMf9eBn9o/lcACYaznW7j5+cSn/lfO+C07unhN3/jHOowmG3LXC1hYPuX98HEYbOsQEBxHLx8FnR2S9CJYIYz60efNC4VBeIK0S91m1bNupK/J7wZ4nc5loRAOdVV/adkXJtnouFC4xNYp5xVUbjI9mGhxPPffeHlCDrw4cl4w4ivdkBkHZqJj6VhIi8oy2ym97bQA2LoIShUrY5so9nFuev7zMqEMf86FQVukReOk7Q54h4AwgeGq+k8DaYGYIGsjngBBH/q91OJVtBn8msgIza3BF0uBWG39D1OuQ1Ro4y6LtmGWiuZp/8mIeBtKQEzfcf5ffQohSqRr7+BGT+7fHPgyQqRxDTj+hBu97shl3TRAVvrfTllRa06VHexHrmWKYbJfWm6EFJ1i3HKfMCp03295Vow8Alw/lesuP7ctpREToX0rH2WTXQhC6zMGrlnOOUR1bKmPeMWOniSgv4UmMIzX4NXeKfNgn7Tyy1GiIGgrPDcEXmgzOPx6LQ9S5QJLzOSs9GsakutLsBsTGHgMO88GS195RGxRQ/npIjEOJkZkqntGvIHMwywa3PynQHoNIl0hWqNljGRwX56X4iOzxqWvxzNG03/nw8KlUXBbFXh7MSMxR7bI1OScuWBp0PYrB3MUV8vN6PMSg57VcVnii+qrva+G9e5aDSGv1CuhLNglhHfLCuE6S1/FG82xs06ldIaGNsjYGDwmmH+qX3EXF1/AWSFeC+l36DDKrZ70myDUmDvks67C
 hY5wY0u0
 9W4aNPWMRnUi1smQSi8QFelRrYCN2LuY9NoWxwuAOKDkYyjKW49m1Q+sUAz0SkoRD8q0IA6xeA643AsQ6YKvNeBXQczLa8dtBL+BXNEXrLOnX5q+AlwWBZQymDBLF3drc3AU3dMM7JMSpwfgjjaBdEqiIL4BBjFfk/wR+b/thsGaLheCutRME6JleAUtqy8bKBVL9n6FE4HiVLtt8xqAIPsHOZt2GVN6MAkMO8acSL6sOCaP6e/KlGdUadT+7FIjQrJeiG8o/ej79CpyKyxwNeg7oSyPc48ur+0cnkeHTilxxWpbfqRKg9eJMqgGcdJng9CVQzFeBMmytT9XTNf6JmPjrtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

David, what keeps you up at night? Well, the last 3 nights, TLB flushes.

We have two mechanisms that can delay/batch TLB flushes and cause
problems:

 (A) mmu_gather zap: we can delay TLB flushes until after dropping the
     PT lock, after having zapped PTEs and adjusted the mapcounts.

 (B) TTU_BATCH_FLUSH when used by reclaim: we can defer (batch) TLB
     flushes, after having unmapped folios and adjusted the mapcounts,
     and after having discarded lazyfree folios, removed folios from the
     page-cache/swap-cache or just dropped the folio lock.

Code that installs new folios (and doesn't just refault the old ones)
must be aware of that, otherwise we can end up with stale TLB entries
while new folios are already mapped into page tables.

So in general, whenever we install a new folio into the page tables,
we must make sure that no such stale TLB entries exist.

Even worse, whenever we replace a folio in the page-cache that might differ
content-wise from the old folio, or we end up modifying a new folio through
write(), we must make sure that no such stale TLB entries exist.

There are some exceptions (e.g., only once MADV_DONTNEED finished is when
a new read from the same address gives any guarantees), so the primary
focus is on folios that got unmapped transparently by the system, without
involving MADV_DONTNEED.

This series handles the following scenarios:

Patch #1: Zapping: flush the TLB before installing a CoW'ed folio.
          Handles CoW of a folio that is still in the page-cache.

Patch #2: Reclaim: flush deferred writable TLB entries before unlocking
          the folio. Handles writes through stale TLB entries getting
          lost when reclaim keeps a dirty folio and somebody else
          starts writeback.

Patch #3: Reclaim: don't defer TLB flushes when unmapping lazyfree
          folios. Handles mapping a new anon folio after reclaim
          discarded a lazyfree folio (do_anonymous_page(),
          migrate_vma_insert_page(), UFFDIO_COPY, UFFDIO_MOVE).

Patch #4: Reclaim: unlock unmapped folios only after the deferred TLB
          flush. Handles refaulting a new page-cache folio, CoW of a
          folio that is still in the page-cache, and swapping in a new
          folio (do_swap_page(), unuse_pte(), UFFDIO_CONTINUE). Also
          handles invalidation replacing a folio that reclaim kept, and
          write() modifying a new page-cache folio.

Patches #1 and #2 are small fixes that should be merged as soon as
possible. Patch #4 makes the flush added by patch #2 unnecessary by
keeping folios locked until the deferred TLB flush, and removes it
again.

Patches #3 and #4 are RFC, because #4 is rather intrusive and #3 comes
with a performance impact (see below). But there isn't really a good
alternative to fix these things for good that I see.

In theory, UFFDIO_COPY installing a new anon folio into a MAP_PRIVATE
shmem mapping is affected by concurrent zapping just like CoW faults in
patch #1. But the required setups (e.g., userfaultfd on a MAP_PRIVATE
mapping of a tmpfs file that backs a loop device) are so unusual that we
will leave it alone for now. Same applies to the hugetlb counterpart.

Remaining Problem
-----------------

There is one remaining known problem that is not handled by this
series:

Zapping (e.g., unmap_mapping_range()) removes the rmap of clean
page-cache folios before performing the deferred TLB flush. If the
mapcount drops to 0, a concurrent invalidation (e.g.,
invalidate_inode_pages2_range()) will skip the unmapped folio and can
remove it from the page-cache before the pending TLB flush.

A page fault (except a CoW fault, see patch #1) can then map a new folio,
or write() can modify it, while other CPUs still read the old folio through
stale TLB entries.

I think that this is low priority: it requires two concurrent invalidations
of the same file range while another process has the file mapped, and CPUs
can only read stale data until the zapper flushes the TLB; writes are never
lost.

It could maybe be fixed in the invalidation code? unmap_mapping_*() holds
the i_mmap_rwsem in read mode until it flushed the TLB, so
folio_unmap_invalidate() could briefly take it in write mode iff the folio
has unexpected references. But dropbehind (RWF_DONTCACHE) invalidates
folios on writeback completion while holding an additional reference, where
we must not sleep on the i_mmap_rwsem, so that would need some care.

Something for the future :)

Testing
-------

I threw a bunch of selftests at it and had AI generate some stress
tests, in particular for the benchmarks below. I also ran stress-ng to
force reclaim.

I managed to reproduce the issues in patch #3 and #4, as described in
the patch descriptions.

Stale reads out of 1024000 checked pages in 2000 iterations:

                               base    series
  lazyfree,  MGLRU            16242         0
  lazyfree,  classic LRU      16274         0
  swapcache, MGLRU            24076         0
  swapcache, classic LRU      23028         0

Performance Impact
------------------

I ran some benchmarks in an x86-64 VM with limited CPUs, RAM and zram
enabled. Running inside a VM might make TLB flushes more expensive, so
the results below might be a bit exaggerated. AI results below.

Classic LRU, 4 threads randomly touching a working set twice the size of
their memcg for 30 seconds. Pages touched per second:

                 base     series
  anon-rw        681k      1055k
  anon-ro       1013k      1027k
  file-ro        417k       419k
  file-rw        173k       183k
  lazyfree      1512k       333k

Swapping out dirty anon folios ("anon-rw") is about 55% faster, because
patch #4 now also batches TLB flushes of stale writable TLB entries.
That is what Zhang Peng's series [1] tried to achieve, and his work also
inspired how patch #4 locks folios again, but the used mechanism is
different.

Reclaiming clean anon folios ("anon-ro"), clean page-cache folios
("file-ro") and dirty page-cache folios ("file-rw") is not noticeably
affected.

Reclaiming lazyfree folios ("lazyfree") is about 4.5x slower, because
we stop batching TLB flushes when discarding them entirely, which seems
to be the right thing to do for now. We can look into optimizing this
separately later.

[1] https://lore.kernel.org/linux-mm/20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com/

---
David Hildenbrand (Arm) (4):
      mm: flush stale TLB entries before installing a CoW'ed folio
      mm/vmscan: flush deferred writable TLB entries before unlocking the folio
      RFC: mm/rmap: don't defer TLB flushes when unmapping lazyfree folios
      RFC: mm/vmscan: unlock unmapped folios only after the deferred TLB flush

 mm/internal.h |   5 ++
 mm/memory.c   |   6 +++
 mm/rmap.c     |  20 +++++++-
 mm/shmem.c    |   2 +-
 mm/swap.h     |   5 +-
 mm/swapfile.c |   7 ++-
 mm/vmscan.c   | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 7 files changed, 184 insertions(+), 16 deletions(-)
---
base-commit: 0c524518413094607a6178c53a65815762bc9c45
change-id: 20261114-file_folio_flush-7d1749fab2d8

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


