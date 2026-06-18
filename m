Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE61CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409A46B00DB; Thu, 18 Jun 2026 05:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7416B00E1; Thu, 18 Jun 2026 05:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088276B00DF; Thu, 18 Jun 2026 05:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B17AB6B00DE
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:38:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9141DC2C0C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:11 +0000 (UTC)
X-FDA: 84892492062.10.A506760
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74FCF180002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bwtpUSU5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QfA9obPswGJtaazWa7wtlqPBE8fA3np3bpzuNLaVkE=;
	b=doXELGfIoQXCA9CVey2RA8O2IX1u4ueOve2wfhnqAHdazjQ9SXGVDOqIbqdDa2LGcS2FvB
	q4Ngc3jeTRn/8DBfojnj02EFaDsftY7yIEDiCJCVbKrv57Tf9TF3emKHKmYahrvUbKPVNy
	x8eu5QjLHi1tQqfQGhD9ZFcelhPAVvQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bwtpUSU5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774529;
	b=zpsms51SIiQPPltZNJpIg8EzfBzJkRHDkRTY1badTOat/OEj0/VKSjKl/Pg1WR+0VNB6Tx
	pI6ZLTGMSd2/01JNuhnrqHBot4bylH5C9W2tWi84c1f7Z+6BbOpLTtTDCmtWLAnzd6z71e
	abAsN6dcq7515si8a/QW8JLMh4xQM/Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774524; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=1QfA9obPswGJtaazWa7wtlqPBE8fA3np3bpzuNLaVkE=;
	b=bwtpUSU5fjKkKb1vLADNVp+xUJKdf4aNqdsaa0+7bOY7T9+c+ejaRP8+sQDYjeE1v3ZkKw+AlSTzCf78kS1C1r/pQGuNhPkXDl02uCPYqqm2kafLjbw5Rzd3p+1gkRBHxwn4tEPK4R5UyHbhMNFOd6TXgZ7OTly5HCGV8bowHlE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X56TKAw_1781774519;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56TKAw_1781774519 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:22:02 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com
Subject: [PATCH v15 6/9] arm64: support copy_mc_[user]_highpage()
Date: Thu, 18 Jun 2026 17:21:20 +0800
Message-ID: <20260618092124.3901230-7-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
References: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74FCF180002
X-Rspam-User: 
X-Stat-Signature: zqsa55mgreiw3pp7ztnzxzqjo4fikypt
X-Rspamd-Server: rspam09
X-HE-Tag: 1781774528-53117
X-HE-Meta: U2FsdGVkX1+Cpys2umSkNoS1F02N5mGKVzehAi9YLV/q7o1zTSSmoVSFC1iQI3KbS1DokUU1KdE13zQew46ijORsrUlDRKhO3gigV+GU8UryFLFxKR+yYJOLVkxpx1NjVLMW6yaV0N4spDK4h9BM1v+m0nKYixOyqghlJzTaC/9wqvJB+3vypBnGh+SL1mBJRac1xmEbsz/CIuTURYzmJOsBkrs+ytOfZBaOiEdIPYh1ZFBpYztQMf5/Z+q7E/ng4yJvwdolDbn/ifHFxT9ErVbfW2XzHFvdtV9ph37tHDM7k013nX7uL0j+CQgRl8j5lCod2nR/gT7/YM5DuAWXeeV68e1vzEe0/AdExhtpBlUKsEc8eUk5BEH/V3ntyB1l4eOkGxkzxLRRdiKu/t1sMQxuTIHPqhiWFHV6+cu1YadV9jpAT40ddGzgpZCjs/uQWczFAHR3u1a+mu8P6nA/yoxQcHHXq+EpwzvH8RqE8BTf28vBVtlmC9AaxSbkhSAE7S2z1Ij0kRlMV52ePEKiRAHvOtRsMSdmg37rctDqUtP/wZ2480iBvZcW5zzK+vM6yq/HsiVMUwZEv8UydVaUx30iKt7WLmad8zYqjn10BOMHUIIFmbidnrLNl+K9e8H0CltSfTqgvcTDaC6ZoKqEvnM8Gbr4LOXiNw0QM8kEcw1YFPIDtBNtF2wxSSHJf+bgbFlbmBQe9j4pdfOPf4qlWc2tTfaBaZRfg0woo8gFS3OK1poPtw9WVnBu82p8Un57mWxaRfllTsx4s/IEhAGVR3HL286VJbTYBjJ/1GpIgNyYK4UPVq6cAFVv3NKjwRwudXoh4KN/A8SW4AzH/f/Tr9dlzEnWDhYgHNk5bg/Hy0QruyYrno/+TMEM9F76nl3QOMzQ2QwWcj9JqEEMuXLtYejKob2hftrWynpFVqZk4PKtRp0Q/VRM1aqVccFEYhnHCpsJD6pET1mbmktim06
 i+fc1ccU
 kPfg6Pgob7Ol9ICESzl1FynMeiDsTQUQoY3I/vbp9DyOBYZvo2Q3H07tkxVQWHMhdFBLem8RYuMSY8uNbOsXaBJp636eu5iPxItxFuIg4N8chpvgxoobydYktwt9WaOQ9PapCYAWrkK3zdui4f2zaNiDl8bpII9AqiVkZGCrgTdVncR5Wto/goEvdgkHhRlFqSZBKsHdFW/8gTDSxFfnuWj1euWirUFYwdtvbUjsLW3dHejML3Enhfvzev4BXY+v4jzAFtaxTB1fvfCT5UluTjnUX5TpLVkZgdba1QrF+crybJbt6pHX5tyvxbPUUqVg7pzHCeXj6fjNWBPLVUtdOZRfxB5+t/a/yGl/t05Iu7aNoFPHKfSOzFshL134WB+hZHEZFExGvVR/avQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tong Tiangen <tongtiangen@huawei.com>

Currently, many scenarios that can tolerate memory errors when copying page
have been supported in the kernel[1~9], all of which are implemented by
copy_mc_[user]_highpage(). arm64 should also support this mechanism.

Due to mte, arm64 needs to have its own copy_mc_[user]_highpage()
architecture implementation, macros __HAVE_ARCH_COPY_MC_HIGHPAGE and
__HAVE_ARCH_COPY_MC_USER_HIGHPAGE have been added to control it.

Add new helper copy_mc_page() which provide a page copy implementation with
hardware memory error safe. The code logic of copy_mc_page() is the same as
copy_page(), the main difference is that the ldp insn of copy_mc_page()
contains the fixup type EX_TYPE_KACCESS_SEA, therefore, the
main logic is extracted to copy_page_template.S. In addition, the fixup of
MOPS insn is not considered at present.

[Ruidong: add FEAT_MOPS support]

[1] commit d302c2398ba2 ("mm, hwpoison: when copy-on-write hits poison, take page offline")
[2] commit 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
[3] commit 6b970599e807 ("mm: hwpoison: support recovery from ksm_might_need_to_copy()")
[4] commit 98c76c9f1ef7 ("mm/khugepaged: recover from poisoned anonymous memory")
[5] commit 12904d953364 ("mm/khugepaged: recover from poisoned file-backed memory")
[6] commit 658be46520ce ("mm: support poison recovery from copy_present_page()")
[7] commit aa549f923f5e ("mm: support poison recovery from do_cow_fault()")
[8] commit f00b295b9b61 ("fs: hugetlbfs: support poisoned recover from hugetlbfs_migrate_folio()")
[9] commit 060913999d7a ("mm: migrate: support poisoned recover from migrate folio")

Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/asm-extable.h |  4 ++
 arch/arm64/include/asm/mte.h         |  9 ++++
 arch/arm64/include/asm/page.h        | 12 +++++
 arch/arm64/lib/Makefile              |  2 +
 arch/arm64/lib/copy_mc_page.S        | 44 +++++++++++++++
 arch/arm64/lib/copy_page.S           | 67 ++++-------------------
 arch/arm64/lib/copy_page_template.S  | 70 ++++++++++++++++++++++++
 arch/arm64/lib/mte.S                 | 29 ++++++++++
 arch/arm64/mm/copypage.c             | 80 ++++++++++++++++++++++++++++
 include/linux/highmem.h              |  8 +++
 11 files changed, 270 insertions(+), 56 deletions(-)
 create mode 100644 arch/arm64/lib/copy_mc_page.S
 create mode 100644 arch/arm64/lib/copy_page_template.S

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..831b20d45893 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -21,6 +21,7 @@ config ARM64
 	select ARCH_HAS_CACHE_LINE_SIZE
 	select ARCH_HAS_CC_PLATFORM
 	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
+	select ARCH_HAS_COPY_MC if ACPI_APEI_GHES
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/include/asm/asm-extable.h
index 8450ec5a3af6..9305ea77482a 100644
--- a/arch/arm64/include/asm/asm-extable.h
+++ b/arch/arm64/include/asm/asm-extable.h
@@ -10,6 +10,10 @@
 #define EX_TYPE_ACCESS_ERR_ZERO		2
 #define EX_TYPE_UACCESS_CPY		3
 #define EX_TYPE_LOAD_UNALIGNED_ZEROPAD	4
+/*
+ * Kernel access: used in kernel context for both regular load/store
+ * instructions and MOPS (memory copy/set) instructions.
+ */
 #define EX_TYPE_KACCESS_SEA		5
 
 /* Data fields for EX_TYPE_ACCESS_ERR_ZERO */
diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 7f7b97e09996..a0b1757f4847 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -98,6 +98,11 @@ static inline bool try_page_mte_tagging(struct page *page)
 void mte_zero_clear_page_tags(void *addr);
 void mte_sync_tags(pte_t pte, unsigned int nr_pages);
 void mte_copy_page_tags(void *kto, const void *kfrom);
+
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+int mte_copy_mc_page_tags(void *kto, const void *kfrom);
+#endif
+
 void mte_thread_init_user(void);
 void mte_thread_switch(struct task_struct *next);
 void mte_cpu_setup(void);
@@ -134,6 +139,10 @@ static inline void mte_sync_tags(pte_t pte, unsigned int nr_pages)
 static inline void mte_copy_page_tags(void *kto, const void *kfrom)
 {
 }
+static inline int mte_copy_mc_page_tags(void *kto, const void *kfrom)
+{
+	return 0;
+}
 static inline void mte_thread_init_user(void)
 {
 }
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index e25d0d18f6d7..5c4c9f974b68 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -29,6 +29,18 @@ void copy_user_highpage(struct page *to, struct page *from,
 void copy_highpage(struct page *to, struct page *from);
 #define __HAVE_ARCH_COPY_HIGHPAGE
 
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+int copy_mc_page(void *to, const void *from);
+#define __HAVE_ARCH_COPY_MC_PAGE
+
+int copy_mc_highpage(struct page *to, struct page *from);
+#define __HAVE_ARCH_COPY_MC_HIGHPAGE
+
+int copy_mc_user_highpage(struct page *to, struct page *from,
+		unsigned long vaddr, struct vm_area_struct *vma);
+#define __HAVE_ARCH_COPY_MC_USER_HIGHPAGE
+#endif
+
 struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 						unsigned long vaddr);
 #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 448c917494f3..1f4c3f743a20 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -7,6 +7,8 @@ lib-y		:= clear_user.o delay.o copy_from_user.o		\
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
 
+lib-$(CONFIG_ARCH_HAS_COPY_MC) += copy_mc_page.o
+
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
 obj-$(CONFIG_ARM64_MTE) += mte.o
diff --git a/arch/arm64/lib/copy_mc_page.S b/arch/arm64/lib/copy_mc_page.S
new file mode 100644
index 000000000000..f936e0c98611
--- /dev/null
+++ b/arch/arm64/lib/copy_mc_page.S
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/assembler.h>
+#include <asm/page.h>
+#include <asm/cpufeature.h>
+#include <asm/alternative.h>
+#include <asm/asm-extable.h>
+#include <asm/asm-uaccess.h>
+
+/*
+ * Copy a page from src to dest (both are page aligned) with memory error safe
+ *
+ * Parameters:
+ *	x0 - dest
+ *	x1 - src
+ * Returns:
+ * 	x0 - Return 0 if copy success, or -EFAULT if anything goes wrong
+ *	     while copying.
+ */
+	.macro ldp1 reg1, reg2, ptr, val
+	KERNEL_SEA(9998f, ldp \reg1, \reg2, [\ptr, \val])
+	.endm
+
+	.macro cpy1 dst, src, count
+	.arch_extension mops
+	KERNEL_SEA(9998f, cpypwn [\dst]!, [\src]!, \count!)
+	KERNEL_SEA(9998f, cpymwn [\dst]!, [\src]!, \count!)
+	KERNEL_SEA(9998f, cpyewn [\dst]!, [\src]!, \count!)
+	.endm
+
+SYM_FUNC_START(__pi_copy_mc_page)
+#include "copy_page_template.S"
+
+	mov x0, #0
+	ret
+
+9998:	mov x0, #-EFAULT
+	ret
+
+SYM_FUNC_END(__pi_copy_mc_page)
+SYM_FUNC_ALIAS(copy_mc_page, __pi_copy_mc_page)
+EXPORT_SYMBOL(copy_mc_page)
diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index e6374e7e5511..e520777b5150 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -17,65 +17,20 @@
  *	x0 - dest
  *	x1 - src
  */
-SYM_FUNC_START(__pi_copy_page)
-#ifdef CONFIG_AS_HAS_MOPS
-	.arch_extension mops
-alternative_if_not ARM64_HAS_MOPS
-	b	.Lno_mops
-alternative_else_nop_endif
-
-	mov	x2, #PAGE_SIZE
-	cpypwn	[x0]!, [x1]!, x2!
-	cpymwn	[x0]!, [x1]!, x2!
-	cpyewn	[x0]!, [x1]!, x2!
-	ret
-.Lno_mops:
-#endif
-	ldp	x2, x3, [x1]
-	ldp	x4, x5, [x1, #16]
-	ldp	x6, x7, [x1, #32]
-	ldp	x8, x9, [x1, #48]
-	ldp	x10, x11, [x1, #64]
-	ldp	x12, x13, [x1, #80]
-	ldp	x14, x15, [x1, #96]
-	ldp	x16, x17, [x1, #112]
-
-	add	x0, x0, #256
-	add	x1, x1, #128
-1:
-	tst	x0, #(PAGE_SIZE - 1)
 
-	stnp	x2, x3, [x0, #-256]
-	ldp	x2, x3, [x1]
-	stnp	x4, x5, [x0, #16 - 256]
-	ldp	x4, x5, [x1, #16]
-	stnp	x6, x7, [x0, #32 - 256]
-	ldp	x6, x7, [x1, #32]
-	stnp	x8, x9, [x0, #48 - 256]
-	ldp	x8, x9, [x1, #48]
-	stnp	x10, x11, [x0, #64 - 256]
-	ldp	x10, x11, [x1, #64]
-	stnp	x12, x13, [x0, #80 - 256]
-	ldp	x12, x13, [x1, #80]
-	stnp	x14, x15, [x0, #96 - 256]
-	ldp	x14, x15, [x1, #96]
-	stnp	x16, x17, [x0, #112 - 256]
-	ldp	x16, x17, [x1, #112]
+	.macro ldp1 reg1, reg2, ptr, val
+	ldp \reg1, \reg2, [\ptr, \val]
+	.endm
 
-	add	x0, x0, #128
-	add	x1, x1, #128
-
-	b.ne	1b
-
-	stnp	x2, x3, [x0, #-256]
-	stnp	x4, x5, [x0, #16 - 256]
-	stnp	x6, x7, [x0, #32 - 256]
-	stnp	x8, x9, [x0, #48 - 256]
-	stnp	x10, x11, [x0, #64 - 256]
-	stnp	x12, x13, [x0, #80 - 256]
-	stnp	x14, x15, [x0, #96 - 256]
-	stnp	x16, x17, [x0, #112 - 256]
+	.macro cpy1 dst, src, count
+	.arch_extension mops
+	cpypwn [\dst]!, [\src]!, \count!
+	cpymwn [\dst]!, [\src]!, \count!
+	cpyewn [\dst]!, [\src]!, \count!
+	.endm
 
+SYM_FUNC_START(__pi_copy_page)
+#include "copy_page_template.S"
 	ret
 SYM_FUNC_END(__pi_copy_page)
 SYM_FUNC_ALIAS(copy_page, __pi_copy_page)
diff --git a/arch/arm64/lib/copy_page_template.S b/arch/arm64/lib/copy_page_template.S
new file mode 100644
index 000000000000..e5afbeaaad25
--- /dev/null
+++ b/arch/arm64/lib/copy_page_template.S
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ */
+
+/*
+ * Copy a page from src to dest (both are page aligned)
+ *
+ * Parameters:
+ *	x0 - dest
+ *	x1 - src
+ */
+dstin	.req	x0
+src	.req	x1
+
+#ifdef CONFIG_AS_HAS_MOPS
+alternative_if_not ARM64_HAS_MOPS
+	b	.Lno_mops
+alternative_else_nop_endif
+	mov	x2, #PAGE_SIZE
+	cpy1	dst, src, x2
+	b	.Lexitfunc
+.Lno_mops:
+#endif
+
+	ldp1	x2, x3, x1, #0
+	ldp1	x4, x5, x1, #16
+	ldp1	x6, x7, x1, #32
+	ldp1	x8, x9, x1, #48
+	ldp1	x10, x11, x1, #64
+	ldp1	x12, x13, x1, #80
+	ldp1	x14, x15, x1, #96
+	ldp1	x16, x17, x1, #112
+
+	add	x0, x0, #256
+	add	x1, x1, #128
+1:
+	tst	x0, #(PAGE_SIZE - 1)
+
+	stnp	x2, x3, [x0, #-256]
+	ldp1	x2, x3, x1, #0
+	stnp	x4, x5, [x0, #16 - 256]
+	ldp1	x4, x5, x1, #16
+	stnp	x6, x7, [x0, #32 - 256]
+	ldp1	x6, x7, x1, #32
+	stnp	x8, x9, [x0, #48 - 256]
+	ldp1	x8, x9, x1, #48
+	stnp	x10, x11, [x0, #64 - 256]
+	ldp1	x10, x11, x1, #64
+	stnp	x12, x13, [x0, #80 - 256]
+	ldp1	x12, x13, x1, #80
+	stnp	x14, x15, [x0, #96 - 256]
+	ldp1	x14, x15, x1, #96
+	stnp	x16, x17, [x0, #112 - 256]
+	ldp1	x16, x17, x1, #112
+
+	add	x0, x0, #128
+	add	x1, x1, #128
+
+	b.ne	1b
+
+	stnp	x2, x3, [x0, #-256]
+	stnp	x4, x5, [x0, #16 - 256]
+	stnp	x6, x7, [x0, #32 - 256]
+	stnp	x8, x9, [x0, #48 - 256]
+	stnp	x10, x11, [x0, #64 - 256]
+	stnp	x12, x13, [x0, #80 - 256]
+	stnp	x14, x15, [x0, #96 - 256]
+	stnp	x16, x17, [x0, #112 - 256]
+.Lexitfunc:
diff --git a/arch/arm64/lib/mte.S b/arch/arm64/lib/mte.S
index 5018ac03b6bf..1afe3ef1502c 100644
--- a/arch/arm64/lib/mte.S
+++ b/arch/arm64/lib/mte.S
@@ -80,6 +80,35 @@ SYM_FUNC_START(mte_copy_page_tags)
 	ret
 SYM_FUNC_END(mte_copy_page_tags)
 
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+/*
+ * Copy the tags from the source page to the destination one with memory error safe
+ *   x0 - address of the destination page
+ *   x1 - address of the source page
+ * Returns:
+ *   x0 - Return 0 if copy success, or
+ *        -EFAULT if anything goes wrong while copying.
+ */
+SYM_FUNC_START(mte_copy_mc_page_tags)
+	mov	x2, x0
+	mov	x3, x1
+	multitag_transfer_size x5, x6
+1:
+KERNEL_SEA(2f, ldgm	x4, [x3])
+	stgm	x4, [x2]
+	add	x2, x2, x5
+	add	x3, x3, x5
+	tst	x2, #(PAGE_SIZE - 1)
+	b.ne	1b
+
+	mov x0, #0
+	ret
+
+2:	mov x0, #-EFAULT
+	ret
+SYM_FUNC_END(mte_copy_mc_page_tags)
+#endif
+
 /*
  * Read tags from a user buffer (one tag per byte) and set the corresponding
  * tags at the given kernel address. Used by PTRACE_POKEMTETAGS.
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index cd5912ba617b..c22918ed0f3c 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -72,3 +72,83 @@ void copy_user_highpage(struct page *to, struct page *from,
 	flush_dcache_page(to);
 }
 EXPORT_SYMBOL_GPL(copy_user_highpage);
+
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+/*
+ * Return -EFAULT if anything goes wrong while copying page or mte.
+ */
+int copy_mc_highpage(struct page *to, struct page *from)
+{
+	void *kto = page_address(to);
+	void *kfrom = page_address(from);
+	struct folio *src = page_folio(from);
+	struct folio *dst = page_folio(to);
+	unsigned int i, nr_pages;
+	int ret;
+
+	ret = copy_mc_page(kto, kfrom);
+	if (ret)
+		return -EFAULT;
+
+	if (kasan_hw_tags_enabled())
+		page_kasan_tag_reset(to);
+
+	if (!system_supports_mte())
+		return 0;
+
+	if (folio_test_hugetlb(src)) {
+		if (!folio_test_hugetlb_mte_tagged(src) ||
+		    from != folio_page(src, 0))
+			return 0;
+
+		WARN_ON_ONCE(!folio_try_hugetlb_mte_tagging(dst));
+
+		/*
+		 * Populate tags for all subpages.
+		 *
+		 * Don't assume the first page is head page since
+		 * huge page copy may start from any subpage.
+		 */
+		nr_pages = folio_nr_pages(src);
+		for (i = 0; i < nr_pages; i++) {
+			kfrom = page_address(folio_page(src, i));
+			kto = page_address(folio_page(dst, i));
+			ret = mte_copy_mc_page_tags(kto, kfrom);
+			if (ret)
+				return -EFAULT;
+		}
+		folio_set_hugetlb_mte_tagged(dst);
+	} else if (page_mte_tagged(from)) {
+		/* It's a new page, shouldn't have been tagged yet */
+		WARN_ON_ONCE(!try_page_mte_tagging(to));
+
+		ret = mte_copy_mc_page_tags(kto, kfrom);
+		if (ret)
+			return -EFAULT;
+		set_page_mte_tagged(to);
+	}
+	/*
+	 * memory_failure_queue() is not called here because on arm64
+	 * the firmware (GHES) has already reported the hardware memory
+	 * error and queued the page for memory_failure() handling via
+	 * ghes_do_memory_failure().
+	 */
+	return 0;
+}
+EXPORT_SYMBOL(copy_mc_highpage);
+
+int copy_mc_user_highpage(struct page *to, struct page *from,
+			unsigned long vaddr, struct vm_area_struct *vma)
+{
+	int ret;
+
+	ret = copy_mc_highpage(to, from);
+	if (ret)
+		return ret;
+
+	flush_dcache_page(to);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(copy_mc_user_highpage);
+#endif
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 18dc4aca4aa1..f168c9d4ad0e 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -424,6 +424,7 @@ static inline void copy_highpage(struct page *to, struct page *from)
 #endif
 
 #ifdef copy_mc_to_kernel
+#ifndef __HAVE_ARCH_COPY_MC_USER_HIGHPAGE
 /*
  * If architecture supports machine check exception handling, define the
  * #MC versions of copy_user_highpage and copy_highpage. They copy a memory
@@ -449,7 +450,9 @@ static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 
 	return ret ? -EFAULT : 0;
 }
+#endif
 
+#ifndef __HAVE_ARCH_COPY_MC_HIGHPAGE
 static inline int copy_mc_highpage(struct page *to, struct page *from)
 {
 	unsigned long ret;
@@ -468,20 +471,25 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 
 	return ret ? -EFAULT : 0;
 }
+#endif
 #else
+#ifndef __HAVE_ARCH_COPY_MC_USER_HIGHPAGE
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
 {
 	copy_user_highpage(to, from, vaddr, vma);
 	return 0;
 }
+#endif
 
+#ifndef __HAVE_ARCH_COPY_MC_HIGHPAGE
 static inline int copy_mc_highpage(struct page *to, struct page *from)
 {
 	copy_highpage(to, from);
 	return 0;
 }
 #endif
+#endif
 
 static inline void memcpy_page(struct page *dst_page, size_t dst_off,
 			       struct page *src_page, size_t src_off,
-- 
2.39.3


