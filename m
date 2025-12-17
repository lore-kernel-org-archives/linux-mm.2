Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A337D6552A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2846B0092; Wed, 17 Dec 2025 04:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CAD6B0093; Wed, 17 Dec 2025 04:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6DE6B0095; Wed, 17 Dec 2025 04:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA9C26B0092
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:47:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CCE6609B2
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:17 +0000 (UTC)
X-FDA: 84228484914.21.F390F9C
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53A2B100006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XNsRb5JY;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964835; a=rsa-sha256;
	cv=none;
	b=tT2QKOQypzt/FAVLmfwggvZxWGBCiWcvVSJdisV2RWEiFggWGq53AAQ2qSfzzc3aQgV557
	rqRXx7LY1bQSbKDBDic46Lc4sTwxG5uSoXRl1LWMvkF5tnYPbNexseIYBboPGDzt9/nXty
	/DAimSt5iszE5wMDyq8MnsgiNO7jgiY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XNsRb5JY;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkW1q5oTlkchrLBj7uhW1/fyT/NJTp0qrNRVsGoiJYg=;
	b=DnPaRtUzUVE7JyZtBli0F32CpN3d65XQVpWCOZVrO89KfY0XdOTpyZtRlrTYdBn3VaOgW0
	9AJ9fTDubGQwiYMXG1rY2tYafqNn2UB91PAuNs3X8u2X7z/lckSCZiEMiBGO0qMmtrhRYt
	l8PlTtoiy2wMh8cU25Y/PpNEextfQjw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765964833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fkW1q5oTlkchrLBj7uhW1/fyT/NJTp0qrNRVsGoiJYg=;
	b=XNsRb5JY0NarSUDlxllpefgnMRlLZpW8qzQc9ZHNREId6Fq61bYkF9z2/CqnDHghDcClS6
	JSWQbuaoMZEDzyNrP0E+UpEKY+0lMWWkYwX8tos3g2d3TeSlYHmAkMIa+8GNC7vJ+Ulmkt
	1rnXZCKBiJgsfxRzh6s1Opl85Us62zE=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ioworker0@gmail.com,
	linmag7@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH v3 4/7] mips: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:45 +0800
Message-ID: <1c14fe4de18e7bc71b98eb58dbd4edb13d3391cd.1765963770.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765963770.git.zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 53A2B100006
X-Rspamd-Server: rspam04
X-Stat-Signature: ys6zfbkujuyqfiye5e8k9ha4yw9xonyh
X-HE-Tag: 1765964835-617167
X-HE-Meta: U2FsdGVkX19qb9LUWzRG5eYi1soEI1lu98+EUW9fx65OAWampB0bfZjgN16m4z+CJdr+CplnQoE6fcBumarnSSEMEcTE/snHDHVABmWvzS+URvAIhVWorvJ0IECobqhrIi3c8VQsw3WWMZyum1pAluvGWBE8dgXUU5CSl53mvSWo/l2LK8T/V6la8pJEiLcrEbPhzsajwUQGIwEx2ZtQ/W4mCfoxV9YugpnMgR7ldHeBK+xSSTS45JhbiEe2XqpyzDjO+APib/whtD7UGb2hkdng4e2SwTGoyHfpIpdD2z0ZRE51emJhaCVhDSgk09jjWWXMYmT/y/ktjZxkHZ9rgrLSHsC0QzykfKXRsr0f4DDLEUabjBs4Yu6dn8pDFzOwbFp6JEOLAL26oPHYR/jkJ3mqPPY4W1BtrkM/RQYlwfLpBttWA7ReqiTpq7O8Y9GCoODpvOtW81bUDUdcrlFjtj2rrDeuHDCX93lSfAdhly70OcrpJA4vQ769fHDRabGZlJ0JWZYY4/VfnPkJse3kyJcIYAiaUh2yhRpIFUEUrv8lY1OnAs/Wfov9Hbx1eDCDDAeBjV2ThElB9/5G5Epqb5GimelBClVIToJkydstqrhDTRwRAAIYTDJGsoJ8g7aqUknn5udDRGF2YZZ76dXQmMHqwWcg32tSiwlWdOMz3eZT4Z8Pm6GT2Iok68AXELyhIWGQVWjpEQ6GwXZFpN0i1v2apWa2460cb07FSawT26VDA7RgT2/cnd0TiahimeqfF22aOvV33B/ToiDHg92ifEGqpUH8xwKRQxl68giPO5mcvXB62qMM5S0S7J9lg0580jtXK5S+A+A27KkDX+qncxIqRaNeoR9MUOMSSDdzBYyF36Jfv/nA8r+952Z+X1u6icCODwk8GvlZNH1F8z9NCGfiSn2/TeNU/mXHS+zT+2fg+EZHrW/gBT3z4XvrtdFjX+2EcO4aXA25gXtaUs6
 33okB032
 8jOAUrwYRLn63GEjJf/0pjlmcw0Uocfn8xfsqx/617+3UpPACkHvcuyA6xF0r2HJCZofO2vD5BKoHPlzW6rVxx2mXW7rHm0SwinZisMw0Xpkim3wteLNTRIWR+pxBPWv6T97MsXJqoq0De01VohhPF8Ixjvt8cLAOhMHTWw3VTbqvNZOr4V6UYcjHylpkzyj9Lp4fA0jfZwr33JVasqf4nQnn+OxBfMA1kHnna3NmXhQrTaqBTUZ/88XkzS58PdPUyoRrrO6/Oh0NJ4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 arch/mips/Kconfig               | 1 +
 arch/mips/include/asm/pgalloc.h | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index b88b97139fa8e..c0c94e26ce396 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -99,6 +99,7 @@ config MIPS
 	select IRQ_FORCED_THREADING
 	select ISA if EISA
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select PERF_USE_VMALLOC
diff --git a/arch/mips/include/asm/pgalloc.h b/arch/mips/include/asm/pgalloc.h
index 7a04381efa0b5..895bf79e76762 100644
--- a/arch/mips/include/asm/pgalloc.h
+++ b/arch/mips/include/asm/pgalloc.h
@@ -48,8 +48,7 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 extern void pgd_init(void *addr);
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, address)	\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
+#define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
@@ -72,7 +71,7 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pmd;
 }
 
-#define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
+#define __pmd_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
 
@@ -97,7 +96,7 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4d, pud_t *pud)
 	set_p4d(p4d, __p4d((unsigned long)pud));
 }
 
-#define __pud_free_tlb(tlb, x, addr)	pud_free((tlb)->mm, x)
+#define __pud_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
 
-- 
2.20.1


