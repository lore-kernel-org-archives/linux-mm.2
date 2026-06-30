Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D45BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7791B6B00A6; Mon, 29 Jun 2026 21:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 750066B00A8; Mon, 29 Jun 2026 21:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D556B00AA; Mon, 29 Jun 2026 21:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42F046B00A6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:54:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFFB1C1A23
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:02 +0000 (UTC)
X-FDA: 84934908324.28.D3CB0D8
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 146A540005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HCdEsvxY;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784441;
	b=YrIFJwrvkIlmNsN9VBlGKHRX7NZzoCNbDAtq2wel4dfI+kTEhk3j8ShpJ7LJ2H3kPgnDpf
	/oTbyjiKUyaATxHCEd9xVVIcXjHHEjiHmHTsrVFuIJ8uAu9PLzYc6/aZS8P4CjLEr1ZPky
	CshMAJR8K8UP2A/1iOwGBa1NDiACBYo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5E2Wv8UYoqRjiCwOE+UrkeyzYMfi15mzloMMNFtFSo=;
	b=d4R/xi3waaVuDgZtU4NNrG0xYAhWGkgAU4Al4R4jusLll74kPiQ4AmoTfPCDuHJePEMi7x
	GoeU1elnM+jT2h1SqlOK0rEAhdxxoH2JP9SFUKC+nMSuCbFIYTKp347554Zvy0WGdybApO
	g+TtvcgM+6b/3pNxt/x/WIjqtTemR48=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HCdEsvxY;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5E2Wv8UYoqRjiCwOE+UrkeyzYMfi15mzloMMNFtFSo=;
	b=HCdEsvxYjVKQ6EmmI5j7B6xnecAxRhSc6rfhzuMI14kpDaizRIrHAYsR/JjKtXC4uKFkk1
	teOsq+MqPngU7zYvSZqml6WZAAA/rcCM654YRNboMuL8y+u+8VO/506nmhgkfM/V2jVPIq
	F397V+T33rZkWn6c2WqmpTi/Jn2eGos=
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
Subject: [PATCH v3 3/7] mm: use enum migrate_reason instead of int for migration reason parameters
Date: Tue, 30 Jun 2026 09:53:20 +0800
Message-ID: <20260630015331.147174-4-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-1-ye.liu@linux.dev>
References: <20260630015331.147174-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 146A540005
X-Stat-Signature: fmbriwnfw8o5tc6fygpfewta7p7wb6n5
X-HE-Tag: 1782784440-233268
X-HE-Meta: U2FsdGVkX1/dXp0P98Pn7iznBtXuZ1WKNu8rQQiQovclT8tci/XJWyGfX9/eBFHjU0R6K/VkMJ4GgcJzdjdzzsiKpCOqCqrh2svP4VUk2JZkUJ9NkXDcGtVh18Ua9JqU/dk86rcVJKfEM3Ps4e1u3xTaAtG/QDDI6Pu75qiFDWVBt6AEqxnAnPCn8LAkZxxQBjxQ6hCyUPngKxIluQTiGOa3IwdaZyvFu8eLxs4jh5MpM9h57tD3gcWPCuhZVWERzPdn2RA59IfoQrXM3Ja69SbyO7ABEQTfTexwrGqdLNZv+RqdGX1RfSbacRLkL8V5xHPJohYrJJqmW4/k+A9/FKVxlhj9aK0yPupxk3ou14ErrehZhWtMFaax9I7l732xRBSXDRjdQC3DrPGTdA3wFCet2q07tAXgLIG92LLugEgHYxVhUTcUjlzIi+X8yuRDFf7H0n6/KTNSknCisa0czgqSX3GNDaFzra//y/wYuLsjDteZOaML4mnXsC/qeAKNCD8PrFXnN40KOixVbz3inGkiQMwVtNXRgzVhxxJ79l5sLGMA1h0EmGaAbLmmi21AS5sMkBjnpcioav68N1q6Gw71vzJ4JVuPxmVVUoOOhi9vuI4Ooz5wBD/i33vdBbfFlGwn4PSWOA4MKB4PLiqIwuLhH5I6y8bijI7h4SJaTTVXvc9yJgIKwytsSbOIsJEWa3iZpw4fb2rl9YTAmmLORm8WEg/VH6h5kUru2HsZn1D4ZsLF2rJzOoftDAHO0Ys9sjj96mWLXvffwIkHr80r1fBdlI17Gog6y7IBwxyMurOg4EHgUDkDIIpNIXpzK9ru7XIiF8LFWAmzZ6GgA6Iw0w/EKcr0U3G5U7V4zrvfHwbhS93q9JwnNpGcR2o3HB4+VnadMgmb3z2N0+7Gp3vsuC42OZ7JlqPJetM7glagME/c0W9bvpTXuQg6oqeLa0KK2C0mDuDYFQtBlU/j9Ai
 eEsja+sD
 Q/iNL4hI+CnpagNiQEW/STYPsmJJ7RQEP5K5zn/tSEp0oBScjKS/beGI6yDfwnfdslMx0as+G0j/D9u+TFljlVPmSnnX1tagdu5iE2Lcglrekw9mnkhzKfaJkwzhFGLtJ9nO8i2SdAIqc1uiZlgFQduMsqazJvAhv4cJd9LCjsL+ka23M6gDz1GFbCOcP3itwoGilD18/Rydz+ypSi4jKjmc9no6Pnm8aylwWaERJqL1K5tgcBGHOBTuyfc95OgEmqleP/ba9APJ58wT7W7qSWIhYG5qWBf6ajOygneMH6OqggxsyMwfrhkQuyyhYJbJKmwcQ
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


