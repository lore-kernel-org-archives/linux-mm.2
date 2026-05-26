Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CB7FCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532976B00C5; Tue, 26 May 2026 10:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E39C6B00CE; Tue, 26 May 2026 10:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA136B00D1; Tue, 26 May 2026 10:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2344C6B00C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:56:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D63E1C185C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:19 +0000 (UTC)
X-FDA: 84809871678.29.28CAEAB
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf12.hostedemail.com (Postfix) with ESMTP id 842F340009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0iMEW0ts;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+aFKJrjVwtzzo3eLUyF5+IW/uSU3+87cCQnsOJ4oeg=;
	b=BxAYDp8gQM18mSbw/FNQt+U/aMnlWqjGQY/Qke0m2EyabCqF8VTKq4NANe/WOA9+KwHq2p
	VeKIBN0fq49wqFTrne8IS8o/xnm0D3eOltRVTinlJ33OQsWhhZru2VL44GfEaqACU9fIng
	uM7qEIe2R90titqfAAY+KNaI/qC4/XA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0iMEW0ts;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779807377; a=rsa-sha256;
	cv=none;
	b=gLr5POXMZu8iLTnwFQowTwJzUQ8jUePO5TK3EXPv1H5emtYvq6oBzXEBn15/fMvx+b2ZbQ
	niD4IistxCVGtx9N0pbdgb5UxjkIxeZCRgIZMuTro4j2/uceFyIf/V+ox+iIOjF9smI348
	g7y5hN8RaPykoDMo8vNzO8fMFFW3MoI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=l+aFKJrjVwtzzo3eLUyF5+IW/uSU3+87cCQnsOJ4oeg=;
	b=0iMEW0tsF/BBgk4ze5nZcHMmdemvVB1xjaYbneUnB2p3zX6RYNWiFoVmHYi0xEF5s2CCLn5Oa
	A/qAQxOhoQKr4PXdSbSP16hYOVmOosHS57dE7hnJY/IV4AfhzMAuDqs4A7vCLbtKI+1pZ9V6gfL
	dPaibFsUNvw+EGtOP7+W/Jg=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gPwbg0PqJznTVR;
	Tue, 26 May 2026 22:48:15 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 985234056C;
	Tue, 26 May 2026 22:56:12 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 22:56:11 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<ljs@kernel.org>, Juergen Gross <jgross@suse.com>, Jonathan Cameron
	<jic23@kernel.org>, Will Deacon <will@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Peter Xu <peterx@redhat.com>,
	Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth
	<thuth@redhat.com>, Coiby Xu <coxu@redhat.com>, Dan Williams
	<djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Conor Dooley <conor.dooley@microchip.com>, Rik
 van Riel <riel@surriel.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <yintirui@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-pm@vger.kernel.org>
Subject: [PATCH mm-unstable RFC v4 2/7] arm64/mm: use PTE-level pgprot for huge PFN helpers
Date: Tue, 26 May 2026 22:49:58 +0800
Message-ID: <20260526145003.88445-3-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526145003.88445-1-yintirui@huawei.com>
References: <20260526145003.88445-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 842F340009
X-Stat-Signature: qtgzck97ecea9pe54s7dj9bawp774pgk
X-Rspam-User: 
X-HE-Tag: 1779807376-760622
X-HE-Meta: U2FsdGVkX1/Nz74o89kIltOXCL00/HlRr1wVKRyAHvZ5huTqy/jsBAdiiA8SV8h9o1fVvJWo5p2PoV7nMiK4AS65YUVcX62xskG9csBm9P+LxZ+YOr4rU23JENyOZZnUMPEtnUtuPaaS1DEdi5h/fAUgiR54Sk54txDEynBp7/OQELZ5QHtSZm25RaUbHEX3r+tBKJ2RkueLdfB6m11zZtPKMSymeFQo3i5yk81bamTzuk/KYvmFcl1eQXhQxoC/MzbSJmxvhOxNG5rlG6nGpslbAtPm3nF/Nn/NGfWQMSpTZ1drNahECjDhud7sjMv6ae+lUq7y1uKYzTD4Cia9nLr1RJQjheYbDRS2MqsYzxkNR3QtTATZy/jlmBqULkIqBJHXYKPlSQJxJtEstLCopOtqSITCzzN4ow+F8k5NWzdIFcwqTEb9QpEA6aGm2aoU2o9HJLPdLGdD9iN/erV5B3gB9kohPJ615gfgMZfE9Qb4ATxdRfKzG1QWX9Pc0X2yDycf9qOY7I3Kde61rRI4/VowjBZlFgmJYyGea+Tqcj0l5Y08DkxZwC4ni5s4XfQfDu+WQkfrc6KjQcFLN4YrVkr0nm+4E0EJdreUyTwpwbpuUHcjuLd4W/fW6wqIMFVslExudg0U9MUVgAvuW7kqGZobyhFGxJafWG1M/HVoldS4MozZA5dgmdG+GCWWkiASaaWYTEWdHVH3hcXiA77HZxBNl114w1f5tM48LSuu59srNRXBvA35XRPuXnqDG0QOhRc8VIiA/bGA1uZc0dKle+Az6a40rl0ho1K5uBeI8MzpGW8E/+Rkp5oufE0wyOIy3tZoDmzPiN75jiGBhDolF51mXKO7rwRckLYKQlK2YFB71sEl+KEOtehD2ooEuasve5HT6dGtblRAKAHVwUVdRS5ZdRRyhvUYz0PbfRo2uikg98mkVkrsKFKGkh7imR3Kq3+PvjLE0judxQpltIq
 2VbOfHH6
 gpgUq4W853xIcU09zEyaERQxIKu64uGB0U5i35siS3uR2bGNTDqwjMMTAQhyUCt2YuDwDGH3FJGRf1LLPnHEnzrGfZ76+AWWB0MbfkyAxHUHPRzfENAMcVEjOxRlFXeOdCuAysi+mGLMESB1fQt14JrUqLxdIBl01JCVaKYZjF9l+h/UeYn11WCqCpl+dymClvIiLgDLjyd2U3t16XAGWp51xxRKb/EPw1acCg5YtOMjkcNjas83tLvjP9ySbFUABSQmiZrXj/g9I8bsDP4pP/eH9nx+cRB+HiePSC3u4tSICQhO8GRUscxxBHxleVU9WrYd9BAgUqZsBYkIxY1oNvTOPwVizLvl4aTPje305GqPAPZCqNHR7uTphdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make the arm64 PMD/PUD PFN helpers use PTE-level pgprot_t as the basic
format.

pfn_pmd() and pfn_pud() now translate PTE-level attributes into block
entries. pmd_pgprot() and pud_pgprot() translate block descriptor
attributes back into PTE-level attributes.

Remove mk_pmd_sect_prot() and mk_pud_sect_prot().

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/arm64/include/asm/pgtable.h | 48 ++++++++++++++++++++++----------
 arch/arm64/mm/mmu.c              |  4 +--
 2 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4dfa42b7d053..c3ee12e14f86 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -511,16 +511,6 @@ static inline pmd_t pte_pmd(pte_t pte)
 	return __pmd(pte_val(pte));
 }
 
-static inline pgprot_t mk_pud_sect_prot(pgprot_t prot)
-{
-	return __pgprot((pgprot_val(prot) & ~PUD_TYPE_MASK) | PUD_TYPE_SECT);
-}
-
-static inline pgprot_t mk_pmd_sect_prot(pgprot_t prot)
-{
-	return __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
-}
-
 static inline pte_t pte_swp_mkexclusive(pte_t pte)
 {
 	return set_pte_bit(pte, __pgprot(PTE_SWP_EXCLUSIVE));
@@ -628,7 +618,13 @@ static inline pmd_t pmd_mkspecial(pmd_t pmd)
 #define __pmd_to_phys(pmd)	__pte_to_phys(pmd_pte(pmd))
 #define __phys_to_pmd_val(phys)	__phys_to_pte_val(phys)
 #define pmd_pfn(pmd)		((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT)
-#define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
+static inline pmd_t pfn_pmd(unsigned long pfn, pgprot_t prot)
+{
+	pmd_t pmd = __pmd(__phys_to_pmd_val((phys_addr_t)pfn << PAGE_SHIFT) |
+			  pgprot_val(prot));
+
+	return pmd_mkhuge(pmd);
+}
 
 #define pud_young(pud)		pte_young(pud_pte(pud))
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
@@ -652,22 +648,46 @@ static inline pud_t pud_mkhuge(pud_t pud)
 #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
 #define __phys_to_pud_val(phys)	__phys_to_pte_val(phys)
 #define pud_pfn(pud)		((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT)
-#define pfn_pud(pfn,prot)	__pud(__phys_to_pud_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
+static inline pud_t pfn_pud(unsigned long pfn, pgprot_t prot)
+{
+	pud_t pud = __pud(__phys_to_pud_val((phys_addr_t)pfn << PAGE_SHIFT) |
+			  pgprot_val(prot));
+
+	return pud_mkhuge(pud);
+}
 
 #define pmd_pgprot pmd_pgprot
 static inline pgprot_t pmd_pgprot(pmd_t pmd)
 {
 	unsigned long pfn = pmd_pfn(pmd);
+	pmdval_t protval = pmd_val(pmd) ^
+		__phys_to_pmd_val((phys_addr_t)pfn << PAGE_SHIFT);
+
+	/*
+	 * pgprot_t represents PTE-level attributes. Convert the PMD
+	 * block descriptor type into a PTE page descriptor type.
+	 */
+	pmdval_t mask = PMD_TYPE_MASK & ~PTE_VALID;
+	pmdval_t val = PTE_TYPE_PAGE & ~PTE_VALID;
 
-	return __pgprot(pmd_val(pfn_pmd(pfn, __pgprot(0))) ^ pmd_val(pmd));
+	return __pgprot((protval & ~mask) | val);
 }
 
 #define pud_pgprot pud_pgprot
 static inline pgprot_t pud_pgprot(pud_t pud)
 {
 	unsigned long pfn = pud_pfn(pud);
+	pudval_t protval = pud_val(pud) ^
+		__phys_to_pud_val((phys_addr_t)pfn << PAGE_SHIFT);
+
+	/*
+	 * pgprot_t represents PTE-level attributes. Convert the PUD
+	 * block descriptor type into a PTE page descriptor type.
+	 */
+	pudval_t mask = PUD_TYPE_MASK & ~PTE_VALID;
+	pudval_t val = PTE_TYPE_PAGE & ~PTE_VALID;
 
-	return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud));
+	return __pgprot((protval & ~mask) | val);
 }
 
 static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e5a42b7a0160..2dd99d595f19 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1816,7 +1816,7 @@ void vmemmap_free(unsigned long start, unsigned long end,
 
 int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 {
-	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), mk_pud_sect_prot(prot));
+	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), prot);
 
 	/* Only allow permission changes for now */
 	if (!pgattr_change_is_safe(READ_ONCE(pud_val(*pudp)),
@@ -1830,7 +1830,7 @@ int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 
 int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
 {
-	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), mk_pmd_sect_prot(prot));
+	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), prot);
 
 	/* Only allow permission changes for now */
 	if (!pgattr_change_is_safe(READ_ONCE(pmd_val(*pmdp)),
-- 
2.43.0


