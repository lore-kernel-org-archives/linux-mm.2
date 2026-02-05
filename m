Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A219E83F05
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51BE46B009E; Thu,  5 Feb 2026 00:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3526B009F; Thu,  5 Feb 2026 00:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2A16B00A0; Thu,  5 Feb 2026 00:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29AF26B009E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:30:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCA01B9011
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:30:52 +0000 (UTC)
X-FDA: 84409278744.11.9BA9A13
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7B3ED140007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:30:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ea1grlml;
	spf=pass (imf23.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770269451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GgqfJdQjw9jeJ36Z1N0ESMnPon9eBH43wGJH8jQ18rY=;
	b=xLm6TxqgfeOuE2vSzPu1hH2Xog1umUSVKNJVO8vHAZudpYRgGm0SBMLtE+vcbYIfDgwH73
	H8UCWkmPBQ2Y7RgEaUWDC6BduZdfKAcXTBudmGKTnDsyjndzhw31IRSyINFG4CJW1yiZzl
	zFlgnMuvnkYSIRzrnaswiilj7oWVdYM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ea1grlml;
	spf=pass (imf23.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770269451; a=rsa-sha256;
	cv=none;
	b=OsIAoadiFkK0EWXxM+8rRMzJjULlUYX+bisJaOIMX6/T8lgPWECfL9JP1eqvSmfACWd5pO
	9vBxKIHVRDL9hTztKV/H8fVap/Qsvpu9SHHEh3AbndU63j93xoJr4Q+1KnBF9QgsF+6A7n
	RcPf+L7+BNxVW7j1sETVUx67U/LLHrM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770269447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GgqfJdQjw9jeJ36Z1N0ESMnPon9eBH43wGJH8jQ18rY=;
	b=Ea1grlmlpc2e8TGxhyQfULCO/EY//nNMVo9ETJNbi3Irw3qu0wfzrfC9vtkfSXj+07s0HJ
	0kO/NCx7ZavnuuCcB4ZuISd3uuAsmXmocWhOymciFIpNREGdZ1GJX2/AxRiVyI+ZvGg7SZ
	SFf2JUZzIOYrbum/+CFxaXd+WWdZ2IA=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] mm: zswap: add per-memcg stat for incompressible pages
Date: Thu,  5 Feb 2026 13:30:12 +0800
Message-ID: <20260205053013.25134-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: kkpta7duzzp3qaiz7oxa1yhh61eamcmr
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B3ED140007
X-HE-Tag: 1770269449-331784
X-HE-Meta: U2FsdGVkX1+ujI/GurmoRFZ+7FwJ5Y+urTo3APc8sO6wxC/Xu/Eeny1dqh+9um4FJQZmYUQzKJrNPycc1GyYyaw4slUUqlSAdUyawyG9U3/NdynQ42BAucQFpIquoht06x26ckXeNdIxMmjYRxklpc6D2NtRFNUYiVePBPQYqjptu++mKt8nzQpWiVUL3WwrasDT5kBRtQo+oSeS+/CHcpOyLgUOhGFMyMHnTLygwScdrAUZ3FSyS8TpJAXV3la4NCss0LgfMl72GpAOf/s+QcP89wfb8k8cf1ZUUAqZCt7f14ffBJBB8CIp+WPziH8QAMwRR4szKQvWA1XHCFvI5RkgVtgg3bwOC6wTRCQKoz/UHEzg7ewdr0/Em6GonhaCb6prGFCVdNLJ7UYDCefyAi0UpFwvbL+RFaXDszk91lP1K/SuYGZcrY6xUzaZS0079aiE953wv8uLyiVhzXW8L1QeNqycwcziVqAm/UH3D0/dOBF1ce5/aIPYJTUeOhmiXjd4hRRPEhFC2HzX6qQIv5I/6yPs+XPs7CXMOgPCquozxctnfcKA1AVTFLdYKcLPCQaBoNb729XamMTKIiLihn+tW0QlcIq40ZCErmYCEsL2zjdUfcWbHqFbJ7Xbu5zUSMn18C8jEDB7+STOJ+abu708V77hHc/iKE1AMh0e/BXaJ5MQKPBtJ4jCL4pvHhEJne5cwJvSCEeVrymqSsSalan3kQzz9BV+gyKBWXwq8r93qNqRoLjJTYyDRaVq3Ue2Nf8E2XzY9GmBNHEVluMK0fTZSf2psssRRwZWkNlJdbwDWnKbUXCvXcf/K6YhexzSvs54fZstEPNX4m7PGh5znC1YzStDUfKOAqe4/CyJCmXA0dZ4PmhgIF5tQwpk+tQIyyhwRAYz0w7imNQvbmT34zQJ2vQpXqMAffvzKvMbTCKFg2hwWOmn+21ABmDZNlQYRRphSghHVx6B5uj+/Jw
 XXg3/j8g
 qyK81d4PFsXDZ7URWAnF48+wIQlQAwc7crbIHLMwABLz5jb7rY/XtGIWOM7NrO+K4ygBl/XUgs49z3MrHr1DLdFajB2XzjDv2MgbFGkSbT0SBMN6HaoYfNqDBhqy5ZrhE7e5rAvgifIrfqRd6N7/GUvjBolkhcWRkxoNzjvJ9yNqTNmgbGkIs8roLL4Q3faTgKz/XWWsrqMStFke+sAzSnQCmdBstl9A4J3D7lLzgyNMn0xpjce0nS64YPA==
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
management.

Add a new memcg stat 'zswpraw' to track incompressible pages per cgroup.
This helps administrators and orchestrators to:

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
mixed with highly compressible ones". The zswpraw stat provides direct
visibility into the latter case.

Changes
-------

1. Add zswap_is_raw() helper (include/linux/zswap.h)
   - Abstract the PAGE_SIZE comparison logic for identifying raw entries
   - Keep the incompressible check in one place for maintainability

2. Add MEMCG_ZSWAP_RAW stat definition (include/linux/memcontrol.h,
   mm/memcontrol.c)
   - Add MEMCG_ZSWAP_RAW to memcg_stat_item enum
   - Register in memcg_stat_items[] and memory_stats[] arrays
   - Export as "zswpraw" in memory.stat

3. Update statistics accounting (mm/memcontrol.c, mm/zswap.c)
   - Track MEMCG_ZSWAP_RAW in obj_cgroup_charge/uncharge_zswap()
   - Use zswap_is_raw() helper in zswap.c for consistency

Test
----

I wrote a simple test program[1] that allocates memory and compresses it
with zstd, so kernel zswap cannot compress further.

  $ cgcreate -g memory:test
  $ cgexec -g memory:test ./test_zswpraw &
  $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
  zswpraw 0
  zswpin 0
  zswpout 0
  zswpwb 0

  $ echo "100M" > /sys/fs/cgroup/test/memory.reclaim
  $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
  zswpraw 104800256
  zswpin 0
  zswpout 51222
  zswpwb 0

  $ pkill test_zswpraw
  $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
  zswpraw 0
  zswpin 1
  zswpout 51222
  zswpwb 0

[1] https://gist.github.com/mrpre/00432c6154250326994fbeaf62e0e6f1

Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 include/linux/memcontrol.h | 1 +
 include/linux/zswap.h      | 9 +++++++++
 mm/memcontrol.c            | 6 ++++++
 mm/zswap.c                 | 6 +++---
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b6c82c8f73e1..83d1328f81d1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -39,6 +39,7 @@ enum memcg_stat_item {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_RAW,
 	MEMCG_NR_STAT,
 };
 
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..94f84b154b71 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -7,6 +7,15 @@
 
 struct lruvec;
 
+/*
+ * Check if a zswap entry is stored in raw (uncompressed) form.
+ * This happens when compression doesn't reduce the size.
+ */
+static inline bool zswap_is_raw(size_t size)
+{
+	return size == PAGE_SIZE;
+}
+
 extern atomic_long_t zswap_stored_pages;
 
 #ifdef CONFIG_ZSWAP
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 007413a53b45..32fb801530a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -341,6 +341,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAP_RAW,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1346,6 +1347,7 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
 	{ "zswapped",			MEMCG_ZSWAPPED			},
+	{ "zswpraw",			MEMCG_ZSWAP_RAW			},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -5458,6 +5460,8 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
 	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
+	if (zswap_is_raw(size))
+		mod_memcg_state(memcg, MEMCG_ZSWAP_RAW, 1);
 	rcu_read_unlock();
 }
 
@@ -5481,6 +5485,8 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
 	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
+	if (zswap_is_raw(size))
+		mod_memcg_state(memcg, MEMCG_ZSWAP_RAW, -1);
 	rcu_read_unlock();
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 3d2d59ac3f9c..54ab4d126f64 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -723,7 +723,7 @@ static void zswap_entry_free(struct zswap_entry *entry)
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
 		obj_cgroup_put(entry->objcg);
 	}
-	if (entry->length == PAGE_SIZE)
+	if (zswap_is_raw(entry->length))
 		atomic_long_dec(&zswap_stored_incompressible_pages);
 	zswap_entry_cache_free(entry);
 	atomic_long_dec(&zswap_stored_pages);
@@ -941,7 +941,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
-	if (entry->length == PAGE_SIZE) {
+	if (zswap_is_raw(entry->length)) {
 		WARN_ON_ONCE(input->length != PAGE_SIZE);
 		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
@@ -1448,7 +1448,7 @@ static bool zswap_store_page(struct page *page,
 		obj_cgroup_charge_zswap(objcg, entry->length);
 	}
 	atomic_long_inc(&zswap_stored_pages);
-	if (entry->length == PAGE_SIZE)
+	if (zswap_is_raw(entry->length))
 		atomic_long_inc(&zswap_stored_incompressible_pages);
 
 	/*
-- 
2.43.0


