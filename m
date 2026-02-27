Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FDDFFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B846B00A6; Fri, 27 Feb 2026 12:56:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2656B00A8; Fri, 27 Feb 2026 12:56:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710036B00A9; Fri, 27 Feb 2026 12:56:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59E986B00A6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FEAA1CA9B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:33 +0000 (UTC)
X-FDA: 84490991466.28.AAC5376
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6D53D140007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yvPuv6sH8ptnova1Tbtix8h3gQ7QoRRh+xxQudFszJY=;
	b=X31YJf3LVuDdxRwdcx9vfQ1WT+hiouRybkdMJ74tp1EzHE/Kj29d/blFJbMGuIB67x/iUD
	Ry9EVyIoID894VQmUBtBELJadQjjotraLJbEMWylA+AUQU6T+TBP4wSllyCHDZUM0u/0xJ
	EVe8mZIxSgY6c/bOicUIEyAmq3lq4ho=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214991; a=rsa-sha256;
	cv=none;
	b=Jn7HxSkAyMpMLRsajbWoMZOXLmSnnj5kOmGepwjFaazsUI28jxHyJ8h+z1usZ8F3zozF71
	5chyX72tRpC6PJqw3YF3254Md7F1vkQArra0tCObmdbBwa8v1Psyo36w40oMz9YLdpWnnq
	e9xTuL+vLmrftdalshE89iLCW2Cx6Zg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D25D14BF;
	Fri, 27 Feb 2026 09:56:24 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1637B3F73B;
	Fri, 27 Feb 2026 09:56:25 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 10/30] arm64: Enable kpkeys
Date: Fri, 27 Feb 2026 17:54:58 +0000
Message-ID: <20260227175518.3728055-11-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D53D140007
X-Stat-Signature: zi9crgi4cz6qnzsw5tgj66n7zdco4r3k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772214991-119342
X-HE-Meta: U2FsdGVkX186YYKyQ1x2WHk8ioWhLPSbVGUHqVFO6znieySXJS1SeFRrwhGfFg+DuHCFIzD9zcsh49qXLNg/+Q8/O6dubqdZ4sH/ueOEoEiMPBrm5WsJwq49tbL+zOJeVOVCf3/Ieut2I4GU5dSlk0bxqJcpcwvqAroo2vYHfugMBZ2UbtYEHbQs0M1nUPm5daAq4pXvcVP2T7WSCc6DMC0dpzCsAxhqYoL9FH/wqxtdQhUr2rLaaPH6xY6VUrF8Rw5GbbR97Bwl/+BhBnQrKJT4xNwp6A+hFI6lu6VTSY+Zw/BhowHwpjrK2BgYJqziKcR7//5Th/smreGDroKpFaRhhwknGNpN1Z/gBnFIW1ZtsLB/HmB4K2ZcxXFMnSpKQGaMDhaKi9gB1lViWyB5dPVdr9DINHNq61grHt4MqnkNlXQZ0i+0MZc2Z0fdmBcuVWvjeakeoNZFiERQZnCF6WUyEVrbv9uW2MuIJRA+doaiIoqaKLLMLXQy71xCJOjLgqWQiAwONDJ1o/Hb0Le8e4thzg+//zN0AbHhbfSus5nZtUpqLE1J7RjbNRrc15jP3rGQN+VrLyPVjaFEVxYB7V7gffNjAzWnhD4wFI6m8AN+pUhxryKwthINkXMhoFObf/b/wEf/4xw8i4npl4yDRTBvOzq/THWgCTzDSAo4VVAIg+0Fn1XPoz0i9AjMLDViNwmLWvomU3xKJnpOcs7wpkGGwbD/Uobk2+wm8pUEWmsoELwegpdETYabwtzEM+jp0r8rAN2yED0HrXETXjKbbz6/eSM0YkLjAq6fbcHPIQC8wTlxxjo6gHs5h20KVgr27OV1GEVEMpBCGTJy8K134zpktawDxq3TEU3diQCv8BKPbu1UV7siNTUoYDmVBiMwwz4rEYDXqybeDzwC1o/IftYxDH/H9T2sc7fH1Fi0n1noWlr3vEy1UH7ExKax/R+NPMtP0oSqcRrm8hYGn3L
 sO+7b8r7
 io99uAxFtZ/aEVGRBnL0i4xFoJYHkfEzGLm475oRubLZD/pdPc81UkL8So7eph68luyzL4cH8MoiA42u8aLQNiPaAfbXKI5dtS7+ls9bcUXZLlw45Mvn7NlHMZMlBXTqnCiP5HLUqNtVWz4kGhvBdoITY0gtx4NJ+vaifN1PR+D+eO+1M/QVlMiKVOVMiBKUcjZ26GgwiaRQS0JZcvz4doog7fBTQDo9+VShBKhvAcDVrlKQ=
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
index 38dba5f7e4d2..732d4dbbab20 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2164,6 +2164,7 @@ config ARM64_POE
 	def_bool y
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
+	select ARCH_HAS_KPKEYS
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c31f8e17732a..3b01a70b617b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <linux/kasan.h>
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
+#include <linux/kpkeys.h>
 
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
@@ -2447,8 +2448,10 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
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


