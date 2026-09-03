Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62957C624DD
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148AC6B00A9; Thu,  3 Sep 2026 03:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAFB6B00AC; Thu,  3 Sep 2026 03:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66B96B00AD; Thu,  3 Sep 2026 03:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8F7A6B00A9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6691180159
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:35 +0000 (UTC)
X-FDA: 85171656150.03.463E28E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id A55B420007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=JRAktFNX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rK84N3Jl;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421293;
	b=fk+mkcp57I648H3NWSCk9w/ukDSjuKs5gwq0m7h136UDee0AFqtQQIEZmwcDdR+gseYe3x
	O3N922W7Kg6D0+vOamNknyHTSCkXmfJpbCbXwaEGFdxaDuOhSM8Rk7578GHzdLyIedKj+h
	IkQrRvzBfUesF3GF9NLTaKF+4ZbdfL0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ki6vCDtSsDDzCEZI/NcbNJ3KgWETZe+Z10mKdQ4zEk=;
	b=ObUuwmvo0yZpMPnIalOfokoIdC4ylxC+iaO9S9DMVYglgMdcVnjO+QSObCgEXLKiYereFP
	c+hGmUBjBxoNvXxFYtAkYV79zNmDjCqtRzu0OFa0Mm8SUd7x+839t+F8c0eKNkZL58DB3M
	WE+BWCiBqXXAYTnpwu1dM+6od8+2B3w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=JRAktFNX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rK84N3Jl;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ki6vCDtSsDDzCEZI/NcbNJ3KgWETZe+Z10mKdQ4zEk=;
	b=JRAktFNXxfqlu91+k0T2FMDT4dsLDIeVGQryd6RNRQsuL46sy/f9GL5vDjkZKQ30As6CcG
	y4jIxtHNpGkyX+UhGpiNboqpvEodSBecEITblgygLwQokeFFzkr4Ll4/Kox4gQrXToVFIp
	kon8oSRUeQS9RYhfREsXXYvbviB3VOFMEYbPe44WYPcSnEZuE7YOVTEGDeSAcTLSfytBB2
	JOTRwiImSbzXdhs1ON3fmLAM3LhOaWZKK8smMIzsqPrz2JndfdBbQN+CbPhNhe8sM/Iz6b
	eANcYhOIf4zoYbsM667zurVliaQFBYG8cKeHkcXVNim7ooOJoagfrjvMhfBmMg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ki6vCDtSsDDzCEZI/NcbNJ3KgWETZe+Z10mKdQ4zEk=;
	b=rK84N3JlIpaV6T1bzwKE39uGn8xsTCz7f8WrxvWFFv+kVDj8BN/3RvEkemb1aT2Nkwh7du
	noB85/lLZP64wTAg==
Date: Thu, 03 Sep 2026 09:41:22 +0200
Subject: [PATCH v2 07/15] RISC-V: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-7-5bc32a71e3d8@linutronix.de>
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
 Paul Walmsley <pjw@kernel.org>, Andy Chiu <andybnac@gmail.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1597;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=0OrggZCxf341yuayoYgLFkIud/BbXPm8wUo8eswQB68=;
 b=zhOmyJcp+hUlpRYlMOMkNTdyZ8WTdo37I7acj8KYZ6OLWoNxxSsviLjOF6r/Sk08e+CLGGGht
 PvbTNZ2WTwDAQepQqfT+Q6q1+uLkzHf02DaJ7pId4DOxwMaHCCDF5eb
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A55B420007
X-Stat-Signature: xgyns4pbkmh8qd35s7ehy7u7j97sr3g3
X-HE-Tag: 1788421293-362186
X-HE-Meta: U2FsdGVkX19PdiuQNYlhIIjgt1UmuMMok6iwiaztUqLo/vpIAAlotR7mN1ZWVP6r9w+fRg2CLRuWe6pTqQFZBmugsgBGsdoqbrqjZeaVVl6NiIYNzi/118WWxJix8fQzP6dJtMKvuOaKPE4JzSr/4V/kmPUKnQ6ah5jljlrD1hUgzeG8ETdaz/af4CP6S80ylDIi3zu7M7kHDBXb8EBQJ9FOkNS3NC/QH1L6YDhvvxiroWxoe2vBIkNl7LsdVifSWnI4mKpn/A+/m2cGb5jUVJCzYEfiiGueg9amCObA1bD+7L/Cs9B/PP6cAOqA4prom7Y9e0rSaLPMbTRd++NK8BgZuiyShv2SqTiQLPXHmCp1YpENdkEOypZbizXtwfDE/GJyaVWgKcgAaDPs0ZHewyRYgpprSWRKSRWxrOG3Ni1ETqzty0+KGsxhAx6n5jaWSysmxTIGK3uofPfFf93/T99X8vUzoLiZ5+BWxgp7yvk9L2jkqv/PCDl0sxEkzl5YtczG9pXK1P9kyVlOiwcJUdmj9aSEG+gwYHo6VEn1q/CkjYXgujqmI2lNL10ohFYrFD1+YmZybYxW7bMKamKsvK7I1FQnWvdFVeg4lkMWqVrhNGHlIRSAmmldCC43WqzM/oPbpCi6p82djGDPIu2ybOA2vCWHOiNK2JalB2eLkcE3olRIDes9B2maQo/qu2mKI5SXwq97XieIrHTPq7FhvMkqIoBI6E/ZS42b1Bz44/RNo6orBeyijgYrTXxdjJz0tHZ2D50hDWIwr958vosMLDtT1oU9t6YkQVm6aVP1tTY89/2nahdxAUndNgShPKO2LiqftVlQYBd6k83Dj14SoLEleQk+1IHrjRRf8a2pp9ShrSkptr569LLIxd84t5wXTU/MwsmTmuMa24LODLySouG9KBcJ5+1/JvHHlT32+d+kSU2YrYQYHeShLNO9g6T1q//qPjCt1veKboAvQsE
 y5WkmpNx
 rI511fQ8CErKyHhs+4sCQv+tKaCtpd7uToJelsRyPM7ttqHLdIo13bxeS9AEv88XYpfn2XcKm4YQV7f7ONUpWhNuuzZDPEmZG/jqu2+HU7hb4jLOCJN5tc0Et6wjIy3zA0Ixf+D0XzxyRWCNh/zekhtD5myaOh5NZMcJgIYBDeQVfmV3L6Ud/oTm0RoRKKMp5cYyi912gRmJVUcjZlpYmlIuIpJVRDDzAHtyPOIo3/n0JKLcazYDj3bYuKihI8FL5QOufaKS2f0jnjS7PNHkfzy1OYRPX8t9gmRve5ekSA97IoNNrPqULJkB4/jcf/Qou7AHctUdImPxOcqFOO+lIdTPUX6i7pe4LQKzJ6s3smC4X5SZSXd+MFvpoJjOcpee66u7L1qGJoTWhcAvcKsAser+unrQccgJfpSGnTO0zJlmJX2lRXBkoerbrar88P1hfJ0Z5OsaCwOcJwdlIw1x2MKBaz81DWdOoZOw+Vi6nJUEKGDSpOrEp/ptqRErkhbzryP26Q359amFsLYpEI15nn8Zq1Q9wxjqVOVigJWeaMxvwhwmi/EwHlQFYNFD4z5IqK4ZL
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
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/riscv/include/asm/auxvec.h      | 13 +++++++++++++
 arch/riscv/include/uapi/asm/auxvec.h |  2 --
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/auxvec.h b/arch/riscv/include/asm/auxvec.h
new file mode 100644
index 000000000000..fb4233445276
--- /dev/null
+++ b/arch/riscv/include/asm/auxvec.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2015 Regents of the University of California
+ */
+
+#ifndef _ASM_RISCV_AUXVEC_H
+#define _ASM_RISCV_AUXVEC_H
+
+/* entries in ARCH_DLINFO */
+#define AT_VECTOR_SIZE_ARCH	10
+
+#endif /* _UAPI_ASM_RISCV_AUXVEC_H */
diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/uapi/asm/auxvec.h
index 95050ebe9ad0..0a725f2aa2e7 100644
--- a/arch/riscv/include/uapi/asm/auxvec.h
+++ b/arch/riscv/include/uapi/asm/auxvec.h
@@ -33,8 +33,6 @@
 #define AT_L3_CACHESIZE		46
 #define AT_L3_CACHEGEOMETRY	47
 
-/* entries in ARCH_DLINFO */
-#define AT_VECTOR_SIZE_ARCH	10
 #define AT_MINSIGSTKSZ		51
 
 #endif /* _UAPI_ASM_RISCV_AUXVEC_H */

-- 
2.55.0


