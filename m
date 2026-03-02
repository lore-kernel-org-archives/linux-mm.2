Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0E0E9B36D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20F5C6B0096; Mon,  2 Mar 2026 07:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1146B009B; Mon,  2 Mar 2026 07:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CB06B0099; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB14E6B009D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9EC61D20E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:52 +0000 (UTC)
X-FDA: 84501044544.23.2938E5B
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf20.hostedemail.com (Postfix) with ESMTP id CAA1F1C0007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="u5zypD0/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=YRuN5Am8;
	spf=pass (imf20.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KXDeF7UDpB8ZiPE3iLm028k2zogpL4XBUC66IjBoygE=;
	b=Yf1uqGWzf/NrVrTEkGXMJ5k7GrdxqJxGiQEFlE4TY3vXRNgrQwqsS06enDHj/n7tITCknc
	DguJiWevGA8Ft4JL3YslGnQe42aWaUP/gHweeCLSo0ctIaZjTdSsIAENtXtcK2/ALmjB13
	VFz5q96+x1RCrnFTDvqjTqaVE28eIgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454351; a=rsa-sha256;
	cv=none;
	b=Fb4qfzGdGBUa+Cjg1LhtfO1oF9TYgeAGny6+vmW69uBg1VCJY61xSqqteH29U7XnVWCkre
	fUeqbY9L4LCf7p2zKoq9kAqYPVrc6EsT5zO8kVpGaUFY95iOlJRLDiNe6uBL/J6frPQTNf
	2PSO9JGRfoC0GX7n7LGUPl+noH+Qh3k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="u5zypD0/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=YRuN5Am8;
	spf=pass (imf20.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KXDeF7UDpB8ZiPE3iLm028k2zogpL4XBUC66IjBoygE=;
	b=u5zypD0/i7Uz5OODrlF49hQ+lpWWTOdLI3nJOWR1OIvOaMO/3vb+rs4YWorLAbvP3SeupE
	efw3ir1dAVgCC7GhhgW3qdEFCEqGz/gSDiFzw5LRuYIKpRBxkhhBowXFddLuhZtiaOP4gF
	dlepkL6XEteTWqc5T9no4ZA3k61IKxfE6IyhfQStErarfrPL67AkxEbr6CYYlqNEZQVMqN
	NX7z/XIV3AaMIkKD+rc7xX8BEr+XDtbuCIpEFqfZ3QBZQ8mYAYth30AHwbN8dJIxz2QK7H
	BcQ+zup4ER2aBs9NnJ3azWnJ9/PQBtVXq08kdgFnw32rydUXnsqSCDbbdOlVJg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KXDeF7UDpB8ZiPE3iLm028k2zogpL4XBUC66IjBoygE=;
	b=YRuN5Am8QTcAru6KtUv5IvXWiWNuN4ajxCeRCgIAwKrJtoAJkHubhsTbdBJDWkHmvs5dPw
	Q4dALwGBXmkPgVBw==
Date: Mon, 02 Mar 2026 13:25:32 +0100
Subject: [PATCH 08/15] LoongArch: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-8-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1725;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=+/a7BCuaRvs/grFgisGI29OqfBKuEYQlySRlV2+Ad3w=;
 b=PsVs/lovJCA1Gx2WwwkdDjFmcUu2Juw49xEDuMkmmUjNuORoQIekOKf3Yr14UygMky0lYF1th
 pALKMlLZtR4CkzYTF734/hb85wQvMSVlXVQIwWJIc24yD/mabNmcyJT
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CAA1F1C0007
X-Stat-Signature: i835i3qxeom176c6h7gg5gnp4skhp4rn
X-HE-Tag: 1772454350-232906
X-HE-Meta: U2FsdGVkX1/9dJhU3gIdYN81yYGIwIn9vz7UTBC4EHNedxqYdnZIzy1y8L8HSrvh98MoMGvS6mwg4I/mLquolbZp+XHrso2fASVSnhKpKNO2NbTG0W6M5EukmxzWDlYvagp9ot/FrYPjb4qiBmTOw83phXIjWk7MMZvtOO3Ju9UVq7oXtoZ5J2Co+ypRysaKXqUWzLd0bTwp5N9Dm3LmtKhNaSldAzRCUjbqBWbQCeeW/iSa+bKNf17NrQ78SUqpr6iUoPrFPgdrPAJq+exwoZb2l/iHlP1rU+qBH1BYvM6OvZtUDsE9VJjJPfnqrbrhzKw6GX6y1cJ6LpZVWat3i75d1VzKxaogdNy3u5nkos4xnmNYclEaNewlMfO0fh0bUbNsOEGSsAoHMrgAZ0o6NUHznAr+p1DCgZCjT+/cT+bqAu8zUwfrpN+dgk3AqKWYKuYLK2oq308ceT2xHwkwpcuiIDr8xboshhd7FR3Iq9gU1FWlO9wvMYfLpxlFMoU84hcF9fO9/a0dbmOz3Uk/dR6sI55Nq6sESNaI8BZItu6p5MENu5CCdoDaWUWzFC2CSbY2MIyiTnpuu9ZXPKsr4ONkkKTAsdc1RuAFsMXAlqdHEBaxhziNevR49DTxMI8KDrcD+E7lFX3uKdr3TU2AJOn8gzQeNbsd3c/btnTAaJT39tzoHrgr6HCPgAqz7g3Y1v2OHVx4rSEmvN51X5OdA9yXGrTojUdK6XhDa1UdM4kZgHJsdce6zm5i7VVaugpfZUTg02Wu1pUTIHrucX4gr1BMmAPQRzzUDAc9ZBLFaudqJllL1XkHgkgzOfxdv4OQHPmCzjwDc7J0LcnpMlUnka4HuaVHaHKcJb62U/nta7jsMmPK+V23AWswE6X2TcDDJoef9kXUVl8rCgTh4cz2dCuRyytKgRC6irUen0ZJpS6YaD/BOJPCrYj+LxXCucpd98sfrcRON2iIEj9Ex1B
 Z5oyMMWj
 2CmgnKfIwIWsGqXCspuezx0I/91lP86KITBzrws3LpsHFkhwkh5Y/qNIO92I+FeMKfab6vyh1VWvQWW6Sq1BymEojDBr8+BcmmogXuBSqGEYtoApql8k1wS9//earSlSu/scXXgwjJ6nneqw1nz/VapqNx7rrCOHaPa/M7aDIrykKV9Tbyv37jVCVw1dgADlgCSm5Q8oPvFRZczqDiHbvnEbiFvkMcW6G8YLO6D1nmn1WT55wUpu6lZT6EFectaLCg+snEcSFeKxx+HDb3jfstTklqs+A/CQ72W4m4ag7fgvB1saVXtVw0fQuoUPIB0yu5eJqa8nI40v12bHZAqLdtpmcVRrPZzlSkP8qrSLy05ZVwqlXnf1vlhhNlZaQMqWI9eIB82RBQ/UR08P1hV7qkGnrAj6tGV3q9aN6ZdPNZaWqamTzeuTP9II0mOvMuuyxC3sFgW9XDZ25vqzxVB5n2lDzXlQ2XPaWk8sqKFajwaPMJR14cEmh5wpeth5HfgBI4kjSTrv7Dd0LIPw=
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
2.53.0


