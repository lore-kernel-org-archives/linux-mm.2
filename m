Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4904AE9B370
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8F16B009D; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A7F6B009E; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3063F6B00A0; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 163AF6B009E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4ED35CAA3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:54 +0000 (UTC)
X-FDA: 84501044628.22.CB6F675
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8E64C0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="r/CSxxEZ";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=S21YjUM3;
	spf=pass (imf10.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecfuUU5azHq8roSLF5Ax0HiBG0Iw5IvlHchWrSnBNHs=;
	b=m7Ts2RTXrzcnM/0QLJwfYo8X5REr9ttA938cNg/p8zCv4FxGI1LeHbgLS9/yXpJswOTXBd
	xvq53q9/Z5FRcs/dzbSDta3dVL5zYU5VRCNI0c/wxxDZ6AXSYfX4SGIJfOlrP5BFk6TT88
	WGhk/SXQC2DU7vPFXT4xBh/rMiFpvDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454353; a=rsa-sha256;
	cv=none;
	b=OMQCum3Gg5xg4wDW+rVYi44ziSr3wDUm1YfqRXcygS0O/Vkp+nArbpwm14udrgSJXbdhl4
	N/pyhVtQfSZV+nnjhyTI+OuAf26p8g7Ous12eJxgaPYwvk0koPusQjVAfXLDisHswwZf6p
	n20ueM7/RMi709b2dZ4Rz7WMTXVIOvg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="r/CSxxEZ";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=S21YjUM3;
	spf=pass (imf10.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecfuUU5azHq8roSLF5Ax0HiBG0Iw5IvlHchWrSnBNHs=;
	b=r/CSxxEZZPx25noWnuLPEOlvg405Xw3xca3EQ0DE8oLM2u4AtAQKtb0mTgYGT7zNHayXKG
	BQcz8N1JHly/LqSLJydEWe+r3AoQ9SjVio2xtukiWONbZ7tY/j6K9f9K/VAjR8Y+XIZzRg
	Gc3NPnb6uEX0qpxuX6WKeYi+5XpUgY123rtr0SMPuI2QKA/Rp/0x4Yn05tRyih5Vmihiq1
	9LOdeK/U4wIXyctQGqk4grG7EJUMxQHBdiNQ768uDI5Dv6mpUX8ufkZ5jaGs7ki5MemiOk
	Kn0+iI9vvKr8GdhcFoMuZ0AFt61kGSLtejHCDQWf6JNj0nKrPOa3fswYI5rCNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecfuUU5azHq8roSLF5Ax0HiBG0Iw5IvlHchWrSnBNHs=;
	b=S21YjUM37qvJpPQjuNWiTVpxOK1UlM+hhPYM3nYbn/dEZid8oxS5V9nRwJIuc/r7qqTqec
	PWpqTrRguz3wgvCQ==
Date: Mon, 02 Mar 2026 13:25:35 +0100
Subject: [PATCH 11/15] MIPS: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-11-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1842;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=TLuD8XFHYeCFVZxgca4zMFKNXfKPCtPRG8z7BYiMKxc=;
 b=1ouhbDL/O9yTtFSwv4lrq+riHwXSRD0g9+uI9iWaUTHNLcjc0IXfS0sFkkdYUE4260PFKC7dE
 4P5ShG0H57pDHM2jDb3gFoqedukI/2cts2/yo62lyKCENJaUAL69pb8
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8E64C0003
X-Stat-Signature: ibfoufjt6wcp3gny1a4x7bjpa7n6s6rj
X-HE-Tag: 1772454352-659695
X-HE-Meta: U2FsdGVkX182hOAeiS/K3I7ws3UHkDYFhyzDU4kIOUzkliYvL7gvKtnnsQOTuFJINvwnWIpvebPt7nCQnR9gG9pZ4Uw1xvQxOCy7jTFymo6Ok0I8Cwoz3r5aYrs6q2NcrF0PTLAIj/fgwKh22G2FGNAj1cGPSc6sk42xGNel24mVXXuqqSNkX/EoS/YAH3C/BHFGkdlXzsn04lfAzwulVDCFlzywJ5A/KvSsbDBfjIvGaUfWGd09FH0fN1/peruY6iy6mT+wRCO9Fj4Nj8llJZZGzyt09EgwIzYqwuu3KWchZ7UXL3zlbVmDS8TfNIU6EnK7r7IFQkcgGR4KXktlyhsW6Q5l0UzISDcDEac6wLBsoBDKwJWpglw3eXdGEklAtsVFxRFx1Tcn6Avuyq0c+AfLNhMrl0RWppoweIphF5FAvGtAnoc4nqBRRzoUzxtBbNcAegkjjueM1elH8QjBnIg8lenlNAAmuNOJH5gSuX9VORrsr9qmhdS8FzX/wrmbKKdorV/xZS6airb5PVUSBEBo16IJIu2THZscn4lw/e6HJ6nd3AK4ku1juE2ZBGKw8d8D1zZ6Y7pSplY3XYcqFmcCrZ+I8I41LKIBirlhW+dP1i3e4fAylk2+cEhCCqXhm+ChFB6W7JK16AW8B8yj3wOnL8k1fgws0rAoyEMJW61KUJ6RTFBHw27TWeDK35I6qZwTu++HfKGd3xixe+sQO/bZGyCmmbV60Pi7Dat5+bXe3yTrgVkk7VXLkBUpGfB2vdwR3fpmrxNt0hKrLJZvalnvvXEs25tBN1ueSFLKQaik2XC36/F3Va67Iy4fDttSAoNauj+aB8HjJ+j/XqK5CVH3JrpBKrgjhymXNkVtQBa2V53cVyqb82y9IdUYnhPAJHX/7SiUyGGMZNuZUixHiwdq/NsWMYpcuwjeVrwn7zKOb/lGXEyrkaZQ1tcaBMdf/7h15DF4XGT3A+Ndzex
 SkqvvozP
 jWT5sQ9sWwi/bSibU2/ckVXzmnsNg572wHjOEVo5eKWJVBG+svhNJDJWRTNV+5EZmyk7dPZ4qt9dUhjofJ9lnUQSPjaWjbUpqbjAXSAhBELStF5hvu4uuRJ7SNPBPoKAFfPB4oDiu/4YNK6Cn07Mwwz9C2TUbAdZMkYvmPcfPzzuW5JTAMLI0N+QOUAHtnIzDknbsOLru4UdaWAySKQunCm29M7QjhZ5D/q81n0TV9ndtGWT3OHZH6y+MzAl08XoI/zb07Ig0HItdbE6eQrev8v1jwqPERVHZMEPoxrgYnQrUgu1lU++CI4ypPESzrqq0abJHcKs3tuTZiRB5YKxEFO4mUghgB7set7Yvh82wT19ogYAzXR/CnpwXobxPLD2vYWRAH6nIBH+EZP7H4vAgW6gafN7QVNpFG2/xi46z18ZExhp/Xx0CWNHBll0S65eDoWzg+CWCAhE0uuO8Jgm7PJydupYjePOAwGjn1sxBarVSa/ERl5nDzv/Q1JIe92gSIwxyPMF26wWrnTImM1rsIz5tlQqMhJlAC3HkUYEwsJ0ZrhmVojh9Zy6FDg52TmY2DI3zpv6AfYI/cOI=
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
 arch/mips/include/asm/auxvec.h      | 17 +++++++++++++++++
 arch/mips/include/uapi/asm/auxvec.h |  8 +++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/auxvec.h b/arch/mips/include/asm/auxvec.h
new file mode 100644
index 000000000000..76c445e7890f
--- /dev/null
+++ b/arch/mips/include/asm/auxvec.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright (C) 2015 Imagination Technologies
+ * Author: Alex Smith <alex.smith@imgtec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __ASM_AUXVEC_H
+#define __ASM_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
+
+#endif /* __ASM_AUXVEC_H */
diff --git a/arch/mips/include/uapi/asm/auxvec.h b/arch/mips/include/uapi/asm/auxvec.h
index 612c2c41f60b..1331ac4d935e 100644
--- a/arch/mips/include/uapi/asm/auxvec.h
+++ b/arch/mips/include/uapi/asm/auxvec.h
@@ -9,12 +9,10 @@
  * option) any later version.
  */
 
-#ifndef __ASM_AUXVEC_H
-#define __ASM_AUXVEC_H
+#ifndef __UAPI_ASM_AUXVEC_H
+#define __UAPI_ASM_AUXVEC_H
 
 /* Location of VDSO image. */
 #define AT_SYSINFO_EHDR		33
 
-#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
-
-#endif /* __ASM_AUXVEC_H */
+#endif /* __UAPI_ASM_AUXVEC_H */

-- 
2.53.0


