Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2DC8CF2588
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5008A6B0012; Wed, 19 Nov 2025 02:33:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1096B0022; Wed, 19 Nov 2025 02:33:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE096B00AA; Wed, 19 Nov 2025 02:33:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 311F66B0012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:33:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF1F61603AD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:40 +0000 (UTC)
X-FDA: 84126541800.29.89F5F0B
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E23E40003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:33:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LUgmfphZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537619; a=rsa-sha256;
	cv=none;
	b=CQW0uJlHSgUE6kjjkRUq6JEe0X/XupSNxLj3VBDUHRgEashDR3/+XgHVOVKmZe/oXimQoj
	8d2FUCArAkUqvf4cXY8MGjB84gPEAnhGGm+SkI2adpOlStDEilhGzZdwXadTNbDADZUPK7
	gqv8OdfiHVDlAxU76kYk6kvXk6hf+do=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LUgmfphZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/QZPwfh2tBLiGMNDgv3nVc2+27U6V/3aKYz1C9WyO4=;
	b=K4395Il9yOB30m5g75UlZLpb2HfmrkLxtmXXW8zwRJtABRzm+jUw5Eul3obhbxm0uvigRo
	8cug91vG7vtokt6L0V2so1z8nxWK4peGsjHTYh+yjZotiotTjqpetE9rSjfqwOeQJSA8W7
	cd7DbS9apDpBoEpiUBs4e0t48/Yxz4w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763537617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/QZPwfh2tBLiGMNDgv3nVc2+27U6V/3aKYz1C9WyO4=;
	b=LUgmfphZq+fvy8Fvu1tjVnrqGz9k2q8SBhj9h64+wRn+7bojNcXZyqdp6prQqscS2feFX8
	bObNs5syxHC8+5XyV15RIhnayEGuvN50r1EUj1rPlsxFv7tOY7PB78KcZic/oWfkHREL8W
	JIpYE0IsfsnkMqTZu6kB6Akc6TgnRVo=
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
Subject: [PATCH v2 7/7] mm: enable PT_RECLAIM on all 64-bit architectures
Date: Wed, 19 Nov 2025 15:31:24 +0800
Message-ID: <caacf08b765ef00770b7c75afdb5e5754485b2aa.1763537007.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763537007.git.zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E23E40003
X-Stat-Signature: tzg6mcd3j6grc9kbz4p6dsyezad4guna
X-HE-Tag: 1763537619-974881
X-HE-Meta: U2FsdGVkX1/z2nxloSH5L9HqaRH2B+sdp1kmcx9tFtvBFbK8Q56UAHg1nee/oZbNbnk1qnFO1s7f+KxAQODZxABRoQih0XCbDhLP0f1kmIIFCjUgBWMOHQ1pA9C6Ya29R9o2P98Nb1EgYGnee3gnWEg3lLWp6eHHwRfa5zEIbH/Zw2pSsZ4WuxDuV7Zm5K4AFCJaZE4Fm4uw8JWuKoWtFN4ZuTSuRgEg25xqXx+khiXuK1ETiNmfxlbPTeTU1nrSoTGz2XPe/mBJZVxbptbcTMDOcfTc6eSGp2PPY+Dw0huUKRWiRr+yjiuv9gnqxlEKaLrHvPwimyPO2JX6GzxBPa23lFxXvDlUZhAmfQeIF9KSK9UiHDn5B5ITtfxNlFu6lMMkgRCzL4HdiWQynYlHC7pK3r4o4fXEmDaSrpirE911UK6dcHghCoqc8UFWYKGs+bAA8n+fkDG1M7MBmuCHCerFZNTl3/eh13A7hH2eNYAG8YG8L1pbSK35MPT0yXobVt35ZLww/jZyxwiewldrZ5Hrv4N9hEXTD1Ve4/gE+mdobwx8UoRbiL8C513jPq/aUyaW091dftX0C2EarwMiPMfro17A1PXPOjKnL/1XmdeOO2xUPBOZkYXgU0UG5IGvCA/n/vv4OvBvhTSqNFzUJ4DrfLoghqtZbU/yQ8LY3lkVcgOK9N/82vIYU2yVcP7IGh7v1FzYeGOgjujbJsFh0JamMYAhpSxcVVqK8YfhZ5kf6KjdaGgXgTIsBBptui8r1crY/L2JIL2w388/O4lil2/VDlBtSGfnQsuVTGmYg8ctEIykin6RjMcjN9J/+EPUb8spbPzr2JdRdLVIb0UHgZY6gJiO558cbPziS+nGJv0UVIwXi+NTDK6KE6j7GPEPV6w/fYe/nzF5Q4t67Mh+/z0imZ5W0FzAWlak6649/wMcRc58q87xMMamN8i1YSjzuj1O8x7MLnSikYmfNIE
 oidfbpNp
 nsOGR83KMiONZH3uSOJTGuL28P+I+LH/lVgsPn8qBHR2/EWnF+M5t0YztmcItx5JnAGFq417i1oJV9lzw8/hzrTw7/X/0oEliXjXlzs8bVfRrWVjEEyw+nt1oe6Y8P/PwcRdvU2dhYdqK5RoKe6kf2jQO66YjRMx5uSxxa41Nhzxng229S8CjFb6lEORIjbnEnVlWTNfrsF3LoC+D6sfCzl/E23h6e7trye8C7l6Cqd/+LQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Now, the MMU_GATHER_RCU_TABLE_FREE is enabled on all 64-bit architectures,
so make PT_RECLAIM depend on 64BIT, thereby enabling PT_RECLAIM on all
64-bit architectures.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 arch/x86/Kconfig | 1 -
 mm/Kconfig       | 9 ++-------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eac2e86056902..96bff81fd4787 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -330,7 +330,6 @@ config X86
 	select FUNCTION_ALIGNMENT_4B
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
-	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
 	select SCHED_SMT			if SMP
 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
diff --git a/mm/Kconfig b/mm/Kconfig
index d548976d0e0ad..94eec5c0cad96 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1448,14 +1448,9 @@ config ARCH_HAS_USER_SHADOW_STACK
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
+	depends on 64BIT
 	help
 	  Try to reclaim empty user page table pages in paths other than munmap
 	  and exit_mmap path.
-- 
2.20.1


