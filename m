Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E0ACAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 05:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5202A8E0006; Sun, 21 Sep 2025 01:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0378E0001; Sun, 21 Sep 2025 01:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399438E0006; Sun, 21 Sep 2025 01:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 21EFA8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 01:45:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFE3784B78
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:19 +0000 (UTC)
X-FDA: 83912169558.10.314BD9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EBE0E140006
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 05:45:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSr8p7Wr;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758433518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfPpdX3j7lPpA5+EoLJ15X/HbNNB1vcE/IAFe/tQ0Ro=;
	b=5ny83umdqfFmzBplJIFw1QdFcQ/IPdqIEhJRwxFRk+3L0LUrH25eXvYXjFMLoizajm2lLU
	JqpRex5zdicmw8wiZWe3mXgHyOfPgWSJFMRrTIm2PYNDRjx9X7gtYfGuImbZWlP58LSk8h
	3bhWOWiiw5fZsAzIfXOEeACIIOoODsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758433518; a=rsa-sha256;
	cv=none;
	b=FdntYnZR4rDRwNyRKrrxAzu1eM0nKLdyvYpF1UXwa9DjpbSNrKjweVc5BbUH8azCFxNbRA
	bZSsMYwpDCR2eDdLM/0y7m+0+g9E+XDG+f5aSE4jeSPy3IcxHuDe32uzouf2gwAnkip8ip
	QhripqtfFIb7QpUCGFGs+aD/IuNZ0bw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fSr8p7Wr;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B24044D34;
	Sun, 21 Sep 2025 05:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE285C4CEF7;
	Sun, 21 Sep 2025 05:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758433516;
	bh=UdtTBv2QwpatAQr/Knzj1gnaKukQZfcywFkm+eSQ/P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSr8p7Wr5TDnHz9WPa0os9hZsLx46C7O86UNp2ohW1ItbgvYLKqqzYmsL+H2t+5h4
	 HWJOia1lWYZHclS0A3V0T47Uy7j0yuShx6D9GmeK0YN37YIPDMq7jV3/DsGmjCPEIl
	 oAItSLYspzhwKytrAL3I+3GvTMTJbOFEIMP/vdO15nf9XIazfrrUIi6Aq+Zz+Kjm7g
	 9O54f7dCFauLEu85+N2FEg0oJ+FXRMPDyT4LgZRdWfrTKWvV/r9a8HH32ezKhV/KbR
	 tTQiIGa1LsyPHrDNr0H74C1IvoLDZgRLpML7jQRQ56S+xclzJhGqyPcdFLpuHMfFts
	 zcV5q4slubTSQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/4] kho: add support for preserving vmalloc allocations
Date: Sun, 21 Sep 2025 08:44:57 +0300
Message-ID: <20250921054458.4043761-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250921054458.4043761-1-rppt@kernel.org>
References: <20250921054458.4043761-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nucrbt1x6thc9prkihh93gjyaekjc6n5
X-Rspamd-Queue-Id: EBE0E140006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758433517-274427
X-HE-Meta: U2FsdGVkX1+d3WocOEoBtVNwtKaaZu3R87uTkXa9SPCKWwjIgUCPHCK67rpf/zaHnLPZHkGFQrwOkS7emumPe7VamTnHAmCuXdk3x7M3/9lgD5xvp1X4HZYNed/PXvi6kOAWaa9g0P3LGNJn4AJSwZkHcr/IxmYh22AIeZAMmn+x2GKYd3w2MPwxotSWcv5NVcFotDGTPCy+r+N4umYNhtAdaxHH6uLsMx5BmC1EsbC42AVJg0Jrsj11lWA+QQKNbQ7ADfEZCtBbJWt9ha6oeKSnF8xsJijGuXWY6r/lDuog47KTGbTuEZ+VI9o/FvSikeTfGuqcyCN4zhxX6coHQW1Q1bumRAGoC5wH1mkXI5eiKZFOmBBeG6z2eYyoXG2X/0thpzHGd2HOWY0OrMFzFnk+in9KunkDxL6B1vgsjXHahicM+3MFvTbD7uEu4zgtV8i95PQCxzabPK61LSMmrmbT/NwpSHfpwjdfGio32SlNEhhMH/5e8JBqSeCxmMO2E2ZpP+wh+T9+P6N67EXKNzIImupaBjxyJLTDM81Z5SxGsERlzYTvKChrOS/zHQF6y8Uu4VW8qhX7b/PexgxKTy0IdBxCKHsW0Y7LUUX6DHaZDi0EZ2wVw2xLhZhB8/vD1UCMCVQxeT9fGWirL4IQHdEP29vydhUejwnGL/6A4VRqkpkvPjI8ZDlBWe2OJ6lizrhK1/JqWNMF0m4ekK9arIkeguc8Rvy7GbII7aXDohyejMjoR4Bwe6Cl23b7YhewRZsbBHh/lw59eY/BPSFoo8NgJ1bmbDkv58I53FwTcmMx4YexRNSeUa9ZEmVjB8B5j214YSZy1yvAKL9OgFSMUUZmKC9TSkfVAGTu6CfK0iBmABCJKxugvczR/hQXE1jgn/JzZxbIZJMLamChBo0UibsntpKPeYYkK6fNQGRhVciqHhLPComHpKswcoc7KbhZCUKfjaGE7gsuKjfWLwf
 YTgLihVo
 9mDJIRkrdkfZy3EdhSmJLLZNHGS0y4dCWOCDGobVNaY4CGVl0wnpGgHMS3mJmzSGpo7WWwVpmxUFA/4MGpuRV0Gg4VpQt++4dBQhhCTPFjPFQnASA1yHVI+JY2l47A3EaRYdez/ZJxtARPQHWE3r/et0vaGsusw3boG7nfIsBxLFGsE3qIzBzHe754ZzRuHGRbogakG9ZqzoQVXeBJSkgHMZ5fNyWWkFHa6GHdLyWwx3uBCu3x2KeBrefD3gO2vjtTIRiX9B+R7DfhUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

A vmalloc allocation is preserved using binary structure similar to
global KHO memory tracker. It's a linked list of pages where each page
is an array of physical address of pages in vmalloc area.

kho_preserve_vmalloc() hands out the physical address of the head page
to the caller. This address is used as the argument to
kho_vmalloc_restore() to restore the mapping in the vmalloc address
space and populate it with the preserved pages.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/linux/kexec_handover.h |  28 ++++
 kernel/kexec_handover.c        | 281 +++++++++++++++++++++++++++++++++
 2 files changed, 309 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index cc5c49b0612b..49e36d4ae5dc 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -39,12 +39,23 @@ struct page;
 
 struct kho_serialization;
 
+struct kho_vmalloc_chunk;
+struct kho_vmalloc {
+        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
+        unsigned int total_pages;
+        unsigned short flags;
+        unsigned short order;
+};
+
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned int nr_pages);
+int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 struct folio *kho_restore_folio(phys_addr_t phys);
+struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
+void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -71,11 +82,28 @@ static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_preserve_vmalloc(void *ptr,
+				       struct kho_vmalloc *preservation)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
 }
 
+static inline struct page *kho_restore_pages(phys_addr_t phys,
+					     unsigned int nr_pages)
+{
+	return NULL;
+}
+
+static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+{
+	return NULL;
+}
+
 static inline int kho_add_subtree(struct kho_serialization *ser,
 				  const char *name, void *fdt)
 {
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index fd80be3b12fd..e6380d8dce57 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+#include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
 
@@ -274,6 +275,37 @@ struct folio *kho_restore_folio(phys_addr_t phys)
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
 
+/**
+ * kho_restore_pages - restore list of contiguous order 0 pages.
+ * @phys: physical address of the first page.
+ * @nr_pages: number of pages.
+ *
+ * Restore a contiguous list of order 0 pages that was preserved with
+ * kho_preserve_pages().
+ *
+ * Return: 0 on success, error code on failure
+ */
+struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
+{
+	const unsigned long start_pfn = PHYS_PFN(phys);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long pfn = start_pfn;
+
+	while (pfn < end_pfn) {
+		const unsigned int order =
+			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
+		struct page *page = kho_restore_page(PFN_PHYS(pfn));
+
+		if (!page)
+			return NULL;
+		split_page(page, order);
+		pfn += 1 << order;
+	}
+
+	return pfn_to_page(start_pfn);
+}
+EXPORT_SYMBOL_GPL(kho_restore_pages);
+
 /* Serialize and deserialize struct kho_mem_phys across kexec
  *
  * Record all the bitmaps in a linked list of pages for the next kernel to
@@ -763,6 +795,255 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
+struct kho_vmalloc_hdr {
+	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
+};
+
+#define KHO_VMALLOC_SIZE				\
+	((PAGE_SIZE - sizeof(struct kho_vmalloc_hdr)) / \
+	 sizeof(phys_addr_t))
+
+struct kho_vmalloc_chunk {
+	struct kho_vmalloc_hdr hdr;
+	phys_addr_t phys[KHO_VMALLOC_SIZE];
+};
+
+static_assert(sizeof(struct kho_vmalloc_chunk) == PAGE_SIZE);
+
+/* vmalloc flags KHO supports */
+#define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
+
+/* KHO internal flags for vmalloc preservations */
+#define KHO_VMALLOC_ALLOC	0x0001
+#define KHO_VMALLOC_HUGE_VMAP	0x0002
+
+static unsigned short vmalloc_flags_to_kho(unsigned int vm_flags)
+{
+	unsigned short kho_flags = 0;
+
+	if (vm_flags & VM_ALLOC)
+		kho_flags |= KHO_VMALLOC_ALLOC;
+	if (vm_flags & VM_ALLOW_HUGE_VMAP)
+		kho_flags |= KHO_VMALLOC_HUGE_VMAP;
+
+	return kho_flags;
+}
+
+static unsigned int kho_flags_to_vmalloc(unsigned short kho_flags)
+{
+	unsigned int vm_flags = 0;
+
+	if (kho_flags & KHO_VMALLOC_ALLOC)
+		vm_flags |= VM_ALLOC;
+	if (kho_flags & KHO_VMALLOC_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
+	return vm_flags;
+}
+
+static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
+{
+	struct kho_vmalloc_chunk *chunk;
+	int err;
+
+	chunk = (struct kho_vmalloc_chunk *)get_zeroed_page(GFP_KERNEL);
+	if (!chunk)
+		return NULL;
+
+	err = kho_preserve_pages(virt_to_page(chunk), 1);
+	if (err)
+		goto err_free;
+	if (cur)
+		KHOSER_STORE_PTR(cur->hdr.next, chunk);
+	return chunk;
+
+err_free:
+	free_page((unsigned long)chunk);
+	return NULL;
+}
+
+static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
+{
+	struct kho_mem_track *track = &kho_out.ser.track;
+	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
+
+	__kho_unpreserve(track, pfn, pfn + 1);
+
+	for (int i = 0; chunk->phys[i]; i++) {
+		pfn = PHYS_PFN(chunk->phys[i]);
+		__kho_unpreserve(track, pfn, pfn + 1);
+	}
+}
+
+static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
+{
+	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(kho_vmalloc->first);
+
+	while (chunk) {
+		struct kho_vmalloc_chunk *tmp = chunk;
+
+		kho_vmalloc_unpreserve_chunk(chunk);
+
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		kfree(tmp);
+	}
+}
+
+/**
+ * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
+ * @ptr: pointer to the area in vmalloc address space
+ * @preservation: placeholder for preservation metadata
+ *
+ * Instructs KHO to preserve the area in vmalloc address space at @ptr. The
+ * physical pages mapped at @ptr will be preserved and on successful return
+ * @preservation will hold the physical address of a structure that describes
+ * the preservation.
+ *
+ * NOTE: The memory allocated with vmalloc_node() variants cannot be reliably
+ * restored on the same node
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
+{
+	struct kho_vmalloc_chunk *chunk;
+	struct vm_struct *vm = find_vm_area(ptr);
+	unsigned int order, flags, nr_contig_pages;
+	unsigned int idx = 0;
+	int err;
+
+	if (!vm)
+		return -EINVAL;
+
+	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+		return -EOPNOTSUPP;
+
+	flags = vmalloc_flags_to_kho(vm->flags);
+	order = get_vm_area_page_order(vm);
+
+	chunk = new_vmalloc_chunk(NULL);
+	if (!chunk)
+		return -ENOMEM;
+	KHOSER_STORE_PTR(preservation->first, chunk);
+
+	nr_contig_pages = (1 << order);
+	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
+		phys_addr_t phys = page_to_phys(vm->pages[i]);
+
+		err = kho_preserve_pages(vm->pages[i], nr_contig_pages);
+		if (err)
+			goto err_free;
+
+		chunk->phys[idx++] = phys;
+		if (idx == ARRAY_SIZE(chunk->phys)) {
+			chunk = new_vmalloc_chunk(chunk);
+			if (!chunk)
+				goto err_free;
+			idx = 0;
+		}
+	}
+
+	preservation->total_pages = vm->nr_pages;
+	preservation->flags = flags;
+	preservation->order = order;
+
+	return 0;
+
+err_free:
+	kho_vmalloc_free_chunks(preservation);
+	return err;
+}
+EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
+
+/**
+ * kho_restore_vmalloc - recreates and populates an area in vmalloc address
+ * space from the preserved memory.
+ * @preservation: preservation metadata.
+ *
+ * Recreates an area in vmalloc address space and populates it with memory that
+ * was preserved using kho_preserve_vmalloc().
+ *
+ * Return: pointer to the area in the vmalloc address space, NULL on failure.
+ */
+void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+{
+	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+	unsigned int align, order, shift, vm_flags;
+	unsigned long total_pages, contig_pages;
+	unsigned long addr, size;
+	struct vm_struct *area;
+	struct page **pages;
+	unsigned int idx = 0;
+	int err;
+
+	vm_flags = kho_flags_to_vmalloc(preservation->flags);
+	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+		return NULL;
+
+	total_pages = preservation->total_pages;
+	pages = kvmalloc_array(total_pages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return NULL;
+	order = preservation->order;
+	contig_pages = (1 << order);
+	shift = PAGE_SHIFT + order;
+	align = 1 << shift;
+
+	while (chunk) {
+		struct page *page;
+
+		for (int i = 0; chunk->phys[i]; i++) {
+			phys_addr_t phys = chunk->phys[i];
+
+			if (idx + contig_pages > total_pages)
+				goto err_free_pages_array;
+
+			page = kho_restore_pages(phys, contig_pages);
+			if (!page)
+				goto err_free_pages_array;
+
+			for (int j = 0; j < contig_pages; j++)
+				pages[idx++] = page;
+
+			phys += contig_pages * PAGE_SIZE;
+		}
+
+		page = kho_restore_pages(virt_to_phys(chunk), 1);
+		if (!page)
+			goto err_free_pages_array;
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		__free_page(page);
+	}
+
+	if (idx != total_pages)
+		goto err_free_pages_array;
+
+	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
+				  vm_flags, VMALLOC_START, VMALLOC_END,
+				  NUMA_NO_NODE, GFP_KERNEL,
+				  __builtin_return_address(0));
+	if (!area)
+		goto err_free_pages_array;
+
+	addr = (unsigned long)area->addr;
+	size = get_vm_area_size(area);
+	err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
+	if (err)
+		goto err_free_vm_area;
+
+	area->nr_pages = total_pages;
+	area->pages = pages;
+
+	return area->addr;
+
+err_free_vm_area:
+	free_vm_area(area);
+err_free_pages_array:
+	kvfree(pages);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
+
 /* Handling for debug/kho/out */
 
 static struct dentry *debugfs_root;
-- 
2.50.1


