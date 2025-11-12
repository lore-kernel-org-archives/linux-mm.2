Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E729ACCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370098E000F; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EBE8E000C; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA498E000C; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C48748E0010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:38:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8733013A84C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:27 +0000 (UTC)
X-FDA: 84100698654.24.601F875
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf18.hostedemail.com (Postfix) with ESMTP id C85F51C0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b="i/IQlisW";
	spf=pass (imf18.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMqdBX9HO8+AZngQ2hCIyYV6RLWAiIgEKxARiQLqOYw=;
	b=hEOD85dNi8Xp+x/Ga3zpcRFix6uquw5+r7mulAeKYppX75CnMvXs7zj8CGVMabntvivR9c
	9/6UPm57P92bQU/kLdwQs9eV6HHoEoCei3klC3QFaT9Ia6MAkNT/VIvkuX+73Rcil6TigG
	e5290/7bWGHCrRl6LFgiZiWEZGF6Raw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b="i/IQlisW";
	spf=pass (imf18.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762922306; a=rsa-sha256;
	cv=none;
	b=HFM58qOH25L/vOWbdy6OgDldpSf/mu9izSs0xydA/KwlApNMfjZhvpT/GGtGi9XWNqlIiO
	y7LOlTXfF01sRnBhWWefURfwNnQkUz6KWMofhbOmgneZ46uWhUXQRDgN0O99/hoX2k1Vyr
	xIxmMOzxhN/Gg9De+SOUy9no1A2XGy8=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDT542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:47 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDT542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922269;
	bh=DMqdBX9HO8+AZngQ2hCIyYV6RLWAiIgEKxARiQLqOYw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i/IQlisWVBkqsZ6VqZoTW83K3NVYrvQYBx0Y3VkaFX9h4lgeU4fUuaWq30rZcuIfu
	 XxS/8UghVlWbL0SCp+tLs8Fk2bfBUHUipw/HU6f/H/nc0F2JzQYokibRdQER9Ie4hj
	 c0RHigxm1QzqyUHYFgj3dOqwCl1+cnp4EXzXWDWsjiujzBy+V55yG8akBI7m236YLU
	 fMMeyjFmYgfkdjPkTZMozP2KakLOnmUdmszea/IKCcggFtzUEQHAt0JRRp1xPis5og
	 fFV3A9zysNWH0QZLfWebtuLgf82jFhrCqMVCOJX0gl+5XFk/9aL7qrfrGqvQQ201hn
	 p7Q6pDw2hu7Sg==
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
Subject: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
Date: Tue, 11 Nov 2025 20:37:25 -0800
Message-ID: <20251112043730.992152-8-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112043730.992152-1-hpa@zytor.com>
References: <20251112043730.992152-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C85F51C0002
X-Stat-Signature: tg8hg1o3xs3uenzyeafe5yq674ne5y7p
X-Rspam-User: 
X-HE-Tag: 1762922305-609432
X-HE-Meta: U2FsdGVkX18gtxcvnS4YvDREpZdoUWsZ4SUYpIYQcEOO6ckmLmOjkFWsJ7oN6a3EZr98rvNQAqbpUYmxeFmBe5eTMjJNeRKFHafFh6yZDFybniEPoM9iaXpVNTa6CkvTkvM7dz6pWI/VSVSF5M+UgI6fhpIxKdQ+FjtozYivGrJEXyt9daORcNaFQY8196TO21qDZnrNzfKsads3EtpUGG0kc73nxYyyJhpuzdRPWds6ZTat9aPAnJgOYdU66vd7RB5Ln+mv+Xi2etG1CCaiq/k/Kdf+/MziTtpPV+JITlmmF8+x5gErOTzGlpPBuPk3kTmsrk10BnB2C6EFHZki2esr38bZ5SlBHCTnZsHRzh4rH0byhR3qC1DZntUKzwf+WxK7kHYoYDlmEAaLlbH3oL1vU6UFcoF0MCiX2gIUW9+uV4di/PUp8aEIpFLkNUFBZiF0fJtztADhnCfRrHIGVufbLj0L/fEQo3WqACDPQ/fxmsWPZ9pljAEJbx//ouj3AwfQ7GxTfADzRRRa3a1hNEuE8lRUZdjHQD/iNCYvJjZtybYK4TcO/kQR5pIkb3nUIpA6AOiG0/P9RuemT3ZkbjrHcyby/2rmjL4RlEXP24ADRk9wswbxj8r0jwdm+Cgo0e7lPm6b7iMxzTVDYmb4Aeon9/Dz5/Zb3356GfzODCwID7kbVDBi+SlXFrkMCT0Y8KPNN7es9z6dDzwFM+Tcgd860BN6cuWf+X69IW7zGi+tlclFJ8wyvMUu7d5duMfU4d3K72auAH6408M/iebOCl98B0n3P9BwQWUv7rp31WEb/1uWwHx1OZqX7LrauSet2ugcMwWw3JsVjIz3EHeBqk9MAgRavPJk334LU0QpgD+xeUG8YDktm+zInBZRtuYERgFv6lgKHsXhv/1YHp43epj1iHeqv5kWBfB2X7AHjNfh1QCpw3xaEL8/upbkHv7ITCEoEoxvmLTsnhcb4Uf
 VGAvkrp1
 60GJkCgynYk8R9Isy0oWxb1ZocrDIs5l+enfLZF2A0l5J8Wu4ahZuNX6XFlm818qhsD5xXpTAUHMVrxZFMFE7rMZoq2mtT1DFKGDUsqoV/0yBWbzqRqBTU5TYqoJH0P26C00DLVmPgCQr2YaZaspIEWbv5vAVITcKMSUrjID2WgCPjFRiGP783DE3QnMYYu5+JnI7o1xIGyRCsUJH2cr8geFoTLT18KaMPDqUWgll1LUrCbEOW64F/w2emk91KG2ztff2zlwO7C0xQ26xLJL0Yi3y1GA4rrecrIZVHcI1BGXJOGtviJGg1HznUlobXCfffsnOYni7STrN5jI=
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

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/include/asm/vdso/gettimeofday.h | 108 ++------------------
 arch/x86/include/asm/vdso/sys_call.h     | 119 +++++++++++++++++++++++
 2 files changed, 127 insertions(+), 100 deletions(-)
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
index 000000000000..6b1fbcdcbd5c
--- /dev/null
+++ b/arch/x86/include/asm/vdso/sys_call.h
@@ -0,0 +1,119 @@
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
+/*
+ * Note: only three arguments are currently supported,
+ * because there are no constraint letters for r10, r8, r9.
+ */
+#ifdef CONFIG_X86_64
+/* Using dummy output registers instead of clobbers avoids messing up
+   user-specified clobbers. */
+#define __sys_instr	"syscall"
+#define __sys_clobber	"rcx", "r11", "memory"
+#define __sys_nr(x,y)	__NR_ ## x
+#define __sys_reg1	"rdi"
+#define __sys_reg2	"rsi"
+#define __sys_reg3	"rdx"
+#define __sys_reg4	"r10"
+#define __sys_reg5	"r8"
+#define __sys_reg6	"r9"
+#else
+#define __sys_instr	"call __kernel_vsyscall"
+#define __sys_clobber	"memory"
+#define __sys_nr(x,y)	__NR_ ## x ## y
+#define __sys_reg1	"ebx"
+#define __sys_reg2	"ecx"
+#define __sys_reg3	"edx"
+#define __sys_reg4	"esi"
+#define __sys_reg5	"edi"
+#define __sys_reg6	"ebp"
+#endif
+
+/*
+ * Example usage:
+ *
+ * result = VDSO_SYSCALL3(foo,64,x,y,z);
+ *
+ * ... calls foo(x,y,z) on 64 bits, and foo64(x,y,z) on 32 bits.
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
+#define VDSO_SYSCALL6(name,suf32,a1,a2,a3,a4,a5,a6)			\
+	({								\
+		register long _sys_arg1 asm(__sys_reg1) = (long)(a1);	\
+		register long _sys_arg2 asm(__sys_reg2) = (long)(a2);	\
+		register long _sys_arg3 asm(__sys_reg3) = (long)(a3);	\
+		register long _sys_arg4 asm(__sys_reg4) = (long)(a4);	\
+		register long _sys_arg5 asm(__sys_reg5) = (long)(a5);	\
+		register long _sys_arg6 asm(__sys_reg6) = (long)(a6);	\
+		_VDSO_SYSCALL(name,suf32,				\
+			      "r" (_sys_arg1), "r" (_sys_arg2),		\
+			      "r" (_sys_arg3), "r" (_sys_arg4),		\
+			      "r" (_sys_arg5), "r" (_sys_arg6));	\
+	})
+
+#endif /* X86_VDSO_SYS_CALL_H */
-- 
2.51.1


