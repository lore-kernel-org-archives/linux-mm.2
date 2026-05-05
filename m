Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9893BCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 012976B00AA; Tue,  5 May 2026 12:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F054C6B00AB; Tue,  5 May 2026 12:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC6E6B00AC; Tue,  5 May 2026 12:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C2EF36B00AA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 661A91A03BD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:12 +0000 (UTC)
X-FDA: 84733845504.12.3B2C8FF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 615CA2000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JmZcAN5o;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKO93WqhPG4aCFyvB9Qs11u9g/krZhDwYyDRe0RwaAc=;
	b=mXzW3m519r3fOfG3NEq9NKPTXBrecAoJKVNGuQ+6TazkPFXPQmkGEIhj+D4GOvyBO7heJu
	Ml8SiE2eedq+zt0IaXPKxkjCnXX6WX4dhiC1Ef7CeWFdqvp5gohoeT4kw2Kb5eQUNgg55B
	nHS4wN6mprd8G6lilaPZisP2Pt7phzw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JmZcAN5o;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997230; a=rsa-sha256;
	cv=none;
	b=3+zJ84EWH4Aw2G8Ip/6NM3UCzpMrbfZI3OGgNYtSKMy4G9lfgJq1YsxRGic5Nuz+Wt8M2G
	KcVmITFCI7RsXh9vWPjCejmBR6cj8pgfHKovq9Uh78wg+fz+joGhzSi6PQsU09tisK3iF9
	juLmAvUI75u45V8TVqn+dle7NrCQI0I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B9D81A9A;
	Tue,  5 May 2026 09:07:04 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 538233F763;
	Tue,  5 May 2026 09:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997229; bh=Ik79gok8/eHjYMHR4T/cBcTVcQ/dFwUsL5JM4QKZ0Hs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JmZcAN5ofvtZVpY0s+h9mHMSHRISV90QPl1mwSXwC2LuYvl3nkQkrjqaxR6GmtiGy
	 Lg1EDPbsquANu55BfZutenEY6hyH1e7SYJoSWeAK+TGcEgVR7q16f13Bvmf3NRwwEq
	 guwEMvaMDEo0fWI3VEBy6aYgvVABobDzdFO6BpG4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:50 +0100
Subject: [PATCH RFC v7 01/24] mm: Introduce kpkeys
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-1-20c0bdd97197@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=6517;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=Ik79gok8/eHjYMHR4T/cBcTVcQ/dFwUsL5JM4QKZ0Hs=;
 b=SNYRXfEGBDLb8kVVJ/T00y4KyxtTFYZYTe/QggemBtnQquty9NkZW71AaVU0i/LUFfzNUoiIW
 C5I7gAy4Ow2AwaOhIVq6J1L/TRR3wQIEIv5zMOcpzpo6Gd6urhSxW+i
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 615CA2000D
X-Stat-Signature: atcmj5zttig8i88nti9bxbw5srtm8r8d
X-HE-Tag: 1777997230-12298
X-HE-Meta: U2FsdGVkX1//PCwZD5dFm95axr3UOUh6r3BUUg7MhaB/jHW8s3NC+lfyMuLaLBlSV2b+SCyRKVOhFR420HfVdwqtSB+/nFSt9Mg9m1xayv1qS2BDvilhVY5AlBRyVSbTrwdQWN0zLZDrI9KS/3TOPUG6tElaU3Rg47zfte/i9igzXmf8RP5WioM39Z6X2Olud2IPkqD8eg9M85iUQO8ODG3w4CMT6506JmQB1Ia6b26RNIyo2cq09NAiS0s50kuTXNWOiPaI1KVmDYzNx6Lbg5kLMH1ZR9WX2tJQcFyHT+g1vRvF0ImXCOaP/mq7Emq/gHYn6IxN0FzwqWAfS0q7pEmC/O7wBIeraDMLtL7iVfhqoeA7VGwaaUdk/ESwKz8Tk3gK6A5yfpmAtGAgOj/PtNua8BQ/rLG2WRJYmh8KxQE6zqyKpPqOy/SnB2X7PeSID7CCW7f91qwHKQHVJ5rchVeIrAYlHHTav2S5iayBGIFPI5cQLgbGgEqAbajawW5VBevBnWxV2tI4SzSrSn46jTswVpKui3CSTDygsd4jeAMu6594vPjy/NS6+V9UmDCDwl/VVJHXkEl7z2GvJpC/MNKlY+IFn69KzZJBnvti64qtg8X5/OG2pPNpki0VC8vnxE7Mwrjzn8NNbE3FtGLOgZYNOWOi235oqbByBNnEYTjTGFp4bSXHF51GNSv6CW1dyADQrQSN+nhl/Sb1hDmxEV4WbaR2buIwTzOh86RFpUc2rZJ+ZsizV7YHevtcckVjzFy1d42pxDFa8EWR6UkRHgplFTyLQlovUPMAzIZkmunqYHVM0OXDxUyYXaGBT5RolQOQ4IuuMLxOFH0Ge98dV9YRaGSKiSHyQkinxwn8B3AKVLH7dJmEVF8LRg8wkejZAP1eVgLpzmZWs5O4PibCjvkf9caR7U8jm6QzS8AOL21poJOlxkhq0yYI7vsTE/dGEqu5opHzcPiRE80TAxc
 eP1n/7cU
 ROMFNTWgd9+gxXJarklcac+vQseWNk2ME1ug428ihfjRy9XzrlzH8SmJqDZroIoLl0/rP/jbi439H4l3C/VsDU3uM2fZ1SdmOMK4pFAiHt71eTZpXYvINQbd7HEE5CnGJ8X/B+oPTSMcayXflCeTVMFxzv1jbTBzIzJSeGyrsYrayKhcHCKvGBuBN2j3Y9n/HjOCmK5v8ZEFfcW+pUWSDdzzQLltPVvhRpzPnNuhORsI1ussD+0AffHRqAZdQPnEfCQlYCXVnVvH/3OdW1ZE67c7MQIy4MhxPGpgx
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
 include/asm-generic/kpkeys.h |  17 +++++++
 include/linux/kpkeys.h       | 118 +++++++++++++++++++++++++++++++++++++++++++
 mm/Kconfig                   |   2 +
 3 files changed, 137 insertions(+)

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
index 000000000000..cb2d22758391
--- /dev/null
+++ b/include/linux/kpkeys.h
@@ -0,0 +1,118 @@
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
+		       cond ? kpkeys_set_context(ctx)			\
+			    : KPKEYS_PKEY_REG_INVAL,			\
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


