Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55696CD5BD2
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAB636B00A5; Tue, 26 May 2026 07:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83336B00A6; Tue, 26 May 2026 07:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A994D6B00A7; Tue, 26 May 2026 07:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 985656B00A5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C4D4C193D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:47 +0000 (UTC)
X-FDA: 84809320974.05.C26B1A8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 49A5A1C0007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="T+zS/++f";
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNpBzRSFlHSBCIkStgnPyxxPonuN6xED9SLfXErUVos=;
	b=1FqO3YBD7Mf3UJiWPZvdid6trFfzE4kDtD529WjvDFl61otZ/n8OLZJSp2eBGf7ItJZp9g
	XNwa+xMKX+UIIWJwNN8omymqeBsuJHyIPdM19VXEwa0ddhCh6fi+8+JvlYaIkOr/FJqX4f
	rocVgETSCyHvmmWlC8NBX5HfByo3vAA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="T+zS/++f";
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794265; a=rsa-sha256;
	cv=none;
	b=ndiIWTP0gqrk/YpcRBZA5Muutk03cD0vhR7W33vEKIr20eTq9P6X3z2MnbB91vJzNc5xni
	ugHlH7sojkkHC1ZlyEZlD8znu7Ejy392t4iukrBTaBder803S+c+IDxsiyhQCxgYlw+wu9
	9Px8qcv9/NZY+9EsF20zdUXjG00a8R0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5079F169C;
	Tue, 26 May 2026 04:17:39 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 884403F7D8;
	Tue, 26 May 2026 04:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794264; bh=RQ1NlL4ErKEM1olJpMC90dO11W+OKbU2xg5T/p3fkts=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=T+zS/++fPhv805L9NIm+oRkB64R0fwsP1xrVUlJYhMmeiEyiaDsr8k6fmHSyulgrF
	 CbBEjLZvxv2Q6rLyPcSujEjQ0gCNMNrT6wFyl5kmrh0q6ZON+3kqqq1sif5GV3J5dZ
	 FPTw72u53cW9scysuLkEk9ADePql1ih9+MKpXHhI=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:58 +0100
Subject: [PATCH RFC v8 09/24] arm64: Enable kpkeys
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-9-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1824;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=RQ1NlL4ErKEM1olJpMC90dO11W+OKbU2xg5T/p3fkts=;
 b=r89cp8X+naPnzCIbcK6zVZMg6/PfoscxoAVBLDmro6RESiap1gq3zWuTUsc3kXZB5SvTvfbDW
 B37mWVJFAZsDUBXbyZVdkaaZfxXwMAqwrymcQcCIOdRdebwlADWVbH3
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: dg363wic9zc4d1mfyzpy95jmhbeq9oq1
X-Rspamd-Queue-Id: 49A5A1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779794265-212010
X-HE-Meta: U2FsdGVkX1+eiJppupLsc80tcGgyQvMo8Krc08svPX/klMmIEcCUNtxihm15HCMUNP8a24RUWE3uwIHdRGRBqGPthmXGhweUZ94IkBWnwtGb63eT2YOdfwK3IZPggYgYpumezW4trmvwHA20waUbUCvM/Xb6uYmLJ/SUAp4+kGv5P8TFrUVVIloylZJwaOaI+7McyANjTqDFXsPkJlYJv2FR44mWar5p1ujAWuEVW9G9XI/cg4Plfv97uN0+uzAt+wc3rrg3NfdOWj1qUSebhGJe4pG3fgZzfQHp3pB93XGJAVWHqX7tpX3OyW2FIAjE1czX2FDjCDxoQvMmKoOfn9voirKvkyAkN05IZBUOVnv7aP6rvZPEJLegVcsByZFiZa20HFHM+BJHh83+181eDzw6vSfVK87IisUU4MGz1WI/uPMmzi29Vhl+ke5J34jA15pg/hQOoilt9KbhAuQ9mj9GNvT0dB+DJhbM2JrcyCdaKDzE6N4WNvmIjLp+3EBg+ZNCzE3UT1tpFHGzMyD+Gh4iSxyZlI3TDuaUjdoJQg/bRV/nVJRYHn3Kz4Z2kw9DrcpNRmaR5X7AbrgTWYzFdQc9Afxlcff0fjAGfMvHjyhwq52B6Q4UQKEfE5XHdVrMrufdwQG/JWxuR9lqsRCn4H99mFelTCTbkySvpAo9QXTsCrvdINHNalMEzUUPuucqE1+y5+5GRZ98AGC/mdZJNBHUSN4GM9vhKUPvRc8nA+MbHlbs5jMLi3HoyLcPEmOA7FZXoOl9S65bLvRm2fru4TnesuzHaFJd85KZgTG815xXKIGpngx28tEo3EU8SacU7s0COULDcPQXlSIkbudOLfC1pE7earXD7gTiZaxv2uyOOPM6sC9a7lmz4sjczDsT30ez2Jj8o2KQ51VK1SPTBqGR5CTfG5gyE5ZpGhQdJvOdBVtpbcc54y865Du+Pv7/1tu0FPD8XoV1E+KTh05
 1wpWealj
 /3lcEQiNp8Gcs6tm9T//XHVlPJqra5JJblH7E+UUsb8T/XGu1Y791FgIoVjb5Av1Jf1+tXd1/2FCXwvMhc3/08zeV4iktNBDLogmOwDlqhGHo2OxNZCv7X+iI9BN39FLdYcwufS8kWyCBF1BP7AjG8dzWnG8gYn8TYZM08/1tObs0Pb4rd3zTHVrxdNpgVrnFEBYoBQNzj7aOdjhbCD9F8R6Jd6s9mlSxA0dGlOyiJofBGrrlVYID0uN3Hs8t80sv6TJacP8VIJTunDdhhPy4sOdCY7w9j8xhaVVa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the final step to enable kpkeys on arm64. We enable
POE at EL1 by setting TCR2_EL1.POE, and initialise POR_EL1 to the
default value, enabling access to the default pkey/POIndex (0).
An ISB is added so that POE restrictions are enforced immediately.

Having done this, we can now select ARCH_HAS_KPKEYS if ARM64_POE is
enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig             | 1 +
 arch/arm64/kernel/cpufeature.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..ab06324a50ae 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2145,6 +2145,7 @@ config ARM64_POE
 	def_bool y
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
+	select ARCH_HAS_KPKEYS
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6d53bb15cf7b..e032322c0c36 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/kpkeys.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cpu.h>
@@ -2451,8 +2452,10 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
 #ifdef CONFIG_ARM64_POE
 static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
 {
-	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE);
+	write_sysreg_s(POR_EL1_INIT, SYS_POR_EL1);
+	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE | TCR2_EL1_POE);
 	sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_E0POE);
+	isb();
 }
 #endif
 

-- 
2.51.2


