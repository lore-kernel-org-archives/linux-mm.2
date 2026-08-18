Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41680C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D8C6B07C5; Tue, 18 Aug 2026 10:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474EF6B07C6; Tue, 18 Aug 2026 10:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1896B07C9; Tue, 18 Aug 2026 10:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 140AD6B07C5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA050A0266
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:04 +0000 (UTC)
X-FDA: 85114579368.08.206B152
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id C1C8A14000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="L6cdEA/B";
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MHm+BE45gld4PlAAsx6bWNk1naCvu52znLRb6ksdbg=;
	b=tFw3cxVR2kk+edfL4kcmu9SdIp3U988c8qyRlgaU7eNAdOHsoMul1jqtbwGawo3OTPLKak
	loWETpJXyEK9/u075phdJfcA/wjiGBDKoK31samRcMQ26iyMzjLmrkYn10iGf6P0hSeeCz
	2nsH3h2Hz1EPNqsT08LO+rYaDAdiZrU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="L6cdEA/B";
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062322;
	b=Ul0HNkQGdKa+iddld5ZFg/T9KfzLhGwq5kVr8tp1/hSKs2wNAcaWMeI54sV7KmFUKg/FGU
	mSmV+INO9VG8X42DZcJmdKV4E1QrxNuWyvr3RdZgVFqjD7MzpYZdfGYdgs00ttqFFr5xVc
	2Tnl02GOyASoeSoRPxTqjhWRyk1kUCU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0549E19F0;
	Tue, 18 Aug 2026 07:11:58 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44C6F3F85F;
	Tue, 18 Aug 2026 07:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062321; bh=g5SIlfhNFVkGHqg4H9aglJHNTgTJdaH8G/qaojIJDnE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=L6cdEA/BISwr7ZGYF7a704NDGC+im1GJ4f75VGUu82/h16AtX1OuAwGlV9RZIL3iN
	 wTHwhWRwouSCgqYNm4ZyME8nNT67p8y462FT1X4IqDkxZcqIp22QV7Zj6C5AZrcJVC
	 0QT5qi2+96d67Gn0ORmwA+Bs/665rZSZ2l3fkU0M=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:50 +0100
Subject: [PATCH RFC v9 08/25] arm64: Initialize POR_EL1 register on
 cpu_resume()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-8-743ad31b2c8f@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=1238;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=X72DCdJX2SxlqX4hafcg68D9WxF9xj/CvQA2EQYYzDc=;
 b=JseJqSnqWF5VwY3b78AO3x1orBPCnLTkOtj4V+MVgokgLhHzhQg+2ITqTTwUd1hYOxGHqUo2+
 WvBZb5/1pbMB6iiTfbLpaiRifOp3NpBGNVSiTnRWAfpIlMiCzYd4ZBz
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1C8A14000D
X-Stat-Signature: fauebbtfnjofitqfkt7d3zjg4qe8q73e
X-Rspam-User: 
X-HE-Tag: 1787062322-845346
X-HE-Meta: U2FsdGVkX1/4xiDk1ugvkUwzz8tOBuBXDrGJ7F1lh0pjmCTJcK1PVGwlwShww/lqxhGFRnULIgNv0mkzhM6+THztB9sAY4r5G3K9z6MoU1OPaDFlZYM4OSdlty6NWzZxY2kXg0lS0TmyZMyjJusbfLWMnV2Y4Yko7AiUYRfidk+6hTaVAXnozChTxq6JDNMw9c02D+UxJ7OMCkKl4t0bYLq/6voYb0t1Bsfaz1t3/FdxAyo6DG0ZSPPDGD4zhjA/LHZaCRSHRNwY0wWrnegTPJLHCcPhO1nh+XG1gpFocQGTIK6SPcxDrW5mSsEccUq9MZtsCNDIEOhSCyZ5jmrzEW0vUO3unXQUiKfZMvyOEr/G2a5TeI/ehFlBRQT+LGMgtoO+I6TzbiF2963TnJqVttLIgtkWg2Q4s+pqZ0w+q2+oJ5wt94potLEnLxm+ceKhvRlNCSQzAdt3BuqaWG2yoazuyWpW7cnGk8RlCFlVhLvm0Dk2bl/Rabdnq3lkR4nE8CqOy18wVCo2srNvILti6iJSEeh9gxmWXxRtm0sDTW3pNudIW5y4WDhIQHqBtMPohDAptLkh7dTvsjmhy0kb0Ykr93HrzGBxz/M3jzweiiBNXDyTpUhTisNlsTGA54MeyoFfkIG+djT0sFp0I+w5JSV0ikVpobPBT4wk7kw3bM+nd+1b7yAlhHVeORsucsigEKVT9I4EsEplrh8xZYvPkKF8RtH/jdR+GaQZfkzXTm9S5UtWbCnf1/Fq87a5xO4nCiqVwdzFAPgOhODJHJx7dV1jgoScKZSe7RfAzLnkchOS7sebQbaGXM5b9b8ZYHMtI9WqSGCZZEnFSXJ0YLjsaCaMXjX3DaJWPIDcHkw7dzwoIShbcctpWerimQM2UENWZYaHg0dLCKt1FU18LYxogCKENHkXibUAUjfv/W/PmPFDJCOBcpDcS+beuMp6A2EJDZLD3bYxt1FWBjpIY68
 qwiLgRlf
 bA/VPK4DimVhkC/6l8st7q6J+gaMPGJhOCuoX5TUvWB2+FnP3aXZwj+0WYChdE1o100+2J/ttK+GteWnCHJkJbfWxjcoecqiq7U6eNvMx6eevq25Al8vQP9YbuV4Rl+dXXAMjHyYjI4D4AjX9XKCY0RykxhPL64RuM1bPtZrZ+Kjg7xGG2VKrrfV3nueEoSWmwf6qKEXOgxmKmCyZMSkajNkfCVIkI8Z/VctupiZLMbDmRxquZgylUY2eTa50Hf/OPVkSyUxD0LF2kPxHa0gp2N4F9G5o3GJnpsReHfmVftOTvxbBJWCDTc/ydnwlbn0zw0dq9VMfddUNWBF1McLX0PGHEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yeoreum Yun <yeoreum.yun@arm.com>

The POR_EL1 register is reset to an unknown value after cpu_suspend().
Since POR_EL1 always holds POR_EL1_INIT when entering cpu_suspend(),
initialize POR_EL1 with POR_EL1_INIT before cpu_do_resume().

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/kernel/sleep.S | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index f093cdf71be1..e0a6ad85cd24 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -3,6 +3,7 @@
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
+#include <asm/kpkeys.h>
 #include <asm/smp.h>
 
 	.text
@@ -134,6 +135,17 @@ SYM_FUNC_START(_cpu_resume)
 	/* load sp from context */
 	ldr	x2, [x0, #CPU_CTX_SP]
 	mov	sp, x2
+
+#ifdef CONFIG_ARM64_POE
+alternative_if_not ARM64_HAS_S1POE
+	b	.Lskip_por_set
+alternative_else_nop_endif
+	mov_q	x2, POR_EL1_INIT
+	msr_s	SYS_POR_EL1, x2
+	/* isb can be skipped since cpu_do_resume() will do it. */
+.Lskip_por_set:
+#endif /* CONFIG_ARM64_POE */
+
 	/*
 	 * cpu_do_resume expects x0 to contain context address pointer
 	 */

-- 
2.51.2


