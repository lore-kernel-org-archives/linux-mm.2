Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8435FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A5D6B00F2; Tue,  5 May 2026 12:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124E66B00F3; Tue,  5 May 2026 12:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0134E6B00F4; Tue,  5 May 2026 12:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD0986B00F2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A106516050F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:54 +0000 (UTC)
X-FDA: 84733849788.13.FFC2EFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id B40741A0018
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bTGd5+xG;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elBY6J7vzBR28SoMnjs3gKS58nAONtP8FXDkBUTIs4c=;
	b=Qg48VWiE/D0L5iaG+12e98rJ3XqgsG21de08Qf2km63BGCqfGQPccRu9Rg8UO8nwnLmF0B
	B6Vr16RcmNuRXt5x6V3lnquPpOj1G7jgXt80VjZlqw+HwPnABbXGkUJWRcW4tySoMhjyka
	Alpz0Z9cgsx8zZ6l9ylawxV+bZ0HMOU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bTGd5+xG;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997332; a=rsa-sha256;
	cv=none;
	b=bN9eov2dkY103v2L4OvJkL6jzS9mUkVt3Kus5O+samb+JSiNA3oRWZrCzJji1vJ4J2YAAU
	Fgk2oAEo2ap56bPAxnUdFC4CGsuGlS9pS10uduCeOLYAvsa64ZMtxIRnSOKZDO2o4uPReI
	UIOgYtvxo0YbX2bmmrgwAhF39f4z5BY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62CBC2681;
	Tue,  5 May 2026 09:08:46 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BCF03F763;
	Tue,  5 May 2026 09:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997331; bh=9cu6U1HiVAmhbUNVWNlsuArXVoh00G3lSnFMLv4m42E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bTGd5+xGeylIXRVYNaW0F5NgA1F13LCGGV2olJ3z/ZLFTbdE7jk0PguRtMzwSFMEQ
	 xbOoiZAGt5gAq8p3Ll7gYcYTYJpdg4rYWjVeHs7oI2hiELWZbiZwPATt1icNYjxybT
	 ZOU0kfcb43VY9DN4Iw4wJlLs+NdK53vFDIb4CdTA=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:13 +0100
Subject: [PATCH RFC v7 24/24] mm: Add basic tests for
 kpkeys_hardened_pgtables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-24-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=8135;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=9cu6U1HiVAmhbUNVWNlsuArXVoh00G3lSnFMLv4m42E=;
 b=hJnF0O0m7FmlYqSLzbqB1uuh24RvpS4A4ztymCqEafcCYbyEf4boFgWSfnnQ9G7zIQnNgOUiB
 xecAXBCpGS8AF9jTDAQgJc8OK3NDawYByxwg1H4E/MPSQXx6JdNA+rZ
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: qdce6armtfk3c9p6ftqboaaey7nsdh7e
X-Rspamd-Queue-Id: B40741A0018
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777997332-644194
X-HE-Meta: U2FsdGVkX18MHYK4/tbhi6ThmY90LDYsNQM+V3kkVXAl10nmXuWO+7FKVag7p1EryN8cJAl8/P+8G2JSi14AncROsi+vFDKsP1mZl3zmh8ADHwjfGqGt1DHiQFL3wXD/0gzceaJmcHBmfNJuN+UsfRQ2LwStPwaBV24kHu+UIzefRuPMCvSdTl+kgMbWcakiTLbbiUwn9Ut2RPPyjXBxnjfvNSQSzih5YV4mCUTgXuCdCmwHa9nyQQSk0QRqjkjltxIn0VyL1eteX8HFI+1Dm5Co4d/AW9pc7bxanDYx/ifBHghPCH0cFalWLj0V7KZpO3Bzaawkecr2QF+il2O+NyDGaSmXXGUedPQAcHNmqdeYaJJlQVlJf11PIhp0bDxN1QDslW9yZ0c7HurATr+aXVfw9iG0k3H82vf2nZKaT9Qz5zHWkW8Ky8U2I2apyh+v5Tovmq23/y6H9RUzvciUNpiRw6Ty0AEhiq3fKZlNUpIQvsp9Ir8PcCw1Uc4It1tgTkmXBmJKg6uBG6B+F383YRWjzEdELaIwG/oJFf26iS1WoTdmo39a1W6sAEYygERS4YPJq2qzP0aLYKkt5+ys6KyiyY5nOcZlNdXn0/SbOkv156EtROLj2WfrhuYdSJmDqRh2FKeb3eLcQpW2qwfyMiAk95PH7XuTb71Yqg2lK0s0F6LN7h1UzUZ6WOughtYt5tby9IHGRpakMtWqynGBA3l2a8lgSMv+x3Ih+4T9ZrnSW4sk/USAoSCmKWS692PIL9Pq3jlOQXvZBkVzoynGcJQ8aA+nBZa/wgiLSOhdHOiWn7pjFFCV+c0UvHblmbRDXNmoXf0o3RjFPwv8TXGKuTLhFmlEOLr+vdluv02e8N4Ccgjc+L4b7ZXQWPwFCOjKhty+tKcuePctdkvbIFvFYBxykMDZG+Ipt4Ku0MnninhGszx4tsWShXpG4KKct8e+c0eI+9NcEmYGvxNSDTh
 2k+kT32x
 RwNUsBuSfTudFWIq4PgSI+W83f/ZIzdyd8Ibwbj6YkUhay7e70saIE9GMg4YMHauFjlUrZsVeRtH8KpBxZqCAS6kGWFw/1MfDsb66P4X6xzoXqG4Veep7D8ha19O+5CAeErChjSXSAzJfVQFN9U1eyqv44iEgAST6QLN4naumbdCRWN2rwts/LJgfIcLW4AdLuBugUTTsPp0hsM8CdH9wUxrMflLCgL8efXDzJYYAZJD/Fb7xANgKndnrfwlsm+tNrs4z8tVQzZsXlsQp9aNv6RKQOzhVSC9JESRma/lDjJ2fbZQ=
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
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 198 ++++++++++++++++++++++++++++++
 security/Kconfig.hardening                |  12 ++
 3 files changed, 211 insertions(+)

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
index 000000000000..dd4acdfd4763
--- /dev/null
+++ b/mm/tests/kpkeys_hardened_pgtables_kunit.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+#include <linux/mman.h>
+#include <linux/pgtable.h>
+#include <linux/set_memory.h>
+#include <linux/vmalloc.h>
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
+	if (!kpkeys_enabled())
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
+	if (!kpkeys_enabled())
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
+	if (!kpkeys_enabled())
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
+static void write_vmemmap_pmd(struct kunit *test)
+{
+	struct page *page;
+	pmd_t *pmdp;
+
+	if (!kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	/*
+	 * We just need the address of some struct page, so we can free the
+	 * page right away.
+	 */
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	__free_page(page);
+
+	/* vmemmap may use PMD block mappings */
+	pmdp = pmd_off_k((unsigned long)page);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, pmdp, "Failed to get PMD");
+	write_pgtable(pmd, pmdp);
+}
+
+static void write_user_pmd(struct kunit *test)
+{
+	pmd_t *pmdp;
+	unsigned long uaddr;
+
+	if (!kpkeys_enabled())
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
+	KUNIT_CASE(write_vmemmap_pmd),
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


