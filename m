Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F65EE9B371
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB1A6B009E; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700116B00A1; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC356B009F; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 107A06B009D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6936BD658
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:54 +0000 (UTC)
X-FDA: 84501044628.21.2B4CA6D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1198480010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DRPBoJTS;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=l3N5HQGw;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIl7i97gp0WaH6kynmrYy0424iWZ8UY7WAcAVJym5Rw=;
	b=QYA14/cZXcJdqNRmrU011xEodSP8rr6K2Ju6qXmQ6bg0Gq5FEHheLutQilWLeXINYGii5n
	5/ZZvadvqFOVhUPG+o+xh2PLzq0J9lU3c9wnAWNPbeVDSHsxqILiAiGm2MmY+xIfUcnCuu
	aTTTixjKmr6x4RpfqEgAuKV6ek6/cgc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DRPBoJTS;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=l3N5HQGw;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454353; a=rsa-sha256;
	cv=none;
	b=WF9wvkQGabffH66BSO1fw+ekuxA/gpQuX7JEsJAZR8NsUktVpALOJLXhYeQwhUp/R3+qkv
	TKfzsgCBBATMazi8cW8Inj0+ehyqhlm9LXrhCWurgbhsYQoDGmlLwtmZN7Br+Jo/KXkWN7
	9rKLbqdntmb7OaVlFDHYJFh8PzCIDR4=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IIl7i97gp0WaH6kynmrYy0424iWZ8UY7WAcAVJym5Rw=;
	b=DRPBoJTSt1Cn72FxGrkICtx6iDm9aDHjx/AiP76zWoLsyxyzrn4ftQM8rjPsBPR2yghAxc
	iR03PQOiOtY65dbfApwClyN8khUvycPTz5RPDD0zS6rfyoHl/BLatzcQVmp558W1UrU0/V
	DFLjDsmsvIVFvnRmUwCirnFDQgXPo+umbV9RIGje8FXGAYZUx+Oi9PCoWGSVr6fjD4npDk
	X0e31PVB5vjJFxtV/JxaclK2glIQQnIbrbYGPZVHGwtbyhuWE04K6kgZN5ywBmzdxx54K9
	oRG0MM6oeTqAEIOftIbOHX4Ql1V8Gitv0Z0kUSKeQRgIsWMIjbEf/G/ltVyCjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IIl7i97gp0WaH6kynmrYy0424iWZ8UY7WAcAVJym5Rw=;
	b=l3N5HQGw9RkKQ8pgKQOl0uOf0kedifyuf/MGCLSijjuMiUCiOQTt4T2v93KxTFefrGNyku
	1oJIKuXH2FuNXNBQ==
Date: Mon, 02 Mar 2026 13:25:36 +0100
Subject: [PATCH 12/15] sparc: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-12-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1413;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Iwaju8vXi9F4QFXCQeLchkBfrV3+4S1lN9ALuspGOMM=;
 b=qYE0Cjq7x88NCS4YgSX8MOndLBO3D8QhHWThM4b0UUGFInc+vhxv4cTOMQS/J6/diZo2W/4vM
 jvG23iECxNuCS96zpughHWKWr8+8K3S6bWHHCGi1ZI/2c1sH/jMD9lc
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: 1198480010
X-Rspamd-Server: rspam07
X-Stat-Signature: 18qou4y9sqd5ax7gsc1wtrm9mt8kcbb9
X-Rspam-User: 
X-HE-Tag: 1772454352-481321
X-HE-Meta: U2FsdGVkX19JrfPJjF3vTWlwvm+P1HYHI1SKsm0UFYyCFveNEwpMTkwGoq2uuEPBdzNoyYlkn09QnhcIGmhvDEA1hU5LN3T9fQlPzwZtTtniKo+TdS0QGuDsA+KSRtQKtvgX8qe0yAvguCDawa0tbb2ZLqUFgkklr1IOI+LyRLzvuYbS0wdZFfzeehI1vh+dyEjm+fo1rhk6toIlW/Q0YSUX/1+a4UsEtkXzmKpDygrd0+Ml2LM4wbRBVAIMODsxvGq0AWcys8NIyTsOirYe0lF5qwvRkV0+LAs4QsEQPbXRave3beu3dagG+VvedXBD2uJCit0/a9tskfsDlww/7zrF/DikDAmeSfFu14Ex8kUMdPI90B1C70bh4BSqRt17fMoO9BfKUG/ZHohaFKgo4YMLSFt1v7qON+g33JX7TNW8Q0Usj+gWXMkpygyC/YEgtvO6bgPh5NJRPt55Sp9eqiqbysJB8/Tgg7D5pZnBorcx/2v9VkcBH4HUBCpE2FaXN5Jk+7rWpmY2+uPTX5rcW5z3hC31/ylmxeeX3jD8X9Tl170xM0OTkylQOR5ln/+u1ZBHF2lzQl2E04zGXMLxZbWUDFJ96DiJoUC0lLShj7fUs49ledSZI9OqWiAs82L1A79v4lB7h6ZrIRLzbSIBM9QKtJNLjklVGxUOG9ikyY2NW3ew1Gs0XcyCr731wjWsbpt+pmstLajt0p0WbTJmfpfq6VucndsveWk+sPlEwdRp+xeZk+DPtrUVbp+Tc5aRnmUDlKbWD3ABiuK3uEisZuTM8op9AGKDTnjD3DWMcZv1lppxcUSGR5q9tqsTDDcHug0q3ugmSRyYIWzT44IHfPIgXNFuSjIUGeie0+QEU7NsJVY8qcr2t62MEKR1uz+74h+pcm06/6iHcLXAYW6fhRfaV4zxI+cIP9hvPuXpV/Bv+levxzhZi5FgqjJjPvQPQwRWZphpidJpYYGL5+7
 VzThmGSR
 B5UyQnEqm8xtbFcv8EXGrWNqZrFqjZuho/UgQlsZ+yBZEez3r8br1OceO+npWzcBMAnHrqjgPCj8qJtakWakvJWbYFMsft8gpNnQ6bHJf+iXEtxb4EVTlL+BoWXDPkgAO3en8WEjJxAMu1brUOM9ImhFLbLvzAf+e0KnEU/lxe5L3qmUH08wFrVpPl6+Sx7ItLBOfjc/P3stOg5I1sQAPVQctHlEJuf3difLZ9viZ9FNZXcsYB4z3erRAqFmlqD695bqngfTL4EhQJdjDDlqWYr9Jd7M1pMqvBlGsNASu0LS+vCwt4nxwiEElE91C0Jmkmr2l7LAfRh5fRZNaKnMqtwmLD6Cp/EwDhsnz8vK01YESS6pZwbDLVgGoN43SREu/BvjgzrLAW97UJC0au8VRj8KT3XkbMsg2kaU5AexKMdab9r67Ex68ZeBlw9UVfo21c7hieLQWhay2X3arPSQWe/np48auIqVZmXEa57r2wUO6XEQ6DJNp+k2xW9xqHpbbuHCk6NYibAbUfRM=
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
 arch/sparc/include/asm/auxvec.h      | 6 ++++++
 arch/sparc/include/uapi/asm/auxvec.h | 8 +++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/include/asm/auxvec.h b/arch/sparc/include/asm/auxvec.h
new file mode 100644
index 000000000000..50c249a8bd17
--- /dev/null
+++ b/arch/sparc/include/asm/auxvec.h
@@ -0,0 +1,6 @@
+#ifndef __ASMSPARC_AUXVEC_H
+#define __ASMSPARC_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH	4
+
+#endif /* !(__ASMSPARC_AUXVEC_H) */
diff --git a/arch/sparc/include/uapi/asm/auxvec.h b/arch/sparc/include/uapi/asm/auxvec.h
index ab8780fb9df1..0fab3b29148a 100644
--- a/arch/sparc/include/uapi/asm/auxvec.h
+++ b/arch/sparc/include/uapi/asm/auxvec.h
@@ -1,5 +1,5 @@
-#ifndef __ASMSPARC_AUXVEC_H
-#define __ASMSPARC_AUXVEC_H
+#ifndef __UAPI_ASMSPARC_AUXVEC_H
+#define __UAPI_ASMSPARC_AUXVEC_H
 
 #define AT_SYSINFO_EHDR		33
 
@@ -10,6 +10,4 @@
 #define AT_ADI_NBITS	49
 #define AT_ADI_UEONADI	50
 
-#define AT_VECTOR_SIZE_ARCH	4
-
-#endif /* !(__ASMSPARC_AUXVEC_H) */
+#endif /* !(__UAPI_ASMSPARC_AUXVEC_H) */

-- 
2.53.0


