Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0C0CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 10:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7086B008C; Sat, 17 Oct 2026 06:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CDC66B0092; Sat, 17 Oct 2026 06:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BCC56B0095; Sat, 17 Oct 2026 06:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBF46B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 06:05:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E29D14023A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:05:10 +0000 (UTC)
X-FDA: 85331685180.20.AF2E857
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf11.hostedemail.com (Postfix) with ESMTP id B7C5040009
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:05:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=oO56X0+1;
	spf=pass (imf11.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792231508;
	b=mkvZwYCYgI/pwRJEqwT4uXnMTgoNPdlTyW0JBvbKob7KEHnsQOl5vSVWX2u0pJTD+y4Dkd
	+NtVIJHnz7q8PbCAWQG33RkI35taE+7Ir9lo0U044XxL7hBcwtw2ojF4ktJGkaDfLJwnN6
	eKPgf6v2ZCPsvsCL7GHA5hZ7nSE/EVY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=oO56X0+1;
	spf=pass (imf11.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792231508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijHdyvgjkTozfCUmxF87O//t2rILUVcJInxAFYQhzOg=;
	b=vblKRKeOTFvz0B720KHD/T74yeW3c9T5U64wo/ABlgo2BuNLn+q8JVxJo7wllnrIwPzUxP
	pTTvToj8koRtGmn1Jcob2eW3IeCv+nbp4zQyHowtpBciBmPT16dh2Gmsr0LsDpY59VJyA3
	Moe1uUVY3/FWOt+SyvSEOw8g4CZjoZg=
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792231506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ijHdyvgjkTozfCUmxF87O//t2rILUVcJInxAFYQhzOg=;
	b=oO56X0+1KSBelw+ynjRvG7iw1Gd6NSuf0/MAz50TKvcchGq8u0b2+xeWZY1ktqFCTkQEZ/
	lMo2P4Ja3hUatKjN+fg3KvhnY+oLWkhMSEy3qv0dgem5YjVVYUZX4iXjihcwB8t40ea7LZ
	ABWdCwtJObooesEEeXOHmEfnUmiLFgw=
To: Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>,
	Michel Lespinasse <michel@lespinasse.org>,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>
Subject: [PATCH 2/2] sparc64: Randomize the load address of PIE executables
Date: Sat, 17 Oct 2026 12:04:51 +0200
Message-ID: <20261017100451.2266781-3-stian@itx.no>
In-Reply-To: <20261017100451.2266781-1-stian@itx.no>
References: <20261017100451.2266781-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B7C5040009
X-Stat-Signature: ccrhzgk88ccdh4cpbba9bkaepj1ytsi9
X-Rspam-User: 
X-HE-Tag: 1792231508-740756
X-HE-Meta: U2FsdGVkX1/AfZcu8NLXSXKIgc7GBvGu+fIqrCj3MRkYkRQGqXR97c8C+j5WHIuIskL3A8MZqSGuVRBqrG/i9KP36gfKizvmHpkltbWjvhnBTcrmvkLFXnji9yEBGd/TeJ6YCpDQI5AfEXoA6vvn9uBI9fhV0VcDuXm/hGzVK3n0FtE32H2loIL77vkrTePecpByoeP9Qy3x8NptDO00pDabl5/fko0gpb/eM+65758y3sxkhtuuaaps6RWEyD6KgADuvo+zTZKHaxoMbnxaVopn3zgIBPcxpYGXtJJmKwQwEhU8ELq8DW1GhIAdhd2JsKsKth8bADuLE5/7ILGsuPL7kyQlfk2NBRVwG5k/53RnrgWIYA3hsz1IDzLoDlH4POb2+P+M3J7ff9ocOARezcvrjwakulEts3qIBpd/fo0eEVcqPb9Ik7nl2qrQ1JynAusJrQif7mos6xPFjbP/UJbcHuN/j43iJMQL374mPeJIQu4ugEbOQQhkZNarLajHtG5utomXC2bnRFFUmgQLBqSnkdTfnPACP0i2NwUul7GlHHe2jLMfM7YDNKTpawS65l4XUlLZ2dmJBqLpctzSrMJCOx8+uDxOS+yj3tNIxtH8RuJhxBxj8XdEDRvU+ldFUZ4pvwwjzh0XFvZj4IFdt2CskQdT6B/8cxr8xB1+sUqLFmD+elzUEhJodHQFVAVceMA9J2i/2kJwY5EGs3GvGqaeofpFpyhsEElQTB8gF0tt7R1/f3AJHAoPn7LFwYj8FX/wPeL054L+rPvpfBG7CrYk338m5oQCqhlsSuS9QBL36XdtkcV0g5uU3ClHZdLZviLuREetJpi64aK03Mb47Ig+tvbQ6AkD4s3uKp0bmgwOuTCzVwVpjX+6Fz3CG6LMJmLyCnHJWz+JearsszIag7kNXnOgoYc/9PhMwi39YifyNCc2ko+q4F77VG//qxXVIjRkYJqUutBpcs+KdQa
 wlLNVu6P
 AeB6B+7bQLq5aFkghUzPwH9vKfyAee3ffASnSAr1lX5ZHWvQX+QHGZD9IVdH1uLv3YpAGaMSJYB+FKQIztH2doN9uSaD/cJMXLSur0oU5kUhh7zm6mp2LIgWUoIK9Ub2cdjFGqYwzHYR0rNSflP/sZn+JHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On sparc64 every PIE executable (ET_DYN with PT_INTERP) is loaded at
exactly ELF_ET_DYN_BASE, with its brk heap at a fixed offset after it.
The stack and the mmap base are randomized; the program image and brk
are not.

load_elf_binary() adds arch_mmap_rnd() to the load bias and calls
arch_randomize_brk(), but without ARCH_HAS_ELF_RANDOMIZE both are
no-ops. sparc64 already has a suitable mmap_rnd() for the mmap base.
Rename it to arch_mmap_rnd(), add arch_randomize_brk() with the ranges
x86 and the generic version use, and select ARCH_HAS_ELF_RANDOMIZE.

Closes: https://github.com/sparclinux/issues/issues/119
Signed-off-by: Stian Halseth <stian@itx.no>
---
 .../features/vm/ELF-ASLR/arch-support.txt          |  2 +-
 arch/sparc/Kconfig                                 |  1 +
 arch/sparc/kernel/sys_sparc_64.c                   | 14 ++++++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/features/vm/ELF-ASLR/arch-support.txt b/Documentation/features/vm/ELF-ASLR/arch-support.txt
index 57406c0d53531..d4a34c9fbae86 100644
--- a/Documentation/features/vm/ELF-ASLR/arch-support.txt
+++ b/Documentation/features/vm/ELF-ASLR/arch-support.txt
@@ -24,7 +24,7 @@
     |       riscv: |  ok  |
     |        s390: |  ok  |
     |          sh: | TODO |
-    |       sparc: | TODO |
+    |       sparc: |  ok  |
     |          um: | TODO |
     |         x86: |  ok  |
     |      xtensa: | TODO |
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index ab77d3f2536e1..82c989b9e7831 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -71,6 +71,7 @@ config SPARC64
 	def_bool 64BIT
 	select ALTERNATE_USER_ADDRESS_SPACE
 	select ARCH_HAS_DELAY_TIMER
+	select ARCH_HAS_ELF_RANDOMIZE
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KRETPROBES
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 087595fa43081..2948d5769e768 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -26,6 +26,8 @@
 #include <linux/ipc.h>
 #include <linux/personality.h>
 #include <linux/random.h>
+#include <linux/elf-randomize.h>
+#include <linux/sizes.h>
 #include <linux/export.h>
 #include <linux/context_tracking.h>
 #include <linux/timex.h>
@@ -280,7 +282,7 @@ unsigned long get_fb_unmapped_area(struct file *filp, unsigned long orig_addr, u
 EXPORT_SYMBOL(get_fb_unmapped_area);
 
 /* Essentially the same as PowerPC.  */
-static unsigned long mmap_rnd(void)
+unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd = 0UL;
 
@@ -294,9 +296,17 @@ static unsigned long mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	if (test_thread_flag(TIF_32BIT))
+		return randomize_page(mm->brk, SZ_32M);
+
+	return randomize_page(mm->brk, SZ_1G);
+}
+
 void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack)
 {
-	unsigned long random_factor = mmap_rnd();
+	unsigned long random_factor = arch_mmap_rnd();
 	unsigned long gap;
 
 	/*
-- 
2.43.0


