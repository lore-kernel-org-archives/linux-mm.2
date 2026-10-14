Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA0BACC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B763A6B008A; Wed, 14 Oct 2026 05:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E336B0092; Wed, 14 Oct 2026 05:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A9B6B0095; Wed, 14 Oct 2026 05:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 814D76B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:00:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6219140441
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:00:58 +0000 (UTC)
X-FDA: 85320636996.04.79BDF65
Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id A333114000B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:00:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xL2T0Y4e;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791968457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FJ9LqYfdMTA6wgjl1FHWHY/H8GrR1turSt63lgpd3b4=;
	b=5UkBPVrdrIgAG4eOeupk4s/sDgXczGXoizQxSuh/tsTXMrwkkLwzBjmVc6IkbMlCwWS5zL
	pl5uAA9hCtnQM5e0uKQ9VvROWGNLG6jhi7SIG/0FQiPX1xsvPcAWnnO29v+xOoz7c9MgYc
	1fyhZuBtwSPHORSme0yX9ro6g5hIxJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791968457;
	b=gVC+I1/vtRsD2btbArkUXTYoFNy8DqX3mn+fxfgPe0Ip2Dcd2iMJ4DiXMPm1FXi6VinU9Q
	wE9y0yvvAg4f340iFSnnGNP5sEx9JUSSicejyhOzwXMyNc1af7oL1RnQXbMiKqG11zRPIe
	xiM9dpaWpKlqRy/LI/BQoF6z2j2lYjg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xL2T0Y4e;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f83gIxzX791HXNUe8bdGB2JhxsHCRMrxjMWV0SswPjc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791968455; v=1; x=1792573255;
 b=xL2T0Y4erlXpf6tODGDdRmVfGzpvIesXM+F6+FmYxid67fyqDb6FHYFluy1zKP7BnjcbVlVY
 +TalaytCWLlabZSvoEOL3Xl44Sq44YZlTEwTzlpOgEgi6H6JflvnGKiYDeeR7y7HDPuuoCk+9zA
 Hy7uga45YGKLa3g8acHN3wiQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8638e9c036146f7d;
	Wed, 14 Oct 2026 09:00:54 +0000
X-Mizu-Trace-ID: 8638e9c036146f7d
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v6 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttle MGLRU eviction
Date: Wed, 14 Oct 2026 17:00:22 +0800
Message-ID: <cover.1791968227.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A333114000B
X-Stat-Signature: g33up33jh97wz4rio65gexa6uugotd1j
X-HE-Tag: 1791968456-653130
X-HE-Meta: U2FsdGVkX1/7OANTFveuDZkFPP8+6mRpFeuC0/Dzz61ttKKC3KwM7xAK+/7JQDOnFiZWcnH4kMlfdAnjWAJr4wZMnPbFhoVJN/TrHEK+OnMuMqgz9nOFql2c1zBuWenJg7bL1SyV6mb/qelcWWLidRKIhxGoE9vmI2koMJBnn8A8VLCUp/oSJszbAkYv7deE5vqYB8xS3bb31U+WUz8FTa/56+D77/4o+flkH0mB7lqLPKjvk2M33rH5QhzsA77Mtc9jy8DEVPxGEz74rd+vzCf62krYjFKTvFIitW0QTaSc4ks7AlNEPtyzGU+kzO80CK+wKicrpY7ObjC+1BIbt25iAmb0T1P9wEQrscu5DsqobUqhhgRqp9KelQyorW7hSH+ih2pYH6z10/jD1066EDj0d67Q3xJUC/qe2Gi8joadmJ3HevpYmDlGk5XOxQm+uKSweGbAf8lstIwK5MeFY5y8V9GwJ/Y5J9c3A/aZu0/yV5bwGQKFQeK2nTeGHS5p86sogCn6jY2YWbBQ5f2pf88kfRORLPuIW6EpZRcvR4uXcUIuQ3NGqnYkKAR0AjCeVNtr4V7uho35wKh00riEwVal3gSwSLb1l1g/v+3asSLEsPWEXhFKco29malgF8yts/kDzxrXPuu0UpNOHvTcZRxxQT9JywhEnUiUm/e4+gu3vqGqzWbXsIVuXA/VFMCLRowaYff2tAUQlR4src7nj4C8GNkrYgAiRmORwKMVAIYzZYwJR8CuoubUvBwFXhPEXWooGuGhRBeJFFavYOX92PC7+miF9VTXFu5/XKRTrv1zpyF0vh12fWcGHyGYPmsfcrFTUyhh07xQl7UUX91m337rTVCpTNmQYfqnMSj8dJUvDL+oHFBdt1EATyyqppoggdOqybpYedMPZrg+iAN8rb3TUSE/rRepfiPiofNkI6XbA/iWqx9P0VNzFvtTS7DYHMz+arvnY+FTb19eTff
 bfffjrAr
 hveCkouuE8uZDRChpS1aSA8K50a5rB/kXu9S/0ookjUr61z9hX+q9zD8pby/wUVebfWLVs7Wgi8tstN+wQdEagvbQN6+fJxnNrbyJ18UNhKl/TBT2W6eD8EiDFy/MpwzgDYLi4WllUwtMuRvcy4Dk6tKve+gGAhBFrcq4FCBsAemURScdHktXfMdQEQN5pZxAuhJ8AjhGnPJkmmCD/s98tUFrjrKla3WOC+XeYemVTVzhmyKxRgnNdM+CkhybklG8wbNB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Barry asked for a real-world workload that suffers from the missing
throttling. This version adds one: a CI-style kernel build inside a
memory-limited cgroup with slow storage (mglru_build_repro.sh),
measured at three pressure levels, plus redis-based cache service runs
as no-impact data points.

The series is also rebased onto the latest mm-stable; patch 2 is
adapted to the current isolate_folios() type-selection context
(is_single_type_reclaim()), with no semantic change.

The legacy reclaim path has two mechanisms around isolated folios that
MGLRU lacks:

1. NR_ISOLATED_ANON/FILE counters are updated when folios are isolated
   from the inactive lists. Compaction's too_many_isolated() relies on
   them to decide when to back off. The MGLRU reclaim path never
   updates them, so compaction cannot see MGLRU's in-flight isolation.

2. shrink_inactive_list() throttles direct reclaim via
   too_many_isolated() when isolated folios pile up. MGLRU's
   evict_folios() isolates folios without any such check, so many
   concurrent reclaimers can over-isolate the same (oldest) generation,
   leading to unnecessary swapping, thrashing and premature memcg OOM.

Patch 1 fixes the counter accounting in the MGLRU isolation path.
Patch 2 adds a per-lruvec throttle, mirroring the legacy behavior but
adapted to MGLRU's per-lruvec contention and its dynamic type
selection/fallback.

Testing
=======
Five test scripts are provided: the two synthetic reproducers from v5
and three real-world workload harnesses new in v6. All are available
at:
https://gist.github.com/teawater/3ef51251f2e91a5a600e3d26bb477e34

Common environment: 10 CPU / 8GB QEMU guest, cgroup v2, MGLRU enabled
(0x0007). "unpatched" and "patched" are the same tree built
without/with this series; every configuration is run with identical
parameters on both kernels. Each cell below is one run; the build
metrics are cumulative counters over a 1800s window, which smooths
run-to-run noise.

Real workload 1: CI kernel build (mglru_build_repro.sh)
-------------------------------------------------------
Models a CI build pod (k8s / OBS / gitlab-runner): repeated
from-scratch "make -j20 vmlinux" rounds inside a memory-limited
cgroup, with the object tree on ext4 over dm-delay (10ms) to model
slow/congested storage. 20 concurrent compilers charge into one memcg
and enter direct reclaim at the same time, while dirty object files
stretch the isolate->shrink->putback window - the workload shape
too_many_isolated() was invented for. Each kernel runs 1800s per
pressure level; the headline metric is the number of objects actually
compiled in that window (a full round is ~3,800 objects).

memory.max = 1024MB (extreme pressure):
                        unpatched       patched
  objects compiled      4,744           7,211 (+52%)
  pgscan_direct         2,901,083,521   2,228,776,807 (-23%)
  scan efficiency       0.195           0.242
  workingset_refault    565,169,241     537,686,479
  mm_vmscan_throttled   0               511,441 (all
                                        VMSCAN_THROTTLE_ISOLATED)
  nr_isolated peak      0 (invisible)   1,152

memory.max = 1536MB (heavy pressure):
                        unpatched       patched
  objects compiled      18,969          25,124 (+32%)
  pgscan_direct         1,223,905,508   816,812,074 (-33%)
  scan efficiency       0.320           0.338
  workingset_refault    390,048,986     273,442,445 (-30%)
  memcg charge fails    8,344,775       5,868,167 (-30%)
  round wall time       199-391s        182-275s
  mm_vmscan_throttled   0               503,117
  nr_isolated peak      0 (invisible)   1,053

At both levels -j20 is oversubscribed (20 cc1 processes need ~3GB of
anon in total), so rounds end with a cc1 being memcg-OOM-killed on
either kernel. Normalized per completed round the kill rate is the
same (13.2 vs 13.1 at 1024MB, 5.8 vs 6.1 at 1536MB); the patched
kernel simply reaches that point sooner because less time is burned
thrashing, so it cycles through more rounds. The patches do not claim
to avoid these OOMs - the point is that the patched kernel performs
23-33% fewer futile LRU scans and gets 32-52% more build work done in
the same wall time.

memory.max = 2048MB (light pressure - no-harm control):
                        unpatched       patched
  rounds completed      6               6
  avg wall time/round   271s            270s
  scan efficiency       0.984           0.978
  mm_vmscan_throttled   0               0
  nr_isolated peak      0 (invisible)   144

When reclaim keeps up, the throttle never fires and both kernels
perform identically. Patch 1 still shows: the unpatched kernel reports
nr_isolated=0 even while isolation is in flight, which is exactly the
blind spot it fixes.

Real workload 2: redis cache service (mglru_redis_repro.sh,
mglru_redis_shards_repro.sh)
-------------------------------------------------------------
A redis-server serving a 1KB-value dataset larger than its 96MB
cgroup, with swap on dm-delay (50ms): first as a single instance
(100k keys, 200 clients), then as 8 shards with AOF persistence on a
second dm-delay device sharing one cgroup (8 concurrent chargers).
The bottleneck here is swap-in I/O serialized on redis's single
command thread, not isolation contention: charge-induced reclaim is a
trickle (~400 scans/s vs 10^5-10^6 scans/s in the build runs),
isolation never piles up, and the throttle correctly stays dormant on
both kernels:

                        unpatched       patched
  single instance       41.6 ops/s      41.2 ops/s
                        (avg 2999ms)    (avg 2999ms)
  8 shards aggregate    333-419 ops/s   310-358 ops/s
                        (mean 376,      (mean 335,
                        4 runs) (*)     4 runs)
  mm_vmscan_throttled   0               0 (all runs)
  nr_isolated peak      0               0

(*) the aggregate is dominated by a preload-end residency lottery
(which shards' datasets happen to stay hot) and swings by up to 26%
between runs of the SAME kernel; with 4 runs per kernel the
between-kernel difference of the means is within that noise (Welch
t=1.95, p~0.11). The throttle never fired in any patched run (the
tracepoint covers preload as well), so both kernels execute the same
reclaim path here, and the kernel-side counters agree across all 8
runs: steal/scan 0.59-0.63, swap-ins == refaults, zero OOM. These
runs document the no-impact side: the check is dormant unless
isolation actually piles up.

Synthetic reproducers (unchanged from v5)
-----------------------------------------
mglru_iso_repro.sh (64 threads, 48MB working set, 60s):
Drives concurrent direct reclaim inside the memcg and measures scan
efficiency, throttle events, in-flight isolation and throughput.
Neither kernel OOMs at this concurrency; the value of the patch shows
in reclaim quality:
                        unpatched       patched
  OOM kills             0               0
  mm_vmscan_throttled   0               35645 (all
                                        VMSCAN_THROTTLE_ISOLATED)
  nr_isolated peak      0 (invisible)   230
  total touches         246,499,132,369 301,456,426,692
  scan efficiency       0.0261          0.0194

The patched kernel completes ~22% more work in the same 60s: the
throttle keeps concurrent reclaimers from trampling the same
generation, so less CPU is burned in reclaim. Note nr_isolated is
always 0 on the unpatched kernel - the over-isolation is invisible
there, which is exactly what patch 1 fixes.

mglru_iso_repro_v2.sh (192 threads, 48MB working set, 60s):
Raises concurrency to the point where over-isolation becomes fatal:
                        unpatched       patched
  OOM kills             1 (task killed) 0
  memcg oom events      51              0
  mm_vmscan_throttled   0               512292 (all
                                        VMSCAN_THROTTLE_ISOLATED)
  total touches         0 (killed)      682,300,000,972

With 192 threads the unpatched kernel cannot keep reclaim ahead of
allocation and the task is OOM-killed; the patched kernel survives the
full run and keeps reclaim making progress.

Changelog:
v6:
According to the comments of Barry, add real-world workload tests:
a CI-style kernel build (repeated "make -j20 vmlinux") inside a
memory-limited cgroup with its object tree on dm-delay-backed storage,
measured at three pressure levels (1024/1536/2048MB), plus redis-based
cache service runs (single instance and 8 shards sharing one cgroup)
as no-impact data points. New and updated test scripts are in the
gist. Rebased onto the latest mm-stable; patch 2 is adapted to the
current isolate_folios() type-selection context (is_single_type_
reclaim()), with no semantic change. Re-run the tests and update the
test logs.
v5:
According to the comments of Kairun and feedback from the test scripts,
make the throttle check per lruvec (new nr_isolated counter) and skip
empty types in the allowed mask.
v4:
According to the commens of Baolin and Barry, rework patch 2:
drop the throttle_is_throttled() helper extracted
from shrink_inactive_list() and leave the legacy path untouched.
The new MGLRU-only throttle_evictable_types() only sleeps when all
evictable types are over-isolated - v3 throttled as soon as any of
them was, which unnecessarily blocked the reclaim of the other type
and passes the mask of the remaining types to isolate_folios(),
which restricts both its initial choice and its fallback, so that
isolation never lands on a throttled type.  The v3 gate did not
constrain the type actually isolated, so the fallback could still
pick the over-isolated one.
Re-run the tests and update the test log.
v3:
According to the commens of Baolin, remove the redundant nr_isolated
check before restoring the NR_ISOLATED_* counters in evict_folios().
rename the extracted helper to throttle_is_throttled() to avoid
confusion with the existing wake_throttle_isolated() naming space.
Use for_each_evictable_type() in the MGLRU throttle to check each
evictable type's isolation instead of only the type returned by
get_type_to_scan(), since isolate_folios() may fall back to the
other type.
Re-run the tests and update the test log.
v2:
According to the commens of Kairun, Rebased on mm-unstable.
Split into two patches; patch 2 is new and adds the
too_many_isolated() throttling to the MGLRU eviction path, which v1
did not cover.
Add test infomations.

Hui Zhu (2):
  mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim
    path
  mm/vmscan: throttle MGLRU eviction when isolated folios pile up

 include/linux/mmzone.h |   2 +
 mm/vmscan.c            | 174 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 163 insertions(+), 13 deletions(-)

-- 
2.43.0


