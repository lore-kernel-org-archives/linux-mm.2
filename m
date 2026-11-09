Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC873606EEAD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ICz3usDE
Received: by kanga.kvack.org (Postfix)
	id 975AA6B05B7; Mon,  9 Nov 2026 11:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF986B05B8; Mon,  9 Nov 2026 11:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7066B05B9; Mon,  9 Nov 2026 11:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45ED56B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:00:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D56A31C40EA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:58 +0000 (UTC)
X-FDA: 85416044196.19.6AF2379
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id C4F4210001D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:00:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ICz3usDE;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240057;
	b=q1+nL0K8+fgTSg/G1F/Q6XtVdy5sNfAs8FsCfPkD9aCE3x6ZCdjgc+P3DOYoohnCNBrXKC
	Yl64UeXznFD1g1rYe0E7GbeLQKf8cCmLjnw7+ciHALFVV4zw0oT15faoJyfCNxASQgUR5z
	8W6T1wlr6XUP+wQvFsJGa07I1Ticcp8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcRyVl3av4/w754axH9VXzJaDMMrkqSxrG13JEt9n1A=;
	b=jyJgbRO1We4vTps5U2/A8NYijMb4kf+8UyUnFvLzQLLTM2q3jzDOjF1ckygXRq2m+slI9P
	bIBKbCweM4g6tn5dwqxLTIboN6deHwUywxG8TaBiIVLZPTJ9o87JTCSYyKa+OQLyLLZxT5
	wGLX4z1ZuAJYE4Av52o8vzyu3Y483tM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ICz3usDE;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBCAC1691;
	Mon,  9 Nov 2026 08:00:52 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DABAA3F632;
	Mon,  9 Nov 2026 08:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240055; bh=V64+QxW1I268L+mXq7JODtz29+UgFMI5wp/RRCsFELQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ICz3usDEI+AJFOSM9CwmodLqDlnKEquYVwFBN+vqqHVaIQsn0lUi6P9NdeFrQn90O
	 riUKSigPGNIjWu4bu90GFbApTlIDZB/d63VRiOCV+d1PLlOgLnvXqDXRLxfG+E3MEf
	 YnDpeGpz/KsBBSsxNQetzLP05ZpWWxfF98ywIXZs=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:29 +0000
Subject: [PATCH RFC v10 04/22] arm64: Implement asm/kpkeys.h using POE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-4-aa6c4d9603bc@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=3746;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=V64+QxW1I268L+mXq7JODtz29+UgFMI5wp/RRCsFELQ=;
 b=rmjR5AVjdB2ZyCgHS6vrWjKRVgyGGKu82qWQVc7ReZI8FFlR4sPvoyVMXljt7m3b5NfGLfzjl
 X8eWGgyj4ghCK8iUfkL6ITdyn97DuqqOqE27Wu/HHkaxuv3GRw+/nJ5
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Queue-Id: C4F4210001D
X-Rspamd-Server: rspam12
X-Stat-Signature: kjcmwq8tafkrk1fojw1cjb9s8scb477y
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794240056-466549
X-HE-Meta: U2FsdGVkX18KixCxYj21xbFCATyEccWJUmnS4wBH7dwCVbh6FaY4aMh18WvZZFqSzbKNvLbgC71+pve2JFKyhEkbkeLmxriM8TiYQ2zwaoVSuJTKQ3I04bIZbII9XPHMqV3nBfnZ6Gga5Llno1ljlZ1lCD3zAN07KLkNh3r3MQMiWO3j2aqMnDUWa73NFXSBFKgKlH3pv5S8ToO1fZMLRNF2hBxLu3dB33Dg1rPBY0NcOIMMQ2r0CRHkTAITVGCcvR7wRyztjvSnydFdXlF818u0R9+UlVqGdYJnuCE2wbv0/KBzrDS4IGB7IP3ormEbRaOOwoJC8k4YWuE6Yfqlu6qEnoS5f/gv+FerD6p029vju6IPMj9TJQRvT9wwzKkAvvqjXaZFlFHWeX55NLAnukQVV1tkRIYw20SHh4t3uOy+9lTHtcARaSstn7DsVcw83Qxgmduw4HlNE6DfeN3hj824ztCoOfbqd7GSSXbji+oZKG1LWXxtxnGMEl6uo1qljlhsCJZsuvqeqtOAGwQm6dHWXmWUDoWpiV0JnGkPcKvKVfHHKw106WdOsCwJnAvFwf9JM7yqKsXksh0IYgdx10v8siVwTKaR7vNmAWDxoTnCPzWiDAQGLuAO1+0j+uWyaMP3bpnLt7R8PT6+dFSECWV6KJvQPBETzPlEPOPP4KjNFiWyflcfFUkWj8JI38HI2+DLMw9+QYM6wXsTyrMzlcfkxhH7/xY/6w8Xk2BYCypTWsBoMN2r5q1gVMZb0m6y0+Y0M6S/nyfSZTECytV1LqoO0UGHdABHRFohmId1Cc4JQPSaAOYgCaVQTeBIoGcTyMGr7XJs3DKhEnZVzdW2clKudXAYAzT4iNLsavr17nMEkjCiEcPUJYemBeV3AahV5kbR2T24KTb/AW+ygQSHopbh9ofaHnnuULLtdvoRMOANSzE1xmv9yFmqkyWfFobTL9t5po1izDvXEIkonWL
 b34Aa4PH
 hbIs7Axr2cw8/aHhpu+rObjoCEZX5LJepj12yj2n4Nt9d9oCBbaAXFjT1ozSocsLAHVnL672RI3ysr6Wm0brE5zzwEne+yuPOMvBP1tcSysM3dWuH0VT5rYKzVoEzkU1QihJnY+zcunKRRpbyuqBTa97wpOVn8rTr5itq+KamnFIPmdCYVnvVwrb44vWt7gH5Dj+PMdSoUlAJVG5JeFWmtcN3M8cOVV1rFcfdPsnXC2XNH0mZ1SQ0z6qTntGwjMWbKSTpQCdCPVR6RwTFctbgnIaOTasZ8RvDpWbA1zU4nBEoxIASL/ZpUdkkIVgIB8NrXDiux/KKwVtwLvVUrgXd/YOvd3bbcv/qsWj/8LGotV/QaPMccZ4gtk78qIBVj42ubzFZkDCNStMW1MlMBkaFTKA4p50qHKtDW8wD1u6Edx1WW1gLIWYvu7J3iZY4IoZAcOvtN8DyEGWT1ZHOC3bdrETeuP3qLdZQrBUqMpESFitQKf6bhZe8sC2rT/wGfC+71Af5v/HZZU4NC4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement the kpkeys interface if CONFIG_ARM64_POE is enabled.
The permissions for pkey 0 are set to RWX as this pkey is also used
for code mappings.

arch_kpkeys_enter_context() returns whether it modified POR_EL1, and
saves its old value when it does. arch_kpkeys_leave_context() is
only called if POR_EL1 actually needs to be restored.

To allow <asm/kpkeys.h> to be included from assembly, also add
appropriate #ifdefs to <asm/por.h>.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h       | 73 +++++++++++++++++++++++++++++++++++
 arch/arm64/include/asm/kpkeys_types.h | 15 +++++++
 arch/arm64/include/asm/por.h          |  4 ++
 3 files changed, 92 insertions(+)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
new file mode 100644
index 000000000000..4f9bdb369b47
--- /dev/null
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -0,0 +1,73 @@
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
+	/*
+	 * Writing to POR_EL1 potentially affects all memory accesses, so
+	 * use barrier() to ensure load/store instructions cannot be reordered
+	 * past the write.
+	 */
+	barrier();
+	write_sysreg_s(pkey_reg, SYS_POR_EL1);
+	barrier();
+}
+
+static __always_inline
+bool arch_kpkeys_enter_context(enum kpkeys_ctx ctx,
+			       struct arch_kpkeys_state *state)
+{
+	const u64 prev_por = read_sysreg_s(SYS_POR_EL1);
+	const u64 new_por = por_set_kpkeys_context(prev_por, ctx);
+
+	if (prev_por == new_por)
+		return false;
+
+	state->por = prev_por;
+	__kpkeys_set_pkey_reg_nosync(new_por);
+	isb();
+
+	return true;
+}
+
+static __always_inline
+void arch_kpkeys_leave_context(const struct arch_kpkeys_state *state)
+{
+	__kpkeys_set_pkey_reg_nosync(state->por);
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
index 66d8c9a73224..b89be3cf0a0c 100644
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
 	return (por & ~mask) | field_prep(mask, perms);
 }
 
+#endif	/* __ASSEMBLY__ */
+
 #endif /* _ASM_ARM64_POR_H */

-- 
2.56.0


