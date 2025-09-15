Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7653DCAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B578E000F; Mon, 15 Sep 2025 15:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22A58E0001; Mon, 15 Sep 2025 15:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11E38E000F; Mon, 15 Sep 2025 15:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B24318E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AD331DF909
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:22 +0000 (UTC)
X-FDA: 83892531324.18.1FDDEDF
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4902640007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j5T8R0rH;
	spf=pass (imf01.hostedemail.com: domain of 3c27IaAQKCL4jzhpksskpi.gsqpmry1-qqozego.svk@flex--fvdl.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3c27IaAQKCL4jzhpksskpi.gsqpmry1-qqozego.svk@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MEHSxUH62Eh+PKLeZWp21wGeWPgaNRIAu0LrXAExrg=;
	b=Nv1Y2eplfEcbKLw1aYFhU562XDoGhhWkqq1X3iJ8gwJl9sVC7s8Nn7Mb7eioXH9jLE6JTQ
	FSK+7RDuCYzjoRJGsHgLCt7lDPqwlpXg6dkAq4prEJARm1+Q2ZVYIBju9NiFEiYEPlD7X3
	B30N2977cURkwwHNi/X8NRLliNxIUdU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j5T8R0rH;
	spf=pass (imf01.hostedemail.com: domain of 3c27IaAQKCL4jzhpksskpi.gsqpmry1-qqozego.svk@flex--fvdl.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3c27IaAQKCL4jzhpksskpi.gsqpmry1-qqozego.svk@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965940; a=rsa-sha256;
	cv=none;
	b=H6neGq+PgFzoyI/V2DRkeW2+cWtsaH42gALWYGtmQ265QrzlXNI42OmZqLug5rsy8o/tfE
	ZFtQeVQINSKgXtP/ycCQ7viRnW728SHEDWpj9vF+NSDcIbD57iA/LgHQUzRco4nlDRmYRR
	ekmwJ+/ds/DtkTvC0yb+MtKk00+ZoGE=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54d1ae6fb3so851312a12.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965939; x=1758570739; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9MEHSxUH62Eh+PKLeZWp21wGeWPgaNRIAu0LrXAExrg=;
        b=j5T8R0rH++EUf7CeZA0f87zYb/rxBBE6RwD8KY2cpca35SMWFx8JTs6OzDzFBF0kSC
         8LCuDD6rSxQNoOhsnopTMY/1wW0JD4VZ2JSg2LDMdGoE94w8nNXO9G9oi/hfdw7ReYnr
         07I58zH7EyEF6LmqjjqD4dx8Vus0mVuDOGJQnUOBNXKEfGgShGsB3g1IGPZLF3Zv7/qV
         5mP3IcXYkIjSUAkXQC3pxlsiAntvaeKSXzlkzj1GEeU8N1/nI4E2N3ogoOtbvHZUPvN7
         7DIQg9xU2r6O2mGZkI/hLSGalwT0xZQ7mCVnG5kMLT8fpjly/IWRB3lwQSPvYIhF+iSi
         9yRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965939; x=1758570739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9MEHSxUH62Eh+PKLeZWp21wGeWPgaNRIAu0LrXAExrg=;
        b=dmMCJNneNejJlrMZ07baCo/OUWFmU1YXQ/SN1zEW5clTzY7fAdvShPW2od5hWouxAX
         V8bDCljq2uH+HfoIDMjCKprJx07FzaeVjvsnqogK0RT6zsA/fxWCBBiX/44a0oiOe0OG
         7jbRvYkWw4xky+WXSnt3K9tDWhDNpztXfJRs/jUizOZuRlNPU1s2XxktYs+SSGL86z2m
         2M6ow+SruxB0LSwMYGoHwN/ez/P21B6gnjwLqQodBO1VFV0HFffBNL3a22DyZICNpwbL
         d+ioNjeYyP/47/adsN8NlzwnLfytE1ji+VVeP+c5rhQZpEJInDmDrfE/77X5tE89NI+7
         QZFw==
X-Forwarded-Encrypted: i=1; AJvYcCXL3Nf/lXm9jJcNkFHyVv5bOTlEBJ1Ea9PdTMgLF/4oA+IK5eMR+30VLjJi1tvjKGW9bM8D5ICV9Q==@kvack.org
X-Gm-Message-State: AOJu0YyKhRPN/aGk0b+jIrnhQl/YTm42zLEpg/VrM79g4tActVb4ca/A
	+AUIPG3Xeh786lTD82h43Z0U/A8N3IwNVfEtJnq3IcnFvjB1U/KXcEZr8vrPolosWNTQQsfLhA=
	=
X-Google-Smtp-Source: AGHT+IGZlYJ0mle+xbHh0xSRjwktI5S74Ce+g2IBDqSwNJEmJuGQ84hMG5BDqQiRTBYzVAJcWam5sKXU
X-Received: from pjss8.prod.google.com ([2002:a17:90a:1c08:b0:32e:12f0:20e3])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1209:b0:246:2e9:daaa
 with SMTP id d9443c01a7336-25d242f23f6mr188309855ad.2.1757965939122; Mon, 15
 Sep 2025 12:52:19 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:42 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-2-fvdl@google.com>
Subject: [RFC PATCH 01/12] mm/cma: add tunable for CMA fallback limit
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4902640007
X-Stat-Signature: 6c4sb4kaajd1zbnhkg8xrxgyxdaydf4f
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757965940-324242
X-HE-Meta: U2FsdGVkX1+OdE9FohuAjAabtKUdNRB0BSyqwxd9OAuXKY+JWeJAMvtMntGQdz8ejdb8GL8njPGLUArvw8DYmmDbaxoAcvvF6Qu3ZO7tZ7aYIXZgvfyjJ6P/sFiv3LsN7CfOsPHPsmMXaKDt+i67kHB94OLiVLvnYWn5tjF+5FgG6SITwRVC8NJoR3eN0B2FWRElmiaNIpfsA3tbKD/fivgoCBikEnHCgvoYqs/bydoy4t0jag2SqM9OOzvaTPrRbwJSBV+QAL5v7mOmbsCCqne1ovkHT9MbraggHtf0zojd7UFOMzIexq9cTM8RoXaoO8dz5e4gwSTBbSKy5Rg5npeGHp/cpY5u1q05YI4PjkuANZSagWkrlgLsL/JH/ccMloRUDR/YjMWV4xPmn+mWk4xM8JZo21u8pki0g3a4uLfO1SvwyZOklz7G/UsTw1n0nGuNwQEcRCFN20ef4AZU3wKzTV+k0Lmx47jEOv/lEgASnoIB3K8dcKw/BprF6fhZ3F8S4frWxMM/tJi01XFsHTRZli0tXzmnKQmPq2U6Pwx8MXVfd1bhZcEyfcuZ1yNZR5Hy1PwJC/a7NXxSTRpwv3bCGr14LIrYLY59E2C/XzQdkc86AIbC3rhCpOaSgSf+be92dtchNIKvPjFp1Ydde4Ip9+CQHlCpNCt6osErlAsN44Hg0jH0eO+tfAy6y9kKveg9Y8P2ISuvz/aD8PI2uJc1zRpG2J12MQAi1rkT+weLRmkdZqw1Ur1QKO/YB4V4IIE0/T7eaK8D28nLCd69r8/wZpV+R0JJD+3xPI1UbiMk6yEY6MZA2dw7jr6dz3Z2iOMCE35Fg3SWfds8gzuoqdx2w/I92/2axyPSkddFAY/FFtkc9x/+eNYxNbhN9m1XJH4FDCIP07ORXWtENOcMuyesgUpk4YOIhHTPYuzVhpIxbI/s82qkgH11l4QgTz8d4GWxUZCBaNw0/bfBP3P
 E8ZE7Q/p
 fHi0jQG/9EZn+bq5rijGtV4EtfeS68a/NiRjyuYn8I5wP/vwJPAITBJ2Eb8ThYZbkroQqjYfBMSm11EUGT+62HWyBIpUZGZiZeNq7OfjrgLO133ddow6ggL1GxNYVH825KBKS7YoVjTwNMuwbS4hFeBREvdk+pYH7DfCW0NWhuzyKf8nnMUOis/6ieZsD8mNhjQMR+ACX+j0DotriwuteqxssTnkY0hRkJq34KV+EVbVQpjQq6DX2z8BMhfhpyxzWC/fCZB83/9B9nhd0lKgoV/bTjQJPAAiT3N41f+2u7kuVSQQgYhRiyuI8/+b0diFvYgzkL3Zn9PnbCE5oNWZrGe1H3gnQlWYi7PMzUMEqpqFWFxLkfMhm5yw5h8syFBnj9Vd+6xeACrWAdDAKvl92m2o26Rj3dGltIcDdxCv+uHF7YEljZmbNNbRDX9cEbE2wTYB6TB1sIh1e9SD1UFYDI8kGGeS6WbWoRDUsoH1PguyWfc20OyoUDFxt2s4YdZCjHNO/DdtnnNw07AFfSFVMs9MSO5l6+J/GpVk+qEAODRSBU7yyk1eDcmMnag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a tunable to experiment with the circumstances under which
movable allocations should use CMA pageblocks first, to avoid
false OOM conditions.

The limit is the percentage free memory which is being taken up
by CMA. If the amount of used memory in CMA pageblocks is above
this limit, CMA will be used first. So, 0 would mean always using
CMA first, and 100 means never use CMA first.

Currently the default is 50, which matches the existing behavior,
so there is no functional change.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 include/linux/mm.h |  4 +++
 mm/page_alloc.c    | 84 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..313ab38dc398 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3253,6 +3253,10 @@ void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
 
+#ifdef CONFIG_CMA
+extern int cma_first_limit;
+#endif
+
 /* nommu.c */
 extern atomic_long_t mmap_pages_allocated;
 extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..d3966d31c039 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2446,6 +2446,54 @@ enum rmqueue_mode {
 	RMQUEUE_STEAL,
 };
 
+#ifdef CONFIG_CMA
+/*
+ * The percentage of free CMA pages as part of the total number of free
+ * pages above which CMA is used first.
+ * 0 = always, 100 = never
+ */
+int cma_first_limit __read_mostly = 50;
+EXPORT_SYMBOL_GPL(cma_first_limit);
+
+/*
+ * Return values:
+ *
+ * -1 - never try CMA (!ALLOC_CMA or !IS_ENABLED(CONFIG_CMA))
+ *  0 - don't try CMA first
+ *  1 - try CMA first.
+ */
+static __always_inline int use_cma_first(struct zone *zone,
+					 unsigned int alloc_flags)
+{
+	unsigned long free_cma, free_pages, cma_percentage;
+
+	if (!(alloc_flags & ALLOC_CMA))
+		return -1;
+
+	free_cma = zone_page_state(zone, NR_FREE_CMA_PAGES);
+	if (!free_cma)
+		return -1;
+
+	if (!cma_first_limit)
+		return 1;
+
+	if (cma_first_limit == 100)
+		return 0;
+
+	free_pages = zone_page_state(zone, NR_FREE_PAGES);
+	if (!free_pages)
+		return 0;
+
+	cma_percentage = (free_cma * 100) / free_pages;
+	return (cma_percentage > cma_first_limit) ? 1 : 0;
+}
+#else
+static inline int use_cma_first(struct zone *zone, unsigned int alloc_flags)
+{
+	return -1;
+}
+#endif
+
 /*
  * Do the hard work of removing an element from the buddy allocator.
  * Call me with the zone->lock already held.
@@ -2455,20 +2503,13 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	  unsigned int alloc_flags, enum rmqueue_mode *mode)
 {
 	struct page *page;
+	int cma_first;
 
-	if (IS_ENABLED(CONFIG_CMA)) {
-		/*
-		 * Balance movable allocations between regular and CMA areas by
-		 * allocating from CMA when over half of the zone's free memory
-		 * is in the CMA area.
-		 */
-		if (alloc_flags & ALLOC_CMA &&
-		    zone_page_state(zone, NR_FREE_CMA_PAGES) >
-		    zone_page_state(zone, NR_FREE_PAGES) / 2) {
-			page = __rmqueue_cma_fallback(zone, order);
-			if (page)
-				return page;
-		}
+	cma_first = use_cma_first(zone, alloc_flags);
+	if (cma_first > 0) {
+		page = __rmqueue_cma_fallback(zone, order);
+		if (page)
+			return page;
 	}
 
 	/*
@@ -2487,7 +2528,11 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 			return page;
 		fallthrough;
 	case RMQUEUE_CMA:
-		if (alloc_flags & ALLOC_CMA) {
+		/*
+		 * Try CMA if we should, and haven't done so yet,
+		 * which is indicated by cma_first == 0.
+		 */
+		if (cma_first == 0) {
 			page = __rmqueue_cma_fallback(zone, order);
 			if (page) {
 				*mode = RMQUEUE_CMA;
@@ -6672,6 +6717,17 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 #endif
+#ifdef CONFIG_CMA
+	{
+		.procname	= "cma_first_limit",
+		.data		= &cma_first_limit,
+		.maxlen		= sizeof(cma_first_limit),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE_HUNDRED,
+	},
+#endif
 };
 
 void __init page_alloc_sysctl_init(void)
-- 
2.51.0.384.g4c02a37b29-goog


