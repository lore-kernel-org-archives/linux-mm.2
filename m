Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32AB3CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF1B6B0088; Thu, 25 Jun 2026 00:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6A66B008A; Thu, 25 Jun 2026 00:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA156B0092; Thu, 25 Jun 2026 00:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 965A26B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:29:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E40EEC25AB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:29:39 +0000 (UTC)
X-FDA: 84917156478.07.058B314
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0D13520004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:29:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A65Fo0vA;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782361778;
	b=qo2VuUz0hmgaCWluWctyxgXEkzK/iivqhXoSikLb9WtaWbNJ5zwJd16kgnos5zksrJ5yi4
	TsceXu+lO5ah0udoTJEOFTsnYcTIjQ9UVBB6yP9uuGJ++QzjLUTPHqL/1t29D/gv02Yz3G
	1w06b155eOCCUTjOCvCF0nnxf4NRCpU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782361778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a5HzVOzpdvU4WUMmHQ3ODFCp+wamFZ06SPWfkypn5sM=;
	b=0tRp7neUoAGZ/1kcLGP1SpVRzLUcutUReFdQMtdKZMAoOpvCqS9jfuSbRPaFKsY4cTEWoX
	Su3I/KUFt4rFRZ4ri9FThn/HH+LRoyOHp653OL8IHGQaiKxS9X8Cgsd80oBm/6F6CWYnCY
	oNuyPIVWBihuIgY3XhTYpWrN67fKpck=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=A65Fo0vA;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71BCB2BCE;
	Wed, 24 Jun 2026 21:29:32 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E23993F836;
	Wed, 24 Jun 2026 21:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782361776; bh=7mIUdhpxjfBGpDoIwyQsU3lKaGAeN4hJVoywz3Jt11U=;
	h=From:To:Cc:Subject:Date:From;
	b=A65Fo0vA4tHeeQXXWFvROS/Qx4WjhFQyKCTP3R+9g1J/pHMVXTLveKpCjWEo0lrP0
	 LjuuNTfiardA87j/CArqMgKjjdiTuvEsqv9a36VCfwTQm1BjHEBg9Wk4yrRwthoiNE
	 fZ05es2tqrTsRMM8eQqARMz0RPfjPEivtCMlIYJE=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
Date: Thu, 25 Jun 2026 04:28:51 +0000
Message-ID: <20260625042853.2752898-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D13520004
X-Stat-Signature: yt9fk7hjtktgmtqxcq4xaex76w86kwn3
X-HE-Tag: 1782361777-990139
X-HE-Meta: U2FsdGVkX19of9wg0uVUd6Q4QzFgd5+Z47AHSpbWsWKlf7j+0OrLDqYBLeQqgLwYvrb7POyytp9SqWdjgbZ8WqHuL8a3wnmm4ZMFChpvQj/zn+QPdETgtYF70rgMBxUqWDTwldu2vE94DwQBAgdAq/nUWBRmS83Lm/nGlOOMas4h3PzBOP7TC+sjtEV5bOEy91yEDvBAp+oH88ZfqEopbGzzJDhvD5MrTtRHWyFClymJWSeLHABM/k3IQUkzI0Ruvk84jbvYR61k4prdcgQ2hCLSRq47LW2OIn4Yxq3oEF5421uH25NL3rqmU1WJESwJ6pZ+Vuv0unmF+z8jOCbjBMAtFoVFZSK1mZH8SwU06rL01E3we/oWZkmbQwWyoWisnW7I1m/Bazv29Q1nDMlbDrm/MZyUzE5TmGJE1Pcqkpcctx3aIy0c6dSH565XRjJkxOUurX0OQFgDyEZ+oE5IAR7V/sJtxY7nZ2ZouIqoxJSLYEu8Kvwbom4pAmi7VBapeZOEQN0hUnPsOhwLnGY53iVcN13vwZIIJtde18SdkCUWE6ffQu8MSQQvDWXfVxlzvqX4ndgeGm67tVNkSGTgHe4g+MrD2IfcpXFmPnQRd9wu6tUSgoEf4SI1ea2xPawN9AcldMRIPI6G/yquQW6CbmRUJj1ZENS4fNF2jpFEJJwPb15UyOWHxphX0rKRgPcgtFJaRGXAQ7RL6JSBteu/lbTyaktLjrkBc2qcfpdNN7EYZsDjAdCzbj17UCS5Y9ojuyi+ChZ5EozytXP/uT100XM1IbKLGvAVGw+M1Ag6t+GHRj7DvuPQxsFSBG/jAmJER7+SYLPwNn6BD5N2P9hAB/jJS8qtNnmK7iaRXYfC6IDRfc+fBuCBIncReN+Vn2ikdam8TKt241GN0+l6UyRVRExYqwo3fAPh5H33xur33uNJx430Ofn+gr0gURrIHEkFb1KcsBpUlLfI+O5NClc
 nROvf2co
 yJgy/OCOKbPouaKBJslH9bYV7ax7kFqfQburSj77fSdHSr/uZn/UgUXoYJCRauDED5d/SN0Pmj3yVta4i09XOKtgMzVgpvcqVy/F+U9pM8VMnZNS5JTyqHhPUSV4bVMl+8DeN4Wu9jhWJuVB5SlVxmjAhCE+Gr4H3rWzHNj4jLiJojBJJpjDmQ0hmNA2ivzNn79A2Fxz80/ls166lZWBddPwyxyHLgq+tw6RIn4TPXI/tIrkY3nVN4Zgyz37kKgcIHQQ4FEBailI0a3F1+ymmcAkTNgqwpjj8fkyA0rosIFULqDoJbU/ucWRkm8AtdUJLFuA1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_unmap_one() handles hugetlb folios when memory failure needs
to replace a poisoned hugetlb mapping with a hwpoison entry. In that
case page_vma_mapped_walk() returns the hugetlb entry in pvmw.pte, but
the code reads it with ptep_get() before decoding the PFN.

That is wrong on architectures where hugetlb entries are not encoded as
regular PTEs. On s390, for example, a raw huge RSTE must be converted
by huge_ptep_get() before helpers such as pte_pfn() can inspect it. A
raw decode can select the wrong subpage, so try_to_unmap_one() can
install a hwpoison entry for the wrong PFN.

The userspace-visible result is that a later access to the poisoned
hugetlb subpage can miss the expected SIGBUS. With DEBUG_VM, the wrong
subpage can also trip the PageHWPoison check.

Use huge_ptep_get() for hugetlb mappings before decoding the PFN.

Before c7ab0d2fdc84, the bug existed in the form of a plain dereference:
we would check the head page pfn of the hugetlb with pte_pfn(*pte), and
bail out on mismatch. This would mean that the hwpoisoned entry will not
get installed.

I am not sure what is the procedure on such kinds of very old bugs - how
back should I really go?

Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
Cc: stable@vger.kernel.org
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Applies on mm-unstable (d17fe8a046a2).
There are similar old bugs present, in try_to_migrate_one(), check_pte(),
remove_migration_pte(), prot_none_hugetlb_entry().

 mm/rmap.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9f..aa8a254efaecc 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
-		/*
-		 * Handle PFN swap PTEs, such as device-exclusive ones, that
-		 * actually map pages.
-		 */
-		pteval = ptep_get(pvmw.pte);
+		address = pvmw.address;
+		if (folio_test_hugetlb(folio)) {
+			pteval = huge_ptep_get(mm, address, pvmw.pte);
+		} else {
+			/*
+			 * Handle PFN swap PTEs, such as device-exclusive ones,
+			 * that actually map pages.
+			 */
+			pteval = ptep_get(pvmw.pte);
+		}
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
@@ -2110,7 +2115,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
-		address = pvmw.address;
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-- 
2.43.0


