Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18934C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE366B00AC; Tue, 30 Jun 2026 21:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8EDD6B00AD; Tue, 30 Jun 2026 21:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5F46B00AE; Tue, 30 Jun 2026 21:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8946B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:23:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 159E31C0DE4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:21 +0000 (UTC)
X-FDA: 84938459802.12.9B260B3
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5868740004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZyBlmIwA;
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782868999;
	b=Hw7cVBLfr9YgX+WUOBow+krJKSqSq36NqTL/QgHObJScG8fUOXiHodJxHBvQAZGIUL3Hir
	Xg6FGdwla/lsy3u/nPJ5p4EyNoaVqQHpB/PLSEhJ9P8/7oqGpVGn8zwVge9STmC95UkDoI
	+hXtRoLl9kmDKaLWDfqywTAYPX+oC4o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782868999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=me4gxxtk2UE9amPMWJ+tnnDPl3C0v42Lrd1KsRW0P9c=;
	b=yQGCcFawQN5WMXgBrBf+bouu4bU5A7axz3aW9ndabQxrL02bAQTjSs9fdhZtV94mmZSsJN
	wxHUWcQph8Uj9/4pJ3A5Gl6GHhvwVsEdwBDz+AGunRoPo8g+Qx3YszN0ehWGqaNuQx7j1U
	wJe//9BWe5R0ZsPKuAckcNiklGaKTp4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZyBlmIwA;
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782868997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=me4gxxtk2UE9amPMWJ+tnnDPl3C0v42Lrd1KsRW0P9c=;
	b=ZyBlmIwAxBzF2PTTNDSitFwccQ9tmst6rO8NMK4EO3XllhhCy0NX+P8wJyzUYhkJec+bTt
	Gq/udUcVAG1x0T3gUjc/aktHQ6h4le4jXXR8PwMYWuJYS4WFvkfllM7m2mcVaD/IrFqiFa
	agQq+GlLM/OuKB4Vq5bvGGZxkQF53Sc=
From: Ye Liu <ye.liu@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v4 3/7] mm: use enum migrate_reason instead of int for migration reason parameters
Date: Wed,  1 Jul 2026 09:22:29 +0800
Message-ID: <20260701012239.315262-4-ye.liu@linux.dev>
In-Reply-To: <20260701012239.315262-1-ye.liu@linux.dev>
References: <20260701012239.315262-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: xdyj49amx53n8q7795xgay6kpc8mwj3t
X-Rspamd-Queue-Id: 5868740004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782868999-636412
X-HE-Meta: U2FsdGVkX19gfNLElbw5vqmz0an6wdp/w7E7MGpMFKc7MjDVqJaYf/A0k2FFw2CtAekCytLWGv/mq8+tnbp+fDh3RasYJlK4+QjkKqJKvh1HaQxGn8Yg9QvWvBa5fsbKq9LlnJ7uqaeFkUkWIo4zlVfLbZPEsu8Ioh6d2pYd0LF1J78xxPac9cnYz5SqqA/kNGtgqFACpw5FyKBK4BbSi4b9YPPh8sP/W4y2MQg9Ok7I6KNg1ySvkKlJNAhuEHrMhDJQPx+hnFxtsCTZ3b7TRHPLNOkZ7CVW4qgLhFRRu+w/aBRpocdVqb6FPa5Z4Yx/WY/DFFCiYKwfX7kW/rXPYLYsiTAXaXJGCRtMc9Ix6Nc1MGK7eE5P11h5at1wvSQyYiWTRyIK4SiOUP5vJUe5q9TQ0fdpAA0GwUXqw7J0GxSb1Q1ig/qmbRV0g30AUkM8F7MzOes07d1dTObeqQVo/slt+V41iAf31xqlfNS2RjzvS8fMFfj4oBIwIHxozVcTCtAwYqI8LW+hzrF/1Uo//U5DoqzRsZbhc1ZDCDClmC4JX1O7VhZEDDlGu/BEK1u7EuHUI5ncWJ/rgJSkHSQDBIDwf+ouvQ+ftwMOAtXLNADF3hKsOmnmqUK706hhv44gBRay1eq3OiQ6bL0oWIxgnyLLA4ELwWksysaL2wDlBq8tdH1WyP6g6oDt0wDA7uZerblRYxbiYbNI1KFPhvcKRTC4esaItged0mgZmC3UttMe08vWRvLIPvbAyURHshGh3yk6RW0+6pKFy54mM3x2YY6Hrngvk9Ihpq+MSfqZINeL3tDbr1ji6qHHpcUbHsGvVuqw1eo/QVOjtSftgGGVJsq8cBou1FL04zf9NxcTdu8JvBQiUiQ/WWrqzIojyGYKv+kJftc3jH+EZfUKvfARNufKKKfhdTLd03QGB+KBjueOGGVFtfg74cmeeL8psb9wwtzSPIvpowvxjcV3kjL
 5oBE6ynS
 c7cnImhI49cdL4ToDfM2ddhUj44njnRZVegNaEDV4HTmLN6VexUYyoAydDavSKva+Zlas/vWZ3AJeQxoiN7Nx015teurkP0BUSlxYXL0IPscTDkW6QTJyat4pDaRyrGf8VpYk4dN11a/uPyKJMC14bHhuZ3QcxX+NTUhcD4Yl6RUmja+p4sgAcLkt9n2YV7hNrhvFxyvLuZ3O1uSYsJ8LPaQFfOLM7wyNWOxZIDMq/JupTF2KjOScU1e+1PSjm3Vr8Ja89ueS5PcSh2mHh4GffWAGdBpugCagqq9ivTJzCEJYjnKe+Ymkc5RpkmxIlyMH4ENJySBi8dvldvPARjqEDImCDsckywXBIYbW1cV2XqeKoTDbI5L/mJNOUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace all 'int reason' function parameters that carry migrate_reason
values with the proper 'enum migrate_reason' type.  This makes the
intent explicit and leverages compiler type checking.  The affected
subsystems are:

  - page_owner: __folio_set_owner_migrate_reason(),
                folio_set_owner_migrate_reason()
  - migrate: migrate_pages(), migrate_pages_sync(),
             migrate_pages_batch(), migrate_folios_move(),
             migrate_hugetlbs(), unmap_and_move_huge_page()
  - hugetlb: move_hugetlb_state(), htlb_allow_alloc_fallback()
  - trace: mm_migrate_pages and mm_migrate_pages_start events

The 'short last_migrate_reason' struct field and internal helper
parameter in page_owner are intentionally left as 'short' since they
store per-page metadata where size matters.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/hugetlb.h        |  9 +++++----
 include/linux/migrate.h        |  6 ++++--
 include/linux/page_owner.h     |  7 ++++---
 include/trace/events/migrate.h |  8 ++++----
 mm/hugetlb.c                   |  3 ++-
 mm/migrate.c                   | 12 ++++++------
 mm/page_owner.c                |  2 +-
 7 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e9..fa828232dfcc 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -154,7 +154,8 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 void folio_putback_hugetlb(struct folio *folio);
-void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
+void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
+			enum migrate_reason reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
@@ -424,7 +425,7 @@ static inline void folio_putback_hugetlb(struct folio *folio)
 }
 
 static inline void move_hugetlb_state(struct folio *old_folio,
-					struct folio *new_folio, int reason)
+					struct folio *new_folio, enum migrate_reason reason)
 {
 }
 
@@ -956,7 +957,7 @@ static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
 	return modified_mask;
 }
 
-static inline bool htlb_allow_alloc_fallback(int reason)
+static inline bool htlb_allow_alloc_fallback(enum migrate_reason reason)
 {
 	bool allowed_fallback = false;
 
@@ -1238,7 +1239,7 @@ static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
 	return 0;
 }
 
-static inline bool htlb_allow_alloc_fallback(int reason)
+static inline bool htlb_allow_alloc_fallback(enum migrate_reason reason)
 {
 	return false;
 }
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d5af2b7f577b..1f83924615d6 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -57,7 +57,8 @@ void putback_movable_pages(struct list_head *l);
 int migrate_folio(struct address_space *mapping, struct folio *dst,
 		struct folio *src, enum migrate_mode mode);
 int migrate_pages(struct list_head *l, new_folio_t new, free_folio_t free,
-		  unsigned long private, enum migrate_mode mode, int reason,
+		  unsigned long private, enum migrate_mode mode,
+		  enum migrate_reason reason,
 		  unsigned int *ret_succeeded);
 struct folio *alloc_migration_target(struct folio *src, unsigned long private);
 bool isolate_movable_ops_page(struct page *page, isolate_mode_t mode);
@@ -77,7 +78,8 @@ int set_movable_ops(const struct movable_operations *ops, enum pagetype type);
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_folio_t new,
 		free_folio_t free, unsigned long private,
-		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
+		enum migrate_mode mode, enum migrate_reason reason,
+		unsigned int *ret_succeeded)
 	{ return -ENOSYS; }
 static inline struct folio *alloc_migration_target(struct folio *src,
 		unsigned long private)
diff --git a/include/linux/page_owner.h b/include/linux/page_owner.h
index 3328357f6dba..9fe51dfccf26 100644
--- a/include/linux/page_owner.h
+++ b/include/linux/page_owner.h
@@ -3,6 +3,7 @@
 #define __LINUX_PAGE_OWNER_H
 
 #include <linux/jump_label.h>
+#include <linux/migrate_mode.h>
 
 #ifdef CONFIG_PAGE_OWNER
 extern struct static_key_false page_owner_inited;
@@ -14,7 +15,7 @@ extern void __set_page_owner(struct page *page,
 extern void __split_page_owner(struct page *page, int old_order,
 			int new_order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
-extern void __folio_set_owner_migrate_reason(struct folio *folio, int reason);
+extern void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason);
 extern void __dump_page_owner(const struct page *page);
 extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone);
@@ -43,7 +44,7 @@ static inline void folio_copy_owner(struct folio *newfolio, struct folio *old)
 	if (static_branch_unlikely(&page_owner_inited))
 		__folio_copy_owner(newfolio, old);
 }
-static inline void folio_set_owner_migrate_reason(struct folio *folio, int reason)
+static inline void folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
 {
 	if (static_branch_unlikely(&page_owner_inited))
 		__folio_set_owner_migrate_reason(folio, reason);
@@ -68,7 +69,7 @@ static inline void split_page_owner(struct page *page, int old_order,
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
 {
 }
-static inline void folio_set_owner_migrate_reason(struct folio *folio, int reason)
+static inline void folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
 {
 }
 static inline void dump_page_owner(const struct page *page)
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index 11bc0aa14c7e..15ee2ef201b5 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -52,7 +52,7 @@ TRACE_EVENT(mm_migrate_pages,
 	TP_PROTO(unsigned long succeeded, unsigned long failed,
 		 unsigned long thp_succeeded, unsigned long thp_failed,
 		 unsigned long thp_split, unsigned long large_folio_split,
-		 enum migrate_mode mode, int reason),
+		 enum migrate_mode mode, enum migrate_reason reason),
 
 	TP_ARGS(succeeded, failed, thp_succeeded, thp_failed,
 		thp_split, large_folio_split, mode, reason),
@@ -65,7 +65,7 @@ TRACE_EVENT(mm_migrate_pages,
 		__field(	unsigned long,		thp_split)
 		__field(	unsigned long,		large_folio_split)
 		__field(	enum migrate_mode,	mode)
-		__field(	int,			reason)
+		__field(	enum migrate_reason,	reason)
 	),
 
 	TP_fast_assign(
@@ -92,13 +92,13 @@ TRACE_EVENT(mm_migrate_pages,
 
 TRACE_EVENT(mm_migrate_pages_start,
 
-	TP_PROTO(enum migrate_mode mode, int reason),
+	TP_PROTO(enum migrate_mode mode, enum migrate_reason reason),
 
 	TP_ARGS(mode, reason),
 
 	TP_STRUCT__entry(
 		__field(enum migrate_mode, mode)
-		__field(int, reason)
+		__field(enum migrate_reason, reason)
 	),
 
 	TP_fast_assign(
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..17732d1fdc5e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7182,7 +7182,8 @@ void folio_putback_hugetlb(struct folio *folio)
 	folio_put(folio);
 }
 
-void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason)
+void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
+			enum migrate_reason reason)
 {
 	struct hstate *h = folio_hstate(old_folio);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..49e10feeb094 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1469,7 +1469,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, int force, enum migrate_mode mode,
-		int reason, struct list_head *ret)
+		enum migrate_reason reason, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1626,7 +1626,7 @@ struct migrate_pages_stats {
  */
 static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 			    free_folio_t put_new_folio, unsigned long private,
-			    enum migrate_mode mode, int reason,
+			    enum migrate_mode mode, enum migrate_reason reason,
 			    struct migrate_pages_stats *stats,
 			    struct list_head *ret_folios)
 {
@@ -1716,7 +1716,7 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 static void migrate_folios_move(struct list_head *src_folios,
 		struct list_head *dst_folios,
 		free_folio_t put_new_folio, unsigned long private,
-		enum migrate_mode mode, int reason,
+		enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios,
 		struct migrate_pages_stats *stats,
 		int *retry, int *thp_retry, int *nr_failed,
@@ -1799,7 +1799,7 @@ static void migrate_folios_undo(struct list_head *src_folios,
  */
 static int migrate_pages_batch(struct list_head *from,
 		new_folio_t get_new_folio, free_folio_t put_new_folio,
-		unsigned long private, enum migrate_mode mode, int reason,
+		unsigned long private, enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios, struct list_head *split_folios,
 		struct migrate_pages_stats *stats, int nr_pass)
 {
@@ -2011,7 +2011,7 @@ static int migrate_pages_batch(struct list_head *from,
 
 static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
-		enum migrate_mode mode, int reason,
+		enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios, struct list_head *split_folios,
 		struct migrate_pages_stats *stats)
 {
@@ -2088,7 +2088,7 @@ static int migrate_pages_sync(struct list_head *from, new_folio_t get_new_folio,
  */
 int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
-		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
+		enum migrate_mode mode, enum migrate_reason reason, unsigned int *ret_succeeded)
 {
 	int rc, rc_gather;
 	int nr_pages;
diff --git a/mm/page_owner.c b/mm/page_owner.c
index c2f43ab860eb..4e352941a6e2 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -345,7 +345,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 	inc_stack_record_count(handle, gfp_mask, 1 << order);
 }
 
-void __folio_set_owner_migrate_reason(struct folio *folio, int reason)
+void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason)
 {
 	struct page_ext *page_ext = page_ext_get(&folio->page);
 	struct page_owner *page_owner;
-- 
2.43.0


