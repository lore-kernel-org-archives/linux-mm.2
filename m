Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C3B606EE93
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=iMDYvXpk
Received: by kanga.kvack.org (Postfix)
	id 0520A6B05D7; Mon,  9 Nov 2026 11:02:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C7B6B05D8; Mon,  9 Nov 2026 11:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4EB6B05DA; Mon,  9 Nov 2026 11:02:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B75476B05D7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:02:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5199D80718
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:32 +0000 (UTC)
X-FDA: 85416048144.04.D1F03E5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6BB8110000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iMDYvXpk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240150;
	b=opyN0xyotq5q5nix+BAqcnnAfo8d0kIEj3v4JDvqaZl0X101oSVnlIvBXN8WFlVQZty1e/
	yRe14sXMFJLcATBqQfiw5iJq48hzO1YR0W8cPw61MNKS/HCEYTcQPf65k63NPAjq+TAKJk
	KWPVBd7KZShOnXvuWn7DEI0sQL58ZJI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEIsFW9jH6gypon3gbKl/1F5oRxGR3xdBdmV6PMmfqQ=;
	b=I/6pXUKbF+wpzRKpO/W8VkNgoJecLfItlX7fUiubq2H9feqMX8ABQT6VqXeURpwW9M3c7M
	SyYYkIr+jLmq4mcsFt6F9F9ci3MIWj2X1DSVaQtPe/DoLeiwdvAL3O5MBUrS9MQenJLmL9
	Ojg2s6ggSj2gFXvKQgSQCnqsPCPZNls=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iMDYvXpk;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B13A2F;
	Mon,  9 Nov 2026 08:02:26 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE4A23F632;
	Mon,  9 Nov 2026 08:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240149; bh=whHNqvrgkNGDWhe3Qiyv8K8tTXQdyzS5DNMu5K3JCD8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iMDYvXpkelxJePBSzgn+i0+x2akbCd3CBRy4l7OFEcb2EjWv+m/azm068BZjkdudw
	 YKEYwtuM+C3x9QW+Yc1qQptt5HFwSwubGdIKbovaVUgFYoQpjw2zhHxQOKfFxessjl
	 qlyJJr2NTrOl02unsu0tYLesKm6upWccZeB/WIuI=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:47 +0000
Subject: [PATCH RFC v10 22/22] mm: Add basic tests for
 kpkeys_hardened_pgtables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
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
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=8244;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=whHNqvrgkNGDWhe3Qiyv8K8tTXQdyzS5DNMu5K3JCD8=;
 b=864d1s7mcMPTzdCv7ZDhpZX1q/RPNV085d42av0+370yfZpQDlIINNoHvAQ+w9IRHJ61oZ8JS
 4f2IZ8ZwfhmA+1swOc3JPZECBbVL4jaLroXdU6aJWI3is9jZl7ZvBf2
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: 6BB8110000E
X-Rspamd-Server: rspam12
X-Stat-Signature: wst3izgrzdwyedm5r35irzyiwjfyo184
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240150-949725
X-HE-Meta: U2FsdGVkX1/TG1sgOTcTN5tecl5vHoIDsDZG70hnP+lLexDp4V3UKJ3EGawhiYiB8O31VQKu2/4ve0XIwCzKXr+mqdM1j7l9bHg4Y9by2zrQ8qgXUjY448aoCiFB/o0vJfnFzthhqiX53LCph9mevQ9ezDS7yZojcnT8ocixnh3ITwd2fRlWSipQNCip2NdEi2cjFL8QudRUgVfJ+Ejs0AaPWjTBgtDotkcvt/0qxoW9nZcwMm01fTzAt0MzoNdiwWhS//N5dZKpfQoobakiiGDDmOctXBQY6wNsrLBbxbPqn3pVPy7ETHwosN9Wqxul+TEjdQaEEGR8ZYrWAe1/rqXD85t2cLhZ5B4XSzrKlQ6rcwnfkJPwrWkY7u7Z9IzRHLTNzRhxTDAp7ORH9BJPO3YG9EMfJfqeaTehkol41dzEX+oW4PwibZOV5BjgvZ95i5UDVWcc5WsR9CDNLEFUTxMgikwjjybgH8+ZudoZkUp6aPNbvO2h20lOvo/Lua47B9EFRZkVKqKthepNUHlytoC/UaAAcaPXQTuo+Ioz5Rp7uHb2Z6fC6ED7/ifPdrYEKBVj+JlPMDqgADBj7IJn2QW+c5sheYDGZlORI4oBR0tixCcAJX7r7vBoImBh6klUsJuytvrJiW1I3mUG/u8Bk2rMu6utLY4lwozvwHUqKQqzNIypVYTQdJDR8+rKuYICgsXQ2Ac0eMF1y82JtFtZm0r7bYrmvJdPMZcCTdAXoa3EKa3SZ/rDd8tBu7JXnVkikS4kfmUv8ZWKpGVEGKBbdQGeaqh2/iF864qXS1/EKcg1jzM4sPi7YmL6zcfD53ulHvJxfeCWdmUK7psHzR/q68/6fFFebe91bjm6I8KxNuz7BYaMWYdQeE0wjA4FUrRie4wgJV9sOfkA4dLTwSuUeZavtqZhHp6FCjIVhzr4PjcujCLikZQXfO92NzsOM3keAS+gkVupaI8hFBTun9d
 9gEc0T05
 w5NUSOPlwyJIECKLAPNgnU0SnlHQycoYO2INLKyOhfNWEZz7r0DbrPAMU4K+x71eU49VaudeenBA/V4tNhMx0P8ePjLiOvNggZ6sdmX50mMlxulG+wzD8R4Fm60Sl2R9j1ECReJ5gHUOx2zHQ5SqOAYNut1Wx2kStujuaw9kEM+S7bxMa5DyAbkTgLSYcxYvq2nVTbN82HmjUiCrolbr168Ld0UFZNQRCCcLWEIbLjsEM2o0ckyRcPvOzLnSERCPkw42ZqQCRRSS1ywErU8Hp8akR2fXlwbEYAJ20wDQXdGDqTKIvY0XFU8Ni4/w49WIbPJi8hiuTu9HmAnM1+sPreyzdxrPlEP460O9JOpbs8QemHEQmlOtstH4cAUTYKIIbFt002vl/OoDt+tMPx7nWC7DeBe0FOgJIpfTx2kBlvW3xvwzUlP20gbpLnl0jH/PTJid4wfbdXLbprQyhjHes7l9P6ocZNL21eJUhvr81SaIRJT8Ojzr9naLGQyA55EJQLO4qsz5XIcvoEWDnhSMlPrLpnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add basic tests for the kpkeys_hardened_pgtables feature: try to
perform direct writes to kernel and user page table entries and
ensure they fail.

Multiple cases are considered for kernel page tables, as early page
tables are allocated and/or protected in a different way.

The tests are builtin (cannot be built as a module) because they
refer to multiple symbols that are not exported (e.g.
copy_to_kernel_nofault()).

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 mm/Makefile                               |   1 +
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 200 ++++++++++++++++++++++++++++++
 security/Kconfig.hardening                |  12 ++
 3 files changed, 213 insertions(+)

diff --git a/mm/Makefile b/mm/Makefile
index 07b67eaa1b3b..4acdd3c58b46 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,3 +150,4 @@ obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
 obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES) += kpkeys_hardened_pgtables.o
+obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES_KUNIT_TEST) += tests/kpkeys_hardened_pgtables_kunit.o
diff --git a/mm/tests/kpkeys_hardened_pgtables_kunit.c b/mm/tests/kpkeys_hardened_pgtables_kunit.c
new file mode 100644
index 000000000000..b6e1eba0d9b9
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
+	ret = set_direct_map_invalid_noflush(page, 1);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	ret = set_direct_map_default_noflush(page, 1);
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
index 9a6f50103482..af0f83e3a19c 100644
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
2.56.0


