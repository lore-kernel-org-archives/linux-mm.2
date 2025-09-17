Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99342CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014B5280004; Wed, 17 Sep 2025 13:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0743280002; Wed, 17 Sep 2025 13:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4FB280004; Wed, 17 Sep 2025 13:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C9374280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:40:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 626CF86E3B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:54 +0000 (UTC)
X-FDA: 83899457628.21.B2CBAE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C86BA40010
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:40:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FAXZMEr8;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758130852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gnp6ceM3s2zWStCAGmJa8ZSsPRhcPrAfJ9CKIGHaIC0=;
	b=7bdeZVtyVTsulfD9XAA4LtNOErCGcfNkZri0bSbm3Y+20Q/yYK3VQlK2msAYuDihYQCR+q
	kQ/eLWQAx8/x9KLMFR2j5ExhR8M5nh3Zu5hnK2EDRkHCZKOSoDsnEu+TwcCpclBLjun8eZ
	wFrSOkBtQ49HWJoTV0/q1IY5k64Io70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758130852; a=rsa-sha256;
	cv=none;
	b=TZInYy/VkK1urKkyQEIak/MIlQj3ORBifSKamHq+ZDWyDnLv+hXreqxHqzWYWoqH4yv7Np
	J3wMtaTpRhhUH30/mAjQePXUswwvfSSGBXYOX1MJNBgeWg6U1Tdth8A5FLn0FDbiLIPR3E
	CGZoTGpQ8BnpLVQpY/hOq0KotFydn3o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FAXZMEr8;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CB7D6023C;
	Wed, 17 Sep 2025 17:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7778C4CEFA;
	Wed, 17 Sep 2025 17:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758130851;
	bh=g9UTSU7mKXHMD706ZTpvo0p32ufAy0oIGmLbfXKXhCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAXZMEr8KZZlgSJlbISRNQ33VJ5g0BYw/qXtmKT3Bikjm7rG0i2jlf5Gurdno4AxR
	 1r7kxPBsntpO+BCU/Afz6T7L1GuWNbW2ASSlVJPGeoEEVdwH6PWvanekV7UeDfr1MC
	 s+HFoBm3q2nnY5yzvnWNK3AMVV58pLJXAG9CZC0zqI0YQJJKqsBstjKijtb03VWxAt
	 Ulqw2jU+BDrUiqkrOlSVKXRt9iBQOTgapRnvGICFjPgDdlL54+mwEl07bcKzV4T9K4
	 aMxkUacPkUj4Pl31p3MHYqNOrU9MFGOa5mEiXdv38InkEV95ZCH20w7oSNVHlrIMtP
	 EzA1Q7VoDi21Q==
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
Subject: [PATCH v4 3/4] kho: add support for preserving vmalloc allocations
Date: Wed, 17 Sep 2025 20:40:32 +0300
Message-ID: <20250917174033.3810435-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250917174033.3810435-1-rppt@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C86BA40010
X-Stat-Signature: bonc85jsmjfxxdkzcezqnos393h8qeui
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758130852-376106
X-HE-Meta: U2FsdGVkX18MlMf+SV49itEt7wa7c0kvZJB4aSsK+d/oqBsiTwAg4VsmAiEqpYwQIRQJOul8sbqOkrlFGnPSDG4xCcAkJ+vwAh8r6aEFU3VJibyFuDy3zIxxFSKvFxVh5GHagkz+cErcsF/zbZmK3lqkdJ769g53gchGz5ofGzy9jGR24pb9lE0Vl4kQw9D1r5jRsj606y78iW7maPpiEM4X+lWHJQGn0mYa87dr17s0+Y0QNDfjmihSTOqFEhZnGqfh2hl6uKt7xp5NRjQs0VPC5IJ193b9iyi9z6gUNxh1xCuyli///klbWON1O7jEy89d9sfenFnEBNgFp8hcSzrW2LPXgeosUYvusvxzMPltgJowmSl++TRbCYQwBfqes9sNTDBI8E2QyeVYxpK1b2XNSIHyodoCVZ4YGNYVpa43IC8/R323qOWjp9sFeY5eDjw4URNhI591EiPgDZfC4qEtEG7zYQvFQ/upBpzATGxRCvxIG2UHGWIcGIczjKtKd86VIDl4aSgCSW7QyvszHXzRvP9uxR/pdGEaJ+eN6ZIIJT6uixmEFkMwNCnpRPW0n6kegKEcj3KaybBo9T3WPvF8y6rrjfQqQYFmluWWiHaJb/CId6sG60fvW1xVHzouCUCxOVKlXwlDirSGsr4lQFZgGeJTmObmW+1ktHH0UV0mAIMIxu0dWXUNe4arMLmSjfsMV6mzl6jDaEeOUMPpQO6GVSa9UcI+BeQcyywh4Oz1Nz2arXR/yhuFLNSpq7no0jkvpf6zEDlXxsLv2k1h8rK2bTtif/0jjF4yLuE8jXWdN7WFqQ9eIn3yTv/E3as90OPDXAtAdTiYJoD2TH2H3y+xVlROnshYrj2PZd7y/j1M5QX7mvFw/wVYDRPkfdptY0/0cHPf3pulhdZfecCOHlEotKZ9ejEgciZ4Qa4BGmYWVU6Ccb99YrlvD5FloNlnbJGb1ZTf4YE7iXJ6MKe
 0krgc48v
 5uNfdUnLrl8QxYxtqwynbjLmtro61kIPKDbrUMy/AqxCdHxShNVzhg9lJF+yKQO83ugkyNx82+Kz7oQEfHxglKSujGcoDoOVt9TsyVYMP8ln9Kn3EfdU6nAhQangmmiEf/CO36jO8PGZv3bG1dDeHvywD6oGUlCtrpO27eawACUveFKR1ibVfshri3jPXWSrIKwZPkjTYDw1zOyuVdyhdAu80TMyDNMiJXu6I1UI2eNbhpEg=
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
---
 include/linux/kexec_handover.h |  21 +++
 kernel/kexec_handover.c        | 244 +++++++++++++++++++++++++++++++++
 2 files changed, 265 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index cc5c49b0612b..1cb515d8257a 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -39,12 +39,22 @@ struct page;
 
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
+void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -71,11 +81,22 @@ static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
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
 
+static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+{
+	return NULL;
+}
+
 static inline int kho_add_subtree(struct kho_serialization *ser,
 				  const char *name, void *fdt)
 {
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 3ad59c5f9eaa..d670caf6d07f 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+#include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
 
@@ -736,6 +737,249 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
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
+	unsigned int idx = 0, nr;
+	unsigned long addr, size;
+	struct vm_struct *area;
+	struct page **pages;
+	int err;
+
+	vm_flags = kho_flags_to_vmalloc(preservation->flags);
+	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
+		return NULL;
+
+	nr = preservation->total_pages;
+	pages = kvmalloc_array(nr, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return NULL;
+	order = preservation->order;
+	shift = PAGE_SHIFT + order;
+	align = 1 << shift;
+
+	while (chunk) {
+		struct page *page;
+
+		for (int i = 0; chunk->phys[i]; i++) {
+			phys_addr_t phys = chunk->phys[i];
+
+			if (idx + (1 << order) > nr)
+				goto err_free_pages_array;
+
+			for (int j = 0; j < (1 << order); j++) {
+				page = phys_to_page(phys);
+				kho_restore_page(page, 0);
+				pages[idx++] = page;
+				phys += PAGE_SIZE;
+			}
+		}
+
+		page = virt_to_page(chunk);
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		kho_restore_page(page, 0);
+		__free_page(page);
+	}
+
+	if (idx != nr)
+		goto err_free_pages_array;
+
+	area = __get_vm_area_node(nr * PAGE_SIZE, align, shift, vm_flags,
+				  VMALLOC_START, VMALLOC_END, NUMA_NO_NODE,
+				  GFP_KERNEL, __builtin_return_address(0));
+	if (!area)
+		goto err_free_pages_array;
+
+	addr = (unsigned long)area->addr;
+	size = get_vm_area_size(area);
+	err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
+	if (err)
+		goto err_free_vm_area;
+
+	area->pages = pages;
+	area->nr_pages = nr;
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


