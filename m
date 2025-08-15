Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B373CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EE5900222; Fri, 15 Aug 2025 04:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE8D8E0002; Fri, 15 Aug 2025 04:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C44900222; Fri, 15 Aug 2025 04:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F14088E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F8BB5BB0B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:51 +0000 (UTC)
X-FDA: 83778386622.15.4B77C04
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 038A98000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BNna1LnRkBzQnBscTbrqJVsFmbrmgvQ+2jGuzxBureI=;
	b=TbN2eOpMcNDVJVokFW67hJc4KvAqpWC6FS0BHF54z5P5SspkHl/dXeE7e6ij87Do0HQDYz
	spSO8MTb5eDUKRkTnpYrKH1zNVnIcFHqP40CA0OEyFlfw/9Jsn6JzqvZEh5ApmKpiPpcBi
	COwD36TXnNFirk8aX/OKJuSV+leC2ng=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248210; a=rsa-sha256;
	cv=none;
	b=gfOxmgWJvJztG/zIzQYUncjQF7rbFQwoWtjLI0yPFv2luMcQV78vwr1gUrYB0G6EljB5zy
	CCx4I1WBdoZOsyH62f7yn4NhJxzRH3OsY86X6rMdNNSrBglUzJBLPYXhzIkSuLDVFzftcm
	MhT//U4RmgEsDmWzjSiZZdyFYcgBi+I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2900D497;
	Fri, 15 Aug 2025 01:56:41 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C52313F63F;
	Fri, 15 Aug 2025 01:56:44 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 17/18] mm: Add basic tests for kpkeys_hardened_pgtables
Date: Fri, 15 Aug 2025 09:55:11 +0100
Message-ID: <20250815085512.2182322-18-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 038A98000B
X-Stat-Signature: g3o6ypmss8t58ds4cptq9h8pso9ox6o3
X-Rspam-User: 
X-HE-Tag: 1755248209-194215
X-HE-Meta: U2FsdGVkX1+VR6oSnxwH0CwwIobe6MVe7nF6w1p/YPuqn2SgvbwbQ7UWZ6FOdx1K4Ry9m9eZyREvgTVudq5dMnrvtnozImCRg6jaQwy47jVEA16OfUYdkTJyMZIwQ2WgwLxCWaQrK63W+XRPyEyg44D2wluEW5pxnrXm1dAWDU+s6hBbv32I+HZaGRZZS570JIB10x8aTWgzY64WfFGmjKcwf177fZxuymzEL7/BHXZAcmSgzNZtEQlrnMFz6rQcxu1D6VmGwHShdhA06oiA7bIB3q5h+Dj9NClUqeqcIORa7FEb9q/36p6f/OM87j/G/408Lpx6dIqx4yFTPoZimton9/poxpugr18bHWJDWjddgRrHst5Pjz2Gi2uY00szAejQ87zJkWaPxWu04czNRmSaCrHWtUMyDsPXD4dH5GBOyNQplGUZ7+5qnZ2WarCBLI28oSL5oqJ/NV2LpLaafs7pBgFXoOVZ2i+Gl3NOsGVSMFMEeled9VGgQ5ym5mHu+53/s7NS/l8V7Hhv/F0yx+WqMCO+enzedj6S1v+6klubefUt+3Fgs07Y/SxFoKfmAM2u3jtX09KI9fbDozhOBClEw4Xj4OxwLxVv8gfWU639Xnjjgn2ZDt+lPngaSRN8KQMoltQ39+S8bFGTP/Mw2W/6cA3LfYwESvDsU3YG2CKdpFsEU3YPViYEx+0Ghe+TIi0rtRePW6SP1b2I8EhGpsuav1Euy97vErY1dLhamF7aZl1rHxH0Eow6tAANwKCvAXrhnd/UORygNCp31Oju20hob2drbsquQNu1f0XwIL88/02G9/Lr6l4ioioEA6qeul6oA+ENXdL/rf91c1S5oHCsjtUCYLGEf9rs01+wUQjkmBUCoLgILz7Bb9DiQBkQ52E0l9TotEGQGBB66HwtlL24axAK88zUPUcV+jxi1LTs9fs+Ujv1I6porOIPjMT6LJgdjWx3CkmX6DjIrfK
 1LCWKk8u
 0YcYdPrT485d4DqRqvGxnCaMftRp6OfH+owsEHnrIGgYl3Yyp/TyA0DPedt2KdjhxYLpQ6Szhc9Ta0mHbbXiwr4WVsMTw/82Sbki9X+luaqL5AQagPTyD9jr4MYTDgBJIhjYrBWxqR/TjJV/mG2ZceE+9Uw0ZiR6VH4B7gUGS12PLl9+m6EA9vx/8Dn3lstm0jikEPz1OpR9ERWfJWMnGsflHJkCSqrLCBhnBBrz0J5FyfZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add basic tests for the kpkeys_hardened_pgtables feature: try to
perform a direct write to kernel and user page table entries and
ensure it fails.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 mm/Makefile                               |   1 +
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 106 ++++++++++++++++++++++
 security/Kconfig.hardening                |  12 +++
 3 files changed, 119 insertions(+)
 create mode 100644 mm/tests/kpkeys_hardened_pgtables_kunit.c

diff --git a/mm/Makefile b/mm/Makefile
index 10848df0ca85..b1e6cf7f753c 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -148,3 +148,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES) += kpkeys_hardened_pgtables.o
+obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES_KUNIT_TEST) += tests/kpkeys_hardened_pgtables_kunit.o
diff --git a/mm/tests/kpkeys_hardened_pgtables_kunit.c b/mm/tests/kpkeys_hardened_pgtables_kunit.c
new file mode 100644
index 000000000000..3d916f0719d0
--- /dev/null
+++ b/mm/tests/kpkeys_hardened_pgtables_kunit.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+#include <linux/mman.h>
+#include <linux/pgtable.h>
+#include <linux/vmalloc.h>
+
+KUNIT_DEFINE_ACTION_WRAPPER(vfree_wrapper, vfree, const void *);
+
+static inline pte_t *get_kernel_pte(unsigned long addr)
+{
+	pmd_t *pmdp = pmd_off_k(addr);
+
+	if (!pmdp || pmd_leaf(*pmdp))
+		return NULL;
+
+	return pte_offset_kernel(pmdp, addr);
+}
+
+static void write_linear_map_pte(struct kunit *test)
+{
+	pte_t *ptep;
+	pte_t pte;
+	int ret;
+
+	if (!arch_kpkeys_enabled())
+		kunit_skip(test, "kpkeys are not supported");
+
+	/*
+	 * The choice of address is mostly arbitrary - we just need something
+	 * that is PTE-mapped, such as a global variable.
+	 */
+	ptep = get_kernel_pte((unsigned long)&init_mm);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, ptep, "Failed to get PTE");
+
+	pte = ptep_get(ptep);
+	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
+	ret = copy_to_kernel_nofault(ptep, &pte, sizeof(pte));
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EFAULT,
+			    "Direct PTE write wasn't prevented");
+}
+
+static void write_kernel_vmalloc_pte(struct kunit *test)
+{
+	void *mem;
+	pte_t *ptep;
+	pte_t pte;
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
+	ptep = get_kernel_pte((unsigned long)mem);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, ptep, "Failed to get PTE");
+
+	pte = ptep_get(ptep);
+	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
+	ret = copy_to_kernel_nofault(ptep, &pte, sizeof(pte));
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EFAULT,
+			    "Direct PTE write wasn't prevented");
+}
+
+static void write_user_pmd(struct kunit *test)
+{
+	pmd_t *pmdp;
+	pmd_t pmd;
+	unsigned long uaddr;
+	int ret;
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
+	pmd = pmdp_get(pmdp);
+	pmd = set_pmd_bit(pmd, __pgprot(PROT_SECT_NORMAL));
+	ret = copy_to_kernel_nofault(pmdp, &pmd, sizeof(pmd));
+	KUNIT_EXPECT_EQ_MSG(test, ret, -EFAULT,
+			    "Direct PMD write wasn't prevented");
+}
+
+static struct kunit_case kpkeys_hardened_pgtables_test_cases[] = {
+	KUNIT_CASE(write_linear_map_pte),
+	KUNIT_CASE(write_kernel_vmalloc_pte),
+	KUNIT_CASE(write_user_pmd),
+	{}
+};
+
+static struct kunit_suite kpkeys_hardened_pgtables_test_suite = {
+	.name = "Hardened pgtables using kpkeys",
+	.test_cases = kpkeys_hardened_pgtables_test_cases,
+};
+kunit_test_suite(kpkeys_hardened_pgtables_test_suite);
+
+MODULE_DESCRIPTION("Tests for the kpkeys_hardened_pgtables feature");
+MODULE_LICENSE("GPL");
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 41b7530530b7..653663008096 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -277,6 +277,18 @@ config KPKEYS_HARDENED_PGTABLES
 	  This option has no effect if the system does not support
 	  kernel pkeys.
 
+config KPKEYS_HARDENED_PGTABLES_KUNIT_TEST
+	tristate "KUnit tests for kpkeys_hardened_pgtables" if !KUNIT_ALL_TESTS
+	depends on KPKEYS_HARDENED_PGTABLES
+	depends on KUNIT
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
2.47.0


