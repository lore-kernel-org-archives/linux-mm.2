Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0DDC79F80
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC746B00AE; Thu,  3 Sep 2026 03:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984C36B00B0; Thu,  3 Sep 2026 03:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0C76B00B2; Thu,  3 Sep 2026 03:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 646716B00AE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 043B7A048C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:36 +0000 (UTC)
X-FDA: 85171656234.07.BA75D24
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55DA74000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=APQB2vuQ;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kMqEoxbn;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421295;
	b=A7Fa0xaKv4eVuDU6arBjX9APFkBAdkaasvY8egTXVFzFYlkTLyJ1ciigtzdu86wtsmT5by
	q0ppgdSLsi2kuGb5kNNUEsdQ64ikd7AKHkWbBRlf0NcgstfLSkTm6weooEs0tQSg1BPPcn
	EOfvXDpvdNge3i4p7iXiqR4byx42rzU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=APQB2vuQ;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kMqEoxbn;
	spf=pass (imf12.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUcarKasoX0h99dw6M4/xD5hiQ/p+f+NjembhaSjUVQ=;
	b=o5lwnyHY+3FrFWYBBqEoanHXWC9CGLe2CZweeSnJhZSEba9AWqVEk9l0D+/YptpdaB9USg
	qogmVKT2X8pGqv2p+sX/GdGsJ22mu6ZKVXPu5u/ZOSQ4c2HPuv/S1jFF1cvX0fQqPCRNht
	UBEJEaTAd72BjALYIkJInFGZsZR/YfM=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YUcarKasoX0h99dw6M4/xD5hiQ/p+f+NjembhaSjUVQ=;
	b=APQB2vuQicLW7Zb8jMJr8A8PXWF7rS0zkF9Ri7xRZz0NsPEweiKDr7QnuZXaZEvkpJG+4v
	K4RMcVqqimnh0TCJyD8QgGasKT3klSt0i/t9LuY/5GXUbyPDPWKT/4dWU6jcyXMNbq3QSY
	tWglOGTMDhufCZNh4xqwF/KN9UqbmPUZn3x3MB/GHS1WhgREN9lSNUhpFZvq9Y8R7n4jrc
	RzUDRhuuzFI6IhveVU/KEl+OXPL1RML61ZFBzasXiEbV82Qy8nBURU/YjV1AwndNfUiRnF
	pVVKkQaJsMt+N+OB0YtlNGJkvmD9mgWghcpmB4U+XKodetrCpm8ZE1xKF4sWgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YUcarKasoX0h99dw6M4/xD5hiQ/p+f+NjembhaSjUVQ=;
	b=kMqEoxbn4idATtgPsStZnSGqmHcSXU6olXd8YPdu0q+KeHi8EXRyVYj+Mj6ubqC9aAtVS4
	PHj2p3DSjWMbZIBw==
Date: Thu, 03 Sep 2026 09:41:24 +0200
Subject: [PATCH v2 09/15] s390: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-9-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1450;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=SvAg75HBK8bLtuaKgOOLDr10ibDxxL9SdBfOzzfNWls=;
 b=3RT19pLNWlOURXZVikzalNwkQhefjiPlou99ySXRRsmtxX0e69Nl8D5OGCHH4DyrLWTIuCnAG
 MABfP++jZRoDuSWe0OPaLheUiQwuWtT2e9LUHAy/E3h86Qgzctp8htY
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55DA74000A
X-Stat-Signature: ajgwwpxanhc9gzy7gp7odgzww8g19hna
X-HE-Tag: 1788421295-862813
X-HE-Meta: U2FsdGVkX195BcgrFGue/Pr/ozNfpvM2+29B0qMcXCkdvIrz3DSWKFPlU5CiOXb+eezFEPEbSdy30UFWbOgpMRwia+4DrBTuXHLUAkSGy9C08tWwrVDrxsHQnHX4skWdxqoxaSEQozOhGCvRHT8bYdzF6B6MyR6RGg4OQhN4I0bHpM5Z1tfAb9po9Zw1xZBXtHuJ+co3NFtYrR4o/4nsoqJrbnHFYXjCbHqxWAZhuPD5ps5FgD+qpMgCHzBooje9/tVTtI68pAR/SAJZBSZYv7tegYsV9tUD5Rbh7nIyuJXITEWTkQbMqsVEkmW0nvbkTGdgjyv3XzQ3MzeXd3+ziqoVpJTv2FNU5kVYcaPVIWbMnxPqwKUQrij7Rjh8dxsy3vJ1PY+PPi0fw2qTNHsMWmpIKlSkGQ+4qQcP2bMlGQax+txTdu7134aEFykRhciDbJm/dB7D/gjl6ajPcOMpWeE56vSdY9mnn/+/SvOblMmBkYBp2asg9QtLj39mIcdMxm6iiJjzciZR3M9z38k3Shrz9YjHHLaRzqm9OVz1hLHIxFGLQ8R3ROLRPCkJTV7k2WGds+7dKn5KLhbGq2wVDrDtAxEyMQuaq5GkTf6Rr2UWoIIw60T5AWjJoLYj+yWyphvpdw94FWz9ICI1RPcHndgm8Kk7cA+kBj3QGBvch+139nFnwRIs5PInDuN/PaRMUSM7br1p4R/jNQRZpz36VhkTBJkx54c90ErIAzNUc8XlKisz8obOYvvGOA/VYO7uKSmrsZCsfYQvRxH5ozALx8RxG/EaKZt7YQN6gti0z0lspdXIg1W7cdpq/GmYtR+NsG69aY5kPSE0errtnvcg0SaTs1P4yaBOlxtj0AVJX9F7yCfy+hCn+b/t1IIkEGXjUsZsvj3QHF9OFaVOfHH/v6e6YHLS1s5sG4f0F2+z/v8AUEpPPIS+JdUl+gkifu6cFf6xwbZDydeuktMelfz
 5z84OVav
 YJ/XfS9pX44VYbH6DRNLGKzwCxehMnVX6ZWRDVfZFyPtvHwBzhXMpkvrYi8Xab9ugvB6NaLjHcVuQC3bzvnLDT9nwLTJJS9aUr7r/6fvhHgSLoACQMEfYJHJd4MGgPMhpjpZve9l4yBqBztj1wL+k1njzpc30d4XQ649zvexPK6xFSniF2ZHMFc8q6+iLqI4tRbDZxDro+c7e6pOOm7WEnYCUjlbd8gqpA+heziolFWx+ZBdRn7bY7PyK1J0aOiv5O5WOW0o8q1T1nGoAwIGLO449DxwNLp2vn1jEhXtk4qz5lalfURzz69oK5XklDEorQa9fgCUBYKqD/+yBlvpJt1w4W5UQ+8aa8QGGzSQucxcupd1Jz8bjpqxzkfrQXxQxBfekpDoekAYfVyY7NtLdzZoSZUVKyEHKWQa3pWrOZqI841xGLFikPy8rimqvmSqqNSXQ584MDRXyFan8NqFo2dBxv6wPyI6Ba31ur/q4ER8WG0vE5g1GahwIFZ6JsvmYxIHm8TsWFAGJteXWzdfYO7Ww1LzulR9H6dqfudxr22kd+Sk=
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
 arch/s390/include/asm/auxvec.h      | 7 +++++++
 arch/s390/include/uapi/asm/auxvec.h | 6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/auxvec.h b/arch/s390/include/asm/auxvec.h
new file mode 100644
index 000000000000..beaaefe12a84
--- /dev/null
+++ b/arch/s390/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __ASMS390_AUXVEC_H
+#define __ASMS390_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
+
+#endif
diff --git a/arch/s390/include/uapi/asm/auxvec.h b/arch/s390/include/uapi/asm/auxvec.h
index a056c4637ffc..54bbfd68d709 100644
--- a/arch/s390/include/uapi/asm/auxvec.h
+++ b/arch/s390/include/uapi/asm/auxvec.h
@@ -1,9 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef __ASMS390_AUXVEC_H
-#define __ASMS390_AUXVEC_H
+#ifndef __ASMS390_UAPI_AUXVEC_H
+#define __ASMS390_UAPI_AUXVEC_H
 
 #define AT_SYSINFO_EHDR		33
 
-#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
-
 #endif

-- 
2.55.0


