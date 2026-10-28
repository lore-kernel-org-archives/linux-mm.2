Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90586606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=zEm7f38S
Received: by kanga.kvack.org (Postfix)
	id 867906B05B4; Wed, 28 Oct 2026 08:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8183B6B05B5; Wed, 28 Oct 2026 08:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708E36B05B6; Wed, 28 Oct 2026 08:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44B536B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:14:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C720A0BA1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:21 +0000 (UTC)
X-FDA: 85371927522.30.4244E4F
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf30.hostedemail.com (Postfix) with ESMTP id DF6318000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:14:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zEm7f38S;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793189659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jo2z/UtDKgMvST3DW15Q9RIzieX2NG2vU174MOmTVlQ=;
	b=QAZr2irmOv7F/Nas+dOcJ9bdxGVhvm0Oeyje7ZhPbnfoOrHJsCYOBaxBGPyGTaVaYW08hF
	s/SlNfnXATGdC2eyYlnlzmD5ZY2mtOPWfLQgtqZXwxNTCBMEqYwxaZNu0jxj4Vid+Mq8V1
	RlzzxtNzJQSBzhW0SdFZSpOuR/dEM94=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zEm7f38S;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793189659;
	b=G5Sw5Ce7bAhqoWaySRzq/3qBphZ1QhA4V5U0vBng8I/lDULvNaH9gJ5YLgfPF8oXghkiyb
	c1La4W1Ei9ZgScugXMESY3MIVw7O3aLXKYhHWdjyM6KE4lB/NdKidEFIlI0hlbCjSlBFhW
	UqWTvZi9OqtqCjI/fK2ap+xJQahK7kE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Jo2z/UtDKgMvST3DW15Q9RIzieX2NG2vU174MOmTVlQ=;
	b=zEm7f38S0dAlomRO4C7xROtjYXMUcBAq11UKX/4MzLOmoAXVj34hrQwPMbz3tU5ZsdvUhoSFX
	ZUI9gurpVH9UL9SekDSSgldOWiaxitGgf1gtuIyO5GaUMqayHBnPkP1fUT8pFeh5oC+I2ps5DSH
	6qtqDMQyR6BHshVAKtHHgx4=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jF5r233T2zpStP;
	Wed, 28 Oct 2026 20:13:54 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 3023240590;
	Wed, 28 Oct 2026 20:14:07 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 28 Oct
 2026 20:14:06 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH RESEND 3/3] arm64: Add PUD THP support for DAX and pfnmap
Date: Wed, 28 Oct 2026 20:14:04 +0800
Message-ID: <20261028121404.853944-4-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028121404.853944-1-tujinjiang@huawei.com>
References: <20261028121404.853944-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF6318000A
X-Stat-Signature: de56a8isqjmy4adciwpt4kb4gk91b59x
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793189658-414481
X-HE-Meta: U2FsdGVkX1/7QtDKTu4U5algU1lOkQcoDF3kLaPxeYLINeZDwR1vRXx5V4NZV9gOLQ53CoPpmlFdYthB4ZRB1UWbtGId86oErkcW6joS1q7Dt55BaOHeruGgQtlq84dye6v1Us69tO59wJ/aGCshq4xMvW2ytYn2J6Re182xvGEBMJw8AxfCNvQjwpC1NV9p3dI6G2SF6Bh0PPFYiJFvTUWRWs3kP8ZJmll/2fzAJB9qgAjkImBMh7qbLLHpFNbD1gsRh8YLI6itsgnDFB4113Sx3dnpXi/EdXlpSQGbb8l+0ldsvN2tI1T9H7m4LGCe4WDR9SjNXFx1ZsU5cg2zLA6qG0peCSBjofGmrL6CuMRjC52emvBrXLAoh5bYDYGGPWbLFSt6596BIP7XFDcMM9zVucHaT2Te5v59or7MV+8sjOwIRFzU5wRCUIMevkIHIrlw99mbMdqv8ozVMtAjP61jdTlfun1eohoKVQ0IBAy4TE09wdquImXIsdvlC9lag+OIwpCc9SeDfSv6hajLZrD/cuaRTf7yvxDoLvetqPnxODnrm8Ut6MFpXrjLzdHbSGFPvHvau9VGktxsBRJXBG6PDIOiasG+73hsjCARhOpowpRiP3c/rRRiLRCsBju1kxfI3mse6WGcnSu/oaQLQq1wyyd/NpuBxR5ZX9EJ+YR+vQa90plvQcQt48sfFpobI/plV6+ZSYBDLjueF9QzIOAR6KbhEWi1dVaadDjT3vCZU6BXYXitkumXGvgxznJYnynOkJBkeYoHjLUmC4Yb6+rBlWkOcK0N/i7nfyGruOuQ92Dl9+DZWb8TgMDejMHJAM98cisAxTJQ1RU05s9JO7+bLYiIDRGpdUbmdBazMdgCFr+FckbdUS3u6whMS1W8/ocCj2+Aghhqy1XP4UHL6o3n0CM8slsqCqF6jVwYxKkMlGFbmIxEIBBr7i0g1NUa6wdEQWJMjDE2r2hX7O8
 GtTXJFX5
 fi/D4MimaPIsPYegkG8GZsbvHnxNynbV+5EPQOLO1fGI8gbF2+NYZ3X3FwmCdqyQGbEecObn4p7BqOajxvOw2u5u1NwIm4FJPRjB4mlSRhFiwoHHpAIR4CoSHajGMIeX+iMKwZVUMyNiB/EBX26zonP6gWlhdiacEweBYZYPAD/7393c4JITDOpHYnPJUSpCd4ldvmT6MZMtGtAquZTuia3wZoQUyc07ebU/A1bzfWJBYfvP8+yA+3lQxHrcMf21YJbnY2V1pvv4HNqeIMY3u4kWeDhkIv6dyV9Xo1COVv23d1TBaVs9BZwlQV5pw7Z6osd8U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the necessary page table functions to deal with PUD THP, this enables
PUD THP for DAX and pfnmap.

I tested with CONFIG_DEBUG_VM_PGTABLE and CONFIG_PAGE_TABLE_CHECK enabled.
I wrote a test driver that invokes vmf_insert_pfn_pud() in the huge_fault
callback.  Page table setup works as expected with no errors, and userspace
read/write access to the PUD-sized mapping is verified correct.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 arch/arm64/Kconfig               |  1 +
 arch/arm64/include/asm/pgtable.h | 52 ++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index cfef22aee709..4f988f23acfb 100644
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
index 7de2487e4d35..feca481b2079 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -569,6 +569,11 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
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
@@ -577,8 +582,15 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
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
@@ -826,6 +838,13 @@ static inline bool pud_leaf(pud_t pud)
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
@@ -1183,6 +1202,11 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
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
@@ -1207,6 +1231,16 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
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
@@ -1281,6 +1315,14 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
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
@@ -1443,6 +1485,15 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
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
@@ -1517,6 +1568,7 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 #define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
+#define update_mmu_cache_pud(vma, address, pud) do { } while (0)
 
 #ifdef CONFIG_ARM64_PA_BITS_52
 #define phys_to_ttbr(addr)	(((addr) | ((addr) >> 46)) & TTBR_BADDR_MASK_52)
-- 
2.43.0


