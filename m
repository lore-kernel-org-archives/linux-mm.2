Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C737606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=TR8XczD/;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=hoHVYH9x
Received: by kanga.kvack.org (Postfix)
	id 1691A6B05C5; Mon, 23 Nov 2026 04:37:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2696B05C6; Mon, 23 Nov 2026 04:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20966B05C7; Mon, 23 Nov 2026 04:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE9C26B05C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A92A807B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:34 +0000 (UTC)
X-FDA: 85465881228.03.05A973E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id B8E3080007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="TR8XczD/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=hoHVYH9x;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426652;
	b=iEFIHRI1QaH3eEVo66SBf4gJLhkst+NYtyQmrW84trMm3Lk+8zPm5GansAsybicRsPcIrL
	YSs5qbx5VP7JBlg06kNQlLSX5P7zxE3LY+nfUpUJBSPu88O92lr1WaeQATsOiUC2PrGLd5
	4YZRLJRsakdUu6R2yufh1dROU0/aVGQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzqRCnJR602SPiJtJXTG2PDcd45+A0tgb/oYXFQovLs=;
	b=D+vYWjehJBCbXpeCdMG3U9t0IYENzOz3RlicshleDWE+iWJr1QM0dod3U7FDcqxS/o2zCL
	kfiBsYrW9Rljw9lvQ4l6jHQhGAVGhO5fCjm4ISPinkkcbIUKFzGVD/Z/hr0d2X9M7ZkdhW
	GO9wrI3RcX+unKbFqf9ETdQwW63FO2A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="TR8XczD/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=hoHVYH9x;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OzqRCnJR602SPiJtJXTG2PDcd45+A0tgb/oYXFQovLs=;
	b=TR8XczD//6I1MR5e9lJz+GijeGBKJ/F77cjTzH8vVoII07f/tMCwr/xGjF4TQGtgulC1EP
	vACmE5JKgFiiOYT5KMeM2ILfQDDi13RwanO37c9TmxxeyyWSa0jXluHBhTGxRKR0Yl64Oo
	7CYJEReknofWyo9+snoBGSVkCzXAajtax1AaQ/4R5wOyeTS+P0v42R8b4YqyL/j18nRyhy
	mAwleNFjqSK+iTvML/y9rFNzZ0CRLbBTDuzjqKG2uRk179PYD2MCsPQ1UIFgLV23Hjv6Nc
	mYzD6KuLCKi+7tfSemTLaki6pb72ly81l56+DTIHo3Ug7lZ9pzlij7cZQsJJsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OzqRCnJR602SPiJtJXTG2PDcd45+A0tgb/oYXFQovLs=;
	b=hoHVYH9xKLXuXyJAz+H1gDzElbvGfdJZ93NePphkmUT76//hgCh1ZCl3cIDoWvCVOzkPxm
	cENh6xJYPcEMYdBw==
Date: Mon, 23 Nov 2026 10:37:14 +0100
Subject: [PATCH v3 09/15] s390: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-9-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1450;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=XHafUQ8AvHq+zUf/VxtJZdze1xMjqQNOG6NhH665A6A=;
 b=oxMrqHfHeIxNkNvUbLxa7kn1LyC91rAIVfldoDncMK3YDOPceCuvoLmcVldlsZq98SdN6iXBt
 Y22qC0QCyKzCx4lysgpfyA2b5U5DJjnjaaEah8tYPviOHRifBjjXfLp
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: zz3q6yfz1m1emoe37h3n4xrxy9maxewu
X-Rspam-User:
X-Rspamd-Queue-Id: B8E3080007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795426652-423992
X-HE-Meta: U2FsdGVkX19XJ87ETalNu68BrRii3y2Rc+aQ/afXffEKXPZ/+8Ht1dFqoClq2PMW6pJY3mJsFNcVSWWHQu12YxAhBgm/HsdEAa792MsJ0D3FtvFrpurOVKFCiXp5aVmscpMjafnINZJyT08hiMSwygxsML5216ZBB68ql8PNczwl8IG/vEblXY+GsALYSD+sUXmfXXjZbPYbEcCdU+4ZOJVLoXh4EKj6QIM9XdCY8fear4fbpZmgVyW1j8DTVVrv1s6z7JnUU4AOp8ZdNe11+Kty+i6JjHa45eK9oLPfEXxESjZtXB5UyZAaOA6aNBwCqvroML9v9ZD1GupHi1IPoSgq8Bk808v3g+n5sxmE+A3ALrWbQqjSqCnl8WEJrQXSTaGtDaRAdEugo1Hn9njUuX+K6cPf39mVUBS84rFo2QfUfYBAbRJT4rVhnv3lxV75q3EULoCuq59h7ehjJW2MgclCGeGN96isF+zniWH5ymXa7Rbey8OlMmBTYgXoaGJxQv6fPfLpQBlIxVIN+IMskw8jvztjF7Id4LnEXcQf+WAYtMQyfLn+tpfDs7KRnv0I+wTQDSJqa9xCUJrN55QGQQJCApHVe0gsD0wbyPs2dm6hW8xXDW0+OpUkr24HTlU8H+kOoqTeNDyP07AdVJC7TXqr1BXN9RnyofaYtUaVp29eBHuH45SOEkr6dqO7n1UhpoG3+bZKKRgD5dPIbFmoZzJax0jpiW0Vz5Z57P9GFfqJYmFcY8Zsb6PZ2FTjwQxyi2Ef34kQVfe0Vg+/woWzJiZbWtCOfq4MM++wGjwIOgr10cY3YUCcm+cCiq3MO8liToUnQIOWUdidkGeNQcLTdjnq8I6+fKzjnqX+SIeTNmLDMRrJphEFWMIqITumvYLDexrDNVccVT6EGFE395cw1bIINCzbaRPbJu8XL5xTZEluLVCTdz6nx0GuPjg93eY1EDgR/kPShh9EI9HiDUI
 95xzSxY+
 al5kztbGlH0VRi2lDBhSOH1zhxSwsN7vZ7lBp6GkeslJJEhILNr8bgtkGMneic6BQiknQHBB4ZoXenRorcmhdu+54BZ3wpx6eOQFsWEVbYD1GnF8lkQMXDxi462Xa3HzUVHnCL3Y+S5d2VW1BFzJ5+ej4EQb1z5AxfltV9ivAtWmuCI+GRE0TgF6T5OhnSRHRg1EST2CL6lD2twdFWKBr9TsR1lGT1EQSY4tFzyUdJrfm/arhJ3c01U9JxiFOpjw/4KUlX6dTWou37sPoah1p0wt31sr4md0SrmSQhIUBeoevX7J2CL+vMhlJwibKb1WqkrtjNIix04nDOYbM2F6djKoruGKl7Olq5Xo2/W2tzGSus/8GY8c/TnuMLGlQsBSeTBeL0vWtlXU16GXCIK/3+3ZAP+OHWhhfh0106sR5IZj2sRfhrlYDwlMp/EW6nCdTug+503BPp45npnRZjFbzZEL5PdtHf8QX3C3ETzMy6mmragIoI+R2RBaaSCNr8htWMkCmbAx0xNCNyO8ajmyc//SNoWcyFs0wNZHN4V0NIGH7QtD8FmcSk1/m9geiHtZh5CEUn/O5aHsCQsrQI4dhwOli+Gm7kXFIxSHv+wfBhS1jlBJ+0CahPgNcfvuyyqDOnnLfBKRBhdnA+9GJn5sEe+zTb+Yu9cIJ7fqHjT2cJbchHBpvGbLonahuRX1McsE7suNb
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
2.56.1


