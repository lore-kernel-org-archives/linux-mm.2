Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E7FD2F000
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA476B008A; Tue, 27 Jan 2026 07:16:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E526B008C; Tue, 27 Jan 2026 07:16:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1726B0092; Tue, 27 Jan 2026 07:16:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9C416B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:16:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 58FB51A0B75
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:24 +0000 (UTC)
X-FDA: 84377641488.08.71732FC
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id AD940140013
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eTvSU3ZC;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqzAgJ4OlgcGBu7aVY4MnPgaTUGUmQkYyYjl0T7Jjfo=;
	b=Gmcea7DxZdqDSlB2MS7j2A6QK3Bl1xaTSH9XdymrqybxfOUAXNsstFai9ZytnGOJbO9AGS
	W0isOOmpdFNaaJF/Y5y6j5ogUivfCRKDZgiUalKnt7lACDZ89CR0dfDZcJtvqVR1e6dMc5
	2bk/e9VKHCRbfzpmtKQ/2hOkyqe1SxY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eTvSU3ZC;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516182; a=rsa-sha256;
	cv=none;
	b=vmHMM3LSlgo0bHvt2mQyOAR6J4ZiJ802pR7bpdTiHzEKcEpUBV67Y7BOH3CM5dalbnXB1R
	7DNsdwT5hqLnxrVOkqrsJCGXmPadtutbvwDYti4KwEEackmw5JDsHoVYmsajVCt/j6J96t
	PNmUTKK7RPuFsfxjf3FNKaw1qZiaPF8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqzAgJ4OlgcGBu7aVY4MnPgaTUGUmQkYyYjl0T7Jjfo=;
	b=eTvSU3ZCpnyKbhQnuvuO2jr6hynLePtUm7AFB1uPj+vAJuTy9oTT2MVhYeJqwJohWAIjgB
	dugNI+BBRhHolFR11/lct21SCQbz4v6oxO18CXjq56Rn7h5liJp+VIMbmFDxZ6gUEE54yO
	8pDwFthpkMeWcWpvHLph/yKF79EaL1M=
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
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>
Subject: [PATCH v4 2/8] alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:12:55 +0800
Message-ID: <3380f40a89b73c488202c85f9a8abf99fb08543b.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD940140013
X-Stat-Signature: 8qnub4uqmioc5uhrse665ae4ybyiyyg7
X-Rspam-User: 
X-HE-Tag: 1769516182-127800
X-HE-Meta: U2FsdGVkX18MVSV6RE13ep6XR5vVRU566AzlsE+899kbii/eFTYCAeKFxOVDTaB4jJXlYUb4TYF3pLJo2Rq+3PnR9Avw08Qjl26U668wxVGLMrSyDIxdL/nKLuPHD4UzaFj1HtMImrp1NpJsfRn/4p6vfhZqc/xq+Y99y8ddFS/gtFfvX0sVgpKy9himsuc7gKr7dMa27cDUa6EcDjnU4bfePu64IoOh6O+pNUnJTqxfIymPxRyA1uKGiCVhPHNHrnB1k22xFVoPEnBqSdgg+yBM0lvuLeWBhUfWasW4YrU7X8UNvrKSsaaHf8d4UYIAoodNr3oiNHvJ5HO1EwLF6yxcB26bdxm+lsbT5+uYjJ0BjSKZip3Q9quSqYhITIgYiOw0pY3w+eR1+piFQvFVhs42EKY2kDR50eeIMOXTvGtAvGp3yzCsqiXDcU+/GTR2DIaP4k5N6/bBNqNBGijTS7HVHR83OPt1Bmr2nEZs0MOYjmkCVYj4NimGTdPzBVy/RkEaoT7JYVNvj5CXApFo1LEhLwap5/w1qTDCkpTc8o1vJmWGfhymGK+dD6SYOgSRl1GXLnw8bOx4NJqk2ZfMZK7Yq10TUU0oVE4i7dv5uGMHihkj/nWsusnqR9HRtU3ZmTvbI0tC61iTKQgwAZqDr03LUjqaY+LR94j2y0x+Gv/cClWBzRjSy2CnrnQot7cb9viNS+l06hAi9ICDf7suxGZH0ydF+3AnHSKf5T5EO9b+kEyF6FKpERYdGCndmvT/rYjvf96LkezE0lFZ3MZ9J/yLBWv9Xe86lhU6cORti2R7MGuIr/OCzVXuemBSiOJMYX6hNc7nO1HpizPbxqQrghwRb1B/kdY+5Ak13kV1ggC2wTb9/vvyOzz/65FwgoXrTQgKkOUL5fROTmyUkQ/gU2xqjR2TPJ8h4G0Dw6Zu+IJ3njempWF/zWh4Up4QuyONVmB2BoB82Z2LAI7/4u9
 5PAZ7Ucd
 DkP61bCkSsxvVZ58p9DhH1gD5p31v+3HT4jGjmZp3EiMMkBC8P/dC8iUwNPMeG/Dl6rdMMLfjj7amQL06in5Tw4cg4ivPoO95T2prOUlsYx5z9F/rQz2WicZ9nUwjPCwKJYGlkJfa5s05Se+pUJBSXA9M/RPAZ8X0sVYJCED6/CRFonTR+MxPQ0AyGtTAICfaZ0rMyfOiM5RYf3RTgsel2DSzD5bGzPjKC6M2WdOk9AP0WsZtrpUKb/trcuA4VBYn8vXQySLKPExGUyrjHUwOk8t4g6gkMIJX6IytPNj2L5b/btrPcd/FqbgogrPPe1gWG2nlwOV4/lqNDiOzm5efN1eWTrnnJN9M1Lx0Y+lPUmnSjlCWvOmvcUwplSOvn4az64ZE
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
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/Kconfig           | 1 +
 arch/alpha/include/asm/tlb.h | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 80367f2cf821c..6c7dbf0adad62 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -38,6 +38,7 @@ config ALPHA
 	select OLD_SIGSUSPEND
 	select CPU_NO_EFFICIENT_FFS if !ALPHA_EV67
 	select MMU_GATHER_NO_RANGE
+	select MMU_GATHER_RCU_TABLE_FREE
 	select SPARSEMEM_EXTREME if SPARSEMEM
 	select ZONE_DMA
 	help
diff --git a/arch/alpha/include/asm/tlb.h b/arch/alpha/include/asm/tlb.h
index 4f79e331af5ea..ad586b898fd6b 100644
--- a/arch/alpha/include/asm/tlb.h
+++ b/arch/alpha/include/asm/tlb.h
@@ -4,7 +4,7 @@
 
 #include <asm-generic/tlb.h>
 
-#define __pte_free_tlb(tlb, pte, address)		pte_free((tlb)->mm, pte)
-#define __pmd_free_tlb(tlb, pmd, address)		pmd_free((tlb)->mm, pmd)
- 
+#define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
+#define __pmd_free_tlb(tlb, pmd, address)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
+
 #endif
-- 
2.20.1


