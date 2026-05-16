Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A2BCD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 21:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313446B0005; Sat, 16 May 2026 17:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4776B0088; Sat, 16 May 2026 17:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2C66B008C; Sat, 16 May 2026 17:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A95D6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:04:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1122140438
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:04 +0000 (UTC)
X-FDA: 84774510408.13.5CCC4A1
Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	by imf28.hostedemail.com (Postfix) with ESMTP id EB5DBC0007
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SKP5EoTP;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778965443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9yKlsY6+9+MZ7mU7SmEl9YWbtOg8xFpSDNXLhXZWgGQ=;
	b=hhSzZ5wVszcnh9dJ9Xwd/osksXCz8HPaRTXzB3zMPkKM0AMhssMtMuRpChTJSta9pYxHC3
	lsQMvCJFc7eA5aaVbw0N7KfayixFq5H0O0MVWqUDIN7DHnpAGCzFW+CTiCzUQnP92HdbWz
	ydD7VitdhOe3V1Kl9AK1VLWNseyS/9c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SKP5EoTP;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778965443; a=rsa-sha256;
	cv=none;
	b=F3QgStONzbng8blPpNU72cQGaM9rPBotXe1YotvKoTA5rWM956wuWZZlExNnCg98T8smL4
	8ZOXag0T8e6v9Q7j3NVs7hRupOd3wf7TyCaqr+qLtY2wzP+uEof2/OPR43tMzkmPfrPA3z
	/j3SuHhClf5SElpc2A7eUvrwbfzFBXQ=
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-7bdc947aa88so4693237b3.3
        for <linux-mm@kvack.org>; Sat, 16 May 2026 14:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778965442; x=1779570242; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9yKlsY6+9+MZ7mU7SmEl9YWbtOg8xFpSDNXLhXZWgGQ=;
        b=SKP5EoTPB/Cxu0gptVmIJOla7h1mDkSYCkBDcOkQq/WbSfRyfn1giCx2Dfhz4sND60
         p/Q4kiB7f1pae8kt7OtdQu4GfyhfeuUTq6KxxAeN7Y2AG12Qt05CGJTwK+nVEYzglslH
         sA/D4M1hitL9njn8xqe9zj3bEPvmUeOikrOUTduqIvQ5OvE44g7Fg/AgDzbUqKDI55ou
         e35iLXYMCXO0aEtbxRgHFfo2j7/Z8Kmy05qMoman6OU9zrZOMVYzzRZMsUxC9pZGAAO9
         u0BIZkabLp+Po+5UiRyZSNuuU/3OgG99lgS5Xn+BcG7o4wbzdZWDe8MCdFZ4yPW3MFsl
         gGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778965442; x=1779570242;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9yKlsY6+9+MZ7mU7SmEl9YWbtOg8xFpSDNXLhXZWgGQ=;
        b=EElAL3Ri/VBaohssAYRJBLW/+COyrdhHHdi3ORONLNqXaTUbv/wwe2wXGDe7yEbPZd
         Ki1iVF6eZLdvyrOMkXhMjdfgQHznk5isQEZl9FDhHed8D9JAkhik67n4ymjMYfO3X3PY
         IF+heRoBd2e6wwwRLXMUY2HyOra7MQxYXE/xlqHFbIKRpRrPAVk9UqhpUCYDOHHvdoHZ
         ahKNvXWIxIIgq25gXvy5ZINaCyiFwxa3X8hlkIfkCiJVSMcaWEY7x0LIcmYrsdG/CtvK
         s9GklX3g8NnGAJmY5BLawN6kN2g0yOwwZxS9V28b1aHWwPCG6WrTGcuRXFsw5TC5H7ar
         ByPQ==
X-Forwarded-Encrypted: i=1; AFNElJ9PAAZZG7GQunn6DpuyK1frYHAtHxoamIKrPY2aSkA8M1NULipaCX41OfRala5kl1wV2/xrihDL6g==@kvack.org
X-Gm-Message-State: AOJu0YyAH265GcrWHC55aKp+78kligkV/7tR6paN8ChsWn6ktNTQrbVp
	+J7s3GWxxSUeHaUJYLYQefi58YFyWbm9S9nX1PTIlDericfXgFD6Ppc=
X-Gm-Gg: Acq92OGj0gd+AO3xZx4jOUIx5gxGrwgH9KK6VEO6ViCQfO3mZ8K+1VDO5XG1qBNFPFW
	D5lznDwwpH4YZ+gQkjjNzhOgWw3NWTBBs+ISuFfmpWM0xNCa4lOCMnFk0LJx4tuga/XjPFHgTAH
	QB5qFl/UJnlO9fFY/xPPkgN8jX7VwsYBrNItzuscC9ZfbDjEqSV60H9yEZigevoesLfsRJJLhml
	7L+lKvGQY+la5c17bmjE6nKLH1uQsjx9ewaP/Xblsqk+qjUeRwUQUtUqkS96Z86tqUwS2XCCwW6
	2sXZ4cWcdI72dOP1sjcvAOq1UqOiKDYugvuJo1EP4elSNMT2bpYEDLmZpFF8LJHlP4XtUydFw1t
	lugEA+dqFDuhwyFKKFvMf190wXYYj2jbMb6AxO9EiQwsYGSH1k9AbgJ4OtbmUOXJvdxoydI2je5
	ybO4rSnB6vIejnYOqdYu8c8SG7EXPvo61+m5L1q7ya5uCe6Gf2v94CjBbixQJgkF0xydZBXdxuE
	6sIH7JXOYSE
X-Received: by 2002:a05:690c:6d84:b0:7bd:7b55:ebe1 with SMTP id 00721157ae682-7c959f80c19mr97174407b3.1.1778965441933;
        Sat, 16 May 2026 14:04:01 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f5e89bd4sm48605287b3.49.2026.05.16.14.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 14:04:01 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 0/5] mm/damon: DAMOS quota controller and paddr migration walk fixes
Date: Sat, 16 May 2026 14:03:52 -0700
Message-ID: <20260516210357.2247-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dcfip8axtxyewysqn8ajzztrnbs58w4f
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB5DBC0007
X-Rspam-User: 
X-HE-Tag: 1778965442-414311
X-HE-Meta: U2FsdGVkX187C5ah8PdBvfRziOneSlb46kqRqjjDfpWHqhRPDEQKPW5/BrPB+Mr1qsajLMhBcPssCKqTOfzdp+zn+TIVJLdh9sOwLNzEkBy606Lf3xI4ufv+BOI2/FAf1l/ulezl3KZxYCq1+77vo23gWeH0hU7cK4tusbkyU3wsEyg+zHxiQsGVYetdlRVP1ptwYSVcmt9rpdCTbMTypC5fDJn5aHIGCE9/Y9UX3EO6FIKSNVU0UnBWOOfYfWaFkD9OYGejxcfMMTvmC8OrCrg2abrgDxCCGZngtR8hiQ/nXuebLJe+IQCOOsbQAExaLLSLo6EeySQdb24jzpCdJOQCipMcXQi/gpMS5d71MWhioT80pfmwr00RFW2p2MsTynep2lTZUZO5+3qew1sXeUuxEssOV+okYgxU1GkvqKBQSum3lqvXJEj8vm5hfGVsmeNVqoL+azhGSqyDBcfqlAnNnAdcKf5b38ZZtcAFnAu0Gfmc6Hil+s8dzSX3Hb4E0qPCL3v/Ra7z/od2M4xYSn1omra+Fj6WpnOhqBEdKDu5thRhjP3q1x2P/MrNO20UNOhDDb8rs76kvaxJje71VfD8lja9t3Y60jPPsumvMV1+sJpwKkCwSExDdzlOZ4Vc/LgikIpwlt+/D40+XqXiQwrKYuA3X4m6WLUv+UVibJbtvxenjZI6q2Q01Y+hsczYAj5ZwQ05z2pkt8p50X3zu4tPKdQGK1IIKzpWz8PGlC9C2ANQmwEtdeZ9W5kPcIH1AUOgduAgD3luUE/L+FmpGwzLlxfRVhbCQhJuumqGq/qr5ZPcVqBZG/Qa060Q44AK44gH4u5kDCbdkws7cqjNPWDEHEZpIBvvsX0UaxcLfrBWWGP/Z4cZ10r9JCn3KiFBwTIGXXyDXjzV61MWqaUB0TMYM9TROvHshH/IV9K++ol5c0IvyKYmFhPsAy+HdTdo6ab1C85PjWdflhEJrMz
 DJ+6uISD
 xVW/xExXN74d6zoTvthbl3jSMm/xYy8bTZK6Jk40Q8BbbnaepW6QdAibnDhBNs+t0VGO8iB9TK0pv+oMP6/kroYFEpLnQEaVb/Msh0feuG5WQgTKlhGEbQ9Q9PEp9Rf0i4xVEUMQ+H6Vq0A7mGW9VsggTBQxkYSdNervq3w7XP9gj+Lduxu2+/YYfIYwCrZ/hSVS1qv/AyHKRFO/OExkNd1EItnK+k7XcLjDC21tVhmTUwAeL77z96axmxDnUm2LIYwEXFL2m4KF2icGbteeRUAR4aidrk2ekWRJzoIFQZh/kZK08LKCcUY6D2JfPbVYXJ8nmeyeIwotmXGuBnu9WoecOSRaXdc+gmDBdBgzEqSUhWaqZx4EkVi/FnuG7FNLIiFWHWgACxL8KvFC9dlQMw0LG1Pklb6dQfWhd/j3+aeHvfhaP+h9EXw+KngTNdEj4XTX/rKiz+p91dULINzypCxjEabj+MKmdK4nHB00vtCmWjdt2d7LpEZUmMDET8GF1NdXstmqDLO4jqrRPBX7G7mozS4jRv6AOLnf8Tle43UGbRFr1uMOZnFEVvMPqOxvuj7u6Y3WxTYveDLw3EdTgk1k2ymoOcrzPoGoGhoK5BtXNivBFR9DAiH+haThIzjAaKQmf18yjANIrDKwMD/S00lOuDy2dj1yJqKM7biOF3xSv13SW4LWRvvmbGF6HIeglO/B3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This series carries five fixes for the DAMOS quota controller and the
paddr migration walk.  All five were surfaced during closed-loop tiering
testing on a heterogeneous-memory system (DRAM + CXL on a separate
NUMA node), but each fix is in code paths that benefit any caller --
not scoped to closed-loop tiering or to any specific goal metric.

Test envelope: AMD EPYC dual-socket host with CXL.mem on a separate
NUMA node, two-scheme migrate_hot PULL+PUSH setup driven by
node_eligible_mem_bp (now in linux-next)[1].

What each patch does
====================

Patch 1 - mm/damon/core: fix nr_accesses_bp underflow in damon_moving_sum

  damon_moving_sum() can underflow when a region's access rate drops
  to zero faster than the moving-sum window length.  The internal
  accumulator subtracts an outgoing sample without a lower bound,
  producing a sentinel-large nr_accesses_bp that mis-classifies a
  cold region as hot.  Affects every DAMOS scheme, since
  nr_accesses_bp is used on every access-rate update for every
  region regardless of which scheme or goal metric is active.

Patch 2 - mm/damon/core: cap effective quota size to total monitored memory

  The DAMOS quota tuner can compute an effective size (esz) larger
  than the total monitored memory, because the tuner integrates over
  cumulative deltas without bounding by the actual workload size.
  Once esz exceeds total monitored memory the per-tick "remaining
  quota" arithmetic stops being meaningful: any scheme can apply to
  the entire monitored space and "remaining" stays positive
  indefinitely.  Cap esz at total monitored memory so the controller
  remains within physically realisable bounds.  Tuner-shape and
  goal-metric agnostic.

Patch 3 - mm/damon/core: floor effective quota size at minimum region size

  Symmetric to patch 2: the tuner can also compute esz < min_region_sz,
  causing schemes to attempt zero-byte migrations for many ticks before
  the tuner ramps esz back up.  Observed under the CONSIST tuner with
  a node_eligible_mem_bp goal: ftrace traced esz stuck at 1 byte for
  96 seconds before the first region was tried; the first acted-on
  region appeared at t=113s when esz crossed the min_region_sz
  threshold.  Floor esz at min_region_sz so schemes always have at
  least one region's worth of quota when the tuner asks them to act.

Patch 4 - mm/damon/paddr: skip free pageblocks in migration walk

  damon_pa_migrate() walks every 4KB PFN in a region.  On
  sparsely-populated lower-tier extents (e.g., a 549GB CXL region
  with only ~8GB populated), this is ~144M PFN iterations per scheme
  tick at ~40ns each = ~5.6 seconds of walk per tick.  Use
  pageblock-level free-page detection to skip unpopulated runs of
  pages: only enter the per-page loop for pageblocks that contain at
  least one allocated page.  This brings the walk to
  O(region_size / pageblock_size) skip-check cost plus
  O(populated_pages) per-page work.  On x86 pageblocks are 2MB, so
  the same 549GB/8GB example becomes ~281K pageblock skip-checks
  (microseconds total) plus ~2M per-page visits for the populated
  pages -- ~80ms expected.  Helps any migrate_hot/migrate_cold scheme
  on paddr ops, regardless of what drives them.

Patch 5 - mm/damon/paddr: add time budget to migration page walk

  Densely populated regions (e.g., a busy DRAM range where most
  pageblocks contain at least one allocated page) can still consume
  full ticks even with patch 4 applied.  Add a 100ms wall-clock
  budget with a ktime_get() check every 4096 pages walked
  (~16MB worth).  When the budget expires before reaching the end of
  a region, kdamond returns control; subsequent ticks re-walk the
  region from the start.  Folios already on the target node are
  dropped at migration time, so re-walks only re-do collection work,
  not the migrate itself.  Together with the per-scheme quota cap,
  per-tick work is bounded and the workload converges over multiple
  ticks for dense regions.

  Worst-case migration walk contribution to a tick is bounded at
  100ms per scheme regardless of region size or population density,
  preserving kdamond's ability to service other DAMOS schemes and
  user-space sysfs operations during heavy migration phases.


Testing context
===============

  Hardware:  AMD EPYC dual-socket, CXL.mem on a separate NUMA node.
  Workload: 32GB hot working set across DRAM and CXL nodes.
  DAMON config: paddr ops, two migrate_hot schemes (PULL CXL->DRAM,
                PUSH DRAM->CXL) with complementary address filters,
                node_eligible_mem_bp goal per scheme, temporal
                quota tuner, 1s reset interval.

Each fix in this series was reproduced under the above setup, then
verified via ftrace and per-scheme stats after the fix landed.

References
==========

[1] mm/damon: add node_eligible_mem_bp goal metric
https://lore.kernel.org/damon/20260428030520.701-1-ravis.opensrc@gmail.com/

Ravi Jonnalagadda (5):
  mm/damon/core: fix nr_accesses_bp underflow in damon_moving_sum
  mm/damon/core: cap effective quota size to total monitored memory
  mm/damon/core: floor effective quota size at minimum region size
  mm/damon/paddr: skip free pageblocks in migration walk
  mm/damon/paddr: add time budget to migration page walk

 mm/damon/core.c  | 29 ++++++++++++++++++++++++++++-
 mm/damon/paddr.c | 40 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 65 insertions(+), 4 deletions(-)


base-commit: 0cec77cfd5314c0b3b03530abe1a4b32e991f639
-- 
2.43.0


