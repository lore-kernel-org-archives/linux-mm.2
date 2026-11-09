Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BC06082BDC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y6QGzbK4
Received: by kanga.kvack.org (Postfix)
	id C0DAA6B05B2; Mon,  9 Nov 2026 11:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE3E6B05B3; Mon,  9 Nov 2026 11:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC956B05B4; Mon,  9 Nov 2026 11:00:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75A716B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:00:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 433294072C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:43 +0000 (UTC)
X-FDA: 85416043566.08.DCA3C8D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2E7D4100005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y6QGzbK4;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWpLaVBRkOlQWYeoX9SPxGyEXeXPe7MtwkGKCwhz/ks=;
	b=pNd0aW3Qdntzal08Zbtg3OwOKN9O5vlH0ajRLRXy1K1h/irJ0Nu0WC3H2AdUAxN+ZEdLwa
	I9pWK29EtNpmDImTqJ43jHiYT37+0Ey4B2Z70P0qJdkW/tIjRgXkyA3/0/nJs/ykf6Bkgz
	HJwH0+V/idYIeUPK48ez/WLOpXpPlCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240041;
	b=3XsQNl5OojM65IuzFU6DbZ58KEgp0LgUjbffXFy5l1iatthuKePwdgkU1P3KL2ajxIg2Mv
	spMK+o9Awzqnykd8ca4ADVAjTJ+eRgmzSt4BlnPvl66oKvUebl0vvNziN52yZS759JLOS5
	Vjld/4ifBmi9SNjbM8q1SKs6vdH7XYs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y6QGzbK4;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FD351516;
	Mon,  9 Nov 2026 08:00:37 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42CD23F632;
	Mon,  9 Nov 2026 08:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240040; bh=echuUgtLkD2a7BAD+7hYclWLN8NT3mDQAmCpjSBvsFk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Y6QGzbK49+REvpkxtERwwRHEONKDKFghwySdcsjRjdlI517MmjfTwR3s6m0QobYBa
	 3sn/jaGFagkhKCpOG1rpEsWtLz8+b48zchh/AEr560CrvtaBdlQ6wiNUmHQvX3sRzZ
	 twgysJBNhnxsNOoKzScZ0QEdN3mSvpMohb/PcPNc=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:26 +0000
Subject: [PATCH RFC v10 01/22] mm: Introduce kpkeys
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-1-aa6c4d9603bc@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=6214;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=echuUgtLkD2a7BAD+7hYclWLN8NT3mDQAmCpjSBvsFk=;
 b=M7uxGf8m8LgUdUIOChPJY5rfo9p8Svpg9/S7sTLYMAlbmUhfhg1wFRDmHdZYq6jO29fCVU69I
 eijdTIw94XWBsyMBWozP3mIqOnAkhHm0jYlOLiP4EQdKhP9fTFoezeO
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam06
X-Stat-Signature: 1ofk9hnoeypwt95hgctn54c4hybouuip
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2E7D4100005
X-Rspam-User: 
X-HE-Tag: 1794240041-73446
X-HE-Meta: U2FsdGVkX1+daxxI2QspGyUyxrKWXR1lh0UVbe2W2PvqyJrvdnyNdZ+xmRSYJSTB2sivszlTHOaN7joo96ME3xJ1D/KmlahgIY2ne+GL/dXQEQrVJ6tPQsAVOAAFQKLjLsNhU2G5ZR5pDeSioHLnbsVcJoniQy05UVZQxh6Hts6U3ST1PyNrRTthPXrpC0Qvc0rzNnXxOluBG62Mx1jvk+yz/eDvAkAMJoUzYeop8wFfqcfZQLV8KdK7DhB/mlV2Sw8PVijgz67QOVzmUPdaOtNBlV7lMLoKAMdU49qim384Z8/WHuHgSrLFzBRBnU+/1RhPi6kJ/nIo92NjQ3PcaP7YSs3YKWG5qy2XQFxSo7hIqABVIi7xuJt+hBiYWbuChBttTvrShRuKCBxVGZSspi9yYbKaD1352bM4Hmo/giUedKaN1KXKTYs8yPNCvgBhJPwURFlLnuyPBIgFELEMS2rPa+JVjTRdrZpt9O7HKMnV9xaRwCrxBsFR21GiErfpzJmIuOPl9wouCPNun+Drox8zrq5j0AZiMUliXkNdJbZ71MORF/LZBfe8Lvn7EXivJLG7Ov5cuaIUMoEtfoo1l4EJPxviXBblxDB28/N1E08Tu3O5Kt1CZj9VM7UNo0wSLfdDCHb9d5SYoYLRQ23NXeyabJETtENhUzPqzxleZQxwy/D3vwKxrgKkepYWcEgt1bJp2iZOrbDCehH3S6PgkZf+XH/P92oCx0zq2ZeuBK4VIjE989x4EdGZRNRH4DbFTwWgbPcBRpcO5M3YmbO4AFtdTuSItZbSyE7QFArGdRSRVTv3YqKy4j/1HTtuaccYUb1atG/9yJ8DJVoiI8ncFhakUwKTvFxaJ9pn3/CT/kYMR2VKiWO5ScPns3IDGGjT1o2dRqimKyfxZwVUqgSmhDbOEwLKEoxaA1nWGIBDDOdUtSV9QCqWXK9/x19rT7warixKKPhUQCiTjrmgCxe
 6XoKpLlM
 jpZK3hvE2yFb2biqcYbecW0Tf8NFWwf4cgR9F0hBZu6nkkpjURXzVi6oY6EbfY+yMPqiZ0ACjek1DmxZ41u2hqe1TDel6ElQdMrsWQ21VTJxfn2tID08//9Ll08uft0VRrvlLM1kxAqvo+PVAYuyo6t+NPxiWFMRp8TeYkCj545CBNA8iY3QCz/kfbNwLYHVY6Oyrt/gkApZBHMReSvOWyLAZhMWBuAvC8laS0wrV/cyYyPU8iZqUoE/cUyzsB0GHSEatPD0lCT06ueriuc0o5Nd2r8Ee8RworrrsvFuqwus43ksjJXpqusA5VTXIPDnftoRUU5OxNH7ipLurGZALG7XT9mAscyjNOZR091z+N3LeejeCVkI2JlD/zbBqhPsORRSzVGsA/dE6vP0DS6v+KeRfTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kpkeys is a simple framework to enable the use of protection keys
(pkeys) to harden the kernel itself. This patch introduces the basic
API in <linux/kpkeys.h>: a pair of functions to enter/leave a kpkeys
context, and macros to define guard objects.

Each kpkeys context specifies permissions for the pkeys managed by the
framework. kpkeys_enter_context() applies those permissions and
returns a state for kpkeys_leave_context() to restore.

The saved state is represented by struct kpkeys_state, with one
field for the arch state (typically the saved pkeys register value).
The other field is used to skip the restore step in case we were
already in the context passed to enter_context().

Support for kpkeys must be indicated by selecting ARCH_HAS_KPKEYS.
The architecture must then provide:

* struct arch_kpkeys_state in <asm/kpkeys_types.h>

* arch_kpkeys_enter_context() in <asm/kpkeys.h>:
  if needed, sets the new state and saves the original one in
  arch_kpkeys_state; reports whether the context was actually
  changed

* arch_kpkeys_leave_context() in <asm/kpkeys.h>:
  restores the original state

* arch_supports_kpkeys() in <asm/kpkeys.h>:
  returns whether the system has an appropriate hardware feature to
  support kpkeys

To start with, only KPKEYS_CTX_DEFAULT is available, granting
RW access to the default pkey (0).

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h       | 107 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/kpkeys_types.h |  25 ++++++++++
 mm/Kconfig                   |   2 +
 3 files changed, 134 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
new file mode 100644
index 000000000000..69ec4808d850
--- /dev/null
+++ b/include/linux/kpkeys.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_KPKEYS_H
+#define _LINUX_KPKEYS_H
+
+#include <linux/bug.h>
+#include <linux/cleanup.h>
+#include <linux/kpkeys_types.h>
+
+/**
+ * KPKEYS_GUARD_NOOP() - helper to define a guard type that does nothing
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
+ * KPKEYS_GUARD_COND() - helper to define a guard type that conditionally
+ *                       switches to a given kpkeys context
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
+ * KPKEYS_GUARD() - helper to define a guard type that switches to a given
+ *                  kpkeys context if kpkeys are supported
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
+	struct kpkeys_state state = {};
+
+	BUILD_BUG_ON_MSG(!__builtin_constant_p(ctx),
+			 "kpkeys_enter_context() only takes constant values");
+	BUILD_BUG_ON_MSG(ctx < 0 || ctx >= KPKEYS_CTX_COUNT,
+			 "Invalid value passed to kpkeys_enter_context()");
+
+	state.entered_context = arch_kpkeys_enter_context(ctx, &state.arch_state);
+	return state;
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
+		arch_kpkeys_leave_context(&state->arch_state);
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
index afff1b25b543..4635628de622 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1265,6 +1265,8 @@ config ARCH_USES_HIGH_VMA_FLAGS
 	bool
 config ARCH_HAS_PKEYS
 	bool
+config ARCH_HAS_KPKEYS
+	bool
 
 config ARCH_USES_PG_ARCH_2
 	bool

-- 
2.56.0


