Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3100FD6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A586B008C; Wed, 17 Dec 2025 04:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834D86B0092; Wed, 17 Dec 2025 04:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712846B0093; Wed, 17 Dec 2025 04:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6216B008C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:47:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19F45BBB32
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:11 +0000 (UTC)
X-FDA: 84228484662.25.C340926
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74D74C0013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=brOaZf2K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964829; a=rsa-sha256;
	cv=none;
	b=WXylHfaLVdSeK7HMKTJT5emwqfSgEKxzA3S+ukwdkzolMX5HXqwxNYvuT+q2TZWVfeWsqe
	uv9Or2GL9loVLKAEIFv7efDsP3SjbvL+ka+O06rRL/FGSDI4uUdJBLEHyuOziHG13eXslY
	lpTfPa/oVBoPQvjSobhJwKsa42IVoWE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=brOaZf2K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjvVUE6PLFuQKn8iudCm/UQAhzXxbds5MAnD30p0biw=;
	b=pUcNWwarR1yTaIZ1wpMZqEDWq1Xwp0KvRlRo6isQpaXWw5xOfonsqqFSYJr7XJ76FlabcQ
	6iG+Ty3oMlPu1tnWiVFQemYr0iGXeBSJ8CIrV4ZtGrUqH/42jxB++8HJ5dV9dXVAfNB6Mm
	baTpOKrzZgA9hjUB4D639WeSi5ydwag=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765964827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WjvVUE6PLFuQKn8iudCm/UQAhzXxbds5MAnD30p0biw=;
	b=brOaZf2K2ad6KJwOD2w1YutexFLGuWsWBcWsSFSW9Rhbh0uxRAqynp0B/EeXVhrva+cXWe
	gZB0oCXryrPE12cWqlsQwhYB5Dx/EC0LkrSQOTkvtYLvI3X0HBt+KxidI0BnlqQYnQoYUU
	wdwCgfkrV6k+l3/j3AAJV14uDlUcyGw=
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
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH v3 3/7] LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:44 +0800
Message-ID: <dae0a0b490e912273a62a49be9d92f470fbcaf04.1765963770.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765963770.git.zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 74D74C0013
X-Stat-Signature: q4jxz9wz3ntzf367re385xdu3wnj8b7r
X-Rspam-User: 
X-HE-Tag: 1765964829-847237
X-HE-Meta: U2FsdGVkX1/6H4Bdgm3Zcwz6JGSLvDwd5KiZifzGpjs+Wwol4dmHzHnGeyyEF4PAjgUdgpngboqTRGsD1L/X0iEzY5o2D1CvM0XosJ29sCdJzSTrLE9lkFEwXv9N6nglj43EF+JnNTsRlyhehsXKEw8rRezC10mPX0Hasu1mLEDVgnvGXm6wKNudJRWqExJ+Nf0VQHDpFQMzSv7GoHe9JFnJ4CcgIaZsAqOS9+x/pmuMPBdd6hpkhJP6o2/loIoDe/2NN7Kwrxz20PIPdWZIyAMOIvV6tTEo+XEHlzxq250YyphOuDzTv/wfFn4MIs60sCFLvigBLwDuvBrVMdgH/LRGWcE2CM2HO4FAlfxq25Uak1mB12hisobkuo2zM6P4JOTFyzywVohsXzLxWqGsVFf2LEektD2lilZlQqxrhHf8q+zI9/XeJz+p9qA5TxeK1dGddbW7pbaK9BpuYkTWaddVdWVBHmjzRuIAQrESrq/iOA6BShbfOGZMWyfSgYmkvR/TTrw/DLOjVBq3WYP4TJKmwRvijmOYsaChEfSOAS+KDZfR9M/ZH6VgKuxKm9/KMgGVV9pK/8Y1zI01Rr3/4X0WCMB9Mns10X5BoyTtySWdjQ47Ll7G2WKJ4NcM7fynRTUQoCxohZnyfCRo5VeQqEoLCys+bjeOeuwBvIk+EZhbkuTNdVGrebsMyWPsLYCZ1gvdBJSUPqlHW1GAoc88r/UZGr1khVCC4jFXGH0EFxbGUlxatWa8TmPorx5a9Ia6drcjYcDg+thq3WiQ9Z6tsEEJHqIj9fSDkbwpkv+6/Dwhs+2fXnrGZYZQWXKDNME+UUxlKZPLNOKax1ta3KKwpMi2UsQaxMJQ9tFX8VCTnSO0mDrta92Gkb2gDc2UJt2UfjGmZClQPTKaJ77XnWK7L3X64S0PtYPZd88BLRw/jJA3/QdyMBucXm5X/iqY4VhP
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
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
---
 arch/loongarch/Kconfig               | 1 +
 arch/loongarch/include/asm/pgalloc.h | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 730f342145197..43d5b863e1fb2 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -187,6 +187,7 @@ config LOONGARCH
 	select IRQ_LOONGARCH_CPU
 	select LOCK_MM_AND_FIND_VMA
 	select MMU_GATHER_MERGE_VMAS if MMU
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_RELA if MODULES
 	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
index 08dcc698ec184..248f62d0b590e 100644
--- a/arch/loongarch/include/asm/pgalloc.h
+++ b/arch/loongarch/include/asm/pgalloc.h
@@ -55,8 +55,7 @@ static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 	return pte;
 }
 
-#define __pte_free_tlb(tlb, pte, address)	\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
+#define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
@@ -79,7 +78,7 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pmd;
 }
 
-#define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
+#define __pmd_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
 
@@ -99,7 +98,7 @@ static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
 	return pud;
 }
 
-#define __pud_free_tlb(tlb, x, addr)	pud_free((tlb)->mm, x)
+#define __pud_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
 
-- 
2.20.1


