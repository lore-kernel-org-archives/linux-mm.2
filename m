Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E43CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 12:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CA2F6B0142; Fri, 26 Jun 2026 08:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A22C6B0144; Fri, 26 Jun 2026 08:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591736B0145; Fri, 26 Jun 2026 08:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6E96B0142
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:20:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B300E8DD1D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:20:20 +0000 (UTC)
X-FDA: 84921971400.09.EE4D266
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id D198440009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:20:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JtuLUD3h;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782476418;
	b=Po3H2pfe65m4tcHp2jJ7hRXW2jzNr51N5eM7dWod78A2rW4bFG4mo9qMM4plbnfikdT37e
	2zAb91BtlVL+DbV75+Gj9WsU9SQSh+i6cZzCvLZm4XkPgBmR3/LAo8NIzs6FDHRz4lzkTr
	cYlHA4j6yHG9VJfAGxRF9h+iN4vk6qw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782476418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nKnqyFpkGqJ5qqN1vo0VqOJxDpoK/HcDMxENgN5Bb08=;
	b=7TAgItKt19BN/yW+WcABG3TSRW4Qg161pP5Ykyi6JvDTpY+z7gadlvA0a5LVjUPNFSLtlt
	uMqwaeNXfYKX2j5NWOf2CrMe/hJLPR8ri/b+ONMoiH0iBhMG6bNkqS2hBBmDCzDvldbLk1
	idg928LG5orhJJwtKLK8Uij+p03MFgk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JtuLUD3h;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782476415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nKnqyFpkGqJ5qqN1vo0VqOJxDpoK/HcDMxENgN5Bb08=;
	b=JtuLUD3hLJaijfheOV7umvsIyWwvW98MolEhw1ZGvfSBbwIKF+bG8XdOtypvHIOlRlDnFZ
	tBUtI2/7O5QuO+wOKwCoIn5Oqb3EQZQuwc/Fm5GMVOlRfwR/QWCZmtpId2qbQ4VTCoa9ef
	d2o63X8gbL+y6nj8lkOPnl2DiGRD/mU=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [RFC 0/1] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost 
Date: Fri, 26 Jun 2026 05:19:46 -0700
Message-ID: <20260626122009.75334-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D198440009
X-Rspam-User: 
X-Stat-Signature: bnbf7umntbokanksbb68td7exgjxu3qk
X-HE-Tag: 1782476417-591418
X-HE-Meta: U2FsdGVkX1/RnfR9dSKjwWJavAQ+6ym86e+waLjD/4QZNWY2FKUC/juSkmj63qxV7mnafbrMI43aZtEFSrgCN8CQwkxCEcZomvD5VSHz6tte2cxtRBbjI/hrH9uma4eV2Md+s/3FiBNI9G7WMZ9kYqtVu3xG7vfsQdcG3FUguAEvUkURRV3m/nJdbuGKHKStPZYoztlSa3i2Jq0sMP+Ir4aM1bg2JrV1pcLPSNSWItkGS8/nxzjQhvyrmJuaFHg8vbCiFi/19hO41pUWPZVCX7W/D2H3P29fHyOnAXzOBeNyAhrcjVVtcIhhcTw6PBoBy2voKHkRBxzp2ZisAAntDAKF+S1MmkTaa3f1H7kktH398AO5zqCipZGSWJpEkdym3H507vg8GtCKx1pR/20u8S7E0PruxYi80XwZS1qI8/e75IPiYODwbqJg9DMa5lm1wmEiccCJtQGqa3RmM+4T+coIHnbFMvTpIrc1U5GufUAiKapYRDylGBxDOM7bj8vzVPDOw2LW3RUZjUA0+P5GdsKlfMNLbGsV8blSuq6kbT0wAXX1C5zXkG5HClRadvccdjQ6ovyCktKDvwrZy6eOpJ95jRQXRIx0pY/qk91BiHbAEqNGPkHbgXU3zpz3BP/tVllI5u23YWN6CMIizoihqRCejChGta3nGpS7aiAOpSQvG20qw1dX94Mv/vFfu2onAZj6dGf4tcIoDUHIkyfpqox6S20eRS8ckZ+LRaIlBNQkWJMMFUKZP/gkTZohtzGedpf0kTySuMqE3czEgBfM1Ha6Q5QjRMoFQvDSJf31qQkZ1aooOsrEBJR9W3wz06pv6ZfL1Qsd5HoJPNfGD6+flk5OuRdei8go9+xexEniry+AlmpLzQhlHz9IoYtgFutvwJPinTjvEiF8rwJFYfePC07P8/yMvvav03kcfPLpAYmZ+uEZcLzfg0+UfAd5qfCaNTvSo3KnWQ48UUIQKpi
 qgmXf/OL
 D1MrFevTGyFWr/5AGDqyFORvyHXEiwXGUjzWwkjxz9vTKQfgWPUha4dngBZRkX6O8A03NSKwbdLRFL+9TTQpJcws1RmFhjjVNZtBbnt3mRwXil69R28c/R8Kd5S5YwVlnnggT2H5bfIgCat9R3HciCNdfOxs+DYnVm17mozIhOnj6zXlB+Trzn7QPRI1pIGJx5jfTXIonvm03M9t7quWqfMOYRvmq/sKJuF6dOaV8Y4gxl0jHPj45hTXkGFUeB39+H0T8J25xKP2Q8ClDXyTtHj3837FpHeporh36RallyKy1SNTMhJcihaJwteHWF2V4omDLsOs3GWRmC8gH64C/PmZzLuBBgCrTo3oe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The anon/file scan balance heuristic in get_scan_count() is fed by two
scalars in struct lruvec (anon_cost, file_cost) that every reclaim
producer updates under lruvec->lru_lock. The cost-recording work
itself is trivial, but it both contends for and contributes to
contention on lru_lock - which is often a contention point
on memory-pressured workloads. Specifically:

- shrink_inactive_list() re-acquires lru_lock at function exit just
  to call lru_note_cost_unlock_irq().
- shrink_active_list() does the same after rotation accounting.
- workingset_refault() takes folio_lruvec_lock_irq() purely to
  record the refault cost.
- prepare_scan_control() snapshots anon_cost/file_cost under
  lru_lock.
- lru_note_cost_unlock_irq() itself walks parent_lruvec() and
  re-acquires lru_lock on every ancestor, multiplying the cost
  of every update by memcg-hierarchy depth.

This patch removes those producer-side acquisitions entirely. The
producer-local inputs (PGROTATE_*, PGRECLAIM_PAGEOUT_*) become
per-LRU vmstat counters; WORKINGSET_RESTORE_* already captures the
refault input. prepare_scan_control() reads the raw cost signal
lock-free from those vmstats and folds the delta into a per-lruvec
accumulator. A dedicated per-lruvec cost_lock — not touched by
isolate_lru_folios(), move_folios_to_lru(), or folio_add_lru() —
serialises the accumulator RMW and the lrusize/4 halving check.
Hierarchy aggregation is implicit in rstat propagation, so the
parent_lruvec() walk and the lru_reparent_memcg() cost-splice both
disappear.

Trade-offs:
  - Signal freshness is slightly worse: cost reads see rstat-
    aggregated values that can lag until periodic / reader-triggered
    flushing. Decay timing is also coarser since multiple producer
    events may be batched into one read-side halving check.
    The cost signal is a heuristic feeding the anon-vs-file split,
    it's not a precise control loop — it's deliberately smoothed by
    the lrusize/4 halving.  Producing/consuming it with a tiny lag should
    not be perceptible.
  - Per-lruvec footprint grows by 2 unsigned longs + a spinlock,
    its a small cost.

== Numbers ==

Tested on a 176-core, 256 GB host. The benchmark drives sustained
swap-out/refault inside a tight memcg using vm-scalability/usemem:

  usemem -n 16 --prealloc --prefault --random $((256*1024*1024))

run inside a two-level memcg with memory.max=512M on the leaf
(4 GB anon working set has to fit in 512 MB -> continuous
shrink_inactive_list + workingset_refault). A 16 GB swap file
is used. Measurement is a 30 s `perf lock record -a` window
over otherwise-idle hardware.

Workload rates are identical on both kernels (the bench drives the
same memory pressure):

                          baseline    patched      delta
  pgscan_direct  / s      172,662     171,817      ~0%
  pgsteal_direct / s       67,162      66,306      ~0%
  workingset_refault_anon / s
                           40,696      39,830      ~0%

perf lock contention (total wait per 30 s window):

  Lock Name                Before      After     % change
  shrink_lruvec+0x770     722.84 ms    0         -100% (eliminated)
        (= lru_note_cost_unlock_irq)
  workingset_refault+0x167 385.26 ms   0         -100% (eliminated)
        (= lru_note_cost_refault)
  shrink_node+0x4ad       689.43 ms    26.95 ms  -96%
  shrink_active_list      208.34 ms    15.97 ms  -92%
  lru_add_drain_cpu+0x34    1.96 s    917.71 ms  -53%

  Total LRU lock wait      ~4.23 s     ~1.66 s   -61%

The two specific contention sites the patch removes
(shrink_lruvec+0x770 = lru_note_cost_unlock_irq;
workingset_refault+0x167 = lru_note_cost_refault) are completely
absent from the patched perf-lock-contention output.
Secondary reductions in shrink_node, shrink_active_list,
lru_add_drain_cpu and pgrefill/pgactivate look like knock-on
effects from removing the cost-recording overhead and the
parent_lruvec walk.

The remaining ~1.66 s of LRU lock wait on the patched kernel is
dominated by the per-CPU pagevec drain (lru_add_drain_cpu) and the
main reclaim path in shrink_lruvec.

The numbers above can be reproduced using the script in [1].

== Alternatives considered ==

1. cost_lock for both producer and consumer (no vmstat indirection):
   Keep the producer loop, just swap lru_lock for a new per-lruvec
   cost_lock. Decouples cost from LRU manipulation, but producers
   still synchronously contend on cost_lock, the parent_lruvec()
   walk is still required (O(memcg-depth) acquisitions per recording,
   now on cost_lock), and lru_reparent_memcg() still needs explicit
   cost-splice. We can do much better and this series removes the
   producer lock entirely and gets hierarchy propagation for "free"
   via rstat.

2. Attempt to switch to using MGLRU's scan model:
   MGLRU has no anon_cost/file_cost at all. It replaces the cost
   heuristic with generation-based aging: per-LRU sequence numbers
   (min_seq/max_seq) age folios into generations, and the
   older-generation type is the one to scan. So
   lru_note_cost_unlock_irq() / lru_note_cost_refault() are simply
   not called when lru_gen_enabled() — by design it sidesteps every
   concern this patch addresses.
   But MGLRU is not a substitute for fixing classic LRU:
     - It relies on a lot of things including per-lruvec generation
       lists, bloom filters, mm_struct walk infrastructure, working-set
       protection tiers and a whole sysfs interface. Replacing
       classic LRU's cost recording with the MGLRU model would
       mean dragging in all of that.
     - It changes scan-balance semantics, not just the locking, so
       it's a heuristic change we would need to evaluate separately.
       There are known regressions (database/anon-heavy workloads
       sensitive to swappiness, or file-cache-dominated workloads
       where MGLRU's bloom-filter protection differs from classic
       refault tracking).
   This patch preserves classic-LRU semantics.

3. Atomic cost counter:
   lrusize/4 halving has no clean atomic form, and the parent
   walk still has to run explicitly. Reusing vmstats gives per-CPU
   aggregation AND rstat hierarchy propagation for free.

4. Drop cost_lock from the existing patch and reuse lru_lock in the
   consumer (prepare_scan_control()):
   Saves 1 lock space per lruvec but re-couples the cost path to LRU
   manipulation, though just from the consumer side this time.
   prepare_scan_control() runs at the start of every shrink_lruvec()
   cycle, so under sustained memory pressure it would take lru_lock
   on the hot path and block isolate_lru_folios() /
   move_folios_to_lru() / folio_add_lru() i.e. when reclaim is
   in flight. A dedicated cost_lock is never taken by anyone except
   the consumer cost calucation.

[1] https://gist.github.com/uarif1/a4eb33a86c5b2d7bbc55b42f0956e884
 
Usama Arif (1):
  mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance
    cost

 include/linux/mmzone.h | 11 +++++--
 include/linux/swap.h   |  3 --
 mm/memcontrol-v1.c     |  4 +--
 mm/memcontrol.c        |  4 +++
 mm/mmzone.c            |  1 +
 mm/swap.c              | 69 ------------------------------------------
 mm/vmscan.c            | 64 +++++++++++++++++++++++++++++++++------
 mm/vmstat.c            |  4 +++
 mm/workingset.c        |  5 ---
 9 files changed, 74 insertions(+), 91 deletions(-)

-- 
2.53.0-Meta


