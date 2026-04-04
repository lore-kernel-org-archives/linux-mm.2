Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B8BE88D73
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 01:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD9C6B0089; Fri,  3 Apr 2026 21:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DDD6B008A; Fri,  3 Apr 2026 21:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8939E6B008C; Fri,  3 Apr 2026 21:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 764AA6B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:22:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1451D1B7E15
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:22:30 +0000 (UTC)
X-FDA: 84619123260.22.B658954
Received: from mail-oa1-f67.google.com (mail-oa1-f67.google.com [209.85.160.67])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3481D80008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:22:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CL2SyEJJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.160.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775265748; a=rsa-sha256;
	cv=none;
	b=IZQL5YjJZOl68g6xkJZynzTdwzVQlDUFmu7nkkfnGBAYtWvwaXiB1ePnaYa7/dMfLgXLvu
	WThMSCSVy3QHjuW0OWHh62FmaynMONSabx4qOKwSfJyApUCtNqAF4VoUhfGuIUKBQtNGFH
	DcHuyCgyni2G6Fegb7xqa283+H/yZqc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CL2SyEJJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.160.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775265748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQnrzxZZC9imzBgdexmxyRP9cTwF/HChSkxF/hZUuZQ=;
	b=I0X+8aspfzfxEcMHIe5m1uJctIzNNJPuSXjxtomJLgDUtACCygb4IFb5mQQqinzi5CuYRW
	sPb60vjBh4hTtuu+Ty0Kh7qgraHy9LkeDC3N6LtIMgNQgn/kvp1HRAHoNrvNxNIQZULoDe
	vYPBcW86CTqBenZ7nu2trEE3B62CfxQ=
Received: by mail-oa1-f67.google.com with SMTP id 586e51a60fabf-4152698e745so979364fac.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 18:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775265747; x=1775870547; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQnrzxZZC9imzBgdexmxyRP9cTwF/HChSkxF/hZUuZQ=;
        b=CL2SyEJJQPxmkjOAIC1XQGZK4aERYzLJMrwZc4IEGBXPbYqbs1Pql46hPyp+QTQDqU
         dHso/SY+nsa2W9dLC28nyCEaSvLoQ3PvBz2uqCE7fTK0ufLbGtYkjxur8DB4PCbB+7fQ
         M985uinzTygg76I5DdKiRYhIbzz2n0xmLkwdNV3Y4+tC8/NY8Bw/4o+jGybJw+LnPQcJ
         OoqHt1JS3bIZiWZ7Iu62WeEHyTxgzVQI0TEzpCSHIILS2f/XoZYsiyIcRyo1TfDG6Vbt
         66IRlIKaOI2vEOjENbSV+T33TRE5a9ilnRUzMMOy8lL7eMfTtPmKkHizTbR6OhzNrtTW
         thZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775265747; x=1775870547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xQnrzxZZC9imzBgdexmxyRP9cTwF/HChSkxF/hZUuZQ=;
        b=LpXddmQAlny/QtXaN2/6vOqp6CGL0RA8AWBbW37vAwQq0vlrcfLSHE4Md2KBX/tyyA
         ClMfoXm59FAS1yLMa0Z8Zcj1KUK4IioyEbcu/jNUZMFAltowMVZfjSNHu8pGaw1rl3p6
         DrwsSwfz+NtxBi1PL+4YcRUef5VO17SAVVv9bzKY9jrXCQ4HMMSQZoKzghTZdVnlKVTK
         cnMM1+Esxfsnb5DwoFYQZj6d1Z3531FSdu+RX/8GZlX/MqxCHdPAZMHTg5wncQ8p/F1a
         CUcrTQF4ari2D2Jr8PfvZF21nV0nZIr5roUWI5eSy+LYGNFVB0WeLRyBjL50Fu2Yasej
         4Gdg==
X-Forwarded-Encrypted: i=1; AJvYcCV8nq+0yHwwGQ+62MGz0JDkjPA3SrlcfJwDCAve4pOW+CpOAcPhhRurSx1J9ao21i6L874i30te8g==@kvack.org
X-Gm-Message-State: AOJu0Yxe5Pyta4mtg1UUEOG8lGN6GaRTuRZvxf/tHhN4WuUwAWBEM51X
	WYsvrjFydJkjjU3mAg3ZOkFWq0A6bkGMOFpyEl6pq/rm6Kf1pozAYAs=
X-Gm-Gg: ATEYQzxXVyaLDtKECevu2395qTeUv4orVpjSEOJ23DiOLnVDEqAnW9pA+Xyupq1shob
	xoRMyeTPEA63hLCVOi6cbGWKZz5zWNF9IN6wJUaYGkVfVnSP43utHjitatnuuVjmcAQ5dCVOuMH
	dkK+V+yGx5Ksl9UDtCPFXE6bT974XHGCsVruZRgN0W4udlIWSaUOSyD3xAiCeivEA9/DREwt4wL
	hhkHEo/29lG4IZXt+ByHRuyU4NQTSyfVahb7pcxX75Fr65tFIhW0+6Xqboclfa4JQhxlE2X2d0r
	Xv9ijfD3ouaBTwRFDVk2ECgiJi9lbfxx0bt3IhoUm8wMkTqrmIi0Dp4c6KvRdmgdgbTW06Y+l8+
	Bni5d5gCZf6iko4WJKsfqtHxqp7A9L8Eyk9nbJh31lDPoBeA84q5x5tK+JpTqEtqXkg4iP2tknJ
	v9zVMTuGc1g5pMj8OJ4stKPg==
X-Received: by 2002:a05:6870:70a8:b0:41c:20cd:c0b5 with SMTP id 586e51a60fabf-4230fbe8016mr2558822fac.6.1775265747042;
        Fri, 03 Apr 2026 18:22:27 -0700 (PDT)
Received: from localhost ([108.147.99.33])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4230fb42ec7sm3290263fac.0.2026.04.03.18.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 18:22:26 -0700 (PDT)
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
	ravis.opensrc@gmail.com,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v5 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Fri,  3 Apr 2026 18:22:15 -0700
Message-ID: <20260404012215.1539-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260404012215.1539-1-ravis.opensrc@gmail.com>
References: <20260404012215.1539-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3481D80008
X-Stat-Signature: 7a8em69x1aiortatkhrnpfx3io8mtmxx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775265747-177840
X-HE-Meta: U2FsdGVkX1/WxAEuWIiOsozvEfew7aDsPseHEEyHbAdKxXsif0HSfi3IJbscBs0tHBfAmQC4Pj5BQ2vGsQWOCNCP75y9UzF3ENX32tVOlqGkP9B4HAB2t0BTPRHztN+dPMAvjgJG2tnrQcQMP2xgsWkdZ0HhLx2Ccnvw0mLKNuRXSdFFr4Rx2DZynNne1c7Og36xYu3mXE3nkLL4ibTm2oJz4FocjCX+/rUREqI85cJcuHBH4q3BhJ0bfzzD6n5kmc4jn9Jt5HGhZWg+3RJcPLcABbnHBjlXZv+gdJgmze+wjscJb5MFQQ81WuH+ROzGYbDRDV6oVmxoinumN8hX9mVTZHzDamcmCjp5TjhlorYeEY9KtQrBIrh41uIFJBsJtK9aqFAXCDn33XbqEhaXXNv51BJ+K9i7loCuYJgqFHYdXw/i+Cq11P2MPYJmeAhCH0xtm3sEwlZQYJuB2ED1vO1jNZoMFw0PemOp7xRfF9LNxwUYK2vmDnshS3xY13Jhi8fomWVvftE2Xg+Froa1joiYFeVPYoN5VoUlO9+jQUSbJGGNxnOD+Ec1GqtM9XOlBruM2NIJ2szd9dDuWb2hHM2XoJhDUzVmWgwOElY6vW+Sxzwq0tFgb8YAE1fGBf3G46mOMAjINe2p+OkTJ51oGCNN8vVBPRUmCh01IZzu7pJ5rNI5XK9kWQAyaTfh/UpaF9lGeB5ERxVv0DxJospIA1dmhI6SagG2yMCqXbFmhd8sLmaMKfeTCwEyqIWVkjnCoZCLRWDyaN7mZJYD63g0DeNfdgko+2mBiAnfNZLvsAaesEMjyLI6NqFJebYYM6bhldUey7BeOeaAnMHTkqmHxGfchaJTWqAyU/qyyLhFOtBdzF7JDSrcXbU9r98GSQF2JWOTX1NdgsnA1mvEm+J8fXthyEPG7sjHbVX00LEVorUEvB4YROAjdj2Cb8xKCdc7Hg3MHwJJg4J4Yh+9kDo
 KrXBkUPh
 8k4rHd0Z+HPu1V9lFOGDkgTTwYP50H0tfTU8i7uSG1vLsA1gh+H43D8An1T9sBYrvvKA1cg3xJ5ub9Ub8qg6HM/jss7jYxwe+4VXrG/G7YrZmSYYwSeSCHzoSyvI0EY15l1VPOeQhYjiTDjcxpvOaOxtWa7ydd3g2B9xKCPChg3sel+M9epCZO16OgyMp/5w8b6hrks+Q+BcTkjgiVJZxdcBXYJYTgseWtG9OgULsFPhielxoWSNF9lcCVag9ERZ1Gz/OLYZtqrm5ruXvwQcmMYRjW0/bPsF20sTcQH+OVR5n7Qf3u3EcqyyVn+i1t/VyJLgEp1Fl+A4ojKKXui4Qzji+5z0s7aZCjIgSxWeQDAUBA9425Lij8XHcamLpZAUws8TvvrRBFzPNYnJcJqRkwGX2QSyRe1iy5wyv5Lgj42FXBrk9AUnUf4yjEwKc2tz88h1/zNM598PnbUmWcHCLM1j16MwL3IovuVsOO4dbDInm3OmriMnHETqx+xrFQfb5xE3QfOwkdrPEAHamxAEMZmqwYYtBfRMolkfQ0aQx0V38yR0BweNhwRIDswD8Brs/Zul/aqGMdCr+40g8sPpJcS/539tU2aFaM3YXFXz8eJisbgCjgEv9iD2ZCt5s+ZMOqt0E3TLU/kOMkhC3fsQf/wYyEDkzOwYD71OPceQYrRzKgywCIZg8RpXI+H2F5MDL1LHSURVCpL8tIW3IjBcvVtfzr2Das7PH/NyeQVbhcrLgQId1LQqSQdcCYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new quota goal metrics for memory tiering that track scheme-eligible
memory distribution across NUMA nodes:

- DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of eligible memory on a node
- DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of ineligible memory on a
  node

These complementary metrics enable push-pull migration schemes that
maintain a target memory distribution across different NUMA nodes
representing different memory tiers, based on access patterns defined
by each scheme.

The metrics iterate scheme-eligible regions and use damon_get_folio()
to determine NUMA node placement of each folio, calculating the ratio
of eligible memory on the specified node versus total eligible memory.

The implementation is guarded by CONFIG_DAMON_PADDR since damon_get_folio()
is only available when physical address space monitoring is enabled.

Suggested-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603251034.978zcsQ2-lkp@intel.com/
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h    |   6 ++
 mm/damon/core.c          | 186 ++++++++++++++++++++++++++++++++++++---
 mm/damon/sysfs-schemes.c |  12 +++
 3 files changed, 190 insertions(+), 14 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c15a7d2a05c6..98dbf6911dad 100644
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
index 5908537f45f1..f71ee19f526d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -17,6 +17,9 @@
 #include <linux/string.h>
 #include <linux/string_choices.h>
 
+/* for damon_get_folio() used by node eligible memory metrics */
+#include "ops-common.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
@@ -2549,7 +2552,136 @@ static unsigned long damos_get_node_memcg_used_bp(
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
+ * only available when CONFIG_DAMON_PADDR or CONFIG_DAMON_VADDR is enabled.
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
+#else /* CONFIG_DAMON_PADDR */
+/*
+ * Stub functions when CONFIG_DAMON_PADDR is disabled.
+ * The node_eligible/ineligible metrics require physical address operations
+ * to iterate folios, which are only available with PA-mode DAMON.
+ */
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
+#endif /* CONFIG_DAMON_PADDR */
+
+#else /* CONFIG_NUMA */
 static __kernel_ulong_t damos_get_node_mem_bp(
 		struct damos_quota_goal *goal)
 {
@@ -2561,7 +2693,19 @@ static unsigned long damos_get_node_memcg_used_bp(
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
+
+static unsigned long damos_get_node_ineligible_mem_bp(struct damon_ctx *c,
+		struct damos *s, int nid)
+{
+	return 0;
+}
+#endif /* CONFIG_NUMA */
 
 /*
  * Returns LRU-active or inactive memory to total LRU memory size ratio.
@@ -2581,7 +2725,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(struct damon_ctx *c,
+		struct damos *s, struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
 
@@ -2608,19 +2753,28 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
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
@@ -2629,17 +2783,20 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
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
@@ -2652,8 +2809,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damon_ctx *c, struct damos *s)
 {
+	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
 
@@ -2664,9 +2822,9 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(c, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(c, s);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -2715,7 +2873,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s);
 		if (trace_damos_esz_enabled())
 			damos_trace_esz(c, s, quota);
 	}
@@ -2737,7 +2895,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
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


