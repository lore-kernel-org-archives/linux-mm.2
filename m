Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E578BCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390F68E000C; Mon,  8 Sep 2025 06:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3685E8E0001; Mon,  8 Sep 2025 06:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E528E000C; Mon,  8 Sep 2025 06:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158718E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:35:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFB36BCD1D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:48 +0000 (UTC)
X-FDA: 83865727176.22.AC803CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 005B4180007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OB3dtK57;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757327747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBihoWB2BZVYrmxK7QxgrmExXp049NTzu8jRGkA+Q/8=;
	b=BQ6LPKZtIleEFoluCLq4hxH4iANVnjG+CtJtsiNU8OWOZS6CjfMM8tg4graYBzyOSvr57p
	4NVksIQnJ0awxpUQGIr5UvNQrwfxw+cDMPzNYbyRsIaNjAsYk/4InLwCxoHYJ5dcaASnBD
	1TphOAo3hZkiNYu5xw7jZHUGcfiCyXw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OB3dtK57;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757327747; a=rsa-sha256;
	cv=none;
	b=NAI38E5OGdFEU3nOcBH8E9ZAzeW+zIDd91zjpVHBZ1NUGgW3XLW1FPvozzLQUe2+w0w9pT
	O14sCRQShaokSnEk6OfOX0B80s0UwwhVdRpBY3EmzwGzit64GByP5B7h+wMXZB5D+W3+08
	7zouM2Tf/1qP5hnIQRrGkV4wIj4L0ZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89804601EA;
	Mon,  8 Sep 2025 10:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498B3C4CEF9;
	Mon,  8 Sep 2025 10:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757327746;
	bh=luBH4/8PXqGM2HNziwU/5uMhkj6i/VmZqnkoGkwcoNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OB3dtK57qcje3ZPhy1X7LKvnLf5X1PTehI0BCp986MeXT+5cpACLWCwP2ldbxbf2s
	 xR3E2JfxXjb2Qyped613InX2OMANy0+re4H3Kc3nEZqoYMhfPYpx+ntXo/lbXycE3E
	 pk+J5MlavNEHI19iquYcNoNknUBjaiJP4u8pZ/aHdJptzeGkQb1d6sW9PHMml9fJKp
	 hg5/w/SJ0ryJrd9u4539wsNxPZzi/IQq/TARR16s3Y3BbGPKd2xomps2UfXFUD4gsa
	 9ceWVydmmB9jPOsOxARlzn/SgnuPfmZyZXfMVLghlXP/6s6yZTmiMibrKIXkSJKzjz
	 6JvFrO0XPFTtw==
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
Subject: [PATCH v3 1/2] kho: add support for preserving vmalloc allocations
Date: Mon,  8 Sep 2025 13:35:27 +0300
Message-ID: <20250908103528.2179934-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250908103528.2179934-1-rppt@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 005B4180007
X-Stat-Signature: fscm3q85wazz3s46ascugsd8w4g6o963
X-Rspam-User: 
X-HE-Tag: 1757327746-488834
X-HE-Meta: U2FsdGVkX19FGQx13EaeiJHl7p+KaWgacHlXBOyY8k4W50J6xHeFukhj4pkT8tbinlrNURGpNEX5esJKeaL9KcIKhRpnfCak45vTUTGkD/BUtZxdhb4WJq6zJvsWcqgMH8YzHFEiZ0/ozJwTWaLbA6sMDjK2GkQT7v8wUBcbjxwP5To5/SpebycPhQbraODPZCr7hRx+JgEHZoA+0cUQvchFvOB7cnO14SP299CQsBVtSvo0qVm5taD8PCN7pxXiTnd0Gq8h3qWS21D6nGCactdyT+GGhGmKb2RZKqUPal5WA7pKxo6eAK3V2iLV8LPIF2vN7cO4sT2H1bZONN/+Bj4xoIrq4kQ+ub+r2H/FLhSB6HdVRaB+w+pmilfKowpoc2nxXIVGmAsMKlpf0myWIcXbfpTuiNP0G+xI4yq4dwOrkvXDIqyxnr0TU8rMZ29k6w2KTzDu0GAqI+SvS+vq8bc2j1YeGOsllcoBvn1YTTmXfs1MxDjhHBGue3Czbwz4RyLxKNa464DO9+UhQdpLZuvorU2Yqhxtl7bAnJ5gLQj64ltKQ0axaBOSkvEegeY+UgQngTESzYgdTZv+JHbWYlxt7W9exX/afuEJQ0RpdCNbHUbcupDxP7OHdd8HQzDn7s74E/+YkqQl9rGYxG/Zd4Sgq3amnKQLdhLEqVuJGaQXX1PA5/gVymTv3pLN48Jx9Q+vrNSk+sj+sjy4pz1nExqHOOUinEZfBSnUbdhllenqYyY2+kgVp+Nyr6Siahg+/rOAJV52oxLwYA/JxUIrUMw2vldYbdFuutFukbsLchN6WVa89P6ph6vQK8Ffy40jtHbbhAVt2NBcQ1OozwrFHMR3gjSW1D4VuwpD7/ACvfQwpez29Np5Ju4fv4xVaO1sk1oGRSIWbR+VJnemg9/MqQElQBBKmFJmV7VLwXnvn5TijdNpkruSJaqIBeQlMeB/+44QdgqTp8QZzBPShnV
 t/9y8TpI
 aGVlp3SdEqs7lDdyDNYGv/Zs82fCZ0WF5HqOuNWsR2pnPyhOtGVdtmVTVt/Rtq3tqgeOW2leB2Ad/wV22cLoKBjhwQTdIaUttCCYtvv9uOWaB6hZdQrSI9FJ7GQCxQy8F7/p37STUXzvcMhJQCuTG0dksU6itniRWk4s+dY5huV6lLgRFM5wxgn40r+h2sk5026U63uwYWYc3KxNC/PqFP6gWFPnL/X1Ws7qHWFIc9GD5zcCV6b3mDs27dbsi1kWYDfzpdPpLM05D+fQ=
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
index 8079fc4b9189..1177cc5ffa1a 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+#include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
 
@@ -742,6 +743,205 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
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


