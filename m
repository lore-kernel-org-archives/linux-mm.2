Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF795E9B377
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D0B6B009B; Mon,  2 Mar 2026 07:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426FA6B009D; Mon,  2 Mar 2026 07:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329E16B009E; Mon,  2 Mar 2026 07:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3FC6B009B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3098BD666
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:53 +0000 (UTC)
X-FDA: 84501044586.19.F79DFA7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6B16C0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zCoq9RLG;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="jvOwc5/7";
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJXnjzhafvwvwcLJeLx/JDThum82eNRZ+z9+q40EfBA=;
	b=x6XllXezZwlxjaqsExkxT5zcI0S23JNWOCv4CmAWVBtsfP/P2hvfwUlSLOC6dNr+EOHHkj
	Fi0Y4EFU5ZTZIROfNVPwKC96ok3mITZ0Lxkd8bL/Qk0s410HoCVb5sUA6Xk3MM5Sj8C+nn
	YMJCrko3OyzYoGRnBvdav9syZVcMRiU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zCoq9RLG;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="jvOwc5/7";
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454352; a=rsa-sha256;
	cv=none;
	b=OJBfQrB/1WImq/7foK9gAhYSGI/xuq7qKsRLkaY96i2KttOFVu28nezKP7+sqhinqwLbmL
	j3s1zE0kUnPLG8dclTzHJ7i/AtVPILw6IOnp1t90THAfRg09Ep5+TW+UEFVAaVOuwNW2Gp
	hDi8OFSqYAVhaqGo0x5xXkCaflSCVLU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJXnjzhafvwvwcLJeLx/JDThum82eNRZ+z9+q40EfBA=;
	b=zCoq9RLGS8+8Po3hHcth4EHhs3ixn4AZwUIPixmCjgLS1Hf03Lgv9rf45OpQ6lXKNYcXmO
	x0ZUWl6+/PgitXxeWXIAzELn5d1DXLXNveRN9V3nF0ozyW2UUehdzvPfjGObc1KJJdDrL4
	nptOdJbV7CxiN74qy7BRfU4PGFVQaeTGo+XxFJnmWo0PTJnjnUg5HmCvvm22q9qyxQgeJ7
	X5BS/l8Yhy3jYQfDTK8hyatzbIIv6JfQsxytr6PIJESv6V9EwDsSq/G6tuk7rOU8/WH9fV
	LGEhauN3fOdaJMmrQI1L3e6wvuXkuiFz2uTYTcldWK1Zipo7oGvhkQShz2ob/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJXnjzhafvwvwcLJeLx/JDThum82eNRZ+z9+q40EfBA=;
	b=jvOwc5/7jBII+uejUvR7Ec31ujH98q8FcAeuuCJ+X8H4M7QnsAQzjQ0jhftKvsfJJyxGq/
	KBFXdSVINJ5ZpaAg==
Date: Mon, 02 Mar 2026 13:25:34 +0100
Subject: [PATCH 10/15] powerpc: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-10-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1572;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=KhAA9NBJJtHIM22o0JEE0DI+I7SP3GR1+cUX6gC6bWM=;
 b=1xI34QvitdF0I83i8CIUtWdYTc0yBgqiKjqBALtMj6mhthZIMQsEaK/I9frbiDgrwa8Dyn2kR
 BAhEAkxtO/bDDzmtnODmzu2v6S9A4iYl4oRMI1eIsDxYQs6Kx5lcAWN
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Queue-Id: D6B16C0005
X-Rspamd-Server: rspam08
X-Stat-Signature: wm9enaemsigqgeenxx8a83tcek783m4b
X-HE-Tag: 1772454351-721965
X-HE-Meta: U2FsdGVkX18Yq5zMHrAZ4j4oSEA2kh0q0jBnMYWkD8+SJHt02o61NOjHCQ1WKC0cBzs3s1G4ofE6nRToLkk9E9hX4sRuGywbDIw/jbYIyThKne4ZRN9q/zyWh2Ugyx6rlB9GmpLJTmUYiCTSvKOOw6P0ce3CHkfIEduS1tWu1P0aCVS4AwL/Vp+ofB0ApHn9CpeXs1muyTZYZQ036bS7ZaRXX7wQ1ge2U5XV1ZhHGjmLkLgzPx/uv2qfWEZSL89403t9t8lyb1rPx5CKJcjxlEssT9U6G7AWrsu8dFAnscH5AklbYOEJhT1qf4C/djPvq4UYibIcQcL9zAs2ND/hAqJVfnyQ4qGfol//OJuxARPPnGOSOl3Fie/LrtlaMCeKtyUo4uZ4hcLcAZcByG2QUCFm/l60kbHc6R4T7A1U0DWUWHIRvJ1vvPQ2THk3wtj8bjJbuy56qx5SEqLJVUBDSY6AeheQ9mk2vFao1Tzo5u6UmgIg+NjB5s69jTYHJWbm7lz6Yr3IBE5uk4qKLiAB8B8VlhwNHFuqZt/5IyD5vUmnKnjIrtwzIwyzwcpQXCrGn6HEnpbcQrnE0xQhDsBN9vsrnVnunrXXEYM7BfNaTm7BpH9G9uOLmEluH4u1KabKfzp/amLZqeilc6HxVtyNieQjMXuAKrKlwhYnZQEGRe0NvCWt7uBiJIPnUZSd1+HxjLzZAoGsuQHmgdOIbTupQ2Fri/EdeUje1iJAR5lJbfpdF3ir35bogxI9uSeJQnnmCIBQC3l1lSWsQrpTZKC6yXa8+7Otpx4EVaJgTy0MaogjqQNu0Q/BI3ccRUz1AkN/rf4xbd0evX7AqcFw+VmQoCRrPMsGvjiZI2GAFTanTTn3746rxSmr4KE/mrX2oTW2J5iNLYJdjNeTXjHUbpMVrF8iim+Hk0dmz1gkqQ/6LpiiUnBgvgXdxwNvC9HIioEnhNpFQkAMl5RL3uYgbKq
 xgA8knrl
 UtzqFCnc5lDtFp58qwLm9xBVKDGudPpmdlDV9ZuesySsa6d97CQ5TFxBXJkTUq+kINr76DLE/Fh13r8fYlQpNhnUqwp5+D1mbwEutC4iAKLDGHf5gI6PYD3h60KpPhA3FQpj9VB12exSxvUPKtIwcT65r3GbPKW1gPAYrdsHOM3MBq3W3+lqWZTACO1S49Sk+IPc0dZpnI+HGTTkARa9JhUHJzwefovfsu5CsgG76sCpUjeKQdsz6RuUgkEc/HbySEgubzcGgBfo706+a5MCQfa9ntQAq/Nkp7gMyWnDkyGUNjxRsvBcsxswEST36sJKTB5E15IaDFDmE5WBbtEYqYn65/dmlFdQbsDeGT/QQgeQvFEeyqi2PaEhPBJqxCIG88YdyoGKgy0YIiGBEtAhn/GoA1FCw9WhSvpSiqUEtk8Kb5Dke+7jYMCJ0OOYzXC/GR08/7cNg3tYP32to8DP9lKzDBxZ0wYLhdd0ZZ3P1NRO6Nz4WKhn1ja7rcrd+ulO/5Nd5JlgwQXu0SXA=
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
2.53.0


