Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70149CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80386B00AB; Tue, 26 May 2026 07:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D316D6B00AC; Tue, 26 May 2026 07:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46F66B00AD; Tue, 26 May 2026 07:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B30D86B00AB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D59C16102F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:57 +0000 (UTC)
X-FDA: 84809321394.22.36A2719
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 88BBB1C000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Nn4RkJoL;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPe2YgoAH0qSAnCpEeNefoayIWUULTmV/B7RSEo0PbI=;
	b=6jxlH2ZcJSPJPFgP/ZZFdq52Zn0uEAoyeGWFTMnku5xvfF7psIgBJBCp8TCI/xedDWV+5Z
	Wq8Dh4WbCMhfFEeKdiGFdEwUBdU95d/WA3DSWkFL5IvG70CRvOLNXSa5nXbGRugFBx5AOP
	si8Gm7nq/Fvi5c0M4ETxrCImj9fiSHI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Nn4RkJoL;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794275; a=rsa-sha256;
	cv=none;
	b=j21xU7ewtMYhXz7AFc2CyZLfpKymc+pincuSH2Vw68IuTT+9Q+0Yjr7InaE7FhOL7mPWo5
	sAKN42aa9s2aTW46BZKOWTMbBCZ8G3EjXeXG/Ows+utEyBqVtO8YXw1cfmm8jderZ+h4Q4
	j1c3KwEFJ2jFvcPmu4BuXf5Curn6Di0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5A35169C;
	Tue, 26 May 2026 04:17:49 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E95EE3F7D8;
	Tue, 26 May 2026 04:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794274; bh=FwJkibkCBOdtFacZl+Z5KjOcoULy9AB4XvS2nXgTrfE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Nn4RkJoLmryKMcVWDZAo2G9SJrXDVC2e2IVuX/B4SuByLHEZPp3EyUsOPRPwgnKi6
	 u2JIa00peJahtdJ4OiA0FfTH8N4jRfG9r7HvRDrqlEhilfbnhdNzlAkCn7kk69m/5g
	 wdoPZfIR93zdMSoyz0ZavQj7CwZPq+wYJJ0iqOnI=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:00 +0100
Subject: [PATCH RFC v8 11/24] mm: kpkeys: Introduce
 kpkeys_hardened_pgtables feature
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-11-eaaacdacc67c@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=5797;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=FwJkibkCBOdtFacZl+Z5KjOcoULy9AB4XvS2nXgTrfE=;
 b=2cUTS8rHt18AsAstVm0NGzVThMD7m5Y67bLhIkADws+GYq1Gk7VC/5rzaVdp7P+4+Kt/pmT4Z
 oudsu0Y2wlWDejRI1Ya9DPrboy1WjZKr1FzWCgjzCZ4t/G+vItNf9AV
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: gjtag6ybbxw1eff5n8uj53z54rc3nxgg
X-Rspamd-Queue-Id: 88BBB1C000F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779794275-442102
X-HE-Meta: U2FsdGVkX18+q/4GtfVifPYoGcJ3jALNyBmWh83lGvxSK17ippcyy9A1N0iUmWwvNilT6ulam/w2SqzBYUZkfGmL0vnSA9sTQ5Lui0eiKo44W54fA03b0Zr0bZkmREaxB6G9kc72GlT1bEaudtU1ElbgOu7UpJmOOAxMMS7wBjqosvP/wPvWt/t6hbaLas3NLNrdwkPOK46vZwGW54puWBFg7liF68myd5qxkI/qulwgLN89Lvbqh60LTYIqCAMxHb/4/vQijZYEC0FQWEDC9cmxUPsFL4wh3HbLVDmc9O+DMhWHgBuF+5ZcS1HcdCnO7IA8lPQl5yHZVEE2aNgfIFYlWlHugpO9Oa5OpZirfu04wGd24eo4a5uFtQsYiHsJIcREe69dZJCRIQQ+52wXEZhVscBmbdx4uoQ66Ruzsr4qSa/9DfZU/7cHC5xgNzqXpipy2CS53EJ/iUlqcIazjK9L6BCMdl2UIN7rkZeSwJGmC1wy3cLNj9dDKuD0G8uR4smAEZXe824tHEMEDIkwL663arxgnaaQqljyIEWHWVbWwsiF2aX3eTb4U6lLgwiBlJ/SHatkbxNprQDFCG/XVzTXZaepZfCoDDOhMoTpPTeCVuaGYuNsy5kSkYM5UzZzi8JztsGsN2eEI7euROZirQxtRKipUhQnVbcw7JsdngfoZfymPuL+T/pViKDKdVvjTUip3/JXrb2L1U/VHNDhW8zSi8sO3qLZfnoSkESexZQzC4GnyThANpzBKE999mZmmOKmQwu+BqoElrR73gWfetAniIxG6zuPQQc2FCkyFJ7EdjKMBHtvI+FXUTxCimcx59nVpws93d6RBDflHikD9Xv9u2A2xP3j81B62OM870CKLoqwk9Z6wY5Soxx6IKVIHzrRsGTgjqyDGdvnvHQuabtJidsecd27WcuoZQABGrGNx80fCILolb3hLxJA+yPtmULTRnGa2KHuHvyzgDi
 5EDIIfc2
 u/pCfgpq4g62o+IPYP5veyOg+PZBBWoZb0MhOCRfM0hxISnTUN5aPqs6YPXG+8NIVVE9eQy/aSaflcsXSKMxY3Kpe5dFtnNdWpp8GYFpx7GIpq9WaiKBgZApHl6oQS/x9lZuHaX9DEjEHZEJRm+8+FTVL347KNBsN6jZNXacB4EEiRgkbdo7n7y274gYUJHCliQUb2Ame1Uvbv7I52zdvdN+sAlXar45/IWWZcJf4Pz/xS4C/Pd5GC6QosytTteVSfFC0fdnWTP/Z5Axlv1KN4jcyn6bqtg6eL6A25Nmn4yXjNknAgoqhlynrx6noJZtdxA+MWw+/ajggfHlJazbif3xhIIv4fxqPJksfBnCPGm+5lpU4STno0BO3Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kpkeys_hardened_pgtables is a hardening feature based on kpkeys. It
aims to prevent the corruption of page tables by: 1. mapping all
page table pages, both kernel and user, with a privileged pkey
(KPKEYS_PKEY_PGTABLES), and 2. granting write access to that pkey
only when running at in a privileged kpkeys context
(KPKEYS_CTX_PGTABLES). This patch introduces basic infrastructure;
the implementation of both aspects will follow.

The feature is exposed as CONFIG_KPKEYS_HARDENED_PGTABLES; it
requires explicit architecture opt-in by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES, since much of the page table
handling is arch-specific.

Because this feature relies on kpkeys being available and enabled,
and modifies attributes of the linear map, it must be inactive on
boot. kpkeys_hardened_pgtables_init() enables it by toggling a
static key; this function must be called by supported architectures
in mem_init(), before any call to pagetable_alloc() is made.

Supported architectures must also provide
arch_supports_kpkeys_early() in <asm/kpkeys.h>. This will be used
during early boot to detect whether kpkeys_hardened_pgtables is
going to be enabled (e.g. to decide how to allocate early page
tables).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/asm-generic/kpkeys.h  |  4 ++++
 include/linux/kpkeys.h        | 40 +++++++++++++++++++++++++++++++++++++++-
 mm/Kconfig                    |  3 +++
 mm/Makefile                   |  1 +
 mm/kpkeys_hardened_pgtables.c | 16 ++++++++++++++++
 security/Kconfig.hardening    | 12 ++++++++++++
 6 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/kpkeys.h b/include/asm-generic/kpkeys.h
index ab819f157d6a..cec92334a9f3 100644
--- a/include/asm-generic/kpkeys.h
+++ b/include/asm-generic/kpkeys.h
@@ -2,6 +2,10 @@
 #ifndef __ASM_GENERIC_KPKEYS_H
 #define __ASM_GENERIC_KPKEYS_H
 
+#ifndef KPKEYS_PKEY_PGTABLES
+#define KPKEYS_PKEY_PGTABLES	1
+#endif
+
 #ifndef KPKEYS_PKEY_DEFAULT
 #define KPKEYS_PKEY_DEFAULT	0
 #endif
diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 0ce0db80b4ee..d413a17f8882 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -4,11 +4,13 @@
 
 #include <linux/bug.h>
 #include <linux/cleanup.h>
+#include <linux/jump_label.h>
 
 #define KPKEYS_CTX_DEFAULT	0
+#define KPKEYS_CTX_PGTABLES	1
 
 #define KPKEYS_CTX_MIN		KPKEYS_CTX_DEFAULT
-#define KPKEYS_CTX_MAX		KPKEYS_CTX_DEFAULT
+#define KPKEYS_CTX_MAX		KPKEYS_CTX_PGTABLES
 
 /*
  * ... is used to discard extra arguments - this allows users of this macro
@@ -119,4 +121,40 @@ static inline bool kpkeys_enabled(void)
 
 #endif /* CONFIG_ARCH_HAS_KPKEYS */
 
+#ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
+
+DECLARE_STATIC_KEY_FALSE(kpkeys_hardened_pgtables_key);
+
+static inline bool kpkeys_hardened_pgtables_enabled(void)
+{
+	return static_branch_unlikely(&kpkeys_hardened_pgtables_key);
+}
+
+static inline bool kpkeys_hardened_pgtables_early_enabled(void)
+{
+	return arch_supports_kpkeys_early();
+}
+
+/*
+ * Should be called from mem_init(): as soon as the buddy allocator becomes
+ * available and before any call to pagetable_alloc().
+ */
+void kpkeys_hardened_pgtables_init(void);
+
+#else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
+static inline bool kpkeys_hardened_pgtables_enabled(void)
+{
+	return false;
+}
+
+static inline bool kpkeys_hardened_pgtables_early_enabled(void)
+{
+	return false;
+}
+
+static inline void kpkeys_hardened_pgtables_init(void) {}
+
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #endif /* _LINUX_KPKEYS_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 819fb0d7b7bd..042541d28692 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1244,6 +1244,9 @@ config ARCH_HAS_PKEYS
 	bool
 config ARCH_HAS_KPKEYS
 	bool
+config ARCH_HAS_KPKEYS_HARDENED_PGTABLES
+	bool
+	depends on ARCH_HAS_KPKEYS
 
 config ARCH_USES_PG_ARCH_2
 	bool
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..7603e6051afa 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,3 +150,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES) += kpkeys_hardened_pgtables.o
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
new file mode 100644
index 000000000000..763f267bbfe4
--- /dev/null
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kpkeys.h>
+#include <linux/mm.h>
+
+#include <kunit/visibility.h>
+
+__ro_after_init DEFINE_STATIC_KEY_FALSE(kpkeys_hardened_pgtables_key);
+EXPORT_SYMBOL_IF_KUNIT(kpkeys_hardened_pgtables_key);
+
+void __init kpkeys_hardened_pgtables_init(void)
+{
+	if (!kpkeys_enabled())
+		return;
+
+	static_branch_enable(&kpkeys_hardened_pgtables_key);
+}
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 86f8768c63d4..fdaf977d4626 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -275,6 +275,18 @@ config BUG_ON_DATA_CORRUPTION
 
 	  If unsure, say N.
 
+config KPKEYS_HARDENED_PGTABLES
+	bool "Harden page tables using kernel pkeys"
+	depends on ARCH_HAS_KPKEYS_HARDENED_PGTABLES
+	help
+	  This option makes all page tables mostly read-only by
+	  allocating them with a non-default protection key (pkey) and
+	  only enabling write access to that pkey in routines that are
+	  expected to write to page table entries.
+
+	  This option has no effect if the system does not support
+	  kernel pkeys.
+
 endmenu
 
 config CC_HAS_RANDSTRUCT

-- 
2.51.2


