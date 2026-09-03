Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 239EDC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5AA86B00AC; Thu,  3 Sep 2026 03:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31B76B00AE; Thu,  3 Sep 2026 03:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2E06B00AF; Thu,  3 Sep 2026 03:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77F2B6B00AC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E745C01C1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:36 +0000 (UTC)
X-FDA: 85171656192.01.06989D1
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E6528000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=RmnpqQcH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=MutDSXtV;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ctVC8jdqr6QFYd4YOzfCl075dK66bWX+194Sx7TuH4=;
	b=qeX62gvydmZDEZjnWmnma2fJdhyJ/ZrkUgqkY6PWWkEDrQ42pYHA+/nYCirqTC1wPQN4nH
	qiF/HyJDhB9AZU002clzwy5Yyo5gn/aJh56j6NCO5c8RZ5jTDDFpY25QoklqmRJ/yH2ORC
	mrRmbmrjhhXJyQvOTRzlezt7ELd/eqI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=RmnpqQcH;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=MutDSXtV;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421294;
	b=MUQvQswDXYyLj+cr69ZVrm5i79GjhnIR/0VDOonVMawUnvaTtLeM5YCQKDfH/0SfWGuSGx
	x8r2eyUolfgL0ZmZY9SGQ+duTKHOFaycgN/q4CMy4hDpZlWGwgs7eA5XEqdvZA6tEkJI9F
	M6593pozNoa0G03zE5x7cmHthCWqPOc=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ctVC8jdqr6QFYd4YOzfCl075dK66bWX+194Sx7TuH4=;
	b=RmnpqQcHoiAbhcGu+Ye9voJADRcNlHd7//7UZSZpuweS6/azB8kBGlfXNGpZdw+zJFDhmb
	wVqfd/ReM/yvTEBcp2m8agJJbkA7AncmPKWHrzmhKzuSH1IVXory7WFsKLsmSfU+nfF4Fh
	hxpf6Zo0AWb/8lzdQ/XqwzDTqjMN/ZftsjIshCrqha3MqBXvjPJqrmx40U9dtdNY8urMWx
	+B2P0HKRbsRjXaKsVte8egNJzNOx0RSzNnBwbUTf/deLjmYm4421Lw0Q95xES95qHbtIp7
	OG0nZ4yrrLdrUs28+h/3y0b4ZZnyaG3bYORKfR7uKBROl70iqzLJhbBNyDZQmg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ctVC8jdqr6QFYd4YOzfCl075dK66bWX+194Sx7TuH4=;
	b=MutDSXtVdZvrjMqfAE/yNMGtPAGK3IDThXDBVUv0sCpVzDTmiCqIuYuqvvtvE2gzScp5oD
	8MjD0OPK1RDnqHBQ==
Date: Thu, 03 Sep 2026 09:41:23 +0200
Subject: [PATCH v2 08/15] LoongArch: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-8-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1767;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=jZmwpcTvA2lKNhTJtgt0mA5Nuuta8CO6fadzS1+09Lc=;
 b=g6xbNGIMHGTFBPIVi/M+7w3xhJb6s8qCkfAEkcXz7LglyUP7ReGfFvVG9ZkdpA32UwGSvrRmY
 cx+niZaAeaKAcK6Qn9T2uEinyA/55qjVdDuG6KFn3ehAIJWX1I+ofN+
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: 3p1mnhc7sa3egfx4s61rwkrxf6zettem
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5E6528000B
X-Rspam-User: 
X-HE-Tag: 1788421294-825072
X-HE-Meta: U2FsdGVkX1/PVILj9DvKFV5vXJi//vzrs0mvR+V9fN8Vw6BLe3K1mlikzTEZadoV53wT72lstVHWuAn/iJoSj+uYHoiQIvULyKnqifQ+V1ZIyIo/fF+Gi4F1p+oC/JsBVeOAoWhTKH56KhSW/c42HGpFCESs+nWn6MaGiFWAc0o1NkdewW7sbdE1ZUx5rRbpMQSXzyMfRITRjCZRmbJqAqxlMaZDfFKjDSEl1ZQApJYK/s51RPXWckpTEUhikkUkyKQMrLtsrVsoom67ugHup9FNpwmVrec0UWk4uuKBgOrvWk6fPGxj3Sd3NzlcfLORrTfK8RY1axJKisU5H5ZNI8gn+xoCP0zJWjPddJ8El7Vc+FMG/aw//BTcfJpa5bkzn/SqShfd6TYKyQ1MTxpaa6iZmMTA2nCnjdVM6QcjzkspDOuUaAVmpTbX8QUoz+cXZg8z8YJ0c1Ptr3VbHqVGzmsa4Ygy1aSj/uhoF6s7tsDqKZ87izNNTbA4DgyYjupULTX+IzWfZANWBVznfxD/yPbZDdZ971iqA+yrvntlftzWJIQejvE0Voki6/ffFKnMcoe75FRk9M/87ABSUX1UBf/8VrXsRWFB/rV9xdafVCrgcKVPtNETxgwCX4XBmWHGGIkA+yZHgUX8rU96OQMyxrakjkjmrrq0uXUUmSgXRtf+9Wz5sWqFpWkwYrPf/tl8Y9mqMMlxrd0EK040YAtL/zlWNtdkoDAfBlsJVaUbTpdvpkgvapPqQs7JS6P7nd123TtZwVA9fM3IkUyCEJCjUbXzUbn/OKUz+sYSoSuojhCh0FrjkvvemC6Hue9BM9GGEQfACpjcTpVdlQCywGANJs2+cc/uD/2mJJPfx3sAbT5mMwqVeJTQe3FCd0QTBA8VosKgmcbaIR/JcWIe9r6PT2J3fAWfqj6S3A0dybl0uJW4ouWrNcX2GU+hsicHkKIYzPuyPwe7wWF4OYCFcGB
 0Q0ISpA5
 2xlA/Gbo/qbHN78W1cLv1QjRKLMII4IEsFTfq537LyNUz1l3IiBS+7N8g9MRmUb48qIyGy3TbYnE+C9uX/H3b4aTinV/GHPv+2SNEy+QuMpC8aeiIzlZNLg4V+WdLU4Uk77LwvLnV22/1d0mhkhnkYTyLaG+HjE3TOYzlDw5DEmN4/rxxEv13pdPpJv372suyCmIgWOG0PCBEjiDHxmhnQffLy/NuGQXNM6sMwMx7Z5msVbB1ahCF/otJCaXi0lMaJtS5Dz2ba5bxy5QyBQHHFpFajC2WmjATMjcTwuJiy1+7S6itfZJR3YWOBTs6+QIq8N/RuRuc6lVwTKskByOIKUVdE6YFoUElkPXbiGRDN/ZjVY3mS5uLx97Bg1aeE3yUXodD4D2aNBa37lP0DzZZdAvOnvPmnDqldph22V1FrfXR3s/A4Dw69JMoNF69m5adxwgpDxxYwEdxG5ILBQaj11/VJZszaCcbX1QxIYB5UvlBX5kQr+h6H0QV60KFPfkqF6Aj6vUt2bwItAf9JFj53x50WfcQeB1l6ATNwcO5Kqja1d9qKCfxnJdxpczc4NLY6K9MiRiD/WPUaSk=
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
2.55.0


