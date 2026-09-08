Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9D5C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 22:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766E86B008A; Tue,  8 Sep 2026 18:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717956B008C; Tue,  8 Sep 2026 18:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D216B0092; Tue,  8 Sep 2026 18:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 399E36B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 18:10:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE953A4B9E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:10:08 +0000 (UTC)
X-FDA: 85191988896.21.472B493
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0416B14000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:10:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kVRUFHgg;
	spf=pass (imf23.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788905406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ksS/sqihzeitEmR3gs4ZAWpLpAasNILlLxHLkoz4JAU=;
	b=WfT+RNyMRoor1JPFMP2Ciu04l7L2+eZDwPLfUGYY+z4/krQKiY7K7hK+x/noDZ+2JW+HRG
	1tq6wiR5BlW4EKHAyQjD/G+Ffs49rUGePTUP3AVLj3ygL5zWzQoJ1M1P/xfxKtsYxdvDjs
	27tobmeFWIkdVKcBdCeUb182yUOImGM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kVRUFHgg;
	spf=pass (imf23.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788905406;
	b=kfbP2C8v3dx5zTg34ThCd0SHrfYUfCLzyYOuVed1T9aBE8RowY5VLspTotx/fAS5cMBUdC
	ji+/T9AcU09byF1v80yjFLD5xffplODFN07znnY1OzWMMbgsC5Adjkrc9rNtXuJnhYExwI
	4D5P1sZfiGY73TeGZGiIbumZ/uUCSCk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788905406; x=1820441406;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Q/jc42japFqRPbNGvUXBNitZamAzzq9svYH+Tr1/9No=;
  b=kVRUFHggFWQjQAb697kyhjuq3nH7VhUx60iiNrMTQ8QAsIHdI2XqRHoe
   Is4+DP+h1siVu5wlRBjRMJGoPJuCze030zHH36O29W8C5JO5EyHnUiDTg
   hmbuGJ52glCeMCQKx1WMhSZHP+ZQnFSVzQ2TZO4iuIA2SntZF9W6jMwqe
   DiOF5aOabthVoJHGiIShiggviJD0vGN/VVw7CqwqPvG7ZrsyWCd2fAGJs
   UN79Os+PX34MRGjnnp93B6e+JEAC3lydWx/h5upLBqi771M9kdotJpXU8
   yHs3E7bKg31S8vpAOQ3Lo7Gk8pH7+exsg2eH4Fn41nYCk04Wdxaf+FNdO
   A==;
X-CSE-ConnectionGUID: FkQT7avoS0ewJU2H94VcSQ==
X-CSE-MsgGUID: bwy67b8mSVKpMF/90ZtbFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="93017360"
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="93017360"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 15:10:05 -0700
X-CSE-ConnectionGUID: tRGcOBcSTmKezjo7GGigCA==
X-CSE-MsgGUID: SzgLCzq9Q+SBHFyfiT+p2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,269,1779174000"; 
   d="scan'208";a="296067704"
Received: from jf.intel.com ([10.165.154.102])
  by fmviesa001.fm.intel.com with ESMTP; 08 Sep 2026 15:10:04 -0700
From: Ehab Ababneh <ehab.ababneh@intel.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] mm/vmscan: adaptive multi-threaded kswapd for NUMA-aware reclaim
Date: Tue,  8 Sep 2026 15:10:53 -0700
Message-ID: <20260908221059.14777-1-ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ji5t5bmppkdueij4wf1g4k7jw4i4kmft
X-Rspamd-Queue-Id: 0416B14000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1788905405-326462
X-HE-Meta: U2FsdGVkX184h8JDnggydmfApb41L40RGrUf7XTXIAut4YKoYg8FES1Qdoy1I5jxn4lRsZ8pgGh2jQibQtcspGqI7zJy5zNtxkDA6cI5NhIvPaJyPXVNrYNAeHtOaU43NYhQ1TFgHIFFxXtAGQNlRVMR1Pbk7roeIg8Y1gfLSLn6wWjansY1GaXpYwdPT4NzNUPmediVqANyKpK0adzwNujeKVs76q0iOLwKtCqjSM5B+n3YoR2U4IAJfE2hRrPe2BwjA/+UmugJ5jfHDdDpeu6p/Jo5i1fh6gICAGqdqpIxZZZJIL/Efg0+9xnJgCxXDKBIcIXZKpz0qXvoJX3epmlGX7De2Vh3oCsVX+3mCBHRyQ1yxh4dqju9jQwaU8IJ4V2a5pYjwGpOhnjCSkzk8B4jwZML6uei/bokzoI9YEiBfjZpkvYWQoxViIV6Wk+EA7kNb8OKU3dcIxo24iqjBvtlpBuqxpt1BA3DS2UyyndMGh9TFA66bPyv39afKZUrAVrznvuG8jAHVRqbHeX06SEMynabNaGUfOgNay1+NWO2DQZh2xQhaIPvNv6LYxYR2aDQWtnew6mZJqOcu9hA/CWgE5jUN+WMdcosqFqM676btpROYz94U5dKWz4pQKdNo5fIW31TmSnmgMCskSrF1Ah033TFVxd72WB1MWlLJRxPkS23JzUFKvJDy9dCVD1r4Wh1WoPs9/Efg+cOd3wt1hLg0/MAFIW6O1odePkjw2NizYYYUE8s34BBAX1MDRHlrhmJ2yBrdXy3UQ8HpQN+tEoB+fcjsDnWW/m+Azpcb1YsEVFURUeaOYWEWC1orKvV21iOmLBdtxm9sFjgE05WgaCCUu4iB/EZkc6x8vr77rMvMdtxsWp7z291ooG/SQUcmcTHOAuuANfLu/mtWomS+vJI6ChN1IrBU7M/Au4AgSJ/EWTi8SP4nq4yl+nkcKQ8TzW59Cy0IGQkMqXrlO5
 O1+XMQ02
 5SCFTqmv8GLiQct47FKxffmczizhGj81tgwvxpf8NhN+CBqxlTRPMo7Mx0dOksWn15ATi1RWjTWNXCQ9co7Vf2+kUSoNWnKcP7ABtSCHZPJdzAo34/YR5Eg9YS0M0gc37I8GIxyhfiqWlmMWEvl5o3d81SBUZgLpPwB8fGn3jQD/4pYVeOs3hK+fa9YKnmKQhlDeFDvAkMuDYGA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series revives Buddy Lumpkin's earlier multi-kswapd proposal:
https://lkml.iu.edu/hypermail/linux/kernel/1804.0/00342.html

The motivation is stronger now than when the patch was first discussed.
Many current systems have hundreds of cores per NUMA node, not the
single-digit or low-tens core counts that were more common at the time.
When reclaim does not keep up, direct reclaim can still push allocation
latency into application paths and leave substantial CPU capacity waiting
for memory to be freed.

This patchset adds adaptive multi-threaded kswapd. The wakeup policy uses
node load to decide how many kswapd workers to run, so reclaim can scale
when it helps and stay conservative on already busy nodes.

Series summary:

1. Allow multiple kswapd threads per node and add control plumbing.
2. Wake an appropriate number of kswapd threads from per-node
   runnable load.

Concerns from the original discussion and how this series addresses some
of them:

- Concern: Direct reclaim is intended to slow a memory-hogging thread.
  Response: That can be acceptable on lower-core systems. On high-core
  systems, idling many cores while reclaim catches up can cost more than
  allowing reclaim parallelism to scale. It can also block higher-priority
  tasks in direct reclaim while they perform reclaim work on behalf of
  lower-priority memory-hogging tasks.

- Concern: More kswapd threads may hide deeper reclaim issues.
  Response: This series is additive to ongoing reclaim improvements. In
  our testing, multi-threaded kswapd was able to improve performance on
  top of what multi-gen LRU already provides.

- Concern: Existing knobs (such as swappiness and watermarks) should be
  preferred.
  Response: In our testing, those knobs alone did not reliably hit
  performance targets and could increase CPU cost for the same workload
  objective.

- Concern: Need evidence from real workloads.
  Response: This cover letter includes Cassandra results showing higher
  throughput and lower response latency.

- Concern: More reclaim threads may increase pressure on well-behaved
  tasks.
  Response: Adaptive wakeup addresses this by choosing thread count from
  node load.

- Concern: Additional configuration can increase operational complexity.
  Response: The user-facing interface is intentionally minimal:
  max_kswapds_per_node.

- Concern: Lock contention may serialize workers.
  Response: The Cassandra runs below still show net gains, indicating
  contention did not erase the benefit for this workload. The wakeup path
  now uses wake_up_nr() against the existing kswapd_wait queue, avoiding
  pgdat->kswapd_lock (a sleeping mutex) entirely on the allocation hot
  path.

Real-world workload results (Cassandra):

Tests were performed on 7.0.0-rc1.

- max_kswapds_per_node=1
  - throughput sample: 171146
  - reference latency value: 6.375
  - op rates: 43256, 42731, 42341, 42818 ops/s
  - p99 latency: 6.3, 6.4, 6.4, 6.4 ms

- max_kswapds_per_node=8
  - throughput sample: 183639
  - reference latency value: 6.0
  - op rates: 45791, 45253, 46534, 46061 ops/s
  - p99 latency: 6.0, 6.1, 5.9, 6.0 ms

Observed improvement in these runs was about +7.3% throughput and about
-5.9% response latency, which shows practical benefit for production-style
database workloads.

In our runs, performance numbers were essentially unchanged with and
without the adaptive multi-threaded kswapd wakeup policy. In both cases,
they outperformed the single-kswapd-thread baseline. This indicates the
adaptive method preserved the multi-threaded performance improvement.

Addendum: alternative approaches evaluated

- PSI per NUMA node.
  I prototyped PSI-based node pressure ranges to drive wakeup count.
  This became cumbersome because robust PSI-to-thread mappings were not
  straightforward across workload types.

- CPU mask snapshot policy.
  I also tested a simple CPU mask snapshot approach.
  While functional, it reflects a moment-in-time view and does not capture
  pressure trends over a broader sampling window.

Buddy Lumpkin (1):
  vmscan: Support multiple kswapd threads per node

Ehab Ababneh (2):
  mm/vmscan: handle racing max_seq advancement
  mm/vmscan: make kswapd wakeups NUMA load-aware

 include/linux/mmzone.h        |   5 +-
 include/trace/events/vmscan.h |  28 +++
 mm/compaction.c               |   8 +-
 mm/internal.h                 |   3 +
 mm/page_alloc.c               |  26 +++
 mm/vmscan.c                   | 419 +++++++++++++++++++++++++++++++++++++++---
 6 files changed, 465 insertions(+), 24 deletions(-)

-- 
2.43.0


