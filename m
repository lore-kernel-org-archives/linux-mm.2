Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A3F7F44850
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939796B00A7; Fri, 10 Apr 2026 08:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA606B00A8; Fri, 10 Apr 2026 08:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7645D6B00A9; Fri, 10 Apr 2026 08:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60C906B00A7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 029341B812B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:17 +0000 (UTC)
X-FDA: 84642551196.30.F7E8CAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 43A48A0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pacXAmHL;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=P2IEyAEzLrLcDKf1D+hPXmSP/5CZZgHCZVdt+e9rGY8=;
	b=53meOVpVMN1dk7nf6PNnFLMSAYgs4l8pbUdiUwRNb8PogYJI/nfzRrvbiZNa/fxEjE/yAN
	tClAUijCHv+6kdxc3hqzCHmpiCLdkLLlFKHB8oiJBsA3CYV4ROOMFVn89FmWRi1THK4I7o
	ag9VW2+iyZIyTzkZjLTcqOqmT8NcKZg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pacXAmHL;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823556; a=rsa-sha256;
	cv=none;
	b=EPH4veqqMeYzfboXaHGq2ymbJIheW34eaVj3EzLRfGu8WMmPNns4gKclAwLu9IQwMPHo4k
	FE4UXitwN3m3X1znLZmiJm9C+h86OykBTb3692hx5cyP/J6wdhH04PWx7GHwPSumLPhUZQ
	S3rTJB83WUPCOUD/uE3/ugbeFHffn5k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65ACF44037;
	Fri, 10 Apr 2026 12:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE3EC2BC87;
	Fri, 10 Apr 2026 12:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823555;
	bh=qtG4jYoFMBUH8Rv5LkkLsBrvbBwuDbTX1269QfkLCzw=;
	h=Date:From:To:Cc:Subject:References:From;
	b=pacXAmHLAMseTev4RAQUAZDfRzJFeJXjwMW3x14w8vUm7ybikBbtslQQu96s/8Sq0
	 a3pcIexn/gzfbwI2qYLuXSTx/gSXbmVwhuUFKfTY31pSFVH71nhoebkIPAnwJfmArK
	 tPmJiCD8oWRaoY6EByg0L3DGpV75oKKW/C5lmUUCoaSznEsjUHpS9yyQByZ5hUlH3x
	 P8NYw39byMTR2ebfPveTfvTFbDgwqYFvegEj7/kJQbjlvVeppRrN8YtOduabfxNT6E
	 Yw4oV6JDjGSLEpWghPJGJFmnCci2PXJh9wjpVWvhGUbODkplfUDbeuEJIVIN1zibiF
	 mC2OEaJT1jHhg==
Date: Fri, 10 Apr 2026 14:19:12 +0200
Message-ID: <20260410120318.187521447@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Arnd Bergmann <arnd@arndb.de>,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 09/38] iommu/vt-d: Use sched_clock() instead of get_cycles()
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 43A48A0005
X-Stat-Signature: hdhynbpdgmw91aphu7zqdzobcza4aomp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775823556-915951
X-HE-Meta: U2FsdGVkX19dXPE1hKQQXre0LzDMuJXMpyQQDhNAlj81J61/NtLPBp4fLcmPPjgZssJbf3R5nhabXr9VQtPjdsR13SwMsIS7mCaPCkXCjXq2YOGvv5xi3FhczUsQBN4kzvD64xOARhynTmi3LZW41vg/1qBeC0FXAqVYKYH9xdzFJPpGbe6XkGQTBLa4Ac/Ir3p8rpUOnOuu8K4wmWAqgF5mfi8ShXxBGcOqc1ojCrSS8dDAgWMtbWfJRxMgv/rahrGoFie+RDlV5n0r6lOYN56iiowKUKsCgPtKVqeGhPfa5IzQi854YQxApQldTZZhGr4/+wUP90ngsqg+N2iXT8cmeaOOZIrNlUvHlnOpOSU0jdRpdFB6FGxMBbRRK4LlnADsQzVPF3zAZV0iuA4uCClUSE0dRZ0OqdMPRaCbr+9DJAv3lXxMbEdJ8Pvt1GurqBSGbKVlxJ5KZuJMPgaWn9asxxkZstNfZhMWi7LaYpriJm/M2dbW5+nl0YmiieRWiX71+9JhdVFVWq6EVdx76t9BicenIwi0/vu43jsubB/EzY6UrIlofoBEsL54sDeH8lM7WuaA6t6fI2VCEhv0EyTukv1ptR3pAdBMN4GiTBZU9AKAvD066f9xA59p1K08icTjwE+wk9Gj021lt3eebI+Ilm/f5VOix/QS2rVKX8ZvAkGbUHaNjApPuXXCtXtKKXBjcZwoL+I6dS84qN9B4an+HVXr57pK6v4NchDDgcCW7iwfMcHXTa6XbInWlMC+k5PkdKjXGXhQXk1fjY+I+/AeCODtW/UTUsw6vWDWjmWMQGB0vmPTLDDvPwIBLPzoYF6wlkyuCzHL2VLghveZtGeatHModNSQ++Pa3WgCSwu2w5O1put1GNNfaxccMe+NKIr6TEEn2GdP8RNtL9RQ6mIMDp2r3Y08IM3CfGzG8dBNHJ6lM5WbVoSagTUQlrTfqW9/o/YlQEc+edqiw6O
 1xprEqkn
 zPMquHzneSa7XiD9YwuPZSj5GtgzZVoOlQY+IwbNPpkwR3t5L51fqqz7dtFBePVwk1aNnzntSoPgsN+LbIcFRnJi8FgtIkvW3JKCRJtud3Yj7wiTo7Iqtz3DMVz9luLG/snaZMbPn8nrosV8HjZx1qI+HhpY/zAeNpYlpuc1bgjvi67e9ynkjMvsP8+unekGz90d41iAEROqQYztOwHxsabGPKO+QEF1WPYAuNp4W1k58up/jhYdhha4jqdVMHiVq/R7DfoZhHY29kafH4TBdeL+A6EhArmPs3oZ8n9wuRyX0MIieq/gVfAwvDj59rmsLCZ8AdxzFnfi/kJFzrA7konAIMglVXezlfY2Fq8LOHfcpjBU9DtQrbbCeuxdRLb1NtSP5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calculating the timeout from get_cycles() is a historical leftover without
any functional requirement.

Use ktime_get() instead.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: x86@kernel.org
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: iommu@lists.linux.dev
---
 arch/x86/include/asm/iommu.h |    3 ---
 drivers/iommu/intel/dmar.c   |    4 ++--
 drivers/iommu/intel/iommu.h  |    8 ++++++--
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -18,9 +18,6 @@ extern bool x86_swiotlb_enable;
 #define x86_swiotlb_enable false
 #endif
 
-/* 10 seconds */
-#define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
-
 static inline int __init
 arch_rmrr_sanity_check(struct acpi_dmar_reserved_memory *rmrr)
 {
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1606,9 +1606,9 @@ void qi_flush_pasid_cache(struct intel_i
  */
 void dmar_disable_qi(struct intel_iommu *iommu)
 {
+	ktime_t start_time = ktime_get();
 	unsigned long flags;
 	u32 sts;
-	cycles_t start_time = get_cycles();
 
 	if (!ecap_qis(iommu->ecap))
 		return;
@@ -1624,7 +1624,7 @@ void dmar_disable_qi(struct intel_iommu
 	 */
 	while ((readl(iommu->reg + DMAR_IQT_REG) !=
 		readl(iommu->reg + DMAR_IQH_REG)) &&
-		(DMAR_OPERATION_TIMEOUT > (get_cycles() - start_time)))
+	       (DMAR_OPERATION_TIMEOUT > (ktime_get() - start_time)))
 		cpu_relax();
 
 	iommu->gcmd &= ~DMA_GCMD_QIE;
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -23,6 +23,7 @@
 #include <linux/xarray.h>
 #include <linux/perf_event.h>
 #include <linux/pci.h>
+#include <linux/timekeeping.h>
 #include <linux/generic_pt/iommu.h>
 
 #include <asm/iommu.h>
@@ -360,14 +361,17 @@
 /* PERFINTRSTS_REG */
 #define DMA_PERFINTRSTS_PIS	((u32)1)
 
+#define DMAR_OPERATION_TIMEOUT  (((ktime_t)10) * NSEC_PER_SEC)
+
 #define IOMMU_WAIT_OP(iommu, offset, op, cond, sts)			\
 do {									\
-	cycles_t start_time = get_cycles();				\
+	ktime_t start_time = ktime_get();				\
+									\
 	while (1) {							\
 		sts = op(iommu->reg + offset);				\
 		if (cond)						\
 			break;						\
-		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
+		if (DMAR_OPERATION_TIMEOUT < (ktime_get() - start_time))\
 			panic("DMAR hardware is malfunctioning\n");	\
 		cpu_relax();						\
 	}								\


