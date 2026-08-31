Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117F0C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0938F6B009E; Mon, 31 Aug 2026 03:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E266B009F; Mon, 31 Aug 2026 03:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27A86B00A0; Mon, 31 Aug 2026 03:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABF516B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:55:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2048A14041A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:08 +0000 (UTC)
X-FDA: 85160803896.10.1676EA4
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FC9F20009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AssKTkUE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5VVmQasiv9FjgFp8hyWKR9WL3WpfimdUt+OCxubG2c=;
	b=AWUKWg8+upPnLZKJXVVGUhjJYioRQ8HF4hFSqWBTDNJmAPDnNwdz4Re/d1/AspadUj1nSd
	V/gFHxig3ansSVkxWh1dErfKE8LKFIKUoKi6Ou4bmf6MjJt2WiXAr9WO+ALN2XD7nBPrU5
	LRTc7w67OTgKk6zWSdfEIcyPXDZ0MJg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AssKTkUE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162906;
	b=ak7oInQmLf8DvOjCHWOBtjRZ6F8vuuvqW8t9WitPOvrSZ5O8g45qA3KhUhr868W7BExxUs
	xdk/5FTMm+Oj1d84XnVhA620v9E7miMmp/SrenCeu0ctzC1IP93N4MAagECpXqVdXgQaOj
	mwcwLcfni3Vrz6nXpP1zl2q52sS0Uag=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8541875f596so1407089b3a.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162905; x=1788767705; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l5VVmQasiv9FjgFp8hyWKR9WL3WpfimdUt+OCxubG2c=;
        b=AssKTkUE3wjvzzgPSA5xDxjF9bUK7PMqFgXZjVbMuEqRXgRXkqyl5+1WEJonHzV9lk
         g5H7K5NFN9JXIO1FfNA+SmmOB0Tgbb4S3tF7TsRYGP/CBoAF4fIjBg5OwxTQAfC70uOu
         KgN4Rdz78W4r090NXfCAasaKnctuWWrutAqamb1OYWMhw16Jmg1nFdr/K40OK58mubC1
         DT0agPhJyWxrzFU+bfSBsPeZSnMWk4fPMqxvwCxLBqOuTL1kW5DE5CLqSTREiGG0P6gm
         hSpThI4zBs4x4FJdTq7VlDKdmmRDeHps/BrM80vLEoyrTI/5YEXFbB3MJ1pSdLHZBzns
         sWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162905; x=1788767705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l5VVmQasiv9FjgFp8hyWKR9WL3WpfimdUt+OCxubG2c=;
        b=jnJTLbkXVfb6BEZJO73DqIn2FdrW9AxEltaS6B4FT2SYP0/guadKl1Z7V5mi3cmC5B
         uoU6pf0KaNPyE/wrHFy6JrBu7Kg0YbEumb8yeBGN6c6cvatdB3HPrX+fI0pSbRtwAEhq
         KYkMtItR+YLO13pEh8F7ttTtvKJiBfqCCtKtFTCfUGy0sxOo97dQ4PcdImK9NuK0fHG5
         0hwbQiWKgVlcpIsd7Jss/Nngs/T7fIb8LRTuxpbR/xffczAP4WDoaj0tzOssrldqqZDi
         C5wUIooX64UAMa6o/FrK+UBKese5S/AsZ85m1jHXXCMONjtY5An/Q9lr38P496ay3cLR
         w1eA==
X-Gm-Message-State: AFuF++lQYt2attYZaFf1GRV2GhLwS3Cdxv9cKqNh6Fzaqh5looMb00+O
	hJLVNkRKCRTnbSsJE34jf/PXWHbzekz8i8qYA9QqwoSz17zDWZSs5uioOFdtJa3kR0Q=
X-Gm-Gg: AR+sD12zCvwz94rsMMGnbecC4mxGY9GlSAD9+UMey7X0b1LuFkDKF8MYs6xa7xBrape
	BKGqrKgjpI8KJ4wSwUljYFC9AShEJxnRToyhiTw4zm46SqJOWKrd7EXEp0ZJp78u+w6O67QmQcM
	As2i9HQzCC0jsFD+DVWQMoSxjL7rPzWA+sebJbZogzsumjOP0xo0u8A1EMPJgtifd6i811wPs+x
	w0bzW2vlYFcXpG8Xr7OVHjdFYj2skYbRYckC83gfZHtn1bx1kHUcQtiSoSE9lK3tKBgqP+IqTRD
	0tFHkZAWcc9cHGLLq65zJgNfZ9zhhb15lsez/rNGQ2sPQY4VeBeFwoJGlZ++CD/GzWOKjS7ejP0
	la0tiAEKAxnV4ICcJ3PsxtCa5S0kFQWok8KBeJmlVsSQ340PyGmneOWDZNX7xBekKAHRI4PUvle
	QNmb2nzpybniBZoj0TRrOAXg64CEqwF3sm6UrPqePmhJsIcfg/zV4p7MZEJWfNCa930bx+Zq+gi
	17scRoINaacHizPyPCrs8Xu
X-Received: by 2002:a05:6a00:c4d1:b0:856:30dd:91ba with SMTP id d2e1a72fcca58-85630dd920dmr21751321b3a.2.1788162905187;
        Mon, 31 Aug 2026 00:55:05 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.55.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:55:04 -0700 (PDT)
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
Subject: [PATCH 08/11] powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Mon, 31 Aug 2026 15:53:39 +0800
Message-ID: <20260831075342.57563-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aoknj6fxiy5pipamu9mdo7dfiqgo44cb
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5FC9F20009
X-Rspam-User: 
X-HE-Tag: 1788162906-196793
X-HE-Meta: U2FsdGVkX18uPLHJEz6l5yXTKbokpKYZwZGm6VZHFxxGc+11zongJlipmvRhKNsVvCKoMAHKl99XngNwhGVJ/Vnzck4PZF3K3+TQSrD0Kf7TE96v2Qs1bAsF5GOtyf//mmKimmFNz5RqP2AMgSXCGTuXP3zDCspgKKZNyeIi0Ht1TrzNEzHWO2LlhA2XG7is+ExG13U5y+81/Wxa76sr0bxRJyLFsJbAaLZklMp+H/RVaKxuGEOKYSynLneggZNQirLfwDoXENDt5SFNgbyssTA8H/lOUa3x3ST59DAhaMJmxZliaHXT8mtCfx5xbdSTWLnNthdojKZL76bpEcLD38AEkK++st9lYzs01L8MJl2q1qgxt+M6lwRNfxWAWFY9kgfA/AwHwDZTkLOQxDetI6oLLg0SQe/YVYWv0VJVS4AyR2YKRcPBywkuNdEL2UANeSA8gaOBvgGktxjVPSp0Bw9l6bTIpRgjp/xihGYDRQ3idbCrUZyTZgY+iRqw81k+BhpqCSaTx8sctivlwLKow3zSMDLyTaUuLWY+PocG6mq6LdnoPBN3gK+vv0yhaxT6em0qOorVnFRre7L2vCgy5khELtqIGeEzlPloZl1RUCvuVgyCIDUe3M6Mx68k8MjywFy7wK/QGslUA57/d93JqevtqC9w09YGzE1C9Gb9ElYnuhT0BCra9nXxVMDqJUOkPzCDiB4OzqSEHVrvoQhgQe+U83zyQEkmHhZ625kJR6ChrttAcO9xhDzjHLs6mNLOX1jLYW3BhGF1CSJ2c9jo3WzolAclBms0t1NWqOB2eKIWF6lOlKl3JanY/4iVbGQAglxv9iMb/zPhv5qUbokYWpqKggHyAwsew6tIpVLBRUGNHt+aIJEQuVoeqINAxVfs1Cp32b7xsHOc84n0au1b3qAi0xvEHnBY//QOtEEwymAbXhhkOpwgDtN8O5ERj+0Ae7czZ84F8sKOYgwdgxD
 o/dT93tB
 /zz3GbsRg/hDnBw01e6SkhxYu1RO/LPRyrQdCQ4SfYP7uMFyzgkl6LejreUfcCsSqMnZSpGz8P0R9jiordzX0JqIxaP+akvTDdrv9Vm0Xdo88ebT+Nx2FNJ4XrbQnSI5nx/C3ywPYMvryq+SUrtM/CSSg0vbbxZnwOe+wDN9g1AUAPD1L3QtJSI5Ca7mgDwTdGJK0f8jeR83Fl5sFRXHkAhHcFK3dwf7fmKnT64YYK4dBra/U8QB+ft349vnuaqrZobS8lI97wzHgfP8UhpGP4dJVJ+OkyTpnD9y5cNerBWPLV3PQn48KvK6lQQ==
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
index cf692b2b5f7b..831c231a4a18 100644
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
+	unsigned int order = pfn_to_section_order(start_pfn);
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


