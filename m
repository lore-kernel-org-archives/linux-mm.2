Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0431CC79F82
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E866B00A3; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677D26B00A7; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5659B6B00A9; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27C9A6B00A3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5F78A4415
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:33 +0000 (UTC)
X-FDA: 85171656066.05.2AC218D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0CDFD40002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=epr8s8vL;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="/TtDngCq";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iW4jdWMi73lQm0xNAN3vvMpxq+9yLkV/tkClyyUkd0=;
	b=0tpmROXPnJ7eLnlNQGArPJUZNfI7E3aCQs1pockEKqlT0Dh3496FwZxPcggigC2BOYoRFD
	QT8cExLHHncjFA2G+vfIsm6ZPqM2aNEUDr777JpJGFFJflJ8+hBhi1R2aEgdNTSHlyO+uw
	0fL/n8nNPXqLjzDFJ1eChgDJ65u0BhI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=epr8s8vL;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="/TtDngCq";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf17.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421292;
	b=io0shWxSSvWgj51/hB8vVpmMYWEDZan5RuLtj7ZPJpkspRttr/nDaDtLgZU8xeJ+a8GP9e
	NdZjyTkaSomT5odfoS2o3ipMdZvSC/dPvH7xH0Ww+/19y40UQYPcK6GggynjCBBsJsSa9R
	Jy8ZbsuqNlsoqpL8mSEvmGd/aVcK6gI=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5iW4jdWMi73lQm0xNAN3vvMpxq+9yLkV/tkClyyUkd0=;
	b=epr8s8vLWpnga42EE26n/anTxvrFGHH4F82vRsZ686O+FbHTEyfL38Jbyrw33Fao8FUOgP
	YvfpgVnoZnX8uTI0qolELM6IsguWl2qCqGWFBHlWnTJgmPYquNQMwRJfi9XWi6Y5mRGle4
	KW3ueTspexywSZl3IKwRJHiOmkWiXh3Az2QaFtgBu2ylyRNKRnXLJSb4gZuN3or+uhXc+C
	FD6GRaP/A1NC0OFndLerATSc2J8oWgw0KbM/ig2+8dvbYbF0vV+qJArn7vMmZZ7Ov6GROG
	AQU6MqZCgZtTEo2NvDq+V4aCkcTPEMlQGt5c46v4ztQOs+3dQoiiMOY1XvcXvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5iW4jdWMi73lQm0xNAN3vvMpxq+9yLkV/tkClyyUkd0=;
	b=/TtDngCq8exQVQLXPVtjCK54BDhStRy2GTyEEXPtifFWiN3MyDpaRwkn0f1Dw6U+PBq7Nh
	AeLBrYQ9oaU/umAw==
Date: Thu, 03 Sep 2026 09:41:20 +0200
Subject: [PATCH v2 05/15] x86: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-5-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1994;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=b7W/p77P/YlmxuUHtTjOCqsXrUn80Pb/0CSphAb3eXc=;
 b=8bCm4iBaPTW9zBWat/+m5Ee1rmwD4EqMaEgVhxezGGaTPE5ECabv+Lrj7OAgMtDB5ybLV0Bjy
 LrdI/FLc2B7BI3Ex+/EIsufonLKjzeY5VOZWKidM6LruyvF2pR3gqlh
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0CDFD40002
X-Stat-Signature: n3pw434fmjifgjg7fitdr1m3x8pqcyd6
X-Rspam-User: 
X-HE-Tag: 1788421291-218004
X-HE-Meta: U2FsdGVkX19vUmdb98mwBx/KVzs4ZSEqPRkxb63NRnevw3zaMelXjcACnYkByJO6n2fybCyAkYAQLIg1JVxqt/zl5fvShpE5x0VoyDyolrF1pfmQy/LcVwi5p00xhaVGmWIRYdfC2qn1/l5D9yiMz/k88BgAZKbaylnjfKEQq481GgctZFv+Ii9G8K0tN+nD4N96SDBpXPQUfPSCwr4nG+WaIv3CiKBo4F5mvPkDA2oyFSNIezW+VR4IhsZ3G7OJQy0q0IqcC5DQjbQlIbOSNAp5jiF1u0Lq35TjL8lbZY3+k9L2zkLtGEUSO7HxxRThAlJHQscB7AqkuYe1r2XMjmTEjhMRtUHwBQGLNVxCc/FPdqXK1+7Fd65PjySePv1ugdc+VDBpvJTSio1rt+43EKOp29ZkIn9UpKTjbwqlYpi9HeTl3WJpdm8RfbEe3p+6M2SYAwa7juH04t4Uody+PqcbQo0vVr5ad15UGnMYsIIApi60s1Pm81CVD6eVSMpCP04mdkmPNhFF7iaPRJ6D1qaABDczB3Sio4kPIGeFGDmL+AbHJw9AsLrbPlxxbCmPDyMF1saHlN/txOV8XRF2Lzf3n7XGw0WDe/cGKZ2F4OKKD4eeYUB9UrGoE+92FW0JgzGAE6YR9ZsvbvqVG8MFP4JtZio9BUVpg0NbYp0Jt0ExIEvzy8qWrbMfMMgDNA2vQrOVsjditKp004pEfxAgKFJeabDpVR50MSrfTJfuJrI13ir1ai/x3xzhkTV7pwBTaGRM35Sn8QOGRjINMuHd64RV0lUvOo2aZMR5CxtV7hFFoSzuLW3Q2ipRbi/5PzUxieuuH1iYfZSaCV0MsgEazjBPLH855HR/VaeUXBUhZLcyVdzdg0W9Kvf4JdhrrtciwnoM0ZvFkEu68HkTx9nRcKwj+vNz37biag/4uvVrS6T4LHvDpPxqoeYx8YenbapXOxh9FXm7KSsXndWsxR4
 EdJCMEMN
 B9PqdyfKafzbk/IuwHu/6dSMYnp4AUA/Qp51eHaOQQ+4yudWBN9XC+R9Gu7BGkzmBe4EpReT8nKWaXuZQ+3dkiU7FPjeVHujPpW/GX6gBXcidwXGVXjl78NYMZqPeB3USuNskR+AIBqSTkK1p6QpZvflKIQDc72k496DmewtG+D/h4H19ZqThiqJIAODcc0bNRxYZqXRaBPz5KdWXjZuC/JlKYJNQj8LCFpufOQGLSyZbyDtkW6JRilzvai4IcM4h+eXSWgjlpFklO6zT040B1aMwFMwmO3PQEOwXsl6qSyuhqcD0mxqDDJygn3vcjrPwZMy7fZYe22OHtDUC5TX7ifnoFtXrYqdUobqcuN71AILCzJ/pHkSRH8yOrnrgsdJL2SyKXpiwymIySoNpVQCJTrA8nL4N8KJzKVhyOHwkYNzBO42goi3eN+La7JguMwtzlZUmCJYSFTVs1o6ij1v5Bh7WwU5/K2je881cLk5UDucZxuPtCchZSq5kESzxp15c537J5Ay5svVZ1uVfT5+Cj4B5Acrx3WX/+xuu0jnefBmTE6Q=
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
 arch/x86/include/asm/auxvec.h      | 12 ++++++++++++
 arch/x86/include/uapi/asm/auxvec.h | 13 +++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/auxvec.h b/arch/x86/include/asm/auxvec.h
new file mode 100644
index 000000000000..ed26ad09f3e3
--- /dev/null
+++ b/arch/x86/include/asm/auxvec.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_AUXVEC_H
+#define _ASM_X86_AUXVEC_H
+
+/* entries in ARCH_DLINFO: */
+#if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
+# define AT_VECTOR_SIZE_ARCH 3
+#else /* else it's non-compat x86-64 */
+# define AT_VECTOR_SIZE_ARCH 2
+#endif
+
+#endif /* _ASM_X86_AUXVEC_H */
diff --git a/arch/x86/include/uapi/asm/auxvec.h b/arch/x86/include/uapi/asm/auxvec.h
index bdde9e18f94e..6677c9ace117 100644
--- a/arch/x86/include/uapi/asm/auxvec.h
+++ b/arch/x86/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _ASM_X86_AUXVEC_H
-#define _ASM_X86_AUXVEC_H
+#ifndef _UAPI_ASM_X86_AUXVEC_H
+#define _UAPI_ASM_X86_AUXVEC_H
 /*
  * Architecture-neutral AT_ values in 0-17, leave some room
  * for more of them, start the x86-specific ones at 32.
@@ -10,11 +10,4 @@
 #endif
 #define AT_SYSINFO_EHDR		33
 
-/* entries in ARCH_DLINFO: */
-#if defined(__KERNEL__) && (defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64))
-# define AT_VECTOR_SIZE_ARCH 3
-#else /* else it's non-compat x86-64 */
-# define AT_VECTOR_SIZE_ARCH 2
-#endif
-
-#endif /* _ASM_X86_AUXVEC_H */
+#endif /* _UAPI_ASM_X86_AUXVEC_H */

-- 
2.55.0


