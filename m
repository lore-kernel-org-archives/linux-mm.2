Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949C2C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2DA6B00A2; Wed, 16 Sep 2026 02:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13DE36B00A3; Wed, 16 Sep 2026 02:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8706B00A4; Wed, 16 Sep 2026 02:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1CF46B00A2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AB31140643
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:33 +0000 (UTC)
X-FDA: 85218686826.22.D30D334
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2FEF21C0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ECVsA+bd;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541071;
	b=RMse5eH/xnO/csU6LL59yDwgUOzZgf/cMfPh7DyoFInqrye3fYgaibj8wFL5wpDImfdKDB
	LKNx+ru788iQWu1PVh6OhavEaA2jaoJrFynzdNcm805fIohyj9ql+5iihFND1eyBz3MgNJ
	Cw03ohXqMZJQeoBYP0nWZiPzhK5sLbI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ECVsA+bd;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZbZ6WC7vZbHjIhgnid+8T29mCn5dRvITTk6eMnH6Vk=;
	b=PJnxHF7i0Fdl/Pu0X8u9XdXN7UToywhwuhQxonkrTcczZBjtH8CQKxROhUAOzgQ9axTc1p
	jevZpE6ZzjZKALijyf3UOWHZLUZPEnN9RbVCohJKxKs2b62xCAV8HfKNLGhS2VqWV8D1Hi
	a6FKT737xCD36bInYrcPDFLi9AU1hjU=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4b43b20bso3752605ad.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541070; x=1790145870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TZbZ6WC7vZbHjIhgnid+8T29mCn5dRvITTk6eMnH6Vk=;
        b=ECVsA+bdUhRwzl5SG3ZYeXkvsJ8Hjfl1yOcBEaoKx/bTk61epvgOH3w+tD2+mVJbo1
         czmFjSK5pQoZfjmAIf4pg5XYAxGLJD+3ls1wIiD89bTDiN/uX0GKvpffg7vYXijZ6Cbc
         TNqU1/rdBOmikxwIVCfggZcKrisSjnT5+FCu+uKW3/oF2wGZ9iui4S6ts/W9b6JzBxXC
         Z8UfK6WdD8gi0a5jrI6kFJJ7zvhbt5S5GkQoeRaIlfiXpAWf2ErTeQZHw3v7njLFRIHE
         7Qh2mZy17csweC6oBTC6AFZ8RR8rH62AbpH7V5kQWT8tTyz70RKQHV/g/z/n/xOt5KQo
         4H5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541070; x=1790145870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TZbZ6WC7vZbHjIhgnid+8T29mCn5dRvITTk6eMnH6Vk=;
        b=bFT2jqm1iBo/k6yFm4r0k8H+ISs3tOgcvjzRYLFTI6jqPGDW3elRH3QZ98u/u3CDX3
         cvfkQi7ptyyDorCChiObdFjeU49g7aRVAQG+5M8mmmqc90pbkpcGY8mJvNSjLcTIvnvy
         EmfVs76mxY/YbdCIgmXLPlGAR82yXRIcxhpwpM23XHY4R0kSUh2JT5iAe5EqMo2KVwyY
         rTBQ6sT/ZKjT0oVyU0ZXl/117X9+/S2aJ+sod2uui7AGWB9zdT8I02iQXNfc1MhKlCpU
         xuJDq5xBPdIAgh0QmjWtGW275fj9CnRxAGJ2aDHXEiS9qlAUwRMVecL0xMPfUZNKfRv+
         8Lkw==
X-Gm-Message-State: AFuF++nomO+yyxGNedWjIPXeJl3KQYrBxn7FvXOCfUfXWZIkqkeGekGr
	E0OrAtIoc6gDndgCg4E6gUSoqHrytcrqJg2jndgHDp30ae2Pory9aT7CX3Em1kppEW8=
X-Gm-Gg: AYBFou08m/iEnVkK7duQLSb7eOjFeIEpSNC4OU5rIw4sHO4rBAg8NvOswMXNIC//YXF
	/PgPxBxS6Ywa2K5P/BtW8LZl3+0xsCOZpn26PidV6EX68cz0GT0vln9GNui4XnYuoWE3R3JLHa2
	xM3cP7sZnL74FqnwSBbJhAYjf060M42H1ePZly4X9VrvvRy5hix6an4hWVAeLn5Veq/W32tQy/w
	r7wJci6jLGd0gfFoIzG0LQhaVMeAy+LmBBPicUdltBHf2F9ekDdPsnnFBiwRpL7kkS29jLbUvFK
	13l/th8X8vBmZbL0KK1nXFO4ElCR21GmFR9NwofsyOXyvVjATRD5sk6XLSGN3JbNhXS6+Sy8gl9
	pXui2ubICXBUtzC5l78o6tyb4B9Y5oby4pklu5sgWOd2bdiYN0EbRIow1gZrMi9uJdduWO0hVC9
	EqWVL4JUmZP+Tx/ZJwTopQMs+z2mxnQd44XT89BGLT3hHt0m61ARy6oRQC0EZSaAoH1p3W8YSk6
	84z/BM+WICH7TZqNfo=
X-Received: by 2002:a17:902:ce8f:b0:2da:e967:7953 with SMTP id d9443c01a7336-2dd8e404066mr28394075ad.12.1789541069935;
        Tue, 15 Sep 2026 23:44:29 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:29 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 08/11] powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Wed, 16 Sep 2026 14:43:38 +0800
Message-ID: <20260916064341.1825793-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FEF21C0007
X-Stat-Signature: 3dg1pkf4yx8eobyupps6wd49xcr5bb31
X-HE-Tag: 1789541071-271325
X-HE-Meta: U2FsdGVkX1/tjOIW/8AmYrM/2vPI9O3BuOnevx3YlAbWyYiH17cRpCK453yoEvPPEv+k3jNCnjo6YQ5/aIF1EsnOWZ3m+jPtLSotu0WHPAnYDsp6mcMUfhppug9ZMquqQzim18OpYzdM6rBrjB4qnVdMfI2WwzKb/K874+Q+VfB/lncXPt4SyT+2hBxv9srESSx9uP2m+xZLi2I3d92MUW3HcPPk3c3ZC0hSWjRfECcyCxFi/BJHW9tGV5j9Lhra5b6bjdtIxDMN65JaHeov/A2FPyH4cYOj6QTvxSm9G5YiMp4VBrSJYv3rDcmdrgKvNp0atrEeAC9fIF/Jiw1NFyPii0bVyTJTBuLhC7BZrMJBt53pzUm34yQQm03zubekGO4K7HqbmqQXwOgonkphzYXct6u8QYJaT8VmB8HRzWrz1cqz7fConVTHx8SjRlRa13uFOMDbtY9Z6V5v40ds8tR9Oho/ogN1kKT43UZ9OjKhCir6Pl0NQ9Eo0IS/XOX6kH5+ynlwNbol39S7vgGQVJXXYU8DuBJ7r9S1WeHR4za5UbtmF6pDFgSiUTIBmWVdXZC7XY5q/SeXfVqcPiPkBD5lYM2kWRr1le1tRtqge+GoNpChVinkCgvA09yUEhhcpJLpDhrrUSfqQoXupZhzOWKd8IZ1X0ogzRT9agWNgytWjGtxu40NXGI4no/ibqHVXWDEK7QISEcY2sRe/toeftBnlBFBM0snd8iVx4Ata98xVtaK8FUdTaKuMob3CxKfUzaepm//lz7aR2kOWFWrbC1X6TRoOe63CrY5YBBWR2JDCmQw5lrlCs44idls3wtf0X2Z39ecjyCZnA9EM3sZDD2ZKgiRzbafj+84lsbYR42I7E38cwl1CZmjTYXkT/LsMipB5h7c09gr4osBOHAgMm+VF0xUtSDGrbBcWvLvwmZOmn8+63be9neUrQefvKccqDX4JJAheavyuREXHIR
 umEQtHSR
 skX4Ea63gckvdVBSttCy4Qamy6VgKGdbVV26DLCrNqHoae2llDgDsn+fG5f7mXe9OXI7hHojcWIbDP3YWCD5oXtCquF08nePwxUNpor05HiQwRYfIKzW+Cm+VxqHGSmWXOeolvwZ/Kfu/eEsoNeMAGxE/UK6o3n2ZAVIJ9xUTLbF8lqW9dIG4KXwUSrUKUE60X7ItvrCSRPf4FjEm7mWthwdHESZ5ejOh/f6aJ79W9N1Fc1bgMf7jb/t2luSaYtL5gMmbTAYPZJytEigfe3lT06n/s8QhABDrXFHEJQJxyLf71RsPEuPlCBNpVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The powerpc radix compound vmemmap population path still finds a reusable
tail page by walking the vmemmap page tables.

Switch it to the common vmemmap_shared_tail_page() helper instead, so it
can use the shared vmemmap page directly to simplify the code.

This removes the powerpc-specific tail-page lookup and its fallback path
and aligns the device DAX vmemmap optimization path with HugeTLB.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 80 +++---------------------
 1 file changed, 9 insertions(+), 71 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index cf692b2b5f7b..ee068f24a79f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -19,6 +19,7 @@
 #include <linux/string_helpers.h>
 #include <linux/memory.h>
 #include <linux/kfence.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
@@ -1250,59 +1251,6 @@ static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int
 	return pte;
 }
 
-static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
-						    unsigned long pfn_offset, int node)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long map_addr;
-
-	/* the second vmemmap page which we use for duplication */
-	map_addr = addr - pfn_offset * sizeof(struct page) + PAGE_SIZE;
-	pgd = pgd_offset_k(map_addr);
-	p4d = p4d_offset(pgd, map_addr);
-	pud = vmemmap_pud_alloc(p4d, node, map_addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, map_addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, map_addr);
-	if (!pte)
-		return NULL;
-	/*
-	 * Check if there exist a mapping to the left
-	 */
-	if (pte_none(*pte)) {
-		/*
-		 * Populate the head page vmemmap page.
-		 * It can fall in different pmd, hence
-		 * vmemmap_populate_address()
-		 */
-		pte = radix__vmemmap_populate_address(map_addr - PAGE_SIZE, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		/*
-		 * Populate the tail pages vmemmap page
-		 */
-		pte = radix__vmemmap_pte_populate(pmd, map_addr, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		vmemmap_verify(pte, node, map_addr, map_addr + PAGE_SIZE);
-		return pte;
-	}
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1320,6 +1268,12 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	struct page *tail_page;
+	unsigned int order = pfn_to_section_compound_order(start_pfn);
+
+	tail_page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!tail_page)
+		return -ENOMEM;
 
 	for (addr = start; addr < end; addr = next) {
 
@@ -1349,10 +1303,9 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
-			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long nr_pages = 1UL << order;
 			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
-			pte_t *tail_page_pte;
 
 			/*
 			 * if the address is aligned to huge page size it is the
@@ -1377,23 +1330,8 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
-			/*
-			 * get the 2nd mapping details
-			 * Also create it if that doesn't exist
-			 */
-			tail_page_pte = vmemmap_compound_tail_page(addr, pfn_offset, node);
-			if (!tail_page_pte) {
-
-				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-				next = addr + PAGE_SIZE;
-				continue;
-			}
 
-			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, pte_page(*tail_page_pte));
+			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
 			if (!pte)
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-- 
2.54.0


