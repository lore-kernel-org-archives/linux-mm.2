Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0E3C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4356B00A2; Sun,  6 Sep 2026 23:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7F1E6B00A3; Sun,  6 Sep 2026 23:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93E36B00A4; Sun,  6 Sep 2026 23:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFC6F6B00A2
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:50:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 466AD120683
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:52 +0000 (UTC)
X-FDA: 85185589944.30.A657D06
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8CAAD40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:50:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rYQQ5NTw;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vnzyto12ET9Jnyu3Umgb51huyKdHOaZoey7A9TI62Y=;
	b=D2ecmSoqLusbSLJXrGmpzo3vZPic+pyf+dkf4plkxr1DeGIEt2Nt+JEacC2enZp3OJCeNi
	pQQeiDp2mzj45IVdMh3Wl4nFXMlkO8i3qbJRdSUqB0vq+Ybc27Q9f65Z7V+hYqABgIURcU
	0+418NZiOIFOIF0ZWOXUH2aYQ4SFUd4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753050;
	b=7IllfoiE9nPc8dDnol7TtEe2hE2eVNIZ3cP101vln/xpzkazFjceh1pvDv/YrhAHAboRyO
	NoJaY6QUrFdYSEyR7EdJ5uy8XyVl8AvRK8KKNTJ3DHR9tSGVvePJsWjqettm70jpv7pXqi
	99jd9n2LEMPf9nrhN6Jaid9Uj500Doc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rYQQ5NTw;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B5CB1516;
	Sun,  6 Sep 2026 20:50:46 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01ABA3F7B4;
	Sun,  6 Sep 2026 20:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753049; bh=datmweSr9Wz8l6EajpJTnuP4rYWsCtPHvC4W2LbaUaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYQQ5NTw++2T/tMCvMfnjCBpqab+/MaKV87YWGvK+K+0ywMBjSFsvu2yZ/L8K+tPL
	 1buRRth44mADdhDZXsthTzNm91mt0BP1+rChGY2IHHTaLtQo/F4AZzRMIFpaMhPeNj
	 GwSgJ9LCfd+pEY6KoBVJvR4Y2q1BdnGGtQiZTnOA=
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
	linux-mm@kvack.org
Subject: [PATCH V2 04/14] arm64/mm: Route all pgtable atomics to central helpers
Date: Mon,  7 Sep 2026 09:20:19 +0530
Message-ID: <20260907035030.2839978-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8CAAD40006
X-Stat-Signature: jet95yb5frzby66iac4amzdn6st8fnft
X-HE-Tag: 1788753050-748246
X-HE-Meta: U2FsdGVkX193Url7cTukyxjeEtPzyuX8WMPmxNn1uI3+YFoyqVWPGYfssLX9NdwsKhts/aGVc17vMY0rmFvik8oxViMKU/PASi1O/QIkdk78AmL+Lp5m0amGvELAOWOYldJFt7WP/FAsE+XHz2W5IEpWnGlA9kqeYFll3Quyb/e7Nv23n3MzJc57HUPoIPtQSxLrUf6xqRF4cH5ZQIQN3pVkLT+6f91rzT4L0yjq5BPQMgctl4GnfNGIqd6ZWPIm7LSmxrpgAcwWE3EZdYo2eWbl8oj6fk566Kx/Q6nY96WV1NEVTKAo3bSO35ROGhLkNa3EII8QJyVHh5H3bQC33oL+CxpACKjsUp52MUHYhnBEMr1TojDcaYk/X9g1L22c4arc90xH+r6xPS7O57HgfJ2mi1NJc7ZYSpHynXlJxqRjgi49B443J+FFX80sLH/+d21XKqd66wS3GDAYO7wPgMEp51elU7rKJvexdYlrpWqTxsSPPxfpNrvNr1/QmWQ8/SJ57aPTbJd6QSq8oKLyJZMwVLbTWVZ50QRziBVArsVS1+TCBGUiaEtOxIlEFUwImbwW+lN/GMIll3314qE2GZ2k0Qw/QOHxM8gXs7L8Bh4gYmbE+qyntRv6mhP7PdkQvswRvEguJG0XWwdM6MulDRUdVOP/gnS3f9SeiKwxLbLl2SzcEYiRFvGmQp9zhf7yhrCK1fKXRSwGu78+PbA78CwsEc1VA/3sdPmijlyeK/3YTra8DMkNrfJ0xAMT8VsEIJhlVDBgf1WETdUOC8sTpw1yeuROyNZB0a1wYVcNBoBXnnAVic4kh9TBd3XOP9xrw2l9QH6+o6uCJSFgQ3AKadn7Ymybz7lVktKt/A1N8fTwvqIVivHGlkZxJfyY0hF7Q9SDO1ZoSUkZ5VOr+u+Bb0Z64txL4GFhO4P/7vkr5c/bGn4TAq0UYQDdZRpImPC+VAj6Od+WNsql5sSp7Z3
 qAhiVCU+
 NTr/9bjTxTW0WlFWo9cvDYjXXaLD4matPwOqRaMzVrFuCyn9ra3/LqjYjYogt2Mj4cG4iA27lzcF8qbdbtRrOLaBepWg+4Kbd5QpzABykuedvEA0hsY0/ARqwngy42rz8zEvKAxdePsNZd/s/qu2EwqZmKUGnU4Kg2XwSWjijZl9/vr1nx+lPrM5EcL7hboy/N+9NA/21WTWVMOuqlheCxLPSh7MNcq3/qmdyM9+SLLMiI8tDvXk3wv6VpMyrSlWkzDVNwbgFncebk4r2lb4t2ynVfGfQtCXgi7AdYczyzTuJJyTWVlFkafbXiKzd6k2/6iAPSNePpeZaQjab0Cnw3DQ7B4jhR17Xx2jKWbfrJk9VCum66rf4Vy42Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Route all cmpxchg() operations performed on various page table entries to a
new ptval_cmpxchg_relaxed() helper. Similarly route all xchg() operations
performed on page table entries to a new ptval_xchg_relaxed() helper.

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
 arch/arm64/include/asm/pgtable.h | 26 +++++++++++++++++++-------
 arch/arm64/mm/fault.c            |  2 +-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 692669ea2d29..66bf5bbe484e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -87,6 +87,17 @@ static inline void arch_leave_lazy_mmu_mode(void)
 #define ptval_get(x)		READ_ONCE(x)
 #define ptval_set(x, val)	WRITE_ONCE(x, val)
 
+static inline ptval_t ptval_cmpxchg_relaxed(ptval_t *ptep, ptval_t old,
+					      ptval_t new)
+{
+	return cmpxchg_relaxed(ptep, old, new);
+}
+
+static inline ptval_t ptval_xchg_relaxed(ptval_t *ptep, ptval_t new)
+{
+	return xchg_relaxed(ptep, new);
+}
+
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
 {
@@ -1281,8 +1292,8 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 	do {
 		old_pte = pte;
 		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
-					       pte_val(old_pte), pte_val(pte));
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
+						      pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 
 	return pte_young(pte);
@@ -1324,7 +1335,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
-	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte = __pte(ptval_xchg_relaxed(&pte_val(*ptep), 0));
 
 	switch (pgsize) {
 	case PAGE_SIZE:
@@ -1400,7 +1411,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1438,7 +1449,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 		if (flags & CYDP_CLEAR_DIRTY)
 			pte = pte_mkclean(pte);
 
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = ptval_cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1477,7 +1488,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
-	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
+	return __pmd(ptval_xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
 
@@ -1804,7 +1815,8 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
-	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
+	old = ptval_cmpxchg_relaxed(&pte_val(*ptep), old, pte_val(new_pte));
+	if (old != 0)
 		return false;
 
 	/*
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 1de76ced0403..6db93371d649 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -244,7 +244,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 		pteval ^= PTE_RDONLY;
 		pteval |= pte_val(entry);
 		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
+		pteval = ptval_cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
 	/*
-- 
2.43.0


