Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC195C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4446B00B3; Thu,  3 Sep 2026 03:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456116B00B4; Thu,  3 Sep 2026 03:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3430E6B00B6; Thu,  3 Sep 2026 03:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00DD96B00B3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B03AC01C1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:38 +0000 (UTC)
X-FDA: 85171656276.27.B00D72A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id B958C180002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="x98/uR++";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=16lypqC7;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421297;
	b=FJyh6ETVirnHDavoBm+HlaF0x0X82Ia2Z1QBZQtMjJRiceGGtEq/zRmlt+bDM8Osg9RiAy
	FBlISL+KzBF7HTg7ladSMiJtqqp2Fv5gOUj7P/TBAZU+IjJ0768whCeDtjT6ezTBC1Km6o
	7OG4W5iGbdXR+w2kfnXVD6l54dMK1Ds=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="x98/uR++";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=16lypqC7;
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elVYzhuCvmXJBPRZ3gCfrokksTC2QjbDZG7uOX6NqdE=;
	b=yzJGDStWpptcOGcNSwU5+EPHvvkXkUBQo/c5p7lNnRM3h+n9jlbH4Tc3lIsGdnLpHfWjlB
	D7bpPp7q9hUB+Xr1DcFURm8J9RjqRM45OyJ5Wc9RiPmNhZqBs+O7AWnYdvMyhqMQOABAXq
	ofG01kAfHxV796dfn0mKptz8LGBR4o8=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=elVYzhuCvmXJBPRZ3gCfrokksTC2QjbDZG7uOX6NqdE=;
	b=x98/uR++5TGb1kE9DatfjBc7vccpt9Tv6Ybqo6Jpm1/OJSJD5KyNHVs69DNPs/A+utplx1
	kfB4ZZcdBUdFM9kNfHH3RmU8srMZxawE9tJ81+G0De8/k90wTz77UrJ/ZA5huABZSnoy1W
	8xIHZGOtgbMGRjdhG/MspxM5XvQ4jhFgE4/OvO5PFuyRioaV0ToxHelPuUjUoJCxVs1jmi
	a7XdgCUGnmhgYMH5GlU6reqy7m0j89/Z9cAyKN5l/lKlSrtK7RD4b4rQQwaWdRJ7D8nqy/
	x1IhVuGARBmfGfthpyoY88Qljhzj8StgQwCNy0bgCdFb3X+pqYUiWXjLOXJGQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=elVYzhuCvmXJBPRZ3gCfrokksTC2QjbDZG7uOX6NqdE=;
	b=16lypqC7rW9J+MkVv+rFbiDQP8PUbNH9MQTLL3JpXOtqRwqdnyUyndlvLnhpDqwpWve5tX
	0DkewKfU+GC6NTBA==
Date: Thu, 03 Sep 2026 09:41:25 +0200
Subject: [PATCH v2 10/15] powerpc: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-10-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1614;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=YIjNA9GHIeGKIog+4ZRlNVoTyE7Q6c9+vbExkNBbN7U=;
 b=tzh2nu86F+qh+b32xMEyYGMszxVH1qArmLc3sUe8halsMjfnsH1mlrvaUFUosJPsV2OmaGV3H
 9t4yw1mYDMtDty4LZwJAm85bi7LB7ZA/JDYQ5/xehieYzIxhOCKT4g4
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: nou3yqprre8ma7q9bihjmpr954nx63xi
X-Rspamd-Queue-Id: B958C180002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788421296-900479
X-HE-Meta: U2FsdGVkX1/tYr/76s8x2FZVloYsJBorUwjrvegvzHFBTcwQG7Dz/Jj4m4sSbrkfU97aXIvgwPx6o+kG8Zt6Rm0YzyZMIFvPibKMyDl/lLIHJJGUy/0oW5XvKw9MLoDNOh5fiPG9OKC25U72MLPlHEgdoRriCT8CfEfBqTHXSv/kQFrH2X7hAvdgfOaGK38N67GvhQTI0dAkX8zhiJ4yfvSGIz84Zztk+kjXP5cavbVIiCdVB/6TrVlAvxZ/Ny4RVJNfBr7xEBMAnAGo3I7aElpyEznyE2Is5meGRD9SgfbB9lf92vUhooHlFE093jaEMrDZCc5IYKPHEtjmowJQKIzGep+7pC6TNpH5jLnn+K+2az6RqzhKQs6gRERH5gm9TDrYLEyiOAaBFiwOc1KMRBAv57A6iFT0W2HewpA+szX9s2tPFX4H3b79feCzhAgSEIqHzIVtQ70JpnoGJfpuvA1uVfLVcxYShU5tAT7nk/OKUDrDYwsHNfxU0VHQYl7UOoolvu8KzLPKpppmY4v9BwE/40QE/JKSGCo8W5N5CztGQti+O1jkdvklWO+uvcdVzehJb8MtcfPH6DllwMI1CkCae5GSH+jWhN6vRDdvfToOUtHbyWiqTxPi0htpnpgeywK1fryRBYW1FcwWyBCnrw7cX7XQ/JPWYI9SLDxGZ1dT6mrtzZ1DgiCelJ6h983+hhabOMxgXleKw63UI/43mGhHuHvDZc6X/1JWSJdeW6SPkxhyd9sI1F+cifntNt3k6ooKd2VnslsxR40TBGgkigMDmk3RtnKtu2CllrDb8rwmE4JHsa2cwFAhDeekWH7s7MXBEb7ACTsN8/YCcLqXzmYCU8Yy3/ChSHKga/B2DNojR9Ze7H6+r+P/SbQZgTgss417j7H13rMJPjwHZ3GXeKBebi1DxcEFiy2IsZaLjV8TIko4gHlyUWU81pLc6E3dLFtxiLo2gk59YyTU6pD
 0znFV1oh
 UQSlpdReSFDN1HSAFM/FqTyWQzvP+sEhUTeTo/uH6SCuGaJUcZbqJxB9MUt9qWLq7UXex83FK20SejYi9pQe+zFkb5kju5GfqhIZ24chxv1fWs4d4xzYVJvIwFxO9lHAajqg03JaOZ7VLzarPLtVReIuu42hgRpDc9eJeFsoBi8OF4KeynqdNsKL4vz8HBDNj0iD4/mSmTumoB5D0KnwTPEcX06j26fRD17dyLu1KhlB+mKyuq8LFkVM2MqFJmVwDz9hc4bvwothgSuMuWqIsoh16ArSGo1olBsGQ4IythgL1D/5WLr2afyyVJM0W+uHj5xS7/MeYSKgQyXz0mZgkd6jYabUEEtF221MDSHpcHU+Au/H5A4tghqfEku5BMGXpZyc0lFk0TjkgKdwtJtDShuJF7gwFBYoMrW1oZi5z8SPut10fAOj3mp435IvRWNgjota02hgEMo+dZHh7+XcUnWilFArkWzYh4BoJeYJrpDRyr7myBU+Nw3G0QqjgbJWAr8BqkwAn3G1ZWrc7BzTzSV4SO7qRPduriL05ouavFSLCsfA=
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
 arch/powerpc/include/asm/auxvec.h      | 7 +++++++
 arch/powerpc/include/uapi/asm/auxvec.h | 6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/auxvec.h b/arch/powerpc/include/asm/auxvec.h
new file mode 100644
index 000000000000..d6c180e9ac2c
--- /dev/null
+++ b/arch/powerpc/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_AUXVEC_H
+#define _ASM_POWERPC_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH	15 /* entries in ARCH_DLINFO */
+
+#endif
diff --git a/arch/powerpc/include/uapi/asm/auxvec.h b/arch/powerpc/include/uapi/asm/auxvec.h
index aa7c16215453..9ab5b6d17929 100644
--- a/arch/powerpc/include/uapi/asm/auxvec.h
+++ b/arch/powerpc/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _ASM_POWERPC_AUXVEC_H
-#define _ASM_POWERPC_AUXVEC_H
+#ifndef _UAPI_ASM_POWERPC_AUXVEC_H
+#define _UAPI_ASM_POWERPC_AUXVEC_H
 
 /*
  * We need to put in some extra aux table entries to tell glibc what
@@ -50,6 +50,4 @@
 
 #define AT_MINSIGSTKSZ		51      /* stack needed for signal delivery */
 
-#define AT_VECTOR_SIZE_ARCH	15 /* entries in ARCH_DLINFO */
-
 #endif

-- 
2.55.0


