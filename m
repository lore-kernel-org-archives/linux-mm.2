Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DE3D65529
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323036B0093; Wed, 17 Dec 2025 04:47:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDA26B0095; Wed, 17 Dec 2025 04:47:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D61A6B0096; Wed, 17 Dec 2025 04:47:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5BA6B0093
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:47:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEADD8B6CE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:22 +0000 (UTC)
X-FDA: 84228485124.12.CB75B59
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3B6EA000E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e8o1H7ID;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964841; a=rsa-sha256;
	cv=none;
	b=ybcaYuB3vuib0Li7Ed98MzG0Z+tbhZyW8zKA0uboCkUWTzhpl0kTXo3eg+Bpop7Pl1g+4w
	/HGU0IUV7DSKzBn5K4jMWtMwN44ZCtz1Iub8005ynMS3sNCALnvMO7sC4OgPg1rnNMqHVT
	NqGAGNGMDazPl3/KV9YPgKNnx+QXpCY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e8o1H7ID;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PNYJl+4luznSu7Qs41hn6BnOWw9fSYJ1f3qY5qKkjU=;
	b=pbKxIHDnS/GGKF4GzM6Vi9mFmYqO+gXFycQJtQKillTadX1SdZlCmCVSGAEi66TgnGgnFs
	rpHdj8m3t59Ggl0I5LnT+UuRtCsgLj9vsKd76F++RS7/+hJXBe+Kux9z0O5IdB0TiF8G3C
	0XqTgGnSnJnmAkJI3qqYLgQL0UOu0FQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765964839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PNYJl+4luznSu7Qs41hn6BnOWw9fSYJ1f3qY5qKkjU=;
	b=e8o1H7ID6IwrR/gVd0NtVTo7ZEz4HV3uPypab1CIVzcnpIVs9atrTDUBpW98/QwFghrEEU
	5EBqavpncMavIyi2v23cOld40E9HERpVgTZ7omWcpU1XjKqMpN362CMM8Wv9Hk0+oQtTKQ
	oRI/0dVJv/IYhli7SUrb7JHZnJy6tHc=
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
Subject: [PATCH v3 5/7] parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:46 +0800
Message-ID: <e0445acf2c267f060e888a090cdd94cbf7f52dd3.1765963770.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765963770.git.zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: F3B6EA000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 7u5fztpinczcto64wxzehnmskgn5rptn
X-HE-Tag: 1765964840-696046
X-HE-Meta: U2FsdGVkX18M7ygmOcjVqHyEleKjTaAOrKdC1LAdG9Np5zFh9fRWEVMikhGXFPoVqs4Sg8218SlMjhTaV9DtXs4SHm8635kt/IZkmjpN2EoEB7doW983FxV00IdVOQX4UqqRJP/eBDQA8mq9E3qp+4Tq26mwwhyv9zODadvt2UZ+9FFSYaywXiHAVr92llQWdp+R0dO1iIobGUV4enPpWf1cptm7WR1zX+gFPfp0jJyPaRxHYDusy3ZItajR803FCYqoSP6NMgbQHcAvgailNoQqEFuCDO581uU4tL/GyXevckSmwe3097RpoDdOrX7/IoFiwgqdLZTEB0NVlOgyfeS8kfr3NLNB6mqpXEc0KrCEiVXcYYLiLXJ3Q01N136etF5ygl1+ZdklSP0Ij8jOS+Tp+VKYGsaYam++07XMNgbJMrz8DOk6EpYDNW8LEJLeu8SdEvmKyE84ZvDpy/HEdj4AjmiBApf39YgX6TyrXoaCfqQnt3vosRTpTAhsV+FVQVKAH3VjSixmf2ybxJXwyvKse8/jtYMNuCVkxaFiwEeR0Ykc8jCdZko1MxLn2m+qp2eFVL+Hf+Jb5fw/eNFS1R2NYC9q9XKX5R/Z/4pFOYX2+iJGxxCEiYARevDoFlAhYE2TttlAV0iaGVq3VcY1sPU9R1b6XKfg15p0ssSYoTJEg7t9vWLiVs7XVftHWYKz/xno+tuYlIPKhkccQjC3QuUMAc09Zp+XU39W+na9UMByxNw/SwjpcY2NALaoZpIyYPPhVWMoZA0FA0tM/u6E29xPEE5U4t9PXz7ZLJddAY8TtoqfUr/Klpv58sPFUMOO5fMYLlIMP90I7KD+uEC4b8by8qIBhlpuquRbL9ItTcyjHx6KEl4/u1nbBir3UwDpDwKmSxBrGznAe/bRtXan7k7QHzjnb3HjOgCw4JkKHWoc4lKRPUKy2Uf0LkRu/fvibYNeS1xd/tunFNsWsaV
 hZNhXFZX
 TG1/TDhOpTkG1jBo84/qO8np1/Vd0/gHuJaqptIl4sU/k6lcT8MNxUsYK6eZ/4uLuKIiJoz9T6cCQHPIRu2hqgrpxteRXWdU2sazim0lb/7gvgE4fP0jJ9MEgdVYfoCMhrZRW2+sK4heb1WwhThfyZof/GfQnLLU/ieYkzdZbQjng5PIyWxUPGTYrqyhDn0HcA9yYkXuVZ8MarmdvSIx2yWA87COjiyXAl3RLL2y583K88WRqzLgy9q6FwnBuLtQs1wNP2z7ZMisBrNdTuvMyMXimrARG2Kz5UZbv5XRnrIJg7O8=
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


