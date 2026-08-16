Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52CDBC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 11:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB226B080F; Sun, 16 Aug 2026 07:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492FE6B0811; Sun, 16 Aug 2026 07:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A94C6B0812; Sun, 16 Aug 2026 07:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 151596B080F
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:00:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DA07A2EC2
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:00:27 +0000 (UTC)
X-FDA: 85106838894.22.F0EDCC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id EAD42140008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:00:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFSkd1RR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786878025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VP6xAszPN9d5Ab+tWR5O9C7cLz2aPGLpAHH/Gr7UO8o=;
	b=aKY6ophQdQj7lxQMWS3amy0/Mrra5EK78rnGe3NWHiWI28dOuNoSKPg1d1Pcsey35amIqn
	seCXmlPE0qdNj/Ba3lJz22Dn4tEZC+QKu8LNOZ8fqGp75Oj654UMROLaNQ5uCPzRJ9QwGO
	+uxJECxkXu0tDF4EB91sQPfiMDyMdJc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFSkd1RR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786878025;
	b=jFvaoIs8YgMxvCdTaLrrwacRcOzgtdzXU7GcJKYv9wbNeFTJFaZu3NrRzQAsBzsjDIizCQ
	1+t6ainmH3dIWh5H+Q3sl2QDDALesaKK9JokyIV6Wl8PT5erGmQMiA7gyo832GvRRnpHQW
	ACZaqsru/gMrxu76uKenCGkgjWD/WYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AC8B601E9;
	Sun, 16 Aug 2026 11:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F581F00A3A;
	Sun, 16 Aug 2026 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786878025;
	bh=VP6xAszPN9d5Ab+tWR5O9C7cLz2aPGLpAHH/Gr7UO8o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HFSkd1RRaS8oPDbWpyqD3+MFUAGz+zBb2E4buzBKvFx4juV0omhsnE2xW83orpu8H
	 9mAI5h2ZeMhHUsu1Goyi//25wRfRhy5/zldEwqXn+KNf83EMUEv8zRoPeHlgoEQi4V
	 Oa7He8g8qJb2QsEPd1rl39eDbGrMOa8l2swjLNSuJmfqyBVg6W6hz4yFrG1D7pxBnS
	 jwx2+tbyLbsmJcoFViUpm9otjM5Wr+gsaeyRAOH+WJPnI93lfF4TC3uGZWKpXyI+Os
	 rTissIIc+9xMzfFeruWhWw0+3hN5L3fSFuS7lY2WLAPAG3gfVSviK2591GlnaNdjre
	 Mmxv9eXrtRVBw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 16 Aug 2026 13:59:28 +0300
Subject: [PATCH 5/6] mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache
 allocations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260816-execmem-set-vm-perms-v0-2-v1-5-90944a3ad43f@kernel.org>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
In-Reply-To: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: EAD42140008
X-Rspamd-Server: rspam07
X-Stat-Signature: zai9gpq7xcych9gbe3pmxw85hor9x3sa
X-HE-Tag: 1786878025-981420
X-HE-Meta: U2FsdGVkX1+eGjeCu/FL2UTaoamAj1zFaEdj1WvEjzHcbCyU54wxuMXm3s5sbguiT5AT8XV3HZ/pa8dcP17Uwv2xVhedr55HL+s+RQWE42ZtkjyKUf8y7c8URN+WczDVGLrCndDymfojI9lYchr2MU78k83MHc2FLsdbEEKpOLfvvIfcvgYlZqSIfNdsCIxzcKXCZ9CA12kIXHFwbsynNup/1/9RWPS/XsemrKm3nAeyW49HH6lYfe5MxTviPLNM5pHnYhd4Zyh+4hg/zt26m+wt6j4otfKqz9zeL+W7OPzuRfDVLklpiKiXIQoyvCBVqUftGiSYh64h0gV/FEMx0gywnlLzUulf/ConcsVM9QE/VV2GIqoYCY2YIQZ+YP1daD4djjd6jpbak53eK9u5FQ9SgmWBiA97oXrj94S3O3MNqVSsskoPYYYz65GWwbE2ojn/f9+Deie4YGF8NEhxjvVASr57vYo7ZdBhy/ZMUVneTDU6Jt9yMlcUKCzTrF6n0T4iWRqid+2/d4DMB9NZrWs9+KnUy0sQPCf/BV5KTCPhdJCFkPhFF6ObBmR3kQ2ueJIgpcwiMVagqyCVuhwRQw5hZdQzvvQKqV5daSFMvw7z5Xku+tQAGWOniWrDNM+SR2WM/iKyffD1BMfsD8c0OmJ31h5OZlKTcptI2DGrv+rDxzy4gAhujxiRSYejuD8yYUhAfV/rJb0VIs+8aXxp7uuOAZLehfClb3RMKhVMMFgph8o25Ues/vbuak4W6p4FVHaqV1yYrxrrRcYWW4j743NVRLR1K5qZpiz0IOGqh2ox3QtPfRAfSuYF3XX/kc2L3SS//42Pd5Xz4/ZIBZfRoLqIQfRl9QVGlU5Vzb9unNAdhSOE0ngJ0nJ6zfBRsPYsr3SM9wv1sJhKf52O1bLd7TnzDSfVsWaRzUkk+EKunHIBVzPLWPn54GyAME3y65dzK2kV5icdjLVYGIuPqc3
 ugdf6IwL
 Bp9TFNLorUAmTVS3Sw2WTYLmg3/XOtqEoBPV+4TfhLEuGquKjARTCVVBNvCCEhScHhRix24ZB49siJvd7ei3wcNefFTbndQHfQiXTQSLVt3C0Pb2wN6UFCrNSoxylFYDllZ04g+zcsTeT+hEIC4LXQ+g4E3aoPF0/18LearU6VonDmlsev4V7/v3U5QtlBtDREP3tgDfk1M0KpnsmnPh/f0J3qLGXm6pDIg7AbWs2YMDU6dpURsURTj6KYZ1cQ3uQE1RbBl3pIgNMf2P3GLcFnNWeQEl3G+9gkb83
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


