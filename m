Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F16CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043238E003E; Mon,  3 Nov 2025 03:22:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B288E002A; Mon,  3 Nov 2025 03:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C6E8E003E; Mon,  3 Nov 2025 03:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D03848E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:22:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15CB7C0A3F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:22:39 +0000 (UTC)
X-FDA: 84068604438.08.28C7546
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 00A4A1C0002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:22:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X0sbLgWe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762158157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGY1I9raauQCJNDgNXrXD7sy+XV4dnLuExQ4AdxCY7E=;
	b=HTeNe4n31lQa33C34BRuhmcj1FN2gfX76wzNNST8bo+pniiao6EBZOxrzxb2sYhczaHPRE
	8EWS/U5XYLuQ91uucNRmrula2jO2yCvCgpw4qvj+FlryhKJh9v3cwt2PzPfy643Xz5O3WB
	9r4u2NucnS9J/MWdKP59QBvJnpC1IiU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762158157; a=rsa-sha256;
	cv=none;
	b=BAnht6ajOjfeA9yaUGUEUGSRKcvZtYzXEihLugV9nDMoIiC3kRt0ZPwwUbfaw7L70Hk9eg
	xcYOxsuck2DU5Ea69miY9asNMy5Ak6El5ayyoLU6iw9p9yadXaxgiFu0ouMkD4BGM9chGc
	LXPgYJoSzqz/IqUzV4ripeMBU7RD/4s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X0sbLgWe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762158155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JGY1I9raauQCJNDgNXrXD7sy+XV4dnLuExQ4AdxCY7E=;
	b=X0sbLgWeZqkvRF5lbeK/Mnb4OgiMNkyCCm3PGe+VPloWUJ0YNJ1BhYhSqB06mks8dXnvI0
	WWaMwl1EOa5qQzJ6fN+METnepKAMy84lo4aexPOroNK8lHmvffKV0QwVC5Gup80c/DXpvV
	G1/BY6xAG/sq9iffS3YizrpXN+Khvwg=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Geliang Tang <geliang@kernel.org>,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH 1/2] mm/hugetlb: extract sysfs into hugetlb_sysfs.c
Date: Mon,  3 Nov 2025 16:22:08 +0800
Message-ID: <fa0fee2b8c2e54cb2437db44579475492c19e94d.1762156954.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1762156954.git.zhuhui@kylinos.cn>
References: <cover.1762156954.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 00A4A1C0002
X-Rspamd-Server: rspam02
X-Stat-Signature: a4mdf4ew7o55wuwuehw6kumjq78hretr
X-HE-Tag: 1762158156-511067
X-HE-Meta: U2FsdGVkX1/4rZdu4mM/kTFUMSNOi6Kn5T2kUgHH6nKFkLhEFPHOIdffqg4kzqsWtoD/J8BY0CmJ91DkW20KVrxAlPlvUR8XPg9ezifjZGThR/fWgKD1vTX/aHoDu2DvGky4A84zJAKrkmKHpJjHMRk/MuBZ2Ykqt/9j6O7HsH3rNXmXNW1TDj02QJo1ZwVuaptfPjSXBFEFKWPTYkyB2LlB6D0fQKxlGZeIOOUVIg0ig88cVOxk/sXe5sEZd6YFIPRvIPbEn+7P56Tppviyho+LxiMJAIVsWeHcJnz9bup14upJFdlDlCkd/tHvBxU9o1530w39ztB4tlePO6iCIYlIBDQeS4B6tUEox+zCyLh4QxZK22BZh5/397IEtiB2yBkkwxfXXLr9fX7s/ToKiVoEC8ElLi21m3FcHb7QiuGJY2ZcoScUhdeK6rjtIe9kKdlKJQPT6JlIqbsLTSY2r01/Xhr77QTvjRa5mIHuYEns21dHHNN69D/qetKOTfB0mfA6fyTZPq2SzCudfYCvbJVew8PdgspeZU6XVYlfJL2XcdVHCR/DAkCIetfLyGC7KaVs/schwfQNjMaYpDdPp61M7U1HIPHR5LxEq4I4L0EkXGbXb3hqTHJO1ea9aAX7EwbohFpr8VnARDDub6wenWx2JDQQzFPvf5yBYKWgn3vqKd+x0m2nXgWkJaaYH4vZwjC1ZGRHSmbW5nPA5Tx4oN8FXSb2UEGwkwz/eqfJJA3DwETmeWXASD0kMRhRF+G//6R0VGLig1fW//nNYmz3QkKHxDj5dnfZUA+HA9dilCG11HpHdeQPHfNMAE5sM+eib1ChTKwJC5hvPHg8kIcnq37xbS7VJafXwAS9bTSbyXjHgCR2/lqx7/Vol+FVjeqPm1UTjmZhEo1n1SZRR8L8xW8QwSG4WELdDuVnogbwUWRs+MrpIpxQer4sG2VEKEQkebfCwoFNKwZwzV68Izn
 rCSqyVKe
 iyVzoeZPU6H8nDdFXystL7gRcQ5G2V2OkAJI8ZfOJdMNww46WwXzv43sQ24IXHTZXUbmbJhvS76Fqo1bJgU01/D/rMxvoKEHbHPkMmAWJUzRwSjXu05EaGTF/+ZfSZo4q+aX4o974X1188peXFVcPXs8o0+ZWcnHXSYtnrMzo2QNJsiAjXIuE4u5TqCrFElPAkk/qfPOe6JPvltLit3LiiuzD0YSnvjUHAY24R0mmEqMezlcuv/cAII0sF5zFZHy+A+qNwG4JHe28L4Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Geliang Tang <geliang@kernel.org>

Currently, hugetlb.c contains both core management logic and sysfs
interface implementations, making it difficult to maintain. This patch
extracts the sysfs-related code into a dedicated file to improve code
organization.

The following components are moved to mm/hugetlb_sysfs.c:
- hugetlb page demote functions (demote_free_hugetlb_folios,
  demote_pool_huge_page)
- sysfs attribute definitions and handlers
- sysfs kobject management functions
- NUMA per-node hstate attribute registration

Several inline helper functions and macros are moved to
mm/hugetlb_internal.h:
- hstate_is_gigantic_no_runtime()
- next_node_allowed()
- get_valid_node_allowed()
- hstate_next_node_to_alloc()
- hstate_next_node_to_free()
- for_each_node_mask_to_alloc/to_free macros

To support code sharing, these functions are changed from static to
exported symbols:
- remove_hugetlb_folio()
- add_hugetlb_folio()
- init_new_hugetlb_folio()
- prep_and_add_allocated_folios()
- __nr_hugepages_store_common()

The Makefile is updated to compile hugetlb_sysfs.o when
CONFIG_HUGETLBFS is enabled. This maintains all existing functionality
while improving maintainability by separating concerns.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/Makefile           |   2 +-
 mm/hugetlb.c          | 720 +-----------------------------------------
 mm/hugetlb_internal.h | 110 +++++++
 mm/hugetlb_sysfs.c    | 632 ++++++++++++++++++++++++++++++++++++
 4 files changed, 752 insertions(+), 712 deletions(-)
 create mode 100644 mm/hugetlb_internal.h
 create mode 100644 mm/hugetlb_sysfs.c

diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..b9edfce6c202 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -78,7 +78,7 @@ endif
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
-obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
+obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o
 ifdef CONFIG_CMA
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb_cma.o
 endif
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1ea459723cce..1fc24f7e63ac 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -19,7 +19,6 @@
 #include <linux/mutex.h>
 #include <linux/memblock.h>
 #include <linux/minmax.h>
-#include <linux/sysfs.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
 #include <linux/mmdebug.h>
@@ -46,13 +45,12 @@
 #include <asm/setup.h>
 
 #include <linux/io.h>
-#include <linux/hugetlb.h>
-#include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
+#include "hugetlb_internal.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
@@ -134,17 +132,6 @@ static void hugetlb_free_folio(struct folio *folio)
 	folio_put(folio);
 }
 
-/*
- * Check if the hstate represents gigantic pages but gigantic page
- * runtime support is not available. This is a common condition used to
- * skip operations that cannot be performed on gigantic pages when runtime
- * support is disabled.
- */
-static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
-{
-	return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
-}
-
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)
@@ -1431,77 +1418,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 	return NULL;
 }
 
-/*
- * common helper functions for hstate_next_node_to_{alloc|free}.
- * We may have allocated or freed a huge page based on a different
- * nodes_allowed previously, so h->next_node_to_{alloc|free} might
- * be outside of *nodes_allowed.  Ensure that we use an allowed
- * node for alloc or free.
- */
-static int next_node_allowed(int nid, nodemask_t *nodes_allowed)
-{
-	nid = next_node_in(nid, *nodes_allowed);
-	VM_BUG_ON(nid >= MAX_NUMNODES);
-
-	return nid;
-}
-
-static int get_valid_node_allowed(int nid, nodemask_t *nodes_allowed)
-{
-	if (!node_isset(nid, *nodes_allowed))
-		nid = next_node_allowed(nid, nodes_allowed);
-	return nid;
-}
-
-/*
- * returns the previously saved node ["this node"] from which to
- * allocate a persistent huge page for the pool and advance the
- * next node from which to allocate, handling wrap at end of node
- * mask.
- */
-static int hstate_next_node_to_alloc(int *next_node,
-					nodemask_t *nodes_allowed)
-{
-	int nid;
-
-	VM_BUG_ON(!nodes_allowed);
-
-	nid = get_valid_node_allowed(*next_node, nodes_allowed);
-	*next_node = next_node_allowed(nid, nodes_allowed);
-
-	return nid;
-}
-
-/*
- * helper for remove_pool_hugetlb_folio() - return the previously saved
- * node ["this node"] from which to free a huge page.  Advance the
- * next node id whether or not we find a free huge page to free so
- * that the next attempt to free addresses the next node.
- */
-static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
-{
-	int nid;
-
-	VM_BUG_ON(!nodes_allowed);
-
-	nid = get_valid_node_allowed(h->next_nid_to_free, nodes_allowed);
-	h->next_nid_to_free = next_node_allowed(nid, nodes_allowed);
-
-	return nid;
-}
-
-#define for_each_node_mask_to_alloc(next_node, nr_nodes, node, mask)		\
-	for (nr_nodes = nodes_weight(*mask);				\
-		nr_nodes > 0 &&						\
-		((node = hstate_next_node_to_alloc(next_node, mask)) || 1);	\
-		nr_nodes--)
-
-#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
-	for (nr_nodes = nodes_weight(*mask);				\
-		nr_nodes > 0 &&						\
-		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
-		nr_nodes--)
-
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 #ifdef CONFIG_CONTIG_ALLOC
 static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
@@ -1557,8 +1473,8 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
  *
  * Must be called with hugetlb lock held.
  */
-static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
-							bool adjust_surplus)
+void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
+			  bool adjust_surplus)
 {
 	int nid = folio_nid(folio);
 
@@ -1593,8 +1509,8 @@ static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 	h->nr_huge_pages_node[nid]--;
 }
 
-static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
-			     bool adjust_surplus)
+void add_hugetlb_folio(struct hstate *h, struct folio *folio,
+		       bool adjust_surplus)
 {
 	int nid = folio_nid(folio);
 
@@ -1925,7 +1841,7 @@ static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
-static void init_new_hugetlb_folio(struct folio *folio)
+void init_new_hugetlb_folio(struct folio *folio)
 {
 	__folio_set_hugetlb(folio);
 	INIT_LIST_HEAD(&folio->lru);
@@ -2037,8 +1953,8 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 	return folio;
 }
 
-static void prep_and_add_allocated_folios(struct hstate *h,
-					struct list_head *folio_list)
+void prep_and_add_allocated_folios(struct hstate *h,
+				   struct list_head *folio_list)
 {
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
@@ -4034,179 +3950,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	return 0;
 }
 
-static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
-				       struct list_head *src_list)
-{
-	long rc;
-	struct folio *folio, *next;
-	LIST_HEAD(dst_list);
-	LIST_HEAD(ret_list);
-
-	rc = hugetlb_vmemmap_restore_folios(src, src_list, &ret_list);
-	list_splice_init(&ret_list, src_list);
-
-	/*
-	 * Taking target hstate mutex synchronizes with set_max_huge_pages.
-	 * Without the mutex, pages added to target hstate could be marked
-	 * as surplus.
-	 *
-	 * Note that we already hold src->resize_lock.  To prevent deadlock,
-	 * use the convention of always taking larger size hstate mutex first.
-	 */
-	mutex_lock(&dst->resize_lock);
-
-	list_for_each_entry_safe(folio, next, src_list, lru) {
-		int i;
-		bool cma;
-
-		if (folio_test_hugetlb_vmemmap_optimized(folio))
-			continue;
-
-		cma = folio_test_hugetlb_cma(folio);
-
-		list_del(&folio->lru);
-
-		split_page_owner(&folio->page, huge_page_order(src), huge_page_order(dst));
-		pgalloc_tag_split(folio, huge_page_order(src), huge_page_order(dst));
-
-		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
-			struct page *page = folio_page(folio, i);
-			/* Careful: see __split_huge_page_tail() */
-			struct folio *new_folio = (struct folio *)page;
-
-			clear_compound_head(page);
-			prep_compound_page(page, dst->order);
-
-			new_folio->mapping = NULL;
-			init_new_hugetlb_folio(new_folio);
-			/* Copy the CMA flag so that it is freed correctly */
-			if (cma)
-				folio_set_hugetlb_cma(new_folio);
-			list_add(&new_folio->lru, &dst_list);
-		}
-	}
-
-	prep_and_add_allocated_folios(dst, &dst_list);
-
-	mutex_unlock(&dst->resize_lock);
-
-	return rc;
-}
-
-static long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
-				  unsigned long nr_to_demote)
-	__must_hold(&hugetlb_lock)
-{
-	int nr_nodes, node;
-	struct hstate *dst;
-	long rc = 0;
-	long nr_demoted = 0;
-
-	lockdep_assert_held(&hugetlb_lock);
-
-	/* We should never get here if no demote order */
-	if (!src->demote_order) {
-		pr_warn("HugeTLB: NULL demote order passed to demote_pool_huge_page.\n");
-		return -EINVAL;		/* internal error */
-	}
-	dst = size_to_hstate(PAGE_SIZE << src->demote_order);
-
-	for_each_node_mask_to_free(src, nr_nodes, node, nodes_allowed) {
-		LIST_HEAD(list);
-		struct folio *folio, *next;
-
-		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
-			if (folio_test_hwpoison(folio))
-				continue;
-
-			remove_hugetlb_folio(src, folio, false);
-			list_add(&folio->lru, &list);
-
-			if (++nr_demoted == nr_to_demote)
-				break;
-		}
-
-		spin_unlock_irq(&hugetlb_lock);
-
-		rc = demote_free_hugetlb_folios(src, dst, &list);
-
-		spin_lock_irq(&hugetlb_lock);
-
-		list_for_each_entry_safe(folio, next, &list, lru) {
-			list_del(&folio->lru);
-			add_hugetlb_folio(src, folio, false);
-
-			nr_demoted--;
-		}
-
-		if (rc < 0 || nr_demoted == nr_to_demote)
-			break;
-	}
-
-	/*
-	 * Not absolutely necessary, but for consistency update max_huge_pages
-	 * based on pool changes for the demoted page.
-	 */
-	src->max_huge_pages -= nr_demoted;
-	dst->max_huge_pages += nr_demoted << (huge_page_order(src) - huge_page_order(dst));
-
-	if (rc < 0)
-		return rc;
-
-	if (nr_demoted)
-		return nr_demoted;
-	/*
-	 * Only way to get here is if all pages on free lists are poisoned.
-	 * Return -EBUSY so that caller will not retry.
-	 */
-	return -EBUSY;
-}
-
-#define HSTATE_ATTR_RO(_name) \
-	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
-
-#define HSTATE_ATTR_WO(_name) \
-	static struct kobj_attribute _name##_attr = __ATTR_WO(_name)
-
-#define HSTATE_ATTR(_name) \
-	static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
-
-static struct kobject *hugepages_kobj;
-static struct kobject *hstate_kobjs[HUGE_MAX_HSTATE];
-
-static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp);
-
-static struct hstate *kobj_to_hstate(struct kobject *kobj, int *nidp)
-{
-	int i;
-
-	for (i = 0; i < HUGE_MAX_HSTATE; i++)
-		if (hstate_kobjs[i] == kobj) {
-			if (nidp)
-				*nidp = NUMA_NO_NODE;
-			return &hstates[i];
-		}
-
-	return kobj_to_node_hstate(kobj, nidp);
-}
-
-static ssize_t nr_hugepages_show_common(struct kobject *kobj,
-					struct kobj_attribute *attr, char *buf)
-{
-	struct hstate *h;
-	unsigned long nr_huge_pages;
-	int nid;
-
-	h = kobj_to_hstate(kobj, &nid);
-	if (nid == NUMA_NO_NODE)
-		nr_huge_pages = h->nr_huge_pages;
-	else
-		nr_huge_pages = h->nr_huge_pages_node[nid];
-
-	return sysfs_emit(buf, "%lu\n", nr_huge_pages);
-}
-
-static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
+ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 					   struct hstate *h, int nid,
 					   unsigned long count, size_t len)
 {
@@ -4239,452 +3983,6 @@ static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 	return err ? err : len;
 }
 
-static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
-					 struct kobject *kobj, const char *buf,
-					 size_t len)
-{
-	struct hstate *h;
-	unsigned long count;
-	int nid;
-	int err;
-
-	err = kstrtoul(buf, 10, &count);
-	if (err)
-		return err;
-
-	h = kobj_to_hstate(kobj, &nid);
-	return __nr_hugepages_store_common(obey_mempolicy, h, nid, count, len);
-}
-
-static ssize_t nr_hugepages_show(struct kobject *kobj,
-				       struct kobj_attribute *attr, char *buf)
-{
-	return nr_hugepages_show_common(kobj, attr, buf);
-}
-
-static ssize_t nr_hugepages_store(struct kobject *kobj,
-	       struct kobj_attribute *attr, const char *buf, size_t len)
-{
-	return nr_hugepages_store_common(false, kobj, buf, len);
-}
-HSTATE_ATTR(nr_hugepages);
-
-#ifdef CONFIG_NUMA
-
-/*
- * hstate attribute for optionally mempolicy-based constraint on persistent
- * huge page alloc/free.
- */
-static ssize_t nr_hugepages_mempolicy_show(struct kobject *kobj,
-					   struct kobj_attribute *attr,
-					   char *buf)
-{
-	return nr_hugepages_show_common(kobj, attr, buf);
-}
-
-static ssize_t nr_hugepages_mempolicy_store(struct kobject *kobj,
-	       struct kobj_attribute *attr, const char *buf, size_t len)
-{
-	return nr_hugepages_store_common(true, kobj, buf, len);
-}
-HSTATE_ATTR(nr_hugepages_mempolicy);
-#endif
-
-
-static ssize_t nr_overcommit_hugepages_show(struct kobject *kobj,
-					struct kobj_attribute *attr, char *buf)
-{
-	struct hstate *h = kobj_to_hstate(kobj, NULL);
-	return sysfs_emit(buf, "%lu\n", h->nr_overcommit_huge_pages);
-}
-
-static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
-		struct kobj_attribute *attr, const char *buf, size_t count)
-{
-	int err;
-	unsigned long input;
-	struct hstate *h = kobj_to_hstate(kobj, NULL);
-
-	if (hstate_is_gigantic_no_runtime(h))
-		return -EINVAL;
-
-	err = kstrtoul(buf, 10, &input);
-	if (err)
-		return err;
-
-	spin_lock_irq(&hugetlb_lock);
-	h->nr_overcommit_huge_pages = input;
-	spin_unlock_irq(&hugetlb_lock);
-
-	return count;
-}
-HSTATE_ATTR(nr_overcommit_hugepages);
-
-static ssize_t free_hugepages_show(struct kobject *kobj,
-					struct kobj_attribute *attr, char *buf)
-{
-	struct hstate *h;
-	unsigned long free_huge_pages;
-	int nid;
-
-	h = kobj_to_hstate(kobj, &nid);
-	if (nid == NUMA_NO_NODE)
-		free_huge_pages = h->free_huge_pages;
-	else
-		free_huge_pages = h->free_huge_pages_node[nid];
-
-	return sysfs_emit(buf, "%lu\n", free_huge_pages);
-}
-HSTATE_ATTR_RO(free_hugepages);
-
-static ssize_t resv_hugepages_show(struct kobject *kobj,
-					struct kobj_attribute *attr, char *buf)
-{
-	struct hstate *h = kobj_to_hstate(kobj, NULL);
-	return sysfs_emit(buf, "%lu\n", h->resv_huge_pages);
-}
-HSTATE_ATTR_RO(resv_hugepages);
-
-static ssize_t surplus_hugepages_show(struct kobject *kobj,
-					struct kobj_attribute *attr, char *buf)
-{
-	struct hstate *h;
-	unsigned long surplus_huge_pages;
-	int nid;
-
-	h = kobj_to_hstate(kobj, &nid);
-	if (nid == NUMA_NO_NODE)
-		surplus_huge_pages = h->surplus_huge_pages;
-	else
-		surplus_huge_pages = h->surplus_huge_pages_node[nid];
-
-	return sysfs_emit(buf, "%lu\n", surplus_huge_pages);
-}
-HSTATE_ATTR_RO(surplus_hugepages);
-
-static ssize_t demote_store(struct kobject *kobj,
-	       struct kobj_attribute *attr, const char *buf, size_t len)
-{
-	unsigned long nr_demote;
-	unsigned long nr_available;
-	nodemask_t nodes_allowed, *n_mask;
-	struct hstate *h;
-	int err;
-	int nid;
-
-	err = kstrtoul(buf, 10, &nr_demote);
-	if (err)
-		return err;
-	h = kobj_to_hstate(kobj, &nid);
-
-	if (nid != NUMA_NO_NODE) {
-		init_nodemask_of_node(&nodes_allowed, nid);
-		n_mask = &nodes_allowed;
-	} else {
-		n_mask = &node_states[N_MEMORY];
-	}
-
-	/* Synchronize with other sysfs operations modifying huge pages */
-	mutex_lock(&h->resize_lock);
-	spin_lock_irq(&hugetlb_lock);
-
-	while (nr_demote) {
-		long rc;
-
-		/*
-		 * Check for available pages to demote each time thorough the
-		 * loop as demote_pool_huge_page will drop hugetlb_lock.
-		 */
-		if (nid != NUMA_NO_NODE)
-			nr_available = h->free_huge_pages_node[nid];
-		else
-			nr_available = h->free_huge_pages;
-		nr_available -= h->resv_huge_pages;
-		if (!nr_available)
-			break;
-
-		rc = demote_pool_huge_page(h, n_mask, nr_demote);
-		if (rc < 0) {
-			err = rc;
-			break;
-		}
-
-		nr_demote -= rc;
-	}
-
-	spin_unlock_irq(&hugetlb_lock);
-	mutex_unlock(&h->resize_lock);
-
-	if (err)
-		return err;
-	return len;
-}
-HSTATE_ATTR_WO(demote);
-
-static ssize_t demote_size_show(struct kobject *kobj,
-					struct kobj_attribute *attr, char *buf)
-{
-	struct hstate *h = kobj_to_hstate(kobj, NULL);
-	unsigned long demote_size = (PAGE_SIZE << h->demote_order) / SZ_1K;
-
-	return sysfs_emit(buf, "%lukB\n", demote_size);
-}
-
-static ssize_t demote_size_store(struct kobject *kobj,
-					struct kobj_attribute *attr,
-					const char *buf, size_t count)
-{
-	struct hstate *h, *demote_hstate;
-	unsigned long demote_size;
-	unsigned int demote_order;
-
-	demote_size = (unsigned long)memparse(buf, NULL);
-
-	demote_hstate = size_to_hstate(demote_size);
-	if (!demote_hstate)
-		return -EINVAL;
-	demote_order = demote_hstate->order;
-	if (demote_order < HUGETLB_PAGE_ORDER)
-		return -EINVAL;
-
-	/* demote order must be smaller than hstate order */
-	h = kobj_to_hstate(kobj, NULL);
-	if (demote_order >= h->order)
-		return -EINVAL;
-
-	/* resize_lock synchronizes access to demote size and writes */
-	mutex_lock(&h->resize_lock);
-	h->demote_order = demote_order;
-	mutex_unlock(&h->resize_lock);
-
-	return count;
-}
-HSTATE_ATTR(demote_size);
-
-static struct attribute *hstate_attrs[] = {
-	&nr_hugepages_attr.attr,
-	&nr_overcommit_hugepages_attr.attr,
-	&free_hugepages_attr.attr,
-	&resv_hugepages_attr.attr,
-	&surplus_hugepages_attr.attr,
-#ifdef CONFIG_NUMA
-	&nr_hugepages_mempolicy_attr.attr,
-#endif
-	NULL,
-};
-
-static const struct attribute_group hstate_attr_group = {
-	.attrs = hstate_attrs,
-};
-
-static struct attribute *hstate_demote_attrs[] = {
-	&demote_size_attr.attr,
-	&demote_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group hstate_demote_attr_group = {
-	.attrs = hstate_demote_attrs,
-};
-
-static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
-				    struct kobject **hstate_kobjs,
-				    const struct attribute_group *hstate_attr_group)
-{
-	int retval;
-	int hi = hstate_index(h);
-
-	hstate_kobjs[hi] = kobject_create_and_add(h->name, parent);
-	if (!hstate_kobjs[hi])
-		return -ENOMEM;
-
-	retval = sysfs_create_group(hstate_kobjs[hi], hstate_attr_group);
-	if (retval) {
-		kobject_put(hstate_kobjs[hi]);
-		hstate_kobjs[hi] = NULL;
-		return retval;
-	}
-
-	if (h->demote_order) {
-		retval = sysfs_create_group(hstate_kobjs[hi],
-					    &hstate_demote_attr_group);
-		if (retval) {
-			pr_warn("HugeTLB unable to create demote interfaces for %s\n", h->name);
-			sysfs_remove_group(hstate_kobjs[hi], hstate_attr_group);
-			kobject_put(hstate_kobjs[hi]);
-			hstate_kobjs[hi] = NULL;
-			return retval;
-		}
-	}
-
-	return 0;
-}
-
-#ifdef CONFIG_NUMA
-static bool hugetlb_sysfs_initialized __ro_after_init;
-
-/*
- * node_hstate/s - associate per node hstate attributes, via their kobjects,
- * with node devices in node_devices[] using a parallel array.  The array
- * index of a node device or _hstate == node id.
- * This is here to avoid any static dependency of the node device driver, in
- * the base kernel, on the hugetlb module.
- */
-struct node_hstate {
-	struct kobject		*hugepages_kobj;
-	struct kobject		*hstate_kobjs[HUGE_MAX_HSTATE];
-};
-static struct node_hstate node_hstates[MAX_NUMNODES];
-
-/*
- * A subset of global hstate attributes for node devices
- */
-static struct attribute *per_node_hstate_attrs[] = {
-	&nr_hugepages_attr.attr,
-	&free_hugepages_attr.attr,
-	&surplus_hugepages_attr.attr,
-	NULL,
-};
-
-static const struct attribute_group per_node_hstate_attr_group = {
-	.attrs = per_node_hstate_attrs,
-};
-
-/*
- * kobj_to_node_hstate - lookup global hstate for node device hstate attr kobj.
- * Returns node id via non-NULL nidp.
- */
-static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
-{
-	int nid;
-
-	for (nid = 0; nid < nr_node_ids; nid++) {
-		struct node_hstate *nhs = &node_hstates[nid];
-		int i;
-		for (i = 0; i < HUGE_MAX_HSTATE; i++)
-			if (nhs->hstate_kobjs[i] == kobj) {
-				if (nidp)
-					*nidp = nid;
-				return &hstates[i];
-			}
-	}
-
-	BUG();
-	return NULL;
-}
-
-/*
- * Unregister hstate attributes from a single node device.
- * No-op if no hstate attributes attached.
- */
-void hugetlb_unregister_node(struct node *node)
-{
-	struct hstate *h;
-	struct node_hstate *nhs = &node_hstates[node->dev.id];
-
-	if (!nhs->hugepages_kobj)
-		return;		/* no hstate attributes */
-
-	for_each_hstate(h) {
-		int idx = hstate_index(h);
-		struct kobject *hstate_kobj = nhs->hstate_kobjs[idx];
-
-		if (!hstate_kobj)
-			continue;
-		if (h->demote_order)
-			sysfs_remove_group(hstate_kobj, &hstate_demote_attr_group);
-		sysfs_remove_group(hstate_kobj, &per_node_hstate_attr_group);
-		kobject_put(hstate_kobj);
-		nhs->hstate_kobjs[idx] = NULL;
-	}
-
-	kobject_put(nhs->hugepages_kobj);
-	nhs->hugepages_kobj = NULL;
-}
-
-
-/*
- * Register hstate attributes for a single node device.
- * No-op if attributes already registered.
- */
-void hugetlb_register_node(struct node *node)
-{
-	struct hstate *h;
-	struct node_hstate *nhs = &node_hstates[node->dev.id];
-	int err;
-
-	if (!hugetlb_sysfs_initialized)
-		return;
-
-	if (nhs->hugepages_kobj)
-		return;		/* already allocated */
-
-	nhs->hugepages_kobj = kobject_create_and_add("hugepages",
-							&node->dev.kobj);
-	if (!nhs->hugepages_kobj)
-		return;
-
-	for_each_hstate(h) {
-		err = hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
-						nhs->hstate_kobjs,
-						&per_node_hstate_attr_group);
-		if (err) {
-			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
-				h->name, node->dev.id);
-			hugetlb_unregister_node(node);
-			break;
-		}
-	}
-}
-
-/*
- * hugetlb init time:  register hstate attributes for all registered node
- * devices of nodes that have memory.  All on-line nodes should have
- * registered their associated device by this time.
- */
-static void __init hugetlb_register_all_nodes(void)
-{
-	int nid;
-
-	for_each_online_node(nid)
-		hugetlb_register_node(node_devices[nid]);
-}
-#else	/* !CONFIG_NUMA */
-
-static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
-{
-	BUG();
-	if (nidp)
-		*nidp = -1;
-	return NULL;
-}
-
-static void hugetlb_register_all_nodes(void) { }
-
-#endif
-
-static void __init hugetlb_sysfs_init(void)
-{
-	struct hstate *h;
-	int err;
-
-	hugepages_kobj = kobject_create_and_add("hugepages", mm_kobj);
-	if (!hugepages_kobj)
-		return;
-
-	for_each_hstate(h) {
-		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
-					 hstate_kobjs, &hstate_attr_group);
-		if (err)
-			pr_err("HugeTLB: Unable to add hstate %s\n", h->name);
-	}
-
-#ifdef CONFIG_NUMA
-	hugetlb_sysfs_initialized = true;
-#endif
-	hugetlb_register_all_nodes();
-}
-
 #ifdef CONFIG_SYSCTL
 static void hugetlb_sysctl_init(void);
 #else
diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
new file mode 100644
index 000000000000..63ab13cfb072
--- /dev/null
+++ b/mm/hugetlb_internal.h
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Internal HugeTLB definitions.
+ *
+ * Copyright (C) 2025 KylinSoft Corporation.
+ * Author: Geliang Tang <geliang@kernel.org>
+ */
+
+#ifndef _LINUX_HUGETLB_INTERNAL_H
+#define _LINUX_HUGETLB_INTERNAL_H
+
+#include <linux/hugetlb.h>
+#include <linux/hugetlb_cgroup.h>
+
+/*
+ * Check if the hstate represents gigantic pages but gigantic page
+ * runtime support is not available. This is a common condition used to
+ * skip operations that cannot be performed on gigantic pages when runtime
+ * support is disabled.
+ */
+static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
+{
+	return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
+}
+
+/*
+ * common helper functions for hstate_next_node_to_{alloc|free}.
+ * We may have allocated or freed a huge page based on a different
+ * nodes_allowed previously, so h->next_node_to_{alloc|free} might
+ * be outside of *nodes_allowed.  Ensure that we use an allowed
+ * node for alloc or free.
+ */
+static inline int next_node_allowed(int nid, nodemask_t *nodes_allowed)
+{
+	nid = next_node_in(nid, *nodes_allowed);
+	VM_BUG_ON(nid >= MAX_NUMNODES);
+
+	return nid;
+}
+
+static inline int get_valid_node_allowed(int nid, nodemask_t *nodes_allowed)
+{
+	if (!node_isset(nid, *nodes_allowed))
+		nid = next_node_allowed(nid, nodes_allowed);
+	return nid;
+}
+
+/*
+ * returns the previously saved node ["this node"] from which to
+ * allocate a persistent huge page for the pool and advance the
+ * next node from which to allocate, handling wrap at end of node
+ * mask.
+ */
+static inline int hstate_next_node_to_alloc(int *next_node,
+					    nodemask_t *nodes_allowed)
+{
+	int nid;
+
+	VM_BUG_ON(!nodes_allowed);
+
+	nid = get_valid_node_allowed(*next_node, nodes_allowed);
+	*next_node = next_node_allowed(nid, nodes_allowed);
+
+	return nid;
+}
+
+/*
+ * helper for remove_pool_hugetlb_folio() - return the previously saved
+ * node ["this node"] from which to free a huge page.  Advance the
+ * next node id whether or not we find a free huge page to free so
+ * that the next attempt to free addresses the next node.
+ */
+static inline int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
+{
+	int nid;
+
+	VM_BUG_ON(!nodes_allowed);
+
+	nid = get_valid_node_allowed(h->next_nid_to_free, nodes_allowed);
+	h->next_nid_to_free = next_node_allowed(nid, nodes_allowed);
+
+	return nid;
+}
+
+#define for_each_node_mask_to_alloc(next_node, nr_nodes, node, mask)		\
+	for (nr_nodes = nodes_weight(*mask);				\
+		nr_nodes > 0 &&						\
+		((node = hstate_next_node_to_alloc(next_node, mask)) || 1);	\
+		nr_nodes--)
+
+#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
+	for (nr_nodes = nodes_weight(*mask);				\
+		nr_nodes > 0 &&						\
+		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
+		nr_nodes--)
+
+extern void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
+				 bool adjust_surplus);
+extern void add_hugetlb_folio(struct hstate *h, struct folio *folio,
+			      bool adjust_surplus);
+extern void init_new_hugetlb_folio(struct folio *folio);
+extern void prep_and_add_allocated_folios(struct hstate *h,
+					  struct list_head *folio_list);
+extern ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
+					   struct hstate *h, int nid,
+					   unsigned long count, size_t len);
+
+extern void hugetlb_sysfs_init(void) __init;
+
+#endif /* _LINUX_HUGETLB_INTERNAL_H */
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
new file mode 100644
index 000000000000..a681be311664
--- /dev/null
+++ b/mm/hugetlb_sysfs.c
@@ -0,0 +1,632 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * HugeTLB sysfs interfaces.
+ *
+ * Copyright (C) 2025 KylinSoft Corporation.
+ * Author: Geliang Tang <geliang@kernel.org>
+ */
+
+#include <linux/swap.h>
+#include <linux/page_owner.h>
+#include <linux/page-isolation.h>
+
+#include "hugetlb_vmemmap.h"
+#include "hugetlb_internal.h"
+
+static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
+				       struct list_head *src_list)
+{
+	long rc;
+	struct folio *folio, *next;
+	LIST_HEAD(dst_list);
+	LIST_HEAD(ret_list);
+
+	rc = hugetlb_vmemmap_restore_folios(src, src_list, &ret_list);
+	list_splice_init(&ret_list, src_list);
+
+	/*
+	 * Taking target hstate mutex synchronizes with set_max_huge_pages.
+	 * Without the mutex, pages added to target hstate could be marked
+	 * as surplus.
+	 *
+	 * Note that we already hold src->resize_lock.  To prevent deadlock,
+	 * use the convention of always taking larger size hstate mutex first.
+	 */
+	mutex_lock(&dst->resize_lock);
+
+	list_for_each_entry_safe(folio, next, src_list, lru) {
+		int i;
+		bool cma;
+
+		if (folio_test_hugetlb_vmemmap_optimized(folio))
+			continue;
+
+		cma = folio_test_hugetlb_cma(folio);
+
+		list_del(&folio->lru);
+
+		split_page_owner(&folio->page, huge_page_order(src), huge_page_order(dst));
+		pgalloc_tag_split(folio, huge_page_order(src), huge_page_order(dst));
+
+		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
+			struct page *page = folio_page(folio, i);
+			/* Careful: see __split_huge_page_tail() */
+			struct folio *new_folio = (struct folio *)page;
+
+			clear_compound_head(page);
+			prep_compound_page(page, dst->order);
+
+			new_folio->mapping = NULL;
+			init_new_hugetlb_folio(new_folio);
+			/* Copy the CMA flag so that it is freed correctly */
+			if (cma)
+				folio_set_hugetlb_cma(new_folio);
+			list_add(&new_folio->lru, &dst_list);
+		}
+	}
+
+	prep_and_add_allocated_folios(dst, &dst_list);
+
+	mutex_unlock(&dst->resize_lock);
+
+	return rc;
+}
+
+static long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
+				  unsigned long nr_to_demote)
+	__must_hold(&hugetlb_lock)
+{
+	int nr_nodes, node;
+	struct hstate *dst;
+	long rc = 0;
+	long nr_demoted = 0;
+
+	lockdep_assert_held(&hugetlb_lock);
+
+	/* We should never get here if no demote order */
+	if (!src->demote_order) {
+		pr_warn("HugeTLB: NULL demote order passed to demote_pool_huge_page.\n");
+		return -EINVAL;		/* internal error */
+	}
+	dst = size_to_hstate(PAGE_SIZE << src->demote_order);
+
+	for_each_node_mask_to_free(src, nr_nodes, node, nodes_allowed) {
+		LIST_HEAD(list);
+		struct folio *folio, *next;
+
+		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
+			if (folio_test_hwpoison(folio))
+				continue;
+
+			remove_hugetlb_folio(src, folio, false);
+			list_add(&folio->lru, &list);
+
+			if (++nr_demoted == nr_to_demote)
+				break;
+		}
+
+		spin_unlock_irq(&hugetlb_lock);
+
+		rc = demote_free_hugetlb_folios(src, dst, &list);
+
+		spin_lock_irq(&hugetlb_lock);
+
+		list_for_each_entry_safe(folio, next, &list, lru) {
+			list_del(&folio->lru);
+			add_hugetlb_folio(src, folio, false);
+
+			nr_demoted--;
+		}
+
+		if (rc < 0 || nr_demoted == nr_to_demote)
+			break;
+	}
+
+	/*
+	 * Not absolutely necessary, but for consistency update max_huge_pages
+	 * based on pool changes for the demoted page.
+	 */
+	src->max_huge_pages -= nr_demoted;
+	dst->max_huge_pages += nr_demoted << (huge_page_order(src) - huge_page_order(dst));
+
+	if (rc < 0)
+		return rc;
+
+	if (nr_demoted)
+		return nr_demoted;
+	/*
+	 * Only way to get here is if all pages on free lists are poisoned.
+	 * Return -EBUSY so that caller will not retry.
+	 */
+	return -EBUSY;
+}
+
+#define HSTATE_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+#define HSTATE_ATTR_WO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_WO(_name)
+
+#define HSTATE_ATTR(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
+
+static struct kobject *hugepages_kobj;
+static struct kobject *hstate_kobjs[HUGE_MAX_HSTATE];
+
+static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp);
+
+static struct hstate *kobj_to_hstate(struct kobject *kobj, int *nidp)
+{
+	int i;
+
+	for (i = 0; i < HUGE_MAX_HSTATE; i++)
+		if (hstate_kobjs[i] == kobj) {
+			if (nidp)
+				*nidp = NUMA_NO_NODE;
+			return &hstates[i];
+		}
+
+	return kobj_to_node_hstate(kobj, nidp);
+}
+
+static ssize_t nr_hugepages_show_common(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h;
+	unsigned long nr_huge_pages;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE)
+		nr_huge_pages = h->nr_huge_pages;
+	else
+		nr_huge_pages = h->nr_huge_pages_node[nid];
+
+	return sysfs_emit(buf, "%lu\n", nr_huge_pages);
+}
+
+static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
+					 struct kobject *kobj, const char *buf,
+					 size_t len)
+{
+	struct hstate *h;
+	unsigned long count;
+	int nid;
+	int err;
+
+	err = kstrtoul(buf, 10, &count);
+	if (err)
+		return err;
+
+	h = kobj_to_hstate(kobj, &nid);
+	return __nr_hugepages_store_common(obey_mempolicy, h, nid, count, len);
+}
+
+static ssize_t nr_hugepages_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	return nr_hugepages_show_common(kobj, attr, buf);
+}
+
+static ssize_t nr_hugepages_store(struct kobject *kobj,
+	       struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	return nr_hugepages_store_common(false, kobj, buf, len);
+}
+HSTATE_ATTR(nr_hugepages);
+
+#ifdef CONFIG_NUMA
+
+/*
+ * hstate attribute for optionally mempolicy-based constraint on persistent
+ * huge page alloc/free.
+ */
+static ssize_t nr_hugepages_mempolicy_show(struct kobject *kobj,
+					   struct kobj_attribute *attr,
+					   char *buf)
+{
+	return nr_hugepages_show_common(kobj, attr, buf);
+}
+
+static ssize_t nr_hugepages_mempolicy_store(struct kobject *kobj,
+	       struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	return nr_hugepages_store_common(true, kobj, buf, len);
+}
+HSTATE_ATTR(nr_hugepages_mempolicy);
+#endif
+
+
+static ssize_t nr_overcommit_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj, NULL);
+	return sysfs_emit(buf, "%lu\n", h->nr_overcommit_huge_pages);
+}
+
+static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int err;
+	unsigned long input;
+	struct hstate *h = kobj_to_hstate(kobj, NULL);
+
+	if (hstate_is_gigantic_no_runtime(h))
+		return -EINVAL;
+
+	err = kstrtoul(buf, 10, &input);
+	if (err)
+		return err;
+
+	spin_lock_irq(&hugetlb_lock);
+	h->nr_overcommit_huge_pages = input;
+	spin_unlock_irq(&hugetlb_lock);
+
+	return count;
+}
+HSTATE_ATTR(nr_overcommit_hugepages);
+
+static ssize_t free_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h;
+	unsigned long free_huge_pages;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE)
+		free_huge_pages = h->free_huge_pages;
+	else
+		free_huge_pages = h->free_huge_pages_node[nid];
+
+	return sysfs_emit(buf, "%lu\n", free_huge_pages);
+}
+HSTATE_ATTR_RO(free_hugepages);
+
+static ssize_t resv_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj, NULL);
+	return sysfs_emit(buf, "%lu\n", h->resv_huge_pages);
+}
+HSTATE_ATTR_RO(resv_hugepages);
+
+static ssize_t surplus_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h;
+	unsigned long surplus_huge_pages;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (nid == NUMA_NO_NODE)
+		surplus_huge_pages = h->surplus_huge_pages;
+	else
+		surplus_huge_pages = h->surplus_huge_pages_node[nid];
+
+	return sysfs_emit(buf, "%lu\n", surplus_huge_pages);
+}
+HSTATE_ATTR_RO(surplus_hugepages);
+
+static ssize_t demote_store(struct kobject *kobj,
+	       struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	unsigned long nr_demote;
+	unsigned long nr_available;
+	nodemask_t nodes_allowed, *n_mask;
+	struct hstate *h;
+	int err;
+	int nid;
+
+	err = kstrtoul(buf, 10, &nr_demote);
+	if (err)
+		return err;
+	h = kobj_to_hstate(kobj, &nid);
+
+	if (nid != NUMA_NO_NODE) {
+		init_nodemask_of_node(&nodes_allowed, nid);
+		n_mask = &nodes_allowed;
+	} else {
+		n_mask = &node_states[N_MEMORY];
+	}
+
+	/* Synchronize with other sysfs operations modifying huge pages */
+	mutex_lock(&h->resize_lock);
+	spin_lock_irq(&hugetlb_lock);
+
+	while (nr_demote) {
+		long rc;
+
+		/*
+		 * Check for available pages to demote each time thorough the
+		 * loop as demote_pool_huge_page will drop hugetlb_lock.
+		 */
+		if (nid != NUMA_NO_NODE)
+			nr_available = h->free_huge_pages_node[nid];
+		else
+			nr_available = h->free_huge_pages;
+		nr_available -= h->resv_huge_pages;
+		if (!nr_available)
+			break;
+
+		rc = demote_pool_huge_page(h, n_mask, nr_demote);
+		if (rc < 0) {
+			err = rc;
+			break;
+		}
+
+		nr_demote -= rc;
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+	mutex_unlock(&h->resize_lock);
+
+	if (err)
+		return err;
+	return len;
+}
+HSTATE_ATTR_WO(demote);
+
+static ssize_t demote_size_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h = kobj_to_hstate(kobj, NULL);
+	unsigned long demote_size = (PAGE_SIZE << h->demote_order) / SZ_1K;
+
+	return sysfs_emit(buf, "%lukB\n", demote_size);
+}
+
+static ssize_t demote_size_store(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct hstate *h, *demote_hstate;
+	unsigned long demote_size;
+	unsigned int demote_order;
+
+	demote_size = (unsigned long)memparse(buf, NULL);
+
+	demote_hstate = size_to_hstate(demote_size);
+	if (!demote_hstate)
+		return -EINVAL;
+	demote_order = demote_hstate->order;
+	if (demote_order < HUGETLB_PAGE_ORDER)
+		return -EINVAL;
+
+	/* demote order must be smaller than hstate order */
+	h = kobj_to_hstate(kobj, NULL);
+	if (demote_order >= h->order)
+		return -EINVAL;
+
+	/* resize_lock synchronizes access to demote size and writes */
+	mutex_lock(&h->resize_lock);
+	h->demote_order = demote_order;
+	mutex_unlock(&h->resize_lock);
+
+	return count;
+}
+HSTATE_ATTR(demote_size);
+
+static struct attribute *hstate_attrs[] = {
+	&nr_hugepages_attr.attr,
+	&nr_overcommit_hugepages_attr.attr,
+	&free_hugepages_attr.attr,
+	&resv_hugepages_attr.attr,
+	&surplus_hugepages_attr.attr,
+#ifdef CONFIG_NUMA
+	&nr_hugepages_mempolicy_attr.attr,
+#endif
+	NULL,
+};
+
+static const struct attribute_group hstate_attr_group = {
+	.attrs = hstate_attrs,
+};
+
+static struct attribute *hstate_demote_attrs[] = {
+	&demote_size_attr.attr,
+	&demote_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group hstate_demote_attr_group = {
+	.attrs = hstate_demote_attrs,
+};
+
+static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
+				    struct kobject **hstate_kobjs,
+				    const struct attribute_group *hstate_attr_group)
+{
+	int retval;
+	int hi = hstate_index(h);
+
+	hstate_kobjs[hi] = kobject_create_and_add(h->name, parent);
+	if (!hstate_kobjs[hi])
+		return -ENOMEM;
+
+	retval = sysfs_create_group(hstate_kobjs[hi], hstate_attr_group);
+	if (retval) {
+		kobject_put(hstate_kobjs[hi]);
+		hstate_kobjs[hi] = NULL;
+		return retval;
+	}
+
+	if (h->demote_order) {
+		retval = sysfs_create_group(hstate_kobjs[hi],
+					    &hstate_demote_attr_group);
+		if (retval) {
+			pr_warn("HugeTLB unable to create demote interfaces for %s\n", h->name);
+			sysfs_remove_group(hstate_kobjs[hi], hstate_attr_group);
+			kobject_put(hstate_kobjs[hi]);
+			hstate_kobjs[hi] = NULL;
+			return retval;
+		}
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_NUMA
+static bool hugetlb_sysfs_initialized __ro_after_init;
+
+/*
+ * node_hstate/s - associate per node hstate attributes, via their kobjects,
+ * with node devices in node_devices[] using a parallel array.  The array
+ * index of a node device or _hstate == node id.
+ * This is here to avoid any static dependency of the node device driver, in
+ * the base kernel, on the hugetlb module.
+ */
+struct node_hstate {
+	struct kobject		*hugepages_kobj;
+	struct kobject		*hstate_kobjs[HUGE_MAX_HSTATE];
+};
+static struct node_hstate node_hstates[MAX_NUMNODES];
+
+/*
+ * A subset of global hstate attributes for node devices
+ */
+static struct attribute *per_node_hstate_attrs[] = {
+	&nr_hugepages_attr.attr,
+	&free_hugepages_attr.attr,
+	&surplus_hugepages_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group per_node_hstate_attr_group = {
+	.attrs = per_node_hstate_attrs,
+};
+
+/*
+ * kobj_to_node_hstate - lookup global hstate for node device hstate attr kobj.
+ * Returns node id via non-NULL nidp.
+ */
+static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
+{
+	int nid;
+
+	for (nid = 0; nid < nr_node_ids; nid++) {
+		struct node_hstate *nhs = &node_hstates[nid];
+		int i;
+		for (i = 0; i < HUGE_MAX_HSTATE; i++)
+			if (nhs->hstate_kobjs[i] == kobj) {
+				if (nidp)
+					*nidp = nid;
+				return &hstates[i];
+			}
+	}
+
+	BUG();
+	return NULL;
+}
+
+/*
+ * Unregister hstate attributes from a single node device.
+ * No-op if no hstate attributes attached.
+ */
+void hugetlb_unregister_node(struct node *node)
+{
+	struct hstate *h;
+	struct node_hstate *nhs = &node_hstates[node->dev.id];
+
+	if (!nhs->hugepages_kobj)
+		return;		/* no hstate attributes */
+
+	for_each_hstate(h) {
+		int idx = hstate_index(h);
+		struct kobject *hstate_kobj = nhs->hstate_kobjs[idx];
+
+		if (!hstate_kobj)
+			continue;
+		if (h->demote_order)
+			sysfs_remove_group(hstate_kobj, &hstate_demote_attr_group);
+		sysfs_remove_group(hstate_kobj, &per_node_hstate_attr_group);
+		kobject_put(hstate_kobj);
+		nhs->hstate_kobjs[idx] = NULL;
+	}
+
+	kobject_put(nhs->hugepages_kobj);
+	nhs->hugepages_kobj = NULL;
+}
+
+
+/*
+ * Register hstate attributes for a single node device.
+ * No-op if attributes already registered.
+ */
+void hugetlb_register_node(struct node *node)
+{
+	struct hstate *h;
+	struct node_hstate *nhs = &node_hstates[node->dev.id];
+	int err;
+
+	if (!hugetlb_sysfs_initialized)
+		return;
+
+	if (nhs->hugepages_kobj)
+		return;		/* already allocated */
+
+	nhs->hugepages_kobj = kobject_create_and_add("hugepages",
+							&node->dev.kobj);
+	if (!nhs->hugepages_kobj)
+		return;
+
+	for_each_hstate(h) {
+		err = hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
+						nhs->hstate_kobjs,
+						&per_node_hstate_attr_group);
+		if (err) {
+			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
+				h->name, node->dev.id);
+			hugetlb_unregister_node(node);
+			break;
+		}
+	}
+}
+
+/*
+ * hugetlb init time:  register hstate attributes for all registered node
+ * devices of nodes that have memory.  All on-line nodes should have
+ * registered their associated device by this time.
+ */
+static void __init hugetlb_register_all_nodes(void)
+{
+	int nid;
+
+	for_each_online_node(nid)
+		hugetlb_register_node(node_devices[nid]);
+}
+#else	/* !CONFIG_NUMA */
+
+static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
+{
+	BUG();
+	if (nidp)
+		*nidp = -1;
+	return NULL;
+}
+
+static void hugetlb_register_all_nodes(void) { }
+
+#endif
+
+void __init hugetlb_sysfs_init(void)
+{
+	struct hstate *h;
+	int err;
+
+	hugepages_kobj = kobject_create_and_add("hugepages", mm_kobj);
+	if (!hugepages_kobj)
+		return;
+
+	for_each_hstate(h) {
+		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
+					 hstate_kobjs, &hstate_attr_group);
+		if (err)
+			pr_err("HugeTLB: Unable to add hstate %s\n", h->name);
+	}
+
+#ifdef CONFIG_NUMA
+	hugetlb_sysfs_initialized = true;
+#endif
+	hugetlb_register_all_nodes();
+}
-- 
2.43.0


