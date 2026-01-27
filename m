Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF134D2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 20:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDAF16B0005; Tue, 27 Jan 2026 15:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88956B0089; Tue, 27 Jan 2026 15:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69CE6B008A; Tue, 27 Jan 2026 15:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A64E86B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:46:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C3258B549
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:46:47 +0000 (UTC)
X-FDA: 84378927654.09.1F87692
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id BC2EC120002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 20:46:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PFrp9aEN;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769546805; a=rsa-sha256;
	cv=none;
	b=U/VtpCWyYIZKLjTNVoJZ+z6UkdSQCZ7IgrXeR9OzxXW4/YgSVVphPE/cQTb3YgCSHA6LMJ
	fhvppXM/uUfv3A4KGEpXu9ixctBIvtsiQfserv9uUiMXw55gnWNB3PEz9TB85aDTBvRzwO
	CxrX4na6YZHo5ZrKK02YbumLzqpEjgs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PFrp9aEN;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769546805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNEa4mYWEczHBci/mwpJ7O9nUgvSIDfRjPeADRaPwjc=;
	b=51avaMRZdL9+fNX3GjjQ/UalSim7xZ3uy7+4IfVpsb4A61Rp3oHVqhVYrZYsnJjjyjvU1r
	l8YS/AEDhXuTctnTXQ7f4Nxk21OqMl8ecEEWnQkKbN4m1vLCzq5jP15jydzgpYbZTSOYzr
	VBIxzvuraXy/oK0nblbFEIWA6XuEzGw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B50DE601DE;
	Tue, 27 Jan 2026 20:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA31C116C6;
	Tue, 27 Jan 2026 20:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769546804;
	bh=dPe4WO5V5xGcqbRrtLSrAnb6cZI7NA2TSDIlxEHcMg0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PFrp9aENn8GkO3oMV5uU3fw/sDFm4fOIgmG6lOGNP6rxP54wuO7jQTZJOTnpGqGTk
	 NB3Sv2FHYDDBA3dsblyvixrcw3tZ4kXXeRIcFlqab7TMCcctx5uC+lfxG1L0MdwWzA
	 L7gQdZ4FA8nw9mzJUh2KfWM9LIGY8FgBJ+uk9/GM=
Date: Tue, 27 Jan 2026 12:46:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: david@kernel.org, andreas@gaisler.com, richard.weiyang@gmail.com,
 will@kernel.org, peterz@infradead.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, dev.jain@arm.com, ioworker0@gmail.com,
 linmag7@gmail.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, sparclinux@vger.kernel.org, Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 0/8] enable PT_RECLAIM on more 64-bit architectures
Message-Id: <20260127124642.480123beb01ebb487f986a09@linux-foundation.org>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BC2EC120002
X-Stat-Signature: yne99a6isb4tqi7zmid7nh9npbqw7hfk
X-HE-Tag: 1769546805-126704
X-HE-Meta: U2FsdGVkX18sbh17UyQmqX/gSEIFf4QHzigTEGv/4y/0XvOASlMP3J4PNJPegA0fm/ZqBk9xtgTlDKBbP0GIXfg1knST8XtWueOeoB/sHSRJv+XvcjLFHRq1wPQIu+/pryUxiiVY99A0b0qD6xj+V4UyQNa3V0NtY5YHlusmOARIbXqA9rHnNeBh+lxv9QDHlDxpZ7x06QOo8JPW+0HUjykJtdzKW0FH2lpWwN5ns/lY3nKYpaID6pYyN5qy1TjD6xT8x3Vz7DkZJRwhqyw3b2l8bkFilFNTf4PaCO6DjplFi/OW6q/+JXv2ByPqY3/m65kG+Z0hTzpXOClN2/UFbCuqd5qImbxqETWUVcAmACwY/es66Pi7TIrFWbb5W5668trjq7bA5DX2c6xg5gmiXk8MnJxBQoe4XiiycpN1LMiolLoeEw1jRL5es6k96tQ/S0AJQty3+A6ELFOaZ05DHDpXTakUfr8KunZ+m7T1GjchK3oeMjCd6ZDNRM76HxQ+RKw+DQYEyp3Z32uu56mC4yXklP8rTm1JyyaVoT1WCeq9sDf4IiFIUz188CNF4/pro8FXNGSEZLRtWdp+5W7jy/xs0R8VlRF/GouXEWd/DOs41oSciAurBSWf8tHwGHsKNZXRHItmpLzsOL3GqhNli5W8leVUykyhRj4oleQX8Qgqde6uKIAZiJddm0/LHcQRGUZlQ+4tSkrCioZrZ5GLpGhVZCw8xd2RnugVnbpCxpTpytaD3MA87e6Az/dvSRmr5AJc1mUPSTNzdJrxxGL5OmGuaqTuYAHFeueTtGL7TZAC10MIse4jrZmw7+bs1QqPnj5bFtIt8t+kHjpuBevaxK4xTxA+fTMRoSUeX1wsmeYPQHIVvZcIuwI3kGXxg1MKbCL3/l+RmddEVnuqT7dqH8OhEtXBZKGiBeFjyVR5tOpsbVYsXFnQq01c1FZtIgijWb6idavDIto/Z6cHXQB
 StZRgRbK
 O9cWrBPE0u78y9+7rcc7KHHw3Q1HBJLU/CDVJvxifTcdyKrfD27LYZAkK1iIwo5dxQaOjH/THCHOImiGEcap2qKzSZXDaYmxpcA1bvJlgMYc2qAojUjlAMxiq0CARkwW5NO7SrpYTAK5xgwu4wN3CZgKaTxA/AchEU2/T/xlVPMSUTTnIZLdpdlr1gIkMp6cyoHAOyeHdgPTtWq0WVckFyk39VxE/nsnQSky8OiDhy8sbvOIO3Icbpez5Hn44ooYfqTnsm/xhekffF+tbZhTxI+ESaK4NCbhi66hEUbfouGHkS5QGvUejb4b/kewY/n3efiiXu+u+z4qOsPaARQzvQX4uEVc++eTasgCU4oZoXb+Bl6j4giSxoYF+tQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 27 Jan 2026 20:12:53 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> This series aims to enable PT_RECLAIM on more 64-bit architectures.

Thanks, I updated mm.git's mm-unstable branch to v4.

> Changes in v4:
>  - convert __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
>  - fix a WARN_ON_ONCE() on sparc64 (and on ppc)
>    (reported by Andreas Larsson)
>  - collect Acked-by (Hi David, I've kept your Acked-by, feel free to drop it)
>  - rebase onto the v6.19-rc7
> 

Below is how v4 altered mm.git.

I'm not seeing the WARN_ON_ONCE() fix.  I assume that was due to the
Kconfig alterations?



--- a/arch/powerpc/include/asm/tlb.h~b
+++ a/arch/powerpc/include/asm/tlb.h
@@ -37,7 +37,6 @@ extern void tlb_flush(struct mmu_gather
  */
 #define tlb_needs_table_invalidate()	radix_enabled()
 
-#define __HAVE_ARCH_TLB_REMOVE_TABLE
 /* Get the generic bits... */
 #include <asm-generic/tlb.h>
 
--- a/arch/powerpc/Kconfig~b
+++ a/arch/powerpc/Kconfig
@@ -305,6 +305,7 @@ config PPC
 	select LOCK_MM_AND_FIND_VMA
 	select MMU_GATHER_PAGE_SIZE
 	select MMU_GATHER_RCU_TABLE_FREE
+	select HAVE_ARCH_TLB_REMOVE_TABLE
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_LAZY_TLB_SHOOTDOWN		if PPC_BOOK3S_64
 	select MODULES_USE_ELF_RELA
--- a/arch/sparc/include/asm/tlb_64.h~b
+++ a/arch/sparc/include/asm/tlb_64.h
@@ -33,7 +33,6 @@ void flush_tlb_pending(void);
 #define tlb_needs_table_invalidate()	(false)
 #endif
 
-#define __HAVE_ARCH_TLB_REMOVE_TABLE
 #include <asm-generic/tlb.h>
 
 #endif /* _SPARC64_TLB_H */
--- a/arch/sparc/Kconfig~b
+++ a/arch/sparc/Kconfig
@@ -74,6 +74,7 @@ config SPARC64
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select MMU_GATHER_RCU_TABLE_FREE if SMP
+	select HAVE_ARCH_TLB_REMOVE_TABLE if SMP
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_GATHER_NO_FLUSH_CACHE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
--- a/include/asm-generic/tlb.h~b
+++ a/include/asm-generic/tlb.h
@@ -213,7 +213,7 @@ struct mmu_table_batch {
 #define MAX_TABLE_BATCH		\
 	((PAGE_SIZE - sizeof(struct mmu_table_batch)) / sizeof(void *))
 
-#ifndef __HAVE_ARCH_TLB_REMOVE_TABLE
+#ifndef CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE
 static inline void __tlb_remove_table(void *table)
 {
 	struct ptdesc *ptdesc = (struct ptdesc *)table;
--- a/mm/Kconfig~b
+++ a/mm/Kconfig
@@ -1448,9 +1448,12 @@ config ARCH_HAS_USER_SHADOW_STACK
 	  The architecture has hardware support for userspace shadow call
           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
+config HAVE_ARCH_TLB_REMOVE_TABLE
+	def_bool n
+
 config PT_RECLAIM
 	def_bool y
-	depends on MMU_GATHER_RCU_TABLE_FREE
+	depends on MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE
 	help
 	  Try to reclaim empty user page table pages in paths other than munmap
 	  and exit_mmap path.
_


