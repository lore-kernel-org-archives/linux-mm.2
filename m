Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE84CD5BD2
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89DD56B009E; Tue, 26 May 2026 07:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875EC6B009F; Tue, 26 May 2026 07:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78BCB6B00A0; Tue, 26 May 2026 07:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63DCB6B009E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 082B9A03F1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:42 +0000 (UTC)
X-FDA: 84809320764.13.C323A6C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1BB1A2000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fi+UYaEU;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MHm+BE45gld4PlAAsx6bWNk1naCvu52znLRb6ksdbg=;
	b=wjr6ppndl1qeTUFxh2VetRu8PEwBJg55uSFkLV3naCVlrKn5erP0APJkK2ZVdXj2Uad/V7
	TEhaHQLppDy/6cZbJhk2S2RXqNZZYFD7CLgzkBApf38rjTgT/Qna+A7eIL6599dE94h0Ah
	CPQxozHpHiHQRLVitY2qh2ltYWov73U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fi+UYaEU;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794260; a=rsa-sha256;
	cv=none;
	b=pbQIzlOql1xI8EQgfr4o4RkZKOenyxSGRBg62pcrJ5WJvGezYHso0UVQfyvL7Ha//19LfB
	+yX8j3O8xJQ38V1l4+FNoPUDKOY6L6XGAC8eVt66AA0vVNE5wqZxV+EQWN5vLmFgEhpPW/
	0zUisSCQBB2KlsGNBQTOoaitivwXCpU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24AD8169C;
	Tue, 26 May 2026 04:17:34 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56D133F7D8;
	Tue, 26 May 2026 04:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794259; bh=g5SIlfhNFVkGHqg4H9aglJHNTgTJdaH8G/qaojIJDnE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fi+UYaEUI3ApllTrH+WrLvAM4f0KPGB9ULkC7CRHLYRvBGxLjCI3am8deLBrDJnoI
	 psOMxzYECWd5moN7XVrVApszsdb2OyHG/qOWJeiRdhZqeY7fLZYcOap+VENpMo8ai0
	 AlfXf1zM7i+XN0JkdtLCFK7q/9miEXIIWfMQxfys=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:57 +0100
Subject: [PATCH RFC v8 08/24] arm64: Initialize POR_EL1 register on
 cpu_resume()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-8-eaaacdacc67c@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1238;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=X72DCdJX2SxlqX4hafcg68D9WxF9xj/CvQA2EQYYzDc=;
 b=xTqK9y0/jfN6rkxWDlafJT2Opd2CvHu41k45n5VTUfNU5mVSqsubT5frcWIwDYbLHbHAM1udS
 SU7qCdKiicNC9JxB02tTDLd6gkulMR5AFGVMO5fVIu4p1YIXdwXjz6H
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: iyz1p53c6u1qyus7whzifbriochzi5fn
X-Rspamd-Queue-Id: 1BB1A2000F
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779794259-216771
X-HE-Meta: U2FsdGVkX19gpgRmukVtnHw/md+4omZ46GUmSqb5MxHvXKLj3csqMgW5pM0pGVpmRf9jdUpBTyfgg0OmSwYYuhe95gYKOTcSTLDcxp/0ESOTCTDbAa/M/7dOFC0vk1z7cdCjHa+VnOVpGh0vBhsuBiPkRfv/9mWCK6ztJ2Z6hvB6J3XQSMpPTHReWAqSgHHMTM4bD9Eou61jH+PdDrP40M5P+F95Sx68Al5GX1Mi23TgoG6C+5FSiA1c9N5hN8mtS2h/wkG4otVKSCRxpSqWp8l2nS/L215uU8M1x2wHsDf7r8ZHEU+TI+cN+OwV41O1Udh8XNUtoiENJcBWEBRorJVIZ8PlPN1cW75Ic+AJnpjMosSe0oUVOQ1aelHQzyQQ0rWTezdHB9FaRviVu7zAtECczC8DCvsZxGkvvIJcjAzVEUrzKmmXQZzQ+v5cJ2pVMIuPBFazqG0Tw+E2wVh0vG3hNYpC4Ry+r+SIm2TE15E2KkxoFnnsQSX0XzNJ+TW9QQUMlZihJqrDLwV13zsRrlx+MIbHkRevnJFCunNvduD6A7XyFj5AZ0/yebx8ZyupFlwgUM4dacnvy+2O1gf+mPrW/LS7m2KK9J3JF6WFVLq7f44VVnPFX8HCJ0EM08iZ2kGwHf0rQE/8GK9QGsa4tvUGWq07eYFBCOoRdyqH7j8/AOyyzJz7ZW30IqVWYGGwrQJYF72jKiIxnozFS3iOlWim67ugh7H0eBc/T5jHaeiuDFqj9riCeZvXMQ+Qddq0v4G8qPw2+8C980fjIqg0+Stss33oVJMkQJIzysDDGqo5w35WazPov9trw8hQfnp0H0m68xuUuPlF5x0tP0EW/9pJL475NFjNA1uF9YVuKx4hPNu3HOCjNC947wf7QA7a14m15+ptAI58EZNUDqMPUkkqv1gYgMEByglAP2MuYthxAY3udvoTscpDWpYijTCnPiWSIqS1z2GXyjyFyYM
 gWR24poV
 oqT9pglXVY3i2EPj8L6o4mIKEPTzfqaZBa0nbt5ITkSlTl8tj/E4O5OMyA3QEuA5nK7dITP0b2Kd1d8IlF6IJ9jSS5VEENVW/3MMWZDZqIk8tQVRBaNNCtfRfQKl2r1gwxmls7E6skW0zyeZWk5FUHzb+ptdgmemK4lKAc+r39uWuGqOHR7HXKarSL7fXYSMhOHd6JaRvOF47g3ESW8QnzhezAi4dU7i5O8n+3qN0f/2jW0aSyy9XK1DvmhnIkM1G43Ew12BGA6Occ41ptriBm/qq7uDHYIrbOet4p2SZGqFdEKyCQVMEaQL68qOqq6EvsBHU+NQk/MWEM6Mi1SwrzAfvNg==
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


