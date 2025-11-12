Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649F9CD37BD
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12108E0014; Wed, 12 Nov 2025 15:23:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CD38E0002; Wed, 12 Nov 2025 15:23:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4928E0011; Wed, 12 Nov 2025 15:23:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5709D8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:23:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03CFC13B895
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:43 +0000 (UTC)
X-FDA: 84103080768.12.4623001
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D398A000D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=erE5ya6Z;
	spf=pass (imf15.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIA/jdXg8XhpF5qFcJkcp8Nfo/i/kNxnm5Fq/ADnXoU=;
	b=kxq7CwFYs8n1FDmqimir8IqspFbbFjnlAubacARzM9pKGq87SFwNBmn3JWtW++WCkDjkMH
	0WGy1ZXhe9k8lv6Lv3Fz7maIMotaJWwBrwSEckGL/2kvrxjOU8IsW/r8r3etL22zPNAuL/
	7gfr0kp/vY1C9zrKGxsEzRFt+LnIgLs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979022; a=rsa-sha256;
	cv=none;
	b=8Xxy8LqARmHJ/OCjD7iq0dbXkk4GCFljX0fuwp6Y5bmWu3oAcAj2cWRZZhHWbb3NZ3WpS3
	f12sL/HFVA4y/u+T/hlpXh04Y3YQERzYBfDqNXsZTkErhqiBjSVbM6Ej4IExqcOUvbT8gc
	ehqkbom5J0e2EVNPmV81iP571XfCjFU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=erE5ya6Z;
	spf=pass (imf15.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2M2978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:11 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2M2978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978993;
	bh=dIA/jdXg8XhpF5qFcJkcp8Nfo/i/kNxnm5Fq/ADnXoU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=erE5ya6ZBEtOXOOJ5AnvTJd4AlAMrYTDV9tWnhzYO0H2qioOgGzqXd92XvYymdIw3
	 Mb0vPXxWLA+evNZQv6W2FTGg6vslU8tklaRz1TXcSN8m6+eAFHsQgjfH824fun1ZGR
	 OB2UjETqfyXyMRmYE9CuiuKBhrq6v7SN1SssonJX5hvsxhlQ2chl+r++pj6P1jCnQu
	 z4hjkoC8sbj3uKO0vnTUYC31mdWQxaYCFx9kIWAUF8UnSyVCuc3QsXAlFszSQ11n25
	 qEZALCAfm83FK9u+9SyqGvG+tCkhnt4jclQsXVDp0oGFDCsN9JMph67tFJy/iyyqaS
	 lQ6N6oueE++Gw==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH v3 4/9] x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
Date: Wed, 12 Nov 2025 12:22:49 -0800
Message-ID: <20251112202258.1310754-5-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112202258.1310754-1-hpa@zytor.com>
References: <20251112202258.1310754-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D398A000D
X-Stat-Signature: f9bcqy1dtdcm5sk6xgno6u8zse5m7gcu
X-Rspam-User: 
X-HE-Tag: 1762979022-817897
X-HE-Meta: U2FsdGVkX1+zod1EdEj5E2Us56djy8gCn5dRWTKEWPv45tvO/oxD/zz2XAxEUhh8BZB4Rdgkur74fy8nTi01+4AbPKegosS9ZZbJAlUeV3dH205f+9hOoCDWTviqIup5uinGX3PYpRk9iMbLniy0bUgYmv//7GFvSclt6WMRAHLROujCI2UCGm69xw/k1oNoMIzabFyOHVGfN9NJpwuA4OzUmJJ4Ab1fbWWBvXAdFVrYRdHCjaKsW2AVAylLcnPpu0Hd+x9OOZdWBctY7U2hBarNxlPi+oWwKREtI3dZhVNzKn61/0vj2UZ/6aP0SMVaocS2iGBnkB0ks6rk7IHaLP+RnFtlp6E7HYl43zYghvf504TELsvqhwdXUnCW63Fta82XLFNrJDygzWqVA5mEnJAN/c6CSHybhyvuzenLyuqIBfejI7DOCFOgq7Ml8PCJpWNXojWI5UZp9qqoG5vSolaOTd9rk3L1HAXkF6SBvU/2nfCwmBb4CTD0EcmwoJpQ2brg19SFrsynxw+U+8cipbjgo01uROXhGnGGHd8g9qd84SNPXtLFxbYVy5YP9KuZxSh7PbafX0sRcWtJjh/OIIR3Yh32vqJw6kDmmJyaupEnxVkIbF2h3sqCkvK+LDB6ASIoATG6mU0HkDkIrEu5mJ67pA4VdgDlwCUhOaK6hnm6wgj2+y39Yg55upqdUQnevNJ8WTfKrxyG8Pn/R9Fh5P+6zMVGgSEl3yRus+Jwkw1O2AJw1wBtZGFeosqWVudVQaE9zt9fiFPyMmpWq0uzNMHgHLPGRwXfrM4pYIHDU8Ny9bNAsBLGGM/nTxyWOAOPZwWGw0aABZX0QlPFKKOcGIUgf0Zz18MHv9J6or6hFo0Fey/iWGJq83MtSHkgZwfe4dZYSBG4CtMc57A058ehGM8RJBKthYFr//H6/dZpRvtstG90Ld+UrWMOIBR1sMf9Hnq2lz3AOTzp7clukKl
 2SpxB4n9
 EWH7hCr2rsxnEQb9+O50WMrMmlJdc37UfcBBBEfst77t+vlZGF+CdFBcKQz1uwA1bt+VTO8y5VkJ4EeBTZ+DDa4EuySICcqEC/GtovM7TEvBJrXDKS+FaIvUqQYP2ppbWB5q/ScwDszoNZ0ePFz4yjV1DooGbVKyqr47BZMuMXIjtes1akCF/Xg/jFYoT8Vp2GeAO++BdSW6K+F3/K/Zj1zSqOWjQ7U29Y9MOpCl8HE4IlN9wbofJgFmfn0v6VlRIA+4iqw0JrbDB43wXAAWJ99S8izD/co+MCNmIWBvoexfvaojPeDSvPGj+gZpEUjpAzN7grtU1u0du4r9vWLo0I2OjlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A macro SYSCALL_ENTER_KERNEL was defined in sigreturn.S, with the
ability of overriding it. The override capability, however, is not
used anywhere, and the macro name is potentially confusing because it
seems to imply that sysenter/syscall could be used here, which is NOT
true: the sigreturn system calls MUST use int $0x80.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/sigreturn.S | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/sigreturn.S b/arch/x86/entry/vdso/vdso32/sigreturn.S
index 1bd068f72d4c..965900c6763b 100644
--- a/arch/x86/entry/vdso/vdso32/sigreturn.S
+++ b/arch/x86/entry/vdso/vdso32/sigreturn.S
@@ -3,10 +3,6 @@
 #include <asm/unistd_32.h>
 #include <asm/asm-offsets.h>
 
-#ifndef SYSCALL_ENTER_KERNEL
-#define	SYSCALL_ENTER_KERNEL	int $0x80
-#endif
-
 	.text
 	.globl __kernel_sigreturn
 	.type __kernel_sigreturn,@function
@@ -16,7 +12,7 @@ __kernel_sigreturn:
 .LSTART_sigreturn:
 	popl %eax		/* XXX does this mean it needs unwind info? */
 	movl $__NR_sigreturn, %eax
-	SYSCALL_ENTER_KERNEL
+	int $0x80
 .LEND_sigreturn:
 SYM_INNER_LABEL(vdso32_sigreturn_landing_pad, SYM_L_GLOBAL)
 	nop
@@ -28,7 +24,7 @@ SYM_INNER_LABEL(vdso32_sigreturn_landing_pad, SYM_L_GLOBAL)
 __kernel_rt_sigreturn:
 .LSTART_rt_sigreturn:
 	movl $__NR_rt_sigreturn, %eax
-	SYSCALL_ENTER_KERNEL
+	int $0x80
 .LEND_rt_sigreturn:
 SYM_INNER_LABEL(vdso32_rt_sigreturn_landing_pad, SYM_L_GLOBAL)
 	nop
-- 
2.51.1


