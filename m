Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1FEF4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9634D6B00D5; Fri, 10 Apr 2026 08:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915526B00D7; Fri, 10 Apr 2026 08:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829DE6B00D8; Fri, 10 Apr 2026 08:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5D06B00D5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:21:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31B8C1403D0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:10 +0000 (UTC)
X-FDA: 84642555900.23.081AA0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A9FE018000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:21:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uoiHjWjo;
	spf=pass (imf16.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=ae8cfkGUIMIeVdEIq5b46ZHpiRc5HR7kNfrW28/CmkI=;
	b=z/c8Mt8kXb/u+RH0refTFlyYjJmKB34IFJbKpifSifvW21WJ1Rp6660jUzyZeqRpzfVaJG
	dMtosd2PWD50ElPJwB9zrwQbryyAxNbSYPRK+wQDc3PHWk3v8Bt5LE2X5PPF/xVCGAip4w
	LaeT7at8Z/2cIxUxXt5/JIRt5BTIRSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823668; a=rsa-sha256;
	cv=none;
	b=INIDvTX58JHKcJ8JA0pSCJtAkijwyXXqOc5myw1UIiLCaOT6aSqRJcmjFvVx2lDhaTHViY
	IS7zbGMO/riE3q8EmVGrCFxi0ZzzGFaOdRSMtZxYaHOu6KeDy1zIS59v+xZJrc+03X9/oa
	4jKc4Jw9FQ0mx7686lbWMhJj9fnMH+Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uoiHjWjo;
	spf=pass (imf16.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E98D6091C;
	Fri, 10 Apr 2026 12:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FAAC19421;
	Fri, 10 Apr 2026 12:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823667;
	bh=ql5fkS0UEXw/nBMHEudu1ngsgqvxlZvUknLeTtAAGUU=;
	h=Date:From:To:Cc:Subject:References:From;
	b=uoiHjWjoWcWN7Tw6xiUbL/Io/RlHzIChPqiGJJ7RtYjsrncirPNTd0U6jsMefBLBl
	 PuEP8rIYZGWPrDUGiB7D/1OZBxXBypGlDQEoNlUgfhKncfE0Vht3vVd8dR09fIJYz6
	 LaRap+OM72T7ij93UcDxrSAuxRJvyqDUwai7p79fd01gYNQNCFb6LttF4gur8fMl1Z
	 TmanYlU2xNYAREOAaMNh8AIeZ2WEpNPx/37VkP03IexczKkHFgtDwEiwY8TvmgoUyG
	 zdqSX2TqLhRdpCyZVVz2iZYLDeqcR5cB1pNHnjTlrpzblDMQ8i7KXktiKriMpSMGuM
	 +dQ/qJxaC9obA==
Date: Fri, 10 Apr 2026 14:21:04 +0200
Message-ID: <20260410120319.723429844@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
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
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 32/38] powerpc/spufs: Use mftb() directly
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Stat-Signature: 87u81x38d1zbw3iigjdcnsu8ycnhaqop
X-Rspamd-Queue-Id: A9FE018000D
X-Rspam-User: 
X-HE-Tag: 1775823668-624092
X-HE-Meta: U2FsdGVkX1/KZhLrrzqcAtigHRdSn5HNZ9LtZfXn3JiwZ15SaDU/h7kuTQUqCHLEPmUpMte95kPd7gW/EEQZ2zcc/IaK6q3xkP2nZepsEqbeXBZA/8Xt7I1QTlfu+lkZGeAdJrcnmFiLNbUBB5qx9p5poHOfB3E/ay+T4WG1oy004xI6BbzBYOO9d9x5NCeGGG8smaGCYm6idm+/CHJYsiaKKIc8MPTBefiOiH8eMujuPr42VoOGugSEO89IwGXiQo5xnOljc5sAfrbmxKanRlgveJB3sTEpctTQG9M1WGVxGNBvljJk4DL40769GSkUy6rY6O0bm325eriyjThLl2W+Vhp8ZSq8JoecutXdxxDjTF9whJnlr12WWgknwNMJXLnPMX9N4hlJiZM3sfAgvpFf73KQBg4N6Qu3/6eMqo0N/URDLTbEQLgF1JiCvAe+k6j6sJsDzJjuXMi4nVz3NrUXs1TSXsJMWjvL5FQSpmPwDwEnJ3BWVKCy9Vp1shvUPmQJRaHoOBEElZJFs5tEKwNIbadG37js5arc9dU+jGKSgvy5USx/hKbLtUhi0ktRxHdBxB7Vnounr9mMeP1qfr4SnS4ewAplE34aMSftWKZHxg3re3Y0Sdw4SE5IDfupwzHagFtUOae9QX1b/Akp53dbam6yI5kOJbJubZz/ojX06RIRSVsOsOyWku4mbEsHsxh0/4MVeDUx4RQ/iDPhaP6o+x7aFssTt/4t7gDNWsEWAWl625c8cE9mClDrynqWsyzPetZyp8K+5ML5vXFfZue4L9peKqv8S3l19M0zuRfDKHFMFc63/hdadAWDirlVh6RoA2aG/7WMx6ForCdPvUBojECDE/VVjxzE0uKkSknckMmSJz4FB2U/vuluJD9tM/lN8poG60cxdhbL0ta7Fq8dpP+DZIxznUvFLF0Exs+mLUr1PlppRPH83m68YY5F/hlWjKYTNeyuT5eGE5x
 lo0q/YNC
 r+xJQAO5DXbMnackmfmyHw4qMnL0dKeeRsqkPjnuWlYmVGoBfTdL4fcS7B/HG1oURtRRGUqPnrRJDRWexL8X82EmnKQtprgFdBFWSWqOfpGMNNmgP45fiyVqG+t6hjN31HMrnu4/t3A+kTY1dL1spSBo1wIVX9DvPOB8HN+Oxsv4zsx9MAQvixNhtu1JeP+iHF9Mzyv4rYKbbRFBcLuoDIZLvUE8w74eNJlOhLCgPACHVa4/ePKznto+l92mZyJ4ILjxyITfkw/ybdyVHqGGJoBYV/2xOebvCD1+w6xYZwIEvAobIV+N4+paCvuxxgasGrnA68SGDj3wJETyye0E1MhIgaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no reason to indirect via get_cycles(), which is about to be
removed.

Use mftb() directly.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/platforms/cell/spufs/switch.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/cell/spufs/switch.c
+++ b/arch/powerpc/platforms/cell/spufs/switch.c
@@ -34,6 +34,7 @@
 #include <asm/spu_priv1.h>
 #include <asm/spu_csa.h>
 #include <asm/mmu_context.h>
+#include <asm/time.h>
 
 #include "spufs.h"
 
@@ -279,7 +280,7 @@ static inline void save_timebase(struct
 	 *    Read PPE Timebase High and Timebase low registers
 	 *    and save in CSA.  TBD.
 	 */
-	csa->suspend_time = get_cycles();
+	csa->suspend_time = mftb();
 }
 
 static inline void remove_other_spu_access(struct spu_state *csa,
@@ -1261,7 +1262,7 @@ static inline void setup_decr(struct spu
 	 *     in LSCSA.
 	 */
 	if (csa->priv2.mfc_control_RW & MFC_CNTL_DECREMENTER_RUNNING) {
-		cycles_t resume_time = get_cycles();
+		cycles_t resume_time = mftb();
 		cycles_t delta_time = resume_time - csa->suspend_time;
 
 		csa->lscsa->decr_status.slot[0] = SPU_DECR_STATUS_RUNNING;


