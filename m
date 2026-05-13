Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA25ECD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500486B008C; Wed, 13 May 2026 00:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D82F6B0092; Wed, 13 May 2026 00:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414C56B0093; Wed, 13 May 2026 00:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3536A6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:46:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCD4514070F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:27 +0000 (UTC)
X-FDA: 84761160414.24.E66F836
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB263160007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:46:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=beTSK5cX;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhzyf6SzK5v8ouPO1vD0uJkzAnaEz87YunFCeP9jsjA=;
	b=HVK6/jd0F17pnAEeCqK5GUmSRpFjCgsujObQFqb7rGXqSJBo+5ywYzRf0AIbmDiMvb6cIj
	OOgoVCtV56PnFlvptER8Ym7WZ30SCSKPRZFiF0e++cd0iA+LO2dyPWqzOKA3S0905gudgB
	GE8TGboOg3yVye3cKxcBfOO1Ywtz0TM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=beTSK5cX;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647586; a=rsa-sha256;
	cv=none;
	b=EGUHsBDvLXrf1I2rXScBmRlXQ4djVB8pWhRH+VMRTw4sthcHCjvjvQrLlRuF3RbiIlp/cb
	eDGdEdYdT3OPyz6s6qu8/aah58nXCYgwS3T94CWphOEFYJ2I2DECxP5B1AWHOfsO+tUb6r
	mEwDh7X2N/dLWDugbY18FhKISluVVyw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B21DB153B;
	Tue, 12 May 2026 21:46:19 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0D8A23F7B4;
	Tue, 12 May 2026 21:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647585; bh=XAUdZDyrObHdgTp0toPaK0vnw+3+Mz33Tzx7yEj2vSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beTSK5cXEgLmZU6vSh1uneGf+iRimyg6UVTp7Qn51LkNh2vVB6/sR9KhN7ecJgyHQ
	 +R8FVW0RdFcu6sf/7IsSfdXgb5NVpLrNmndBLpzD7ARJdMHsGAsH+VP5eVdH0XtHdW
	 vXM4OmvLt79zBmAf/ik2NiLIVBl6QsYba7WrpdU8=
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
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V2 02/14] mm: Add read-write accessors for vm_page_prot
Date: Wed, 13 May 2026 10:15:35 +0530
Message-ID: <20260513044547.4128549-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB263160007
X-Rspam-User: 
X-Stat-Signature: yhg5utt1y6kpop1dn7eb8iwft56o1uzn
X-HE-Tag: 1778647585-944563
X-HE-Meta: U2FsdGVkX1+hJtRGhFtq9MbKDT6G7yM2h+Tjuvm0bY/aYLGxwpwedj9DDvMnbKrnnj+x4e1mviqOE3JKD0SnJBMq6Q7E63KXaxqQaw6WJg8mfXBxhT9MdA5x17+Zh3XlEhFCuuzv1VEgBuL39JychjAyE+uGNU4yrruWz6Qfdo1ya/nnsnIWEC2Db7RYPubhLYBiyztgH9mpvddK6fvCBqGjM/CckwFTdAsMLDbQBV0pQcRbEjeViqXO0MV7Idqoz7qAbRg/SpqLoe0sXz2x2d149Fc+6UheZzrh0OQvIvvUSRVEbEHLvZYvYUo2eT1MPku9tc6wurMbeYCQ3slxx8Q47DswDjpzmJNYebKPm1MxsUbJcbQOaYbYD9R9CfWUUKLPvixtWIF7SmxDXAhgp3Cv2Te+SOMj9U5hiIFNufNLnB4LJ3w2b60+RkBzBJoMPgfcP8fXgvXDRruJAu8t9qTOt19BonFWQA3QO4uMDyd2ZEFLQg2WXjFpFFkAi3/rPe48P6vUFUP56sDG7ZgSA1Fwg7y98xuNKKr34w9K3c6+sjuvQMxpkbNaf+Ug79j0CxvT/ofb91JzbDyAYCI0OCy7XCA/n9XebNAvMDk+na9xdCj68MNyqoOZxEK3Hsrx4IxJLui5a9ZF0ZDRRw5eX0vwoVk/ONiVkbcckthSsKqlGE5POtZoqxZRtctSvwkmAxf0xDBZnfcInu6OOkAIUKmLi538wCcrhUJv0lCRhffPKlhbUBIPcHc3y/UT9IQLARqaxSOgXpXiYlN8pEKUkOOAfuuniQvezLQgDIxm7hfwteoJlHntXJ6rsiWcZbH9wqml4v+Q02k3d1ju4t/lGk1MgVayC7RT4tnIynZ2DK643dPlm4pXncwctAZ6uN+cwpBVlZBFwXX+xXgonoar7yDxuP1qjEE7Zefr1hG9OWlP7rrkALJeiLUBEoT7n42SwmxgVZJUidmr/eGa2PH
 CSbmpz7+
 IUXTqaHzMAUxCtx0aQGxhmjSQd3NFL2DnSbsv98jTTITqIJSY0z1ANCt8/wNQMGPLqozLLKWthJEPEwg1uYeahfueZLZW1t470em/4blyDWDZ7+BRMvDXRNysQg6ME0TA8VO3/rkd9paseTtrSRv12DpALYF8NEzcqaLVdnM4V4Xi3Q374D3LcBjJM60VBXZjL8KSP/7A4Z9ffdRCn2vp052qpffkJuOU2xNTdsgqokcFyyJ0yFzoS9wRJaaxl+B8kcq18YdB++xFqcNPCccU9aI/Lh++l8OnQwncm4ofx6eZS3GpldYeZr1n2IO2JDxMjopYB+ZtONo/UYQwiR6WAtMIqBics7IUJ90C+CNXiP5imgzdQplUlKwp2Jrg5ECYcVHIuppvP4ndgQO7eAkTq8ix/uCsEF0q78Kccg543yQNwgRYhqVrtH/9ZpJ75LuVKplZ7GkoNdW3T1dctKbENTtBDreJCWIhrWaB9LuY85ozLAg=
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
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in RFC V2:

- Dropped _once from pgprot_[read|write]() callbacks per Mike

 include/linux/pgtable.h | 14 ++++++++++++++
 mm/huge_memory.c        |  4 ++--
 mm/memory.c             |  2 +-
 mm/migrate.c            |  2 +-
 mm/mmap.c               |  2 +-
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index a738048128e7..ca0fc76bedcb 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -501,6 +501,20 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
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
index 970e077019b7..a24abf7cfd63 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3339,7 +3339,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	} else {
 		pte_t entry;
 
-		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		entry = mk_pte(page, pgprot_read(&vma->vm_page_prot));
 		if (write)
 			entry = pte_mkwrite(entry, vma);
 		if (!young)
@@ -5042,7 +5042,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 
 	entry = softleaf_from_pmd(*pvmw->pmd);
 	folio_get(folio);
-	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+	pmde = folio_mk_pmd(folio, pgprot_read(&vma->vm_page_prot));
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
diff --git a/mm/memory.c b/mm/memory.c
index 7b6ee3b847a0..86b2c9513885 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -876,7 +876,7 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
+	pte = pte_mkold(mk_pte(page, pgprot_read(&vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..ff2cbe66daf5 100644
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
index 5754d1c36462..4f11eb732c81 100644
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


