Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DFE2C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3716B00B6; Thu,  3 Sep 2026 03:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D116B00B8; Thu,  3 Sep 2026 03:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8995C6B00BC; Thu,  3 Sep 2026 03:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 695AD6B00B8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 146D4160423
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:40 +0000 (UTC)
X-FDA: 85171656360.13.F007FD4
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6B26220006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3jP4Qdtf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=s2g2u1zE;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acT7QjZNdUmpfnBE9uBNeofdPEPn+BimCrNJZCbn/To=;
	b=RvUvALoml1M8iEFkPqJxCCmY2o8FKwZY4HqGPv63qUs8KfYEdlQ88GGZWjb9MwCPrZdjON
	wLTTBg9O1H6yHZ9C9yZdEQfUpX/UWCTNo6jP/cX1VxmvLqnVFnt1fYcoNMjWW4hQG/tHXc
	6aO3SVx/5x1ZZg4ms82oeiSfdxaFoTw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3jP4Qdtf;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=s2g2u1zE;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421298;
	b=EokdoCjW2A0+vx5KO5IZi0d91sf6Urw7f60rsm5KfuZIcohfIp2BZoCb7rB99SziZlox+z
	J/PymJ9/GFzj6wOSFFpeIFA5RXpA6pH+tTHMA6jjHTyrZtUVmzaQdn57uNa4KHW/7WeLc4
	qyqDLru37K5AgHxjx4u0dZfY4ccX02M=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acT7QjZNdUmpfnBE9uBNeofdPEPn+BimCrNJZCbn/To=;
	b=3jP4QdtfvdGKafZk4gV8HAs0JKCcq1g5wS/L1M3Qb1c7h/bp22yYQ4TGtOpk0Mr1S/c40K
	vezg61PPYZqPkMIMi0P+MeWnhIYlWcTdnwH+SRrFrQj+nHm3Q7XiGS+vPJ4prnY7NtnqS4
	Xcm7eDuut8ABcFWFXYthMXqf5wGy9Ccz9usV3DQF9udUqTs+ZSL1h0G/e/uPiHShZ/Ewxu
	mmqEjU6o4o8g1buldyiSf74wUiAqSpfnewCZQA6Jv6yvahNkaYBKs1k4bYgN+RF3gqYYZY
	9mJxAv66dqtq8g2IiUO/pUOHIbenwPQiYRyIjphamnJW3UILkPOqYRUhshZy9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acT7QjZNdUmpfnBE9uBNeofdPEPn+BimCrNJZCbn/To=;
	b=s2g2u1zE4MoDzQePYnFomJgqRmXe5nRTN2VoD8bDtfLrzofrwt3d1WEshMMUnT7M9XzlRA
	0xw/D3K/rl1yL3Bw==
Date: Thu, 03 Sep 2026 09:41:28 +0200
Subject: [PATCH v2 13/15] sh: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-13-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1608;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=YKN2r1KwV0S2heb/8Y+Jhhyff24Np1SwL0Bw1UDwB4U=;
 b=useSqq1PQgc5jzt7dwdzir5U98FAJIkoH55nFNQGYdoiuFZAdgXYdssF8gR1E00nS8bRYsyyN
 V4+Vyu8LX0EAHidn3hUqdF1MdUf5WBlzeDxA5S/zQiX92l2UKGbW/Vx
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: eennugj9i64yrepqeid7ey7psqpuijoh
X-Rspamd-Queue-Id: 6B26220006
X-HE-Tag: 1788421298-152331
X-HE-Meta: U2FsdGVkX1+1BL9B4n+rZMcZQVF3pLwmLh10Q1jHBORSZFFWOMVaO60jFBN/DVEF0+43WjolYdc+A4LUgljKRIo6PFefeXzthUFYtb4QttYzxYQen/eR31OxGUe4E4p9lqCNdaCDPN4GZYFdMUpXA80sXb0R8JdcO6VZO3CWKKs/MuTYrlh1Qxl1tse3eh5k2eee37QjexTrR/n9eulVN0Modvp11oQnmyL/EBd3oM2gxk29xZL+lL2LirVGVYiSTudgD79xI+KwX3oibGoafSWzwoSgLGzIUTFWeeLwaKLxkp8woEWnvlZjm92ojaQMrr00c3a5nPwSX9VUlsE9zfSKN58gKvMTj9eFoydmJjwwF5Q44M7FjmHu8+diqEajA3ZUWLA0j8IYz26koHbSVBrVy2pz7LUvMhrR8A/R5yIcL7yQdKk1h3yigScCdGl5/QU4MvhgBdHqsTE4M6Z9mkNNKlsdsfu2NQOFFZKrcerinHwfx1PvZiDsF0j4L071hL9TtFhKnrZVQECzqXQBccqpo4+sf8Xjxg7eXtg50Ml28i4MyPBc9VlYon/394hDXzuYGAP1W2K7V325K9iGdT9kDaZdBxIhSPf764N6TiW0BrDDZp9q57A+gjlnKcgRIV/mpTUe+ALgfhrDwaJFqyPuCEjgPyCQyEwcKebQ5QyXZJWnK2axW/Ozl4TRxwF8DUj7Gc88pispOZz07+mT04lOl6tvQJF8zB4SMRPjv0S5e2Vsa9MDmjNqQF+3A9p9svxMxvnGCsHMAb8RQPrpZ7V0RvFwJQaGIWv8mi1/qc9CrFpltf8V699BVcF1J3flxWeBnhdNwmpymHdp54oZLdGoVc23Osg20CjDfhML6jVKAJVl6jxRPurpkrjjIhBLj9Th0+jb4mVnAX/ds9q9od2WPATvnHX0q7+c/AmjFyn2N1gu5m8cBZxjZOpNNFcMd/iim+rM9iH9UxQrHgE
 ise4Hf6S
 zdPDALi+WxFwrqdyoLLNkhlDqP4Vvgn8EKRel6NtUQxYeTDRhM//lqGAX5N7jS4S+EWFUsxLvlHyakclQmo8OVyPrxIEA2+xtlh2f+60/T2+R2YzICzs/Ev4vXZoMk3C5vO7qMm6u7J7N+iQ1H9ssrZ8h2eYCUMsipSeJEBLW40L7F9VYNTBG6J8NB0j+dhSf9gJ6RJo92vbl7YYgGSLBf5CqYBuIkJfcnmlvqD383diCjc5yfRlyweU+FX2fzgZ7IXQZLSPMjXkrKFhWzMguiQtZr+tVm/rhCwcaf9l/H+GUmp1GWytBRW4f5iYGN6CU9k4gL9c+MShm4faVwizBzuIlg9W0I2rteNAXxsFkx7Q/zoe4ALC+bR95n+VBJzxawqDvyZI2pANn18WxEaRysBaP/6yzKF7UVIi9cdNRma6wy5YGZmUAJ+EEfY6XG3aTYHt6lXSrkK2B2J7XF89VUbrQP0XJA0BGxt7b9n/Bhg2+i7A+J6I78i13ioDZXoZJTPdBLm5QHxDLCNx3aogu9YdA4pE8b61OomayNwKPpPu6+20=
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
 arch/sh/include/asm/auxvec.h      | 7 +++++++
 arch/sh/include/uapi/asm/auxvec.h | 8 +++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/sh/include/asm/auxvec.h b/arch/sh/include/asm/auxvec.h
new file mode 100644
index 000000000000..f0830808eb19
--- /dev/null
+++ b/arch/sh/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_SH_AUXVEC_H
+#define __ASM_SH_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 5 /* entries in ARCH_DLINFO */
+
+#endif /* __ASM_SH_AUXVEC_H */
diff --git a/arch/sh/include/uapi/asm/auxvec.h b/arch/sh/include/uapi/asm/auxvec.h
index 63fcc39e2c6a..cf0f13da977a 100644
--- a/arch/sh/include/uapi/asm/auxvec.h
+++ b/arch/sh/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef __ASM_SH_AUXVEC_H
-#define __ASM_SH_AUXVEC_H
+#ifndef __UAPI_ASM_SH_AUXVEC_H
+#define __UAPI_ASM_SH_AUXVEC_H
 
 /*
  * Architecture-neutral AT_ values in 0-17, leave some room
@@ -30,6 +30,4 @@
 #define AT_L1D_CACHESHAPE	35
 #define AT_L2_CACHESHAPE	36
 
-#define AT_VECTOR_SIZE_ARCH 5 /* entries in ARCH_DLINFO */
-
-#endif /* __ASM_SH_AUXVEC_H */
+#endif /* __UAPI_ASM_SH_AUXVEC_H */

-- 
2.55.0


