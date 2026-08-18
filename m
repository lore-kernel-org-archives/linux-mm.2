Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 397C8C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538D56B0502; Tue, 18 Aug 2026 10:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FD46B07BB; Tue, 18 Aug 2026 10:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D246B07BD; Tue, 18 Aug 2026 10:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 237D66B0502
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:11:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EABD1402A2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:29 +0000 (UTC)
X-FDA: 85114577898.03.F3C5128
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id B53101A0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mbyRdbQK;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062287;
	b=KN3fHLEtSnxo5A192ueDkNk2uK2gqv8LY8nGrV4XV5DMUMp/lVYDkzeZZuNEfOsGVUyD7v
	60AyBcTecUM1n5jvTHcwS21SSob7oRHIxk8nXzIxxY55rseAb1E/wGJitkBWRa0v2pwgWP
	NY/yL0GLSWuEq6kPXCCjuVUXjYQgcOU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mbyRdbQK;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fd6mzyncNQ64b8dxo/18sTl4GGfxhyjVOrfC5xcwDCA=;
	b=KAk+KVc+MyPL1p2TV3W768oTfMMXj1AKHw4zW1YqzSLvnyWWpPR9NBPzRRA0jvhIJ0jbdM
	+R2Gwg+Bsgu4v5PW4kdfT+1gefqojOIsulmhuJ5cqQgrEdDU5ATcbVffJ427C04QZX7gsX
	3wEYx93x4R7xgoMCGcDraKcQOwOMQf0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F35C19F0;
	Tue, 18 Aug 2026 07:11:23 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EDB43F85F;
	Tue, 18 Aug 2026 07:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062287; bh=9dqIiwyGVVVxGSjHeF+MAxucmgOd3jqjzZqWJtM2VB8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mbyRdbQKlO/26/1Fa4w7m6hPuhvlnytHQISAVLXNFMFm2TRNGzVS887HJloU+7YFI
	 EhwgLWAo7jUlXEB9y9MveCPjEeP/SCYRV0egYsHA/wHS7GchteF9wmfkFRh5vtG0tw
	 hYHMyLbtBL+KBswx02wzpRLfu1K/xbvltgcfOikQ=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:43 +0100
Subject: [PATCH RFC v9 01/25] mm: Introduce kpkeys
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-1-743ad31b2c8f@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=5979;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=9dqIiwyGVVVxGSjHeF+MAxucmgOd3jqjzZqWJtM2VB8=;
 b=mahw5b1Ggs/ZgmHXvp1+lRl2JXwUwDEs2wO6R50H/rbCAhz9vVQsA9V4MOhyhrRgRZSG93KtJ
 u3AmxqgV//JDyT3mBF536urNrR4z5MugwWxb7CJPyJbzpxbN6IDf9DU
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: B53101A0006
X-Rspam-User: 
X-Stat-Signature: osia9nwupfwq6g867zpra9fej5ecucuc
X-Rspamd-Server: rspam06
X-HE-Tag: 1787062287-193326
X-HE-Meta: U2FsdGVkX18egVVBr+OHqMHOTRGBFwOu249O7+Dx1VebhRbJz8/VCKRYO1HyIAhuYPCy9/JQf32VCNCTpEhNOQbtH79yViZ1aL8aQ9paTwbYHH0a/zclIOrb4xW5QDkwtgny7PY3CiR3Z5lunpJtN3aqn9e36pecSLyFW5uFsJZUW9VIJwBV6wgfplryoRSelG0BDzhRXaHo2AIizlFfSm7R2LfrpaKGagOLip/rAJhm0o8HjU2v+pvLgFKQiuyi41d/cGYJOaIW95bA7p3tWAe1PwiD6dSthUZbM67nkk9FNyBIu+dTtOUfAH1lB2sgNkIQG4qH0MrFRqUOOBKiYxA0SooSXvo9aGChbwvrPqY7NQkUMXDKWJ2GQvw3rHRbcda9RsPcCMnMTqXXqg1Lw5/fGfOyMw3Pvaj69zs47KJN5MAQf0+boDeC/22jfH8ofvAPWURLuM1rtLaToAEmF+5tREiAJJMKpDOj2MUu+646dnytmE/LFP//N5hArurFj+zJ08MxbWqUzS9l3KVvDGTclDX7PcMGAVB+WCVK5kPOG4N/1B+TrSNrHkYtAMqe5NMzR/msczZDiyuwSOTXPFcEXHc1YO1jPmp8s7dSkhwOEFyRNpCc3m+hBU7f0R/vaFkKt6Zq9JB9VoFq+WHWXMjSDhp5vF+1qdGf3Ekg30uqJh95lzGVUZJMcONdNxIELPJL/Ljojj5YtZGLfnzeanoIHdSdBtCxnRLBuYYcoG+R7M7ixYkOdvGmottchtHuUg1bgYViyT8+/lbeHse+bTfRyq1iRZ18bn2M6WY37ZiwuEeWeSh9jK/NUTeB6Uuqw6gIgQzEDxT/n13DpP7KGEZabddD0qmvd3G1mUGOeXIzsckrEbCs6FxhhlkuySQ4cOrA/J8imRH45PV2nhpO+t8JvMI6oB02JXBOvprEQRrVfMdmuM3w2gD4uz+JqErRuKh+ujbThSqvMrzgX0y
 E+ASsdiK
 8CsPkLkCQpHWio+f3upaJphBPGyQ6BuTOGNLViMGj1lFkeVqOWcCk5XtjpEiIrEmM8RzWKKVdMrrTVxtBz8AiB69ZdnzDnNkOv1TLLqPZQ201iB6u+m82mi1qy/+knhztDjBuntW9pwTtpueNFi2HR0bTmO/+0lpehB7cMQ/FQQw9CgJC83lcJJM9AcMAVPe0FNpvBj276//lLLOoOQ1j4nsjHsTvR5hdLooGlEmOtIND3B1mv11OFkBR2MNTaIHhVOlcG88/W85rngFYObdgrYxY2WshRyXj2r/t9Dzi6LaYf38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kpkeys is a simple framework to enable the use of protection keys
(pkeys) to harden the kernel itself. This patch introduces the basic
API in <linux/kpkeys.h>: a couple of functions to enter/leave a
kpkeys context and macros to define guard objects.

kpkeys introduces a new concept on top of pkeys: the kpkeys context.
Each context is associated with a set of permissions for the pkeys
managed by the kpkeys framework. kpkeys_enter_context(ctx) sets
those permissions according to ctx, and returns the original kpkeys
state (typically the arch-specific pkeys register) that is later
restored by calling kpkeys_leave_context(). To start with, only
KPKEYS_CTX_DEFAULT is available, which is meant to grant RW access
to KPKEYS_PKEY_DEFAULT (i.e. all memory since this is the only
available pkey for now).

The underlying representation of each kpkeys context is entirely
architecture-specific. Support for kpkeys must be explicitly
indicated by selecting ARCH_HAS_KPKEYS and defining the following
functions in <asm/kpkeys.h>:

* arch_kpkeys_enter_context()
* arch_kpkeys_leave_context()
* arch_supports_kpkeys()

Additionally, <asm/kpkeys_types.h> must define struct arch_kpkeys_state,
which typically provides storage for the pkeys register.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h       | 104 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/kpkeys_types.h |  25 +++++++++++
 mm/Kconfig                   |   2 +
 3 files changed, 131 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
new file mode 100644
index 000000000000..eac522f55214
--- /dev/null
+++ b/include/linux/kpkeys.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_KPKEYS_H
+#define _LINUX_KPKEYS_H
+
+#include <linux/bug.h>
+#include <linux/cleanup.h>
+#include <linux/kpkeys_types.h>
+
+/**
+ * KPKEYS_GUARD_NOOP() - define a guard type that does nothing
+ * @name: the name of the guard type
+ *
+ * Define a guard type that does nothing, useful to match a real guard type
+ * that is defined under an #ifdef.
+ */
+#define KPKEYS_GUARD_NOOP(name)						\
+	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
+	DEFINE_CLASS(name, bool, (void)_T, false, void);		\
+	static inline void *class_##name##_lock_ptr(bool *_T)		\
+	{ return _T; }
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
+ *
+ * Define a guard type that switches to @ctx if @cond evaluates to true,
+ * and does nothing otherwise.
+ */
+#define KPKEYS_GUARD_COND(name, ctx, cond)				\
+	__DEFINE_CLASS_IS_CONDITIONAL(name, false);			\
+	DEFINE_CLASS(name, struct kpkeys_state,				\
+		     kpkeys_leave_context(&_T),				\
+		     (cond) ? kpkeys_enter_context(ctx) :		\
+			      (struct kpkeys_state) {}, void);		\
+	static inline							\
+	void *class_##name##_lock_ptr(struct kpkeys_state *_T)		\
+	{ return _T; }
+
+/**
+ * KPKEYS_GUARD() - define a guard type that switches to a given kpkeys context
+ *                  if kpkeys are supported
+ * @name: the name of the guard type
+ * @ctx: the kpkeys context to switch to
+ *
+ * Define a guard type that switches to @ctx if the system supports kpkeys.
+ */
+#define KPKEYS_GUARD(name, ctx)						\
+	KPKEYS_GUARD_COND(name, ctx, kpkeys_supported())
+
+/**
+ * kpkeys_enter_context() - enter a kpkeys context
+ * @ctx: the context to switch to
+ *
+ * Enters the specified kpkeys context. @ctx must be a compile-time constant.
+ *
+ * Return: state to be passed to kpkeys_leave_context().
+ */
+static __always_inline
+struct kpkeys_state kpkeys_enter_context(enum kpkeys_ctx ctx)
+{
+	BUILD_BUG_ON_MSG(!__builtin_constant_p(ctx),
+			 "kpkeys_enter_context() only takes constant values");
+	BUILD_BUG_ON_MSG(ctx < 0 || ctx >= KPKEYS_CTX_COUNT,
+			 "Invalid value passed to kpkeys_enter_context()");
+
+	return arch_kpkeys_enter_context(ctx);
+}
+
+/**
+ * kpkeys_leave_context() - leave a kpkeys context
+ * @state: state returned by kpkeys_enter_context()
+ *
+ * Restores the state saved when entering a kpkeys context. If no context was
+ * entered, this function does nothing.
+ */
+static __always_inline
+void kpkeys_leave_context(const struct kpkeys_state *state)
+{
+	if (state->entered_context)
+		arch_kpkeys_leave_context(state);
+}
+
+static inline bool kpkeys_supported(void)
+{
+	return arch_supports_kpkeys();
+}
+
+#else /* CONFIG_ARCH_HAS_KPKEYS */
+
+static inline bool kpkeys_supported(void)
+{
+	return false;
+}
+
+#endif /* CONFIG_ARCH_HAS_KPKEYS */
+
+#endif /* _LINUX_KPKEYS_H */
diff --git a/include/linux/kpkeys_types.h b/include/linux/kpkeys_types.h
new file mode 100644
index 000000000000..9de59092e9c3
--- /dev/null
+++ b/include/linux/kpkeys_types.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_KPKEYS_TYPES_H
+#define _LINUX_KPKEYS_TYPES_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+#include <asm/kpkeys_types.h>
+#endif
+
+#if defined(CONFIG_ARCH_HAS_KPKEYS) && !defined(__ASSEMBLY__)
+
+enum kpkeys_ctx {
+	KPKEYS_CTX_DEFAULT = 0,
+	KPKEYS_CTX_COUNT,
+};
+
+struct kpkeys_state {
+	bool entered_context;
+	struct arch_kpkeys_state arch_state;
+};
+
+#endif /* CONFIG_ARCH_HAS_KPKEYS && !__ASSEMBLY__ */
+
+#endif /* _LINUX_KPKEYS_TYPES_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..55e6763d5792 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1281,6 +1281,8 @@ config ARCH_USES_HIGH_VMA_FLAGS
 	bool
 config ARCH_HAS_PKEYS
 	bool
+config ARCH_HAS_KPKEYS
+	bool
 
 config ARCH_USES_PG_ARCH_2
 	bool

-- 
2.51.2


