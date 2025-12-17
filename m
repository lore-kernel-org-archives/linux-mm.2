Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE16D65529
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6AAD6B0098; Wed, 17 Dec 2025 04:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14CF6B0099; Wed, 17 Dec 2025 04:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D493E6B009B; Wed, 17 Dec 2025 04:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BFF2D6B0098
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:47:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 929876094A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:32 +0000 (UTC)
X-FDA: 84228485544.03.36742FB
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id CC2B2C000B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:47:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pyc1KpvA;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765964851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yDfSie6tI+R/bkHsg8f30F7brlmJ878+dqsdcToXoQ=;
	b=MzGpBx9THA9qmoec6Z30SRWM/3L8La9Y+QN0Xk6PZ6nuOVFVemWcC1oOa3hseoMuCeGyJK
	m8AUvFYjN9FNi3gnzyZbm7zqhIb4KHBFVdwSLVLaErwLJWRNRV6f/bPC2FhU0M2GT1h0dc
	7VT64SxffT80i40EUA9v44tDWDU2EU8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pyc1KpvA;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765964851; a=rsa-sha256;
	cv=none;
	b=1ksKKmvuQX0Roy0yQEP1e42j/r9TfgkID01LTXJpM62TSzEv0az9esWamF3HK2Ky0//d5A
	Qi5Ee5aroMFicuHRtCoVp39Seusd+Zw2uTHtNBkaLC/fVDAtRTnoYQBA7XNlfDIKO/pfB1
	Fls14VBKst2J6CxQzAWu+MyJDaLsXwQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765964849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6yDfSie6tI+R/bkHsg8f30F7brlmJ878+dqsdcToXoQ=;
	b=Pyc1KpvAxk811HYK04xjZpyTzpEkJYxqqJmPoGGAQiXIyGUCHOz7UnqXrw4Idz7ei3/Hvn
	nKx4SWPSfqUG4f91J+BuNBSg1KCzxG0cBAC6q78EOJ3y5AH8vsj9RdwGKsDwh1k/3OGPBu
	+BEuL1tluj818rz3TGgaraPxgsFz7Rk=
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
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 7/7] mm: make PT_RECLAIM depends on MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:48 +0800
Message-ID: <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765963770.git.zhengqi.arch@bytedance.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC2B2C000B
X-Stat-Signature: j4j6ucrseftwzq6igpt9whezmke3nhdm
X-HE-Tag: 1765964850-409303
X-HE-Meta: U2FsdGVkX1/Fb/+BS8MqypHG/OEVVb4HCfC0oyOMChVAEPqBy/T7oOMrVIdWnVeL9QrsjFOmCytHl4mkZ42wCmn5nk9xQVdob3JyNPTyo3jJvjzG3nfAYlbAcFHHDrpTzKmFPoDlEaSOa91cyNaGqL+WADdzi7UPJggGQP5RMe0qcwFRTculkwuIEu/8qKH4VRahxCdMkAwVf0RlPnk7qEiGSPyxG81Xesv64kWH1mix0Wh7oOpuwmItAt2jEaCxF5+snM0i4XyHdoTSNd6ehT2HAolQntMcuFVUf1FurgfDyI0AzpUhfvUmcWulbNd6t56frrQmnU2zczJMbrUXuCzpqu/0fur+5Rw6KMlmTljqOjW+OBPYCDyTtgeObTljOOg5sUIbSc6CP4mdBhbV9mEL/A6tmP+JQ8HmyuvvnKX1dwhj0YfN4mXHXUdgm8X0VbsuTtOMAgZvJZlfg+LtjuPRdaurAvJC0++FWdZ8Kdus2oknHguV8/gm9POFWIWJU8Mj+2uXQS3xgrtfYilDgY8FQM0GXQDqK9rkTjFdSeOoFfoGZ8OWorolxYp354cMBdxHCY1P31ixiYHL57Lkju5Ao1fc0y56ejWyCkJfHGJGVMDnBx3GSne5AwgpZDmML8n1FtJEF0Gi+8opMV7Kc/44aGC/v7GgDyrCrtYddTDsadEc/PTU5KY5sCIs/e8tUAzrPuHdJbkrkjXjzFgKZu+BnRw5nQFRvT97KLHG/BG+PFmICX78nW9PmIOrFiBFHbG9CayPBkHFqDQOeNe6w25nAff1KY26Q53lOVOaiKGTRHPbPHIJ92KOXTzit/adzDqcDyN1TGLvyxHIIjqxwNh51uRaoTd4QiFnhCNVYCJBxVcMuwSWuth/rGzfQDBfkyZPP9r7t0Mg+kjbcr3sOh2kmea6eNcycZoZCHI67swrMhPOeHRgV67bQBQ6+o7apPgb7fDC+/ed78l0qKB
 i9VLBtZ0
 rHUEtELw0zCYIc8EwKLkjKsGclxVZfMXKl26QD/nAs3QBOlC6LmJRa1wyf6NuU65WejASEQjf3Jg+iPhVPomD8WG+h1EZatveohMwm5NqopokqdldnV1xzG/knoo7K6qk3h109upu/yiA0ImIZbTHLRR4Vaf3RZdY+2RP8Oiuqejs20mrw+aI8MNBILDX4U5UJxjPZersh4X6r+IQ4Cb6nwvM0eE1V/glqAdMtKWGYCdvzfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The PT_RECLAIM can work on all architectures that support
MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
MMU_GATHER_RCU_TABLE_FREE.

BTW, change PT_RECLAIM to be enabled by default, since nobody should want
to turn it off.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 arch/x86/Kconfig | 1 -
 mm/Kconfig       | 9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80527299f859a..0d22da56a71b0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -331,7 +331,6 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
-	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
 	select SCHED_SMT			if SMP
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
diff --git a/mm/Kconfig b/mm/Kconfig
index bd0ea5454af82..fc00b429b7129 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
 	  The architecture has hardware support for userspace shadow call
           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
-config ARCH_SUPPORTS_PT_RECLAIM
-	def_bool n
-
 config PT_RECLAIM
-	bool "reclaim empty user page table pages"
-	default y
-	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
-	select MMU_GATHER_RCU_TABLE_FREE
+	def_bool y
+	depends on MMU_GATHER_RCU_TABLE_FREE
 	help
 	  Try to reclaim empty user page table pages in paths other than munmap
 	  and exit_mmap path.
-- 
2.20.1


