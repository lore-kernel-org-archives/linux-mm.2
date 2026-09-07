Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EDA7C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000036B009D; Sun,  6 Sep 2026 23:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F196E6B009E; Sun,  6 Sep 2026 23:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56686B009F; Sun,  6 Sep 2026 23:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC1C66B009D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:50:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49B0A40624
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:41 +0000 (UTC)
X-FDA: 85185589482.07.66DFBC7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 47A9BC0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LW2jt5b0;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yP+XQhskvdcS42TZvvDKrCf5KDgIRQXEgf2mQg8FHI=;
	b=SZPA68UW8KVCHjTicwsh2GAKPQQn1eiCZHfSaTo+wv8awASHZpV6oNRRypDioeXDuDtBET
	JR1b+BbL8n6kdVfySlOmk3GNbjF/7yE4zXBC9SEJNHaoP8Kxhi3dKm6dAcI5gI7wg7APBc
	9yF2zPFwq7OEd3NOiP3d+ode2chMFVE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LW2jt5b0;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753039;
	b=ZYmdwG41XN3s/6RL7istYuIdArQh48/Qn0w63R7OHnrvk8OFu5dPjudCpx1mafaH50ekYr
	bNxrXvl/fgFT/3f6cHr428TWxu3tZZ55ATlrUH98M0Os63rDcWZWcQhiufIq+IHINzn2g7
	eKmmpWHXMZ+KbAys9kHtdzGAJ8CeBII=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 945811516;
	Sun,  6 Sep 2026 20:50:34 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 89B773F7B4;
	Sun,  6 Sep 2026 20:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753038; bh=3yn6gSsOXRoyaBz1CARO0jyrfcLMBCzmt7csYw/Fkvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW2jt5b0BLThiRONOynNfF1FBuy3s6vy0IP2y1G8Ho9rA3Rexh4127PHoDgS9FR98
	 ZDfgStQaqGpdqFi3z28eNV4z53rIyzJ5VwrpgP/WMoKM3iCdUA0Gjq3CKdnnc0WvyA
	 DOD/Cgke+1nc0Oi/K3jQrqX5CVCODcbUyP+HNuEs=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH V2 01/14] mm: Add read-write accessors for vm_page_prot
Date: Mon,  7 Sep 2026 09:20:16 +0530
Message-ID: <20260907035030.2839978-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ixgh53fkmafuzog3uao8gbktc8pgk54b
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47A9BC0003
X-Rspam-User: 
X-HE-Tag: 1788753039-66316
X-HE-Meta: U2FsdGVkX1+SSVLmt7fjjd6zlqayWyCQZoZnZ7lvQhoVfgAYBHY/gxUcPvo1Txdh73wDFM0sDBt2q2c1rb3jksQSlF0Z31IoCsHCOQPA3bbn20bmDFVAQ4+5F9rpbzGzwgd66LWYs+2thC3c8zUWp8ccqdcyGAXhSzF5RD6D2mSovatwhkOXh1rHFO9heFZBnA4sAIrnIdVo0a/1lnkwwi25/hskSRstktBtfUhV92ytzW4CqzoqxzF/6r/YeMBW8p+KvvVMtewGEToHIUDpbcvzzT/fsFuCqXAxVbCXaSZUw6HaeffeqYMDL1YHKmDXaE2XuuUgoUg4sd3LLTDcX871P5TQxWqWUaYb78nh37su6OwJopIMjOBTKPSucuHgLMp7QqT46LYNmjDD1YkpOo23dubKCL5wYx0WxtgkrHpPxkq+wqok4S4mnT42wnwjdUMtVcjI93TO+yVoZ0RWpY0BtVd/CfvAm2AcnmzU0G6B6UXovW+4v0aoy3h1bNEKW+E8NKK/Kp5+M8HlCJMNMbxmsY+Nxc5sUskZp9grLilrr7hh7KA7J4HGYCTDt7duXhmGlAt2Q0B6eAHdgVWL0yqW0Bjv5bWtqFkKY5cWBOpGlCLbvKreF8ghonMd5RHpbTj97zZ19fYwq/LmPmbMa0sYC1npiVbEfnTTzqE1gHGLHbfhp3+svNtdQCueBgfBFnM7GtB4IPII2+UHksLUjVhzQ+gAo7k9d9rC3hgAJKUEWnpfh3WsZKwK7tVQlNO4fFG7r8lcAS+EzdNFfsT7frodA6jV0BxdDtZcue081okWuwb656h+RL2KGrWKSJbL+qP6p7DLZfiBYBaMcU1F5MIp2Mfu7lo2k/C/yDAGoFCBI/l2m2/1k2c6ABmBW09R/WC29UWXVK1ykAJdrTIwMHed8TUXKl16NMwtGtkyieo1gZd6eqpk8ilMWhCCWdsotSCKBgGou7ioGZ5lTUM
 gJrmMmuB
 VvnXxsQiFAnbL+cDzycKVPWjyjJW0127hCU/yjYZrXA5gv69c0kWisZpa1TUiPAkOPclUFECkUFYdP07dZOseyagibx+83kaZeKKcMw7ifJzi2alRoRRKmZnDLd4G9o1hCRHIknYFdtXd1ElO+bQo3wwAn2fNt5jmLfR51fz9dj9zigxtWwkOVcM3+p34/q90wRFHVAN5Zd2gpEplzK8zy/mHekVv1dc7Bug3kihEdBQ4m4vYuFiMGZXHjE/vpNT6XOD1EzkJEvJ/JP2NQi6wqD8nA9wAInFGRgN4l4nbpjRTSN/V88lQaMWHIq3t9O5wCNXVwk+rxZazOTrzgiSsZss4V+j89q6qjGPzPD+Zled3ckDMvxeKx16e6eoHR02jG9xTuH2rxkCgNHZFzgzTlgTa8v0gH+NwKWwa7YHfFm/CFPJvGkZQoPiuR8LAyV5roFLcIZNo1SMghfgN+tnpw7TZjB3C99Bd4w/EeKcJ+ZB+Z7olnWysWc3nKMHVzYzuBdwN
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

Add read and write accessors for vm_page_prot like pgprot_[read|write]()
which any platform can override when required, although still defaulting as
READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 include/linux/pgtable.h | 14 ++++++++++++++
 mm/huge_memory.c        |  4 ++--
 mm/memory.c             |  2 +-
 mm/migrate.c            |  2 +-
 mm/mmap.c               |  2 +-
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c..0df57a5c19ef 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -524,6 +524,20 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 }
 #endif
 
+#ifndef pgprot_read
+static inline pgprot_t pgprot_read(pgprot_t *prot)
+{
+	return READ_ONCE(*prot);
+}
+#endif
+
+#ifndef pgprot_write
+static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
+{
+	WRITE_ONCE(*prot, val);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pte_t *ptep)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..33753bffead4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3391,7 +3391,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	} else {
 		pte_t entry;
 
-		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		entry = mk_pte(page, pgprot_read(&vma->vm_page_prot));
 		if (write)
 			entry = pte_mkwrite(entry, vma);
 		if (!young)
@@ -5103,7 +5103,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
 
 	entry = softleaf_from_pmd(*pvmw->pmd);
 	folio_get(folio);
-	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+	pmde = folio_mk_pmd(folio, pgprot_read(&vma->vm_page_prot));
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
diff --git a/mm/memory.c b/mm/memory.c
index aa6b2fc770fc..fcea6098efb2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -939,7 +939,7 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
+	pte = pte_mkold(mk_pte(page, pgprot_read(&vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..579152cce502 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -387,7 +387,7 @@ static bool remove_migration_pte(struct folio *folio,
 
 		folio_get(folio);
 		new = folio_page(folio, idx);
-		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
+		pte = mk_pte(new, pgprot_read(&vma->vm_page_prot));
 		if (!softleaf_is_migration_young(entry))
 			pte = pte_mkold(pte);
 		if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
diff --git a/mm/mmap.c b/mm/mmap.c
index 4bf26b0f1e6e..729bc244b317 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -89,7 +89,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
 		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
 	}
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
-	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
+	pgprot_write(&vma->vm_page_prot, vm_page_prot);
 }
 
 /*
-- 
2.43.0


