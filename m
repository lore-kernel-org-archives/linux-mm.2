Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4E8606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 06:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LpzC6cA2
Received: by kanga.kvack.org (Postfix)
	id D18136B05B0; Fri, 27 Nov 2026 01:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9056B05B1; Fri, 27 Nov 2026 01:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB80B6B05B2; Fri, 27 Nov 2026 01:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88D2B6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:16:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6975EA0217
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:16:40 +0000 (UTC)
X-FDA: 85479890160.01.B724C1D
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	by imf14.hostedemail.com (Postfix) with ESMTP id 612F4100002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:16:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LpzC6cA2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795760198;
	b=nLYDRPPvegE3z91oHc9yM43VFGTDE0Ve4jMk1RrORjut07ph8cD7ZXxQoTn672FyOyfxeK
	D11KQ9WU4sqlUjJxpE4iMTNQmOX8WWwJsD2oCm6HEALDIP7+zsTn9VsweuGKTDCnwQOLBt
	cRm8M5A2B2lmAcFkF6z63MrL+2qrJHs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795760198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iWKw8bbDSxm+meQ96Dp39fnCqDgwNz8IFY77jbYE8dY=;
	b=IPYZmpjmQHTZlshS7osiH9RwCpQQHNJ6M5U/nXpiH0Jkv7jjVv9S0O0YNnqqvrkNCbMfhC
	/JftQC0cHEpjck34/Opk32DQslvb6IVLVdw9uqoi3dz23NKPyeuHb95nD3qllIZ4l/CmkQ
	5OnsJDo4fUI44QXWdOj+AxYmoa6OhFA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LpzC6cA2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NqNIkYkVH6OEpoA10GF8c9i+CFvSpoGK22oVo8H9KE0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795760196; v=1; x=1796364996;
 b=LpzC6cA2qAmf49Y+olbT85sZ7A/2ajFScmXAJ/MStCB0kA5pcGYguKHOUN6L8j7kLd9wCvoL
 2ZK6Hh6msCmpu+zYHNXKElFTa0l85Lf5j/7Vk9g3JnApBQu9y/moh5Gdm01dZAka4Ns/mLe5F8Y
 JNsAL5NqExOrXzIg8c5j4o/M=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id fdb16f3314b854fb;
	Fri, 27 Nov 2026 06:16:36 +0000
X-Mizu-Trace-ID: fdb16f3314b854fb
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v6 0/4] skip empty PUD subtrees during aging with a PUD-level Bloom filter
Date: Fri, 27 Nov 2026 14:16:26 +0800
Message-ID: <20261127061630.11290-1-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 8py7una6nxnqhoigf5qagf6uk14jfnt7
X-Rspamd-Queue-Id: 612F4100002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795760198-670727
X-HE-Meta: U2FsdGVkX1/q44tAdhn1UG4rdfA28IoX1AbrgHJod39BqxODBBpXJ4C/gYzsnhN/ai/8ASbatdrdQkBDy6PzYCHoUPRYvHG/I5S+ylJ/le0bB2go3bSqVtNG5Jt+eXomXaBIcazV3EhUKhBkkXkpyTxgIGIDniIe6pOojx4IS7J/zwFlhTnOD//jUbCgdQ0qUe4sUo5+e2QGSSGgVEjK/6vjcNi0v/cLq5pYhRD2zHXrL/zSyxn8BCEAmrHHgUFL11PUCPC8jrWCBn+VcJ+CquwDEUp1ANH6O65nGla0KN04lIf8RKETAvMryuxjoHZy6jNF75tIOsmc5I0cS/4HTABH76fc6N2J05qq7P3JhTXvUnPyCsEC32f9FFa1iCUOL93OV5fHFNdj1E+7Dd7YRaYJD4/IAwGZiTvRivYD9cam1p2MnyrhEnCL5U98iFGtWtq5W77nhAF3htxsFh6eu/x6JkGnLMHFhrTb0gNneL9dXo7wn0KG+TcnoPI+q2tIOqv7Br7GrP7DDk49AzyAihszqw2/jBh/fLiTV21ct/HeWa2koyj+jBNe2RlK9xfa/9QltmjyzuHz7L0n14oyIJPMdchFOrfzPI6SHD7fxo7RP63aqwEoTZNRvbslPM1Si51xXrgRB5fzb/aDiQEio3CDQLtiJqoBJ0FaHD0eEYGXXy5FFXqgFWh0Y5Mfelq4oBauqb84ap6usXBr9214HqON576r9g/RjpcsScqgP0M1Qtzl42Z63odyp/N4KO+lL9Gh5g1siSQGr6tJJjHkaRna2CmpFQkYyHpm/DcjwXtrtHBexpH+Nda5ZM0CFwb4xOJWFv9fZkIkQQaYx0GnmJi2RxauuePh/+D6desPXqdQrThV2EXzRPYxggKpsVkYqMsY2MIrwrg/hokhqtMojbC7rIw+6hkNPoV7wQOD6I7JO1pifCdzXJcqUGCjqwvffh1DpiMrdFcO7ODA/cB
 CDgLbywS
 Tzn0T347spFSd4/i+nue+29sERbOu+8EYHmpYjQMflSj8MNCNXLrurmgP2eAfXjp5V4BxC92dvxkLok8wyW18DPgH8u88JUVnlLXRWWuC3L9l8CziMxVM9eVU7hMWRhxmHhIBtC+ZA7alOgYo3Mocej2rZHM5mauep37krKG3tCkVySyqA743E4/Fvda5tlyslDFU/FXboujAclyW4sTbnLIabF4ygCeBlwCH91+w6HnFmfV5mJmLZUMf3YNQXLTxvcJsyGJzMtObxlLCtyX/Wv0h4AvsyZOhqS1s/7oJqe3BWHeXv4/IsDcxe2aM1g3enDH7Tdf4tgos92D4S5G3HYt9j+F6M5tljgYjryJSapIzQJxD9cgiBIhtdZ1IIzGI8jFHu7P/wwlORlG7yKPOqLHPjCTa3EtqtcC89pUK1IVwIp3/UJQcTd8xt4a5DGOPbSd+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Problem
=======

MGLRU's aging walks every PUD of every mm in the mm_list. For a PUD whose
512 PMDs all fail the existing PMD-level Bloom filter, the walker still
descends into the PUD and iterates all 512 PMD entries. When an mm has no
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
     whole 1 GiB region, avoiding 512 PMD lookups.
  3. walk_pmd_range() reports whether it found anything young;
     walk_pud_range() records that in the double-buffered PUD filter.
  4. The rmap feedback path marks hot PUDs, so regions whose hotness is only
     observed by eviction are re-examined promptly. This is done for both
     mapping types: lru_gen_look_around() covers PTE-mapped folios, and
     folio_referenced_one() covers PMD-mapped ones, which never reach
     lru_gen_look_around().
  5. force_scan walks bypass the PUD test, so manual aging and newly added
     mms always rescan and re-populate the filter.

The filter key is (mm, PUD-aligned address), as suggested by Kairui. It is
a stable identity of the range on both sides of the interface: the aging
walk computes it from args->mm and addr, the rmap path from vma->vm_mm and
the address. So the feedback path needs no page-table walk at all.

The double-buffered filter flips each generation and force_scan bypasses
it, so a missed re-mark costs at most one generation, and reclaim is still
safe for a wrongly skipped subtree because folio_referenced() consults the
PTE young bits, not the filter.

Change log
==========
v5 -> v6:
 - Rebased to latest mm-new.

 - Keep the "is MGLRU in use" test inside lru_gen_mark_pud(), so the rmap
   side is one plain call and rmap does not carry an MGLRU expression.
   Suggested by by Lorenzo.

 - In the non-leaf PMD branch of walk_pmd_range(), keep the result of
   walk_pmd_range_locked(). That call can flush the huge pages batched by
   an earlier iteration, and if it does and no later PMD is young, the PUD
   was left out of the filter and the 1 GiB subtree was skipped on the next
   pass. (Sashiko)

v4 -> v5:
 - Drop MM_LEAF_ASSOCIATED: an empty walk is now "MM_LEAF_TOTAL > 0 and
   MM_LEAF_YOUNG == 0". (Sashiko)

Test
====

8 GiB KVM guest, 4 vCPU, two 4 GiB NUMA nodes, 7.4.0-rc3 with the series.
"base" below is the same kernel with the filter disabled (patch 1 only):
same .config, same workload. Each result directory records its own cmdline
and per-node meminfo, so a wrong configuration would show.

1) Cross-node empty walks. 16 workers x 128 MiB pinned to node 0
   (numactl --membind=0), so node 1 owns none of these pages. 100 aging
   passes, both nodes aged, 3 runs, median:

                                        base   filter change
     node 1  leaf entries scanned      1,243      107   -91%
             walks with leaves            17     0.67   -96%
             PUDs skipped                  0       51
     node 0  leaf entries scanned     12,926   13,155  +1.8%
             young leaves              9,228    9,167  -0.7%
             worker RSS delta             0%       0%

   The base's own three runs spread 9,133 to 9,248 young leaves on node 0,
   so node 0 keeps its young leaves. The filter marks young leaves in
   exactly the same place it did before; what it drops is the walk into
   PUDs that had nothing young.

     forced pass, node 1 leaf/walk
       before the filtered passes   1,359-1,371  1,363-1,370
       after them                   1,361-1,371  1,363-1,370

   A forced pass bypasses the filter, so it costs the same on both kernels
   and the same before and after 100 filtered passes: the filter is a
   cache, not a state.

2) Correctness, 11 checks, all pass: a cold PUD is skipped; touching it
   does not revive it; force_scan re-marks it and the next pass walks it
   again; a munmap + mmap at the same address shows no stale suppression; a
   1 GiB range migrated from node 0 to node 1 is re-scanned by node 1 after
   one forced pass; no premature reclaim in any of them; dmesg clean.

3) A PUD that holds only PMD-mapped huge pages. 1 GiB is mapped with
   THP=always (AnonHugePages = 1 GiB, 262,144 of 262,144 pages resident) and
   aged until its PUD is skipped (S +4 over 3 passes). The memcg is then
   put under reclaim pressure (memory.max below the current usage) and the
   range is touched again, so folio_referenced() runs on PMD-mapped folios.
   The next normal aging pass walks the range again:

     leaf_total 1560,  leaf_young 387

4) Reclaim pressure. Four 512 MiB workers in a memory.max=2G/swap.max=1G
   memcg, at the limit so reclaim never stops; each flips a 256 MiB half
   every second. Both nodes are aged every 0.5 s for 600 s. Rates per
   second, because some runs stopped early on both kernels:

                             base                filter
     pgscan_anon          23.7-27.4k/s (3)    34.6-35.3k/s (2)
     pgsteal_anon          3.95-4.10k/s        3.74-4.63k/s
     pswpout               3.94-4.10k/s        3.74-4.61k/s
     refault_anon          3.95-4.10k/s        3.74-4.63k/s
     oom_kill              0                   0
     hot half resident     262,140-262,144     262,144
     node 1 walks w/ leaves  2,812-4,544          4

   The filter's scan, steal, swap-out, refault and residency are the same
   as base's within run-to-run noise: base's own two runs span 38.8M-48.7M
   on pgscan. The filter still skips the cold node 1 PUDs (walks with
   leaves 4,000 -> 4), but reclaim costs nothing measurable.

5) Aging cost on a single node. Per pass, 200 passes, perf stat and the
   median wall time around the same fork-free debugfs write:

     shape                                base      filter   change
     2 procs x 32 GiB VA, 0.2% touched
       time per pass                  1,577-1,596  1,278-1,392 us  -15%
       instructions per pass              5.79M        4.27M       -26%
     20 procs x 3 GiB VA, 2% touched
       time per pass                 9,889-10,097 9,563-9,775 us    -4%
       instructions per pass              29.6M        28.1M        -5%
     20 procs x 64 MiB, fully touched
       time per pass                10,294-10,579 10,167-10,411 us  -2%
       instructions per pass              30.06M       30.05M        0%

   The leaf counters are the same in all three rows; only the skips differ.
   The wide shape has 34 PUD regions per mm and skips all of them, so it is
   1.5M instructions lighter per pass, about 22,000 per skipped PUD, which
   is the 512 PMD-level Bloom tests it no longer runs. With 5 and 1 PUD
   regions per mm there is little to skip, so the other two cost nothing.

Baoquan He (4):
  mm/mglru: add MM_WALK_EMPTY stats and tracepoint
  mm/mglru: add PUD-level Bloom filter state and generic helpers
  mm/mglru: skip cold PUD subtrees during aging
  mm/mglru: count PUD subtrees skipped by the PUD-level filter

 include/linux/mmzone.h |  20 ++++-
 mm/rmap.c              |   4 +-
 mm/trace_vmscan.h      |  30 +++++++
 mm/vmscan.c            | 184 +++++++++++++++++++++++++++++++++--------
 4 files changed, 202 insertions(+), 36 deletions(-)


base-commit: 5bd93e4b0b357e9d0a13199887aacbf04d1ce216
-- 
2.52.0


