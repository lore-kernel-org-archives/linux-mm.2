Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 473CCCCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790808E0006; Thu, 16 Oct 2025 07:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7408F8E0003; Thu, 16 Oct 2025 07:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656638E0006; Thu, 16 Oct 2025 07:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50D238E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:33:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB672580F3
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:33:21 +0000 (UTC)
X-FDA: 84003766602.19.AC0B8C5
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf10.hostedemail.com (Postfix) with ESMTP id 810CEC000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:33:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=S9aEoxsh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760614400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8/Q9I7t7Qi4x/ZrI5Kaz0t842MDdUKD3sBtEPlbIMk=;
	b=tm7zsOKl89SaTmHpR+Pnc6qKD3mOGMHuk6C5vLQc7ve5oCGIBlnhw2qROHRryOgh5FnrK3
	w/LItko+jqgAB+GZj6tFYMlCR7/JWeOrLq08M2mHFjP6wMYv/WRWubrjT0wMJzg0VUiyxO
	YBUd9VUawao/QTmrCARS31LW4ZqGows=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760614400; a=rsa-sha256;
	cv=none;
	b=KfDTJOkkGrUlp1sNCu/KXGr5lKrV/qlyhq+h/v7oATvQiUZiamz1ZQe9V9UMTksN6HTgVm
	Zhwd9sL8CIHCF6Yrz8TbFS+izKcCRFygzMuTxT3ZCrlPG4SpErIgpbku7OLhXLUBCRI6Iv
	D7exthQAaxx5gJtwjiU6m4ddq7ofSDM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=S9aEoxsh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yintirui@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=I8/Q9I7t7Qi4x/ZrI5Kaz0t842MDdUKD3sBtEPlbIMk=;
	b=S9aEoxshqgJ1DGVDyxEs704Lhfm/eP0YArwn6D7TVeJAzSaVZleG2UL/AteUOOOW1+p0/dpR1
	RIEMjxyngwhUFbMkJMvey91qwrJiQwRo+BFSLN3X0uTmdncij78NRBLOfh7FmW61eP/8lMha7Rq
	yhIYbwtgEzbjRnQW1uMkw60=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4cnQmj57QwzLlVc;
	Thu, 16 Oct 2025 19:32:53 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id A4CE61A0188;
	Thu, 16 Oct 2025 19:33:14 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 16 Oct
 2025 19:33:13 +0800
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
Date: Thu, 16 Oct 2025 19:27:04 +0800
Message-ID: <20251016112704.179280-3-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251016112704.179280-1-yintirui@huawei.com>
References: <20251016112704.179280-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam01
X-Stat-Signature: t69a7o7376a76a4659o1ka6mgeua7k3u
X-Rspam-User: 
X-Rspamd-Queue-Id: 810CEC000A
X-HE-Tag: 1760614398-687502
X-HE-Meta: U2FsdGVkX18PdFZuQUKo1zRudjYXi9jNsFsU8PcQWCkrEH2gJD5gEIS5hGNtCV7DnyCQeyohd/dJkQXHoMaGUIEE/MsFOgwGsBBWCmV1XCWxiQZnlEgKynvOy5ZHLSDqhBRLM0l01dJN5PufmhPSqobJTwe0qiMoAscgZ1ft/lbpzfY9uj7UtoqpQW29/dezJNAT5hkEoGmYPFJ9P860V1+NB7hTyeH/Pi/HCVyYqtqZyvSAMiMwR14ecNiDTLUX6a2HyALDu3iwwtxC+03HsWu1GYtMeYUVRDd4ASpXActLfmdUc1eOjTvBoq4EONDvYvXa3eLNeRL9pQlrUZMDHJ04xsVMYZm/NiI0a5lUyeaGv/KSfPjEqY+iWM3z0kwBMAVt4XW/L10FazB5xkMOw6l3eVW+/tX7nNrfC2EJMtc44eVrG97Uqr+wuuNAOw8S3090BxUuak+HowiRnMuMfyHXwU0toJRikQwU8tJYhZ7sFvf+nFMl8JenY9nBCp7ky0v2JJPCI8foXAz4JC4Z2maLJuRIO7Gf0KRes0wcDe9EisRZ9pKMUM9mTf73N07eCvu7WsmsstdsSdSDEZMmT3/0ixFFG/zNSO2/nB5mZ+3ArpolPNihLUllGvj1J7TgD0IP9Ms1EonCponZ6hiCEJbXiK17DqJGX6Nj2iYIZXe6MM8/4LfNQXRuTI6nckgk6pNusuyiK0han3BqG+lxJkMUIgF4j1kIt1p0uT4RIf6ro0gNQa3A9T6kXaA7DykHRXkXjWk8hxLkOWpzH7qy0VVucjYueTCGueRM3xmr99duIQr24KYOQY0VWDf3eaqLIqhBjKpz7lA10bwhcg+wBGcIJhJAtuDTeqcARqL6rAJBLwFwzPMZy0HmaBd1S3hZlhebs96XBTg3NpHmApJfAu9DxOJBefTwMDLDqsCKjIXKEqjO3LmPcRvT5tvxDcO/N/jXntQ6KKPpjuxGB4l
 KN8I8R6J
 7yuXW0W40eC0JVCFmC2sW/WDPZF8SuAaWe7BLjZqXB+E82sIWgMD782urCBNjJt/T4UgHBYXLcZNXMic=
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

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 include/linux/pgtable.h |  6 +++++-
 mm/huge_memory.c        | 26 +++++++++++++++++++-------
 mm/memory.c             | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 25a7257052ff..9ae015cb67a0 100644
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
index 9c38a95e9f09..b5eecd8fc1bf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2857,14 +2857,26 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
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
+		} else if (arch_needs_pgtable_deposit()) {
+			/* Zap for the non-special mappings. */
+			zap_deposited_table(mm, pmd);
+		}
+
 		if (unlikely(is_pmd_migration_entry(old_pmd))) {
 			swp_entry_t entry;
 
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..4e8f2248a86f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2705,6 +2705,40 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
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
@@ -2720,6 +2754,12 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
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
2.43.0


