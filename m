Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5831CCF9EA
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 22:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535618E0189; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE8280009; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272F98E0184; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDD468E0188
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:12:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B988B8345
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:12:56 +0000 (UTC)
X-FDA: 84041666352.14.9D7FBCD
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61C60A0008
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:12:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=ldtqOC32;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf25.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761516775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIA/jdXg8XhpF5qFcJkcp8Nfo/i/kNxnm5Fq/ADnXoU=;
	b=4r71NNNw0IRax571BOx0L/qOphV/Zt/Ji3mQGVSXnRzIekzsNoyThelIWLxnBKqV35XWyF
	86gEM46bRbsHV91iqaWrCP0BTfDavao5hMNGXd9L3iQ/WZJzLJaGfba92MuSz9k/ui6qJ6
	YsC06k65tTfTwDrmBz41y0NY/iB18Jk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761516775; a=rsa-sha256;
	cv=none;
	b=ibuIuFC8JaM0jwsEXgPhudsIz6ocha76x+aQtMGWJTb5G1t5T7eC+Gk8+MIli3EplMjfHk
	4BzHmg9/YDi/P+LHOaTyt5Yb9rPv1AkJjR87nUoGiQ583i2TlY4pgZELJMMQrV1Zs/kvmm
	drm0cNft/Md8z726w0sRbbl/09qOTuY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=ldtqOC32;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf25.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from mail.zytor.com ([IPv6:2601:646:8081:9484:8257:f1ab:878e:498b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QMCFpO548264
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 15:12:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QMCFpO548264
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761516747;
	bh=dIA/jdXg8XhpF5qFcJkcp8Nfo/i/kNxnm5Fq/ADnXoU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ldtqOC32Z7ofOTOOL2gbuuiwZQIpVuKjbUYHk5QVeXaNEf+wP6+wzmT22LWB0hW9f
	 t2Rihp7rML9voHc7NL5XoGrbMklovVeD70bngnDkpGp37wxqk+bbK7gyZeJIHlDrQa
	 ACGkOHod7Hn1wm5kztomJX5XveMz5zhrABMDmDmVzcLaS8UzUQ8a3uTKmbDErDXZw6
	 XMBdoIbgVztNYlOMsJHG4H9Pjovy/6+QbvmnwFeGfYLAsD48K93t0avD8kJtNGkeME
	 5J3T/LU8s0521B2bft8Qnhpbp4bsCsPakMyA3GgVndF8AdHGavJmAd/mcXSWVo9fid
	 nWupg9XHOVKFg==
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
Subject: [PATCH 4/6] x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
Date: Sun, 26 Oct 2025 15:12:04 -0700
Message-ID: <20251026221208.1938173-5-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251026221208.1938173-1-hpa@zytor.com>
References: <20251026221208.1938173-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: czpgsabff3hfzoobuho8ga333o86zegr
X-Rspam-User: 
X-Rspamd-Queue-Id: 61C60A0008
X-HE-Tag: 1761516774-404750
X-HE-Meta: U2FsdGVkX18tfXn3k6OCOBY0oCWihmlOpr21F0c2NvPWmYuiwyC62A5XUQQDlM/qAjTSphvXsPlzxnNbk/n3MRoHDNQboTVATDnkBErGNKOjxVsM1wLDxKqsQJ11ynXtRIC1guaFduUR0hQhUa4HyWDAs9P8PL+UaJsHl7XGZ6HOBt9NmeIJ0SxRFABLbH8HIkersoYOIvYuC7Jq0qwOh+ej2bERK6dnrbUHu1wzfrRE3iqrn7NsF6bUdp7g3ampr+UB5nrq5/WoU8jjEXH10Wh522KjHnAGJNEenX0xl8YsLU3WOYGHexVRspZ4/8lFO1IT3J3PJL9lNN8ZGudbKK0riVZKj3cNlQTJjUT3zkYVM2k1DzEmUM2o52T0vPctlocUjFfd44paxW02e0BCyPSGSiYYM0lQAvaquwkGCy3b0K9xBKxgce70sYCWP8V2aLWrlipk0jD4ooOl7eG19mgcKqXwWLUm9nX/Slja8HBeWm3O3oQG74Lp3FLILECUkPpBWnbMdHgOwlg1Cq/0Azib81sKxPEot+Zmr24054patOF8j9eJRzdOcDybetVLcwVul+hN3iI+MNlbhQnS/6kkeV2MPNKk+WiZwvt2ZuT397IMjXKZ1nwl2DStO6tgvy3Q8361SiweIm6Irs584zR80600eEoSvkp9hu6P+Tl+RP01c7+Xu/KAsCQy9+khnlHhxAv9xvDjaq+4o7GDw2lSgNz1EVN0isg78BZEnYWuIMVoe4uruhsJa19CuMNcwzBwiYFgI2h0FKMrpBDKc27fR12hDJp7qAv/m1kaU/4AOGA+5/h4TxZBgsl25AQHh3BrNiO1wF0QzSkHY5f8Lag35J2aTLFwfyNULhi8WN/TgaG4d6tOoC2RRTZRS6NkO89j0hI/QJBGkz02T5fp6lO9on2mgHB20VsUGCznAKDyWS46Nlk8GExO/k7FUZaUoqB47NVmWBeFDxD7eK4
 ciKIFm5Q
 NoFh9Ojk0ZJtP7gAIwcALks8L8IdYBDZQL/buNXeLKqU6N7iLptfu5jaxukpapdBtavYLL/wV39wMve83KS+FH4v3Vnktd4Qh6pYB2hIaNAcF2Sp1rUTt7QcCv4bHgpX+lMZ4ksGSMDWM7YS0nh51H8BW8TC/cCzpxEWwj0s3IE0ClLQ6joAahJCyXRxp1QY31ndDBHYFTWmYvZE995wAtm25KtTR9SYBcgR63KKSvkv16OkbdxWqOtKZXkSD8dGC9zJGtxdWPQ+N9GlUqscjhbKPYB3oH12fuMd28CZmFQMWz9NGCDqgs5TQ3HPSp26ypWE9DH2rTM9RhgPcDn4hPXCCNU5HM5TAEhKYDQFxrk/C2pQ=
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


