Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1D6606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=2z10FrIE;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=UGWZ7T+q
Received: by kanga.kvack.org (Postfix)
	id 784746B05C3; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2DE6B05C6; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC7F6B05C5; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 335EC6B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3CA6A84E7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:32 +0000 (UTC)
X-FDA: 85465881144.10.EB08DD6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 068B3180005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2z10FrIE;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UGWZ7T+q;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf24.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426651;
	b=S26dyk+n4oc/oK/PSZvur+2KR+UZfjSnY+imvn1i5LIl2voWRpZan9QYXEdcK288fElKpb
	h/ze20kgKEtGafSGpGv+yUnmrXgawrM9WZvFPLxefEKBVxi0qt0jUPApiLErYd1klKLmFb
	31EpbCBKHgqC+955Ho2JnApNhAzUgmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIWLxGK1Vij7tiU90cRxSFqpScY7zQR7QJvEseKLzwo=;
	b=vUbgMjI6vcL3YObZRS9/F2PoQx50Nu5eKXCrvKeSlLlfjy6rYjnfDvfUHMBtRNCfZf4A6m
	6VCkE0O+aPyNE/BoxdJrKl4zhi+TXUEIBJAH/WdmrpsWzoFoJ4pT6HlgGeeB0rKDbG6TLe
	xbUDAKFWVp0arK/1EJLU4sJGshEE5N4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2z10FrIE;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=UGWZ7T+q;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf24.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UIWLxGK1Vij7tiU90cRxSFqpScY7zQR7QJvEseKLzwo=;
	b=2z10FrIENPAZxNBu/4FgnLVDlG3M7eRID7PzxUiXKydy/rln1DK0lZio8yE3noqkjRh9oT
	e/b+tC4rq+6YEoAcrjJ3cO7WlEfdLeLM1li0q/Tu0ADcA+or6b8Go/sgxFoq3u5Jml76nL
	wEJatTYHV8KEwJ04HLx5bycTT8ZyBzDv/EG6zYCj2bUXUfvkPNDwJxK6iLrH1+oKwxdDm0
	M6du5ER5mMXwAVZIpKmMPCoHzkl1ZHZHlS6RXzVJrU/FNTiYSQ/havtLOL4i6YJNQIQTNc
	2tz4Vmrf1kO+R+LB3ZbFcXy/yLpQ6jr/eCHfaUARFPi2Tkk0Cg45knkrepuvNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UIWLxGK1Vij7tiU90cRxSFqpScY7zQR7QJvEseKLzwo=;
	b=UGWZ7T+qthHBHDZwO2ZfnZZ4wdrxxNgHz6eoMYh19mIUB2kturgEFENUaaOBWGQCMbjlCJ
	6yQtRb64pG3v47Aw==
Date: Mon, 23 Nov 2026 10:37:12 +0100
Subject: [PATCH v3 07/15] RISC-V: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-7-d342dae9e843@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
In-Reply-To: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Paul Walmsley <pjw@kernel.org>, Andy Chiu <andybnac@gmail.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1592;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=d8drZZysn7iP84IJ7qJbdevEVmAtmC8DVsiKbIAXolk=;
 b=aNwL1kWJlo01PaCvebxGDmG5xP0glqFTyi1RyyWhaa+P/3M+1844nqqBisvg5ICRxsxQjd2Xb
 /DJ1mQEVkTCBkqSfISfQLtBeGU1DOULq9hjkJBkJp0rUsvPlCTIH+I2
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: cqfaakjswqnnzmmybhbtztqinp86juii
X-Rspam-User:
X-Rspamd-Queue-Id: 068B3180005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795426650-178817
X-HE-Meta: U2FsdGVkX18GtVx0QTJRExVznNjSVidwa3RQwGrahYL8rzG8lozFyfbRAnNPllPWyUXIQlADd2LI4COZD8Da0RTJ/EjNmG7PKWG0s6QTOXKjSWlcjrE8VUeSJdTr/gvDrH4BqiVe/l5sLkgllz4e8ztUkNeR5i26CrSQdLio+S1RCQFlC19oovDD60uDIDK++lxOl6BA7uHbriWbnhJe27IB8xRN8eKI8KJ5i11gAaT+u60z+XcC+PPED7D/go43ywhHDf+AqWtAlAYAZhq5GPPBpbtfLNsciNkjMlA17ZDXhtdP7SrEKVq7MYagJliMohYhlNb+Ou9uJQgn/6jPnB4qRrdqVSg3eFQTIkozkh+BYcHH3AXFyEK2flhQcmX0k3GnwH8FBYX312xl3ju1ZAZ1jlB7AKr48o0p+jvC4d6Awwf/LjzO8TMheRj15RLjmaAGbu8RvdVI59VHVuAACwh0bdE2jYw2F7PJbeKt74uFAQJiWhPpzxSWa7LcvA7RepRmtKDZ36Gv/3oypjLVgA86LHGCqFw7KmV1Adf3ljwVmsTFoDndYnklQEt4aKgqnL+wm6MjgV5fpA2wr63m3bR8ySDdvP/JpS+U9UxA/pYa7PyhJ4k1ldj2e5LyxX5zHbDQCMAA9jxgrQhbDKUKqqQkfR+zpEgNzXkVYY00UmR7Q5faU6zw/QCKtdPJFTQ5K/14q+yJY3zZxahFegx3uNldxPaBXvyrhQ4XfaW9bp1n/DsZDLePZK28W8eqVDsQMIZrDrfujl3/FXe6EIoVWW741PuN54V1TkGEzkzi+YrNDT1S1nLrnJexQrUb1gBft0t9dGpRymNFwaTzpNjbXTvjlhDiimyeLG/iqBemeKhAZfcyIl+YF4Wms+WCILxFKVmCBuMh+jtaVxrblJHPbthsDNGu3E4wldvLTnX0CKQEsuC/SOrP2EaAMdIQIqXczRTZH8lXgy2knkphFS0
 2AajEjOF
 UIKE6XHjFZjGevWdP2bayAXNV5DwveBaqVl4mURxUlWY/LtZ2kzjv6bfowhBlkjAlC1kx9eozr8RcY3sVIK9dz2qHk/YH0XLsIk534OsyPQPC7IeKvFxKTJoxOfIadJLvitwiFxqDCJr+qpg6j0eSzfISF7J7KTdcAPko8rcNIS+n6Ac8l6cG7L1siAbMld17Lk5g7KoOxBurbJgv6+cRrnaXcesStTyVj8omnTQLlJE4cR6YdQ1f8IQVNXk/4SruSx6Iy2jGxEmLifwyTq27jZTafC7y8YExp/8ZPQzSgGWU9FgS3GilUtfSBCWdeHJo0ouhSel2bmiSZrEiM5Fd0vzjNDolI/5ScGNrz33j/WZvgPsJnEiy4hz1uQ1wwuBD4id6Qh0FVxMoLSd6wo12Ku3njmQBVwmam66RpWd1S3rt9Ycbe96ufa+/FFfNYSSXi3S4tNDIQGW0yExcgQATJtp1XTiHtPPwsiOVP20al6Fqtfeh9c1EOkJVnUU0jGu29E0JoQZDggiSVCspD3DIrezTm07RQP9fdF3P1qIRDOqa/PJflevKBef/j3e6knH2UC5x0risOjMSHHLLFgGU4ZgLKAeHvr4zhuW2tNZanRTeJ5Wr6m7qqXSvQEP7VOpO6OKSdIoc8VjtvaUJ0wiLqYGb+lNMVVUDcOnoArno/pdAU9FDl1IV9hME/10IUVbpSb0zM+c0+1hD3KjWhYcEJmosoA==
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
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/riscv/include/asm/auxvec.h      | 13 +++++++++++++
 arch/riscv/include/uapi/asm/auxvec.h |  2 --
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/auxvec.h b/arch/riscv/include/asm/auxvec.h
new file mode 100644
index 000000000000..0960bc07ccd0
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
+#endif /* _ASM_RISCV_AUXVEC_H */
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
2.56.1


