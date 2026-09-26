Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 729DAC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC33B6B009F; Sat, 26 Sep 2026 05:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97E46B00A0; Sat, 26 Sep 2026 05:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BFB6B00A1; Sat, 26 Sep 2026 05:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 817D76B009F
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:27:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C7B5A088D
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:27:11 +0000 (UTC)
X-FDA: 85255384662.09.F167148
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64B81A0009
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:27:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLWp7dPv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790414829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2IB/emxkyHo2HX8WhbXxbTX5kHFJvnRUt1R1zJ5EJrY=;
	b=pyVCIf1D2ShgSblan4Zeg/h2VP7GhXzBDNkiiMN6dhwcciAX6ku3K4cLfsd1jeIcuawy22
	Ad+dbzvwJb/o+CWQhk6l7YuJ6dyrw1k5Wm6SXriN+XqyIqxE16iBvcUIC+gVIOYZWzTdKF
	DLUo5Ruf2FRP+zJaJ68i4ky/KjXQRKM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLWp7dPv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790414829;
	b=CfwGXYgWm1Q06Vq8XM93Pg+hb6Gw4eUEMbkaeYYNa+gYPmTxt3SCcpepOkfOlrfZuY89Bo
	B1+gCfl1DEgW9Zy19izEXCZHlFYVK7/mQEIlUmpq5BCTYwIt8u7WU3aHlumd9xwF7+ns49
	z6vLNweAbvM2+T+WbukRNLHvfcaCc4Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB72742BA4;
	Sat, 26 Sep 2026 09:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4E41F00893;
	Sat, 26 Sep 2026 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790414828;
	bh=2IB/emxkyHo2HX8WhbXxbTX5kHFJvnRUt1R1zJ5EJrY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bLWp7dPvvkC5iYRn7QCrP+n9zSTEV8wSmdq5FLV+7rYRGdMhh+tpPjxpnq+4hKK+J
	 8BKlAXrHl9Cp9xDuPkaBrwHNg/in02IrPjosuTDhMQczYv27FfMLn8pJlJho48qLT6
	 Z3IIFsrvAPo6O4v6WpPzfb4JBsmop7Jxbs44KA+6ugbrbZeEDkQHbs/bwwRe8TiGiZ
	 nM20PIm1RDsbFfAV5pfG/hgppsIWZE13Hhthp4QxT9HNKxPadW2zjX5/pY/kFPJkxw
	 hbWNIET7AKzXxDO8ucZep/LqAibyByxWc17RpEqLwaAQ6jgvO/L5N6tF6wNH9kSk12
	 iHr1cJxNWeKzw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 26 Sep 2026 12:26:34 +0300
Subject: [PATCH v2 5/5] hibernation: make hibernation unavailable when
 debug_pagealloc is on
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-hibernation-v2-5-235f69f3ab2a@kernel.org>
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
In-Reply-To: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 5698kt4rm8np3ta3oq3sphqa8bpc74ci
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64B81A0009
X-HE-Tag: 1790414829-143863
X-HE-Meta: U2FsdGVkX1+y8jjjHpiRYO2R1zrFLszC8GQ2YMreKRqsOLV7ITAtwI+TdyoTUctuFanZbP1JQz44ieRcdyL31H2fNSmaOT0srUW4DdnGmTP+vPPQ7CXw6ZsILqhzBH+MOG675+qQd6W1lgYDI0RVDGfwHQgg6HnX9pH47AZWJzr0Czf6MSWZAdyaGY3HwdejRYHEkxU+8mpBwAQW0MV2BdZ0zBVa8S1Zoq9F6dVbUc6BJ0oHeae506lfZbIqYfVJLBikW3VFcJ9jcxneUT3Ocm3tyACtDkL3PhrDtqTfCggZXLqjp0yd0GYVJ/XpEZ3a7dghU7kKAmFmdGbnjyPxMoCOhi2HMI+522z1XM1j1bcIAcBrZCZbVZ28b3eQpy+bm3fElwrRWrdm5S0H3ZrnMifS3Ar/lO1qxuD5n4lJOk6rWyo5Z5VE4UoQzOfszVcatXrhqpkD6thRkrMRW17MgWT9/mPjgTAg227/WS9F2KmlZPgvqWlFEP+CwHR3n3bFOomO+WwyHEd/IOlIJR/iaHMyvoYcHqFriiNrEjPrp2tNNtoT3c9TDcyDoKpSTAuxWB3jDoeitV2YhQZ+zKtkPsy6IfnjF4m+/22AZGqWkdpetocppsfLNacnFudqzRn0pWu1qO1d0ga8tRqjx28qwDVoL8Z5nOWpDcrJyp9ymnJyGI++X7e/2vG+Utp25KC1BHmWhz3BbfbEqTIjwgOE20iP3Q5+25PS3MSJnGcjvQQROtuhSwJp7Z0sX2/rSr1DLnkhTdppmNC88XwIY84z7Uw9OfOYVJjVRUfgcGZ8T42BcabdJV2otl5fuva2cO4yEkydnDdKkYn2RXym0XHFGtcLOk5dsKJvgF6CMpscGvixdmduakK1p6bjFCnBQmRqzsiM+zeBOuHz/1QPEtNoXA2SIuswBOydsc0SjUOqdouyEzzYxg3qUz1emgl3NsCobTohFHMvnl0aJZTeadN
 TiSAiOGK
 lGnEe79HjtEG1naxGQcAhUSFpiBzBPF3RPa94z61MKrLfhbIi+i4+jlntOplHFQoAbG6SSpe1WM7DbEdAKcM7qvEHwOKonowvXOTTCLSDpYsJcHkEncRP0Mw8fSsmFPbv0e7efQrfqNGz8MC2JVkfJgFGFf3HNIUAm8Yo5ft+6bwjSq8xFmc1Dkandlt4NIF8DuIXRPGcNnPt2ty90M/NToJ8WWdHtMSA93kiYORiavnoDGwGZUGPC4CihbTmM3RU1YamYiCx+SoWtn+0Vw01XY4kGQbmoh1jXhA8nhfi26KqJhw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Back in 2008 when commit 8a235efad548a ("Hibernation: Handle
DEBUG_PAGEALLOC on x86") enabled coexistence of hibernation and
DEBUG_PAGEALLOC, the world was simpler, the combination was only supported
on x86 and a non-present page in the direct map meant that the page was
free and debug_pagealloc removed its mapping.

Nowadays there are more architectures with inconsistent views of how the
direct map should be managed, there are more debug mechanisms in MM that
can either drop a page from the direct map (e.g. KFENCE) or require that a
page must be mapped immediately after resume (e.g. init_on_free).

The latter constraint is particularly nasty, because enabling
debug_pagealloc and PAGE_POISON at the same time simply breaks resume:

  BUG: unable to handle page fault for address: ffff888000100000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 4f0c067 P4D 4f0c067 PUD 4f0d067 PMD 4f0e067 PTE 800fffffffeff020
  Oops: Oops: 0002 [#1] SMP DEBUG_PAGEALLOC NOPTI
  CPU: 0 UID: 0 PID: 477 Comm: bash Not tainted 7.3.0-rc3-00090-g4a613f1d9124 #1 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
  RIP: 0010:__kernel_poison_pages+0x45/0x70
  Code: 89 fa 48 c1 e6 06 48 01 fe 48 89 d1 48 2b 0d 9a ed 87 01 48 83 c2 40 48 c1 f9 06 48 c1 e1 0c 48 03 0d 97 ed 87 01 48 8d 79 08 <48> 89 01 48 83 e7 f8 48 89 81 f8 0f 00 00 48 29 f9 81 c1 00 10 00
  RSP: 0018:ffffc900017dfd78 EFLAGS: 00010086
  RAX: aaaaaaaaaaaaaaaa RBX: 0000000000000000 RCX: ffff888000100000
  RDX: ffffea0000004040 RSI: ffffea0000004040 RDI: ffff888000100008
  RBP: 0000000000000000 R08: ffff888130fcada0 R09: 00000000723e0de4
  R10: 0000000096ad9215 R11: 00000000db907bcf R12: 0000000000000005
  R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
  FS:  00007f8f2243e780(0000) GS:ffff8882e8e13000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff888000100000 CR3: 0000000140679000 CR4: 0000000000750ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   clear_or_poison_free_pages+0xd1/0xe0
   hibernation_snapshot+0x548/0x5a0
   hibernate.cold+0xcb/0x321
   state_store+0xc3/0xd0
   kernfs_fop_write_iter+0x163/0x240
   vfs_write+0x21f/0x550
   ksys_write+0x70/0xf0
   do_syscall_64+0xb1/0x590
   ? __irq_exit_rcu+0x40/0x110
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f8f224d0687
  Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
  RSP: 002b:00007ffe7bbe0910 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 00007f8f2243e780 RCX: 00007f8f224d0687
  RDX: 0000000000000005 RSI: 000055e3e53135d0 RDI: 0000000000000001
  RBP: 000055e3e53135d0 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000005
  R13: 00007f8f226295c0 R14: 00007f8f22626e80 R15: 0000000000000000
   </TASK>
  Modules linked in:
  CR2: ffff888000100000

It's possible to build a complex infrastructure involving a new page flag
and/or page_type to allow robust hibernation and restore with
debug_pagealloc enabled.

This infrastructure requires a proper detection whether it is safe to
temporarily remap a page to include it in the hibernation snapshot because
relying on kernel_page_present() is too permissive and may include pages
that were deliberately removed from the direct map for security reasons.

This complexity does not seem justified to deal with an esoteric use case
of hibernating a system that runs with debug_pagealloc enabled.

Make hibernation unavailable when debug_pagealloc is enabled and simplify
hibernate_{map,unmap}_page() that don't need to deal with debug_pagealloc
anymore.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/power/hibernate.c |  1 +
 kernel/power/snapshot.c  | 31 +++++--------------------------
 2 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 97de677e360f..187ec6e87345 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -110,6 +110,7 @@ bool hibernation_available(void)
 {
 	return nohibernate == 0 &&
 		!security_locked_down(LOCKDOWN_HIBERNATION) &&
+		!debug_pagealloc_enabled() &&
 		!secretmem_active() && !cxl_mem_active();
 }
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 6868d6155daa..17b7cbbfc441 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -85,12 +85,7 @@ static inline int hibernate_map_page(struct page *page)
 	if (is_kfence_address(page_address(page)))
 		return kfence_force_mapping(page) ? 0 : -EFAULT;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		return set_direct_map_default_noflush(page, 1);
-	} else {
-		debug_pagealloc_map_pages(page, 1);
-		return 0;
-	}
+	return 0;
 }
 
 static inline int hibernate_unmap_page(struct page *page)
@@ -98,17 +93,6 @@ static inline int hibernate_unmap_page(struct page *page)
 	if (is_kfence_address(page_address(page)))
 		return kfence_reset_mapping(page) ? 0 : -EFAULT;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		unsigned long addr = (unsigned long)page_address(page);
-		int ret  = set_direct_map_invalid_noflush(page, 1);
-
-		if (ret)
-			return ret;
-
-		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-	} else {
-		debug_pagealloc_unmap_pages(page, 1);
-	}
 	return 0;
 }
 
@@ -1446,10 +1430,10 @@ static inline bool do_copy_page(long *dst, long *src)
 /*
  * safe_copy_page - Copy a page in a safe way.
  *
- * Check if the page we are going to copy is marked as present in the kernel
- * page tables. This always is the case if CONFIG_DEBUG_PAGEALLOC or
- * CONFIG_ARCH_HAS_SET_DIRECT_MAP is not set. In that case kernel_page_present()
- * always returns 'true'.
+ * Page could be not present in the kernel page tables. Try to map it before
+ * copiyng and unmap back as needed.
+ * If the kernel page table update fails, bail out with an error.
+ *
  * Sets @zeros_only to true if the page was entirely composed of zeros.
  *
  * Returns 0 on success, a negative error code on failure.
@@ -1458,11 +1442,6 @@ static int safe_copy_page(void *dst, struct page *s_page, bool *zeros_only)
 {
 	int err;
 
-	if (kernel_page_present(s_page)) {
-		*zeros_only = do_copy_page(dst, page_address(s_page));
-		return 0;
-	}
-
 	err = hibernate_map_page(s_page);
 	if (err)
 		return err;

-- 
2.53.0


