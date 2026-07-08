Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D34C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA096B00A9; Wed,  8 Jul 2026 10:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB17F6B00AA; Wed,  8 Jul 2026 10:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE2F6B00AB; Wed,  8 Jul 2026 10:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 750C06B00A9
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F05C214016F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:55 +0000 (UTC)
X-FDA: 84965798190.07.A65485C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3CC48180015
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B17tA9He;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=miQa8lQVN9P92rh/AHg6VkdRGgh0vkvCevN6d4/Au6M=;
	b=H85sAI1hCBQI+eopx2HTb3FvlMmOGRrCLspPqPk8+wkXFEKl3JaeVyNgVFeKU78Yk61yIR
	TZmUMpHxoKKipo/GH3WMpSOVSC9e2JObVcelB5nLxytS7wO1coduWkqXVSLmnu7zv0ohkL
	ROo8Z6HPaRjJay63Ud8QSjnJpaxflac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519914;
	b=FmOl/425GX0tjCtjrSq3aUDjwLOUioEpRsuk7QDHWEKSa685bHPTHI96ZGnTwtS+gudQj2
	9s2TVQRRKd5sJJLwbApHJupySpzQsDCHINNEYb6zcFKQG/F2FNvKblRC64lByzXqDHCN8S
	/Ij4bUQODshMBD5JC0Lp+epZ3NFRrFA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B17tA9He;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EB1743296;
	Wed,  8 Jul 2026 14:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B93F1F00A3A;
	Wed,  8 Jul 2026 14:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519913;
	bh=miQa8lQVN9P92rh/AHg6VkdRGgh0vkvCevN6d4/Au6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B17tA9HeIU88/tyJHj96M26a0PmSB/UUpXMhsoHP8wPOsuvOeIKHaBF3uA9egWTeU
	 rxD1bvoX2gt9AxceoS3plZMQbgCh1Rh55HBMXhxStJNs1PwDH8TNyEu1kZYlHJXZPx
	 Dy6n3Q7Zmd46KP56W1DOkDGrsvazghTAIYJ0Hjr7zYT/BgqX1OZCUV3YXQ6NsipXJ0
	 McUbUc1O3y05jvVQp5WQMH0AMAVNNOZv4W6WCdO7UNbWvBPJZ6Emi1awsgvEHnZM9P
	 DbbPx5HndMX6hM/x0fY2f1TqVxHhi4T3wBqoqSDsv7CorKn/ZPLDHTeb0AEB6skOjq
	 8G63Q2AltcEjQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:11:01 +0200
Subject: [PATCH 06/10] x86/mm: stop marking page tables as MIX_SECTION_INFO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-6-156ce4986598@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CC48180015
X-Stat-Signature: n6cide91hci8ztetztygcyi3fgjxxfis
X-HE-Tag: 1783519914-793616
X-HE-Meta: U2FsdGVkX19lDi3K4GON7Jgof4WBBLMbKJMH5noKyJhBvpUPviL0S9YyPSXAlPkEPwD9wr+4m6yLvvEfr4Qm89Q0VPLGcS9uZy+uXSFwiEFdL/4FqHxcWdbV5ucpTb1gFj9BYOCxP/BQysbuY7NU9lQBzSw5zXPg8MH7/RlzK9Ypr1xBEMJpVOJYn8kj4C1QM1eG9yIj1EaauNMTKYkc3AW0tsrHdWLSoPXjoSZXr6Zyjks/aQJpUCSST0ixiB3huk3QJlqAPwNxt+x9xceYnXep+wFaJh8XPTaiB0GkgtcuL78CZ1C5oPBzAizjEG2AtcwrrQnbTssLvJju1ifCvJI1BOR21zI01Pobkze3j34XeqSQHF7DQqrsiHgjnmrdy3YIVJLAkpJ4hlw9kpJ64599jDGWmez777KhOz2DsSlX2gd0aQVdsmlO6W7IZdV7KzaY1M3XjdIBI48GR7ABtH+v2JAgLSZZeCM50zOmk0KhEl7gMJnzuOPaiSE2MUs83UF6tVpeEvDK4iGtTjxqTOUzDcwE8W7Yq5MFozaCdzOlL24nwZsAUEeYZYJqeUxS26ZVx/9oPk9lhTTBLuYadOplitbb/AjiELKHdo6kMR2Io9lvoiK6b4+lq3vQOPPWoIWTBXp50w1xJMKP2LeVo8ujirwiDMFu85Sz+hlgtHyzEc84hMeShKd1oVvkVhhcxB3ecvSUEpHcdmPJHW5H3dtQw7BzBT2NoqKY6TgNZ85LpPQYbaJeAvWXlpNEj/CPm/6SrToMWy3m+3jWrlNVC+LkmaiRg+7U3TskdM+Wiyxmoew2nXzWgagMHZZyAykm7EfQ4Bte3N1WQWbE+JRreqbNjn2p0BiXfpeqYkFkE9UzcVvngMwEGNdb4lXA6lJl9JiDQ79ZU8ltFgD9yShOUk4F67Mt4TNweIF8Jxh+8UpJVLKcErQQiHk48sYBfEZIo0U5vmzj/HljCeKvfPY
 E8vOE3z1
 H33mW3Pi9VECiQSJgs9aG95FZYCw7gZM7sibFQMPn2X9GFjr1Oq+7Y1UdYmEU4EOlqZbyTDbKkUw4he1YFDYWOFJ0+2qDca7/J3NonJcmOmeWhdXQ6+xMeMLcju/gi/6ynVmZPFtaSC2V56iPMW2qPEnM/NxUAU11HSIDIH10EaTYKZGKyh9cLUnRzmb445si/MKWhf6MI3qzcVinuBAaGtdj4+bTuwdw9cTJMsm6vB0U35bLk9Fu3EKpCUSs3ZYiq1irvXIIFUH2+Sl3MMV81a2M9B4F3guqyGkf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no good reason to mark boot page tables as MIX_SECTION_INFO: we
only free boot page tables when they are completely empty, and memory
offlining/hotunplug doesn't benefit from it in any way.

So just stop marking page tables as MIX_SECTION_INFO. In
free_pagetable(), we can now simply free reserved pages directly.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/mm/init_64.c | 59 ++-------------------------------------------------
 1 file changed, 2 insertions(+), 57 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 82bb0384b8ab0..1b17dcf781e66 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1002,21 +1002,10 @@ int arch_add_memory(int nid, u64 start, u64 size,
 
 static void __meminit free_pagetable(struct page *page)
 {
-	/* bootmem page has reserved flag */
-	if (PageReserved(page)) {
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-		enum bootmem_type type = bootmem_type(page);
-
-		if (type == MIX_SECTION_INFO)
-			put_page_bootmem(page);
-		else
-			free_reserved_page(page);
-#else
+	if (PageReserved(page))
 		free_reserved_page(page);
-#endif
-	} else {
+	else
 		pagetable_free(page_ptdesc(page));
-	}
 }
 
 static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
@@ -1579,50 +1568,6 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long nr_pages)
 {
-	unsigned long addr = (unsigned long)start_page;
-	unsigned long end = (unsigned long)(start_page + nr_pages);
-	unsigned long next;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	for (; addr < end; addr = next) {
-		pgd = pgd_offset_k(addr);
-		if (pgd_none(*pgd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, pgd_page(*pgd), MIX_SECTION_INFO);
-
-		p4d = p4d_offset(pgd, addr);
-		if (p4d_none(*p4d)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, p4d_page(*p4d), MIX_SECTION_INFO);
-
-		pud = pud_offset(p4d, addr);
-		if (pud_none(*pud)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
-
-		pmd = pmd_offset(pud, addr);
-		if (pmd_none(*pmd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-
-		if (!boot_cpu_has(X86_FEATURE_PSE) || !pmd_leaf(*pmd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			get_page_bootmem(section_nr, pmd_page(*pmd),
-					 MIX_SECTION_INFO);
-		} else {
-			next = pmd_addr_end(addr, end);
-		}
-	}
 }
 #endif
 

-- 
2.43.0


