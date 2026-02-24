Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DAA5EFB7FB
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18806B008A; Tue, 24 Feb 2026 00:12:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF016B008C; Tue, 24 Feb 2026 00:12:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEF46B0092; Tue, 24 Feb 2026 00:12:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDF176B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:12:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68586C17E2
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:37 +0000 (UTC)
X-FDA: 84478179954.16.E8072EE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id C12ABC0007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6CnmJdYzNBH6v1gLDDRgLYkrgcpHli5wtReFHoAMMQI=;
	b=zQ2eS92kPqiuqH4kGmV1xeMrWZXsh3FVncZDTUaoLOzi9PhS+xDSvxpAA33ZPYSLc8Dk2G
	if7ECO8St7Dzs+BqK8zslOXOWnHT2w/CF7ULjc8egtV8jezCKZV75ZgljAkAj/5mNfU47W
	utQtgT3znw8sjIN5pOCU/6uD+AmH7IY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909955; a=rsa-sha256;
	cv=none;
	b=lsGw1Kty+7lfGGpzcJiTp4mWfFz59kxi8Z9x/YIZygQQpPvyBleuUqlqZtDMIaSAKS287R
	t5YhheK79c01K4YHm+BuhUnC/yDHEWTHxo+ta/ItzVyPCtLDcy+xOYDeTv9bS9je49T+17
	w8MjeIlI7LX1uZgdjK8ItNEzwjx7OIU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3E3B339;
	Mon, 23 Feb 2026 21:12:28 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C4D163F7BD;
	Mon, 23 Feb 2026 21:12:30 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V1 02/16] mm: Add read-write accessors for vm_page_prot
Date: Tue, 24 Feb 2026 10:41:39 +0530
Message-ID: <20260224051153.3150613-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C12ABC0007
X-Stat-Signature: 4a7kpw3enj4hi48gmzg8nqtb8mb95bqy
X-HE-Tag: 1771909955-925715
X-HE-Meta: U2FsdGVkX18oAYJBEWp1bS+v66bSt/yx6ADlJr+/s4mIy9BMEKEqQGDoMcbh5ZZBV2+KPgRje3kcEcJYTxrYg/n2TK0YJnDqFopIGUj4qm7W/G7GnNCSrZ5fsLTUYi5QRRWTXT4GI7cQSaoDT7rkXl9qLcvyVwJCEzMA5/4l5BQ8HuPsg/JF7cPPkdOz6v6JDZHTQHLxXzzn2Ualg6eR8pcqidGZi7po13lm1+9R3ZpNh1HL0ztmO3tokcy8Te6Qwy1FGx9p6ky+rtpzOx39PhyTCzrC0DRN+6dpyiDVRTb0UqfkyBZEVuHi/yIQFg6tNcZuoQONDy5cm2lJwTJN7NKNdO2Ko5gmqGGrRd0vKRN6RsUae4BdqlPnD4HdBz5ZgNQZzGHCJJLOtgBlq0YVq/K2Ploii1kn2OSJV6AB133eJFLxBVebe4/M3SO/Dc9wAah3SgJfOnV5gQnm1M3VXDfAjli1mQNR9cHdTtkjGGfuuh5wzKD/iGXak39OJM8RHwkBiAQ0rLsW9H0UFqULC+Es78VncOyd8z+LxGSd3qinUO2LjMjILaEK+TmSyuUMnJwhTM/V256ZaijJz7ykwE6laVd9eG6LzEz5BqHUb4dqDP1DCuQ1fdgp/n1vH9wu3vSdFRQUVRj+W8wW54usFf94euGtfF9twTkj+Wtid9obLJEyI0ts5COdbE1PMfnpP354kRxrq8j+xaLauXV0AXLhokGEMQEMgYfl8HWCgPoYb35bCXWZKuOJ8EBVChHco0qeVgbQCWbfm+1MJPdFDV+rHepuZTqSJ2S94NLxWS8UZSFVT7wP1wUyItfLguQEinsv17gA63yKQdu/GSQY2DNGnkm51tVisYc6+UgclIWtTNOgvP+USvoxnnndpvZdWfhTzzKX+m6Q7x6Lxs1KdxzBKDLTJPdJSQkZ+gBLREfNUmcy+f4Lgt2AouPB/s3KZDt4P1aBQTgG65csQM8
 LKCpS2mY
 OJFNqLfKf7ysXXpzPUb5g6+3XkjeAtueYDNmKdXX8ypOhPtxLYlH0tg79PZoMH5tLe4QhKsY3yEMeJg7IRbzMuTdwQxdlA9tsG6axsqV51agpoTLWhqCvGU8ZvnXef7fSLv3r9srq0bezQx2pvwu2IlGz0XsfrYLTOXPLzdimu9Y5/WPb9IW0iLQeabQqEMEiGC11jZLxep9OkIc6KBXjehch/F7Lj4cCbaNxus6oksG9Gn+oFmDfdmHob38Ulq8G6socQl4rjogRtY4IZFgCvmNM0Q1eQ3+KMWqIavV3yvrum5ijZu2IElI7IIHuHEp75F/fTgCYzxwtyMsDXk8wISx47jPg1KEsaak2AIjENrQhc1uBYaFYhKD1Y7yfWaqQsO4cAHGSl63nJLrkKrjymSkPYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently vma->vm_page_prot is safely read from and written to, without any
locks with READ_ONCE() and WRITE_ONCE(). But with introduction of D128 page
tables on arm64 platform, vm_page_prot grows to 128 bits which can't safely
be handled with READ_ONCE() and WRITE_ONCE().

Add read and write accessors for vm_page_prot like pgprot_read/write_once()
which any platform can override when required, although still defaulting as
READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 include/linux/pgtable.h | 14 ++++++++++++++
 mm/huge_memory.c        |  4 ++--
 mm/memory.c             |  2 +-
 mm/migrate.c            |  2 +-
 mm/mmap.c               |  2 +-
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index da17139a1279..8858b8b03a02 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -495,6 +495,20 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 }
 #endif
 
+#ifndef pgprot_read_once
+static inline pgprot_t pgprot_read_once(pgprot_t *prot)
+{
+	return READ_ONCE(*prot);
+}
+#endif
+
+#ifndef pgprot_write_once
+static inline void pgprot_write_once(pgprot_t *prot, pgprot_t val)
+{
+	WRITE_ONCE(*prot, val);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d4ca8cfd7f9d..0d9d6569367e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3233,7 +3233,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	} else {
 		pte_t entry;
 
-		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		entry = mk_pte(page, pgprot_read_once(&vma->vm_page_prot));
 		if (write)
 			entry = pte_mkwrite(entry, vma);
 		if (!young)
@@ -4918,7 +4918,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 
 	entry = softleaf_from_pmd(*pvmw->pmd);
 	folio_get(folio);
-	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+	pmde = folio_mk_pmd(folio, pgprot_read_once(&vma->vm_page_prot));
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
diff --git a/mm/memory.c b/mm/memory.c
index cfc3077fc52f..2d99c9212883 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -895,7 +895,7 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
+	pte = pte_mkold(mk_pte(page, pgprot_read_once(&vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 1bf2cf8c44dd..9db1e6ed9042 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -377,7 +377,7 @@ static bool remove_migration_pte(struct folio *folio,
 			continue;
 
 		folio_get(folio);
-		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
+		pte = mk_pte(new, pgprot_read_once(&vma->vm_page_prot));
 
 		entry = softleaf_from_pte(old_pte);
 		if (!softleaf_is_migration_young(entry))
diff --git a/mm/mmap.c b/mm/mmap.c
index 843160946aa5..af6870115a9d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -89,7 +89,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
 		vm_page_prot = vm_pgprot_modify(vm_page_prot, vm_flags);
 	}
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
-	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
+	pgprot_write_once(&vma->vm_page_prot, vm_page_prot);
 }
 
 /*
-- 
2.43.0


