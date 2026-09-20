Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC781C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3A96B00A7; Sun, 20 Sep 2026 03:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB2B6B00A9; Sun, 20 Sep 2026 03:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907926B00AA; Sun, 20 Sep 2026 03:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA736B00A7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:22:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FC461203FD
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:21 +0000 (UTC)
X-FDA: 85233297282.13.B8824BF
Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1FEBCA0004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888939;
	b=7DxdMZMRjLbPo1iTsMnZUphrzoaOGCMuayU7faJmXwQzJykh9rTTSFWfte0RPA/NXsJCsu
	zMrKemzyZwMd5+JJ2Krb6IOu/vyifR7rckQcRCy+3n1dQwhnrQT0AgLiZxEJlWTobx6904
	k418/mY86MpEqPR97Xka5Zs28jlf+dc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tr2bukTivR1BGPmPwj5F10lJbFNCjGagAsaEacwZ6H0=;
	b=g959QAcwxaytFwROStjlkeXcVkgyUuetEnuRTrMy4kE5LLxavaHj8B2YbhmC07SihT3dxn
	NERAtyevwnehGhPkisg43Rq9vKqx2oXCrhSB4CuVYm4QG+DFSfGdje//pl2jHql+QV9+0C
	LGMea8PDUR057VEWz9a1LamUtAnD1qI=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c6579a60f1fc76d4;
	Sun, 20 Sep 2026 07:22:13 +0000
X-Mizu-Trace-ID: c6579a60f1fc76d4
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 12/17] mm, swap: split the swap memcg charge helpers
Date: Sun, 20 Sep 2026 15:20:38 +0800
Message-ID: <20260920072043.430390-13-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FEBCA0004
X-Stat-Signature: muhm546ft5teb4eampaqou8spjk9oxej
X-Rspam-User: 
X-HE-Tag: 1789888938-664212
X-HE-Meta: U2FsdGVkX196k2vClgN2PqYTAy6GgelZZIVQ/K1Xr0Fa3fITKrahfA7Pcg5NBg9b+p6sOJYTYnFbgdh/IoVG/5xhGbqoLz3ffGdnS4ct53cBQobRryP2FDJOgwW2xd3buGPhgnPpBW0HkK9bSKmgnbwuIqiINiYHJrY2N8NyPpugVfIDSHcbxgYKAah4k9pPjCiu5l0zRbCKnZaKxj0kZimDHeAiUd0sFrDBKv3Sd6AJ+FgExMKBklt25QRE9FhwpNjR6Z4aoneyL/n8Wv+QY27eBQj0xfSgDc7r0y0f3QijvDwBBnknNe+9WHZ8VJoK93vybT5PZODNV5JqSgGj6ZtHDz5nM1C6KO1Spt3xAgPtbqrapAKzNsepu4TDzrXldJrumsJqpKQ3Ec5/zRZqlQvDfJb+8zRRhshgLfzT6fDh0YjpSkWvd/8j5lxynJnx0u8Y9+Zm8RIws/hpcpzYr8ok30goqD2SDLuvJTJH3TBo3HrN2WobspSy5K1XfYta2kPlByeF/OM209FklnAqO1kfXJTmIc1ltqgISGFnaHY1xG+uhbmj9/iHADrb9cGxuhxw06D90P1pNwLqq8f/W8639UJRmvyHRV3yPVoCv4m+AwHXRNrlRv676uJB3V9bThHOyroh/CfVPaazG7pQYKY9iZ3J4bRGYqLPX+aOrL7yOHjCXihpXIgg45ersROKixU0kSQlHLbgtka0hdVGWx7uDB8PUPS5AIokms7eL7RDw/ZAG1Z5ZrcD+fbweQMMrr4QEIz/MPsegpUfSjnsgoiWPiTOrmGG4PSw8XV3PGS8j4kV/88AGTbLUWoB1Mkr7uvCV1N6ZjU1mI6K66TfbZM10FOzMlQ+ZzRHawbaEphzR8m4Ghshy8AWu3lctfNJY9+qIwuQbArRJlzvpdmi2icIXBvIIx0uir3Ut5aIYhDEAqcZvfX2NeYnw0oq+JzJwCJYMWibDLDtK6Q/Sqd
 Q5X2uzzR
 xOc+K4ezT787WRLbEA5vkatc+J0iiFxywtI+AMK2CyATgHGik5sKwPasQM1QhEv8XfqUhV+H8DxAhHtlZXJ+1dDmrGg36zwZz591nqMIfQYr06CrpBfT193OMMap+mZZHHTq61/Y1SzboZopdgWcgHW6hlmm21qLsG8tITfGPJziYfbwhu8qxo3ZGiG2B3ZreVqS/pGmqs2zN6tAV6mNsTmkdEd7qbDcSuntC9EGcL/FKYxnRZBUMeDlPYzHaWhW0aMFEghc75613rNVcYoatipkYf9A1OEt8/nifl5QWTaKH9cHoDrgRJ7xPFdYF7l76Jj7/doaOpEu5M/zpDuzGSPKyX6yWe+zC0ghFqlC2tI/gM13H3L9vtaHvkPgL+TQwWYrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

Split __mem_cgroup_try_charge_swap() into separate get, charge, record,
uncharge and put helpers, and factor mem_cgroup_may_zswap() out of
obj_cgroup_may_zswap().  Recording the owner of a swap slot and charging
it no longer have to happen together, so a later patch can charge swap
only once it gets physical backing.

No functional change.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
 include/linux/memcontrol.h                    |   6 +
 include/linux/swap.h                          |  61 ++++++--
 mm/memcontrol-v1.c                            |  10 +-
 mm/memcontrol.c                               | 133 +++++++++++-------
 mm/swapfile.c                                 |  34 ++++-
 6 files changed, 181 insertions(+), 65 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memcg_test.rst b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
index d9951c319ef5..cd565626c435 100644
--- a/Documentation/admin-guide/cgroup-v1/memcg_test.rst
+++ b/Documentation/admin-guide/cgroup-v1/memcg_test.rst
@@ -43,7 +43,7 @@ Please note that implementation details can be changed.
 	mem_cgroup_uncharge()
 	  Called when a page's refcount goes down to 0.
 
-	mem_cgroup_uncharge_swap()
+	mem_cgroup_swap_uncharge()
 	  Called when swp_entry's refcnt goes down to 0. A charge against swap
 	  disappears.
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..4add06affefa 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1933,6 +1933,7 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
@@ -1941,6 +1942,11 @@ static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
 }
+
+static inline bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
+{
+	return true;
+}
 static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
 					   size_t size)
 {
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 188821b24e51..7ceac868a885 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -529,36 +529,81 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-int __mem_cgroup_try_charge_swap(struct folio *folio);
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+struct mem_cgroup *__mem_cgroup_swap_get(struct folio *folio);
+static inline struct mem_cgroup *mem_cgroup_swap_get(struct folio *folio)
+{
+	if (mem_cgroup_disabled())
+		return NULL;
+	return __mem_cgroup_swap_get(folio);
+}
+
+int __mem_cgroup_swap_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
+static inline int mem_cgroup_swap_charge(struct mem_cgroup *memcg,
+					 unsigned int nr_pages)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(folio);
+	return __mem_cgroup_swap_charge(memcg, nr_pages);
 }
 
-extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
-static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
+void __mem_cgroup_swap_record(struct folio *folio, struct mem_cgroup *memcg);
+static inline void mem_cgroup_swap_record(struct folio *folio,
+					  struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return;
-	__mem_cgroup_uncharge_swap(id, nr_pages);
+	__mem_cgroup_swap_record(folio, memcg);
+}
+
+void __mem_cgroup_swap_uncharge(struct mem_cgroup *memcg,
+				unsigned int nr_pages);
+static inline void mem_cgroup_swap_uncharge(struct mem_cgroup *memcg,
+					    unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_swap_uncharge(memcg, nr_pages);
+}
+
+void __mem_cgroup_swap_put(struct mem_cgroup *memcg, unsigned int nr_pages);
+static inline void mem_cgroup_swap_put(struct mem_cgroup *memcg,
+				       unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_swap_put(memcg, nr_pages);
 }
 
 long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
-static inline int mem_cgroup_try_charge_swap(struct folio *folio)
+static inline struct mem_cgroup *mem_cgroup_swap_get(struct folio *folio)
+{
+	return NULL;
+}
+
+static inline int mem_cgroup_swap_charge(struct mem_cgroup *memcg,
+					 unsigned int nr_pages)
 {
 	return 0;
 }
 
-static inline void mem_cgroup_uncharge_swap(unsigned short id,
+static inline void mem_cgroup_swap_record(struct folio *folio,
+					  struct mem_cgroup *memcg)
+{
+}
+
+static inline void mem_cgroup_swap_uncharge(struct mem_cgroup *memcg,
 					    unsigned int nr_pages)
 {
 }
 
+static inline void mem_cgroup_swap_put(struct mem_cgroup *memcg,
+				       unsigned int nr_pages)
+{
+}
+
 static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 {
 	return PAGE_COUNTER_MAX;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index bf2c7d53b01b..3e06a8bdf46e 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -341,6 +341,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 void memcg1_swapin(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
+	struct mem_cgroup *memcg;
 	unsigned long nr_pages;
 	unsigned short id;
 
@@ -372,7 +373,14 @@ void memcg1_swapin(struct folio *folio)
 	id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
 				 nr_pages);
 	swap_cluster_unlock(ci);
-	mem_cgroup_uncharge_swap(id, nr_pages);
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	if (memcg) {
+		mem_cgroup_swap_uncharge(memcg, nr_pages);
+		mem_cgroup_swap_put(memcg, nr_pages);
+	}
+	rcu_read_unlock();
 }
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..1d35b7ae8d70 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5926,80 +5926,111 @@ int __init mem_cgroup_init(void)
 
 #ifdef CONFIG_SWAP
 /**
- * __mem_cgroup_try_charge_swap - try charging swap space for a folio
+ * __mem_cgroup_swap_get - pin the memcg to account a folio's swap slots to
  * @folio: folio being added to swap
  *
- * Try to charge @folio's memcg for the swap space at folio->swap.
+ * Pins one private ID ref per page of @folio on its memcg, or on its closest
+ * online ancestor if it has been offlined. The caller charges and records
+ * against whichever memcg is returned, so both land on the same one.
  *
- * Returns 0 on success, -ENOMEM on failure.
+ * Return: the pinned memcg, or NULL if there is nothing to account. Drop the
+ * pins with __mem_cgroup_swap_put().
  */
-int __mem_cgroup_try_charge_swap(struct folio *folio)
+struct mem_cgroup *__mem_cgroup_swap_get(struct folio *folio)
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
-	struct swap_cluster_info *ci;
-	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 
 	if (do_memsw_account())
-		return 0;
+		return NULL;
 
 	objcg = folio_objcg(folio);
 	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
 	if (!objcg)
-		return 0;
+		return NULL;
 
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	if (!folio_test_swapcache(folio)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		rcu_read_unlock();
-		return 0;
+		return NULL;
 	}
 
 	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
 	/* memcg is pined by memcg ID. */
 	rcu_read_unlock();
 
+	return memcg;
+}
+
+/**
+ * __mem_cgroup_swap_charge - charge physical swap space
+ * @memcg: the mem_cgroup to charge (may be NULL)
+ * @nr_pages: the amount of swap space to charge
+ *
+ * Return: 0 on success, -ENOMEM if memory.swap.max is exceeded.
+ */
+int __mem_cgroup_swap_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	struct page_counter *counter;
+
+	if (do_memsw_account() || !memcg)
+		return 0;
+
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+	return 0;
+}
+
+/**
+ * __mem_cgroup_swap_record - record the owner of a folio's swap slots
+ * @folio: folio being added to swap
+ * @memcg: the memcg pinned by __mem_cgroup_swap_get()
+ */
+void __mem_cgroup_swap_record(struct folio *folio, struct mem_cgroup *memcg)
+{
+	struct swap_cluster_info *ci;
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap),
+			  folio_nr_pages(folio), mem_cgroup_private_id(memcg));
 	swap_cluster_unlock(ci);
-
-	return 0;
 }
 
 /**
- * __mem_cgroup_uncharge_swap - uncharge swap space
- * @id: cgroup id to uncharge
+ * __mem_cgroup_swap_uncharge - uncharge physical swap space
+ * @memcg: the mem_cgroup to uncharge (may be NULL)
  * @nr_pages: the amount of swap space to uncharge
  */
-void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
+void __mem_cgroup_swap_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	struct mem_cgroup *memcg;
+	if (!memcg)
+		return;
 
-	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
-	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
-			if (do_memsw_account())
-				page_counter_uncharge(&memcg->memsw, nr_pages);
-			else
-				page_counter_uncharge(&memcg->swap, nr_pages);
-		}
-		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+	if (!mem_cgroup_is_root(memcg)) {
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+		else
+			page_counter_uncharge(&memcg->swap, nr_pages);
 	}
-	rcu_read_unlock();
+	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+}
+
+/**
+ * __mem_cgroup_swap_put - drop the private ID refs taken for swap slots
+ * @memcg: the pinned mem_cgroup
+ * @nr_pages: number of refs to drop
+ */
+void __mem_cgroup_swap_put(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	mem_cgroup_private_id_put(memcg, nr_pages);
 }
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
@@ -6198,8 +6229,10 @@ static struct cftype swap_files[] = {
 
 #ifdef CONFIG_ZSWAP
 /**
- * obj_cgroup_may_zswap - check if this cgroup can zswap
- * @objcg: the object cgroup
+ * mem_cgroup_may_zswap - check if this cgroup can zswap
+ * @memcg: the memcg to query
+ * @may_flush: force-flush stats for an accurate check (sleeps). Pass false
+ *             from atomic contexts; the check is then best-effort.
  *
  * Check if the hierarchical zswap limit has been reached.
  *
@@ -6209,36 +6242,38 @@ static struct cftype swap_files[] = {
  * spending cycles on compression when there is already no room left
  * or zswap is disabled altogether somewhere in the hierarchy.
  */
-bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
 {
-	struct mem_cgroup *memcg, *original_memcg;
-	bool ret = true;
-
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 
-	original_memcg = get_mem_cgroup_from_objcg(objcg);
-	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
-	     memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long max = READ_ONCE(memcg->zswap_max);
 		unsigned long pages;
 
 		if (max == PAGE_COUNTER_MAX)
 			continue;
-		if (max == 0) {
-			ret = false;
-			break;
-		}
+		if (max == 0)
+			return false;
 
 		/* Force flush to get accurate stats for charging */
-		__mem_cgroup_flush_stats(memcg, true);
+		if (may_flush)
+			__mem_cgroup_flush_stats(memcg, true);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
-		if (pages < max)
-			continue;
-		ret = false;
-		break;
+		if (pages >= max)
+			return false;
 	}
-	mem_cgroup_put(original_memcg);
+	return true;
+}
+
+bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+	bool ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = mem_cgroup_may_zswap(memcg, true);
+	mem_cgroup_put(memcg);
 	return ret;
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 70ec544acd6b..7dcb4b48645d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1962,6 +1962,7 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	struct mem_cgroup *memcg;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1995,10 +1996,18 @@ int folio_alloc_swap(struct folio *folio)
 			goto again;
 	}
 
-	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
-		swap_cache_del_folio(folio);
-		goto failed;
+	/*
+	 * Need to call this even if allocation failed, for MEMCG_SWAP_FAIL.
+	 * The memcg is pinned here, then charged and recorded.
+	 */
+	memcg = mem_cgroup_swap_get(folio);
+	if (memcg) {
+		if (unlikely(mem_cgroup_swap_charge(memcg, size))) {
+			mem_cgroup_swap_put(memcg, size);
+			swap_cache_del_folio(folio);
+			goto failed;
+		}
+		mem_cgroup_swap_record(folio, memcg);
 	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
@@ -2144,6 +2153,19 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return ERR_PTR(-EIO);
 }
 
+static void memcg_swap_free(unsigned short id, unsigned int nr)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	if (memcg) {
+		mem_cgroup_swap_uncharge(memcg, nr);
+		mem_cgroup_swap_put(memcg, nr);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * Free a set of swap slots after their swap count dropped to zero, or will be
  * zero after putting the last ref (saves one __swap_cluster_put_entry call).
@@ -2186,14 +2208,14 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (batch_id != id_cur) {
 			if (batch_id)
-				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+				memcg_swap_free(batch_id, ci_off - batch_off);
 			batch_id = id_cur;
 			batch_off = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
 	if (batch_id)
-		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+		memcg_swap_free(batch_id, ci_off - batch_off);
 
 	swap_range_free(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
-- 
2.54.0


