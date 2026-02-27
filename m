Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF4BFEFB72
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3F56B00AC; Fri, 27 Feb 2026 12:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2646B00AE; Fri, 27 Feb 2026 12:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8A16B00AF; Fri, 27 Feb 2026 12:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54BA86B00AC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 038FAB76EB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:46 +0000 (UTC)
X-FDA: 84490992054.08.22BEFC2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B7588000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbBO07KMheiD4qpqOH6PpqEx4gFUsuJ/6QGTfjSazf4=;
	b=tWiZr6NuhbyelSMUxFy5cTlKfbcCLl1Fv2OKxAQgKhVotoWspRSG5QfLW7JkGF+UUW7b1Z
	YLBepxVWPHVUFj1VJ77DK9BcpCJ0udKJjqxCRIsrZdY+GESIhpmo7PbIzFXH5+3JhkFXcF
	0I4bjnQka5BinVpvmaCCSwsg8XBLsDE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215005; a=rsa-sha256;
	cv=none;
	b=Teao3sy/DVuBDbeuYCL/3J7+Qofnhk6TvYb5rhqeuj1D4KlJYELRUnmceB9w59I2oVqSnF
	JL5y2bwRjA0LXhYN2bIjEJYQb1UKvAukNGugIfLnEUlYSv5V1gWGWByw7xH9AdDhjhTxVC
	l0K9gsmdvFl5tMvL5WwUETNUFUrpj9E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F377176B;
	Fri, 27 Feb 2026 09:56:38 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2979F3F73B;
	Fri, 27 Feb 2026 09:56:40 -0800 (PST)
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
Subject: [PATCH v6 13/30] mm: kpkeys: Introduce kpkeys_hardened_pgtables feature
Date: Fri, 27 Feb 2026 17:55:01 +0000
Message-ID: <20260227175518.3728055-14-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B7588000F
X-Rspamd-Server: rspam07
X-Stat-Signature: fjc96dhggy3a779y6wm1zxrajamkr5di
X-Rspam-User: 
X-HE-Tag: 1772215005-773791
X-HE-Meta: U2FsdGVkX18Cvl7TliZ+pbaGiop1R7gF/WjudMUm5tSqLslawCEOpOHSEvxbbPSLIq4ve9CMEpQ8k7xrk1b7CHqxVUYHdGA0R7+Eq1FdG111wWHqsxcKI5Gmkw4IdIDjItbVrjTl/sLs2tH/Seo3yNYdzPUjc1HNKybD5005vOn5jlV+22KuM8Y9fyLvDuXlqv7qGzs1tVOWZRo5WsLFSdr35ZzbMrGY67abQzG6+63ec1WTGqE2pnOyk27ZINLyjTwhywM1tpwW0Z29s3gQvfOpDJ6Lx+pWSCyuSUEVDa5uPjd00lpGvFdFRSQSRlhevkWPxOQwXKpzXvaBf1H2dVnw4nDMUzhzf0ZddL4tjoAJNSJOgssaSI8qMznLXC+Ul6JXuW/GpaQPZCvvUhr/x6GrDMKs4gnn6UV3BzHd5fjA2Gcl1IpFzgRk3potzfVcU6+We8ooCTFwjF88JWLBp/J9NatIutD7V3/x7KNnR8CXcmdhvqueSRhoM/AB33mH9cOXokQBBCKszjmGgiihUNUqdg1wM9eJV9NBntQ+2XcGHLCc2s41nvS9sgdsFgmG/rGEVg+vIrIU0H1VbLyqdKiC9/Yna3gLZ3egHNdqY2IKuT94VJa2esj/IbXY1yV6FZA6TxyLDMy3Ptfyz0KfaNOY1ZaS2O0QYqHmc1yfDIvq611IImq/dwZtMVmDfSdXsXP1QH1Z4FjadC1KshPNFW6Nm+C2VDLoyezW4PURf/MDcrXv4/u9usAdRxhfiBjSDAL+LVkzG2RuSYflpInRGAjus3kbW6VwDFiMBIZnUmk5aFQDp54QeUmcDaQbobuv2nWTa/fu2cTp0gMIXZsLnydnUG1iBLHJjfPsk/t335DzpxP8a1pLT0BPRJX2orSRO4q5/WfyTQz9uhFAfSfRWmPzeR9mXF+RdbwvtyFfY+H1yLW2S8/m+Tu1E62Hg/qmbN55RPmSq46yzxe8zRj
 Q5njM5xH
 kmJ3kOrbviW5BYV2WgIC8soLiVkcmM54QraqscgdjAZ4E3CCJUu8MnKOTlBEp4F5s3M98JDYJLuup/J4zFhallwyLhPoBZKYGhbnyK4tIa2DRYOwXKDIKHMLIuK8lKI4sn/u9ql06Lk4uHUegqtVazEGkq7/iEl9/ytmv7bxZCquXVcIVrX2CzcBZRh/FMlimWPitXBXrxhVyq496cElKIRwErBTKQyxNi+e2DwKqgUdDxTPUSHdCCx2keedLk7CXWDPhGdRhpuIldaM=
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
only when running at a higher kpkeys level (KPKEYS_LVL_PGTABLES).
This patch introduces basic infrastructure; the implementation of
both aspects will follow.

The feature is exposed as CONFIG_KPKEYS_HARDENED_PGTABLES; it
requires explicit architecture opt-in by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES, since much of the page table
handling is arch-specific.

Because this feature relies on kpkeys being available and enabled,
and modifies attributes of the linear map, it must be inactive on
boot. kpkeys_hardened_pgtables_init() enables it by toggling a
static key; this function must be called by supported architectures
in mem_init(), before any call to pagetable_alloc() is made.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/asm-generic/kpkeys.h  |  4 ++++
 include/linux/kpkeys.h        | 30 +++++++++++++++++++++++++++++-
 mm/Kconfig                    |  3 +++
 mm/Makefile                   |  1 +
 mm/kpkeys_hardened_pgtables.c | 13 +++++++++++++
 security/Kconfig.hardening    | 12 ++++++++++++
 6 files changed, 62 insertions(+), 1 deletion(-)
 create mode 100644 mm/kpkeys_hardened_pgtables.c

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
index faa6e2615798..49af2ec76923 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -4,11 +4,13 @@
 
 #include <linux/bug.h>
 #include <linux/cleanup.h>
+#include <linux/jump_label.h>
 
 #define KPKEYS_LVL_DEFAULT	0
+#define KPKEYS_LVL_PGTABLES	1
 
 #define KPKEYS_LVL_MIN		KPKEYS_LVL_DEFAULT
-#define KPKEYS_LVL_MAX		KPKEYS_LVL_DEFAULT
+#define KPKEYS_LVL_MAX		KPKEYS_LVL_PGTABLES
 
 #define __KPKEYS_GUARD(name, set_level, restore_pkey_reg, set_arg, ...)	\
 	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
@@ -110,4 +112,30 @@ static inline bool arch_kpkeys_enabled(void)
 
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
+static inline void kpkeys_hardened_pgtables_init(void) {}
+
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #endif /* _LINUX_KPKEYS_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 2baedee59bb2..2f87ee69d16e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1245,6 +1245,9 @@ config ARCH_HAS_PKEYS
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
index 000000000000..9e4771263ad2
--- /dev/null
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kpkeys.h>
+#include <linux/mm.h>
+
+__ro_after_init DEFINE_STATIC_KEY_FALSE(kpkeys_hardened_pgtables_key);
+
+void __init kpkeys_hardened_pgtables_init(void)
+{
+	if (!arch_kpkeys_enabled())
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


