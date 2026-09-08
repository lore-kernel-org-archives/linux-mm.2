Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF689C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3AF36B00BC; Mon,  7 Sep 2026 23:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11D66B00BD; Mon,  7 Sep 2026 23:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26C46B00BE; Mon,  7 Sep 2026 23:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B647D6B00BC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 433C5140347
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:38 +0000 (UTC)
X-FDA: 85189102236.27.D4DF22A
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 80566160006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GBxarYHr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5VVmQasiv9FjgFp8hyWKR9WL3WpfimdUt+OCxubG2c=;
	b=kSUMY026YViL/yaEFzh2tOukoAARyboMm2c20MR9mEce/owxmLb2ctGWqxJZ5cf3opXEPS
	xqogG0BIXXnz5bd8jATnJfuxwDhhvm0oqmS56V+N+NK7VQrcHiIzAP8SmduMQKg7a0aScP
	0ZHK38majmcRwnBnDgzaPGdj0LxmKRU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GBxarYHr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836676;
	b=aJL20nfh1Nh6rn5DQ/YpZLYPMYa+jNL8WeTvOlqS9XRHxFXMbMCKV3Hi8FCxOoXTBVj/rs
	F9wXnztqhj3OS7GI+Jqk7ReUMU/XDnxWOWE0W90fqjJ9rYc8zYwdBSWBTrILQgGxVNJfKk
	An4EqLR21Sn6hXizfbd+36k+54EqSig=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso3529324b3a.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836675; x=1789441475; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l5VVmQasiv9FjgFp8hyWKR9WL3WpfimdUt+OCxubG2c=;
        b=GBxarYHroevaULQBM467p6eYupYwmIgAZ/itxp0EEj30yGlRGF9ETlnQMEewAH0AYT
         GHfSPed5zqNj1mrAC/GtZvXXtimvc8IVMs9CZ7jA90gWzwgbWrLko2yXjxB9+EdMz3II
         HiG+hn8b2U9oDEk7n4BgwThn5Y7U4d4KMm/bwOqPzx0sAiQrAvXzR7pw0nFBt1ZlDqGZ
         T3SjtuR4ncul1oGdzgcR+CL2GAHuEpXn01RBZScmAMw1Q5zzqjL8Qij6CBTchl5VAkqL
         S3q84ruwNYd51hfcU0uJ+FitP6whfQtbnb9MkrK+sElRnRkeC0R1LTuRqdwuyNu9tlmf
         RhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836675; x=1789441475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l5VVmQasiv9FjgFp8hyWKR9WL3WpfimdUt+OCxubG2c=;
        b=SzcAoBWtW2Q9uzUnevUQUn+rZQLfw5hYmJo5atXis9Lm+sIXzz0K4EesCOxrd6ItUN
         Yu1ag0kjOCqOOHrWi8eoHNUcMAd1eYqK2NARv1or1e3EtwI3LZos0ZPYIaNm3G9wdSOB
         PoK1HtQndb2IFu0XKr6Ucn76uztskFaPgDaE9NkSo0eUnYUHASwwNEwps8WctNCd+Uaz
         z4aBN7TYU4NJCrWPiyBtRUWNVAfFE0fjAcEWS+jq1SfDydFH+95rQIFEm9RgQGcksnu3
         xU0vt3jsYEEuFChxJT4e3mP5hNiEDDJj3u/uIzkypYhLqh7lffjuhCwyG+wrvb1pGrze
         TC4w==
X-Gm-Message-State: AFuF++mTXE3gFkQtl0Zm+omoCpFtYQlaEtIExre2pqWvhQ/XvhKe+OdD
	NBpfTjtVxilzFEl217KFunS+OD6N/eUo8+E0LgSHCDZKR8RV4NcnfdZN9GYHFLugnBE=
X-Gm-Gg: AYBFou2wQ8DfnXSUrZZihN5vMrj0qjSeegB5YI21UguBkjT1JYI9JKt+m9hseYjG7wl
	gTeWi6eFEsfgVTbyvWA0+k9iBrJBS5/wfkRUFbbzvkTtVamPvzLl7lRZhoKMZmbirBJLwhta/LA
	gNo7FaHRHtuYgBC6SPdYBJ7H/m1jEP+gI1eQtYzI0o0N0+r/LUbzpQL9VsHmBzIGq5r3zqh37FP
	hn2xiTVtRe46jJmZcGhNb4WYlICZG5QXQnWq5tlGSbSvk16tP63+O+8IN7FK3jQ2/xuMwKo0Bd3
	UIP6x7Ed455ZiqJs1SJkl2bsciunGC8ITY9Q+1qYEXuALh45I4X3dhNKVLRpM8OgBf08b2yGbZB
	7j0rMMOMR/k07F172fk1x0Am3eD6uNb57/5gHk3Z4OhDCW4XFT4DWFGiUz24VM+HZg/GfQ/pFH3
	fpxXob4zYwAk6ownEY++o6khrPTcWyZXX7+9WVjqtSgVwuZPVMC600mXcJGxcmQ7wiFF07sEsUr
	AD/hub7uSb5bCOPzxMLKCWX
X-Received: by 2002:a05:6a00:991:b0:848:4c3a:a359 with SMTP id d2e1a72fcca58-85ffeadd0famr28321527b3a.19.1788836675326;
        Mon, 07 Sep 2026 20:04:35 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:34 -0700 (PDT)
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
Subject: [PATCH v2 08/11] powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Tue,  8 Sep 2026 11:03:32 +0800
Message-ID: <20260908030335.96549-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rwmb7rp9mw64wjqiaiessfjhfuo4gtye
X-Rspamd-Queue-Id: 80566160006
X-HE-Tag: 1788836676-445052
X-HE-Meta: U2FsdGVkX189ynZIxRAXI/06jXAYs9gYymW8ZEber1iqtdD5le8CJEBvj5ysGGHcr145DQ+gAopnUsiEtQKY44cYWQeIbHqZP2khYMa1/S8Dhledt3O9cNbcj+E3Ssat1ZUpFL6UF2twSv6nIZgbQw3NIL5HWH3fgE/GXfTqtDhY8ftZPX/dB9Ro0GQmjhGbLbB6SwD6VwL/GsdTS1nrcpBk5gMKdOBmhY082x5gOikMps01PgaCxe+qXYg8azlZX+bQigWRItS7LDK0T6yV3UMlPUv8YHfrvmff0+3QWfM085EIRpOYXCB40oTK6N0gi9Gm/VWL58ma513jmstufG0q2SfvgfCpToa9GH4u10IqZTWAawUbnaqve98ySR3UX8hy6opufCdXireiDDMWiMhBQrgUHzFQ2LWG8lD6c7o7eCcNGOvGqCRVf1aI9HH8tSkaF9MG+WQfsMQ03IYbkUKW5IM8OKxVd+Q/XtFBJyFXRodbGPSIuj0/mMw7Yy/gmbER7YzPcovNVljab++hRygp5wZNLyxmA2axmUr6HgAS9q39Bk8is0vrRJpMgx9aGgUyVjXOKcN3O8mZCTVx3QvD4TMb1X33lJ03SwWDftnupewSN97KwCbL/UgQM750H8YLvYp6cfTAYk5mNQjXIjJfd5dnnGSviXyEU88BJkBX9P8MKsZ0Uf0rhLaH8C82AjbwfMFhVthUqkGpTuCXAQqHY0IsIKbXgitWMlLnl1UZ4J19o4btL2woDKNIZsIiS8zJRfs9fGkGFGpGCoRobR5v84sEpFIzanKsxyg+nnWlJCfUkpFL/kJP8NA4Qg44Sr4bu1IpLH+7QPZzvJPemzE7hDjQC6GnUW+jvj+aZ1w29CKQ5hWVdeG2RIB7YD/IWzUQDQ5EzksMf2/p1FVYWAo2OHkKgg1JpQ+q6MCVQHKcfv0i3RyS/r1veXk47ZL0dDm6v+zvpYQIEOpEVY3
 GglngrzH
 mkav8P9A0E7tK8t8KgIlHFP1SdCzToQ8fgNWMKLJkd2g2b1DEsZ+yFi8Nr7vWlht1hPeukh6epOcqbS41viws7klRkKx18zkgA9JBoXVBcmSvPuBxkcXlQorqhWu1C1f5JLT/VPrrjDo38hcf4uaL7bqT9AMWOmMcSPx8W/A/2stVViy42QOsegiesJmT7dAIAvGM8qOlOh5lrViHQX3pmjiRUajMU5ECz499qyFM4QI/NAehzsFzpEDVoq08NEKe2+MUUbtU+wpkS/YpdGLytuliWsuAnip6cHycxBctKT12KD1YTp/31/kUfw==
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


