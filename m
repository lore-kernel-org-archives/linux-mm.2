Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDB8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=Qhjfuhg5;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=DJ5CQ+2g
Received: by kanga.kvack.org (Postfix)
	id 18D876B05C8; Mon, 23 Nov 2026 04:37:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1670A6B05C9; Mon, 23 Nov 2026 04:37:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005696B05CA; Mon, 23 Nov 2026 04:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D282F6B05C8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72A7D120818
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:36 +0000 (UTC)
X-FDA: 85465881312.26.D71B88C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id CA258A0002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Qhjfuhg5;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=DJ5CQ+2g;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf15.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426655;
	b=1SYDEzQKnoG/e4tWXPvrGYiS57YhZ+g9HRVJJ3ZNnrDUJt4lQrnO5CYJRluigR2fmwwIJ5
	jwueij8P5initE6aFz5SEQtmIdVorRhtNKeQDTHRdnFjVs/sHhOhQ6pHUjXHDqkX69r1Vt
	ntl9HFzXnX9z5cE6Wq7pnAbYeNa2Bgs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFz11W/0Lqk00aPK2+1rfyP0U4LgLtsvecMTzf9C0fI=;
	b=WBsIZfwofOyweHiqStjR3VgTuNE4cInXeXdjLjYTkFOxyHhtUHcA8X5PERxpkAh5YyXqvm
	zYaePO9cSS4/qLueUU/sLAOZAL1k+Ti8MUmIt3byqfY67UlRB2pBGQhVRejgSui09SOjsB
	YZdfwYfnKKz0O2XO2ES0nyTzMZLwgMU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Qhjfuhg5;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=DJ5CQ+2g;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf15.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OFz11W/0Lqk00aPK2+1rfyP0U4LgLtsvecMTzf9C0fI=;
	b=Qhjfuhg5BOpRdkpv0wg4HWnEWXpfOXKFeEV6Sz/b10Pv8ng2sR4CWRYNUMklJdLK+lfFhQ
	ciG8+VF0sDO41CzlncqE8Nn08rc0T60asEFi81sdelPgJ0xU5AdnXOBI+Fd5RUlN7xW6yQ
	suXN3LFNwZB08v4kbJY5Khoy+gIwVBMhJJcvRMo49tcKazxB2JkNFp7n0LqC/8/Dhebatb
	ZaMhDZgGsx/KdS26g/v+rWxCq4PFo03cy9ktkysnFIHbaU/A25ie0CbJdjqk6+NciQ2riA
	vFNQtU2TwgDZ6bNnr2LODBFP9Ko/KAHQ1WRx+mzOY2aLp/YG/M6n+1r8GRGmfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OFz11W/0Lqk00aPK2+1rfyP0U4LgLtsvecMTzf9C0fI=;
	b=DJ5CQ+2glRL7KEbNa9Pi3LC8RLTKlXOHkKWu1TseL+8X5jKEfrdNP/q+t6jT6amybgKSCh
	JOB22dFWK0AzxLBA==
Date: Mon, 23 Nov 2026 10:37:16 +0100
Subject: [PATCH v3 11/15] MIPS: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-11-d342dae9e843@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
In-Reply-To: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1884;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=/scq+fYP6ilitEq/RHaQnIRXIqOzidKEXbq390ysiEM=;
 b=VI0g7Ty5sUuiX3Qxq01gVzHhE4kwB7ooWl14HZPmX8PuM1fgFaPwF+XKQX6xfpE7avFmAUJaS
 6ukuvxThL4qDUbzZO3QI098ohACP5JqOVuaivPYQJ/IemhwRfmSZgvo
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA258A0002
X-Stat-Signature: qaegudbypdz16561fjp5ikdprkdon3xw
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795426654-703280
X-HE-Meta: U2FsdGVkX1/5QluvaVI3cwU8TjJLBWcc95AvZB5CbImaC9m2Nu/fZZQpUW6W+pMIrxjbaMqFHoa4wYusbRayfgxrEUDYZAKZvDs7OL3IehS7nqM54jLtNRDFp7IppsZ36/+Tji6FXnR0fquiaJ3u7sNpFExx7eOAjfmZAKCm8ItYZvI549hh0kXKYF0+qwtYLtIUvoWNlkxb0v8tMwy6EQrw9N91yueX6f3J+/GZP+1no2IjA5w5/9ngahomO6aWJRicfEKqvv51JskzO1uIwWa5ujWHyDr9qjz3Ua9Tuxcxk6g31KbY5rBHkmUUj+D11Gxmui0FG3UBN8IZJpusofxUZ0W/YbIvRYGo7rR9irCWThGg7gDLYvpqGCOD+F1/zzDuQ38uzr96xyDcmI+H8hRThkC3qsjzCTJ+fPOtSffZhNRrFN+mOzmNP0mZhM5XMk4/lveQcWqp7Sf6XyLMebHv8TIIQmw1cERb3SZVbWfj5DPlPFjh7T15YwYdvhYBhVXkTrMV0KHxii1P8RMS/SMwaHJNwu/3pFqec8V5m9mUJOqpCtMo4wwPTMYHWks2/c0lajhZOd8N3BHrQmxUT3QvF6npLNq8LCDOZFoPHNXmbzJljHjWGY9cmBiMUr9d/4RJI5Kn68g7xWM4EaArXTCFhHe0WV5rZjulzW149XW8CrRCiM5AWyjsn3IskRYDVPG6+xLgbhfU3cy4iRLNDw/fzOAq7Hy4gFD23SCBF6Cg/ZspKeJ7zWMCrvlhYFFj2/tSobCxmd2HsZZwz5RVUp18/FEFihIQ7ra+yXOlAZBuzTrMTmEhdopCIhuwcc8RfUu2OXNA7nIqyj/gEkKY0Q6eI/zjFf20zmcUpdj6FsTuq3ll2LLdqICWpj+lFgR7d4kIFaFgAW7GGmyy/agbDsFnpg2maVCtnZ1gbUlMQJx6eqRX+6q/tSqzgw3SLCqDato/GCUBEB180xVsxNp
 88yfTPLK
 Hqc0eCgpdt/KU1aWUASVikj0LZ9fGOcZA2FRsfw5YSfRmv0QcvPL//bFa2dY9OoPdocjp9GGXznPq54uznLuB07hq9RJPZnyB38w/mO10RiULY6Vsdm6cPGj7lA3yfN4tsvQw2RLqYzo4p9JIqc0VN7BUNJ2bQCuEcwllgZ15zRwdW3OsOXwRqweWzvFMJq7NRzXngJFl3Qktk1n3xiQHxeg4a8i70VIzidAq4wuv7OgboyIdwGjHjjnhmjPXLbPXoE7YJJc8RXpKXMgcIHbqGzyOJiA9gKh5KKVdG0SMVXFH4l6lSy6r/Ruk80AwBbokWJ944A+5+YP5BuCqKMZU6j+acrNAPvhZVzBq4637CTpvkr8CYOqvBvVFwiLhkFQghrKp/Vpl+xuwlCsmXOBCJOCwhRO+c7sZFXaNrTvC0GDumOM4hNrlrYHFm/EndOmGlAGusY/xilnc5q6t9Cg51RXWLaIonqg5rKLe4h7AxCFeSSeglvEjLHejCtBN+LTHC+1IH1/msIussVVMCjRYAH4ghE1TH3Y6EMdwn/43LiwKiKc3H2jQCNpXeUvOCm1ZF0JIjqP72y3EJiozcZVjJh4QX0AmMqh3l+NGDBeGB/cn67URvtcRifmZWoo7ezS9HWPTi2fY4NS9+2OvP33+FnR66oUBwCb5xP1eJjWk3ADPwjsuMnY2mPdtTbSkkjNOhavHeZu3GyZvAq/3yAAgg8/LToQJFBEGUvwlkARcSXH2PPx0eSWQQozBjrDw09/ztWaekb+qc+nF7VWsXW0KVBw5r1XPVXs3gpHGDAQSu8N4btqxc2kZ7yQMtcjIwVAXhyS+cfCRmOAb+QM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There is nothing userspace can do with this value. In the kernel is
always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
userspace and also changes from time to time.

Move the symbol to a kernel-internal header.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
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
2.56.1


