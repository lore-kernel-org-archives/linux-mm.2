Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11E1FC5921
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0D76B020C; Thu, 26 Feb 2026 14:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85BE6B020D; Thu, 26 Feb 2026 14:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09806B020E; Thu, 26 Feb 2026 14:29:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A66DE6B020C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 693EB140222
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:50 +0000 (UTC)
X-FDA: 84487597740.10.BC79968
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 84FAD40006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M7zWiiYJ;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEfEA70JNXawqJbV01nYPcSs1BoCcq++8AXelGDLMgg=;
	b=rIY8sOvls384+Sl76Q99zFx2lp8NMb4VUw5RHbuSY91MADo5uYlTUslliFqSlkq1O7yz2/
	iRA1IUfhb+eI6UC9fjArOb1RS0w1M6dPQLYFD42J8MirWN0IJd6LW09sCENyJkHlGOuZXg
	sNNCx4aKBKwBBHuQpdR3nEpRzkxVnzg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M7zWiiYJ;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134188; a=rsa-sha256;
	cv=none;
	b=iJhAlojCH/tXYygv/1wfvECbi1uH755os622JsN/jYh0lH4h0RFFq5OmQ0d0WEjCSJT3wo
	Lc5MPZZdd6Alp0VyhOkyoo9YfbaK/6BpfeZBRgGa2oxNPYfqvvKmyh+JjXVehCJiu1hbx9
	rU7x8peiNxPwYHv4QWqLlqiu9Geattg=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d1872504cbso1208545a34.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134187; x=1772738987; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEfEA70JNXawqJbV01nYPcSs1BoCcq++8AXelGDLMgg=;
        b=M7zWiiYJFlQxiwJSxjBUJCIkaKecPNkFlKf0Z9MrVQsFftrmHrBm7DpEqY7bp+lZT2
         uEYjzJEkAtV2xa1MpltASgJRtZfpxER7TQT2h+3TJw70Eeweex6e0po52P5/cfUm38Vf
         wBj2yyVXhX5Oyt3lkEDEcV3orVE1VyQEJCv3zv4KD4SYOk/0nuVTfPzXVr1Hh9q1ael3
         AR6NbsMMwDB34EZzJiMh0Cu+7U47AjzC1cMmEHGXB4Rz3ECjDX9nNIJiU4ObQmfCZdmF
         Emim47nems5sV9rXtjDtrW/ZwXXEJyeqZedgvveFxtoEXj0GzXfpnBrf2RDocTwASu0g
         1Tbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134187; x=1772738987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oEfEA70JNXawqJbV01nYPcSs1BoCcq++8AXelGDLMgg=;
        b=rUfl8X82h30JQbSlMF/+sDSP8wEgtYBYzm3YubAfnHStYWnsFt/gLSnerv0H+cgF4u
         Y80j4s5yXtdPVFd6BVp4ZCI95IdGK2Z8RnwHRM6L2h80/wi5RAxeUNdaFl1xTq5jvIQk
         yR7m+oe3PwmmCFwPxPeOVmIuY3V9gNo7bMWC4iVng5rC/EWB7w+3+eOQ+iHQSgaH/T8W
         AXkP0Jga/ZHS+sWa791TiK1hOKDokJ2oywAxqnJUFvNMNykVofJhwuP9pRcXlxzHmBXM
         gtk/aKzYtXi5TuuZ+D49VXqFkRNEIHQ15E2ZVVkjb2rc6vsUyPIp4tQlwkRWOIL9C/K3
         wiAw==
X-Forwarded-Encrypted: i=1; AJvYcCUhUuhpwgtNCoLlc7giJpgcLptRPwPagPAPv/dAL56bU/y4a/Vj7/TeSmGcofba5KxJBLTyKlXxAg==@kvack.org
X-Gm-Message-State: AOJu0Yyz5LbvdojoCCeIvnVKcK9sI7Ybnz5OesfNnMlPo6didQjHM1qd
	wCD7gqC1xfOyLnLFATzp9zspLhH8KTW9RyYsK9FkOwRPBn4jj9DGJ2g+
X-Gm-Gg: ATEYQzzJiwWbYmfM7O32A5Hhkrr4DGMqHF5iohFxYzzWAq2pVJuCKI+4tzSavHRCSlD
	M0JcpUvB8T6wvoXMX8Xqv0VYecOlEZQy6i8fGQvEMLyoHNbq8JmQZfYxoZ+Esn8dUteYy7Joe9Y
	fqCM4jX65LNFTRpwU0dOJ+E5BLA5UUotNfAl1ShAs8EHHw8TdR52qUZ6qrhOef5KEcjqU2niglR
	F+kSGxv14VVJuoOiKt5e+OtqdQOSTpskPCKUid+hBmrr0i+kBxhiitXY8s7DlWWgbQwH1dCDS3j
	OKalit+VV6Y2WljBruPIC2y+PkqKHHpYs+XQjsnR4EB4PGfWSJs0BLFIgGzNBF4FBLpKiOTiw1g
	6/C5h2mMG8fhiguvUVxvntvsDHakpyceX6jmnTAxxF/nM8nQYRq6mmOFuQ3tJIfBVFHneIC8Xmf
	smTpYB+rgUfrY6VuUgDfitWw==
X-Received: by 2002:a05:6830:3986:b0:7c7:48b7:640a with SMTP id 46e09a7af769-7d5856d877bmr2357295a34.7.1772134187538;
        Thu, 26 Feb 2026 11:29:47 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d58644d426sm2404272a34.3.2026.02.26.11.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:47 -0800 (PST)
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
Subject: [PATCH 5/8] mm/zsmalloc,zswap: Redirect zswap_entry->obcg to zpdesc
Date: Thu, 26 Feb 2026 11:29:28 -0800
Message-ID: <20260226192936.3190275-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h3gctnbduexb37hs4uucoyxxq9he7gx4
X-Rspam-User: 
X-Rspamd-Queue-Id: 84FAD40006
X-Rspamd-Server: rspam04
X-HE-Tag: 1772134188-34852
X-HE-Meta: U2FsdGVkX1/hxpWRIEfmXkxQ4sqabEWMMcC+pxts0dm4VOqGvNHtYzcYnWrZWo+k8Xwce6hVJ2FX8qbotHMitmSUATim+EHfPVm/bRNpjWOZiAp2NieDRWGsjeoItt56jY9M88mCranqrA2uhnouNJG2U+4I0CO0EaZ/4HOB7J0tuSyLEPo2yEPdrxPQhQbJGVxAoqagZdyOckb6HAIw2Y2n6SrEpUrXxQZFoV5su3o3F63HtorqfiO6DCC1HcKQHlLfR2sb3YSjwX2h6VQy9+iB/TK1RYe7njXcYlbI10+XrfXBEo1L40PB66zOi4ln0/Ha3ednpSt7z+5uFSqfui2PIf11k24MfmNfkJGdzRi7UjWhmO3SU7ODvOMPdgO/j7GK3N7ak88VOBTm6A2FS19sdh3VYwmAL0m1Cs5koH93I/G7K61uXdX6n1wNgOVXmS7xSSRGBxtyt/G2jwWYhRgJsBgVAohpTG/8MFM+oPgCSq9yEjdSLHbF6vCZfpM395ccT3GFCvE/9hX8OFNOvBcJ1SBT136JIxzlcet417wFVrhrtz5F8PGPPDKIBmQZn2giWlComJ/Rn/xj9i7rzZW7wLhsvQKgffQaP+kLrfndOa74eNWnDCTVcA5G60B8kaq21Z7ufsq9C16I45Sa0Qt7OOQjHp1H2GgZkBWNQPSLmfhep/3MFxxwuNbuQNxFad1gOh2NZOcUvJOj4xe+7ar1VyI80HvKxJOBkH6LeCLN/nQuP+H34PDraBy7P3RaRPZmrF5GJkkD086Ex4XtS//28Zi1Sr6wv31pVJbrlLnhRRGmx+MQf/2zPArrBn7XJOiw6Se0A4LFrAbDuTi8vuvBrtqBa+PqhJW7D3a6v8lSKNnnSjURtNF9/rG1ggkHiJ6PNNQ7AXD34oAKHZgMcbc67oIaxjGDFdQgM2Z56GYJWpW5HDII/+VvFeHNPW5t4OzfX4xlSCqVFjdkOuB
 5uV24o9I
 Ioouz7WhX0WAla1AesIMLF5rENYX6I7jV0wPJZdhVYplnXmY4RAvZ4f/Lm4DOA4pt5Xvlj0uCM+GxpHizzU+KR8d6h7RMuddCIHszsPi7gLikDBFIQyhUH27REUJffLEONpMxKVn9v0lsoexNQRGs/iNhrERVTtrFRw9iEBOHke2mPXiE9/WbSGDpCs0PD+wTAkpf+zwJIQauXV8QbOi8wAYQdZiN3uMzWfwZUpKxvJtXJ6Bp+AFCIo+h31eqdZ06gp6qtjAshxEyGn6e3S+JqrcawARY821MOn6duVEdHrymLJSJzLksBCYw8Ue7iCEXOWeOb2bIWhXB4Uxmbobyh4V+iMQ/lOHW2I9m+fCMkADukWrCXvk8JbZ4LIVTCfsstCJplw8IoJ9x0IdcgR4wLlChOkaWSCK4ZHw8y9o0lRoRNhbY1v56FjXJ4stOOIp9DLRjKae8v47h+eLgDKWmpeDevM/tvbtZNl5unPDFONHsGKdgMksgKYn20esx5TFGgFtcVcyU+acEFqjIAAn165FQb1hOKUylKNVScZxGD5NyJJGyGpUYOtp8l8PCQQKt4tK/YoIdKLW+wa10fLwx6NhUPD96vKvyN6DE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that obj_cgroups are tracked in zpdesc, redirect the zswap layer to
use the pointer stored in the zpdesc and remove the pointer in
struct zswap_entry.

This offsets the temporary memory increase caused by the duplicate
storage of the obj_cgroup pointer and results in a net zero memory
footprint change. The lifetime and charging of the obj_cgroup is still
handled in the zswap layer.

Clean up mem_cgroup_from_entry, which has no more callers.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/zsmalloc.h |  1 +
 mm/zsmalloc.c            | 29 +++++++++++++++++++++++
 mm/zswap.c               | 51 ++++++++++++++++++----------------------
 3 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 22f3baa13f24..05b2b163a427 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -38,6 +38,7 @@ unsigned long zs_get_total_pages(struct zs_pool *pool);
 unsigned long zs_compact(struct zs_pool *pool);
 
 unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size);
+struct obj_cgroup *zs_lookup_objcg(struct zs_pool *pool, unsigned long handle);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index e5ae9a0fc78a..067215a6ddcc 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -977,6 +977,30 @@ static void migrate_obj_objcg(unsigned long used_obj, unsigned long free_obj,
 	zpdesc_set_obj_cgroup(d_zpdesc, d_obj_idx, size, objcg);
 	zpdesc_set_obj_cgroup(s_zpdesc, s_obj_idx, size, NULL);
 }
+
+struct obj_cgroup *zs_lookup_objcg(struct zs_pool *pool, unsigned long handle)
+{
+	unsigned long obj;
+	struct zpdesc *zpdesc;
+	struct zspage *zspage;
+	struct size_class *class;
+	struct obj_cgroup *objcg;
+	unsigned int obj_idx;
+
+	read_lock(&pool->lock);
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+
+	zspage = get_zspage(zpdesc);
+	zspage_read_lock(zspage);
+	read_unlock(&pool->lock);
+
+	class = zspage_class(pool, zspage);
+	objcg = zpdesc_obj_cgroup(zpdesc, obj_idx, class->size);
+	zspage_read_unlock(zspage);
+
+	return objcg;
+}
 #else
 static inline struct obj_cgroup *zpdesc_obj_cgroup(struct zpdesc *zpdesc,
 						   unsigned int offset,
@@ -996,6 +1020,11 @@ static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
 
 static void migrate_obj_objcg(unsigned long used_obj, unsigned long free_obj,
 			      int size) {}
+
+struct obj_cgroup *zs_lookup_objcg(struct zs_pool *pool, unsigned long handle)
+{
+	return NULL;
+}
 #endif
 
 static void create_page_chain(struct size_class *class, struct zspage *zspage,
diff --git a/mm/zswap.c b/mm/zswap.c
index 1e2d60f47919..55161a5c9d4c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -193,7 +193,6 @@ struct zswap_entry {
 	bool referenced;
 	struct zswap_pool *pool;
 	unsigned long handle;
-	struct obj_cgroup *objcg;
 	struct list_head lru;
 };
 
@@ -601,25 +600,13 @@ static int zswap_enabled_param_set(const char *val,
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
@@ -636,19 +623,20 @@ static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
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
@@ -716,12 +704,16 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
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
+
+	if (objcg) {
+		obj_cgroup_uncharge_zswap(objcg, entry->length);
+		obj_cgroup_put(objcg);
 	}
 	if (entry->length == PAGE_SIZE)
 		atomic_long_dec(&zswap_stored_incompressible_pages);
@@ -994,6 +986,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	struct mempolicy *mpol;
 	bool folio_was_allocated;
 	struct swap_info_struct *si;
+	struct obj_cgroup *objcg;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1043,8 +1036,9 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	xa_erase(tree, offset);
 
 	count_vm_event(ZSWPWB);
-	if (entry->objcg)
-		count_objcg_events(entry->objcg, ZSWPWB, 1);
+	objcg = zs_lookup_objcg(entry->pool->zs_pool, entry->handle);
+	if (objcg)
+		count_objcg_events(objcg, ZSWPWB, 1);
 
 	zswap_entry_free(entry);
 
@@ -1463,11 +1457,10 @@ static bool zswap_store_page(struct page *page,
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
@@ -1592,6 +1585,7 @@ int zswap_load(struct folio *folio)
 	bool swapcache = folio_test_swapcache(folio);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
+	struct obj_cgroup *objcg;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
@@ -1620,8 +1614,9 @@ int zswap_load(struct folio *folio)
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
2.47.3


