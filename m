Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0323CA1013
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 07:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F748E0007; Sun,  7 Sep 2025 03:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D196F8E0001; Sun,  7 Sep 2025 03:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1D88E0007; Sun,  7 Sep 2025 03:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABBA18E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 03:00:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B80386C82
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:35 +0000 (UTC)
X-FDA: 83861556030.07.12203A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A02F540008
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VlOT3EFe;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757228433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wnOGZbPA+pJ6E43mrAV34hs4thPz+wgGsrrH/lPENw=;
	b=eH6HEhk0d7xtko+ruBd25fzAHnPZzodE7nzVEknkenRuCbsBFhSxmGb5UJJxMS+abdZ1XW
	05/DQT1q+9MS1McbO+WFkUTUBsc7StOY2w8m1ZTLhtEzlBXGwPzmC7wW4bUCV2STYfn/wh
	rpMsvj5Egves3e1yL8w1tUfHnw6bpuQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VlOT3EFe;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757228433; a=rsa-sha256;
	cv=none;
	b=z7ZFZCb/vD17mg++Wm2m2BSxjFUIEi74vl5DUYSeg81fWkT56KhUzet2TrFenxw3KknMNS
	SClamheSy9ymanJtQXNBTIcjyu+EN/PD4b9HN0IZCnAY6NT0pA0tPWCB4TkuQhGM6BepTF
	yernqZIKv74ASmqV0qa1JMWY3rV2u10=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE165419A3;
	Sun,  7 Sep 2025 07:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9F1C4CEF8;
	Sun,  7 Sep 2025 07:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757228432;
	bh=7kJZgdLvlkty1R/matrNEswbE0YZDCA8+y+K2Ilbxag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlOT3EFeKTyres4rPOzS3AcP7VlATID/HLbJnnDh+6EybF7zeQv7+4diYrdOTInvV
	 w4me702fgy6FjrPR4FwzHTTFmr3lVzJMmNRCZnqh0NkqX7TC+yzVxBXk1C62NF7sxS
	 yn/HfG1Np32F2F0BESMRSBuw51pYAOVWYEWiF3BDEyt36cwAXoIxrNj+ODbX+v7ZPV
	 pyFVeF0F+isNGfwuRMNgO6oUDW++IlIXsSV5TQBC3QZ6CSg6wC7lR93ggtg3I/Zx7X
	 qJQ5+1W3VTPFZOdeCGaLbIng+d6XQYBGvbnPyLkDDuLmlzW0ERUXdGsasuVtHbptLj
	 dIQQo34KASMOw==
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
Subject: [PATCH v2 1/2] kho: add support for preserving vmalloc allocations
Date: Sun,  7 Sep 2025 10:00:18 +0300
Message-ID: <20250907070022.2177974-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250907070022.2177974-1-rppt@kernel.org>
References: <20250907070022.2177974-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A02F540008
X-Stat-Signature: g4towurx3h1z3apxbp49bypm1a6dofzh
X-Rspam-User: 
X-HE-Tag: 1757228433-421362
X-HE-Meta: U2FsdGVkX1/6dn34+Kh82hEIGPxmlpzraXtExDycoEjox2vGochGcCF/ife2B7r5+v3E3+CKV8lnYbpXgMd0TQ2v4NLcZNN9XzxMC0MItcdMH+nfy1cl2bvDh2tftH3DiCuHyd7PpwJx/1U/l4k9CMIO8M2Ried5Yk6bEfp9ok3CJ8aIvK5VyHaI8a2AmAwasxc5saxK2ltjSifisZ2wGhQUJ2yu1TrsaEJB7EXrPZh/920f0UBkeKfDDPBrYL6hCy12DiI6nJw0D23lh+17IPqcgdMfr9+ME5z9tVWeCeH4BBl6zXTC2ZeZEnB/rxrcq8W9H0a+peLF5Z0o2BlDrJ8As2o1d1G+CdlmluHPxZl4GkJnRzgXFszUTaMDEKuROZKvhksaJoM3LqqYq4ll3kzYWfg8TACB03BUtZII/CWD2VW8WlPG+xPgkDYtdeQnNhp49QWQqnxOaP1m/YnltTIvT7Wq7IRo50j3U9MIt9ECvQZTYbr1Web/uyJkhGITpsF3TTTViC0gc9ASZsRammkDom/QciQqdMtequJsM2SMIoAUpzpWiTHD/DfEo7DW06j5eud8GWUF8acBm6IrTzftrc5lAZNyMVdrfRwaZdDTZH/kfICMRdimI03JCMx8KCYnwKUEQw3KL11yx8hj2dSQ43vQNFHhXyvawfZoJ0oxYJbUAy3TQ34+YfC+CuEx0c7z7a5i/cYkFV0HXN+7Li5Izg/cCJFlsYC0JO5ZiwTo80z/noMsRTjjQopJUUH5ENwmwQFpmUqBRiTUJW7KurYdYSw7r6BJJuLnVNjf6Lgo5LFFMz//L+bKGG5IFZ1VrmaLRYpVuanbxGrXkn6GyUN/IFG5dIg1+50TxqMnjBn9M0rguViOBdY+/8AqpxmbmwQbl1kgE5W86mp1/g1+Bgs7ZyMBLAwKadA/dPvtdKkT5gN7b724T4U05SjdW11CImhF6HKBYn0CCRe4SrF
 IRQ==
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
 include/linux/kexec_handover.h |  12 ++
 kernel/kexec_handover.c        | 200 +++++++++++++++++++++++++++++++++
 2 files changed, 212 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 348844cffb13..b7bf3bf11019 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -42,8 +42,10 @@ struct kho_serialization;
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
+int kho_preserve_vmalloc(void *ptr, phys_addr_t *preservation);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
 struct folio *kho_restore_folio(phys_addr_t phys);
+void *kho_restore_vmalloc(phys_addr_t preservation);
 int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -70,11 +72,21 @@ static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_preserve_vmalloc(void *ptr, phys_addr_t *preservation)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
 }
 
+static inline void *kho_restore_vmalloc(phys_addr_t preservation)
+{
+	return NULL;
+}
+
 static inline int kho_add_subtree(struct kho_serialization *ser,
 				  const char *name, void *fdt)
 {
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ecd1ac210dbd..c4560ff9b1fc 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+#include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
 
@@ -733,6 +734,205 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_phys);
 
+struct kho_vmalloc_chunk;
+
+struct kho_vmalloc_hdr {
+	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
+	unsigned int total_pages;	/* only valid in the first chunk */
+	unsigned int flags;		/* only valid in the first chunk */
+	unsigned short order;		/* only valid in the first chunk */
+	unsigned short num_elms;
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
+#define KHO_VMALLOC_FLAGS_MASK	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
+
+static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur)
+{
+	struct kho_vmalloc_chunk *chunk;
+	int err;
+
+	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!chunk)
+		return NULL;
+
+	err = kho_preserve_phys(virt_to_phys(chunk), PAGE_SIZE);
+	if (err)
+		goto err_free;
+	if (cur)
+		KHOSER_STORE_PTR(cur->hdr.next, chunk);
+	return chunk;
+
+err_free:
+	kfree(chunk);
+	return NULL;
+}
+
+static void kho_vmalloc_free_chunks(struct kho_vmalloc_chunk *first_chunk)
+{
+	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_vmalloc_chunk *chunk = first_chunk;
+
+	while (chunk) {
+		unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
+		struct kho_vmalloc_chunk *tmp = chunk;
+
+		__kho_unpreserve(track, pfn, pfn + 1);
+
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		kfree(tmp);
+	}
+}
+
+/**
+ * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
+ * @ptr: pointer to the area in vmalloc address space
+ * @preservation: returned physical address of preservation metadata
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
+int kho_preserve_vmalloc(void *ptr, phys_addr_t *preservation)
+{
+	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_vmalloc_chunk *chunk, *first_chunk;
+	struct vm_struct *vm = find_vm_area(ptr);
+	unsigned int order, flags;
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
+	chunk = new_vmalloc_chunk(NULL);
+	if (!chunk)
+		return -ENOMEM;
+	first_chunk = chunk;
+	first_chunk->hdr.total_pages = vm->nr_pages;
+	first_chunk->hdr.flags = flags;
+	first_chunk->hdr.order = order;
+
+	for (int i = 0; i < vm->nr_pages; i += (1 << order)) {
+		phys_addr_t phys = page_to_phys(vm->pages[i]);
+
+		err = __kho_preserve_order(track, PHYS_PFN(phys), order);
+		if (err)
+			goto err_free;
+
+		chunk->phys[chunk->hdr.num_elms] = phys;
+		chunk->hdr.num_elms++;
+		if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->phys)) {
+			chunk = new_vmalloc_chunk(chunk);
+			if (!chunk)
+				goto err_free;
+		}
+	}
+
+	*preservation = virt_to_phys(first_chunk);
+	return 0;
+
+err_free:
+	kho_vmalloc_free_chunks(first_chunk);
+	return err;
+}
+EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
+
+/**
+ * kho_restore_vmalloc - recreates and populates an area in vmalloc address
+ * space from the preserved memory.
+ * @preservation: physical address of the preservation metadata.
+ *
+ * Recreates an area in vmalloc address space and populates it with memory that
+ * was preserved using kho_preserve_vmalloc().
+ *
+ * Return: pointer to the area in the vmalloc address space, NULL on failure.
+ */
+void *kho_restore_vmalloc(phys_addr_t preservation)
+{
+	struct kho_vmalloc_chunk *chunk = phys_to_virt(preservation);
+	unsigned int align, order, shift, flags;
+	unsigned int idx = 0, nr;
+	unsigned long addr, size;
+	struct vm_struct *area;
+	struct page **pages;
+	int err;
+
+	flags = chunk->hdr.flags;
+	if (flags & ~KHO_VMALLOC_FLAGS_MASK)
+		return NULL;
+
+	nr = chunk->hdr.total_pages;
+	pages = kvmalloc_array(nr, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return NULL;
+	order = chunk->hdr.order;
+	shift = PAGE_SHIFT + order;
+	align = 1 << shift;
+
+	while (chunk) {
+		struct page *page;
+
+		for (int i = 0; i < chunk->hdr.num_elms; i++) {
+			phys_addr_t phys = chunk->phys[i];
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


