Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1158D637AE
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0866B0093; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93DCB6B0092; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854826B0092; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60F326B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 267908B529
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:57 +0000 (UTC)
X-FDA: 84226619274.22.02EE2C1
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1F6B640006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=XzOLOxrp;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf27.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920415; a=rsa-sha256;
	cv=none;
	b=LkL154damqxs/iuvY2tQTXvvt+owlH4wwwmru/2qDnWa44/TKHlpp1KmiI4znMCCWd09Ay
	UXMoJEgVciKtsOiK3q+VoxUGgddOugZc7iWM30HUM7t+U9oNeFZxncv3RQHedpdWPI0um4
	TfzR2yAtXzFTzTDzL1gQo4OxshDvEQk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=XzOLOxrp;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf27.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qflYDEYSfpEA8CgU+zw+8+XYOHYFRgGv++82XjVNC1o=;
	b=xS5I/rCV/lz9NgA3X1KjXNltoYNE3ITM1i59Ulf7dHvtGUbskKUgW19YrpR1O2HUjmDDFx
	3kqwV4OmawOM5iinGFkALoohK+b0BQ6ca1uc5CrMDflYLbwYyT0xZqLCtj7niJeUT9Alc/
	EODX3OdW8nG/2IH7c06BgOtWQWS2/ug=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC242563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:22 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC242563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920384;
	bh=qflYDEYSfpEA8CgU+zw+8+XYOHYFRgGv++82XjVNC1o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XzOLOxrpdf40oquT64n+xO1zoW9HFk/YtJNWiV+60eMixlN2qmphpmp5QVfhL/nYA
	 DqmL77T2IRZd2PDBgUmkUXw9Bouu+xqrhBJy7SDQKGPJwrME2yJ+EboA9ZGsytqqjG
	 wq3/JCad6gGt8h1JzYcQxNBiUuovPKUctE/vZ0rDK6OfRDIIiv0imYf/5m7E1J5rWF
	 COrHo3gQeDcHw4bMaF59odhQm604OYkNZ3JG5przpWGXs/FPgiwLzx3z69cB9VJTJT
	 LI2TAR1Rq8FYdt9TZvnM6Id40wTN+l1TD+sifWO6JTqZfJBvaDmYGujXC0nFZVnZ82
	 FGgsLycI8fMiA==
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
Subject: [PATCH v4 05/10] x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
Date: Tue, 16 Dec 2025 13:25:59 -0800
Message-ID: <20251216212606.1325678-6-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: <20251216212606.1325678-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F6B640006
X-Rspamd-Server: rspam10
X-Stat-Signature: yumbrpkt78bsdho8u6e864akcajizm7p
X-HE-Tag: 1765920414-864428
X-HE-Meta: U2FsdGVkX18QPTqAgX5Cu7EmeZbqRtG1qcKRcz6NnnUg6uzY3+w6Hf90Q5Cyk8Cj7Ex3ntoWLUUg+1TrFxKgphFC9up3dzbithey0Y7RjuhbSOZJwA2M2HJuKlOlNl8Je/9A/nm7Xg5TqRpI5AMeAtO36Va3ud+4V+uKvBij1zcAHwMjCbHozjkNv98TzaI8nrav7GHhIK2SGRTBqWDojij1HmDGpujdZJUheDgcCu9Ye/L4icF3Ozp48Wk16SNYH7tNdlBJCN7Qm9iQmdn4/E8lV5ueZnfS96+XWonrfyDbFbk7udI6S6Ds3QZ7DHK7JITguE9VQhMPrDwTB3OQ1RSuFy8rV+ZLI843caLD5fMqpnqqQw6E7NFb8ogP80gE1IbqHz+MsbqfD6YzsLLL+UE/mMnXI9fXsPUPFjhgHcQK30nIDnF8PiXgc6hpYXmSom+GPMWcNGlx77Jct9Hy/xMUCyjAeO/6Y1o+hiVpcjyvdpRC1RnPEkY8g61KXuV2pKrtY79G8G3UNWHq1IYXEbxmqOO4gZCyRxCtg7HJuEm+zQdmkm8J0bH/Oz5juspVK0Jym+ZOCNuiAhJMrJ54QvskAPtq2nUsl5l5mNTtEWqGnIzRNzSHJbZ+VvGMpzesbP401Mc3k/CM1KMCWQKM85F0yH0/t5z0qvyEEhCPErdWJXetzlj7xV3bcQQTex0GPThFMbzJKBL4UI9nKvVvn7TljsqqjqtTfyJ+5gOyBQuoJBjRkiK1h5eoQByIAgJvoh0+MYDeriRvX3wC4YPYUa6xE1gwhAW6oNLWIINpPpnFeLcoz2p9WOPSHZ0xT84/YynY2CAToMLzm4cIQh81ju4RV7kO9xcCnXW3ohdnVGv+Um1SIbqljwi4cEyfzs/0G9P9k0Z5S9hwOCQDRdS4dVxQpRI5poU3DsYjuO7iyodwiTiVobeFl1rSrUqZ+7f0/QGm4UkQGQgVPu+y1YU
 /dFe6yCU
 ANBxZoXW56iW2hKU+HypdYhJD24dYmXCNUPA5TuPkrPiEHrwL0fJSivRr8iadCzF5I3hFfQnoonUwB7jb9YpLupcfijaBCks4B03y5VwMtH6heXr6xG9dTVGHFOnCymgiodebBHkL1eQsV/YHuAms1UmzJarzdO04cjHDDN2qit/pvimnzDALa27asL5iUolsL2Dw3TyYb8vu4ELl7QLV4+idkQ3YstYFz7QokxBw1O8e8WA1awVFhpfVrdG98fFMRVOW+2zipbHVGF/ZtJY0zvgmIj5YOJsqZGDB0LmxPdcFhxYdBb9qpuC5w9XXsrkccNEtrFXL+os9aGNjiLbabrMsmw==
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
2.52.0


