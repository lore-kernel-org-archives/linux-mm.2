Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB42FF885D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 01:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6CF6B0005; Sun, 26 Apr 2026 21:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E685F6B0088; Sun, 26 Apr 2026 21:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7DEE6B008A; Sun, 26 Apr 2026 21:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C4D5D6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:02:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68B281B8F1C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:02:16 +0000 (UTC)
X-FDA: 84702534672.15.C632547
Received: from mail-yx1-f65.google.com (mail-yx1-f65.google.com [74.125.224.65])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94AF5C0008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:02:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=goJRSKf+;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777251734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0ZI2xM+TBNd7IU6v5gjYzXQ9SJoiQ+0RRefyIfi1zWQ=;
	b=MNlO3vlDK2L/j4EUPvQeLVugk2QhoDhjk6EAd6X+EKpgL9rAgpYYzofSocbeW9lwplOPLy
	DeDlPaX5nMxl5p3yBNLJFyEUTwq5OmgUCq2LzgwSnQMMGvAoXvV6XMbmKfb9LJGaEvcFba
	GaM8ktlhqmmw59Uih6tem0dmP7BPZ8U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=goJRSKf+;
	spf=pass (imf22.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777251734; a=rsa-sha256;
	cv=none;
	b=LmPYMwkdxseUixBr15rHyGZ0sK5XduMKwkajAJ4ECESdIi4PGdxACF8Nc3Zisfy0ZxBKGt
	XdO4rIlfsoK7SNauWOVAagIJW9OnDFUOZjkZJF98glY4woXDplF90/1rVPK4+loCCztVNV
	sfC28xu+AgExRV9B/eAYH2GlwlOggc4=
Received: by mail-yx1-f65.google.com with SMTP id 956f58d0204a3-64937edbc9eso8198012d50.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 18:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777251733; x=1777856533; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZI2xM+TBNd7IU6v5gjYzXQ9SJoiQ+0RRefyIfi1zWQ=;
        b=goJRSKf+I5cAWnQFAg+ZyIn98co48fCGWxTti/CDVXIZf3r04S4efs2jq6XkaeQx3Q
         dH6h7MBQn/3Q94Wq0BmiwGGBBpd31AdjGnAqT+kEJ7ZbEkiWIy8TRih8CVk7iKzr3Nun
         19hGAobZ0SicUjjsjxngYynbMxLu6TGJw/qiO5UFGGTYQH9UdfVmdvHz6g9quSSf6ik/
         LNzQi3fEJ4HL8S8VPgXN26UfUqyBf1KICGcXxJvUnLJSH6OJn8mHckKsQazlMz4rici0
         Vvfu3fXyLGu/nziJ8zxuMA+OdAzBg5IL6pDCn4tV2Bv5UXe6rBj/VsSHX6FAAcRFeTa4
         cgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777251733; x=1777856533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZI2xM+TBNd7IU6v5gjYzXQ9SJoiQ+0RRefyIfi1zWQ=;
        b=ZBAxjfrRTb0fuhxWtSjTMQVHl+ZPp5kqcSlfDjGue5KEWQKwa3Uo9c6vom0gwwLZVs
         izEq88jG+xwyEWuaHyhLzEuIZQGT5ABwXTVX7VvnQQuqI9Wn6pD8+JefUsh32LQsfplB
         4wn8SKAhapLOhHSuHOLa5p3cYZmHtdF+xuyIarIPZ4dH8/l1qOjx4x9Zp8R6xeWYA73q
         /Ds/1KH0EvjYhs/z4RTFQ+OcLCNqqhYXWT8/vHWn38yF/ZlV3qTOpI5f1kYa9yWs6pu0
         1cMhtjBaGvJRcuADGjpUbirDwuAdQGwRISFBJVAhHLEvdM29DQK0gHnqP0n9Ezcb1A5Z
         qafA==
X-Forwarded-Encrypted: i=1; AFNElJ8aKF59RRsiRC0DzfCIWPJ25MFnlDBxgrKzdGu6vRxmU7ussny3cpvR0OrZI93dAxrqcsZ0Pea/Yw==@kvack.org
X-Gm-Message-State: AOJu0Yzswo+DkTIHSk9NMyit02al102VAlWiukLbq+xfXnRpR4ZRqpBU
	gnsAMlK/7n7trcW5woreHkca+lUOiu5dH8Iq1fk7Her+bockP1EDnrI=
X-Gm-Gg: AeBDiesWaiG68/IjNNy+wfQAn8r1t+kFi0D+U+WSAd9kc4I+Yxs/DMq+9m/75YKFZEm
	mEmI+ZBjUltL9Ub9bQSe/EQhoOzRByA6xvKHPTLQ3ETm+DFqZo5ctjxhQMMsjwB/3QKYBiDNaB+
	FiUtIhKxmHhAS33HZdEWi7yn9KBd8yaonzXon0st7nhWkdg8QKrxWU6A60npgEXsgEM5yTJvjpx
	YClok1bd4beDZxbIwgT7QGT9A3jTv4hPo9oKM4YvtREM5eZ1GF1MT8ipMxZyE7FBBh2i5I9SgTg
	/b8pp1uFsrw/s/1ofyQb8v+QSbGeTe0zKWYonsT95CTx3j568qlN4OPKCNWkjNbxuVaNke0HLuB
	wyf2t/s2OjJmPNEtfBR+S4rmonhMPaLYSblmdpIazyUAabG0C2Tva6yYVLFeDOFx+1+5qoyk4NL
	7kdFHtagdf33NrNw/EyPaFun3pS8d9Wfwj2mcKB1IA7b7GHGJPL8stQ/perrd4ZgSV7qpUPWkOs
	n7sYMCLoT3H
X-Received: by 2002:a05:690e:1913:b0:650:2ff9:d67d with SMTP id 956f58d0204a3-6531087b9c5mr37346175d50.27.1777251733385;
        Sun, 26 Apr 2026 18:02:13 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65441e82f54sm7796363d50.14.2026.04.26.18.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 18:02:12 -0700 (PDT)
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
Subject: [PATCH v9.1] mm/damon: add node_eligible_mem_bp goal metric
Date: Sun, 26 Apr 2026 18:02:09 -0700
Message-ID: <20260427010209.843-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nsoh78h7x3mbnw9jeoouu5j8tqotqcq5
X-Rspamd-Queue-Id: 94AF5C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777251734-640100
X-HE-Meta: U2FsdGVkX1+SezTsQ8Q20dxt9YJFDOM2/FHtWmnmIxciNCRSGGcciGnTBhrHvx+tvGIxf/jK/x7M70RfD9T7xnj7+X8zAvXDdr6yqQMAena1TrbukMULd5yuPzc7Y48KINU6xQaAsjLM4ig5495NUNM6XPqQ9eEw+PN1wUN057Vcatg8njbnGwGsvGPRmjK0jxn0RC89MLGPKrsMOvDlzuGLAFZYNHxlsS16YZIoY4KbsKUQQsNmu8eQFjG1wFnToTF1thJeEkFQ7PVQ4mt9w/Ybn9wEg3/qVVPwxgD0XpNt0mrHQm4vBa3mbWxhHMiZZ36TPGmvINmVhtfUwFq8MlrqIfftUzyZFGXY29T1W3TvA60k2730G66u6m6lsjk2nCq/D+C3wZYS/kazh26yut6TfvCKVsyq23O8DqjoEEkyt60ryTLAH0JjYZldqKmZlYfE6WnF5rnPOIAvA3lsY2H6H/mpAeWcFM2xWbg7s4xlCwZmM6PvLy3WxmZlzoDfQf7z/jFufwQagYUCXoLMymyOMpMTeEOPBDWG050CY4GWiGo98w8BGxeUo17SYrZRcMPydc3rNl2gMvnxPs5ZqxO7jq88tVnxP3SnEsL+oXN/fFbYmHtUv9dcJ8FoPQbdlzwdiw7DzRzfUD+zPVgF4yyOPZ2xdBmbJXDuPVHyNxTyGwamgbD8Tarx3hx5A+dbSVGABH8BeQyqNK8bU8dfTAYhCySDGcmAOceqW859VZ53jqO66nULSdRObczEmjDf2TNbUzureF8pvRGW9dMSIDzNh4tR3nM32zfnEEhN585HkYXmGvCS9Mm1ns2O31TIO2P0XdZR4hpk/8aqvVcm4NQShfgg/YnmHc6Bj3JeufXfHEOLsbOXlozeuWRLE3hP+NiJZeoDmwU9P9wQT4gLA4CTGhU8e5Bxd3JtkH8wYU1DfKfu1lBKgeXmUhSdV0EgiJGsd1/FC019QjuK1QG
 0wxg9b/Y
 uXQXivvn+W2R2VXydKq9QX5KP2FhWEJngHq7siJ0ScGMZlek/PHtv/d7TclTvtuBO8c39bASlvNGuRWsfIL+MlGg2RK6KPRkl9iQC31aEqNE9v7xFyX1mrVtywjhCAVEDZhsoPBtlItki/O6HunDr7HrOjAIGTctRu9Z6PS3UNttXzqpmXjLNRZd4xpGHDegm1xbyG7teitZvzsUrcqZ03giHLvvHLVbscUSeZ/M3l08oXgvYRAH/8SCLIQ74zluxfePS9mYhCKus8ic2sninHU7A4GfJMXKXyXdJVpreGt+bsRAg6HIFup6nkURF3j6ia1dfzGVdRNfOaFrPsWiQSOKneD95d2nCR7rduiSdBe1FSeZStTNFWUPNuNsKP+QWTFJ2VW7Ootlf1mWtaK45lVPhxGlH3c9XMP6Cvywm3OCphmprfNwbmPfyeZkItC99/qtj3OFaMOFw7ZBpat5jz21QrjbzFoCZGjrv01XH0EQMmgVAJEcPVuf3OQriTMRad0XW2DaBhwN6wot6vpXr0YKc1pLYF/FRxCCCMgEKVpAT2mLcd1TfpFyb7PNghOrLRyItvc6x47Ipeh7yHoaRe4LsXsRWKBU3XJO/QUbW9xnoV7WX6S6XQcVD5OEyDcG2ArvX0EysMRxGkLWHQIDae5Id2ZXd2Wh2Ps4SIuokCzw3vVCx60FMepGXwQ==
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
 mm/damon/core.c          | 169 +++++++++++++++++++++++++++++++++++----
 mm/damon/sysfs-schemes.c |   7 ++
 3 files changed, 164 insertions(+), 15 deletions(-)

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
index 3dbbbfdeff71..22d6eb3a974d 100644
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
+static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 {
+	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
 
@@ -2402,9 +2541,9 @@ static void damos_set_effective_quota(struct damos_quota *quota,
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(ctx, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(ctx, s);
 		esz = quota->esz_bp / 10000;
 	}
 
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


