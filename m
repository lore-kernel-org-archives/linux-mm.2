Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782ABC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62ACB6B00B4; Thu,  3 Sep 2026 03:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBA76B00B6; Thu,  3 Sep 2026 03:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F16E6B00B8; Thu,  3 Sep 2026 03:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26E2C6B00B4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE7F11C1D30
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:39 +0000 (UTC)
X-FDA: 85171656318.12.F0406F5
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1CC24140006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=A7uMxPFG;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4+LXrGA1;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrAnP/C3vIIV9MfVxkKNdnam3FAI0o97+nAzFrr7A6o=;
	b=PAtE4iYUjiqyXs/y69AxPn6K9WZnEJBLcz1EwFCVsg0OWYtOGj6/cqoe2+KpDXFqibzlFC
	NdrZUHcVFbBuiDUiAFSV9InKX53WnwPXHTCDpU9akoAjLwRw5LwUoa/xXda8oNMd8Mlp1/
	MA1H2FpYmIaeOFRGM8S80Ij/sO7N2Hk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=A7uMxPFG;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4+LXrGA1;
	spf=pass (imf26.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421298;
	b=RfeWcVI0TxV3JexCT9v5g2hobRcP29psPJPXNiD724aE945xRz2sYcytO0ITIHfVvOvWC3
	F1wNXWRh5QEOaBcfH3fqg7m3GtJIpg0FsS3AwLrQlt+PjjCEAk+IoFapKt6r32dHsKQYIm
	X09SYv661Ly3sUO0Tv/4lrYv8OVzcLo=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hrAnP/C3vIIV9MfVxkKNdnam3FAI0o97+nAzFrr7A6o=;
	b=A7uMxPFGSNRKyM+CJ+qi+nH0EVA+MdWp35wphWaEq2E8+0fRn9MbLOB3YpV2ixqEZxN/yY
	o3xT6U8duMUicllU/fFzqeNAcXNYjnmbWLuP9Ch69tr76jl5AlQe3N6DjUD5g9hRhZ57WZ
	olbXOlRtqjhM3eDLMpgailyhTg1ViVGBqUv/W2UKgy4MqAlW6aRfOEnyEMEaTbcMfyg3v3
	AzKBzF8fw0Tus/oHpwhzkco2BlB0yaOGb/fhK0uWDRdoSDCtKLzR4FiKRwpXRiUZBZAdVK
	n+fwbsrReekXVse4Vgc+2+OQC9qpYeuhvgKdvyN3IcmTz6oKlgewhGS31B7Vvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hrAnP/C3vIIV9MfVxkKNdnam3FAI0o97+nAzFrr7A6o=;
	b=4+LXrGA1BNsb+1bt9PPBXeYwlB5OKLjrbTPg3/JyXLOelfRU9JW6w01qpy84FUq6+qD8x1
	o8BYkU71G9JpY9Bg==
Date: Thu, 03 Sep 2026 09:41:27 +0200
Subject: [PATCH v2 12/15] sparc: Remove AT_VECTOR_SIZE_ARCH from UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-12-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=1455;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=BmY0rNeTgoOTIM8NoOSOBKd7iOT2/BoW3MMuJmEOpcY=;
 b=k8LJMytIpq8a92cFKJDRyQD9G2gB9e4yHENKcxQqZFuxwyQL3K6Na9Pxjb+tfuD8ycnpiW86k
 er0SGyhyT3cByQa0pEx46UyDAAhL+iId74x9DTkTy68/ftCipnFboFb
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: 4fkqbeofz5a19ja7zcjndpc49stg7359
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1CC24140006
X-Rspam-User: 
X-HE-Tag: 1788421297-520107
X-HE-Meta: U2FsdGVkX1+3xO4hXg1B1ZG7B0hJOPkxQ6HPZ7VP02+DShLIZ1Ig5baot4UyQ8wy627Nb2bDiqiLV/CQ8JcKiFh6N2H1qZcBW03TUUTgrxqqudbY4yy5wpJ1bnko0tFDUMcTXRTT9l8bQg/itqMrxMLbEgIK8D8Cp81tvrFC5D2u75rG6BTVdKDVvcel15v8F0/BYekOF6GKtJ03N2ES02kk9FMvCF5mckF9yqWy3h25iIjktn++TrwCwF/dznMIs1xcKjqR8WfKZUq8vMChAdX4vLNDFHJxhCUHdPhhVE8C3OLg8eRLJvJm7rLVGwqSY9T66YC6Z5nHeADVaod0d2U0aza2nHeyN7xiSIsUvM/EtwFwSTJF6ogf4LkLw2CAxTq99fSvi03Bmpt0jACgEasHITefVmx4WXQYwrv1hWl04DCNEeeufztd3isn5Dk7A0N1W+ZmJnCvALFzJq0Dqypf7RTZfKp7yAT6y7ybJ7va3yunO8Hshal3+WMUHz60nVCwZN/019Z75u6vO987N+0aba/RSsDa1Lcrlc/+YMJFHJ41toS4GA1BPWD1jpHkPTkQk8+VV08Xh01rN0+pZqwWcNAOPCQx4rnwjEsIVqpambUX+2LFEQ5s/+qb3oc9zJSBebuNsxNhi5tjdwfSAZZINznonuiOpZz3kXtQlJCe8Z74dn6FkUW4N8uyw14J5TPFBa0DBPloJXC4J5dPf2Tfl2yR9QEc2wzPEXXSW1ykHD5mGZXobL4ffEvEFn5RrpWScO+d2HuPPOtAsQZknOQoQzZB4xlahkc0YiQZDF+ebhKeap64KtCnKqXxgO5/+ocuBOPCIfO9ieZ74WVCuuvhrt5fcSabbeN2FZDQfuauhwh/9+0/vL9P6rxwRw7AMhgN5avSCQp10uToX2QbHkJGmq9YzIHAueZ5uzDYDHIUbALoGOf8KiEyp1Wip4JyiUbCDpOVoV6Rz04euoC
 u6+j2gQT
 eXebyk9tnlwR4lEaiPN3qIUzr6+xIPw/DxQLE2OlqwRmC6T9n4AITeEw4OsMPzn59Vvi+xtD4yb+o1j3rPcfBoDkUBph44hkJxWLlEQdW7Akz+HCCFWX9KdLePcSmsl/EjfDRo3Jackxpqojh0d895d3s8kFEnajdpNrENQaI/S+4Rva0GkmPXLdvUnzyVIn4YRF4vmFfTxHbyyLVVAwUGjr4RNBuKPhXl5N/wDB3O7nq+exni0EkJ5RpoEv5aElnwDmmg9JIPv9xzUbMiF0FcdP0yAsTZeO548kAxxkdrDMy3aiWN1pxk6eHOyDTfkbqsmJV+KXqBeN38Sk6uQe3SLjISlTJuadtf2fs3zzpS8NAhtSKGmQC/n6ttgA3mHoxYw3aXiZt5OMUcX7JvBqcf+9CfkvTGcq+Ph2WLLNS0BdOWqg6a6W2hzKf60cQAKqU17Aa5jYBHllViGa3HsSB3A730e0I3kKdl+13kpSgL10gS9dtDXQaDSL6qkCA+o1YP7H/FTSVa6O6DULJVzVOS0bHur7dAHHj+32pFMGZsgLzw6Y=
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
2.55.0


