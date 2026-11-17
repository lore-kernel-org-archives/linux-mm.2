Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC128606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=h5CrYLpt
Received: by kanga.kvack.org (Postfix)
	id 8C95A6B05B6; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804906B05B7; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBF96B05B8; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B3396B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:02:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9D2A1C2899
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:47 +0000 (UTC)
X-FDA: 85442962374.25.7342D9C
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3E1A9A000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:02:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h5CrYLpt;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880966;
	b=ruNyM39Mmh2JK5GzVtqyVEj7Lpy6Nuys4/V1PyXP2IAa0SjfLXygcxw3SdXwmiqviMWhoO
	KlnWlQWXYsWWoBvnZm6CfO1549DLryz6Fz/JGqmQgGUS7WaOkXdKAJ6gyWatK1gI94fNpX
	feXTipDm/9GlFwVlsYTL2yyBhQDacgc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h5CrYLpt;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uA3Sv8ytCCOw7MeX7toFmQOLlM5lQ9hHEuSPO73dnQ=;
	b=RPISdjISs491lyMkdiQTc9TCI4K3Ey2nBY6cqiJWxUgKwQErTp2/6O8nygN7Qfk5yV8rq+
	AD7udt15OZyplCkEIsUZWCOgMvs7AfL7mPHOJcAk6YHJFBrSaYFbGIBV2Q0Pxp7FMP09Dj
	PG7Ba1Hum+g/qGIGS7e9EQAV4Pi4ia0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4uA3Sv8ytCCOw7MeX7toFmQOLlM5lQ9hHEuSPO73dnQ=;
	b=h5CrYLptzwHdrgv+0XVhIrE/aphC5MF1MhP/WPSiFWabXk2gNAf5X2IHr/vC0Spugfctft8Ef
	se5ykmjhSwwDH1kJm/O/rjXa9G4trYsjgt9SbZLmyHI8716PxohKlq9pv5hnoTqDJ3thJ/gbcMn
	7zkSbZu35EVtKUH3gXuONYQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jT7Jp534xz1T4hS;
	Tue, 17 Nov 2026 10:02:02 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CF274056E;
	Tue, 17 Nov 2026 10:02:40 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 17 Nov
 2026 10:02:39 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<ryan.roberts@arm.com>, <peterx@redhat.com>, <dave.jiang@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 4/4] arm64: Add PUD THP support for DAX and pfnmap
Date: Tue, 17 Nov 2026 10:02:37 +0800
Message-ID: <20261117020237.4037980-5-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117020237.4037980-1-tujinjiang@huawei.com>
References: <20261117020237.4037980-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E1A9A000B
X-Stat-Signature: ndhdbpk7hftmqa74i9i4zpcu4wmjbe36
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794880965-983215
X-HE-Meta: U2FsdGVkX1/Nr7VrSS3LuHsd7KsQ3Q8TSZuaHhUHbeJB7yMqdtbo++j0td4JG3WUP4YFLzWunxh/3Syhs6eEkImGYDi8AgiIQkqKSABOyTnDMvr0DT6PVwwhig4p3rXdC4wdtOCEscNVra32XAnzfzzeVfsvvDsGRtU5DgEpIgx0GvAWBAN4CZDehLhZPpJG3xCR/cePfNaPySR6qThTIcSkqR5Od5DWMZnxViA0Y3ze4TqBanIPlpSdVfQ7F5V5NYPav6FsmU/TlVA01L8Fy+89PGnJ1vmm62dtzsOpVitTU64r830eS819jY67eztbvq96UG/51QF4AVO3MpBoNcYZgQ092SGedgAtA6vgy/ugxdj9iW+EV3im5eqOChI1KcYUHxO2LJEyPZ6GPSjQXeQHc974jczMWh074UeNlrvTuO8avBp9RA2Z7AxmQcOZlYdukAGpQh8C50oPuJh13qkXvptH18CBJ8/4gBB7OfdzwYhv5o/E1t+/hcRo/e3Wk3ixW6pG8bUlpomfmLd2y/h/7ol6m4PBzHQ2PMK9wq0Pr20q1gAL4RUNtjoUdGhoilt/6ImG36k/q6nmN0NU/j0ysMq4OqkZ7JzagOH82K+BSLffRtn6jtWeavg5gNxoWFpkLsXd9eTBuauY2jdbeZmC3s2sIbbrJQ7PA9lUiHR+yMuK3MtLgOshSVJTLqQ6Mx1WXvcAwEYelTxFtZNc1V4PmPIF2iE8PaCfsCT6kd9/6uQe0LN3ZWO3TVb+p4nIxZMFIqeTljexdHSW8HntcTfz+8eV1kDrK9GxtKNg1a6D5/rbrmZ91MLguA5F67CqF2/DBF5SzU/seBDiVw+KE8CUMR4nGeS/Dc7d8XYcUf7u3U7Gn5xpHR0DCMvx6CX/+Z/XfUNqn5gedamr/CkIE6aO/MUJZW2TFg7zOgnQTObTZLdSQdV4yqUCIDFLIJOTenosmlU1b/3HfSJrleh
 aASwQHhB
 98lMwgfBOS+6kjwpiAk9uBn/KYfkIzS8bEHSkXBrwwei+kWAfR80+KWXJgmN6s5g61nTg5oxBMlv5cz59eyicRc7OBmwagh9qPfE5yep+rpYVUg0FmnHmiD9x7VAfaiaCSHoeIGSz0kAIHzy4zTyaYs4f2qAH4h+a4zWkMSBYJxAepiBrPTXdMiM29sFQeGeKbtDcJajTSBaM9A5AAhDzAKIoBwjah+a5N4cRWI9zRxJJFeS6qu/iPlzVxiGO9/hHV3Vw8o4TUbtBaAy82o1gyieuv2A9s9jsTd7bSdBnt/+sp88=
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
 arch/arm64/include/asm/pgtable.h | 81 +++++++++++++++++++++++++++++---
 2 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1075bc661833..808d7106df34 100644
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
index 3c1c000cc5dd..2dc6aa3096d8 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -573,6 +573,11 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
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
@@ -581,8 +586,15 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd)
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
@@ -738,6 +750,13 @@ static inline bool pmd_leaf(pmd_t pmd)
 #define pmd_leaf_size(pmd)	(pmd_cont(pmd) ? CONT_PMD_SIZE : PMD_SIZE)
 #define pte_leaf_size(pte)	(pte_cont(pte) ? CONT_PTE_SIZE : PAGE_SIZE)
 
+#if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS < 3
+static inline bool pud_table(pud_t pud) { return true; }
+#else
+#define pud_table(pud)		((pud_val(pud) & PUD_TYPE_MASK) == \
+				 PUD_TYPE_TABLE)
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
@@ -747,14 +766,15 @@ static inline int pmd_trans_huge(pmd_t pmd)
 	 */
 	return pmd_present(pmd) && !pmd_table(__pmd(pmd_val(pmd) | PTE_VALID));
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS < 3
-static inline bool pud_table(pud_t pud) { return true; }
-#else
-#define pud_table(pud)		((pud_val(pud) & PUD_TYPE_MASK) == \
-				 PUD_TYPE_TABLE)
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline int pud_trans_huge(pud_t pud)
+{
+	return pte_present(pud_pte(pud)) &&
+	       !pud_table(__pud(pud_val(pud) | PTE_VALID));
+}
 #endif
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 extern pgd_t swapper_pg_dir[];
 extern pgd_t idmap_pg_dir[];
@@ -1187,6 +1207,11 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
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
@@ -1209,7 +1234,17 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 	return __ptep_set_access_flags_anysz(vma, address, (pte_t *)pmdp,
 					     pmd_pte(entry), dirty, PMD_SIZE);
 }
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline int pudp_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address, pud_t *pudp,
+					pud_t entry, int dirty)
+{
+	return __ptep_set_access_flags_anysz(vma, address, (pte_t *)pudp,
+					     pud_pte(entry), dirty, PUD_SIZE);
+}
 #endif
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
 static inline bool pte_user_accessible_page(struct mm_struct *mm, unsigned long addr, pte_t pte)
@@ -1285,6 +1320,14 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
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
@@ -1355,6 +1398,15 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 {
 	return pte_pmd(__ptep_get_and_clear_anysz(mm, address, (pte_t *)pmdp, PMD_SIZE));
 }
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
+static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
+					unsigned long address, pud_t *pudp)
+{
+	return pte_pud(__ptep_get_and_clear_anysz(mm, address, (pte_t *)pudp, PUD_SIZE));
+}
+#endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
@@ -1445,7 +1497,23 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#define __HAVE_ARCH_PUDP_SET_WRPROTECT
+static inline void pudp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pud_t *pudp)
+{
+	__ptep_set_wrprotect(mm, address, (pte_t *)pudp);
+}
+
+static inline pud_t pudp_establish(struct vm_area_struct *vma,
+		unsigned long address, pud_t *pudp, pud_t pud)
+{
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
+	return __pud(xchg_relaxed(&pud_val(*pudp), pud_val(pud)));
+}
 #endif
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
  * Encode and decode a swap entry:
@@ -1521,6 +1589,7 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 #define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
+#define update_mmu_cache_pud(vma, address, pud) do { } while (0)
 
 #ifdef CONFIG_ARM64_PA_BITS_52
 #define phys_to_ttbr(addr)	(((addr) | ((addr) >> 46)) & TTBR_BADDR_MASK_52)
-- 
2.54.0


