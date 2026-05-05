Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E70FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5D16B00CD; Tue,  5 May 2026 12:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0605B6B00CE; Tue,  5 May 2026 12:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91E96B00CF; Tue,  5 May 2026 12:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3C996B00CD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D6FC1C041B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:56 +0000 (UTC)
X-FDA: 84733847352.30.07DBADB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE29B40006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oDYOzeRr;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rJQQXqc/pgs4y72MEHaFoTC6kS2XVmfoerGcbGJgWc=;
	b=A3kKznwmHUirsZnv50GwpVl4qg923178h6LfnJwyltnYWN+v97u4ZXE8mvFfvZGrvfNLV4
	Lp6xvE18apv//YCVpmMb09glBmbEIcBs6LKO40NN5POpxVxTvKgVsEXcbQb08CSaBNn/WG
	oXEox9uoqbFV3Mv2DoW7eq0QeFHd+rE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oDYOzeRr;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997274; a=rsa-sha256;
	cv=none;
	b=BWjv3gAogM+/do6FiSgF7b0la9MOKmz/OT+ES6UpjMfu3m0MB+YVkZth1aZf1NIgkYdke1
	T4L1CdALtL7oGydoKtBvmI7tCPWp60s9wnXidGIOlL9XqXMNaWpJE1j/fv5pOD+x7qzteo
	tbqUeMq8k5sNe3AnrGQdGg5aUHvuxcc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F7002681;
	Tue,  5 May 2026 09:07:48 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA3DA3F763;
	Tue,  5 May 2026 09:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997273; bh=ozeOAdr3jlygQ+LzFQQTepylRW4GqnLBcYHZvpRCf6g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oDYOzeRrxGkb6WgoF0/tyhcey0msj2rO63eaDHL/bZMbXnLNk38qmc2noaeoKNg8i
	 j8Z/2K7AQVJRPSMdDymRQUZUTGRMnJcfZLiSBSBMLyV7UxJ+P7EpkRcli994jTEJGD
	 Oc0LULVHGtjY3GvmDi9RsdzEtatCBoO9JuZW+ySQ=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:00 +0100
Subject: [PATCH RFC v7 11/24] mm: kpkeys: Introduce
 kpkeys_hardened_pgtables feature
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-11-20c0bdd97197@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=5877;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=ozeOAdr3jlygQ+LzFQQTepylRW4GqnLBcYHZvpRCf6g=;
 b=eU7WrOKEsysSiJ7rQ1VLcmV9b9H85aOAXkzAXSutH6Aajlxhc3Iyh95ydDqhVRFPKQr6UUuUE
 QFdbj/hha2nBMtl+J4l+gDkDdlWAalvI6ADOBzdJcUQAWtlYjqbGbgX
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE29B40006
X-Stat-Signature: qiigka4qi8mmqw49ikeqyuasfx6nkppy
X-HE-Tag: 1777997274-997726
X-HE-Meta: U2FsdGVkX19j9/GxNUe1YeOqc/mVAlRrlS+M2JiL9b94oig5Fq6LlxjM6Qd9x/3VbZIqHw4Q4MoFxB86zeCnVvOyK35k7U/ZIDxaJpDw7qtzvukv1SpSWvgoYQ+woHGKB+ZuernIvast1J5Ast/h4fBXIT0lXzeqeqIkClc/Xi6yiTDnKouilv3Y4U9XYZTPBoI/+Tv/FpyVDXiSOenVKKCeQng7fwdbZyDtDcsEc/ONBCnTPGC4JGbMNkH2HmOUrXARsxJ9ZNxDAG8uuOqpaMt5U/5/e3MPw6laWCNbhWDegQ+DQE2ijqUlOtoflcg+5XWMHI5kP00ZdNfkjWw3nhikW+omErShY1M1KJm4eN+OATFpYWlQmv8qxrpZ0SQIFFVc7erhcwejFZJLM0Q49R6PrDaCZUMQfWflS6wt9CFzHGG3KVP83gTuKXMuBooFE0WdnFadtvJcBQkaBmOGgJ7OYKmD9S1DztK9rG/vCbwK+g10fuMixu9/XhrBneJvFb5NekXeYMLgqVnRl/kuDye+KsBluZhQ9VgaWzUjzk68FsLKxSvJEIAEQ1DQWjIvuRG3/avm3VeLMR2+ve0xOJ1ooax/DacKehqC/FL1kr6TSQPZyoc617jV9XjUXDebdpkERficGw7+zJ+cwpQC46ZD7taeBLQAaGiJx3JX8xock1XvcPKvBHgfUJb4I1J/sHgNr9GDa/rHSL/Fu4OIdBJUXSqE8MPWt3hiQmPwgIHBWSsFXNSiYVcY36khQFPJA6DtwWSm09VLNSC1FEbb07yER2Oi7EsRsli9ckrGtVNCGxgkJHeB/Gj61gRZD78p46OEFYOqTbtVSwX3X9kDxmL52SicwL0m0cyThxoGxRZbkn2mXgrURrV3EONY/ZhLbivk8yk5p/+AEWD0X6Q58BCpSkwDcGuY19aU9SZLE6KKD7tlWTlN9XyOfitGELN51gnU4mvawFDP8E3LWcY
 kc5pR+Z/
 ikG5ui0t+VIaOL99UmxJFc9HevGFSde0m3Lr4cjJiZjsQWfcrfCJbr3PctEPwmzHCIUQasYDpsI5NWzYUT0W+bfVBle0od1RsJEMDk8eFZ1rqGeVfT8o8Uc8AIXpHp6RkfmgrVIlb9CLiXX1+ig/Mg2K6yFenNdlp1Tv1IKKzcdAs16m8Kk+SYEVCnLn1zTF1Ebxo1Of/2EU7QN7AY5SaI3xtQ3VSXynX9F96hzn/x27AD+fupz6YLNjAaqUQh9NZltJ75YlxImrEbj4fbuxGK0Y8FER14eNBNeFAET2mIRLDq6AXV2VkOq3mfNb2k3PcWq5VZ9lYYtW1qnQAHtNcz8f1y05CPOSfsqh3+bEIqV77jFkEQJGMei0n6Q==
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
index cb2d22758391..1ed0299ad5ac 100644
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
 
 #define __KPKEYS_GUARD(name, set_context, restore_pkey_reg, set_arg, ...) \
 	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
@@ -115,4 +117,40 @@ static inline bool kpkeys_enabled(void)
 
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
index 819fb0d7b7bd..dbba6b878d5a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1244,6 +1244,9 @@ config ARCH_HAS_PKEYS
 	bool
 config ARCH_HAS_KPKEYS
 	bool
+# ARCH_HAS_KPKEYS must be selected when selecting this option
+config ARCH_HAS_KPKEYS_HARDENED_PGTABLES
+	bool
 
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


