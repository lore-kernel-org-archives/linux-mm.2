Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D6DCF2588
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2400C6B00A5; Wed, 19 Nov 2025 02:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2178F6B00A6; Wed, 19 Nov 2025 02:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154EC6B00A8; Wed, 19 Nov 2025 02:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 046246B00A5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:33:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14AAE12F09E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:03 +0000 (UTC)
X-FDA: 84126540246.01.C01B43D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A9F814000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YWY8Wd/h";
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbQut2RAeaEKXRoxc7PGnBbX+lTx58XUfxm/tIDziS4=;
	b=eXQ7fiCk+5uHfyo8ZjQXBYobaovrBUC9LIIp0BMTuma0bsJaTSEf4AJjuZb6hFpoAH99ra
	bEgg5tfPHi80vklI6uueornf7Mwo1WEoouqB17+QNnR2EUBzPOYZYd93PYHiBAXkwNWFZn
	XjPQxHpu6pJ0T4+IZK6Y8JGUQtJ/d10=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YWY8Wd/h";
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537581; a=rsa-sha256;
	cv=none;
	b=378CF1hEiaWLDghtHx/Ps0/VnYYUSaZNIMUxU18EzabRhNcR612wKbXQGHbTiLI0roiQ7P
	AESViyJK4iqF21L6E/jsZaqySp+jsyezI3A1DWOO+Yd5NAEFn+S9pYgittU+j+KwO/CLng
	j88N7hKCrHn+w/1wKhdny28tHEdnVj4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763537579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xbQut2RAeaEKXRoxc7PGnBbX+lTx58XUfxm/tIDziS4=;
	b=YWY8Wd/hFhv3CZWBDDzWNHWU3c4vCOTDJZW/mEzfM0Wlf7hnGTSivFcCRJ9xyCe64ovTmd
	byPLPVtAT4GqYNj4gNPzHf5ibj7aP2MQEmdYxkGBgLDrH/5Ncl2qWFYZmMJp+cJyyYj/NQ
	72JNhTJaov0NSjtaGyaV32a2xS5LLUE=
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
Subject: [PATCH v2 3/7] LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 19 Nov 2025 15:31:20 +0800
Message-ID: <0e12d201cc18a970c28c84030a0d79f5bda492ca.1763537007.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763537007.git.zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5A9F814000B
X-Stat-Signature: 9qceymo8dmfignajoey7ysnxcdq3644c
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763537581-211083
X-HE-Meta: U2FsdGVkX19aZEEaCF+wDGZDMfrGD+597iuAIA+l0O0LbnVmMcM7/ZUI6SFoLkFmKXzISxknFvpkyETuNMCwq3uYKBb6bXeP0jeAzIRVuL0T6f182TfikZCM5mvf2D8Wjxqkdriv/+mhc4yG19hOrqqisfvgWv2f7ul6GWmGGxPqcWLtDjpXZGxlvFQA+7I0YT2BOqguHkrVDuzGioaXtiCQrg3AiVxZWmZgHaimZCHtZcIToT0GygawpD5CPekx/cWah7L/Y41UPKBr1jUJL8tkhcFKNVi30/cp26dS5RjgQQP+EXVEkMlDeIiDqMnFXFUEN50OFllOAHXQYMYMg7U+jOgm/C28d2zboi6czveR/FJ8FT6pZf1PFUs0rHMk4BkJi12oFCvvW74F3Hlv+2KQnrRhHEJDIRlo8LmEajKKYLWN8T717Qbmnn8jSizrWTEoyV9WWAvEwHVknQn4UpEv01vXmDV2koetO2W8OtuSyY3jZSmV5Y9goG3gReAubcKjARMlz9RF2ycLLvu7vTLn08w5/JEHHR1+ugxUaMGtcJXB2/q0hLFRYW3y+qSsJhV3w/qOX88hOepmBhkrBZdeXx+gkOfH7qqCJqKbfuM4xUqiDzR4H+GSLDZl1bniQ5zGc5DzsoXhYK3gnpx9cRIbECAN/uFJLV2vJPjMlncRxSeQQgb2QfTYs9UMkvuFthzZNM9uItPjzQBfJBujkt/XFGYPU9JFDESudM+Jsg6Uwfj42foXgie/8TTiJctrZ2Rb3Jlrk10UuSNEsny+Qg2M+0JLp9DEhZxnIwZsgqRkHtFVPV6xRyFjCHEZ9kF6PyG72kH7SrlIGVjTagCqLffrOmkKjNziN5Xjir5KkXNH5g3/crhmj2KKQtjN64BmsgfuyADW3q10ATdSiZYJwo/IMRbT67FtU8tEe+u8y+JjzqPG4zppI3s9SYQ0uUDtp3R2HRZ213TLtc1ZbjC
 sdmdhPT1
 zEtx3eHPcvAnahmDNChVRGNgvFT8G4oeskFbTbPvqtyDE60db25EiG9XTOUWk+CQNmmuFXE/KYAzRn9b3BhZ5vWBtBJ5ayIAbYHOAYOIsf7WOUmaHtSe39uIvmFnQA3PbHNLwQk0IaYZ//aAnlGSTxZ0oSiwm3kuelbGJtHkcIqEGemqpT0A93GnQ1mUOFHfAhVZHjQCfoInHQOGKO1qQEjSu6Z3hDxmB+B0fOdgwUtajYtqq8Zlrl1ji/wjh2F3EAcDHkaRx2jYxiEPuJynRUikttf6ZVtlQFPEW
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
index 5b1116733d881..57d3e199605dc 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -186,6 +186,7 @@ config LOONGARCH
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


