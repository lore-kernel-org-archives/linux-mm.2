Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A768606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=TyvVEjET;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=UeyrNx36
Received: by kanga.kvack.org (Postfix)
	id 3D86E6B05CA; Mon, 23 Nov 2026 04:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AFCC6B05CB; Mon, 23 Nov 2026 04:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C54C6B05CC; Mon, 23 Nov 2026 04:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 037AB6B05CA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B2CA14031F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:38 +0000 (UTC)
X-FDA: 85465881396.06.0B68C4F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id E55BE140009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TyvVEjET;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UeyrNx36;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426657;
	b=ZRYSH6yd6OsxjDd3CcywOHtjRe3ijRQyG04Gm8Yh+9bCfQXOv89bE/pwy2S5Y3xrgeeh+S
	yYb+Z8T6QM8lKj7xuDMRr1DOmgAk8tGE4hyo6WR0Fq7At+Ej5AUqodTWae9OAYHDYCyAAd
	cAY/dmsy5N3wAZhJn/19eXVZup74JXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dp9YyKBWCSEjb6xrb6VMG09P6jqIzXjTgw7J5S2fTA4=;
	b=1jYhNvt/PG2/IPK5Ati0w7W2DVF6pgtBP0bE66Xbhg1qDDTx/9r500ScQYDygX2wWjsdRq
	JXnHd4Ophz8ynSEz4reKcNUbyGeR3xH8XA9AcdPf3RSRgD5aPHaa6ptf1lIt3/PbLm1Xlp
	hmGWdvt/GKauVIwcXy7TeKxrICCiKOs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=TyvVEjET;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UeyrNx36;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dp9YyKBWCSEjb6xrb6VMG09P6jqIzXjTgw7J5S2fTA4=;
	b=TyvVEjET6MQnliSzrqpnj+WkaFtU1zdWalGJrq4lM+AG+q+GryJ6uLyXM3uuKuMjPwI8Q7
	hXW9l92VNUnHMqFEWfhzIP/+ank7W2QypcCihnx37IfZQBhZP3LFb7GNb+YNj3CHfGSbs5
	ZhZR+iPlg/bcytywj2VDrgqzMWW1DBlh2cJuaI/J0WVIFHmyAwJi5zM/82k6QefOlFt1dz
	tg0ik+MAZFWoUZhTqe87bhvHbNeg3maMBV/cDtE0aW/fZiImJGJWeAXysA5to544DrSSxJ
	G84S2kJq5OpbCqnzmKWFT3UfGcp35UD7EOdsH8gcGg1UZbcf7aAajTe5p6hbsA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dp9YyKBWCSEjb6xrb6VMG09P6jqIzXjTgw7J5S2fTA4=;
	b=UeyrNx36ELx+2TKAHU7bC/JsVRcYrQLbDiG5FMpmWcJSPNqa84GS7ohHzM60dWu8RXOreK
	Iht1lJnEMVjGIzAg==
Date: Mon, 23 Nov 2026 10:37:18 +0100
Subject: [PATCH v3 13/15] sh: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-13-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1608;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=ztfIXLUSH0CwIJyGBvoNgGeeiOG70QOYQ4pFqwwxIFQ=;
 b=LKBQXJ0mP2V6uYDx8P6XIyIzFshAJA1+7kRDjBNYWfzYxsdonu5uj4s7DWGYZrkTi/6jZXHLX
 /DLzlefFrAKCVL70qHWqHj3o6sDBv0xorI5veF399VQjaRzOqml8CsX
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: bapxuqke1bes4jupopmpjtnpum4jsne7
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E55BE140009
X-HE-Tag: 1795426656-734926
X-HE-Meta: U2FsdGVkX1+7oPIRAJSdT5w+8c4TRcMnYmv/fJl3fhf9AUNl4W5z/V4TJiMWfqmEeW0ZPKZqBZfwYowbvSnG+wSuWbm0l0pNuwW+HGwOQLw4gplTV+tWVhxDkmJkJzdYQ7x93vLij+2tmRSsSCKu13bbk1ga1I9VM82gf4E/0XN2Dp7IC2tYIlwbD6BL6YQBZCdFuiNYv5Mnsgiey9o5GC3UFnVABalLESQQU4/y08nLpW/BAV8o36uGFYcBoLNVELn0ZMwdC0HV2eKYwsKKX/V9t2TTF2dOKhW3H43L0nrIw0UzdUTrf4qbuH/HHLmPFXonoUDwsSLbg6MlDrAGD4Jk0CT0WnNnAPj7wtR5BFvvu8pJoMkGQfNab97EDxg5NFoLfO881A5Y8h2Iw6zVzLSGFtGujuuiuOW/V9pyTTAqP7MejBrMDyFiW8xAp/q0ZbuHyqPadp/WGByLjPmiOOIggW+n2yGEznsUkg/5Hz02YQ0L7uj/YemE7Yubf8Enhl34I2Y5lE4t+gkNXxoAktaAPg4f0L8GqOUgS+mjtaYuD7eqEeX9QFjVdE96xXYg/a8ZdUCNdH6JWJrJP67nLDXrMuOP2MR+BuWvzz3r47h0RJSkPvN6LdKzWyB3zgtjngg1XxJUzAeTyE4wjU/PHHBtrIxQMsRGdv9Tok7rkOtzBQGDM56obnfe9uIUsQEL4ZX16UBea/rsd1DGuRy3+Rk1LbBx6GGoCkah97ND/8yuXOnNQ0RgpLOtQGM2DH8jLUNBQKNsMFe0SQqO8TwjiaJwJByLQLx9YjEC9Od6um8XvHf1ZQKwykCQM+TgtV7Ox7mk4V1QirgmNIRuWNlrDIuTb352heDI926MVCAO93vpjl5DgE+8fK/QhgRTzX+e6RrXCdPXdF+IPGn756XKcOUSZZ/GydpV5q8JstroCPqCt6QwS77VpSx4phLcw1Y8dTS1ORqFyFhVFrWoGr6
 Ca2TwSoF
 +VuR7lCZWBdI+jSHT8tlCFVQcEqT8I2LN8DQjAcnu7/9+WrkApi2ckzf+djwXaA24pNS4X3tSazLrEsbd82m+IOj9ZJuH7VVrHtmJpxzbRE3nS8LX8lAXJWNGEwCwY7K21HZye9LPuuJlJc7Vi4v0JmlxLupntojNm0N2f5IGexGcVNDmXB7pOXXyL/TjP7WDq56XfMwo1WuAl3B8o9flEzwIznRDQPRkDpOi4adrC+Fepqx0K+X7E1KOgDvAW3csHuLcYV1dHiyTeOeAtILf+2O2pdGJQ3dULaXwZSv/27mXmImugaRI26HQ5NoW/qAHHA2/hUeP20MpgSXXGA5HTKP+sFLW/tZqCH3DgCTirlJnRr/lv4s9Q8I6HVmMHZVVzGEdCLqvkSGCAGvxPGianDGNAoMlVOMrk8VD2KCc20Of2zkslDJP/Ei+qT5xCRMbzsYhMI1yrtOqd49rniJFRTYdVm0tHTZMwHWCYfxDHg3JsHcZ14Y1IQSYKieS4pFMaY5jcPaPHBtSTl0/7le+KqfpDzkgaM4ps7MROfQp56wIlAeH1iFWFoUB2jXNmKQHl2XqYsLa004+yQ9GrrI/geshtA6g2wMmiY1M068YjWrGma9vMhAXoVhtkuS1j0+WwmlEdh8ZcjaIvQGliZzkTJcfSOlGZIly8OyB/tGiqSCKvBwY3kbl2S/YzepMYM5e0HkUJlVPJBcxgU1oigW5kYVtkz82coVUc+jnKvbUGlU0zIg/Ge4SzplXW3qby9FjqAUKFIksm4Wxuxw=
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
index 63fcc39e2c6a..cf0f13da977a 100644
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
@@ -30,6 +30,4 @@
 #define AT_L1D_CACHESHAPE	35
 #define AT_L2_CACHESHAPE	36
 
-#define AT_VECTOR_SIZE_ARCH 5 /* entries in ARCH_DLINFO */
-
-#endif /* __ASM_SH_AUXVEC_H */
+#endif /* __UAPI_ASM_SH_AUXVEC_H */

-- 
2.56.1


