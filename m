Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB46C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C4A6B0096; Wed,  9 Sep 2026 05:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3766B0099; Wed,  9 Sep 2026 05:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649AA6B009B; Wed,  9 Sep 2026 05:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 353016B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:28:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE5AAA3387
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:28:32 +0000 (UTC)
X-FDA: 85193698464.16.BC8D3D3
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf11.hostedemail.com (Postfix) with ESMTP id 472EB40003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:28:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KVQRbP2a;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946111;
	b=umiDFudDSnAvDdYAezOSYv/y8qNO+tU7AzZYsySr7rdJMAsyRo211cQGwRWMTEDDjI/4T/
	Jz5EhhoCK0/6Z5kPsshW8d04UZWAkiQ23Jm41PUVNqyjLqpfRfWe8Eia1O6i3D50nzSt17
	dVOiMIEoeb8skZ3GBZj7OVrhRwSyjLM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KVQRbP2a;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLP+Qen/7FlMgfeGn+GCMV7hbDA0yzybp+V1qh81JEw=;
	b=dVnpaoimpv+bwUZ0mtEH/JrJ9szb3ghvKcULdVIAVLAxBcCiOmu2QktfckJ8gNqK80Shw9
	2COBrA178WVX0gPg9EzE9d9E6rprMhs7H2C4r5jb5cjjn6c2wjIMz4cFKg0eU1BX80LINN
	HsAxfevtIb8ZT2/uTMFmUOKmE/bUiQg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mLP+Qen/7FlMgfeGn+GCMV7hbDA0yzybp+V1qh81JEw=;
	b=KVQRbP2aFPXjxwfsj9GMdflbK+s019Q2giB4YC/g5p0t9AZhWxNAjrZnqrQrp3K3c/wXj1OGC
	yMHnrpul7XhXqWhalRxkOp5OrdAq5gYfqyw7mry8+asaIHbm1XhMih/s8hXTWoiicVokE5/Le8N
	Ui/pncGx645fpiK+JicPQw8=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hfwF63RkPz1cyTS;
	Wed,  9 Sep 2026 17:17:30 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BE7F40573;
	Wed,  9 Sep 2026 17:28:24 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 9 Sep
 2026 17:28:23 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH 3/3] arm64: Add support for PUD THP
Date: Wed, 9 Sep 2026 17:00:18 +0800
Message-ID: <20260909090018.1991485-4-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909090018.1991485-1-tujinjiang@huawei.com>
References: <20260909090018.1991485-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 472EB40003
X-Stat-Signature: ynk4sqbn1179swi4xki88dwt8q9hz61o
X-Rspam-User: 
X-HE-Tag: 1788946108-876019
X-HE-Meta: U2FsdGVkX1+XGidiTHs2rW4RSoV/p33/UBtN2pHygmc17kget3JLWI2Qg8p2oLRX3594ZgXjRSH2sm21uUxWDciJA0P2GTHNHTzpcRzixTcSfPGST8IVxkm3B1rosLNeZ3V2VjgxjJp3f3C++D99Q5QaX+AenGr5pnGDFSDCjxuovJ6SLS0U3P8yURpejsPoL6lp4OZj/5pzRNJg9hfkspK8gA0XWOv+hDTM00MdnmfisC8apWurGy3Yl7vlb3PSonsXKAW3QyTa64lM5sQxTgTvNujKCteBJTziGJQrGkMyRWCjpLjwnHFfheXErZN1Ktb5F5sd2mCYAlTikOuUWbMhTZs4D03HuZqp+sj/faqsjABk1cI+eX9wetX6Ne8CPA10kxXZrrT64buB5pael3hk8AeHkP/iQ1uv5wOKxrrD1skIcYO3zU/jfanLz4FjuDOgfpGD8AaglAKTpS2ch9uY7FlaYP/vrLHReZmTglEV1MvRBdVcQz1lJJn3GFSAOMYKKYS+8dT3/f8qpHDWjp0NcY2KJ2R+dA9UAdXcSepqkHzFb85KI09t8zu52JzuDfs7faUpslKd6K6GVBEUK7lUsxKpSNxuGclg/PvQ/V3rD2Yesii+S6PtKFCIGxI2yGliwq1ZzO44mkU2V4griuuqX42aPvALiAKoF2kYIs+D2Z4+1FPwagHE/cpjH14oowgVo1/Jgrs/+wkbl2T6PLVTXXDjAdLVA553AMPaw4atqilhQ4K0SwU2niBgkY7orke/+UdcBQovzhCyPeKYYMcL6IHyHcaLdQHWEyrHTZ3zd75/yEcEVa72g7ZwR7h+87C7t20cKiBF6BhciyjowXAXlwPDKhqjF6WPI5hS7gXOYNec4NZvd82nEtaRu5gCqMZS+UG5luf3vWMwF2dF0Uo5x0w3/JdNToxlCwKzS5linFFq5fRPQTrYQMdVYrpqgWI1eKyrmZPgDxe3a4K
 8F9iFVb/
 ICILpj833r5HrtsvvPHzA3SABaJUbyTPscbH5XPIDa2OSK7nBqKjT7Mcnoc82rEG0b26SI53Tagp4n0zZyG9EtkphL+ugT/j17p1TL8EFp7jsZu8W+0PONX0B8sFbwYuPP+YsssmsnDybwjIDrLYa85DPrrlGQgt0e0y41NkjtxXzVJDIANnz09C0haWNSDMqoAfwaeggkjtL/QmKiq3m6XSkEtmyr5MERlr7WP9g/IKwvvh8VNx9YS/CASDxHW746wHg14XerFWe7u+72zOFn8nvGBTHEEj8IkVWiN4c0oB99QeUVCACA82jeECcNL4dgGzi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the necessary page table functions to deal with PUD THP, this enables
PUD THP for DAX and pfnmap.

I tested with CONFIG_DEBUG_VM_PGTABLE and CONFIG_PAGE_TABLE_CHECK
enabled.  I wrote a test driver that invokes vmf_insert_pfn_pud() in
the huge_fault callback.  Page table setup works as expected with no
errors, and userspace read/write access to the PUD-sized mapping is
verified correct.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 arch/arm64/Kconfig               |  1 +
 arch/arm64/include/asm/pgtable.h | 52 ++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef944..8a7ca1863595 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -173,6 +173,7 @@ config ARM64
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if PAGE_SIZE_4KB
 	select HAVE_ARCH_VMAP_STACK
 	select HAVE_ARM_SMCCC
 	select HAVE_ASM_MODVERSIONS
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 427ea3d2bac7..fdc338970934 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -611,6 +611,11 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
 #define pmd_mkspecial(pmd)	pte_pmd(pte_mkspecial(pmd_pte(pmd)))
 #endif
 
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+#define pud_special(pud)	pte_special(pud_pte(pud))
+#define pud_mkspecial(pud)	pte_pud(pte_mkspecial(pud_pte(pud)))
+#endif
+
 #define __pmd_to_phys(pmd)	__pte_to_phys(pmd_pte(pmd))
 #define __phys_to_pmd_val(phys)	__phys_to_pte_val(phys)
 #define pmd_pfn(pmd)		((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT)
@@ -619,8 +624,15 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
 #define pud_young(pud)		pte_young(pud_pte(pud))
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
 #define pud_mkwrite_novma(pud)	pte_pud(pte_mkwrite_novma(pud_pte(pud)))
+#define pud_mkwrite(pud)	pud_mkwrite_novma(pud)
 #define pud_mkvalid_k(pud)	pte_pud(pte_mkvalid_k(pud_pte(pud)))
 #define pud_write(pud)		pte_write(pud_pte(pud))
+#define pud_dirty(pud)		pte_dirty(pud_pte(pud))
+#define pud_wrprotect(pud)	pte_pud(pte_wrprotect(pud_pte(pud)))
+#define pud_mkdirty(pud)	pte_pud(pte_mkdirty(pud_pte(pud)))
+#define pud_mkold(pud)		pte_pud(pte_mkold(pud_pte(pud)))
+#define pud_mkinvalid(pud)	pte_pud(pte_mkinvalid(pud_pte(pud)))
+#define pud_mkclean(pud)	pte_pud(pte_mkclean(pud_pte(pud)))
 
 static inline pud_t pud_mkhuge(pud_t pud)
 {
@@ -871,6 +883,13 @@ static inline bool pud_leaf(pud_t pud)
 #define pud_user(pud)		pte_user(pud_pte(pud))
 #define pud_user_exec(pud)	pte_user_exec(pud_pte(pud))
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline int pud_trans_huge(pud_t pud)
+{
+	return pud_present(pud) && !pud_table(__pud(pud_val(pud) | PTE_VALID));
+}
+#endif
+
 static inline bool pgtable_l4_enabled(void);
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
@@ -1237,6 +1256,11 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 	return pte_pmd(pte_modify(pmd_pte(pmd), newprot));
 }
 
+static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
+{
+	return pte_pud(pte_modify(pud_pte(pud), newprot));
+}
+
 extern int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 					 unsigned long address, pte_t *ptep,
 					 pte_t entry, int dirty,
@@ -1261,6 +1285,16 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 }
 #endif
 
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline int pudp_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address, pud_t *pudp,
+					pud_t entry, int dirty)
+{
+	return __ptep_set_access_flags_anysz(vma, address, (pte_t *)pudp,
+					     pud_pte(entry), dirty, PUD_SIZE);
+}
+#endif
+
 #ifdef CONFIG_PAGE_TABLE_CHECK
 static inline bool pte_user_accessible_page(struct mm_struct *mm, unsigned long addr, pte_t pte)
 {
@@ -1335,6 +1369,14 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+static inline bool pudp_test_and_clear_young(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp)
+{
+	return __ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
+}
+#endif
+
 static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       unsigned long address,
 					       pte_t *ptep,
@@ -1497,6 +1539,15 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline pud_t pudp_establish(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp, pud_t pud)
+{
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
+	return __pud(xchg_relaxed(&pud_val(*pudp), pud_val(pud)));
+}
+#endif
+
 /*
  * Encode and decode a swap entry:
  *	bits 0-1:	present (must be zero)
@@ -1571,6 +1622,7 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 #define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
+#define update_mmu_cache_pud(vma, address, pud) do { } while (0)
 
 #ifdef CONFIG_ARM64_PA_BITS_52
 #define phys_to_ttbr(addr)	(((addr) | ((addr) >> 46)) & TTBR_BADDR_MASK_52)
-- 
2.43.0


