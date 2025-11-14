Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F9DCE7AB9
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7878E0009; Fri, 14 Nov 2025 06:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3780B8E0002; Fri, 14 Nov 2025 06:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266A38E0009; Fri, 14 Nov 2025 06:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1205C8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:13:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A75DB4CCE8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:41 +0000 (UTC)
X-FDA: 84108952242.10.1124601
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id F13C410000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:13:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ahulCYKl;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763118820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEefGr34jCXytLhrSj7xX2XGq0Zan5wY+b22XB//Qmo=;
	b=fKTVz3wAtGtTejJ77upKRszvaqzRgoCn1+l2m6e05LdAcmPmPAry4xf8gRzz7E392FYInH
	2+XHYN+4t2pbmhnEdkoaL0jRcEiLdIVOEAD57HWmhfjzA4HMGFB6URZhskTAqfA04wloHn
	2nBdAkqhgwIiZH2BgNU0brjxWAY3Vgc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763118820; a=rsa-sha256;
	cv=none;
	b=mL/GeUoAucFp4k3AxNJylArUms3K6gaqOTHMgehIlHpP3MxSt5MZu7I1Bsen/jXPWAWrCx
	qOjkn+WYcNICACCnTUCOQxbjNUUOrgMhtQ2Pb8oC3v5sunMb22gLDA8KZL84QzVrdk1Tkr
	mYG+rLwZZQZMp+MrM3GDFoQ0narEGcQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ahulCYKl;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763118818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QEefGr34jCXytLhrSj7xX2XGq0Zan5wY+b22XB//Qmo=;
	b=ahulCYKl1T8/1EigkwF90o/vnGsd/SAoByvuSZpMwweuYRBk2FeVT2gsJ/dzEfCsjfcpLo
	mpzn6A8+HWUhO2EAEW8sql75SXT+7QKV88bnfAPoO9rKIxep+P5dEjCwnXn6+B9LQj02Kb
	jUh7PSOGRzsLU0M33QU2JbDlxuvcAFE=
From: Qi Zheng <qi.zheng@linux.dev>
To: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	dev.jain@arm.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>
Subject: [PATCH 1/7] alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Fri, 14 Nov 2025 19:11:15 +0800
Message-ID: <66cd5b21aecc3281318b66a3a4aae078c4b9d37b.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763117269.git.zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qh9uomn99wfhmeib484q88gx9sbs9zcy
X-Rspam-User: 
X-Rspamd-Queue-Id: F13C410000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1763118819-18964
X-HE-Meta: U2FsdGVkX1+ttyDRnwFEMrB25lGrrjTelXk56zPZ2CGJ78zwwFb08fAGPU/k7Ba6zGicRk/TFEMUEOF8CjNFX8L86JpdctWH4yltqstIfmjjpSSq4o8+FN/PSc1FsPCnQKuJHl2+9M/E2GgcRcenZ8Mo7+AJ/Z2R0A5VNrwZegZhM6UNMSP7Al4s3U7lSAFdAoqYRoag/2xaxTi/7QzHr8+xOXnS4vhmzZx/gTBKHE1P50JNRwvwaK3OCycsU/pXXQzMe3Hn7QZxPSDa70Tmeshyl8X+oJEFej0n4nE79rJ1mgvfHjlRsSIEXWYUmiGIK/Uzu/ZHqH+CNRd7gTBixOJYr3qdfMbpplYgSWrnfr4kqAVGImeHSUh3jTzdco5nnbMO0nUNWMzpR04RyyWfi5BmljeOd+mcVjSv8Dgzjt/sVPVMeq4TSuRl+76TeWmSuDzCYKzSi/er5EHZDhIno3TyYtYTTzKujPhMBvB4o4pjoWahtbEv4z5wl4TBmN61mEi3Gkhn9IhN4F9ZJTNzPQYxvI0bvMnmoiau7LcUL10UfPMXB8Fjl+xLFoF0WQiGldnTMgpAIckVaS8UfFLPUm5d2HkPdPfuuuNcUjIoQuUcKKlbz4f3q5cGW1bK2KIiretppgAMhh5cGGteTqH7aIXAsJYHcH/arKyUvkEjujR1s7FaKHlwBkj6fOVKlydI7VtEUR+2rVyL7qXG9PwRgXXT409TK1CZFuXuBDasIYbkbHR5U1rgJpubmanr12EzRB4ZvmpZUDywLIypbYMSqTKP7FbFO+KhA6Bl8lX9mmVr8TlFFY1fmdDoERp5GLgi3O3Lqa77hoZFigyBNj8hDm/HITqRWEmIkHVcyrE/x5iqxjcYRnvUquJPChcOraujostuibpYuvr9TA4K8wr0FnW1SxNQGNnXtu0khgqN1M2eWmhm0MN2p76xr8DwtP6oDQ374u652tFA2QJu/s1
 5U6SCILr
 yryINhJ7mgWXFpLdx+X4KT3fnsAHSmcy017MzwKJuk2F3VS6zucCOz2XgCotxJoFX2OX5ghzmhgFA4U45j3mwDgkHHbw8ZGhHpkPdcEsBYaiH1B5zMfGl5KlH37kIePbfjCXCe4crmCoZhBBURfDrCjNgfcd2CsTEgxIGG+yP+FO7B9L7SrLmNkZ8/OKFCua/SFaxXUiPl60epVRqgOYaME+weT3rNKvzxEiT4JVPXRpLsi1vkPZpU+R+hizrIYP2v0qACUE7bw5RHiJpvo9F2m5s4INm6+0QpnhemXnjsnSgx2rGSDh7jacdWrupZU7VVz36
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
 arch/alpha/include/asm/tlb.h | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 80367f2cf821c..681ed894d9e72 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -40,6 +40,7 @@ config ALPHA
 	select MMU_GATHER_NO_RANGE
 	select SPARSEMEM_EXTREME if SPARSEMEM
 	select ZONE_DMA
+	select MMU_GATHER_RCU_TABLE_FREE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/alpha/include/asm/tlb.h b/arch/alpha/include/asm/tlb.h
index 4f79e331af5ea..4fe5a901720f0 100644
--- a/arch/alpha/include/asm/tlb.h
+++ b/arch/alpha/include/asm/tlb.h
@@ -4,7 +4,9 @@
 
 #include <asm-generic/tlb.h>
 
-#define __pte_free_tlb(tlb, pte, address)		pte_free((tlb)->mm, pte)
-#define __pmd_free_tlb(tlb, pmd, address)		pmd_free((tlb)->mm, pmd)
- 
+#define __pte_free_tlb(tlb, pte, address)	\
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
+#define __pmd_free_tlb(tlb, pmd, address)	\
+	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
+
 #endif
-- 
2.20.1


