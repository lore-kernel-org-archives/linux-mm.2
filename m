Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 800B2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774D96B00AC; Wed,  1 Jul 2026 02:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724F66B00AE; Wed,  1 Jul 2026 02:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CB06B00AC; Wed,  1 Jul 2026 02:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1D56B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:11:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2DEF12024E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:41 +0000 (UTC)
X-FDA: 84939186402.08.D9DB612
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id EC2C912000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Tl3d9P/l";
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886300;
	b=gtZyjJJuJp2NzCZK3Eb/nrwIbIIa+AyBps2/84PVuA7T0opI7GOLSVpDCX5x4ClP9LmCKN
	W0gBgKGFrUsKVGZicQPpR+ze9d/he+PbWFgza5ayMGVxgq44vb3+OgPGk0uOvtl4kTKM4G
	tDpvkjuEUtpSNWxECdTAsvwb01arAZU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=me4gxxtk2UE9amPMWJ+tnnDPl3C0v42Lrd1KsRW0P9c=;
	b=fWCaRk/9urpX/mqtEg4FQH1nOrDfyFbjGoh9cB09c9jq8gw2JDC1VXdn6b96gqFg6DTlMJ
	6rmyxZlsX8EMx1fB/s61eXlDncd9h3guZi3gzEgc2wzVNMkqd2t5z8ZUEj4+/4oH26cCM8
	/tPdLRHcTPcLWzG7N6T+xj59GMGMCXQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Tl3d9P/l";
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=me4gxxtk2UE9amPMWJ+tnnDPl3C0v42Lrd1KsRW0P9c=;
	b=Tl3d9P/lUbMK1V5dyEoD4tPdAbzkBrxsM02ccwejdf4lEKI2WYoESppKJmW/xJqTcqrzrE
	qbf+78dFcjskI71BncuW8LzWGbRtnPrWcBxGLI63WsHMKT/FP/3sOtSe8T9NnmZRsSG8q+
	JW0E5vIjHszemhST0asQPC3vzamoU3U=
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
Subject: [PATCH v5 3/9] mm: use enum migrate_reason instead of int for migration reason parameters
Date: Wed,  1 Jul 2026 14:10:46 +0800
Message-ID: <20260701061101.344679-4-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC2C912000A
X-Stat-Signature: 1zi7j5ddgqbfd1sre1aqyod33gch1ubp
X-HE-Tag: 1782886299-932007
X-HE-Meta: U2FsdGVkX1/zv0ELs1jimX0xlCbFpfnnH01caNa3RXFLM6xDrzY6FRRXo9J3+a2cJnmGm/+uu82gYjzFO6vak7gBzObwnYmFGL4NVkzzEZ1NC5+RH7nU7utz1C3TwASXkyemV90nCU+OmSYfDchPywvwK2et9bQLXNr65XRE1U3b6DBjDK6PpzgZC7zmNVOtpskRFcuUlexXLxuJRRhpZxRMsU1CG5XrtasGDeh/PM5hpzBpF04By4x7ZbeqMTNX8TzAPCcgR81HrJ2dqNHwvX69kBFkc+NRJ8HFmVrwAJvY659I+PRHUCkhbbdnxKGDKmqVwY4kDwqRwwRFVQdrEVq9gQhVRfYfp8HqZfUrJqmRzrOsPv7QzamirME8zBV5ZqTqylwJMW0jUciloRAnmKUaABEe6khjURPvEcCcvib2N16Tp43wflbAbjUe22fWgN54bQtWBgNJ3I7o4JfGxSLce/4echQwY1s8O5zuzPNOKF7gtosIDQga/JWcafkCRxJEEZtHe+aseww9vU/vQ3WhEZOsqAPO0ZAnye70ldj1z6uRz+frTkmiaGGskxK6xfTMEGIg+7zyCEp1f99ydkydSzgLausvlSf6XykaU7+xMhUUryF0JF8pJgwmcQygo5Qk0XJwp6G0y1isBT2sPzK2+WSlnJSXFdyIeebtfbiKbJg9LCjUM81i315tvPMHsaFj669L9lHQZktuxbB+MzUADps0jHn/mD21VCfnm4419OWPI6aPD+yhnEUSq7AFvkCyhKSvWb23b5v4Vm7eiAKDWWHw5meGBeAoOw4ei4aqxmLDwHbU32felNR2Du1YsIFdRe3zdECOfOwh9k4pqqke9JQyET8kNqC1IL63uNZr/6ALei7TvwUkQ75qNUzuqNwJiVhxtX5GF9JUOHazw7m7hoKj4/gqq8NPH02MpHGXZOAfrTl24LxfCMmClVYopKbJOgcOTTbsVr2BZER
 3YuU37Wh
 Y7JnzacsQMeElUoSVOtX2ke3h0VHla0hqt0JlDBRdre8jE971Altu3jUrw0qS7+e5nVM2iCe2EFPuzDQ7zZjpoA4ooiGKBoVZb/snQlqf1STm8H86wUW4fxc1FAGlt/d+cYBgnp46kJzpj2hrKnZZd8P0ruJR5mClMiyeGhxzsKiY2EHQv7TU3szuQwImPr9fl+nqVto+gfYh6tI3+nY4L8I7RIAPAXQkf4c8mFQL/VN0jZ6Q1va7gb1f0JowN1601cgpRiq+t/9O+j1kTS/fkBRHgMvlehg86CcE7GDZOPO9iJ+hHi2PjW9cw1uY4D6Y6sH40KrenNu0iy8F78Z+qT+RJ6PB90XQVWzX3eoDHPWKkSbZmRElDvIzOQ==
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


