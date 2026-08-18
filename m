Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB30C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080646B07F2; Tue, 18 Aug 2026 10:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0319B6B07F3; Tue, 18 Aug 2026 10:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89156B07F4; Tue, 18 Aug 2026 10:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFCA66B07F2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:13:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EA95802BC
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:29 +0000 (UTC)
X-FDA: 85114582938.17.14BC3B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6B509C000E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:13:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pn0sG1iw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Cqfq6txhZErfhbyj7xjA3Rbs/jkv6MSn+BaaqatuCE=;
	b=vbW/Pvj9zomBpJjE/uhhfV7tfaO6gSB80EOSSUGZiQe+f7B+zawOVX7XR/VldWnBX8j3dT
	21QMrzHaGkVJy7QnWXLbnL+nykXRf1EtYNTd9jfbDlPaRetqj1iqyMJZwaP0FOIf+sD8Sj
	Yyexk+waONBUshCN8bRe3zYZesQG9zs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pn0sG1iw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062407;
	b=l7DXYfsTNudKt4xZ6wzT9PnVnD7pMMMDUJigw9m2PVAt39tb9JoEx7Ak6SybKNcNX6b98r
	w1/e3AJc/les5uaVfX24p+lrdmtJ3CsyMH/EzMZN78PlAck95jNmdC5Ww7Xe4ohcGViPLL
	hhM//8PFQTRdTiuwxDlNODLfiz5IMmc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5C1119F0;
	Tue, 18 Aug 2026 07:13:22 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E129D3F85F;
	Tue, 18 Aug 2026 07:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062406; bh=sJbE8NLgwo2nj84nkxPSpL2i2LPH5XpUVTvG2CACATQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pn0sG1iwAdXKOT8As39XdvEFBPfyHGDscQwApXXCbtq2hCt5N/+FYO6jVj/cRfp3m
	 2Qnjopn7ObgQ/mbtudgsNE7BxrpFcbry2fUFK2Zl2gX3G5lmJ8SbOgH4LgJspRphpV
	 +XRir/ROwBftafAib4c/ol4obZUqX+lrFOh17KvA=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:09:07 +0100
Subject: [PATCH RFC v9 25/25] mm: Add basic tests for
 kpkeys_hardened_pgtables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-25-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062277; l=8176;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=sJbE8NLgwo2nj84nkxPSpL2i2LPH5XpUVTvG2CACATQ=;
 b=/Y+TYwvWUK3vc0eahhukYehcUiD/3b33M9t3s/hJxjH6bh7B3GD/N9ACWMr4VtA5S/wl2fGS6
 WzlkzrrDe4tAwx5fOYQ1z3I8W1zmiXQ9VSvH0YRMMyCH8Gxo/v3UxiX
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B509C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: dtqz3borsiik5sf3eyemsqg3jf3knm37
X-HE-Tag: 1787062407-731895
X-HE-Meta: U2FsdGVkX18hYvulAPLp4lXWIsJT1joGOwL139eufdCJQwqkyqe4OdcE6XLfm0I2s0LJ8BP/tJFe+3iIS2uCcqRYm5uJjqReiyLbPWjPnRTj3Ron7EfwAGEKrcgik6rEdtpwiLDsvVmLAIg6o8NMB/rIy1IBhiZmIx2drBTbA7xm4SQeLNR5nN53dlBcLftzHjPnFRDQoz1GpVCDuzTqmrk3ilkq1qlXZRpRAOj2Yn7HTkNhvHtgg5BJS0vVuZufgGtYX4Om8nOFU+KSX52Gpj9ujOg4IjAwq0hKEDXk0zoT1Zx7hzfhbpuyHOYY/HCOHiJDGIVLVuOqVB2//kJboAExTKQHB5YtidX5Ha7bZn8mx/2FVkBK/AV3y8QC8PjxnZzIqaYCcth7FOcExOKgksi5ojY8gCKGTWwv9TZ8o0pdeFjkjfgd5HXeq7nPfVTWr9duOqS35ovgIOJE9bXCZvETbKDEpVUm7Xese5ioSaO5wLHnzswRlxkj+SAdpmQehx0Jw7eJVct7NkdcoZfpwOoe5EEHH59REvQd/EqNeabugiMtChJCVu6p+alC9+Q8ZIVFgPoqJVxlFWLniZFpPoA6HyHeLO5sKcZMgUash/Jg+KDC8mCgK3LKOf6bAdKLcRw5tMk/H7zM/sk0Y71ZitTmFaEynGFlEAwUaYl6OqvVqFldPDR/qICzXb5IyrnlJn0+63EPF8D0ZbN6bVRxCSsTYTDvSH0Qm7Slntg/MQDdOZd3sk+ime9BQRLdM11A4tuvFFUmjwWNlaH5LfFtSn/DHonE3Ut2j52fnQFXTzN3kCUTy6rJwbCc2fBCk3IpcyccEYG4/szrV2z9iJSs/ozwRBw37bjcrrDtKlwRRr/ycsfbqkDY9niXhPgxYtcn+MEyTUMEnnWCPigwxcYGBewzXtneBZx9h4Vw50///bGkB+cNFROvk2pqV7aJILlU4VK99nyb0ps/ll4Wn62
 BLfElKS1
 juQLmN7Swuwppvc9DDOJa6UJKWYfvWcGSsBNaDFjxVQIqdjac46kFdZXlFyLidw5iuPyFHwslM84J17UKVdUDuwIx+JGKENSdDp6J/die2sHU1/sUoOB17cy7HnJ/pRrFhIiQZBD/HwVdY01BntrJuAbReu2UOH1AZu5ky3bQGv5WVCrsxbFseVuVveQNGioZOm0YQpk+WvMhZ3On8mdtJi1gyfXu+06lwr6wF3b9C4+7kdbs6DMZhLDQG81mHsKddoHnYNIB0UQn4evdN7UG/rD1b8dzG7Ph/L6RK6wLI0B48U0=
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
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 200 ++++++++++++++++++++++++++++++
 security/Kconfig.hardening                |  12 ++
 3 files changed, 213 insertions(+)

diff --git a/mm/Makefile b/mm/Makefile
index 35982b6efb56..e31e58294845 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -148,3 +148,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES) += kpkeys_hardened_pgtables.o
+obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES_KUNIT_TEST) += tests/kpkeys_hardened_pgtables_kunit.o
diff --git a/mm/tests/kpkeys_hardened_pgtables_kunit.c b/mm/tests/kpkeys_hardened_pgtables_kunit.c
new file mode 100644
index 000000000000..80d4f5144e48
--- /dev/null
+++ b/mm/tests/kpkeys_hardened_pgtables_kunit.c
@@ -0,0 +1,200 @@
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
+	if (!kpkeys_supported())
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
+	if (!mm_p4d_folded(&init_mm))
+		write_pgtable(p4d, p4dp);
+
+	pudp = pud_offset(p4dp, addr);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, pudp, "Failed to get PUD");
+	if (!mm_pud_folded(&init_mm))
+		write_pgtable(pud, pudp);
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
+	if (!kpkeys_supported())
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
+	if (!kpkeys_supported())
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
+	if (!kpkeys_supported())
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
+	if (!kpkeys_supported())
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
index bb75b580b7f1..ad6152961f8e 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -283,6 +283,18 @@ config KPKEYS_HARDENED_PGTABLES
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


