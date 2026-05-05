Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E856CFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C116B00B5; Tue,  5 May 2026 12:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5DA6B00B7; Tue,  5 May 2026 12:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4D76B00B8; Tue,  5 May 2026 12:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 33A686B00B5
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 010931C02FD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:29 +0000 (UTC)
X-FDA: 84733846260.07.6F60FD0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E3581A0007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d2gpOI5g;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wXOKxD5sGL6mfcCXWS3lqXU5doM7M6+nrpyXTdgpAo=;
	b=s7Pz5WkPQb+hAGkGkRFuL1t86C8SspL2Mxv84SZJV3E+Adyvjz1fW5DlUKr2VjJyYFLpqS
	e2aR9ODgRojm1yrG11D6Rk7xLuYBLcDjPYngO4/JQJVAMk3L3J2IyhuzM/gTZGoy/K+P1e
	QONUzZvRDft/Uj7FtfkiZ9qJSPuuVUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997248; a=rsa-sha256;
	cv=none;
	b=v8yDFP4jD2ixcqUQvmrAl9yS59GWdR8DX+i5gTNco1+3UQbfC+HLIj8MkOX2Yq4LGiklf5
	hJ2pkwohEFyamgKpyEC68NVP/p3Mx9ylGa2A57r965ctf+pjHXixAYFfpM7I2ycKD9y6LX
	w3EsySo/860+Mhxf+Dtwbl3DK6uancE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d2gpOI5g;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF37514BF;
	Tue,  5 May 2026 09:07:21 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21CC83F763;
	Tue,  5 May 2026 09:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997247; bh=6h53wIhICiTdohxtZ773SNUpArSJEO1cKJs65JAmPCY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=d2gpOI5gY7qiZ6klE1noMUGXimHfRGXXfFw+/eM4tO7XW+EALiXnHmq1wjynsIv+G
	 KggwbbLDH3ULPGGYBhxAF57HxF7iuKb7O+JN4F44w7LnIGL5e2z5c1jXFkxZrybi0O
	 ZFh8CEGhMPWhgXvF9lkm0kTEcgXMpk4ij4xg1hsI=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:54 +0100
Subject: [PATCH RFC v7 05/24] arm64: Implement asm/kpkeys.h using POE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-5-20c0bdd97197@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=2665;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=6h53wIhICiTdohxtZ773SNUpArSJEO1cKJs65JAmPCY=;
 b=kMmOZAzlr5JiNYZ8sm1nG7q9J8yJ+5iLF5bQYnzwypt2/PnQ0z9eV0aNwTIPyYfR+nQ0ESKVw
 Fi7x6wj+1aNCumcVAwAGrapKsxO92BmroPdMDLaQgffctO55Vf5ZLh3
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1E3581A0007
X-Stat-Signature: 4jfpg6acmoucmcjhy61cuqg6w5mbffu7
X-Rspam-User: 
X-HE-Tag: 1777997247-678919
X-HE-Meta: U2FsdGVkX1+5eQ+q8MSjN2oLyp+T9Ev5TZcG7a8rl4QM6qJauh0DzaSzaTcQKOHUckZacbacicdsH9ULDU3qFitKuCed1bRCSD/PqJclc/ahLONZg887zW+EVgdGvOA+smHMI3LaPBSS73t3BPRrQtNK2Uh+HqvixAijIhSrjz+RmItZbxM2SG4hqFOJu0T08Jzk8hPMI68KR4jnAmShNqsHHvvqnA3Nm33BzdJLQ/TawNP6BOhUQKbrbpX1YQDwWLTzx6Mh+KycpqHI0msdiudcYjgPkd7jSRG6QaYsv64KDrDjbzwric79X9vl8ZZyproheE6FLL6lMpC+4IW3aRfZEHwq6AHL/9ESmA9zn25RbhxWaczu1JbB+CEwNvwqdRnYPd5oTTDyYkyAvDBgD2mbUgmzlY+84f6ErLWSROIi9Sng7yQD5+LmkWlvEZeU436OrD5oH/Y07+SonvkzHnRgrlP98kYujWwiztwcirEj+CdDZdH7gfNEY9U66Cu2FvH7+icGf+fw1mEXLxSkZTlq/aQENvU6coA296p/UeKLWDKh77JHjVS9DF6MRDYGpg09jkAXV6FN2X5F3/hh0tyqqbW6jK0E0lWENqSqxr/qzy2L8pmsV6ueL8ohkBgo3ITS7LLnzCeZghx1eG1QraL9VHq9v138IlF5cm4AS3qPp4rpzdqz0VFHFtLKbRoJ+3lq9KDYM82QIgG/6mqk1XDbNs/PVBVIxYVEcKwBhx8MsgHdu+/v1Tdw82iWakYb+ZNkpWqKOvAhBgXVuy6oB+A/AF/2FRLSRQYSAt0nMyPIKFkAvFFcycyKdyUyNTyp4XGa1dgCl0lIZjPbPQo5won5/j3p9iGRN2XJcACqDQNMQonpHS1cqoi4jRkh8HEBa+XfLQye4F9/QfMY/puJEqkCVvAJEk5QPF4h4aRNL9lfVdUvrnElyxNQlKRFqMe0hy3tDkBalLmb/DCtJoj
 Y9XklDcd
 nb0lyKeYjFUaHG7YpMS/atsyAin74I3D4mFy8UxAbpIBGIQro/9IQXIkJntdxu5po+PhIF0K3kQs8AghNElkf/SEechZXWV9r4ihYyr6MiWniXUWQ1urco3y8nV8Pib7ELEfL4IlNiheIoyiRj2SE2proi5TxYX2iz0HwhZLVA5hmAHkyywFAK0VHcQjBMy0UAdCY2AeruRv/38k9TF6J/CLHHewhDnsJ26QN+eTZD5S/v2R7O86hvasUJYZ1ZX6NTy6Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the kpkeys interface if CONFIG_ARM64_POE is enabled.
The permissions for KPKEYS_PKEY_DEFAULT (pkey 0) are set to RWX as
this pkey is also used for code mappings.

To allow <asm/kpkeys.h> to be included from assembly, also add
appropriate #ifdef's to <asm/por.h>.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 59 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/por.h    |  4 +++
 2 files changed, 63 insertions(+)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
new file mode 100644
index 000000000000..7dad3532cacf
--- /dev/null
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_KPKEYS_H
+#define __ASM_KPKEYS_H
+
+#include <asm/barrier.h>
+#include <asm/cpufeature.h>
+#include <asm/por.h>
+
+#include <asm-generic/kpkeys.h>
+
+/*
+ * Equivalent to por_set_kpkeys_context(0, KPKEYS_CTX_DEFAULT), but can also be
+ * used in assembly.
+ */
+#define POR_EL1_INIT	POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX)
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
+static inline u64 por_set_kpkeys_context(u64 por, int ctx)
+{
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
+
+	return por;
+}
+
+static __always_inline void __kpkeys_set_pkey_reg_nosync(u64 pkey_reg)
+{
+	write_sysreg_s(pkey_reg, SYS_POR_EL1);
+}
+
+static __always_inline int arch_kpkeys_set_context(int ctx)
+{
+	u64 prev_por = read_sysreg_s(SYS_POR_EL1);
+	u64 new_por = por_set_kpkeys_context(prev_por, ctx);
+
+	__kpkeys_set_pkey_reg_nosync(new_por);
+	isb();
+
+	return prev_por;
+}
+
+static __always_inline void arch_kpkeys_restore_pkey_reg(u64 pkey_reg)
+{
+	__kpkeys_set_pkey_reg_nosync(pkey_reg);
+	isb();
+}
+
+#endif /* CONFIG_ARM64_POE */
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __ASM_KPKEYS_H */
diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
index bffb4d2b1246..58dce4b8021b 100644
--- a/arch/arm64/include/asm/por.h
+++ b/arch/arm64/include/asm/por.h
@@ -10,6 +10,8 @@
 
 #define POR_EL0_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
 
+#ifndef __ASSEMBLY__
+
 static inline bool por_elx_allows_read(u64 por, u8 pkey)
 {
 	u8 perm = POR_ELx_PERM_GET(pkey, por);
@@ -38,4 +40,6 @@ static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u64 perms)
 	return (por & ~(POE_MASK << shift)) | (perms << shift);
 }
 
+#endif	/* __ASSEMBLY__ */
+
 #endif /* _ASM_ARM64_POR_H */

-- 
2.51.2


