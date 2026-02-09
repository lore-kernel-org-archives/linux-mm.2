Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA7B1E81BCF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1AD6B00B1; Mon,  9 Feb 2026 09:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D988D6B00B3; Mon,  9 Feb 2026 09:41:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2126B00B4; Mon,  9 Feb 2026 09:41:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAD016B00B1
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:41:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C0841BFE9
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:41:41 +0000 (UTC)
X-FDA: 84425182002.25.36D9B82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B65158000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:41:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IoiSaopD;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770648099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHeTYlrnqQ8tIjmWDSX04No3xBlUEI/t591IknV/v6Y=;
	b=pk+VIJS+pTGQE7RsgaGmZU6RTbVzWbb1ofOfmRwQqGxRDO+Pzb7THSwxh8S3pvaAjhFtb5
	330jANupwnC5J4Z/uwKpikEv01sYXYa/zEniX6nHOd799otop5fZvZUfJ6wNtnHI79+e6d
	XnjhKP/aNE3noFaGc11iibAwMCCeyhE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IoiSaopD;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770648099; a=rsa-sha256;
	cv=none;
	b=ylZR/ixYZiZYFiMa2Qhsh50q+bs97HrZEGZnZ05DIbk+UylssYB/RX/SWurG8yJhDn7rcf
	IUVIn+O+p3Na8D+qoDqEUlZY/HUlZhsdoX1N0dO40h2tHOfauzHHsFyf4k8JaphRiAA1yD
	dX9p5WVxbKQtvSVggTf1sFzNwhknyBo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4700460008;
	Mon,  9 Feb 2026 14:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D57DC116C6;
	Mon,  9 Feb 2026 14:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770648099;
	bh=dIkOhzWY1xuDq5ewEz/XDIyATuNWlEhxlmAB0qWidMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoiSaopDKfrfSZ7+rlBU8LjocFAFB8EJgAVaUZ/W+cBxwixSmGT1x/E8BIkMkjYP8
	 SzhptbW3ELmnRGgPqG0GC6S3X5YQ0NFlsp7/MwlGEwmonjJfjX36w6Zrid+02MdXYD
	 aD13CKitrIkfiTc+tMswjO0GZ7FkCVjL6pg6DrkfeYhc3cdJymj5D1FMzCONDpjNPt
	 CRTH696/5neg33D9wpXGgfmmIGyqUJnxX11v6uXDMEkOIdpDtKcYEzjVktAE2R8WVo
	 jD3MvmL5DA+h5y6UTuTlFtK2d3SzKn7oXhmb/Hq02WBSEx3CHrl4//hhcmH0UMQ0G3
	 Ad/W6NbiDr+Ig==
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
Subject: [PATCH v2 2/4] mm: rename my_zero_pfn() to zero_pfn()
Date: Mon,  9 Feb 2026 16:40:55 +0200
Message-ID: <20260209144058.2092871-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209144058.2092871-1-rppt@kernel.org>
References: <20260209144058.2092871-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B65158000D
X-Stat-Signature: 7m61tbwrg34ousnrqtwby8h3w6damydi
X-Rspam-User: 
X-HE-Tag: 1770648099-386207
X-HE-Meta: U2FsdGVkX18IAGDIHXBOGqZny/g59CFNeBNsw9f2XVLBdwXrk7xLEONRWb5vxAaS82ciJEalaowWPy2BXMAU+u5szuRK7IdX/2TRCCSOLyiD4XhR7X96y6lSkcJfYbHJAUz1DY0Hf0rzJK5lqXG76Y9/e2KwTjd6Pdhy+BWbEc8A/F8g++XWovRCyY0hkL6xXbSvwPKu+hHizYkO7Zu3zpKkqQcxmx+SBE41kCzcDhCL7ipIs9Tu0sDx4/tF4OdSI01F0RBKYnZtXvk6Yh5Qop3u2mOfM1NfZEtLZ86xPMrCBY+/CMKam+5O5hUI85sKPbAWcYPZiOS2kGGesZyd/rj5mQRA0MtdnKp67j6urkw+FUifm46BHwTcL4J+hbfwty0HfZbNG8QyWh6XXGlvnVvSOH7plFiCX09K22EOg0E6Yoo5HEAJAG3Rx2WpH/c6loK65/UGfSqsPrGNBSOGTH1IgYEE+ZDFxhPvLqTPtuk21N6sHxYoWbXUUiW7VpP8+wJn2Smv7LXMYd2WVC2HE8lZD/PnWuJeZnWEOVaHQGCeYESJ7NcqhZE/lGfJvcvR6oHFP0joNPJ0dS6EyAFjNRVCU+CGEnLX5e60E5VuGFcUhiKfGoNd0W4CWT1Sdi6Y56SyRvUITR+ywXMZdBTEsnHyyVOpKZQ2VouFdoHgrrWnvmYwBBic2djhA7O50JXnyD/4W66sX8jZKi/dbOjSa0QOYompsjkdMYOeIBTAat+YF7ggiFQw3kcZ45G9fTpPGMidQRadfSenInXWdwdc7AIUYElrNJjYjBteN/HyRWSFzhJOo6eAUyy/v+J4b4TJUCWtatx1Y0eUacBpf1KpX0m2DUgh41wMIcPq6j5okVW+0ukuZQgQH8pZ7gSLSRXUpGKjlJSHZ1ZnDkgTXTokBoZDJomb9lOSiqX9TtAZIVxV/HkqQY0vogOZVXIwWKpa/ZIuCyLKQUNbR2J28wU
 Z/V2epNi
 MAYZxQs2lDcwc/7LQ7ztixTL0lRppItlGpBcbk9Rm7ycBhRg8M/Im+cTQI4Pc4tXTTaxp5/Q6LY+33OtJDLPeF9OcnJzzn3WLwS8CKxncUJDezUnle8joFskUrgGwlHHqFpzVBnNOvtPQAx5f1uTgovJdIp0g3dU9zjtKiJyqaA74ddYbeFLUAGQj/x9Na1YIIfALdljmAybfXrM8WpY63IuAUM4PF3OHrVa73pFnv1gFrFl0IJ76R5OSE0IvNcLLF0KDHyIIgPjw1Tkip95DQHEhhbOIK4/iGJM6j2sCR55ZeSgYlrbLUHBe9g==
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
 include/linux/pgtable.h | 25 +++++++++++++++++--------
 mm/huge_memory.c        |  2 +-
 mm/memory.c             |  2 +-
 mm/migrate.c            |  2 +-
 mm/mm_init.c            | 10 +++++-----
 mm/userfaultfd.c        |  4 ++--
 9 files changed, 30 insertions(+), 21 deletions(-)

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
index 08a88b0d56e5..a965e2f8b8de 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1882,27 +1882,36 @@ static inline void pfnmap_setup_cachemode_pfn(unsigned long pfn, pgprot_t *prot)
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
+extern unsigned long zero_page_pfn;
+
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
 {
-	extern unsigned long zero_pfn;
-	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
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
+	return pfn == zero_page_pfn;
 }
 
-static inline unsigned long my_zero_pfn(unsigned long addr)
+static inline unsigned long zero_pfn(unsigned long addr)
 {
-	extern unsigned long zero_pfn;
-	return zero_pfn;
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


