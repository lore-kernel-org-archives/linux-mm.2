Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C7ECD5BD2
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E5F6B0098; Tue, 26 May 2026 07:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45FC6B0099; Tue, 26 May 2026 07:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C076B009B; Tue, 26 May 2026 07:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A14C36B0098
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C7F01A03D4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:26 +0000 (UTC)
X-FDA: 84809320092.08.ABDC2BD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 837B2180004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p57PsWH7;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9danRDBw1AQtwV1J30XI0czBEF8V99fPLYQxI09Agg=;
	b=VXD4JHNU8elxY1MjhXVvvnadNv0GFjxE+HNsLwhieGH8NuPD8cH1gY1g7XUXeUSB7L4GHS
	3687w2ZjH5+zKD6Irh2cdoUSnYKpRioEDX3/bbBJXQNKXbyqWp6wlaorD9yHO9RHoJ+ieJ
	gSXKSVX0oZ8Ex6amP+TpDI9WrhJHr2w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p57PsWH7;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794244; a=rsa-sha256;
	cv=none;
	b=Bnl5hC/RsJSp69dRezVCIolRcLhE7qw79kBfxcQRAd/iftx1oJ6gM7DDf3wPZAhAfXclzC
	cEs2Gua/3kcUinjwurv2NU1AREEx0fGBp6pBm196uU6UnOA1imSJfTGqn14hCwNRRIT2v7
	7PxOfTByLqfqzcGfueItNKOrGf1qLd4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82706169C;
	Tue, 26 May 2026 04:17:18 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B87673F7D8;
	Tue, 26 May 2026 04:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794243; bh=ScOjJcY4lUZi/QiKcDOuYUVGfjH/6STcb98MmPgtlWs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=p57PsWH7Zc/0vwIDEqRb6A8BMGopx8BzxIos9wA6VwJhaJ74/w2g0vmBB0HSm4yEq
	 Z544DK5JqY1WHW0NhjUxiSdJRwI0NSQsMWUca6nP0uuvJLCB8CDP7bOM6XWqXvidh2
	 nk+vL2A631mKhZf/REEEg2LSG+IZ9Q9hz/WFjSiA=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:54 +0100
Subject: [PATCH RFC v8 05/24] arm64: Implement asm/kpkeys.h using POE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-5-eaaacdacc67c@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=2665;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=ScOjJcY4lUZi/QiKcDOuYUVGfjH/6STcb98MmPgtlWs=;
 b=/HffIylQMDpk1TSgqL1d4Ijti+SGSoyeaOj5/vNUNbYO173PNGvrz3r/7wIUBVck2GnvXCYDK
 vKmtmOhZJymC2zZtCSQRF67bKDlRhR58WkFHN2xAnO6o1s7iyG2GAdG
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 837B2180004
X-Stat-Signature: i3q7zxum1hadqhr3yu4amdc8xjd9e35n
X-HE-Tag: 1779794244-670904
X-HE-Meta: U2FsdGVkX1/1DceycDJzG7LCMSp9ONfMOC+vI6ykt2DerAE+/ZPRzWdIGpE8v2rTPJW0S+nul5jaFyllMMYBr9DWUGbLOUzbgp2HyGqUwdMlqKOKtorCr0YTfB3Y9ADKuCdLYLE8Vv/SrM6+wjRSkZkuN309riYe+QfRXZQQtx2mcurA/+xA18ctx7eUy75Xl/49ds83q4ml1x+JIXiDzoQwsi+SzOV49d0ChyrHITSC7CATOPowgoA58c/jXuyeB4AVQ6bTqOVC7uu6+7R1/tDsJbKEyLSgmGNKC41u4z2vrLwyRxtaTtFVbYMtly8T8ptmsS4wD3rYKVdA8AFs6FGyJB6PCnV/rvKit3QbGI/oa+AX3jRBvz8RVHgyNb3DWFJHNS9++VPcEF472NVYZO4/4j0ebf7iU1GpabPzT5qXdMbfKv1wbpvLfIV+ugfOxm3LrBzI3nnsz3ADCv9EdvVdTR7w3v+eJhnFYSHxwIleZ8gQF/DUT4qxsfwNPbn5G5y4I7tlnAkwvsH0+xWwZxcnuaHHxMEzwzNalBF/jIo/t2U9JQ6xvzLhzC+W3RZPa3133YPJgnhD+juBzWlR8hqtUfmQi5of26/lSaufEmtcpkOttzUK3HJMVo5aybcVNVTZ+y1pHSmIt0FsUYQ5b5hbfbFKp2EKqcA+rsPvB2YtxLLwcI6MYQlhe+nsq8wZ92orwvxxQOvFkVd1z8tAlccl7h54Q/16E1koCFpJctvOZZSrxQH+Rguand5pEGQGnYy9CRUUL7CjDKeoGbp2zS+f1+AtNxfvGbGwYFcGT2I92KshQrrc5Obzydw6X2SGRCvSjxjY5NPFpb3lKriQe9CvxprcTOEd+9IaTVSmuHTfQbXa55++x6BW7+ktcAAIebSLkf008qoJuKKhdKXxjvcuWt26tP7Fna+8gLpT5u+keHYYd0wKiwnQCHlJKcDOXsP46yUmO6MyXgQs1ux
 EtFZXw3Q
 BLt0TavZ/carZsJ1zBGM6/ZUPXyvcsmA0E3mbwZaPIZaYOEeo82tqMmh1OLJE4xNSHzRtNUrPnwNEbTYlPm0QMjQ+okNe8rJCdrzFEM16O3UDFHjsOuprAPucXXl0bIwheqVATD+06pvubgbQQd/nvwtNUn6u/2RWk2Uso+QBa5vRdgJ8hXzxF7i4SRUsAC9AFoIhygbov9tTh9rAoO11+EVM6i21e2h4OlDXcGSm936dMx2SkauTLfiXvaLcMhRnqUEO
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
index 000000000000..4dbfeb3dfcfe
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
+static __always_inline u64 arch_kpkeys_set_context(int ctx)
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


