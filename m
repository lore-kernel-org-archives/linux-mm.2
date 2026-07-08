Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2A5C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AA56B00AA; Wed,  8 Jul 2026 10:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2136B00AD; Wed,  8 Jul 2026 10:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8646B00AA; Wed,  8 Jul 2026 10:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BDF76B00AA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:12:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C45C61C722B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:12:03 +0000 (UTC)
X-FDA: 84965798526.04.72F9B30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0A2EB40010
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:12:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoctbuLL;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QogqO2vhwb6p7TEPdjCvspK5sajQUWVpqTDoqs/yB/U=;
	b=y0ZNKeF/A6aUg6O/uF109o2pLU+nA4krnD+qfjlwBXo3M6XjPIamMNxA1Y0eWUZz9IWXNd
	MPkkb6YhbPsDPALQAcxyGQzuuqL9A6eC5Q8H62Jp7XxHbSPXE7SC3FGanppS54Kka/7885
	p+Du9pblXjNEGGRgtKFfBKLFK1WqrsY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hoctbuLL;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519922;
	b=i1XJYWs7+Mw85XUkVEnxpGGEnHMsOAjzbdtRA/NcWTSve3qdFGh4jeJ55mhVEwbr+MSKPz
	Xn/IBDFxW1D3U/UFFEHHx8z9hwPLPMb1ISrZMmTO43VvLiBOdqcFh0MlDPf8dOy6WdOZGZ
	keY6K7GmQy6dRA6mQ168m1Ae0YmIj6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5ADE743B40;
	Wed,  8 Jul 2026 14:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F981F00A3D;
	Wed,  8 Jul 2026 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519921;
	bh=QogqO2vhwb6p7TEPdjCvspK5sajQUWVpqTDoqs/yB/U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hoctbuLLxdAC0N3FiscXIkIWyHz6YjDTXPz2zjNd4PHHqRA7EJc7+9JjaG/85/OEC
	 yZcBMEZoWWd+WtlXsolZSDhHxC3ED4nWpLgC6jUF+MMlWqhjeKbnzdBDQscW4gw9tD
	 VsACB1aJb6TstaZWXgRr3EizWOYvP7FCdl1113zmR7X6JbFd666nd0C/zk1mHn3xhW
	 VJRt6yPyFnkkMau/q5Hq2TmljEIwtE6dEduKYT9Gf9Gzh1Sxm8IlAae8zFL8kjazsk
	 7EJcIukUE+gYmvRHjqpSvPWNmDG9LAYYKUftJ5tZv74xtD925scZRMh35w8SvA3v94
	 jvx2m2o4Emd5Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:11:02 +0200
Subject: [PATCH 07/10] x86/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-7-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A2EB40010
X-Stat-Signature: 16igkd3ny3kpqk883mmh5ch5ek1fffyh
X-HE-Tag: 1783519921-612556
X-HE-Meta: U2FsdGVkX1+yydTDyjZYgQNkly8G3a8LsVsBczfkb3XuaZZWpsFObN1TZGAnOcNjpoeKvNjBCUjArEpInRq+/z5WQaBJnsuVemFPlD96t/A50JrRQBnjBdBGpG3Zz26l7DMbsGHAkkRio1ZDJgHK2DinnV3t1oNo0EpX4fGfIIMR856LBGx/pTu1+qnlqHOcZDie0GkqBA0pHJSGJ0yNgh54aFUx4eegSBTFsWzQHzsXspYteQ8ZWK6cjFHmZc2cjCOSciV8+vS3V1pGcPAc3rxQ+5coE/TBmHi/nTcA1MtvN40ehMl13i71cNjhHLfs6DVLHtgtujNq0lv0KJPS9/AEWAH2lVi+n+r/kJpxaFW5D5OwrRwvF6jojBM5Cz73gC6OmzVZHh5XR2pNhkO1ANFcbE3DJpBvAO0O12cKKry7JfApaeJ9dEvf5Yjeaauc2jqA2nwf76817aEcpfZlXjaeQ4OK/cWNZMHl8y8X5vH6nUhRfBNXEeldSg8Lz1yQ4EHTfEEKUHVpPpAKEBhq/LK15wVSw0o+KxMbbdu1oYbTk6FUaqBCWw+PoD/D7laLgocyl1RwirLeSuKKlLOE40c1e79RfRtiU0hxzKCpaXRDexHasW3NvFCOR7lV5MnQddqkUqtb/+ATl/0McZs5g+acMV5qPcr/hAGcMdb8/FEzaP9jOTyMp/0n1geLchTYr0OkbBdFplJHtOoqooJ7caf+MRGLixrXKfRJstjCSCxtPOnutsB2uFt8bZiifbNy1G1RYUNzmRN8JO1oVmnxszXtleDiUOzT0vheJtSDPYwtO09x/nqgSzAK0UYC7Y9bAFe/7AmsrX2UZcnrLoR7Ph6qSX+swUS0gzCzcoE9nG2tSy6Mz+iU1At3ncI9ORRVFLGJETzklqIdRnvyse2qpncKuhsQybVzkXV8Z6Mb30JVAaRv0+ZLTj4ryRLZMZy8ldF0U2gfgHM6mlQe7Q1
 IlWSA0rl
 iUsj7Yn9oum9HXBLmglDwWaEwW3hE644+WOMhX8oZA/oAojJjS7aerRc8/gGmy5oUgacCqshCXJBdmqqWLUTezIrEd+aAPEca2Uf7hywoKGfIcaJuWrMTM5MLioW3lZ9w2dAypwkGc0Q7GAFtM2GYSDu6XOjbnJW6Z/3icZYkxm7j1sRn1EUPbJG8YcKZIC3nlFT0oVM6EPen20fOHyH1lJFJx4MMEucOLvrUk+HWEchcvAbuw7QXstjVwOZJO487Ajn0SblJt1aVH8uUu9SFrxVbJb2ydiG+FCxxbbPaUBMJQwvfqxtC+JWrteX6L7NGsJVGSa7AZEh0GWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_HAVE_BOOTMEM_INFO_NODE now essentially doesn't do anything.

So let's remove support for CONFIG_HAVE_BOOTMEM_INFO_NODE.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/mm/init_64.c | 26 --------------------------
 mm/Kconfig            |  1 -
 2 files changed, 27 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1b17dcf781e66..ab4c5a02326f7 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -33,7 +33,6 @@
 #include <linux/nmi.h>
 #include <linux/gfp.h>
 #include <linux/kcore.h>
-#include <linux/bootmem_info.h>
 
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
@@ -1286,16 +1285,6 @@ void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
 
 static struct kcore_list kcore_vsyscall;
 
-static void __init register_page_bootmem_info(void)
-{
-#if defined(CONFIG_NUMA) || defined(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)
-	int i;
-
-	for_each_online_node(i)
-		register_page_bootmem_info_node(NODE_DATA(i));
-#endif
-}
-
 /*
  * Pre-allocates page-table pages for the vmalloc area in the kernel page-table.
  * Only the level which needs to be synchronized between all page-tables is
@@ -1358,14 +1347,6 @@ void __init mem_init(void)
 	after_bootmem = 1;
 	x86_init.hyper.init_after_bootmem();
 
-	/*
-	 * Must be done after boot memory is put on freelist, because here we
-	 * might set fields in deferred struct pages that have not yet been
-	 * initialized, and memblock_free_all() initializes all the reserved
-	 * deferred pages for us.
-	 */
-	register_page_bootmem_info();
-
 	/* Register memory areas for /proc/kcore */
 	if (get_gate_vma(&init_mm))
 		kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR, PAGE_SIZE, KCORE_USER);
@@ -1564,13 +1545,6 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	return err;
 }
 
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-void register_page_bootmem_memmap(unsigned long section_nr,
-				  struct page *start_page, unsigned long nr_pages)
-{
-}
-#endif
-
 void __meminit vmemmap_populate_print_last(void)
 {
 	if (p_start) {
diff --git a/mm/Kconfig b/mm/Kconfig
index f794a341d7422..592003a258bad 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -590,7 +590,6 @@ endchoice
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	select HAVE_BOOTMEM_INFO_NODE if X86_64
 	depends on MEMORY_HOTPLUG
 	select MIGRATION
 

-- 
2.43.0


