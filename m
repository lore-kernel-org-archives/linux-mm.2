Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DCAC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 04:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485896B008C; Wed, 23 Sep 2026 00:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E256B0092; Wed, 23 Sep 2026 00:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373046B0093; Wed, 23 Sep 2026 00:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1961D6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:32:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DE851A03FB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:45 +0000 (UTC)
X-FDA: 85243756290.12.A759340
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D559E160006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GWw24kQK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790137964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cdl4n7J0NNjeWxNe/6kR65q/Rf/LtvWHYWRSkhFpZ6o=;
	b=tiZXLTC1QlexDhMfnsAkbieplFq7D10sZDx2IaPV4o7fU4/jhpnDdx11y2qR+Zc2W2JzM/
	G3FcfojDbRyZ6fyIx/y/SbaN5zEZGnJykdWH9EsPw2wfY+Kiohagjrzdk78PRxzodltHdM
	uf+S5Pn1BvOlTYMviaVfquD8cqkD6qo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GWw24kQK;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790137964;
	b=8l+/V9bTOQZdeQ2zLXA3i6uNg9LhTwn666iIgs6TDJmdeHXkgcsGXoSWpfXignwonoGtJY
	0MQ26TsgBwXoObJ8tj4avycG9+mDSYmn9FLg6StQBQQ8hL1nZ228aF0Xgn52DXb9ReNEZ9
	DCcYQoL9OqMFBoeW3oabr+eqJkgXpIo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B7D11655;
	Tue, 22 Sep 2026 21:32:39 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28E6C3F86C;
	Tue, 22 Sep 2026 21:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790137962; bh=Blq0g3C+Aco5j50FVYlFra5qoOzNa+7RbX7vJ/LL7hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWw24kQKYVL6QVo5QDNfRGhCdHnFv+zt1jcIwVSlUFS61k5th89XJXeFDeGMjNx/U
	 uE2430iBu4OuR5C8oyoeWFjSd8r5WqWrfcTaGvvXEPfXV+AVSGNzda1dXZx2erKFFi
	 KFwSBC/N9CblpexCFxs5ffWhb3pSQ+AL6/G3HNKE=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Helge Deller <deller@gmx.de>,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] loongarch/mm: Drop all pxdp_get()
Date: Wed, 23 Sep 2026 10:02:21 +0530
Message-ID: <20260923043226.331880-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260923043226.331880-1-anshuman.khandual@arm.com>
References: <20260923043226.331880-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pbf839duftyf9ame36uqd7so1butek6s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D559E160006
X-HE-Tag: 1790137963-274671
X-HE-Meta: U2FsdGVkX19YIZRFLif6zqvJC9cfZ3happdkpzvd8T6nKPCSadXmcqkeDjlPOOAj4Icla2V2eIB1MCan/5o1QTRps3GrSJy6dU2Eo8PM0j1GeM9FwFHV/oPcDWgmLe9YUnHCxybs3XMi8dNP64MaLs1CTweX6aGU1wtRLOI+n6rEolTRQLYTK9pp23NLWq0/APXrQAGXahhH0PibsqorBCN7hJTuxxk6aOIgqLBfRKpplE9il/83zefaorF2TxWGXUGUMJ3qoVuIsl6kK8gwXsKPqD0k19lBuPH48YKyY9Ufwhf4hL3o1dZZH+zvhKoltwJGR7wZBYFn1O7AahpEWOy7x5I93KlZMtN3P7hJJV9QKwaiWc6ezfw6QwouwFHmQZu8agRIfOT072z5aix5Y262WGTPyjJErOdgy/0DCju/P9OTtbC2hbG3RTU2ali6HkwmMdJq6NlYJkRnPqkPAwTTmMpNApZsNUafcP35AmiWLTsw4f9GuDNgviYzX4o5oMqnLnzDFFvQeKxjHlWHGhMpFboH+Ej27sqRcQeZ6DGabiuFvuukrTqgfUH/BDevCFPVA7BAeBuDBGDN/4qBK+Bnk8TLZMxfwzM0It9qocyBPwAYg/2EX+CAPLOhxII4QZaPi3bfx6sxdLJ/kO+/L+BYEwba8w4NUj2vaLijRE13GYyHA+YSzMl7216jNbcoNV8AlMQumHpHrd3B2LQ38YBl9AYM3NvwDv8EQILFevmrdz7qaTUhv+su1VO0J5PCGf5UhTBrVs6x31BpZg3d3Z2g+wJzjWsepjTg6d2QhQPCqQnAGms0pomEMUfZjaFgIH8OheusZGSvW/H09l1nbFECjj3MDnijjS+87T0audzVTSt5PhEbADCuIau7y7uPCXcBMZH8XqOUb+JBs3Tl3ZUDB9cQHnNDmYtqRO3nY5i5Es9IsNs/nk1BmPbOUWRZOknNcFl9QU0HbxtyFAz
 FySRPGqS
 5ldZnVH+V3Q4ttgb5p0FcqNu/KOkbLYf3nitxISRn/THHKsIQYmc/Fo3cDOUH8aCR/OndDDOcySJjZJjPtd7ZyjSH7jqtsscYbJHWcPOEkLCcE+0DYKC8Gp822z+rX5qcjK1OO/UtJDkCejAuC3nHFLcpDIUxsryOQ6PXCAUOnzWpm0uRramXIL6e/53rxNVlZ1re0n7lu4xrmO2AuXGhoqptibzy/60Cv0ZmvN3jae+KHuNjeheWYP7UnYmDpcN8ymX4yBBA1x2YqAJdT2jQCfD9GV++so2nTbwy2xWePOGCOjt99ncCwVVAGE7DkCjnvZ8EPsZnBJLbKhxVg3BC8+uaXGGn+KtCK8loTFrppchVi1s+k0j+blWdhO5M9DzoUQbkv7kTrALKx1AzcnKQoMy8fWu77OVxS2EF6irMQKT+1p+v6nU/b+FcyTzzzcPgh9n1TBKCk6tQDMs+4FVjw1uTSsDkYF524Oa55h7WKJ8ANY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current platform specific pxdp_get() helpers are exact same as the default
ones defined in the generic MM header (include/linux/pgtable.h) thus making
them redundant. Move functions that are now depending on generic helpers to
avoid build failure.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: loongarch@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/loongarch/include/asm/pgtable.h | 20 ++------------------
 arch/loongarch/mm/init.c             | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index a05f6a4928dc6..b1060b86d5353 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -132,9 +132,6 @@ struct vm_area_struct;
 #define DIRECT_MAP_PHYSMEM_END min((1ULL << (cpu_pabits + 1)) - 1, (1ULL << MAX_PHYSMEM_BITS) - 1)
 #endif
 
-#define ptep_get(ptep) READ_ONCE(*(ptep))
-#define pmdp_get(pmdp) READ_ONCE(*(pmdp))
-
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -378,12 +375,7 @@ static inline void set_pte(pte_t *ptep, pte_t pteval)
 #endif
 }
 
-static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	pte_t pte = ptep_get(ptep);
-	pte_val(pte) &= _PAGE_GLOBAL;
-	set_pte(ptep, pte);
-}
+void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 
 #define PGD_T_LOG2	(__builtin_ffs(sizeof(pgd_t)) - 1)
 #define PMD_T_LOG2	(__builtin_ffs(sizeof(pmd_t)) - 1)
@@ -618,16 +610,8 @@ static inline pmd_t pmd_mkinvalid(pmd_t pmd)
  * different prototype.
  */
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
-static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
-					    unsigned long address, pmd_t *pmdp)
-{
-	pmd_t old = pmdp_get(pmdp);
-
-	pmd_clear(pmdp);
-
-	return old;
-}
 
+pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long address, pmd_t *pmdp);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 4b46c5d30708d..5751b3bcca994 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -266,3 +266,22 @@ struct execmem_info __init *execmem_arch_setup(void)
 	return &execmem_info;
 }
 #endif /* CONFIG_EXECMEM && MODULES_VADDR */
+
+void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = ptep_get(ptep);
+
+	pte_val(pte) &= _PAGE_GLOBAL;
+	set_pte(ptep, pte);
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long address, pmd_t *pmdp)
+{
+	pmd_t old = pmdp_get(pmdp);
+
+	pmd_clear(pmdp);
+
+	return old;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-- 
2.43.0


