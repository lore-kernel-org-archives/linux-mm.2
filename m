Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E9860A2600
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y04HtbWK
Received: by kanga.kvack.org (Postfix)
	id 4E2426B060B; Fri, 13 Nov 2026 03:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9A56B060E; Fri, 13 Nov 2026 03:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7B96B0611; Fri, 13 Nov 2026 03:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4026B060B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:50:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA4B11A03A6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:08 +0000 (UTC)
X-FDA: 85429473696.02.29F4576
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8B9BC0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y04HtbWK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559807;
	b=YP82JGqCjlPEJalZBahMDSBP36IpaOfrrInxvQmzwNZqUg/5KhH9+10vrMnbzSkD7li6kL
	Aj5i+smy05D0WPTwOui6TgUpIP2hvkd2SD5jeGgLqENi85uFkvpRWRGHtRJVprklUfVUBq
	rCaTNhlmLvefvl8jrm/Bu3GLgd/FCOA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=icF5WIc6Cragr5xLrzXsfWJkmaNOIB0h6RmiIfsMPW0=;
	b=QgPKeVRvIHVvNUAQ6QPrn985qsCj9ASqMCDt72S+vLjE33VgCegbAdpOFYpt6vqmPfLzj9
	ZqODdUQhx30EynKLOLqrB+e3fyIPdhHYbg/6/rlPtEdXDV9OAVdiIuEcNFqA5RPv1hhwVH
	MO7KXzUtue2ZKxpEI/ehtGMquXMwhKc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y04HtbWK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E4OS1/ZyfIAV78pkXMT4J93GebfAiZKGupRmIN9suJc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794559802; v=1; x=1795164602;
 b=Y04HtbWKA8sOsTy0vgr9xZd00I9PoIWYLiP1l+N19IsNlKvdOkDoRVudKjOtECiqCXvwsPbC
 P6X0QRce+m7o9AtMFgUn9LKJUj4g2h6MosEBMuH5zxSPV/bBWBOgkfnRbUzA9GupUCVVRiOJDQu
 U8Iglk9dAv68OMikUXN6TL4E=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f0317e142de2ab26;
	Fri, 13 Nov 2026 08:50:01 +0000
X-Mizu-Trace-ID: f0317e142de2ab26
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v3 0/4] skip empty PUD subtrees during aging with a PUD-level Bloom filter
Date: Fri, 13 Nov 2026 16:49:49 +0800
Message-ID: <20261113084953.412919-1-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B8B9BC0004
X-Rspamd-Server: rspam12
X-Stat-Signature: u4quhtifz5zde863pzw85d1kbe5mpqyd
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794559806-384651
X-HE-Meta: U2FsdGVkX1/7KTQpxm4PRztydPlsepI61/qi556vKQuGrnqNqwiC48N5qjJxaNlZh/rEGCzQ86SMb3A5GcvE6LNCVjGHLwMTMt2rDIbhISxsOPe1caRK4tFmbsWeo3LZKx9KHNcYlFBjnPWBBqr7kjO1dlEmgtfrMzOe8NxkBftsq72V7jtTq1TIY8Vyvbek13T+V6NniOUC4VeRxqCCV49wg/AXfEiM1VQxgUztzqySTBGkBOdNgopt53D5vIi1y+rXnvk8WD/IXrZVkKV+JezTQ5BzCSWMy5l+3BsB48xvLU0szY7HzRlg4hHwLPu4r1tp+auoUeW3K+MTikiIa9fjRiTi68OHj5fjhJ3gQMW431cvyRZP/u9OAj1FecJnnorD8gGO9HQzj1qCdPCzuPWQcW1lup5/comq469R0T4HeauyNELRYLDaKxWuBLJDuFKm4prDiqmjgqsNXrlsB0TtgJQV3m6ccvM2FfKo4XGFRTtFT8XXG32mms7x95JL6NVP45yx2plNncudh480Tu5yx0se07DQuOzBv/Cx4+jdZDDGbb5DHgqYGejdNAFcURN41AxARd20jGC+UugRgdu08T/hp0kdPznLNp8AwsG2sJN4M0TggOFF6diQSHdUFfGO9a63bz5uM2m6CL3+Pxp98rZRYTjGwtLQbP5UeLojSZjUtbDvUFlrQauGyw+iGTm45VxQRaxeveyGAc4er0wiEzo9XESRB6j0kbwyoNDNy6TX+wPt0zGKy6E0nMjL6iHWdlGDzrOHDi7HWW/oZ/aPJiE/wcaqrCzHmzvLsZdNShpllGNLjFXq5MOijmOR3OTsoQBIdEeufwael48pcRpMA7iJ3k4SSDp1PFFGTMS5lR9QLUO6be8y53ZTEiuLPHdXaUMkgp/gtq/7rCX5UYeb5hFfJPh22ew3fhtP4l/w/9J2O/CVMq4H+Jh2WaM7UAaKDM3aBeJIrsKgwfr
 7KMCAGls
 AteBlGIIpzaOLJReZGFBzXEHCK6xeounRvYOb9kcJeIbVtAMEBCnfqV+EMAprsUpWEOGwF25tI1KcsbeFss77oKvjcyjv6R5+lYc1P3uY823d5ytUSUU+3jzTBRQiZ/yG9ZmSUaPnGo9LSSf2OT8/3AemBCtlCS12JQqYs9Kh5PFdy2cIQ80er24UG1poVDDo+1MtcUzeYvVufuIGQ1eXgBSQzPRmim9q6dffgk9QdtZ6oi5LhKIpxUri4GUgWoY+S57fMfoku1fZXUFCvx+zGsH4Hb9UsLPPkh4SBVwJtAZKQwFithxXs5bRKAfratRd2iPLp9jY8KD2xoXHuOAInauT6a1pH4j+ysr5xhOo2GN/TON2z32TQotTvy1O+0B+KqvnlPqNI9xAl0ANf6FSt78IpsjB0XLRTFQbjp3TnexaJenZcaM22JgIA4UUsjCto7xv
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
walker of *every* node -- kswapd, direct reclaim, proactive aging -- walks
the same mm.

On a 2-node KVM guest with the workload pinned to node 0, node 1's aging
walks of those mms scan 1,363 leaf entries per walk while finding no folio
that belongs to node 1's lruvec, and 94% of those walks are entirely
empty.

Approach
========

Add a PUD-level Bloom filter, one level above the existing PMD filter.
The walker now:

  1. Tests the PUD filter before descending into a PUD subtree.
  2. If the PUD had nothing young for this lruvec last generation, skips the
     whole 1 GiB region -- avoiding 512 PMD lookups.
  3. walk_pmd_range() reports whether it found anything young;
     walk_pud_range() records that in the double-buffered PUD filter.
  4. The rmap feedback path (lru_gen_look_around()) marks hot PUDs, so
     regions whose hotness is only observed by eviction are re-examined
     promptly.
  5. force_scan walks bypass the PUD test, so manual aging and newly added
     mms always rescan and re-populate the filter.

The filter key is (mm, PUD-aligned address), as suggested by Kairui.  It
is a stable identity of the range on both sides of the interface which the
aging walk computes from args->mm and addr, lru_gen_look_around() from
vma->vm_mm and pvmw->address. So the rmap feedback path needs no
page-table walk at all.

The double-buffered filter flips each generation and force_scan bypasses
it, so a missed re-mark costs at most one generation, and reclaim is still
safe for a wrongly skipped subtree because folio_referenced() consults the
PTE young bits, not the filter.

Change log
==========

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

Test
====

8 GiB KVM guest, 4 vCPU, two 4 GiB NUMA nodes, 7.4.0-rc1 with the series.
"base" below is the same kernel with the filter disabled (patch 1 only):
same .config, same workload, medians of 3 runs.

1) Cross-node empty walks.  16 workers x 128 MiB pinned to node 0
   (numactl --membind=0), so node 1 owns none of these pages.  100 aging
   passes, per pass, both nodes aged:

                                       base   filter change
     node 1  leaf entries scanned     1,213       99   -92%
             walks with leaves           17        1   -94%
             PUDs skipped                 0       52
     node 0  leaf entries scanned    12,308   11,793  -4.2%
             leaf entries assoc.      9,175    8,902  -3.0%
             worker RSS delta            0%       0%

     forced pass, node 1 leaf/walk
       before the filtered passes   1,363.0  1,361.4
       after them                   1,363.0  1,341.3

   A forced pass bypasses the filter, so it costs the same on both kernels
   and the same before and after 100 filtered passes: the filter is a cache,
   not a state.  Node 0 keeps its associated leaves (-3.0% is run-to-run
   noise), so the coarser filter does not starve the node that owns them.

2) Correctness, 11 checks, all pass: a cold PUD is skipped; touching it does
   not revive it; force_scan re-marks it and the next pass walks it again; a
   munmap + mmap at the same address shows no stale suppression; a 1 GiB
   range migrated from node 0 to node 1 is re-scanned by node 1 after one
   forced pass; no premature reclaim in any of them; dmesg clean.

3) Reclaim pressure. Four 512 MiB workers in a memory.max=2G/swap.max=1G
   memcg, i.e. exactly at the limit, so reclaim is always active; each
   touches one 256 MiB half and flips it every second, so a half is cold for
   a few aging generations and then hot again. Aging runs on both nodes
   every 0.5 s, for 600 s; medians of 3 runs each:

     oom_kill 0 vs 0
     hot half resident, min   261,902 vs 261,887  (of 262,144 pages)
     pgscan_anon               84.5M  vs  110.6M  1.31x
     pgsteal_anon              4.47M  vs   3.55M  0.79x
     pswpout                   4.45M  vs   3.54M  0.80x
     workingset_refault_anon   4.47M  vs   3.55M  0.79x
     node 1 walks with leaves  4,568  vs      4  -99.9%

   No OOM, no residency loss, fewer evictions and refaults.  The extra
   scanning is expected: pgscan_anon counts folios examined by the LRU
   scanner on both nodes, not page-table walks, and the baseline's own
   spread on these counters is 1.5x (pgscan_anon 73.1-112.4M between its
   three runs), so both directions are inside the noise.  PUD subtrees
   skipped on node 0 are 0.002-0.015% of its associated leaves.

4) Low memory.  Two checks for the phone case.  First, when a 1 GiB PUD
   covers most of a process, can the filter still save anything?  Second,
   if it cannot help, does it cost anything?

   a) Aging cost on a single node.  CPU time per pass, taken from the
      utime+stime of the task that writes to debugfs:

        shape                              base      filter   change
        32 GiB VA, 0.2% touched           2400 us   1750 us   -27%
        (32 PUDs per mm)
        3 GiB VA, 2% touched              7650 us   7650 us     0%
        (3 PUDs per mm)
        64 MiB, fully touched             8250 us   7950 us     0%

      The leaves scanned, the leaves associated and the number of walks
      with leaves are the same in all three rows. If a mm has only a few
      1 GiB subtrees, the filter has nothing to save and it spends nothing.
      If a mm has more, it saves about 10.5 us of CPU per skipped subtree
      per pass, which is the cost of 512 PMD-level Bloom tests.

   b) The pressure test of (3), repeated on a single-node 3.9 GiB guest.
      mem=6G cuts the 2x4 GiB memory layout so that one node has 3.9 GiB
      and the other has none.  2 runs each:

        oom_kill 0 vs 0
        hot half resident, min   262,121 vs 262,051  (of 262,144 pages)
        pgscan_anon               99.6M  vs  97.3M   0.98x
        pgsteal_anon              3.50M  vs  3.54M   1.01x
        pswpout                   3.49M  vs  3.53M   1.01x
        workingset_refault_anon   3.50M  vs  3.54M   1.01x

      Residency is the same, and there is no OOM.  The patched kernel
      evicts and refaults 1% more, and scans 2% less.  We think this is
      noise, for two reasons.  Between two runs of the baseline kernel the
      same numbers move by 16%.  And in the 2-node test of (3) the same
      ratio is 0.79x -- lower, not higher -- so the direction is not stable
      across tests.

      Even if the 1% is real, it is what the design expects. A subtree is
      skipped only when it had no young page for this lruvec in the last
      generation. The pages in such a subtree are already cold, so it is
      normal that they are reclaimed first. On the only node the filter
      skips 16-18 subtrees per pass, which is 0.013% of its associated
      leaves.

Baoquan He (4):
  mm/mglru: add MM_WALK_EMPTY stats and tracepoint
  mm/mglru: add PUD-level Bloom filter state and generic helpers
  mm/mglru: skip cold PUD subtrees during aging
  mm/mglru: count PUD subtrees skipped by the PUD-level filter

 include/linux/mmzone.h |  15 ++++-
 mm/trace_vmscan.h      |  30 +++++++++
 mm/vmscan.c            | 134 +++++++++++++++++++++++++++++++++--------
 3 files changed, 151 insertions(+), 28 deletions(-)

-- 
2.52.0


