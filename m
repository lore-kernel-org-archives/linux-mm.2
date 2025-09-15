Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D73ACAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61458E0019; Mon, 15 Sep 2025 15:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75A28E0010; Mon, 15 Sep 2025 15:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D708E0019; Mon, 15 Sep 2025 15:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 853838E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26B6E1A0734
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:35 +0000 (UTC)
X-FDA: 83892531870.10.7E320D5
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5289E80009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c9DJAWga;
	spf=pass (imf30.hostedemail.com: domain of 3gG7IaAQKCMswCu2x55x2v.t532z4BE-331Crt1.58x@flex--fvdl.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3gG7IaAQKCMswCu2x55x2v.t532z4BE-331Crt1.58x@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DjbF4KpmP4NywIoDsroRavthjlO6MqxRwXYsW+YSfA=;
	b=RopvPsVvXxEwe4FP21QrDdMDgEHCc3hsDWpCr/OrmxX+Oy9G38S0Hs9V89No/C+BB+LVsA
	sSRR7ApYnaSmA8F0jZRFSjHZ33SpePF8w7OiyNjB7PckJo7sXINACF9mWCMeS2Hkd7dzCM
	i/W4dr8kPRZkhPdx/6ZJ7dtJrFIctG4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c9DJAWga;
	spf=pass (imf30.hostedemail.com: domain of 3gG7IaAQKCMswCu2x55x2v.t532z4BE-331Crt1.58x@flex--fvdl.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3gG7IaAQKCMswCu2x55x2v.t532z4BE-331Crt1.58x@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965953; a=rsa-sha256;
	cv=none;
	b=7jqPBYd+5MnnUwllwsMP35K0T85Q1CO/nVec5BA4tVoBx8XKDWmcf71JPNskRsnP7Ti0iT
	ky/CWlGQbWh7DPHldcgfaIB55wBYjgoKwGFRWK2Se9fnCw84T6/E1RnauDg+RL8FGVuAEq
	WXW1yOk6s052/p+lmxoMKCm3BMHeH3E=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24458345f5dso54808275ad.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965952; x=1758570752; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5DjbF4KpmP4NywIoDsroRavthjlO6MqxRwXYsW+YSfA=;
        b=c9DJAWgaeHUbPZRCdp2SFVsB+XUI1q3O7zMOjo1Xz3nAEw4mFJnpWEqZCUeTVae9Xp
         bq8vxTdEc+6fwzvLo7Ijix+rMMSbF7U9JoeWkjSK2RMjgY1PI7asFAgqjxjXXDzshebv
         DDUv4Y2mBNeU+yI2M42T0b4QwFeL5Py/GSxJKW4Bl5qMQD9PbRFHbs987TX6CPG8KM7W
         j3ctNplynJO1pIsBjtqan/e3XEy6QNAHKseffp1m8NqZD3hPZjgFjdLMgaK/58sM6moY
         EvJuj2MMFqawL65/A/rFKsHMtCgW8Zfx6M/biYyv6HeNEf+lchoZn2fEcqYyQBK4eB0f
         GgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965952; x=1758570752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5DjbF4KpmP4NywIoDsroRavthjlO6MqxRwXYsW+YSfA=;
        b=RlNn/+WOUbdyP3QQyh/v3bK97+WfXxOylPGFzvcie77rQ5ldh7dD6vm3eVDEW8JFpN
         WBWFZEetc/OhQjWtv5mJow8RWEg2kNjmnNbzwYN/zFSa2MTzk2jJmXrpMuSXaCzCL3YI
         7Bh6JJlitbIWxulJhlHgNLYiMHaqdkCbaTgFtY8COjGOxsJXjoszr0+d5RpoBpnmFvgE
         cJd4Zy4Hx7v32qRk7Jj+FkKMG1Rnurj74kzLgQAgF6rV/2RWkOpxH+I2YAG+h/G7786Y
         /xCPwEG+JG8ZO6z/ZppOk4PKm9g+/z0oZ6tbQ7ulBwFBBgasQHAHG/9T4UXK1XwcnMf4
         z2yA==
X-Forwarded-Encrypted: i=1; AJvYcCUT3uUNjdr3I/oz3teeAVDjfsIeIxADtebT8khSLz6ROMHhBgOLEkzeCr98vygaRIRes2ZQ6tshpQ==@kvack.org
X-Gm-Message-State: AOJu0YwQ6+ngHeShJmxjC8lY25koh8Swe59YIvzGujfstthXLa31Zy6H
	Xyi/OZJHnbZgjyZWZaL/E8gkRJI5/2ibaxRjN36po1PH0Ali/UVW0rJ4xHtcJ1vPI5xlykftjg=
	=
X-Google-Smtp-Source: AGHT+IF8O+VLtGgAGnPoMFPwPtML+wPGmo10/Gb9GlzY+4KfLm4QkQw7DA2FoDyUrRDSv5yLbXqWtzOk
X-Received: from plbiz4.prod.google.com ([2002:a17:902:ef84:b0:24c:863e:86a3])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dacd:b0:25d:8043:781d
 with SMTP id d9443c01a7336-25d804381bcmr162786945ad.21.1757965952236; Mon, 15
 Sep 2025 12:52:32 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:50 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-10-fvdl@google.com>
Subject: [RFC PATCH 09/12] mm/cma: introduce CMA balancing
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 98sczqzz6njoucj6jwo6uhfn5so648h7
X-Rspam-User: 
X-Rspamd-Queue-Id: 5289E80009
X-Rspamd-Server: rspam04
X-HE-Tag: 1757965953-685692
X-HE-Meta: U2FsdGVkX1+m7Gyw5SMCfUtsTkd06SaRhoTck40WL1JfGWmc+n7DR/UUxm165jDDCnFqaomA3xux3/0XuTy4lWDkdk+WyhuoAwGba+0oTAQn23A2wqtescge0arlllcqyOHazHdQFHJvA22mEB1t8WMUddan2EvV44Uc5b24Qwtcz71uN3sCQhtPBTmv3TuJRDOeMiYqJ3BWXH5Y6vTBc/YV7RG2bV+IkGFkksc3MKmJIeqOrYjbLtDOldRbRrlJ8J0EvbJjIgVtiT0tT0OOYUZd5MaPUZ1/gITB4Lt+jr1gwbmPp0mvcpW2oEuzReLEkzlnRosexGxBFU3HEMhSNVJNdR7q65xfIl1ySAmFBvznbnUU6bTy+gd1cc9EfJvZzoh7Za6nspNp6MmU6IeOoX60O+lZVFdynx77HWPHwoyDUFsfd8b01MkPYphcstHQ+k8yLgLRp8wHspnaHsSzSeUPfR4xJ5cInWXNccxVhP/L77dtthxx2sNuzOsgq84ZNgAVIeOL5YKX05iRTX7cvXhdHDG9AyQWX96FScW2WxYXqhZJuRcGU9xVSBircO4LadTGh3POKzM8acBU9SeS1xYpkxMChB9Oxh46tsQA4xEAvLFKv+qqxOfQEf2ZfaB3zqElgVdySJNXdsL4a91h9mhtIw9eqZKJ2YdZJ6AQSfJ3vyjV4Dv0MUHFJNJHOHkvMDsmj31teulCd28tTgpAUs7yzIgDiwrg4bjATSnQDzXGpXPQi4fXPh8U8gfCWhveXFf+6w60mqapWRIS4zymNZ0lca/k6T4mUy0ZVuk8mzM0D+0x2gqEKRlY5AH/YarhSWWXq5eoGoeHUjeJnCW4OfmMMvbX0MC/dddL2AH/dW/1JsiEGybu4aViN+sRaeSqdZd7UR8SKG4jdWSt97NxaHgnyIWkQnHjg/t8vr6IW3Drb6JB/kByoYHEZy9pGIF2CJxWDfjqkVqB/EHt/UW
 jgmFSTtH
 +Df0AIX2Z7kJhr87X3P1R+dGj5F9m/OBBoJcQuOZUuy/ZjOL8irLueRrSJgRt/fsPtBTxarHvA4gCLS+Hz6DNDrw0zEwIGAtn5QZYrRd9OxidhGFRZonTE658FiTbmmcxM86UlnCR3GZjIDQ9npEUcDYO8K01L3vq3vQ602dh6I/Kot8Kn2S/HtoawHz6K7UTJzDfq+6T1VzXcTLuR0JcqeM0F68w2YN6Nrp7O1gZJ4h63Wo/HMIeO5uB7cRtnzE8oAHQ9S11hKHp3xCOcDC3UHR6J/judeT5gpSbLQzKdTxyOtfevnulZF9npI7N1r1hYudz0W4NB/+Ad+fka6FngfZTXA8o/QicF9QQ5dYVrj9AfvsRcdb1XXDiwA/5l9P+YgPkzCm17G1st9Tda/hH0TYfmPQBoDCUT1WofoVUXDCXErrNz0vnQm+yAZLQNDw73siY0/HpmywVNiF30nRJjIl8hLF0OAbAzSRBbiGBM1LguKKMQuxwLKQrOB2FxolauPmruFwzzhvbb+38EB4e4KgHlYF1KqY6i3+DZPMTeKhqncAf34ysYouGNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A longstanding problem with having a lot of CMA pageblocks in
the system (through hugetlb_cma), is that this limits the amount
of memory that the kernel can use for its allocations. Kernel
allocations are unmovable and can not come from CMA pageblocks.

This can lead to situations where kernel allocations cause OOMs,
when in fact there might still enough memory available. There
isn't much that can be done if the non-CMA part of memory is
already taken up by unmovable allocations. That scenario can
be considered a misconfigured system. But if there are movable
allocations in the non-CMA areas, they are unnecessarily
taking away space from the kernel.

Currently, the page allocator tries to avoid this scenario
by allocating from CMA first if more than half of free pages
in a zone come from CMA. But that's not a guarantee.

For example, take the case where a lot of memory is being
taken up by 1G hugetlb pages, allocated from hugetlb_cma, and
that the hugetlb_cma area has been fully used by hugetlbfs.
This means that new movable allocations will land in the
non-CMA part of memory, and that the kernel may come under
memory pressure. If those allocations are long-lasting,
freeing up hugetlb pages will not reduce that pressure,
since the kernel can't use the new space, and the long-lasting
allocations residing in non-CMA memory will stay put.

To counter this issue, introduce interfaces to explicitly
move pages in to CMA areas. The number of pages moved
depends on cma_first_limit. It will use that percentage to
calculate the target number of pages that should be moved.

A later commit will call one of these interfaces to move pages
to CMA if needed, after CMA-allocated hugetlb pages have been
freed.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 include/linux/migrate_mode.h   |   1 +
 include/trace/events/migrate.h |   3 +-
 mm/compaction.c                | 168 +++++++++++++++++++++++++++++++++
 mm/internal.h                  |   4 +
 4 files changed, 175 insertions(+), 1 deletion(-)

diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
index 265c4328b36a..3e235499cd73 100644
--- a/include/linux/migrate_mode.h
+++ b/include/linux/migrate_mode.h
@@ -25,6 +25,7 @@ enum migrate_reason {
 	MR_LONGTERM_PIN,
 	MR_DEMOTION,
 	MR_DAMON,
+	MR_CMA_BALANCE,
 	MR_TYPES
 };
 
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index cd01dd7b3640..53d669ee26be 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -23,7 +23,8 @@
 	EM( MR_CONTIG_RANGE,	"contig_range")			\
 	EM( MR_LONGTERM_PIN,	"longterm_pin")			\
 	EM( MR_DEMOTION,	"demotion")			\
-	EMe(MR_DAMON,		"damon")
+	EM( MR_DAMON,		"damon")			\
+	EMe(MR_CMA_BALANCE,	"cma_balance")
 
 /*
  * First define the enums in the above macros to be exported to userspace
diff --git a/mm/compaction.c b/mm/compaction.c
index 2e6c30f50b89..3200119b8baf 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include <linux/cma.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -2512,6 +2513,173 @@ compaction_suit_allocation_order(struct zone *zone, unsigned int order,
 	return COMPACT_CONTINUE;
 }
 
+#ifdef CONFIG_CMA
+
+static void
+isolate_free_cma_pages(struct compact_control *cc)
+{
+	unsigned long end_pfn, pfn, next_pfn, start_pfn;
+	int i;
+
+	i = -1;
+	end_pfn = 0;
+
+	next_pfn = end_pfn = cc->free_pfn;
+	start_pfn = 0;
+	while (cc->nr_freepages < cc->nr_migratepages) {
+		if (!cma_next_balance_pagerange(cc->zone, cc->cma, &i,
+						&start_pfn, &end_pfn))
+			break;
+		for (pfn = start_pfn; pfn < end_pfn; pfn = next_pfn) {
+			next_pfn = pfn + pageblock_nr_pages;
+			isolate_freepages_block(cc, &pfn, next_pfn,
+					cc->freepages, 1, false);
+			if (cc->nr_freepages >= cc->nr_migratepages)
+				break;
+		}
+	}
+	cc->free_pfn = next_pfn;
+}
+
+static void balance_zone_cma(struct zone *zone, struct cma *cma)
+{
+	struct compact_control cc = {
+		.zone = zone,
+		.cma = cma,
+		.isolate_freepages = isolate_free_cma_pages,
+		.nr_migratepages = 0,
+		.nr_freepages = 0,
+		.free_pfn = 0,
+		.migrate_pfn = 0,
+		.mode = MIGRATE_SYNC,
+		.ignore_skip_hint = true,
+		.no_set_skip_hint = true,
+		.gfp_mask = GFP_KERNEL,
+		.migrate_large = true,
+		.order = -1,
+	};
+	unsigned long nr_pages;
+	int order;
+	unsigned long free_cma, free_pages, allocated, allocated_noncma;
+	unsigned long target_free_cma;
+	int rindex, ret = 0, n;
+	unsigned long start_pfn, end_pfn, pfn, next_pfn;
+	long nr_migrated;
+
+	if (zone_idx(zone) == ZONE_MOVABLE)
+		return;
+
+	if (!cma && !cma_numranges())
+		return;
+
+	/*
+	 * Try to move allocated pages from non-CMA pageblocks
+	 * to CMA pageblocks (possibly in a specific CMA area), to
+	 * give the kernel more space for unmovable allocations.
+	 *
+	 * cma_first_limit, the percentage of free pages that are
+	 * MIGRATE_CMA, is used to calculcate the target number.
+	 */
+	free_pages = zone_page_state(zone, NR_FREE_PAGES);
+	free_cma = zone_page_state(zone, NR_FREE_CMA_PAGES);
+	if (!free_cma)
+		return;
+
+	target_free_cma = (cma_first_limit * free_pages) / 100;
+	/*
+	 * If we're already below the target, nothing to do.
+	 */
+	if (free_cma <= target_free_cma)
+		return;
+
+	/*
+	 * To try to avoid scanning too much non-CMA memory,
+	 * set the upper bound of pages we want to migrate
+	 * to the minimum of:
+	 * 1. The number of MIGRATE_CMA pages we want to use.
+	 * 2. The space available in the targeted CMA area (if any).
+	 * 3. The number of used non-CMA pages.
+	 *
+	 * This will still likely cause the scanning of more
+	 * pageblocks than is strictly needed, but it's the best
+	 * that can be done without explicit tracking of the number
+	 * of movable allocations in non-CMA memory.
+	 */
+	allocated = zone_managed_pages(zone) - free_pages;
+	allocated_noncma = allocated - (zone_cma_pages(zone) - free_cma);
+
+	nr_pages = free_cma - target_free_cma;
+	if (cma)
+		nr_pages = min(nr_pages, cma_get_available(cma));
+	nr_pages = min(allocated_noncma, nr_pages);
+
+	for (order = 0; order < NR_PAGE_ORDERS; order++)
+		INIT_LIST_HEAD(&cc.freepages[order]);
+	INIT_LIST_HEAD(&cc.migratepages);
+
+	rindex = -1;
+	start_pfn = next_pfn = end_pfn = 0;
+	nr_migrated = 0;
+	while (nr_pages > 0) {
+		ret = 0;
+		if (!cma_next_noncma_pagerange(cc.zone, &rindex,
+					      &start_pfn, &end_pfn))
+			break;
+
+		for (pfn = start_pfn; pfn < end_pfn; pfn = next_pfn) {
+			next_pfn = pfn + pageblock_nr_pages;
+			cc.nr_migratepages = 0;
+
+			if (!pageblock_pfn_to_page(pfn, next_pfn, zone))
+				continue;
+
+			ret = isolate_migratepages_block(&cc, pfn, next_pfn,
+					ISOLATE_UNEVICTABLE);
+			if (ret)
+				continue;
+			ret = migrate_pages(&cc.migratepages, compaction_alloc,
+					    compaction_free, (unsigned long)&cc,
+					    cc.mode, MR_CMA_BALANCE, &n);
+			if (ret)
+				putback_movable_pages(&cc.migratepages);
+			nr_migrated += n;
+			if (nr_migrated >= nr_pages)
+				break;
+		}
+
+		nr_pages -= min_t(unsigned long, nr_migrated, nr_pages);
+	}
+
+	if (cc.nr_freepages > 0)
+		release_free_list(cc.freepages);
+}
+
+void balance_node_cma(int nid, struct cma *cma)
+{
+	pg_data_t *pgdat;
+	int zoneid;
+	struct zone *zone;
+
+	if (!cma && !cma_numranges())
+		return;
+
+	if (nid >= MAX_NUMNODES || !node_online(nid))
+		return;
+
+	pgdat = NODE_DATA(nid);
+
+	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+
+		zone = &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
+
+		balance_zone_cma(zone, cma);
+	}
+}
+
+#endif /* CONFIG_CMA */
+
 static enum compact_result
 compact_zone(struct compact_control *cc, struct capture_control *capc)
 {
diff --git a/mm/internal.h b/mm/internal.h
index ffcb3aec05ed..7dcaf7214683 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -857,6 +857,8 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
+struct cma;
+
 /*
  * in mm/compaction.c
  */
@@ -887,6 +889,7 @@ struct compact_control {
 	unsigned long migrate_pfn;
 	unsigned long fast_start_pfn;	/* a pfn to start linear scan from */
 	struct zone *zone;
+	struct cma *cma;		/* if moving to a specific CMA area */
 	unsigned long total_migrate_scanned;
 	unsigned long total_free_scanned;
 	unsigned short fast_search_fail;/* failures to use free list searches */
@@ -938,6 +941,7 @@ struct cma;
 #ifdef CONFIG_CMA
 void *cma_reserve_early(struct cma *cma, unsigned long size);
 void init_cma_pageblock(struct page *page);
+void balance_node_cma(int nid, struct cma *cma);
 #else
 static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 {
-- 
2.51.0.384.g4c02a37b29-goog


