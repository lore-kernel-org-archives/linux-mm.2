Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A58DCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635068E001A; Tue,  9 Sep 2025 10:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5358E0003; Tue,  9 Sep 2025 10:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4528E001A; Tue,  9 Sep 2025 10:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36BD78E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:44:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB4DE14050F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:46 +0000 (UTC)
X-FDA: 83869983372.20.4545D05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5B78F1C000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:44:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nTeyXhqa;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHuTpuFDBTx6I41iJVGaHiW2V3hZpXsUAkeGb/SFsyE=;
	b=nPgCjKFpVYMXMR7yYlgHDOAd5H+6ELJLqOZ6DXNvWRkt6rC0xKKm3hTRQh0EoPPEruydS/
	KXbU6kDqcjXIX4Xt+/p6fl6S7a9f0KAKmtfHnoQDhJMXLx+NYErjk3rmB9Dy4XaKUtsvTM
	YEAo60ComA+n7bh31P2ohBrBkAJKn2c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429085; a=rsa-sha256;
	cv=none;
	b=2whBezzh9yrNkqgJEYH0rAduIV1vbUW/KfaPj3TqyZNvgzYWqmxilVLug+O43k3nTrmw6L
	N8cHMD8jW7ltj+GYQQ5ONCS2+LW/q9PibZ4RBpH4vnGaRwMHu2ZRua+3NHc2deYBluPOsy
	E8J/ZN8MS6p+zzx3QkDCB1obj+Uz04c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nTeyXhqa;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C273C6022D;
	Tue,  9 Sep 2025 14:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547C8C4CEFC;
	Tue,  9 Sep 2025 14:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757429084;
	bh=R58t8Ck7gaCyPwSxTfKs4rf/zne/bpphAKyTAFsHSEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTeyXhqaog50wiTHSSHI/usuM6Lz1jubOhD0MerikJmeK4c/dobUWCoKgpcwy2wFK
	 Lb39k544yz4KwqKbBp7ObMKBgessNF88sW9kNtV3Ueo704WFmO60mTKjH0CrO62j2O
	 HdVlqYH1A3Y42pMDsi8xJAc9FsgOPyNeayWGFy1Wd6wgpbDhyiUjCPscw9EP/5yrSi
	 tVhcWdijota3s2Uc6HG8jMDzcVTXp1inUWpKioo0B3Dj28uWySSwbWDLOIe8VwGI0j
	 8IqLOJNwnFkzlz3AxXHJiIA4jQt3cWdaBsmtSeyUztA1fDXjqYXiEOiWJnuxVX7HlF
	 uHD9wGZNDLPpw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Chris Li <chrisl@kernel.org>,
	Jason Miu <jasonmiu@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] kho: add support for preserving vmalloc allocations
Date: Tue,  9 Sep 2025 16:44:23 +0200
Message-ID: <20250909144426.33274-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909144426.33274-1-pratyush@kernel.org>
References: <20250909144426.33274-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B78F1C000B
X-Stat-Signature: igyhsdmetp5iakk74h7ed8f5fmxh8dhr
X-Rspam-User: 
X-HE-Tag: 1757429085-627391
X-HE-Meta: U2FsdGVkX18TNdKZ7O5LQC4D+i1ZiMCcOvmhplGiP1NtUvKRXmGLzZ/kIJfcaKvhl6ywN8lEIYpSpRom9W0jBMjRJS8Sg6Ga/W9zWHhLjJPbT6VhO6Ilky+GfWaalv5EXY9KVPn9MhVuFOmxquBvVBTmZeW8NjI/fal5vOixJ9oPR0JhISjcBk8lf74EO2fy6wl05yXrqDpmeDPh3G8gYsPSLoQwaCWtbCN1rJjPaS++mStgWR/GyCyx7Ot3vGhsCCEiw2oV1yg6aMNTOWlh199yF+dKpRFfdsYRicUdBCWD7zeuHdAx8FLMoDPTrRxI5co1kVCkq4ZY9egWUUX72a1/ymVXTT6qpC/ntdt6KtXcqhXwws8oNrzWbqxpyPEjNNdSWK4IYOx3ahpaNbyJU6v3PBvXjPUTGlz1ARjVhmEreEvXvg082or1Ujv/j+oS8I+Ra/botG8OwuExAlvcDZt74iIvRfzHNARz6TBa9h0UpDwFfxV4yqqILTjU8kXObZ5jzJBHK9+U3Q+3AupKzJlQ0r24N8trkchYbvIUow0NZKE0yHoRGXzttPH3bqqL1q2gtlTeoYge3zgtMxQPqLB6+aWj1GF8zFjvdyOorWGrBNo5I51cccIhrrRwkpZP/rF2aAG2h90FQIIezC5MwJ707O1/aa9X+jG9IHiYl56lmLCtc0eiKY5RIOR96nrU8uecIJ7D+SJVm+HdkmtbB8vUZBtjv2fcTNX5mf5EFU2mYO/mMrM4Ob4Id1scrhRZywV46oLF33KlTFNTVNoJg+ce+uI7Cm1HyncxC0aCJPeCLFkO70IYNJbp/AKqnhz+8CRaEqdawq2npCEi9hXoXjTispde9qERyw1mgoUwBvL1g2h/qpTkzrEQCoNhKEVpjwNr9hk8dodqASY1Zcd8M+D4UyMrDdQ4T5ocqIbBQwWNLHFUV91B3UKCUs6zUi15wgJfM9u94aSK4jf/hrj
 HPLHFbJJ
 pbyzFlzzCvjl+ytFofD/4nB8ebidM3Sb7XnclIZ9zvn0DKiaDQq+x4O32oWi+mptbC8h3yGyKTJS+Z1qu6CJoFDx/a0KNxW8i3jl4gn2AV6ld0h+eXA5h/deOZDVsEZd4SjsRFBLJdBNpPE27yU/b9HCCg7Q6TMv1PIxgxFI4P8ZVvVCCj3zuC25zQAu+jciIq/eDhJUxuAaCjp5A+1ApC2JAsklg1WD6RKYPeUcr/aedocQJF9n3X2rbjNJ+t9M3sVVMprB0q/BC3oQ=
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
[pratyush@kernel.org: use KHO array instead of linked list of pages to
track physical addresses]
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/linux/kexec_handover.h |  21 +++++
 kernel/kexec_handover.c        | 143 +++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 348844cffb136..633f94cec1a35 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/kho_array.h>
 
 struct kho_scratch {
 	phys_addr_t addr;
@@ -37,13 +38,23 @@ struct notifier_block;
 	})
 
 struct kho_serialization;
+struct kho_vmalloc;
 
 #ifdef CONFIG_KEXEC_HANDOVER
+struct kho_vmalloc {
+	struct kho_array ka;
+	unsigned int total_pages;
+	unsigned int flags;
+	unsigned short order;
+};
+
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
+int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
 struct folio *kho_restore_folio(phys_addr_t phys);
+void *kho_restore_vmalloc(struct kho_vmalloc *preservation);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -70,11 +81,21 @@ static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
 }
 
+static inline void *kho_restore_vmalloc(struct kho_vmalloc *preservation)
+{
+	return NULL;
+}
+
 static inline int kho_add_subtree(struct kho_serialization *ser,
 				  const char *name, void *fdt)
 {
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 26f9f5295f07d..5f89134ceeee0 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -19,6 +19,7 @@
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
 #include <linux/kho_array.h>
+#include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
 
@@ -723,6 +724,148 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_phys);
 
+#define KHO_VMALLOC_FLAGS_MASK	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
+
+/**
+ * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
+ * @ptr: pointer to the area in vmalloc address space
+ * @preservation: pointer to metadata for preserved data.
+ *
+ * Instructs KHO to preserve the area in vmalloc address space at @ptr. The
+ * physical pages mapped at @ptr will be preserved and on successful return
+ * @preservation will hold the structure that describes the metadata for the
+ * preserved pages. @preservation itself is not KHO-preserved. The caller must
+ * do that.
+ *
+ * NOTE: The memory allocated with vmalloc_node() variants cannot be reliably
+ * restored on the same node
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
+{
+	struct kho_mem_track *track = &kho_out.ser.track;
+	struct vm_struct *vm = find_vm_area(ptr);
+	unsigned int order, flags;
+	struct ka_iter iter;
+	int err;
+
+	if (!vm)
+		return -EINVAL;
+
+	if (vm->flags & ~KHO_VMALLOC_FLAGS_MASK)
+		return -EOPNOTSUPP;
+
+	flags = vm->flags & KHO_VMALLOC_FLAGS_MASK;
+	order = get_vm_area_page_order(vm);
+
+	preservation->total_pages = vm->nr_pages;
+	preservation->flags = flags;
+	preservation->order = order;
+
+	ka_iter_init_write(&iter, &preservation->ka);
+
+	for (int i = 0, pos = 0; i < vm->nr_pages; i += (1 << order), pos++) {
+		phys_addr_t phys = page_to_phys(vm->pages[i]);
+
+		err = __kho_preserve_order(track, PHYS_PFN(phys), order);
+		if (err)
+			goto err_free;
+
+		err = ka_iter_setpos(&iter, pos);
+		if (err)
+			goto err_free;
+
+		err = ka_iter_setentry(&iter, ka_mk_value(phys));
+		if (err)
+			goto err_free;
+	}
+
+	err = kho_array_preserve(&preservation->ka);
+	if (err)
+		goto err_free;
+
+	return 0;
+
+err_free:
+	kho_array_destroy(&preservation->ka);
+	return err;
+}
+EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
+
+/**
+ * kho_restore_vmalloc - recreates and populates an area in vmalloc address
+ * space from the preserved memory.
+ * @preservation: the preservation metadata.
+ *
+ * Recreates an area in vmalloc address space and populates it with memory that
+ * was preserved using kho_preserve_vmalloc().
+ *
+ * Return: pointer to the area in the vmalloc address space, NULL on failure.
+ */
+void *kho_restore_vmalloc(struct kho_vmalloc *preservation)
+{
+	unsigned int align, order, shift, flags;
+	unsigned int idx = 0, nr;
+	unsigned long addr, size;
+	struct vm_struct *area;
+	struct page **pages;
+	struct ka_iter iter;
+	void *entry;
+	int err;
+
+	flags = preservation->flags;
+	if (flags & ~KHO_VMALLOC_FLAGS_MASK)
+		return NULL;
+
+	err = ka_iter_init_restore(&iter, &preservation->ka);
+	if (err)
+		return NULL;
+
+	nr = preservation->total_pages;
+	pages = kvmalloc_array(nr, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		goto err_ka_destroy;
+	order = preservation->order;
+	shift = PAGE_SHIFT + order;
+	align = 1 << shift;
+
+	ka_iter_for_each(&iter, entry) {
+		phys_addr_t phys = ka_to_value(entry);
+		struct page *page;
+
+		page = phys_to_page(phys);
+		kho_restore_page(page, 0);
+		pages[idx++] = page;
+		phys += PAGE_SIZE;
+	}
+
+	area = __get_vm_area_node(nr * PAGE_SIZE, align, shift, flags,
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
+	kho_array_destroy(&preservation->ka);
+
+	return area->addr;
+
+err_free_vm_area:
+	free_vm_area(area);
+err_free_pages_array:
+	kvfree(pages);
+err_ka_destroy:
+	kho_array_destroy(&preservation->ka);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
+
 /* Handling for debug/kho/out */
 
 static struct dentry *debugfs_root;
-- 
2.47.3


