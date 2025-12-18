Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF87D68BDA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 10:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04116B0088; Thu, 18 Dec 2025 05:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87576B0089; Thu, 18 Dec 2025 05:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93436B008A; Thu, 18 Dec 2025 05:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB19A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:05:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77405137646
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:05:55 +0000 (UTC)
X-FDA: 84232160670.21.6F0B5BF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id C4E1C180010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:05:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766052353; a=rsa-sha256;
	cv=none;
	b=eEtIg8PrNFBsosQ+gmocdWzvrNlJXOc12XbXAmnfkxLtma9tTSfi7NOo07l+377zTeZz/y
	rXh+k5x2wwHO6ap6JE8cX/Z+zUUf5FIRzAGfFM4H3I8vEp9CufWhfyEfpjDVkunZY1Tj3E
	dICkBT5gMDq8OxL2y96aYWEhjJ99S68=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766052353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DVsEO/Uncox4v0PKEPTB80dS43kMoZw/5eQhs0Kuy0=;
	b=tRlPTfHyf3VjwC4CxGK8F+4G+pJKYdQ5c45GiEQgtJlADWLkKagtUs3JtHmCyreqdINAvo
	bcIHJjkbruZbT8HJyOUSJ/JnPSX0R5C2buh2Bk/dtxqE3Sv14LwiavxsMdRe3/HwmVNzeI
	LRcIj3qTezg9hEWHU53MuqbpC9oK6sQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D982339;
	Thu, 18 Dec 2025 02:05:45 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B72E3F73F;
	Thu, 18 Dec 2025 02:05:51 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kevin Brodsky <kevin.brodsky@arm.com>
Subject: [PATCH] sparc/mm: export symbols for lazy_mmu_mode KUnit tests
Date: Thu, 18 Dec 2025 10:05:40 +0000
Message-ID: <20251218100541.2667405-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
References: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C4E1C180010
X-Stat-Signature: b6erwacyrkuaxbxkzo85wp1uhhqkzqji
X-Rspam-User: 
X-HE-Tag: 1766052353-87633
X-HE-Meta: U2FsdGVkX18vnjPxkv3C6WN2lRQapqKDZWs85pUX0Hk+jApKvfCogwHWoX/iZ7jmp0+79vols7FMLvTjZt3mOj29KN1ooJeiNNRHDSCJTfjBsm9tiHMK+nRDwCXe9+Sa6ALAcRv4n0gc3wk56F9bq4KsZsujW0qwP6DaKRnu6rTRrgEylkXtpzIDRd3/lUEShA6F3D7jH7vnLaGGjtI/uXXTV7lln35lgT+Wqh0f3Tz12Ygku9MGmom4Ulox87rQT844Xm1Ou+mc5NgVeZFiQo7rCVda10ATURtS8GYsRlA1eR7k5ZwbkxvU9jGnr/iR7ZdEN1c8BK02W7xp7Yv6P/QYMPLwNaJtu5XS33TBNoZsd1P0d2du5mojlM/S/CtKI6rquaRMIIHjPtrdkL4qgf4BY/cZHGO6z4AnLj7Zkuzv7IP8xv7pRaLBsxlQWfm24BV6xQBXF8i3ZKm9WT98lES6UbI2kDJTjmQJi0TOkS9flw0HliSkEa5edsI6ZDQ6+GTMcMIHrpym3sjEwEwgmaZKS5wTNBPoqN2NjMcXBtw2sQsckDIoNiAnVcKG/1LYoZ4ybyYHL7EWDIri333/j3+lzy3WvNkTvmL0Ls4OE+5Uv4Nusp3jKZYxnm4X8YvcRnMdpgcvLJFchNA9f3dmNMYC8zVv1KokzklNzukwiGSJeahJWsniSi61EhTu+siqW9/NLX5OzOtBtbkWhewGrjt1YjP06u2MkwB7EVJwF00aKc2cQfPG8fbFg9UkY5AoyO6jxnLL+F4uUId2DjtC3vb9BXuqDG2Z2pOrV1STedes45ZQ41yk36Ppgh4PB5TDbFoDnHsfXTSksFY4f7zvU2foNvdT2pG/E09SHJrDrrJT+TX6hKVW6ro/u2T2Uguw8dU53mtJf91AxuElMWYidT8YrJYDbpN8BLB4Ih9vEODmEajpqd/6UUkwcI2ZlD5p7JY2B3d+7LMf+yqtAij
 vM2Vkhly
 Mjdv/xONp3+jBQKDMExR79MEX6bG4rSzZYRTQl5zxQYPLE+gRKU3bFfjw43hQS1KFIHTou10BpwAP2ytt7fkfobCaeJK/y6GMHrgVHHTrplqHkgdSQrcFouaaG3CfTReGM3HflZe92F8UFFcB3EL1YpgrdI8V08tRcAGII59YtlM+cn1PSPBYClTFfx62u8KwWpKwIdomhQUw365aAXRwUErTSRkqPy1WV3mOFN3htQXRLvHarDkcUDYeN9Q6TXm98bo3nufaHy1tN9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming KUnit tests will call lazy_mmu_mode_{enable,disable}.
These tests may be built as a module, and because of inlining this
means that arch_{enter,flush,leave}_lazy_mmu_mode need to be
exported.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---

The CI reports that sparc needs pretty much the same time treatment as
powerpc... Here's another patch to take care of that.

Andrew, could you please add it after the powerpc one? At this point it's
probably best to remove the comment above MODULE_IMPORT_NS() in
mm/tests/lazy_mmu_mode_kunit.c. Thank you and sorry for the noise!
---
 arch/sparc/mm/tlb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 3a852071d260..6d9dd5eb1328 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -11,6 +11,8 @@
 #include <linux/preempt.h>
 #include <linux/pagemap.h>
 
+#include <kunit/visibility.h>
+
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -54,6 +56,8 @@ void arch_enter_lazy_mmu_mode(void)
 {
 	preempt_disable();
 }
+/* For lazy_mmu_mode KUnit tests */
+EXPORT_SYMBOL_IF_KUNIT(arch_enter_lazy_mmu_mode);
 
 void arch_flush_lazy_mmu_mode(void)
 {
@@ -62,12 +66,14 @@ void arch_flush_lazy_mmu_mode(void)
 	if (tb->tlb_nr)
 		flush_tlb_pending();
 }
+EXPORT_SYMBOL_IF_KUNIT(arch_flush_lazy_mmu_mode);
 
 void arch_leave_lazy_mmu_mode(void)
 {
 	arch_flush_lazy_mmu_mode();
 	preempt_enable();
 }
+EXPORT_SYMBOL_IF_KUNIT(arch_leave_lazy_mmu_mode);
 
 static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
 			      bool exec, unsigned int hugepage_shift)

base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.2


