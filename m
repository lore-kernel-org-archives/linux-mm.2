Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85EADC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE78F6B0125; Wed, 29 Jul 2026 10:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99596B0131; Wed, 29 Jul 2026 10:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF0F6B0132; Wed, 29 Jul 2026 10:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB4D56B0125
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6ACA61C0F77
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:16 +0000 (UTC)
X-FDA: 85041734232.08.51835FD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5F74100010
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G2izd5OG;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FR7iSCvnkzVCTj63vl/6ShqY/5yTsmSU375XxxhVyn4=;
	b=BLhObiYvVbQmi/f5lt8QovrfVEb4tBEjMOA8IVxjy6+1e6iOLOmfuAD+6c6Ufx/odluEf0
	hhBwWRrgbl9o3rXxV8Kqv37MV1tCq9m3LJElFzKpX395hnRQgU08cAfhLsaLHSZFR56eNw
	Fs7/2MgU47FYjDY5LUyR1rzWJjI2qfI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327914;
	b=XkT+awaA2ytpz/vaOMxNqahH/CzAUz4GORxO7IVViqpaVADp+4B/ykVU9MZ/kse2Zag7Kh
	Jiy3qUgXC2Bi8HbUflROjEG71wQUzbCIgxtqX8Eqa6MrmAd9HH8lWxprMhKyFT5CFLmv9U
	dTdPYy6GfFEWIavhJFj10iYEZTaYZHc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G2izd5OG;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91B25168F;
	Wed, 29 Jul 2026 05:25:07 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CEB173F66F;
	Wed, 29 Jul 2026 05:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327911; bh=2ivscI4jufFIfQzWpvv8SWV0GOCXrTpCwRUQnSpO4Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2izd5OGCyPuuBjnWPWL5Qb7rru99JByJ9ZBW6qH+9xLHu0NSpILZMNz/v1++WKRs
	 F6pFvnVvHSyd17Cv32sWT3t+34iiSUYikecw5a8Z3bqhWa0pJQ3ZWl0WmcgCY4AGfT
	 23NB7LTCPsQDRgPxcEz6RILwcppO6xjmCLy0ZfkM=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 01/17] mm: Add read-write accessors for vm_page_prot
Date: Wed, 29 Jul 2026 17:54:36 +0530
Message-ID: <20260729122452.3797443-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5F74100010
X-Stat-Signature: uwc4pmqf5y9h4rkdtqcbayr3bbwijsgb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785327914-33580
X-HE-Meta: U2FsdGVkX1/sVMlNZOMixZQo72n1Fi5jt2y54F1Cf2dEHeshjuSXRC2ms6Ag3nAdq6j/xTtCXlG9gULMQyKYCDfRgwe4c0Nc+AW9mM9hSJh27ePv4dsnMJVb2m2+g9VQ7l+Jor3w/VZFSEgOSv71BuLvitoczxBIVmoNoR8ByG1wlxHGGs6UJpeqxzO4wHK2mNfn+L27BnhBprEdBIPCCU0hwB7X4QxKjm8MD9UAtjl++TsFGCxmTxJzDixj+fw+p3zLdw7PWezoJkk94G7mgbAfehO4GaQhRfXU0wAEqegGxfXrqw8pjOaWOpa0VZRUsxPuhryc9ZItsD4nMq8yCa55r8tnD68y2p7mMmV7wf/aZBhCvSSPY9pbXY+QySpUa+P3cWs/9crHuEPiYKd++ecNL7kgIkEfY5ij/q7+EuZiD/UZGp1I/AwBAt0dayrni0GPo8fFtlX3RpwZxeAILT9z8eFasdj238SwRbJtQXnpW4+4QYFKOkROnIzoFoQx9PiG58g1f77l/DLMIHyuRYedzH5hVS+GQa+3/rMcB/CSHxquapEiMAKREcTe3J22xV3H+JkaeNq9XV5K92dl+kWj03DqIC1K7dK6gzme8cF6GCjRJ23c35GmFVMbGLJoNeHn9e7xmCN9etxuXe9u/cz9zQUDJzJO8V/E8PkUyoGhUF6t/B1Oo4h02A5tI24oqPEz+NDOMk0DXiWt1foZvaqzC28lrdfbcuV7v8z3m44xUosEQb2ghxLOk6h9eAp5LKIxmdQZ2ouOSPVnmQwd3O0GkCYMYVAvn/GwjaDdKoCMEFAiPkTXbkrWTylZHDMIqxOHVo+TGLV88mDhFF8bh4idrZvXb0Ylmh9CYPymFkudofYP4QLCF3N45vLLvqR6N4dK3+mm8M6qeVme+CaUrqt32rPqwLlyZga7gMWiWDLPecHfYas/PqFAd66qikoTUimsLWObKRTKgAGbutF
 Q/gtxHJ8
 Gb4MQUDDIYc0nMn4E+TgKxxSvPVQzrl4lMqBVmfDe99M27DAxisDPYPv+ZtApBRu9WQlG9asVbQlbRWUWiS7tOXfimcvrL7DOYu698/88esCq9CJsyCh41CktvrpCSO+cQuHjCxDDkaiRRqNSUk6cThnUQY41Dd9/gB7dBR/kHJud3BnnAVZVNXNJconVHT993FNR0Eqb+8+jDt5XMiKz3rZ4tEGpmvNI0EpBWQPLKdqn78zJPIS8UBEgku972XZGMeNwLoFcWC4YIZgtvfNKqayWUhOpy2J3RAl4zEWBuumTqBG1uCaJ6k2WqaCnNmsWcfIkeBnDGiwRdpw5b0zRvD+CI+Tm+4no3MVkiTXhsLHoAiJPgX207bQVaD6BBL19nLdmLn1Zsv6YSS3svNTXamo78D4L2crkKDYrjJnqMrnsBjb5OERaC8tZkI31cdaYlalTiRPjBtdgZgM=
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
index 2981e386da7b..3ecbeec6b463 100644
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
index b5d1e9d4463d..2915e7c628ef 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3281,7 +3281,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	} else {
 		pte_t entry;
 
-		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		entry = mk_pte(page, pgprot_read(&vma->vm_page_prot));
 		if (write)
 			entry = pte_mkwrite(entry, vma);
 		if (!young)
@@ -4957,7 +4957,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 
 	entry = softleaf_from_pmd(*pvmw->pmd);
 	folio_get(folio);
-	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+	pmde = folio_mk_pmd(folio, pgprot_read(&vma->vm_page_prot));
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
diff --git a/mm/memory.c b/mm/memory.c
index c8fe2f373fd2..598d0e588e9a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -945,7 +945,7 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
+	pte = pte_mkold(mk_pte(page, pgprot_read(&vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..4f3492cf3fba 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -377,7 +377,7 @@ static bool remove_migration_pte(struct folio *folio,
 			continue;
 
 		folio_get(folio);
-		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
+		pte = mk_pte(new, pgprot_read(&vma->vm_page_prot));
 
 		entry = softleaf_from_pte(old_pte);
 		if (!softleaf_is_migration_young(entry))
diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff4..750ba48cdf14 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -89,7 +89,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
 		vm_page_prot = vm_pgprot_modify(vm_page_prot, vm_flags);
 	}
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
-	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
+	pgprot_write(&vma->vm_page_prot, vm_page_prot);
 }
 
 /*
-- 
2.43.0


