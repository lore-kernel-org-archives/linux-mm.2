Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E39CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8C06B008A; Tue, 26 May 2026 07:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679896B008C; Tue, 26 May 2026 07:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567D36B0093; Tue, 26 May 2026 07:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44D606B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7A08403AC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:05 +0000 (UTC)
X-FDA: 84809319210.11.C0C230C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7732160011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mgXyVOhP;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQMyTBmvjiPpeVX4Cyb/CofbNEVWc3TSovYmGaEoLwc=;
	b=H4aI85t7FXIyjZn+o5o6SFK4YKqebD1dbOngDDbrxHUWMCcfRus3kVSwcqbGxM+6dLdIOU
	arRj6molFL4ofAjz90jcy+BTXICk+ndDKZ1jhqZ2Ov87ah/6JR4Gv0GFNrCzN0TNc+Sxvu
	1rS8pWLF1PRg+AJj3IWm88BeKgB0PC0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mgXyVOhP;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794223; a=rsa-sha256;
	cv=none;
	b=fE21akVo4ncH8bkPQ4j/GUwZqnnVI2Xix4abqEpRk4l2Root7qIGMhv0TX6AUTwiV4svER
	MoaY3dgsV/9v2GSFu0ChsRXvby+CkbGjpdBU4EtTFGhbCHQyqeO/ye8PhHFAQ4n6dQFbnv
	ubw/hFK/ZalOymw9ZHFv+fcc3BFQnG4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2E0D16F2;
	Tue, 26 May 2026 04:16:57 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E94E83F7D8;
	Tue, 26 May 2026 04:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794222; bh=guqrDTBg9L+rMmzwHLEGhZCrOb5ASxmVe+Yvhw85EsE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mgXyVOhPh5Ym8PaAy/kc/vKjTdJycVt1gR+XQakLOLXLXMPMA9SKf4u2j9sYFRd9i
	 aOEwPgI21nLFRvV6Ia0IoxWtjQG+Vens5CoW5haUDSrRhdGKh1VzI03uWp9YRrz/fh
	 gqptUhdgLtjrDdzyHwRLzOxfYrR8cC3/jIKaYTBs=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:50 +0100
Subject: [PATCH RFC v8 01/24] mm: Introduce kpkeys
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794211; l=6647;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=guqrDTBg9L+rMmzwHLEGhZCrOb5ASxmVe+Yvhw85EsE=;
 b=oPJXA+ORDOej1DfFtYeT+KvUWZRlr0MxVa1EQKUPKgt4IXJnjaOVA4turG7Yc1iDLet8vQuRs
 viYfkErkNpxDLE0InZj9u2G7iaznYEJvG8TQ3z7WrySKrLaXBYgqDXT
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: u7eh3g49qm95hnctwfb7dx7kz671oro3
X-Rspamd-Queue-Id: B7732160011
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779794223-872799
X-HE-Meta: U2FsdGVkX19ZqvMm72dGiSKxDkowAeFCW8Tc1Mp2PPw+WdzYQKlWnGxbVrRT+3MpBcVRVnO6qh8Re7kgM4isW8YgLqJVcKRJQRUSbuw88TrHd5+9GMl6Q7spV5gSRmDdqHGVcu4KE5tyUsFSmJ6nIkyWZFQKPZmsZ+ZRAwqwW2CjRQ733lR8Ble7DhoahtRh6LWoIn6x0yqPGkXQQs5cONly3Ol/IitcY3p2yticP/qCYtDWa6OJJ+BEnGX7+X2dSoopl2WH3ipkz4Fib00R+aPsUUdfkEiK4J6k7CJV7HP/ECjJ0h8p8J/utomCRJvYL5syAQGb6VJL5VxdqBG3qbjpF5Zs3gX78jlMk8fFjKEaumr6iW0pNyoZtN9qM8AcV/gDPFhhEa4kOI3vCtBagYZNHmaMNBiep9kb2KzhRqGHiwpbOrk0fqPH51rdk09Hx1Of6cAu6W7x/HWhpoiTvAHVElDyrjFY4j2QM+mBcW7WuFWTker4zDFuWwLd0t224LGaNrz/nfvGZUiLHEPrfHB2zsxYRcFeRgXnG4FCEPL26FGw24FF+PVcQky+yNhAgQLSvlldJo8hQyzzUTq7FKcyqygO/6qHkuMQ79++f7EYVRBcG9vIx7h6eOMrXtCyTSY/rvSFylr9vGKyNx9LhKYDpsEtWD4+QKbxM0tI1A0pXR9OPJ9Ho0qtGKiq/egfHK4zaIaUV4ZnmlDzTTMd/q00l8dJzNQFlkaAQYe+aoU1REUbV9Chtq82kL0Qb+nD5DvyVz8qIPrObhe84R7XCNDCFxNRzHJ+W1da0SOb2kszPSrUwTgT9cE9qC01SnW6IU+YR1q7kk5frvXbn4ERFJbcnyht/1ys64wWqfYOasdmGCTYzv7w7T1mYCYU9WY7c1LOWfrI1rxJ44J1NQO0k1JbeB+WFAqOzkXvIuYxCcUX/PuGbqfztpa9R4sBuCtDSPH73UAx4snE78Cvbz7
 aMO4PqgO
 RgSH4uSjTta0JJVycNzTLcBc0ggTxC+qYcZqLAXCfqAKTC7lu0IcCle2h8vGzJw8MBpwIQg34dzT2vMf/Rct6mNBX8TEu9UxJ1QTUnAlOFDAhQMQ69YPD4zZs4mKD+HiGqTeZr9eIMraKp4YG5OT0KJYPIpnboX4KWUNpm/0WWh29TQyUclrWZm6o9PF0/X593DY/gwIS1DICpgLavl+wVGshJnLMgt1u+ApcX5mjnmhUX2u5E95XY7Lpa7A0n79bksSqa8OZMt9pFC4hdmBuVsPRkDt+gOawULPx
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

kpkeys introduces a new concept on top of pkeys: the kpkeys context.
Each context is associated to a set of permissions for the pkeys
managed by the kpkeys framework. kpkeys_set_context(ctx) sets those
permissions according to ctx, and returns the original pkey
register, to be later restored by kpkeys_restore_pkey_reg(). To
start with, only KPKEYS_CTX_DEFAULT is available, which is meant to
grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since this
is the only available pkey for now).

Because each architecture implementing pkeys uses a different
representation for the pkey register, and may reserve certain pkeys
for specific uses, support for kpkeys must be explicitly indicated
by selecting ARCH_HAS_KPKEYS and defining the following functions in
<asm/kpkeys.h>, in addition to the macros provided in
<asm-generic/kpkeys.h>:

- arch_kpkeys_set_context()
- arch_kpkeys_restore_pkey_reg()
- arch_supports_kpkeys()

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/asm-generic/kpkeys.h |  17 ++++++
 include/linux/kpkeys.h       | 122 +++++++++++++++++++++++++++++++++++++++++++
 mm/Kconfig                   |   2 +
 3 files changed, 141 insertions(+)

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
index 000000000000..0ce0db80b4ee
--- /dev/null
+++ b/include/linux/kpkeys.h
@@ -0,0 +1,122 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_KPKEYS_H
+#define _LINUX_KPKEYS_H
+
+#include <linux/bug.h>
+#include <linux/cleanup.h>
+
+#define KPKEYS_CTX_DEFAULT	0
+
+#define KPKEYS_CTX_MIN		KPKEYS_CTX_DEFAULT
+#define KPKEYS_CTX_MAX		KPKEYS_CTX_DEFAULT
+
+/*
+ * ... is used to discard extra arguments - this allows users of this macro
+ * to have set_arg default to void.
+ */
+#define __KPKEYS_GUARD(name, set_context, restore_pkey_reg, set_arg, ...) \
+	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
+	DEFINE_CLASS(name, u64,						\
+		     restore_pkey_reg, set_context, set_arg);		\
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
+ *                       a given kpkeys context
+ * @name: the name of the guard type
+ * @ctx: the kpkeys context to switch to
+ * @cond: an expression that is evaluated as condition
+ * @cond_arg: an argument specification for the condition (optional)
+ *
+ * Define a guard type that switches to @ctx if @cond evaluates to true,
+ * and does nothing otherwise. @cond_arg may be specified to give access to a
+ * caller-defined argument to @cond.
+ */
+#define KPKEYS_GUARD_COND(name, ctx, cond, ...)				\
+	__KPKEYS_GUARD(name,						\
+		       (cond) ? kpkeys_set_context(ctx)			\
+			      : KPKEYS_PKEY_REG_INVAL,			\
+		       kpkeys_restore_pkey_reg(_T),			\
+		       ##__VA_ARGS__, void)
+
+/**
+ * KPKEYS_GUARD() - define a guard type that switches to a given kpkeys context
+ *                  if kpkeys are enabled
+ * @name: the name of the guard type
+ * @ctx: the kpkeys context to switch to
+ *
+ * Define a guard type that switches to @ctx if the system supports kpkeys.
+ */
+#define KPKEYS_GUARD(name, ctx)						\
+	KPKEYS_GUARD_COND(name, ctx, kpkeys_enabled())
+
+/**
+ * kpkeys_set_context() - switch kpkeys context
+ * @ctx: the context to switch to
+ *
+ * Switches to specified kpkeys context. @ctx must be a compile-time
+ * constant. The arch-specific pkey register will be updated accordingly, and
+ * the original value returned.
+ *
+ * Return: the original pkey register value if the register was written to, or
+ *         KPKEYS_PKEY_REG_INVAL otherwise (no write to the register was
+ *         required).
+ */
+static __always_inline u64 kpkeys_set_context(int ctx)
+{
+	BUILD_BUG_ON_MSG(!__builtin_constant_p(ctx),
+			 "kpkeys_set_context() only takes constant values");
+	BUILD_BUG_ON_MSG(ctx < KPKEYS_CTX_MIN || ctx > KPKEYS_CTX_MAX,
+			 "Invalid value passed to kpkeys_set_context()");
+
+	return arch_kpkeys_set_context(ctx);
+}
+
+/**
+ * kpkeys_restore_pkey_reg() - restores a pkey register value
+ * @pkey_reg: the pkey register value to restore
+ *
+ * This function is meant to be passed the value returned by
+ * kpkeys_set_context(), in order to restore the pkey register to its original
+ * value (thus restoring the original kpkeys context).
+ */
+static __always_inline void kpkeys_restore_pkey_reg(u64 pkey_reg)
+{
+	if (pkey_reg != KPKEYS_PKEY_REG_INVAL)
+		arch_kpkeys_restore_pkey_reg(pkey_reg);
+}
+
+static inline bool kpkeys_enabled(void)
+{
+	return arch_supports_kpkeys();
+}
+
+#else /* CONFIG_ARCH_HAS_KPKEYS */
+
+#include <asm-generic/kpkeys.h>
+
+static inline bool kpkeys_enabled(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_ARCH_HAS_KPKEYS */
+
+#endif /* _LINUX_KPKEYS_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..819fb0d7b7bd 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1242,6 +1242,8 @@ config ARCH_USES_HIGH_VMA_FLAGS
 	bool
 config ARCH_HAS_PKEYS
 	bool
+config ARCH_HAS_KPKEYS
+	bool
 
 config ARCH_USES_PG_ARCH_2
 	bool

-- 
2.51.2


