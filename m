Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F2B606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=sy6wKMMi;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=EIfbqxqQ
Received: by kanga.kvack.org (Postfix)
	id 3D98F6B05C7; Mon, 23 Nov 2026 04:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A8B6B05C9; Mon, 23 Nov 2026 04:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277EF6B05C8; Mon, 23 Nov 2026 04:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1E1B6B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90526A84F0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:35 +0000 (UTC)
X-FDA: 85465881270.09.E41D47B
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id E147640003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=sy6wKMMi;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=EIfbqxqQ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf11.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426654;
	b=oHEUjYEzDab9CM+GA0SBbmAqq/5VIwwE4V52D8kvqm+LXbWP9syDFXCuwTbkg8zGyjJk/Z
	sSYPJ8loEwqGUk2z5up3KnDbx/B9U9t7j6ni2K+D8kJzQ8h0WUDTPRhcXFIReWb8QJRZrH
	ofQOmTCitXxONVsPL28Q+leMZUNfoyE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyQVJDn0J0MtFHgb5Qr9bVYS1xHAFGjzONhCtcrDq0g=;
	b=LG428gIbwtBFRCcKXGS5umJyk4Y8k7GzlLpnXhKMUTgwcUpdB5TUQZceJc6B9NggeNmPEQ
	nKpb6OaUC6I5SOu76VH3QYgiVoQPKnt4EBkrwuvCVSnd4rpAfvyecoL46ICFJ76hVnNyOs
	Cps1kSFL9mQ0gfcEVKhdbEUqqJOtQiQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=sy6wKMMi;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=EIfbqxqQ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf11.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wyQVJDn0J0MtFHgb5Qr9bVYS1xHAFGjzONhCtcrDq0g=;
	b=sy6wKMMiSIYJJrLVs8OtFCFEbAMDezBV33VL71jtQheALKkWfogtOtkMSo7f3iDpx1hnmH
	DCow9DPdvS16RqXtCng1RNmV+NhFA2xClLPkTLPOYfmJGRa8ojIpmcuQsaxu56R6M4Fm+F
	kWBEw+7wIe+yzmSezbHp2T0eZORxNQJkDKd/9DCeDLuJAd/R7aeaufQ9FSQHhA2EizTWnq
	xfUG5037egX7h41/8CHjMiihW5FLjTaXA3mTegbNGNV896H0etpBsr0RNnEtHhkJFChwPx
	ujWRQS8fQWadjGCep69ydOg4Axb/KfFESJIPml36wiPo21QQXQ8D1RJkrL8ZZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wyQVJDn0J0MtFHgb5Qr9bVYS1xHAFGjzONhCtcrDq0g=;
	b=EIfbqxqQDY5EeJRfGC/cqaJZmr3BsSxE/bXQsnuaukyukzxhYJf5e7OI+OIDmQ4Kkwp59O
	ifnISwgD66ulBTCQ==
Date: Mon, 23 Nov 2026 10:37:15 +0100
Subject: [PATCH v3 10/15] powerpc: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-10-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1614;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=lq2CTgfwZG73WGl5OVl7p6mIHPWbhjx1Tz1RNRtR7N8=;
 b=bJ5A5zd3pfSWIa+VMd5QiOGWtRTF6UJscvwGWocaeSTuxYx7he2xiLti1KebdjyptmSFP9R36
 LWL13Cj7QasDcyXmn53dOiu+z7BAW25TVHWTaylnvQbJlD/oDtlC0ip
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: op4gdi4aq4rpxmmi4wpi54cfbz8u5hqo
X-Rspamd-Queue-Id: E147640003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795426653-928239
X-HE-Meta: U2FsdGVkX19w4Luk4JZcsaQ+h79fmx6JIiTo2lAo45ghgKTDx8zJJqTUFQCND36dDi0nzy6tngMlLJVUP2wZ0KkaZHNDxOxEsqtPj5EemxrH53+a1uExA+oNECGk3PR173niciZYhEG0RcOG1bwE3chSUORvbP0qBStd7AJ2Bx9QiSvXJ9xuy4qVCPGQ5RK2etzyQH9kc8OIz0BurLHa6SIaMWp6b3dRXP4g75/y5GnjNMMdpJi6gAi8iVuzyKWYn5n1vQLEKb8cH1arfuwj+gt5zDedc7N/nwP4TYmKCoRpb2pYs2ZHay/hnxhTGYcIpHI2Gmv7J7KcRD5LYCuurJSXtXAk7NvooxU7IGvYlBHuIy+yFhOICwg2xJJJdftp8BAgILmpDbxK/qHjUFLtOcIqICEwERqEHf0oHxQF9MGcINQTPSk7r+xgJ2DCoQ49dCYFnKB1sw8sbO3ti7QCWVuko7IXMOcC6J4kBOjPVGOF4g37CNy4lAGzGnJBz4e+MBeYN7sendh+gvpomN4x8jHeIpC/yr4GtMsIu1x/khm5idY1akT7Ata0IbSj0Wu3c4E0rNdId3MPyfwFb1H5XepoyWrPNiqk/Z0BeTmrY1GXwMHZUPmq8FYDroU8kdV2XUSnwK0mlhssYm71MKa/Xj6S65Om3QX4HMlC36kD6DwgmuMCZiEdOlb7InYnumbYc3r+k2RKCHhtKfwlfl/D9DE+x/OBCnwzJYqnfDPk+hJ8xfNllYGI5u6qE4kqds2eg62JfMqJEXJ1SYKWdTnfr9G9MWgVhkDHpRRnmcxxq1cW+M2IRiNYrwntFpxseceeBdyBJ2VR5TGuIuOEsgJRA4EaOMeWCPs+I2Av15UQj1Z4eL/MrkZ/XbRImcN0/Y7G8iERHDvcZF1wMiVViJR/bUpKGIm8Rm0wCKwLhp6YwriIZjpsUCM5hssseX3pKYKL9a1kiL6SOZEouDBXYSW
 jdnfZTbH
 8QxOeZjh9hhfS1ASUewSNOeRBrKFWC52kDhqpr4rVsDWZMUU5K+Gbkqqe6AannJdJ+/Cyd8ipDzKniPIjURXV5XSe6/7eJqmqVwbEFHjxIbx88o8AYlurclJibYhiP0BRYyVqtfBQ5Kj0P1oRy7Rrnm2GWZj9l7MmhTP6BQ4blOlkr+sUThpyB6kyYV7X7BJ6TntTbWnU6GbLuGA2CHHKACXMWjwU+Hpr+GSgzsykE6jMFrdLZ4rh9kYAeNX0l94jDcRa7bbfz8eWgzgfxzKqkGewXtXzS3tVEDzaN6nWRyMdPLz4cCyuCYT8QsTQTY1Rco4FePBWVzg32vPhLday1aqSd+S0mQczHxj0kKvgvbCC9rZvPeh/8KC9+G6S5/8yVMxmjY3NnOZBacUG/zMx9y/cRhXTMYyFrtbqs43w+Hdzgk6077/BEd+fBzynxJnsKc4hPwuD5jA1fEZUgv1RUTAKv1tMtVYU0wSdziK8aybXk6Aw/lovwJPT091bcm65TZ1HcIUW7LYrZNdXs8QLr/jPkcOUxMeEUFwzZVvzQTmLKNMKbflG7s3l95nDGEu006kn0JQqmBKlInZzRqNqj2W/ffHxnaY80o8DDGwJi2P95g8DdOkPEZKSoR77po06aiP/U4uSqjmFrJWHKCJBsjBWetaLB/c3WtJ0i1ImOjBgb2pwEtNaSCTI42Vyzt6mybMNj1h5Xrb9lKAJH83Z2q5VomJr01Qvl2pxuWKqrIpB0jZnGflzndKXJI964zTEeRmEWQvxsUu3R4g=
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
 arch/powerpc/include/asm/auxvec.h      | 7 +++++++
 arch/powerpc/include/uapi/asm/auxvec.h | 6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/auxvec.h b/arch/powerpc/include/asm/auxvec.h
new file mode 100644
index 000000000000..d6c180e9ac2c
--- /dev/null
+++ b/arch/powerpc/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_AUXVEC_H
+#define _ASM_POWERPC_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH	15 /* entries in ARCH_DLINFO */
+
+#endif
diff --git a/arch/powerpc/include/uapi/asm/auxvec.h b/arch/powerpc/include/uapi/asm/auxvec.h
index aa7c16215453..9ab5b6d17929 100644
--- a/arch/powerpc/include/uapi/asm/auxvec.h
+++ b/arch/powerpc/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _ASM_POWERPC_AUXVEC_H
-#define _ASM_POWERPC_AUXVEC_H
+#ifndef _UAPI_ASM_POWERPC_AUXVEC_H
+#define _UAPI_ASM_POWERPC_AUXVEC_H
 
 /*
  * We need to put in some extra aux table entries to tell glibc what
@@ -50,6 +50,4 @@
 
 #define AT_MINSIGSTKSZ		51      /* stack needed for signal delivery */
 
-#define AT_VECTOR_SIZE_ARCH	15 /* entries in ARCH_DLINFO */
-
 #endif

-- 
2.56.1


