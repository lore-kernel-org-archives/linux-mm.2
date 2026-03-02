Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B766E9B370
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31696B008C; Mon,  2 Mar 2026 07:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65C26B0092; Mon,  2 Mar 2026 07:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89E26B0095; Mon,  2 Mar 2026 07:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 942286B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5835B8CF59
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:50 +0000 (UTC)
X-FDA: 84501044460.30.A525184
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 831E0120013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rxZQv7hK;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4UlDmyzz;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glnHOe4x1n8QotwxnJCfVYRyCZYHnBdaRGVCFc6KFbk=;
	b=rLhT7pew3pEtlHkNfhmtdoYsLMOie4N1x79qvzdJq6KuA23vzHtGvy4jJiPR7fG7yMQsOT
	44lR6z3Pl/LIEdt3HPp413N6pgtuJdYiF+6DvgA5l0shUo17DSdEClzI9s4CxxBaZa9uPM
	2FSq8m1ZZNE78ODk2lfq1JFxJd5qfN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454348; a=rsa-sha256;
	cv=none;
	b=qzaHQnoKseYQfiGKBVp5LYYpzjGkXNEUD4BHC/9+Ee2i9c8k+/XiuBav/DKzpnCAp8Gmfr
	oQ3RoVlMljkPEX3Ps3gKhcljFLErhL6ZTIml/tQFx8det22eu6ge1MzfqXLH7gRblvHRLy
	aGdxBBvPm99YRFPVDBnvxnaxJKueCJc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=rxZQv7hK;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=4UlDmyzz;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=glnHOe4x1n8QotwxnJCfVYRyCZYHnBdaRGVCFc6KFbk=;
	b=rxZQv7hKeFYWJyFKJsUWMqNlbl2vjnSpyMUWvtbM+KVkUK8WaqYOWnhTleOFkje/NFvInP
	Qt/vVXUdfFnn1iq74C1RCTqwoqvw522r7PU2TEuWmhtnt/N+13u0BFDqvSJ9+N50ZjfS4U
	BSarBmo8rYOEJLTRt0ek/3O3vhTop7sJQum0OPLLRalA9vrZx9iZHrKfjYg84JldDBDnZA
	t0WwlWRm4tnjSIcfZAdKa6/AeBM96TDCbJDRytzgPtYIaNnWXkYcPaqvUu9PXVyIRi67Kg
	DLHn9Iv+m+Ef7KGJDn9Agiynrv+ZuTEFjtwN8a9glkN8hM57G/egFrrJPWtgeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=glnHOe4x1n8QotwxnJCfVYRyCZYHnBdaRGVCFc6KFbk=;
	b=4UlDmyzzjetdRsu/XceNY6w9k+iZB9u+rg7F/k0y7+4PQofKHMuBzzowktpEfzJO2FIgmM
	N2iAdlv556mYd5Bg==
Date: Mon, 02 Mar 2026 13:25:28 +0100
Subject: [PATCH 04/15] ARM: drop custom asm/auxvec.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-4-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=481;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=x3siZYFPocmk1PJ7pJ2spSV3FxjnTs1Nv3DHpd4VwUE=;
 b=rDZhb8bdTw53LKoUbzecX+TybS3+vD/iuZGnWTOdu4kbPRoekZDJcE/myi94bDcvoXoVfIa/j
 i0gchlTXUzRD5/MoKkZ/K9H2k8m5yzGUuEJql+dJlXH03noNQrp6bhu
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: ewxjwekurrsa4mwcgfoagj1ii1amoxf8
X-Rspam-User: 
X-Rspamd-Queue-Id: 831E0120013
X-Rspamd-Server: rspam12
X-HE-Tag: 1772454348-136957
X-HE-Meta: U2FsdGVkX1+B1g6dyCCbEaHTD5RgdaeKzw2ALrXROgSrdofaB18u6MxWNtIOIGeTDxw6brEjgK1pCsHRgTf1oau2wzWaZK1HEJJCmiqUk3BKhB7wwXDUXbV3g3lhzTke8J+LzFiCPZumY6TWh1v3pi54S5s1e32LTskeAHgcIN8J1ETVkV3L0UrUwKkEqVzUOrEUHy7AybLhCIXEplLb5oJ8APopPmWp++01PumOUSRzqrkAMt7QvIVB//aeYKeTIhj+bJacsNmFN5zknU/j7xhmhLzfufOnpm6NYBb9e0FkUinVGLU1qJhYycoYfJKOhcqsLf+PQfLaZLkw6yGc1NRSmmVj8ip44nN/FuYB2K8+/hbH7XHFuktHlufIiIwGcNFmzx+ZEubL9Iay4rPIszsl37vSNIqqiLm2Ct8FfS3jNWfF9WMmSxGsHwES75JuVfLh1HDP09ItT4gt8bpzfISi2uR0mIJ9rXGw/H5O1XciwXx8etNWgeXLXROcC1MrGaD8vFtqJp0KXSy05HgB2YDzoRB+m97DxHp0Yt05BnAwjED7HEpE/6tbIiY9F0GiYBkkHzLwxjBlzUevpanZkBS9u6k5xutnltCrAQYnriGiz+kcZbexq9YNBJF5Sm7e79yjjtQ8GIxTu6UZO5sAAajqDbfU9hic760TxhWnT7N92JvngSZZzRQ3y3bW/XSWXiWHYK4B8/HCMl0+yFJ2TeJ6UkxhUAuySLFkaElrj9CDyD/X9opTycviB6eOqJYgcCjOYdVQdK5bHrvwTtLbZDORdj1dZT6tf1IckB84N00EaZ1nY0jZBBzdj0g/dgM5yJHaFq73UBYtH+EWoNjA7/fKv64AlZ3yYXJ1a95/XvY53+jc7cKKqzqZtGFVlSCewDtrPEhF2719vXPcKrnLx7GfxaslQxFv292LmMFfmWMWZTEAZdLC/DnA2xzVi7/g85goL0kctQ3KRIgWGNc
 N5+V9v/w
 OBiJBfEft6Zp7cou4o5nw0ms9HTQAtzIz5wMvxXMoN+iD0Z9LxAorIweuZBdER+xaGfS41BTDVYGVIWPPFl7COl4BQjeV1ULD7gd8FaZZ4iWlmPFPvxhZDBJUGKLXGM9jEhS9HSBabafI87qfZcBcDuvZBWLC+eDWylaxqoL/Ibr4eOqKUaKz0R8mV/o35at42YXChRx9neT2+uUE/6Z4G20xN93VvdvZ+Qphf6J8i2kMXroKLVknGKcoORfV4RAO/iI1mFtjCmOhVQvoC3BNjLNsShdoRL6lcLLun3BeYR7PV/UY7arj7Q1wCOJFk8Qdxc06oTZXq/Bzdxbc3yhTq703TNxwX0JrO092TSFX/E7PlVDaaVT8hFeUT2+r4Jjn3K3wHbNPCGaefS1WW4EP0voTNGd7G0XnZLhlAYaN13HHGRh29XqhnWrgROzAExfJXJc89/NCewffxpTRnDNPyHaKseZ3/eJgaqih
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the introduction of asm-generic/auxvec.h, this header unnecessary.

Drop it.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm/include/asm/auxvec.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/include/asm/auxvec.h b/arch/arm/include/asm/auxvec.h
deleted file mode 100644
index fbd388c46299..000000000000
--- a/arch/arm/include/asm/auxvec.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <uapi/asm/auxvec.h>

-- 
2.53.0


