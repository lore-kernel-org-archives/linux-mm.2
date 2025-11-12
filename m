Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26634CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD818E0012; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D068F8E0011; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6718E0010; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90C8A8E000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D488140310
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:28 +0000 (UTC)
X-FDA: 84100698696.30.7808813
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E5BCA0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=D7WNS7Eb;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf25.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762922306; a=rsa-sha256;
	cv=none;
	b=XcQfAUc2OlGhriIp9psiwG4M8I7hO/nQDrAI27/2NUZ/gfTg98HSUDQ4IQw8NglxAg5fph
	QxJmZ6HkqDZwcbCirz3ql/8v1Wrj3TY8aH4D+E+I+Zo1EjDbc31e7v1VdnBpVpiMF+iIMM
	h/V4GRkZzy2fgJJXsBPvKlZ8aZa0urA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=D7WNS7Eb;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf25.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMMOcY5k7WMRbb5RjzJJtEFLgKhj6ZkdpyvvaWniwlU=;
	b=L/ji72wbKTDFUJGC4UvKMPu6W8E2pZhqrCOvcxeK8/tvrEm+LIONjIVzlW/XdNL081gY7T
	VlJOP2Zrl+vnqrxnpQvw4fI3In6niNcFHNfPmP/K1a9XK+vWcAkjgoiZPsTlEKvZpd0Nor
	WTZl19U2yIzlbnwmFulTMmHpmOiiScY=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDV542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:51 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDV542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922272;
	bh=GMMOcY5k7WMRbb5RjzJJtEFLgKhj6ZkdpyvvaWniwlU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=D7WNS7EbpirDhdlVdB86gK7uihe3y5A5N/RIwZLiGL8TO45lYCCPqR/KNi3sNWimE
	 iyKjMIEFgzUQUr2FIjmvaS2Y5JbInKCBOo62CPe9x3AZMsNPwb4u+xzhFk5sB3LVxD
	 zhQDlx99DArdwnKHQj2YA3O0f5obsoumWPfYaCjl7tT+O52dT41sIOxUGXbfwPxbJU
	 Hlp6AnLql4DQQEgI/NSGfGkJIms2dV0toBRKwcbhxL2G7KeX1dOZcX5YSdBfLYVOAZ
	 7iQBfnlgL7DxeFcghKxiB0wHCSmC+niGvrvdCcwQIV0KOSfFs+XfW2/PKhLuUmT7Af
	 9ewipLxNs73wA==
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
Subject: [PATCH v2 9/9] x86/entry/vdso32: when using int $0x80, use it directly
Date: Tue, 11 Nov 2025 20:37:27 -0800
Message-ID: <20251112043730.992152-10-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112043730.992152-1-hpa@zytor.com>
References: <20251112043730.992152-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E5BCA0003
X-Stat-Signature: uhk4xt9d4y4z391ue4bnxwysfq5t733e
X-Rspam-User: 
X-HE-Tag: 1762922306-122290
X-HE-Meta: U2FsdGVkX1/PN6/LXrkFuFqzCr8NhXOv+fJg7NKdFKsJSW2DWFh6sDI4AlcU3ewnOn7ExapMcmGpNr8BtQlKa++i/rQA4ipa0krsNVlHWC+TSAGAwSNi2ohajqoBNW9FP+PCEz3Ngu5FhwKokKOKE24h037/38dTwogd311Kj1inSLEmkT7ugjHuWo8YOTADhUY9M4PFtPyq2hV0FupPEXxMY1btxLUFTQ/6dfkp+69Jqt1kP4xMD0Mdc2W6zQ0hcFhHzaqqwY6xBjvYduajLiBsogBtOFNvSljgG0DWmUCpNhzrzpPF/r9JiJ0FM5f0DslbGraEQ3dswui/vG2NiZM7MMDvhXPjNEycpcfN8UVENyHxIloijCq+QAUHYvk+OgKUhHztwI5j5C9SKtQ/xKEwhVlPAZXCfQhFCDdUPMlnSyMtWCoLKrLLM/1x2nMOoauYBZiZhtndzUDzcIP4MB1NxOkUPIo9eqgEgsim7GqQoaGkeNSdhyuPKzwL45HDgUXO3wndOw1PGxkcLj2Ehk3iRHZV8vmlt/kr43Q4u2ZO/qpEx0P8L7cMZMThtbt7/0bdg2ZK3WNHo04pxHHWSpCo75rZl6N5d/iiz/knZdMtfuhOLdeoJQrBBWP8bIpBFqopedLAnfEQutGcvE+zZ+nkMs/cUwt+/aydQbiLk0SPowJ/FQ1I3gzuFJ9XsNUIiE1jxjDP1Gek3u9EWxkSZKXr6b/uS4B9K1soyf3SC/oZXoRc1ehyVr/zc3rs05aSwToRZVx/EXsp/otTwgHv5CRsjrYdXbaC4vDZ9mU1MVT0i/ZuizVJSdlTKLGnZVa350PaA1rYEIqjtV1HRrnhgchoaHQfXj1s5fa3/NicxtBpiN63b/YXZM3fVaYZpGilMmOzHCIqSUayCriyIdTd61hlCJ+B7UYGRzHAoq/+uhzAPNfwCp+BAdBROI9Ogz6+XR0XtAM6W3pxURoGvw+
 vgGZ05mC
 j5xqSykEndlTlYk4EEwIX6uvi3LxtdiY/dWFNzvTqyBVj7gOayJI6xl42Zr9DlwpAcebUpWrtbI92pvgyxkmzkWuzeX5BjaEFRuyOTIqxy+KfFsu+2byu36PcrLso+nDcsLb2R6fLn3lGaBAtJNyAr+D5kQGJ3Svu9IEZgkxhvXTBWvOHvRHOnZfhLs7s2j8ihyYYFLAdd8lBwEPF0DmHMjdyoyuCk64ZuQV/BtTr28xFsK9nLE+QS7V1tu0SWP3HCziitTkVRCPCLp2DBbWxtHWi8+grh3EDf6eO2axEDUtW/R6qvGGV5Lau/uQwV/lYESdsszr9z7kHp2I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When neither sysenter32 nor syscall32 is available (on either
FRED-capable 64-bit hardware or old 32-bit hardware), there is no
reason to do a bunch of stack shuffling in __kernel_vsyscall.
Unfortunately, just overwriting the initial "push" instructions will
mess up the CFI annotations, so suffer the 3-byte NOP if not
applicable.

Similarly, inline the int $0x80 when doing inline system calls in the
vdso instead of calling __kernel_vsyscall.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S | 18 ++++++++++++++----
 arch/x86/include/asm/vdso/sys_call.h     |  4 +++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 7b1c0f16e511..9157cf9c5749 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -14,6 +14,18 @@
 	ALIGN
 __kernel_vsyscall:
 	CFI_STARTPROC
+
+	/*
+	 * If using int $0x80, there is no reason to muck about with the
+	 * stack here. Unfortunately just overwriting the push instructions
+	 * would mess up the CFI annotations, but it is only a 3-byte
+	 * NOP in that case. This could be avoided by patching the
+	 * vdso symbol table (not the code) and entry point, but that
+	 * would a fair bit of tooling work or by simply compiling
+	 * two different vDSO images, but that doesn't seem worth it.
+	 */
+	ALTERNATIVE "int $0x80; ret", "", X86_FEATURE_SYSFAST32
+
 	/*
 	 * Reshuffle regs so that all of any of the entry instructions
 	 * will preserve enough state.
@@ -52,11 +64,9 @@ __kernel_vsyscall:
 	#define SYSENTER_SEQUENCE	"movl %esp, %ebp; sysenter"
 	#define SYSCALL_SEQUENCE	"movl %ecx, %ebp; syscall"
 
-	/* If SYSENTER (Intel) or SYSCALL32 (AMD) is available, use it. */
-	ALTERNATIVE_2 "", SYSENTER_SEQUENCE, X86_FEATURE_SYSFAST32, \
-			  SYSCALL_SEQUENCE,  X86_FEATURE_SYSCALL32
+	ALTERNATIVE SYSENTER_SEQUENCE, SYSCALL_SEQUENCE, X86_FEATURE_SYSCALL32
 
-	/* Enter using int $0x80 */
+	/* Re-enter using int $0x80 */
 	int	$0x80
 SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
 
diff --git a/arch/x86/include/asm/vdso/sys_call.h b/arch/x86/include/asm/vdso/sys_call.h
index 6b1fbcdcbd5c..603ad8a83c66 100644
--- a/arch/x86/include/asm/vdso/sys_call.h
+++ b/arch/x86/include/asm/vdso/sys_call.h
@@ -27,7 +27,9 @@
 #define __sys_reg5	"r8"
 #define __sys_reg6	"r9"
 #else
-#define __sys_instr	"call __kernel_vsyscall"
+#define __sys_instr	ALTERNATIVE("ds;ds;ds;int $0x80",	\
+				    "call __kernel_vsyscall",	\
+				    X86_FEATURE_SYSFAST32)
 #define __sys_clobber	"memory"
 #define __sys_nr(x,y)	__NR_ ## x ## y
 #define __sys_reg1	"ebx"
-- 
2.51.1


