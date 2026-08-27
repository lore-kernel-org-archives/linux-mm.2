Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C543CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016196B009E; Thu, 27 Aug 2026 12:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07E76B00A3; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC06C6B009E; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 671776B009F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFA0FC010D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:42 +0000 (UTC)
X-FDA: 85147572804.15.1317371
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B54BA000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TcSB835q;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847881;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qaJ1PYCrq7Z4YDNZIpLbpgluhtpESAtKia0lPi28zuQ=;
	b=vgnuZTuu3LteFMzhvTC9mO9ESmkhQphibH/bUPLbACSloN8pL+0yW0r+Pn/pud5JRxyrk1
	9lAUqTAJTmXOMC+JKYb5yETTN6cE4dL/hjeAXdch1HLOBh9kXTyDo80unCxrJeG0vJ/J6a
	/7Pi/K2frGSJzLy3hgSfCnCY1n2nmu0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847881;
	b=Z+8syGPkvk2n3Kk3LmFT3tdPnlxmh8pnlL5tFYfEsrOf3htev7sgWcDdgdcK5qBmZwsFID
	8Va4oyu4RjCfAGSXyh4KoAXmGnU6ikYWvs7IXAuAqJnEtvaBawnjIZRUKXjKqg/oFO/pWW
	o4TOkDSMdK/abDGdP0ckT8vW8ZEjijk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TcSB835q;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qaJ1PYCrq7Z4YDNZIpLbpgluhtpESAtKia0lPi28zuQ=;
	b=TcSB835qmyqhdBzyqaw3s86lSkHss40WlOP4r/nQsE4HHZ0Y2Ss8V3Mo5FNl4ozP2wsVLqN8l
	MDaOylHR44Y1T4HKKFaTqtVHh4xYkVpUJlzXHrlCVoBKuC2DS15wP6DufUpJQ3D7hlP9x2Nygm9
	gR1BN/IrmvkdvTJrfcN9q3Y=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KF0MjSzHnH3v;
	Fri, 28 Aug 2026 00:24:01 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 1057B4058E;
	Fri, 28 Aug 2026 00:24:37 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:36 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 09/18] mm: add replicas allocation support for vmalloc
Date: Fri, 28 Aug 2026 00:11:49 +0800
Message-ID: <20260827161158.3618409-10-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B54BA000F
X-Stat-Signature: 6r66nw4ey1foy3pg5xmtix9buzbwi477
X-Rspam-User: 
X-HE-Tag: 1787847880-152651
X-HE-Meta: U2FsdGVkX1/0S8eq8nsTQABOKz4Zrwyx02QnHK3N4aYF6Lr9MlXTQTEoGNU20pd2rL1nvfYEfss7EJ54oJFifKOB58acafOGEH0MrzlqGWJ3R+ZgFZl3gCLWf33VboTHIGqC5BEjeWihOwOWa7JHfpinzExl5EjiFJwR0hKPmaqoVz+pUjJ+5cCieF9hyPE2zRp8WgEOmdI7qOuEgpcd/f+OLSCVAs6YSAy5QzI7hQ1WN7sQUU8jFwkn4OmOuNuPvdEQd/7nrRjYsPXRYTbvnxUroSo25/oFPtcagNdTz0wvKs2NhbgiANONsLshs5gjR3gmfGQD3G0Y0Qr1lhyLu4wAMFsmkRND4Hzp/3AoRqAZ1qwNZSCcgTjYADduoFXLHw7nx+WzOk1ZHvO+s7sBY2hB8nLbevFRa1/1x+NaA0YC5Vo2hGXvVSUgCZtMf6N2ipK6QVXuw86/RwcFVij+UEL+b+slRgRJVN2CqeCRFe0K1WCZ5JF2xGwqhLqZKBT0FS5lj4clAlGIGFUkCGvbGqDwFXQXqh+rNcEFzT+mgeClDrcwIAgGbasOrYkKy3Tzzw1cnBajRLMo4M2Lg6mRvK8irip7Ak/bEtW1uBEPdL2C/ww0t5y4RKm8LRU2BvLH1gN2tYYrE7mJCC6T4qDYscmgLHk2c0ca1qCrgmP/j1Kyq3gxO3EoTOr63iMhToa56uZxg8CL66ustJMzuwceefDOZqtDytD6mn+RkoKn12BD3WsXDrcfkWViHSkFe6sYbJhuqqIXzOeSCZOGYAVnJa3jy45VNhzGMzeg+N6UkkjgG6F0RMm6Tpv4HdLVHm258gqSx6Vb1rFqopZgfm7zMfGI8X6xAE1TSLX6OTjUujWgnVlFYN48gYGIVHXS/9EAUvF7bYOwsZzJw/stEprJSJlF/T0NJnpP5M360j0yrFngMaHLNY3kAqxZ2C/P2ZcNSC6Qa/GUKb2tXwK9g5Q
 VNyb8P4q
 JHL4w89dtE/aWsx4kwXLpxILwKbjiYp58WqFvo5OeLWHFndb0AhSNpFJfOdca3o3Ioi9yTnW1iIiRJg+4Q/BOpBUrI1E82MKNH7DAO3SaXw92Td2wx+NIoC1dS3ZbKsR5vj/GcbzUAxAGt4KL9J3ohm1HzfdnGt73F/PvTflaVFle48i9Vp6/I8RBm/PynMZMeACQ1mb/zDAIVgnrG9gniryRoSxvzca2KEDM85rP2jXVb84ipTuNo7r7LHp8wPNbf91qUSFbbN0NHPHCQIFmFcegntE3CP98A+fKXb94dqFU6mwhAVzdZw94NhkpIyh6GsMC/L3PMd68Idr/C5IXkyzmSDWUwBdcK5VgsEHPkBSgFSt6GEt1bIVScOqzaJ1PMtXhhHA9K+NJVrHeDfitbGLRvjKQdlUTtncP+8TiUl3B2ccvcH3FtKiKvgnAPbQX2GHwMANR+tUauN7bPhesmJVnADxel3TOV7gSAT27PcY4ppXAgQJgB/MwPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to support generic vmalloc, several modifications are required.
If the allocated region belongs to the non-replicated part of the table,
then the normal vmalloc mechanism is suitable.
If the allocated region belongs to the replicated part of the table,
a replicated table for each replica node must be created for this memory.
This region might be replicated after its initialization,
for example, to support replication of text and ro-data
for loadable kernel modules.

Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Co-developed-by: Artem Kuzin <artem.kuzin@huawei.com>
Signed-off-by: Artem Kuzin <artem.kuzin@huawei.com>
Co-developed-by: Nikita Panov <panov.nikita@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 include/linux/mm.h      |   2 +
 include/linux/vmalloc.h |  18 ++
 mm/memory.c             |  61 ++++++
 mm/vmalloc.c            | 454 +++++++++++++++++++++++++++++++++-------
 4 files changed, 461 insertions(+), 74 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 95213a81907c..8a7083c02203 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1885,6 +1885,8 @@ int region_intersects(resource_size_t offset, size_t size, unsigned long flags,
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
+struct page *walk_to_page_node(int nid, const void *addr);
+
 /*
  * Determine if an address is within the vmalloc range
  *
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index aed121d729b0..44eda2175a28 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -31,6 +31,10 @@ struct iov_iter;		/* in uio.h */
 #define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
 #define VM_ALLOW_HUGE_VMAP	0x00000400      /* Allow for huge pages on archs with HAVE_ARCH_HUGE_VMALLOC */
 
+#ifdef CONFIG_KERNEL_REPLICATION
+#define VM_NUMA_SHARED		0x00002000	/* Pages shared between per-NUMA node TT*/
+#endif
+
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
 	!defined(CONFIG_KASAN_VMALLOC)
 #define VM_DEFER_KMEMLEAK	0x00000800	/* defer kmemleak object creation */
@@ -66,6 +70,10 @@ struct vm_struct {
 	phys_addr_t		phys_addr;
 	const void		*caller;
 	unsigned long		requested_size;
+#ifdef CONFIG_KERNEL_REPLICATION
+	int			node;
+	bool			replicated;
+#endif
 };
 
 struct vmap_area {
@@ -177,6 +185,16 @@ extern void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align
 			const void *caller) __alloc_size(1);
 #define __vmalloc_node_range(...)	alloc_hooks(__vmalloc_node_range_noprof(__VA_ARGS__))
 
+#ifdef CONFIG_KERNEL_REPLICATION
+ /*
+  * DO NOT USE this function if you don't understand what it is doing
+  * Use only in pair with vmalloc(vm_flags|=VM_NUMA_SHARED)
+  */
+int __vmalloc_node_replicate_range(const void *addr, gfp_t gfp_mask,
+		pgprot_t prot, unsigned long vm_flags);
+void vunmap_range_replicas(unsigned long addr, unsigned long end);
+#endif
+
 void *__vmalloc_node_noprof(unsigned long size, unsigned long align, gfp_t gfp_mask,
 		int node, const void *caller) __alloc_size(1);
 #define __vmalloc_node(...)	alloc_hooks(__vmalloc_node_noprof(__VA_ARGS__))
diff --git a/mm/memory.c b/mm/memory.c
index 05853e4fb266..49e5a502abd8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <trace/events/kmem.h>
 
@@ -7810,4 +7811,64 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
 {
 	if (is_vm_hugetlb_page(vma))
 		hugetlb_vma_unlock_read(vma);
+
+}
+/**
+ * Walk in replicated tranlation table specified by nid.
+ * If kernel replication is disabled or text is not replicated yet,
+ * value of nid is not used
+ */
+struct page *walk_to_page_node(int nid, const void *vmalloc_addr)
+{
+	unsigned long addr = (unsigned long)vmalloc_addr;
+	struct page *page = NULL;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+
+	if (is_text_replicated())
+		pgd = pgd_offset_pgd(per_node_pgd(&init_mm, nid), addr);
+	else
+		pgd = pgd_offset_pgd(init_mm.pgd, addr);
+
+	if (pgd_none(*pgd))
+		return NULL;
+	if (WARN_ON_ONCE(pgd_leaf(*pgd)))
+		return NULL; /* XXX: no allowance for huge pgd */
+	if (WARN_ON_ONCE(pgd_bad(*pgd)))
+		return NULL;
+
+	p4d = p4d_offset(pgd, addr);
+	if (p4d_none(*p4d))
+		return NULL;
+	if (p4d_leaf(*p4d))
+		return p4d_page(*p4d) + ((addr & ~P4D_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(p4d_bad(*p4d)))
+		return NULL;
+
+	pud = pud_offset(p4d, addr);
+	if (pud_none(*pud))
+		return NULL;
+	if (pud_leaf(*pud))
+		return pud_page(*pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(pud_bad(*pud)))
+		return NULL;
+
+	pmd = pmd_offset(pud, addr);
+	if (pmd_none(*pmd))
+		return NULL;
+	if (pmd_leaf(*pmd))
+		return pmd_page(*pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	if (WARN_ON_ONCE(pmd_bad(*pmd)))
+		return NULL;
+
+	ptep = pte_offset_map(pmd, addr);
+	pte = *ptep;
+	if (pte_present(pte))
+		page = pte_page(pte);
+	pte_unmap(ptep);
+
+	return page;
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..da6facf64db8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -10,6 +10,7 @@
 
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
+#include <linux/numa_kernel_replication.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/sched/signal.h>
@@ -318,7 +319,7 @@ static int vmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 	return err;
 }
 
-static int vmap_range_noflush(unsigned long addr, unsigned long end,
+static int vmap_range_noflush_pgd(pgd_t *pgtable, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift)
 {
@@ -337,7 +338,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	BUG_ON(addr >= end);
 
 	start = addr;
-	pgd = pgd_offset_k(addr);
+	pgd = pgd_offset_pgd(pgtable, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		err = vmap_p4d_range(pgd, addr, next, phys_addr, prot,
@@ -352,6 +353,13 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static int vmap_range_noflush(unsigned long addr, unsigned long end,
+			phys_addr_t phys_addr, pgprot_t prot,
+			unsigned int max_page_shift)
+{
+	return vmap_range_noflush_pgd(init_mm.pgd, addr, end, phys_addr, prot, max_page_shift);
+}
+
 int vmap_page_range(unsigned long addr, unsigned long end,
 		    phys_addr_t phys_addr, pgprot_t prot)
 {
@@ -490,18 +498,17 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 }
 
 /*
- * vunmap_range_noflush is similar to vunmap_range, but does not
- * flush caches or TLBs.
+ * __vunmap_range_noflush_pgd is similar to vunmap_range, but does not
+ * flush caches or TLBs, and able to work with pgd granularity.
  *
  * The caller is responsible for calling flush_cache_vmap() before calling
  * this function, and flush_tlb_kernel_range after it has returned
  * successfully (and before the addresses are expected to cause a page fault
  * or be re-mapped for something else, if TLB flushes are being delayed or
  * coalesced).
- *
- * This is an internal function only. Do not use outside mm/.
  */
-void __vunmap_range_noflush(unsigned long start, unsigned long end)
+static void __vunmap_range_noflush_pgd(pgd_t *pgtable,
+		unsigned long start, unsigned long end)
 {
 	unsigned long next;
 	pgd_t *pgd;
@@ -509,7 +516,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
+	pgd = pgd_offset_pgd(pgtable, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
@@ -523,6 +530,17 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 		arch_sync_kernel_mappings(start, end);
 }
 
+/*
+ * vunmap_range_noflush is similar to __vunmap_range_noflush_pgd, but works
+ * only with init_mm->pgd.
+ *
+ * This is an internal function only. Do not use outside mm/.
+ */
+void __vunmap_range_noflush(unsigned long start, unsigned long end)
+{
+	__vunmap_range_noflush_pgd(init_mm.pgd, start, end);
+}
+
 void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
 	kmsan_vunmap_range_noflush(start, end);
@@ -545,6 +563,18 @@ void vunmap_range(unsigned long addr, unsigned long end)
 	flush_tlb_kernel_range(addr, end);
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+void vunmap_range_replicas(unsigned long addr, unsigned long end)
+{
+	int nid;
+
+	flush_cache_vunmap(addr, end);
+	for_each_memory_node(nid)
+		__vunmap_range_noflush_pgd(init_mm.pgd_numa[nid], addr, end);
+	flush_tlb_kernel_range(addr, end);
+}
+#endif
+
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
 		pgtbl_mod_mask *mask)
@@ -643,7 +673,8 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 	return 0;
 }
 
-static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
+static int vmap_small_pages_range_noflush_pgd(pgd_t *pgtable,
+		unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages)
 {
 	unsigned long start = addr;
@@ -654,7 +685,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
-	pgd = pgd_offset_k(addr);
+	pgd = pgd_offset_pgd(pgtable, addr);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
@@ -671,7 +702,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 }
 
 /*
- * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
+ * __vmap_pages_range_noflush_pgd is similar to vmap_pages_range, but does not
  * flush caches.
  *
  * The caller is responsible for calling flush_cache_vmap() after this
@@ -679,7 +710,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
  *
  * This is an internal function only. Do not use outside mm/.
  */
-int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+static int __vmap_pages_range_noflush_pgd(pgd_t *pgtable, unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
@@ -688,12 +719,13 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
 			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
+		return vmap_small_pages_range_noflush_pgd(pgtable, addr, end,
+				prot, pages);
 
 	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
 		int err;
 
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
+		err = vmap_range_noflush_pgd(pgtable, addr, addr + (1UL << page_shift),
 					page_to_phys(pages[i]), prot,
 					page_shift);
 		if (err)
@@ -705,7 +737,7 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 	return 0;
 }
 
-int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+static int vmap_pages_range_noflush_pgd(pgd_t *pgtable, unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift,
 		gfp_t gfp_mask)
 {
@@ -714,20 +746,35 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (ret)
 		return ret;
-	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+	return __vmap_pages_range_noflush_pgd(pgtable, addr, end, prot, pages, page_shift);
 }
 
-static int __vmap_pages_range(unsigned long addr, unsigned long end,
+int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
+{
+	return vmap_pages_range_noflush_pgd(init_mm.pgd, addr, end, prot, pages,
+						page_shift, gfp_mask);
+}
+
+static int __vmap_pages_range_pgd(pgd_t *pgtable, unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift,
 		gfp_t gfp_mask)
 {
 	int err;
 
-	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
+	err = vmap_pages_range_noflush_pgd(pgtable, addr, end, prot, pages, page_shift, gfp_mask);
 	flush_cache_vmap(addr, end);
 	return err;
 }
 
+static int __vmap_pages_range(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
+{
+	return __vmap_pages_range_pgd(init_mm.pgd, addr, end, prot, pages, page_shift, gfp_mask);
+}
+
 /**
  * vmap_pages_range - map pages to a kernel virtual address
  * @addr: start of the VM area to map
@@ -821,57 +868,12 @@ EXPORT_SYMBOL_GPL(is_vmalloc_or_module_addr);
  */
 struct page *vmalloc_to_page(const void *vmalloc_addr)
 {
-	unsigned long addr = (unsigned long) vmalloc_addr;
-	struct page *page = NULL;
-	pgd_t *pgd = pgd_offset_k(addr);
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep, pte;
-
 	/*
 	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
 	 * architectures that do not vmalloc module space
 	 */
 	VIRTUAL_BUG_ON(!is_vmalloc_or_module_addr(vmalloc_addr));
-
-	if (pgd_none(*pgd))
-		return NULL;
-	if (WARN_ON_ONCE(pgd_leaf(*pgd)))
-		return NULL; /* XXX: no allowance for huge pgd */
-	if (WARN_ON_ONCE(pgd_bad(*pgd)))
-		return NULL;
-
-	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(*p4d))
-		return NULL;
-	if (p4d_leaf(*p4d))
-		return p4d_page(*p4d) + ((addr & ~P4D_MASK) >> PAGE_SHIFT);
-	if (WARN_ON_ONCE(p4d_bad(*p4d)))
-		return NULL;
-
-	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud))
-		return NULL;
-	if (pud_leaf(*pud))
-		return pud_page(*pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	if (WARN_ON_ONCE(pud_bad(*pud)))
-		return NULL;
-
-	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
-		return NULL;
-	if (pmd_leaf(*pmd))
-		return pmd_page(*pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	if (WARN_ON_ONCE(pmd_bad(*pmd)))
-		return NULL;
-
-	ptep = pte_offset_kernel(pmd, addr);
-	pte = ptep_get(ptep);
-	if (pte_present(pte))
-		page = pte_page(pte);
-
-	return page;
+	return walk_to_page_node(first_memory_node, vmalloc_addr);
 }
 EXPORT_SYMBOL(vmalloc_to_page);
 
@@ -2490,13 +2492,39 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 		schedule_work(&drain_vmap_work);
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static void vunmap_range_noflush_replicas(unsigned long start, unsigned long end)
+{
+	if (numa_addr_has_replica((void *)start)) {
+		int node;
+		kmsan_vunmap_range_noflush(start, end);
+
+		/**
+		 *  In some scenarios we might clear
+		 *  empty entries here, which is totally fine
+		 */
+		for_each_memory_node(node)
+			__vunmap_range_noflush_pgd(per_node_pgd(&init_mm, node), start, end);
+	} else {
+		vunmap_range_noflush(start, end);
+	}
+}
+#else
+static void vunmap_range_noflush_replicas(unsigned long start, unsigned long end)
+{
+	vunmap_range_noflush(start, end);
+}
+#endif
+
 /*
  * Free and unmap a vmap area
  */
 static void free_unmap_vmap_area(struct vmap_area *va)
 {
 	flush_cache_vunmap(va->va_start, va->va_end);
-	vunmap_range_noflush(va->va_start, va->va_end);
+
+	vunmap_range_noflush_replicas(va->va_start, va->va_end);
+
 	if (debug_pagealloc_enabled_static())
 		flush_tlb_kernel_range(va->va_start, va->va_end);
 
@@ -3193,7 +3221,11 @@ void __init vm_area_register_early(struct vm_struct *vm, size_t align)
 	BUG_ON(vmap_initialized);
 
 	for (p = &vmlist; (cur = *p) != NULL; p = &cur->next) {
-		if ((unsigned long)cur->addr - addr >= vm->size)
+		/* Why change this? vm_structs for kerenl text
+		 * might end up outside of vmalloc region. (kernel replcation + nokaslr case)
+		 * In that case, underflow will happen and normal vm will be added in the beginning
+		 */
+		if ((unsigned long)cur->addr >= addr + vm->size)
 			break;
 		addr = ALIGN((unsigned long)cur->addr + cur->size, align);
 	}
@@ -3357,17 +3389,74 @@ struct vm_struct *remove_vm_area(const void *addr)
 	return vm;
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline void set_direct_map_page_replicas(const struct vm_struct *area,
+						struct page *page,
+						int (*set_direct_map)(struct page *page))
+{
+	if (area->replicated) {
+		struct page *cursor;
+
+		list_for_each_entry(cursor, &page->lru, lru) {
+			if (page_address(cursor))
+				set_direct_map(cursor);
+		}
+	}
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 static inline void set_area_direct_map(const struct vm_struct *area,
 				       int (*set_direct_map)(struct page *page))
 {
 	unsigned long i;
 
 	/* HUGE_VMALLOC passes small pages to set_direct_map */
-	for (i = 0; i < area->nr_pages; i++)
+	for (i = 0; i < area->nr_pages; i++) {
 		if (page_address(area->pages[i]))
 			set_direct_map(area->pages[i]);
+#ifdef CONFIG_KERNEL_REPLICATION
+		set_direct_map_page_replicas(area,
+				area->pages[i], set_direct_map);
+#endif /* CONFIG_KERNEL_REPLICATION */
+	}
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static void vm_account_replicated_range(struct vm_struct *area,
+					struct page *page,
+					unsigned long *s,
+					unsigned long *e,
+					int *flush)
+{
+	int flush_dmap = 0;
+	unsigned long start = ULONG_MAX, end = 0;
+	unsigned int page_order = vm_area_page_order(area);
+
+	if (area->replicated) {
+		struct page *cursor;
+
+		list_for_each_entry(cursor, &page->lru, lru) {
+			unsigned long addr = (unsigned long)page_address(cursor);
+
+			if (addr) {
+				unsigned long page_size;
+
+				page_size = PAGE_SIZE << page_order;
+				start = min(addr, start);
+				end = max(addr + page_size, end);
+				flush_dmap = 1;
+			}
+		}
+	}
+
+	if (flush_dmap)
+		*flush = flush_dmap;
+
+	*s = start;
+	*e = end;
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 /*
  * Flush the vm mapping and reset the direct map.
  */
@@ -3393,6 +3482,10 @@ static void vm_reset_perms(struct vm_struct *area)
 			end = max(addr + page_size, end);
 			flush_dmap = 1;
 		}
+#ifdef CONFIG_KERNEL_REPLICATION
+		vm_account_replicated_range(area, area->pages[i],
+				&start, &end, &flush_dmap);
+#endif /* CONFIG_KERNEL_REPLICATION */
 	}
 
 	/*
@@ -3438,6 +3531,30 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static void vfree_page_replicas(struct vm_struct *area, struct page *page)
+{
+	if (area->replicated) {
+		struct page *cursor, *tmp;
+
+		list_for_each_entry_safe(cursor, tmp, &page->lru, lru) {
+			BUG_ON(!cursor);
+
+			list_del(&cursor->lru);
+			mod_lruvec_page_state(cursor, NR_VMALLOC, -1);
+			/*
+			 * High-order allocs for huge vmallocs are split, so
+			 * can be freed as an array of order-0 allocations
+			 */
+			__free_pages(cursor, 0);
+			cond_resched();
+		}
+	}
+}
+#else
+static void vfree_page_replicas(struct vm_struct *area, struct page *page) { }
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 /*
  * vm_area_free_pages - free a range of pages from a vmalloc allocation
  * @vm: the vm_struct containing the pages
@@ -3455,8 +3572,10 @@ static void vm_area_free_pages(struct vm_struct *vm, unsigned long start_idx,
 	unsigned long i;
 
 	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
-		for (i = start_idx; i < end_idx; i++)
+		for (i = start_idx; i < end_idx; i++) {
+			vfree_page_replicas(vm, vm->pages[i]);
 			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
+		}
 	}
 	free_pages_bulk(vm->pages + start_idx, end_idx - start_idx);
 
@@ -3862,6 +3981,58 @@ memalloc_restore_scope(unsigned int flags)
 		memalloc_flags_restore(flags);
 }
 
+static int __vmap_pages_range_retry(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask, bool nofail)
+{
+	int ret;
+
+	do {
+		ret = __vmap_pages_range(addr, end, prot, pages,
+					page_shift, gfp_mask);
+		if (nofail && (ret < 0))
+			schedule_timeout_uninterruptible(1);
+	} while (nofail && (ret < 0));
+
+	return ret;
+}
+
+#ifdef CONFIG_KERNEL_REPLICATION
+static int __vmap_pages_range_retry_replica_aware(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask, bool nofail, unsigned long flags)
+{
+	int ret;
+
+	if (flags & VM_NUMA_SHARED) {
+		int nid;
+
+		ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
+						page_shift, gfp_mask);
+		for_each_memory_node(nid) {
+			pgd_t *pgd = per_node_pgd(&init_mm, nid);
+
+			do {
+				ret = __vmap_pages_range_noflush_pgd(pgd, addr, end, prot, pages,
+						page_shift);
+				if (nofail && (ret < 0))
+					schedule_timeout_uninterruptible(1);
+			} while (nofail && (ret < 0));
+
+			if (ret < 0)
+				goto out;
+		}
+
+		flush_cache_vmap(addr, end);
+	} else {
+		ret = __vmap_pages_range_retry(addr, end, prot, pages,
+						page_shift, gfp_mask, nofail);
+	}
+out:
+	return ret;
+}
+#endif
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3942,12 +4113,14 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * by the scope API
 	 */
 	flags = memalloc_apply_gfp_scope(gfp_mask);
-	do {
-		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
-				page_shift, nested_gfp);
-		if (nofail && (ret < 0))
-			schedule_timeout_uninterruptible(1);
-	} while (nofail && (ret < 0));
+
+#ifdef CONFIG_KERNEL_REPLICATION
+	ret = __vmap_pages_range_retry_replica_aware(addr, addr + size, prot, area->pages,
+					page_shift, nested_gfp, nofail, area->flags);
+#else
+	ret = __vmap_pages_range_retry(addr, addr + size, prot, area->pages,
+					page_shift, nested_gfp, nofail);
+#endif
 	memalloc_restore_scope(flags);
 
 	if (ret < 0) {
@@ -4076,6 +4249,16 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		goto fail;
 	}
 
+#ifdef CONFIG_KERNEL_REPLICATION
+	/* Check, that for requested region correct replication flag was passed */
+	if (WARN_ON_ONCE(numa_addr_has_replica(area->addr) && !(vm_flags & VM_NUMA_SHARED)))
+		vm_flags |= VM_NUMA_SHARED;
+
+	if (WARN_ON_ONCE(!numa_addr_has_replica(area->addr) && (vm_flags & VM_NUMA_SHARED)))
+		vm_flags &= ~VM_NUMA_SHARED;
+
+	area->node = node;
+#endif
 	/*
 	 * Prepare arguments for __vmalloc_area_node() and
 	 * kasan_unpoison_vmalloc().
@@ -4165,6 +4348,129 @@ void *__vmalloc_node_noprof(unsigned long size, unsigned long align,
 	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
 				gfp_mask, PAGE_KERNEL, 0, node, caller);
 }
+
+#ifdef CONFIG_KERNEL_REPLICATION
+static void numa_replicate_page_range(struct page **src, struct page **dst, int nr_pages)
+{
+	int i;
+	void *from, *to;
+
+	for (i = 0; i < nr_pages; i++) {
+		from = kmap_local_page(src[i]);
+		to = kmap_local_page(dst[i]);
+
+		copy_page(to, from);
+
+		kunmap_local(to);
+		kunmap_local(from);
+	}
+}
+
+int __vmalloc_node_replicate_range(const void *addr, gfp_t gfp_mask,
+		pgprot_t prot, unsigned long vm_flags)
+{
+	int i, ret, node = 0;
+	struct vm_struct *area;
+	unsigned int page_order;
+	unsigned int nr_allocated;
+	struct page **pages;
+	unsigned long area_start, area_end;
+	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
+	unsigned long array_size;
+	unsigned int flags;
+
+
+	gfp_mask |= __GFP_NOWARN;
+	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
+		gfp_mask |= __GFP_HIGHMEM;
+
+	if (unlikely(!numa_addr_has_replica(addr)))
+		return -EINVAL;
+
+	area = find_vm_area(addr);
+	if (unlikely(!area))
+		return -ENOENT;
+
+	if (area->node == NUMA_NO_NODE)
+		return -EINVAL;
+
+	array_size = sizeof(struct page *) * area->nr_pages;
+	if (array_size > PAGE_SIZE)
+		pages = __vmalloc(array_size, nested_gfp);
+	else
+		pages = kmalloc(array_size, nested_gfp);
+
+	if (!pages)
+		return -ENOMEM;
+
+	page_order = vm_area_page_order(area);
+	for (i = 0; i < area->nr_pages; i++)
+		INIT_LIST_HEAD(&area->pages[i]->lru);
+
+	area_start = (unsigned long)area->addr;
+	area_end = (unsigned long)(area->addr + area->nr_pages * PAGE_SIZE);
+
+	for_each_memory_node(node) {
+		if (area->node == node)
+			continue;
+
+		nr_allocated = vm_area_alloc_pages(gfp_mask | __GFP_NOWARN,
+			node, page_order, area->nr_pages, pages);
+		if (nr_allocated != area->nr_pages)
+			goto fail_alloc_pages;
+
+		for (i = 0; i < area->nr_pages; i++)
+			list_add(&pages[i]->lru, &area->pages[i]->lru);
+
+		__vunmap_range_noflush_pgd(init_mm.pgd_numa[node],
+					 area_start, area_end);
+
+		/*
+		 * We can't fail here (hopefully)
+		 * Possible errors: not enough memory for tables and not empty entries.
+		 * Both unrealistic because we just cleared entries in existed tables.
+		 */
+
+		numa_replicate_page_range(area->pages, pages, area->nr_pages);
+
+		flags = memalloc_apply_gfp_scope(gfp_mask);
+
+
+		ret = __vmap_pages_range_noflush_pgd(per_node_pgd(&init_mm, node), area_start,
+					area_end, prot, area->pages, page_order + PAGE_SHIFT);
+
+		memalloc_restore_scope(flags);
+		if (ret != 0)
+			goto fail_map_pages;
+
+		for (i = 0; i < area->nr_pages; i++)
+			pages[i] = NULL;
+	}
+	kvfree(pages);
+	flush_cache_vmap(area_start, area_end);
+	flush_tlb_kernel_range(area_start, area_end);
+	area->replicated = true;
+
+	return 0;
+fail_alloc_pages:
+	for (i = 0; i < nr_allocated; i++)
+		__free_pages(pages[i], 0);
+
+fail_map_pages:
+	kfree(pages);
+	for (i = 0; i < area->nr_pages; i++) {
+		struct page *page, *tmp;
+
+		list_for_each_entry_safe(page, tmp, &area->pages[i]->lru, lru) {
+			list_del(&page->lru);
+			__free_pages(page, 0);
+		}
+	}
+
+	return ret;
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 /*
  * This is only for performance analysis of vmalloc and stress purpose.
  * It is required by vmalloc test module, therefore do not use it other
-- 
2.34.1


