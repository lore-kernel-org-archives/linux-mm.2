Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A74CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142CA8E00D8; Tue, 12 Aug 2025 01:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CEB58E00BE; Tue, 12 Aug 2025 01:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF728E00D8; Tue, 12 Aug 2025 01:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D00A18E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BD831401BC
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:53 +0000 (UTC)
X-FDA: 83767016466.16.BD25E0E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA5E120007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=4R7GK1Ns;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=k3fJ6hiV;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977492; a=rsa-sha256;
	cv=none;
	b=MbWtwKmhzgMOd7xe0BxDI2deQc7SxQpV1BaHJQ9hNPb9bAwLPAUXiTxC3FVcidU9ftldVU
	paAcVmyvD2/RT3Pc+gx/mcWT+BfkmPo374/B/Ot1pHD6uBmp4MwqaYQ388OwT19LLyLzFw
	ilOhsl4042s3uIm46cG72dQklUOlg2Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=4R7GK1Ns;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=k3fJ6hiV;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yt/Xm1UMfOhB+4hjRHAkXu2RVWCfW0hAXkjRskrMp90=;
	b=Pub6jw9WyJkfJp/9iaEo+5A94nsB5eWdF9AoCm0BcNQVZIzWD9wmb9fa7W+wbEdq9AwhA9
	+AF5zwRbRRgjjjXQxFEGTCBhGepR8o6NO5j3FmhzAcUUUqrQtK8nHWHGU8esQYaeVhNWCc
	beCdxsEbB6Fx9YtCesK188C3vkjlXLI=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yt/Xm1UMfOhB+4hjRHAkXu2RVWCfW0hAXkjRskrMp90=;
	b=4R7GK1Ns/hWx6TZIMnggUIdGxwNwFjzJWNFPxFs848dnDyWhFTvY+RMOmyP5Kp+tWOTxnw
	FMlWKazRs5aP80wuH+qVWYytZv2LPeT/htFzHm3zzQzRpZoSuglfAWCyLaRWo1xXJK3mze
	/EDXe9OX84IGqHKBu9Lj8PeaIAKiz3QONIRgJL07IsxQop3aVJVwOfvc4DfnQsvz9hR/K9
	FJWfI4Bec2VKnqy05LcEGQbq/VuFg76FAL/nGbNsK+Zp7Tb5Sn4jo6tXggcHjI+ruiVkZe
	efTuVKXLYnIxrPThzovEFcWF7aLKC9SRppWxAoQoH2kdV9cj8m1DRyvh4j321Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yt/Xm1UMfOhB+4hjRHAkXu2RVWCfW0hAXkjRskrMp90=;
	b=k3fJ6hiVMh2JFiv+1qKUzRxGonhn1sC95oifI2QM636AD1C5COlMeHHYVWR9m5qnrDzCl0
	WQQ3zD4hOmEYiUCA==
Date: Tue, 12 Aug 2025 07:44:31 +0200
Subject: [PATCH v4 18/24] riscv: vdso: Disable LTO for the vDSO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-18-61a8b615e5ec@linutronix.de>
References: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
In-Reply-To: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@redhat.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=1406;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=SOEunbiKKKTnOWrF+pK81yxcp7tmWh1LCgMbmBwYcqE=;
 b=1Yj/TLz9zqgfdJG4tPNUhVnU/LPFKndOYqYO2YKY3GvxdtS2InB9rllJGVyVAVRovcYvZjFXM
 1mmMqVL3+dfBRWzstw5hka5H6IK1HeBJJp4KVZMkpgRQSb3KON+DLoI
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BA5E120007
X-Stat-Signature: wqpepnu4d58rtxbpc61nm95xux7d8j9n
X-Rspam-User: 
X-HE-Tag: 1754977491-7325
X-HE-Meta: U2FsdGVkX19Tu9ANNyhO7yrWOwzpAflefN7eIqH/fggH8EXFjpoLZ/8oDrgOHpYPQBKkQsroVhj5tXLCJZkSz4zl5ZLvJ/esaQYVuN6U61OII4+28t7SdotHmJwpunNPWRCgrLzMs3l3nYohPMiVbcNjMBMQA8lRF91/l3vwMHN45gRaLDoF86yFhqrat1xALcC/51mA87TFJ6u+V3Hl66ePio80AOcKXOsy+ApdMEtLY/kLErWyErqZtR1brG9esUKj5A9m17XKS7a7d6q1BZ59470TrTwGa2QVjo1KK+NsQMXMX1nSXThst25mmINyQMGBGftxxvTqzghfyPnB6duh6/uUkfK3os10YtJGkT/Vhfy6TozaQYoUoPixeR7UZGUjR7gIdQpO2mc0M4N4AzegB/Ievj4sz+7KbWlLgukp8zIQLQaw+Gw1SAUAChjIDmunePL0q88fZ+aPz86o8kGizDhmm7wafZxvfg43zQoLrvz/alcoUHCMb/faltxenvoga4J1wBOQnsGKqwqjYqTcmxKdBi0Qvd8R/FpDPY82t07lcWcv336on8EoNjKFdWxls1olXR+l3c1pHICEvLh+lhsPxVc87/JnNLeUsgpt2SG4VCjxjl/iLn/UapUgrsDSogUMzUlgbf2ncbMsRcafv5z8jAf1tNm6h+WBN+AwbWkuUIMhPtC10SAzEjj/D+Qo63Lc15E2vcIX0MJVHUQ/ZQ74qwOk2qlQYUSyCH9QHZCiMFdY3U9lEVRpL45VE76caZWT8p8WlpYzff7LF0HiI55595ZSq0J913Gj+G5UYNNbxpvh7WsxGGsmQRiqNlbvGcDj50V2YLCvdSUucg/LIL7XKPu+Cvty1Iet30TzrcRGgUTyJ1qGxEGkDsxrJY+o6YgqcPaerHYPEQKxI8P7/NiCrWHildcH9+pAKWyje0uV/ZjtMaT17wZeKE3LU4xPbEdBq0jLYgkZhXI
 RDr1wpCF
 HkEYwqXvVfZJ8/+4bYAoVBNkJQSRmH7OJwR5P3c7M20j06c/1sg8whJoALHC3HRt9G5teBre11uXPL3oTucqBhvbx+1EbrGgqXfsXVNDzjMJBdvruf/FSL7c/n1Hsmo95HlwZSPgqiWGus9lKU3fC1SfyOh3Wm7fEYLGnLnaBaDOM3t73bROe3qH9mY1jiw3Bp6DiwJ4xMvwsixs1eRndX4JeDEZzsZrij9V8zNV5brV/heXXJWOUA/QbmCfbNt6X4S3fJZQEOI8NQ3hqmPRSGnsjXH2OOl2B5IEDxYLs1msQMkYQmkNduaLEZjh59gno9QMFLeStKvz3ckd8begmKaqyUt/zQ0nbodv5Kve2x5ww8VkLZczjpoTAypj+9sftWCRD1B/nYDkkAezt5SYH4HrvgIJdq/oxoTiBpU0IyXWq9PdPQLt+nRCH3jl9+nI1j8Dr9YmyWaOakuH7ewBRH1NqAJ0krZbaaJVbotcuQ4ycqM59LMxnOJs/Xh14gR4ifFdKXSxcAMDacrQmdemiw9edbALFbJaAhK0Eok7/HCD6jR+gLCHdXSkyuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All the other architectures supporting LTO (x86, arm64, loongarch) do not
use it for the vDSO.

Its is problematic for some upcoming compile-time validation of the
generated object code.
The LTO object files do not contain the necessary relocation information
and -flto-fat-objects is not compatible with clang < 16.

For consistency and to enable the mentioned compile-time checks,
disable LTO for the vDSO.
The vDSO heavily uses __always_inline anyways.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Jan Stancek <jstancek@redhat.com>
---
 arch/riscv/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index c19c3c76f7c9f6b2f7523a59269de3b683656323..9f1bf5bae9bd473e43d9fd3022e9e1a185128b73 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -49,7 +49,7 @@ CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
 endif
 
 # Disable -pg to prevent insert call site
-CFLAGS_REMOVE_VDSO = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
+CFLAGS_REMOVE_VDSO = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_LTO)
 CFLAGS_REMOVE_vgettimeofday.o = $(CFLAGS_REMOVE_VDSO)
 CFLAGS_REMOVE_getrandom.o = $(CFLAGS_REMOVE_VDSO)
 CFLAGS_REMOVE_hwprobe.o = $(CFLAGS_REMOVE_VDSO)

-- 
2.50.1


