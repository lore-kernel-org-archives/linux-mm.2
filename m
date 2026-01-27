Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86DF8D2F000
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BADFE6B0092; Tue, 27 Jan 2026 07:16:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36FB6B0093; Tue, 27 Jan 2026 07:16:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B026B0095; Tue, 27 Jan 2026 07:16:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 969E86B0092
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:16:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 618A013C128
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:39 +0000 (UTC)
X-FDA: 84377642118.20.EC5D72F
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id D759C4000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sFZyeoHJ;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkW1q5oTlkchrLBj7uhW1/fyT/NJTp0qrNRVsGoiJYg=;
	b=DboJAacrcn/jO8kfw/vSICnB+ehe1quoL/i7OczLcqaxPk81FjhHJG3ylN3J+J70Hewu03
	Uags5eYwwVCevinunTIpCZ2ffBdUtQPRNChlopNHI+xRKpT7A+7OJ2fF5Ee0hn+sNxpdAL
	+gEiGWP2g3o+aJfBEPKvISjtHHasUPg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sFZyeoHJ;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516198; a=rsa-sha256;
	cv=none;
	b=iyMpTV3QwPLZpQDQOkLN8rsIvs/DzNz01Y4LviUsqGX4oXCq0SV0hjMFf6akXLkhy/ivk/
	0WXpCVAe3yQZI0drdhu6QgJH2EHg4xfAlbbyoDxT3FJ/9aAxhPO54I/y7kkpTfiAEm8b05
	SuJyBhZk3eEVccZcXkavirTahRvN6rs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fkW1q5oTlkchrLBj7uhW1/fyT/NJTp0qrNRVsGoiJYg=;
	b=sFZyeoHJIKbye9uwcywAcpjl2xzdJccXUsdUJIt0TNtOYHgA7a208ZAIF7HqUNMoKtlbs6
	TW0o13FMFBrSCMFPpUnlYGDJlzuL1Fr0k5t+5kHxBoiaDB3yOgkQV/YzB2ftvcx1Aazeg3
	1xj0enzbG3UIgCeH+LduDr8+xkNa3bA=
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
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH v4 4/8] mips: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:12:57 +0800
Message-ID: <0d17f00a724f77aaca2da7c847acd490c3a47571.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D759C4000B
X-Stat-Signature: kzp1dxkq7fxxnagythjp71w78gryao1w
X-Rspam-User: 
X-HE-Tag: 1769516197-862708
X-HE-Meta: U2FsdGVkX19tYYw4EPzp1jptBeiTNV/7RADpCMkxctlNSsObz/nAwwlZBZ9A6d0Gw6Qy6V/jRxS/CjEoqH+koDDMoIu36FU/dGrretFf4KV2xFqyezfnLv9hFXQE834hPLqF9VLbxjPb/6CpbhVsfqCkC1O7hlauBA6ShOAOVGMzhPydi6uQ6oFauOE2U/UGFsway/9inPy1BWafhhigTlhmRnrH6Rm6MlvVlAHZnO6/CNFW2OgzprEz68TSx8+hDpKZdqmC2ZBf4xchEM0AZyiFSwiu9nX8eqzbMMJbLV2UB7ch8wpQVO/4hPbfeXwYz3nhUIcSwjv7wUXjM5vl8NFJkP5tBSCXgGQIwtIQ47XWTmPLCEUCpADBR0zXO4NpqOJjKAhHdmKTebZrdiVhTHezVVJ06Ff98e+9Z8QRjp0wowtMGVCUKRCsRNzAceIOPRZ/154YydYYi5T6ASQpYDYBEKnDFrwJC1g+xUNlF7Jl4J1W8XPUBrAdIsZOuV9M7Ke1D1V/YPF9wqv8Fg4JHsa2VFjXUYzCQNw3Zv+b9mVOzy74Zu94Z072YafZttsoIG1cS/KCx/hyBCZtit5IN5SM7z2likjneratJ7gwn1aQfnaCx+1jL6dhALSrFIMLBNu8BiqfXWacGaBCumnJnMfM8LSY4R4HtkWc0+c27kkry5fLXyJ+zdB0pzAQDAnR93TaprJsmqnIY6ZCFbJS/P6mSk5e8ZRe1T9QGx8vP3wr1m/Hn+la5PM2RkudUyef0xH63PD/8/ZofDXGcyNI3lx/DN+WBJ9PQ95lVBtc64OntE8ajyng5W7MVkDVw7w0eGu6jfSW1g8uGeLrdL63h7o+waqrc6Tpr2vibh1KBUFYoYJ64gncEwVRiZquZOfiBUPeuQSRq+CgtryNpv8ra0VNaBcyCsjMkhEVhVJ3xs0+TJF2W+t0mCyyoudogKeHhRqsfg5RtldByUKd99f
 5JyZOdhs
 ZtlLRhLSaCeN9KaM=
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


