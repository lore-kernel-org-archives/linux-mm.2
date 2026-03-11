Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C591125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29FF16B0095; Wed, 11 Mar 2026 15:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284AE6B0096; Wed, 11 Mar 2026 15:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B6A6B0098; Wed, 11 Mar 2026 15:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E83D16B0095
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E6B1140378
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:05 +0000 (UTC)
X-FDA: 84534828210.15.366627D
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id F41D3100017
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cz5Xz508;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLnaCWh6dwryZ7JtF26SIxlcfvOnnhqkpWeywtzyEhI=;
	b=DYClT8GFCdJCEN3KjrL9Yuv8JFORm45OS45y03EFDxpI2PvnZqgbHFc20eXNnEkdHdiRtb
	ZYAkrFx2WnYXfkxKT0LWwOT67FtObeKi7XIHlSFML27CBAGTdGYRW/xGZlAZLcFxWoFW7k
	jq/tqQc7tYoR8WDrkyCTcCJZOkOP8rQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258724; a=rsa-sha256;
	cv=none;
	b=b/1+je5FP7MeU6wi6cZrFXYZDouHjfQCrB9pSxiGd5hefcMhv/0O9mj3O9qllFYiljl6HK
	QwGOshnbqnIMb4j8FpaPn5mAb9jmPtstwxeTLcePbBTExXCqRAEyo9aG+Uviv6PtNfYeZS
	e5lE7WOF7NRdBmLBPrQl5eXq3ERbOm4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cz5Xz508;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d75e74f5adso327915a34.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258723; x=1773863523; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLnaCWh6dwryZ7JtF26SIxlcfvOnnhqkpWeywtzyEhI=;
        b=Cz5Xz508SCxFPtWzV7FfJJkYfnDcCSMLi6eLeOWFzjudec5dOMrhXcKY0lAiMvI1t5
         awIrbzEPU/3dCMrXWd8xvoDPQs/imffwaDX0Zipmji+7r6qrWIW+y6nZBK62TevTjEfT
         5WhBaQniqieZ/DTD8ErY4IY0sb2LkYYCvi0BJV4ZOpZ1yyCx3L0D3VdamcvuPl+ov6Hw
         cYwGE6iVSdAnadxwD6NuIsZxZZqO0Jcw0zWgduMk1NsJzFAtVoUqv1jKR41Mv7Lm5JW+
         5v4MJZk0oe5DuTEyfv+PozF5lgQvFxjCNsXdFOSWI/0Kz7M/5nSx5A7nebcZYEbDRLvU
         IjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258723; x=1773863523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yLnaCWh6dwryZ7JtF26SIxlcfvOnnhqkpWeywtzyEhI=;
        b=BGomSu2ac8szdqfiRlO0CeeSBQk9zj3MJ6yTOI/cSDqAN9vYH8I1dNaLOKzbTek684
         EXjDayp2dZOHShIZ5ApQxTvGtxmhil9t9oeeDYSut0oWrS/4Sg+zthNA8iCZsDuOIp2j
         66CiY0BGbxMqINwTUA225d+CL0q2ZRvmLrI4V9Kri8C7GbgkDG4OZk6xRsDdU8b0X5Bq
         swTE4K/BNKQbKEFvGJ/kt6Td7nPLIFt4lbH3PJASYeZV/yYQYw/n+DCTY2WRgZKO3BC5
         zj/2/bprHa0da5oc31grz9IEk59RxaJjC7J1KbYBqHvo6rPYlWAhrjMf5rDLimyGotIb
         bMKA==
X-Forwarded-Encrypted: i=1; AJvYcCXmq8vFqdSCBew2AJqyQYKQFtGOa1O6z+PPfYsQLtXA0exHZOoy13Il6mAm+pr2hcA5GXf9Iw6Z2g==@kvack.org
X-Gm-Message-State: AOJu0Yyl8GbznW6coChygEYL6bKi5+KIspa6/wT29zxXPmC4s9Osd1K4
	+KZuCnccFF5IQzMydJeGg4Y2RIDN9s+PKLq5WrGKtdLr6nasahfaspYP
X-Gm-Gg: ATEYQzxRN0PqJ+u06ek2di8FwjVkbOJOlr0VxBvrCyQlS8ZR3z07+7PgCiSfcvXJNoa
	kUM+W6Fu/Dqzyo3On1M++BB89/oLmTI75d51wi8dMWVabzXllZnBuuDZCCE6V765/NCvb7BnjsZ
	PBo+7nbrc3GRBNfyPkGxLve+krbuOOlOYveUEsYvvPonDjmJGPBgE4TSyH1dqEtADub+x5sqD40
	DCR41Rg0RTvpJr3Cfp3v4CwPKQmgUjC+wPSDtkRmL6JlUrNqe6eVIMi5FFQV5JIIuG5wF0im++X
	sMfwmPMJfIp3c8TqqyWyXtEuAtyDmgA4lUK6gFi4AhpoHXSKBE408TiPnr/LgQfn406fG8TlmuI
	u1OQr5bR9phmh+M8MeUQ+jGaQCYonutSa3bzWCkA99GjsywP3QJTZHDus5zseN1bxvA0Lp75X0b
	snCRgOCgMECJcvPam77QpBMQ==
X-Received: by 2002:a05:6830:449f:b0:7d7:551b:aeeb with SMTP id 46e09a7af769-7d76a4c6880mr2823367a34.0.1773258722891;
        Wed, 11 Mar 2026 12:52:02 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7749f1f5csm680280a34.6.2026.03.11.12.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:52:02 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 06/11] mm/zsmalloc, zswap: Redirect zswap_entry->objcg to zspage
Date: Wed, 11 Mar 2026 12:51:43 -0700
Message-ID: <20260311195153.4013476-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F41D3100017
X-Stat-Signature: agzyc5ugchfu5nbpio54if1omi3ztq5f
X-Rspam-User: 
X-HE-Tag: 1773258723-114829
X-HE-Meta: U2FsdGVkX1/oOw/hApyeLXtcaAaIDUArzDldMd/2fQV2Io9TIaFeZAcxVujmItEFnx1qEfdoRgEE0sHvqRU26Ca40iPpy9PlxVAbY0fGKnnhpTCYILhZwwDjJQ8UUdMdTtSh+2A38yhHpc2eLJx+Cw2BZX+zLl2Gltk+VRasWslWakIOMAcPqu3rcORCc8L8Yow3sfe5qhQJniZHa7/enAff2kGSWgTmlc8EaNBgBC4T9lYrvjfL30ZBgtpQNCdpQALefKhE9FzI0QESGbBxJR8HL3c6NFIyEsBpmCJ5sJQY9g8KbVIYrO/Ln5j1YGAH3MaQiEHeDF/dTafTJlYZBU0PQgCNddteWAbgJbwtHjnje4RlJmebMtP05IE0klRYf6fuxlVIVSoY5EK9+JyHzDVswnnIC6Av1Gvq+976ktUR5uCrHFGRIrA/V6q/ZaTAfyMuip+7Fc9waHvBGZTulTZJPMxqiFZor5PXwvb7mX7dd24shDueIXWhHYylkudNf0qgPbU7DE0RoQXmH3gBk0cfuga7xoKiXM6joo1nezBF01J7P5NFBBBXi3RJrp7/WRW/IkJSmX9AvdgbVlqP104dY05UnDIjIhJwP3ekiPcDVsyWEsC43OxMRsQroTMGZK8DyZrCYlwqhtgG+WgGP2KK0lAljgmAfPKbk0LgspSYYCw+ayE7g87MYHpxGcfML4gSac3M2lP0rQ79wgzU2lXbk1VJwefZKWeJUN6gJZNL9nrsKW5UwjM5eHwgGm9dRa+tRXat+zcjKe4ISEyVkr74SZ3Y8z9W0YyCmsYTLXHyR3P7OTi6qdAC9zIRreYmtLoYsPHvB/TmGU4tFvhi7Cp69dNSvzpEW/KBJqd+hRJeb78ZK3RQNkq9/hWaJv1AGjgyooi7SVzUE4OlUpWS9ARtcR9xS1Ea22PVij0wvuC+qqMy13S65PR5B/fQPNQgvchsd0mAdyjEaIaMZ+r
 aNTt3JwB
 ndTJz4F18IDw0AuMZgIpL7amdGpBZTnf9spBYBMH0vyHmci8iEgzK/32WHX29teH5GfMFNn6sbgh9lPYDljtEX4q1REzupeiqly38jpvjvgqKhoh0U3Uit/Mge4xCsoy3bqQE5q3GDnSSkj2UVzeuzlZiJwoApF9rltLUastb3H1fr/y7Z6a9givp2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that obj_cgroups are tracked in the zspage, redirect the zswap layer
to use the pointer stored in the zspage and remove the pointer in
struct zswap_entry.

This offsets the temporary memory increase caused by the duplicate
storage of the obj_cgroup pointer and results in a net zero memory
footprint change (aside from the array pointer and flags in zspage).

The lifetime and charging of the obj_cgroup is still handled in the
zswap layer.

Clean up mem_cgroup_from_entry, which has no remaining callers.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  5 ++++
 include/linux/zsmalloc.h   |  1 +
 mm/zsmalloc.c              | 25 +++++++++++++++++++
 mm/zswap.c                 | 50 +++++++++++++++++---------------------
 4 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 70b685a85bf4..0652db4ff2d5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1072,6 +1072,11 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
 	return NULL;
 }
 
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+{
+	return NULL;
+}
+
 static inline bool folio_memcg_kmem(struct folio *folio)
 {
 	return false;
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 645957a156c4..6010d8dac9ff 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -41,6 +41,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool);
 unsigned long zs_compact(struct zs_pool *pool);
 
 unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
+struct obj_cgroup *zs_lookup_objcg(struct zs_pool *pool, unsigned long handle);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index d4735451c273..a94ca8c26ad9 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1049,6 +1049,31 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size)
 }
 EXPORT_SYMBOL_GPL(zs_lookup_class_index);
 
+struct obj_cgroup *zs_lookup_objcg(struct zs_pool *pool, unsigned long handle)
+{
+	unsigned long obj;
+	struct zpdesc *zpdesc;
+	struct zspage *zspage;
+	struct obj_cgroup *objcg;
+	unsigned int obj_idx;
+
+	if (!pool->memcg_aware)
+		return NULL;
+
+	read_lock(&pool->lock);
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+
+	zspage = get_zspage(zpdesc);
+	zspage_read_lock(zspage);
+	read_unlock(&pool->lock);
+
+	objcg = zspage->objcgs[obj_idx];
+	zspage_read_unlock(zspage);
+
+	return objcg;
+}
+
 unsigned long zs_get_total_pages(struct zs_pool *pool)
 {
 	return atomic_long_read(&pool->pages_allocated);
diff --git a/mm/zswap.c b/mm/zswap.c
index 68b87c3cc326..436066965413 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -193,7 +193,6 @@ struct zswap_entry {
 	bool referenced;
 	struct zswap_pool *pool;
 	unsigned long handle;
-	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
 
@@ -602,25 +601,13 @@ static int zswap_enabled_param_set(const char *val,
 * lru functions
 **********************************/
 
-/* should be called under RCU */
-#ifdef CONFIG_MEMCG
-static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
-{
-	return entry->objcg ? obj_cgroup_memcg(entry->objcg) : NULL;
-}
-#else
-static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry)
-{
-	return NULL;
-}
-#endif
-
 static inline int entry_to_nid(struct zswap_entry *entry)
 {
 	return page_to_nid(virt_to_page(entry));
 }
 
-static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
+static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry,
+			  struct obj_cgroup *objcg)
 {
 	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
@@ -637,19 +624,20 @@ static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
 	 * Similar reasoning holds for list_lru_del().
 	 */
 	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
+	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
 	/* will always succeed */
 	list_lru_add(list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
 }
 
-static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entry *entry)
+static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entry *entry,
+			  struct obj_cgroup *objcg)
 {
 	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_entry(entry);
+	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
 	/* will always succeed */
 	list_lru_del(list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
@@ -717,12 +705,15 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
-	zswap_lru_del(&zswap_list_lru, entry);
+	struct obj_cgroup *objcg = zs_lookup_objcg(entry->pool->zs_pool,
+						   entry->handle);
+
+	zswap_lru_del(&zswap_list_lru, entry, objcg);
 	zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
-	if (entry->objcg) {
-		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
-		obj_cgroup_put(entry->objcg);
+	if (objcg) {
+		obj_cgroup_uncharge_zswap(objcg, entry->length);
+		obj_cgroup_put(objcg);
 	}
 	if (entry->length == PAGE_SIZE)
 		atomic_long_dec(&zswap_stored_incompressible_pages);
@@ -995,6 +986,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
 	struct swap_info_struct *si;
+	struct obj_cgroup *objcg;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1044,8 +1036,9 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	xa_erase(tree, offset);
 
 	count_vm_event(ZSWPWB);
-	if (entry->objcg)
-		count_objcg_events(entry->objcg, ZSWPWB, 1);
+	objcg = zs_lookup_objcg(entry->pool->zs_pool, entry->handle);
+	if (objcg)
+		count_objcg_events(objcg, ZSWPWB, 1);
 
 	zswap_entry_free(entry);
 
@@ -1464,11 +1457,10 @@ static bool zswap_store_page(struct page *page,
 	 */
 	entry->pool = pool;
 	entry->swpentry = page_swpentry;
-	entry->objcg = objcg;
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&zswap_list_lru, entry);
+		zswap_lru_add(&zswap_list_lru, entry, objcg);
 	}
 
 	return true;
@@ -1593,6 +1585,7 @@ int zswap_load(struct folio *folio)
 	bool swapcache = folio_test_swapcache(folio);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
+	struct obj_cgroup *objcg;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
@@ -1621,8 +1614,9 @@ int zswap_load(struct folio *folio)
 	folio_mark_uptodate(folio);
 
 	count_vm_event(ZSWPIN);
-	if (entry->objcg)
-		count_objcg_events(entry->objcg, ZSWPIN, 1);
+	objcg = zs_lookup_objcg(entry->pool->zs_pool, entry->handle);
+	if (objcg)
+		count_objcg_events(objcg, ZSWPIN, 1);
 
 	/*
 	 * When reading into the swapcache, invalidate our entry. The
-- 
2.52.0


