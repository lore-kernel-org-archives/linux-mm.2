Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0220BFF885A
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 00:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8176B0088; Sat, 25 Apr 2026 20:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2424E6B008A; Sat, 25 Apr 2026 20:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2E46B008C; Sat, 25 Apr 2026 20:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E96976B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:32:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13F84120436
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 00:32:54 +0000 (UTC)
X-FDA: 84698831868.07.64F1E92
Received: from mail-oo1-f68.google.com (mail-oo1-f68.google.com [209.85.161.68])
	by imf17.hostedemail.com (Postfix) with ESMTP id 361DE4000C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 00:32:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jOGPepdx;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.161.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777163572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ErNgJXSkdgMs2LmXJDoeftzfAnsz7AjCk/cSLhb2Zaw=;
	b=07rG2SeSqS04A2fVIl4RYe4BXgKbgDOzqHt37oKXItxNm51s9WoNroZTP5TFvRh2VEpAXB
	dz+22/z4IuXnjPGi22yeVuOjHbZcZhj6/6LKXdbXQuQrsi4/TyMg6ldIb1eGwzLoJWqs0U
	IzNjvZ+aO6VUWwFHH1BtQJuJDOgNkBU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jOGPepdx;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.161.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777163572; a=rsa-sha256;
	cv=none;
	b=1q9FJaG/8LW6GExdhnfhjlk2ztmM4ndwFFmlt3p6IcGWxvCpHITtezlKejvkuDKbn6MaVL
	J4FhZJldo/sRSghRTOPa22qhw+Ric5Sy303ZAVxryvBX+eMX0eDoEIpwFb1H9HDm2xUA2u
	n5xL3dj+Tdh7i3ET/LyqYi6Yv1+Yb/s=
Received: by mail-oo1-f68.google.com with SMTP id 006d021491bc7-6949831a7bcso3059676eaf.1
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 17:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777163571; x=1777768371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ErNgJXSkdgMs2LmXJDoeftzfAnsz7AjCk/cSLhb2Zaw=;
        b=jOGPepdxbcqvQIwkPjifQoE+YZQ9e9NfNy8Bg1fayqAK5JPmqwnjYDPJXdfNEfQ2aV
         y2KVF4rETCIRGvZ/iSabHNKDOpfl1Zb3ogqH67aYYPCqxY20b8+uczsmr+wzc5PbEeoT
         0IbVlLNFmSBApOe23hFPmUBYaCV9QoA1+g8+5C5EPpBEzPw6RXyhN4i4oK6eqA84I/mF
         WySY45yDQNiW1QeOToO7DjCORXFB45uRYXErB0/ALxnYjEl3RWdhE3iaZisyhlYgIgkG
         1BZq4BkB4Bq9FOsdNskkR1RYFyfCAaPTIjHYH1sWz807KWf2wAG7KAHFPNeElG0GbJTN
         0GgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777163571; x=1777768371;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErNgJXSkdgMs2LmXJDoeftzfAnsz7AjCk/cSLhb2Zaw=;
        b=CpLe6QjmLPeahxvWg+ykGNuS+e9WrjHRVcuQqIPee6RRNMwRSz6rFd+EKDpCa4gH6z
         eh4Jbq29hqTpGs/JJy0mrrA8pgtEbDKT5XKgOU5DHrV0ZisTdaIWCk9xTRSoIT1hTqOo
         CRaTC/ta8PuX5jamPLBOO6+nO1YRF7vZE7Gx/QNH9canTUlHsFLTeB0sr8CKheFPRAST
         7rxgXB4JfgP32n6/H3qvjB7DHxIGgI3BozxOjGnQ6Enyl+pXBKtqcr8xkgoFf69StjFt
         SEk3rgUL6x2W3hmjTzJ83nsyULkkDOXkX3aLegJFB+qmsEBd0kn6sZAa2sqXDtRUIjR/
         U0FA==
X-Forwarded-Encrypted: i=1; AFNElJ8MGsGLLjwGk2OF8FxQMooVBkIOljwHjnBlZ9OKmfXH+xRKClCrywbopyGOkoBb1ru7iRIj4PnQQg==@kvack.org
X-Gm-Message-State: AOJu0Yyry3cQdAvqPaWPxN4CZC1d5zkataevcuUPr6OwYVZXe5DaDEm0
	ywTLhE7AEE/pJAzels9IP/bLo4wg4pPzkMx93yIywlhn1y/7cdx/Owc=
X-Gm-Gg: AeBDievP57Hms2UA5oDOh3L/Cs0vuGidN19mxKFvprNjq2ZxrRzm7AkQK6TatG0PHYZ
	Jv5HGcvLjMllIp1hDfbMuwvrh47AgQLz/DWcLCph1NgxaNvE62T6yH1dRUW63BYXgnavXtlVA4L
	uwtaKWoB14tCGAHEizvZpSdvgG8scegOJGT1NWmE8pr/B3ADb5VK5ZBPxVzDG4a7qYqjkgEWEJL
	YCQTx3yESnVUdfL6BKiGjIpmCb+7xlpW2vRcSRPFeauau/B9g1jlwlFXYasgQaaYcPpF4JDgbTM
	RWmkbzI0loAL8alecLfka+Bxady13MbmQUGTcVF38OA7YqFY24AWet2tFQ2KESKmsufwPFIBZ6m
	+KifYbRvh0vKNkLRQbOIjpQUYucQSHi2DbEs3Ght3fvFzEyLtbhLy+FFg8j1RXccq/zx5Lu97Ix
	SRil3+iAgNdH0EepMCHfNKHgEuz1BNins8w0w2UMNhmZSRgDFMByce5zCACEIR5JshHorYrJnAo
	rgNP9ErJgVQ
X-Received: by 2002:a05:6820:98a:b0:68c:5bdb:8c12 with SMTP id 006d021491bc7-69462f303d7mr22097776eaf.45.1777163570898;
        Sat, 25 Apr 2026 17:32:50 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42fae7ee3a5sm14805795fac.7.2026.04.25.17.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 17:32:50 -0700 (PDT)
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
Subject: [PATCH v8] mm/damon: add node_eligible_mem_bp goal metric
Date: Sat, 25 Apr 2026 17:32:45 -0700
Message-ID: <20260426003245.2687-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 361DE4000C
X-Stat-Signature: 8po7epq8fiiy1yabtfrdsybjtj7bxmm3
X-HE-Tag: 1777163572-660583
X-HE-Meta: U2FsdGVkX19KviD3TC3UcFWJ3deJChUIMkHSXKNCIQMHANWEnqwCKMCblLZYCIGhjeTcFO7awkhbXGrNzUINraM0YPEo6r0gFeiMrvlBLqMRupPUHnpMWH3uChD6ORk/DiTmRMKAAMRY7+IKN7E0vtRt8TfPKRkZrm6kAMhxLNG5v4EHTMcNq+5ZLqBMEFTCNVhoBuFNQ2t3nUHPqIHsBAC7HcfbjtOEZKjIc8zp5cP52HVYNmqWziQCAANY2IuqwKi3OJqfB50BN+VSepyNC3i9U8dnNVkMsJNOtaMT7IBzspcQyvlEmIIljAUh9W8sGaktxkW9KEZo9gSo2NrjVvCrdrpd+1kS1rue6iQB6VYJdRUpo6R0xNW8S7XMvYTbSD+iPYCJ15PkMdYl1VN3ql/b1oArvQbq6yiQozUx4avIJgp4T4f+PkU6iMNpLqlRHwCIDk5dgQLP0nhd/HK3JMQnsIvjmpiWRvhAorDfZXk/ijzstlzLIJhGLwtlm0/xDHXoS2reY5tJfXradz5d0Yhb94+Q8LCXksoz1NXN51PonEKVPw99GnQvHCl1/+Cklc0O1OE/uR/OaXKA7JMPOrQWN3/UR3L8/47FgVGMdQpY8qV2vbsdFBSjXdVm63BqLbduixhnlr2ziWMapZDghbMlf871PlAuPnDrREd3ErZgymdXaGTGJd/nOQVAj5koFg3Hr5Ele1KgqB71bbv3dIAj7Uc3rGBNFFi1EHzYs/ZGdsd/tgsjqqiEAZo0CqIyPdaS7xxGdZ571FPGIdaSIim/3pxElTqoDgVmZK9Co7Vh6RFhB2yPtRF01TCS6bfwmuGtQOZ/Ju6l5H/2HZ46Zc7RHOFeg0L6RsPFNRICnr7gyYieSxR4ndAjHSCxZ1im49+fv9ZkBrOGbAuOaOKKDHAfNKhvKWfGMJJ/WRyDZRqXeWGbSWZ3Skseat4+L6lgCJkko0tjzPOVc5WqTZY
 mpGdiVUA
 qrQJneY7OpeKpCF/tAiB16gyKyG6/VLe0ZIQAsWnrhfeXhQ2F+ngg006nBIbVuzc0zvJ8Wl4La5DTUvEFc4AEJvYDMLp0JDHEFQJ8aJ9dEsTbTvm0v0wuE+AmITrdxUnuAFKg36HZm/X9WJDkADjnlMLltTAcNZE50i/tr2VRnQ/kN9Vx6u/ElfU8Hih+G5sI4zk4w3ovgQkMCYRSRo+qZ9aG0nVXtTZD0TzTZn1uWzSEPYBMxZ9c8hnP4zRwJRxy5uRkom/2S0htSXNtOy3dmZDuQQcjErbDI9sftTyToCMuExV0V8RRkxW3gJ3q/o2fx7eTa9LNAlpKWdoY1iPue2lcE282ZGjmauty/ibbZ7YTKbARadevu0wog9fswPgZx4QK6jcXCAWknW/eSwCbyTbT4sjPlvWy4zkE1WYIx8Dj6rHlS3+n1OBdnNGN1ttUIZYQS1MCGDyxErOZQ1fDKvBH8ghU6cP2oVYYAhcu90qRzidnfd+T/MiDuxUuISbnikNHn0vTQ6mEzfrWNaqUd2W5cIP5lVfTlF4V71BOVEs16coCuqzW2avkpCMEkmua7i6bs+iJlnc8uNAR0iiOwl4IlUsz/GUPbRTytaycPpEhXgwdhgKLtRi1UgsnoCrSmiJb48XwzmIsX7x8J5ufqjrdoo2anBEBzbiwYAGxw9uCDlN4Rp8zY+cXRQ==
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
---
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
- Updated two-scheme setup to use 6:4 ratio with both schemes using
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
 mm/damon/core.c          | 171 +++++++++++++++++++++++++++++++++++----
 mm/damon/sysfs-schemes.c |   7 ++
 3 files changed, 165 insertions(+), 16 deletions(-)

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
index 3dbbbfdeff71..a9303a8c4384 100644
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
@@ -2287,7 +2306,112 @@ static unsigned long damos_get_node_memcg_used_bp(
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
+	return mult_frac((unsigned long)node_eligible, 10000,
+			(unsigned long)total_eligible);
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
@@ -2299,7 +2423,13 @@ static unsigned long damos_get_node_memcg_used_bp(
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
@@ -2319,7 +2449,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(struct damon_ctx *c,
+		struct damos *s, struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
 
@@ -2345,19 +2476,24 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
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
@@ -2366,17 +2502,20 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
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
@@ -2389,9 +2528,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota,
-		struct damon_ctx *ctx)
+static void damos_set_effective_quota(struct damon_ctx *c, struct damos *s)
 {
+	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
 
@@ -2402,9 +2541,9 @@ static void damos_set_effective_quota(struct damos_quota *quota,
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(c, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(c, s);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -2415,7 +2554,7 @@ static void damos_set_effective_quota(struct damos_quota *quota,
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
-		esz = max(ctx->min_region_sz, esz);
+		esz = max(c->min_region_sz, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
@@ -2452,7 +2591,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota, c);
+		damos_set_effective_quota(c, s);
 	}
 
 	/* New charge window starts */
@@ -2467,7 +2606,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota, c);
+		damos_set_effective_quota(c, s);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 245d63808411..f21191d31f58 100644
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
@@ -2685,6 +2689,9 @@ static int damos_sysfs_add_quota_score(
 			}
 			goal->nid = sysfs_goal->nid;
 			break;
+		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+			goal->nid = sysfs_goal->nid;
+			break;
 		default:
 			break;
 		}

base-commit: 80a5456b3cf475eea155b66d7a06ff266dc05647
-- 
2.43.0


