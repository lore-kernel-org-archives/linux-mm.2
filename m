Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE883CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608526B00C3; Tue, 26 May 2026 07:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DFCC6B00C5; Tue, 26 May 2026 07:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5FE6B00C6; Tue, 26 May 2026 07:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CFFB6B00C3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:19:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09AECC10BC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:19:05 +0000 (UTC)
X-FDA: 84809324250.25.0285E3D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 329A514000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:19:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Kt+6FMad;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jppd3A4HdekgA4XDgFm4hc5SUFtd3NB3jKqK8x9gJXc=;
	b=fDltaAjjHpcDHRsXX6FwgDZ+Up+Q3joimoZW9PrYayvwyb2DXauKhIfXetfl0w65r0Ww3p
	7xGbOP8OnkbMCeID5IWVHDDjmaeFIKfatdOgutgcP01o8vLiNghU32xEEhthBAq08qAyJb
	ZHQytS1GCzREl9SuayrR4WIOrpFr62A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Kt+6FMad;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794343; a=rsa-sha256;
	cv=none;
	b=v1EbQ3dVOKhogfR5ITjRxC8XqCRlElP1HaJr4DIWuNTZPZnv1hp8taUf6pi1Y1M8WEjqh6
	pGp9171eKR22R18pQoXBMnwZKBQnXzb3b/H8PKc1HYo+0k27iFqPXrVaY5DlfFLKm81GCW
	TmMAr4fBUxEWcjs7ScuS0FSoFtC421E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54C4B169C;
	Tue, 26 May 2026 04:18:57 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87C963F7D8;
	Tue, 26 May 2026 04:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794342; bh=AgMvAuYmaNxfXrUucs9DZmmpNg7EPlM7dqhVFh4ciHE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Kt+6FMadBIkKS5pp1aU4ExPJVdpKXEglYvKs+YswQeaIZ4pEh+84bLI8G8VFPIfBl
	 lmxOGNjnszkoq23U9iJSK4jQiFY/LaPm9IF1+D7J5D+qFmGt9KUcGo9K85odZwyY+W
	 y0p9E3yDUJpKAyyYHdyOl9VkZJz+dw5RSQ/XDwzs=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:13 +0100
Subject: [PATCH RFC v8 24/24] mm: Add basic tests for
 kpkeys_hardened_pgtables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-24-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=8166;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=AgMvAuYmaNxfXrUucs9DZmmpNg7EPlM7dqhVFh4ciHE=;
 b=/IA4BAFRSnpNB60t/Gx5BBgArgYOitzi93JUV6qGVVKAbwUNdCABR7wAqo3ow+NyFYPO1Dauh
 o16cCVsFqWaDWG+k0HNp5OckFV1/23yW24NJdRcERmHUZovBu4Q0s4+
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 329A514000A
X-Stat-Signature: 3qfugiem49p3afthk655mgambbwjajip
X-HE-Tag: 1779794342-447973
X-HE-Meta: U2FsdGVkX19gN8rdePat6ulrQdY+AuBmgwVbHeCaIcUqIf+OMn5wz+tQmrCSxT8RldoR9m3HNA7yc4649Rwg72ueOTFelZQ0DaDvgGe07l2TZ3ApATzQNLA3pm00pf9fdLrArnsNts3AhxrfViI9YNM430DCtFKFLh+ID7cHsb+GmaV0pSRLA4cZRubGXIMMo1RUNpDGy2HDKJU2nTO6C/PlDmAM0lVBtgQXsNDSXHK4+V2Xzm+m4l1LUwhqKOgcTJR1zXMDw9NJUhHaNlZvpmyKrdnqo5L16TNKRFq9ySjo5uaLBqNC+Nmma86n7WtP5OTyDhXLl/FGG2x8pJulLH0jM3r51NBWl0xEPKxNES00KAygGt6OawWnvj4C//QaMDqCTfNJIv8heCTU2pViubzKgrToqQp5D3tbD9kKvKZBSQ5qoXsZDbzvETt8yDvRFuvSuwF9sNA1/pSY9ADRawl5I+l29/gXK6+bFnS2zvKHsI39q9/4I+HjjGisjDEJaMVjlLqpSpk0hv5Ah9Q2h3LkAlhSoLROwxTYviTQulA0fJYDMRCsEqvWHaN3cbuzs2TLgnbsQvidUxkr7No9b5InD1GsTvkVnr/e7DPbBZoPdvHQymWbxVT4Uhg9z/bSruVPvuw2maNTVV7ebQ1EF7lEgPIJFE1ezoFqNbKQD99bPUF19HNYZhAmxkldn3kXCCWG41MxiTp/iHi68ajLgh8XcsRchcFWpsGGQK5651J1ztrn1T0REMsGOjVAou4ZKRm6oCCXj+bfmCKUm5QV9w+7GIDes7v4c36zJhR8n9dHKt7EJEugxDMC/zYcefhS6D1eo9IsQ4kpvg/i6XeDjPtYm7vg/ocMMSbYNB6tmOGNKqWSqpMkJQGSRkeOCdUV8DJJgBQUZOOv3hqqjfr6LpZ/Ou1vEwdKAVrGO/ZMc+LhviIwK0xDZICPt1M1s5acMYws9kFPh9m4tbvZ6oZ
 DoK59qIA
 LOK2erlOF/6pRUOxr8KbsTq3B/cka9ryp+JssNmms2mn4d/23JzobpGRmDiS193gFr2rlZ2mmnbaFi8YC2NhvfA/mRZMsXjzjZyeyfV3241Y6A5EECOcp+UgiXe8hhEu36j6rrPXGfx1mPkg4K6sQW2fL+FFGT+xVlDzuQ4mUwrToZlpq0zKp41ehGuibe8jQYp5dp7E9FstD2qbx1MUJ9gpv+WnoVAV15wd/ORmck2YP9wn0T03CIS+0a5vEM9cIG/Z3aYjQQ7eOOp9mlxMQkZ0pOWY9ka/qf2qVsFKSVSCmvZ8=
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
index 000000000000..cab0c2e66500
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


