Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C563606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=i0WDMFuA;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=7mhh8fkl
Received: by kanga.kvack.org (Postfix)
	id 29F0F6B05C4; Mon, 23 Nov 2026 04:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276176B05C5; Mon, 23 Nov 2026 04:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166156B05C6; Mon, 23 Nov 2026 04:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E157C6B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F1B51607AD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:33 +0000 (UTC)
X-FDA: 85465881186.01.D55B45F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf23.hostedemail.com (Postfix) with ESMTP id AB552140009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=i0WDMFuA;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=7mhh8fkl;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf23.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426651;
	b=DJfPG6lgTCF2z8EuTwbRWGhgYPG65jX4qzdXOzoH3G176EE2WugCg6N3otYb2eeOsJ5F4F
	KDlHNbrbHj3ojlUCOW7z04RU2ass+fcaarPCavB0d5XxNH6LaB9HpiRmcs86iU6fvqbmob
	K82dyA4xxAvzqcwCVqAoyuW5sB8nSJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6O8o4jPy1JR2PVJ3l/7YMV8E/5cyWIFMpsjiqqNdK9Q=;
	b=J0poRy4gHFoNPySJtXEN8gIJZXoKr+gmU/RukTy6KxJA77n/nWzRSd2TYyqwy2OtHl1hJ+
	IquRfQKNRVma7vg0WYfXhwA/XCZGB591N/wuCujUBRc2AWv25aB8Is4CbrMo7Hn+FeO9gx
	ZQYPnFluhJk3LXlkw7PQnrsCgNmPnWQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=i0WDMFuA;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=7mhh8fkl;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf23.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6O8o4jPy1JR2PVJ3l/7YMV8E/5cyWIFMpsjiqqNdK9Q=;
	b=i0WDMFuAdZ2j2rOtxrd1oZv/FkA8Zp0c0dAMiqHcxV9AQMvw9zWWBpAXxB01tlEHVKbl1c
	xx5XliI8ACdB9yBxdxLxGu7qzryOwbaFbW+i+rSoV3DxerMmyEaAO4cU1vDSWYAIXnfHvO
	21Sr6Q4wVLZzwo1Ob4tWM6RdWOFnjfDFcFmHBXgHfCeNVASJ6MpDdRqQ2Wb+MOX+6Ic/Zp
	oPsmXQYL9M79ldoIbg7c+oq/fVFbvWgqyoLx3myysEdv0KsG5lTMtACMg3B5SbicTWQUbG
	l5Zo+jNl6b7uMJwahvcGFmmIsImP3IPO3YVAJTn+TuAcogVLzylegCP7rhZmlw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6O8o4jPy1JR2PVJ3l/7YMV8E/5cyWIFMpsjiqqNdK9Q=;
	b=7mhh8fklHnCbzFB7I+Q0iexBgbzBVixkvY0GBhA1YVDTjzBQjroLWJYnoRr5gGZ2or0Rlj
	Kd3zBjtkngEuJxCQ==
Date: Mon, 23 Nov 2026 10:37:13 +0100
Subject: [PATCH v3 08/15] LoongArch: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-8-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1767;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=vBs3VQQa67rpUmE2rrBLqD26Zpyg2BNszpmqddnCDow=;
 b=cLRElbxW7EhCUz/xMdMTbFBzL6Lski3xa/GSrklt0Zpdw5U2z1v/lmUutRs/DZrC5RtEPdqXP
 iJPTytwMCD0A+UQ2BgjEc7a7FwJHbB1gtR61Pfli6wtUhfwog+Lxafo
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AB552140009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: e1regj7gthdzni8uuaum6dum1joxqkdh
X-HE-Tag: 1795426651-337854
X-HE-Meta: U2FsdGVkX18T0JDNICtTz73SllKFeM1/H5hhaswVGmfsxEkeFxk5JVgoFz6OmcuVURWBtTSTgn3oUlGplrLNox83663/Go+dad+SDKanunRSRDcETDdD4Cb7Wlm47rHII2xoWT7RWskTsNvfXXfUbm/XVm46t+migWHQhwh2+WpzsdIyCVHoMIAgSnGXcwEG5Yg40ZL/0MTaPt56amZoB/SWuQPcLQuXp3kNDZU+ZFDBwFVKncnrDf8PSCBQfxgNUF4LarJ6kDR3J2rgAx6PS2u74dhFIUpclRWpHfejh2omaV6eIP0AiUJDDeDRScWZB0BCwtikzb/QKW1gxdeLnjzG4Z880s7spKr7ZgN9vOZCJj1ShmBV7IBzEVsUVDYrEn4Aub+BwlmMO3HNHF2KtVc5sQV4enwpvE9mOO3Rrh3MmuGGyDAk+GXMjnPU3HgFCxKA4zDIbJEVY4avBk7vYzwwEPoips+ZohjcHtp82psXkg5MH9lznhKaxtM8F4wT79GPqxKtKxgW1gYUNg1tMIWpGtCUQwQNb+SwGOQIe2k68ye3LuXRLGrKnsFEOqd4DlU4ssHef5upjOzaJCBzYMX7fYVADjOWSzV1K/T4FHOOcHduT5ccpyUF2yjAXaKem0MgtY7IDl+k0t6ivLlF8jKbKtc3Yda/IGrgelJ+H7gLiqb+9CIy17TEp8aRNcfU8m5kOUm9gEpERZCMI/rwOqLJdSCHlKMYfv1ljgz2dfINYW1PQmWKDIGYRdans3gAkuEJivqnD6AdsWpvnFRdl35mG5ESXZ375/H+lCK6KoaJPNLXrdAYDW1jnbhEeaZGG6c6DcYzgdOJHogsR2/0MlxuQNhA0hxjhXgth2VhQdWqr0j/N1trZtOguuAe9oX669xpfM1d4NjdNzHcavSCT990Rflzt25xJvFd5ThiP3AKxKJlDRZt916SHizRcEXQeyIwP3cqHVE/hV7aj3V
 sLLhPIdi
 WIHvcjmauzx9kvwzWEomkI79xhOx0B9+dkz2rZME/FKLNgS8nxPm9Z0RLD8BNc0SQpUguy71cGKIRmPy+5xn0Q6wwXToD31e1x4vSrS4qSr8mQFgO3C0WLFJwydmv+IFPQv5lemwlcd5R4fD6AoesIDOIv5GSj1d87h2aU/fJfTYN33/s0LvF/1oyoG+ALka+R8pJd0IgKV7JQC5nwGO43soq+dNiwnQWGxk8AaPFpcsJynf5LU2qrrSSVSkf4bAXocgKKAkgsgnPVS9pp+NVkS+Ghlk+tOyP/MgsxP4X7/JbsWupB+8ivpt/VuS5AQH8HhUDlgMX8heOb11g9Q+AQxvtUBH7DVxvdflR/Sl/C16uMidZxu0DUOfXSw+TiRhVxdtTnQEUDh8RSJxsy53Xp04Z5aTzW3+KYsKNU8IQB007z7i/vCbip214f/OqT4POOwjZ1pHL7V0A4zy/xqv5v9vwiRIHSRGgx/VyraZ/pcHdu7QfZdoBjhQs5mO7iP/TC6LPDAPcV+Tq8LQ/fHzekqikIsBZh6JlF00pcefEyS2he76xXYRontqSPivPbylRhrWgiTfGa/G9RwWyEXd7r0w8IAfqoaPy+BX2/OFOh+wuaWWL0vfCt2QiuADzyRUZQ4r+yRLW4ZLVUTgrQEds3dYieNLsiLyGHJjw7Y9PQV07TVGeNDRDCkKTdHolQhKjlq2GzCXyNXj0YTMJKZ/AGKrSwVzm/dfMfYFJMnr7sRwUH4g=
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
 arch/loongarch/include/asm/auxvec.h      | 14 ++++++++++++++
 arch/loongarch/include/uapi/asm/auxvec.h |  8 +++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/include/asm/auxvec.h b/arch/loongarch/include/asm/auxvec.h
new file mode 100644
index 000000000000..37dd717a3a22
--- /dev/null
+++ b/arch/loongarch/include/asm/auxvec.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Author: Hanlu Li <lihanlu@loongson.cn>
+ *         Huacai Chen <chenhuacai@loongson.cn>
+ *
+ * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
+ */
+
+#ifndef __ASM_AUXVEC_H
+#define __ASM_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
+
+#endif /* __ASM_AUXVEC_H */
diff --git a/arch/loongarch/include/uapi/asm/auxvec.h b/arch/loongarch/include/uapi/asm/auxvec.h
index 922d9e6b5058..79691c422c7e 100644
--- a/arch/loongarch/include/uapi/asm/auxvec.h
+++ b/arch/loongarch/include/uapi/asm/auxvec.h
@@ -6,12 +6,10 @@
  * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
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


