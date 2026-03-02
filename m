Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB14E9B36A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44B56B0089; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6FD6B008A; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C76A6B008C; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB776B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31FEF1D0B4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:49 +0000 (UTC)
X-FDA: 84501044418.25.A6778D5
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B29580012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="ZRJF2/RI";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0RhC5Fte;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgXUWuBQc37HPqUBgBljEt4K1lGTSpiCtiKFdFvnpEo=;
	b=hzNePcLLQQTsjdwj8nFp5p/wPxPtgKscPHft8bWxOkJV+gFk9eAgFfv7OcnANrj+XQWToH
	rZUVTae/fTJrrNR9jtTxUe/o0eY2rDQFUD+01kOPOnhjhCW8eMeabPTlvFl4Ax8eazEQ5O
	meqo6LW3SBCNbn9jwI/2HuhjPN6OUf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454347; a=rsa-sha256;
	cv=none;
	b=gc+FTljetwwzlfQt88BlSXld4+TARIVrU5eO1Hu5vFBoEffdli+pgebg+CaADDW+Rt6MTs
	hMQ2NPODveVu4vOsJzGDppGUktfI/gg9mqn8xLwBUGQCNZvM/mCeYuEju9w/d95LpQw6AV
	vvdMhi5kmzE58zNuMhalkG5OZniG4sU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="ZRJF2/RI";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0RhC5Fte;
	spf=pass (imf02.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wgXUWuBQc37HPqUBgBljEt4K1lGTSpiCtiKFdFvnpEo=;
	b=ZRJF2/RIYlZzXdvvP4EyC5ziS1eYTGNaiCpGWGAlhlhh6WP8XJtMwKY10FScMfkRk07Kpn
	WAm0HrLrPe3V8GufiCyKFmoR+hIoDakEwVJRmOfrOG1vTfDvZthRNy9j1FqSQDBSumosRb
	lSJyQo7Ek9W6Irxwps/fZr6+32MXQ1g940bY7aUn2wgzoOpTYYGfSmYo1TtUi2eNGBzDXQ
	HoOKG9XkKlO6Lsynm5IwDc/mDANODBHa3D+7XWmQ4jr8Z4GRPHRxNIFyYedKVrZJWzUsgn
	Xi/TXpXkeaoOKoyyrYw2RkYIhmbqg4P5rd78zu1pTPRTbMW07FzruR62fY8Dzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wgXUWuBQc37HPqUBgBljEt4K1lGTSpiCtiKFdFvnpEo=;
	b=0RhC5Fte5zjulHI4Ol2L/ovJ2Kd9lvvPGCNYvwBDoFq6AG8nEkIzJV8ldugwY4YHFGhnle
	Y1e4YJBTshKAKTBQ==
Date: Mon, 02 Mar 2026 13:25:26 +0100
Subject: [PATCH 02/15] auxvec.h: Move AT_VECTOR_SIZE definitions to
 linux/auxvec.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-2-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=1267;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=R6dPuK9hTEu2wzxXNEaPtc8TE7i9ikP4nTJiTP9bZT8=;
 b=ZulijLjkAtvEzMGw3cQEKThTnvyrB3XWkn02AB0dxIROztyb5g4HrOCwXizPScG4JZMtRLaOM
 3hiDIzMjiB4ARdfLbg+OTnHYu6B/6h5UxzpDiSphCOmDSpy2QygkNcG
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: haztu5tk84tcxhosanjd7346xck4qp9m
X-Rspamd-Queue-Id: 5B29580012
X-Rspamd-Server: rspam03
X-HE-Tag: 1772454347-354617
X-HE-Meta: U2FsdGVkX197Z19AyFxmaF/078R8cSD3sqjK9bG3WWV+TBLsGkuzfMvxr3+eZt9pwQMeUVYb6boBIQRZdq3GEGy0GtDF1dgkJT7Hni0jgScejjohogjRSu3mAKYf8I8Jp4wc3Pda2EsLbD8d3i3Nk05/4xDpFIt/CiNj8rV5qn0I0pvABB1pUyyZxezSEXPhtQwJq8fzDn1LpNXcqADYciVjvD0wn6/ZHAaHUd9p6SVfRW5FUii3DQmsJt2YSt2kVKzwWfl5tJHNx+zFhTkw2HVXaJW6dgBt7QxhQtMFUV/mQOPl+bXWmy9cZvZVo44Hutt8knP4WofxvqPkyss8pPy53D5X8OToq/gmQPQlwslpkPbGmc+RUEpUWUBZNCv56AvOOC3bIja1xOQ0WRIFvzp6U572lnB+xPVajDGaXFNAgD7ioAFeSjqrAlo+/9MbOB3B/NgVaa5tZKqwwxfRdcDAjZ0sOrtiykMx/i2o+NWRbytDMhGAk1fqnYIsHBV0SNgeoYq+koouoluoB/TIkRGQ+2aGsh3L1uWZKhSoCRHo3qphMePljnNUt42oIGMLSGATlEJdWBV4R7lFW2q/2f70js2HXW5YhHYntyU4YCFVery/enLnf3FxfkGrp8uL85b885E8S+zybvSaTPXjsnOOfNr9mRYJvOxZ3rAsVZAdxZ3wdTIf9P5rpKrzSbdQiQGfArm5iK7ntQTBLwz7Dj4fY1KHqsD3vXSYIcy28lLBALppeWlqBCERhnKIhJqam7VbDhOl6tsusTSjPwsBQoxjMEk2XBI8K7PGpOaQnp0WZmvooECWUBGaWwYmsPIr5XEM+n7JlnJXGL2zo8g4HZhFC3P1gF5d59ZRN1yG2xt9Xqo0sn/7ugtzb74RLVd9Wz6YkXWqtftuCOm8dmh8ifB+KXNHH4iidDlKDyNsvC6x+JkYU6EP1qf57YKPQbqKIbskKokrihe3IK8uD2g
 HGMvib4u
 iRXKkL7MW2RXVyFkUyvAxhtMtJPuhxhq/lSwh0byuWlQxihj31VFDfwPt+OJfncyyGvw25KzlEV9GTtGJbVGcLPAZJWHaUKkujPqpx2weVs/wBpY741UZNRCD0ROm6x7IeBoHpx+9INODUS0u+NWOwqQ5/hXnp0b9j8O+z2AuXsJq3o+jSzUhNY0NFGVkQber1lkCYljB2kmDxKL7S0N582TORfTBg9Hv/q76uzjESAhnBdUUEgvDg0UAxJqxC6mVhkfwckpClS5yDaMFTIgBpQl0XJx8V+ESPw+3V9chqy2ePhwUsKKXBOr3Hyf+HidUSeR38RBZaMsSErt+zPTOfmte3zqJiJslAT3503JmA/ACRX6XZi7PYXZ/PfZJvpTwHyE4/YXTz/3yJ0hstjSl0PW5ATYq259CUjtg9oUP3oXQNwzMwKHAuPxFSz18O2ENsHTi9jHgzYzUZOfp5Fr7k8OOoRrSm9aL3FQCkheyD/4UuKixAH7XgdeC4T2RkMTH4JWrP+diZbqYopQPmV5WswUgmAjwjLRskMpYUcqIYdFkhPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The auxvec.h header is a more fitting place for these definitions.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/linux/auxvec.h   | 7 +++++++
 include/linux/mm_types.h | 6 ------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 407f7005e6d6..943e8b80b41e 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -6,4 +6,11 @@
 
 #define AT_VECTOR_SIZE_BASE 22 /* NEW_AUX_ENT entries in auxiliary table */
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
index 3cc8ae722886..64019dc29f4c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -25,12 +25,6 @@
 
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
2.53.0


