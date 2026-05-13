Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 944E1CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 04:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB756B00A4; Wed, 13 May 2026 00:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0937B6B00A6; Wed, 13 May 2026 00:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC046B00A7; Wed, 13 May 2026 00:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1E976B00A4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:47:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A93AE140718
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:24 +0000 (UTC)
X-FDA: 84761162808.19.292F75E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id CAF5B1A0004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:47:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LtmKpP9c;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778647643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILmpXtopRLPbAdJmkKRWdEfyEgQe48JK5xdWQ/oou1c=;
	b=rFFqC2WweBxr6Y34dqeNooiEF7BZdhs1znP9UAAjxm83TuAXk7qHGPUzp+qW7fqLLipMAN
	6VanJi4uxbj78Y7l+/Y5osMn39I+UDttxmBXIhBeUqDxp23NubSGeYqL3aqCDe9FFvJgeY
	7YzPFxCpsyW4HtYgMGZNDtdx/RqaIZ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LtmKpP9c;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778647643; a=rsa-sha256;
	cv=none;
	b=dPg5bqX19SLaQMpxHF66mEVUFaW8d/AVt71p7CSn/NFo9f5CorOMQ4Eb4THOZuDXoYUVbZ
	3aHIJbsvZzJc7T8+7Uu8Xt4cNAeDSwpuy9Lt83JVA+DB/FZkpnqSq4j8DQj/XoGDuRZiWj
	oy/mgoV/VzEUNPDGpXJj42kvCRms11Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F3D4153B;
	Tue, 12 May 2026 21:47:16 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C7183F7B4;
	Tue, 12 May 2026 21:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778647641; bh=nE2B6txq+G6J1DnWDY4MtjVn5yQsvc5RujCivGOJKhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtmKpP9cKE1qV5sW3DA+rvF16uG8jRxLPJSmZsGdBfR0DQSryEZth4AszSlYSLkAS
	 gyIT8hchv4UYfL/Zy/kZxuIArk6BYD7ckkBAUz5Dr7p0sjHXGE/gZ/94wsfvY5tMVV
	 5wJ0qMK8B3ytnwb0TrnJcMT1EvJhM62KUM2v6DT4=
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
Subject: [RFC V2 10/14] arm64/mm: Abstract printing of pxd_val()
Date: Wed, 13 May 2026 10:15:43 +0530
Message-ID: <20260513044547.4128549-11-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4dj1s9s8qz85chkcarky7kauj1ynzn66
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CAF5B1A0004
X-Rspam-User: 
X-HE-Tag: 1778647642-444762
X-HE-Meta: U2FsdGVkX18xaVz0Ck9dDtvEKsfA4FnAIyWS3FBWhqRvG333JU5pJsZM1SyW2vFqFfvWX9Rr/AlTcPR/SZmoS3VsMX5fYfTnCDLpfQ3Z3+lGFR6CCPcqqmUuhSxCpvbTWYWSCZAeRXg19uLZgI08bQe+oF3paAsAqj/Xv3u/nEh78hTMeIJNkOSbaLSnHYR1hN9z/jxFbxkxoptYHTK9fv5ioLDaUKSqFA5A3+R+fnw7PuUMivyHI4mM6Uqj3s/L81xVZedSRP2NBGnwKI1Wv0+rS+dyrPU/7591FwaTiatCw4ra28D6JvxOCsGzsT6jsyvC7xg6ir535mf2CUq32NOjT0FtEEUjBMmzqq73itOEyk+sz22lNV4YV+Tmq8SEZNVVOdhRaeCLyautmMiFUXqBs32NwcHFnrdd4DEEEPqkTcDZNFykB/uPg2BQBlziDPA8o3KEXUkHjZkMroufEewjewDoyF8oJkF4YAJVGiqFs3zxIkH42Mw/+dlZOFtBMGJhPhC5hhmL0v8LQUvCsOkOF/hWHIk0xy1bkfvWPOZzXiY24S+YwnY/va0/Kq3H7r47+H4A59VuXfaW70P2joCYE2aaV0PyGH621NsLDXofJoxTRwFHXlH2xa5W43CvVNWCxnrKZd+jTyssHARSVs11Tp2m64+iNjYmPRwSG2PjsJQVLoyg1yF+6mBY1pcpTlu4d83jY9rpSNVvizjOSl3yG1AdA2YlGaLgbfpi+hAL8oYRuRXsA3u4P5zJz7kA5tLHjaQK7ixVRt+J0juCqa8bI5t2dmvYmD0mHgqx9MrdVIK1FZugFaNktFEbTvUWWZ66HWeCFNQBD/86pFGf+HLy72LqshJ3lvTKPsgASiPEirHVZ5G92SkpYtWvjoCykvZ6QyTXuO47ad90TSrrSdIT+3ljxfDV82Ar1Px/WmYKfucPnRKrtKmgTceOsltk2CWyJepmgSBgDJxN97Y
 IE4KCr99
 vGrnxSIx+tpvp8ER3MOz5uKlKJOATeBVg/zoFxJ5RFFeomWA9UBlH3OiYB4TSFIWxdhHxYMkUgesFKwf8Jkvz41pgoP2hbrn4Bu1mzO4s2h3sLxYxZDOKHkROt37zNPy8ZpLEQuUAab749/IDXwEdTjEKnuYdhHzUCfUoFgh8s2diplMfTt3wiDvC3sUymcbCiEnVTlmmSpZsfEDpe7HOrLCfhq3G/SyWQlUnYkmQgd0U/cOg0bBXt8O5q/hbw4niCeeBaDJqVmxJRRcv9CX3qpAOqTqtmSocmQuU+ARwDu8MkO0ljxq6lb29gqB0L/u4ZqpiZOiTaac6KlOGR0An2nORmFnr/fd1XUx+GJzEDZ3JnstHOG6TwvIXaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ahead of adding support for D128 pgtables, refactor places that print
PTE values to use the new __PRIpxx format specifier and __PRIpxx_args()
macro to prepare the argument(s). When using D128 pgtables in future,
we can simply redefine __PRIpxx and __PTIpte_args().

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in RFC V2:

- Renamed __PRIpte as __PRIpxx per David

 arch/arm64/include/asm/pgtable-types.h |  3 +++
 arch/arm64/include/asm/pgtable.h       | 22 +++++++++++-----------
 arch/arm64/mm/fault.c                  | 10 +++++-----
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-types.h b/arch/arm64/include/asm/pgtable-types.h
index 265e8301d7ba..920144ec64dc 100644
--- a/arch/arm64/include/asm/pgtable-types.h
+++ b/arch/arm64/include/asm/pgtable-types.h
@@ -11,6 +11,9 @@
 
 #include <asm/types.h>
 
+#define __PRIpxx		"016llx"
+#define __PRIpxx_args(val)	((u64)val)
+
 /*
  * Page Table Descriptor
  *
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f876200d383e..4065b68e8d79 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -146,7 +146,7 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
 
 #define pte_ERROR(e)	\
-	pr_err("%s:%d: bad pte %016llx.\n", __FILE__, __LINE__, pte_val(e))
+	pr_err("%s:%d: bad pte %" __PRIpxx ".\n", __FILE__, __LINE__, __PRIpxx_args(pte_val(e)))
 
 #ifdef CONFIG_ARM64_PA_BITS_52
 static inline phys_addr_t __pte_to_phys(pte_t pte)
@@ -461,14 +461,14 @@ static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
 	 * through an invalid entry).
 	 */
 	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy access flag clearing: 0x%" __PRIpxx " -> 0x%" __PRIpxx,
+		     __func__, __PRIpxx_args(pte_val(old_pte)), __PRIpxx_args(pte_val(pte)));
 	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy dirty state clearing: 0x%" __PRIpxx " -> 0x%" __PRIpxx,
+		     __func__, __PRIpxx_args(pte_val(old_pte)), __PRIpxx_args(pte_val(pte)));
 	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: unsafe attribute change: 0x%" __PRIpxx " -> 0x%" __PRIpxx,
+		     __func__, __PRIpxx_args(pte_val(old_pte)), __PRIpxx_args(pte_val(pte)));
 }
 
 static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
@@ -905,7 +905,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 #if CONFIG_PGTABLE_LEVELS > 2
 
 #define pmd_ERROR(e)	\
-	pr_err("%s:%d: bad pmd %016llx.\n", __FILE__, __LINE__, pmd_val(e))
+	pr_err("%s:%d: bad pmd %" __PRIpxx ".\n", __FILE__, __LINE__, __PRIpxx_args(pmd_val(e)))
 
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		((pud_val(pud) & PUD_TYPE_MASK) != \
@@ -1000,7 +1000,7 @@ static inline bool mm_pud_folded(const struct mm_struct *mm)
 #define mm_pud_folded  mm_pud_folded
 
 #define pud_ERROR(e)	\
-	pr_err("%s:%d: bad pud %016llx.\n", __FILE__, __LINE__, pud_val(e))
+	pr_err("%s:%d: bad pud %" __PRIpxx ".\n", __FILE__, __LINE__, __PRIpxx_args(pud_val(e)))
 
 #define p4d_none(p4d)		(pgtable_l4_enabled() && !p4d_val(p4d))
 #define p4d_bad(p4d)		(pgtable_l4_enabled() && \
@@ -1128,7 +1128,7 @@ static inline bool mm_p4d_folded(const struct mm_struct *mm)
 #define mm_p4d_folded  mm_p4d_folded
 
 #define p4d_ERROR(e)	\
-	pr_err("%s:%d: bad p4d %016llx.\n", __FILE__, __LINE__, p4d_val(e))
+	pr_err("%s:%d: bad p4d %" __PRIpxx ".\n", __FILE__, __LINE__, __PRIpxx_args(p4d_val(e)))
 
 #define pgd_none(pgd)		(pgtable_l5_enabled() && !pgd_val(pgd))
 #define pgd_bad(pgd)		(pgtable_l5_enabled() && \
@@ -1257,7 +1257,7 @@ p4d_t *p4d_offset_lockless_folded(pgd_t *pgdp, pgd_t pgd, unsigned long addr)
 #endif  /* CONFIG_PGTABLE_LEVELS > 4 */
 
 #define pgd_ERROR(e)	\
-	pr_err("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
+	pr_err("%s:%d: bad pgd %" __PRIpxx ".\n", __FILE__, __LINE__, __PRIpxx_args(pgd_val(e)))
 
 #define pgd_set_fixmap(addr)	((pgd_t *)set_fixmap_offset(FIX_PGD, addr))
 #define pgd_clear_fixmap()	clear_fixmap(FIX_PGD)
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index bce191d16090..58d0670b6a43 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -154,7 +154,7 @@ static void show_pte(unsigned long addr)
 		 vabits_actual, mm_to_pgd_phys(mm));
 	pgdp = pgd_offset(mm, addr);
 	pgd = pgdp_get(pgdp);
-	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
+	pr_alert("[%016lx] pgd=%" __PRIpxx, addr, __PRIpxx_args(pgd_val(pgd)));
 
 	do {
 		p4d_t *p4dp, p4d;
@@ -167,19 +167,19 @@ static void show_pte(unsigned long addr)
 
 		p4dp = p4d_offset(pgdp, addr);
 		p4d = p4dp_get(p4dp);
-		pr_cont(", p4d=%016llx", p4d_val(p4d));
+		pr_cont(", p4d=%" __PRIpxx, __PRIpxx_args(p4d_val(p4d)));
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
 
 		pudp = pud_offset(p4dp, addr);
 		pud = pudp_get(pudp);
-		pr_cont(", pud=%016llx", pud_val(pud));
+		pr_cont(", pud=%" __PRIpxx, __PRIpxx_args(pud_val(pud)));
 		if (pud_none(pud) || pud_bad(pud))
 			break;
 
 		pmdp = pmd_offset(pudp, addr);
 		pmd = pmdp_get(pmdp);
-		pr_cont(", pmd=%016llx", pmd_val(pmd));
+		pr_cont(", pmd=%" __PRIpxx, __PRIpxx_args(pmd_val(pmd)));
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
 
@@ -188,7 +188,7 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pte = __ptep_get(ptep);
-		pr_cont(", pte=%016llx", pte_val(pte));
+		pr_cont(", pte=%" __PRIpxx, __PRIpxx_args(pte_val(pte)));
 		pte_unmap(ptep);
 	} while(0);
 
-- 
2.43.0


