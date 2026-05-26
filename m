Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D0CECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AE16B00D8; Tue, 26 May 2026 10:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C796B00DA; Tue, 26 May 2026 10:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B2B6B00DC; Tue, 26 May 2026 10:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7256B00D8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:56:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E15C440142
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:25 +0000 (UTC)
X-FDA: 84809871930.24.15E3D47
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf13.hostedemail.com (Postfix) with ESMTP id 849B520013
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="CR/mU79d";
	spf=pass (imf13.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9KVwVo2Cm4f4rYBWd0AF4RdxTPXu9UJm3DZXHV1hSk=;
	b=CQ020A1B0XHL8DQ45zqwT/s55vA5YT9WncnnpiAR/HEAYgIMiGffGNV7550Pa9Q0bu3IrK
	cy6ON4C2Z8L0DVrGocfSLAWzSQ7ZrTH7ukurJXN4yepp79cvBpQdQSHHuKBOUf7Q9IMSM3
	DvZzBw9rcoOwHWKWzMXdEzz0k+GUB50=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="CR/mU79d";
	spf=pass (imf13.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779807384; a=rsa-sha256;
	cv=none;
	b=r+GuHy1GZXZAu7TmRVItnjN9leAKmH5Xj3zV+dVNpdYC9QMZzhGB5xM5m8eMrj4fT6z88x
	DW7g3MwjTisCiT3iMpQ6o7K2vUgBRFAYW/npn+V/KKRzT3qNU1TAkbW9kPmo3ynt8STpJV
	8e3egl0AMlB+ttsoYWuntv7VNFqVbKA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=k9KVwVo2Cm4f4rYBWd0AF4RdxTPXu9UJm3DZXHV1hSk=;
	b=CR/mU79d0PRk0JiMm+3Bz8ydmIH42L8XRQ5l/1mx34szLa8TeL9FDoHeIzGpUof1CeyHqV1uo
	MiMAzDnrdroxqRe8tboa8teu1VRpNr2pbt00sMv5yTUngQDbQorn/c8WgUYfzFhtNbbmPTL1rES
	BykeJAQlxO0hm/dE9NVpZho=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gPwc33yv6z1cyNp;
	Tue, 26 May 2026 22:48:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C67340539;
	Tue, 26 May 2026 22:56:19 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 22:56:17 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<ljs@kernel.org>, Juergen Gross <jgross@suse.com>, Jonathan Cameron
	<jic23@kernel.org>, Will Deacon <will@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Peter Xu <peterx@redhat.com>,
	Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth
	<thuth@redhat.com>, Coiby Xu <coxu@redhat.com>, Dan Williams
	<djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Conor Dooley <conor.dooley@microchip.com>, Rik
 van Riel <riel@surriel.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <yintirui@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-pm@vger.kernel.org>
Subject: [PATCH mm-unstable RFC v4 7/7] mm: add PMD-level PFNMAP support for remap_pfn_range()
Date: Tue, 26 May 2026 22:50:03 +0800
Message-ID: <20260526145003.88445-8-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526145003.88445-1-yintirui@huawei.com>
References: <20260526145003.88445-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: 8mzwjue9r17xiydypaego6tywbtsm6yq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 849B520013
X-HE-Tag: 1779807383-76170
X-HE-Meta: U2FsdGVkX1+cOLQzpgShy+TmUG697JwIETwDLy+ezbhW2JUnEdKj0fEgvcQCkDpi9FYS9zoxBe1JOCaMClqVf18l9Kg3iqluRZ/3IoPZ6byb0bVcLJmZZfd/5r6BeJUD8KyLVfXlKUWnO8t2C9+zF3LpOCpA0nJFx4tH3KShiQyIe4dEFXbrw1qiTSLEh69Aosi85O0FaqoMoQtFqH69dfM4eztFwzLXI+2k/gPc4vO2v5VkVjEbLZnhofAMXsr5uCbNqU5e8ploHkr+poEFFavGWdcO9yxQPJCBREd5EB7eVClMWwvqQuan6/tGfpjFB3zxJy1kIu7ShEx3/yASXCYDxpOcjm6ll461iDwPdKNy2PGypW+dbMMo16F5en1+yh3sltXfmPpFmAfOE4cxSyWjxfS8mGjefYedNu2wQOW0p4hqN9LZfv7vv1NM5i6QLrF4VLxPv54EAKtyWtkTysIj4+e9C80xeWlf5X8HvNM5ffWwntFaZ9t+uCzNq9lE7/zaGzRW9EmPWj32ePeFw2NI72jQYU9iiT27kZepLFk2kbtb+xFgDaIjvMiH8g8FsFMFaTJNKpCEMXWkLbWD5ZqxJrvct/JZDZ1FDFVzw0rJxXCE8QvS0lO/nNXe/gzaZyI9MTVVS0N3vRdPti3ROzvZIVskndTBWLBm3KE0cQDVvji1r95xH6dbslJE7ffP8InlQRvC3AOBdPmbeKndALBOqdsKBoOKEMqaXc+X3IWOYVwp8hWrqjAOzfwOsQx8bboVBnNjNDPjUO+R/+Xy8UlA0nRIvQ6K/aAXyip25whGk7VvtxJP3wugVWfzg7Vz5XXqaeUxqzX+LQ5+T62flpWBVKn+Oh+JMad320lei4GGX9EEGCgUh2MDqb9duE2o7XUwoioGAiVNKTJiHxFJXm3WmwsGV5f5AznGCSat+YV7Cyn/ZbvE9zojuPckypX2ktL44NbpLdTWQrOeQmC
 16mScN7C
 lZfGtV8GUW+SxIZLgGQxJbwgvmm1YA8Rp7iJbfvKa6pmUvo+Xh95AtczwVaVlNUFy5jP9OLEu4SrVuEzE0vJeJIcxJq08EfJYM7KtUD4QRwDvI0MRGo/6SIlZIaptGbR8xZTnZNs/k6H5WUdn3jSHYBItMRKPONCpmvmuefnofaAKfkg417nO/BYAPu+L/V6JBXsbgj3dPuxkoCtFxjlktnd6hTHO6uf9kBoMgLSJLVziUMd+TzlkS9SigfSCnWZrThiYBSfNIt6NMODg/ABH6c9jE435dFwl9uIxgpkAteik+S1Wj4xw9u/cpT3C3u8+GRe3z/vIKi3/517WRdafSo2sATEqqL3OeuqZXJw0iWbSInFnPqLCZ1eghAMaKIGEENgvQHAqR8+Rcdw2a+hi4hj45QAVtwnO/HXag44Ay9VoQYn5MDtPe4noaLb2IbOFzRDOsWneyQN+nUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach remap_pfn_range() to install PMD-sized PFNMAP entries when the
virtual range and PFN are PMD-aligned, the architecture exposes PMD
PFNMAP support, and PMD leaves are available at runtime. The path only
runs on VMAs without ->fault or ->huge_fault, so the resulting PMDs
are known to be non-refaultable.

Non-refaultable PFNMAP PMDs cannot be rebuilt on demand and are
therefore installed with a deposited pgtable.
vma_pfnmap_has_deposited_pgtable() becomes the common predicate driving
the deposit logic in copy_huge_pmd(), zap_huge_pmd() through
has_deposited_pgtable(), and the new __split_huge_pfnmap_pmd().

The split path withdraws the pgtable and populates it with special PTEs
derived from the original PMD using pmd_pfn() and pmd_pgprot(). With
pmd_pgprot() returning PTE-level pgprot_t, this preserves protection and
cache attributes without reintroducing pte_clrhuge().

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 mm/huge_memory.c | 60 ++++++++++++++++++++++++++++-----
 mm/internal.h    | 21 ++++++++++++
 mm/memory.c      | 87 +++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 148 insertions(+), 20 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index be9b637c813b..19e6d856e8bf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1879,6 +1879,8 @@ bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
+static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
+		struct folio *folio);
 static int copy_present_huge_pmd(
 		struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
@@ -1912,8 +1914,12 @@ static int copy_present_huge_pmd(
 		 * able to wrongly write to the backend MMIO.
 		 */
 		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
-		pte_free(dst_mm, pgtable);
-		pgtable = NULL;
+
+		if (!has_deposited_pgtable(dst_vma, pmd, NULL)) {
+			pte_free(dst_mm, pgtable);
+			pgtable = NULL;
+		}
+
 		wrprotect = false;
 		goto set_pmd;
 	}
@@ -2495,11 +2501,19 @@ static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
 	if (is_huge_zero_pmd(pmdval))
 		return !vma_is_dax(vma);
 
+	/*
+	 * PMD-sized PFNMAP mappings installed without fault handlers cannot be
+	 * refaulted after the PMD is cleared, so they carry a deposited page
+	 * table for later partial unmap/mprotect.
+	 */
+	if (!folio)
+		return pmd_present(pmdval) && vma_pfnmap_has_deposited_pgtable(vma);
+
 	/*
 	 * Otherwise, only anonymous folios are deposited, see
 	 * __do_huge_pmd_anonymous_page().
 	 */
-	return folio && folio_test_anon(folio);
+	return folio_test_anon(folio);
 }
 
 /**
@@ -3118,6 +3132,32 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	pmd_populate(mm, pmd, pgtable);
 }
 
+static void __split_huge_pfnmap_pmd(struct vm_area_struct *vma,
+		unsigned long haddr, pmd_t *pmd)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pgtable_t pgtable;
+	pmd_t old_pmd, _pmd;
+	pte_t *pte, entry;
+
+	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+	if (!has_deposited_pgtable(vma, old_pmd, NULL))
+		return;
+
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pmd_populate(mm, &_pmd, pgtable);
+
+	pte = pte_offset_map(&_pmd, haddr);
+	VM_BUG_ON(!pte);
+
+	entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd));
+	set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
+	pte_unmap(pte);
+
+	smp_wmb(); /* make pte visible before pmd */
+	pmd_populate(mm, pmd, pgtable);
+}
+
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
@@ -3157,11 +3200,12 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 				return __split_huge_zero_page_pmd(vma, haddr, pmd);
 			}
 
-			/* Present but not a normal folio: drop the PMD. */
-			old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
-			if (arch_needs_pgtable_deposit())
-				zap_deposited_table(mm, pmd);
-			return;
+			/*
+			 * Present PMDs without a normal folio are special mappings. Huge zero PMDs
+			 * are handled above; the remaining PMD-level special mappings are PFNMAP
+			 * mappings.
+			 */
+			return __split_huge_pfnmap_pmd(vma, haddr, pmd);
 		}
 
 		if (unlikely(!folio_test_anon(folio))) {
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..f82bd987131d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -198,6 +198,27 @@ static inline void vma_close(struct vm_area_struct *vma)
 	}
 }
 
+static inline bool vma_has_fault_handler(const struct vm_area_struct *vma)
+{
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
+
+	return vm_ops && (vm_ops->fault || vm_ops->huge_fault);
+}
+
+/*
+ * PMD-sized PFNMAP mappings installed without fault handlers cannot be
+ * recreated after the PMD is cleared. Such mappings need a deposited page
+ * table so they can be split into PTEs for partial unmap/mprotect.
+ *
+ * Faultable PFNMAP VMAs can drop the PMD and refault it later, so they do
+ * not need a deposited page table.
+ */
+static inline bool
+vma_pfnmap_has_deposited_pgtable(const struct vm_area_struct *vma)
+{
+	return vma_test(vma, VMA_PFNMAP_BIT) && !vma_has_fault_handler(vma);
+}
+
 /* unmap_vmas is in mm/memory.c */
 void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
 
diff --git a/mm/memory.c b/mm/memory.c
index 56886d1ddaf3..226e3a53a48e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2943,9 +2943,66 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	return err;
 }
 
-static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
-			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
+static int remap_try_install_pmd_leaf(struct mm_struct *mm,
+		pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, unsigned long pfn, pgprot_t prot)
+{
+	pgtable_t pgtable;
+	spinlock_t *ptl;
+	unsigned long i;
+	pmd_t entry;
+
+	if (!pgtable_level_has_pxx_special(PGTABLE_LEVEL_PMD))
+		return 0;
+
+	if (!pgtable_has_pmd_leaves())
+		return 0;
+
+	/*
+	 * Do not install PMD leaves through remap_pfn_range() for VMAs that have
+	 * a fault handler. With this restriction, a PFNMAP PMD in a VMA without
+	 * a fault handler is known to have been installed by remap_pfn_range()
+	 * and to have a deposited page table for later split; see
+	 * vma_pfnmap_has_deposited_pgtable().
+	 */
+	if (vma_has_fault_handler(vma))
+		return 0;
+
+	if (!IS_ALIGNED(addr | end, PMD_SIZE))
+		return 0;
+
+	if (!IS_ALIGNED(PFN_PHYS(pfn), PMD_SIZE))
+		return 0;
+
+	for (i = 0; i < PFN_DOWN(PMD_SIZE); i++) {
+		if (!pfn_modify_allowed(pfn + i, prot))
+			return -EACCES;
+	}
+
+	pgtable = pte_alloc_one(mm);
+	if (unlikely(!pgtable))
+		return 0;
+
+	ptl = pmd_lock(mm, pmd);
+	if (!pmd_none(*pmd)) {
+		spin_unlock(ptl);
+		pte_free(mm, pgtable);
+		return 0;
+	}
+
+	entry = pfn_pmd(pfn, prot);
+	entry = pmd_mkspecial(entry);
+	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	mm_inc_nr_ptes(mm);
+	set_pmd_at(mm, addr, pmd, entry);
+	spin_unlock(ptl);
+
+	return 1;
+}
+
+static inline int remap_pmd_range(struct mm_struct *mm,
+		struct vm_area_struct *vma, pud_t *pud, unsigned long addr,
+		unsigned long end, unsigned long pfn, pgprot_t prot)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -2958,6 +3015,12 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 	do {
 		next = pmd_addr_end(addr, end);
+		err = remap_try_install_pmd_leaf(mm, pmd, vma, addr, next,
+				pfn + (addr >> PAGE_SHIFT), prot);
+		if (err < 0)
+			return err;
+		if (err > 0)
+			continue;
 		err = remap_pte_range(mm, pmd, addr, next,
 				pfn + (addr >> PAGE_SHIFT), prot);
 		if (err)
@@ -2966,9 +3029,9 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
 	return 0;
 }
 
-static inline int remap_pud_range(struct mm_struct *mm, p4d_t *p4d,
-			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
+static inline int remap_pud_range(struct mm_struct *mm,
+		struct vm_area_struct *vma, p4d_t *p4d, unsigned long addr,
+		unsigned long end, unsigned long pfn, pgprot_t prot)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -2980,7 +3043,7 @@ static inline int remap_pud_range(struct mm_struct *mm, p4d_t *p4d,
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		err = remap_pmd_range(mm, pud, addr, next,
+		err = remap_pmd_range(mm, vma, pud, addr, next,
 				pfn + (addr >> PAGE_SHIFT), prot);
 		if (err)
 			return err;
@@ -2988,9 +3051,9 @@ static inline int remap_pud_range(struct mm_struct *mm, p4d_t *p4d,
 	return 0;
 }
 
-static inline int remap_p4d_range(struct mm_struct *mm, pgd_t *pgd,
-			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
+static inline int remap_p4d_range(struct mm_struct *mm,
+		struct vm_area_struct *vma, pgd_t *pgd, unsigned long addr,
+		unsigned long end, unsigned long pfn, pgprot_t prot)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -3002,7 +3065,7 @@ static inline int remap_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		err = remap_pud_range(mm, p4d, addr, next,
+		err = remap_pud_range(mm, vma, p4d, addr, next,
 				pfn + (addr >> PAGE_SHIFT), prot);
 		if (err)
 			return err;
@@ -3049,7 +3112,7 @@ static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long ad
 	flush_cache_range(vma, addr, end);
 	do {
 		next = pgd_addr_end(addr, end);
-		err = remap_p4d_range(mm, pgd, addr, next,
+		err = remap_p4d_range(mm, vma, pgd, addr, next,
 				pfn + (addr >> PAGE_SHIFT), prot);
 		if (err)
 			return err;
-- 
2.43.0


