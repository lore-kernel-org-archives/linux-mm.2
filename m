Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539C9C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560F76B07C6; Tue, 18 Aug 2026 10:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538D66B07C9; Tue, 18 Aug 2026 10:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427086B07CA; Tue, 18 Aug 2026 10:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 209626B07C6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DAA6C02A8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:09 +0000 (UTC)
X-FDA: 85114579578.23.20F30E3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id C16FB10000E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KM8LyCZX;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbamYU/DplPGG5Sdc1uS9ux2xcERNC2JNIHH6b3u4g0=;
	b=Bu2Y5+m72sgpSFXA9pTDVMJObvarlLL5A/jDKjuDQ4mzIneoY0j2A9LCbVNq777AvkjWze
	qTgmTA+pE2fzH1qvgWFaclyZF7gEjsmk4qhTk3oMT1rsw/nYGPi/muT6TG0bJC7AiJ+tYN
	9XLFEu2FdbB/Hgl2yYLCOPmu493H0wc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KM8LyCZX;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062327;
	b=mYhRgA+tYd1RjYlhzsxOWsuOZpBcGmW7g/xuFOte0zmF/kVYOIOiab+AWE/tWZJHFqONVH
	HmGXIgKfixwpRtpfVr8rijt8FTwCVzHZUnS5aRsQptOBDh7X8pOkxaxXVTKYiPKz8FgTfE
	aIlfWKDHBCboga6BIt64vtp9oGrJlPM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01F7F19F6;
	Tue, 18 Aug 2026 07:12:03 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F3733F85F;
	Tue, 18 Aug 2026 07:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062326; bh=FCGum1rTAVPaw3kfR73YNYjOCQm2+TowdZAQ4naswfQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KM8LyCZXFoj2SvWeg4FGMfVfyTECIs2/JVcKP3TzZ0xStyDKLjYaZ0cR3odPlKCOW
	 R89GcnDMSAgmVu93FnpXq8LTI0wIc11PuL9ccaEFetP2FTKbixbLItiNQx18OmKuYC
	 ZCRu1Xf/noLdgQMlvM5rFelQT89YHjYdnkE4JLMY=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:51 +0100
Subject: [PATCH RFC v9 09/25] arm64: Enable kpkeys
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-9-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=1824;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=FCGum1rTAVPaw3kfR73YNYjOCQm2+TowdZAQ4naswfQ=;
 b=cWs9/HhYQLlTOWcxsFeqRjaQ1YfUuLMxMTT+5dNmHs0vj2L1unepwEAB2wJrTYv+tdehkAoM/
 zD6D9oE2xVzBMNqlw/+Y7ieQRDluBuS3dfwZyC+BdW4UgNNENLR2FpS
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: dx8i9cabpxaprozzw97dkohk3opxzdj5
X-Rspamd-Queue-Id: C16FB10000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787062327-276301
X-HE-Meta: U2FsdGVkX1+/bsWVOcevOg/+t3uwAYp70Y7mHsDl+2pXJ7TQJbERioclJDyam91G4twjn8E1VmrMf66k0nVBzfe3XoWBnAqz2MjzPxQR+lxthnOs3vYvi3PqmdWzLpjn4NwSNpHHS8Yx+Q7FmgQLkXWoJsOlER8XEaU2Lgye8Uf+cRIvIunDW1fI3BeYdAWDN959ZEVy1fpac1qSYqZlTQZy6udytiyZlkD2ALro4R2TXhzCSJF45zki+HnYVVEeKinGYlb47coQZ1VznSrpXHjKCZhfzXx8y+zLkFqOAdedc9dXgV89H5HhzSYuWDCmfdOABRldQEN1Rot0tKhOb9QzV073Cn9i+/G0jptJtpkUYTPgSyBVw8y1kPjwUStNcVN4fWAsuVJlCSxq3taAg60Domj6C3LmEMUTsDHTExBimovKoVBwxE3u4Z4XjB5Z7pLdS8Xtc13dykFfzJ9XNGyt5XuLRO5N3Mrn0ZVKPtTRHox5Wc2AgSjUQ2y9rbdGmQmyUX+WFLgFFhE5ZHwtSnPsqCdRYM/XaX1jwsKi67hF7IcOEDg1KUDBa1hfhvEy52/I1ik0v/y6pWb9TZTlUEaYJZoY1RyoM2bNvLWFM8GFiT69HW8Pm9+CwdZlSKSPGFUrXvhAk/Vo6KSaJGWKmnV12yZcpb73D8L6kwcgrVgEQkdwvRc4ENrZxN9qEvMuA2GXr/HIFgpZPNx7iD1YHjk8eDA0nTAHOFDTFc1dqn2WbhTFXl/f8V9Nw0O7hl0nHpFNu8C6RpOja7nsob68Q7upF0LOsqXns0AwHP1tsDtorXo7ruAJWIwhXpLacB8DW2vil6uD4UxKF+cFfRV/x9A9mNINjXACCGcdrvDK4bQzY3CEh7BKhOG0SaH0PXEuq/4gHft45eF09HFBisQnbnFcJKWFYk9zpp8fNIitGRu2oie1HXYhb4stiUGraRRVnl6/C+nCkCu28IX1je8
 ilzU1Awh
 0WjP7Tux3agK7quMKYnCmJA5ice3LsgDRuxNB0haDVaSlGN1GhGRqTkk5epSkGBQPXuLZe8JIZJ4hRHAOC8tdhxNE3EqLr5d8+ie1wm4z0XaPhDtqqHyixVoO30J9lQHOOSGOqlgIc2gR+fl+7pUpF9Nqb+5Qw8qYjprYgIup6RsHJz0t/1/mayciNrAnwc/0Ez+6ZEeVMVCcCZCSP1BdgO8zmExh2m9qZs52iJdPLJrGenchGKJPoVwV+Cs6V8HlNPwoJh8ie1eCAlGq2hJknzSno1QTR7ag14F6
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
index b3afe0688919..0afa085c66be 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2202,6 +2202,7 @@ config ARM64_POE
 	def_bool y
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
+	select ARCH_HAS_KPKEYS
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120..4f2f54007ed6 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/kpkeys.h>
 
 #include <asm/arm_pmuv3.h>
 #include <asm/cpu.h>
@@ -2463,8 +2464,10 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
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


