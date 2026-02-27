Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF59DFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE9D6B00CF; Fri, 27 Feb 2026 12:58:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C446B00D1; Fri, 27 Feb 2026 12:58:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275486B00D2; Fri, 27 Feb 2026 12:58:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12A706B00CF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:58:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCB5D13BB40
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:58:06 +0000 (UTC)
X-FDA: 84490995372.25.CF829BD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10EDA80019
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:58:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DY3j3VE+t6mCUPJe41jWT4ckHFoQnZEEHV+qXxwLqWM=;
	b=oZJn4twApZhqErsR2uGwectfFQL37M7c13cvknGrkg8Ern9rAJt+76Gn+7sh5ri2Ay/yoY
	CUhkivowhbWr/3NihdCXB3vasgWgVFVH8PowvmsfxwHcNyiIPSpnwafVvfF6h07bzrURtI
	jN5/mkOUlVD3EYx/zFf98HlTgQFTrpQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215085; a=rsa-sha256;
	cv=none;
	b=P48a9pXpaWtYuTEqvSBCuNXv8ngT07q8WF0nPBB1MHdL8iqz+M/Nkg7eeq7xmKn7vn/boC
	MzoIkDt6qfmwP0FtfGUeOob1O/cXmL1RPUudobDXMxxQazS2mai8Za9i1wFeFFjZ3nKT/B
	4YVwNwTHuRZX6SOOKvDrPzqKve1cdzY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBCC214BF;
	Fri, 27 Feb 2026 09:57:57 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D689D3F73B;
	Fri, 27 Feb 2026 09:57:59 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 30/30] mm: Add basic tests for kpkeys_hardened_pgtables
Date: Fri, 27 Feb 2026 17:55:18 +0000
Message-ID: <20260227175518.3728055-31-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ni535ihxu9jybb1xe9tamykpwzfes1yc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 10EDA80019
X-HE-Tag: 1772215084-414346
X-HE-Meta: U2FsdGVkX18OXvXaaEm0Bk/hz7VeFlYjwOX1Vxthuf5J86n5QffoK2dTUUvUWIOjwgzOAjZ3bJ0gP9t9N+T75alRGf8frshYRlTPPvg6BZ3nqWoKOcVkEjwHG/TWpZCvKDALBHR/WDy1YLl1XqueufnDotnO1bXztivXmVKn+ay6oEPrhozvGU9kly/R/NFF7+oqV3B0/W6riDq7NrnzReocnLiEnoBVNFno4MOXsKhWZrCUMT1QxUYM6qBjSgTXyviopQrlo2/rlXU2j+YPKufQxROmBc+gcZdM6D3Hmvdy+T/cDrpyZo7+r7nntkUizKICDvOtWh8X0U3ps1E4sl+zgA28htPfoAVfLJ8ouhOSMyAIY96PKFShM4MbKbBrNHCHHGwjMx1XmxFfD5/SyVBMKccMuTk4GpnqwGO5IDTaBHU0xi3AtenVQf3KGrrkwhPt69M/2GPhYg404dRjIqMfklwBMdl/PXPtM6QTXRHfX7Zz9mVukA9WjAN9mr6zVhkv83W5PjQU9soy5FyD+rcHn93EfB3lrf3H0g8kkjaFp/pwoqIpD1bNk+RxOcr5/lESAiQ4BM2ksIr0ky2YzoC+C6I8bhZmRYqpWh7iwEkJeeQ4Lp6p1q86BbtYB1tWb9MjcMUiU3tW3fkUITNiGd0YqlbOROQszLXr35TnX2CsnIxUrbofFbdyKhLPA19PbJO0C0TEVJjMDmr6N50pFxrGeKF+kfWSoIKahPk6Qvo4xizapA25W0Sha1R7llCrixkufA8DJM8TuavBcvl6auzMz5DvNwDTXa5XQC4+TGDi2yxWLAZpyYerSsR5ayaRmNCzzLQlpwmdZ8VvR75cD1RGub07yMMKGDfdmo3gD8bSrnoVjHe5lBSs+8QrB+QivOxLkePOqMIndCeYxF9j8ND7Jas0arZC1s3+omissPW17mPcgpSKSHixl5+k3OOJ+1RwUcySV8Lzx/YK3j/
 TVssboLZ
 CSIC/qb1Yf/CHkjitRpvIPrsYBzFNYAvdYgbx4rysDFnfnhTKiz/NL8NJVVPde3EnnTNoa7TUJb69XO1S4fmbDjF2nae2jd2VuguPG8tWySWG2uN3Fzj2gSzL7FfRNOWCSh9Z7cJO1exCPxS9SEzzslO5lHdrRigXEsWdw81xJRFIt2hJDJ09T2U72GyBvDvJN5q1zeVNrr3MXQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add basic tests for the kpkeys_hardened_pgtables feature: try to
perform direct writes to kernel and user page table entries and
ensure they fail.

Multiple cases are considered for kernel page tables, as early page
tables are allocated and/or protected in a different way.

The tests are builtin (cannot be built as a module) because they
refer to multiple symbols that are not exported (e.g.
copy_to_kernel_nofault()).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 mm/Makefile                               |   1 +
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 202 ++++++++++++++++++++++
 security/Kconfig.hardening                |  12 ++
 3 files changed, 215 insertions(+)
 create mode 100644 mm/tests/kpkeys_hardened_pgtables_kunit.c

diff --git a/mm/Makefile b/mm/Makefile
index 7603e6051afa..9ebdbaa696b2 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -151,3 +151,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES) += kpkeys_hardened_pgtables.o
+obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES_KUNIT_TEST) += tests/kpkeys_hardened_pgtables_kunit.o
diff --git a/mm/tests/kpkeys_hardened_pgtables_kunit.c b/mm/tests/kpkeys_hardened_pgtables_kunit.c
new file mode 100644
index 000000000000..fa11fcd7abde
--- /dev/null
+++ b/mm/tests/kpkeys_hardened_pgtables_kunit.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+#include <linux/mman.h>
+#include <linux/pgtable.h>
+#include <linux/set_memory.h>
+#include <linux/vmalloc.h>
+
+#ifdef CONFIG_ARM64
+#include <asm/stacktrace.h>
+#endif
+
+static void free_page_wrapper(void *ctx)
+{
+	__free_page((struct page *)ctx);
+}
+
+KUNIT_DEFINE_ACTION_WRAPPER(vfree_wrapper, vfree, const void *);
+
+static pud_t *pud_off_k(unsigned long va)
+{
+	return pud_offset(p4d_offset(pgd_offset_k(va), va), va);
+}
+
+static pte_t *get_kernel_pte(unsigned long addr)
+{
+	pmd_t *pmdp = pmd_off_k(addr);
+
+	if (!pmdp || pmd_leaf(*pmdp))
+		return NULL;
+
+	return pte_offset_kernel(pmdp, addr);
+}
+
+#define write_pgtable(type, ptr) do {					\
+	type##_t val;							\
+	int ret;							\
+									\
+	pr_debug("%s: writing to "#type" at %px\n", __func__, (ptr));	\
+									\
+	val = type##p_get(ptr);						\
+	ret = copy_to_kernel_nofault(ptr, &val, sizeof(val));		\
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EFAULT,				\
+			    "Direct "#type" write wasn't prevented");	\
+} while (0)
+
+/*
+ * Try to write linear map page tables, at every level. This is worthwhile
+ * because those page table pages are obtained from different allocators:
+ *
+ * - Static memory (part of the kernel image) for PGD
+ * - memblock for PUD and possibly PMD/PTE
+ * - pagetable_alloc() (buddy allocator) for PMD/PTE if large block mappings are
+ *   used and the linear map is split after being created
+ */
+static void write_direct_map_pgtables(struct kunit *test)
+{
+	struct page *page;
+	unsigned long addr;
+	pgd_t *pgdp;
+	p4d_t *p4dp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+	pte_t *ptep;
+	int ret;
+
+	if (!arch_kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	ret = kunit_add_action_or_reset(test, free_page_wrapper, page);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/* Ensure page is PTE-mapped (splitting the linear map if necessary) */
+	ret = set_direct_map_invalid_noflush(page);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ret = set_direct_map_default_noflush(page);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	addr = (unsigned long)page_address(page);
+
+	pgdp = pgd_offset_k(addr);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, pgdp, "Failed to get PGD");
+	/*
+	 * swapper_pg_dir is still writable at this stage, so don't check it.
+	 * It is not protected by kpkeys_hardened_pgtables because it should be
+	 * made read-only by mark_rodata_ro(). However since these
+	 * KUnit tests are builtin, they are run before mark_rodata_ro() is
+	 * called.
+	 */
+
+	p4dp = p4d_offset(pgdp, addr);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, p4dp, "Failed to get P4D");
+	/* Not checked; same rationale as PGD in case P4D is folded */
+
+	pudp = pud_offset(p4dp, addr);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, pudp, "Failed to get PUD");
+	write_pgtable(pud, pudp);
+
+	pmdp = pmd_offset(pudp, addr);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, pmdp, "Failed to get PMD");
+	write_pgtable(pmd, pmdp);
+
+	ptep = pte_offset_kernel(pmdp, addr);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, ptep, "Failed to get PTE");
+	write_pgtable(pte, ptep);
+}
+
+/* Worth checking since the kernel image is mapped with static page tables */
+static void write_kernel_image_pud(struct kunit *test)
+{
+	pud_t *pudp;
+
+	if (!arch_kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	/* The kernel is probably block-mapped, check the PUD to be safe */
+	pudp = pud_off_k((unsigned long)&init_mm);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, pudp, "Failed to get PUD");
+
+	write_pgtable(pud, pudp);
+}
+
+static void write_kernel_vmalloc_pte(struct kunit *test)
+{
+	void *mem;
+	pte_t *ptep;
+	int ret;
+
+	if (!arch_kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	mem = vmalloc(PAGE_SIZE);
+	KUNIT_ASSERT_NOT_NULL(test, mem);
+	ret = kunit_add_action_or_reset(test, vfree_wrapper, mem);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	/* vmalloc() without VM_ALLOW_HUGE_VMAP is PTE-mapped */
+	ptep = get_kernel_pte((unsigned long)mem);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, ptep, "Failed to get PTE");
+
+	write_pgtable(pte, ptep);
+}
+
+#ifdef CONFIG_ARM64
+static void write_early_kernel_vmap_pte(struct kunit *test)
+{
+	pte_t *ptep;
+
+	if (!arch_kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	/*
+	 * When block mappings are used, the IRQ stacks are allocated before
+	 * set_memory_pkey() is available - the pkey is set later by
+	 * kpkeys_hardened_pgtables_init_late()
+	 */
+	ptep = get_kernel_pte((unsigned long)raw_cpu_read(irq_stack_ptr));
+	KUNIT_ASSERT_NOT_NULL_MSG(test, ptep, "Failed to get PTE");
+
+	write_pgtable(pte, ptep);
+}
+#endif
+
+static void write_user_pmd(struct kunit *test)
+{
+	pmd_t *pmdp;
+	unsigned long uaddr;
+
+	if (!arch_kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	uaddr = kunit_vm_mmap(test, NULL, 0, PAGE_SIZE, PROT_READ,
+			      MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, 0);
+	KUNIT_ASSERT_NE_MSG(test, uaddr, 0, "Could not create userspace mm");
+
+	/* We passed MAP_POPULATE so a PMD should already be allocated */
+	pmdp = pmd_off(current->mm, uaddr);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, pmdp, "Failed to get PMD");
+
+	write_pgtable(pmd, pmdp);
+}
+
+static struct kunit_case kpkeys_hardened_pgtables_test_cases[] = {
+	KUNIT_CASE(write_direct_map_pgtables),
+	KUNIT_CASE(write_kernel_image_pud),
+	KUNIT_CASE(write_kernel_vmalloc_pte),
+#ifdef CONFIG_ARM64
+	KUNIT_CASE(write_early_kernel_vmap_pte),
+#endif
+	KUNIT_CASE(write_user_pmd),
+	{}
+};
+
+static struct kunit_suite kpkeys_hardened_pgtables_test_suite = {
+	.name = "kpkeys_hardened_pgtables",
+	.test_cases = kpkeys_hardened_pgtables_test_cases,
+};
+kunit_test_suite(kpkeys_hardened_pgtables_test_suite);
+
+MODULE_DESCRIPTION("Tests for the kpkeys_hardened_pgtables feature");
+MODULE_LICENSE("GPL");
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index fdaf977d4626..48789f93e933 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -287,6 +287,18 @@ config KPKEYS_HARDENED_PGTABLES
 	  This option has no effect if the system does not support
 	  kernel pkeys.
 
+config KPKEYS_HARDENED_PGTABLES_KUNIT_TEST
+	bool "KUnit tests for kpkeys_hardened_pgtables" if !KUNIT_ALL_TESTS
+	depends on KPKEYS_HARDENED_PGTABLES
+	depends on KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to check that the kpkeys_hardened_pgtables feature
+	  functions as intended, i.e. prevents arbitrary writes to user and
+	  kernel page tables.
+
+	  If unsure, say N.
+
 endmenu
 
 config CC_HAS_RANDSTRUCT
-- 
2.51.2


