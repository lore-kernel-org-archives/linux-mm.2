Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE501C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A556B00A0; Mon, 13 Jul 2026 12:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB966B00A7; Mon, 13 Jul 2026 12:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23B36B00AE; Mon, 13 Jul 2026 12:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C48006B00A0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:34:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DC17120107
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:34:53 +0000 (UTC)
X-FDA: 84984302466.21.1B1F806
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 889B14000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:34:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=haNkL20k;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XGVzZk+EZbjQt/HAvFA/+T9A3SExi5ynlWA6au9+tbw=;
	b=xybATISrw2W3U4FNWZCdgzrU0tJIp4ypIsMBjS94hzLPs17SL0utrCz093LktwQDRBAHC/
	BSzl70+R7n+R+8ChQpFnFWIMordcVCnX11kZRtLkBHPi1PzEKCSUuXdQJF0XcUgdOOWVG9
	T6EuldwT564LfYYFuXDfRSpO/N1KU6w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=haNkL20k;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960491;
	b=XrTog3NQBTpqcpBu1Z1awr4YGY2VWNetC+if3QZbUIUy9WFRJyE7g/S6xrVmlHr2DptVKi
	XaK8DXW2C8L0K8nsmD+QFhog2FD8ovtrKf3xHIR0OxPoSb3JdaMRCXfcffl/p5iD9YjYJ5
	GpYxdILvHnrN6nLZSJgRdTERjHJGmN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783960489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XGVzZk+EZbjQt/HAvFA/+T9A3SExi5ynlWA6au9+tbw=;
	b=haNkL20kKANlYAa3K530QRSumtDpsJOOmJ7WWp1z+ekDmIZu6uxpyI/FPsopzKnfJLJbnU
	uvnI8Ebv+PdEiIt6zc6p7Y1ikMfAnYwqzIho94yJcOo9oq1EVfWSlVAgo9caBqRn7nOUID
	2AJXdXvpYLB07RdsFgwYRn+oZoBXD84=
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
Subject: [PATCH v2 0/2] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Mon, 13 Jul 2026 09:34:15 -0700
Message-ID: <20260713163443.3562378-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6ftgfnkr5g8u8ghxhcyitzzktiiwekpn
X-Rspamd-Queue-Id: 889B14000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783960491-345404
X-HE-Meta: U2FsdGVkX189M4NUQgsGdBqj81LjsOAgwBrpxNd7iSiNz7wcHYpMS6r4Pd6gXs8fX2uJBdPOTlsVc/dDA9Xk9OEh1eEimRpC0AOOBcoe9xORxeWWxdcAUUOnXDul5vOMwkH4d6uIIutDij6PVdTUSXeugMYCrKnquuajfoC+haPusjM+jAJtdbdMeM2HrZT8T48EtX1snZFsJPgVS/ZolNW3B5VF3A/XKl04gjHxgZ+SxQmqMS6E/IKJGgQ7B8wRqg35ef9U4FGs9PJYZ0n9Z4WyLZFkc7xduc2RYYJjCA2X0UcSz/w+zfNQ0a3wo93feFATgT4YCO1oVkaF00+39X/qgKNAbOuFxVHeTtMgPuUivPBq1IjGvFDsjVtbkAogKoH0piug0LOE54vMEKtKe9XG4kRJ7ga7s6bNQZ7+etIq3cu0lSWzjGgSVltBUaCXZyqs9KNuWXJ8rq2v1RMJxutGGXm0NQKzl/vVHZiqhbHM2uBY16UUrVXZ9iTHd3aa8l/vZOIW0Ipe3D14VR4GXEeOMVjH8j792tYxxcUlUQdF8kD5Z90TiFUYkFbrq37FhWznwdcmj7X+97IBVbIdzFdoIzEGhUAz7XRfz6V3GuQX2S9eYJa2GjLhCh+C7AmzhSQXm7L3BI2UFO0rN2jydO+Lzk+ruWAtvbG1IHLQEJtSwhyU3OHeHqrZdnLF7+/WISOohEYKlD5xKGzLbd1qVvCmdygY9sIH8/UPCObaqaHkSVSjMwB6tWGxnJ1RZdkflGTKH7dYOlN2LIm78ydkTy2BY4iFu6ra73hlCBihWPjEsBP0md9pMXMetX6Z3dAuXP1N9XQBjmHvPiKm3R67pGtq2Ky5IVPXpy7V3adI+AjIk/M/Mz4ELsVhJ6YvU5RJWEHGPpvRjszSBknwcZZEWBkxExSJ/AcL4uISwwDcy3CIevO8X6SmkAVmGCG2ENBemeIxxP5NqnKrzugJLBT
 9EJ83NK6
 bdQfma7wCSb3kLRfGHE/6JuS1kay6i2Sckj/ICibff5F7GeqcJW0d0V86K3LP2CfhCnsQ612w/vNKiBFwfaQNEeNizBYXmDOqHiXzhl8I2M9Z+jD8It5SPVIDCni8o4iBhwT50L2wU6x7R1mz+IHPvl8e9gpYNse/jt4+3OlzHYSNrGhqdoPJ/N41PMb3fvNE3v1ngb0v70G31rAZqL5N4yd1429ENl6rIWtPAE5brgFMFdgLk3wDoQWhcZH6RCcwYQfj5JzHzjPEZp90dCKJt5xhVk2UBWoOoKcMnj/yshRyHb0qXmqnJE2TTto7t3DeG4Q45CfG48BHlts=
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

This series removes those producer-side acquisitions entirely. The
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

Moving accumulation and decay to the reclaim side also improves the
cost model across reclaim gaps. With producer-side decay, events that
happen while reclaim is idle still age each other before reclaim ever
samples the costs. If a workload refaults a large anon set and then a
smaller file set before reclaim runs again, the later file activity can
age the earlier anon activity out of the cost model. The new scheme
observes the whole between-reclaim delta and decays anon and file
proportionally, so the scan-balance history better represents what
happened since the last reclaim pass.

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

== Series structure ==

  1. mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
     Non-clamping siblings of lruvec_page_state() / node_page_state() /
     global_node_page_state() for callers that snapshot a
     monotonically-incremented counter and subtract two samples.
     Unsigned modular subtraction on the raw wrapping value stays
     correct across a signed-long overflow that the existing clamp
     would otherwise turn into a huge spurious delta (a real hazard
     on 32-bit).

  2. mm/vmscan: reduce lru_lock contention via vmstat-derived
     scan-balance cost
     The optimization described above; samples PGROTATE_*,
     PGRECLAIM_PAGEOUT_* and WORKINGSET_RESTORE_* via
     lruvec_page_state_monotonic() from patch 1.

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
   This series keeps classic LRU's scan-balance model and fixes where
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

v1 -> v2: https://lore.kernel.org/all/20260706122954.3552990-1-usama.arif@linux.dev/
- Sample via the newly introduced lruvec_page_state_monotonic()
  to fix a 32-bit delta underflow when the underlying signed
  long wraps past LONG_MAX (Johannes and sashiko)

RFC -> v1: https://lore.kernel.org/all/20260626122009.75334-1-usama.arif@linux.dev/
- Document in coverletter and commit message  how the read-side vmstat accumulator
  improves cost-model aging across reclaim gaps (Johannes)
- Fully decay the cost_accum below lrusize / 4 using a while loop (sashiko)
 
Usama Arif (2):
  mm/vmstat, mm/memcontrol: add _monotonic vmstat readers
  mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance
    cost

 include/linux/memcontrol.h |  8 +++++
 include/linux/mmzone.h     | 11 ++++--
 include/linux/swap.h       |  3 --
 include/linux/vmstat.h     | 16 +++++++++
 mm/memcontrol-v1.c         |  4 +--
 mm/memcontrol.c            | 40 +++++++++++++++++++++
 mm/mmzone.c                |  1 +
 mm/swap.c                  | 69 ------------------------------------
 mm/vmscan.c                | 72 ++++++++++++++++++++++++++++++++------
 mm/vmstat.c                | 15 ++++++++
 mm/workingset.c            |  5 ---
 11 files changed, 153 insertions(+), 91 deletions(-)

-- 
2.53.0-Meta


