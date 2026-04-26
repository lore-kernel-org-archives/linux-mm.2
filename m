Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6743BFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF18A6B0092; Sun, 26 Apr 2026 17:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8CE6B0095; Sun, 26 Apr 2026 17:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD786B0096; Sun, 26 Apr 2026 17:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85B596B0092
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:39:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A7211C0931
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:39:07 +0000 (UTC)
X-FDA: 84702022734.27.0A4D9CA
Received: from mail-yw1-f194.google.com (mail-yw1-f194.google.com [209.85.128.194])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5EA80100002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:39:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HvgzQoc+;
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777239545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gB3C8z1N+EcktD5DpZs6GfHo6tuIfAcGGJkDFACNoXM=;
	b=6ntGFDfEQrLH0iMVVljKAKrqNPaaJuJ+M3vXRgfPeg6NoYMuqyUlqrRbEh05eMxk/YLQ0j
	WN8+SnvBYLfxw9J0EleRDBZwkNxphY0XBBRpgqYlLVRxjEvTEd5sGsERiN4nD/d8tK8lss
	qwDa4a3BsUwvryuavBZ1f/O0/6GR5zY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HvgzQoc+;
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777239545; a=rsa-sha256;
	cv=none;
	b=0tZmUWjGX26G132L639OsxXeENVeB7VhAStC7uJT/RlY5o5eWUnVW0HlG5lTd+x8abC5u7
	3S2qxuV7Jezs9MG2iMgULR6tCQpnkj2fJ27WstoW+39QyVSYhYpQkj71W0/hC1r7eIWkt4
	ydMEyAtFu+6GX3ZOX5o2fAyxHPoClO8=
Received: by mail-yw1-f194.google.com with SMTP id 00721157ae682-7baee75f874so76305447b3.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777239544; x=1777844344; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gB3C8z1N+EcktD5DpZs6GfHo6tuIfAcGGJkDFACNoXM=;
        b=HvgzQoc+Y90WZCfbgS97HPKfKHGw3/4N0mAMvzhwptRV3/7VcDK3bLB7mqgmtgxh6r
         qPHIIVTb+t3EIvKXqKXe3qjgYlWBw7kclPh2/22RziBoITLEv8bS2C8pnaUCZqx8pwOq
         5kRtocUlRpvfRxwIhzqKBVyUJe3YXbzlwDTrtKUt2XNG0+pc0IE0Nr+cEi41NVKY3HtP
         c+MxjNRwJdKA10SYmZD0v8QprYzxdvnOGbg55TKZmWMWXqgJic3o1/IMWvBvt3fXRoIw
         +QGZujIABSuVrrLQLxNmAEjD+yAAUCwXJuYsJVHTcubvCYPLuSU6HPwNPycqdzGlnJm/
         XtTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777239544; x=1777844344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gB3C8z1N+EcktD5DpZs6GfHo6tuIfAcGGJkDFACNoXM=;
        b=KhaGi3oO7Asdh9wxlJvXdANrLvH6qvYrqH565IP5U/EIqqow9aQmhph1ZHbHd/edhu
         R6GyMAzOPqnXXCaVSd30htB7TMtjyzsIMiL1G3Z9SZJAw21+1TJD0BmRzxsM1NWQBfGB
         6F1iK2za0clBRtpQ41tlLF42Ih5m4gtYv2adWFdRtqdbDrmeoDSsxxIRZs4pPZbqhoaf
         UzcBykFA8f9bp+mpqxfvotazHBA7a3QrdDrYuCewGgHNBxF6QRCt90+0CqKmWxmlUj2+
         K6oNpMQkc1egHXXYUXNlqC4ZqjQOx4O4ZSmO5bg407ahyklCQRBZiX9JXnEPC9VRU9NT
         AtBg==
X-Forwarded-Encrypted: i=1; AFNElJ+WYLjt9dJ+MrrtPQlNvUDu7/+aAk/7XuvFYp1B9pwsnmSc+QWUkuF5ltZrUmOhiwFhUx4Wust++Q==@kvack.org
X-Gm-Message-State: AOJu0YwuQ6elUKaDetEKmi93tV7mgUTw6RwTWug5ANeG3kj/Am1+LiAC
	iwYLIeJ31wb+vE00Dvz9BWe2c0Hy50eay5Frtt4m9FZB/pIUO0JJpoo=
X-Gm-Gg: AeBDievaXb6s0wapkKQFNbGjGVSzhJA4iq8amRIzFk6MWEBulnUXTVcOYWpssBUEuXH
	xo7hDpsz7JmmcEH6LGhs6ZnCxOSbK0b49LKGQBjWszbGOw/MitTS1Fs1Q4TFTQ0tLkXqs70l14q
	N20cm707NdplSi3nHtdsPeftAEFdmX4//mv9VS1FIJrW+Uxuf7Vmv9RQSsN/4e51EedMCvCxoXo
	zGMome0YvrLTBPrq7OKd/E+F/cpo4KdtpcvArsNTT5jhnLPve6CPxN78C7zfqXxdgDhpKDlhwVu
	pRQYhTTbL1fv2nIv13sImnJAYXYeV57DfM6G2cgAMPUT67AbDYYIliefVBfoj+dn2FZ6D9p6aVG
	G6MUP4w1kUqebCfYUVS+3sU+lmCKtVnWGcRzkrR2c8fMS1jhMtSeVBmSA81CVR+v7SOoVflhw6D
	6Jn0Tr726MF+CoUGI8HyxxuR7ioRVpqyt6CwOlPMgUg/XnPv1gQ39OuMC7OZV3XORPNUQOOElHO
	1rAqnPqb38m
X-Received: by 2002:a05:690c:1d:b0:7b8:338d:7d6f with SMTP id 00721157ae682-7b9ecf7aefbmr400124587b3.25.1777239544286;
        Sun, 26 Apr 2026 14:39:04 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7b9ee8c3f8bsm121357917b3.19.2026.04.26.14.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:39:03 -0700 (PDT)
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
Subject: [PATCH v9] mm/damon: add node_eligible_mem_bp goal metric
Date: Sun, 26 Apr 2026 14:38:58 -0700
Message-ID: <20260426213859.1835-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5EA80100002
X-Stat-Signature: o7kss957zjk7n44xit17icy68innbupz
X-HE-Tag: 1777239545-662007
X-HE-Meta: U2FsdGVkX1+LI/fu2bb/5pGHaeuLxxh4vUo6ZmUZcsF3qGq8789VeReE86Br7UiePsjZuYMITydkJcmxKAdKrKEvOG4Vi/TuWk0SLvDkncAqDQ3oEIeezeV/CAc79oevvF8fENy9k+e8rm3OnIcvZp77w6K7coj3C2z64uGy1a/TJEYs9xp9Lq1dr7i6r8eg8vOn4YVHkxW+ALvOY6+5acI+73I9ieAId/6Yf+xfgGr09DDBtXraVclRNzkiYOBmiEuiko1Yd1twAIp+mr9mSQBhP5BW1kgX6Gd88A+Dnu47j9ca//BNVTw1bm0gNqaOb1o7qSYim3lUAxxgcJR0u+CC1y0dS0ZvlIRS1lwbM/Pr9bvF1r/Sa2S0d/VrhcIdTOeDA1LFphfPi8hQlo7B00EIp3jVcqfLyCTxc+63pr40iNWFJ0+uHVmEO8pOykN0GehhRblW84YB13+aIzYfo0OSPuhUsB84W9FLGRCn/khXG5tM4rhi2hkPnA0Ox84r3bP8MGpe/Vangc3A+nsUR+GSfrnaSGnnwGIxzEwhcOTq+y1nL2KAjz31iFL/9v2rRBZq3+q2UY0JeI0d6NmPs3Edby9qFq9beHRiy37oe43VQozy0bFAHZ+wKBV2ynjr4+BOFnb2I6QZIosTuRYQ8W2ihB/aoInrY78urGvF/GMDEp/yfdDXekG84Wh/kWi2/LU342EEqERrXRUVpMXggX92spMgnjosyYvjdssrQl/z1d46QyRiPfCubtIs2M1rxiS4pfUOTFI2SAp35byQMCyIqJk1HgwuWNz8vTepU+CXMzAi3THXimn6+5QRiWsZnH56sPMymEJ4XFWoKRZbph3Cl2GBoxi02wpU96BOr8YL5G44K4he9KnWjqd+6jKiEuRLEa/oCpOeXoxv/0rGt7BglsxHMiOnqYBgWFGjfDEvjXnhkWmbuFI6yX88t9IBVBjvk0BWdRmmpjjkLjv
 9tQc488W
 /ruZe1EcaA4GLuOo7ejlCL60Ij3Y0EP8t6zbc6+k9pNeT+MaNFEyB88hClzU+d5m0yPURcfq/LJxcpZQ9PGWCoCSM89Tw4Q+fG4PFgwkcj4aCA3JEbGAcYHNWwRDtBiJKHDErTYxFo6UT5EtyNJ/sIEDmOIkKG+P1D7AU2BCaKQ+4xtwvwqEhdUVUpz2q5PsLhHKswSg7vY+1a44dlKSJ8tBYPGgZTnASDgzF2sfNkq8GfC4CCQpJZreLKx8UG6B2IbiU8rY+UaPZiwRvsJsL1dWN+7zB0urT/P+jttzxFAfuL9pZx6IeygyG00ezt7W86rZzdV42V6LdkbjsZdPjpfwrCgT0p0E9V+HajGtkeZaHL9UjRxOi9F5yN87VbtN1faN7llDhp5XaNjR9s8tpelHjVGB3aeBa7lPGtWD+8zMFGoh8sq0ywpQSXg/O9xnYo3tfwH1Bz/gHqQuEa11iJSMRwnGZG124bODWxH84Fo4Exi+9YXHXIYhg1Zuum8IsHGzTxoU+G4K1S8IPa2SkhfU38XqKFBaxoFNKjLaHSbbiC71WXy2XnrNv7k36A5NH8YPSoSxpXcoDY7RJspPBLuTY6F9HZhiHjdJ4pS0E5O7pJE40SXMm2hKDtAe2XaO+PtcKENQYlYkW7X5Cp4jcfIBVLSfbIM/D/sqgjadrj1iPnXy6e6IRFgsPog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Background and Motivation
=========================

In heterogeneous memory systems, controlling memory distribution across
NUMA nodes is essential for performance optimization. This patch enables
system-wide page distribution with target-state goals such as "maintain
60% of scheme-eligible memory on DRAM" using PA-mode DAMON schemes.

Rather than using absolute thresholds, this metric tracks the ratio of
memory that matches each scheme's access pattern filters on a target
node, enabling the quota system to automatically adjust migration
aggressiveness to maintain the desired distribution.

What This Metric Measures
=========================

node_eligible_mem_bp:
    scheme_eligible_bytes_on_node / total_scheme_eligible_bytes * 10000

Two-Scheme Setup for Hot Page Distribution
==========================================

For maintaining 60% of hot memory on DRAM (node 0) and 40% on CXL
(node 1):

    PULL scheme: migrate_hot to node 0
      goal: node_eligible_mem_bp, nid=0, target=6000
      addr filter: node 1 address range (only migrate FROM CXL)
      "Move hot pages to DRAM if less than 60% of hot data is in DRAM"

    PUSH scheme: migrate_hot to node 1
      goal: node_eligible_mem_bp, nid=1, target=4000
      addr filter: node 0 address range (only migrate FROM DRAM)
      "Move hot pages to CXL if less than 40% of hot data is in CXL"

Each scheme independently measures its own eligible memory and adjusts
its quota to achieve its target ratio. The schemes work in concert
through DAMON's unified monitoring context, with the quota autotuner
balancing their relative aggressiveness.

Implementation Details
======================

The implementation adds a new quota goal metric type
DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP to the existing DAMOS quota goal
framework. When this metric is configured for a scheme:

1. During each quota adjustment cycle, damos_get_node_eligible_mem_bp()
   is called to calculate the current memory distribution.

2. The function iterates through all regions that match the scheme's
   access pattern (via __damos_valid_target()) and calculates:
   - Total eligible bytes across all nodes
   - Eligible bytes specifically on the target node (goal->nid)

3. For each eligible region, damos_calc_eligible_bytes() walks through
   the physical address range, using damon_get_folio() to look up
   each folio and determine its NUMA node via folio_nid().

4. Large folios are handled by calculating the exact overlap between
   the region boundaries and folio boundaries, ensuring accurate
   byte counts even when regions partially span folios.

5. The ratio (node_eligible / total_eligible * 10000) is returned
   as basis points, which the quota autotuner uses to adjust the
   scheme's effective quota size (esz).

The implementation requires CONFIG_DAMON_PADDR since damon_get_folio()
is only available for physical address space monitoring.

Testing Results
===============

Functionally tested on a two-node heterogeneous memory system with DRAM
(node 0) and CXL memory (node 1). A PUSH+PULL scheme configuration using
migrate_hot actions was used to reach a target hot memory ratio between
the two tiers.

With the TEMPORAL tuner, the system converges quickly to the target
distribution. The tuner drives esz to maximum when under goal and to
zero once the goal is met, forming a simple on/off feedback loop that
stabilizes at the desired ratio.

With the CONSIST tuner, the scheme still converges but more slowly, as
it migrates and then throttles itself based on quota feedback. The time
to reach the goal varies depending on workload intensity.

Note: This metric works with both TEMPORAL and CONSIST goal tuners.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
Changes since v8:
=================
https://lore.kernel.org/linux-mm/20260426003245.2687-1-ravis.opensrc@gmail.com/

- Removed unnecessary casts in mult_frac() call to fix potential
  divide-by-zero on 32-bit PAE systems (Sashiko/SJ review)
- Kept original parameter name 'ctx' in damos_set_effective_quota()
  to avoid unnecessary diff (SJ review)

Changes since v7:
=================
https://lore.kernel.org/linux-mm/20260424203448.5040-1-ravis.opensrc@gmail.com/

- Wrapped if condition for goal->metric check to fix 80-column violation
- Used PAGE_ALIGN_DOWN(addr + PAGE_SIZE) instead of addr += PAGE_SIZE
  for proper page-aligned advancement
- Wrapped damos_goal_tune_esz_bp_temporal() function signature for
  80-column compliance
- Removed unintended damos_trace_esz() call from first charge window
- Added addr filter usage note in two-scheme setup documentation

Changes since v6:
=================
https://lore.kernel.org/linux-mm/20260405184247.2690-1-ravis.opensrc@gmail.com/

- Dropped node_ineligible_mem_bp metric per maintainer feedback
- Updated two-scheme setup to use 60%/40% split with both schemes using
  node_eligible_mem_bp (per SeongJae Park's suggestion)

Changes since v5:
=================
https://lore.kernel.org/linux-mm/20260404012215.1539-1-ravis.opensrc@gmail.com/

- Rebased onto mm-new instead of damon/next for sashiko review
- Removed Reported-by/Closes tags per maintainer feedback (not needed
  for bugs found before merge)

Changes since v4:
=================
https://lore.kernel.org/linux-mm/20260320190453.1430-1-ravis.opensrc@gmail.com/

- Fixed commit message description for DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP
  per review feedback
- Added clarifying comment for ops-common.h include (for damon_get_folio())
- Fixed build error when CONFIG_DAMON_PADDR is disabled by adding
  #ifdef CONFIG_DAMON_PADDR guards around functions using damon_get_folio()
- Dropped RFC tag per maintainer feedback

Changes since RFC v3:
=====================
https://lore.kernel.org/linux-mm/20260314223432.2292-1-ravis.opensrc@gmail.com/

- Fixed phys_addr_t overflow on 32-bit PAE systems by using phys_addr_t
  for intermediate byte calculations
- Added cond_resched() per region to prevent CPU soft lockups
- Improved folio overlap calculation for accurate byte counting

Changes since RFC v2:
=====================
https://lore.kernel.org/linux-mm/20260228191045.1892-1-ravis.opensrc@gmail.com/

- Added node_ineligible_mem_bp complementary metric
- Fixed DAMON_OPS_PADDR validation in damon_commit_ctx()
- Improved commit message with two-scheme setup documentation

Changes since RFC v1:
=====================
https://lore.kernel.org/linux-mm/20260215184523.1432-1-ravis.opensrc@gmail.com/

- Initial implementation based on SeongJae Park's suggestion
- Added basic node_eligible_mem_bp metric
---
 include/linux/damon.h    |   3 +
 mm/damon/core.c          | 168 +++++++++++++++++++++++++++++++++++----
 mm/damon/sysfs-schemes.c |   7 ++
 3 files changed, 163 insertions(+), 15 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2cdb7c3f5e6..986b8c902585 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -159,6 +159,8 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
  * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
  * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
+ * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
+ *					node in basis points (0-10000).
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -172,6 +174,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
+	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3dbbbfdeff71..b23b6bd53aba 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -13,10 +13,14 @@
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/psi.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/string_choices.h>
 
+/* for damon_get_folio() used by node eligible memory metrics */
+#include "ops-common.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
@@ -1326,11 +1330,26 @@ static int damon_commit_targets(
 int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
 	int err;
+	struct damos *scheme;
+	struct damos_quota_goal *goal;
 
 	dst->maybe_corrupted = true;
 	if (!is_power_of_2(src->min_region_sz))
 		return -EINVAL;
 
+	/* node_eligible_mem_bp metric requires PADDR ops */
+	if (src->ops.id != DAMON_OPS_PADDR) {
+		damon_for_each_scheme(scheme, src) {
+			struct damos_quota *quota = &scheme->quota;
+
+			damos_for_each_quota_goal(goal, quota) {
+				if (goal->metric ==
+						DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP)
+					return -EINVAL;
+			}
+		}
+	}
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;
@@ -2287,7 +2306,111 @@ static unsigned long damos_get_node_memcg_used_bp(
 		numerator = i.totalram - used_pages;
 	return mult_frac(numerator, 10000, i.totalram);
 }
-#else
+
+#ifdef CONFIG_DAMON_PADDR
+/*
+ * damos_calc_eligible_bytes() - Calculate raw eligible bytes per node.
+ * @c:		The DAMON context.
+ * @s:		The scheme.
+ * @nid:	The target NUMA node id.
+ * @total:	Output for total eligible bytes across all nodes.
+ *
+ * Iterates through each folio in eligible regions to accurately determine
+ * which node the memory resides on. Returns eligible bytes on the specified
+ * node and sets *total to the sum across all nodes.
+ *
+ * Note: This function requires damon_get_folio() from ops-common.c, which is
+ * only available when CONFIG_DAMON_PADDR is enabled. It also requires the
+ * context to be using PADDR operations for meaningful results.
+ */
+static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
+		struct damos *s, int nid, phys_addr_t *total)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	phys_addr_t total_eligible = 0;
+	phys_addr_t node_eligible = 0;
+
+	damon_for_each_target(t, c) {
+		damon_for_each_region(r, t) {
+			phys_addr_t addr, end_addr;
+
+			if (!__damos_valid_target(r, s))
+				continue;
+
+			/* Convert from core address units to physical bytes */
+			addr = (phys_addr_t)r->ar.start * c->addr_unit;
+			end_addr = (phys_addr_t)r->ar.end * c->addr_unit;
+			while (addr < end_addr) {
+				struct folio *folio;
+				phys_addr_t folio_start, folio_end;
+				phys_addr_t overlap_start, overlap_end;
+				phys_addr_t counted;
+
+				folio = damon_get_folio(PHYS_PFN(addr));
+				if (!folio) {
+					addr = PAGE_ALIGN_DOWN(addr + PAGE_SIZE);
+					continue;
+				}
+
+				/*
+				 * Calculate exact overlap between the region
+				 * [addr, end_addr) and the folio range.
+				 * The folio may start before addr if addr is
+				 * in the middle of a large folio.
+				 */
+				folio_start = PFN_PHYS(folio_pfn(folio));
+				folio_end = folio_start + folio_size(folio);
+
+				overlap_start = max(addr, folio_start);
+				overlap_end = min(end_addr, folio_end);
+
+				if (overlap_end > overlap_start) {
+					counted = overlap_end - overlap_start;
+					total_eligible += counted;
+					if (folio_nid(folio) == nid)
+						node_eligible += counted;
+				}
+
+				/* Advance past the entire folio */
+				addr = folio_end;
+				folio_put(folio);
+			}
+			cond_resched();
+		}
+	}
+
+	*total = total_eligible;
+	return node_eligible;
+}
+
+static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
+		struct damos *s, int nid)
+{
+	phys_addr_t total_eligible = 0;
+	phys_addr_t node_eligible;
+
+	if (c->ops.id != DAMON_OPS_PADDR)
+		return 0;
+
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_online(nid))
+		return 0;
+
+	node_eligible = damos_calc_eligible_bytes(c, s, nid, &total_eligible);
+
+	if (!total_eligible)
+		return 0;
+
+	return mult_frac(node_eligible, 10000, total_eligible);
+}
+#else /* CONFIG_DAMON_PADDR */
+static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
+		struct damos *s, int nid)
+{
+	return 0;
+}
+#endif /* CONFIG_DAMON_PADDR */
+#else /* CONFIG_NUMA */
 static __kernel_ulong_t damos_get_node_mem_bp(
 		struct damos_quota_goal *goal)
 {
@@ -2299,7 +2422,13 @@ static unsigned long damos_get_node_memcg_used_bp(
 {
 	return 0;
 }
-#endif
+
+static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
+		struct damos *s, int nid)
+{
+	return 0;
+}
+#endif /* CONFIG_NUMA */
 
 /*
  * Returns LRU-active or inactive memory to total LRU memory size ratio.
@@ -2319,7 +2448,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(struct damon_ctx *c,
+		struct damos *s, struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
 
@@ -2345,19 +2475,24 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		goal->current_value = damos_get_in_active_mem_bp(
 				goal->metric == DAMOS_QUOTA_ACTIVE_MEM_BP);
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
+				goal->nid);
+		break;
 	default:
 		break;
 	}
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-static unsigned long damos_quota_score(struct damos_quota *quota)
+static unsigned long damos_quota_score(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota_goal *goal;
+	struct damos_quota *quota = &s->quota;
 	unsigned long highest_score = 0;
 
 	damos_for_each_quota_goal(goal, quota) {
-		damos_set_quota_goal_current_value(goal);
+		damos_set_quota_goal_current_value(c, s, goal);
 		highest_score = max(highest_score,
 				mult_frac(goal->current_value, 10000,
 					goal->target_value));
@@ -2366,17 +2501,20 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
 	return highest_score;
 }
 
-static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota)
+static void damos_goal_tune_esz_bp_consist(struct damon_ctx *c, struct damos *s)
 {
-	unsigned long score = damos_quota_score(quota);
+	struct damos_quota *quota = &s->quota;
+	unsigned long score = damos_quota_score(c, s);
 
 	quota->esz_bp = damon_feed_loop_next_input(
 			max(quota->esz_bp, 10000UL), score);
 }
 
-static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
+static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
+		struct damos *s)
 {
-	unsigned long score = damos_quota_score(quota);
+	struct damos_quota *quota = &s->quota;
+	unsigned long score = damos_quota_score(c, s);
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
@@ -2389,9 +2527,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota,
-		struct damon_ctx *ctx)
+static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 {
+	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
 
@@ -2402,9 +2540,9 @@ static void damos_set_effective_quota(struct damos_quota *quota,
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(ctx, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(ctx, s);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -2452,7 +2590,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota, c);
+		damos_set_effective_quota(c, s);
 	}
 
 	/* New charge window starts */
@@ -2467,7 +2605,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota, c);
+		damos_set_effective_quota(c, s);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 04746cbb3327..e0a4e309b15d 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1094,6 +1094,10 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_INACTIVE_MEM_BP,
 		.name = "inactive_mem_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+		.name = "node_eligible_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2686,6 +2690,9 @@ static int damos_sysfs_add_quota_score(
 			}
 			goal->nid = sysfs_goal->nid;
 			break;
+		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+			goal->nid = sysfs_goal->nid;
+			break;
 		default:
 			break;
 		}

base-commit: 4f7b2cc1ad8719d55a8de9675a0aca65cb17c364
-- 
2.43.0


