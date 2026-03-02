Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4317BE9B373
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B736B0095; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D901D6B009B; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75926B0095; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA866B0095
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01DD61CF2F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:51 +0000 (UTC)
X-FDA: 84501044544.24.B656238
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3CCFD40004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NgEmBRH8;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=wBjvzdwE;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr/FVLaERA/6AyGKnbc+eEestu0HgmTMXr3G7w1zsEE=;
	b=uQ0VyNAtMcIqGOeUnhnpRLirqzcC5fEFfeUSZbtbUyYtDhDQpy+fzUKIigq5KQD06ygUQ3
	08NZs7npHRCnZxmUUNSTpcYFPDHZ0UD2JSyZrkjK5jtSKsBIbwaJb0/ndlta6Ly79+s+Px
	NB/2eUHw6omHRu4e+l9QpQ+dW+Zl84c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NgEmBRH8;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=wBjvzdwE;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454350; a=rsa-sha256;
	cv=none;
	b=8PQaemzKtVZq/9QKM/ja/Re3AbMqj+ck91LM0wU8W0h0k90JMtnH68D0qoxFT2kvtRjwve
	fJ4y23kx96+gjjIct/lKZOOlZ8B3R5D5gStKHy/2Hf+Z/jyVmZ0Dqe3Ex2uQ5oZnGAwHf/
	5adfS1MChD+egLg0zTjYjs9sn5Mljlw=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yr/FVLaERA/6AyGKnbc+eEestu0HgmTMXr3G7w1zsEE=;
	b=NgEmBRH83vNY7H36CH4oO6VnJ5MAvKmiUKvwK3t7ouIQuPACqkkjKl2URmwcjH+onPdSZb
	r9EzOPFWNJPD/IuM4H7H7vF+bKQ2SYeG40TaRA9tVFaRIHivjPmTcNQ5/9CdZNluIMIyXb
	eAEshz46RA8/Ju0Ah9MapcJN+oVWn19o1cu3Mz6ujerXIQ7x5HQj7wht4jZmqkSgxgJ1TF
	3OxHlKUOzBCmOC0KB00MIeEsuA/rH+5YF1NUpCcU5Zfiqm6TXzb8mbOaNOvRguUB5IAS6w
	sz6lJH8dDDk5KbCgBUQK4ckDtwyo3MRB9L7tWcpXT8jZB/H/xMqqehwM/C37xw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yr/FVLaERA/6AyGKnbc+eEestu0HgmTMXr3G7w1zsEE=;
	b=wBjvzdwEGM5OTq4hn5Ae5qenwnN25sPzXSMLGyi7kK7MBM5frm1SN3i93koTAjShsmKHdH
	r/HgSkHAiAt1SKCQ==
Date: Mon, 02 Mar 2026 13:25:29 +0100
Subject: [PATCH 05/15] x86: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-5-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1952;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=H/zS+Ct3UHio/FsL18acsKnK+cbSHWGTE0BjVHLUtvg=;
 b=zafh0BF3nW0lW74zLMVAm5CMViipzIhJlV12m0OWQt+FQwiQhO8t2F9dDNqKSZeCroOF2w7dU
 QaM4A6LGzPhCYQpOkBtTE0q/iOHVWPqMyNJAu5/H35A8mav/lYtcmVc
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CCFD40004
X-Stat-Signature: ho43u7y7woee8tgqxajp7if53737y5te
X-Rspam-User: 
X-HE-Tag: 1772454349-285462
X-HE-Meta: U2FsdGVkX1+mNrwBhii5oMQaD0+BOTaXFrG2FB7Ku/EDwYsn1IHuzlXWnrewtaCeGoP7auRQOwrhCJFU3s5eriRMTzVIiOTy9C3FYqZvGwUPppfzpp78XKgH89MH3wC6FPB9AGaRZ7xI8SMOBY308/1yk+hoSvsR0+ckAG768dxFLx/9EjxKZGEx048FbTBx0omJDS8/H5q6KXC9MrM7sxGkkOCMHsy1TxsScJXdvHsMWNHHY3pwWaxIKeRGLYW5tDK6ADFuIRxi5IWZ+C3OZ1ivlp7ngW20vCZmb9Ev/7JFEhGFyE4IpnuhrKa2Od7UGNu1mzQdYiFd/urCoUNwX4g6LAyhqOXaBE3lhiCnxHHMSM5NE888k7gcbTQ2N938F/cubEitNuxEquq6HA2jQkDUvHYJ2EoggXeQ0cgRjHgItPbSuy+Z4BLVnCbEfsgCwqKHM7KYB6Ks3ijmwgZj2eDpEvOuDuUYzTZuyRupJtZ/lcjVy+6c9ZQjZyRCxKYPFHinzqqusMHwVjcvQZc2Y4hhzBRRrN3Ko0gEpvtoP9QJE5EkAmxtugVYw5JE6bgdxv4mPCBqC1WlZG01QgWd2TCsjZDvBnkqLuOkafdTlGcGklWpdZNcJuF8AtHVNuiszasoXjd+JyLkymsgax+gw86Ww2dFXG5a8qs7Zbi2M27XzXr7mTEl5k5N3bMKEl8uBErYW0aL9GRcxwqif7wyNrpUknTC8aP163m2V1T+VyVWu8x0OW8kAzscBS1YcCeNXaMJgJXiUZP/o4io6DsY+KnsX7pYwB5x+a7g5smmwbAzVwwVava6cO4SOzWP9nBVgq9rjQbXdF7JZ2O5vnm37QR9NKmoK1qf4ITRe+mlLTgLfSs8mToXttRvkzepckDYDkOAX1ZHvOLc826yqYDZ3jxWMnbmUrv+CglhA9nuHt5Eq1m4erADc52/sRX8+2PzNl+SXJ8GF1XbJDiXz4u
 gL6N5c+C
 V4NVaoJNC23h71Xs1OvpQ6Oj8KfEILLCDWecFbp34uULuvVZ6X5NNhMGf5u7NdWW3qbiIi1XUM4HCAhBQ5LZ4PEXfY4RHuUFp9aJHZdpKNRFxkqRzojYFtQEn9sIknerQpFxfXtLCJq8VCeXzkbFP2kTIrl1JQUJ5yuuVqIccHYhRQJc=
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
 arch/x86/include/asm/auxvec.h      | 12 ++++++++++++
 arch/x86/include/uapi/asm/auxvec.h | 13 +++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/auxvec.h b/arch/x86/include/asm/auxvec.h
new file mode 100644
index 000000000000..ed26ad09f3e3
--- /dev/null
+++ b/arch/x86/include/asm/auxvec.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_AUXVEC_H
+#define _ASM_X86_AUXVEC_H
+
+/* entries in ARCH_DLINFO: */
+#if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
+# define AT_VECTOR_SIZE_ARCH 3
+#else /* else it's non-compat x86-64 */
+# define AT_VECTOR_SIZE_ARCH 2
+#endif
+
+#endif /* _ASM_X86_AUXVEC_H */
diff --git a/arch/x86/include/uapi/asm/auxvec.h b/arch/x86/include/uapi/asm/auxvec.h
index bdde9e18f94e..6677c9ace117 100644
--- a/arch/x86/include/uapi/asm/auxvec.h
+++ b/arch/x86/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _ASM_X86_AUXVEC_H
-#define _ASM_X86_AUXVEC_H
+#ifndef _UAPI_ASM_X86_AUXVEC_H
+#define _UAPI_ASM_X86_AUXVEC_H
 /*
  * Architecture-neutral AT_ values in 0-17, leave some room
  * for more of them, start the x86-specific ones at 32.
@@ -10,11 +10,4 @@
 #endif
 #define AT_SYSINFO_EHDR		33
 
-/* entries in ARCH_DLINFO: */
-#if defined(__KERNEL__) && (defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64))
-# define AT_VECTOR_SIZE_ARCH 3
-#else /* else it's non-compat x86-64 */
-# define AT_VECTOR_SIZE_ARCH 2
-#endif
-
-#endif /* _ASM_X86_AUXVEC_H */
+#endif /* _UAPI_ASM_X86_AUXVEC_H */

-- 
2.53.0


