Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84806082BC8
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=pAn2SFZ+
Received: by kanga.kvack.org (Postfix)
	id A618C6B05C3; Mon,  9 Nov 2026 11:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11966B05C4; Mon,  9 Nov 2026 11:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2616B05C5; Mon,  9 Nov 2026 11:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 465F46B05C3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4C70A83C2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:34 +0000 (UTC)
X-FDA: 85416045708.18.7B7E05A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id F1737180017
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pAn2SFZ+;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJscV3NGSsLPzzmUC/ClWQH3voh7QzyOkJMx5kRXbyo=;
	b=rbv5blh/jdIvzVMiP4SZ8/lzLlyrWl1Yi/SATbIgIv4eH8Bl9e/7F4N4dkO28jJd4RCepe
	9GZJt2lxSQUsaafhA+YoNhMTjEzmSp8OfXIFzpYMsv0vl7kJykuDAn7biTa7hxOzU99L0n
	qBLiaW/kwhfn5h+n4SOpsOOBALhuZP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240093;
	b=0NPrkfkbPtgSNsL0lZKALAyRtNAvDM+svClp/DoaLyzg62m34j0uwnXONgVrDmYBYeQJ9H
	h7mnF2o0XHltoPLxDetsaMJcIWkNhKU9/vcRxp0x9Ps+o85bdwnmT0Y8t/DlbsBthUC573
	z3aOPMI6wTuYU7DgEXsO6VigkMmmPVM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pAn2SFZ+;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 367451516;
	Mon,  9 Nov 2026 08:01:29 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C1483F632;
	Mon,  9 Nov 2026 08:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240092; bh=CAIyfUtJbjmfrkqxkWqZ7YLIG0a17tfM6+7+J94AUX8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pAn2SFZ+GktBtPCYVQ/Ez/focYKHrodPzOaECMjUkflBU7DpxHyZELa3aBwAwmFiL
	 BdFJw+SChQQqxXrR+dV2Ij6KjY9LKipu0V00hbyxEjpFFb9jTZN19DZtLGKV9lTDpm
	 kREzA0g3iOl3k4Yu/GFdZeVNiCkyhOMEPlFp71Cs=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:36 +0000
Subject: [PATCH RFC v10 11/22] mm: kpkeys: Introduce
 kpkeys_hardened_pgtables feature
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-11-aa6c4d9603bc@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=6143;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=CAIyfUtJbjmfrkqxkWqZ7YLIG0a17tfM6+7+J94AUX8=;
 b=o+1OCV6c8nE69uhycwwo0znE2NnD1Tad/IfI+JQDg+qFfcBQ2GcXsvu0cHVgjBWGW9D7x9EIR
 2p64pT0+rQaCr3uAGocy46SDGZQ6lEy27oczr/YL1piHSmm20FRBp2n
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xmxc7q3xuxu5b7fckd5ryypyszzgsxhc
X-Rspamd-Queue-Id: F1737180017
X-Rspam-User: 
X-HE-Tag: 1794240092-416800
X-HE-Meta: U2FsdGVkX1+kjUtNTaVEvh44DsGLXeR8ah2FWjwHuDzeXoKhmmq6c4kqT7A49olUa1H2yY4qf80/Ny7KlbKQWTPDrAkVEWZxd6pWg3r897bz1HWXh3tO/hocFk61dIUQ2yMjH2XAFdnGxSeKtEEjcnNC/ejw4oS14ABSsuid7QAHhoL8QB0lKtOYjLlyxRYZv0JKlgwqJnL8lHtlrf4ycy7Oe5xGNrt+e3yxUvgk1QyUzNFBYUqUhMC5oIXdSTPDdmiOHDP6hMWVh1YBAwpaPpbFZSgvh82JO4+2gu+o9ZJUC20yHgrrkkxsL+UuXe5E1xBApoXZbAE9HvAKCxNY3CK24Z4Sa5ZHPWQsqmytGez+eQhs95/yQJRd6SMTgs9sYvWzHBoLYZSJE0jZqk/DEss+i39I0koD0cVAN8/TcnPVA7j8a1Z+RJ7ON1cakGgY6uAXSzcZ55F1Pzs4eYlZduCraHNScR5Cr/6ROVy9xhZtFTwKcwuWxxj/KktqMbncrKaKPUJPeAp4me6MHGxnhq8mfHr9M/juQAN+FRtiCJjdF7bCokUOAtAzQqyz9h5rYc/y3Ymvvh7IccYIT/X9BXGULkBFipy0+aO2BQb/ntto5IeOdK1pGNoyFB1cJozQxVujDbZaxBbNK/8bdVNn4xKtfE+zq5Id6oe5k/jPzihCG6CdRelPIFc7pvdWV6Qf5+cK0CQ+c2/QlDKRUbfG4uRrTc2JW5MvHYdNCYS3WcVN4Z/m/ZUkMq4LjS3piM4jfx4n+GEzubLtx/8QIRUrsalcihFMeeyymIQFrrfZ1UcBQYBxHxEb+5RyYwG2oCvLgYBNkILedbxnPq5WcDPexaf9gTInQWRnrgwqPZLJU0GCQPzPappyOWfZlKZ8nb0G8oHD8IwHz3Gm8UEnTb6Ccamvaa5g5WHFHYXe4RwoMyDwEim8SEFurjQsuVqk3eAi9TjW7Na465MlV6svRnW
 H77v+j39
 AMuxPgo4d1Bi0m86FbHEKOIRp6nooi+ZcD/5rTbR9dBT/Q27brEf3HapEHh0uDA28OmW9BaZR5vCE0Hlil7upnwx3oRec+I8nCKT1LiCfQvYjdAiAGHSTSYiAUmQ/59ssi7OEOa04kHn3rtZcIEIQbTyOUHPqJ1mMRp48dYaUL+v0tJfYKSsS9UWPUE1/BaRLH49gKK9O9a7+meBq9rVRjGRrhClRkzn0vo8fB11YLLhUJu46pNHmWhk4AGupAOVHAI/8gnlFmQ4IWwPdgIZGYQzoXmLThiE0y8uRnchAUfqkTU3cn7y80l5zf5qkkggztrimgP/mSVYkg6s2ztbUWS/h8iWmSUGncjJr5KoVoeGtzvqYYsC1x0+HxGqtNDTpmyBTNmvpv51PLgwHPVbf7DHX+A8QJ99ci6/I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kpkeys_hardened_pgtables is a hardening feature based on kpkeys. It
aims to prevent the corruption of page tables by: 1. mapping all
page table pages, both kernel and user, with a privileged pkey
(KPKEYS_PKEY_PGTABLES), and 2. granting write access to that pkey
only when running at in a privileged kpkeys context
(KPKEYS_CTX_PGTABLES). This patch introduces basic infrastructure;
the implementation of both aspects follows.

The feature is exposed as CONFIG_KPKEYS_HARDENED_PGTABLES; it
requires explicit architecture opt-in by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES, since much of the page table
handling is arch-specific. It also depends on
ARCH_HAS_SET_DIRECT_MAP to modify the direct mapping of page tables
using set_direct_map_pkey().

Supported architectures must also provide
arch_supports_kpkeys_early() in <asm/kpkeys.h>. This will be used
during early boot to detect whether kpkeys_hardened_pgtables is
going to be enabled (e.g. to decide how to allocate early page
tables).

Because this feature relies on kpkeys being supported and modifies
attributes of the linear map, it must be inactive during early boot.
mm_core_init() enables it before any call to pagetable_alloc() is
made.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        | 33 +++++++++++++++++++++++++++++++++
 include/linux/kpkeys_types.h  |  5 +++++
 mm/Kconfig                    |  3 +++
 mm/Makefile                   |  1 +
 mm/kpkeys_hardened_pgtables.c | 16 ++++++++++++++++
 mm/mm_init.c                  |  2 ++
 security/Kconfig.hardening    | 12 ++++++++++++
 7 files changed, 72 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 69ec4808d850..cd3281223778 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -4,6 +4,7 @@
 
 #include <linux/bug.h>
 #include <linux/cleanup.h>
+#include <linux/jump_label.h>
 #include <linux/kpkeys_types.h>
 
 /**
@@ -104,4 +105,36 @@ static inline bool kpkeys_supported(void)
 
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
index 4635628de622..cf3b6105c4ad 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1267,6 +1267,9 @@ config ARCH_HAS_PKEYS
 	bool
 config ARCH_HAS_KPKEYS
 	bool
+config ARCH_HAS_KPKEYS_HARDENED_PGTABLES
+	bool
+	depends on ARCH_HAS_KPKEYS && ARCH_HAS_SET_DIRECT_MAP
 
 config ARCH_USES_PG_ARCH_2
 	bool
diff --git a/mm/Makefile b/mm/Makefile
index 2a3ec53d62ee..07b67eaa1b3b 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -149,3 +149,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
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
diff --git a/mm/mm_init.c b/mm/mm_init.c
index d99af80ec752..347246135ce1 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -21,6 +21,7 @@
 #include <linux/buffer_head.h>
 #include <linux/kmemleak.h>
 #include <linux/kfence.h>
+#include <linux/kpkeys.h>
 #include <linux/page_ext.h>
 #include <linux/pti.h>
 #include <linux/pgtable.h>
@@ -2733,6 +2734,7 @@ void __init mm_core_init(void)
 	kmemleak_init();
 	ptlock_cache_init();
 	pgtable_cache_init();
+	kpkeys_hardened_pgtables_init();
 	debug_objects_mem_init();
 	vmalloc_init();
 	/* If no deferred init page_ext now, as vmap is fully initialized */
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 81c81ad983ad..9a6f50103482 100644
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
2.56.0


