Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D4ACA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756E490021D; Fri, 15 Aug 2025 04:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7061B8E0002; Fri, 15 Aug 2025 04:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C7390021D; Fri, 15 Aug 2025 04:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5172A8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E9D71A0918
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:22 +0000 (UTC)
X-FDA: 83778385404.13.1A492ED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7EA8216000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248180; a=rsa-sha256;
	cv=none;
	b=YC7MTB5aoU6Kau/N2d4u01C0i1CeqVFF6SdTvqhG0Ycac/JeMK8d2zeZqPnvTQP+c7YEC+
	iYkm29YAOrXC4C5WtTU+BU7PTfG5Ke/sT2ssk5FTP46DbxpcdEtqGaz5z7+a2wZvLAiafc
	My/5jQz5CxjOYR7XLKVXw2sVpmfkAR4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rERn3rtGEvUrAdJLPdiij/tpOVbfy8tftDeD0deRkhg=;
	b=VIxez0hZOzWAOQQ9qSuIWaWfdSDi38m5FZKi2+a05GayIl6D8Z0k80eD8vceNyF3bPP3Q1
	l+odtA8FeI1hdxwQdGxYIwyHTfdJnX4D15Dtdd5lsXJ2hCOGqEQKrubZ3P6LRk1nNg6VgW
	tmCj3RFA7jFkRd20f8d9xvYUE6+5eNQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A38611688;
	Fri, 15 Aug 2025 01:56:11 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C4DA3F63F;
	Fri, 15 Aug 2025 01:56:15 -0700 (PDT)
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
Subject: [RFC PATCH v5 11/18] mm: Introduce kpkeys_hardened_pgtables
Date: Fri, 15 Aug 2025 09:55:05 +0100
Message-ID: <20250815085512.2182322-12-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7EA8216000D
X-Stat-Signature: og6qgdj4nd5dye5fez96d11wwx7crdeu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755248180-870808
X-HE-Meta: U2FsdGVkX18xnhW48P3SRNB9+nOp1r9+P1ml0wbvSKXgWn+CNA5KblvJCq5QJ86UGVgFJkiUbIVuiYgJ/vbqJIcK11g9Ui2XfvFfSSpcv3f3rYDHG11PAQYoLprIg9IyLQIvaR+O3Fl6YbhvJmGtD9dtUMZI0r5zryZkv//b4Al/hBMzrIW9ELCmLC2i0HV1XJc8Yty9AU2GpQ8NR1WKId0wxjVOHZDYJjgQVd54ooexEpvQEcY/TvT6f5affX6legKxQlsd87olx4nICBg/t5Lr45NkPCmdWgcP/U6RJNXXSKCCZtCrYqIMcP4nsiXxq+tm8jIeCq6d1y6xXxVlj/WETtPkvGF4+mEVqes1jqKSrX6fw7rKDUcxcifijqfzWT549EjRmT3nPrSZCKbWPtruF24B8i8CoAExHCnOj/G5QKJDpRFNxcwtGoNCt96GAzl64uh+5iokLx05z2nXcSkUnues9uX6y2C3p5fMMW6jNTkPCkhZJqoIMXu56K/tmLg4vYN/JsgpvM6Dob5etUzNaaLK/g5G9KsYsm4YFIcqZbCrS9GWdVt2M7OUqfkJ9/UA7KvUIGwdiu0QkqLY6DaDeLqBtgWiWnisI0MCSgG7VRnfIfYDXobBC1myudL59dtvbup78qN2j87j8qCxyq7pMa1G+OyJ3kpNa2/PvYRCyP3JBfgyjDiHkdrhpjjxnE/wxTpvJ7w7wr1DL63R85Y+i8wUskU+P9+sa+fUDGWzBge7BXWMc2cveYk/80f7zohH9IQccnLtG0COJOoERASr4CYKel2rkAEw06f4DhcyrwJ0xJxt1+gENOYDKhH46t4ljIY39nUAlN1rx5H5WA52B1foFkrISW9jg03eSkCABgUHhkMTnJOzmUVCCtd2f9DSCkrp+DZZj/k3NZdfREiHjip9pZmV+U3GmgwMDiR/nn9tR6AzAD11+7/5F6ajP93d9yTaGAnmlTdf0Nd
 86hLIdqv
 j+RMg4+8z3P8px/aS1AxIx3NO+pQ8GIy7ya51jTzycV5CzTP8oaYxYVAd6TGiBELfnubaMhupPW+n7OJTeC7sL5pr1gtEzTHQQir880X68rb0D3djVrhLWrv9nP/2ErGYIWpc1C4B8srJZUfsxp8sRnmvqAZBqbNlyIrpT9tJlCu+/Vawz9DTIHpF5jXnRg20Fr0cSSFZC11+3BuNMKZ4aL4GpTFxVIlZbHCN3G2iWFTlIgs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

The feature is exposed as CONFIG_KPKEYS_HARDENED_PGTABLES; it
requires explicit architecture opt-in by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES, since much of the page table
handling is arch-specific.

This patch introduces an API to modify the PTPs' pkey. Because this
API is going to be called from low-level pgtable helpers, it must
be inactive on boot and explicitly switched on if and when kpkeys
become available. A static key is used for that purpose; it is the
responsibility of each architecture supporting
kpkeys_hardened_pgtables to call kpkeys_hardened_pgtables_enable()
as early as possible to switch on that static key. The initial
kernel page tables are also walked to set their pkey, since they
have already been allocated at that point.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/asm-generic/kpkeys.h  |  4 +++
 include/linux/kpkeys.h        | 46 ++++++++++++++++++++++++++++++++++-
 mm/Kconfig                    |  3 +++
 mm/Makefile                   |  1 +
 mm/kpkeys_hardened_pgtables.c | 44 +++++++++++++++++++++++++++++++++
 security/Kconfig.hardening    | 12 +++++++++
 6 files changed, 109 insertions(+), 1 deletion(-)
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
index faa6e2615798..5f4b096374ba 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -4,11 +4,15 @@
 
 #include <linux/bug.h>
 #include <linux/cleanup.h>
+#include <linux/jump_label.h>
+
+struct folio;
 
 #define KPKEYS_LVL_DEFAULT	0
+#define KPKEYS_LVL_PGTABLES	1
 
 #define KPKEYS_LVL_MIN		KPKEYS_LVL_DEFAULT
-#define KPKEYS_LVL_MAX		KPKEYS_LVL_DEFAULT
+#define KPKEYS_LVL_MAX		KPKEYS_LVL_PGTABLES
 
 #define __KPKEYS_GUARD(name, set_level, restore_pkey_reg, set_arg, ...)	\
 	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
@@ -110,4 +114,44 @@ static inline bool arch_kpkeys_enabled(void)
 
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
+int kpkeys_protect_pgtable_memory(struct folio *folio);
+int kpkeys_unprotect_pgtable_memory(struct folio *folio);
+
+/*
+ * Enables kpkeys_hardened_pgtables and switches existing kernel page tables to
+ * a privileged pkey (KPKEYS_PKEY_PGTABLES).
+ *
+ * Should be called as early as possible by architecture code, after (k)pkeys
+ * are initialised and before any user task is spawned.
+ */
+void kpkeys_hardened_pgtables_enable(void);
+
+#else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
+static inline bool kpkeys_hardened_pgtables_enabled(void)
+{
+	return false;
+}
+
+static inline int kpkeys_protect_pgtable_memory(struct folio *folio)
+{
+	return 0;
+}
+static inline int kpkeys_unprotect_pgtable_memory(struct folio *folio)
+{
+	return 0;
+}
+static inline void kpkeys_hardened_pgtables_enable(void) {}
+
+#endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
+
 #endif /* _LINUX_KPKEYS_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 90f2e5c381a6..e34edf5c41e7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1175,6 +1175,9 @@ config ARCH_HAS_PKEYS
 	bool
 config ARCH_HAS_KPKEYS
 	bool
+# ARCH_HAS_KPKEYS must be selected when selecting this option
+config ARCH_HAS_KPKEYS_HARDENED_PGTABLES
+	bool
 
 config ARCH_USES_PG_ARCH_2
 	bool
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..10848df0ca85 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
+obj-$(CONFIG_KPKEYS_HARDENED_PGTABLES) += kpkeys_hardened_pgtables.o
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
new file mode 100644
index 000000000000..931fa97bc8a7
--- /dev/null
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/mm.h>
+#include <linux/kpkeys.h>
+#include <linux/set_memory.h>
+
+DEFINE_STATIC_KEY_FALSE(kpkeys_hardened_pgtables_key);
+
+int kpkeys_protect_pgtable_memory(struct folio *folio)
+{
+	unsigned long addr = (unsigned long)folio_address(folio);
+	unsigned int order = folio_order(folio);
+	int ret = 0;
+
+	if (kpkeys_hardened_pgtables_enabled())
+		ret = set_memory_pkey(addr, 1 << order, KPKEYS_PKEY_PGTABLES);
+
+	WARN_ON(ret);
+	return ret;
+}
+
+int kpkeys_unprotect_pgtable_memory(struct folio *folio)
+{
+	unsigned long addr = (unsigned long)folio_address(folio);
+	unsigned int order = folio_order(folio);
+	int ret = 0;
+
+	if (kpkeys_hardened_pgtables_enabled())
+		ret = set_memory_pkey(addr, 1 << order, KPKEYS_PKEY_DEFAULT);
+
+	WARN_ON(ret);
+	return ret;
+}
+
+void __init kpkeys_hardened_pgtables_enable(void)
+{
+	int ret;
+
+	if (!arch_kpkeys_enabled())
+		return;
+
+	static_branch_enable(&kpkeys_hardened_pgtables_key);
+	ret = kernel_pgtables_set_pkey(KPKEYS_PKEY_PGTABLES);
+	WARN_ON(ret);
+}
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index b9a5bc3430aa..41b7530530b7 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -265,6 +265,18 @@ config BUG_ON_DATA_CORRUPTION
 
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
2.47.0


