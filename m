Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F3860A2635
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=xIytSaYS;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=2Pxz/VbW
Received: by kanga.kvack.org (Postfix)
	id 7597F6B05BE; Mon, 23 Nov 2026 04:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710B26B05BF; Mon, 23 Nov 2026 04:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50EFE6B05C0; Mon, 23 Nov 2026 04:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEA86B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC0DDA84F0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:30 +0000 (UTC)
X-FDA: 85465881060.23.819ED90
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB4AA4000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=xIytSaYS;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="2Pxz/VbW";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426649;
	b=XFUbEWkHZXTvDXBF1sgvdDlgPwXHcahlw1tloBkw/l4J+2c3R520j8X7KPpxMmFT3hTKYb
	gTP5UAqosvLlAkXWTuNEr1d5XaEHqHVG3SFKzH6dmlA7QjzS3cF5u9Zh1FDNjfw1d4Qv0e
	mlhM+44UJKo4eso6YyEO7a/TQpUxWNs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCjIARJZuyF2MKvJaqs9gktLzUWSriQ88u2CMxFe+40=;
	b=PDQ+OTue39r73jQ9BzyFoiNwPDklXdq5sB0aCcgi0YCjaVyVLoQAA41T8u0bxdaG88OMvk
	Twh8yCh2AvPlr+BEhb5kYIHuNLryPs5O2CVpjz/7HyDn83Bi5xn1kx9Omd632kfsX3YxYI
	K0zl2ffe9vxLOXTQTRt/jv/7aI8yPHg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=xIytSaYS;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="2Pxz/VbW";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dCjIARJZuyF2MKvJaqs9gktLzUWSriQ88u2CMxFe+40=;
	b=xIytSaYSFHN7/y9Cb6dzhLZoJdiOyeCxL5r4X+xqU1KFQodlzXHZ1+mdJGSlR3PQJg/1Uu
	fVEOi0x/TStTeHc0h3jLEkDxpbGD04A8mgZYbnKq9zmR2jvB8zm/yvcNnKATqqhSeRE4cs
	rbwbg8XerkQgAhVy0iuT2y0+x7S4fKS9pkrVkrtuYk0suVgPk0rhV4B6QeeuRr1V/2qiJK
	jJLheGc1xc/Ka1IE87KoIi9cqes27CLdqY+GeL9LX9NWEBINRVASPjjMH6az7WGiDShQU+
	qo0U9lTYqdekyvsiFR1cd6CavQlCKnS4Hj5w6SaaE4O6EZFYxKYRLwFmcf1K/w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dCjIARJZuyF2MKvJaqs9gktLzUWSriQ88u2CMxFe+40=;
	b=2Pxz/VbWqlx26KJWhfHWSW1lo3/0I1ylQ3IrkZhGN8RmXz3hJdqDbSsE/kFGz+dsGZWEYw
	0UR9RJ8W7uv7rIBA==
Date: Mon, 23 Nov 2026 10:37:08 +0100
Subject: [PATCH v3 03/15] asm-generic: add an in-kernel auxvec.h header
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-3-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=2500;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=bABQvj2R57kM1fjG2HzTA04qWWs5Q4Mt3h+20ozb1Bw=;
 b=c7YPyzew3rWzJzbI2YP0fm7hSzzpwV/lGlOxq0YhZpLxMX5aMMqlW9Ut22ftoTisF/UfC1sVF
 xSIj1kgJmJ8AVkpAm3KQ8rGCCmbjRYaF6z2sQQD5o8/QyTjOH9GD+al
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: yey68se9hi6e56f51n46q4tas1ik56fz
X-Rspam-User:
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DB4AA4000C
X-HE-Tag: 1795426648-746625
X-HE-Meta: U2FsdGVkX1/4u6mBatcoLI8HeUs9+HqksJx3yXqtEUiOLv9AIYCG5GUZOuKmeFrVqnKfH5oFKC+PxH752M69LspQhKpZYHVNlSTCjnfOeumtO3wYLBsI5VoFbeL7tnFsSE+RGrTXQ7giyaheeRWoemgHZu0DZu8snSX6c8NQ0ScUMti+XU7kAiqDH5WjF+J1S0Z+e+Pvp/uA3l7fshf23Keg5S7mBLrcQvgtPR4ZTedDf8gAqVS59AnJTvF1aTs+yGRfheyealybUvSTBAyFKVpDHMVy7OlCPezADZbishH827FV1nRaiICgTLP/xGFkQNtD8azU/ac6ciK7Z8ai6RQi/sC8dFcxkuG8M0AlKO2DhGBJdDjKUSHEKnkP3am277GFQLko0ff1HOIM/LWkceMBAaxYp2hMvZe3tihb5KPPclQVcztztHqRFOB5/8VbQaUw9QXO4LQ3uP7uYcFpBQmtlhWdSEx8L2ysBCQHx5MsFUj/5PHTWqz8tQuRO0fwnUjIYv286TIAx24CQc5qH23fOBDAvOG5epDqdqyzilPXYOpuy5Tv/8YANHgliGCBbHc9wzRaSyMUeTPtUnF1zbjMlHwCuRGphifil+oHGW8A4SSbOflMdv1FZdkCqUOyiiCwRMGOaFEHOd0oiZBCKUdYj0PfYZQ5+jMkYD/4bsAXKe2A1nrtWIXTRb1gTT8r5pbxW3V55XLGvAd7izBo3PaR6JmBpKyja7OKyeoPdW26G1ORKM8ZPvrBuk4S1rSrA4LzmyEwFd6uqlBRcHHcdVsKZwn1Ceo3FOvcQoT9THOOSu6olDKTu5cMzqEpZaPj/TPL46f0ttTC8bIRagg5JiHL7x0P6f5ARPxGCn0aFwnXV4fsVrHE5TZxWrFlc/HYD2jt+jC3fG84pBS+gOGT+jqGq3SnAdIuMZ+nVAKWrBapGcj6uhX/TZemLdQYydnMsFeafuKSXRyfi3WVw1R
 e5sOEhXl
 onRa2LB4ElHErfJGql7/CdRq6hr5QF8MJ2TkZQnPGzOHClxSQtxGzt+OAKOVrmD85dJIDTLTTo7yaLjmtuC/NUcb/E00/oSjhtJo7juZ/nzbxjuuirHkI+73S/mgzBZjncktU18MYI2g9rUQouYBdIdGIUjWEI5UV0XO5VgQilrtto3y+JpKdTPYputKJYdE9n63GdHSiEx8+m7ZPKKdacgf7wCbppeFUrF9MGTCIdenhZ2BpIOTIBYpzba0Twz3RQRuU/pa9cuWsBh3khWeEP4wtyg1JggyC+mcsC1jvjMyXwNkmEnUuQONR00DwqJFgnU4s5bpAPiUHaBv1rXQbmBXcKuOgdGzXc0ZX9coqXQS7N8O9OXYiYPilhyOC80w9o/Swu/MuMCN7vxwxx+Yjqhd5ldO7Wil4cXGjx/9J1DGqjn0LZ7L15nDYaR2YiXZYSRLgOEcoyOpHwtHmXHHnDmVT1+YZG5XPV7W2BMUsQlG1Aoujwg0xcQfidhOW9zzidcaq1cCnNh28nsyrDuC02n6VR5AnFtkr8sA+f74uvGsP8Hcz+YXkq2wIlvbMFsWgZKDfHJtIIfDR2B3lwEnQMfDuy91DLrlBtpQ8ckWXG6FIRE8Dm+3YKVY/ORghORHvVELWwkW3rtAYxuZbE37H529Wk2wjzCrUz6+y0FEH+lGEHffxYxyBIL4ZHKl0DpNg2zznrQ48Th6GEAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Upcoming changes will create architecture-specific asm/auxvec.h headers.
Add asm-generic infrastructure to handle the fallbacks for architectures
which are not migrated yet and those which won't require their own
definition.

Extend the list of includes in linux/auxvec.h to cover all potential
low-level auxvec.h headers.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 MAINTAINERS                  | 2 ++
 include/asm-generic/Kbuild   | 1 +
 include/asm-generic/auxvec.h | 7 +++++++
 include/linux/auxvec.h       | 2 ++
 4 files changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a659c9bfb0f0..8cee58e323a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10073,12 +10073,14 @@ L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/execve
 F:	Documentation/userspace-api/ELF.rst
+F:	arch/*/include/asm/auxvec.h
 F:	arch/*/include/uapi/asm/auxvec.h
 F:	fs/*binfmt_*.c
 F:	fs/Kconfig.binfmt
 F:	fs/exec.c
 F:	fs/tests/binfmt_*_kunit.c
 F:	fs/tests/exec_kunit.c
+F:	include/asm-generic/auxvec.h
 F:	include/linux/auxvec.h
 F:	include/linux/binfmts.h
 F:	include/linux/elf.h
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index b7a388bef6ea..6dc54359c4b1 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -6,6 +6,7 @@
 
 mandatory-y += atomic.h
 mandatory-y += archrandom.h
+mandatory-y += auxvec.h
 mandatory-y += barrier.h
 mandatory-y += bitops.h
 mandatory-y += bug.h
diff --git a/include/asm-generic/auxvec.h b/include/asm-generic/auxvec.h
new file mode 100644
index 000000000000..b5f73f35e21c
--- /dev/null
+++ b/include/asm-generic/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_AUXVEC_H__
+#define __ASM_GENERIC_AUXVEC_H__
+
+#define AT_VECTOR_SIZE_ARCH 0
+
+#endif /* __ASM_GENERIC_AUXVEC_H__ */
diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 4b364e639f08..de1c33c4a256 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -2,7 +2,9 @@
 #ifndef _LINUX_AUXVEC_H
 #define _LINUX_AUXVEC_H
 
+#include <uapi/asm/auxvec.h>
 #include <uapi/linux/auxvec.h>
+#include <asm/auxvec.h>
 
 #define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */

-- 
2.56.1


