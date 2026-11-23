Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C747606A684
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=0j5Gmmlj;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=xKFKMpGl
Received: by kanga.kvack.org (Postfix)
	id BA67E6B05BD; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77AC6B05B0; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65EF6B05BF; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 857156B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27446160815
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:30 +0000 (UTC)
X-FDA: 85465881060.17.794888E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5962B80006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=0j5Gmmlj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=xKFKMpGl;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426648;
	b=BO4tmkg0rJ8YwVDYNclwwzIGISDZyBEA/EjGJqotqs6Lt9k41VLnc5JnTasGMQ6zX5ayCy
	C+1B5XNA4M/fViEUfL5PqMu3vqV/JLN6ONyX27LsZhAe+92mRkr/y0vqMv74Wh8S4Y3+cp
	EMbxBcepYXe+6GS4vvGYWdUprv5uw0Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDtQZ0VAonHgAXv6V61xlzs7rkDt1P1WSeLVHahPhAk=;
	b=V59xNdH7NYL+OMR8HprLnLQ/3PEfOtHi02RmoMuN4ypB7XQrWW41ZNucaaJ0OmzmNCmOB8
	OrrQLpRbB96hmXtBwojr/SxnFkg8sm3Mmf99x9+jKdszsq5a/6gHK10HqiGKLRnmZwqm7e
	ABgmTwXGmm/35C+YM0WuE9/F8c1E58o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=0j5Gmmlj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=xKFKMpGl;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dDtQZ0VAonHgAXv6V61xlzs7rkDt1P1WSeLVHahPhAk=;
	b=0j5Gmmljkca/E2gltZCv/iUBQbTWeg/kQBkYf9XVAiAvA+qtjrKckZWXQHPA2f/1TeXecV
	/zE0P2DNvoi8HzN3ElVxpGGiQAEUlNEcd6UGF8hYrc/wSMLNce0GBczPBbKvIrUO5X19RR
	R1IdOvKig4vP9CGu5Hhx6vXZPUH55eQ55Cmk36Mb44np+ZIxlZSOLnCp0ymuePoAJEdl+5
	TwmUudfDzyUogJxAH8+mEPtUHitYqGo8y7Cn1b+rbDaEO5y1tmknjd9BzK8UJv7cfl21hY
	ru0ooQgiSTna2g0imjxfqNWRrK9ENYE5x9K6ykIbUErgd+RZ7TijW+6DyYVOYg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dDtQZ0VAonHgAXv6V61xlzs7rkDt1P1WSeLVHahPhAk=;
	b=xKFKMpGlecHS7QXXG/FYCxByPNPhxibU2GcZwDKmWF1WUgWqaJk6Gin5FmwBxGa5E4PlWb
	9bnxn8NrLGCuOXAA==
Date: Mon, 23 Nov 2026 10:37:07 +0100
Subject: [PATCH v3 02/15] auxvec.h: Move AT_VECTOR_SIZE definitions to
 linux/auxvec.h
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-2-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1309;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=vTIIJIwUFOUw6+gUJjUOc4a2N37x7HojOq0oR0BBlzg=;
 b=GyKn4Bxu+C22SecrgL0rmVE25rtNo0/nZVqR9YcowgOuG6XWN+hFQ7LVwF48ESsfl68yPNaNg
 5OD4YumxPGrDTLDcZ/xMG4kmg7ZscPSTHPCE8zZxHWIbEnZdxHW3/L6
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5962B80006
X-Stat-Signature: xebzq7uf5jzpd3k1g48mw5ej7iem1y8p
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795426648-458792
X-HE-Meta: U2FsdGVkX19FzQe2xl0E4RFcPNBG4Tk/GKR3syp1TZKfonryDf8FcJmf8iOJrCad/96IUTrrjOqEHo10rRMpqY+67UaqAZJPXNqDQPaz/YsNqOj2J2nDbJ2721VvBAcebZ+irPlMLNMQhFS6lInddIBL0/qGfOOoLedIdg2lC4SYmOTY2TAfgQQD1gP+OpMrFOE1UasC+WkV8fV32S2EmF3UndCLjjmDFIxR1hwq7bJJpZB50mn/yUFSVeIQ5871280/qmhJkIRPh1JWCl6Gmy/n52ZNPRrY0LqPLJpdFJlJybG57+4frVaiQWirAIVU7FhEL1dBRfGbaHKXmWLc+Bv5Sv+YJp+QfKFHVzdL4WZGv1It16waDH20T2WVMDkvKUROHL0R+0jXOaidvGD2VLPs9P73h7/DR9lkD7tUGcXf9pLg1nHKX12M/JeIS0lm7jau4IQMt45RCOMFrWkxYd7mBK0WjUantsbquJh5XSqykqPOAYfALZyQnc5TrmOUQWX6EodV4gFSniNWa/IQiQJOXmSj1s36GtGliPV6jURcPR1tiGGvcm6GB+xVZfqbdsQBy4dnZv9UpNtwgWix/+mMuzRzthqJFOkWRISj9Peje9W4v8KR4PjsA42YjcPukQ99UG+qq6tWuvqimpcW4KMB7/uTXaCCJTj6jaygAKJNxZcg7LgMzj9A5KFU4mykOtInAesiyOzSro/aqgt2PpEGxFEDj12l7UlAdB9U6FNLO1UXYZQ+iH3/4vvh/6gc7DR721O9O2WHhFkux5M47xn0WKXSDyJJ6JDKYZ6G9fHy0AiY6ai5c1/uNUv4QERzW5O2+a3HvfPndeScpuZ/WxFtdKtmXHDnVWFB3MXoJbS0Qkm5l3t7d7yahdYf/XA2hNxRWTWJgZB3Y5RaLUW2bFYSRu+Sqq9002+aOPnwUtInoAxkzBXcoS0TzjX68mx+yWYx9a3Q4Ee+gdWeXrb
 X7zPrArA
 Wn4P1nCdSFkk4OH8rvLTKBe3Sc3Uutoo3mL4MGJ7cKZqPSaaj9Jo2kCacLlY5nNOgUNDVkmTTzt1FXPMWxZDaB/b7yBrtbRheYs8yAwfTbgZWGOFKO1SHAaYRZvFzdAF8cVz9CppHyneeALs2au0IfakHPpUHrQIpsu9o5Vrt8mRKYYrYzSYzX/d8Ht5DhbL+oAgl2Bvz1pEf9rNdk5IElkfiOdH3FhOx7IqPByFKONBAA8Cls1kgPiYEVrGwdjNRTXxN4oLkWqNNLnido3g4x3g/4vRBmBPydc/OgrAwJal0eDBD9YjIAFR7TUW7r9LSnmzKTspVdPCZGBcUG6do+tiZkForXxuHKu75FTlQCTJ42YGkIAwM10Acm+a/9WW3njyhQZ0g3ikGE+pU6RlyFY4JwCOO7FbxIeIGCtnjGnm+PDN3RHk5WXR8cjPKSJKC8fSpEex0gmFHiYgB6aBC/OUx899EIU6HZEuK4XJh2d1ashdmwyAuGQxotnk3GQuaY6SgMqCcvwxD8p58onKjOoX71ESARfPQtmJ1Uha0byC53Jm0APKzb+C9E+tCj+RYX1k7Y8WwjTa9Gi2HCetHAN+jRTGxArK+/Qoug5Vwk/pFGbwpFEkjeQzCkDJxhhFP20NlNqRhHr8K8dxHLU1QxWrhA9Mb82HOQ4qAHPgUnyss7Kx+UBw93BHbPpA4RTSDe0fF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The auxvec.h header is a more fitting place for these definitions.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 include/linux/auxvec.h   | 7 +++++++
 include/linux/mm_types.h | 6 ------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 8bcb9b726262..4b364e639f08 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -6,4 +6,11 @@
 
 #define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table */
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
+
+#ifndef AT_VECTOR_SIZE_ARCH
+#define AT_VECTOR_SIZE_ARCH 0
+#endif
+
+#define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
+
 #endif /* _LINUX_AUXVEC_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e..c75626c5aad4 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -26,12 +26,6 @@
 
 #include <asm/mmu.h>
 
-#ifndef AT_VECTOR_SIZE_ARCH
-#define AT_VECTOR_SIZE_ARCH 0
-#endif
-#define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
-
-
 struct address_space;
 struct futex_private_hash;
 struct mem_cgroup;

-- 
2.56.1


