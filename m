Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0EDCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4D8900213; Fri, 15 Aug 2025 04:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6958E0002; Fri, 15 Aug 2025 04:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493D4900213; Fri, 15 Aug 2025 04:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 38C6A8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:55:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1C821408B5
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:33 +0000 (UTC)
X-FDA: 83778383346.05.02630D5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 45A0D140005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248132; a=rsa-sha256;
	cv=none;
	b=au/tZTy6HezBB6bIJ4zxP38wMLI97qlh4NYGCyMq+o6XzAsGyKOW5i0/b1Nie+oHyze094
	eQMNVC9Z0SBE9yGNj6pm+Bq7kwMyU0WxKfuL5vcHaxgwHGfTWf+KTMxyGboqbsjmIFNRgF
	E99Kd+ifggqCGkAGADmnivWVm+THyO4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a4MNdbvB46xSqJXw/T4+elvNarYzJJ8j5Dig82KsZ5Q=;
	b=R6p4Gv1XZnaKe5YIx7hQWyKYXIUXrMDllmto9OvwY3XClYQkO+C0D74vggnbaIZ4GM/5QP
	HB3RsWHAlIKZMmhBFyOFW3BDHJv3HJjlyuLl/u/cnQUPdz+br/aExG37K5luyAmKomsno0
	zjVI/IrUYNbD9Dxs132y/BPKf7vyvWE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CB461E32;
	Fri, 15 Aug 2025 01:55:23 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B58A63F63F;
	Fri, 15 Aug 2025 01:55:26 -0700 (PDT)
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
Subject: [RFC PATCH v5 01/18] mm: Introduce kpkeys
Date: Fri, 15 Aug 2025 09:54:55 +0100
Message-ID: <20250815085512.2182322-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 45A0D140005
X-Stat-Signature: x1ruibesqucdnwpm31mq1pcu5x4ccm3d
X-Rspam-User: 
X-HE-Tag: 1755248132-804544
X-HE-Meta: U2FsdGVkX1/Q1BcLrCCltZZUIOdDq/lyoeYr1my/Gbk83QEBMxh9QYschnB9Wd7hwbsbtxRDnlR9DMMoW85DlQeNyR616Wi7hr1wq94+Fvg7/ZbSEEhpN5KY4fIpJADaSnSxDuKrGjgOy8/uFyDdS+zc0TzAXl/WAhY1AGTI1+cBBPXrXkn120oO9VCeRC5JB3Uz3iJVPxKfL7HlnoXT1FthWzt40E1TdcvI5fvZ70SnP1e5RUXiWwvmDFXwecmnU3snSqRw2zcmPz0lxQ/a325JjdytFMhxtsgyzrtKoW7epcOQzz+OIgcBQAjjrLRVVwRVsDYsUQa11KdqlkDSxcedIS9JbgL1MsRlEqEPT7SLde1dp/JoA1nq+DOwcYaKJifogT2AALTUUogqDQgQ8pjLya3CIENQeruw0tZ+d14rZMGz7sYaIgAAtu1qCqcJbFeoccIl2DFvAHiP+ncy8+WQtmIvXQFzSIWbqumCcqbOkbgKHeswni3hXP/sliDdix7/GMam0xdLaOfJoLpMrGijP1+lcJxktKDA6LSl4x7NnbUEev/11VYHD7kxsmKPmmLsrA3rUtivK2QgifWp19pUMF7OGLy8S9XuBbYdyoOYUSWkA5pZT+YZakoRL39RgxynpzruQiDza2ia/mz6Cg5Fh/3/U2UOD0pkHygr8inbc+1rbQmIIA3Us0apq1WkV9GgDpXbr57Y7kArIHhiUnWc9KhHimUJ9prgwyA5C9FxFoEGI0A46pcc+WBx9snlyy7ZzXU3dzsCjJ9oPLjtJq2dstnwHutcpBhi7TPPy+HtlyucnmnayEmx+4RgfkZqIP6jZPDJdP/U/j8cJZjfdPtoTt9Ooga5tBdOxjWrLO78R28QvcBuxK7iAwRVUGtOn3UYiCRTl5DjRbN2jrLZq9d04xa8V7Kny99OHF9myBAmgDYGDOlo7/NSwd0/yTmYb/eufwFgkcS75Egc6+o
 6Zn6Z2FE
 bAcT97ykkq+xuHneCtDPkOr8slKoiDAe/E6yKrCuLm8IgYzZrS7N5G+IuKmRg8MvJdI+J3GDdmEOigtwZ83K00IZuAKLFusYUJhUR/TwnZxenlFFhVx6+YYzYM4k6dFMLuz3+bcW+MxtNvSFskqswMrS111Yl14M+QsIWvMOoWkaALXsM5g0mGZYzpFVVcgl4dz0N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kpkeys is a simple framework to enable the use of protection keys
(pkeys) to harden the kernel itself. This patch introduces the basic
API in <linux/kpkeys.h>: a couple of functions to set and restore
the pkey register and macros to define guard objects.

kpkeys introduces a new concept on top of pkeys: the kpkeys level.
Each level is associated to a set of permissions for the pkeys
managed by the kpkeys framework. kpkeys_set_level(lvl) sets those
permissions according to lvl, and returns the original pkey
register, to be later restored by kpkeys_restore_pkey_reg(). To
start with, only KPKEYS_LVL_DEFAULT is available, which is meant
to grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since
this is the only available pkey for now).

Because each architecture implementing pkeys uses a different
representation for the pkey register, and may reserve certain pkeys
for specific uses, support for kpkeys must be explicitly indicated
by selecting ARCH_HAS_KPKEYS and defining the following functions in
<asm/kpkeys.h>, in addition to the macros provided in
<asm-generic/kpkeys.h>:

- arch_kpkeys_set_level()
- arch_kpkeys_restore_pkey_reg()
- arch_kpkeys_enabled()

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/asm-generic/kpkeys.h |  17 ++++++
 include/linux/kpkeys.h       | 113 +++++++++++++++++++++++++++++++++++
 mm/Kconfig                   |   2 +
 3 files changed, 132 insertions(+)
 create mode 100644 include/asm-generic/kpkeys.h
 create mode 100644 include/linux/kpkeys.h

diff --git a/include/asm-generic/kpkeys.h b/include/asm-generic/kpkeys.h
new file mode 100644
index 000000000000..ab819f157d6a
--- /dev/null
+++ b/include/asm-generic/kpkeys.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_GENERIC_KPKEYS_H
+#define __ASM_GENERIC_KPKEYS_H
+
+#ifndef KPKEYS_PKEY_DEFAULT
+#define KPKEYS_PKEY_DEFAULT	0
+#endif
+
+/*
+ * Represents a pkey register value that cannot be used, typically disabling
+ * access to all keys.
+ */
+#ifndef KPKEYS_PKEY_REG_INVAL
+#define KPKEYS_PKEY_REG_INVAL	0
+#endif
+
+#endif	/* __ASM_GENERIC_KPKEYS_H */
diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
new file mode 100644
index 000000000000..faa6e2615798
--- /dev/null
+++ b/include/linux/kpkeys.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_KPKEYS_H
+#define _LINUX_KPKEYS_H
+
+#include <linux/bug.h>
+#include <linux/cleanup.h>
+
+#define KPKEYS_LVL_DEFAULT	0
+
+#define KPKEYS_LVL_MIN		KPKEYS_LVL_DEFAULT
+#define KPKEYS_LVL_MAX		KPKEYS_LVL_DEFAULT
+
+#define __KPKEYS_GUARD(name, set_level, restore_pkey_reg, set_arg, ...)	\
+	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
+	DEFINE_CLASS(name, u64,						\
+		     restore_pkey_reg, set_level, set_arg);		\
+	static inline void *class_##name##_lock_ptr(u64 *_T)		\
+	{ return _T; }
+
+/**
+ * KPKEYS_GUARD_NOOP() - define a guard type that does nothing
+ * @name: the name of the guard type
+ * @cond_arg: an argument specification (optional)
+ *
+ * Define a guard type that does nothing, useful to match a real guard type
+ * that is defined under an #ifdef. @cond_arg may optionally be passed to match
+ * a guard defined using KPKEYS_GUARD_COND().
+ */
+#define KPKEYS_GUARD_NOOP(name, ...)					\
+	__KPKEYS_GUARD(name, 0, (void)_T, ##__VA_ARGS__, void)
+
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+
+#include <asm/kpkeys.h>
+
+/**
+ * KPKEYS_GUARD_COND() - define a guard type that conditionally switches to
+ *                       a given kpkeys level
+ * @name: the name of the guard type
+ * @level: the kpkeys level to switch to
+ * @cond: an expression that is evaluated as condition
+ * @cond_arg: an argument specification for the condition (optional)
+ *
+ * Define a guard type that switches to @level if @cond evaluates to true, and
+ * does nothing otherwise. @cond_arg may be specified to give access to a
+ * caller-defined argument to @cond.
+ */
+#define KPKEYS_GUARD_COND(name, level, cond, ...)			\
+	__KPKEYS_GUARD(name,						\
+		       cond ? kpkeys_set_level(level)			\
+			    : KPKEYS_PKEY_REG_INVAL,			\
+		       kpkeys_restore_pkey_reg(_T),			\
+		       ##__VA_ARGS__, void)
+
+/**
+ * KPKEYS_GUARD() - define a guard type that switches to a given kpkeys level
+ *                  if kpkeys are enabled
+ * @name: the name of the guard type
+ * @level: the kpkeys level to switch to
+ *
+ * Define a guard type that switches to @level if the system supports kpkeys.
+ */
+#define KPKEYS_GUARD(name, level)					\
+	KPKEYS_GUARD_COND(name, level, arch_kpkeys_enabled())
+
+/**
+ * kpkeys_set_level() - switch kpkeys level
+ * @level: the level to switch to
+ *
+ * Switches the kpkeys level to the specified value. @level must be a
+ * compile-time constant. The arch-specific pkey register will be updated
+ * accordingly, and the original value returned.
+ *
+ * Return: the original pkey register value if the register was written to, or
+ *         KPKEYS_PKEY_REG_INVAL otherwise (no write to the register was
+ *         required).
+ */
+static __always_inline u64 kpkeys_set_level(int level)
+{
+	BUILD_BUG_ON_MSG(!__builtin_constant_p(level),
+			 "kpkeys_set_level() only takes constant levels");
+	BUILD_BUG_ON_MSG(level < KPKEYS_LVL_MIN || level > KPKEYS_LVL_MAX,
+			 "Invalid level passed to kpkeys_set_level()");
+
+	return arch_kpkeys_set_level(level);
+}
+
+/**
+ * kpkeys_restore_pkey_reg() - restores a pkey register value
+ * @pkey_reg: the pkey register value to restore
+ *
+ * This function is meant to be passed the value returned by kpkeys_set_level(),
+ * in order to restore the pkey register to its original value (thus restoring
+ * the original kpkeys level).
+ */
+static __always_inline void kpkeys_restore_pkey_reg(u64 pkey_reg)
+{
+	if (pkey_reg != KPKEYS_PKEY_REG_INVAL)
+		arch_kpkeys_restore_pkey_reg(pkey_reg);
+}
+
+#else /* CONFIG_ARCH_HAS_KPKEYS */
+
+#include <asm-generic/kpkeys.h>
+
+static inline bool arch_kpkeys_enabled(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_ARCH_HAS_KPKEYS */
+
+#endif /* _LINUX_KPKEYS_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf..90f2e5c381a6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1173,6 +1173,8 @@ config ARCH_USES_HIGH_VMA_FLAGS
 	bool
 config ARCH_HAS_PKEYS
 	bool
+config ARCH_HAS_KPKEYS
+	bool
 
 config ARCH_USES_PG_ARCH_2
 	bool
-- 
2.47.0


