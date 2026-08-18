Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3A5C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90606B07BF; Tue, 18 Aug 2026 10:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67516B07C1; Tue, 18 Aug 2026 10:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4EA6B07C2; Tue, 18 Aug 2026 10:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7231E6B07BF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:11:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F033D40283
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:49 +0000 (UTC)
X-FDA: 85114578738.01.E936BE1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1B182140006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eegD3Q5z;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8ZEIDDOAvbld7L9/nQWkBl00b8uwYrx/LGF9pE90tw=;
	b=DKQZgYEgZ4Pm5ULW2G4d/W0+oUNzHKKvvjDFmXgorH/IEpbmjtzRdn7eHSEgfPQicohfAO
	YQY1lI3FGyejRxbDk+DvMDQ5APpHqxXfVpOK+jNLiLLZ0JCL4hPBi+5uz8cLfoBsuepwiv
	7HGtxEisgmPEFBUvrqwA16FJ54OvBrY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eegD3Q5z;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062308;
	b=typrmESRP8yYSFt8S1e3xnf8npuFGBRwO2Isn6eqoag1lLKQ17epwnEobFZHFtPnWtN6F0
	EcYt3+CsATK1Vfq1nnhiv6kKAwTtz7O00CEQSe+eId4lv1hyND7Y/a7bxUH8J5OuIYXCXH
	fQJIgBL+cQy0OJMXC4uCKLz0PjBgBW8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C40119F6;
	Tue, 18 Aug 2026 07:11:43 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 578593F85F;
	Tue, 18 Aug 2026 07:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062307; bh=6wbz7M9AxUaVbPIWUUWjzRRnSMPq0HS+t9xWqqATY50=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eegD3Q5zeLXme4NvXnUJNYwKafnS1JAt4VVHBEbHdSs/9LuqzzWjqNenBJoOpv+oW
	 UeD15hUuXB2GUF+Nw3cbWEYXVCC9G8Y9+PFLZekCFB3REt156/mNAaAHvbVLijXgkX
	 a4CLhHodZe6F1Gjhm9EgzjUU1gV7P6m3VeSq9A3s=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:47 +0100
Subject: [PATCH RFC v9 05/25] arm64: Implement asm/kpkeys.h using POE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-5-743ad31b2c8f@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=3520;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=6wbz7M9AxUaVbPIWUUWjzRRnSMPq0HS+t9xWqqATY50=;
 b=qSs2aR0MM51fpLHnCL+cqiL5CeqWF8AjtCb69VRsQre+Xry4+dqxT+AElsKlSRpe1daufmoo0
 DHdsQ6uk7EFBwHC3vYbMZnfyPIBOBhD6kw+KHDnL00yy/Gvme1fBgMK
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Stat-Signature: qks6r6k3g5xh17b8too4q1zbu7yqti1n
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B182140006
X-HE-Tag: 1787062307-322599
X-HE-Meta: U2FsdGVkX1+8K8Jj3010lQpSJPQBAYueKSHhrjVPKqXnUWEV1q0OUtyPeWsyQKyOAc7iqI+ap4DGZgWi+9SnjPi2TtTXd5qdazGql+dBLON0oAgMEgUMW0ZSJ4TOag8sIQKDmeA3rozt7HQOgZFt/y/vZs+9GO57k6eCBIBIPQwNVxSciTadXgto/ViXurHOvAmUA1LWj/v+8bA9FYXrEo5vi0nodWT/K6B7qI8dui0285sQuDa9FqH7xoHpAPxi9oGoaNDrHH/FzJ7qz1xeQwiCOAuJ31G/7WpzqQNe5kHdj6kfQZL9EIKEw9Ajb1h7mYDx3ChxcBZIJIdqy2IlxMvOgpjGm484BagLR+vfZXx5vAaZWjMxCwsOvXSQt8MT6DhzbgbDZWcUWLR0+2aXfFvPyWMv4jCXoHhF4h4r0qkj8+SfkZiIfOinCC91KILAlmlbmdnEdEMFcNZ5I3vVUkD7XbT4jY1BFIAImbnuBzq2UnD+tZMHAsxIcqKH4YCDyuGOw7014NFBnFUHOUi6fz2bBNT83ov0KBoB3mA399x5r/SkUXtCy3J8hNIU4cSxMIg1jf7Oh0n99zUpOFsUNqzXOMfiiMeGhCzTFDZ3ozf2xXfOeVsnmh5DSro/p9szxS/S/WuI4FIAStI5feA3gT9378sReo9q/riYuQ2hTt3fpiOvJGSc6LJ3P8/tMV8gzTDdsBbJQIhXz+pUCVyFBjOk+7b3YOWTLp6ds5KuaOU6uWePk98U/zvGPMR//l70TZnk82t3ZahDGbDndsUS5PuhT1f2PJaLNv7DMqJp1tDBZl4nfdxpL5dIASB8Loo+3bJ21d/TAc5u9LkjpJ+KQmSCWNR81n+yFfWAAE1uJBKrMN3wSzgVJhNRUnV5AiZpHwUWpMxdQcu2eWOQsO1dInv8HqokCAbzD0vj36iJ6cb7vbhmi5CBTTialyGiUWOA6QFmY/z84iZOnFv9GsD
 nUqBPH2b
 dLVqPB7su7BNT1sGSE8w0vbu6yWPrTQcJmn4fGp1fLs/IncWq/R88E02792hW0jvBLwRAkEOEhNmrTmqybCO8cjjtiWUb/dDEHPeYfVLr9QwmXNpjzzPm3YPAcrb+i6LtI8BsV6MzT0QVgc+MW9l0YIO32j35n4hY7grexEpaIq9QjuUvrE+Jx4G0MmW91g6KKiH/feTDMsfTI9l6bGZP6OxhbhMUUjoPKfYl5VATmAMZrhaCVFTgRsCn5OWIINONOn9Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the kpkeys interface if CONFIG_ARM64_POE is enabled.
The permissions for pkey 0 are set to RWX as this pkey is also used
for code mappings. POR_EL1 is left untouched if we have already
entered the requested context.

To allow <asm/kpkeys.h> to be included from assembly, also add
appropriate #ifdef's to <asm/por.h>.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h       | 67 +++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/kpkeys_types.h | 15 ++++++++
 arch/arm64/include/asm/por.h          |  4 +++
 3 files changed, 86 insertions(+)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
new file mode 100644
index 000000000000..09fd5a849cb0
--- /dev/null
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_KPKEYS_H
+#define __ASM_KPKEYS_H
+
+#include <linux/kpkeys_types.h>
+
+#include <asm/barrier.h>
+#include <asm/cpufeature.h>
+#include <asm/por.h>
+
+/*
+ * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
+ * used in assembly.
+ */
+#define POR_EL1_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
+
+#ifndef __ASSEMBLY__
+
+static inline bool arch_supports_kpkeys(void)
+{
+	return system_supports_poe();
+}
+
+#ifdef CONFIG_ARM64_POE
+
+static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)
+{
+	por = por_elx_set_pkey_perms(por, 0, POE_RWX);
+
+	return por;
+}
+
+static __always_inline void __kpkeys_set_pkey_reg_nosync(u64 pkey_reg)
+{
+	write_sysreg_s(pkey_reg, SYS_POR_EL1);
+}
+
+static __always_inline
+struct kpkeys_state arch_kpkeys_enter_context(enum kpkeys_ctx ctx)
+{
+	const u64 prev_por = read_sysreg_s(SYS_POR_EL1);
+	const u64 new_por = por_set_kpkeys_context(prev_por, ctx);
+
+	if (prev_por == new_por)
+		return (struct kpkeys_state) { .entered_context = false };
+
+	__kpkeys_set_pkey_reg_nosync(new_por);
+	isb();
+
+	return (struct kpkeys_state) {
+		.entered_context = true,
+		.arch_state.por = prev_por,
+	};
+}
+
+static __always_inline
+void arch_kpkeys_leave_context(const struct kpkeys_state *state)
+{
+	__kpkeys_set_pkey_reg_nosync(state->arch_state.por);
+	isb();
+}
+
+#endif /* CONFIG_ARM64_POE */
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __ASM_KPKEYS_H */
diff --git a/arch/arm64/include/asm/kpkeys_types.h b/arch/arm64/include/asm/kpkeys_types.h
new file mode 100644
index 000000000000..e9c59a26ee7a
--- /dev/null
+++ b/arch/arm64/include/asm/kpkeys_types.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_KPKEYS_TYPES_H
+#define __ASM_KPKEYS_TYPES_H
+
+#include <linux/types.h>
+
+#ifndef __ASSEMBLY__
+
+struct arch_kpkeys_state {
+	u64 por;
+};
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __ASM_KPKEYS_TYPES_H */
diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
index 19b3dd1d43a0..dddabf6ffae6 100644
--- a/arch/arm64/include/asm/por.h
+++ b/arch/arm64/include/asm/por.h
@@ -10,6 +10,8 @@
 
 #define POR_EL0_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
 
+#ifndef __ASSEMBLY__
+
 static inline bool por_elx_allows_read(u64 por, u8 pkey)
 {
 	u8 perm = POR_ELx_PERM_GET(pkey, por);
@@ -38,4 +40,6 @@ static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u8 perms)
 	return (por & ~(POE_MASK << shift)) | ((u64)perms << shift);
 }
 
+#endif	/* __ASSEMBLY__ */
+
 #endif /* _ASM_ARM64_POR_H */

-- 
2.51.2


