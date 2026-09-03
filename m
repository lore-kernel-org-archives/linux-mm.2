Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995BDC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED9E6B00BD; Thu,  3 Sep 2026 03:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5776B00BE; Thu,  3 Sep 2026 03:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB866B00BF; Thu,  3 Sep 2026 03:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BCE16B00BD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D351C1603FB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:40 +0000 (UTC)
X-FDA: 85171656360.24.2E197E1
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id 194EB80007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=XvaTjzYV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=uYmG0xv0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rrF5e3YgB+atcHD5Gfa4JDkXTz+7YXoVXv9oxsgM/c=;
	b=00Qdm2UzFGHTS8jUYQqRhUe01OpMxA5UpXVTeVof8Yzb+tAUlqV4JKGAW1/ztPXSBfY4lO
	HNd6At47/hlJ4sbeH3QZAWF7fReATW6+a374Fm7QyohV9Vd7S3toPHDiBlR0Q4oTqqjcEL
	OQu4Gd0IJFk8axvy12iUE4Z0EwzFIPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421299;
	b=roSTB8z7mNQpFL34LWnru2MNz/0INOwJvpo7Ukxzk5lzhQ7fSShn3Av+2aUBW5hME4AXST
	HbANw17KTlkloLXkMqU7sdjBOcVWo9eMnBGDa9cTOUpFZ3mF2ONq7daBtHAWGFwp55cnBq
	AjYzbWM/GePWb/fp3C4sxIhcDMKdUjo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=XvaTjzYV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=uYmG0xv0;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+rrF5e3YgB+atcHD5Gfa4JDkXTz+7YXoVXv9oxsgM/c=;
	b=XvaTjzYVh0HucbGPiPARvWRn6wVYgsx+Csp2bfua/QOqfVCXtGr02dq9QV/NIgKdrmQttN
	FruSzRbjGV2ltb8/SOj7JTLix/fJZVbI+j5Ihb3ZDpTm9XgO+CVNAi1KGHNu8modprd4sx
	vkfb4UP1bfOYEiO25nbrMDeHeIFboyfqD/hgadHhg6C9qPWzibZS6r8QLE9hRF1PQ//5se
	ouoFxnd7ZLe4sa78VjkPB4220N3XCrJT5IaQiUF3lV/yfjq+0w2UO+nVMsmD0xDcfEP6cw
	d8JWdATeYQ0teA0PFMluj9KnXp8rrJpvWvmGfu+qMoJuGF9YZd9f/btvsvTkJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+rrF5e3YgB+atcHD5Gfa4JDkXTz+7YXoVXv9oxsgM/c=;
	b=uYmG0xv0qojWcb+hNeKMxC7/rqCyITMqfBa/1k5/2s66l8mXzXZhdsVPFBCJGgk8R1nWYV
	/D031BwFTFBTL0Bg==
Date: Thu, 03 Sep 2026 09:41:29 +0200
Subject: [PATCH v2 14/15] alpha: remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-14-5bc32a71e3d8@linutronix.de>
References: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
In-Reply-To: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Magnus Lindholm <linmag7@gmail.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1710;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=mT6IunlNmVAACIv/qOnfprsS76yyb9kAy/7Jf1UY23I=;
 b=yYjljrbgHd9g0YvBGpHX18OgBAHjsDzVbGwiInZAXSnDdTlr6s+0cRT5wpLbzZrAcLw7t0bCW
 UZTIpaJMtZoDO1+CQ6vAol3PKC5JWA+jRIyABLT06nkmg8XMLKxb5lc
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 194EB80007
X-Stat-Signature: 6zszurdty5pk6i9h953m9rpwepowmdy8
X-Rspam-User: 
X-HE-Tag: 1788421298-92333
X-HE-Meta: U2FsdGVkX1+0+TUoCR9iu+QE7m+LOUOGLtIz5GoOqsbIzPAiuYNaiGiuZGTTqsAaTqCZOVtwbVD4pmgXfeEA3d4ftpbDCaSBhdx+PuUBzcnCyW1F5qiDPJ7dKQUWBC7TOox2+ufGfwEdntIz2lSGbnVjimxjWaxSaHT2Y3AsR6SA7zmmVP7HI3Sd8GTpf7dQIrM1go3XYSpeEq7xBMUxPLjNG9tz+ch/RsCxHfqtIGt1ui/u+qXMagwlXOt9Xnh0ksNb9EmlwcXFf4ZkMsi0K5Bk1AA6dToW679bnsbY02U1PDKRM27Q1QmNE1wZTqgC29UYnOPC/6PeHBufE2T3abC3DtCaGJ5HXyiVi89RJ2AxehQ4yPw1TeMZbek0OjvnKsnkIosDMpAWEgWG7hbTA4rFSW3fWp2KZO1hAZkLQP51J0dOskWwbr9oMjIP/GqEuud5bCXo1TKcdA+R0VFDuxbnG5B3cbUkeJnLMq252HId2DT3Av/2pjbvys6InI8yZKLbxpAE2kQVyD5s6w+BXm41YmBuWMJ4tVg/c516kpW5pM1VjcgeDiUd1h6qj74SZEOYumN/QBE8EHsI2/LvOxIJc6BAYR2rQuzzR2qQXqNfHuKVv1lPp+3dZ426lTRgTgrzVbsaHT3dDCKADbJ7eW7jWp9CfbvnJqTaLNuXRhY0nP6zKK29S5+JHE85G3zORUaiIz9kv8GPImjAP7anuVR8W/R8dE3V2OuefODkob88omtRIPXOKjyvbMKEQxIMK8G00H8Tk/sjcHCLUzuDmtjQ8QEN5MCasHLXHoz2HX97DYXmvDR/ha/5cmYEXn/FpJeMTiYkD2OYwXxAxwgDNLSceN0ht4xD91vYMPFJrhN5+L78HJoOOdaIy8DJ885XwLC+bbFd0/gmI3M16xN6waSMa6IWapV4vt35gnhtEi6V+ybwgm4qCpRDd6t+d8dTvjNNOmfShTxKqpvMaR7
 o5rf8Lee
 vz7odCZ7P6XPLhHwJSec1m+ThFPgcQ6nhFdQBYKjmfjUTyYLN+SiXkyf/ul7QAPXRQLr9fU+9EhNpu/7o3+NMytKlQR7rI8789bPizYm4y5UrP1/gQ79Lz6LRmicmImZqlw9liG3UJz2el4ONj3XwhbzebbyU5/SKSiuHxOFRy2FbUWTl9+cLRg/jTQbHwR/4+VJN4JwTNEATsToz1llj14iVM6a1aHZ787uu6XRLNEEfiMdAZWmXFHspCDl+hWQwZADjvL7JZgctHeNNyB3kjMWKGi44CWXbWlMdGB1vcZ+73kP8efShEOsYjteU6u46/Ihe5bNJHNfK37MoAztDF7OfoKh/vfTEVT7lcVI4/glfSbCe356uGigxcychQruhaITRTdDdy5a+OwMo7SBX1yNW6iSvDhue0IPTccJMpJCdJ07fERwysLrV3y9M+gJgNBJr9mgUL2PBWlw7eBWahUKdutXWhffJddfQZq0eUnIHAJ7SZjjvPmH8N7N1kByzO9+DKx52e7eBFCzzWdlfhfLlywsrTThN8jr9cSXOmdazosFLqHCY09Zu9oskpKMMLxa+
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
Acked-by: Magnus Lindholm <linmag7@gmail.com>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/alpha/include/asm/auxvec.h      | 7 +++++++
 arch/alpha/include/uapi/asm/auxvec.h | 8 +++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/include/asm/auxvec.h b/arch/alpha/include/asm/auxvec.h
new file mode 100644
index 000000000000..fa90ee4f899c
--- /dev/null
+++ b/arch/alpha/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_ALPHA_AUXVEC_H
+#define __ASM_ALPHA_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
+
+#endif /* __ASM_ALPHA_AUXVEC_H */
diff --git a/arch/alpha/include/uapi/asm/auxvec.h b/arch/alpha/include/uapi/asm/auxvec.h
index 57cae8780d81..d21b87b6730a 100644
--- a/arch/alpha/include/uapi/asm/auxvec.h
+++ b/arch/alpha/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef __ASM_ALPHA_AUXVEC_H
-#define __ASM_ALPHA_AUXVEC_H
+#ifndef __UAPI_ASM_ALPHA_AUXVEC_H
+#define __UAPI_ASM_ALPHA_AUXVEC_H
 
 /* Reserve these numbers for any future use of a VDSO.  */
 #if 0
@@ -22,6 +22,4 @@
 #define AT_L2_CACHESHAPE	36
 #define AT_L3_CACHESHAPE	37
 
-#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
-
-#endif /* __ASM_ALPHA_AUXVEC_H */
+#endif /* __UAPI_ASM_ALPHA_AUXVEC_H */

-- 
2.55.0


