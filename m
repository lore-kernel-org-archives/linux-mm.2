Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74DDCCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9E78E000D; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F098E000C; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90ED68E000D; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD538E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F034EB83C6
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:26 +0000 (UTC)
X-FDA: 84100698612.08.CD35DE1
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf23.hostedemail.com (Postfix) with ESMTP id AD008140006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=jEcrnhOd;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf23.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762922305; a=rsa-sha256;
	cv=none;
	b=zxbJf8ENy5INze65WRhQAFnmrVY9pUD64/rsRHdUG0sDHBISQlt3IbH8raOBmNbuMaruf4
	q9LRLl19OD3epmnzqufjw4A60YFR+RxJ+2QuflpUJHnIr9iO7Myp6N4vwv3Ptg9wH8m12/
	Bx1X31aRUITPXLAO/Qqw+C2H4ThiRtI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=jEcrnhOd;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf23.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIA/jdXg8XhpF5qFcJkcp8Nfo/i/kNxnm5Fq/ADnXoU=;
	b=NU0jGA1C2hpg0KptIDnGtuFpYXn/ak6P2sGOROptqVA0xzXVbFtxLJ4aogUopL2+L4AG56
	ZsGMgf0FgFWrhX4vcsioqcxYRzZUA8ljBJUxF7pm/i4Tlfn9niZXcDtZtvlFA+OK3xWPJC
	K4hOop1EXpzOU71TeOQHO+4MOfoB7MM=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDQ542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:42 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDQ542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922264;
	bh=dIA/jdXg8XhpF5qFcJkcp8Nfo/i/kNxnm5Fq/ADnXoU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jEcrnhOdpe8Ixmh0q49w9KDD0kroYtcUNitFGnm9RfGXtf5qBhYZseIDzUBYHEH7x
	 tIYuW1a/9fzwcnF80UT+skupeoK4R+vEL46PAJkVkzx7jzmq3eusoWzR7cHxJXhE6x
	 w6+ly7WKRU0Tq67PBUlNzgqZhbBzpR6AAgAVQB7/PXAPqI0ZKZG4HiAlth2Zkz+lyc
	 plLtmlM9V4IqVmKSFIFYNCi5VPB/WBuD5kz5T9GobknvSu0oeNVLNPczakZjatqlok
	 xBS22IQcwDI0gxb4w0lJ5D9/jl2MvZo+NdmOIuvZYstQRKoiFf/8UPcLQoGzIT4iRr
	 D09kaZUI4wMkQ==
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
Subject: [PATCH v2 4/9] x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
Date: Tue, 11 Nov 2025 20:37:22 -0800
Message-ID: <20251112043730.992152-5-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112043730.992152-1-hpa@zytor.com>
References: <20251112043730.992152-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD008140006
X-Stat-Signature: sindz9gxgqmmtzhoi3zwfd4tduy4uedr
X-HE-Tag: 1762922304-387640
X-HE-Meta: U2FsdGVkX1+AaxS3l54R23Spz4q2nmEqxrwDnMa5ETxs6cRnoXtgjBomL20Ry/s3j9pCHEuAK1RaDz49ivcP3B8IXiwWZVJGRjBCFknRkecGnalg0/816kBu/4qyN+WXzf51O2KpSq2NalTgpNprKA8lO3H58k5a6QeZTmzHts9bSG47KarITAnC2Vr5Uzq1RHiNCWTyLy8gi5MLLJY7FGPuvvc3XaEvQG363LOLC3e3iv67603+tePkvPKv6mAlEiFWTLA8b4h9VVjFNngmvsLEb+OIiCuF2r3deri+NAmcVaDJvGxQDhgaY//0noSfddrBuVtRh3+AEL9cBlzKXypRJJG6T2IepO2A0OMvDFiQfe4vlL9zdl2hB/W7uouTEQ2PnCge/fXYgiu3oNBRDhRT1mjslEOlq8CaIvRBYQCHu7QtOQY+2ld1T7WmWJov7ve0K+DhGRzmy/Ue3EfzYX5nnjlUV/DNZKYzDSzmSUdw6yBUxHwrISUr5R+ztkrQoKD/Ymeg/HRXaCzMWDjpDTHOpL26iiETon0c/Q2KqjXxkGTkOTDvz4Ue8/p6DmIUkg5MQZbnsCI5PQp5/i7xIsihR07LJIHTTLpwE471ycQd0x4bXWcSDpHjgyqNMUXXjs/WC1JIZHm0VpRzevJ7tX7s0nf+MY0C4A5p4b/AH2tSaKbZXhJ1UKhl0G4bFQFzrQvcpDPdCSkbMb4Xy6scOBNEV8Oi57oMzFpR4acj/b7LOiD8/99giUbLMcKcykMbjNquZbKq/4Dhtc8DdqV9mZQowLWEx/+1RpsoXBIa7u9cLL29c7F1v74OCAqTQXNVO9tUUzFNJGjP8Ct1i+ZcKg493OfK9a0RDg4I7YZaoLCZePwH9bOZJntshP1PbYE3WeupJurOKJRT0E7U3d8No8c92VxqhNPn4N6I/v9a0y7zZ8zL4QSKkWeftD2cvNdnNSdLao6dVgAYiaFlBtm
 jo0POAnq
 DxMTyYXuNDP3ccCSzuHi221vdZn9r+YbH4R77n6E0UHeVmh7B+XujP1ekY5YXXuXWO9pIvZY5+r27OTgrGDBw27Ru02Mq7qTW9Tp7ngsuxHd7LfPpwvNCj/i+WJ319Drjte4wZDUa3vQ/C1VkalbbajvH404ImZfz4EgXrqF91iBEtoURFMSi1+wDgvvCzf0wDq2JN1HUzittjZOiJiHR2bLmaGsMkPcdYQWYuwIVkcd99mUODopl8E66cSxpa6l8M40gVLCRj/RVtLF6JQRR1//yonOGLqYyc61N1MMWxnnjjWYJAJqS+OQQflbXHhByxSKs0lLDCk5enZeVR2S0cwmoVA==
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


