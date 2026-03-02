Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3246E9B374
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6F06B009F; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F616B00A0; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52936B00A1; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C62196B009F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93D5B1A0C61
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:55 +0000 (UTC)
X-FDA: 84501044670.06.7957ED6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 974511C0004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=da6EZmSf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=l0hZVyeq;
	spf=pass (imf18.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IuCsvm2cGfELoFVj6dzhBy1SObe9G7IuVP1EF/2gXo=;
	b=BbNMNHwccLhoiFNwEfudNXA1jsAkUaSL9OyUzIlMfrz+1fTvS+o4S078uqb9VbUwLOEqm8
	STkBmcYbcp7yOGH9nEkYUeeMdvxug7CcpTXmUl70uKo5St4lKN/wOlok9ATq0yHeLqxC8w
	1Dukjt4UWav61ZhaJZnEdPjSQEJJU44=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=da6EZmSf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=l0hZVyeq;
	spf=pass (imf18.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454353; a=rsa-sha256;
	cv=none;
	b=4tlGsqOFTN6LbTYJemF1l9Vzq1dP9hzfIsbIfLdZzNyaQAbQlxP31Z8TyXQa4+bENaCASk
	+vFpMN7SJxZ2a5bpaCJN5DzNkUtg3es0K5114FULamGiOs4ZLFA7z5raNJS26IF3fk5svX
	5cs27sZ7HtINkK6AImHdDbrY9E6MCEc=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6IuCsvm2cGfELoFVj6dzhBy1SObe9G7IuVP1EF/2gXo=;
	b=da6EZmSfUm9111bFjIM3F+dNlZNGWPW1eN0BtOHAmyUkek/S4ApnyYsLAvQDTs3BfD8bNR
	olHyAq4d14aPCG7ZVsMhzqZcxVZhq3SlX2/LZCZ6bRx/FXwxP01+/B9YgUVTVhxcjQD3Xe
	2QVGzitWwT+eK+uYSrOBd3wPjWBv6oX0WxUiljKTgs5w4p1AATrCcykQEjpm7Wckv9EzS4
	R+prsnzd1PNt3Wn0W+ZeBl5H6RAhXbXQNmrGKr9HD5az0J/a+4xWjV23G7X5AoolJFcj9Z
	JCL0A7KseyQ+esU0vtZv29qwN6j6gzV74ezeGydEcvB+RCAX1FY+gd/IX8cYpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6IuCsvm2cGfELoFVj6dzhBy1SObe9G7IuVP1EF/2gXo=;
	b=l0hZVyeqGYmKCh8kKgBW2VcGXwDLfx5b9Gdrnegn+TBMrdFjh/F3qGt4TKfpLXDUNM+pxG
	6dNRMGZ/nruazVAg==
Date: Mon, 02 Mar 2026 13:25:37 +0100
Subject: [PATCH 13/15] sh: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-13-a11f03ba2ca8@linutronix.de>
References: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de>
In-Reply-To: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1566;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=H/m8MEbscz6WrH/+FAiysHkWJ0RcGdw589TTpDmII/4=;
 b=70FaFWSkNZh4Bigz/FCzkj6Q189+PNtssX+j5xte676xMOG9LLtUgl7gGtydm5ZgSwLz8qm7a
 m8JP07HyaioCw989TZl/9nlUAJ4kPMiJ3LDiNOJB7E4QpPK9Lg7q5Qc
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: 974511C0004
X-Stat-Signature: afhk6wm144bbjhqwfu9zb6ojofy67isq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772454353-876391
X-HE-Meta: U2FsdGVkX1/Yn7ViFA1v3xJzkit+RHfp50nuAbka4XANbdVYJbxYlGFTA4yWRdEF8rDV4x4TGpGg4DNX+qpInEliNzd60KZB1vm/1GqYcCT9ThlqDzK76ss7tsXerG0CmwfPwpfyUayGODTmg5+D7hkJYvoZkBr1/xQjCrmN5aBm8PyDZpNlA8sYU9vsbMyYF1blhdhFvOQGWgqxWqRS2Qn2lB8o/w1+xhEWGnrsxzBdZYNugGZUGVFKXWMcgcPyOSIS9GUwFYDGGeqcVFPawvlanEd2HmteoGtfKE0JITsdqk77zCCqEs3aTar+BTZKs95Y9Td/Fqo22wzmsWKzqkXki3QCakeUPyUl1byDdgTy54uUTlVYUwtNQmiHYGX/LAze+y5Wp9ti+QKN7aOTJBT7YEEKj2YYLucppy3YRRVwUeOX/W4EXnkUnQmnNHRe3zz2YO3dynnroDxiTN2A1O9yAAPhpytOKdwwFE7hnclm19bTBDvMOagutzhtTHsdBKAkI3GfNuHNiDwpK9cIaxr94qttwfE4X040nXbydwN5Cv7RGZUVAp8zEu6YKkLdxtvXkPt/D0D5nDopq+IFw26zix5cFHBObXwBnAgSpixHFbmpOZMBCxiSW9/lz0U8RrIiUtcIQV95XPzUJcDvEfGzeP/HYCFI5C3LK6jC/Z0kQ03OfDzqX/eX4lL4gxVRzfonwhiReXYXfPM9GclMpNEGBWWBh7JNyxJDOETT6Xzkib9BgNUqHy/vweIa1DuKS9xU0P8hw/KWIAII3qMx3IPEIuA86DEqVkHFk/iUSt4JZlxViUSwHd3yuqdE9tNm/bT7yJjD0TyLjqApfcbKGYt4JNUMuD4boD6UTBb46KwUkp2k9BHuT0kdPkxK3WVqtIvy7pqJOA5qT+8vTU3kzdwGkndfNhzp3tiZ2dG3gmrX4w80FD58moxan9Zbt4tc6SMTrhtxA/kORn37mY7
 bcfTsSnL
 2JkMoq3NREhusmDg4QhzqK1g/NtYLitsWQVOID9/EcbmWPAcQ2Kf0dHsggN5KeUlaI/PaFU0AS73u5XobhMmiD+f2+R3Kv6ssL9EM1MOZshogBk2EXSkAHilHu4O+Bqief57yn1aO1HHKjFSxu3ks3WRvbpEvLwljDEqfTakCbOmMvvy4GWfl4ekFBHpGfBS/IMlZfa0zoEMdNARzlinanU1sgUgLqZ6t9FE4cRP3IT09CAhPqs0yc8BlYsEC+MlyVDSw0SgUQ+D7zWx6VIFWfACyCSWSrMUfEJx1ZFZuZjmcum+rOxoADHc2709mDsmzfetfWsYBeeHfyO1MrZg4CMXdcoInH+wLliv6p0jBSas19aaCd3RbBrG/30Tt7hp4T2Lxm/QQOMPIZhXQxkd+CP0qzoUhSSyBALvlK71s/hpEl7MWjSxHN/3pJE5CyE+c6a/f5QyQVU3v2IBEOxVOaRrkB0Fnye1OKv/NbZjb57RUk221I1BsY1JtEvV3+Nm/MZHky/PWA185n7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is nothing userspace can do with this value. In the kernel is
always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
userspace and also changes from time to time.

Move the symbol to a kernel-internal header.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/sh/include/asm/auxvec.h      | 7 +++++++
 arch/sh/include/uapi/asm/auxvec.h | 8 +++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/sh/include/asm/auxvec.h b/arch/sh/include/asm/auxvec.h
new file mode 100644
index 000000000000..f0830808eb19
--- /dev/null
+++ b/arch/sh/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_SH_AUXVEC_H
+#define __ASM_SH_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 5 /* entries in ARCH_DLINFO */
+
+#endif /* __ASM_SH_AUXVEC_H */
diff --git a/arch/sh/include/uapi/asm/auxvec.h b/arch/sh/include/uapi/asm/auxvec.h
index 8eb47ede7193..1b07c4bfe160 100644
--- a/arch/sh/include/uapi/asm/auxvec.h
+++ b/arch/sh/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef __ASM_SH_AUXVEC_H
-#define __ASM_SH_AUXVEC_H
+#ifndef __UAPI_ASM_SH_AUXVEC_H
+#define __UAPI_ASM_SH_AUXVEC_H
 
 /*
  * Architecture-neutral AT_ values in 0-17, leave some room
@@ -34,6 +34,4 @@
 #define AT_L1D_CACHESHAPE	35
 #define AT_L2_CACHESHAPE	36
 
-#define AT_VECTOR_SIZE_ARCH 5 /* entries in ARCH_DLINFO */
-
-#endif /* __ASM_SH_AUXVEC_H */
+#endif /* __UAPI_ASM_SH_AUXVEC_H */

-- 
2.53.0


