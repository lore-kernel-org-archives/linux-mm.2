Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 404B6E9B373
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC13F6B0005; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2CAD6B0092; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFB96B0005; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70E786B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 245CA5CB5F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:49 +0000 (UTC)
X-FDA: 84501044418.27.7676000
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5806618000C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=0ote18nb;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="/aSPglB8";
	spf=pass (imf24.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+wSVvr2iY1iH7k3F0iPCSqLzNSvbTbj527LLEkOjHE=;
	b=uFVQa8TDUMMk6hrCos87+Wyxr59h+1SGHvxBDfFhv0xxudtJteZcQcoKimYyvxL55ZCr4M
	G/d7aPyOltnnmI25stXvMTowfn1UDy2DQhyce/9JdG+bNu3jNa05xAyUZ4XBxXTh+6bFPG
	4yVkKI/JSiYh6HqAH1Pl/299mHgc3dE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=0ote18nb;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="/aSPglB8";
	spf=pass (imf24.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454347; a=rsa-sha256;
	cv=none;
	b=v9rH/hIaT9+JkbrQJNBncIAXEezk4B7To7bOEMrNwYo0CxN8+z09w4ww2Puav1l7Xl19bC
	JKT8U4hOzK2vhUqgJfe5bYDepqmnddG06JONwQGeVLGOpWc3H+OJ8txtoVxSBX/n93QhqY
	Nc2TDsIcG3hmwhntc8i/S2M/A7dsh9c=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+wSVvr2iY1iH7k3F0iPCSqLzNSvbTbj527LLEkOjHE=;
	b=0ote18nbZ1t68zJyeexrdJSVHAZPwP9UOAsFgAAFR/fpqYcoez3egBK6lgBnGLIpBoYIKz
	byNNJflcxX/8kT7PsREcxt3F16BI7KnZB/m2IKc74GZSYeD2m3CHoAuFhIulLiNJ8gNHgT
	fEGJClPPwBHWhKwqt8bqeoHqX9DFdCRP2bHywf7Ar1A3BuZHm88vpLBma/whU2VfEjPu/N
	0AVHGyqtCyidsedREaPVbnXHovlkR1DKs3rnrmanu3HagPXtCHNl99JbLfJz39FsFs/Mnq
	gYBYIP+QlW6OTeMQ6Ptwvq/2BcQ8xXbDDHUKO8JYjy6dMfwBHZRxnLHMpnCOzg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+wSVvr2iY1iH7k3F0iPCSqLzNSvbTbj527LLEkOjHE=;
	b=/aSPglB8AXbqg7opAXpO0/jUG+0+n3k3JqmDL/ll0iG0SJf+fha6jNyO8a0dtGc75s+t06
	2+O3rwMHLHMlBaCw==
Date: Mon, 02 Mar 2026 13:25:25 +0100
Subject: [PATCH 01/15] MAINTAINERS: exec: Add more auxvec.h variants
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260302-at-vector-size-arch-v1-1-a11f03ba2ca8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=935;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=BIlr7zgi66zD1ig2kTolm4aENXktO7wosOLcoYFwhtU=;
 b=0OWgCWYeIEIelNOmr0tEyiBwM5q6MuFfywVklpSmD0OLBHIs+3QQGBNYsmCJJqT5R/0oHxk2v
 IVHrY681uTqCvAuwCRegS2QuY8D2kC+ODREUKmQlpZd3Q/msGQ3Pvmv
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Queue-Id: 5806618000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 3e31bq8nfrbi3z7uxjaunmh6kjgn3wpz
X-Rspam-User: 
X-HE-Tag: 1772454347-19303
X-HE-Meta: U2FsdGVkX19flIIAajORpSVZAqLJ32FgJO2COeqZFdVpVOxvu3oXUegAYe4CN7lLE6G4erYtBK2/fRwOBuKqM1JWh4LfswrO/fc+d0ZhHsRUR/kmhz8uUO6jwx8wlXTX/e+i7Cwcl1Wmeykk8INZig0AwneXDj/DvDw9XSoO+lflcWalfUSBA4zqLSPqpCk2AQM7x1/9Ssa148BMCWgboBKMQWFz/xF1cX+VSrIL1GViBkLyIOdjxCbP70JgwMrkYZFOnUgydlljs7P3x6bFJtZ8H78tEl8t4Jam6nnWTxTUYPwSGAxRqqOPFPn1hlZzHXKHSTa1dVzBmA7/jWJifoXt1vWb+TgauDIo8+U0Z666wERD4TzVc3f28vA6qMFDXycc/eclPHFDx5rHPyOnbZoY96qa3s+rSaVhhEEky5HmxqxUIg+HLczjhOgN9Zh5ZedsikYGoBCaRmi9okbyd3oY5Qr2QQ8q11LpuW/yTlaa2VQe/P3uKyE2Sf5YOMQTCCOMOJjKnEnwkNV2cKzIwllj0n7KCdrIlL/GGmB0Xzwg7Qpxd/afpQUhygHZJeUeMxzkf6p0nD18XQZSRVMJkgrkfDk8X2wnFXvh89sz3Rjerg+gRZHp+93nU9qmqeeYZaxwD9hYG/V+2R6+LZ1ljXhqQy8xzm4L0+cwsfHhp4Q/gprgJB/t6nAGlN7REG+U72Ma5ceD5SYMNDe7EHizLeN0oIzJ+xk9jUs/hCadq2oix9ikO4GDO0+dpCqoRz4+YY+He04riGBVoaIk8IW/zjtOXgOkarC/KCC2PZ+A8Sz70F4FMs+OjBKIBcIrS6L35OUt5SdxxQ9C3Edba/RhXQoj7Z585xYKywdGhwidNlE8D0ux+m0fDhRg6rx75IfnsFtrXpVN5pPneGzIvaK96LrBSYak8Qqhor897oO2RcZWdkDb2lCo5dKfXxMnCPBZhQVIpBp1I8EHnWmV02w
 yoor8hVw
 f3jfYqgKuTAW7bbVDTKGY5zggDBenk7rEXRDlsMPLRYb+x8VlbOkz4cPMglJdIqjU7xQM48dxou6dZks0n/jPOieO2fzaVo9q568e5gVBJvcVW0iIMoXI8XQ6pTvIugM4R18oZh2i7CHAtx6LizfO1fGumH1YmA4WNkgDmi5BTCDj2xdzKa2ObDjcyoha2T9Wylaf2pyJFgPSpdCjwop3JHjk57DatWgAnv5vLuUd/rMx0iroAuClSZWF/IhojkIS3Br9A8WYrkGCd2n5mIEvkgLX2FUk+/3ahprBM1A0MjbMreAIi/NELMzIojcXIGtkScSNswP6AO4HPYUksp7fKT3F9OvQlFWoIXxT4LYLAOMZVIfLdx9hUvyOpz06l6Ddj1yLeh6apQewGrfryu2TaozfjYkrdEvdCw2fqjAnEukzqc4OxQcePhuunx6vOHKDVy6Iy3AI+QXHIjxd1edbCDxThSmVlF5VeUvi6DDrPryzvIPnP385Tui3691pK2p9rmP4qxvvWd+8sH6UESK9w10KZbc03LLKUwEiFXGBARgYt+nOJHxa1l1o6JmU9V5krARDhcbT9u9i33bMbCzu4la+qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are quite a few auxvec.h headers. Mark all of them maintained
as part of 'EXEC & BINFMT API, ELF'.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55af015174a5..7a2c952d72bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9573,13 +9573,16 @@ L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/execve
 F:	Documentation/userspace-api/ELF.rst
+F:	arch/*/include/uapi/asm/auxvec.h
 F:	fs/*binfmt_*.c
 F:	fs/Kconfig.binfmt
 F:	fs/exec.c
 F:	fs/tests/binfmt_*_kunit.c
 F:	fs/tests/exec_kunit.c
+F:	include/linux/auxvec.h
 F:	include/linux/binfmts.h
 F:	include/linux/elf.h
+F:	include/uapi/asm-generic/auxvec.h
 F:	include/uapi/linux/auxvec.h
 F:	include/uapi/linux/binfmts.h
 F:	include/uapi/linux/elf.h

-- 
2.53.0


