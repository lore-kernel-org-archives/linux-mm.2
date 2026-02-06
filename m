Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE39CEB28D4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C0C6B009E; Fri,  6 Feb 2026 02:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9D46B00A1; Fri,  6 Feb 2026 02:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E32A6B00A2; Fri,  6 Feb 2026 02:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8F86B009E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:22:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D58951C1EB
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:22:42 +0000 (UTC)
X-FDA: 84413189364.25.BFE7AF3
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1950880006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:22:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kWhW/9Q2";
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770362561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FlgnQqPR0Eqtlq7a3B9xxhSsLwOvW1r1+v4iZpc7xIc=;
	b=DYbWneZlAsDdIIc7GQ2lBxfzkg+wil55QlX4oaKMs4PADv/WHItVwinQbJWd6E+7nypgx3
	WEII7BJXb2uGj3KPTaYtVybOULCfP8InoeSJBzERZpdnGBzcjK7MlTEpSJXPUuL8rox6kh
	FX5ZaCa3UYgNh/HBCd4A6sjRPsZwgbg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kWhW/9Q2";
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770362561; a=rsa-sha256;
	cv=none;
	b=j9wDNiipg2aBCm8EYiTCJQF+BsAHRjrsw9KRat4gk/YDwrGbKbN1nge9V4gJ6FQ0Hwp+Tv
	YhHUdpwjIe5klz7HVA89SFlQlvphw6FKzoM6Bxis9ZTj+EpEURd5U/cevTTd8H7HM0axda
	4PUV0WUEQGJselvCbEABHV48HrRqTIA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770362559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FlgnQqPR0Eqtlq7a3B9xxhSsLwOvW1r1+v4iZpc7xIc=;
	b=kWhW/9Q2R5RI8yTcLIJXaW0F0l2jwPZG+wn3xYTgRi6V2vts0omDsq/CDPphq2QsoFQECt
	pB69MQnUf5fELBEb3fISrxDsqxbq4Sup6C9qWK5NiqR0+CP+L6VppMGK7XQRDgrd+KCkPl
	HxmYS3RrMHIqcKlfVnmPms3K/Gs431M=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 1/2] mm: zswap: add per-memcg stat for incompressible pages
Date: Fri,  6 Feb 2026 15:22:15 +0800
Message-ID: <20260206072220.144008-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260206072220.144008-1-jiayuan.chen@linux.dev>
References: <20260206072220.144008-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1950880006
X-Stat-Signature: kmu5cntzo16jw9cdnfjbwuh93fr6a8t6
X-Rspam-User: 
X-HE-Tag: 1770362560-593000
X-HE-Meta: U2FsdGVkX1/IbNycbrAV2FKlw9MjKkt1PMtG9ADMX7cpQ3ZJixPEokRszJb2uk/2C9Ll6ek9EallTI128pSbaZFc/zflXtY6Z5OKowX6ui3ojmZYnTCTu9nNfLN5Pdab54BU++hOPHCDSQcFeRl7mPN9oWHn5NxtbXQqqWFuJU7+kIUy6sCk3X4UegibGH3X10Tinjw/L57XEeYnW3sqENyR9Xj7W8jTVtzucRHISvITTSHe3BC2avpK4X6Zu+bQYLvwWv8eQIT8ZptjHYtb4eYDqD/Yc5Hn+aAIoZNP2x/EK16H+WGqKhKmQf+PghT7cNeZCbd3PrQoF6tNrjy9iH2+tCI8yydKqtLgVnmXoP0eTjgnH91jkXZQ2rN0nAENdi5X9ouDiXjWWTeRrymQezdvPMnIb/bA/85GckV4hYY/+OWqXNiXsWpKKl8L9MN5tllBVM6xI81xXBX4S30LYBoT6BR/GR+UqkMjStimuIrxo+AQ6NPCqjMuq8x5Cazar+GtGRDR+aUz5YWFYYQ2wxhWrW2etSldhgQOptYbCbf2kgpNL8MWVH7PMWtVeJMM0s3Z3WkK9rk7qcNHsdN0HIhBMhYeSHlcW6FDfQQMlhx6ZxW+PyP/x3KikI+SFaCIU1QWBkS164bL2spuiv5O2GERITgJfzys+sAIGNmBKau2FgUphI0oYI+5bGp2ToYQ58uNzziMQ0qrsauiHrh6tqQ8ldtsz4ESq94qEYhtRLGkWh8E97m9+MS+Q5CdfL4vSRllNw1etdGNYR/4IEHeh+QFiucD24LbvdVWEvrqrfa2kiOwt3kQdBLDxg+oj5X9rCLHmt0zIpINzhY2/dQrWgF8aLVWCJza5Fw8Zzo/euocejFplzEQnJzO8MquoRL1Q+YHAFh9yKR2psdrn0mJfhJcbZw9qIva/cwjSZc69UzAOItN0feoVZRsqLyANu3peqWVW+F8XGLiU9WVWkv
 nhLtypE+
 9NSK7LYObMwse5OYSG2FfJmz1v4H042IxbYw2xAn+CmtovnJVqIgSZmhuc4qb+HZuMmIn0OixxfvZR1OJN1tJR8IuNx2SnjJUr03QijA3oWOAEH9gug8MGXIufoyI7oClvllBwcCuqZXRGFi+XzyIYuNYb9HB4d9Wy2SX5uxNTjIzjw026Lp07E5ums8AKTdODniprsxZN985P9WtnlldS+T66vZ1WBVJO81BIKhfjgM57vZzVqXI6rBbCJYAQB74im9U2vhhMzg6ai4fF3KZ5VxGqrKQv8fNtRn1PHsiJ2Hk9ftk2IG9npVCbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

The global zswap_stored_incompressible_pages counter was added in commit
dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
to track how many pages are stored in raw (uncompressed) form in zswap.
However, in containerized environments, knowing which cgroup is
contributing incompressible pages is essential for effective resource
management [1].

Add a new memcg stat 'zswap_incomp' to track incompressible pages per
cgroup. This helps administrators and orchestrators to:

1. Identify workloads that produce incompressible data (e.g., encrypted
   data, already-compressed media, random data) and may not benefit from
   zswap.

2. Make informed decisions about workload placement - moving
   incompressible workloads to nodes with larger swap backing devices
   rather than relying on zswap.

3. Debug zswap efficiency issues at the cgroup level without needing to
   correlate global stats with individual cgroups.

While the compression ratio can be estimated from existing stats
(zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
"uniformly poor compression" and "a few completely incompressible pages
mixed with highly compressible ones". The zswap_incomp stat provides
direct visibility into the latter case.

[1]: https://lore.kernel.org/linux-mm/CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com/
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 5 +++++
 include/linux/memcontrol.h              | 1 +
 mm/memcontrol.c                         | 8 ++++++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7f5b59d95fce..78a329414615 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1737,6 +1737,11 @@ The following nested keys are defined.
 	  zswpwb
 		Number of pages written from zswap to swap.
 
+	  zswap_incomp
+		Number of incompressible pages currently stored in zswap
+		without compression. These pages could not be compressed to
+		a size smaller than PAGE_SIZE, so they are stored as-is.
+
 	  thp_fault_alloc (npn)
 		Number of transparent hugepages which were allocated to satisfy
 		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b6c82c8f73e1..d8ec05dd5d43 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -39,6 +39,7 @@ enum memcg_stat_item {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_INCOMP,
 	MEMCG_NR_STAT,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 007413a53b45..a6b6cf5f1aeb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -341,6 +341,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_INCOMP,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1346,6 +1347,7 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
 	{ "zswapped",			MEMCG_ZSWAPPED			},
+	{ "zswap_incomp",		MEMCG_ZSWAP_INCOMP		},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -5458,6 +5460,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
 	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
+	/* size == PAGE_SIZE means compression failed, page is incompressible */
+	if (size == PAGE_SIZE)
+		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
 	rcu_read_unlock();
 }
 
@@ -5481,6 +5486,9 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
 	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
+	/* size == PAGE_SIZE means compression failed, page is incompressible */
+	if (size == PAGE_SIZE)
+		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, -1);
 	rcu_read_unlock();
 }
 
-- 
2.43.0


