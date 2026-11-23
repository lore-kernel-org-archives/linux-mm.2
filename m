Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53409606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=jkhqAnQN;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=KGBqyz3G
Received: by kanga.kvack.org (Postfix)
	id D05ED6B05CB; Mon, 23 Nov 2026 04:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8956B05CC; Mon, 23 Nov 2026 04:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29D86B05CD; Mon, 23 Nov 2026 04:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2136B05CB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 381CD1C4253
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:39 +0000 (UTC)
X-FDA: 85465881438.11.EDB01CB
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8B402120004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=jkhqAnQN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=KGBqyz3G;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426657;
	b=8WpiZvHjJF8gHvJKUzUzcYQIsFBxEfxAr+aGLbXzqfzNx49ISz3lxSGCuUF/Xt1zMBEDWD
	me4K+MCPXIvoNA299ywMYu5OEtH+TKoszCazdCAU8tc7PIiYYWTPKVlck3oLs3+T7kSjwE
	pwS47FxwMvPdlzfJCGgFFz68lGkdPBo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/BiTKNpCaOxND2c83McUOfReF7CsUOwl4ywWdEVIsc=;
	b=1QtUoMBEoAEpxgMTzqTUC3P+1pkz9O5uFgs/VkRj8kE+HzhNiw8MwXMaa9QUoibXW5bfw9
	m4A1cctq5WTw5Kg85kCyn1e8xRVb9jWqH+xki8NI+rpTpjxOURi7mL4qiGNVoO4xkI5FlF
	0QrDdqDQDtihK+dHSOPB6aucSl59MTQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=jkhqAnQN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=KGBqyz3G;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l/BiTKNpCaOxND2c83McUOfReF7CsUOwl4ywWdEVIsc=;
	b=jkhqAnQNELqjAUyPC+ah0b+ywki2lualhhUkxkV7P3TMrXvXwGyiycaGYRoCbZBpM0RcTn
	X2q9PPlCsravdT3r794YuvNNdQagbYQKFtf9bNwRN1Iu/5EZlLemXEjySqRl802oCFXXBN
	xFQ7t0rPYG02dO0BgPjMOt67Zar5eE6hJqTwbrFc8Ac6PQY+OebLC3xD9Ckcd97nVxtC2Q
	p8pcYvW94R0pQNY9SPNX3yq/qhkzYWAU70LE6jHJ8gf1Bkj3Spqu9mEzfFYbTQtQa2KpjV
	Y9THEgzS7mxC3lm/z8O4Wde4DU0UBYUi74rZ2qlM2nIFIOUzQujqAWDNxKjtsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l/BiTKNpCaOxND2c83McUOfReF7CsUOwl4ywWdEVIsc=;
	b=KGBqyz3GdaK1oBFiUeoizJlsqPljXvKlT3ga2tV8p7wV+lhoSN1YNMjumnKIpgLiGs3g+I
	tWCAeCC0Wv8iJ9BA==
Date: Mon, 23 Nov 2026 10:37:19 +0100
Subject: [PATCH v3 14/15] alpha: remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-14-d342dae9e843@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
In-Reply-To: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Magnus Lindholm <linmag7@gmail.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1710;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=vXjkxYJIlc0NCEosFzkpX8TeQp7Um4IKFK3k2WrdPLI=;
 b=EL3RVXJCnvkuQSc9r9Cl1BTDgl6XF0yfwf03AwNKQGGyAiPL6VTd53BWrWQo89v0CFbbKICYh
 V+VEt6hrynCCWJXvzqn4zeLgAiNjUEfCVNRVTmgGZhdW4+BddfJZUHx
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8B402120004
X-Stat-Signature: 6r6qokzo549ignr4nkihxxc6tut8u8hr
X-HE-Tag: 1795426657-716465
X-HE-Meta: U2FsdGVkX1/DVv/MgSqiuJ4r8lF+CXp2k1BVSsNGudGO9N8DkeKAESSg6lR9qh6cAeLFA6p1DXjH2k05F3owoeANJi+WadBI8QYfQXzA1len6QaxppuhWlOGRWRafY+FHHJ6bNBfzt4NMOxztMj/hrHAZth5/J0vQO/9a2BYsKgFVVbbDsZFBYFKeG8aXDdGI9/w3m19iuBFj5BWoV1OfN2WJ7c6FIqWqtPSt/Lg1Ggpc9KjOZmbWsUru2SQSxqEj+IjfRJHTsU6YCMiC4MnbZ73xyZqUs3+JKJeJLUmszWmbUoG/TdISu2OXw4NCYh1szE/N3NXBIf7hwkEF4ddmDIvOrApQwawLsuzkuhSfbrqmx6P0R4Od8D4bJdl7S5V0FKylhPii34uxWCKrU0PD1WaqF0jiMtnUpGIaPBV9+feWp+oxIxlvdKEStZQcWeMI8J4O4g0NfGlwP/Ce9ZdjhQvmOLJEpWggjA1C6jqbGKMZYpg4yCPFWU3Xm/Mg8/BTJ6slp6f8AogbQn9vN9YNrRuZWlsF7ip5fOWwE/kIDWSUiGsj5R7Lk7yFGPEaJpoHBof7ljuw3Zo6b6TVHsjafLamBR6UTIAF+S3S6tdh4j5hMfY+TLm6P/s5XGWDmR/P2ogCSoVCcvnWybA1efqdKy8VKp1jZ4hqmHBWBOXLEiD32TRWgx1BiYJuieyRM5JilGBLJbx2DJGyiKlomuFxhwECVPLM9I203Goic4BrHZy4n2xX2Y+5nMPbUi2wh5UMZFUPWk5sexkX8HQgIC3Gv7ZSw0kmMmpXaHpMU2rEnjz1Y69GBW4cQjNkhqwDPWyICX7/F0GRpjrauaT0DKLS2B6opR00eUBj0kdOlgXTHEIVHB0XuxzAdwZT0ua9TVBtVygbMpLBicwBn1drG+3JyBFdUcsGZ483oSx0Na8KHnewZx5taSzK2rDkVrklJa+A+qYhl88W2jYMk9Xs4N
 0+rswoVH
 n2I96GT40xyGoagig/V6nYPLA7/8WvNvpcgTdPBDs3Xbg0a+hatMHzAOX6O99KIke0lKt8E2tA4Ogp7OE+qc8sIP2o4xQa5drY/imaM/r/r3xz2ePUfCxtK0pnE+AH4HDFnnIWhUpoBMh9nifeeBtnLRkeAfOx0mR3g3vK8jLH57mbkaJhvFJHcfSq80JKNQSvRUdgzToHNYosBQ8jFBcEKA1InUrStatQKMf8BIrjchXeRNTAbqJiiVlKEeeqjrfCUrZFcnSGEz5uKClBK6I8nz54mwLmKQu8tCj2ERWEM8rK22basYzwH2qEg7eHq1MtLNtgHPqbpYgfHtSQg+0mqbE3nF/hPPBab23io1QhoEpfkRFlFxZOpJN4U3Bn9bM0x/4lk9mtL8vLv0qXOkdGYAyi5B2eOHTT6m40PegEizbxwcWhVBGeafBsUjSZ4NmvKs5xjgfRa+B1J96Fhrw6AeDWlOh02mosOT7UG78bqsdbjlKEYd1ByuTrA6n7zIck6/DYD4ItHRjd8XlAOPh3yx5E57qUrGmxtfmK8B9AdnJCYYOZ6HwteZd+s22eBRleTwYODcv9aUXeD29Vo5IAGakq1BaZXxcUaX+Vf74wkjxxKNwRHSFnMusW8nk5YAaWfxzPh1c75RWCFw09UHMhEvcNXpwV2/exTAty297KiYI/CmLYIQqJz3mPDlO0c0TlQOOf8nAWaNVLoEj0TmX6cDHo6tyYozjY1pnoMWB5kfw+Edc9sPYWcYNHLB0rwJKjERfwWcFJwuHFFyYzsB4i+GrNRXXeJQVCjpWYWdHI2btB34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There is nothing userspace can do with this value. In the kernel is
always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
userspace and also changes from time to time.

Move the symbol to a kernel-internal header.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Magnus Lindholm <linmag7@gmail.com>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/alpha/include/asm/auxvec.h      | 7 +++++++
 arch/alpha/include/uapi/asm/auxvec.h | 8 +++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/include/asm/auxvec.h b/arch/alpha/include/asm/auxvec.h
new file mode 100644
index 000000000000..fa90ee4f899c
--- /dev/null
+++ b/arch/alpha/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_ALPHA_AUXVEC_H
+#define __ASM_ALPHA_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
+
+#endif /* __ASM_ALPHA_AUXVEC_H */
diff --git a/arch/alpha/include/uapi/asm/auxvec.h b/arch/alpha/include/uapi/asm/auxvec.h
index 57cae8780d81..d21b87b6730a 100644
--- a/arch/alpha/include/uapi/asm/auxvec.h
+++ b/arch/alpha/include/uapi/asm/auxvec.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef __ASM_ALPHA_AUXVEC_H
-#define __ASM_ALPHA_AUXVEC_H
+#ifndef __UAPI_ASM_ALPHA_AUXVEC_H
+#define __UAPI_ASM_ALPHA_AUXVEC_H
 
 /* Reserve these numbers for any future use of a VDSO.  */
 #if 0
@@ -22,6 +22,4 @@
 #define AT_L2_CACHESHAPE	36
 #define AT_L3_CACHESHAPE	37
 
-#define AT_VECTOR_SIZE_ARCH 4 /* entries in ARCH_DLINFO */
-
-#endif /* __ASM_ALPHA_AUXVEC_H */
+#endif /* __UAPI_ASM_ALPHA_AUXVEC_H */

-- 
2.56.1


