Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F6FCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 11:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8878E000D; Thu, 23 Oct 2025 07:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662A38E001C; Thu, 23 Oct 2025 07:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529D98E000D; Thu, 23 Oct 2025 07:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33BA48E001A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:42:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF16B491B9
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:43 +0000 (UTC)
X-FDA: 84029191806.23.95C1DBE
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf12.hostedemail.com (Postfix) with ESMTP id 67E0A40003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:42:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761219762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eRHU4a1/lxZOvrGZL4UO42kHzxS2WG6BBT/KZTObRIU=;
	b=PplwYmqWXOGALkF9pind7UF4CpVhyg6upuvWozvcwSaf+TzJAOiDmYUF71AMuFKohr6KBG
	njsd8LS9KNJjjTv7n1XCFl/pYXtQVTzOdIoQ9Cy1Se7S3NvUnVY17rSge5temEdeYzp95H
	+Ome2fQ+Waz1fRh7TvWk3F6yd48XO+M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761219762; a=rsa-sha256;
	cv=none;
	b=4qcwnNW3NxTHA2qVZ8N7HA8m82lsCjEqVAs0YK9eY3qx0+OSIrlmpx3YE0FxJRMFjQYPrk
	HPkxZ4+i0qB8Cz6Q6ArIv5ulobim1R9ecGV8u5WxLWfCfUW3vHw9no1cuUBMQ7IYS4Ovig
	LR/hDyFE1/kOPa1LfdQ6mr306fouq68=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cskYt0qQ6z2TTHP;
	Thu, 23 Oct 2025 19:38:26 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A1F6D1401F1;
	Thu, 23 Oct 2025 19:42:37 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:42:30 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v5 3/4] mm: mprotect: convert to folio_can_map_prot_numa()
Date: Thu, 23 Oct 2025 19:37:36 +0800
Message-ID: <20251023113737.3572790-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
References: <20251023113737.3572790-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 67E0A40003
X-Rspamd-Server: rspam03
X-Stat-Signature: ykjktk9gn553j47cbzo19g4jeo8rw6yw
X-HE-Tag: 1761219761-314456
X-HE-Meta: U2FsdGVkX18++Tk1dC1bZO3ERzBbAbj993V0aN6FT1ZYJbWdEkxzZuoKpoNFigL/jtiD1K/uAPT+OoicOSNsX6g1liEpBozfgMzTTb73d8PA7lCYtRtkW0GBaE3cubyPqHrOeb7Q15t1VfSmrvuU1XLGc8Epp0ydXY71AKkvSvpMKomofBfSS9TsIzGRxR5aC1q8QY7dk1sBZnYa1hjzXkGqWdb5x6h7DgMOePL1Z0gdfYgHb5/3KynUSrCCI7MMZg2mbhl3lpNnIYdDbVonveVMl9rRQWjDvt2W0ZUMubCfB0ZlDgs2IywtQkClmzkl6pqmLpESO3/pH2rdTVMx2RVoVJnqIx1xfV6FbF4gC3KA3gXe3XFgl5yNhuQjeycMd02c6wD+Wray2rmal+LAHp5Z+OJu2B12c29baaFqE+1QP22Yl27OvH2LnKZ1ICjlqz7ttGQ+m+yPWR1KajWsyd7huv3n1+lgu+1x6/N3ndEqoinpJVgtErRJGokDREjg4hNreLxiXWs62QDpfO6XOio9v4gs4fKQe8d0e+6wKK/UTebJVyfz4IFUILFS2K2Kj/H+mi9rsrfKj4PJtOwPfhWCQyH9twJiLFFD0Tvo90X1pvgoukh6cRlA+9k1RKhIM7UNkw2/TphHgUVWAX4eAq1LhYCXhw9CjwWAsjfG5LO/gkQRBA5WR2E+PbVJc9gygMl8BZLO2/sdoUczcphQCI8QOCswI4Y++GRHZmTDxaRVTlhcPKhjWX2BesgtpV/smdHZeVJBrumYZfpkPg1+OiQwTNStX3F/etSEstGo2CUvKxygLnpsk1bp7AYTKqfcyMQzu/WF2ym8lNQpr/bRHK2ufH8ooz57t4Dt3WhWHYhwg9SntM6T0iM758wnYlQ8KKhsf9W+Z9kNK8rqQHMKTebG1TxqlvOnMumFvobF7YJpFe339ahHLFOvuCp9mxCiq2IZyfsRZ+wjGgJj5R3
 dIg3TyFp
 mWRwD9wsY2lTpH87ltQwq1ekcMo/H60BkI9iQd4adzR2eLDnmcFLPAJu9CUEVij79zBlQuxWNrncZP0pJnDcP9X2jllsHoD8NMifQ5zysb/rRejn06T2R/xa8O/oUyiywKD2X6cq8/cxMPlHbGSpjlcszH5+Nn53/8iZ8zeWS2VWLu9YWngcUTOlTJ37GpLbIxYsN8y/UzUtZANSrMoE1CtRpU7KEI0Syo8Kka2HyND2xDjIrSejJfhDze9JqNutSOKH7aCkDYlZyIqBvfOZfJXKyzpDEwz3FqDy1+73hN8DAK3ZlRDaAg8AoOaXTlzLM9jQk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The prot_numa_skip() naming is not good since it updates the folio
access time except checking whether to skip prot NUMA, so rename it
to folio_can_map_prot_numa(), and cleanup it a bit, remove ret by
directly return value instead of goto style.

Adding a new helper vma_is_single_threaded_private() to check whether
it's a single threaded private VMA, and make folio_can_map_prot_numa()
a non-static function so that they could be reused in change_huge_pmd(),
since folio_can_map_prot_numa() will be shared in different paths,
let's move it near change_prot_numa() in mempolicy.c.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/internal.h  | 20 +++++++++++++++
 mm/mempolicy.c | 61 +++++++++++++++++++++++++++++++++++++++++++++
 mm/mprotect.c  | 67 ++++----------------------------------------------
 3 files changed, 86 insertions(+), 62 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6691d3ea55af..69a8442ed2d4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1399,6 +1399,26 @@ void vunmap_range_noflush(unsigned long start, unsigned long end);
 
 void __vunmap_range_noflush(unsigned long start, unsigned long end);
 
+static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHARED)
+		return false;
+
+	return atomic_read(&vma->vm_mm->mm_users) == 1;
+}
+
+#ifdef CONFIG_NUMA_BALANCING
+bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		bool is_private_single_threaded);
+
+#else
+static inline bool folio_can_map_prot_numa(struct folio *folio,
+		struct vm_area_struct *vma, bool is_private_single_threaded)
+{
+	return false;
+}
+#endif
+
 int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 		      unsigned long addr, int *flags, bool writable,
 		      int *last_cpupid);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 3d797d47a040..b633b3342dea 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -85,6 +85,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/numa_balancing.h>
+#include <linux/sched/sysctl.h>
 #include <linux/sched/task.h>
 #include <linux/nodemask.h>
 #include <linux/cpuset.h>
@@ -99,6 +100,7 @@
 #include <linux/swap.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
+#include <linux/memory-tiers.h>
 #include <linux/migrate.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
@@ -805,6 +807,65 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 }
 
 #ifdef CONFIG_NUMA_BALANCING
+/**
+ * folio_can_map_prot_numa() - check whether the folio can map prot numa
+ * @folio: The folio whose mapping considered for being made NUMA hintable
+ * @vma: The VMA that the folio belongs to.
+ * @is_private_single_threaded: Is this a single-threaded private VMA or not
+ *
+ * This function checks to see if the folio actually indicates that
+ * we need to make the mapping one which causes a NUMA hinting fault,
+ * as there are cases where it's simply unnecessary, and the folio's
+ * access time is adjusted for memory tiering if prot numa needed.
+ *
+ * Return: True if the mapping of the folio needs to be changed, false otherwise.
+ */
+bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
+		bool is_private_single_threaded)
+{
+	int nid;
+
+	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+		return false;
+
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		return false;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
+		return false;
+
+	/*
+	 * While migration can move some dirty folios,
+	 * it cannot move them all from MIGRATE_ASYNC
+	 * context.
+	 */
+	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
+		return false;
+
+	/*
+	 * Don't mess with PTEs if folio is already on the node
+	 * a single-threaded process is running on.
+	 */
+	nid = folio_nid(folio);
+	if (is_private_single_threaded && (nid == numa_node_id()))
+		return false;
+
+	/*
+	 * Skip scanning top tier node if normal numa
+	 * balancing is disabled
+	 */
+	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
+	    node_is_toptier(nid))
+		return false;
+
+	if (folio_use_access_time(folio))
+		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
+
+	return true;
+}
+
 /*
  * This is used to mark a range of virtual addresses to be inaccessible.
  * These are later cleared by a NUMA hinting fault. Depending on these
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 6236d120c8e6..ab4e06cd9a69 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -29,9 +29,7 @@
 #include <linux/uaccess.h>
 #include <linux/mm_inline.h>
 #include <linux/pgtable.h>
-#include <linux/sched/sysctl.h>
 #include <linux/userfaultfd_k.h>
-#include <linux/memory-tiers.h>
 #include <uapi/linux/mman.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -118,60 +116,6 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
 }
 
-static bool prot_numa_skip(struct vm_area_struct *vma, int target_node,
-		struct folio *folio)
-{
-	bool ret = true;
-	bool toptier;
-	int nid;
-
-	if (!folio)
-		goto skip;
-
-	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
-		goto skip;
-
-	/* Also skip shared copy-on-write folios */
-	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
-		goto skip;
-
-	/* Folios are pinned and can't be migrated */
-	if (folio_maybe_dma_pinned(folio))
-		goto skip;
-
-	/*
-	 * While migration can move some dirty pages,
-	 * it cannot move them all from MIGRATE_ASYNC
-	 * context.
-	 */
-	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
-		goto skip;
-
-	/*
-	 * Don't mess with PTEs if page is already on the node
-	 * a single-threaded process is running on.
-	 */
-	nid = folio_nid(folio);
-	if (target_node == nid)
-		goto skip;
-
-	toptier = node_is_toptier(nid);
-
-	/*
-	 * Skip scanning top tier node if normal numa
-	 * balancing is disabled
-	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) && toptier)
-		goto skip;
-
-	ret = false;
-	if (folio_use_access_time(folio))
-		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
-
-skip:
-	return ret;
-}
-
 /* Set nr_ptes number of ptes, starting from idx */
 static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
 		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
@@ -274,7 +218,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 	pte_t *pte, oldpte;
 	spinlock_t *ptl;
 	long pages = 0;
-	int target_node = NUMA_NO_NODE;
+	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
@@ -285,10 +229,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 	if (!pte)
 		return -EAGAIN;
 
-	/* Get target node for single threaded private VMAs */
-	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
-	    atomic_read(&vma->vm_mm->mm_users) == 1)
-		target_node = numa_node_id();
+	if (prot_numa)
+		is_private_single_threaded = vma_is_single_threaded_private(vma);
 
 	flush_tlb_batched_pending(vma->vm_mm);
 	arch_enter_lazy_mmu_mode();
@@ -315,7 +257,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			 * pages. See similar comment in change_huge_pmd.
 			 */
 			if (prot_numa &&
-			    prot_numa_skip(vma, target_node, folio)) {
+			    !folio_can_map_prot_numa(folio, vma,
+						is_private_single_threaded)) {
 
 				/* determine batch to skip */
 				nr_ptes = mprotect_folio_pte_batch(folio,
-- 
2.27.0


