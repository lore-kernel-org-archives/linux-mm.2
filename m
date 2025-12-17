Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC90BD65526
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391306B008A; Wed, 17 Dec 2025 04:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B316B008C; Wed, 17 Dec 2025 04:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F186B0092; Wed, 17 Dec 2025 04:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1932F6B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:47:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6026BBF10
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:07 +0000 (UTC)
X-FDA: 84228484494.13.0206EDF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 72900A0006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jh2KGANA;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqzAgJ4OlgcGBu7aVY4MnPgaTUGUmQkYyYjl0T7Jjfo=;
	b=u1UYm+A6Cfv3tSqra+o+dAHITSiQqWreZhHhiuDqrF6kiA7Ca/b/q/58HnBo0HNo6OY+h5
	E1dfPspP2BioYTjC7lurI+k4AvH+Stt5hQkwBnunS707qJIC5n2qYwpodbgtO5P/vhByma
	KMhG7OutwX6gekrmtevd3Ea0yEbmRRw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jh2KGANA;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964824; a=rsa-sha256;
	cv=none;
	b=0dLIL9tc8JurdS3/vL1agU8P1NcDP1bmfLLWovdd9f7DFdK+vov5ZLPBC7TnqOUhMpC3ul
	hpSdod3c7TrYyHsWfWiHgmSwYpYJmSAYT1bJltnmxrux88wXVs/wp0Kxzao3NxrqiiMeJc
	ohY5cC3PRsMB8qSeV2iAxD3EpBzi85A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765964822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqzAgJ4OlgcGBu7aVY4MnPgaTUGUmQkYyYjl0T7Jjfo=;
	b=jh2KGANAcZFZ/Soyhd/A84RQMbBaBHVyKCxUF5JCM+7cx9Rnhf/tMQ9P6HVN/+QKFGILZp
	BLjt6g/DwkO9AsGY0t54potwgCcFvvmS0tsSHhK+hfb0CuuOfNRuGIBOXhCfCHIj04JF9d
	IqY0V30iUlnAoa7IdoieTfgaHfQtGcM=
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
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>
Subject: [PATCH v3 2/7] alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:43 +0800
Message-ID: <3018b189364a57a76fc70dcb477aa5f0da045b05.1765963770.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765963770.git.zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: 4gq96aorcey65d1ohbftuxng5n9dxc3p
X-Rspam-User: 
X-Rspamd-Queue-Id: 72900A0006
X-HE-Tag: 1765964824-783857
X-HE-Meta: U2FsdGVkX18H5XgSJscBwgwguZdBqq8phc+tDTJ+eI6GyEovEDyEVfoQUjj1tz7nrYrIisYMGW3ReJhyZ6FbjstaPwE6R4MX0OSG602pDIYLdsC7o8nyS5Njh6xu9fVyaZsfZlkZzGh2Mm3iQAflsssmVwFloQQB5KJktwaw05XHZF0rKmvTp1AQrqCXsndYXNnseCKfcHKSPH9s3UEmfatybFc0SOcNu8XzpD58e2C/X6PruQ3A2MG3ZlLGgySzD3+osE1jjP7/Zj0Pn3EataVG79C+IebMMXLmvsV9SLPkrEo21kyP74rtxCGdLcwohKkpRmhWNndQLGSVSpTXNNvB29qCgnJ575qM+SWtPy8mMqjxrXQdCdr4e6aoMJjXE8XnitqBG9lV14eLbWocoCPAy+kDTxr3DoX5bKlxxXjMZXx1mnL4s1oX5EarQW821ppwF6R1JjEh7cdjv8wIUJT0sxqjpiHIXbcjawtkYP5GbA7glmb/GaBKrbUC5CxIBVmmRsjOs4NSsvmltWRUlPRyCHd7WrtkstgFnz+WRK9yA3CVZ3q8wH0znSqk3slOlo4AV4PFKsslovbiz6ESMdvutevZoGDTJ9NvJHhfhmiRuJVgwUYhxjGy8a512nv0dtOgd5HnRDvifNFa/fZ0mRGu6SWDOqR13+m6om21otgsOqlXCKoyfzkDd0y1HJRGkfsUKs2EsYW/+Fjtc8nffuJdkk10HU2nw++Nprcxe2tk/MIVOnxjY8VZH90kErpBu3rmwx3T3F2S6VVvLfE1RyMfaLgoEDg2xVjlPebyTjMMC0dPrDAMwajDD02j5ZVKTRDT9c/1UIudkEBYPs4hMJMGe7ozPeq/gMDEzI2BLKH1CysEE60UG/xCnnAyBk+HSWfddwpam2uuFAAvOYHGo3gDAtdFWchRqSkmNfhfWiSmHUQKnB3BLt9pJKgHjvMO1WnMtNah+zJ8GvHIArd
 NF2uLvTB
 N01U2sTlArYaXt8ts8h/rYyvwhFZX6KcAbp6H2cVqjsj+sfUo0QpahX/K+kQTZH8s22q6ROvQTTlb1w+JpJiRZoP3dwTJA76FQBuidXkTkDPz5dSYauc9vvHhaHXwNs9vXraXRI9vLYEX8i7KiddRsTHuZf6fMmyULHlEND8vs0nTq0OgKOmytdjZLRZyJ6xLmTa/pXXNRcWVIi/KQYN5krx3MpR3d6lkbHAztPKDatbUGT+QRDAZhz/KYbmwAbuBuvfFy6PO/ETfDvANUOC6+TS6ZPWDrmX4lj2VTZtqOKBr6lG2DA27Hv8ADBPRPMRGFG3D
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


