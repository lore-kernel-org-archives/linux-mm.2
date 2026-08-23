Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4A0C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 11:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 022D56B00A3; Sun, 23 Aug 2026 07:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CCC6B00A4; Sun, 23 Aug 2026 07:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05786B00A5; Sun, 23 Aug 2026 07:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C03B36B00A3
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:47:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43A911602FB
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:47:15 +0000 (UTC)
X-FDA: 85132358430.22.21D30DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9542E20008
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:47:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+w987WX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787485633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VP6xAszPN9d5Ab+tWR5O9C7cLz2aPGLpAHH/Gr7UO8o=;
	b=4iwZExjdyEPdaVOj58tn1jInLSV5PkV5k6UEGQ+93zrdF5yOOvKMRxESGv9pjffFlrip3n
	Sjzt2EDRHCt3/Vkbo3YnVwO01QzVCEU/Zy829cNTjAvoAkE8u7xqrRleUgvzCizaWScMNi
	r20CM036/p2+5iYzGaDN4qSydRSLlpA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+w987WX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787485633;
	b=SyHiBAPmTRDjukTHei+sGwOUxFZrUGeMNZ5Mhh56oSvs6E//92/0g6bxvNGD5h0zcmOh9T
	6sEq3jlY7hwTEJW51+2EjbTaZp/qBdO8//fy1OdaFa8YqrhMlmRNwGsNrKw9FoPwft2cz3
	FgC1moig4EfogKF/4yTxjSh7hghg3XM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9CDF40103;
	Sun, 23 Aug 2026 11:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC6E1F00A3A;
	Sun, 23 Aug 2026 11:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787485632;
	bh=VP6xAszPN9d5Ab+tWR5O9C7cLz2aPGLpAHH/Gr7UO8o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H+w987WXJaPHn2bT6gKuUd72cuh1y13kfP506djkCA0zXRW/jORubuL195QaKVqmG
	 KuCmgCTHchPs/NniDr3HKwZqjXGQs3pex3kFQlGOv8/qmIVpaZRNERU7Dq5clxtTL1
	 g55BGIwhPam9+5AxnN7wlrCC/hP1Zp4Tw77b4/3dE1OxfgpIsQHjcEK9GPfawCOMs6
	 qwH2PXIXAxF94xauBdmZSyzpxHD+65Ap0G9d9F2i4cHYgdYz/i94AWYtOwIQxroq4d
	 id+esyyJnOy+p55d3eNo+FGuBcxpb+1iG6SOZe/vDkAASWckBuVJabv9IoLRGgBvwy
	 zoNlMXUs2wT7Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 14:46:16 +0300
Subject: [PATCH v2 5/6] mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache
 allocations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-execmem-set-vm-perms-v0-2-v2-5-b013a37d84b3@kernel.org>
References: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
In-Reply-To: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Stat-Signature: 53sf5xrobt9tfe35eby7usyc95u579ix
X-Rspamd-Queue-Id: 9542E20008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787485633-761967
X-HE-Meta: U2FsdGVkX18cF+AWZqirGpYbXHHrnAqd3QPoDc0VmIabGX9w/ox4Oy4nOX/nxuBMPvNGTNBl+4rk9t3pTgYNGm26ZKwLMwtR17Z0brj8HUxDHD/79NOMwQlk60P5Wdl/3ufd44ZrMFH06JjF4wCkazBxSOv0jDl3ZgZhwpIBzxDiYfAH2pjC5BEBZ9rNxTdhUv5hZZz4nhHp8KXWwdq9If/16tX2Wy2LuC6yGgJHE2AdNQAh7oMIjpVB2VgewklGb6DqLa6XxFfnd/Z3nVXgmujyUc4Vcd1x1fAvrocBH+1ySYdzNBpoH82fX3f+BEmjBDg+i1NFPJKWB7WhWAsTqlfYMNYlR7YFZtT/Btoi93ZPbtieL+og4PQGnhBnXjHOGXrEo8z6Mg9q3kqnKDD7bvxhCYOWfUlS7FmBXfwKjsUM3bntjVz+1Pffr7eWQz1ABR1SgyK8RKRN0iD/wLPhhB2zaWtkPQwfvhmUGj/rXMvPhQGm0VwZpFtjKzIm0dOr+q8hE5DB7whQbcQOvAH2ndjmyqUMaOwzbDZr0lCeXcyV0tXTNYZYVQJSV8qS0XazpX540OxVwzwhX6RW3bMFsqugn/HnDnpJ6S8+mtBRYwK2s25oVgdJI5+ZZtO6567J5nONyEaNM3DG3v27Ze7Q6gS0il+h3wOi+bB0C5/3VXiVmHHBlRDxaqCeu+CjIjGdXe1UNScDrnRp862kSOqEwdxvDRjCHU6noz4mdeo36i6Ulhi6UvSKLJjXI8bsWWmWzwZw/xkIV997lcDpPsWPxTE83LO3Tww55KmoJdHF4P2jlqKMAH3eDGCqULXjeoR6HuwPIqaAk23g0EN77kBqVj1/oE0b3L5dzh6SKYJO1GtmuLaJx85TmxXau2xTBMoANJRc95HFAB0cDqSFoj4+NADdYT5rXwGAT8Pyxn729USj3xW/es+t8uVPp3YjXSbOBUAQjLQYshCUSNzp0NG
 QcsSwIw2
 oFwpGletDangx+czUTD5hnQy7VCST89q/MLJ1HxcM7yGfQi4aPKh8CguGtprvsSpz6X3Qkoz/gz3LOCo53BaslpG83he23lnd2odVDlLucYfgU4UuYwG/t9Da1HNykpaZUipuOVc0fAukLP3P+Uns5niUYg1YIsijA+5hETl3weax/fGA2mKjlXph0chYjrvh7l6p1GB4jaM4XHmqGnS51SHwr3S88vgpUXiU/eC+tohaPRo2ApZh//reeT/4yZRdpqRXLZh0qBo6//e6FXHZ4zz2qAAcShTwYuwP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initially execmem completely removed direct map alias for the memory
allocated for the ROX cache in PMD_SIZE chunks. When that memory was
freed, its direct map was restored also in PMD_SIZE chunks to avoid
fragmentation of the direct map caused by vmalloc::vm_reset_perms().

This required execmem to implement the wrappers for set_direct_map APIs for
proper sequencing of removal and restoration of the direct map aliases.

Since then x86's CPA gained support for collapsing the direct map page
tables for ROX pages and execmem switched from removing ROX caches from the
direct map to making them ROX there, so execmem only needs to update direct
map alias permissions when freeing the ROX cache memory.

vmalloc already handles those updates for areas with VM_FLUSH_RESET_PERMS
set and vmalloc::vm_reset_perms() does not force split of the direct map
for PMD_SIZE chunks.

Make all execmem vmalloc allocations use VM_FLUSH_RESET_PERMS and remove
custom wrappers for set_direct_map APIs.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/execmem.c | 42 +++++++-----------------------------------
 1 file changed, 7 insertions(+), 35 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 74a178a87e75..d35f1d0ea54a 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -36,6 +36,7 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
 	unsigned long end = range->end;
 	void *p;
 
+	vm_flags |= VM_FLUSH_RESET_PERMS;
 	if (kasan)
 		vm_flags |= VM_DEFER_KMEMLEAK;
 
@@ -113,28 +114,6 @@ static inline unsigned long mas_range_len(struct ma_state *mas)
 	return mas->last - mas->index + 1;
 }
 
-static int execmem_set_direct_map_valid(struct vm_struct *vm, bool valid)
-{
-	unsigned int nr = (1 << get_vm_area_page_order(vm));
-	unsigned int updated = 0;
-	int err = 0;
-
-	for (int i = 0; i < vm->nr_pages; i += nr) {
-		err = set_direct_map_valid_noflush(vm->pages[i], nr, valid);
-		if (err)
-			goto err_restore;
-		updated += nr;
-	}
-
-	return 0;
-
-err_restore:
-	for (int i = 0; i < updated; i += nr)
-		set_direct_map_valid_noflush(vm->pages[i], nr, !valid);
-
-	return err;
-}
-
 static int execmem_force_rw(void *ptr, size_t size)
 {
 	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
@@ -169,9 +148,6 @@ static void execmem_cache_clean(struct work_struct *work)
 
 		if (IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
-			struct vm_struct *vm = find_vm_area(area);
-
-			execmem_set_direct_map_valid(vm, true);
 			mas_store_gfp(&mas, NULL, GFP_KERNEL);
 			vfree(area);
 		}
@@ -312,18 +288,15 @@ static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t si
 	 */
 	mutex_lock(mutex);
 	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
-	if (err)
-		goto err_reset_direct_map;
-
-	p = execmem_cache_alloc_locked(range, size);
-
+	if (!err)
+		p = execmem_cache_alloc_locked(range, size);
 	mutex_unlock(mutex);
 
+	if (err)
+		goto err_free_mem;
+
 	return p;
 
-err_reset_direct_map:
-	mutex_unlock(mutex);
-	execmem_set_direct_map_valid(vm, true);
 err_free_mem:
 	vfree(p);
 	return NULL;
@@ -466,7 +439,6 @@ void *execmem_alloc(enum execmem_type type, size_t size)
 {
 	struct execmem_range *range = &execmem_info->ranges[type];
 	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
-	unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
 	void *p = NULL;
 
@@ -475,7 +447,7 @@ void *execmem_alloc(enum execmem_type type, size_t size)
 	if (use_cache)
 		p = execmem_cache_alloc(range, size);
 	else
-		p = execmem_vmalloc(range, size, pgprot, vm_flags);
+		p = execmem_vmalloc(range, size, pgprot, 0);
 
 	return kasan_reset_tag(p);
 }

-- 
2.53.0


