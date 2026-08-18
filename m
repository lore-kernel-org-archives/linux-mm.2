Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F928C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EF6B6B07CA; Tue, 18 Aug 2026 10:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A05B6B07CB; Tue, 18 Aug 2026 10:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD746B07CE; Tue, 18 Aug 2026 10:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3E146B07CA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 677AFC02A6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:19 +0000 (UTC)
X-FDA: 85114579998.18.1C6C9C2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8C1D91C0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DijChpUd;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062337;
	b=u/szULUuvIw86lTiQqTC9U+ck+Xa6qH+uKg8JFg4bveiKo3Qs2u+Il/Ivnt0c6NQWYsosC
	OtK5r4Jhtal3uB6FtjG4dtXWAW7Qr/wHeC3WWNUk4Wxn/XlF6pSSjDldeVdsSQhidsUfVt
	xmuNKXTIG6WZQ5K/2yP8WpWjxHelPYQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DijChpUd;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8iB9G7RpDcnb+97PZ+8AwUL+hlHtRZxbva7Wv/6m+Y=;
	b=k2Er0AcnghhZUon3+yAJsw2z86sVVX03kNqhmLQGwhMfu64+DdiX1qIg/A0GV3qg+QFRNc
	c5dO16POlLnUqG5kFrL1pNdM+rJMi2xYQkoCn1xsYHEC+93FtgZh2x6K+K2SmREzY3T3n7
	zPnItk0GgqwNxr80DJC26DsYuWEDwkE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F03EE19F0;
	Tue, 18 Aug 2026 07:12:12 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3566E3F85F;
	Tue, 18 Aug 2026 07:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062336; bh=/3l8zOUYVj+WOkd0xAlju+IzOxqp5kEU0RRVT0zZ9Bw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DijChpUdF1RuBdkyLFATeOsiSAmz3vRvsbQu9Xf4r8fSCwkLPYeX2u4TqhHmuvK5v
	 bEA78LX2fa1R1gpIgUtzR5f05+sSjB9A7FnAX66ViZQxIp8GFqGwo92X07hrUbqCmL
	 RxLHMp+W+M6Qq0IWBi4KLPfjUbXSDVaC+IE4DK+w=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:53 +0100
Subject: [PATCH RFC v9 11/25] mm: kpkeys: Introduce
 kpkeys_hardened_pgtables feature
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-11-743ad31b2c8f@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=5593;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=/3l8zOUYVj+WOkd0xAlju+IzOxqp5kEU0RRVT0zZ9Bw=;
 b=qTIS+Q2f7O/ftDpgcOtYPcie0+ZP70DESK0YuE6VZ35VxabKw7HIm6ZYoMNyRRP8plVUnpJTj
 ukEN7bDubSeA5X5+HECw13im2U5oHjzFkg4rQuW3Ysw2V1t7wzyGZku
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: 8C1D91C0006
X-Rspam-User: 
X-Stat-Signature: qom57xnedd1upyihzgh89qb8r4wqs7mb
X-Rspamd-Server: rspam06
X-HE-Tag: 1787062337-863189
X-HE-Meta: U2FsdGVkX18qswJ+YdWI1nw6/zFwVGjnfLx47KgfQnLYi/4I3Zq9mRwfQe1u4U1KXZT8I+ixckUyLbQmnvnpYJjBg1t3PQx0oYvCEChKQlMrJKS3im85jBOmvLXMvzZtgcOnVyUQJPa0iSsyBC08wol7lgXy2N7eiywmU50u0H9XYDs2CXvavnwz0lL2PhYFGDFDe5H73juTBCJeMjvENv/+JbjfDp6qbb4g1Q7tuAxcSYbdEd+s+SdOoVjtiQl9RmXUa3Oi4sgBahAqdgDlGfOxE2o6swP83EOYlDvAWI41pjZzQj4pajxJbrHOKP+/j8Lm39+Ho6io/yXpdF4gwk486qTRgSKNtneN/eZYif3E5+q4kpC+e8z0p/5FQ9mCDxtg94z6jLHhthGrDwLhBPB47mtIoj+r0OaCHsYDozpFmQqQThmay4ufuTfZHow2HLq4SXoYbgBcnMzilPtOkY3u+MdcsrwGOf8mJVE7/IAmcAQYNxPX2Exmg0snW0Du9TwfunQ2HOEqb7n+okCJbzoDL7Wf7O0B3aq+0BHjSoOuQJLFBV4OjRo1U5wap2McA38ySpKez2P59Z3Y96slGcRGjq9EzHRVIehJFLYY0SAp9BZ8GCT1uJI+JH3Y9PR3VjycWRUlzOMFyfTnYp0X3ecRKiZoYL6+LRYDhqX1qpqS8uKCU1sno13nX1AAGhnl2BwVkA1uGFK7RpKpb5q+NOtBFwZSl/uKnjIVuVkQ4tak40s5BCPqpeUUbURCb+d8FOff9uFq8suSOfMju5Retm7RcHyBfwwJGfAnWIfN7szhDdbnGluDtGePY2qCeretA3Gf4ZBugGwXX/Bn4e6a6kGDgDMdrEkq2ZoixMCBs27pUyf8ya/gBQ9QbXgaxc+bzeyHfgLnbN0shqKZJrqEYJaoia6xCW3dpGe2Tj+QXJH7d2KM2AMAtIl3NFhB1bjxmfpeGA/kT1UiQT0C1YK
 Enx5ZzaN
 7XHCp4oXkBr3Dpd101wS/pSBpSha3Gh6dluneHdQrv2PQHd9wKZ7acuch0XqqkhPYksdITxs47a24sCtRFe5QrNKy2+XfSftoQsqBWQFHM07xbbaeGzfp4BLabAdEcvlbxfXkGmEJ5uQDOCPvrAiGMhzl6WahpX3/t50yEyUOcLiFbHxofUd1fAD5Z/yoRxRa3ZxRxCYatDDbGdYKD7t10j82dJcjEbdd5848nRXku4xIsOPqWyk2Tf9QE1sngT7asKqylcpC4aULSikAoj7Sjq3KjiM2gF3NKELmXR/77YK19VHac7FX+dk1/gY7HdLHe34qsyxEzn0v6Lekvd4VYAu5Rg==
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

Because this feature relies on kpkeys being supported and modifies
attributes of the linear map, it must be inactive on boot.
kpkeys_hardened_pgtables_init() enables it by toggling a static key;
this function must be called by supported architectures in
mem_init(), before any call to pagetable_alloc() is made.

Supported architectures must also provide
arch_supports_kpkeys_early() in <asm/kpkeys.h>. This will be used
during early boot to detect whether kpkeys_hardened_pgtables is
going to be enabled (e.g. to decide how to allocate early page
tables).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/kpkeys_types.h  |  5 +++++
 mm/Kconfig                    |  3 +++
 mm/Makefile                   |  1 +
 mm/kpkeys_hardened_pgtables.c | 16 ++++++++++++++++
 security/Kconfig.hardening    | 12 ++++++++++++
 6 files changed, 74 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index eac522f55214..23ae4ed512f5 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -4,6 +4,7 @@
 
 #include <linux/bug.h>
 #include <linux/cleanup.h>
+#include <linux/jump_label.h>
 #include <linux/kpkeys_types.h>
 
 /**
@@ -101,4 +102,40 @@ static inline bool kpkeys_supported(void)
 
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
diff --git a/include/linux/kpkeys_types.h b/include/linux/kpkeys_types.h
index 9de59092e9c3..09f15a9565cf 100644
--- a/include/linux/kpkeys_types.h
+++ b/include/linux/kpkeys_types.h
@@ -8,10 +8,15 @@
 #include <asm/kpkeys_types.h>
 #endif
 
+#ifndef KPKEYS_PKEY_PGTABLES
+#define KPKEYS_PKEY_PGTABLES	1
+#endif
+
 #if defined(CONFIG_ARCH_HAS_KPKEYS) && !defined(__ASSEMBLY__)
 
 enum kpkeys_ctx {
 	KPKEYS_CTX_DEFAULT = 0,
+	KPKEYS_CTX_PGTABLES,
 	KPKEYS_CTX_COUNT,
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 55e6763d5792..21bd3e550de8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1283,6 +1283,9 @@ config ARCH_HAS_PKEYS
 	bool
 config ARCH_HAS_KPKEYS
 	bool
+config ARCH_HAS_KPKEYS_HARDENED_PGTABLES
+	bool
+	depends on ARCH_HAS_KPKEYS
 
 config ARCH_USES_PG_ARCH_2
 	bool
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..35982b6efb56 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES) += kpkeys_hardened_pgtables.o
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
new file mode 100644
index 000000000000..4c654e0cf585
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
+	if (!kpkeys_supported())
+		return;
+
+	static_branch_enable(&kpkeys_hardened_pgtables_key);
+}
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 6923036e1a2f..bb75b580b7f1 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -271,6 +271,18 @@ config BUG_ON_DATA_CORRUPTION
 
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


