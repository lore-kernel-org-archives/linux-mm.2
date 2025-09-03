Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC670CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 06:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B7A8E0007; Wed,  3 Sep 2025 02:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C418E0001; Wed,  3 Sep 2025 02:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F4E8E0007; Wed,  3 Sep 2025 02:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEF088E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:30:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 826D61DE583
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:30:31 +0000 (UTC)
X-FDA: 83846965062.20.022D0A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EC6D110000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:30:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K12YYfWJ;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756881029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWZwFYnc9AbNVc+pd/rQ/Kr2nKuVQa6MiB8177P1n/U=;
	b=OmrjkSPQJCmxQsDx8zuIF4R1OFkFHKlUqKmQF9BCLYLdTsT84nfvu+HzZWss6jbr8AEYD2
	Z8zQojaKF47MrYJKUrdBtm2cIEWR4qgwiA7s6Xu8kZ17yCdrL0y8eAJGrYNP0Sj1fTvEZS
	HIqGX3HcBqV8dUE4JJ1y7IMm+whc0WU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K12YYfWJ;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756881030; a=rsa-sha256;
	cv=none;
	b=JltVtZCmjsTWNLi/m/P4wa+2pz2D3cFCu/LXOfRPRbhwBIojpifwPms9az3V+N2xvCDdGy
	/D9qxQRn7IQVwU3MxU3RDkYbi2p+KQuGCvulXOAF8twNPOpOVPs5oKsk1WAi89F3/wTLK7
	0FL6LluABzcA72KSPVI/idJ3D4SdKqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BEE860239;
	Wed,  3 Sep 2025 06:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1168CC4CEF1;
	Wed,  3 Sep 2025 06:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756881029;
	bh=71VhAKjgW0E1aO+puSjE7uBqc/1v+0Vas8jZUkLzLuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K12YYfWJlksaS+EWHjzH/MCzJZAzvwF42oeLtOIsRgk4D+3RztSI8WhbMfCjqJxmR
	 eplt3hMq0MVq+NIojWepYjQWaRZCMARGfsRSr0854+nCxMqRFbm6F9rDv/cbfQSrqT
	 ys8u6+IBxtZD8sD9pLU/HvRfwzXwsf5Pr036ogTFzG8vV+vA0QwH+iQhpi5oUxZLC5
	 7sGTLV9Bj+sgMH/SG8aLnDrKZXk2f/NvNptrTHkZjXgEawFmwf/cwC/jR7DIft+I9F
	 MBfH3Jt3v/VWqh1CkKzm1zgoqSXV8eDEb4vhx9rwaWivag2I3VH47wVc3MPjRYlRZa
	 7wbfsptG8q5MQ==
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
Subject: [PATCH 1/2] kho: add support for preserving vmalloc allocations
Date: Wed,  3 Sep 2025 09:30:17 +0300
Message-ID: <20250903063018.3346652-2-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903063018.3346652-1-rppt@kernel.org>
References: <20250903063018.3346652-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC6D110000C
X-Stat-Signature: nieh781zubri3gcwj69w7yboaem4qtn7
X-Rspam-User: 
X-HE-Tag: 1756881029-878796
X-HE-Meta: U2FsdGVkX1+gZSf3BCAgDjc9Omk4+YHDRf1WMFS+7GNh7eZwAB9iEC2+3nd98Tc9ahNBit3gQfhvcb2GNvmzKdanFKqUx7R2y9/eMIKkj4cyo7I7ATZJoEQ8FQizrXIz2Gbf6AzeFELN8oNEXpnqBRd8R2tDEFOZ2j1oWVVRuDamm4o/tx5FKxm3QfzhnVIs+YyLLertpCEFWcCSQNEvEYjsjFZyNvRC7dVzxJePNkYHbjmK3NnHs53EzyUJzxZKUm3GSP9+i31LtQPynkq+auXmLqUROaq52rdlT+E5AwOg3qCQKxgXz1q/ICdQW5oYrYWH3/A9KEIShkd03/1Qtc9BKmJYZTUgFTIghi1SwrCrRtkcqKOS3Hw0Dc5Df00w+s8Hzbv3s8Th8piLMi1Dycq1XQ/c4UlbAtvazT+dBHHuGci7L4zRnP1dYk9aGM/ts3pjoWJJE1oY+B2BwVJup3ZJXYZQGvthKmJRKLQzlZX5QZrjAquBxKym6eZtc091TpePCeIx96tcuD/obfJifxyQubkReIUSazX/hZnjVqZqBwUEC6ySTeiTtO4+nRHp6JlcBZ5/907xX+Qzd31Q+JZyzTPSqwWyp/yzhfmHRaxhnZ3wtl9ccJ8EpkJzS8t2qYOyHw/7i3zO8On/b3R8UYIPzvwzVHM7FJD0VJlzPTmHfyt9CLoHPYlkxd3lcTiXVTN1u79p/CqizKQicdSfDRBb6dNALsho1lsioe3lCrjBqH0RrWld9et2sNxY2nQa8PGchx4k3Bq4Ed+flpLcibVl+zj+4MIl3O0HDaE0aVe+IloPPpM1Ojc5VO4L7yFwnui8GSEmNp+tzEg133AAif17svO7k3kT7Lb2ea1+qgHRazuhK7NSln6lurnFZxlzX5nHldFjLgKSZUdGZdtk/DMvV1x0yP95voK7ocTYOliX/lMUNIzZXLGtDHiDG1oOC4mUlxcDcv+txZOOgPl
 RjFZLn+P
 7YIiBGlttj/0Bp8TghvZt6F1/5K4T0l9MR1bD2oPJa7ulk4RZM2tlJFkCwgmbfJezVo0zBOxULkARetHfu1U2nHmY4hd6UnTW2sHmDip82UJopOQlsScP7n0r/ebGeWwAZH+fDBlUnWmk2au9EhIzNKq9+1vrXC12bB9aEn+NOV4YKWn/Nihl+0rtSmNsMcbUjh8MExQR4e+55WGDhiZ6RB6OUcAUC69QuDkZpD3luvg/UPYmTaLSgnLx9p0jje0PDGSaX1zJZy6D4Rbzzl1b+oRa1Q0JIYKsvk6hq3tXAXagYW4=
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
 include/linux/kexec_handover.h |  12 +++
 kernel/kexec_handover.c        | 140 +++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+)

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
index ecd1ac210dbd..a11ae79d6bc9 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -18,6 +18,7 @@
 #include <linux/memblock.h>
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
+#include <linux/vmalloc.h>
 
 #include <asm/early_ioremap.h>
 
@@ -733,6 +734,145 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_phys);
 
+struct kho_vmalloc_chunk;
+
+struct kho_vmalloc_hdr {
+	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
+	unsigned int total_pages;	/* only valid in the first chunk */
+	unsigned int num_elms;
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
+int kho_preserve_vmalloc(void *ptr, phys_addr_t *preservation)
+{
+	struct kho_vmalloc_chunk *chunk, *first_chunk;
+	struct vm_struct *vm = find_vm_area(ptr);
+	int err;
+
+	if (!vm)
+		return -EINVAL;
+
+	/* we don't support HUGE_VMAP yet */
+	if (get_vm_area_page_order(vm))
+		return -EOPNOTSUPP;
+
+	chunk = new_vmalloc_chunk(NULL);
+	if (!chunk)
+		return -ENOMEM;
+	first_chunk = chunk;
+	first_chunk->hdr.total_pages = vm->nr_pages;
+
+	for (int i = 0; i < vm->nr_pages; i++) {
+		phys_addr_t phys = page_to_phys(vm->pages[i]);
+
+		err = kho_preserve_phys(phys, PAGE_SIZE);
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
+void *kho_restore_vmalloc(phys_addr_t preservation)
+{
+	struct kho_vmalloc_chunk *chunk = phys_to_virt(preservation);
+	unsigned int idx = 0, nr = 0;
+	struct page **pages;
+	void *ptr;
+
+	nr = chunk->hdr.total_pages;
+	pages = kvmalloc_array(nr, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return NULL;
+
+	while (chunk) {
+		struct page *page;
+
+		for (int i = 0; i < chunk->hdr.num_elms; i++) {
+			page = phys_to_page(chunk->phys[i]);
+			kho_restore_page(page, 0);
+			pages[idx++] = page;
+		}
+
+		page = virt_to_page(chunk);
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		kho_restore_page(page, 0);
+		__free_page(page);
+	}
+
+	ptr = vmap(pages, nr, VM_MAP_PUT_PAGES, PAGE_KERNEL);
+	if (!ptr)
+		goto err_free_pages_array;
+
+	return ptr;
+
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


