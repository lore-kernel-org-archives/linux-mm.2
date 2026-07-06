Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30292C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A776B009E; Mon,  6 Jul 2026 08:30:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CAA6B00A1; Mon,  6 Jul 2026 08:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148F26B00BF; Mon,  6 Jul 2026 08:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFE386B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:30:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5769A1A03C9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:30:05 +0000 (UTC)
X-FDA: 84958283970.08.5862529
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf18.hostedemail.com (Postfix) with ESMTP id ACE4F1C0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:30:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IuqhZc3d;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783341003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IiKzO679j946ruJWISndrjcXB8nvv67rJegLpTIoBQw=;
	b=0Qs82CqQYutmlP43GL+jiyVp8nH9btOj3hbdOF9ZM2mRIC1p5t77ZfvOMIJdr17S23gWxg
	Ii+WsKGp1dgpgE9SC+NyzVsP0rxJ4gU2JEZPUp+r0NgDRuaKzbw1m26dNFO0X9tTK9kFbY
	w3DHF3s+iRQmx1b0LNaqHutVgiLQWF8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IuqhZc3d;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783341003;
	b=8pvoCLN2JkVTn/xQSR3OkttI+jJVPA+oMGWsfvTLYjidYGZVomvjoz1BDTvtqXy3fGD0eP
	puK/g9Vf+nWElZ+hOgG/taxgilVSvBtZVn3q3UrJaZ7d8I0OtULu8W6q145Zb0F3DT/BKp
	BVpp/1VUv+Qc+wxP8nqTA/BL5XjMLOk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783341001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IiKzO679j946ruJWISndrjcXB8nvv67rJegLpTIoBQw=;
	b=IuqhZc3dWKvM2dM8E56GYDoiXtJLX/9wst49KebJUrRJM4YyoAcWG2HpVx7Gs4AysucrLy
	maCYO/OmWmNi089aXRjrb9D7xFKHAxat2lOhx0nypoM3tbt4gqTXpKFzB8Qe/9j/KB30o8
	Epiek91tCVyyA3oMTRIfJCjmYoHzgIU=
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
Subject: [PATCH 0/1] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Mon,  6 Jul 2026 05:28:25 -0700
Message-ID: <20260706122954.3552990-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9ysgx4dxcmf99365ahzim6zduzh1bsxn
X-Rspamd-Queue-Id: ACE4F1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783341003-948117
X-HE-Meta: U2FsdGVkX18gCF/xeiyh6v96F1uOeRWbX9oBSxrtMwo/hWs6clWwvwBiuuqE0YuqE9K4C9YIAPkIgR4WZbcpGX79stVSj7nRSQPk98Iu73AmgBt3XayHLW0ujwaTqEPod9Lvw5tVCs6ZI2wT4STqiU0w5ogJDUaL16G0BmOHAtgPvRNLH7NrCSh+Jdsq4lEhfWsVvx/9YADjW6cP3bVMNX+7p2eMFlzAL1QlKre1ewf3JM/TOUFMjO6dGQ6Iter6s9UKsJD+uRSATep3kya/YnzQCehGWeGISPzOInOAOSlLrknhV8+Gw837Z7lJ5J455Wj/iomJuVfWsfvOMUEBS5O4RVNrzvCf6QWqELzENieNQ4xIVX9yYB5ANfHeLIAzF0ROeDQpWM4ga4BSfr+xfb0yABo8dXjaG8+pOTEf0hYBqLnM5NIdUTnhbmueYk0cgVJylrbx28SWMTV4QqRDR4Aowcv0cdMHW7g8YKxal5f51O56LSYSmI483GKASMWulIY6RSeH30KK2Q0uI1pm6ZVj7ni1nizlA/rK/DRWZMHE9lNMqfJIUN+kPsJmS8qd8QWHIguQWjS8CTN3K0NwdgGy6ZPk+P5jxPseUi1Rg84/46orSCympqo8q5F0TuXVivmP+EQSbtFToygThooD7WWpoQz2s1q2BFBHj89lgly1iaCys59cVWxjykIyT1GYV66Jl+4/D18jICvtDYU6+hTVf20MlodVk/G2D5ZiwQZ9fTPsg2Rt6QfuUAXfiazteR+K7jjw8wiSAO3/Kgdtk9g+7BfwWPrZBtEnl84VyvHIPHFcaLKe82JQSRD8euEVIZwx436QlACgKJq2jenCBKLAGDy2/aWLKuRE+V6LBcmHoyeb3XOOu77Im1UnwK9Tvu7xjrR/kGUb8W3fTbNfI66KCZVb8h3JAxjYbrCdu4gqcCFkBhnrI7lVDmVIEnHV/4SkjfD8GzLW2IwnDrr
 x+w0HP5A
 nNE1BIm9/za+NEIrtvtTvC4qUjQ+I9vRUPsBdmuHYxCA4d6plrgaJ7vMBC2tU5Evfb/skWwhBfakQWuDRuazVh1SGamz4g96IPXFAAmZrrCCxu0FaK94qk9Y7oOqOzwZ26QYGItyPpFXVgc1qvMIhAP2mKNXFq3IHBuHbBH+/H/G3TA00eRwUGEyHkwJUhNmpISZhEqD7uB+OK7ljs9rBBpexx3h1qoq99xJpXAyIhOOxfJCiaiVMDEMGos4bDyz+PN7xHXos6jfLtfRd/tSzGI2WIYrEAIIFe+nQ0mNDD3oCAHuH4pDYGX+eKDADXjJB489PAbY11vl08m0=
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
contention on lru_lock - which is often a contention point on
memory-pressured workloads. Specifically:

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
accumulator. A dedicated per-lruvec cost_lock, not touched by
isolate_lru_folios(), move_folios_to_lru(), or folio_add_lru(),
serialises the accumulator RMW and the lrusize/4 halving check.
Hierarchy aggregation is implicit in rstat propagation, so the
parent_lruvec() walk and the lru_reparent_memcg() cost-splice both
disappear.

Johannes pointed out that moving accumulation and decay to the reclaim
side also improves the cost model across reclaim gaps. With producer-side
decay, events that happen while reclaim is idle still age each other
before reclaim ever samples the costs. If a workload refaults a large
anon set and then a smaller file set before reclaim runs again, the
later file activity can age the earlier anon activity out of the cost model.
The new scheme observes the whole between-reclaim delta and decays anon
and file proportionally, so the scan-balance history better represents
what happened since the last reclaim pass.

Trade-offs:
  - Cost reads see rstat-aggregated values that can lag until periodic /
    reader-triggered flushing.
  - Per-lruvec footprint grows by 2 unsigned longs + a spinlock,
    which is a small cost.

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
   This patch keeps classic LRU's scan-balance model and fixes where
   its cost history is sampled and aged.

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
   the consumer cost calculation.

[1] https://gist.github.com/uarif1/a4eb33a86c5b2d7bbc55b42f0956e884

RFC -> v1: https://lore.kernel.org/all/20260626122009.75334-1-usama.arif@linux.dev/
- Document in coverletter and commit message  how the read-side vmstat accumulator
  improves cost-model aging across reclaim gaps (Johannes)
- Fully decay the cost_accum below lrusize / 4 using a while loop (sashiko)

Usama Arif (1):
  mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance
    cost

 include/linux/mmzone.h | 11 +++++--
 include/linux/swap.h   |  3 --
 mm/memcontrol-v1.c     |  4 +--
 mm/memcontrol.c        |  4 +++
 mm/mmzone.c            |  1 +
 mm/swap.c              | 69 ------------------------------------------
 mm/vmscan.c            | 67 ++++++++++++++++++++++++++++++++++------
 mm/vmstat.c            |  4 +++
 mm/workingset.c        |  5 ---
 9 files changed, 77 insertions(+), 91 deletions(-)

-- 
2.53.0-Meta


