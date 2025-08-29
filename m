Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911BBCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D315E6B0096; Fri, 29 Aug 2025 07:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A396B0098; Fri, 29 Aug 2025 07:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83266B0099; Fri, 29 Aug 2025 07:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9DE6B0096
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:53:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A132C06F3
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:21 +0000 (UTC)
X-FDA: 83829634602.09.0169BF0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6859AC000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4BllJvMqCzyeYfgbpIpdXMBKPOmSkw7QSpJtSIw0FO0=;
	b=3htH1xbhClHcAV65E0c4G1jGOcQegYWgFA8QqekNgyDoD1iLN+iLk3Ep+EkgKXQdSY79DH
	AU25EFJf8o/mCQKOvXvvbdQCf2lU5yqV/8+kEBMY0iM/6mmsvvmSZY6RuiSaUauosIos32
	i+mv6HTklj6KzI9UfQYGKmk2tq8yOf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468399; a=rsa-sha256;
	cv=none;
	b=VgbmN3mQHbeVI3jpXkw3bmZjlTfKPdFvY3SntRTdQtbie91hgtIC5Z7tXv5E50f2bCwkvt
	NfWyqFmFiWDCdSbZiGQ0mCz1wFGY9RGzxF0+H1nmU2vfHiDcjPyAPon0I+G3whz6DweUQT
	vYrdDSh7CUxkZZdSY4n0GNaHadqHFxY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3ACFE19F0;
	Fri, 29 Aug 2025 04:53:10 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8498A3F694;
	Fri, 29 Aug 2025 04:53:16 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	scott@os.amperecomputing.com,
	cl@gentwo.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v7 6/6] arm64: mm: Optimize linear_map_split_to_ptes()
Date: Fri, 29 Aug 2025 12:52:47 +0100
Message-ID: <20250829115250.2395585-7-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250829115250.2395585-1-ryan.roberts@arm.com>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6859AC000D
X-Stat-Signature: uwpys3s5pjnwxsmtkqo46eqgbdwsp8ur
X-HE-Tag: 1756468399-705349
X-HE-Meta: U2FsdGVkX187+YyZo9Sfzhi6aidrPegULf5yXWiWKhdPVWcUGybMjGrAn0xoCZdr/z4P1qdXdQhzvO8nTw3UoxrdF1jh0lEi0214euZ/d6k+6Bmqyq78Z4J9JUVLL8UW/B34PwjxYJxSgu9fWnLPOifuT+arFaCXl4rD5pMF6DwMvVUKR+EjQNpx1sO7LMJs4mFzSMX8SxwZGcvKhlNXPamocC2vxrmBXWBIahEBzU8BitfNvGifQGciS9d1HmL5Js6LGWWiJlB5nxj8n8zPJmupP1sW7ls3stHjuNC9Hvo9lSJ8vUcjdxKRp9QIH6hIhqRx+yjOui6rm+X7qWrMteQEFKOe1kCNajYa55uCeb5PsGaBMyBX78eJTG0egV/VKP1PT0YDwZobxGrzzCvfaoxR9jQmvJ+uh7CyP+zMsLiwexY105aof/yCopOXdyvbeu6Z8+Y6XNzPsjSdGDcPW15g0ML+nSZfklUBrMvA2Gt+E2nVZm6neOJMNN20/ZGw0nSsiXi74jXJ+d8LhXraBJ6dgaZQWHb0ukLT+OYoRabkyNDl7O89Duc8IsfI4F9Kk97J1ta90Z42prSzPMEvnEj5eL7HE5WYwQT8kNqzJVJ4Uw/VU0IOeYSJNAby3RsDCsZ800Zj0A5gVVQYe7w5luJp0QUxXiZDAk7vf0iyhLVpUTDuRNDDdilF7aTFo/2a2bFMEPzedPtmOQ9FdNvqH2wMVeThi12sgH+hurfxvfB/WHjrv61VhSPUNUr6h4/lyu4u9TwO09CV7mNCqwtopddIhyuzQlawuooxuz7SFA74/3+Zq+JU7HhGKYfUunRsUiMiJzFVxDwwVbcC8EuXUJbnHFvNzZxwuBKS0ECkC0103XZ2BRwl6tQpfDKXMH6eTgPmbnQQk3Ls59zSk1LBzauEYQ5B2O87zBXaXkjNljtC+iJv5wq6D2SQSs6I/75yQRxFmlbd3YOj6asFcH4
 rH4xo2gg
 dQOdvG7Nr4O+gI0J1b/tiuQ3d+9LSG7xJ6F9XMLqNAgzOU5EXl64squlK7sDyqEUVag30cjyQE+YmlaL+XfpD4I9OhEexMeeSFiDeLRbi0LN368KtA/ByrcnB2Q6J4etvV6sqKGhzxWrDiFJs+dxS558wqZVSGOaMrOpU3skVKVKJTOzWw89lXSOjc/miklBBUjx6JBqBbwj8Uc4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting kernel leaf mappings, either via
split_kernel_leaf_mapping_locked() or linear_map_split_to_ptes(),
previously a leaf mapping was always split to the next size down. e.g.
pud -> contpmd -> pmd -> contpte -> pte. But for
linear_map_split_to_ptes() we can avoid the contpmd and contpte states
because we know we want to split all the way down to ptes.

This avoids visiting all the ptes in a table if it was created by
splitting a pmd, which is noticible on systems with a lot of memory.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/mm/mmu.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6bd0b065bd97..8e45cd08bf3a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -550,7 +550,7 @@ static void split_contpte(pte_t *ptep)
 		__set_pte(ptep, pte_mknoncont(__ptep_get(ptep)));
 }
 
-static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp)
+static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp, bool to_cont)
 {
 	pmdval_t tableprot = PMD_TYPE_TABLE | PMD_TABLE_UXN | PMD_TABLE_AF;
 	unsigned long pfn = pmd_pfn(pmd);
@@ -568,7 +568,9 @@ static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp)
 		tableprot |= PMD_TABLE_PXN;
 
 	prot = __pgprot((pgprot_val(prot) & ~PTE_TYPE_MASK) | PTE_TYPE_PAGE);
-	prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+	prot = __pgprot(pgprot_val(prot) & ~PTE_CONT);
+	if (to_cont)
+		prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
 	for (i = 0; i < PTRS_PER_PTE; i++, ptep++, pfn++)
 		__set_pte(ptep, pfn_pte(pfn, prot));
@@ -592,7 +594,7 @@ static void split_contpmd(pmd_t *pmdp)
 		set_pmd(pmdp, pmd_mknoncont(pmdp_get(pmdp)));
 }
 
-static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp)
+static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp, bool to_cont)
 {
 	pudval_t tableprot = PUD_TYPE_TABLE | PUD_TABLE_UXN | PUD_TABLE_AF;
 	unsigned int step = PMD_SIZE >> PAGE_SHIFT;
@@ -611,7 +613,9 @@ static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp)
 		tableprot |= PUD_TABLE_PXN;
 
 	prot = __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
-	prot = __pgprot(pgprot_val(prot) | PTE_CONT);
+	prot = __pgprot(pgprot_val(prot) & ~PTE_CONT);
+	if (to_cont)
+		prot = __pgprot(pgprot_val(prot) | PTE_CONT);
 
 	for (i = 0; i < PTRS_PER_PMD; i++, pmdp++, pfn += step)
 		set_pmd(pmdp, pfn_pmd(pfn, prot));
@@ -669,7 +673,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 	if (!pud_present(pud))
 		goto out;
 	if (pud_leaf(pud)) {
-		ret = split_pud(pudp, pud, GFP_PGTABLE_KERNEL);
+		ret = split_pud(pudp, pud, GFP_PGTABLE_KERNEL, true);
 		if (ret)
 			goto out;
 	}
@@ -694,7 +698,7 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 		 */
 		if (ALIGN_DOWN(addr, PMD_SIZE) == addr)
 			goto out;
-		ret = split_pmd(pmdp, pmd, GFP_PGTABLE_KERNEL);
+		ret = split_pmd(pmdp, pmd, GFP_PGTABLE_KERNEL, true);
 		if (ret)
 			goto out;
 	}
@@ -771,7 +775,7 @@ static int __init split_to_ptes_pud_entry(pud_t *pudp, unsigned long addr,
 	int ret = 0;
 
 	if (pud_leaf(pud))
-		ret = split_pud(pudp, pud, GFP_ATOMIC);
+		ret = split_pud(pudp, pud, GFP_ATOMIC, false);
 
 	return ret;
 }
@@ -786,7 +790,13 @@ static int __init split_to_ptes_pmd_entry(pmd_t *pmdp, unsigned long addr,
 	if (pmd_leaf(pmd)) {
 		if (pmd_cont(pmd))
 			split_contpmd(pmdp);
-		ret = split_pmd(pmdp, pmd, GFP_ATOMIC);
+		ret = split_pmd(pmdp, pmd, GFP_ATOMIC, false);
+
+		/*
+		 * We have split the pmd directly to ptes so there is no need to
+		 * visit each pte to check if they are contpte.
+		 */
+		walk->action = ACTION_CONTINUE;
 	}
 
 	return ret;
-- 
2.43.0


