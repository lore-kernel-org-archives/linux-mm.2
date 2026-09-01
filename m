Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AACF2C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212456B00AB; Tue,  1 Sep 2026 04:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198BB6B00AC; Tue,  1 Sep 2026 04:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE14F6B00AE; Tue,  1 Sep 2026 04:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B43CC6B00AB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:48:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C5201A0369
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:48:12 +0000 (UTC)
X-FDA: 85164566424.02.F406DC2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3E6EB40002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:48:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=qbguMtFL;
	spf=pass (imf17.hostedemail.com: domain of love_goo@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=love_goo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e0X6NkXJNqcY06y/9A2BHnUsW3ZejkoSNN5X8QSqQTM=;
	b=3o8CF+BXZclZas9Lk/IA4erH1GJZsL95GU8jyw+PXI262MxyeKdspz7QrNXGgPwucHJdeN
	c1gBzRQ6g0RFONY3NDRatLIWmYv2S688cygksOhaNIXDqnf7e7gbM0DgmiVeyrq3i2ewOk
	m+tXVHazwtMPwRMoN4UP3hdqljksf7U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788252490;
	b=umVlm2UIttpBJfTUiiMY6nbwJHohuqfowrDzflYJgV3A5KZ3QcTsbLPIFc9oC+YCcDBFfM
	REoEPWDNHEAjaqsTNup5q7J7I2GSzO19knLlYTM0IN5wzn5lWNZve3a1VgQlMWh32aKOb/
	/71pOTB4aw+Y4lG1zsK1/fw12mYJkbU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=qbguMtFL;
	spf=pass (imf17.hostedemail.com: domain of love_goo@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=love_goo@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=e0
	X6NkXJNqcY06y/9A2BHnUsW3ZejkoSNN5X8QSqQTM=; b=qbguMtFLuJPhhnoDRf
	DOJCJDHrMe3OZPFk6H0BvVbpvhNJgqomMaqot1nCdg6Jc4odV6sNU+9CSwz3tY1J
	AbLLZ3tQ0W3M/R394g1wJBWP+wMVKpa5XgpN5yBqW+6RFKKfhFIufU1gk8guE3hS
	WjZ+Sn6i50eL5pS3eQmRQPxQ8=
Received: from hpc (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3qo4OkZZqHFWTNA--.28200S2;
	Tue, 01 Sep 2026 16:47:11 +0800 (CST)
From: john <love_goo@163.com>
To: akpm@linux-foundation.org,
	liuye@kylinos.cn,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	mgorman@techsingularity.net,
	yang@os.amperecomputing.com
Cc: zhangqiuhao@huawei.com,
	wangkefeng.wang@huawei.com,
	mawupeng1@huwei.com,
	love_goo@163.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wupeng Ma <mawupeng1@huawei.com>
Subject: [PATCH resend 0/2] mm: vmscan: fix scan overshoot and ineligible folio scanning
Date: Tue,  1 Sep 2026 16:47:04 +0800
Message-ID: <20260901084706.3784449-1-love_goo@163.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3qo4OkZZqHFWTNA--.28200S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGF15XF1fuFW3KF4UXr4DXFb_yoWruFyDpF
	ZxGr93tw1kJFWayF9av3W0gFyFkw48ArW5WF4fGw1xuw15JFyI9r9Fkw4UZFyUGrZ8uFyY
	qr4DGws7uF4UJ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pROdbbUUUUU=
X-Originating-IP: [36.24.89.45]
X-CM-SenderInfo: 5oryvsxjrrqiywtou0bp/xtbCww+n32qWkQ-CKgAA3+
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E6EB40002
X-Stat-Signature: 1hr65azcxks35rfhjnsxodzkq7oggoyu
X-HE-Tag: 1788252488-42681
X-HE-Meta: U2FsdGVkX1/HMtPwqcOsv4xGpUihsaaDt1cx5+/u0174FPMNVrX9y0c+OQRG7QC551c4RLUOTVj2klDvRnB1TIS7sI238AgWDyK9ZrNB+3Dc1sGatzy+6OFTYoq3qiT1gtTPujQktsupFXEOgoeltzVKqyR8gAxy7hGq1py60n1K7Rfg6hUhU4qCus7V+mROHghKp9uG4lVQdBxusHILJzwRVv7hAVIseL5PJGZRwbCHcUOTdD6nDS/PwIySIeO83aObxK2S/PUDNu9SRJ/ucDFRg0IYF4UFMrSlbl+se1/8RWg5n8IbPa8pXdNv6HOH02QmreVXxXDPsB5jw2B5yl+zFndRZiym7BqmNtR+Fyigr4ON16FPIrqY8JWn6DsOPgZikk26v85ItmxQANe39tkknupRde+w48YIk6o4/UPHGI+C+GmYWIaTCZLJLlKO9Ov7EXsqC4gKxXwRWmbqqriO6hABiMXJS2OK2MGka5tr2uyDJQyzefcxbM7CvYXXtk+ybREEXZ5B4D4ze0MefIu5ZOGunJ+/PsKItM1HXy7kGBqoUkmSO7iWONRkOPE1aBdR2exTx3kKocMCwG6x94d1w1wF1L+MPq0/QKMbGP/6Nn3cAogqdVllX0qvnjxRC0vDEVEIhLCP1b0WPPYoakiJekvxCKs0HXfwywH0pjM/jUp8Gsn1HTt2bOW5zpmFQK/2VfsHSYjgJGD8xww2rbkv9Zk8dHB5On+pa8nRVPVC+3bgCpBVYRA2UVmBXrFSSNZBCmY47qqz3hAj099lTACZBwemElAHoVncKa5inGlEPaslNn63V+vJHInf8dUAnLnlkqfHlltrfa7Wk5nfUm2inxO67FgqJ2H9+097p8gTuBZp3ol1AdGjH7dYJ3jbzmKolOV+AGI1seW6ooZONQojIjl9gxONiQgpnaH3QrQ1gSFW5h0UJD40VcDtfAC4l50P2YndnZ+nD1aW53d
 77CExZ80
 MEZao6P3nelKLHMmlX5V+yVk6jVWSv2g67ZsEBXJO2YF4lX/EX/X9mKGR1dfSl3KkotbhjxpdKU0zf2RGyYKVxJBkTnlNqV8OzVCzFlWyO354b6RIFsy0M4bz+z8wH2aJzhCMOHRltLWfRfkNYarKR8UMXytbg+RoEh/erjUYwQ+07B1wUB6waoPtLmz+24x1/yEWAOE1ngdSVJzT7BFgky4B1pG22Fkn3zz6LC0R0T/DoJlxuJP3576072hnbuaBWyLnLnw3weIXwY+HHq/LeqqKEdDAGFHMESEHIH91MeqCwHBH9d48O5CreiaK2OB7FIea7NLa1n/wjmZiciEaA7Vb1of1AHZMoCAXorKYpXTfou4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wupeng Ma <mawupeng1@huawei.com>

Rebase to the latest v7.3-rc-1.

These problems only surface when reclaim targets a lower zone
while the LRU holds folios from a higher zone.  Normal userspace
allocations go to the highest zone.  The zone-skip branch stays
dead under typical loads.  Lower-zone-pressured configs (DMA32
module allocations, memory-constrained devices) hit the issues.
They inflate scan cost and delay the OOM.

shrink_lruvec() drives reclaim in SWAP_CLUSTER_MAX (32) chunks, but
isolate_lru_folios() may scan far more than that per call on a single
LRU.  The excess is never charged back, so shrink_lruvec() keeps
rescanning the same folios round after round.  When reclaim targets a
lower zone, the same scanner also keeps walking zone-ineligible folios
that can never satisfy the allocation, inflating nr_reclaimed into a
false progress that delays the OOM.

This series fixes both:

  [1/2] Charge the isolate overshoot against the scan quota so the
        next round skips already-scanned folios.
  [2/2] Stop scanning once too many zone-ineligible folios have been
        skipped, instead of force-isolating them.

Background
==========

We observed slow, unexpected OOM behavior during extreme stress testing,
and while digging into the reclaim code during that analysis we spotted
these latent risks in isolate_lru_folios() -- the overshoot never
being charged back, and the force-isolate path on lower-zone reclaim.
The concerns below are the ones surfaced from reading the code, then
confirmed by constructing the situation deliberately.

The problem only appears when reclaim targets a lower zone while the
LRU holds folios from a higher zone:

  - reclaim_idx points at DMA32/DMA (the triggering allocation asked
    for a lower zone, e.g. __GFP_DMA32), and
  - the LRU holds folios from a higher zone (Normal/Movable).

Normal userspace allocations go to the highest zone, so reclaim_idx
never points below it and the zone-skip branch is never taken.  It
needs a real lower-zone allocator to drain that zone below watermark;
that is also why it went unnoticed upstream -- the 1c7b17cf hard-lockup
fix that introduced the force-isolate path was found only on a ~1 TB
box running DMA32 module allocations.

Impact
======

Reproduced on x86 QEMU, 7.2-rc6, with a kernel module doing
__GFP_DMA32 allocations to drain DMA32 below watermark (LRU folios
sit in Movable):

  - A single isolate_lru_folios() call scanned 32794 pages and took
    25 (32769 skipped): 99.9% wasted on ineligible folios.
  - Across one run, isolate was called 339 times, 140-165 of which
    isolated nothing (taken=0, pure empty scans).
  - shrink_lruvec() charges only the 32-page quota per round and
    never refunds the overshoot, so the same skipped folios are
    rescanned round after round.  vmstat on a memcg OOM path:
    pgscan_direct / pgsteal_direct = 2836624 / 112719 = 25.2x
    (isolate -> shrink_folio_list returns the folio -> isolate again).

Once max_nr_skipped hits SWAP_CLUSTER_MAX_SKIPPED, the current code
force-isolates the remaining ineligible folios.  On the inactive LRU
they reach shrink_folio_list() and get reclaimed though they can
never satisfy the allocation, inflating nr_reclaimed and resetting
no_progress_loops in should_reclaim_retry(), delaying the OOM.

A/B results (same .config, md5-identical):

                          baseline    patched
  empty scans (taken=0)   140-165         0
  isolate calls               339         7
  total pages scanned      343711      3140
  single-call max scan      32794      3104

Empty-scan 0 is the stable evidence (holds every run).  The
pgscan/pgsteal ratio is volatile (baseline 56-26675x, patched
65-1324x, ranges overlap) and is not relied on alone.

Caveats and reproduction
========================

  - Triggering needs a lower-zone-pressured box.  To confirm the code
    analysis, the situation was constructed on a small x86 QEMU VM
    (1500M, CONFIG_LRU_GEN=n) with kernel cmdline
    `movable_zone=DMA32 kernelcore=256M` (DMA32 small, Normal empty,
    Movable large), then a kernel module doing
    `alloc_page(GFP_DMA32)` drains DMA32 below watermark.  LRU folios
    sit in Movable and are zone-skipped while reclaiming for DMA32.
    Observed via the `mm_vmscan_lru_isolate` tracepoint and
    /proc/vmstat (pgscan_direct, pgsteal_direct).


Wupeng Ma (2):
  mm: vmscan: charge isolate overshoot against scan quota
  mm: vmscan: stop scanning ineligible folios after max_nr_skipped

 mm/vmscan.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

-- 
2.53.0


