Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF4EC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A5E6B00A4; Wed, 16 Sep 2026 02:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23C66B00A5; Wed, 16 Sep 2026 02:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B506B6B00A6; Wed, 16 Sep 2026 02:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD7C6B00A4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E70AE120627
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:37 +0000 (UTC)
X-FDA: 85218686994.03.688349F
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf24.hostedemail.com (Postfix) with ESMTP id CEF96180005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=R9QjpSla;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541076;
	b=aKyyWbdATrjaruvWgi7VdKvF2pGogbdWMmM0GUw6R/YQis4N7phv4EyV3WjUGTT7kbGHWN
	2rhI+qVoIO03R8D4UVoM4H3QnKxy1Iq1t20exHr6nOqaqax/n/hLSvk7dcmZS1s0MBtUAN
	qF28FtgMrg8dr7bKujSIG5Z28PnXTCo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=R9QjpSla;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVLitPRwuorHo3p/kYxhVkChlufVFy2kYjbuHRdLiho=;
	b=DBJioWPFOsfmESusLFrX5T7wZtvQxUIVN7cIinXs6O+A2Ij08yOSTrow4uzi0atgUA1u7n
	MUQABz8bfxuvusp7dvuuS52nLRWl/hGVcT0b4rFQNEU26uhpezl7R496FaMpV+/GRDCGIS
	XnDzuh/5EAmYDuqiA1/LEiwsZ5KoMjE=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2dd58e1e2c7so6019715ad.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541075; x=1790145875; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iVLitPRwuorHo3p/kYxhVkChlufVFy2kYjbuHRdLiho=;
        b=R9QjpSla8vOe1LdgpOg6nhnp4Lb7T9gRjt85P5d08SmPv7UO3+14JVbakKg92JmKrF
         zTL5aHnQ8MKc19CsSwkar0hmj+qKtmdQrEbATh2GeTEtapQ5fNqbBTkE8GYQXjrRowsL
         o++VspVQpfIxkniniwefR1Rg6qwx5VHvn1bEad/gNu+ltObjAF9xeHd7AlG5HPMBtQQY
         qMoO8lGJlRkratRajVg1UF0+vQ9/S0tuQU4DlbJh/LWyfeZR9Y7d8abVm8a+3okHLXtv
         imPoElHezsnfaEjbXPamDfPcvZASCwUxS+IkKeasinKbKgtOQpu+6ozTsr43rtxgXTid
         irPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541075; x=1790145875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iVLitPRwuorHo3p/kYxhVkChlufVFy2kYjbuHRdLiho=;
        b=RcZw4WpU1YUYmW084yPT2HnrWru5JyFUfymbm9myK8Orar3CCzy+wxhrLnMe0OJknk
         D+HxvI7btMaZyKawQBxjrlhKWcghbuN8SH6oNRNLHRDU3qdysTo5xHB+6y5X/vH9FOk2
         styzv2v0Pk5NaiSg4XGuhZyYfTGJYCI/oVpk+oetu7R/NRNVTEmXdYDvdL9kKke05VDY
         s6x7eUxB6RkDqWrsOLWxJzlcbbVYhIv1p0INpIwkoEJ0thBypIw6M2Ush6bsJLs41YUf
         0fDK/9keiyzgnjUnODSLQZeKnbZ3RdlzOUQGPrbAC31gKQFvwut+Zt5YjKbZvnuedVE5
         5OYw==
X-Gm-Message-State: AFuF++kRufuFcAt6MLrmdBHDEAiP/27IXJaDKpULWwPccbUmcCiC0JK6
	BoF4JjSAQNuS6sDLizB7Q3JjwooCdLlxfJs1dNKabJhavyCa4E4MUAm8/GiTxWzAfvo=
X-Gm-Gg: AYBFou3L81lWxGuJschd0idLJhkpxUcPrgYNu80menqo8QHR9er+QHbwetNqNdvOyVB
	tuxSIuAi9FwnaGQgPI5iJKLrGA8/xkbid02bOxcbD9XHr1WeVaPEUrsloKLyyZst3hDm5eC/osV
	krrJRsCZH7p0mAOXJxPcLDxqq7GD4t0pnlZuDL3os+MDE7c1TSrak5zMPdpjatSUC5CNFXc2kpJ
	sQF9dJN8ePCjno6Irj72B2R57+GAERxK/a/oEwe5r/fve8Z8ydAeZKfYgmeRiy90PVXSxCKRnJN
	9igG7RqvmceSjzmdf+XpZoM2vZa5bxLpOtBwxsDbUy6qDmrhEHrCOjbMLf69IM4KnnQBiVUVWBe
	Ld+gUYv9sp9DOCDxVpIa70MDRVCDLws6SAHLSA5ykccb/8r3sWlKyY/kKa5rfgOhmogdD8BGAzz
	y/g5VrPICBK/U5jruWkd0lvY0puwJsve+mutxgSwg0dGHfibOrYTNISf0xi2w6f7JYbcYvyERZn
	MU1ASrJdJ5kv/2fhmbpLMxeCPNzBQ==
X-Received: by 2002:a17:902:eac9:b0:2db:5c0a:f18c with SMTP id d9443c01a7336-2dd8e00ecdamr19914175ad.6.1789541074649;
        Tue, 15 Sep 2026 23:44:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:34 -0700 (PDT)
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
Subject: [PATCH v4 09/11] mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
Date: Wed, 16 Sep 2026 14:43:39 +0800
Message-ID: <20260916064341.1825793-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CEF96180005
X-Stat-Signature: k3s4713x6qakmiqjbbc9eets9ae7itho
X-HE-Tag: 1789541075-4657
X-HE-Meta: U2FsdGVkX18v1551tA58zhbobgmpXQ/tqlt4mQWt4TmP65uytA6BMgx8jXikvTIxngkhWfVcBy1k22vHnXYXdcM0SdC+dgsksPEAVGwgfOAy769JnbABVWiICpc116XoCN9F1u3zlsvRqxmWUo7s5rjO92fs3ikZUVHvKbE6xS5eCJP0CLYlZWfHITid3tk8oe3b3/tGdKJXUsESgTgYLn51ARUMvViku73v7oonn8dSj55zQjZHTT6zXZgS5N1DrYLkcA3kRRIQyHjxCPJK4dB/GAZsgePXH25nNA2cN1QbQqsVzt0WHRgp1Nhjk9tzVPKb21Y91nE7sEVZR5ZhA3XYOZeRmkhMZ8M5pD3Awb+G6o5eKU4x3chU89lVKNZZE4XpYd2ROw6Z7rLfQ1S+6N8+5eC45xAFNC62Nl/gAfyP1hIoQWvygMPoZWUGJSsRnqGua2dmL5tA/uPzxPvoRK+3D0yOiDjw1GuVdltDGQHtekCwLVDCxI9c7NhQk4FHmdRkFKsWT2xY9yShgaAivGzLy5brrm/BJQrgNlc4Y0KjzVAya93lGQTv1D/EhxLk1be+hTsb8I6iis6s/pYJGfxyn9JxWqRhjdpwj74ptfvFl7g4LyPsiB1AM/3LDHhfNuTuQh6CCKZzrzuIvKEFMoIrJc9J6Vdf9/jimJfyc8K/sWIGWwtfxmV2q81GqCMHn4XPTnAzyK/ARAOuob3uPa9N5HpOzg8XDPQP04KcyYGQ/aXoYWzYBfTyEcOrvE2uU9J6VM0qjuGqb7m8bMIQexeDM1AM3Jm+KV+Cwa3pm3M3uVLvCLhZL7MAnxc3A200uSKkZ+9cbdPpgWSYnKZb22ACvd93s98jSPVfX9cJfmg83o9Al7r7qeUAsrnFJPhAK3HcdclgOBKwApcD5Y+ovkqZ7qR1YWLvhXnydjbX/puVLb48YJvsgcTasbNUBug/CBggxhOc8R66oBimqNk
 aI0MJRej
 dBXrhGvqLPLxa/j1ASK98vqxDVuuBwmznUQwCC2oC7wryaPgqaAlwSf5YjBhBtShuBdU8wkPFsjLtsyiAYiyjC2K4waDz+vB4FSFNM4vKkuJRrFhvSunm4vleTPpkth1/m+UxUUwI9xw3DGhjrTzLtn3QTBXp9rIm8d9Z+GIY5dN/IxyLXFeIHvQHc6TWYqEVxCYV7YEk3m8nymAc4u1gMW7bddbC1dkv3t6cQ+5spv4FyLdAnHk2F1TtgMl0ELr53LtBEMAtOwjzT3jd3fhUWS+7D9YhhRmJaQSBkavKsvdyyzWFN8zRZXAnsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The device DAX vmemmap population still reserves one extra tail vmemmap
page after the head page.

Drop that extra reservation and let the shared tail page cover all tail
vmemmap pages after the head page, so DAX follows the same reservation
model as HugeTLB.

This reduces the reserved vmemmap pages for optimized DAX mappings to
one and removes the now-unneeded first-tail population from the generic
and powerpc paths to simplify the code as well.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Collect Acked-by from Qi Zheng
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 46 ++----------------------
 include/linux/mm.h                       |  3 +-
 mm/mm_init.c                             |  2 +-
 mm/sparse-vmemmap.c                      | 13 ++-----
 4 files changed, 7 insertions(+), 57 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index ee068f24a79f..9ca28e4a610a 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1218,39 +1218,6 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int node,
-							 struct vmem_altmap *altmap,
-							 struct page *reuse)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = pgd_offset_k(addr);
-	p4d = p4d_offset(pgd, addr);
-	pud = vmemmap_pud_alloc(p4d, node, addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, addr);
-	if (!pte)
-		return NULL;
-	radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1297,7 +1264,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		if (!pte_none(*pte)) {
 			/*
 			 * This could be because we already have a compound
-			 * page whose VMEMMAP_RESERVE_NR pages were mapped and
+			 * page whose retained vmemmap page was mapped and
 			 * this request fall in those pages.
 			 */
 			next = addr + PAGE_SIZE;
@@ -1318,16 +1285,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					return -ENOMEM;
 				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-				/*
-				 * Populate the tail pages vmemmap page
-				 * It can fall in different pmd, hence
-				 * vmemmap_populate_address()
-				 */
-				pte = radix__vmemmap_populate_address(addr + PAGE_SIZE, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-
-				next = addr + 2 * PAGE_SIZE;
+				next = addr + PAGE_SIZE;
 				continue;
 			}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 070ce27e9cd3..66d384da4433 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5167,7 +5167,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	2
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
@@ -5187,7 +5186,7 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
 	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
 	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
+	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
 }
 /*
  * If we don't have an architecture override, use the generic rule
diff --git a/mm/mm_init.c b/mm/mm_init.c
index efffa8609b85..56bb4567a494 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1056,7 +1056,7 @@ static inline unsigned long compound_nr_pages(unsigned long pfn,
 	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
-	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
+	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
 }
 
 static void __ref memmap_init_compound(struct page *head,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 7b5b9ceec697..39f0cfeefc6a 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -136,7 +136,6 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_compound_order(ms);
-	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
@@ -147,13 +146,13 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
+		return VMEMMAP_OPTIMIZATION_PAGES * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
+		return VMEMMAP_OPTIMIZATION_PAGES;
 
 	return 0;
 }
@@ -521,17 +520,11 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		if (!pte)
 			return -ENOMEM;
 
-		/* Populate the tail pages vmemmap page */
-		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
-		if (!pte)
-			return -ENOMEM;
-
 		/*
 		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
-		next += PAGE_SIZE;
+		next = addr + PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
 					    page_to_pfn(page), flags);
 		if (rc)
-- 
2.54.0


