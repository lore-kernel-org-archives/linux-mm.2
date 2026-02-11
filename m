Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E74EB2700
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 10:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EBCD6B008A; Wed, 11 Feb 2026 05:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3236B008C; Wed, 11 Feb 2026 05:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5086B0092; Wed, 11 Feb 2026 05:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8AE6B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:32:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30EAB8B300
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:32:29 +0000 (UTC)
X-FDA: 84431811618.18.A89C01E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6980F10000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:32:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGmYLPza;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770805947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/aoERoFOXeyXFOhhLJsMp5W5sgybP/LbxdaeC99ppY=;
	b=JVLBEe0Xy2DnPgh0tmVGIEvMY8hpnXehWAxtcEaVW59Xt7dxzTw38oy+abIz6i1bwc2nWv
	ElX3diJW7SKjFFDRdxHr9/mD07BgAIES37cdEZytRmJ3id7BTJhSbO30PT4osbmLw3q4Am
	MHFFDgujXWodlgXZgHcJUjotS2Djiqk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FGmYLPza;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770805947; a=rsa-sha256;
	cv=none;
	b=8WY2IzL1nhjo1SVVBZOH0o00Q7QAJgqdhytL9/WBDSiKsLaEqnBaT1zUv2QKHO/rn9K63F
	0czENrVnufQW0qNGJetfJpAvg3t8n8M/Pd/slvRFVy5OmHaQEqK4a0fOvqz2X6KWik4yXN
	amyjR0wU49pwInlSqioGxpi9K/7MehY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70BAB43D75;
	Wed, 11 Feb 2026 10:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0801C19421;
	Wed, 11 Feb 2026 10:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770805946;
	bh=vA/knfi9Vhxszewnk92IVn+RVqoIT2RuM5wYLPxphtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGmYLPzap419hKTlPDkD/m287e04gxg4KUE3Smz/Q3EHWjE3x0qsYIQPSqIQvKK6A
	 L3MC18Ziq6Lsh6Ep0ugSBryw7Z8iReRdnJuR0GI/TrybYKkD/vPJ7zvRCN2CH1KKoR
	 S9x9odwqLsqrL8gVaOfxIEGjSc9aFj4LGTZu2tmElRXBv6iR/XK/YW9Ep/4P+dSSuX
	 8vXc/Yd/qmfdhwXBWbK50HNKVw8/2k1p50eKv08cfKIgYMyFkPTwsh/YuuybqGUS03
	 c39jhM0A4IPodmm2YwEfQoQpOZ0WrZwf+x9JGCCafPcxAdqlTrAbApI1qukK+k6ADk
	 ESHxl1GPy56oA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v3 2/4] mm: rename my_zero_pfn() to zero_pfn()
Date: Wed, 11 Feb 2026 12:31:39 +0200
Message-ID: <20260211103141.3215197-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211103141.3215197-1-rppt@kernel.org>
References: <20260211103141.3215197-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6980F10000C
X-Stat-Signature: iiuzs4ubrqacm5np9hk4p6djp1yeueub
X-Rspam-User: 
X-HE-Tag: 1770805947-888465
X-HE-Meta: U2FsdGVkX1+SWxaRkAvVNvcncEBZjtOmV2KZOfRx2vVu3TRl7YlkzYjOlWMN89Ig7VxxDLsEjcy6jl5ViGa0om0T2vbOBdSZDIvPKCeFBj1dFRG3J7vQ5jEdSxqxXMAF2ooedkVWjBBpd1/AWDB+u3n+46r7Ewt7T6UgvCpuLou+ICNfr9FAXZxjYfmvdO4DMjUKaVNZ3XhboEhkRs4ZwsMygOkRIURJMKI7EM7/OZ18NyGKtGx6IY7g9hfCUQXDFbyts+XgP2J66uTmgcOAzkmGG9kvi7uCgR48McRcbnv1V1WuWv3J/fkDWImvL+rkPq5LY2Ui6l56WL5OfFcUc5ubXbktZbWKdIcWgkrYc8XmTnZNP06kBNSB+RnlQiWaXaQXrkvPciALcEkGpBYKWxrIcs4cUs2tc60SJ29ypJ63/K1UBqL4cUehXe11B5drWyCMP4NzScdg0ELHuQJDdNhRTmxauZ+2pG4ts2eDzmXBlVSMJzoAQjqSMw/OSLz2yZk3N8Mty5vPfAghFNmn2C4//YccBfSUHiRSF5DSZMCKzTjbPHC/yVeDQYPx38dklytU4b2j7lPBzpfd4mVOmlZJuWJVBzgEBs59gW5xS1pPT/Wn0KOditzMEGDq1TaPwEWyVGFjz+v3UOn9P5fZVz21x6jrWrwZaWk+F4wcFOqY6jUk/itDFghafpmf4KyVO/OJDSICtq5DnJ45fP1+KkB0g5QpJdGMnKq3BtJOxsWMVP5ciVDBVq2839+imkYUZphTjX84ivbdxOjKwZxZ2fB7bawFzNZM9ryUk4jv2tkDUCSC27JnxTZ2wF2rEb6E8/mhr/VgxVieQ48MA2/4u0hIJs+Nhq4WYVhVSRtQMkCtmbC+SOptddms79tRXxAuEVOW0jP3+2ZDmObGJYHoeckiBQXm0cjBhZok1wlK3h+aI70Az+DixJ3yyXC/9x330mgG9e2B0xzcjMeDqpN
 lNZ3U1vw
 aWQNta8aE5gFeLP/HYOV3npOyaaKXkb4yp4TR+5l1uM28Yw/vrLPlytp27Wem1uRUnOzbRpalNHnqg3dnU4gWyWvqq1eNQJb1v/rkSYlu4y5/npi0vuSeKnKw5F3Uee8H0E37caoyaifWbFCvvlfvdAMUcjbxSfMp9jMPozPd7LKffspGdYeHCmVvpoo2DQoIv0AF+Ehk24HraIWjOiqDtvaCcK12gWkFjf+4XkTZJSdT+MPbyHIblLqlBGK8I95AJExg6ptKKQHBhNdC+brA7lf9Ntp2UFUM9UOk4YWZLQCenR1QxLo+0m32NB6zwNOae3Ea
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

my_zero_pfn() is a silly name.

Rename zero_pfn variable to zero_page_pfn and my_zero_pfn() function to
zero_pfn().

While on it, move extern declarations of zero_page_pfn outside the
functions that use it and add a comment about what ZERO_PAGE is.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/kvm/mmu/spte.h |  2 +-
 fs/dax.c                |  2 +-
 fs/proc/vmcore.c        |  2 +-
 include/linux/pgtable.h | 28 ++++++++++++++++++++--------
 mm/huge_memory.c        |  2 +-
 mm/memory.c             |  2 +-
 mm/migrate.c            |  2 +-
 mm/mm_init.c            | 10 +++++-----
 mm/userfaultfd.c        |  4 ++--
 9 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 91ce29fd6f1b..8c0ffa2cded6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -248,7 +248,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
 static inline hpa_t kvm_mmu_get_dummy_root(void)
 {
-	return my_zero_pfn(0) << PAGE_SHIFT;
+	return zero_pfn(0) << PAGE_SHIFT;
 }
 
 static inline bool kvm_mmu_is_dummy_root(hpa_t shadow_page)
diff --git a/fs/dax.c b/fs/dax.c
index 289e6254aa30..b78cff9c91b3 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1360,7 +1360,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 {
 	struct inode *inode = iter->inode;
 	unsigned long vaddr = vmf->address;
-	unsigned long pfn = my_zero_pfn(vaddr);
+	unsigned long pfn = zero_pfn(vaddr);
 	vm_fault_t ret;
 
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, DAX_ZERO_PAGE);
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index f188bd900eb2..44d15436439f 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -525,7 +525,7 @@ static int remap_oldmem_pfn_checked(struct vm_area_struct *vma,
 {
 	unsigned long map_size;
 	unsigned long pos_start, pos_end, pos;
-	unsigned long zeropage_pfn = my_zero_pfn(0);
+	unsigned long zeropage_pfn = zero_pfn(0);
 	size_t len = 0;
 
 	pos_start = pfn;
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 08a88b0d56e5..9bacf4df9769 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1882,27 +1882,39 @@ static inline void pfnmap_setup_cachemode_pfn(unsigned long pfn, pgprot_t *prot)
 	pfnmap_setup_cachemode(pfn, PAGE_SIZE, prot);
 }
 
+/*
+ * ZERO_PAGE() is global shared page(s) that is always zero. It is used for
+ * zero-mapped memory areas, CoW etc.
+ *
+ * On architectures that __HAVE_COLOR_ZERO_PAGE there are several such pages
+ * for different ranges in the virtual address space.
+ *
+ * zero_page_pfn identifies the first (or the only) pfn for these pages.
+ */
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
 {
-	extern unsigned long zero_pfn;
-	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
+	extern unsigned long zero_page_pfn;
+	unsigned long offset_from_zero_pfn = pfn - zero_page_pfn;
+
 	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
 }
 
-#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
+#define zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
 
 #else
 static inline int is_zero_pfn(unsigned long pfn)
 {
-	extern unsigned long zero_pfn;
-	return pfn == zero_pfn;
+	extern unsigned long zero_page_pfn;
+
+	return pfn == zero_page_pfn;
 }
 
-static inline unsigned long my_zero_pfn(unsigned long addr)
+static inline unsigned long zero_pfn(unsigned long addr)
 {
-	extern unsigned long zero_pfn;
-	return zero_pfn;
+	extern unsigned long zero_page_pfn;
+
+	return zero_page_pfn;
 }
 #endif /* __HAVE_COLOR_ZERO_PAGE */
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 44ff8a648afd..bc15fd152526 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2968,7 +2968,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 		pte_t entry;
 
-		entry = pfn_pte(my_zero_pfn(addr), vma->vm_page_prot);
+		entry = pfn_pte(zero_pfn(addr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
 		if (pmd_uffd_wp(old_pmd))
 			entry = pte_mkuffd_wp(entry);
diff --git a/mm/memory.c b/mm/memory.c
index 51d2018a387a..ae610afa9cea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5165,7 +5165,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	/* Use the zero-page for reads */
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm)) {
-		entry = pte_mkspecial(pfn_pte(my_zero_pfn(vmf->address),
+		entry = pte_mkspecial(pfn_pte(zero_pfn(vmf->address),
 						vma->vm_page_prot));
 		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				vmf->address, &vmf->ptl);
diff --git a/mm/migrate.c b/mm/migrate.c
index 1bf2cf8c44dd..739c4e03769b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -321,7 +321,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	if (!pages_identical(page, ZERO_PAGE(0)))
 		return false;
 
-	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
+	newpte = pte_mkspecial(pfn_pte(zero_pfn(pvmw->address),
 					pvmw->vma->vm_page_prot));
 
 	if (pte_swp_soft_dirty(old_pte))
diff --git a/mm/mm_init.c b/mm/mm_init.c
index dcf9eff34f83..a0ca236eb4f5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -53,8 +53,8 @@ EXPORT_SYMBOL(mem_map);
 void *high_memory;
 EXPORT_SYMBOL(high_memory);
 
-unsigned long zero_pfn __ro_after_init;
-EXPORT_SYMBOL(zero_pfn);
+unsigned long zero_page_pfn __ro_after_init;
+EXPORT_SYMBOL(zero_page_pfn);
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
 int __meminitdata mminit_loglevel;
@@ -2670,12 +2670,12 @@ static void __init mem_init_print_info(void)
 		);
 }
 
-static int __init init_zero_pfn(void)
+static int __init init_zero_page_pfn(void)
 {
-	zero_pfn = page_to_pfn(ZERO_PAGE(0));
+	zero_page_pfn = page_to_pfn(ZERO_PAGE(0));
 	return 0;
 }
-early_initcall(init_zero_pfn);
+early_initcall(init_zero_page_pfn);
 
 void __init __weak arch_mm_preinit(void)
 {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 927086bb4a3c..e19872e51878 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -357,7 +357,7 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
 	if (mm_forbids_zeropage(dst_vma->vm_mm))
 		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
 
-	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
+	_dst_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
 	ret = -EAGAIN;
 	dst_pte = pte_offset_map_lock(dst_vma->vm_mm, dst_pmd, dst_addr, &ptl);
@@ -1229,7 +1229,7 @@ static int move_zeropage_pte(struct mm_struct *mm,
 		return -EAGAIN;
 	}
 
-	zero_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
+	zero_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
 	ptep_clear_flush(src_vma, src_addr, src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
-- 
2.51.0


