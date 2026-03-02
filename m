Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E59E9B36D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB466B008A; Mon,  2 Mar 2026 07:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE5B6B008C; Mon,  2 Mar 2026 07:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E2D6B0092; Mon,  2 Mar 2026 07:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 347336B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E82AD160B54
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:49 +0000 (UTC)
X-FDA: 84501044418.29.41EFE6D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf04.hostedemail.com (Postfix) with ESMTP id F165C40006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=VSTpMZSg;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="G/2aXJAd";
	spf=pass (imf04.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHIzJvF5KQOpwYCYi9ql6W4HspVQ0yjpDjp6mM86yJw=;
	b=5UfuAbyxpZYS+KYk7xNxz8H4NAGpfUB2hC9d89EcwVwBDupYb73xh81R6jxSjNGU4l6+5l
	fkA1769gnazJNImXtzS3rm7qlhOVFF6xRKTM56qhTMKt9w89fG5Spmuls5pSME7wkKhsjq
	NVnjxaM4mC4g3Sk293OD/bA6T215r9I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=VSTpMZSg;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="G/2aXJAd";
	spf=pass (imf04.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454348; a=rsa-sha256;
	cv=none;
	b=7uWUqeGip5VUzGctoS3qg4Ly/Mk4Big/K6N6m5xPzGlsLk/jX2Q9rPJf/dLcvNkSV3/Z4D
	2Vm5hZPfhO46EqVXc35NIz3uF3snygFjTPuHB4+PmyYAQxoteb5KBUfde18cVl2Qau+6fo
	DqWLDtEt87WdApXRbDMOWh/f6WdvuKc=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHIzJvF5KQOpwYCYi9ql6W4HspVQ0yjpDjp6mM86yJw=;
	b=VSTpMZSg42IpjDoyq8x9+eZPlsHoPorC5Yp8YHj4lKeW+Q1Szd1xOG4fFF7EJLwDkmEElh
	Z3g2XNlLUEQXFYWtT1wTzzVrlTXkuKzTmGMw+x0EqKJ4LeUXrjJjJz9lJnK+89gpq3WLGy
	oN1SPmqhXJjTI1F26N/mPppPlsn4jQGpTDBXT0NDq/8fxvXULJkTzM2tpxTQVwaHLcuW1U
	Ae/LHkrGix4F6TnO6aBb8sxd1YFTkcIXW+VMaM4TNsJsrPLF9PBIQ54+mKt8MHtaGAITcS
	B+X5r0z7pzo5rFVib7xx/JWax0hdtUhV0alQE1QY5Ha1BrzXLHxtWhLz6E8YJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHIzJvF5KQOpwYCYi9ql6W4HspVQ0yjpDjp6mM86yJw=;
	b=G/2aXJAd/neq7Iq6LG5EvgJJLTyYQF8QAAaiLOtne55+AhOQkYy3dDXFI4V6jUcj/tzh18
	cH1j7O7IEeC/0FAg==
Date: Mon, 02 Mar 2026 13:25:27 +0100
Subject: [PATCH 03/15] asm-generic: add an in-kernel auxvec.h header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-3-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=2425;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=juGti0dpwtScxN3ZOParltAs+5PHUSX08Ot1ja9jIhY=;
 b=Xcrk5dRYDUnYdF4eUZUFljFjwJQobHGx53H0FPFSGhAS/a5w0rdNpYo278IFrTj31KWMPplHV
 UTZtJZTy+WEAZQyCi2JwlViZJY/10n5lJZhKwTiWSCLwCN/M5GCwyen
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: F165C40006
X-Stat-Signature: hq7ez3fto17wzbhhn1shoui15c5t1eg9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772454347-465979
X-HE-Meta: U2FsdGVkX185GLA+/FcJ68/8ou/KWZk+zWcyBqQg/9lLUeKSocwbazRhvy4/toCHlns1VNNqqqDtaPEQniscoHpxQ9U4X8EPf3ElR2YdocVlUPxwvWpPJQYhBLRZEitd9Iw8OznfAoeE6b5N5mN0m/5nOXXVRtjz9dEdcIyPMPypphMniA9DxHlxzckUED4a69yT5MjmzNCbpNWDqoH66uPt7rzGTxuWIVl/0J/R1pfycr9wpMwRMwN1I3u6oB/oyV+0RAhJs4LEPf1OAVo/uo2ghvJXM4M0S5OoHcpdRmHpGH6EOX4z7WxMDZttTmZRmrSEQ4RdzUI0GCW7RV8tqBZRLUNDXn0S7AC9+w5W24CZhbo7w4WDfYDnek3sDteC+FSC0RGdcEuycgj3SvADMwWobU8zky8PiNo1vcxs4icVXMAHL4DgrkUqUVnDcxQoGDvU4XSoG9HSGFtlEiM4Qn5AkrLhPEUnmomgU17aQ8g7mdDYpcm5ygoZffGzqWkMICNR8cXyfia5bTeTehvyVLqB0NYwn1JLjomLoRDKGCtdPSqlIwhI5rp0nQszKFGasEckdMl8TbLL7mMVUw3/H57LR50YkccG6d2bqQd0WncJ1Q1KhHvB+yiWllr1Lpxse6Lwmyuvcx/1CHIvRB0HjJ6ZVehJoP4Z/tP24fP/dce3Tmf/ugIcfsckwNYjAMHWM77pPHlqltrwpCd0y/wxG6hvUoLTM2EN7Fxxvp0yznU5bSB/vbJg9kxmfuU5mvodxMdpw1kemBhay8wN/ON94XSNuRBqq/+MPbjumgIBnEFYBekn/H0BBD/1XArKysOGB44CeD/dFBzppA3sVdR++/YC6f9pPyqsKVjvoMm3zZ0YoOMmB5EO8rADWDNODk/HWs8IzQg1e4F+U9JF4I3AjCPKbDSEeznozo1Aj7xC9vrXtUefXe9/12IjY2zD9bmwiY6o0aA2Y9+8RxNgF40
 Rce0jD3v
 DMRDdL6jjQ7bJtweLjOlC8JXhdCoY1o2v5763i3SsXpBT8IQaySYfZTtnqu+0Zgdh16Lk8u1wL+yuHbOVzIipImynze+NGbSklW1mkVQ2/PWVEoCIbgSQjsPBR6tHDcm4RBsFVvSdV28HCgcVpsmL/IVY+X3jh4N41DJ7fOTeemrhtxR+smp8zfAmuAd9q2L0UJ9xh8du9ZdKTt1O1aHVBH+PsZcMvmR7tehuF6AW4HLwcb9BG7fSCPsjI5dKcEoKDBU8tVUHjxrLTRH598TailwJLgIlzKyQDvzannY0LDnNia02j5dmjgXlXYNsvhssNhx5VwR68fccEJKqM7PyZv5V+o8tVk6Co9xch4Txv9SslJ/eCok3yL8GiK1vPP7VviT36lDkoyafQBf3HUQRA5u8aWCun/lQktR01NolJZCcHpYz4GGeN6Leghr62oRXSJU74/FCNj79AV7OIYR2J2vaewO8TwSORhAzqz6Ujag4OMtG7LR9kHkqMsf2W+h/5ZWWdp3ys7HR0tVcGXNLURlntQVjTSKCkg4D4V+2rh4bZpwo4lpYe2o0+ITjpN0oUsZS5NZ6mop2yWlhHgveUecRbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming changes will create architecture-specific asm/auxvec.h headers.
Add asm-generic infrastructure to handle the fallbacks for architectures
which are not migrated yet and those which won't require their own
definition.

Extend the list of includes in linux/auxvec.h to cover all potential
low-level auxvec.h headers.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 MAINTAINERS                  | 2 ++
 include/asm-generic/Kbuild   | 1 +
 include/asm-generic/auxvec.h | 7 +++++++
 include/linux/auxvec.h       | 2 ++
 4 files changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a2c952d72bd..239c4e3ef5c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9573,12 +9573,14 @@ L:	linux-mm@kvack.org
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
index 9aff61e7b8f2..756a991aef67 100644
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
index 000000000000..e4abd2a8c5ed
--- /dev/null
+++ b/include/asm-generic/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_AUXVAL_H__
+#define __ASM_GENERIC_AUXVAL_H__
+
+#define AT_VECTOR_SIZE_ARCH 0
+
+#endif
diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 943e8b80b41e..68c9d6b118a9 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -2,7 +2,9 @@
 #ifndef _LINUX_AUXVEC_H
 #define _LINUX_AUXVEC_H
 
+#include <uapi/asm/auxvec.h>
 #include <uapi/linux/auxvec.h>
+#include <asm/auxvec.h>
 
 #define AT_VECTOR_SIZE_BASE 22 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */

-- 
2.53.0


