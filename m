Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30457CF2567
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8316B00A3; Wed, 19 Nov 2025 02:32:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858786B00A4; Wed, 19 Nov 2025 02:32:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747C26B00A5; Wed, 19 Nov 2025 02:32:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4426B00A3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:32:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10913C0337
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:32:54 +0000 (UTC)
X-FDA: 84126539868.29.1E6832A
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 61DF0100003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:32:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uyjpuiv9;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqzAgJ4OlgcGBu7aVY4MnPgaTUGUmQkYyYjl0T7Jjfo=;
	b=cnPMIhDZMWtSpcQSI63Mld9wHa36llCi+CIU9mmo9nCRepQQ91XuCko4hx1eoDoZ382ELs
	onUJv+WDGbzV6wzDFXa3Ta0tFRAbANhpf14MKH9zmFrMCmmczFFr+bRAAPc6pyJHgqT+92
	9l5Qegr9T7v4eHoHrsDSojLmIZa296o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uyjpuiv9;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763537572; a=rsa-sha256;
	cv=none;
	b=sbqsJSI635ndGBSf4boPgkLxgxtYj60yjwy+I+QNtj6IgwoTdN2LKnH+5apWoSc7tASebt
	+UChTVoO5itw3ye/z0zDgFG+py3CNJiz31nfVIJDln6MnVrGtMi4f3o4QLOCoTlbFgaKYN
	wOeam+2zIJb2xfhH1Bfz3TLAhbrOiUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763537570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqzAgJ4OlgcGBu7aVY4MnPgaTUGUmQkYyYjl0T7Jjfo=;
	b=uyjpuiv9TBbXB7w5nX9ezg2b/0arYsi+ngniUmEy5/UHQe7UIU+7bW+ZZH6JZOPtCOAwTM
	I2y6i4tBKl8QNLVOSZZcx0mBsB2R/e0ql3nUife45Tqxisf0T9zBpRBX7bZtz84Wv3to6z
	ik4dz5PKJGLLY8Z0cTmGxwsTW0EsQQg=
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
Subject: [PATCH v2 2/7] alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 19 Nov 2025 15:31:19 +0800
Message-ID: <54381c49729449b9c3a09e78a69bf14b4b107774.1763537007.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1763537007.git.zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 61DF0100003
X-Stat-Signature: ytonujkpqu441fmh9i4r4pozbdjqb4cr
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763537572-74905
X-HE-Meta: U2FsdGVkX18ns5Nx23Q1A2tco8zoMT+dlWndEPp/M9TYPdgBWjxAeQHz0L2eTClhsbQauJQbeEPenTEUk9rAVvMIM4AuE1WMPGIflup3ISzCpDTaKazbhOQbi05acKI1rkfI+cuLun5vxzY63aL3bE2iVU+sckG0+U7ynQzQ4hXuwmjlpVJcNeC2en9brRXcllsVaLR6HdsnEn5CF1AAkpVnV9xvcI9o+nQrW12iT9TNu1rC8ICu4D0gTMivz3JOARFX0BhGu7aSRtP1ia+O7fsp91ANpFw3a+zIKsoXdUSm6AVayPGmUYpWrd4And7hnHpPldHznh46LJA1ac6Rv2Rv5YdJAY+Mv4yimV/Y7hPajRNiN6TJARgETWCccS0IBw0VKSJU/Ngy5KeP7/p+xlOPGKvsUhFpLlH4Uh7Y8XVJreJYc1AsNu25lfDwazMQ1YRBcL0aVfoDo7Z3roHeUyZON3zgBpbb92LZeVHaxaI1EuBQkau5gLhiqne2HFOZvLoSx3Jg00jEREjlmCJn4p7WPgSh73rgUBAwmTbJmkwD2JP1fW4KQvhz89Ba/LiDCfVW8wBtpQYBtDdUEnSv+Anh9b7t31hCH/kR2e2ZiphzEL0NM2YfbOVo0CBX7dd7BAD1Q5IhxYb7BxDEOxkWQwxyQkzkCs32MzNOCA9kqbTZPT1zPrNYKS8KdHHL96Z7wq3YjbvJcdjohBa0SzncvphH8jeJn7rseZoZ9j89WQOETeKVsdMKBmi8X5p+f3oBGb9XAvd8nmEUvdnx22lc1KWt/0vKx2wjG7HiB3323dLbMMto6XeCrM2CT5ll3ofICMzEdnfOYD5qVc+Dlb8bS8xeP7JzyKMUlI6MAcNDadOAiplFMiDsSrboTEUGvGVYXaIMKrpqMHaOxHImB4LPJhbBjPu5KZyMXjeI+aWg7oM063NyRGiCDotlfBMOonxySYns38s4daWL3r+j011
 xyqzFDtV
 lIfv6uDm1PnBYFwcyfgLisz84cWstIPRmNgm0CqaZkm3HVyH/LDGIsEMpFqvIy45SAgSJAe62UguVUXH792rHovMbNK619dezhvuLjpM3DXUwLfoe69GivYSG9B73Ib+B6auDpeAFEKcUkBVbBQeWQUvbcjdD7hMTIbCmgLjZapaF8Ag4H94liUKrfRF+3HkG9wFpY6uIlmkIJzvmktX7HHd01OsZtSqEqnWWQ+G2bRm8dLvYKTKv5A7uUC8E5JBBwBaqyYZFoAeMQ7QVsBieu+yxLzihtzQ2TaxsP2pG+OOSaRbkq4R1rBpvzipKiMybgbac
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


