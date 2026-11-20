Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4BB606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nvTz9Tdx
Received: by kanga.kvack.org (Postfix)
	id DFE846B05F4; Fri, 20 Nov 2026 03:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6006B05F5; Fri, 20 Nov 2026 03:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED0A6B05F6; Fri, 20 Nov 2026 03:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE8D36B05F4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:58:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42C6DA8DDB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:17 +0000 (UTC)
X-FDA: 85454895834.18.ECB094C
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id CB579100009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:58:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nvTz9Tdx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165095;
	b=hCezMw9dGR972NXO7yaoQTr0PcxbXgORHJEuVCq1w4UoTr019eGUYm6gr0S44UZ8WiAWKc
	zRnW97COHzrRjEhczfE2qeQ5W+R7SLGTFRos55rmpdTiPj489Wg+CtbzDgprN1bOfoxAsJ
	1B9vaWgrD6myEtzURcTM1X8+quurbVM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5r4xC/O4MWxZVvHQzJ1uLFYDll58J4bpt/8UhZflL7w=;
	b=u9oIJ8UkHzZvmPJsdeDuc87Y9crfuuFS8s+Zrjzz+TMg+0kEuTxsz/xmawiPwbGRvxSs8J
	kc9yBBZvkBpWprDCCFG9lpPqAnJHLK0HGwIyx625bEbPalgt+Azs4hgj3pwaEEjBGbWJ7E
	UbS7Nw8PBMkhXclVsGqQPhadW1F8cxM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nvTz9Tdx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/832JfYZ1qzrgP568/YRuT0HkNEoTtxSbeZ18dQW4d4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795165091; v=1; x=1795769891;
 b=nvTz9TdxowBpYkk/e8j0bzX3jcNfJ9EAfceF1XrhBqyYP9dCDT1bIiXsej6burWQJBmWWJT/
 zb4GcTB0WG3kJP40ivnNwWsa+S8VmJMHztYlJ8ge2lJ/AE4cB/Yf0I2XUmQdbeLvhfnVnpFVUpL
 1+dVUFZMqrq++gybi7S6ko7M=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e8288e39601ac73e;
	Fri, 20 Nov 2026 08:58:11 +0000
X-Mizu-Trace-ID: e8288e39601ac73e
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com
Subject: [PATCH 0/4] skip empty PUD subtrees during aging with a PUD-level Bloom filter
Date: Fri, 20 Nov 2026 16:58:02 +0800
Message-ID: <20261120085806.781225-1-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB579100009
X-Stat-Signature: i8xyjyww5zjes4qzhi48jhpdxtx7hn9i
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795165094-154483
X-HE-Meta: U2FsdGVkX18cAyHCJfkW+GUWD9VCX8Iahpg4Gz4gNdOfo3uO3ymzJejNBb19PO45yPi6Qfabwp+IIYAc84NKXznV6VdpzrIsbakVcKUnitL8cOO/RinnFmnq5uBWLCOhKtlPvL4Zkb9vlAKSV0pZDHvQbs2Q9DKBFQ2qKqj2pnMHFz7nlHD7nOGsJAAEfG5d/G5tYNgs59MYvJTaCeZHsl5Gah6tuNsyktq0y6QRTX3d83Oim/AtIf9tOhLl1x1TY/7JsF8ILfarspD4mcbobTIKqOLQELep6JAgJF/CglwxYT6c5Zt+htyZ++nmMYpr4NfmUu9FdYdGGoyhdGe8zaAjkA/lKjRdsUBoyJkokKl3D+XJC+iHKqXc4p08mtE1sdpHvF09lG1lnS9gaC3+peNwEPd3m6n75dBBEfXVsMcg7exOymQXl/ceVn9hi+HqblqmXjZQUvFydscOc7xWzgutUCofdVi89XjnVcOfGQGLoJ9uPZ/fYyaf8ZQeMFMyZwvWm18cAm/zOXRsFFCUbMB9atyx2e6aFKdiS6Rti+GDeboP75jmOgUj2oU4rlfIgjYEBVuWJcRGMoo1z4e3hk+AnwVycmp6vpwJNX19k9Z24jxBqhy6cGHfMbptWAYNPZin+lyQvRg/r6U1MaNW9E6MO/ZvG6d+R0X0LNR6S6cRZsEjPIaClT0JkIdbdHnxO32LoR3PJiDfGCGevgUtio3D7YbYLB+HyC7ssb92xwxFlmO1gxByrdbiv/BhTKdiF3I3M8d1qFcnILjh1eWeMu8dXOGbueSmW8L1UjKv+4dy8mJj6G0AJ+wl3I+QW8AQusSVIKpSaDDtjVmhcyzIDXGk0pvrrAsh7LpdepDB+sQGGotmKadTI4gM/3JwrAD9oCTZ5e42x1nn0G0MCWkYvyb2Zn+Yi85A77Pdtptm0MVAfytzITXxE0FwgCyANMqwZ0Am0BcG2WnNRqwySg1
 MTuqHutC
 Gs83jnTRJ3gsIqrhvyjxg7mJyQ4yLeu9BSEhu2Lq/d9UC8VEjA2GkJc/uph3OXZNyoXi6ZKq5dN549gyH87s8SeUHSWD+wJWw5LgNuSe2xE096xhn5eSIXReN7lonwQ5fL+7Ug+XR97dbMNO7zRul6M0b/4lGjrYXvpdHUSreGv78tRhQkVvdHB7X21OnFWGWRqHsY6tdJYHywz44N9BhEUvI1QuUFJfshgGfcf/udLyqcbbhioy6BFttpMkv++ewbMuuNlSyorFbbOR6+Y6uNgTIPyY+3NQVL6zsjdOh85nqQMoku5TmSGcoRPllmt+SBSzwNXfZtNkR86RCDbGR6XpeJWhM7KRutyCrE/OmcklaXAhA/vKNSOH/4zXE112HEGu4F1kkSLtZfrR7bnuLCMXm3efmMbZR1DeMSuTfn5o2+0++qb/kciuBNgXQ1JAIZoD7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Problem
=======

MGLRU's aging walks every PUD of every mm in the mm_list.  For a PUD whose
512 PMDs all fail the existing PMD-level Bloom filter, the walker still
descends into the PUD and iterates all 512 PMD entries.  When an mm has no
pages on a given node this is structural waste: lru_gen_use_mm() sets
mm->lru_gen.bitmap to -1 (all nodes) on every context switch, so the aging
walker of *every* node, e.g kswapd, direct reclaim, proactive aging walks
the same mm.

On a 2-node KVM guest with the workload pinned to node 0, node 1's aging
walks of those mms scan 1,362 leaf entries per walk while finding no young
folio for node 1's lruvec, and 94% of those walks are entirely empty.

Approach
========

Add a PUD-level Bloom filter, one level above the existing PMD filter.
The walker now:

  1. Tests the PUD filter before descending into a PUD subtree.
  2. If the PUD had nothing young for this lruvec last generation, skips the
     whole 1 GiB region -- avoiding 512 PMD lookups.
  3. walk_pmd_range() reports whether it found anything young;
     walk_pud_range() records that in the double-buffered PUD filter.
  4. The rmap feedback path marks hot PUDs, so regions whose hotness is only
     observed by eviction are re-examined promptly.  This is done for both
     mapping types: lru_gen_look_around() covers PTE-mapped folios, and
     folio_referenced_one() covers PMD-mapped ones, which never reach
     lru_gen_look_around().
  5. force_scan walks bypass the PUD test, so manual aging and newly added
     mms always rescan and re-populate the filter.

The filter key is (mm, PUD-aligned address), as suggested by Kairui.  It is
a stable identity of the range on both sides of the interface: the aging
walk computes it from args->mm and addr, the rmap path from vma->vm_mm and
the address. So the feedback path needs no page-table walk at all.

The double-buffered filter flips each generation and force_scan bypasses
it, so a missed re-mark costs at most one generation, and reclaim is still
safe for a wrongly skipped subtree because folio_referenced() consults the
PTE young bits, not the filter.

Test
====

8 GiB KVM guest, 4 vCPU, two 4 GiB NUMA nodes, 7.4.0-rc3 with the series.
"base" below is the same kernel with the filter disabled (patch 1 only):
same .config, same workload, medians of 3 runs.

1) Cross-node empty walks.  16 workers x 128 MiB pinned to node 0
   (numactl --membind=0), so node 1 owns none of these pages.  100 aging
   passes, per pass, both nodes aged:

                                       base   filter change
     node 1  leaf entries scanned     1,214      100   -92%
             walks with leaves           17        1   -94%
             PUDs skipped                 0       52
     node 0  leaf entries scanned    12,559   12,288  -2.2%
             leaf entries assoc.      9,164    9,175  +0.1%
             worker RSS delta            0%       0%

     forced pass, node 1 leaf/walk
       before the filtered passes   1,363  1,362
       after them                   1,363  1,369

   A forced pass bypasses the filter, so it costs the same on both kernels
   and the same before and after 100 filtered passes: the filter is a
   cache, not a state.  Node 0 keeps its young leaves (+0.1%), so the
   coarser filter does not starve the node that owns them.

2) Correctness, 11 checks, all pass: a cold PUD is skipped; touching it
   does not revive it; force_scan re-marks it and the next pass walks it
   again; a munmap + mmap at the same address shows no stale suppression; a
   1 GiB range migrated from node 0 to node 1 is re-scanned by node 1 after
   one forced pass; no premature reclaim in any of them; dmesg clean.

3) A PUD that holds only PMD-mapped huge pages. 1 GiB is mapped with
   THP=always (AnonHugePages = 1 GiB) and aged until its PUD is skipped
   (S +4 over 3 passes). The memcg is then put under reclaim pressure
   (memory.max below the current usage) and the range is touched again, so
   folio_referenced() runs on PMD-mapped folios. The next normal aging
   pass walks the range again:

     leaf_total 1132,  leaf_associated 513

   This is what v4 adds. In v3 the range stayed skipped, because
   folio_referenced_one() takes the pmdp_clear_flush_young_notify() branch
   for huge pages and never reaches lru_gen_look_around().

4) Reclaim pressure. Four 512 MiB workers in a memory.max=2G/swap.max=1G
   memcg, i.e. exactly at the limit, so reclaim is always active; each
   touches one 256 MiB half and flips it every second, so a half is cold
   for a few aging generations and then hot again. Aging runs on both
   nodes every 0.5 s, for 600 s. The base ran twice, the filter three
   times:

     oom_kill 0 vs 0
     hot half resident, min   262,051 vs 262,120  (of 262,144 pages)
     pgsteal_anon              2.12M  vs  2.24M
     pswpout                   2.12M  vs  2.24M
     workingset_refault_anon   2.12M  vs  2.24M
     pgscan_anon               14.2M  vs  17.6M
     node 1 walks with leaves  4,532  vs      4  -99.9%

   No OOM and no residency loss. Evictions, swap-out and refaults overlap
   between the two kernels (base 2.12-2.61M, filter 2.03-2.26M), so this is
   not a measurable difference. pgscan_anon is 15% higher; note that it
   counts folios examined by the LRU scanner on both nodes, not page-table
   walks, so it is not a measure of the filter's own work. PUD subtrees
   skipped on node 0 are 0.16-0.20% of its associated leaves.

5) Low memory. Aging cost on a single node, CPU time per pass taken from
   the utime+stime of the task that writes to debugfs, 200 passes:

     shape                              base      filter
     2 procs x 32 GiB VA, 0.2% touched   3,707 us   3,191 us  -14%
     20 procs x 3 GiB VA, 2% touched    11,008 us  10,573 us
     20 procs x 64 MiB, fully touched   10,962 us  10,783 us

   The leaves scanned, the leaves associated and the number of walks with
   leaves are the same in all three rows. If a mm has only a few 1 GiB
   subtrees the filter has nothing to save and it spends nothing. On the
   wide shape it saves about 14%, i.e. what 512 PMD-level Bloom tests cost
   per skipped subtree.

Change log
==========
v3->v4:
 - Mark a PUD young only when a huge page is really young for this lruvec.
   walk_pmd_range_locked() returns that now, and the accessed bit of a
   non-leaf PMD no longer marks anything.  (Sashiko)

 - Mark the PUD from folio_referenced_one() too, so a PUD that holds only
   PMD-mapped huge pages can be re-marked.  (Sashiko)

 - Statistics: count the batched entries of a large folio in
   MM_LEAF_ASSOCIATED, move the tracepoint inside #ifdef CONFIG_LRU_GEN,
   and word the comment so MM_LEAF_ASSOCIATED and MM_WALK_EMPTY clearly
   mean "young".  (Sashiko)

 - Bloom filter helpers: fold the __ functions into
   test/update/reset_bloom_filter(), and describe both levels in the
   comment, including why they keep the same m and k and that two levels of
   double buffering take 16 KiB per lruvec.  (Kairui)

v2 -> v3:
 - Use (mm, PUD-aligned address) as the PUD filter key instead of the PUD
   page-table pointer.  This removes the pud_offset(p4d_offset(pgd_offset()))
   page-table walk that the v2 lru_gen_look_around() hunk had to do to
   obtain the key with withc Barry is very worried about adding cost to a
   hot paths. This is suggested by Kairui.

 - Store both levels in one array, filters[BLOOM_FILTER_LEVELS]
   [NR_BLOOM_FILTERS], instead of separate pmd_filters/pud_filters
   (Kairui's idea).

 - Count skipped subtrees (MM_PUD_EMPTY_SKIPPED, debugfs column "S" of
   TYFALWEES, and a tracepoint field) so the avoided cost is measurable.

Baoquan He (4):
  mm/mglru: add MM_WALK_EMPTY stats and tracepoint
  mm/mglru: add PUD-level Bloom filter state and generic helpers
  mm/mglru: skip cold PUD subtrees during aging
  mm/mglru: count PUD subtrees skipped by the PUD-level filter

 include/linux/mmzone.h |  21 ++++-
 mm/rmap.c              |   5 +-
 mm/trace_vmscan.h      |  30 ++++++++
 mm/vmscan.c            | 171 +++++++++++++++++++++++++++++++++--------
 4 files changed, 192 insertions(+), 35 deletions(-)


base-commit: 9f004372ebeb18fdeb699f9880a0e472df90135b
-- 
2.52.0


