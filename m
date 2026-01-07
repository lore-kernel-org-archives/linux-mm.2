Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D94DCD583B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA0D6B0093; Wed,  7 Jan 2026 06:32:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE036B0095; Wed,  7 Jan 2026 06:32:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A4C6B0096; Wed,  7 Jan 2026 06:32:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2FD6B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:32:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEBCF1AA310
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:32:51 +0000 (UTC)
X-FDA: 84304955742.28.50CE3F7
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2FF27A000E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:32:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QhuMMV+B;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785569; a=rsa-sha256;
	cv=none;
	b=rh8qw2bflmmuMLJzc1RavQz62AmVf1LSjWCHwUEyGM79omZuoUHF3ztw4Fua/GRB6Jt8n1
	tLTwhRe4oEtcUXoEBZPF5PK2KhChCWra2nKBwK88c1VdQfABuDG3Lrhg4R0uJsjnTBLhYu
	ClNc17WNMhlKa0VRkZMaL2kwKeOIuTU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QhuMMV+B;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCbQrsy9EGhaI41sv7J59xf0PzXpHKfWp8oxq4i5ozI=;
	b=5h4ewJODnx0ZYlKzR5Rk4WRuehf4ln+QUQVVnGkUJSNwxKeoETJ0FlshygBqybmVQ1SgBH
	E/Y6BcLg8fnCa5Uurpm23z7ApluO59ggNa4l9vQ9F0Jl8MhCLXeADaxqfHd6UGq2vog+HB
	76xYIczxRrpD+W7/dpW6RY0yiabsZxQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785562; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=GCbQrsy9EGhaI41sv7J59xf0PzXpHKfWp8oxq4i5ozI=;
 b=QhuMMV+B4Vw3PRjwNlR73heSQvK2VCFGs4yhGQRppwtijM3cPzyQGI4Vh1UpnQz4r8mTY0
 FxCtdfkCz3BSq4QIcZa5FLTBgh966n/Rc5F3+cAN1FCSStL/sx1ybBjlDVttweuzo3JJdo
 ILg1mHMlSEzv+V2JC7//bZojfaXmMiTVRlRuyKdO5ZTUz2QGveji1ojPh6/Eo2HdjkqLmE
 uxLPSm6e0vynRWXGjPfyRcPgruXIi5U01cx6TXIRKdTNv5TIcbzC1FVwEWMH475vTd3a6X
 SsJQd8ybEay5c9MZd6WEeC6nuKmaO/QyL/UQpCqJH5vkZSDg1VMKtlaX9WMT9w==
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed,  7 Jan 2026 19:31:23 +0800
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
Subject: [PATCH v2 1/8] mm/hugetlb: add pre-zeroed framework
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
Message-Id: <20260107113130.37231-2-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+2695e4458+d7c06a+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 2FF27A000E
X-Rspamd-Server: rspam03
X-Stat-Signature: 49hjjh7sg1ufqj4wekbioy3humshabpx
X-Rspam-User: 
X-HE-Tag: 1767785568-225004
X-HE-Meta: U2FsdGVkX1/ZkymnDLDY+hUfXNZt9fxwtZTFgJ3viuNhE6O00onu2pY5SHE075LNWQl21YIKaFgV5oLvoBs4g+dIIlIeofehRTiXkBURyaGlol5E60MUMJo1nf60Pl3tN3g7OHlLKh+1OVVcTgcmFKnqG4A47UB/jfa2qghs+91RAvddu/f2M1if7DMDhlaEM84bUjwtjV/PDZ4ZvmGYV41PV+jkIhVIhfjQsIpz7XcEkZmstKx4Scytl70ZbdY5c887aqUszSCV2PONlQEUGZIoXOC9Xg+bJU952kj2jJB9WYkKgoJTD7kQXdoNZMlvF+bgLD0k7c7u2FwFwGQq95n/1gXD+fKlB8p+M+xj6CUCrvvwf2pVhxadCV3KhuUujWI9+BVv2/XfPixZDLXVF7b4RIEMsmj9ZivPAY8F/p56LypTQxPVsKCZ+G8g+EU7zmZ50K+wZCIK6B6T44f2kfcZYT1oJWDBIz3vACyrWrFfQ8Gb4KfoEAplc9xA9AHgLzQ3QO+KfmxTIizSZpgLrcNzYwjP6E0Pb/3ViEZmV3UdKD4A9NaPS4+jp9BRJiNp6UujVHJL/6Fu4tdXXUOJgXCRJJd06Qm0R4NpsVQnfSCqQXvZNsvNcH5Us9s1jISDvbmBH2b0ieimSi6aA5aiscUriGFJqEtnqLXVE80jNtPXCJgyFvuWkorUbkmsSamXQZCq1AGIFDFYq5KQluqNhSaumyxUuDwQk3sv4no8AfATXZ5uPAQd4pCRYRDWjLXeJHnQpaQRh21ZWYo7zRzXAF93R9Eh30RUoGCmzVPisyNzp0yJolFsyI8YhQgwHsNJyXZqBnPMdpEObWRvdreTPOuV3j6lm60BcoHPv2iYsy5UrI/em4fYTPbO9MVL4rQsaaehQUVcFQGHj01/0OwoEQUhq1+4z+7ueD9PnoAP+04kpVNfXqBQfCslsins5UIc1CJTWvQ+/n6KR99Rcf9
 HVb/o3kA
 1DS4UWtCMwy/06LvaaxmIR3OElW7IMbmeMv9Y7VBVb72x+MaYMXv9LSS+yRZumcwmu6Acg69Byp6m9Ko4m5DrPUIcgGOlUhVk5/o37jFnxVhFwufJCbKUIS3u6jyGmsX6RLVMGGZdlI97hg7Ipcyectll3n8iY6WD+LVEWA55cC9GkwVTCLy28P9wyOaUxZ2A1vDDIgDNMqlaBc76DjHfVnX1ZD3DFSxMMIAqMmhLhAHZzqZ7FXthDgXjB4bQUk4o66XYeUB7xLuCo62npdXrbwX3ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 include/linux/hugetlb.h |  26 ++++++++++
 mm/hugetlb.c            | 111 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 131 insertions(+), 9 deletions(-)

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
index 51273baec9e5..001fc0ed4c48 100644
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
@@ -4190,6 +4252,40 @@ bool __init __attribute((weak)) arch_hugetlb_valid_s=
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
+	guard(spinlock)(&hugetlb_lock);
+
+	wait_event_cmd(h->dqzero_wait[folio_nid(folio)],
+		       !folio_test_hugetlb_zeroing(folio),
+		       spin_unlock_irq(&hugetlb_lock),
+		       spin_lock_irq(&hugetlb_lock));
+}
+
 void __init hugetlb_add_hstate(unsigned int order)
 {
 	struct hstate *h;
@@ -4205,8 +4301,10 @@ void __init hugetlb_add_hstate(unsigned int order)
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
@@ -5804,8 +5902,7 @@ static vm_fault_t hugetlb_no_page(struct address_spac=
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

