Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E38DCA1017
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 07:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664348E000A; Sun,  7 Sep 2025 03:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE348E0001; Sun,  7 Sep 2025 03:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48EA68E000A; Sun,  7 Sep 2025 03:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7F58E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 03:00:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5C4F1606F0
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:45 +0000 (UTC)
X-FDA: 83861556450.09.69246D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4EA83140015
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 07:00:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RioIoARx;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757228444; a=rsa-sha256;
	cv=none;
	b=sCqACZ6tBerznUfyD9CLkQo2WkYCuAvNbVfQ/giuEphk2DcGg5qqz+PQsqm4N/uAhYyNUR
	ZDARVKst32YizL9klWHNRAQLw2V7g05mTQTQuy29zblYknmCEE5eoa78i3wBv9VENV5IBO
	DW+0wV8Ue2Vd1KF7UUmcN4FqRF84shI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RioIoARx;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757228444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBihoWB2BZVYrmxK7QxgrmExXp049NTzu8jRGkA+Q/8=;
	b=c+1BFxrsoHoLnfRGurFeBAOV1mqGhfJA8njudKOXSG72ubVReJMJh07zCTi8jUZH0jr3Sh
	Y8hvv7GMhpsSaMa/3/yfcTBDSnwd6OauPJEy8UFuTQpsLFG8urHmdunhklJoC3cY7rBozA
	bR7AJ2GGiuT0J0pl5uhH7sXVxq60Vns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C57CC601BB;
	Sun,  7 Sep 2025 07:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF34C4CEF0;
	Sun,  7 Sep 2025 07:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757228443;
	bh=luBH4/8PXqGM2HNziwU/5uMhkj6i/VmZqnkoGkwcoNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RioIoARxwgT06rU/NNN2OtMbczZJl68wxYgWZ2767kzj/ZtDYgz/+bHqp74XZoq2m
	 laGz/9nducUfx2u1kvrM+8Fsg4ZResbcdsmtz4Lgh+0IRFj29TrZQz3M/MPDXTpl9w
	 s7ElQl8sP6CHMmatQggBR/OheT4rsbPyuyEQOCP2VSkz7zKEM8UEcBgNsf/sXND4zo
	 8fGCaZp61X94TBwrqr6MeUZR59UBIs07HQHu3P2URi0qp+NVW6E0tc+BU8SGJAVl6j
	 bRDD9fXVLApmpFyncFMIgUMa3oPeI0zSupDG0U3aUaKqY3GOgwve1pcdyEr+xot+qp
	 VgV+l9wyuyO2w==
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
Date: Sun,  7 Sep 2025 10:00:21 +0300
Message-ID: <20250907070022.2177974-5-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250907070022.2177974-1-rppt@kernel.org>
References: <20250907070022.2177974-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EA83140015
X-Stat-Signature: h9udtrzy7jfdsyiyn84mrsg9naxwqqef
X-Rspam-User: 
X-HE-Tag: 1757228444-225144
X-HE-Meta: U2FsdGVkX19JAP5ae/hAuQu+WYskcjZvGp4Y04asTJqFfEAtTV52eNf7i5FrNP98ycKS2JVvV37tfwoHvtERtX4OX589qakQP0RB2AsVSDetVtEqnSh2fgk0I1nDm9rjmXWDZGr2LofZfiJ+cqKDhmbnt5xA9K7cbyzL0z97hfbE1UnQO6ohxLKLBr6lo6djbKFDM0HfHXeMukJfk4IRpPXTw3M4YsOhXFfcWDg3BuKZ4otEiBbUbfRmybypPyRHXKjP7r4Qz+5GPnENU9HpXEmVYteInrEEgwA5SMEm79J+jHaVbBf9nYGdlTY/UZhaJkJ3Z6ixAXN9RM55cTHLyG3xXrlmBqyxGLsB89sZRrhOsttaocao7TzIItEBgvp7k4IhWWwb+/Uoki9TJVcXcOH6BLCbu3BTM0cmX7qos03kKYC7FDCFaLn3oAeWO0oc80+XQXv1mnEgXWBNmQwGGpg+uum+XhxdSy2lkaSWpX1isC9Ao1/n2uLk1XO63smsbiBZ/ln49rrcINvmKjaJCxKfDze7BECDFjKYWx3FSS+P8s2BFkKfRnZb6OuXDrXyPmW3ije4eVKvZSaroDDkUxfTfi2aTVOE6PTHfMft/o4z/41FXjGvMB5ji0qjHxaC4ss6If2secypeEj28Bmbnj2sXJZ4yIxuSN/MT0/XdLqVtb1OZxshF/6rF1XY4F6WpM+0KilK50GJLtIODAuvRAQ+UEVDJ+bc99QWrnHHAcRX+Xa0F1AK7wODCwkb9n0g6OGz8fCdaMQhsVQbyRtVFO56Y+GOgCauyzu+NqUtbqRBPa228TGRFoLz+wkuYokVs63PWM9LbuQlZRgG885IIIzf+ihvRWsRohcBQg8ueeWODqy2bZ6fnVkrRXVn9IO5iJaMpbbwOP+tqYoMnDrChARfD/LHEpxwEOYQnKvsnnOdAeqmOQXLybGeX4S0KqCXPt3Xg4/hrV/dEcv1lFl
 TNuBoa6e
 yJrSuPV3rJJ7BOt+SEG75Kb28PMFiUeTjVNeQykiCnlFmCKdhCZbi4RgXgxl8bbuLQb4JDzCZjc6KZKaUb3csTXigOACuSVpn4kvTvE2uUfsJdeproUqwEISSntvDzL4kB3689MiP+RYJKSyaeWgcDNQzCx+5XSZT/klF/ZKonguLmRnBSv5G2P0mRXqKbu/TcXDjVFuIStCUF8Dum3zWssBp5ER3833RTgIEZ7KPVYgXROOHxe0/3IBh/6Uv9j2VtVhumHkIfdE5z6o=
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


