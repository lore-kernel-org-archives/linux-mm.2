Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07282606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o5FD5QSx
Received: by kanga.kvack.org (Postfix)
	id 1BD566B05B2; Mon, 23 Nov 2026 03:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C726B05B5; Mon, 23 Nov 2026 03:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082736B05B6; Mon, 23 Nov 2026 03:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBE526B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:58:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50CC5A848B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:16 +0000 (UTC)
X-FDA: 85465782192.22.F1FB022
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id CED7B4000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:58:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o5FD5QSx;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424294;
	b=6u2QGMiegyZQW15NEAC+vHEQALHp0pwurWcllCF+omzHqExcw4hq3OmQZ0jvbVO5v+vH3X
	Aaf0fnT8khuqM5kz2c/ccLV39Wi7cme5Ial+EUarede+o3WjF8CsvllKpmuJQqzFbqYhxo
	XYsJ2VP7LioUEvI6vfqzEDrCLveHeGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IY4cRX3FUxOIUmhZmjuPYAgtEsWKkBHZ2j4hqum2+cM=;
	b=YI3vQ6X5YLRTn6xlJ5v/Zu/QN4IF7+8AWeRyDTlCMRMBc+L9wS9kZ4EGogwwtlWscUJO4x
	3iXnFl0xLbIeCWCRgu0fxqIS6ziKUnFB/v/UaEvX1TEcURLlH7ExIi9Wc4XNx86w75t0Vb
	ymXF0G+g6w7E1xDmgXqFe6T3pg2pfv8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o5FD5QSx;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JBSwwgI2Zpd/AEU/EG0T3MJZy8FWErChazvstQzfvok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795424291; v=1; x=1796029091;
 b=o5FD5QSxvwaOJZGg7TKKEPWfo6/6nEhkQCz9rBi+ymsjClV/D00wKxilkM7MVey+xOtl29EF
 y7TefEvis7c4mFmCfTvBWmA/iS2YHXdTDUDQhhc+4Ux9CFytaVn0F6wiOO3eELpjBPOSPNkU5e6
 ZK8HSiljfZNhvfFQL3PzHZmI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d086ef5e6cafc22e;
	Mon, 23 Nov 2026 08:58:11 +0000
X-Mizu-Trace-ID: d086ef5e6cafc22e
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev
Subject: [PATCH v5 0/4] skip empty PUD subtrees during aging with a PUD-level Bloom filter
Date: Mon, 23 Nov 2026 16:57:56 +0800
Message-ID: <20261123085800.981256-1-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CED7B4000C
X-Stat-Signature: 445syrpbupdawmk858fmuh8c9rksrtuc
X-Rspam-User:
X-HE-Tag: 1795424292-750051
X-HE-Meta: U2FsdGVkX1+vwjb0hW3abcR+/Y7te6SFYwA++SPSOB7eiY+jigXwZ4jiuUXujcEIzHRyCBjy3JOQB8G0yY2Q/wMDEea2rri/+EppWGnKz946Py1hHgizbLZu8ST3cqQclr5255ivG7T9S+O62Cv40wRtjj1tqG2gs8RGrbSdiKdIOOqgwvKznW3cxx54V05PIDzJt/neslq/e+L7/NCO+W56nXmwcg2TjbDq2uOnTX/iQ//e8MyBedlKutdo6UbRn2J1TgecJPISl2+Q7Iz7Hq0U0c9uZCzATEIM2XjU4xYir01hW0BAwHs4uvfwVsdQvNy7UKVKX+hBaBgZd85707PGCrs9rvM8aOANviP396fgR7AuXYwAoGv29tKZaH1JpR5+Dk2F+TktJeHwYtVdYCkiwAa7DGNrHYXW/7f7pwLsHrxSo3P9Sjc/NyP8Eog6V2nuw3lWD/q9iFu9xge08QQg4UAS9CjAjC6EO0Uc79JRi41yB220wqQ9gGgF6hP48D99HfwMIjZce7gcuwKqHHnPLqVOXV3rQDEJJmKpkxzYOExPxcKgTtY2zSqnnMIj18iEkiPCQnjXXTXUdYP8ya0aL5ITTy5cc7MKGKlLFtskmWc3lm4wwl8WNbELRt3Wc8djGmQXF8hLfK0fWyK1szYe63xDfRFqHfJSSLrWxl6R+OyTtSr5k9B+hPXpcKdtxgh7fNtJzBrIdYUjv1H1HgRl9ukvWTqRUAAR1BdGGD6BZxrQFWLSuD5y2+eRCa3H8pDCPEzG/Ipjm34jy3ULAl54EzKtLOdNdEXS2udlBHRy2oQ7RcD/HEfZIzXWZ47LbB/VVD0KBUzkiloZUJYG/ppAS5b93fFeFajorGmRLEZBouWjd8Wu2u1AFTN6Dec+n6Ud2V5G48aLcRNcUv+BwTx7c4HId8mi9/6TX3lcEILnnHeGSA8htUX/NQjL5panX46hZXGv6IOS0e2G63U
 a3DkWTz5
 HjXTWf4rN0Jq4tKln3j1AmhmO3lwZVZ09ByKkm9XLkgkcccFZslTClOyeTy0WoSkLQrKgEWXs01QpmUpmhT/FQkTmkkOEK9nW41VJshbC35wCyPXor/7aj8I0tMayXF0NNcS6CERfb9bmNmB1FqSMxz+M9QKtLcg1IV4qYZLZH+FobHtdmgTfrkNIAfkRaQEgNsy4lUOrS7U5Dtow1b+MHdEECMYo4rFcNTp/zCWQWm4N2+cEkIcyr4vh25rq5dSIhCpAK7VXvW70ilSjuzUsiAUIsOpr8C+hoVFsTq36Pm7sN7LPfRruJ4iQbEeKz0ubs0yFlD1IEnDhoHqCgto7CRvdxM6qwmcEMnfm/D+Mrc0oWx5AZSyStBHy38hKteA1UWmOVy4Jr1jpwMG1UL91Mhj1vV0DwoqafWD57COQseLIGk4eVZhkdxjVev5omJxPNL/3
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
     whole 1 GiB region -- avoiding 512 PMD lookups.
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
v4 -> v5:

 - Rebased onto the latest mm-new commit 7d1a16abe4cc.

 - Drop MM_LEAF_ASSOCIATED: an empty walk is now "MM_LEAF_TOTAL > 0 and
   MM_LEAF_YOUNG == 0". MM_LEAF_YOUNG already means the young leaves of
   this lruvec, which is what the PUD filter needs, so the second counter
   added nothing. The debugfs columns and the tracepoint field are renamed
   to match. (Sashiko)

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

4) Reclaim pressure.  Four 512 MiB workers in a memory.max=2G/swap.max=1G
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

   Evictions, swap-out, refaults and residency are the same. The scanner
   examines 26-49% more folios with the filter: a folio under a skipped PUD
   is not promoted that generation, so it sits in an older generation a
   little longer and takes more scanning to reach. Extra scanning, not
   extra reclaim. The per-walk statistics cannot cause it, nothing outside
   lru_gen_seq_show() reads them.

5) Aging cost on a single node.  Per pass, 200 passes, perf stat and the
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
   is the 512 PMD-level Bloom tests it no longer runs.  With 5 and 1 PUD
   regions per mm there is little to skip, so the other two cost nothing.

Baoquan He (4):
  mm/mglru: add MM_WALK_EMPTY stats and tracepoint
  mm/mglru: add PUD-level Bloom filter state and generic helpers
  mm/mglru: skip cold PUD subtrees during aging
  mm/mglru: count PUD subtrees skipped by the PUD-level filter

 include/linux/mmzone.h |  20 ++++-
 mm/rmap.c              |   5 +-
 mm/trace_vmscan.h      |  30 ++++++++
 mm/vmscan.c            | 169 +++++++++++++++++++++++++++++++++--------
 4 files changed, 189 insertions(+), 35 deletions(-)


base-commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27
-- 
2.52.0


