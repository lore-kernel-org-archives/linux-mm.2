Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B875D64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49F46B00C1; Wed, 17 Dec 2025 02:34:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF74F6B00C3; Wed, 17 Dec 2025 02:34:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F66B6B00C4; Wed, 17 Dec 2025 02:34:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87A9A6B00C1
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:34:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54921136C63
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:32 +0000 (UTC)
X-FDA: 84228150384.23.FE70B07
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8745F160015
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UacKPeUo;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gN2incYyd3bEfYUDdyG/px7wt+Bzu1XD/CTk+F4CEY=;
	b=J9J+ekQy7fowMDuphP6n8OX1IhOHndblodkD35F9m+yFtLvEkq0ex7YqRMZ4WRiA1hcDxX
	IJGZQYDpHnoGd4MWGpRSNJHjiFzZ8cpp+oOFVFmzg27vG9QSBeiXSFGVkpZWmPx4NrH0LH
	dMMMtQZF5142xKxZUnUyljmvJNN9XYY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UacKPeUo;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956870; a=rsa-sha256;
	cv=none;
	b=tnPpRWggWWRdjqS7l75JuBDH+WFN1FLBczcwaybKl4CBNIprk0yUEC5c96dUU3Ps4Qbnde
	aPbJUIUvteQ01FX1+9irCFHy30VuWzEz4vYLhQoRg00Dz+x9ElJi2EOnGNBS6efNeRx20l
	vEBScEx80tHeqyX3tGToyig/M4NJ7pE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/gN2incYyd3bEfYUDdyG/px7wt+Bzu1XD/CTk+F4CEY=;
	b=UacKPeUoE72RU6WlaViTblNzq31GLZjQTFmJ8WgKimuCJhWC3wgTm5WfyBVq4iB2PkQtsA
	G36vivMut2LKuUW3ffrmaSX067rJSKhPz+rknuw8x3SdshYTtk+TKD2i+l0bTKSEKhZa2i
	/Q04oTEd9QyPMpOaTqpe0rOVtF61QZE=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 27/28] mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios
Date: Wed, 17 Dec 2025 15:27:51 +0800
Message-ID: <c08f964513f9eb6a04f80f1a900e3494a99b7e0d.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8745F160015
X-Stat-Signature: pq75fkfcgryw8q8xohc1rsdfpgkapqgy
X-Rspam-User: 
X-HE-Tag: 1765956870-361543
X-HE-Meta: U2FsdGVkX1+n35sLkIIXxT5gMyYMhLew+PnSwsRrDpdaVemFURj5yaj5tYhExvVeNIV/hb7zQECdto4ZMMUZ34MSba4sWz0grve8WegBDOvLo8La+yteS03RkB2/ZZXKuA0F1EK+x4leDgu0wkrPpb4V0gtTf5FXx69M4QqT/DzLBjr84jTvl5tbTjWDQRKcHWE16ojVJfpxQzsSgtCt74d8SuskiF3gJ0ppi9/2rL6nBWLYdXS0eHafyMXdk7ARymu3orO8zaUdQpm/Mg1JPV0lv44bMFyVB5lTahRL+ya3Q03I+1EYxuCDVxhSKgPIqtXn4MDQWxXkK6SzYVhXedxaKJDZa7TywMy1oxL/4BxWOwkxNCGxIA+wGPqGOyqkDufFIzzZ9jieuxRs9cUfFSEeW8Z23Yt7UGPAYmoPrscTRBsG27GIEoGBOQ0AkRQu3ig5nnhhP7ofM1sXWVDoluFafoJzlFeZGQusBVXjio6ftlv8rS5RrUIKI75qlGXjoQd+phwnK3nCrxKXTB5RDo+1vmQT5lBFmtOu2EY8BievOv3ivb33a/STHI2odeJBOpWi6/3QV2FdLwTlCXxx2ubQXjgE7nmbG7erspDMOaR5NB+nypGXCj4vAQpkRD7pVYrUCJ7QBUBpprzBT1aSecWmkfm3ByLMjtqSN7QaKZcIqsnj+v/HrDcwija6waY2m9eLLQ0IljBCPua7Luh2VzzjHHyuw+SpO4sLX3h4Ef2X6IiIbGnhnUy/2D6ELIk5D/iR+9KNSAaCqX8bkVCIcDHTJll7Hp9vs9DG53gXyXAZyGXmZvH1HIA1hLKHdbu/eKLDZScscD1/K1DVwRPgvxJWEx48jGpWYl8mx7iTYOhyfDzxqjgmNAItUXngpLRwmoaBiWWhIAYWQ3F1xW6oXnvJE0HK6i/4dxAECJPJj6yKB2kvOMM9roK14XizBRQL2p+KXSZ+4GxYcVuvKNX
 CXMoo7IY
 g24FDSZFlDTbH+meNVVIGfoZIjfZMG+0KFo1GeKygIZ670/ufhmVtPe7qpqjHjtc7Z8MiJKAQds05pWywQT+Ole/1gAlBIoa5e5M+197V3h+hi7THxFig0GvdnVSnHBnafv3A58brCzSWaNqjV8UMjuFy8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

Pagecache pages are charged at allocation time and hold a reference
to the original memory cgroup until reclaimed. Depending on memory
pressure, page sharing patterns between different cgroups and cgroup
creation/destruction rates, many dying memory cgroups can be pinned
by pagecache pages, reducing page reclaim efficiency and wasting
memory. Converting LRU folios and most other raw memory cgroup pins
to the object cgroup direction can fix this long-living problem.

Finally, folio->memcg_data of LRU folios and kmem folios will always
point to an object cgroup pointer. The folio->memcg_data of slab
folios will point to an vector of object cgroups.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/memcontrol.h |  77 +++++----------
 mm/memcontrol-v1.c         |  15 +--
 mm/memcontrol.c            | 189 +++++++++++++++++++++++--------------
 3 files changed, 150 insertions(+), 131 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 85265b28c5d18..9be52ce72f2c5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -369,9 +369,6 @@ enum objext_flags {
 #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
 
 #ifdef CONFIG_MEMCG
-
-static inline bool folio_memcg_kmem(struct folio *folio);
-
 /*
  * After the initialization objcg->memcg is always pointing at
  * a valid memcg, but can be atomically swapped to the parent memcg.
@@ -385,43 +382,19 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 }
 
 /*
- * __folio_memcg - Get the memory cgroup associated with a non-kmem folio
- * @folio: Pointer to the folio.
- *
- * Returns a pointer to the memory cgroup associated with the folio,
- * or NULL. This function assumes that the folio is known to have a
- * proper memory cgroup pointer. It's not safe to call this function
- * against some type of folios, e.g. slab folios or ex-slab folios or
- * kmem folios.
- */
-static inline struct mem_cgroup *__folio_memcg(struct folio *folio)
-{
-	unsigned long memcg_data = folio->memcg_data;
-
-	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
-	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJEXTS, folio);
-	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_KMEM, folio);
-
-	return (struct mem_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-}
-
-/*
- * __folio_objcg - get the object cgroup associated with a kmem folio.
+ * folio_objcg - get the object cgroup associated with a folio.
  * @folio: Pointer to the folio.
  *
  * Returns a pointer to the object cgroup associated with the folio,
  * or NULL. This function assumes that the folio is known to have a
- * proper object cgroup pointer. It's not safe to call this function
- * against some type of folios, e.g. slab folios or ex-slab folios or
- * LRU folios.
+ * proper object cgroup pointer.
  */
-static inline struct obj_cgroup *__folio_objcg(struct folio *folio)
+static inline struct obj_cgroup *folio_objcg(struct folio *folio)
 {
 	unsigned long memcg_data = folio->memcg_data;
 
 	VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
 	VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJEXTS, folio);
-	VM_BUG_ON_FOLIO(!(memcg_data & MEMCG_DATA_KMEM), folio);
 
 	return (struct obj_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 }
@@ -435,21 +408,30 @@ static inline struct obj_cgroup *__folio_objcg(struct folio *folio)
  * proper memory cgroup pointer. It's not safe to call this function
  * against some type of folios, e.g. slab folios or ex-slab folios.
  *
- * For a non-kmem folio any of the following ensures folio and memcg binding
- * stability:
+ * For a folio any of the following ensures folio and objcg binding stability:
  *
  * - the folio lock
  * - LRU isolation
  * - exclusive reference
  *
- * For a kmem folio a caller should hold an rcu read lock to protect memcg
- * associated with a kmem folio from being released.
+ * Based on the stable binding of folio and objcg, for a folio any of the
+ * following ensures folio and memcg binding stability:
+ *
+ * - cgroup_mutex
+ * - the lruvec lock
+ *
+ * If the caller only want to ensure that the page counters of memcg are
+ * updated correctly, ensure that the binding stability of folio and objcg
+ * is sufficient.
+ *
+ * Note: The caller should hold an rcu read lock or cgroup_mutex to protect
+ * memcg associated with a folio from being released.
  */
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
-	if (folio_memcg_kmem(folio))
-		return obj_cgroup_memcg(__folio_objcg(folio));
-	return __folio_memcg(folio);
+	struct obj_cgroup *objcg = folio_objcg(folio);
+
+	return objcg ? obj_cgroup_memcg(objcg) : NULL;
 }
 
 /*
@@ -473,15 +455,10 @@ static inline bool folio_memcg_charged(struct folio *folio)
  * has an associated memory cgroup pointer or an object cgroups vector or
  * an object cgroup.
  *
- * For a non-kmem folio any of the following ensures folio and memcg binding
- * stability:
+ * The page and objcg or memcg binding rules can refer to folio_memcg().
  *
- * - the folio lock
- * - LRU isolation
- * - exclusive reference
- *
- * For a kmem folio a caller should hold an rcu read lock to protect memcg
- * associated with a kmem folio from being released.
+ * A caller should hold an rcu read lock to protect memcg associated with a
+ * page from being released.
  */
 static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 {
@@ -490,18 +467,14 @@ static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 	 * for slabs, READ_ONCE() should be used here.
 	 */
 	unsigned long memcg_data = READ_ONCE(folio->memcg_data);
+	struct obj_cgroup *objcg;
 
 	if (memcg_data & MEMCG_DATA_OBJEXTS)
 		return NULL;
 
-	if (memcg_data & MEMCG_DATA_KMEM) {
-		struct obj_cgroup *objcg;
-
-		objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
-		return obj_cgroup_memcg(objcg);
-	}
+	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
 
-	return (struct mem_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
+	return objcg ? obj_cgroup_memcg(objcg) : NULL;
 }
 
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff7426..23c07df2063c8 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -591,6 +591,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 {
 	struct mem_cgroup *memcg, *swap_memcg;
+	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
@@ -602,12 +603,13 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	if (!do_memsw_account())
 		return;
 
-	memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
-	if (!memcg)
+	objcg = folio_objcg(folio);
+	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
+	if (!objcg)
 		return;
 
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
@@ -625,7 +627,7 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
 
-	if (!mem_cgroup_is_root(memcg))
+	if (!obj_cgroup_is_root(objcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
 	if (memcg != swap_memcg) {
@@ -646,7 +648,8 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	preempt_enable_nested();
 	memcg1_check_events(memcg, folio_nid(folio));
 
-	css_put(&memcg->css);
+	rcu_read_unlock();
+	obj_cgroup_put(objcg);
 }
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3daa99a0c65fe..cd2f0f0c0f5ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -223,22 +223,55 @@ static inline void __memcg_reparent_objcgs(struct mem_cgroup *src,
 
 static inline void reparent_locks(struct mem_cgroup *src, struct mem_cgroup *dst)
 {
+	int nid, nest = 0;
+
 	spin_lock_irq(&objcg_lock);
+	for_each_node(nid) {
+		spin_lock_nested(&mem_cgroup_lruvec(src,
+				 NODE_DATA(nid))->lru_lock, nest++);
+		spin_lock_nested(&mem_cgroup_lruvec(dst,
+				 NODE_DATA(nid))->lru_lock, nest++);
+	}
 }
 
 static inline void reparent_unlocks(struct mem_cgroup *src, struct mem_cgroup *dst)
 {
+	int nid;
+
+	for_each_node(nid) {
+		spin_unlock(&mem_cgroup_lruvec(dst, NODE_DATA(nid))->lru_lock);
+		spin_unlock(&mem_cgroup_lruvec(src, NODE_DATA(nid))->lru_lock);
+	}
 	spin_unlock_irq(&objcg_lock);
 }
 
+static void memcg_reparent_lru_folios(struct mem_cgroup *src,
+				      struct mem_cgroup *dst)
+{
+	if (lru_gen_enabled())
+		lru_gen_reparent_memcg(src, dst);
+	else
+		lru_reparent_memcg(src, dst);
+}
+
 static void memcg_reparent_objcgs(struct mem_cgroup *src)
 {
 	struct obj_cgroup *objcg = rcu_dereference_protected(src->objcg, true);
 	struct mem_cgroup *dst = parent_mem_cgroup(src);
 
+retry:
+	if (lru_gen_enabled())
+		max_lru_gen_memcg(dst);
+
 	reparent_locks(src, dst);
+	if (lru_gen_enabled() && !recheck_lru_gen_max_memcg(dst)) {
+		reparent_unlocks(src, dst);
+		cond_resched();
+		goto retry;
+	}
 
 	__memcg_reparent_objcgs(src, dst);
+	memcg_reparent_lru_folios(src, dst);
 
 	reparent_unlocks(src, dst);
 
@@ -989,6 +1022,8 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
 /**
  * get_mem_cgroup_from_folio - Obtain a reference on a given folio's memcg.
  * @folio: folio from which memcg should be extracted.
+ *
+ * The folio and objcg or memcg binding rules can refer to folio_memcg().
  */
 struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
 {
@@ -2557,17 +2592,17 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return try_charge_memcg(memcg, gfp_mask, nr_pages);
 }
 
-static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
+static void commit_charge(struct folio *folio, struct obj_cgroup *objcg)
 {
 	VM_BUG_ON_FOLIO(folio_memcg_charged(folio), folio);
 	/*
-	 * Any of the following ensures page's memcg stability:
+	 * Any of the following ensures folio's objcg stability:
 	 *
 	 * - the page lock
 	 * - LRU isolation
 	 * - exclusive reference
 	 */
-	folio->memcg_data = (unsigned long)memcg;
+	folio->memcg_data = (unsigned long)objcg;
 }
 
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
@@ -2671,6 +2706,17 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
 	return NULL;
 }
 
+static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
+{
+	struct obj_cgroup *objcg;
+
+	rcu_read_lock();
+	objcg = __get_obj_cgroup_from_memcg(memcg);
+	rcu_read_unlock();
+
+	return objcg;
+}
+
 static struct obj_cgroup *current_objcg_update(void)
 {
 	struct mem_cgroup *memcg;
@@ -2771,17 +2817,10 @@ struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_online())
-		return NULL;
-
-	if (folio_memcg_kmem(folio)) {
-		objcg = __folio_objcg(folio);
+	objcg = folio_objcg(folio);
+	if (objcg)
 		obj_cgroup_get(objcg);
-	} else {
-		rcu_read_lock();
-		objcg = __get_obj_cgroup_from_memcg(__folio_memcg(folio));
-		rcu_read_unlock();
-	}
+
 	return objcg;
 }
 
@@ -3288,7 +3327,7 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 		return;
 
 	new_refs = (1 << (old_order - new_order)) - 1;
-	css_get_many(&__folio_memcg(folio)->css, new_refs);
+	obj_cgroup_get_many(folio_objcg(folio), new_refs);
 }
 
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
@@ -4737,16 +4776,20 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 			gfp_t gfp)
 {
-	int ret;
-
-	ret = try_charge(memcg, gfp, folio_nr_pages(folio));
-	if (ret)
-		goto out;
+	int ret = 0;
+	struct obj_cgroup *objcg;
 
-	css_get(&memcg->css);
-	commit_charge(folio, memcg);
+	objcg = get_obj_cgroup_from_memcg(memcg);
+	/* Do not account at the root objcg level. */
+	if (!obj_cgroup_is_root(objcg))
+		ret = try_charge(memcg, gfp, folio_nr_pages(folio));
+	if (ret) {
+		obj_cgroup_put(objcg);
+		return ret;
+	}
+	commit_charge(folio, objcg);
 	memcg1_commit_charge(folio, memcg);
-out:
+
 	return ret;
 }
 
@@ -4832,7 +4875,7 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 }
 
 struct uncharge_gather {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
@@ -4846,58 +4889,52 @@ static inline void uncharge_gather_clear(struct uncharge_gather *ug)
 
 static void uncharge_batch(const struct uncharge_gather *ug)
 {
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(ug->objcg);
 	if (ug->nr_memory) {
-		memcg_uncharge(ug->memcg, ug->nr_memory);
+		memcg_uncharge(memcg, ug->nr_memory);
 		if (ug->nr_kmem) {
-			mod_memcg_state(ug->memcg, MEMCG_KMEM, -ug->nr_kmem);
-			memcg1_account_kmem(ug->memcg, -ug->nr_kmem);
+			mod_memcg_state(memcg, MEMCG_KMEM, -ug->nr_kmem);
+			memcg1_account_kmem(memcg, -ug->nr_kmem);
 		}
-		memcg1_oom_recover(ug->memcg);
+		memcg1_oom_recover(memcg);
 	}
 
-	memcg1_uncharge_batch(ug->memcg, ug->pgpgout, ug->nr_memory, ug->nid);
+	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory, ug->nid);
+	rcu_read_unlock();
 
 	/* drop reference from uncharge_folio */
-	css_put(&ug->memcg->css);
+	obj_cgroup_put(ug->objcg);
 }
 
 static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 {
 	long nr_pages;
-	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * folio memcg or objcg at this point, we have fully
-	 * exclusive access to the folio.
+	 * folio objcg at this point, we have fully exclusive
+	 * access to the folio.
 	 */
-	if (folio_memcg_kmem(folio)) {
-		objcg = __folio_objcg(folio);
-		/*
-		 * This get matches the put at the end of the function and
-		 * kmem pages do not hold memcg references anymore.
-		 */
-		memcg = get_mem_cgroup_from_objcg(objcg);
-	} else {
-		memcg = __folio_memcg(folio);
-	}
-
-	if (!memcg)
+	objcg = folio_objcg(folio);
+	if (!objcg)
 		return;
 
-	if (ug->memcg != memcg) {
-		if (ug->memcg) {
+	if (ug->objcg != objcg) {
+		if (ug->objcg) {
 			uncharge_batch(ug);
 			uncharge_gather_clear(ug);
 		}
-		ug->memcg = memcg;
+		ug->objcg = objcg;
 		ug->nid = folio_nid(folio);
 
-		/* pairs with css_put in uncharge_batch */
-		css_get(&memcg->css);
+		/* pairs with obj_cgroup_put in uncharge_batch */
+		obj_cgroup_get(objcg);
 	}
 
 	nr_pages = folio_nr_pages(folio);
@@ -4905,20 +4942,17 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 	if (folio_memcg_kmem(folio)) {
 		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
-
-		folio->memcg_data = 0;
-		obj_cgroup_put(objcg);
 	} else {
 		/* LRU pages aren't accounted at the root level */
-		if (!mem_cgroup_is_root(memcg))
+		if (!obj_cgroup_is_root(objcg))
 			ug->nr_memory += nr_pages;
 		ug->pgpgout++;
 
 		WARN_ON_ONCE(folio_unqueue_deferred_split(folio));
-		folio->memcg_data = 0;
 	}
 
-	css_put(&memcg->css);
+	folio->memcg_data = 0;
+	obj_cgroup_put(objcg);
 }
 
 void __mem_cgroup_uncharge(struct folio *folio)
@@ -4942,7 +4976,7 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 	uncharge_gather_clear(&ug);
 	for (i = 0; i < folios->nr; i++)
 		uncharge_folio(folios->folios[i], &ug);
-	if (ug.memcg)
+	if (ug.objcg)
 		uncharge_batch(&ug);
 }
 
@@ -4959,6 +4993,7 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 {
 	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 	long nr_pages = folio_nr_pages(new);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
@@ -4973,21 +5008,24 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	if (folio_memcg_charged(new))
 		return;
 
-	memcg = folio_memcg(old);
-	VM_WARN_ON_ONCE_FOLIO(!memcg, old);
-	if (!memcg)
+	objcg = folio_objcg(old);
+	VM_WARN_ON_ONCE_FOLIO(!objcg, old);
+	if (!objcg)
 		return;
 
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
 	/* Force-charge the new page. The old one will be freed soon */
-	if (!mem_cgroup_is_root(memcg)) {
+	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
 
-	css_get(&memcg->css);
-	commit_charge(new, memcg);
+	obj_cgroup_get(objcg);
+	commit_charge(new, objcg);
 	memcg1_commit_charge(new, memcg);
+	rcu_read_unlock();
 }
 
 /**
@@ -5003,7 +5041,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
  */
 void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
 	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
@@ -5014,18 +5052,18 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (mem_cgroup_disabled())
 		return;
 
-	memcg = folio_memcg(old);
+	objcg = folio_objcg(old);
 	/*
-	 * Note that it is normal to see !memcg for a hugetlb folio.
+	 * Note that it is normal to see !objcg for a hugetlb folio.
 	 * For e.g, itt could have been allocated when memory_hugetlb_accounting
 	 * was not selected.
 	 */
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(old) && !memcg, old);
-	if (!memcg)
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(old) && !objcg, old);
+	if (!objcg)
 		return;
 
-	/* Transfer the charge and the css ref */
-	commit_charge(new, memcg);
+	/* Transfer the charge and the objcg ref */
+	commit_charge(new, objcg);
 
 	/* Warning should never happen, so don't worry about refcount non-0 */
 	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
@@ -5200,22 +5238,27 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
 	if (do_memsw_account())
 		return 0;
 
-	memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
-	if (!memcg)
+	objcg = folio_objcg(folio);
+	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
+	if (!objcg)
 		return 0;
 
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
 	if (!entry.val) {
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		rcu_read_unlock();
 		return 0;
 	}
 
 	memcg = mem_cgroup_id_get_online(memcg);
+	/* memcg is pined by memcg ID. */
+	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
-- 
2.20.1


