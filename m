Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27745FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C4E56B008A; Mon, 27 Apr 2026 23:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627D06B008C; Mon, 27 Apr 2026 23:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7EF6B0092; Mon, 27 Apr 2026 23:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3242E6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:05:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E76C1C1849
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:05:29 +0000 (UTC)
X-FDA: 84706473978.10.87A11D8
Received: from mail-yx1-f67.google.com (mail-yx1-f67.google.com [74.125.224.67])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2656DA000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:05:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nq5jzbrc;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777345528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nKzRA9juVdBMs1pZDV3CeSH66YJK3jXv7jdwa1xUxyQ=;
	b=vxuSNLmcHVXeEpfdPKlGLpVbYVF0jYeYGWSeNWkurdyZJ5ryd7/AgIR7DSw644sQuNkLSp
	7g+Xt6LdhvGwoWLQ3E2jpivnMxx8y+GoEl37+FmimBOqhg3i+kwIXaks5am/L+zw0rgq+4
	Vsr/Pa+yak/ZTyE9gnfI0SxuBu/wQYs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nq5jzbrc;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777345528; a=rsa-sha256;
	cv=none;
	b=XWx/YHxkQVf88YeTNtAFeY21s7lIMYAIlU+BDy28zZVaXI+b906VcxqpldwunBTtlWr5XU
	nS2JnqCJ+YZHP/iOVSPS+Uj820yq6BlVv2wt0KPCL74Kk6xgmbSHY+bobgzHMgk5A2kvoI
	S1m6pbBeQQPuCKq0vCmC9+hZzmCi8Iw=
Received: by mail-yx1-f67.google.com with SMTP id 956f58d0204a3-6501c9903edso11108396d50.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777345527; x=1777950327; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nKzRA9juVdBMs1pZDV3CeSH66YJK3jXv7jdwa1xUxyQ=;
        b=nq5jzbrc7tZYOi2IwDRRIMXErIXW7HmhfVo5lidSxjIvNohRzyzjMQHfecZ3FaDNlI
         bUA6+wdA9ehvhZjZA2PQVxDR75196o3VsTz5sPMPsjmWJJ3AAaEnarXtKZ9D1svG6dni
         t0B02ee17a6+XBEngEmYz714ohUi58xnwo5dMGYpD7mxFzOL+BVWcLsi6bW6bMNcMBK0
         ge2qP+YyfghR6AzdFrxlIDPHv2Yv1DReU73jEptjOHvr64t6rh0ceYofGrIV4sJYmxkW
         Gt3s1AjRc2pAPwVSPsd9+WZsATYwEV2MHO2rQczmwbmJftqqiYHSBktI1DaTD9t3Lo5e
         zICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777345527; x=1777950327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKzRA9juVdBMs1pZDV3CeSH66YJK3jXv7jdwa1xUxyQ=;
        b=TYH8IafVW3ip3dC8Z3wFd8QTanaggMk0yqgM6HCv/ywsDYOZDa2wDLRscobCpBFCp5
         yZF9U729XKC8suJfZ7N+P6cjLx7jXGu6wvGIy0jCXG7zmDGxq5rSO1OL+gztc5n3y3/M
         YtnvZFwgH2lKD0+Ol5Dc/kB7GzkD202/c9WdQjqq5UVRSSdaDuf4ocA9HZxI21N8yRS0
         dDxFAeZ9F192r0vhUz6HwvT3aWKnhAa8r2tbyShy+MiyrmdTCnCIa/nVebdwfYGrCByt
         YoMzKfkamZpOudfFZT0GXh+RzeG05bbVJR7jButO+L8vkQKs+zrqkI5XgJwNLDnZmFJe
         3mXA==
X-Forwarded-Encrypted: i=1; AFNElJ87xHzzx+2vUKR0nse+PtRaqD4YztUsfi84ZsswNfq7cPbO9mS6t+gwRx6XMplMKMUTHuwN6WhXCw==@kvack.org
X-Gm-Message-State: AOJu0Yw7tWrnRZUAtgEM0kCzZVQ7alti2b+cfyXUvaE0fO2EDOaWqx2Q
	aTKvLMnhfiLNjFOMVlLN7nv1+jCcN1XzVTf41Sg2YZ/5i/DqxGLa01g=
X-Gm-Gg: AeBDievq7SFiXgLVxjWExqrNRDsdTuJtcC8XJ9fA/iPFp83uH3q6cyVQF5X9tXI5l5d
	Y02jcd1DWDanshWlH3yddHLJwu5sO+9uFzpAWCETMPw0dTtoT1fSOY/QHlDSmYtfqKZ7VaLT366
	e51e6hhppz5rlEePJ62m7aS+8cxYjjQj+OiU+DASjSmJF6EzC2vdbFbSzQ0hkj3EEbItjFXbl3w
	1xrEbrbYWAUGB+sK6DUBvjvOTlpdxTGwJGkIvGujTa0ub3kjeYLWw0qUnoScUWXlxMWnyTFd58d
	MT6DTAWXan0d19utZrUWUa5MGOeSdB2c122R2kLYv5nU5pzTBkZpfuKC6KnvLRvpDgbaaGTslA1
	rUWAU+2onWCwMkvl/vbUUcgkoZZEQ2U8/vzViEQuiUiBtXODhMWZLu3GNkXT1aha39AcWAn259M
	+QkC+iYaTVXXPJyIW8Kv+NZe50ZY4e+qzgxsY6g5gvTWrioifGs9yf4aC/jWgrDO5UNDCboYuxa
	+lPIO/g2q9xPqaOzg3E0ds=
X-Received: by 2002:a05:690e:14cc:b0:654:ea8a:f2e with SMTP id 956f58d0204a3-65beed3d1cemr1081635d50.3.1777345526966;
        Mon, 27 Apr 2026 20:05:26 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65bee26b960sm738059d50.1.2026.04.27.20.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 20:05:26 -0700 (PDT)
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
Subject: [PATCH v9.2] mm/damon: add node_eligible_mem_bp goal metric
Date: Mon, 27 Apr 2026 20:05:20 -0700
Message-ID: <20260428030520.701-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2656DA000A
X-Stat-Signature: zfcfyjnzsa9of5s7i643dngrc4pejppo
X-HE-Tag: 1777345527-926279
X-HE-Meta: U2FsdGVkX1/FmEV05vQMT5Gec15FVHkAA4fMYWYCA4EOgh9EI8qSZqNv/+ZplXBcYeFRHKY0eqsbRKmcNhzZHjI9yQHfCAuQqqULga69hQIrc0fGRNigWrTMNS5s0ZIXEQeFIfpfAQbpi9e6m1TBtclZARAsFFo5ek3nbLlEUlc12t3ACMJfEGjwgtf3xF1WQkNBQ/e7ZmVDUEMQIgg6n61F13PJmJYP6ZyFVrCApKIqcDZmrw0/GZLVyVnPGCEqGYsLqIKphP1Qja2C4pizVeNi/9JMqALlVwVb3VCaIYUARFTmo8YasBn59NtTvLDSe+zi8LlIpX5BdEHPE9UhyWCTIT72ZhOmgvxHZ8QOXTr3nFuJ5JjGaDsp8FDnhqyhyZShYT6tjWbRj1I9rKY3mjPILQ9DRsx1s08VtGXMQqndetE2oEs9oyq7RMqREWoaFvF1tihCoLS9Wz/dhoemd0o7t3y/uido9UFUewplX7SMsbtotNccxivU+pg8BRNDo+HvGkL34mK8fgopT7G9ewW1Rc8ZjMSurll6gIRi74Nhwja8tDdFhZ3s5MGyf0gd80J8KG85L13T8dZTYHmxLeL1TfAZVDDi/MMkwq2J4f1IFIWooxW+kubjLUaC0jrO7in9Ot9BjDuaKkfymdN6CFftJn2BVcprGidsuTXSTLgrEwIWixafma6lYTmbqBB8dps/5HQZSn+uWv+uXEFmZGRYRng9vygHTQa2yPdQyRoezl5V2Nc6cvBF3r392TZu2F/moDBf2bagybm3R7bPwguQaZiDtEDqXqkDs4ud2MA1JwwHX3wNSkrealob9voJt/oAGvhtwLe5DZep96KYDXiismRhlwJNbkowUJTZzf3oKDtarlkWBN1UeDw9I9HzIdLBbTDOibkkG9e9NNK1GeE3Fw0y7yIdFV+9qZanGSFaR1IBokYAysAk031N5KPzBNvFJXkn5dR2uf3w3m/
 mrgSyzQv
 MMagvyUPJNsWyk2O9E857MUxplYJFplYLTs8k9Xt29V1mGiPM9GEmorrvRf/lYkBxUOEtFq0McVGuROcR43zGmmKPqPfSy555uPD5OzwfG08vN70xVYT28oS7ragMVGG4cocY5tL4B+KHPM1uojcSfwrT9hCdBopdrwqFLltLEkroc6i7eX2tW6ksB/87yoaBgsiqJvQ4qu0nXeuydqwYXi6vBJWXGZ2AYDubfNf0geTOZaJVug6N8HWczQ4AdBabDpbMSQQYhQ0AXSgV6APtgSDabNdGgLSgkMQzcdaGeIR7Hd8Or5tf47GTIKlzWjVjVc5wy3g4+lXBFXbFZ+JjIv/qEvQWjsIpUKcKtP9SCRwUGMDNg2UbdRVLIxGdGeHYx3QAvteop1IPy8JbQuKtv+JY3Xu63Owsx1McpfXViRGUH7GReO4/nE35utGfJetfQSM/J6jglL8S1NInd+MyM1dJbwa1EtAk7Y9Z5C9+hFZtizhIqoluHYWB9jLnRShXauYN/XbYVpOXR91AP2fi0L5MOSAiDYB5VgYAvn+eWfIPXROyvuBAEP/g9pWY/aFs7M7Cmilri3eu1exnqZKblGdj7xi0epAvX9C0N53epQ7gtgfV62leh8KfugObU6l7C4D5hTiY+2kFJj/svofKNKt+SmYT3H5GGtitEMh8S0JhVTl6mTEL/SeRqA==
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
Changes since v9.1:
===================
https://lore.kernel.org/linux-mm/20260427010209.843-1-ravis.opensrc@gmail.com/

- Break calc_eligible_bytes() loop if addr overflows to prevent infinite
  loop when addr + PAGE_SIZE wraps around (SJ's fixup based on Sashiko
  review)

Changes since v9:
=================
https://lore.kernel.org/linux-mm/20260426213859.1835-1-ravis.opensrc@gmail.com/

- Cast phys_addr_t to unsigned long before mult_frac() to avoid
  __udivdi3 linking error on 32-bit systems with CONFIG_PHYS_ADDR_T_64BIT
  (SJ's fixup suggestion based on Sashiko review)
- Check !(unsigned long)total_eligible to avoid divide-by-zero after
  casting (SJ review)

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
 mm/damon/core.c          | 172 +++++++++++++++++++++++++++++++++++----
 mm/damon/sysfs-schemes.c |   7 ++
 3 files changed, 167 insertions(+), 15 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d3054af1d964f..82dd43fb639ad 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -161,6 +161,8 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
  * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
  * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
+ * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
+ *					node in basis points (0-10000).
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -174,6 +176,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
+	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 278594847cf94..00ff1a1c92e73 100644
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
@@ -2288,7 +2307,115 @@ static unsigned long damos_get_node_memcg_used_bp(
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
+					addr = PAGE_ALIGN_DOWN(addr +
+							PAGE_SIZE);
+					if (!addr)
+						break;
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
+	if (!(unsigned long)total_eligible)
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
@@ -2300,7 +2427,13 @@ static unsigned long damos_get_node_memcg_used_bp(
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
@@ -2320,7 +2453,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(struct damon_ctx *c,
+		struct damos *s, struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
 
@@ -2346,19 +2480,24 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
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
@@ -2367,17 +2506,20 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
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
@@ -2390,9 +2532,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
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
 
@@ -2403,9 +2545,9 @@ static void damos_set_effective_quota(struct damos_quota *quota,
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(ctx, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(ctx, s);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -2453,7 +2595,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota, c);
+		damos_set_effective_quota(c, s);
 	}
 
 	/* New charge window starts */
@@ -2468,7 +2610,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota, c);
+		damos_set_effective_quota(c, s);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index c14a564dd8218..e897745f1e185 100644
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
@@ -2690,6 +2694,9 @@ static int damos_sysfs_add_quota_score(
 			}
 			goal->nid = sysfs_goal->nid;
 			break;
+		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+			goal->nid = sysfs_goal->nid;
+			break;
 		default:
 			break;
 		}

base-commit: a1316f1941695b84c9b9eff946bee67b8c8ff0d8
-- 
2.43.0


