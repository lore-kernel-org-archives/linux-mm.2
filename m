Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761BCC624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343266B00A5; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B176B00A7; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC886B00A6; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC28C6B00A3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5A971C2124
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:31 +0000 (UTC)
X-FDA: 85171655982.03.DBCBDE7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DC3A120004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=EAotfmrF;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ds0SsmUa;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421290;
	b=6BJR3nXU4goxsTkRNM1nuyjR3tKsWzj/F1+n2sdyvCSMbizuPrlQJp6gFzHxKhW9pMS187
	6IF4Qi7lPHUsZpLdNks8mnC2yTZmUvHgLRUvSRedfSYuDCO1xTXim7lPQshHheuh6NLSny
	xPgpyKxUCaiEGXI4lr6MWNi+L6eAb6k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=EAotfmrF;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ds0SsmUa;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTIUO03+vTuzokz+0CLC3jJffqMKEhB1M1saHVAcdrI=;
	b=vypEVjK90YJHh7SJjcB/754dkpJtD4gJcTHQJHQXyPHEDJOSwr0NegChaQIm7eBcFQh6SB
	7nYsCzZkDlOZ61eVIOUvXG40tRPTJF5tUWDAd8k36DwIctEwlKsA2UpNw7OJeGLm4r4RV3
	WYDPIMhl7asQNWd6vEeZ2xH6FGv0RX8=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WTIUO03+vTuzokz+0CLC3jJffqMKEhB1M1saHVAcdrI=;
	b=EAotfmrFrsbPTUu0GtvAGP5xKeex4onVnvkHIsoxrfK/u1t113B/VDkIfcQtC8ZTyOR6zO
	kkmeP5SkZKTSVkPaaQcUL+Q4beh+HHJbJpGVSGRRBhjIHoqdI8s4/u284bWB+YCx80DgAC
	KtJFVQhplo8B8/8GOlbgnK1W0C+YZ3AekXg8duKZYajxT2pX89dgXTjMPhpdVMksBpTcgB
	ZW39MOWr0/vLLnSDDHEFXhugb7f2eoEUWUp9IjQUni2MiRyPYBuQs4WqmdNmeZVBqM3DWP
	+OA+lFOzWNCma3+pGSIsnJ4ablQqkqlRC6JaA1x4up2cN4e0WRWTBK0AY8Vvmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WTIUO03+vTuzokz+0CLC3jJffqMKEhB1M1saHVAcdrI=;
	b=ds0SsmUaK7hbdxAtIf8vYzrxvul23GNKluaEgREqtkFfgg60aDVcJOUqm3pGFw2WBvcEWa
	nRKqjPhNX/6RcIBA==
Date: Thu, 03 Sep 2026 09:41:18 +0200
Subject: [PATCH v2 03/15] asm-generic: add an in-kernel auxvec.h header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-3-5bc32a71e3d8@linutronix.de>
References: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
In-Reply-To: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=2467;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Dz+MzkOjlYnWkAvQ/wE+s+kQ2Hop+FhDIVkDntsCAkc=;
 b=ZpM1agafw8vnEzFvvYGBo4mc1Mri6kilHloCGhylalJY3bCPcuVwBQ47m1vZB5zJ4e44kqdg+
 OboO+VdSwkbC2yW6wGK+lHdE+2dw2GWeg6plS8qSz2kJau22a8VmvWB
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: 5tot8ohgn5nj3mrizrg3s7s9ijwxi5pd
X-Rspamd-Queue-Id: 3DC3A120004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788421290-287741
X-HE-Meta: U2FsdGVkX19VpoOx4FFQxT9PefRhQGalUcikaDkAPlFEbR4/PtcwfzNRbIU6xWG9IVz9FVfwpFkgHpXitjY8awDff+Z4zkReHUCMKz3m8OquEb0WhhSAS8ouFQeTobe5ct0oZ931XQmWSyIRUQNgI2HTKtV2V/Jx9YQyaej4ailCtPGjhYX8xTV0y0opLuZQA0r2Sm/mOmVOvXV1Dqko+M5WSBK4cj3/W4O1SVzPlZxD+HCo7sVAwFIBbDVm8sfpvldy9m8CoUEMrtS9lE8k2s9oo0SujH4otEvPkWU+uObY9kLzM+5uOO2uxDKDfMkmvPhJHCBgWiILlj+1L84ExdwoVqHRVrzIDTUS88hMlDggxNfz9XVZ7Q3PkKR+oNUJRuXLdjJ4a7ok17E628gjKL3NVpZ+LME720rgGKJ8HhxSFhqw8sf4UC8isDDdjBDpsxSufiLcZpuVHaMq3XvvXBPMmhUMoGIgdhytfzkN0VZD/Dc6IHdgAFQG1OQwrwquJpA/nvKbotJNYfO0wWX4+mZe4wKnEPJZHfWAIeZUMZs3Cp4ySf3/NU/CuZt5ziyjMFr8nRqtfMwpQFF6GzuLUmNRSatQbVI5qpaooQ4VOwreTY8BRRGwxkTR1G38wf9+rtvRYRS/MDdItnLqW0bcEI/b/h5KMsFnPbJTlpg+6JEKxoU3p69H6Kz6lSA/DjI1PV9qm1OZababd90XXtxANrrRAwMpW0++/X0a1HEb2RS/JhIoh9L7dFndBI3fBKYAcbduJ9UsvXEdQH5mw9mOXAH7LDw8L2OB+5F33Za07BaFoTFNLebfzKtoojxCVMlXHF5S51NUzgeWuIRzQ5M0Wx5tPlmRbKb84ZhQqiRvfKyz+Jr1xMaJjGt039lJxPVci2bWFSMfxYT8YiHnomHIyGAqy5TChC2iEmc4df0Upi5euTl30fn6ki42c8DAue2o4Ux7nDtehxEuBMAxL1A
 ePEkvUan
 OR27bR3qmbM/GlWMQIvpcDglZp3ExvwN85qNUHSMY+QTfSmJLLiUstxafJJkpUAyNRGGo4j2v3ohtRbwk0mmmfLMfSbK6OV6fVnoh6ybWM6S/H6q7YBfo7SdKZejNODtN0Eb9qn73fGK0B1aN0aM75jX7cwbEINXkChVj+3TjQMB8F5tuaoHLesPPUTEd48c3REcTrMazCBJrHWC+9QA7DNrOcpfDPE7036M8r90//KC+gzU8lyicbno1YEKBRaaV+L8W6HYJufael34Zyfjrxecv5XAnMEpA+y8lOskrT4miaxAzNyjIEiDBKwh8cgAcgpwtJ6sAVOqx47oLWc4FawwZy0+s+izlUhhkkcR+Vs6DMS93TOptdqF/g3yz8Ew3pm2HKoN+V8o/PwgYu3dVrfMW6b+EkGRDrv/kKk0ZA+ruCAx3k0GrTOejG/LioVgKcvJAg3eOm+rBYUwQZmv2Eb+gaJQZswxAprRtp3KEvh063iw83qDZP2k3XfzzonFEaJ6rRuwAvRvUSnf7HWoWTHYAqcFBOp0sDnswjWB3o5kP2tCyiqmoiDkoew==
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
Reviewed-by: Kees Cook <kees@kernel.org>
---
 MAINTAINERS                  | 2 ++
 include/asm-generic/Kbuild   | 1 +
 include/asm-generic/auxvec.h | 7 +++++++
 include/linux/auxvec.h       | 2 ++
 4 files changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 42715aea210b..6974f8dad1e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9808,12 +9808,14 @@ L:	linux-mm@kvack.org
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
index 2bc00c67dc54..90626358f94b 100644
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
2.55.0


