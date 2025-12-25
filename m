Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE751E7AD73
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546826B0089; Thu, 25 Dec 2025 18:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA1F6B008A; Thu, 25 Dec 2025 18:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFF16B008C; Thu, 25 Dec 2025 18:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B10B6B0089
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:21:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D56431605B5
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:29 +0000 (UTC)
X-FDA: 84259567098.26.119FE2B
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 30558180010
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ts2+6/GS";
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766704888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMuFk6SfrgNzCfHXzFMzuHFFLdc/IVuMulpjk+slEIw=;
	b=MXps1fLClGfHFczW/pRHlIfcENb3z4qndPD9GgMKEXJLQxapWC7NvrUfykdbAHfPcbIAc7
	XlpTSUCH1F32Hqcksg1uxncF9miiXrys4P7rcc1/EvNBZP8C4hCVb7GhY+XRJ1ZTN3Hb4c
	F25Sx/+rfvESKW1Cu1tuA8mKtMSVLMw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ts2+6/GS";
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766704888; a=rsa-sha256;
	cv=none;
	b=I9ALZ1Y4Cpqs3vNeyJvH3OpddzK2fCvfXn+T9iqBb2i/1404il3heScSqHxIbLua2fYxBG
	6yaeX9v1u39f400aHicojUk+fpH15WHKR1eGFAft0TQh3kgpa9wMgUgjPvKo+K786j9Fma
	Lta7ko6tg5zr05HTsLlwMTTMJgK8bgg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766704886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jMuFk6SfrgNzCfHXzFMzuHFFLdc/IVuMulpjk+slEIw=;
	b=Ts2+6/GSboekRiPCAzSPqJM51w0dkzINhL4AEp3Y0ZdIiFQr5faOs8mLDPxBm0YlkTSu82
	AKbkZZdps4L0IZ3+v6hIljdvEdWHg6cs+xJQHEsFX6HLblSBVQ9H6XIHWB5U8qvTfZsdru
	YBUVdLBgtZ+jO2cIZJBQsCYlbysWSzw=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] memcg: introduce private id API for in-kernel users
Date: Thu, 25 Dec 2025 15:21:09 -0800
Message-ID: <20251225232116.294540-2-shakeel.butt@linux.dev>
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 30558180010
X-Stat-Signature: igx3u7o44ap8h18b6m8bn47mgbmof6b5
X-Rspam-User: 
X-HE-Tag: 1766704887-41766
X-HE-Meta: U2FsdGVkX1+c2CTb7HTMuVUSUyYC7LqURiX1xSavXWq32/sQ+W3JXnxDOgBSECh1epb+aRY1Eg3uonHnTgiCg1rNWv1bgC1NpdcU0dPpsDzvclIhr1OJo4uMhp+tuAN/KgJJHHxgTgenI+AOWAcqIYQs9F8+W839/2ZsqWe8M81xe52LrglkwlQhjoEIeIxImMD84CBG/+wJL2Uxs8fzszOlzip7FYnDObYOR8GJp3rIZ8rjrHJCPe/tlDoFkgS3UN2mUmXyVSPf8xk0z7qCRYqyvB23500lYPS0eRs3KFjiW+OGQVXsdkAUDCWbR1MahyApuPne4UbRXl5nMT60SMGrSFVDuK5h+47kLYRpClsmjIGYeeexUbEM1V1buxi2UAA+zskYFsbe0lXGsic2B01Rmm9XWgWphkbbdpXO5KlJwgWIupoe9GYApKhbvdwkBT78d8AaGFWiRLQke8iS3G5ys9cafVFOMiZ+PuUoGNFJnkPS/2n5yxO1qv3BBh7LU647tU5aiaZT5BLiAaRujyNDMeImRCvKNgEY+1KcJynZQ/1UjdQnKnZb1qEMiKCZJwzQDK3FlldAJ+HMiDyXPwL80KY6km5APuDoEuBB9MJN1Oc8nvw75021IisvRCZXXiUKS8c4MjUvTMdiRSGqwO2VU9U7v1+Rs2a4WZxRkpyHoenocNqyDrbR5pvSdK+fI8eHrmlh2p6WUkBMEC9W8XUG5yl195vdwlT4Yw4Uu3qoiYKy1D9qh7BvtmWPInmOOVaBBebGSF4ok7dxW9VF5Ytzbd9WXAtuRiZ9JvLxqQBR4EG1S4L7faqdfI9S20PEjk7uvem/gT6hlRQFUJG1Hv4MKshxYxkD0CPk9SNoUA4bcihk+MutudHg3V7c3jx6BTL/Rw/olwDthzdRxzi3lIiUCRn0xi+iVrbIPvfwhKoi4rBn77GV18dMYl1PTHBG7dFREKT98XoqnEmx6EH
 cyJUoe8S
 UJG8feHZyZcIQLQJBpCQNZfwSVhLa0qwzIVgSvHdKg+sA9fLLLPlRsDS42T/SU9MlczWTlACTvfbsQdSmpaCQxAUrWfyhTBOceCL/+qNmUt5ZBwieDIjtFkcf2DgyMORV4CHeTcZvTV128gbVQmNQ4yK+sqpv3HqQRLkcS1qilfuQjtm+5s+DKBLsVKL7WwnyiKqy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory cgroup maintains a private ID infrastructure decoupled from
the cgroup IDs for swapout records and shadow entries. The main
motivation of this private ID infra is best described in the commit
73f576c04b941 ("mm: memcontrol: fix cgroup creation failure after many
small jobs").

Unfortunetely some users have started exposing these private IDs to the
userspace where they should have used the cgroup IDs which are already
exposed to the userspace. Let's rename the memcg ID APIs to explicitly
mark them private.

No functional change is intended.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 24 ++++++++++++++---
 mm/list_lru.c              |  2 +-
 mm/memcontrol-v1.c         |  6 ++---
 mm/memcontrol-v1.h         |  4 +--
 mm/memcontrol.c            | 55 +++++++++++++++++++++-----------------
 mm/workingset.c            |  8 +++---
 6 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index fd400082313a..1c4224bcfb23 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -65,7 +65,7 @@ struct mem_cgroup_reclaim_cookie {
 
 #define MEM_CGROUP_ID_SHIFT	16
 
-struct mem_cgroup_id {
+struct mem_cgroup_private_id {
 	int id;
 	refcount_t ref;
 };
@@ -191,7 +191,7 @@ struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	struct mem_cgroup_id id;
+	struct mem_cgroup_private_id id;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -821,13 +821,19 @@ void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return 0;
 
 	return memcg->id.id;
 }
+struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
+
+static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
+{
+	return mem_cgroup_private_id(memcg);
+}
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
 
 #ifdef CONFIG_SHRINKER_DEBUG
@@ -1290,6 +1296,18 @@ static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 	return NULL;
 }
 
+static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+{
+	return 0;
+}
+
+static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
+{
+	WARN_ON_ONCE(id);
+	/* XXX: This should always return root_mem_cgroup */
+	return NULL;
+}
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 37b642f6cbda..13b9f66d950e 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -369,7 +369,7 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
 
 		xa_for_each(&lru->xa, index, mlru) {
 			rcu_read_lock();
-			memcg = mem_cgroup_from_id(index);
+			memcg = mem_cgroup_from_private_id(index);
 			if (!mem_cgroup_tryget(memcg)) {
 				rcu_read_unlock();
 				continue;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 0b50cb122ff3..0e3d972fad33 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -635,14 +635,14 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	 * have an ID allocated to it anymore, charge the closest online
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
-	swap_memcg = mem_cgroup_id_get_online(memcg);
+	swap_memcg = mem_cgroup_private_id_get_online(memcg);
 	nr_entries = folio_nr_pages(folio);
 	/* Get references for the tail pages, too */
 	if (nr_entries > 1)
-		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
+		mem_cgroup_private_id_get_many(swap_memcg, nr_entries - 1);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	swap_cgroup_record(folio, mem_cgroup_id(swap_memcg), entry);
+	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entry);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index e92b21af92b1..49933925b4ba 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -28,8 +28,8 @@ unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
-void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
+void mem_cgroup_private_id_get_many(struct mem_cgroup *memcg, unsigned int n);
+struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg);
 
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75fc22a33b28..25ad8433df2e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3554,38 +3554,38 @@ static void memcg_wb_domain_size_changed(struct mem_cgroup *memcg)
  */
 
 #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
-static DEFINE_XARRAY_ALLOC1(mem_cgroup_ids);
+static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
 
-static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
+static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
 	if (memcg->id.id > 0) {
-		xa_erase(&mem_cgroup_ids, memcg->id.id);
+		xa_erase(&mem_cgroup_private_ids, memcg->id.id);
 		memcg->id.id = 0;
 	}
 }
 
-void __maybe_unused mem_cgroup_id_get_many(struct mem_cgroup *memcg,
+void __maybe_unused mem_cgroup_private_id_get_many(struct mem_cgroup *memcg,
 					   unsigned int n)
 {
 	refcount_add(n, &memcg->id.ref);
 }
 
-static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
+static void mem_cgroup_private_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
-		mem_cgroup_id_remove(memcg);
+		mem_cgroup_private_id_remove(memcg);
 
 		/* Memcg ID pins CSS */
 		css_put(&memcg->css);
 	}
 }
 
-static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
+static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg)
 {
-	mem_cgroup_id_put_many(memcg, 1);
+	mem_cgroup_private_id_put_many(memcg, 1);
 }
 
-struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
+struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg)
 {
 	while (!refcount_inc_not_zero(&memcg->id.ref)) {
 		/*
@@ -3604,15 +3604,20 @@ struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
 }
 
 /**
- * mem_cgroup_from_id - look up a memcg from a memcg id
+ * mem_cgroup_from_private_id - look up a memcg from a memcg id
  * @id: the memcg id to look up
  *
  * Caller must hold rcu_read_lock().
  */
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
+struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return xa_load(&mem_cgroup_ids, id);
+	return xa_load(&mem_cgroup_private_ids, id);
+}
+
+struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
+{
+	return mem_cgroup_from_private_id(id);
 }
 
 #ifdef CONFIG_SHRINKER_DEBUG
@@ -3711,7 +3716,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&mem_cgroup_ids, &memcg->id.id, NULL,
+	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id.id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
 		goto fail;
@@ -3771,7 +3776,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	lru_gen_init_memcg(memcg);
 	return memcg;
 fail:
-	mem_cgroup_id_remove(memcg);
+	mem_cgroup_private_id_remove(memcg);
 	__mem_cgroup_free(memcg);
 	return ERR_PTR(error);
 }
@@ -3854,7 +3859,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	css_get(css);
 
 	/*
-	 * Ensure mem_cgroup_from_id() works once we're fully online.
+	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
 	 * We could do this earlier and require callers to filter with
 	 * css_tryget_online(). But right now there are no users that
@@ -3863,13 +3868,13 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_ids, memcg->id.id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
 
 	return 0;
 offline_kmem:
 	memcg_offline_kmem(memcg);
 remove_id:
-	mem_cgroup_id_remove(memcg);
+	mem_cgroup_private_id_remove(memcg);
 	return -ENOMEM;
 }
 
@@ -3892,7 +3897,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_id_put(memcg);
+	mem_cgroup_private_id_put(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -4779,7 +4784,7 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 
 	id = lookup_swap_cgroup_id(entry);
 	rcu_read_lock();
-	memcg = mem_cgroup_from_id(id);
+	memcg = mem_cgroup_from_private_id(id);
 	if (!memcg || !css_tryget_online(&memcg->css))
 		memcg = get_mem_cgroup_from_mm(mm);
 	rcu_read_unlock();
@@ -5174,22 +5179,22 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 		return 0;
 	}
 
-	memcg = mem_cgroup_id_get_online(memcg);
+	memcg = mem_cgroup_private_id_get_online(memcg);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_id_put(memcg);
+		mem_cgroup_private_id_put(memcg);
 		return -ENOMEM;
 	}
 
 	/* Get references for the tail pages, too */
 	if (nr_pages > 1)
-		mem_cgroup_id_get_many(memcg, nr_pages - 1);
+		mem_cgroup_private_id_get_many(memcg, nr_pages - 1);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
+	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
 
 	return 0;
 }
@@ -5206,7 +5211,7 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 
 	id = swap_cgroup_clear(entry, nr_pages);
 	rcu_read_lock();
-	memcg = mem_cgroup_from_id(id);
+	memcg = mem_cgroup_from_private_id(id);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg)) {
 			if (do_memsw_account())
@@ -5215,7 +5220,7 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_id_put_many(memcg, nr_pages);
+		mem_cgroup_private_id_put_many(memcg, nr_pages);
 	}
 	rcu_read_unlock();
 }
diff --git a/mm/workingset.c b/mm/workingset.c
index e9f05634747a..13422d304715 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -254,7 +254,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 
-	return pack_shadow(mem_cgroup_id(memcg), pgdat, token, workingset);
+	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset);
 }
 
 /*
@@ -271,7 +271,7 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 
 	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
 
-	memcg = mem_cgroup_from_id(memcg_id);
+	memcg = mem_cgroup_from_private_id(memcg_id);
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
@@ -395,7 +395,7 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
 	/* XXX: target_memcg can be NULL, go through lruvec */
-	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
+	memcgid = mem_cgroup_private_id(lruvec_memcg(lruvec));
 	eviction = atomic_long_read(&lruvec->nonresident_age);
 	eviction >>= bucket_order;
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
@@ -456,7 +456,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * would be better if the root_mem_cgroup existed in all
 	 * configurations instead.
 	 */
-	eviction_memcg = mem_cgroup_from_id(memcgid);
+	eviction_memcg = mem_cgroup_from_private_id(memcgid);
 	if (!mem_cgroup_tryget(eviction_memcg))
 		eviction_memcg = NULL;
 	rcu_read_unlock();
-- 
2.47.3


