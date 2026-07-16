Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F75C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB3A6B00CD; Thu, 16 Jul 2026 10:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1923E6B00CE; Thu, 16 Jul 2026 10:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080936B00CF; Thu, 16 Jul 2026 10:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF05C6B00CD
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:51:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 494C61401D9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:55 +0000 (UTC)
X-FDA: 84994929390.15.AD8F515
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F23F40007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ycdnm1d4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213513;
	b=ABs/OTtj6wkrFuEsI2P2+pIgOy7r4/LuIOUNrXwiaj/gCNrEZBB1RV3o6U1fd14HxQs2jW
	NyargzssFCtNWNdjzfoVHGkHuHO8A7Pa1B05dvI1zeDfYvW/bKqngL4jyfEQfwyth7lbSz
	Aoq9/QmiNaMvlm5oPP4lCxe12Q8Jcx4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ycdnm1d4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FtMdM//r+7Y276dxFFM47VzlAtz3XaD8jlXTCfCIVcY=;
	b=225t6Usm9S41YuUTvZTUbzEO/Ncb7Q3VUbX3DtwfIgTzp/zfiSqQ5N8eYkZxmiLj35CR1b
	JVITcyq1Rn6Rv5bJSIVWnSSZVbinPo197qc0tlJ708OHtH0oE5kbdkoULmzab2NHiiSiCg
	HBrbC2H19KFZKvPC61cJSHS+rlZDug8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 379A660A58;
	Thu, 16 Jul 2026 14:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826A41F00A3D;
	Thu, 16 Jul 2026 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213512;
	bh=FtMdM//r+7Y276dxFFM47VzlAtz3XaD8jlXTCfCIVcY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ycdnm1d42gWDnWDTRojKBNFdh5wn8uBF05tZnLmRs8D6bCVovGm6yJMGC0t9n7AF3
	 2MtyM/yRovly8/6vZYD80pdwY+uadMTSY5PpLij+IrGFn1v+aJE3Jao1wnjh/yfcum
	 Rze8Ce6AMCBKiYFlunDDKvd/cP6840lu4/NnhUw0OzLC67qbmVK2OcRMG82XzPaD1H
	 0m9Tr402Uzow6RFwe3QIjK8mKVs+Tv52BWwGCqojl9X6n6G+K6zg/Rj2zYPQefgKRM
	 TxhfM/wy14PKNydPBDFfgEP6QAkH7f1Ly9gi4oMUOnjop13CePyZ0y1FeOEl5nnxG0
	 +6OvgNjXlXVRg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:06 +0200
Subject: [PATCH v2 07/10] x86/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-7-4afc76c73d61@kernel.org>
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
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
X-Rspamd-Queue-Id: 9F23F40007
X-Rspam-User: 
X-Stat-Signature: 9cfo8u1bn6439jummktycjtf73988ssb
X-Rspamd-Server: rspam03
X-HE-Tag: 1784213513-288540
X-HE-Meta: U2FsdGVkX192/FF2/h1dHB040HdhDiqfLOhOhJv9Kr3DSsUj4h0xkCKJxT36w7Zryg5/39HrPfSySLFDc192eJkygEH3FDZihKJ7XuCpamx7rPvvUxZ5Tu6FKqoyjk5SSLeo5cOZpDt2dm1MjTtrvqvL8IBpba0xB0ZUiQCgJb/5TH2G7q9sVNUmVu6CYQgyUn30GtzPezIbazGejvJT1yRWZgUPCMP5gXXiqqX8o0rRjGDy3Toc8P20XTxbqS7nfdfPN//37CiBngKATI/uZSSq1lU/gETPPkAvEr0jWfGBJkglP6J1UiZnw2UoK1Rt6XO8dyhG58lNWL3qsLm/x2qs5e7cUEiceHuFlPBKY8LdHXPYw9eUNGo9Xviqe4jEbcuA2Gnicq2OSrqvXryVPzKPGHxsCAScJ+ptMnzlNm0cj7cYJ6XX18wdYeVbA7J68uvBCPvk7bMxUarqEXP864JQRbWW50+FJWEUHmm6FXP8sVJaR/az/Fpze77eCl17HoI26NPFTzCQyR5UWrUP+3jcNXS6M0G3PFjcYy2gJErwldgjqG/XSW7KHDsbNTndiophyMhJhCHBYwuplaI9Q4l5JgfYCJSCPjoxrKpLBrWmVo/ktgXGgphv9hrfzeqAlXsaS+/LuIoQ1AYG1XqnUoarjZQJ41do9k/roMcAkg6+ZNUwbkIFpNBzxhHV7eEKOXkIAvfYE5NSibvzUC/h3zuondU49dqtl4HGQDPhQrfq0h7Kc8nd49TkPoHt2CJZPUORQxvQNdxmDBLgSSAF5dsX0PYiVF0aW8ONtV9W9igqFptF02fGGejF6DoiCoPOL6CXED9FsPjHQnvRXdEF54T51A0mMKvqEe6DE8mfYLAjSghFs4EK+oNy9F7LZDlSFoJEePThmNjh1XgdrOBz32/LGFDWX1AQw5AQQ11+X3sItd7EpHw1ur5TrSCPgXclXrHn0igrBIE5NSvTl6M
 aJ5W4Kx3
 jy6b3UCJ0fCUHhvasQ/R5oIbBFBIjbu8K5zGlS4ikY2JYlduC9kIyM++pdsoFo9H+iPPwQ3x0I7Hu/xAAMxsM0lu754w5zHOLnBZHY5kpNrPxVHJP1IHHL+N+VG23r6p3Q6a6+XckbMjb/qx2s1Fw7pWXZUpmoIQvCnZ1zmNM5QlWKY6fs7CYPTBSKUau9hAhgKjQNhLaqyjUzZwu+iiZ5Fj2ZsmtFZZaJeA6xuZRnVBD966EllbAw7Ln7+e6s78qs2TjsERDwNK6aD1IqqVl2xvX274C3GNA8qH84tJrmStlleNty34y/Osvgn7yuORaLzMIQX0Y4g1azNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_HAVE_BOOTMEM_INFO_NODE now essentially doesn't do anything.

So let's remove support for CONFIG_HAVE_BOOTMEM_INFO_NODE.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


