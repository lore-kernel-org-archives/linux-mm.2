Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5531FEE4C6
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 07:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE676B0089; Sat, 28 Feb 2026 02:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B066B008A; Sat, 28 Feb 2026 02:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC636B008C; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE0C36B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C08A1CD42
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:29 +0000 (UTC)
X-FDA: 84493004778.30.9A82AAF
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0370DC000B
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F2yxSYtM;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772262927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GY7w9lG2hNjdddPK/8x1giPete9XsAMvnf7gDXNDb+Y=;
	b=nXDid8dIGFOH+KBNxWNV/XCdaNgNV/HBJ/RydqAoKKad4x8uvIGnrmVlnKvs6Q6t50cRs6
	2F7TnG2Apwc+5VOVWCm65XglvcXhyPHFDRBTYILFR5gymgGcjsL8IaYc6WvHZyObDEhk1W
	RK33oKdyIF40JBZkSccXxS7agSmisFo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=F2yxSYtM;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772262927; a=rsa-sha256;
	cv=none;
	b=fZTgiImxxgYUgG6m6+VPs5jDTa9XxcRlDtGqTNOuvHIV9yHxd9NGuFeBi8T/BkFGaojq94
	NuG0mMBhD+kvr9/n0U2EfQKLaLhgQ8dF4aMHgpHtUExwwwUFiWAvUXLq8B9VOt2cmg9Sw3
	5ozqxnl2OTRnohOgbyvHxl0HlXXItx8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GY7w9lG2hNjdddPK/8x1giPete9XsAMvnf7gDXNDb+Y=;
	b=F2yxSYtM126iXPXdt97LlTD02LO7RRIbC7ASktZs819acq4FuUmUfnDGPoEXJ5gfBqoq++I+U
	VDjuSx7eYE2bDrwHfE4kyrEq0bo0V6N7u9JZnmeORNH0RStBvhdzxjA5ALyY5zk4khG4RjBYism
	OW4U8djntX5MznrWT8xvruQ=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fNGYM6X91zcb1Z;
	Sat, 28 Feb 2026 15:10:15 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 041724056E;
	Sat, 28 Feb 2026 15:15:22 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 28 Feb
 2026 15:15:20 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>, <jgross@suse.com>,
	<conor.dooley@microchip.com>, <Jonathan.Cameron@huawei.com>,
	<riel@surriel.com>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC v3 4/4] mm: add PMD-level huge page support for remap_pfn_range()
Date: Sat, 28 Feb 2026 15:09:06 +0800
Message-ID: <20260228070906.1418911-5-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260228070906.1418911-1-yintirui@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0370DC000B
X-Stat-Signature: g3f3h5e4ejwphhodcf5wgkianeeac57o
X-Rspam-User: 
X-HE-Tag: 1772262926-140070
X-HE-Meta: U2FsdGVkX18Lh6xr+A2QBTxJjFlxEEqJESLNiK0iWlwbVt2uEh+h4MhQtKF7CvTypDy2EJXZFnsZ7+eRGlF6iWGL9wOap4e41vQELtYX1x34zTuW8dpLQsEeNUsRXrcDGoeImnq/keebeNV9vBjGB5nfaXDzBASHSn9GuTecmacEtJ7pG+b45m1e3jQBa2P6hUgb+fySY56tvTMfDdLoNYYmMs/t8Q3EH7fTpWIC5c/mpyA+jiHnH0q9FxD9qC2JJTOV2QrmZK8JZfQadTkQgZJZ8grQfo2EcmupySQqOY8NI7q72Q8PS9Wzo3hLUIonmbk5+mIDVIIkrAyLoFLfTbERUAgNrzGF57LZmO1Jek5zNM1aaKGPcRXliw+o3uLc99/4lytBp/I+Htr3DvY9Dyhg7nJ5O4nOKanQ6CuNrWfbkK9GjnBpN/JaxmwZtFtnfR+UJvAL7ATzS+N39t+0z1Y99q1T4l97vzoaCKXjjGO9f4z0FLaJJNPyMN9Rbc8zfRPT9k3tiw5Wnq3ejTP5nACcghJXLtlEsZFcQ8KQKmWDk1XwaKau71nD92t/O77QUr3Oml99flduqrlYK5VCKsiIXn22Yfi499AVp/A1U6g0x80UHc0XsNUGUQCbZrmiIaJvEuQ6TsmQ6ilUkY4S5GHfN+IMUenaWUp2surj7C0WN3dm8Fle/5zYN0+cElZbOpshD5Wx5C1Pybo+83QsBEtzQ/KYPsw6yHFAItgTZE5XJB/1r0mHHk1FgPNS3zeE6+Met5RZjdFXBkjAk4HrEFnwR+2RV0c2EU2OL+LDupqeG/RaDXnXl0CflwIsJtFipuR8cdMjfiYAFMm5KdtOpivLQyPo/Z4TO1udletPmm9+6cGbHglvzaBP+PDH8Nrknd+XQYvSnpFUUAt7K56Fpbg9VTbhNc9Jx5bfJuHk8KKWgK/MJm/4z18W7Sz64VuNNkv4Qrx9Y+f2kCek2y+
 5MBLUF5h
 vCe5TDsQSaM3j9HRw+Z0YugHJfsNUVLUxdB0/FKbHbjdFktuwOxfNw6x5pFFZo6h69/LzvypHECgs3WPCbWcjR229ElI7Cwahp8H8tPdBNzUMVDvA0X2yJdzn/UeyEghIQgUPnmMAwZ+5xhiiejZHF/H695PFmEUMA9vL96nfJxIHzFDtnpriVxS9OEQvuBCId21VckSB99SHb6lwHuy9bvbD3hWhp6lGXag2gUxiGB4S/VOuKyNz61v/N1mTZX5q8/xSyXkSM6D/jyQ432KQ4qTz/vkXv6Q1OWGtOSnogtFJi4toyFlHRw1YMsW4nBNsH7NOiH5/KXWZnbBmN/rHhITNt1//rJn8JyD/4RkYA4vf/UCGKFJac3ZKXQ==
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
huge mapping.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 mm/huge_memory.c | 36 ++++++++++++++++++++++++++++++++++--
 mm/memory.c      | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d4ca8cfd7f9d..e463d51005ee 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1857,6 +1857,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmd = pmdp_get_lockless(src_pmd);
 	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
 		     !is_huge_zero_pmd(pmd))) {
+		pgtable = pte_alloc_one(dst_mm);
+		if (unlikely(!pgtable))
+			goto out;
 		dst_ptl = pmd_lock(dst_mm, dst_pmd);
 		src_ptl = pmd_lockptr(src_mm, src_pmd);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
@@ -1870,6 +1873,12 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 * able to wrongly write to the backend MMIO.
 		 */
 		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
+
+		/* dax won't reach here, it will be intercepted at vma_needs_copy() */
+		VM_WARN_ON_ONCE(vma_is_dax(src_vma));
+
+		mm_inc_nr_ptes(dst_mm);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 		goto set_pmd;
 	}
 
@@ -2360,6 +2369,8 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+		if (pmd_special(orig_pmd))
+			zap_deposited_table(tlb->mm, pmd);
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
@@ -3005,14 +3016,35 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (!vma_is_anonymous(vma)) {
 		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+
+		if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+			pte_t entry;
+
+			if (!pmd_special(old_pmd)) {
+				zap_deposited_table(mm, pmd);
+				return;
+			}
+			pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+			if (unlikely(!pgtable))
+				return;
+			pmd_populate(mm, &_pmd, pgtable);
+			pte = pte_offset_map(&_pmd, haddr);
+			entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd));
+			set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
+			pte_unmap(pte);
+
+			smp_wmb(); /* make pte visible before pmd */
+			pmd_populate(mm, pmd, pgtable);
+			return;
+		}
+
 		/*
 		 * We are going to unmap this huge page. So
 		 * just go ahead and zap it
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
-			return;
+
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
 
diff --git a/mm/memory.c b/mm/memory.c
index 07778814b4a8..affccf38cbcf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2890,6 +2890,40 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	return err;
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+static int remap_try_huge_pmd(struct mm_struct *mm, pmd_t *pmd,
+			unsigned long addr, unsigned long end,
+			unsigned long pfn, pgprot_t prot)
+{
+	pgtable_t pgtable;
+	spinlock_t *ptl;
+
+	if ((end - addr) != PMD_SIZE)
+		return 0;
+
+	if (!IS_ALIGNED(addr, PMD_SIZE))
+		return 0;
+
+	if (!IS_ALIGNED(pfn, HPAGE_PMD_NR))
+		return 0;
+
+	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
+		return 0;
+
+	pgtable = pte_alloc_one(mm);
+	if (unlikely(!pgtable))
+		return 0;
+
+	mm_inc_nr_ptes(mm);
+	ptl = pmd_lock(mm, pmd);
+	set_pmd_at(mm, addr, pmd, pmd_mkspecial(pmd_mkhuge(pfn_pmd(pfn, prot))));
+	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	spin_unlock(ptl);
+
+	return 1;
+}
+#endif
+
 static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 			unsigned long addr, unsigned long end,
 			unsigned long pfn, pgprot_t prot)
@@ -2905,6 +2939,12 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 	do {
 		next = pmd_addr_end(addr, end);
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+		if (remap_try_huge_pmd(mm, pmd, addr, next,
+				pfn + (addr >> PAGE_SHIFT), prot)) {
+			continue;
+		}
+#endif
 		err = remap_pte_range(mm, pmd, addr, next,
 				pfn + (addr >> PAGE_SHIFT), prot);
 		if (err)
-- 
2.22.0


