Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D8C2E7AD40
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8165C6B0089; Thu, 25 Dec 2025 03:21:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D6806B008A; Thu, 25 Dec 2025 03:21:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC4F6B008C; Thu, 25 Dec 2025 03:21:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3686B0089
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:21:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 134E2C19DB
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:21:57 +0000 (UTC)
X-FDA: 84257300274.17.8FE2272
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63FBE180002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:21:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XQBVdjdR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650915; a=rsa-sha256;
	cv=none;
	b=bz4F5mTPa4DjZ5r3W7rYiQW74DYjMhPH4NNKa2jiyiOc5c6cImU5JyB75Ei7Xowl7eRcwi
	SoOCEhGk0liF2YFYzD7zhOg0JiSU2Azy4LRu2ZIvPYaK5kNvxeK4rnNAkgZOH6xsiqfOgN
	YooaMOVuqJEbOc0YWd3ijyXFgyy0LuY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XQBVdjdR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+r0VFqcM+WeLTZRrlUPH/veK2s7ukAnrdDDBIh/Zd8Y=;
	b=wC9Ql+mJJahOWq4kmJPH3yU5Bdq96mHc0CzJEz8NYmOyeesWhynntEKEG4FHCHNcMil9j7
	NpvNX2EUT/Th1eGLRYsxNNUIfC9Cu0OobgS/UspJRYiZzyGq4vPRGAGt4Oi5vqLSMUC5NZ
	8y4x+Q5YucEoKRQVHqqArL7q76rv1Ss=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650907; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+r0VFqcM+WeLTZRrlUPH/veK2s7ukAnrdDDBIh/Zd8Y=;
 b=XQBVdjdR4orYpadnV12J6eKNNjbp9rihd9eQ2QaJV8cEJGQJAaPhH+ISxBnhMJtuT49EWz
 PNXtgtRSaeV9xTKJIWdh36CSDbgEQtfwVptLh8ajVKiVG7wF9dOOGLJe/Ip5f7+xn9OMjd
 JoPMas5kkTkCys0PAggA8JgkuNViut9GJVkSXL5VTD1s6LCvGIJKqmdfY/aoTjwh05oFOm
 hC1AW7oXCHLeNXYv5GzyX26eYrd18RiKUPgSmNk4jKKbWgXKjrV2I4Ne8bI0hLcWcqjwcx
 toPX0A0I8vRMS0xC7IeKCoELCVSG4uhc0Aqw63QOAjjXDqRkS3kwqCR6uj4KIg==
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Original-From: lizhe.67@bytedance.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH 1/8] mm/hugetlb: add pre-zeroed framework
Date: Thu, 25 Dec 2025 16:20:52 +0800
Message-Id: <20251225082059.1632-2-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2694cf419+46bdc8+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 63FBE180002
X-Stat-Signature: p1fgqrzy4y9cd5b6dc1apj7wdfupsiq3
X-Rspam-User: 
X-HE-Tag: 1766650914-142061
X-HE-Meta: U2FsdGVkX192TeiiJrFqtjHUs3ySqPbyo+TBZQVLH+RBC2uYfREjmMnXk+hiFB3HYkzAOeDFc7KqTMh/ORhyUiuVJ94MLZuMbRuUqy8wTLI+dDIYMTNuswmKQ/YyPILMmRXwXZZXFS5upC2gk0dPmpu7yXjXHZOiV1I0XFRjYGzYx1Y7ApZoJS2A6Rf4T68zb7B4m5g8svTHCAYku0JMh065Dd1ILiYo/RwMkT8hUUOYGgo/w0oTwYfU4oLRJDmuJY9Q0pOXVekC0t3Hnsw6KGbuWCzX7Q5kPHAwXGN4P7n3rx7hQzYu9rgxYA/yvlxeGBauab69pombRxoXhgCP1dcY2ZGM3BIMnLktiXl5rpDsM4MPDItwkWuMwGgF96JdVkGgnE/9GDGT/MvmWoVoUHfifHZ9XbU6hZQevIs4j0Wl7047kXd8lDx/bnWrmu40Kl65Nw6x4GiwmsJR6ksS+HL/MBV5587vZ0dA7OgPVX4Jf/IE7jFx8GIPp0uzSdu3WR9Re09x+rtVk6irJFdyvhUPIdQPGRoWHBM54v4tu19Sxq/Sl4eIa3CUZZYc1LC1GaIAeLNk/UiYtF2POhc2t87UPQI9E+2KDhdReIh2O0r3lPlsDFYZI3rcOZ3OdsngcYIyPT+TyZt0tAhHaZRxE4YNEwDPoDnVMANLlv1/GVt3X0D2dMiYa4FvmdXFTEj7A8/ZKiCGiA88rWvZktIwxiK9H8yihAPuxWF9q8Dmwuhi64rZzKfPoKLt4c2tOTrypc+6BNwk6LrLrIUexb193koGTugIvdvOigDmxJpZy14w3b0R4FqokQ5RkiZnHmVtCptdcWYC2DpjT7vd+byizpFVyIWcqZWwcNhSeNjUAWYVyr4+/m4XzD+6OrfvxKw6cxdRrD1laSTPv4b7+RR7Iz5j0rOXm7TGxjcYcRgg1UHT8x1RAZLAcdWDcmbRVw6DQFRzQJ+8e2L3+ARgPSE
 AbQcvtZS
 4aw8MTLoGlvCEzd/mch/G0u7yMt8CE92jGz14sTHPinEuk5LEXTmrAclSmFKABN/cgnKIz9wv3Be5fWiQVunB6ePQs7MJGrkB809PLPnVQPFDYwAsyx/FxftYZF5JhB2kMgigF4KwrW/s8zX4mIcF2nj0ei29dofjo1lEWylqDtsB/WYX3WkdCd/nj1Lnci3JP19wWQhPdbg51AoajThYbxQ1+WCs6h4SFJea9DIx77r4xl0FkX5+Kn+paWvsC2du0A5LFgNhfsw038c/nQJLXS83R6ipdoVF0vo0SSvHaujI2pc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

This patch establishes a pre-zeroing framework by introducing two new
hugetlb page flags and extends the code at every point where these flags
may later be required. The roles of the two flags are as follows.

(1) HPG_zeroed =E2=80=93 indicates that the huge folio has already been
    zeroed
(2) HPG_zeroing =E2=80=93 marks that the huge folio is currently being zero=
ed

No functional change, as nothing sets the flags yet.

Co-developed-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 fs/hugetlbfs/inode.c    |   3 +-
 include/linux/hugetlb.h |  26 +++++++++
 mm/hugetlb.c            | 113 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 133 insertions(+), 9 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3b4c152c5c73..be6b32ab3ca8 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -828,8 +828,7 @@ static long hugetlbfs_fallocate(struct file *file, int =
mode, loff_t offset,
 			error =3D PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, addr);
-		__folio_mark_uptodate(folio);
+		hugetlb_zero_folio(folio, addr);
 		error =3D hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 019a1c5281e4..2daf4422a17d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -584,6 +584,17 @@ hugetlb_get_unmapped_area(struct file *file, unsigned =
long addr,
  * HPG_vmemmap_optimized - Set when the vmemmap pages of the page are free=
d.
  * HPG_raw_hwp_unreliable - Set when the hugetlb page has a hwpoison sub-p=
age
  *     that is not tracked by raw_hwp_page list.
+ * HPG_zeroed - page was pre-zeroed.
+ *	Synchronization: hugetlb_lock held when set by pre-zero thread.
+ *	Only valid to read outside hugetlb_lock once the page is off
+ *	the freelist, and HPG_zeroing is clear. Always cleared when a
+ *	page is put (back) on the freelist.
+ * HPG_zeroing - page is being zeroed by the pre-zero thread.
+ *	Synchronization: set and cleared by the pre-zero thread with
+ *	hugetlb_lock held. Access by others is read-only. Once the page
+ *	is off the freelist, this can only change from set -> clear,
+ *	which the new page owner must wait for. Always cleared
+ *	when a page is put (back) on the freelist.
  */
 enum hugetlb_page_flags {
 	HPG_restore_reserve =3D 0,
@@ -593,6 +604,8 @@ enum hugetlb_page_flags {
 	HPG_vmemmap_optimized,
 	HPG_raw_hwp_unreliable,
 	HPG_cma,
+	HPG_zeroed,
+	HPG_zeroing,
 	__NR_HPAGEFLAGS,
 };
=20
@@ -653,6 +666,8 @@ HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
 HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
 HPAGEFLAG(Cma, cma)
+HPAGEFLAG(Zeroed, zeroed)
+HPAGEFLAG(Zeroing, zeroing)
=20
 #ifdef CONFIG_HUGETLB_PAGE
=20
@@ -678,6 +693,12 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+
+	unsigned int free_huge_pages_zero_node[MAX_NUMNODES];
+
+	/* Queue to wait for a hugetlb folio that is being prezeroed */
+	wait_queue_head_t dqzero_wait[MAX_NUMNODES];
+
 	char name[HSTATE_NAME_LEN];
 };
=20
@@ -711,6 +732,7 @@ int hugetlb_add_to_page_cache(struct folio *folio, stru=
ct address_space *mapping
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma=
,
 				unsigned long address, struct folio *folio);
+void hugetlb_zero_folio(struct folio *folio, unsigned long address);
=20
 /* arch callback */
 int __init __alloc_bootmem_huge_page(struct hstate *h, int nid);
@@ -1303,6 +1325,10 @@ static inline bool hugetlb_bootmem_allocated(void)
 {
 	return false;
 }
+
+static inline void hugetlb_zero_folio(struct folio *folio, unsigned long a=
ddress)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
=20
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5..d20614b1c927 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -93,6 +93,8 @@ static int hugetlb_param_index __initdata;
 static __init int hugetlb_add_param(char *s, int (*setup)(char *val));
 static __init void hugetlb_parse_params(void);
=20
+static void hpage_wait_zeroing(struct hstate *h, struct folio *folio);
+
 #define hugetlb_early_param(str, func) \
 static __init int func##args(char *s) \
 { \
@@ -1292,21 +1294,33 @@ void clear_vma_resv_huge_pages(struct vm_area_struc=
t *vma)
 	hugetlb_dup_vma_private(vma);
 }
=20
+/*
+ * Clear flags for either a fresh page or one that is being
+ * added to the free list.
+ */
+static inline void prep_clear_zeroed(struct folio *folio)
+{
+	folio_clear_hugetlb_zeroed(folio);
+	folio_clear_hugetlb_zeroing(folio);
+}
+
 static void enqueue_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
 	int nid =3D folio_nid(folio);
=20
 	lockdep_assert_held(&hugetlb_lock);
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+	VM_WARN_ON_FOLIO(folio_test_hugetlb_zeroing(folio), folio);
=20
 	list_move(&folio->lru, &h->hugepage_freelists[nid]);
 	h->free_huge_pages++;
 	h->free_huge_pages_node[nid]++;
+	prep_clear_zeroed(folio);
 	folio_set_hugetlb_freed(folio);
 }
=20
-static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
-								int nid)
+static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h, in=
t nid,
+		gfp_t gfp_mask)
 {
 	struct folio *folio;
 	bool pin =3D !!(current->flags & PF_MEMALLOC_PIN);
@@ -1316,6 +1330,16 @@ static struct folio *dequeue_hugetlb_folio_node_exac=
t(struct hstate *h,
 		if (pin && !folio_is_longterm_pinnable(folio))
 			continue;
=20
+		/*
+		 * This shouldn't happen, as hugetlb pages are never allocated
+		 * with GFP_ATOMIC. But be paranoid and check for it, as
+		 * a zero_busy page might cause a sleep later in
+		 * hpage_wait_zeroing().
+		 */
+		if (WARN_ON_ONCE(folio_test_hugetlb_zeroing(folio) &&
+					!gfpflags_allow_blocking(gfp_mask)))
+			continue;
+
 		if (folio_test_hwpoison(folio))
 			continue;
=20
@@ -1327,6 +1351,10 @@ static struct folio *dequeue_hugetlb_folio_node_exac=
t(struct hstate *h,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+		if (folio_test_hugetlb_zeroed(folio) ||
+		    folio_test_hugetlb_zeroing(folio))
+			h->free_huge_pages_zero_node[nid]--;
+
 		return folio;
 	}
=20
@@ -1363,7 +1391,7 @@ static struct folio *dequeue_hugetlb_folio_nodemask(s=
truct hstate *h, gfp_t gfp_
 			continue;
 		node =3D zone_to_nid(zone);
=20
-		folio =3D dequeue_hugetlb_folio_node_exact(h, node);
+		folio =3D dequeue_hugetlb_folio_node_exact(h, node, gfp_mask);
 		if (folio)
 			return folio;
 	}
@@ -1490,7 +1518,16 @@ void remove_hugetlb_folio(struct hstate *h, struct f=
olio *folio,
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+		folio_clear_hugetlb_freed(folio);
 	}
+	/*
+	 * Adjust the zero page counters now. Note that
+	 * if a page is currently being zeroed, that
+	 * will be waited for in update_and_free_page()
+	 */
+	if (folio_test_hugetlb_zeroed(folio) ||
+	    folio_test_hugetlb_zeroing(folio))
+		h->free_huge_pages_zero_node[nid]--;
 	if (adjust_surplus) {
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
@@ -1543,6 +1580,8 @@ static void __update_and_free_hugetlb_folio(struct hs=
tate *h,
 {
 	bool clear_flag =3D folio_test_hugetlb_vmemmap_optimized(folio);
=20
+	VM_WARN_ON_FOLIO(folio_test_hugetlb_zeroing(folio), folio);
+
 	if (hstate_is_gigantic_no_runtime(h))
 		return;
=20
@@ -1627,6 +1666,7 @@ static void free_hpage_workfn(struct work_struct *wor=
k)
 		 */
 		h =3D size_to_hstate(folio_size(folio));
=20
+		hpage_wait_zeroing(h, folio);
 		__update_and_free_hugetlb_folio(h, folio);
=20
 		cond_resched();
@@ -1643,7 +1683,8 @@ static inline void flush_free_hpage_work(struct hstat=
e *h)
 static void update_and_free_hugetlb_folio(struct hstate *h, struct folio *=
folio,
 				 bool atomic)
 {
-	if (!folio_test_hugetlb_vmemmap_optimized(folio) || !atomic) {
+	if ((!folio_test_hugetlb_zeroing(folio) &&
+	     !folio_test_hugetlb_vmemmap_optimized(folio)) || !atomic) {
 		__update_and_free_hugetlb_folio(h, folio);
 		return;
 	}
@@ -1840,6 +1881,13 @@ static void account_new_hugetlb_folio(struct hstate =
*h, struct folio *folio)
 	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
=20
+static void prep_new_hugetlb_folio(struct folio *folio)
+{
+	lockdep_assert_held(&hugetlb_lock);
+	folio_clear_hugetlb_freed(folio);
+	prep_clear_zeroed(folio);
+}
+
 void init_new_hugetlb_folio(struct folio *folio)
 {
 	__folio_set_hugetlb(folio);
@@ -1964,6 +2012,7 @@ void prep_and_add_allocated_folios(struct hstate *h,
 	/* Add all new pool pages to free lists in one lock cycle */
 	spin_lock_irqsave(&hugetlb_lock, flags);
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
+		prep_new_hugetlb_folio(folio);
 		account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 	}
@@ -2171,6 +2220,7 @@ static struct folio *alloc_surplus_hugetlb_folio(stru=
ct hstate *h,
 		return NULL;
=20
 	spin_lock_irq(&hugetlb_lock);
+	prep_new_hugetlb_folio(folio);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
 	 * as surplus_pages, otherwise it might confuse
@@ -2214,6 +2264,7 @@ static struct folio *alloc_migrate_hugetlb_folio(stru=
ct hstate *h, gfp_t gfp_mas
 		return NULL;
=20
 	spin_lock_irq(&hugetlb_lock);
+	prep_new_hugetlb_folio(folio);
 	account_new_hugetlb_folio(h, folio);
 	spin_unlock_irq(&hugetlb_lock);
=20
@@ -2289,6 +2340,13 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hs=
tate *h, int preferred_nid,
 						preferred_nid, nmask);
 		if (folio) {
 			spin_unlock_irq(&hugetlb_lock);
+			/*
+			 * The contents of this page will be completely
+			 * overwritten immediately, as its a migration
+			 * target, so no clearing is needed. Do wait in
+			 * case pre-zero thread was working on it, though.
+			 */
+			hpage_wait_zeroing(h, folio);
 			return folio;
 		}
 	}
@@ -2779,6 +2837,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct fo=
lio *old_folio,
 		 */
 		remove_hugetlb_folio(h, old_folio, false);
=20
+		prep_new_hugetlb_folio(new_folio);
 		/*
 		 * Ref count on new_folio is already zero as it was dropped
 		 * earlier.  It can be directly added to the pool free list.
@@ -2999,6 +3058,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_stru=
ct *vma,
=20
 	spin_unlock_irq(&hugetlb_lock);
=20
+	hpage_wait_zeroing(h, folio);
+
 	hugetlb_set_folio_subpool(folio, spool);
=20
 	if (map_chg !=3D MAP_CHG_ENFORCED) {
@@ -3257,6 +3318,7 @@ static void __init prep_and_add_bootmem_folios(struct=
 hstate *h,
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
+		prep_new_hugetlb_folio(folio);
 		account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -4190,6 +4252,42 @@ bool __init __attribute((weak)) arch_hugetlb_valid_s=
ize(unsigned long size)
 	return size =3D=3D HPAGE_SIZE;
 }
=20
+/*
+ * Zero a hugetlb page.
+ *
+ * The caller has already made sure that the page is not
+ * being actively zeroed out in the background.
+ *
+ * If it wasn't zeroed out, do it ourselves.
+ */
+void hugetlb_zero_folio(struct folio *folio, unsigned long address)
+{
+	if (!folio_test_hugetlb_zeroed(folio))
+		folio_zero_user(folio, address);
+
+	__folio_mark_uptodate(folio);
+}
+
+/*
+ * Once a page has been taken off the freelist, the new page owner
+ * must wait for the pre-zero thread to finish if it happens
+ * to be working on this page (which should be rare).
+ */
+static void hpage_wait_zeroing(struct hstate *h, struct folio *folio)
+{
+	if (!folio_test_hugetlb_zeroing(folio))
+		return;
+
+	spin_lock_irq(&hugetlb_lock);
+
+	wait_event_cmd(h->dqzero_wait[folio_nid(folio)],
+		       !folio_test_hugetlb_zeroing(folio),
+		       spin_unlock_irq(&hugetlb_lock),
+		       spin_lock_irq(&hugetlb_lock));
+
+	spin_unlock_irq(&hugetlb_lock);
+}
+
 void __init hugetlb_add_hstate(unsigned int order)
 {
 	struct hstate *h;
@@ -4205,8 +4303,10 @@ void __init hugetlb_add_hstate(unsigned int order)
 	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order =3D order;
 	h->mask =3D ~(huge_page_size(h) - 1);
-	for (i =3D 0; i < MAX_NUMNODES; ++i)
+	for (i =3D 0; i < MAX_NUMNODES; ++i) {
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
+		init_waitqueue_head(&h->dqzero_wait[i]);
+	}
 	INIT_LIST_HEAD(&h->hugepage_activelist);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/SZ_1K);
@@ -5804,8 +5904,7 @@ static vm_fault_t hugetlb_no_page(struct address_spac=
e *mapping,
 				ret =3D 0;
 			goto out;
 		}
-		folio_zero_user(folio, vmf->real_address);
-		__folio_mark_uptodate(folio);
+		hugetlb_zero_folio(folio, vmf->address);
 		new_folio =3D true;
=20
 		if (vma->vm_flags & VM_MAYSHARE) {
--=20
2.20.1

