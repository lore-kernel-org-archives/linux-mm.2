Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FC0D637B5
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184A26B009D; Tue, 16 Dec 2025 16:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037C76B0098; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07586B0099; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCCA26B0098
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88C331A07AF
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:58 +0000 (UTC)
X-FDA: 84226619316.12.082BB38
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id D11CB1C0002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=m6jZ4on9;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920417; a=rsa-sha256;
	cv=none;
	b=NerbQB5qAbls1J7I6WX7+c6D7zqnT6mSggQipfUnJjk/bgvHvsPmk+T8DvTniW/GIbpctM
	1w1ccbrZZOqGz6OEQqmsLRFgi3UJTN4D7TlOID+3VFo8TunHZmveFtbR8SXuHMj5AFfX2A
	HufX737bcuj9a/KLZax2dNFCURV6Q0o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=m6jZ4on9;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78LVi13gVlB9UDQcZ9uC4YepVxV2P7X7WMn5xcDlZ3M=;
	b=u7VU1bLfbUX5cqRVa7u9XUqzfg3nI6ASC2nvGHWd7T+ZnJqYy01wrHZYLBhiOnRIXifBsa
	B6PzoOYL2hUOI0Ev4iSCOUE+UnL1E947faz8mGRVHbgGNqRJQEssev+tE33PBFACQK+iyy
	Q+hj+IpMKWshIL2cuAG9OWN89kQoVpk=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC272563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:28 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC272563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920389;
	bh=78LVi13gVlB9UDQcZ9uC4YepVxV2P7X7WMn5xcDlZ3M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=m6jZ4on9bgCY4hbv+oKFvhkI/cB5MXkvUB/930SdTWnEdvqd3c+6Tgq717pQtL3f8
	 9GGUe2fdEsGmuhy7+ieJsLfHrKGjPvnxTBsooU6FTl93As2qAoKzvbuvLfCfxE3Qdj
	 Xx8ES7sYLmiiWjsHtf/VtxHSNauKX/L8/tbDBDY1L39d05X8YUugdgFi1IfaOivE5S
	 HCH4BZKlQMiagUCGC6dZWLN1X2KOqq8vqurySJUxfdTTCvTw3AWozHStE43pYpfAO4
	 EyzJt+9H0QKi6MldJRhDVDQ/mGKzjB7KPd3ZIOA4f47l8rFr52OP739ZNO8jUbRzAA
	 Dpjp6HTaO2XgQ==
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
Subject: [PATCH v4 08/10] x86/vdso: abstract out vdso system call internals
Date: Tue, 16 Dec 2025 13:26:02 -0800
Message-ID: <20251216212606.1325678-9-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: <20251216212606.1325678-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D11CB1C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: 3tmp3ogntpsw5oen5m9rhjq5toy9qeqa
X-Rspam-User: 
X-HE-Tag: 1765920416-487869
X-HE-Meta: U2FsdGVkX18bkAlmxeMrJXVhoXO0diNDDLrI0TnfhbiDwNIdjQIaBHLAyvkyXTdfExfi4sc0NzJ+ZZcLjZqUJ/2PG8KNzf6jAH/SW0EUNlCyNuAcuMZDl0nRI8afFmXWRh9Apd+1Px3QgL3oLt5nV1AepjFA94B0mBcIffp8/LnBxv7LmkEQjrcsCYC8IuAJBevIx8nQIUyE57fDYbXAFd3kMRZUAsshgy+0w+oc0+xDQmfEYiP1JMTc/qxgJ+yseqOrPR6BgAJeRkePBalvOYgd+IIDDPDxcCij3J+yB8rqWXg2Hb9mQVYEQSSSswwaBuWirHQgjANJdmqi8s1LEAydIfhEkAU/m29JQHMZJz2bBieWG813aCSNBfLADxh2ju1sTiacD82n50enlee3otirPON5MP4k++CJXbuzLVfqEHa3CBodEU8goNpW8JJQ7LxbELl/YtjczSMeFw2eILuOkLPpEmdLBUEhEZN28Fw3aymusZurHZNyI2NJevsXeY+KcE0usfCNEzoOCN8KVWfbvjHud148r3Ocs91zx3hmnF9i47MEns6qiQgA16hU0Nk7cSUcCj6BasrEro92hg1m3+8IwrBt/3maoHNgbvtFtBJ649jRGaUT46iISVnz4oWWWtkcC5tvqHYvFij0NB9WOkJ7lQb7yJ9JKeVGk0KYU8mruJpOsqhgyQY8I2HnUdT5aeJ6SSCZ0ZEknBo12HezCQhCLX2KOhKzBsycsiVjkUOZ9RHKXqz26ArA+bPtgBhU7+Enkx6Yq9R7t89lp50+nZ3pWj+G5EHkcDkXjsaKLIrOSz5Y0enHuQpnOJ0HHKebseSMiSEBqD4CKrUJOMdtc3FSXd71IMV1kfZ7OZ3PySMGpB19Kd4oLsK3IfN5OZB8Wopzia8Atri4vKqrdiF4pJ7/FETavAKAYvADEgBRreEM4hOxSPf1lGJJPfZd5IZcWJCHfu5668f8bk5
 IoO4MsYx
 ECIIUJMKLwEcj0izJxI4OWhvjH0UdVRVX00Ii8jd56CBu6qNC7hbVegmZNkolPGxbrylKCkyV+mhEuEjmXwKbkIGYbNTSKnDLWFCdr4vZbHmiF1HLLK2bpT5/FGYZJbBrWTUaF/XVfbDpcTgzY+aDyqJFPXLGt0GhWary1pz0GXik6OpS7GDQHQ8fXTisq+kFpmxNXg5q7TWMrzC96U+xluCYsh7dozkF3Ju6vv+Clj3CFhfn2QCrt6W5JXbGdcSATp/NmBrfpraziAVfj79YwiuXmhIjga0l1dxGTOH6lN+MwfuOGW1i6QVa2TOipWmgmd3fozdHGsZBfk0=
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
2.52.0


