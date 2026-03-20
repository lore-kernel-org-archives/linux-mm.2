Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7B841099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D726B0146; Fri, 20 Mar 2026 15:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374326B0148; Fri, 20 Mar 2026 15:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F856B0149; Fri, 20 Mar 2026 15:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 057336B0146
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:05:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8886160354
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:05:03 +0000 (UTC)
X-FDA: 84567368886.09.A89FB77
Received: from mail-yx1-f68.google.com (mail-yx1-f68.google.com [74.125.224.68])
	by imf17.hostedemail.com (Postfix) with ESMTP id B22F64001A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:05:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MEx6W2ba;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsaG2cqBlzmGBKhCZrr0TNjZqNjOAajTDrfTI+nVTrg=;
	b=mrl7oqmU4/fRi28UJBtq7uqTGsN8fi+zRCT+z5s02xBPYNeA7ZIMdO1VleabFGK6LFKfm8
	bVeCI3YpWOoPiZUqIbEGXC4lQuaJ3vDwLQ99wsOCnEZPpqmSGE/mcdu4nCx70TWM4zKEM7
	kRuky8rjxqLk4Qv00ncFTUv997wTwtE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MEx6W2ba;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033501; a=rsa-sha256;
	cv=none;
	b=EIExrYIuqXG767m0/9hPicsilF5jzJO7JQZg6262sZaM2hruaq+4hBo11uvAnJtRKN9/PF
	VHzcsxDsUjjCo+Wpkgn77KwnTVj5pduqsBLpGkKOf9d2Eox16K7rcraqpKIAkd/IdYpz5n
	XPHDZOzORI9Mc/p0W7+QHU6CtmfBDCw=
Received: by mail-yx1-f68.google.com with SMTP id 956f58d0204a3-64ad79dfb6eso3243542d50.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774033501; x=1774638301; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FsaG2cqBlzmGBKhCZrr0TNjZqNjOAajTDrfTI+nVTrg=;
        b=MEx6W2bajCQGJtFhDLagLbT4f/7EMNg7KQSDTMNUng51yy+sum9fcAutAaNczumRlL
         u4pOqScra0kYpgZWDaahE40n5GvcK/OE9Pz+XtnnE9sBYbfdEfiPTQqZm+GxfsjZ+0Vy
         e3TK11jvwuphr/fHhOdPYc9bECvp6S+Gkknviy8BQNDyDdYm2YL2k7bp+uwoTGbfCsQe
         G0qwxeKLbkr2bmuPhODVO8LU1DsgdmNMMRzGFbnpPcNzXpNyToeYsee1DiE9vBpAdHmk
         5hszacs5MHDPWTFhnTLnxT2E3sDmOt8Eh2qUI7nr4QIsG/Dbrs1/AXEbbACKgpBrXdwy
         VcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774033501; x=1774638301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FsaG2cqBlzmGBKhCZrr0TNjZqNjOAajTDrfTI+nVTrg=;
        b=eTwh8rGL9EfYyIGo1cLGQmjHI6d5PkTmfP6BDCmjh0D4pgPfbajEiMy2O7B+1LEK4a
         9TlElPSkDAeGpu/merVTok1+cx4102k+8pgAzpjuThKfmOZaPdcEaZb0tbGnTqBKAfXE
         7Ik5CrWkGFRO2L+J+5r37H1npsHD2s9Iw9dFlfqkWu1kUwu69pUthHvDjUvI0/QlxnVF
         NMm6HkiQdgS13Cph40kspctUuLn+8ABEEmNg8uMpmwxrkhccE6ztLr44H6HwiYFksV0K
         KKWi6ccR3U4mDhG/M3S18x04BzTXq6gT8gsWjBZWOmb290Gihyw4iVpsiZS6EDNBZv2J
         qgsg==
X-Forwarded-Encrypted: i=1; AJvYcCVxb6X3vvC1ICAO+ESwwzgNkSwT8pfpLsbvBwNluzyxyfKGFVwMK30syhf5bxVcIlPxcZig9BPThA==@kvack.org
X-Gm-Message-State: AOJu0Yx1FIgd0bq3KIeklKBVrfcHDO90XwP8/3edodj0zvCUYrHWbdki
	JqtC/nwfn562nBhYc4x+DvSAFOjW/KGLsrkbsfYT1kwn56Ve3ZqdSnQ=
X-Gm-Gg: ATEYQzzDM8n0B1ewn5steWqRjM0Z6A/9iLMoH+p90UlHwGIA4AdnACEoiqLgOg+YkFq
	tI9airybvIWqAHRH1bww0QMjb1MLANG8D3HOALzrCeTz3WeZOsdnyc42EIIclMUCI8/+l1RaTE9
	I1GNra3qUGWIb7FbkfcOuwMKVs20p2q+VlCvoeC5DkNR0en/J0NOC2PHthZghra2U8QxsZ6ZK7H
	wddbY7HJUBCPnnje0xpMFgyMXQ1O2ouTQpSsrHIz/TS6TQxNjYQnb6mmwPS/FdFCo9PumSu8WRe
	hnFw0iq0SxJKu8MXkxX2S64ahMjqPyU2GbNEOpInO+Xg2mYJhTW/SVuZpK74t+zvIZsIHURVoem
	QGLDreAJChsQPgGFfw85wBH/95ZOR3TzRO2hkWnMp5r6gJIc9Ea038etnpbO5ohJBQ7iNRcb3yI
	hJsJWA0HY5AP4ReH48p2Q8lUVGKABvciEZalsVd5U+YschCKydEvTKfNLGjnzM5OIhykqjoI9wS
	w==
X-Received: by 2002:a05:690e:e83:b0:64a:d705:31d0 with SMTP id 956f58d0204a3-64eaa701833mr4984332d50.28.1774033500742;
        Fri, 20 Mar 2026 12:05:00 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64eabe7e34esm1990519d50.10.2026.03.20.12.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:05:00 -0700 (PDT)
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
Subject: [RFC PATCH v4 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Fri, 20 Mar 2026 12:04:53 -0700
Message-ID: <20260320190453.1430-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260320190453.1430-1-ravis.opensrc@gmail.com>
References: <20260320190453.1430-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B22F64001A
X-Rspamd-Server: rspam07
X-Stat-Signature: ybgc4z1fzq5kbehyen77nc8npwo98ebn
X-Rspam-User: 
X-HE-Tag: 1774033501-802101
X-HE-Meta: U2FsdGVkX1/MyW1QF9ykrwH9XJV0l+uVLKxwAso1ABVdq3pUN6znE3ziDfoNLw+x2tm/kIG4yRXjGpYxkU2OzhnhKGGax6rMOgZpuDRhftujJxpTHBlZJyVE6tkz+9BH0pOy9Bj2tnNb2UAayrpGlnYxnMwsdEerjY7EaIc8ET30YJ89Vb4mK4ZaF3vOLZ5+3JKd4st6dXglvXrxuGcTeotkK+xd0FkpJF5CAayUN41qORqTvCJ/CkcpEEr6aKW0plO22HLHF98Im1773LxzDf95t7+0612Wk0MhDUFe1NaoG62wguO3ZlbNIEZJ6qlOt1t7UaQ4MnP8GlpOzWLcUd6bu9AQnskkjA44nUv/mEjjX+quopU4UD6721R0CK4DftnXq7OfhiFpVbm6HMmQx0ZzCJmtSGek8uD5T91aTcJ1LDr9pTJLrrFjrUWWjiBo5cUX4cobx+ZBgy3xqN5PRs82H5O3BWnsoYGC/jElhQU0kQQU5b0EF6Vb5dYIFT/QIEj/TFb0Ol2evCsPBOZT8tN+metxFiHAayqItAKHiRKf1nikWwmXKEJV75lu0e+TCeNgDuL13+c/Ffh5LYvFFWtm62vXNpYczCLlI2PtSNG0F+ZSpVCRdYANq7/AnT97F6MatM9kTddrpKTnJRD0Pk9KfnjqG8C4yxdKS/KNnHHU2mtGd21Uj11O5RrXu4Wx7HPraZEOMQZFxioxtC39pHtWeEq+bN8aM9WT+i7kVeGaYKA2ofctsChZgvzP4N0ORgg8TjmlCk24KfLr+tAwspygjjnRwWdZ14VsTYiVot76sMqyTMH0VKN7y9QNClnkugaMpzt1FPGeozizfbWVqP3leuwBpaIJfIfRLVP8AOSFV5I5fBWrVwIhBuj1wka5QqywVEev+FYV+4ny4PoZPS47XMCozA8t82/oi1vTSz2DW6MzUF3ILv/CCtXDXhkA3X3vacDPXtzQBdI5Omw
 wflwQJno
 mMUyAM5xCoP+u6EqIocWA80UR/lPFxB+42BpYvdYy+YbhirAybRQmduUNe4DPqrmcAEVtykyniH/1Mr5U9vBwW7MKvTLuomGpq89e754fqvLfITcsojH4IFxA8/JxG6O3CVi05DzQGzwRnrEfUf6LS1EvxXCsZbsjm6qBcjAVYzpPOSveLOu5u9L5iDxHq0sZbo7eht8DgVKPJ9fnAng7rDzbJAY6mq31GVWWqInWc411Es9oD88kohBwsTpHOJVOlkDLAgJiKKWuATRztmx5+VT2f4VkfMyCsuzjItFkGY2y3ccRGZAfwilbOmEb40xAl4+W279bIRddUCXiOl9rapMRrT/PlHanSiw+xIagVxbsBcfqdRozSq1ENrof986QDufr2VciML4Na6pup/ONV9qzvKgP5OZWY15wXV4NBmPfHwHwv6Ai0kHy5syAkQlAPt6J8+vIl3vnRAHuMHq4EDlThd0N75Zd8a3Kkh0QWBvE5ZZRXpMPlQK91IqM43m/UoD/8TkvOn4MrTpQFpS7Gn2Q35oEuBztIr7/TMIkhKOkNA/Q+oXto9pjoUz4ZSDBHToKmXOAos+2X4BwVQsOYOJ50d9wiAcP+ftt3pvX8CcqAlkaXaW39yXcOPZPAmaYE27tPc32u9yyxLusEWE8ogwGy8BR+9BEVD9Ay3D8PB6sxbAApNRTrO4MROK51lVuSVfc0OA0GQmIUyJHdjKLtZ3tpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new quota goal metrics for memory tiering that track scheme-eligible
memory distribution across NUMA nodes:

- DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of eligible memory on a node
- DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of eligible memory NOT on
  a node

These complementary metrics enable push-pull migration schemes that
maintain a target memory distribution across different NUMA nodes
representing different memory tiers, based on access patterns defined
by each scheme.

The metrics iterate scheme-eligible regions and use damon_get_folio()
to determine NUMA node placement of each folio, calculating the ratio
of eligible memory on the specified node versus total eligible memory.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h    |   6 ++
 mm/damon/core.c          | 158 ++++++++++++++++++++++++++++++++++++---
 mm/damon/sysfs-schemes.c |  12 +++
 3 files changed, 164 insertions(+), 12 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b1d8fd88a0fc..490918804f85 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -193,6 +193,10 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
  * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
  * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
+ * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
+ *					node.
+ * @DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:	Scheme-ineligible memory ratio of a
+ *					node.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -206,6 +210,8 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
+	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+	DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index b9e12865622c..3e0ac65e34a0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -17,6 +17,8 @@
 #include <linux/string.h>
 #include <linux/string_choices.h>
 
+#include "ops-common.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
@@ -2552,6 +2554,112 @@ static unsigned long damos_get_node_memcg_used_bp(
 		numerator = i.totalram - used_pages;
 	return mult_frac(numerator, 10000, i.totalram);
 }
+
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
+ */
+static unsigned long damos_calc_eligible_bytes(struct damon_ctx *c,
+		struct damos *s, int nid, unsigned long *total)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long total_eligible = 0;
+	unsigned long node_eligible = 0;
+
+	damon_for_each_target(t, c) {
+		damon_for_each_region(r, t) {
+			phys_addr_t addr, end_addr;
+
+			if (!__damos_valid_target(r, s))
+				continue;
+
+			/* Convert from core address units to physical bytes */
+			addr = r->ar.start * c->addr_unit;
+			end_addr = r->ar.end * c->addr_unit;
+			while (addr < end_addr) {
+				struct folio *folio;
+				unsigned long folio_sz, counted;
+
+				folio = damon_get_folio(PHYS_PFN(addr));
+				if (!folio) {
+					addr += PAGE_SIZE;
+					continue;
+				}
+
+				folio_sz = folio_size(folio);
+				/*
+				 * Clip to region boundaries to avoid counting
+				 * bytes outside the region when folio spans
+				 * region boundaries.
+				 */
+				counted = min(folio_sz, (unsigned long)(end_addr - addr));
+				total_eligible += counted;
+				if (folio_nid(folio) == nid)
+					node_eligible += counted;
+
+				addr += folio_sz;
+				folio_put(folio);
+			}
+		}
+	}
+
+	*total = total_eligible;
+	return node_eligible;
+}
+
+/*
+ * damos_get_node_eligible_mem_bp() - Get eligible memory ratio for a node.
+ * @c:		The DAMON context.
+ * @s:		The scheme.
+ * @nid:	The target NUMA node id.
+ *
+ * Calculates scheme-eligible bytes on the specified node and returns the
+ * ratio in basis points (0-10000) relative to total eligible bytes across
+ * all nodes.
+ */
+static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
+		struct damos *s, int nid)
+{
+	unsigned long total_eligible = 0;
+	unsigned long node_eligible = 0;
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
+
+static unsigned long damos_get_node_ineligible_mem_bp(struct damon_ctx *c,
+		struct damos *s, int nid)
+{
+	unsigned long total_eligible = 0;
+	unsigned long node_eligible;
+
+	if (nid < 0 || nid >= MAX_NUMNODES || !node_online(nid))
+		return 0;
+
+	node_eligible = damos_calc_eligible_bytes(c, s, nid, &total_eligible);
+
+	/* No eligible memory anywhere - ratio is undefined, return 0 */
+	if (!total_eligible)
+		return 0;
+
+	/* Compute ineligible ratio directly: 10000 - eligible_bp */
+	return 10000 - mult_frac(node_eligible, 10000, total_eligible);
+}
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
 		struct damos_quota_goal *goal)
@@ -2564,6 +2672,18 @@ static unsigned long damos_get_node_memcg_used_bp(
 {
 	return 0;
 }
+
+static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
+		struct damos *s, int nid)
+{
+	return 0;
+}
+
+static unsigned long damos_get_node_ineligible_mem_bp(struct damon_ctx *c,
+		struct damos *s, int nid)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -2584,7 +2704,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(struct damon_ctx *c,
+		struct damos *s, struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
 
@@ -2611,19 +2732,28 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		goal->current_value = damos_get_in_active_mem_bp(
 				goal->metric == DAMOS_QUOTA_ACTIVE_MEM_BP);
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
+				goal->nid);
+		break;
+	case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
+		goal->current_value = damos_get_node_ineligible_mem_bp(c, s,
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
+	struct damos_quota *quota = &s->quota;
 	struct damos_quota_goal *goal;
 	unsigned long highest_score = 0;
 
 	damos_for_each_quota_goal(goal, quota) {
-		damos_set_quota_goal_current_value(goal);
+		damos_set_quota_goal_current_value(c, s, goal);
 		highest_score = max(highest_score,
 				mult_frac(goal->current_value, 10000,
 					goal->target_value));
@@ -2632,17 +2762,20 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
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
@@ -2655,8 +2788,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damon_ctx *c, struct damos *s)
 {
+	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
 
@@ -2667,9 +2801,9 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(c, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(c, s);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -2718,7 +2852,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s);
 		if (trace_damos_esz_enabled())
 			damos_trace_esz(c, s, quota);
 	}
@@ -2739,7 +2873,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index bf923709ab91..7e9cd19d5bff 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1084,6 +1084,14 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs_qgoal_metric_names[] = {
 		.metric = DAMOS_QUOTA_INACTIVE_MEM_BP,
 		.name = "inactive_mem_bp",
 	},
+	{
+		.metric = DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+		.name = "node_eligible_mem_bp",
+	},
+	{
+		.metric = DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
+		.name = "node_ineligible_mem_bp",
+	},
 };
 
 static ssize_t target_metric_show(struct kobject *kobj,
@@ -2717,6 +2725,10 @@ static int damos_sysfs_add_quota_score(
 		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 			goal->nid = sysfs_goal->nid;
 			break;
+		case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
+			goal->nid = sysfs_goal->nid;
+			break;
 		case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
 		case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 			err = damon_sysfs_memcg_path_to_id(
-- 
2.43.0


