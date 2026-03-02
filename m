Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47ECE9B372
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52F46B0099; Mon,  2 Mar 2026 07:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D196B009B; Mon,  2 Mar 2026 07:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801526B009D; Mon,  2 Mar 2026 07:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB386B0099
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32FFF1A0C7B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:53 +0000 (UTC)
X-FDA: 84501044586.19.4BD2E1B
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id 65B66C0006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NHM8ly0i;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=M5bdRgSQ;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGu4YUonqtswtsX27rVZnBUBJm/UklEpSAAXy65RzL4=;
	b=w2vNznZHkVpUd9SVIw76yJ32biwf7a8VVkkap8xAZFQjqDuu+1Mp8pwb7DgZVoZmnB2KAW
	kSZtxqS2sebQ7JQhL4BLUf80a78BCkORr4l7/ZZfWdep8eCT9JZsX+KmsvW8y5mIBr6px+
	ec7sHWpvaCcg15SetYLnk1BPjX37VT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454351; a=rsa-sha256;
	cv=none;
	b=ehIyzGDVmkr8Bp0oUABg7uNFrNdV3lQ6mdGk7zpDaz2kBkcyP/iWqW7xyfKyQZYv3ua9JH
	7Y4P/2+SmzPPv6/bgz/p6/Qm2Kj/1db1gLLyjRT+VRyCaDbBbtQ45Q6ggFYOr4g2xOW00J
	svlww0ihZir/vg8IVT/tUpbInG/vnEw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NHM8ly0i;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=M5bdRgSQ;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGu4YUonqtswtsX27rVZnBUBJm/UklEpSAAXy65RzL4=;
	b=NHM8ly0iuYcuh7E4eVeKeGXpReTprXhsGXJI+WYqlEaUf/lJYOUtBGH2QJnSAmI3I5QAPW
	LY468YWc+wcltpXurLXAtczrS3GRRs7ErvM61alrkPsKE3X9qmMsWKbpRyDz62q6oE5QGd
	Cw8Ohv3wtKFFpU4zvThVjA5RvZbBiw4fuurA+7UNWmQxvsskDaVVA4bfSSZgB12N/2TAie
	0omDMNnN9zOIOVB7ao1DehqzId2upP6OirsIQL+gbHRxhanTRwW23vCB34naWTWXi9Htpn
	0i4DmvsTWUtmu8SNg8v9pArAePWhRXG5bmVWZWSE0NmChST4B+21+gbeLT8M7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGu4YUonqtswtsX27rVZnBUBJm/UklEpSAAXy65RzL4=;
	b=M5bdRgSQ3QlnfcfTl+A8OeDFC/IW8uhkG1G/LEw+Ak1w+mPEMp7EWeeSHFb/e7QgJ7ScQS
	t/VtnQymro8BskCg==
Date: Mon, 02 Mar 2026 13:25:33 +0100
Subject: [PATCH 09/15] s390: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-9-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1408;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=wSV5J7HzEFuS3KJbZLwjne1zxmW3zDPxdBoyG55t7aA=;
 b=DiL9Q3q9a2OSCTrfhnV8gNkfPXzhPZlr/JwJIjpZtjcaaAF6eqOl6SEEE9FmY9unQs6qSC3IS
 Tt2RIf9FHBFC64LLNTZGUWGPwKnIoYVR6wJCeubfkDRjuZzU3F/usem
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: yairckidqi4zq7q9hesm97jsx6kukx4o
X-Rspam-User: 
X-Rspamd-Queue-Id: 65B66C0006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772454351-281435
X-HE-Meta: U2FsdGVkX1+G42/VRED803AjAi3Gx/8FEpeUUKJ+C+Y7ay43TIFnH7eI4PmcfgpTQRcIHYCZ9DqAA2kAuhHuyRn2jiDX8agK9PXz50IArQIW98jzkLTKXXZJL6Hf9ZtS2W6sl7VpSGqDVi8GEB/oi83YAwL10xl8gigdWH2cRYnNBQaszn92M9+8Hp12b2OQ3Z2KIvQBtIfx4YQ7OU/tFcybnN0Xjwu6stpdm6jsf3p1Ndeb4GA7JrTvNImKXg0XZeTQHkyEyKNxZs6dsg9jhhsfFMz83GppA8VrWNFOTqm6rVz7B6OJbF+iFg2Vnw/YhAbvbT3br7MWAQ6xpWnNEUsL48YlBIcCdvNjbaWtL9UB1xts9Zuq8hLZUmYEJHCZwHXuTTaP3NYMf0EshmwLy3pYHU5P8D+K0F0wtGyYb23d1x40ZRtG0LfViATPzQrjb91mLcfAG9zUJuj5f6SvFtQSaVoAioVC+q4UTPUUCG0e0A1R5zAD+v5lrWqXY0B8xd0t9Eo3VXBYN2JK8EYS6gCt2x08RH1647iyR1ItYYW34i/8Ox7tQso6qDs5d1S12ilc+K/mUBxk9nIAvrETbMP2oB8vvq2w2QXPN2KsPAkNklUXs+D1H307v9slZ8jwf85cPKPJiELc9Fqd/bLV7BgDd19j2B5wtXnuYunHtgFt8A2443gLcpnYsbQRW2ZqJBLLPTHt4XA5K4GylpdnaC0ONYQ3vQkUgelipWTd841Hctl5Nd+UQI/82TRJaxAZDi7ey+Jiamka+yS6LwxXCQu9oxBitpTIBxKFG+QVXfONQyyB/xJpQ0l4BKqIQjv2yaEqRjc7aY41Te8I2tVNKcx0dWx+1paQKG3kSmG6eN6YXi2FHz7XsEQ3K9hltSiiuxruev19wqFELjrXCyf5ifmAhdBiyHKWnxv9xTis1Ooj3jhOYS8P/WCR5hNz/4G6b7dAaMpzEgJUG7O/V3T
 VsuWwLsf
 MCx9xzDiboDzDAi66V07zJAS1Ds9KlmLAgO8P0ZsLnrqMuQoyt9bINLTlHD8T3ySyb+3JKmxBEUozzeWiblACT8nKp8sj7MXnVhBcSYYDK5PgE+8zg8b5/MMw+7MUzQNfMCfCWJdhaNtQZh6GQQ8wdy+fzp0taXSNfgz+3VxiNgRiESF4CG3Kly8rFToPqAWohq2hstorwbjAJPc70os0dU3y1JS8Thy/Z8sBLfSeGFhtGMHwJUZd5wrppderCba0aT/ZhXYaVwx3favK4jpAApA85f59lPFOB5vtB/otqa8tqWv7/jYS8O/r9q9ZRlbudMjyDCncp3rOTl6rwC0ZyB9wgfyv9x9v1FPSQl1rWd/kis42tRImzjeDtBBv70nuPel4JD6cKdkGkRADJs0K5IQNx9PP2eqo/QBqcl7SoZajYjFgCD4YVkk1Lb3G3JKEZZBDBw0m+dXGFVaL7qQGFFbh2OZccR/Ji3OE2SJrFD4ZMdoo7KrUg6zow7ia4XB5NRK/tRebjQKOMMY=
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
2.53.0


