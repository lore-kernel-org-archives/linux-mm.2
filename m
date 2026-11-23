Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2768C606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=zs2rFukl;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=PrBaN3N0
Received: by kanga.kvack.org (Postfix)
	id 3B1046B05C1; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314D96B05C2; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3696B05C3; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E833D6B05C0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96BF8A8333
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:32 +0000 (UTC)
X-FDA: 85465881144.15.0F9DD7D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED75F10000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zs2rFukl;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=PrBaN3N0;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426651;
	b=GrhhdCz+8ntTdXAGRAVdZ1ro5IgsR8Sp1Vzk0UjQ0fxvI73/wePEzTqZsvXrJWFTu2FsqA
	yH3K2Pk4KtYZzqS4h1ffeMIfOhyYuQfKuVWBqXjyM0nSVUU5tsdDb1K4ye6jiSHRTOqmT2
	EfJylmCPdjDMKhwGh/Oxk3c4SuJQIWg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XqI/ovDzkmrLY2+2cJN8n7p6UWRDilYHLPeAY+Yquw=;
	b=FPYJgQCPF8WQ+RqZX8n/mu0WeSdkhlN4HgP6Oe8NsMcvBYbhQlCJaU1QH0Sx5wjtHO+7hG
	eoPfWdmNXLpzh21CefTU14M2THGQSxpdGQLoOso6SMcbjybUsJ/kj32zhz2sB36OKAxDF8
	ErRs9sdDl0vv/VppxX1/c8IaGncUoMI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zs2rFukl;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=PrBaN3N0;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8XqI/ovDzkmrLY2+2cJN8n7p6UWRDilYHLPeAY+Yquw=;
	b=zs2rFuklTxUZu5QUQvubGD+p6Pyzu9fQaaPPpeVicdMWD9WrOngHzV4/XzWZBGRHsdJ3cc
	quUxa+FO+MT7Qm/1zSlCXev5I2WGMZIh/fLeXdR2vba6jrhmd5wv+j2JDbGxOR8rDRUZTq
	BrS2u4u2bVtIG6e9i5XPQgNb5b0xiqfa7c6Hy/FALHoQLbQ4PissJnR0w7x8W5wTyO+xDz
	W93AeGkWa+PBh71o7o+hiHRXY5BimtaJ7OVjOnYimFgvPF1vB7Sw1JBQRyGxXt9skYIxqX
	1OCyPLXO09TENfB/JZxU1yGMr5vNBBFPKGZp4DoiSMxG8+jwAwxfZJtkcpfl7g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8XqI/ovDzkmrLY2+2cJN8n7p6UWRDilYHLPeAY+Yquw=;
	b=PrBaN3N0mDSUo7jZ1zD0BdxjTZzR+Nlue0EyvgR0thKd8gbwBgsxQQULaCNGGe53D7j5Fj
	BqzY9hdcO8uUC/AQ==
Date: Mon, 23 Nov 2026 10:37:10 +0100
Subject: [PATCH v3 05/15] x86: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-5-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1994;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=AMxMWB4XLAUF07GFQRf/ET9aUWKjGb7vCuCYUiBHLok=;
 b=zxx6vGGdxpYVQVUw2UCdVcTPBGb0aQyLdwuRLfgrOIr0g0B+Y9UEJYR4JcBJhIcNn1mnVle0L
 jMOLDNcao4zATn0M7hA6ZDAZUGDgHq+8r7fL+5MoLrHIByaxlnXij9k
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User:
X-Rspamd-Queue-Id: ED75F10000E
X-Stat-Signature: kkxsj93z8enbsjkownfhtkbnoouojrfk
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795426650-80469
X-HE-Meta: U2FsdGVkX1+uxRrDk0V32pUfwDGVI2O01zpyaHBsDsaG/yZFiHvO/VVVsiUnJDVO3XpozF4bjn+G0BTtA0/vD8/rxxilFNq6ctyAeAlob0B7RqyWe8CNBz2YIWWMhtOBtLp7OChEaqjnzwzcZi/WLWJAfvex8FflaTKa4p6CvwYeX8sYVTK077UZJ9c9eWtgaFdmcKNpsizBS1zlQb2pvlfnxljzMqtmbES2vaiLnV+WlvJNGc2WOEEioM9z4is5FVjlPFG1Ko//HqR+DI8tuvzOrm4tzvY6nCqpxSsIIu3A1Sm/6zdGdY6/+UWON2tv/JnkJZCnBA5FDXbgXygFZPZfHd7eKBLg73Y8cFPoF2DeECybUMuiDvuq/d5kjxvJa7LZrCFuIa8kvJMarevhU3qXMBvqXWcVwAf7oj6X+z4WIjGdYIbBcEnBq4tSabvJTjDUXWzGKto4F/sXeQPkpxcx0Of1NjyV906YRjsEsyGUEoACZT4QkVPFcVXlhZGBuUZd27HcvACjmj7TSDyTGKJWif0dcTJxUxjq334PMDWdRKeXETqUE00/7nOzqoKEzPL6MmMdkpgX4qofeYVZsw4j9RVKJC9OJPz6deI4Tk9i12csX/C6FvsdhrVzJixuMgXDIoROf38y2Ay1s4ALEuwr3ftn5o1Ea7hOn2qBN/jVlz4Xh55pTxZTuNGz6jmNjtxMO5fs6euoEMycNgYpIiBZr6N1jVUzWBLXXcNzSYwQ2xxohKQEPrJOjl81NCu4r/Ramp3KzVEfjxKsf4g709oBSLF7m+u7y8fWlE8y5Wz2v8MZlGHIdLaInntZ097gTDHk3T+HIN/d3L4n1mZ/KRLfBM8EUhZ6nl1XRMF0IwrC9MrlSS/EfnQbrgojPo0t+afg3IkWsXGpMa2HPpTLcHRj4kCE83h/3LZrqQlVVp9qIrdtLF2Li+TlsNYemXi60P2mfjq2GpsRQeXORSk
 crhw4yjY
 EUp4rMNW+DQFSlu4oUS9R1cqk46rffrKJXzJfBrIWtWlZ8IAvCdIRH8wL/P+ikh/ijbL2BU/mRC7gVQdQ11z4ugeUZi7l5y+aqKMdwJmNu2EHYf1ENJXFpNIg13y9A7WhYexwuEGVTFT2H7JVzSg+jRIDyV3WY664nfWuuCODI8F5O5fwaAX5exR1UhWdTEbt6a76dCTOMWi5FztJp5VMz+FA51z8FbeZhKQQF/jqSRJgns0W4Q7qGs5n013stxTBRDvEEXsv8wd8ttHfI3/GIuD3gZSNqYWTi01B1n4MPW3aXPFZG1tUrOQr+B2o9fkFhq6Uf+P4vJp+OrMA1GbJ2oJnCh1mfxZxQY8R4wRduBNabr+bovVhWqI5Hu6fkLMugAU8JgpQMsoDr0GhSgS+blz8dTrFCTmdbCHhOKlKmndvBFjTlgOK07BJqXfKVFn7EKbXNR2vXIMgNtBpYMJK423/l5aQOiAIPWIUMH8jXguGJ+aEGQLQVMZxfb3a2J+f/lXn7uPvds6kzrprcWneps8/Si8VDIKklZOifzrBB76ar4kbsyJh5s6Ht/aDoii8EirM+cbxeKeLdGlRZ00rhdT9nnTlYSaiam1eBN5pvw6lIlU9xH8WXQ0DdrELyTsbHVID7RA4AYDmrBXqyLps44e8gQPpJKtjUiwMjHUohZWbB99zbott98zvC7Ii/QJOmbGg
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
2.56.1


