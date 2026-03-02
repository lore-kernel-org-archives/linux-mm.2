Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9387AE9B375
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C862F6B0092; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CF06B0099; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1EF6B0096; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 676CC6B0098
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39B33BBAF3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:52 +0000 (UTC)
X-FDA: 84501044544.29.BA98D59
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58C40140006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ajSAQlia;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=JwfnIxj0;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/rC8JaKdvarxwfXTuFmyKVLUxrMKeBR1vS+B+mbt60=;
	b=Cws1xwZQvI8ylBJh96X8r15Vcsmeo5zBSr6k0dUWFGD4Rtn19zSCN+pJlaKwJi/gSLg5+u
	iJtCS2+x1QGCmp90zPolZSuep+tvT4fglCOvrC+gMkT6BVXG9JvhOkYP5xlUnzJh+Vb11N
	DI/CXOy5M7VxXEV6JSFg/l3LulHZ4Uo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ajSAQlia;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=JwfnIxj0;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454350; a=rsa-sha256;
	cv=none;
	b=bFJ6k1TqQGwn2xRAOHv3rKKfGmTBQjRPsRsJ/CBQsK9M/ehWEgBkad9DnkKXXP4BnZvxbJ
	S7mXoD2PIrAp5DTPbSaqxIyyk0uIuGM/Fi80uHQr91TdtIwGcd2VfcCjov84Tl3LrPTnEX
	5GJVR5YaMToVovCx5FsWZcKzHxX3xoo=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/rC8JaKdvarxwfXTuFmyKVLUxrMKeBR1vS+B+mbt60=;
	b=ajSAQliaS2qS7tskq6tMH3t68+qJUkIdQPRiKkQMCt0DsJ7PTdi8iUy+3o2QlTfA/80+BY
	pL4KjEeMLMt5yVfqYI8OjS5j5Hgc0vW1HnPf+ayu8rkOjs3Vqzr3P8Pvk1qR09O6GiUPU7
	UjvxcgX0fxJ2BXwr0xwniOcLVDPzRXV2NpnJ6qmMXgvTVUCqPxt79l9TQoCuPBc5LqctF5
	MOP0zzVzjZIt8A9dHgSUvittHeK7AIKBGH1r07yFDH3F1nOQGX7jARYyieK4yCcZ8SyVqP
	WgJmsqUP71HlSfhNa2LCC30IGSGkt4eDD2DxsNAdFLLAYMipDWo+OKxY7VeX8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/rC8JaKdvarxwfXTuFmyKVLUxrMKeBR1vS+B+mbt60=;
	b=JwfnIxj0Sdg5oU0oqOjI3YutVwzh75rX2vx7bewd7VBp+XEcIlK6TmXTrPbufqiMTXJYxv
	PB8QnQj/S2BFCGBA==
Date: Mon, 02 Mar 2026 13:25:31 +0100
Subject: [PATCH 07/15] RISC-V: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-7-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1455;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Zpl+G7mVLygoIP0MMSeWtai1WKLwvJyTNt46U7Sw0iE=;
 b=1sF3PQMcvc8QkKpWrYiRBLQP3NxEkxGiX9D/WLc7u5XoilAqV1Gvh/xCY9I+JL4qVtUA6VIVB
 dt3gdx2a1ezB0KhTVbLa5Br+JAHDOGRPvkd3jjBSo797OWQR9U01GlA
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: 58C40140006
X-Stat-Signature: 9pdossekgwya8xryhzxgydrjethjexig
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772454350-84244
X-HE-Meta: U2FsdGVkX19/YbcULR1AohzBkzkuyixgtMK36lnagmNYsBldknEs0BKcoGoqk/mTWt6YDI6B1zEXU34c03esu2PWblOBwQePhCUZACSe3biSjsy250HRhr02MSmBNgc4ri5XYRNwkPRPvFlW3CGZ7uKlEoOpmIeBLuJuYANUVmmtyeMskUwXlWeRCP3lxXGzk0joOnY/mvVszmKais9wmXqEf20o3u3oXIeIwSoimEgJ8cBZZnaCZdZLRjAR878HjaSENo9BziD8fkXSrS94jPsERHZu1iQhg013tO358v+O3Etl2n+a7faKTCqsXg3USv70TwRGdzLy8ZGQQJlUpu+dpWgBJirs8uGY/cXGgSjX2N4CeLW4MBHd3ul0NK1RG+8KDPPyoCauhNEyoU1Gr3RaPm9CUMXi0wmIJHl8rQaHniyNBog/9XolN3J9CEPS52lPPKoWgSBBeWmYoqfx+KliMo10iIqxnYie+4mIJ0U74KfozQDDdFbg1a5Ks4lj7TK4Eogy8+JhWUy6iOlK+d3eyF+J9+yblIKl9VCSABJBydVcV0WdD5yttMwvVmaWB8jPWbuvahG5x1m09DaiKqcL0kgIzePf9/aY+w5gGjHazFeigksg7p1AIFVuM/Z3G8tUXI/RIJ8cCJQ54u5dSrPozdJfaAcsAgRtf5epZmXL7HtdZzj1eC5pg2hbWW/EwsWT3BBTL+S+7XLIXYcuG6xHhMkZmkeMG7g7l4o8IcW5pQdFPhltd+muR4IZqNDSWMRy23euiT9NRR5GaHjADaciNHsdWkjMQcfgJPyMjh0X5sRCd56xDNKxmn2IyefIh4+ofz6XhuwAu83HYTnhQUzElQK4i2Vp++0n6FcrzQTe++qsh7h50xiT1ray7alombmezsGOzO6ylZzGsaKxyBhNu3t7CY8iJDx4b0MGSC66Uom7EuGfC8gT3cHkzjQ8y1gTFtVNxqi30xC5NqG
 rQF2/IIb
 i/qannr9l9wYjt7D8U2p1aqeWQD8kHzxRVItecSdDXAegMAYW1H/0ki/qSBf9RHnBVrWh9R2FA31AG2/BQlrjHbKPsv51Q+ArLM5Irif60ftr3dIqScm7TT3KnSFjLmXlEjKU5BKGB53f21RBpRLRE4VMXeAYRZr8WcWI3SpCkTYaqZes8dfGRk1Q0GkTrJR4RhPevk8tcO5sa7YFSpiLFO7egR0n0NaJwLOt0Lbon75EmZ1U22O2RyZhnedGRjhB38OEqLOV3KjQklKoqk2u9lgf2Z9fXHMl2sAqatnxGikc40DLGCCPtxcVr58DVUmWylUH206l8Ujo1v5i0WuyCftN6BGkl1c7dWaABBBVh0wN329u6Ime198lkDqLlBALflpRruZom063QB7flvYWRJ2zHXWo3RoLoy3t/3cG3BThwT0mRsklFeo/L9CBcMabrlZpNNeSruSM2PmUCAEnsH6V52RFAa806ebTHfk8TX8I5AmMfaAM2HPG50f8iedo5aAzpyp8SaZMnic=
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
2.53.0


