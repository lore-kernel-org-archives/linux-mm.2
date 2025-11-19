Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9666FCF2590
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F122B6B00A6; Wed, 19 Nov 2025 02:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC23F6B00A8; Wed, 19 Nov 2025 02:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62D16B00A9; Wed, 19 Nov 2025 02:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C28936B00A6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:33:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 743D11A0385
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:15 +0000 (UTC)
X-FDA: 84126540750.13.F5A5D77
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id A6E161C0004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pb5LFJ+I;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdgUvYzcKft0e9ATGbEv1Xh5QzTrrx2Vkhg8Ynjkseo=;
	b=ItAnhOyF/aFOyLWEE/Ag2VJVvsrEwtgPB8LihEqByXmXCtB8kjVlN/Gn82ohp0XotgazLw
	/MgdNn8Pz+mJnLtw2jHxZF4UtSy1ETZJBiC59yXFUEaRBUG2P3PGMjd4ID6BS+c1iUM7Xb
	PDRx6uW6To6s+n2uYLzmRyDD9tEBO6U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pb5LFJ+I;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537593; a=rsa-sha256;
	cv=none;
	b=nfqFVgop76qBRj0eObIfExdDs6BJSHdGZHeYaix+dk+J37EkNzlxfSv/9QP01F7JRdceFI
	S10kiR5+tTBQVFN2hHJqL1sCOWHcIwTxwTtjvuQhuf2h7gnxnrEMdzZ3jCgXxGfVRPbdz1
	UAURMZ/VAmOgDzuqgP22oAzn9mWSQmY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763537588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zdgUvYzcKft0e9ATGbEv1Xh5QzTrrx2Vkhg8Ynjkseo=;
	b=Pb5LFJ+IU/AZ2Oz4xGklQJtAr7Es3lk5E9mJtBOlpGjpEgsHLj1bdTC0GTVwKClzrR4LOK
	intXEaBo7Ss5/OCkxQXg0NTRpmfVxlu9kTak8I4es9WvoPUCvmE9L4Qkpx6nGAl9AKSns5
	kY9KU02r2QCtq/wVBDCUyb2Auh35ZjY=
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
Subject: [PATCH v2 4/7] mips: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 19 Nov 2025 15:31:21 +0800
Message-ID: <1ef6075dca55a0ace4a6de6350531e4bc513080e.1763537007.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763537007.git.zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6E161C0004
X-Stat-Signature: 6b55qnhmcts9edo7qg81rpkt5zc6s3i4
X-Rspam-User: 
X-HE-Tag: 1763537593-679970
X-HE-Meta: U2FsdGVkX18N/jQ3z/YXSup7StcVvISSHwG2pDcU1B7L3tIpZozcF18/cyJDsYsJiHLK1MV4g01pRzGFF+i1RXlpQrCrne7ZYYlvEIa60d1bEOManS7YIZr9Ci7EHPbxRyIqbBpkc/28UIbd9xFbqOZXLjT6WaezBncCeTYx+UCXMWI/NGDELNmyjWogusdptJeYZewWjn73cTy+t1f1Hyy9JVYBgNi2KNLVggnmVTPvvswFGIFhVXPhSgxTTBdWCz0B+GOuoDHHCGThA5GO9u5dgQvPlfwKKUjuEg13nE1rqVo1g8ZMvTjSA6nsanPo1Y9MznEyCilJvPurwG36r3N6FgMBr55acbNO6N2pdu5M45LpmK38tb+fScT++prltw22RRyD1RKu0ClAXJy+D4cdVX2o1glRa7Rl574kdtupXXG8Wq67Ok3Erc75OH2/GddD4wt4E6aJ/cPtDejXhnwIK22F3rin8eOWcyxYyV4MigMfTwcpJViYb6vvN/y+HUA630rr6cSxR/7K6+2cZ2fnjYk1KxDDo8xctxEf+2cVXVhxVBbPugAOJyfhiJwjzjYcHKUAcAkhVoB6SRJc+wFW81+nISpGTqBuZJpu15OP9iKqLlEC9QnU6WOnIr9J8v2+k+2xzjfWH+5k0fugxGnMCz8XSsP0RkNW49jEfdJcUZHj+QKOCNWozAQtS+zze5/5/lDGar4bbMp9BcQVVy0jBkE4qhS13niSmVeyWJxfZOqMktHJoEfdifs/T+JR7WPJ3pK5bfh3fEnJ8b/CgzzFTBberKGb3BpVJnCZlNjnk7Jp75Mp5k73VH5kwH4XawHCDHoxQqsDUaJR+XP5vQX6sqJ+YoMa9sYDScZJGpgWATB1fd3RgptunXhK4gmNvl/4kEojCWZqfoOHV4XfTIyQx0l6ToD8UGunIOAClMGWNOr0zDLcvHT7q7DnvJul6zcfBqe3464f5cPmMQV
 3rPCmHgP
 JHhE9D/izeY7U/wUtwo5OhIDHA/5VeLxZMi+BA5kN75K+0D/UQVXkGpRnZkQwV/C57QB5rQ6JqWnZEt6LsRrieDUl+2an3D1aMRcX0qMts6TU/CYxSxKXaL1sTv6ZJ9Z7iSuWng3BPNjmvlq4f9S7KaZe11oi4ZZVuPgvDs58PPwoeOe5TonSjJIh7GLjGZCKqunsJ/iu6xD+F6EeR0eWrL5e3wLtuEsGnUdR
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
index e8683f58fd3e2..8b16dd4db7c08 100644
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
index 942af87f1cddb..9a7e5af16c00b 100644
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
 
@@ -98,7 +97,7 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4d, pud_t *pud)
 	set_p4d(p4d, __p4d((unsigned long)pud));
 }
 
-#define __pud_free_tlb(tlb, x, addr)	pud_free((tlb)->mm, x)
+#define __pud_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
 
-- 
2.20.1


