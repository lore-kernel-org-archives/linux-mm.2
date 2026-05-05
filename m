Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791BDCD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43306B00BE; Tue,  5 May 2026 12:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE196B00BF; Tue,  5 May 2026 12:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94C16B00C0; Tue,  5 May 2026 12:07:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4E226B00BE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71A1A8C951
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:43 +0000 (UTC)
X-FDA: 84733846806.17.36A43B2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E7A5160011
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KkYtO8mZ;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MHm+BE45gld4PlAAsx6bWNk1naCvu52znLRb6ksdbg=;
	b=6fKGhQdYA/1L3Ql5LrqI8XOzfJRH2UD3YsyZ5dsdXG76KKe+NbOvDJv7A5YJgx2Tl+sLf/
	G0bXxD4SrYGCaxplA3Omr9St6Q27ApDSR2jS14Tfvc2SrMI8+tAZvRDMXcMytX0frvuUvP
	Lm3BAUctWQDZbJTCbIiO3MNtLZ/iPDU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KkYtO8mZ;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997261; a=rsa-sha256;
	cv=none;
	b=6EFqlnetXw7hAL3vVuD3kMjEHdj8aYt1G0XPMcv9s3FFOWDxJXjM5qLKMOjv/He5ZdgMGN
	jBiWBJiiW0H+FDvXYr4Ct4psY2FGyPODx/KCa/oRl1RpWCnaJkcwgaKpMF4e3/aSqx7NKi
	bmIL5eL7jkxSK9tPSH1F0m22hLQd6KQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F23014BF;
	Tue,  5 May 2026 09:07:35 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76B503F763;
	Tue,  5 May 2026 09:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997260; bh=g5SIlfhNFVkGHqg4H9aglJHNTgTJdaH8G/qaojIJDnE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KkYtO8mZqdaw92smrCGaZTzZI/VIzEyKkmaReuGHOucgR+tC88xl9fofAudD6UVpk
	 k8mMgNRteA9j5G51xbINy6Vsrn2R/ZjvzJ3WLH6+D35W1zPhu88N6Lht8mUvcMEWUs
	 dFkjBvRkKGt4/X16YT0hU7+djWqlw+f9qAt5Hw2s=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:57 +0100
Subject: [PATCH RFC v7 08/24] arm64: Initialize POR_EL1 register on
 cpu_resume()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-8-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1238;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=X72DCdJX2SxlqX4hafcg68D9WxF9xj/CvQA2EQYYzDc=;
 b=fim2j4aK2yghbZYMjdBQCOZyKY91r9Ul0SwmGZQdrKUeEhqyNGE1v6WJFGHlbNiKl5XqoqcSj
 w/Gou1BnYSkAXgMZuyZl+N93zHfpv3GYcZkYHunaDhY0KWNQFbc8UfN
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E7A5160011
X-Stat-Signature: 6ehiuq77gq7gtdaiq6aydo1p1jtc96hs
X-HE-Tag: 1777997261-242828
X-HE-Meta: U2FsdGVkX186Ty63XclKs99aCvv0XT9kIgSK+0Z9XnGyFeMKJ9dcV/giH4yf9m3IWr2lbUv4iAvJYV0zOD1uso/e1VsDnrUedpJK2bKJ3TYQdN1HaK65l7Sj8krxoz8YxWtTbPkHo1feD67rH6FAGZSBf4zxd9bzXni0P+wswwUHIAQ5Xu2VQCywrXpnrgXZjctDN4XsnhUfqCMoV+xhbet0BCqBrS6SIQzdILHXmD4wZpZWq4ddrspRxhWg2jKcxwgD7SDAse1Ej/faqubZggUsU//b9p0bvXsdrMWAkNPLiMxMvMcsjgqZUQ0F0Xt16GXdQg6Nj723KsQHuBofIzEpDawjpeO0OPfxAsQJxKGENqMliG0t8MtTWOwsITtV6657sTXMZGWYZbgF0WGb/WG2S0IJIi+J1LLhAmVWq0hIS+ZfaJSj14NTQuFfcgjvqs0mHqTlEwrdcrx2TtnBB+xbX6Mjc473Up4Lk4EhIeLyXnOkEHA6WiCtqTXmxn85ZnMUE8nuPoUeK565DMBN43miSPy6seTOFFNHjQYDEJG4nBTh/74IjkNB6+zCWeBm4aparYSDlc/OOHW0s9QZkm7g70vQwfMoeFGrWWNP9dg/xMtXn16svS/HCPhwRwBJTQVBJPxJmy17l/OVHOuaURFxD1dnTkocUVXwQTBbXgDB8vh05Rp9n9iOwoXQLSYY1GGTdyzSYwOmYftDWmfuPSABzTWWarDJq//tTWKgI8lqJuF/rQqvIRRDOzJeeXMu+PIP3ddgDbVLLOpTpEvn7ijMBk9+SUfbu0a/sVObVEVt6iWaNwNdtgCMN+2pgt9qDNstdEHmd2H3N2o9cndPyJp4vDK0L7EC8/RUdgahs+M7aR0siTRoUtOD7Yl500LQBwjtdVUI5BK3eyfQjGyXY22WrkMSa0KSOARgOEPxFrbxCrNFmGCAAeVO4VOUal0eKPmvL0A5sYqzquv2CFi
 0DJrfvsS
 1OeIIy9UVYUoScDaGX/3T4PT278FMJnSDfui+a2DbB0y3xZdYEC/JgzeEx5aKYvZFiCJud7KRPTHwY6vdZZG6lBP9APFsoSS/Z+oyLifpxGEtbAsuFAf5qT/9RJuspCpI307ZF+XZq/ZrzNykQhtmIKAuafwyEdGCncFIgy96oOerCLWoRJySEFh63Fbwqx8h0pdzcC1leSh8jzijq0oEgkNFRZJv51Kkm3XAlkWBNZXsLZpjHAlA6xAUMPfzYLCeIaV4JPS6JnQJs8Cyv2snnarPfeUPC0Rar8j2DNCVklASQ/G1DyUvRG7/TFHNYQze8ogsoxSagSsvBwcM9CNXWCaMkg==
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


