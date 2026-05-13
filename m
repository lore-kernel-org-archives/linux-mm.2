Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA55CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31B16B00A2; Wed, 13 May 2026 00:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BAE46B00A4; Wed, 13 May 2026 00:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8476B00A5; Wed, 13 May 2026 00:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82BC36B00A2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:47:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E3A21C05D9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:17 +0000 (UTC)
X-FDA: 84761162514.28.3A4C13F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id A1D62100003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FSJUQ9Mm;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkVHE+92d7jQfh/WlF0tcCdoXxZGt3mB6DSDfTvNfLs=;
	b=wFqTgKVrwzCNhP1tcfiMCNVPe91f6GDUQ5mHDHdL2n3Jc65L33RI4X7C9mrIdJ4fky7Qnd
	ikN5r1QXw4l834LJ0kSwFFZv2m3r8orz7QiwVAoch3sYj7F0D4QQMa43Hg5b/pEHwN71Zm
	okHHwZJOAMPELwY6CAx4UPNlbBf4jkM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FSJUQ9Mm;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647635; a=rsa-sha256;
	cv=none;
	b=MDRujCooo9rZVprzWmEvSSFmMgupxpS+E57C1qANtKeIWDR7/UffCtImj9PRF/n4fL3yXm
	i9Ll53dzBCbRud+r+GwUXCC2KOzO3GhP1DAQFv4UYtUn5IeCERSIc6FUfdZbNHrTKf1iOg
	5G19E78v8+oKpQx4ZCHNoKrx5j1bbIU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D6871595;
	Tue, 12 May 2026 21:47:09 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7BFA53F7B4;
	Tue, 12 May 2026 21:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647634; bh=lvT4OCr8HFR/loLDsco3PxFqEGIrLg1z5XdjhHsuXec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSJUQ9Mm6igkWJsNd+siFvVXDMs55q2Wv9KJbU+0QvYb3ljdsQQVz0dhv+QqQQiW4
	 MuIoS4g9UpaXSH0Xvp8aWRXsDWUG5p7x2zkn1dtyQJHlsigQKmbn3npn/j9a83/H0n
	 A1SC1GAjz1nWTaCUvKP8o58UsthWd/YpBXFWt+R8=
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
Subject: [RFC V2 09/14] arm64/mm: Route all pgtable atomics to central helpers
Date: Wed, 13 May 2026 10:15:42 +0530
Message-ID: <20260513044547.4128549-10-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sf91ec1kf65a17ijz48hexfk57y5j7dr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1D62100003
X-Rspam-User: 
X-HE-Tag: 1778647635-700878
X-HE-Meta: U2FsdGVkX18yfwnIXQ+gxUxeLWlFfPhFsM/tbY7dUhlHuv+v/ws5tymhaftcEpMWAGe98ArsU/yWMgVO4jiW9V5+z+8Neh052CxY5H7q01WzpZ3ZlmQJH+PuBpznNYRM/OZ3gYp5euUk2uIPLmovmKOfFeDvZB6s5G1bsokKm1mBXyHxYde076IrOZNlRfpuqhXsTEScaYSITmDA/kyCgLPBeuu9r7e5V4/3yHm4BZ3Rg7K6SQIuD/jYDGSPMYC4bKPOyPvjY0SwZiB/wEmMBj4QtSBfge2IiSQfDZ/AM6ZDA0iOe7yO9XG6vCAvW/fC6yAHgT96KBQyOCzyYlMMXnRd3LQpN4O+kDnagtSUURHP9eFBf3juyn0fUFUpoPUf1mGXhAZNPbMbNopkGhRWE34HRLT5hUSf6LX2EbTAqim83t15O0enq5MdrVOKlEqUK1VovQ2lCItWdG7LjztTUlDLWav0eYCQomP38ZQf6GkDMINDBPZ7zkzCTKkXji27IMliQ71lZyXuz7hZvh/FdJrIoigSDv+HLkrq6LK9edXxQg64VlYdox8JHfLxXmrorBh2vaEoTK1/koxbtZW/rpUoVv595l5TRGhV70gWx5tlmikHHPZH8E0qMSoxCSzOqJNGiizGWKaDVv7O249rqISVtKIvox2WZUy3/C5sJdX5wTIVY57X8nS7RPFPW90tMkCCW9936ujgzuDpN5hSZarBvu5R8iJ9K3Jz+wYg5KS6Jc1bIs/uaxmKhQSNUWXb1A/8lHkAarIumx1Uaz9VdUlWgFbvj6DnR8unCRsNa9y58xaYcXiRi+ZBH7kCh0nZvKoWJgjP7Stfc/gqv13nvArL/iaG0kPIdiwKZv9iRM7OhxHfG3ZHRL6wYI4JXGmrgsGu1aYHci8oaPQLBTehVXIXJW3l1xzl97/iG5HK+qSVwXdtN2jsGXF8dD+xHH15KJcEB2BB0RoPwK0yo4/
 blp1eZyk
 9+nMiTdcI/rzYnRmv41mVL9FV2Qfy7Xf8+U3/G1MEVNrPOX4T9ZwX2MpjCNZXKN3zLglLeD2cBak9uQhp+bKJlx99bY+hPJAG1ckY7/5HJwddo2+q2EG21DtsmIQK+eCdwi/WfO1vrUvIRY89KmHitvg2JzbnA2ZMtmq1LwbfFTe+1ISaiMQte/WYJ0Gyb+Ozu+ZDkm+qSvBl2j12do4JY/aKj+O3N1BFmwKxkiVDuoYEv6aYDe2pOjvcVZ1vDbxjQq0Jx0+rNvYmCmweI7SfdG578KjDhWdzzxxVQqP0I/qwYKtyIes2I6KITYEqgLGHnd1WeDMZOZnd4Ew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Route all cmpxchg() operations performed on various page table entries to a
new pxxval_cmpxchg_relaxed() helper. Similarly route all xchg() operations
performed on page table entries to a new pxxval_xchg_relaxed() helper.

Currently these helpers just forward to the same APIs that were previously
called direct, but in future we will change the routing for D128 which is
too long to use the standard APIs.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in RFC V2:

- Renamed all ptdesc_ instances as pxxval_ instead

 arch/arm64/include/asm/pgtable.h | 23 +++++++++++++++++------
 arch/arm64/mm/fault.c            |  2 +-
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index c71bb829e9f1..f876200d383e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -87,6 +87,17 @@ static inline void arch_leave_lazy_mmu_mode(void)
 #define pxxval_get(x)		READ_ONCE(x)
 #define pxxval_set(x, val)	WRITE_ONCE(x, val)
 
+static inline ptdesc_t pxxval_cmpxchg_relaxed(ptdesc_t *ptep, ptdesc_t old,
+					      ptdesc_t new)
+{
+	return cmpxchg_relaxed(ptep, old, new);
+}
+
+static inline ptdesc_t pxxval_xchg_relaxed(ptdesc_t *ptep, ptdesc_t new)
+{
+	return xchg_relaxed(ptep, new);
+}
+
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
 {
@@ -1340,8 +1351,8 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 	do {
 		old_pte = pte;
 		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
+		pte_val(pte) = pxxval_cmpxchg_relaxed(&pte_val(*ptep),
+						      pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 
 	return pte_young(pte);
@@ -1383,7 +1394,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
-	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte = __pte(pxxval_xchg_relaxed(&pte_val(*ptep), 0));
 
 	switch (pgsize) {
 	case PAGE_SIZE:
@@ -1459,7 +1470,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = pxxval_cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1497,7 +1508,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 		if (flags & CYDP_CLEAR_DIRTY)
 			pte = pte_mkclean(pte);
 
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = pxxval_cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1536,7 +1547,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
-	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
+	return __pmd(pxxval_xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 5c61f39f7f29..bce191d16090 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -232,7 +232,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 		pteval ^= PTE_RDONLY;
 		pteval |= pte_val(entry);
 		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
+		pteval = pxxval_cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
 	/*
-- 
2.43.0


