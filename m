Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB86CD4842
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAEBC8E0002; Wed, 12 Nov 2025 15:23:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FB38E0011; Wed, 12 Nov 2025 15:23:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF208E0013; Wed, 12 Nov 2025 15:23:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72FC68E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:23:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4002C13B8E8
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:44 +0000 (UTC)
X-FDA: 84103080768.24.54E35E4
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8EDB940009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=m5Zdg3v6;
	spf=pass (imf11.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKepbIurdihWBOSv7qfxVjB2xtYQNTgrV9okxaVFtJY=;
	b=IZmgNAwc+7DPW6yfnXGYqpkpZEc4W64GEJFt//YcYsZ1gqsh6xmnFK7Dm8bpDMd8fn7jJ1
	Ca3g6zFbTMrLOO5AZD63udF4BWJHfiKqFTLuqeiB0V4WvzYlf4s/cSQEcyJ8FAj5ngLyFc
	p3m5nAx0QiWA3HkMG2mJzZJQbdFvNh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979022; a=rsa-sha256;
	cv=none;
	b=xGkZd9fIa1YH8XzbyaHhW5J6TTDvNsFAlhdqTrfBWFSWvpzlk5irrPMTBW2/eX0OaC+gOT
	nmL5MQGW8UbKJQV/MvM2/DSKCRh2MjPt6yP9wev7alEKwxldJOguqT3FRi56brc+Q+mD+C
	0BQoAXdNNsGQN5Y6sFd1cy6l3I9FfWE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=m5Zdg3v6;
	spf=pass (imf11.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2M5978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:16 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2M5978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978998;
	bh=kKepbIurdihWBOSv7qfxVjB2xtYQNTgrV9okxaVFtJY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=m5Zdg3v6NVwk5n3XG9KSuQXOOMS2SeHI7FvfxMGCwHyBkA4GLazgEU/ibfCXefRP5
	 NDyff88v5Po6/9PBN7H3oL8d1C/L/La1SNXMmZfOvdJ6bkQktDmzGqhpXb0qd8Z9fH
	 Cj/nXsP2LbPYPvPYIWATaJNSbhh8oX+WwKVM3yz3NMhvFuhz/ZUZaZefJFGLi+tf9l
	 3WmhxMzphWWWhv3ehR3oxOSx46DqLCZDPDa6LpJOvGhPh27BuWtl71XQVrM7ROIZwN
	 vF0eIDeqp+hcfbYHWyxP2Ib/6JMQj0vX02iIFUMHegXtp4bPlBP+c3+Ax9e0MnywIm
	 S4bdBCckfPnoA==
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
Subject: [PATCH v3 7/9] x86/vdso: abstract out vdso system call internals
Date: Wed, 12 Nov 2025 12:22:52 -0800
Message-ID: <20251112202258.1310754-8-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112202258.1310754-1-hpa@zytor.com>
References: <20251112202258.1310754-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EDB940009
X-Stat-Signature: 4ucjfd1toyx3dw44n18htjsc3bdf3d67
X-HE-Tag: 1762979022-405017
X-HE-Meta: U2FsdGVkX19bCNkQC3JbBWSQrVbjaZzfzOewGXHCEN2brXbkiTys+7fEM54BnvvbEPtgvXzl+CxC6b6CSTXU60abNDrigU3V4itOShTjvrAOxeZY2RZwd1Nv89aqGAp11Mb9XQeVqqGFmM39qWQLukx/L/EzL6pOhrlHMPAyvlBIIvJQxuGyLQIumhgdIoEsje2HHLCJDzlC4IQVRskcowqTJMOGjtfDmT1jULXu/6Ipq5OrIPg5SHo5XEnrufg2drCRchQkLjlc5kUlSKnkRAH9gA3hXxLalrHBkYzmKSsY1z0cPxy8oDwbrvNaVEq6l+TAniyqJDvlB4rkLVvVtWbuG8uL5+cExiTB38YwjHHEhpWGvDXZNxKcB7Pg3JuY1/1hh+30OGgGC6bM2qzOHHz3nnNn5TbtbbCUKxxnuKeUBpfezLB9CFcuhcpJL5hHjYjC5xEWbXHrX4CkoRfXCUxNruvYamiSNd4DzXIRiMXrwoOy8bGUjpHR2ckKNbcC8S5RpFGWuL/QEg5urAiZqc9wZUxkpg3x+a75e6u4IqAC3HpECCzTxhEs8aEDkAeHGbRvYDzwW0yNtPFaeZSJ3UqF/5tI/P29SIBM7HUIIBSRgk5qZmIR1xWPlYyb/ryIf7i7U/L/hEJ3aR40BnUV1v3nJ6M5wTJR7y4+l29M6RoRes9/XEBUDzcJYY0ROGfdySZ41QduS8w6V7TsfwBd0I2KnVuPnzuQELuuJR7P7MCi3D6BZHJRGMrBTx08yZg3zjZ4BxDT+Fn8YgMDdcvSuhPDeaf5pZ5ONrGFUVHiWvgglHwyJ93HO/nWF4w5y2VUAlLREbpG08UK4UhqvNpmChZF+TAXxXueYfzQENRjktrZr4EvHdPm44B92mU48FgvHGBcZqRPJNtpSO/UnQDXUVqvOERQerr/0y00hSbvcft8MHEGae2RhYnye2gBMvnaCROt6ff2H2NBucaAO2G
 0v5Ut9U5
 MPvBOEpu+BqtW1om5FHsAzdJ1EhibC08MKeg/yEidOe+xr9MmCbiAGBHQK3Yl00tL/34y79xBHYpV7GajtOfQv6nVGH7tQ3P5rRGWFMu4kEDb0sAZJvhjNHkihLlLBGAUfD4iBwyZpmELjK94sTMjhSo4ViAm7Qi6q+ufMaIn3U0KnBG+AtLNQzKXZmW1HLGiqTJA5/GJAQGdITd7CILih0RcbsHGJw+YbuIQd/YUUAruUZdhRiF09VtTd8udBlQtj9+LN+iGeHaB9H18F7GjW4s9w13P3gahvzQAuLgXBj1fD/QMnDIzREe90yTK3ftge2WpXahESZgNE6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Abstract out the calling of true system calls from the vdso into
macros.

It has been a very long time since gcc did not allow %ebx or %ebp in
inline asm in 32-bit PIC mode; remove the corresponding hacks.

Remove the use of memory output constraints in gettimeofday.h in favor
of "memory" clobbers. The resulting code is identical for the current
use cases, as the system call is usually a terminal fallback anyway,
and it merely complicates the macroization.

This patch adds only a handful of more lines of code than it removes,
and in fact could be made substantially smaller by removing the macros
for the argument counts that aren't currently used, however, it seems
better to be general from the start.

[ v3: remove stray comment from prototyping; remove VDSO_SYSCALL6()
      since it would require special handling on 32 bits and is
      currently unused. (Uros Biszjak)

      Indent nested preprocessor directives. ]

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/include/asm/vdso/gettimeofday.h | 108 ++---------------------
 arch/x86/include/asm/vdso/sys_call.h     | 103 +++++++++++++++++++++
 2 files changed, 111 insertions(+), 100 deletions(-)
 create mode 100644 arch/x86/include/asm/vdso/sys_call.h

diff --git a/arch/x86/include/asm/vdso/gettimeofday.h b/arch/x86/include/asm/vdso/gettimeofday.h
index 73b2e7ee8f0f..3cf214cc4a75 100644
--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -18,6 +18,7 @@
 #include <asm/msr.h>
 #include <asm/pvclock.h>
 #include <clocksource/hyperv_timer.h>
+#include <asm/vdso/sys_call.h>
 
 #define VDSO_HAS_TIME 1
 
@@ -53,130 +54,37 @@ extern struct ms_hyperv_tsc_page hvclock_page
 	__attribute__((visibility("hidden")));
 #endif
 
-#ifndef BUILD_VDSO32
-
 static __always_inline
 long clock_gettime_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
 {
-	long ret;
-
-	asm ("syscall" : "=a" (ret), "=m" (*_ts) :
-	     "0" (__NR_clock_gettime), "D" (_clkid), "S" (_ts) :
-	     "rcx", "r11");
-
-	return ret;
+	return VDSO_SYSCALL2(clock_gettime,64,_clkid,_ts);
 }
 
 static __always_inline
 long gettimeofday_fallback(struct __kernel_old_timeval *_tv,
 			   struct timezone *_tz)
 {
-	long ret;
-
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_gettimeofday), "D" (_tv), "S" (_tz) : "memory");
-
-	return ret;
+	return VDSO_SYSCALL2(gettimeofday,,_tv,_tz);
 }
 
 static __always_inline
 long clock_getres_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
 {
-	long ret;
-
-	asm ("syscall" : "=a" (ret), "=m" (*_ts) :
-	     "0" (__NR_clock_getres), "D" (_clkid), "S" (_ts) :
-	     "rcx", "r11");
-
-	return ret;
+	return VDSO_SYSCALL2(clock_getres,_time64,_clkid,_ts);
 }
 
-#else
-
-static __always_inline
-long clock_gettime_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
-{
-	long ret;
-
-	asm (
-		"mov %%ebx, %%edx \n"
-		"mov %[clock], %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret), "=m" (*_ts)
-		: "0" (__NR_clock_gettime64), [clock] "g" (_clkid), "c" (_ts)
-		: "edx");
-
-	return ret;
-}
+#ifndef CONFIG_X86_64
 
 static __always_inline
 long clock_gettime32_fallback(clockid_t _clkid, struct old_timespec32 *_ts)
 {
-	long ret;
-
-	asm (
-		"mov %%ebx, %%edx \n"
-		"mov %[clock], %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret), "=m" (*_ts)
-		: "0" (__NR_clock_gettime), [clock] "g" (_clkid), "c" (_ts)
-		: "edx");
-
-	return ret;
-}
-
-static __always_inline
-long gettimeofday_fallback(struct __kernel_old_timeval *_tv,
-			   struct timezone *_tz)
-{
-	long ret;
-
-	asm(
-		"mov %%ebx, %%edx \n"
-		"mov %2, %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret)
-		: "0" (__NR_gettimeofday), "g" (_tv), "c" (_tz)
-		: "memory", "edx");
-
-	return ret;
+	return VDSO_SYSCALL2(clock_gettime,,_clkid,_ts);
 }
 
 static __always_inline long
-clock_getres_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
-{
-	long ret;
-
-	asm (
-		"mov %%ebx, %%edx \n"
-		"mov %[clock], %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret), "=m" (*_ts)
-		: "0" (__NR_clock_getres_time64), [clock] "g" (_clkid), "c" (_ts)
-		: "edx");
-
-	return ret;
-}
-
-static __always_inline
-long clock_getres32_fallback(clockid_t _clkid, struct old_timespec32 *_ts)
+clock_getres32_fallback(clockid_t _clkid, struct old_timespec32 *_ts)
 {
-	long ret;
-
-	asm (
-		"mov %%ebx, %%edx \n"
-		"mov %[clock], %%ebx \n"
-		"call __kernel_vsyscall \n"
-		"mov %%edx, %%ebx \n"
-		: "=a" (ret), "=m" (*_ts)
-		: "0" (__NR_clock_getres), [clock] "g" (_clkid), "c" (_ts)
-		: "edx");
-
-	return ret;
+	return VDSO_SYSCALL2(clock_getres,,_clkid,_ts);
 }
 
 #endif
diff --git a/arch/x86/include/asm/vdso/sys_call.h b/arch/x86/include/asm/vdso/sys_call.h
new file mode 100644
index 000000000000..dcfd17c6dd57
--- /dev/null
+++ b/arch/x86/include/asm/vdso/sys_call.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Macros for issuing an inline system call from the vDSO.
+ */
+
+#ifndef X86_ASM_VDSO_SYS_CALL_H
+#define X86_ASM_VDSO_SYS_CALL_H
+
+#include <linux/compiler.h>
+#include <asm/cpufeatures.h>
+#include <asm/alternative.h>
+
+#ifdef CONFIG_X86_64
+# define __sys_instr	"syscall"
+# define __sys_clobber	"rcx", "r11", "memory"
+# define __sys_nr(x,y)	__NR_ ## x
+# define __sys_reg1	"rdi"
+# define __sys_reg2	"rsi"
+# define __sys_reg3	"rdx"
+# define __sys_reg4	"r10"
+# define __sys_reg5	"r8"
+#else
+# define __sys_instr	"call __kernel_vsyscall"
+# define __sys_clobber	"memory"
+# define __sys_nr(x,y)	__NR_ ## x ## y
+# define __sys_reg1	"ebx"
+# define __sys_reg2	"ecx"
+# define __sys_reg3	"edx"
+# define __sys_reg4	"esi"
+# define __sys_reg5	"edi"
+#endif
+
+/*
+ * Example usage:
+ *
+ * result = VDSO_SYSCALL3(foo,64,x,y,z);
+ *
+ * ... calls foo(x,y,z) on 64 bits, and foo64(x,y,z) on 32 bits.
+ *
+ * VDSO_SYSCALL6() is currently missing, because it would require
+ * special handling for %ebp on 32 bits when the vdso is compiled with
+ * frame pointers enabled (the default on 32 bits.) Add it as a special
+ * case when and if it becomes necessary.
+ */
+#define _VDSO_SYSCALL(name,suf32,...)					\
+	({								\
+		long _sys_num_ret = __sys_nr(name,suf32);		\
+		asm_inline volatile(					\
+			__sys_instr					\
+			: "+a" (_sys_num_ret)				\
+			: __VA_ARGS__					\
+			: __sys_clobber);				\
+		_sys_num_ret;						\
+	})
+
+#define VDSO_SYSCALL0(name,suf32)					\
+	_VDSO_SYSCALL(name,suf32)
+#define VDSO_SYSCALL1(name,suf32,a1)					\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1));				\
+	})
+#define VDSO_SYSCALL2(name,suf32,a1,a2)				\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2));	\
+	})
+#define VDSO_SYSCALL3(name,suf32,a1,a2,a3)				\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		register long _sys_arg3 asm(__sys_reg3) = (long)(a3);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2),		\
+			      "r" (_sys_arg3));				\
+	})
+#define VDSO_SYSCALL4(name,suf32,a1,a2,a3,a4)				\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		register long _sys_arg3 asm(__sys_reg3) = (long)(a3);	\
+		register long _sys_arg4 asm(__sys_reg4) = (long)(a4);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2),		\
+			      "r" (_sys_arg3), "r" (_sys_arg4));	\
+	})
+#define VDSO_SYSCALL5(name,suf32,a1,a2,a3,a4,a5)			\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		register long _sys_arg3 asm(__sys_reg3) = (long)(a3);	\
+		register long _sys_arg4 asm(__sys_reg4) = (long)(a4);	\
+		register long _sys_arg5 asm(__sys_reg5) = (long)(a5);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2),		\
+			      "r" (_sys_arg3), "r" (_sys_arg4),		\
+			      "r" (_sys_arg5));				\
+	})
+
+#endif /* X86_VDSO_SYS_CALL_H */
-- 
2.51.1


