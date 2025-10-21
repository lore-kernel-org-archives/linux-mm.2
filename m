Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA14FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19EA8E0022; Tue, 21 Oct 2025 05:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF11C8E0002; Tue, 21 Oct 2025 05:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DF28E0022; Tue, 21 Oct 2025 05:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0E5F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:50:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6351F11A020
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:50:17 +0000 (UTC)
X-FDA: 84021650874.26.94F5B28
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2E4E41C000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:50:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761040215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0U/KY7FhZ8afxw/9nxn0L2r6RudCO74f17iJrIgXAbs=;
	b=6HuI2gpXskoWICUAvcZ/tsibtfcvd3A8qxXoIEob6jXSYTlS4Dwdf/E7R3Y9Lab+Gxbbt+
	HppvOD36mpAccVBmVW9r2cBR7yh14o1hytqgbpfmPLjE3VxLy0/kuGc+6tCAyEdCMEcNRA
	STyXM54+7AkP4qQ/sOFOIY7gkGbFSCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761040215; a=rsa-sha256;
	cv=none;
	b=WSVOfgmyNoq17vXbsuIZligxO1MZURDSo43VPuvIEDoARh/zOp1Sbmbc3pzLA2cCH73INK
	BjU/pRtzNXZpKcHjOL6ZaNHXgb7X4Knc0yZcFZSCe8Tgq2ue6WOeTSXc37BKXG/C0iE8nx
	Bytt648u/N2TP1HKgyAQQSkuG1uYtqE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4crSDn73DmzYrxv2;
	Tue, 21 Oct 2025 17:49:13 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Oct
 2025 17:50:08 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 21 Oct
 2025 17:50:08 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <akpm@linux-foundation.org>
CC: <david@redhat.com>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>, <zhengqi.arch@bytedance.com>,
	<shakeel.butt@linux.dev>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<weixugc@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH] mm/page_alloc: Consider PCP pages as part of pfmemalloc_reserve
Date: Tue, 21 Oct 2025 17:50:04 +0800
Message-ID: <20251021095004.12157-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam05
X-Stat-Signature: ufhkge68nxr9aup9u7u95auu4auaw95z
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E4E41C000C
X-HE-Tag: 1761040214-589003
X-HE-Meta: U2FsdGVkX1/+DfZrtEJ9QHaQTNAq17koQ5o4KvAExy/OVqgwcr2ycK5gi24lK9e8T3v3WHAEorS3vqDP/UcxciF0YvQBXYjo6sQPuTA7ijNjDB1tiPS2Ql9Eb9QlQBF2T5ARLCXyriIzetcd7vMNBTUd9zONulwPO6E5UiMW8xGsst/QRJL5+g6n2rZxiudtsijkMgU3thZbpt6HaAAwCBWKvzdDRywoFKaep+sH/NyRMvwTVxeiNpB38k8exSQIv+XTS4aHsPYVlzDgg9OM2+bt/J/9jzLl4uUnMUs2Rc/Wae0zdtOa5Gx9Eit9STgytVa8b8XcrwPqgQ3Yaz+lO76lW2yeS/atPyOF9+CvKHzTyXwgwl+eXXLEucAfxpWTq/cK3bN6nLWUVevwYTeZLJcpTBhGO30TumzOMyVysdEmccBKx4NwSh0nMdoY/P2UZOmFFaOuAruY9d6wZPklDmthTujDUu4uJkTwnMWNqpVmcVw9HW2MRu0i2hWCsOJvr1RrnQPNcY+7s7q+Z1BUYLdRbtvkpnjHrCqmZIzCgGTnqCWwElG/+m19M4MQiQ5dfwuQqbGiA4ub2sw4s9wfhvwNFvhN7/CV369u9uD6iXL73txh/T5hpyMz5JJLKCSWSd+jMECGyl6P+oQVwFuD9hPxoOcwcwGUnee6LGcpxmCE/tG5BW+7mFriM5utdD2SMrRNk2FmUid7co57ExU1V25Rd8O7ci9QBynkti4hiNgO47GtH7vyZ2QrMuUl99w/BkRNGQw+3WnmK0G7E7J75DhjdkwBbeiXeuW6UhlnpBcFcEldojLEhu3OuegGGJKtcqXF6QdXijK4tQwF5LwpfbTjhMAIZovVMKCti5EfGjm8S2oCPdard8qCkxVTDazCjkzvpYK1T1h2P3FHAwSB06mJMTkIWpXP+e2Wine7tvpM73selEIeQ0/RDxjDxwNehagrQk2S47QlpiEYb8U
 0mHAhnVW
 gz/ZAfLHNyQPXQd8OwEkW0OED0ZeJV8tDE/6ZHZgSbzSFzmNgypv20OW6s0FDIqaC+LW3++agmEiLi1NB4bIsxbbY7/5xofBSxqQ+EFgawNMHVyfGtE89C8DGH98drN7PAIeQ0UZtCknl13wmBaNs0LldgGvsye53sT0H//Otzva6gUM0CZ6mOLuI8l07b0RmbFb8mjs53ZS7uqxHQFUSBhcykf51is0x48sKQW8/GkNNIZ3GkWLptJyStFjmQn0YtVSU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When free_pages becomes critically low, the kernel prevents other tasks
from entering the slow path to ensure that reclaiming tasks can
successfully allocate memory.

This blocking is important to avoid memory contention with reclaiming
tasks. However, in some cases it is unnecessary because the PCP list may
already contain sufficient pages, as freed pages are first placed there
and are not immediately visible to the buddy system.

By accounting PCP pages as part of pfmemalloc_reserve, we can reduce
unnecessary blocking and improve system responsiveness under low-memory
conditions.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/internal.h   |  1 +
 mm/page_alloc.c | 14 ++++++++++++++
 mm/vmscan.c     |  1 +
 3 files changed, 16 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..c8fcee51d662 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -842,6 +842,7 @@ static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int ord
 #define alloc_frozen_pages(...) \
 	alloc_hooks(alloc_frozen_pages_noprof(__VA_ARGS__))
 
+extern int zone_pcp_pages_count(struct zone *zone);
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1999eb7e7c14..e34031946adb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7134,6 +7134,20 @@ void zone_pcp_reset(struct zone *zone)
 	}
 }
 
+int zone_pcp_pages_count(struct zone *zone)
+{
+	struct per_cpu_pages *pcp;
+	int total_pcp_pages = 0;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+		total_pcp_pages += pcp->count;
+	}
+
+	return total_pcp_pages;
+}
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * All pages in the range must be in a single zone, must not contain holes,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 674999999cd0..148f452d9cf5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6498,6 +6498,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
 
 		pfmemalloc_reserve += min_wmark_pages(zone);
 		free_pages += zone_page_state_snapshot(zone, NR_FREE_PAGES);
+		free_pages += zone_pcp_pages_count(zone);
 	}
 
 	/* If there are no reserves (unexpected config) then do not throttle */
-- 
2.17.1


