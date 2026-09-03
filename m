Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C1D8C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281216B00B0; Thu,  3 Sep 2026 03:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231806B00B4; Thu,  3 Sep 2026 03:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AABE6B00B5; Thu,  3 Sep 2026 03:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8A786B00B0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72341160423
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:38 +0000 (UTC)
X-FDA: 85171656276.25.04696A3
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id C264CA0006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zh5925hV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=p+sdR1ZO;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsqBa4DYT6UOJOiQLZcJsY0z2uNBnuWhMaLFwrPj+rM=;
	b=CfL2JJe4OAjWgw3bmIlnninhnsGWnRcOa0N+g2xU2NqEtbcZzV5NXw++UD/UCVauX68wA7
	xKkqU06QM6LwQ590OWLZbW27l7YcbWhgc4pw+pf39GlAJyRpBvphAVjeDlhjhes7tsvTpA
	PGcJY7OcdEEqgRS1SQe57NfnqmMxuZ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421296;
	b=GupB1uo9SX+G/hvcWXd6Ot+pCw56asnXZmTLdOhZgGfp1p2lkYPYAqxKVMtJU75FIWKBaB
	olddNQs5SS/1ONgmg74tNI+IMKd2cXngUqXgdZD83sm7cxkyNdSul/FkreyT/EMFsg9J+d
	o3HUmTr5Jz2u7MbSnYclB9KWtwuVPeM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zh5925hV;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=p+sdR1ZO;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YsqBa4DYT6UOJOiQLZcJsY0z2uNBnuWhMaLFwrPj+rM=;
	b=zh5925hVYaFB8ZqXkqngvUmrw9+a6ujcjssEZbyneFYSTtX2htRdyVd+bPbvOpRgBkbHKS
	UyYRl8bVC/aCmhDACl6PUsAGjL6qD6UrgJ6fMtX0XrK73AXH+bTIM0RQh9RqQBqTE7PfWd
	sy46BX+9UVIXQQ8gXYqvn4EW9yJvpFkVlqSZcEgQdubafxa5Ht10HI2PyF6YkErVIB8+Pz
	tTtz7udMuul61G9wZ8BcAdTTwiUXTNFB24x65Fdz0iHU4ieKAxzzI8OryCDb0/Sujiis8f
	xSWrzR7JgVoAUIc97d1Z76rvV+zJZLsOMPXpSeI9zqAUC1bi8nMdiAkqTFv3cg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YsqBa4DYT6UOJOiQLZcJsY0z2uNBnuWhMaLFwrPj+rM=;
	b=p+sdR1ZOWyxm4iWpsvHvJ/zT475he8+gLNu/e+0exOHrUUoHvzRjT1tFhSKbw+QZymljTy
	5ABuxLobpVaHXeDQ==
Date: Thu, 03 Sep 2026 09:41:26 +0200
Subject: [PATCH v2 11/15] MIPS: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-11-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1884;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=cs0IiOQ51smsz0pVBiUdFi4gN8rZXBN55vGK/+lYj0w=;
 b=fgMzeADRsHBHDhQ0aBCRMVdgaCDOyOHavpx7wa8hChxiqtcHW4YZOAtPgh6azTmpGG9KLODsH
 xiGj8+MIrP/CxqeNABlDpjpPVwhKierLeYQje+RQU0pz9pb8sg6KNDG
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C264CA0006
X-Stat-Signature: condpidofja1gmay7f55u4xjgry7fc16
X-Rspam-User: 
X-HE-Tag: 1788421296-482398
X-HE-Meta: U2FsdGVkX1/qHPIeiR4URupgALXW4ooHlq/xJlzvgzBDXhU2QVoPF12D8nQWkLZ8yxN5xmocqbgxrLh2q2JEFNZLdFwY65eqC3bbz0DOhYhJE06WrEE0tvHgL1MI0jsoIg1F6lKjlp7V4aQ0hGNBwPMXsN56/Sva5LaAJHVEbKCFgGWgRUg3ArAAZ0Nwrak2N4KXg39gyMu4H9QKGd4zrcaXQHoFZLAjTe6i0ojbY6DOc7ANUu9NCC1YPSsfRfQNAoEHvKqvhTsePz4ZPdVCQD22/GRDdrNXq56gk18/TzV/ImlNhrSgQ9FQpa93iksOoBGPhdeZ8HNFsFB94fh0FONgFdyiSz6GvToRsF9uoojxzymToNmqJN/yJAzKpP1dgGMiHsOjr9ypZX/4URtBfR64KDPL+Wk7D6TUjgtZsGBExt4uTkQ2E7odaC58+4KTXoCfqyXTSHsOwoAjht5L2chUiJ/w03CGcW1zrxN6cUOdgBfnNlEzcAozAuILZezVszeOgjxCmx3MmkP4eOscoJfuk718mkQ/MuICIbp3sDZXmyY/2cD3WftFEAZIXJEfokj2EYB3WGwCg1F+hkZax2plJykiMArEyMe2ziK12+W6R4bFyocdRB7B3MhqCGvIWDDSi2i2oXVU+/GFDL02J0oL4EI9wB2YnfZxufae/lzLtx6CcVjFvqmlqVWddwHmhhrV9MOe9PL/tgiZyM30fC/TBcEWHyzzVCw51nSNDqjjZLPV+h//cVl4tGbafPcLV5G6HlweApOWImi9/2ieJzWli6upFPtC5gu7UGfcDCgwsU4fojhAq0PJgBqPebZ/tXwvRrYZg2nKT4M0EA4Rfayz9XwWgoymFIbs4fcUM3j4pd+0ZOWLY7wc/ffRzlSRlmRmzA8JP+tiWe3uNuvts+Mmk9jaqhpu9/1cwhLbfRklYO+02oZ8WLdr1nYnMH1NoBEZ68n3ER2jelfxteX
 NVdcK8NX
 zRdSAYdFD23zA1OVyTfUgNfKe9ZpL2yFwUqt8DpPvvTEF1SYgY5xR+dRcPOBX5U1ONX8vTFYkwsyr9PpsY4m1lG3cu6naenGvTwtuVlOSS1oWWb5JfKHrF2QZCiexY9ZPNexp76/SiwYsYBJLhu4HMvfLmuheQpcQOc11zA0agCwy7i8apuxM8W7werFZgiA2h8WV9NatB1z6rl/FFQrFcueJeAZzuE0knvAD89kYjAj1P/YX8qTjpta16+SqA7THtvN34kuf6gCeFlcN9Qe7hvTs47YP+URxadmEiwVbQpRxQQCrvbSPlWdfB21bnxBtMZT+g57QIgHXJ266GFGIoYvQUbNd91PFsgius2xqnUZByFiQIUMY+5sbPd5vGVpVku5DBit14TGtvSLOwRs2Qx4dy10T0ZMEv7o/CHlP96eRS2yqnZmawnBBv4PvM7+3Jzir2QMr867vdqUl+QOzbDeq/3JmBt3NhkATablKj8qEQsE2VNOsTmtYEsRV4clwVMSl23wJyv+mOlszeGdDOyr4Zew7MWjx/z50XVo+BDqH2tgc1opSRExWnGYVME/rt9b4kgJw9NOxyz6A0tao/RZTAJAhK4MMU3rl
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
 arch/mips/include/asm/auxvec.h      | 17 +++++++++++++++++
 arch/mips/include/uapi/asm/auxvec.h |  8 +++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/auxvec.h b/arch/mips/include/asm/auxvec.h
new file mode 100644
index 000000000000..76c445e7890f
--- /dev/null
+++ b/arch/mips/include/asm/auxvec.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright (C) 2015 Imagination Technologies
+ * Author: Alex Smith <alex.smith@imgtec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __ASM_AUXVEC_H
+#define __ASM_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
+
+#endif /* __ASM_AUXVEC_H */
diff --git a/arch/mips/include/uapi/asm/auxvec.h b/arch/mips/include/uapi/asm/auxvec.h
index 612c2c41f60b..1331ac4d935e 100644
--- a/arch/mips/include/uapi/asm/auxvec.h
+++ b/arch/mips/include/uapi/asm/auxvec.h
@@ -9,12 +9,10 @@
  * option) any later version.
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


