Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13147E9D80D
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 18:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547136B0089; Sun,  5 Apr 2026 14:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7C36B008A; Sun,  5 Apr 2026 14:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7246B008C; Sun,  5 Apr 2026 14:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 287CD6B0089
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 14:43:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B600DC3375
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 18:43:00 +0000 (UTC)
X-FDA: 84625374120.22.41FE959
Received: from mail-yx1-f68.google.com (mail-yx1-f68.google.com [74.125.224.68])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD4B1A000E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 18:42:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oSP5v7vM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775414578; a=rsa-sha256;
	cv=none;
	b=oBP+1xEOKvg2SRVO1EP8lG9cYUHPbXDR8ZUwmqusLoDiJLT7a0LMuDhuO4xWxwKsnJQ8If
	q851uCYPoHBNrOdDkE2yffpBSrQtRef1eOUCJwzIb7xFht41bJA3gbI9JFEAWQZZur17U5
	E2NjtN2qf84p9VBNFRdPlOzAzoaK3O8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oSP5v7vM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775414578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEKRNySrl5bfNR25LuvdIM9mAYLQZGQHO8FJc6GF6Vs=;
	b=JMOc3YRw8YcTk5YJRaXBe7+K8HUOUvFaun3auWyRGSsRQjpZEV7wSvqmYulwVEh8WZrNyA
	4hznmgpip5iReTGbrM60o3CMCYxVS56FTJ1F/JM54hpOZgoax65aBqw9KqIrA3fngLZSYO
	KdN00VJfy9UY/IEwz/0ltpzCvx7pr6Y=
Received: by mail-yx1-f68.google.com with SMTP id 956f58d0204a3-6501547d7edso3249529d50.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 11:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775414578; x=1776019378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEKRNySrl5bfNR25LuvdIM9mAYLQZGQHO8FJc6GF6Vs=;
        b=oSP5v7vMoSM5oEEtrQ+HR80sWB7HONVOkpudvcrM3zQO865MPFDGcqdu+6FKzhdvg9
         VbaeqSVVURetCZSlew1nqWB/tGwIDo18ErImxDna+Ne8dOMtltzOnLvUKP0XNqYxsO+F
         YBGdOA4l+WyP/6EH8TSPXlSqaYL54Sl2O6layXiCSCpF/gyHMDpX3DX1UgVDFaJl/Xch
         73lq+hNIoYgLAPaQNHQ/vgMISh9u1SY1qe5g0OltLh9WGnDYo2Lu+/4JaMVBsOljCToz
         38qZovdGppCrMSNEpocGby3r2+nSnBVGYbCLuWkerTDktOLKKLGyfQVgUoygUmUlR6ta
         5EPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775414578; x=1776019378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UEKRNySrl5bfNR25LuvdIM9mAYLQZGQHO8FJc6GF6Vs=;
        b=b+1xxy8n6jBR8sS6mVWA09BiV0XvSpwO49aHZpeWX/++61HQKnGvlOzSCX+Q016bB9
         cV8MXPPSroGWWTrCrVIsQlkaYRPnlXWP+Rx6itBcdpvTZTPNCtsznO/Dd9GVaDcYT8qC
         Nd2fM2agI1902rm++mNSna8EQEECB8tpkIGRYl5kQKTuASX2TzFt3DSen5OxQeuD22K8
         lnNuUDJyXSAFZ0u6IkT4/oJNb3Y7KijCKPi7pQqsLgsA0OeTamZSxtNL1wsTW35PaIiX
         PnZMeR/WAiWk9zue0lDB7g8hqSsa7XbuMcX/xuvlwpBdzO5yu6ShCyuV69XeRbBt5q4z
         8/IA==
X-Forwarded-Encrypted: i=1; AJvYcCXibPwvCCDEuvwjQZP471G09GV+jy0fOoqLbf9tZP5mpU4v/W8sObC+empq6h23MP+rDZCh+O29gw==@kvack.org
X-Gm-Message-State: AOJu0Yyiki/qXmu3v8dXRzJcXmUfQf4PJUzpLoSsNeh7bXga9uMqNSkT
	Eh5jS91jwbkjaCv5rD77i8LQS6NdtEVcQAdMzqElxB3a0wAzc2ltsxQ=
X-Gm-Gg: AeBDieva+F6iZfBbmipfq+MBbTOQ2Qp5rQ6m5FnPT7R2syQ+4DKGpHsmS/R/83H47id
	qimYFW7/7aHVHa/uS5K80vkhHvT91XtgXzv5ED3Cj4Uukyf22KtmpqNoDVpdj0WsL18nSvFIEU8
	CbHGfpwF1TpWaY/SVvy0B+AoQR1RlpPFHyHPvpMqRT8aDkbFC4yDGlJRGz6vNib85C+Djncsvwp
	7n+RENLsvvjK2P7LeTdBP6KUlOjnLfif5uuOmC6UzZdV2A0SwDOhI61nx5tePV/jvCCxIx0EFde
	dcFb4dty0+A4HQezpyptor2vb9GOPPlnM6fQLWHwwDNFLRyP0LOTZtOj9eR7tQbGVqCzPRJ/962
	mrfkjum2DEKnY2yanheLvx8UVv56pKOcyDWFMGBwa2p60Er0CyeOHUKjDVFiYH1w0rkQQ2b9EyI
	nzKj+SuZlWBQk+VI0jyPs1oQU9rXp+qphxlEprSnVT5m9UrCn2VMgf0F1TbUddNS4N4VcKPubhw
	Q==
X-Received: by 2002:a05:690e:440d:b0:649:bbf4:121b with SMTP id 956f58d0204a3-650486bf82emr7496002d50.2.1775414577596;
        Sun, 05 Apr 2026 11:42:57 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6503a9d8c2fsm4963299d50.20.2026.04.05.11.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 11:42:57 -0700 (PDT)
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
Subject: [PATCH v6 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Sun,  5 Apr 2026 11:42:47 -0700
Message-ID: <20260405184247.2690-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260405184247.2690-1-ravis.opensrc@gmail.com>
References: <20260405184247.2690-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CD4B1A000E
X-Stat-Signature: mc4ikd7qub97itj7hq6e41uqs6sexn4x
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775414578-529316
X-HE-Meta: U2FsdGVkX1/XWvJTBB4tc/UViraLC3fIwmQGXuvGPFf9TuLwl3Tb4666NwlLIMPRqRZeYO5E7x7iN1VzWL4vQDKpYHS3L0P7kVqOhk7BZOTKczlq63YumXdyZrbnUP1mGqXXWZ0o6hNmIvBZwTsOtdmDUqJmujSuAXK+VQmMs5x5xdvjaSrY0B6YGl13MaUSCeM+tr5Sz+/UB0KhTeuK7fJ1yZL9mpRFDWkylmv47kFz6HHthiCGDDraa8YDjrYskndCoXvw+LsVwO0WzoLLzjMaVaNyZ6qD5Ihh3R+7uIY2PBh1IhhlTY+OEFLuHXITLqAOweE4axWIixGgkjAUSUjiaqOcHlw05LpGSZSr0OMC2EbLDvSF18yGmdL+VWBFMDCwU70nC9yiRSvrQ5cujxyD8sIgRkEmAOqusJgWNurFDhH1KKlJ31R/bK4pRcSsOw1OiG4ZCpfxvJXT0PPWYQTmDorZbtnTYeWEwy9GXbqfB29a+woWOiljsNp5tpPGU7H53C2SWOZm6vF7z6+H7lFQIPf/B4X4P4W8w1+gomivjctJxEIyyet7usgFZmIJabOSTZCgcRubATNNCgBr0s90BhOO+qPykotiqy2wuMxmjYLhZI0a0hKBLvhgJkSq6QX3422qhAaK9Jx0iN1YX64ZxX77Rj54dPhrpRwMeR41e+/hItfQJ1vBBRCKxpI+dztkbqgMoFx1a5arqb+xUYvnjNdOPixWdddekInEAD6sziNi+fsBkYgPWAor7029/8RYAq5bbqbYL2ODnzAHo9wubASoE9gE+wRXrE7X8ytdTacMp75v6fDBXYc0baPL6l52TUQkbF/Tbe2YnLdmgmvI4zVxWA4y6rt8gA9E/jBKw7R+oGgaOJz/v+lJKEM2mWvo5K+um6MghXhrK9+HDCEA4QpUpcLi37BwMxFWqO0VuLPSTIcvBX1V5PDXCsMaAqbGYX/G2HQ0fohI/wp
 WuTP7FUO
 jRpkdmVwlYhqEAWRRJeoamNkM+ihoTTL/bgoh9H+wh8vvvMB6eZcxWPdOMt7AZmn33Nl9ltbHDzDPzgGYVjnQbDL2SqRoEzwdVd5S348qyOGvdUvq/TY4AiKwKyttS391GWviGCq38PRTWGRxCKq8c533x59YMniZPGhw/TGzif6aMx9C8ZBKV3ilV4GJoiP+wdQmbb8tXr5q1b/mxiVhD1eNx4s8vxg8LGyzbCTsyo35TjaLk/ze1miTKzD2aJl4EyKg7kh2BjjVs5I8Em5nzGskkY7vxtAosexR1UNTsnAKAMGZc1Dx/2qNyG0i7wgpg8kfMUVtd7LSilixyCFga1xElK+UeLSGb39U0ztZlpP/NcC18xkSXUyFi7VIHqvwHqhfR38vOrUdpfHvmk51KlRRG79CBxJDh3H9/e9T4NJGYemIA8W3nwlPcwoNtVcmPZVGFr3+etrPUQpM6WJaiHl8S//+QcmJ+98QmK5x5ZvLbXvAzEkCAjeifmLIAdeasd+4ko5GJdZmaT3yervIMz0vGRSQHiPzvabZCXPKX+rGxU2Yl0/bvMbOv8WlyKmAR5smK02orTgrhcMk60FrKd4dUQXn+bPThUwyK8wEMfJ1v3yNVLEKU+shvj3uv+XOJFumrqcwgbn2HFAdQ0hF8mXWg6atviVRx00OAP5JWbp50joTnUkvIK6AzO7NTAU3Hg49SecGOdcTYIG+E35uj5dHuQ==
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
Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h    |   6 ++
 mm/damon/core.c          | 188 ++++++++++++++++++++++++++++++++++++---
 mm/damon/sysfs-schemes.c |  12 +++
 3 files changed, 192 insertions(+), 14 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2cdb7c3f5e6..a268f44beabf 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -159,6 +159,10 @@ enum damos_action {
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
@@ -172,6 +176,8 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	DAMOS_QUOTA_ACTIVE_MEM_BP,
 	DAMOS_QUOTA_INACTIVE_MEM_BP,
+	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
+	DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3bc7a2bbfe7d..bac810f740c3 100644
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
 
@@ -2282,7 +2285,136 @@ static unsigned long damos_get_node_memcg_used_bp(
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
@@ -2294,7 +2426,19 @@ static unsigned long damos_get_node_memcg_used_bp(
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
@@ -2314,7 +2458,8 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 	return mult_frac(inactive, 10000, total);
 }
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(struct damon_ctx *c,
+		struct damos *s, struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
 
@@ -2340,19 +2485,28 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
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
@@ -2361,17 +2515,20 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
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
@@ -2384,8 +2541,9 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damon_ctx *c, struct damos *s)
 {
+	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
 
@@ -2396,9 +2554,9 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(c, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(c, s);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -2445,7 +2603,9 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s);
+		if (trace_damos_esz_enabled())
+			damos_trace_esz(c, s, quota);
 	}
 
 	/* New charge window starts */
@@ -2460,7 +2620,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5186966dafb3..aade681b4868 100644
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
@@ -2655,6 +2663,10 @@ static int damos_sysfs_add_quota_score(
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


