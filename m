Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2331F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=kEyAOZ+f;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=lIn2F/rY
Received: by kanga.kvack.org (Postfix)
	id E196F6B05B2; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D733C6B05C0; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4756B05BF; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB2C6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D3B5120821
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:30 +0000 (UTC)
X-FDA: 85465881060.09.81234A2
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id 62213160002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=kEyAOZ+f;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="lIn2F/rY";
	spf=pass (imf08.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426648;
	b=gCeN6TaVXXnG7XmnHeS375pcCG/wpvWVb+CDlcdwObPHPvo951foz4qJX5lrXFPgDot8Gs
	4yazCfjvJeBTXsweX92XQvu0dMpjlDgAzwNQvLd8ugRHkE2mKmyVjHdcNyLqaStYVEa1PO
	uXGPhuoS9oofo1wRN1NqltB4Emr7bI4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1kpH9qtmZAMmYTBOk6CnIKFezpBGJI84FmVahSpOrc=;
	b=jP+LiiRJVeEg2fKhwxDfcsi6a3wLYhc2gJnvNYZvtRfysXT8GPM4QZBgJR0yD4UCTIg7Vq
	5mXGcJ54eTm3OLONwHzqN3UQKO/gTBKOxgqImU01v916YhqABjZWvBNNbrBx4pDGfRssqZ
	mT35GubwI368Ywk7HtubyBW4LRVfFw4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=kEyAOZ+f;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="lIn2F/rY";
	spf=pass (imf08.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1kpH9qtmZAMmYTBOk6CnIKFezpBGJI84FmVahSpOrc=;
	b=kEyAOZ+fXfpEFfXli9cKb4jaOvep+YD+wGpQAMUQQojZWoFAqgtWYb70a2ykA+VO1bRedq
	xJ1z/x/EoR0vCb1RSKcWCP09fC16ImShi/WU9K9AboAh6Pl6VYOpQX7L3Va0rbVF8sRgwZ
	j1VkZWwgTUUpmxL3P+j222I9Hpz4yBmTIIBjdDdZJBGCITy12dETeke7yfjVz6eOwfrX2T
	qwIgn0zPKXkYeYkzAhQRrFUZf3oInFDCx1beSUFl6BqCyxq769Dp3hpWe19ngJScL2Wjxr
	jwMUd1tmM8P3eypY0Zj/ISZvHtFUuVCqtBxqaoGWMGH3MzUX5NwVGjxH9YMJBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E1kpH9qtmZAMmYTBOk6CnIKFezpBGJI84FmVahSpOrc=;
	b=lIn2F/rYSSMxABLTJM4B3AbW/3uEZC8vK5/mSmfekSgDDXw9MHlSZZVoCJyH3+Wc1EX+Zc
	QINruovqqc4qHEBA==
Date: Mon, 23 Nov 2026 10:37:06 +0100
Subject: [PATCH v3 01/15] MAINTAINERS: exec: Add more auxvec.h variants
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-1-d342dae9e843@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=979;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=hyCnjfQwzbLi6OQVQUQL35+BD4s52Bt4na4vvI8iM88=;
 b=Yd3vnnMHSBep+pRQRmyi1AA40DEVjxA2c8/dBeFWV4J0rKudeRDSHvhOeNFfw6AFADdjfzkJf
 OYY7DU1b6DAAWfLpRxBPgKDgCI6NtpX+tyAlSPU38iJqHr9hcKiFypZ
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 62213160002
X-Stat-Signature: yf5hk3z7e8yaafgmbjhmm1xj4nba1xzc
X-Rspam-User:
X-HE-Tag: 1795426648-719216
X-HE-Meta: U2FsdGVkX1/GGl9D9kDp+GHLi3psIyifI3m850lFl/lbRB75Nb6r2hN5EkWZ63te8ryZL135Ao9Pm3TT7L/G/0p2AvRgNETloh9op7CgvxRJeZzsq83Glv2eR69Jh8RddiKE6jDlu8H0pN78ICom/sLKmxGV3JD/G9nx2qhU/LhUtNORJwDAHkifpmnFG3Ivf/Lmsl4XO/ANY7OG4DsMpYTroB5InQe+Zg81zs9W8GhovVOuI056gTCsxyhA1p/XC72ztAXdfFkaVTGUElupOGZDCUKfen67tn6SGqfmBQU7UOqgg4Y9WwQjutyVj9NS1NV74ri2op4uOPYKZ288qDN6xKNX9fo1KJIQ/N+leHLn6wU7NNH1eLJeVWnlJeESh8/njUmv54PhnEeh+hm7yM1Ceh+u1FSZuC+ERIpuJfDn2gCM+VENP3JiIurQMpnpFFWl0FSLZhXJkMcBdqzAsuzujxh3Qqet/Gsr6X2fyCH7ytTpw8uTLrLHQCD4hSC/dXHC/ftgtySJU9OwebHHCCaXgj/S/gGz4ubJf8qNPktkQbfod6w9XpicxPS07v6OhoCl49ffQLO0F882yE4Qnyq6Qj99B9PLQiY1xZevpdTBPldRaU165VhlKaamugd9IB0iFy2Q103CKAozNHjGbvKOH/s6AK9Zga6hps5318ql9mBF5j7mbwgSFF+k55StBraweqJ5aSUgUI4WCw/ODu3Ys9q/GNe9bGWa4f8d2/h1kVOYZqwbKvK0sn3J+UvKNN6bstfbhRfprFetbdyLPwbbXXver/DtQQwytPVFKqRYKO8BKByHRsM2jWoOCsWtFYjHYwanNP168qS4II/3H6/UjUmv2u5OBtngsE4vAzQxxiKvMHFuj2IdL3y1kUTersyCyrWZo+HhWMB6lg1seOGYAKV1wHPO3V9PGMsYYdkHgdy3aQcRO1yh7fVC2LI7UI+TTAi9knOhBJSRJbc
 0oiJfnYC
 I+/MMAIRYoDhao5uQIQBxXR8ucZty6mdkU1PVsYIidQx2cO04TJk+aOHtfAEnxGNjaGr00hRr73rZLR9XtjDOGshR4yuA5GuiJcga/LkQ46hQ6ivn6mMzp42c8JjTrCCgdz3iFvQQgJ56dan8qgtGAxLOECAOqu6Bix+4B4NWEky7Xs6E0InViOGCKUIxG5/DsfiUtYvZtV+Jv/llEGLR4XYNj4PCe/I/2MMFdgaVkYFhuQwIjkgoATkgOZShHz7Bc4juHridmAKtM6l9i2DmCCmjKYLZ/u3tPL1LDSZbMpK7cAH+8L51MQol6Rvhuj1GltOf3ce2ilTq43ua7/jX/DQlkaIsdsngxt6X4/n+CGCtrcMlkyhtYTtucoekcsftR3NPF6qOFmog0UnufTJCdJdoJnXkKd8DjGXw15Xb3rebF1MNvrQT3/rFGzhUBpW1P0lgYIWjZTHJAydHpnXO/KHyBUXY9Re615hz8XAVK5efQl0o4r1RBn9If2QK31Lmo0/+3a1eDTFLU2+yiv9V5uhV3CNcwDUvEEo4+h4aEXi/pjIqLIas3AYTv2DZGp0BPaiomTJEiQBYAaCuYBPNU23r+lxs48M9/UkzXl/Tq4GOJcFa5oXVb6qV+wOcYTKKEPwbjgs4oQUnyhp+sVKvTKZV8EfaMpiA7gHmKXP9sxSFQhqtflamuvVeExEaYW7oNSePyT0YdjPt0fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are quite a few auxvec.h headers. Mark all of them maintained
as part of 'EXEC & BINFMT API, ELF'.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..a659c9bfb0f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10073,13 +10073,16 @@ L:	linux-mm@kvack.org
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
2.56.1


