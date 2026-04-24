Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122E1FED3FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 20:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A66E6B0092; Fri, 24 Apr 2026 16:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257516B0093; Fri, 24 Apr 2026 16:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147796B0095; Fri, 24 Apr 2026 16:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F23F06B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:35:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 888871602F0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:35:00 +0000 (UTC)
X-FDA: 84694603560.03.4354F9D
Received: from mail-ot1-f67.google.com (mail-ot1-f67.google.com [209.85.210.67])
	by imf23.hostedemail.com (Postfix) with ESMTP id B849314000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:34:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VH78evNI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777062898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=92bmG5mdwkOb6S734aAYKrvcPKrn24NTG3MKYhd6SJk=;
	b=crqecDN4XYi2VFcnmFy0xD3z/1vJBvlUvteYkv4tTDh234sieY3Y+iNY8DU0GGwoqS5uOR
	rOWRzzBxi5+jkMm+EvjpZY0ifUpc+FkjF5wIDVUJEeQ9nA6Xb3S3jlW/0hBapbZUGsKvYd
	KMio+ahdatxFX8NESwN/XtoX56z4sQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777062898; a=rsa-sha256;
	cv=none;
	b=qMAdCuKtbwKb95hK71aFGzuxiAbQb5Zvr6GT+nOEb5vt4VeVmnhvAtx6+7Wi1UHUu8R8Yh
	dW/6W4so7FMoYN8k05xwiAEupd98zZTLAHd3gvEwe80ccQj0TN9LUT/N7PE5oZ3qGw4w9v
	POolcUEMG4cPUMeREOP0cN12hmeQxpc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VH78evNI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
Received: by mail-ot1-f67.google.com with SMTP id 46e09a7af769-7d4c383f2fcso6948429a34.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777062898; x=1777667698; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=92bmG5mdwkOb6S734aAYKrvcPKrn24NTG3MKYhd6SJk=;
        b=VH78evNIKXR6ffyuIx9kCKjFdTqEGFLT7gW60+5PC1YBkUBfFNhVfJ5jQlUUdiLDoT
         z14L3Dba7yOnnBvQ86NH0tx6GEl6oQuCINBGXWymDIkiT3JzHyjwSa6temXxVM9uUdF1
         fwy5DMT7SxUJyGVlQ76y3AI/ckJ6GNyI8lGToM6WnF8Y9HgHT3uegBzOGmOYvnenEP8q
         KaAZl7bpuboHeb0DL6wgBwTX2831AkoC8d1KPllPZYomfTknL1AK7jwJcRQvL9FWFJNb
         ugMPP3WQCnBnCSEBGMtb1V9Sb8M/1rsXFTQk61I5bJynyZLMoxpsQfFH7TtAS64vQG5h
         Lr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777062898; x=1777667698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92bmG5mdwkOb6S734aAYKrvcPKrn24NTG3MKYhd6SJk=;
        b=I3m00u0gOtLnKclPbU4MxIbwZ1ys4Jbkky65cTqhbypRY5KFY74cPt8jBMBttaYCkS
         X8bdPiRdV1QUxrJ+eFloGZldaXQ64JxqaOxYOCq95MbR7IyoRd3/QM5KW5gIvFpPE109
         tMCnXZ4WwWxiBclq1Me0/XKRS/iu9xw27c1HSr8IlnadjHYSEepflPVv6fkgD8Ov+Fs3
         i+kqcYWsC7YNcu5yvJtBvM0OAKY1RGEevrlph80QngZDri8SLiASlXrk4+PRZKNMVftx
         vRCoSjp0h74c8fsMSeTQBojDQtMVdRtJno0bXs60+IDqfXtqvWDLc4LBPSpi/+aEHjBU
         r9KQ==
X-Forwarded-Encrypted: i=1; AFNElJ/JYYXs/mPTNiH0v9Fy7RTym2owWhuk2jRWrkY8PoBov0+gfOZPU6ZSBxN5TyYEyD4wcYSLoOvwcw==@kvack.org
X-Gm-Message-State: AOJu0YxRLrrJeu5gPjPF5vmsIlNa9gK2MGy2n+MRs8OpntfDzvv37tu7
	beqgxZYRSY4ZYGx9RUZY+PeFTLi2PcafbTA2ZiyA1xT/ZgLuKaJzqoI=
X-Gm-Gg: AeBDiesB66PoxugBnOfWMuBGU6ycVB1e5xwPLszOupxL/DqFJefhN8GZiSiiFI6xv1i
	AYD5np58pSzt/zJx5gyKTvVqip67BBF6KuG0adtvj4BoEdoRwzPGrzzqxFM03ZiRj/FcMOAzoDQ
	jkxxRmLXCB6ErunqgOvFUFPUHLpWsadNWZst1SAwCDexEOHXBqJnVG0qheL1uAGzajtJdNdNseA
	u3bSeBMhzoyQbW78N/ORXmZamxHaK5WZilQDzBGk7QDAhrVvAb8rKz38ftmUmz6Iaco3jpGjMIY
	IAEmTpOCRFiSTwzxpuI9PmUAPKS73HrTp9L7rnLQhNZ92R0u38sRpS6ioRM3/nmLoxZAXsw8rEI
	YSGyHpEHZLfvy3ektu1Qw9HhSBZoZWmZp0rxvKjG3xoZ9aOOJZ3BjfKfuG9+5qyyBPrEMuEuwNz
	7L/fsPkenaitupBnsTLv+rosgTVtsrHnlbQxA4C5H8AZGqLBuOfmv2pUXXqCfiAm5m+8nxK1u/r
	BtTmWfBjmAHthO8G5E+FGg=
X-Received: by 2002:a05:6830:6d56:b0:7dc:d2ad:fb29 with SMTP id 46e09a7af769-7dcd2ae018bmr12849116a34.24.1777062897420;
        Fri, 24 Apr 2026 13:34:57 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc975034e7sm20050939a34.6.2026.04.24.13.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 13:34:56 -0700 (PDT)
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
Subject: [PATCH v7] mm/damon: add node_eligible_mem_bp goal metric
Date: Fri, 24 Apr 2026 13:34:48 -0700
Message-ID: <20260424203448.5040-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B849314000F
X-Stat-Signature: yeq6dxyg16enm47i37f33ainnsqkeyn5
X-Rspam-User: 
X-HE-Tag: 1777062898-892560
X-HE-Meta: U2FsdGVkX18U0owVIW4Y6MBXkj98HAwyUbinlWSGTmmB8stQqdCui3upBJlIThX5WH5BeGpVXJhUC2zVIEb66rZY3mwW38Zn7nvQj3UQL3Vswz7SwBZDSZ7xdlr0hzxvWhq+oHibKY6WzVthZXANpkZ1UCrQyUQbmsKVkTFL3XFiP5YjhTL3A4/QnKcynCRa8vdJTqeEi9cK9xv3O3Q5GnUQSZ1VlMJ2fmY4Juaz5i3v/8Ewn+7IZqi67fMD2ztOxT8mF2vwVioIW9FsGaYqfjwjElpRJDj8Xra+pwFn888RyLHN4X4jbjRlXcnF2a+pWHhhqEwdkF/nBcAzDTzMyLtGEF0kjZq7RiyXkYAJSJqU5Hh41zL5mkZNzgB7E+GyCTLY2U6JqiWYcwsk/tji2xlDW0aMKLRhNu5ZgjTbj2rXGoi1+8Ax5p/IGXl9ZmY+hmR3M6Z5rwgsVp3ADgFym0M3b/CV3g/Tov7aUmTVkolMEdXrvkFekzVsgqa7giPmykhNL0DQywQqVU8ChK0xpBL/kjOkjBDEI4E8HxqI0jgx9BQ1SXyDqiSQLjIqS61B1oHSDSzksZoYI+c6cN2CQstqR21aQ2a9tLnnniSUWavq/RG/weX7h8sBEu4cTsshbEYSeaxhKDFlWEVd6mNKJdlTq9D3H2gvde9c2hA0pV4i9ZjL0WKmBRVeUtMW/oxvH1+3zAg/k52WFQrqpIdu2mO/Mjon/PI4o9FEMuNd/etK0mfzCLWuD0lMEIaSG+mIw39iuJomQj53c6tL1lSSJleyXMMtlkFDO5lpYcpOUWPMHmuVter90KkaHrer/p+zTBpjT2WJCfPGDDUbaK2jujexBeAUyF/oRqcRjD8HK0GUSDOSf+GwGLYWvhCvVCi92DMrQqdsb3BqigdaMXw2JlChD+T5yk8jfXtxwxwQCLYCWrEL/Zb9PjklxB7iioJStBZv4YFp8Lm0KpYHiV9
 sRtuKnNF
 ZkrhG7rSN68l8KafrR3sZzkMwc1xXIPwiVPAsEr25CxE8P1fjub9RFtDeSonA6uRIvpQK33vwfXXi83Kox+aU3UjcEXbFJFwhmuNE+fadcR9bocj8tcxzJ1KZhYZzNc1sn2568BAbFMM2yNVGM0P1QQiTntGrHmXDGNRl7oY2kJLG78nhLJGtv+Ini+q6NzOPgN3LO5GWtqevVu25MJlOL8f+pAS4QQUuCyk+5cLEjLIaA0fA9Pz/ocrCX2h3n1EnEI+HtV20xyy1d0Oh2iuwxOre33dfVjRebCYOtfaihQMKs9EM/V18+L3wLFPjyguHUeeHFxzjyRRLOtCaO4g9gY7+NCmn1VczNoV7Sb1y3/f7ifTLuRCYg2kNMDiDciZsYGkv8Nt5eAKT5Ii+AGryi8L6+v29csq87Vxw76q9WnSjfYv4rCdoMQmGK3HMNGe+Yewq1fFrjRzUtf2r3JadLVzOH0aADnHel7qNWbVrkb8zyd6jjJ1IHeZUhLRijYPX9HPQiocR3o/yDcUVZRRPfgBE50nlQG4ifH2IWJd3UWG4V1/aNEVN2DfIOk5Hn+m78s3mB62duzxIX9iocpkRpan7Aa/P/dKcr2nK7/zxen/ysRs6+8wW3PQECEbbNbdWKGdhQhPpox0vNtPiMEnV1fI/LtgBeNKBoJyw0yLHqMNaNkQR4ghSt0GqGVLKjx6zHRyQOqPaAk8OpDhJA/gGyAJ7cXnd6HJMwFKGQE8Ts7OZsK5USG7wD/iD1A==
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

The metric iterates through each scheme's eligible regions and uses
damon_get_folio() to determine NUMA node placement of each folio.

Two-Scheme Setup for Hot Page Distribution
==========================================

For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 6:4
ratio (per SeongJae Park's suggestion):

    PULL scheme: migrate_hot to node 0
      goal: node_eligible_mem_bp, nid=0, target=6000
      "Move hot pages to DRAM if less than 60% of hot data is in DRAM"

    PUSH scheme: migrate_hot to node 1
      goal: node_eligible_mem_bp, nid=1, target=4000
      "Move hot pages to CXL if less than 40% of hot data is in CXL"

Each scheme independently measures its own eligible memory and adjusts
its quota to achieve its target ratio. The schemes work in concert
through DAMON's unified monitoring context, with the quota autotuner
balancing their relative aggressiveness.

Implementation Details
======================

Key implementation considerations:
- Uses phys_addr_t for byte calculations to prevent overflow on 32-bit
  architectures with large memory configurations
- Includes cond_resched() per region to prevent CPU soft lockups when
  processing large numbers of regions
- Validates that ops type is DAMON_OPS_PADDR in both damon_commit_ctx()
  (for clear error feedback) and the metric function (defensive check)
- Properly handles folio alignment when region addresses fall within
  large folios by calculating exact overlap

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
index 3dbbbfdeff71..4ac805205261 100644
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
 
@@ -1326,11 +1330,25 @@ static int damon_commit_targets(
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
+				if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP)
+					return -EINVAL;
+			}
+		}
+	}
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;
@@ -2287,7 +2305,112 @@ static unsigned long damos_get_node_memcg_used_bp(
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
+					addr += PAGE_SIZE;
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
@@ -2366,17 +2501,19 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
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
+static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c, struct damos *s)
 {
-	unsigned long score = damos_quota_score(quota);
+	struct damos_quota *quota = &s->quota;
+	unsigned long score = damos_quota_score(c, s);
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
@@ -2389,9 +2526,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
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
 
@@ -2402,9 +2539,9 @@ static void damos_set_effective_quota(struct damos_quota *quota,
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(c, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(c, s);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -2415,7 +2552,7 @@ static void damos_set_effective_quota(struct damos_quota *quota,
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
-		esz = max(ctx->min_region_sz, esz);
+		esz = max(c->min_region_sz, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
@@ -2452,7 +2589,9 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota, c);
+		damos_set_effective_quota(c, s);
+		if (trace_damos_esz_enabled())
+			damos_trace_esz(c, s, quota);
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

base-commit: 277a7fae172bb4a598e0d4144ffb2ff6207fedb3
-- 
2.43.0


