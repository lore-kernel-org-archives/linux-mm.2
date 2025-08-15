Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E20ECA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED70900217; Fri, 15 Aug 2025 04:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E678E0002; Fri, 15 Aug 2025 04:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C67900217; Fri, 15 Aug 2025 04:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75C108E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:55:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2E5A5BB11
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:52 +0000 (UTC)
X-FDA: 83778384144.20.5DE53EE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B8D74000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248151; a=rsa-sha256;
	cv=none;
	b=K7jlXSVndgJKyyQbAzgsHmNCBqUzO4PP4k5MVwBrTEh/gxx4NzHOWWvOkBEpT+ei5mrFaj
	9tvQKq7WfDEZWpUkxnW1UDLvzdOCIP0z96cn6pOYaZ1XSKIj516BVHvUZNUoWjwD5YwyOX
	lsRSCbs1X50z/xrNoVLfcy543yOMPsU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJoDwb/u3Nzlv4jn8+XZaODNbWbOa/Nrb+B9eqkeeBc=;
	b=LHCnIH6MvZGJG0N2syep073P0pBTuRXHNJPfqUPLjKuuv2WOroxSBdJYXcX5z7C5JAwlK0
	PO0lLuqQbgEWKZJaCk7nagngt8ECAgluatVdGu5AaOrBSVUlfhYxvf1P2qmp0kOvo5EiFP
	B3v7J3UHQE8nO2Z2NfjCRy1D0czbhRc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8534D1E32;
	Fri, 15 Aug 2025 01:55:42 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A4FC3F63F;
	Fri, 15 Aug 2025 01:55:46 -0700 (PDT)
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
Subject: [RFC PATCH v5 05/18] arm64: Implement asm/kpkeys.h using POE
Date: Fri, 15 Aug 2025 09:54:59 +0100
Message-ID: <20250815085512.2182322-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B8D74000B
X-Stat-Signature: madsw6to7n3sioxjybweo74co6sdfzqn
X-Rspam-User: 
X-HE-Tag: 1755248151-469350
X-HE-Meta: U2FsdGVkX1+abjVcxS6qERj8osRq9JCANnx7oYE1sA+TAqqzN1pv5ZzF05DWEHaAXa556yCeGufvBnd7L8cLLahOfmbNBNyy4XQfoHMLhvzukAy23heLJqzzzPhDX9cLzFGC5MZif7T4KeVytcNtHSizgpY11d0nYbo9n73tGcDcyQo/LN95ZAR9ClyS3z8QByDijM5VWM1MnNWx+u/W2Vz6gX1ApMKvOF2JLJ+mL/yA6FrzlxqJL2nY5kevPcRhpJosZ3fzI8nyeW5Lw4pOiD1Rsd0UcEiX9ZwGAG0IA5CwxiMtOTKX7gq9kHlW7q6eSHs5mIdziycRopv0VUPFUH34ColOZcBFjCPsarZqcjUFBfnJBIgfOSzXIqR9BgYJFuBE+BkNxLYLcFT6cgFyGVkKA8KYsT0tRySBY0TGf0JKAbgW3KyALrJFVx0mNE6fYQzlkzUSG6vUMiFOC53Rjup/y7Bk0/61mfcwKrD/gR/a/c4UUJM0zAwVRWrn2bK4lT3i6vh+LUw3I5r3YvURHTiImKC/gX2miNFqFzZorueglD1AKZ7TikK3fTTs43PUqZ7efNv7ZUwE8Tjg4EWh2Ux/+VEELmHmylqULosengBND8AW/41frCsL6BxIEQ10T9FydEsEKT8IGplppJ4JMFiTpRseSg/q/c8TcuLLlDErCsxu1rnSYpcQfkBbE52MPORMfzc8EK3uro5Xto3XlTYa9lCWYME4JSz71o0ShOLkcIKubbnviXay9SJmMwD2U+X5Yl0kp0Q3UXGzAm4x0/E99s7Skhiu0Vmz7K1C8zA1VJnPndeR5xkM3tH24imSdJxCwcoX/YdQXkfjo3xNgxfeOyz5+aPysWLHOrG9a2F4xxAywK8dad2QL32pUlmv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the kpkeys interface if CONFIG_ARM64_POE is enabled.
The permissions for KPKEYS_PKEY_DEFAULT (pkey 0) are set to RWX as
this pkey is also used for code mappings.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 arch/arm64/include/asm/kpkeys.h

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
new file mode 100644
index 000000000000..3b0ab5e7dd22
--- /dev/null
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -0,0 +1,49 @@
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
+static inline bool arch_kpkeys_enabled(void)
+{
+	return system_supports_poe();
+}
+
+#ifdef CONFIG_ARM64_POE
+
+static inline u64 por_set_kpkeys_level(u64 por, int level)
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
+static __always_inline int arch_kpkeys_set_level(int level)
+{
+	u64 prev_por = read_sysreg_s(SYS_POR_EL1);
+	u64 new_por = por_set_kpkeys_level(prev_por, level);
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
+#endif	/* __ASM_KPKEYS_H */
-- 
2.47.0


