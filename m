Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F00D5D2F000
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B85E6B009F; Tue, 27 Jan 2026 07:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575CE6B00A0; Tue, 27 Jan 2026 07:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485166B00A1; Tue, 27 Jan 2026 07:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36F756B009F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:17:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 605548CF1D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:17:01 +0000 (UTC)
X-FDA: 84377643042.14.F0D7657
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 72A761C0013
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSGS7Oe7;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQBzLGwNWLhDwXoP+ZRSwxq1ZRzbrKmRMjKOPlq54sI=;
	b=TNzgyKXuAzNLrYTI4gnJbWPWNpD/o3LdgKTZbVIkw1NO1m2COveE/wQoVBdb/5E1nL/jl3
	71KS4Tc2NbWOrXLP/GRlNG6iC7pLNaIBcB40SvqzcUf8PnyDJ42cTvO60lb0qjpdualbB2
	5yIiQdLxv8tvds2u6gN2iEmk+qkUJro=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSGS7Oe7;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516219; a=rsa-sha256;
	cv=none;
	b=BWOqSaMr9j2KsOZRfNU3eJSONBEN/EWOXSBAVS3TO3JUPDCcQDbFHLSpiqHlAjqL4rBp3V
	pQXxg+Q1RX2NMsZwuEeszOGVxLtkewQbjDwInY2RWuc1j67dIOassL+bwt9eQQP1n2n08u
	xWKpy2cCQ3dNL3vnvnR/LylbakobMHU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cQBzLGwNWLhDwXoP+ZRSwxq1ZRzbrKmRMjKOPlq54sI=;
	b=jSGS7Oe7flEf1a3jjawW71oBSQhZPtzIf1jHxOLDpEaGXg/8H0JQMtgOEgm1lxSI0nFjif
	CMLoz1yjkN0nwmCjWOwy4dWfqN8+bvppy0gq8toChP4Uc6ASbK4hQf7zJ4fTJfyy7Xu7HL
	RfqIvb9PoL98f2B3qx4iqWkzECkNTi0=
From: Qi Zheng <qi.zheng@linux.dev>
To: david@kernel.org,
	andreas@gaisler.com,
	richard.weiyang@gmail.com,
	will@kernel.org,
	peterz@infradead.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	dev.jain@arm.com,
	ioworker0@gmail.com,
	linmag7@gmail.com,
	akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	sparclinux@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 7/8] mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
Date: Tue, 27 Jan 2026 20:13:00 +0800
Message-ID: <5ebfa3d4b56e63c6906bda5eccaa9f7194d3a86b.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: 75wt1x6aipmzjnr3nwittei4f9jkr6q1
X-Rspam-User: 
X-Rspamd-Queue-Id: 72A761C0013
X-HE-Tag: 1769516219-88898
X-HE-Meta: U2FsdGVkX1/FkuNSlUufZGNOQVcCvP3IaKzMWgHsxi291QywXEUhMn9NeZGZsZlPFZ1YPq5PrUIUq8V2c4f727+g44jVuNa4HkxS5oCsasrR6Yt0yy78n1LkycZ/0HJlenfxi8LuzFkFwZ/rTuG10HkuQdxxAbyG4Gi1M/WNlm4mIHbcbdpbp94DOZ1xySFxkUf6fTBgeolY4plajMGdqBY4ITSYF9mwgeBp5+h1+DC4KizdliRG1r8NCNpV94ivdKG7+7EM6A/V/onBogSKOXsl0jxzizXtod0R9xt+gysukZmTfBv42uaIhurLTvTaP3vGeIQtAIP/1HY38B5NQ7GTrlyaLecAeEr5CUVceAwmVTLMrHNcRghO/CLkYjq9br7dFxQvjOzUpXbiEoXESQYbOWFwyaC3RzLnzVGeV4Cf0yu0G6qIvwmAyQ+7iHh8P9hGphwBwcAQRgu21W0ZNGC0CM7hfS53AZJhtijFUnlAoIwwTOIriunb1duYD0PiiVMu/46PDDPo5zK7utR6p4lx2vb+N/EdZpGcaLfFK6wLzoHj2hyXY3i2EN5w+I8/h0uXBRFS+73Y3BXQMV+iM+P2WR0OVLCFInNzTZnybqnfyhsGdz9zyqzUigC8KtKQ7hz7lKSPVWY22DV3FVd/i9V9vXOteLTnbkQI3nreLHJgjld715+Ow+tZc8n4UkG9IVB+hyL5hseNhI+1RKwnf1wJ9hTRaqq35pBOuhoeOptJ1Bbrpb5TkoDQg9vk+pvizSU91HSr1YOaIVv1p/wz+woLpR7VMI1lIwmXMChiOMlfGy8dIXLWfXboHYRjRWWTlAmpwL+WYOHcbpuR/7zkDwIViQohcxfsSu/GJsHtHJ23FgZHdYkats1OHM3AbDwTJiLG+eT+xH1lQA03v6OfQVRMBrB0fFek0qRL7DSVc4pMf4+WHbFNilVFrVXQR1Hj3TL/xo+QcXsXMq5wLpq
 sAOKgNtU
 2jzkrkBFs/xNrLBN6sQWJ3CtLiW3k2XiyJJnu+VmnPCelwAlbbTQwrbFUatXhEaey/yvB3ogTfPOSR4mmMsyw4a/GIDtGlE17oxR22qSfAdK8f50bJ+GHvWtOCraIlJV6y6ATKWzUL06u1BPfzdzQeDbFKTjo1TUOpjOH81mhl7+3SrSCCeST5LVvQGFgXGUp4++LUaciWhKvwPlBY1SOmx6tGlqMKRa4zvrlT0ZMXCmfriA1MFfVYoGwbmBdRS+4n1fIpe+6IfITCM5bTM7lFjZituAwriv5XceB9O5YSnISGr9Ykk8ZBzwZ0aWzp+fDcotWlavAfrj7OnVKZ+gt4aDK3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

For architectures that define __HAVE_ARCH_TLB_REMOVE_TABLE, the page
tables at the pmd/pud level are generally not of struct ptdesc type, and
do not have pt_rcu_head member, thus these architectures cannot support
PT_RECLAIM.

In preparation for enabling PT_RECLAIM on more architectures, convert
__HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config,
so that we can make conditional judgments in Kconfig.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 arch/powerpc/Kconfig            | 1 +
 arch/powerpc/include/asm/tlb.h  | 1 -
 arch/sparc/Kconfig              | 1 +
 arch/sparc/include/asm/tlb_64.h | 1 -
 include/asm-generic/tlb.h       | 2 +-
 mm/Kconfig                      | 3 +++
 6 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9537a61ebae02..b47aa8fd62742 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -304,6 +304,7 @@ config PPC
 	select LOCK_MM_AND_FIND_VMA
 	select MMU_GATHER_PAGE_SIZE
 	select MMU_GATHER_RCU_TABLE_FREE
+	select HAVE_ARCH_TLB_REMOVE_TABLE
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_LAZY_TLB_SHOOTDOWN		if PPC_BOOK3S_64
 	select MODULES_USE_ELF_RELA
diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
index 2058e8d3e0138..1ca7d4c4b90db 100644
--- a/arch/powerpc/include/asm/tlb.h
+++ b/arch/powerpc/include/asm/tlb.h
@@ -37,7 +37,6 @@ extern void tlb_flush(struct mmu_gather *tlb);
  */
 #define tlb_needs_table_invalidate()	radix_enabled()
 
-#define __HAVE_ARCH_TLB_REMOVE_TABLE
 /* Get the generic bits... */
 #include <asm-generic/tlb.h>
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index a630d373e6453..25fa2908d6152 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -74,6 +74,7 @@ config SPARC64
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select MMU_GATHER_RCU_TABLE_FREE if SMP
+	select HAVE_ARCH_TLB_REMOVE_TABLE if SMP
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_GATHER_NO_FLUSH_CACHE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
diff --git a/arch/sparc/include/asm/tlb_64.h b/arch/sparc/include/asm/tlb_64.h
index 1a6e694418e39..3037187482db7 100644
--- a/arch/sparc/include/asm/tlb_64.h
+++ b/arch/sparc/include/asm/tlb_64.h
@@ -33,7 +33,6 @@ void flush_tlb_pending(void);
 #define tlb_needs_table_invalidate()	(false)
 #endif
 
-#define __HAVE_ARCH_TLB_REMOVE_TABLE
 #include <asm-generic/tlb.h>
 
 #endif /* _SPARC64_TLB_H */
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4d679d2a206b4..3427b8036ba33 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -213,7 +213,7 @@ struct mmu_table_batch {
 #define MAX_TABLE_BATCH		\
 	((PAGE_SIZE - sizeof(struct mmu_table_batch)) / sizeof(void *))
 
-#ifndef __HAVE_ARCH_TLB_REMOVE_TABLE
+#ifndef CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE
 static inline void __tlb_remove_table(void *table)
 {
 	struct ptdesc *ptdesc = (struct ptdesc *)table;
diff --git a/mm/Kconfig b/mm/Kconfig
index a992f2203eb91..456e9eaedca39 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1451,6 +1451,9 @@ config ARCH_HAS_USER_SHADOW_STACK
 	  The architecture has hardware support for userspace shadow call
           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
+config HAVE_ARCH_TLB_REMOVE_TABLE
+	def_bool n
+
 config ARCH_SUPPORTS_PT_RECLAIM
 	def_bool n
 
-- 
2.20.1


