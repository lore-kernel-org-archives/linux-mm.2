Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C1ACF2567
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD9B6B000E; Wed, 19 Nov 2025 02:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685816B009D; Wed, 19 Nov 2025 02:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2166B00A8; Wed, 19 Nov 2025 02:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3DF6B000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:33:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1219F1403C6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:23 +0000 (UTC)
X-FDA: 84126541086.17.D37BBAE
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4EF5920002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UPZyoHTW;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PNYJl+4luznSu7Qs41hn6BnOWw9fSYJ1f3qY5qKkjU=;
	b=1wFQmEL78frI2x75OaPuTwVep/AaThz1vmwTAC53VtprXiMIsDakPj+sRUHVx7s9BnnWuB
	lyz8XMC2cLhfP0/LPwyIT78F3WJi3okocdAb4YKi/nb4wJTZt8MQxqjWdyjx1uet8Chm6l
	IuvDX15XPSCCMi9Ls9jnGrWyagtb4hU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UPZyoHTW;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537601; a=rsa-sha256;
	cv=none;
	b=wETQnVlOD9IyBcYku21hm/u1iVzUHhmfWyRJqE3ILkb+O2bhVC/3ZMfMxC1UcjzQXKxh8Q
	j0W9hf4dN1lVA1Iyuio29DnyjA8Q0Ga5uignxFQYfy7BeqGOkb7OYEORKLBhoDrEWONudi
	epuiO31V2rK8F63tFB4LR3mI22UvRks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763537598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PNYJl+4luznSu7Qs41hn6BnOWw9fSYJ1f3qY5qKkjU=;
	b=UPZyoHTWlvcojbrasT0m6wZAA4vVJvUtdfGcqOc224298mAJZj8RgoKfcBwgHvUNwVVlYY
	xUXSg/BFyvnGHDg1OT0FG3OvfiUEgAljF44L6ANy/FULPK7Dli6T59Yj/3HWliWxACip+2
	cxcFG/pEkqS5KVkntRXLnkKsYrtQDIY=
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
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH v2 5/7] parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 19 Nov 2025 15:31:22 +0800
Message-ID: <74f0e72f11347656a9de0d4b9e2bccc17e4338a7.1763537007.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763537007.git.zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4EF5920002
X-Stat-Signature: kpqdrgrdzfd1e1hs8mm77g4smskmdnnf
X-Rspam-User: 
X-HE-Tag: 1763537601-270503
X-HE-Meta: U2FsdGVkX1++36kQNSaAftPm3/Z09gYUZNFpN9d/nGT3DP0lTfY8jFBJpXL+7JLK+X5fnxusyheaDKhnFTVuGaIRDxtplZrf46pSYkjlv/MIKE1B0wEBlXq7cgyymlqGW0qCPZFRkmQamRNctDOAGphV3LM9X55Ul1VaONKwDoYnBsJyp6yCU02qgoJpKWqZFYR31jJNS0Jgx8zpvcYf9HsOop16pJb7fN77rniO/tkMKTOp7CxKH6AamT8hwdhpR5wThBd1DG31bas7EPe0+qny2Tuc9YLPTLGatubt1G628WRTe8lNkWBICnUixMPFxMiLeYpCYVFJwiSiSWpp2KhBFltM0Q6jWTutHFrPGcXrl5/us+cQRi8V0Mq1DA8mktKqK5x0HR7cCsGAhrVa3yNIKChz4AN9srsExL5CPoR63IyzeQzx0hnzfyxJwZf6Shtu/Dm8T38aHaauAGHuu2A6CzGU+P6e3C85F4RAFW9AErmu76W9mk0Mim9wesJHbM4/ZKyQYXXZgjefswzG9XsSGBOgxtfiZa3a5h4eDghAorjYA3+Z1PvWMkx81PMfoisPSh59oZkX9IzuXyVSiSu1HNwRdeEa4XMR58JRBDK/utXWgY7huoJl3sBq9n3dOlWLgzK3tWxw+zrU/95g/WnNpAgtVQLmXIyhAMT3n7gdT4BVAu56ucXgDi1UhiYe0kcAMhI5xqPkds/XVxW7e4QzmEBp/JB0BQbL7oa/A98j22gcxJoj69Xz6zWaHbCku35Puyby9z+fKS3MS6S/LUqGxuZ3zzXtUPl1Qq7/w3W9sVvR5XKoU++IRKtO8N3HJdg/7N0DdkAjspddQl/BjvSFmQpDt5ZHKKu/J/sGR2kaMRBeJBnmEMh4TPTIowxR8uRs3dolbBIT7QgoZ6b8THUzNQc9DYcHcLnIOX0aJdZm+TXUsvYfBE5oDVZ4hdmlAKCxMDgh9THGfjaSKxv
 qaHO0O94
 Cp0xGKGkWCgcEbUTubhVp5qBIm0ER8MxOIuAV4Fim2gvK3Qru5lYtD0bL1r+kcL3gTFpXbLi+VuthbR+yCbZEHwVpOsOMybaFedUH1LemogUoc9wkVu8MzSPlSGVjSw6C1rixeAIa7yibTnBhWWLVyibmd7XSnPwlXfGiWW1ebzl8J42yPNstF3krtf0lnVstIMwT9CM1TNEsHpCpVHbcUTeFarZF+LDW6CLTyNVice5Gugh8xNMXu1xBILcnbVEhLV5s7wJZTQx/HG6B6OYQzqaamV5fQAY0kv/w
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
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
---
 arch/parisc/Kconfig           | 1 +
 arch/parisc/include/asm/tlb.h | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 47fd9662d8005..62d5a89d5c7bc 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -79,6 +79,7 @@ config PARISC
 	select GENERIC_CLOCKEVENTS
 	select CPU_NO_EFFICIENT_FFS
 	select THREAD_INFO_IN_TASK
+	select MMU_GATHER_RCU_TABLE_FREE
 	select NEED_DMA_MAP_STATE
 	select NEED_SG_DMA_LENGTH
 	select HAVE_ARCH_KGDB
diff --git a/arch/parisc/include/asm/tlb.h b/arch/parisc/include/asm/tlb.h
index 44235f367674d..4501fee0a8fa4 100644
--- a/arch/parisc/include/asm/tlb.h
+++ b/arch/parisc/include/asm/tlb.h
@@ -5,8 +5,8 @@
 #include <asm-generic/tlb.h>
 
 #if CONFIG_PGTABLE_LEVELS == 3
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+#define __pmd_free_tlb(tlb, pmd, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 #endif
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, addr)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif
-- 
2.20.1


