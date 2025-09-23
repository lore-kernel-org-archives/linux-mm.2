Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBD47CAC5AE
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 13:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8888E0013; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77BB8E0001; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB2D8E0001; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 788BA8E000B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FFA8C0162
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:37:35 +0000 (UTC)
X-FDA: 83920617270.30.D3B93CA
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 933EA4000D
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:37:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758634653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cImIzswbVblbncJUIKsGJV2GEX2y2IAc1Muz2j2wglI=;
	b=Dm5cHzfWIWqHnHEO/FLrX8gkgtwc6eKLk0wOChqpmHlGQbULGWCHmEPhXaFBVrb0FQnrqQ
	0K0f5VnHet5P0/+E8HGUq5QtnpLvKX4Tpej3WFfRY4FrviS+HkSnWxf1ZBXpeWFueVRDlk
	2TzMcdu3zJ6wVD8UzTMlCysccG/mhbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758634653; a=rsa-sha256;
	cv=none;
	b=QC2mCRIIrW+dZH/dB19anNymVoXVk+MRMBP8VC7vecPkk5QJhiXx047SWrgKzYlTPM+BIz
	LdyTg2UEMukf41Ks34Vht7jdLrn8Ehxw0FNZItOFYys2pz6bzTLM3LXBiU2nlu2HfLCEmg
	AMRM6rNwtnUUVH9B6Wr7rr6OUQ82+UM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cWLWj1Z2SzVgCP;
	Tue, 23 Sep 2025 21:32:49 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 98ABD1401E9;
	Tue, 23 Sep 2025 21:37:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 23 Sep
 2025 21:37:25 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <anshuman.khandual@arm.com>,
	<yangyicong@hisilicon.com>, <ardb@kernel.org>, <willy@infradead.org>,
	<apopple@nvidia.com>, <samuel.holland@sifive.com>,
	<luxu.kernel@bytedance.com>, <abrestic@rivosinc.com>,
	<yongxuan.wang@sifive.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC 2/2] mm: add PMD-level huge page support for remap_pfn_range()
Date: Tue, 23 Sep 2025 21:31:04 +0800
Message-ID: <20250923133104.926672-3-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923133104.926672-1-yintirui@huawei.com>
References: <20250923133104.926672-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 933EA4000D
X-Stat-Signature: d7d6s1uim3tubsmpmty63xwsipqr6x19
X-Rspam-User: 
X-HE-Tag: 1758634651-197264
X-HE-Meta: U2FsdGVkX19TuWWHfxeObZMVLDoL3RlAgpgyMbPHsg9LQUfG3mhf2F0/TbuIhnDkIiBZ9TR03wC7PApEyKNFxvnIX41S1Zl5Nfmt82KprjUlV4f3nxPLlBpJDuF8E4GpfFoiz/i4/HgqVTIHZoseOTbf6Tn3SH9w9e1cFC1bJzqU3JqVJzZeQnq4ebQCEShQP77sg5dzDicZ+6wCUZugSDc2+8+zaxPPwEq4Z5CczlxEYVqC760OwrZg7oiJ5dLecGZ+tFlALayRkcFjBlJXV5MabUAqXpCfK3CKIXVV6baorJNQ0NbqUlVcy53Mta/AYHWsyWZ5ewTxYm185d7iex2/hoICnBnMnuT4lQkRO690zVIkAiH3VD7+sa3ABbZ9VY1o4+bz8iuuy70JvrMRyu60f5udaiy06jLg8JeWbqAjkWaDiPSh6x0Z7j4/UsmMBE4BVjdkiYuCXBptIYZCkuJZXS/abfG7Op4l9FXEu/+W+Qg2bRktHS7Kv76+6gpuaNyzjc5fMc9D5l2vUWJvGZIouvkbqp93+TwithHIvPeu7browdCaUkWz1GAs/raqoys5fwLasbbwd2REOhUiPg7yoqiNwpa/+9Ib1WtuB8hPLmueIkk3vihfC1B/5A5+HCne4gaA3nrwKYrILA0BL6JLpXtaBVjufOwaOllCgD1E+eeB2dxpio4qe9y4C7hCgzuyOYu19WDX4GrIfJf/m9GH9Rx33MVXXO+7z50ULVRVE4uBIr+58nnvizPE2jF4zX4+H5LkIwGf1bmWULMtk4cZ13SIsevIQHOOrrFrz5TT0I3VIBhntVR5koy8Ayx7hy9UrVGLuAraA/PuKwjrK3bPkcAHb30+iq/QYIJa0oJGrA9eAnHrByEKZutXUTKMEaFHmopdS8iu30ORudu4wUhSkxJ6XLXXbrKA1k8DjO5RhjiFT+57OCmXjfeURDizm8JpoJpDF/J8bs3+opW
 jlFM5cd8
 RW51u68fnRavepgIczkbMJYznPqeO/uaikNeq34/EGBtIABfDXq/hoLFfBquPBEFtxjtFnKID416Zir6Re2xGByffLqTVYC/w2guHARkON2oIevzem7ex8NrClqaDlaJKXtqifR52YJ+Dow9NRCM/cI9wePrWLoH6xS0c2SfBAPIZ6SnHB1YZDHjQQNVBlZtMnKFtqJEgwHSNXksIqQKvOtvlMYZQKVt5WtYAI3TBUDXG5iyyAvYTN7S+NqLcZ6PZm/7xFJoDn1xBLj+Yz+g0V+Wbyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add PMD-level huge page support to remap_pfn_range(), automatically
creating huge mappings when prerequisites are satisfied (size, alignment,
architecture support, etc.) and falling back to normal page mappings
otherwise.

Implement special huge PMD splitting by utilizing the pgtable deposit/
withdraw mechanism. When splitting is needed, the deposited pgtable is
withdrawn and populated with individual PTEs created from the original
huge mapping, using pte_clrhuge() to clear huge page attributes.

Update arch_needs_pgtable_deposit() to return true when PMD pfnmap
support is enabled, ensuring proper pgtable management for huge
pfnmap operations.

Introduce pfnmap_max_page_shift parameter to control maximum page
size and "nohugepfnmap" boot option to disable huge pfnmap entirely.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 include/linux/pgtable.h |  6 +++-
 mm/huge_memory.c        | 22 ++++++++----
 mm/memory.c             | 74 ++++++++++++++++++++++++++++++++++++-----
 3 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 4c035637eeb7..4028318552ca 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1025,7 +1025,11 @@ extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #endif
 
 #ifndef arch_needs_pgtable_deposit
-#define arch_needs_pgtable_deposit() (false)
+#define arch_needs_pgtable_deposit arch_needs_pgtable_deposit
+static inline bool arch_needs_pgtable_deposit(void)
+{
+	return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
+}
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..9f20adcbbb55 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2857,14 +2857,22 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (!vma_is_anonymous(vma)) {
 		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
-		/*
-		 * We are going to unmap this huge page. So
-		 * just go ahead and zap it
-		 */
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(mm, pmd);
-		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
+		if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+			pte_t entry;
+
+			pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+			if (unlikely(!pgtable))
+				return;
+			pmd_populate(mm, &_pmd, pgtable);
+			pte = pte_offset_map(&_pmd, haddr);
+			entry = pte_clrhuge(pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd)));
+			set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
+			pte_unmap(pte);
+
+			smp_wmb(); /* make pte visible before pmd */
+			pmd_populate(mm, pmd, pgtable);
 			return;
+		}
 		if (unlikely(is_pmd_migration_entry(old_pmd))) {
 			swp_entry_t entry;
 
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..c4aaf3bd9cad 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2674,6 +2674,19 @@ vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
 	return __vm_insert_mixed(vma, addr, pfn, true);
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
+static unsigned int __ro_after_init pfnmap_max_page_shift = BITS_PER_LONG - 1;
+
+static int __init set_nohugepfnmap(char *str)
+{
+	pfnmap_max_page_shift = PAGE_SHIFT;
+	return 0;
+}
+early_param("nohugepfnmap", set_nohugepfnmap);
+#else /* CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP */
+static const unsigned int pfnmap_max_page_shift = PAGE_SHIFT;
+#endif	/* CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP */
+
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
@@ -2705,9 +2718,47 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	return err;
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static int remap_try_huge_pmd(struct mm_struct *mm, pmd_t *pmd,
+			unsigned long addr, unsigned long end,
+			unsigned long pfn, pgprot_t prot,
+			unsigned int page_shift)
+{
+	pgtable_t pgtable;
+	spinlock_t *ptl;
+
+	if (page_shift < PMD_SHIFT)
+		return 0;
+
+	if ((end - addr) != PMD_SIZE)
+		return 0;
+
+	if (!IS_ALIGNED(addr, PMD_SIZE))
+		return 0;
+
+	if (!IS_ALIGNED(pfn, 1 << (PMD_SHIFT - PAGE_SHIFT)))
+		return 0;
+
+	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
+		return 0;
+
+	set_pmd_at(mm, addr, pmd, pmd_mkspecial(pmd_mkhuge(pfn_pmd(pfn, prot))));
+
+	pgtable = pte_alloc_one(mm);
+	if (unlikely(!pgtable))
+		return 1;
+	mm_inc_nr_ptes(mm);
+	ptl = pmd_lock(mm, pmd);
+	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	spin_unlock(ptl);
+
+	return 1;
+}
+#endif
+
 static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
+			unsigned long pfn, pgprot_t prot, unsigned int max_page_shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -2720,6 +2771,12 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 	do {
 		next = pmd_addr_end(addr, end);
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+		if (remap_try_huge_pmd(mm, pmd, addr, next,
+				pfn + (addr >> PAGE_SHIFT), prot, max_page_shift)) {
+			continue;
+		}
+#endif
 		err = remap_pte_range(mm, pmd, addr, next,
 				pfn + (addr >> PAGE_SHIFT), prot);
 		if (err)
@@ -2730,7 +2787,7 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 
 static inline int remap_pud_range(struct mm_struct *mm, p4d_t *p4d,
 			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
+			unsigned long pfn, pgprot_t prot, unsigned int max_page_shift)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -2743,7 +2800,7 @@ static inline int remap_pud_range(struct mm_struct *mm, p4d_t *p4d,
 	do {
 		next = pud_addr_end(addr, end);
 		err = remap_pmd_range(mm, pud, addr, next,
-				pfn + (addr >> PAGE_SHIFT), prot);
+				pfn + (addr >> PAGE_SHIFT), prot, max_page_shift);
 		if (err)
 			return err;
 	} while (pud++, addr = next, addr != end);
@@ -2752,7 +2809,7 @@ static inline int remap_pud_range(struct mm_struct *mm, p4d_t *p4d,
 
 static inline int remap_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
+			unsigned long pfn, pgprot_t prot, unsigned int max_page_shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -2765,7 +2822,7 @@ static inline int remap_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 	do {
 		next = p4d_addr_end(addr, end);
 		err = remap_pud_range(mm, p4d, addr, next,
-				pfn + (addr >> PAGE_SHIFT), prot);
+				pfn + (addr >> PAGE_SHIFT), prot, max_page_shift);
 		if (err)
 			return err;
 	} while (p4d++, addr = next, addr != end);
@@ -2773,7 +2830,7 @@ static inline int remap_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 }
 
 static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn, unsigned long size, pgprot_t prot)
+		unsigned long pfn, unsigned long size, pgprot_t prot, unsigned int max_page_shift)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -2817,7 +2874,7 @@ static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long ad
 	do {
 		next = pgd_addr_end(addr, end);
 		err = remap_p4d_range(mm, pgd, addr, next,
-				pfn + (addr >> PAGE_SHIFT), prot);
+				pfn + (addr >> PAGE_SHIFT), prot, max_page_shift);
 		if (err)
 			return err;
 	} while (pgd++, addr = next, addr != end);
@@ -2832,8 +2889,7 @@ static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long ad
 int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
-	int error = remap_pfn_range_internal(vma, addr, pfn, size, prot);
-
+	int error = remap_pfn_range_internal(vma, addr, pfn, size, prot, pfnmap_max_page_shift);
 	if (!error)
 		return 0;
 
-- 
2.43.0


