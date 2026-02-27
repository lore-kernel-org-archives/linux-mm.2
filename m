Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303F4FEFB74
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DEC6B0088; Fri, 27 Feb 2026 12:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808406B0089; Fri, 27 Feb 2026 12:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFF56B008A; Fri, 27 Feb 2026 12:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD526B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:55:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E33F91C3B7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:55:50 +0000 (UTC)
X-FDA: 84490989660.02.0B0972F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 439442000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:55:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MnxBiUXZjVF3FrE27+SVGYm31v2l1PQElIgd3UxpUuw=;
	b=Hy83DN1C7gBIGlXol7xhPTVb2IrYO+Aq+loyY3chQ1JYTR+86nqi0S7oMQ1acgLRErZCN3
	2HhQH3JuSYOhjT85r9kGVM+TjZYGGysrR3h7iNuL628BqdOLW3Ts8eMAU2xzcmblcTyXWK
	JvPU8n9YCMn13BlfiymyMrwHkhq+Dg8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214949; a=rsa-sha256;
	cv=none;
	b=V992YL3dge6zawkp0S5WIH3xRu/+/N+Yepwh55YDnEE0J2E6P77WXl1j0Ov0JcMcHGV5r7
	9aHinGR7PHIBPmVzc2/XkAF6KZMV9z4xGxxtVjSVigMizHmg+JpjACsMBkFpAJIIbSDl9G
	LEcQu+/DNtlwr/ohX91wz2CJ6a63V4c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6CA41516;
	Fri, 27 Feb 2026 09:55:41 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE6883F73B;
	Fri, 27 Feb 2026 09:55:43 -0800 (PST)
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
Subject: [PATCH v6 01/30] mm: Introduce kpkeys
Date: Fri, 27 Feb 2026 17:54:49 +0000
Message-ID: <20260227175518.3728055-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 439442000D
X-Stat-Signature: kwfq3bz5ugyf5jpcw8yrwe3qazpaz3qy
X-Rspam-User: 
X-HE-Tag: 1772214949-778866
X-HE-Meta: U2FsdGVkX1/qxaYJY5e8BmxdFfJsBr4ROD+oh5+620YS/7K7UxB4FBBeHOwHSLBsw14NUf/CfxkrDP+U2vyJLmYsaRtN/d8IEEXNHYDoL1XB6VUa3/icAbZH2tlnQskYliYhotlzy+EeqbYyzVgNh6iYTKfpa9XWJLNW93bO4/juBUbyh7iFplxrOthhmm9m5j6BvsFAqpx0C3fiBQ4sz+PhY0fG8PC0JZ5cdPq2mDlRHb/PB39KVowahUTweF7gSsLrXAn5iH5lXK4gQyPYqoAiUNVXdEthUNjNHjhtfw00OetewLzoET4jBYCiOc3XYnKmyZKoTTnUdFYZnQvIC0kk9qZkkWWQDDWAJadzj0UXsgNx2F/YE5QKy6np1FIfAjfcxtVrBQM545zQROLN+4prjpseqh1gqjubKFLAl7Nu/FRuld2wfWLpL+yf6OL1NzPMSyaaY048aaSixCk2dmw5Uf75iXxO1bMAay8kDopQBMSsUPRY6pQA+459++JJJT3lh0oQuyaTM+9vXPx3Z2Hqm12OJg24iELpkzd1KWADb2RRRweCY+rAVRdZHweJgFQ29CkhxfmScmffU2+U/tH2CBXhnu3uuTCUhvRGT23CXZ1ODqlrnzw8+TZ5Gd5WvsakblEHnthHJU6DOT6q1FTni9o4Z8A7Lorimnk6K2dswRehGyaqS3BZtg0WVsC0iJ/P7bJvAo8sh+PSduFvdalrfCA1mFdhivUwYpdjE6zom+l1SvuXJDtd3eTXqgUG3g7lRuNj+FMJyoFH+xtTsN1Y+c7uusIjG489A4lUFPp0HrOWnbY7IfllFxPU6XuncHsDjY8xSXxJkwRDOL4T+iXO2NjF8SyfHoCXmYaJD/GPoMugx5rqqoyYTRydSZF5Ws0eePdIk4fpWr7UBhGBCF/SqsyovuBF4reEzcnmWiKsK9bMMOrOFJUqHWIbjEW+5ZAXOPZAd+VQXX9BxP1
 U0+zTzYI
 h4yjbdOoDAYudESw1toZexDbt/VaAhxKIStnn58rgt44IMDdOV4mwPt7D06/Mdwt7vOvk5mJu9ceD1fMf5eID7hjIuCULmiCcza72sCQg0fAcpYsEzHMBLrRUNMrSLw4nhLQIYLEnEiVfc+zZSpbqrxTy8w==
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
index ebd8ea353687..2baedee59bb2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1243,6 +1243,8 @@ config ARCH_USES_HIGH_VMA_FLAGS
 	bool
 config ARCH_HAS_PKEYS
 	bool
+config ARCH_HAS_KPKEYS
+	bool
 
 config ARCH_USES_PG_ARCH_2
 	bool
-- 
2.51.2


