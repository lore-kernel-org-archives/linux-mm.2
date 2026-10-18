Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08201CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 12:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0F846B0093; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0056B0098; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35246B0095; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0246B0093
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 290821404D1
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:27:48 +0000 (UTC)
X-FDA: 85335673416.21.553308C
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9596AA0007
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:27:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=CXbp6ygD;
	spf=pass (imf15.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792326466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Txe+udQ287O1wqGtPm5D/O405MfUgofaZ8ktocn6Qo=;
	b=gmkQUuyPdQ3gZzJy9DoSjC+GxZ8YXRd99hNdWBbWHQaS5RMgi0xIn/ECEpPIG+Il5asE/U
	JEfthFjJl1qbp7zuQqmTJs+DTNt4z1tgvgPRUp0EHbO/iIEcoOEvMDaFYDHeE75u8dDMbU
	bhb2eN/4YblNB4I/dW1AnkcfY37DaeA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792326466;
	b=rfRkyxmG6Jp8w7XiEHgTj8Z9RqOaM0AD1zju4hlmT/CcuTujHsxNp8ZBTf88ExVIDl1sit
	m3v8Eq6E8iEgtcO9sqK98w4WCXa5Wj8YKfjcjLY4pw3QAIQqIweRg5eldukkSj8hbcMOri
	MykzXPelaXjykDW5LyzdkdHUTHHhR6c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=CXbp6ygD;
	spf=pass (imf15.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792326465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Txe+udQ287O1wqGtPm5D/O405MfUgofaZ8ktocn6Qo=;
	b=CXbp6ygDR4mch8ZkAo7K+mbmv97iMMp3lHwhKEoUyzdAxA2hvatFtwtwnCkU3hIejNan9s
	q6IiEUMiFdFoTMBFJZn5G7YyQP3B8IAsq7RaSC+gkSF5b3KI3RPrQkeXpLSoJBsqNxwweb
	oEOdRRjjlrdWiKjMGdW1otfjsW7iPvo=
To: Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>,
	Michel Lespinasse <michel@lespinasse.org>,
	Jan Engelhardt <jengelh@inai.de>,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>
Subject: [PATCH v2 3/3] sparc64: Randomize the load address of PIE executables
Date: Sun, 18 Oct 2026 14:27:34 +0200
Message-ID: <20261018122734.2594904-4-stian@itx.no>
In-Reply-To: <20261018122734.2594904-1-stian@itx.no>
References: <20261018122734.2594904-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9596AA0007
X-Rspamd-Server: rspam08
X-Stat-Signature: sjgbp6tc9gizeq86tnzaimw4syhe7rxp
X-HE-Tag: 1792326466-250415
X-HE-Meta: U2FsdGVkX18EOLkAC1q514XoMWlAqoJ0pb9TfNiVV5S26gyzqDnX5y1cYVsVZCh9zxZdK4zDCGXb1H7nlCBIbXwFLVfolHebWQ8z+dI68oH1aprNmjIexqsBFQ6xiAPyRYVS0fZQvWPkQjDPpz2RAh0eg7fh4PQR+He1C5ogtIZXcXOoWQCIZUYXcfXN5zXU9TcIalhvzIt3vziS8l2zRw8PiweDEJtSFq5dKCBfnO53xEFGkKVsWdyLkuN6CgOCRS/vhREa+iLAeWf+SGyHUYPhBfEUKzWt5lK+vqXeAa9AYwRfKxB21SqmICLAiUc/2lCMcGzyKxKeOilRbXK6/gkLtirZhqTqG2gkAIEN/sHjaFkOTz36JYA8V/q/pwbiNB+8A7rcQjK2JK2aAR0NuG/R8yeKKGqdjMGa0+xel9GzkUOOeJD4WlighEMzU4ECaLMN+rYGBPmK6iwGtvGY792Jebnxb+gSAs400LCt5zWfdeyr/DKssOLusUDosBAJC1SDrQSJbETaWQHbre5Ib870OSQ44mX8aAYceLIAcU0DaZyqTkdpbczFW790wlUBf4Q+iEUojyLuPQ0l1gaVLVuYjk78lsjuoiggxBIoqkojhUtX0GJaL9EQAUjTv6GylyyoEQBr22N1v7zQdE3xti4VQqm6zEGnwKLGFaee06TXMQxftXaE32VA7vVu/HCyAuOvvSo+dZ/aKw+4Qb+vA6V2k4QXU/9CNelPfuV5JW/THHZFtZv751AVKLawG0IYhPkq0bymklJqSEBXdx6Ow2MPrI2U4Cw67w60jUhOQCWt9QwFnZxLxeliZ06ghY7qPwvHwXawvMs5SHC/OsW3k9eRcikHG79sX/b55hdScCYf2WCFR1Fezdj3B+bT4UW4hMxaIvg9WebKQBCNWsYmYPSV3o6d909GHRS0peOfQzXl0adJDTLncDr6XJGHnReb4yqoF4MzeZuKUDV+8S9
 hUEm9gcc
 XRjTpEa07uDh0kOB3P7t+w9RyirGUDQTzsISEpwzuLImO4kmxgVdiUEMFq0b0uQPw10wTvooalPx9kJL4tyyg30jqOn0thA/mFVAONk2HCvqRLrWwWzIgLkJNOBuu6SfunMTvZICdJ2kbpnqrxZzV95Krkw==
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
Tested-by: Jan Engelhardt <jengelh@inai.de>
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


